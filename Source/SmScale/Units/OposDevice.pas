unit OposDevice;

interface

uses
  // VCL
  Windows, SysUtils, SyncObjs,
  // Opos
  Opos, Oposhi, OposScal, OposEvents, OposException, OposScalUtils, OposSemaphore,
  // Tnt
  TntSysUtils,
  // Shared
  NotifyThread, LogFile,
  // This
  DriverError, ServiceVersion, SerialPort, QueueThread;

type
  { TOposDevice }

  TOposDevice = class
  private
    FLogger: ILogFile;
    FEvents: TOposEvents;
    FOposEvents: IOposEvents;
    FSemaphore: TOposSemaphore;
    FEventThread: TQueueThread;
    procedure DeliverEvents;
    procedure SetPowerNotify(const Value: Integer);
    function GetDataCount: Integer;
  protected
    FState: Integer;
    FOpened: Boolean;
    FClaimed: Boolean;
    FDeviceName: string;
    FDeviceClass: string;
    FAutoDisable: Boolean;
    FCapCompareFirmwareVersion: Boolean;
    FCapPowerReporting: Integer;
    FCapStatisticsReporting: Boolean;
    FCapUpdateFirmware: Boolean;
    FCapUpdateStatistics: Boolean;
    FCheckHealthText: string;
    FDataEventEnabled: Boolean;
    FDeviceEnabled: Boolean;
    FFreezeEvents: Boolean;
    FOutputID: Integer;
    FPowerNotify: Integer;
    FPowerState: Integer;
    FServiceObjectDescription: string;
    FServiceObjectVersion: Integer;
    FPhysicalDeviceDescription: string;
    FPhysicalDeviceName: string;
    FBinaryConversion: Integer;
    FResultCode: Integer;
    FErrorString: string;
    FResultCodeExtended: Integer;
    FLastErrorCode: Integer;
    FLastErrorText: string;
    FOpenResult: Integer;

    procedure CheckDisabled;
    procedure Initialize; virtual;
    procedure EventProc(Sender: TObject);
    procedure StatusUpdateEvent(Data: Integer);
    procedure SetPowerState(const Value: Integer);
    procedure SetFreezeEvents(const Value: Boolean);
    procedure HandleDriverError(E: EDriverError);
    function IllegalError(const AMessage: string): Integer;
    procedure EnableDevice(const Value: Boolean); virtual;

    property Events: TOposEvents read FEvents;
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    function Open(const ADeviceClass, ADeviceName: string;
      const AOposEvents: IOposEvents): Integer; virtual;
    procedure SetDeviceEnabled(const Value: Boolean);
    function ClaimDevice(Timeout: Integer): Integer; virtual;
    function ClearInput: Integer; virtual;
    function ClearOutput: Integer; virtual;
    function CloseService: Integer; virtual;
    function COFreezeEvents(Freeze: WordBool): Integer; virtual;
    function CompareFirmwareVersion(
      const FirmwareFileName: WideString;
      out pResult: Integer): Integer; virtual;

    function ReleaseDevice: Integer; virtual;
    procedure BeginOutput; virtual;
    procedure EndOutput; virtual;
    procedure CheckOpened; virtual;
    procedure CheckClaimed; virtual;
    procedure CheckEnabled; virtual;
    procedure FireEvent(Event: TOposEvent); virtual;
    function ConvertBinary(const Data: string): string; virtual;
    function ClearResult: Integer; virtual;
    function SetResultCode(Value: Integer; const AErrorString: string): Integer; virtual;
    function HandleException(E: Exception): Integer; virtual;
    function CheckHealth(Level: Integer): Integer; virtual;
    function DirectIO(Command: Integer; var pData: Integer;
      var pString: WideString): Integer; virtual;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; virtual;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; virtual;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; virtual;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; virtual;
    function GetPropertyNumber(PropIndex: Integer): Integer; virtual;
    function GetPropertyString(PropIndex: Integer): WideString; virtual;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); virtual;
    procedure SetPropertyString(PropIndex: Integer; const Text: WideString); virtual;

    property Logger: ILogFile read FLogger;
    property DeviceName: string read FDeviceName;
    property DataCount: Integer read GetDataCount;
    property AutoDisable: Boolean read FAutoDisable;
    property OpenResult: Integer read FOpenResult write FOpenResult;
    property PowerState: Integer read FPowerState write SetPowerState;
    property ServiceObjectVersion: Integer read FServiceObjectVersion;
    property PowerNotify: Integer read FPowerNotify write SetPowerNotify;
    property FreezeEvents: Boolean read FFreezeEvents write SetFreezeEvents;
    property ServiceObjectDescription: string read FServiceObjectDescription;
    property DeviceEnabled: Boolean read FDeviceEnabled write SetDeviceEnabled;
  end;

const
  OPOS_S_CLAIMED = 'Device already claimed';
  S_DEVICE_ENABLED = 'Device is enabled';
  S_DEVICE_DISABLED = 'Device is disabled';
  BoolToInt: array [Boolean] of Integer = (0, 1);

function IntToBool(Value: Integer): Boolean;

implementation

function IntToBool(Value: Integer): Boolean;
begin
  Result := Value <> 0;
end;

function OposDeviceExists(const DeviceClass, DeviceName: string): Boolean;
var
  Key: HKEY;
  RegKeyName: string;
begin
  RegKeyName := Tnt_WideFormat('%s\%s\%s', [OPOS_ROOTKEY, DeviceClass, DeviceName]);
  Result := RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(RegKeyName), 0,
    KEY_READ, Key) = ERROR_SUCCESS;
  if Result then
    RegCloseKey(Key);
end;

{ TOposDevice }

constructor TOposDevice.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  if ALogger = nil then
    FLogger := TLogFile.Create;

  FEvents := TOposEvents.Create;
  FSemaphore := TOposSemaphore.Create;
  Initialize;
  // EventThread
  FEventThread := TQueueThread.Create(True);
  FEventThread.OnExecute := EventProc;
  FEventThread.Resume;
end;

destructor TOposDevice.Destroy;
begin
  CloseService;
  FEventThread.Free;
  FEvents.Free;
  FSemaphore.Free;
  FOposEvents := nil;
  FLogger := nil;
  inherited Destroy;
end;

procedure TOposDevice.CheckEnabled;
begin
  if not DeviceEnabled then
    RaiseOposException(OPOS_E_DISABLED, S_DEVICE_DISABLED);
end;

procedure TOposDevice.CheckDisabled;
begin
  if DeviceEnabled then
    RaiseOposException(OPOS_E_ILLEGAL, S_DEVICE_ENABLED);
end;

procedure TOposDevice.SetPowerNotify(const Value: Integer);
begin
  CheckDisabled;
  FPowerNotify := Value;
end;

procedure TOposDevice.Initialize;
begin
  FOposEvents := nil;

  FState := OPOS_S_CLOSED;
  FOpened := False;
  FClaimed := False;
  FDeviceName := '';
  FDeviceClass := '';
  FAutoDisable := False;
  FCapCompareFirmwareVersion := False;
  FCapPowerReporting := OPOS_PR_STANDARD;
  FCapStatisticsReporting := True;
  FCapUpdateFirmware := False;
  FCapUpdateStatistics := True;
  FPowerNotify := OPOS_PN_DISABLED;
  FPowerState := OPOS_PS_UNKNOWN;
  FOpenResult := OPOS_SUCCESS;
  FBinaryConversion := OPOS_BC_NONE;
  FResultCode := OPOS_SUCCESS;
  FCheckHealthText := '';
  FDataEventEnabled := False;
  FDeviceEnabled := False;
  FFreezeEvents := False;
  FOutputID := 1;
  FServiceObjectVersion := GenericServiceVersion;
  FServiceObjectDescription := '';
  FPhysicalDeviceDescription := '';
  FPhysicalDeviceName := '';
  FErrorString := '';
  FResultCodeExtended := OPOS_SUCCESS;
  FLastErrorCode := 0;
  FLastErrorText := '';
  FOpenResult := 0;
end;

function TOposDevice.Open(
  const ADeviceClass, ADeviceName: string;
  const AOposEvents: IOposEvents): Integer;
begin
  Logger.Debug('TOposDevice.Open', [ADeviceClass, ADeviceName]);
  try
    if FOpened then
    begin
      FOpenResult := OPOS_OR_ALREADYOPEN;
      RaiseOposException(OPOS_E_ILLEGAL);
    end;
    Initialize;

    if not OposDeviceExists(ADeviceClass, ADeviceName) then
    begin
      FOpenResult := OPOS_OR_REGBADNAME;
      RaiseOposException(OPOS_E_NOEXIST);
    end;

    FDeviceClass := ADeviceClass;
    FDeviceName := ADeviceName;
    FOposEvents := AOposEvents;

    // State is changed to S_IDLE when the open method is successfully called.
    FState := OPOS_S_IDLE;
    FOpened := True;
    FOpenResult := OPOS_SUCCESS;
    Result := ClearResult;
  except
    on E: Exception do
    begin
      Result := HandleException(E);
    end
  end;
end;

function TOposDevice.CloseService: Integer;
begin
  try
    if FClaimed then
      ReleaseDevice;
    FEvents.Clear;
    FOpened := False;
    FOposEvents := nil;
    FState := OPOS_S_CLOSED;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.ClaimDevice(Timeout: Integer): Integer;
var
  LongDeviceName: WideString;
begin
  try
    CheckOpened;
    if FClaimed then
      RaiseOPOSException(OPOS_E_CLAIMED, OPOS_S_CLAIMED);

    LongDeviceName := Tnt_WideFormat('%s/%s', [FDeviceClass, FDeviceName]);
    FSemaphore.Claim(LongDeviceName, Timeout);

    FClaimed := True;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.ReleaseDevice: Integer;
begin
  try
    CheckClaimed;
    FEvents.Clear;
    DeviceEnabled := False;
    FSemaphore.Release;
    FClaimed := False;
    
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TOposDevice.CheckOpened;
begin
  if not FOpened then
    RaiseOposException(OPOS_E_CLOSED);
end;

procedure TOposDevice.CheckClaimed;
begin
  CheckOpened;
  if not FClaimed then
    RaiseOposException(OPOS_E_NOTCLAIMED);
end;

// State is set to S_BUSY when the Service is processing output.
// The State is restored to S_IDLE when the output has completed

procedure TOposDevice.BeginOutput;
begin
  FState := OPOS_S_BUSY;
end;

procedure TOposDevice.EndOutput;
begin
  FState := OPOS_S_IDLE;
end;

(*

The State is changed to S_ERROR when an asynchronous output encounters
an error condition, or when an error is encountered during the gathering
or processing of event-driven input.

After the Service changes the State property to S_ERROR, it notifies the
application of this error. The properties of this event are the error code and
extended error code, the locus of the error, and a modifiable response to the
error

*)


procedure TOposDevice.SetFreezeEvents(const Value: Boolean);
begin
  if Value <> FreezeEvents then
  begin
    FFreezeEvents := Value;
    if not FFreezeEvents then
      FEventThread.WakeUp;
  end;
end;

procedure TOposDevice.FireEvent(Event: TOposEvent);
begin
  Events.Add(Event);
  FEventThread.WakeUp;
end;

procedure TOposDevice.EventProc(Sender: TObject);
begin
  try
    DeliverEvents;
  except
    on E: Exception do
      Logger.Error('EventProc: ', E);
  end;
end;

procedure TOposDevice.DeliverEvents;
var
  Event: TOposEvent;
begin
  Event := nil;
  repeat
    if FFreezeEvents then Break;
    Event := FEvents.Remove(0);
    if Event <> nil then
    begin
      case Event.ID of
        EVENT_ID_DATA:
        begin
          if FDataEventEnabled then
          begin
            FDataEventEnabled := False;
            if AutoDisable then
            begin
              FDeviceEnabled := False;
            end;
            Event.Execute(FOposEvents);
          end;
        end;
      else
        Event.Execute(FOposEvents);
      end;
      Event.Free;
    end;
  until Event = nil;
end;


procedure TOposDevice.StatusUpdateEvent(Data: Integer);
begin
  Logger.Debug('StatusUpdateEvent: ' + GetScaleStatusUpdateEventText(Data));
  FireEvent(TStatusUpdateEvent.Create(Data, Logger));
end;


procedure TOposDevice.SetPowerState(const Value: Integer);
begin
  if FPowerNotify = OPOS_PN_ENABLED then
  begin
    if Value <> PowerState then
    begin
      case Value of
        OPOS_PS_ONLINE       : StatusUpdateEvent(OPOS_SUE_POWER_ONLINE);
        OPOS_PS_OFF          : StatusUpdateEvent(OPOS_SUE_POWER_OFF);
        OPOS_PS_OFFLINE      : StatusUpdateEvent(OPOS_SUE_POWER_OFFLINE);
        OPOS_PS_OFF_OFFLINE  : StatusUpdateEvent(OPOS_SUE_POWER_OFF_OFFLINE);
      end;
      FPowerState := Value;
    end;
  end;
end;

function TOposDevice.ConvertBinary(const Data: string): string;

  // First character = 0x30 + bits 7-4 of the data byte.
  // Second character = 0x30 + bits 3-0 of the data byte.

  function NibbleConversion(const Data: string): string;
  var
    C: Char;
    Item: string;
    Text: string;
  begin
    Result := '';
    Text := Data;
    repeat
      Item := Copy(Text, 1, 2);
      if Length(Item) < 2 then Break;
      Text := Copy(Text, 3, Length(Text));
      C := Chr(((Ord(Item[1]) - $30) shl 4) + (Ord(Item[2]) - $30));
      Result := Result + C;
    until False;
  end;

  function DecimalConversion(const Data: string): string;
  var
    Item: string;
    Text: string;
  begin
    Result := '';
    Text := Data;
    repeat
      Item := Copy(Text, 1, 3);
      if Length(Item) < 3 then Break;
      Text := Copy(Text, 4, Length(Text));
      Result := Result + Chr(StrToInt(Trim(Item)));
    until False;
  end;

begin
  case FBinaryConversion of
    OPOS_BC_NONE    : Result := Data;
    OPOS_BC_NIBBLE  : Result := NibbleConversion(Data);
    OPOS_BC_DECIMAL : Result := DecimalConversion(Data);
  else
    RaiseOposException(OPOS_E_ILLEGAL, 'Invalid BinaryConversion property value');
  end;
end;

function TOposDevice.ClearResult: Integer;
begin
  FErrorString := '';
  Result := OPOS_SUCCESS;
  FResultCode := OPOS_SUCCESS;
  FResultCodeExtended := OPOS_SUCCESS;
end;

function TOposDevice.SetResultCode(Value: Integer;
  const AErrorString: string): Integer;
begin
  FErrorString := AErrorString;
  Result := Value;
  FResultCode := Value;
  FResultCodeExtended := OPOS_SUCCESS;
  Logger.Error(EOPOSException.GetResultCodeText(Result) + ': ' + AErrorString);
end;

function TOposDevice.HandleException(E: Exception): Integer;
var
  OPOSException: EOPOSException;
begin
  // EOPOSException
  if E is EOPOSException then
  begin
    Logger.Error('', E);
    OPOSException := E as EOPOSException;
    FErrorString := E.Message;
    FResultCode := OPOSException.ResultCode;
    FResultCodeExtended := OPOSException.ResultCodeExtended;
    Result := FResultCode;
    Exit;
  end;

  if E is ESerialPortError then
  begin
    SetPowerState(OPOS_PS_OFF);
    FErrorString := E.Message;
    FResultCode := OPOS_E_FAILURE;
    FResultCodeExtended := OPOS_SUCCESS;
    Result := FResultCode;
    Exit;
  end;

  if E is ENoPortError then
  begin
    FErrorString := E.Message;
    FOpenResult := OPOS_ORS_NOPORT;
    FResultCode := OPOS_E_FAILURE;
    FResultCodeExtended := OPOS_SUCCESS;
    Result := FResultCode;
    Exit;
  end;

  if E is EDriverError then
  begin
    HandleDriverError(E as EDriverError);
    Result := FResultCode;
    Exit;
  end;

  Logger.Error('OPOS_E_FAILURE', E);
  FErrorString := E.Message;
  FResultCode := OPOS_E_FAILURE;
  FResultCodeExtended := OPOS_SUCCESS;
  Result := FResultCode;
end;

procedure TOposDevice.HandleDriverError(E: EDriverError);
begin
  FResultCode := OPOS_E_EXTENDED;
  FLastErrorCode := E.ErrorCode;
  FLastErrorText := E.Message;
  FResultCodeExtended := OPOSERREXT + 100 + E.ErrorCode;
end;

function TOposDevice.ClearInput: Integer;
begin
  try
    CheckClaimed;
    FEvents.ClearInput;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.ClearOutput: Integer;
begin
  try
    CheckClaimed;
    FEvents.ClearOutput;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.COFreezeEvents(Freeze: WordBool): Integer;
begin
  try
    FreezeEvents := Freeze;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.CompareFirmwareVersion(
  const FirmwareFileName: WideString;
  out pResult: Integer): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError('CompareFirmwareVersion not supported');
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.IllegalError(const AMessage: string): Integer;
begin
  Result := SetResultCode(OPOS_E_ILLEGAL, AMessage);
end;

function TOposDevice.ResetStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError('ResetStatistics not supported');
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError('RetrieveStatistics not supported');
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.UpdateFirmware(
  const FirmwareFileName: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError('UpdateFirmware not supported');
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.UpdateStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError('UpdateStatistics not supported');
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TOposDevice.CheckHealth(Level: Integer): Integer;
begin
  Result := IllegalError('CheckHealth not supported');
end;

function TOposDevice.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError('DirectIO not supported');
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TOposDevice.SetDeviceEnabled(const Value: Boolean);
begin
  CheckClaimed;
  if Value <> DeviceEnabled then
  begin
    EnableDevice(Value);
    FDeviceEnabled := Value;
  end;
end;

procedure TOposDevice.EnableDevice(const Value: Boolean);
begin
end;

function TOposDevice.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  case PropIndex of
    // standard
    PIDX_Claimed                    : Result := BoolToInt[FClaimed];
    PIDX_DataEventEnabled           : Result := BoolToInt[FDataEventEnabled];
    PIDX_DeviceEnabled              : Result := BoolToInt[FDeviceEnabled];
    PIDX_FreezeEvents               : Result := BoolToInt[FFreezeEvents];
    PIDX_OutputID                   : Result := FOutputID;
    PIDX_ResultCode                 : Result := FResultCode;
    PIDX_ResultCodeExtended         : Result := FResultCodeExtended;
    PIDX_ServiceObjectVersion       : Result := FServiceObjectVersion;
    PIDX_State                      : Result := FState;
    PIDX_AutoDisable                : Result := BoolToInt[FAutoDisable];
    PIDX_BinaryConversion           : Result := FBinaryConversion;
    PIDX_DataCount                  : Result := GetDataCount;
    PIDX_PowerNotify                : Result := FPowerNotify;
    PIDX_PowerState                 : Result := FPowerState;
    PIDX_CapPowerReporting          : Result := FCapPowerReporting;
    PIDX_CapStatisticsReporting     : Result := BoolToInt[FCapStatisticsReporting];
    PIDX_CapUpdateStatistics        : Result := BoolToInt[FCapUpdateStatistics];
    PIDX_CapCompareFirmwareVersion  : Result := BoolToInt[FCapCompareFirmwareVersion];
    PIDX_CapUpdateFirmware          : Result := BoolToInt[FCapUpdateFirmware];
  else
    Result := 0;
  end;
end;

function TOposDevice.GetPropertyString(PropIndex: Integer): WideString;
begin
  case PropIndex of
    // commmon
    PIDX_CheckHealthText                : Result := FCheckHealthText;
    PIDX_DeviceDescription              : Result := FPhysicalDeviceDescription;
    PIDX_DeviceName                     : Result := FPhysicalDeviceName;
    PIDX_ServiceObjectDescription       : Result := FServiceObjectDescription;
    // specific
  else
    Result := '';
  end;
end;

procedure TOposDevice.SetPropertyNumber(PropIndex, Number: Integer);
begin
  try
    case PropIndex of
      // common
      PIDX_DeviceEnabled          : DeviceEnabled := IntToBool(Number);
      PIDX_DataEventEnabled       : FDataEventEnabled := IntToBool(Number);
      PIDX_FreezeEvents           : FreezeEvents := IntToBool(Number);
      PIDX_AutoDisable            : FAutoDisable := IntToBool(Number);
      PIDX_BinaryConversion       : FBinaryConversion := Number;
      PIDX_PowerNotify            : PowerNotify := Number;
    else
      RaiseOposException(OPOS_E_ILLEGAL);
    end;
    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

procedure TOposDevice.SetPropertyString(PropIndex: Integer;
  const Text: WideString);
begin
  ClearResult;
end;

function TOposDevice.GetDataCount: Integer;
begin
  Result := FEvents.DataCount;
end;

end.
