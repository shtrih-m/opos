unit OposServiceDevice19;

interface

uses
  // VCL
  Windows, SysUtils, ActiveX,
  // Opos
  Opos, Oposhi, OposFptr, OposEvents, OposException, OposFptrUtils,
  OposUtils,
  // This
  OposSemaphore, NotifyThread, LogFile, PrinterTypes, TntSysUtils, gnugettext;

type
  { TOposServiceDevice19 }

  TOposServiceDevice19 = class
  private
    FState: Integer;
    FOpened: Boolean;
    FClaimed: Boolean;
    FDeviceName: WideString;
    FDeviceClass: WideString;
    FOposEvents: IOposEvents;
    FAutoDisable: Boolean;
    FSemaphore: TOposSemaphore;
    FCapCompareFirmwareVersion: Boolean;
    FCapPowerReporting: Integer;
    FCapStatisticsReporting: Boolean;
    FCapUpdateFirmware: Boolean;
    FCapUpdateStatistics: Boolean;
    FCheckHealthText: WideString;
    FDataCount: Integer;
    FDataEventEnabled: Boolean;
    FDeviceEnabled: Boolean;
    FEvents: TOposEvents;
    FEventThread: TNotifyThread;
    FOutputID: Integer;
    FPowerNotify: Integer;
    FPowerState: Integer;
    FServiceObjectDescription: WideString;
    FServiceObjectVersion: Integer;
    FPhysicalDeviceDescription: WideString;
    FPhysicalDeviceName: WideString;
    FOpenResult: Integer;
    FBinaryConversion: Integer;
    FResultCode: Integer;
    FErrorString: WideString;
    FResultCodeExtended: Integer;
    FLongDeviceName: WideString;
    FErrorEventEnabled: Boolean;
    FLogger: ILogFile;

    procedure EventProc(Sender: TObject);
    procedure SetPowerState(const Value: Integer);
    procedure SetFreezeEvents(const Value: Boolean);
    procedure SetDeviceEnabled(const Value: Boolean);

    property Logger: ILogFile read FLogger;
    property Events: TOposEvents read FEvents;
    function GetFreezeEvents: Boolean;
    procedure ErrorEvent(ResultCode, ResultCodeExtended,
      ErrorLocus: Integer);
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    procedure Open(const ADeviceClass, ADeviceName: WideString;
      const AOposEvents: IOposEvents);
    procedure Close;
    procedure ClaimDevice(Timeout: Integer);
    procedure ReleaseDevice;
    procedure BeginOutput;
    procedure EndOutput;
    procedure LogDispatch(FDispatch: IDispatch);

    procedure CheckOpened;
    procedure CheckClaimed;
    procedure CheckEnabled;

    procedure FireEvent(Event: TOposEvent);
    procedure StatusUpdateEvent(Data: Integer);
    function ConvertBinary(const Data: WideString): WideString;
    function ClearResult: Integer;
    function SetResultCode(Value: Integer): Integer;
    function HandleException(const OPOSError: TOPOSError): Integer;

    property Opened: Boolean read FOpened;
    property Claimed: Boolean read FClaimed;
    property DeviceName: WideString read FDeviceName;
    property DeviceClass: WideString read FDeviceClass;
    property AutoDisable: Boolean read FAutoDisable;
    property LongDeviceName: WideString read FLongDeviceName;
    property CapCompareFirmwareVersion: Boolean read FCapCompareFirmwareVersion;
    property CapPowerReporting: Integer read FCapPowerReporting;
    property CapStatisticsReporting: Boolean read FCapStatisticsReporting;
    property CapUpdateFirmware: Boolean read FCapUpdateFirmware;
    property CapUpdateStatistics: Boolean read FCapUpdateStatistics;
    property CheckHealthText: WideString read FCheckHealthText write FCheckHealthText;
    property DataCount: Integer read FDataCount;
    property DataEventEnabled: Boolean read FDataEventEnabled write FDataEventEnabled;
    property DeviceEnabled: Boolean read FDeviceEnabled write SetDeviceEnabled;
    property FreezeEvents: Boolean read GetFreezeEvents write SetFreezeEvents;
    property OutputID: Integer read FOutputID;
    property PowerNotify: Integer read FPowerNotify write FPowerNotify;
    property PowerState: Integer read FPowerState write SetPowerState;
    property State: Integer read FState;
    property ServiceObjectDescription: WideString read FServiceObjectDescription write FServiceObjectDescription;
    property ServiceObjectVersion: Integer read FServiceObjectVersion write FServiceObjectVersion;
    property PhysicalDeviceDescription: WideString read FPhysicalDeviceDescription write FPhysicalDeviceDescription;
    property PhysicalDeviceName: WideString read FPhysicalDeviceName write FPhysicalDeviceName;
    property OpenResult: Integer read FOpenResult write FOpenResult;
    property BinaryConversion: Integer read FBinaryConversion write FBinaryConversion;
    property ResultCode: Integer read FResultCode;
    property ErrorString: WideString read FErrorString;
    property ResultCodeExtended: Integer read FResultCodeExtended;
    property ErrorEventEnabled: Boolean read FErrorEventEnabled write FErrorEventEnabled;
  end;

implementation

{ TOposServiceDevice19 }

constructor TOposServiceDevice19.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FEvents := TOposEvents.Create;
  FSemaphore := TOposSemaphore.Create;

  FState := OPOS_S_CLOSED;
  FOpened := False;
  FClaimed := False;
  FOposEvents := nil;
  FDeviceName := '';
  FDeviceClass := '';
  FAutoDisable := False;
  FDeviceEnabled := False;
  FCapCompareFirmwareVersion := False;
  FCapPowerReporting := OPOS_PR_STANDARD;
  FCapStatisticsReporting := True;
  FCapUpdateFirmware := False;
  FCapUpdateStatistics := True;
  SetFreezeEvents(False);
  FPowerNotify := OPOS_PN_DISABLED;
  FPowerState := OPOS_PS_UNKNOWN;
  FOpenResult := OPOS_SUCCESS;
  FBinaryConversion := OPOS_BC_NONE;
  FResultCode := OPOS_SUCCESS;
end;

destructor TOposServiceDevice19.Destroy;
begin
  FEventThread.Free;
  FEvents.Free;
  FSemaphore.Free;
  FOposEvents := nil;
  inherited Destroy;
end;

procedure TOposServiceDevice19.Open(const ADeviceClass, ADeviceName: WideString;
  const AOposEvents: IOposEvents);
begin
  Logger.Debug('TOposServiceDevice19.Open', [ADeviceClass, ADeviceName]);

  if FOpened then
  begin
    FOpenResult := OPOS_OR_ALREADYOPEN;
    RaiseOposException(OPOS_E_ILLEGAL);
  end;

  FDeviceClass := ADeviceClass;
  FDeviceName := ADeviceName;
  FLongDeviceName := Tnt_WideFormat('%s/%s', [ADeviceClass, ADeviceName]);
  FOposEvents := AOposEvents;

  // State is changed to S_IDLE when the open method is successfully called.
  FState := OPOS_S_IDLE;
  FOpened := True;
end;

procedure TOposServiceDevice19.Close;
begin
  if FClaimed then
    ReleaseDevice;

  FOpened := False;
  FOposEvents := nil;
  FState := OPOS_S_CLOSED;
end;

procedure TOposServiceDevice19.LogDispatch(FDispatch: IDispatch);
var
  i: Integer;
  TypeAttr: PTypeAttr;
  TypeInfo: ITypeInfo;
  FuncDesc: PFuncDesc;
  ItemName: WideString;
  ItemDocString: WideString;
begin
  Logger.Debug('TOposServiceDevice19.LogDispatch.Begin');
  try
    if FDispatch = nil then
    begin
      Logger.Debug('FDispatch = nil');
      Exit;
    end;

    if Failed(FDispatch.GetTypeInfo(0, 0, TypeInfo)) then
    begin
      Logger.Debug('GetTypeInfo failed');
      Exit;
    end;

    if Failed(TypeInfo.GetTypeAttr(TypeAttr)) then
    begin
      Logger.Debug('GetTypeAttr failed');
      Exit;
    end;
    Logger.Debug('TypeAttr.cFuncs', TypeAttr.cFuncs);

    for i := 0 to TypeAttr.cFuncs-1 do
    begin
      if Succeeded(TypeInfo.GetFuncDesc(i, FuncDesc)) then
      begin
        if Succeeded(TypeInfo.GetDocumentation(FuncDesc.memid, @ItemName,
          @ItemDocString, nil, nil)) then
        begin
          Logger.Debug(Format('%d, ''%s'', ''%s''', [FuncDesc.memid, ItemName,
            ItemDocString]));
        end;

        TypeInfo.ReleaseFuncDesc(FuncDesc);
      end;
    end;
    TypeInfo.ReleaseTypeAttr(TypeAttr);
  finally
    Logger.Debug('TOposServiceDevice19.LogDispatch.End');
  end;
end;

procedure TOposServiceDevice19.ClaimDevice(Timeout: Integer);
begin
  CheckOpened;
  if not Claimed then
  begin
    FSemaphore.Claim(FLongDeviceName, Timeout);
    FClaimed := True;
  end;
end;

procedure TOposServiceDevice19.ReleaseDevice;
begin
  CheckClaimed;
  DeviceEnabled := False;
  FSemaphore.Release;
  FClaimed := False;
end;

procedure TOposServiceDevice19.CheckOpened;
begin
  if not FOpened then
    RaiseOposException(OPOS_E_CLOSED);
end;

procedure TOposServiceDevice19.CheckClaimed;
begin
  CheckOpened;
  if not FClaimed then
    RaiseOposException(OPOS_E_NOTCLAIMED);
end;

// State is set to S_BUSY when the Service is processing output.
// The State is restored to S_IDLE when the output has completed

procedure TOposServiceDevice19.BeginOutput;
begin
  FState := OPOS_S_BUSY;
end;

procedure TOposServiceDevice19.EndOutput;
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

procedure TOposServiceDevice19.CheckEnabled;
begin
  if not DeviceEnabled then
    RaiseOposException(OPOS_E_DISABLED, _('Device is disabled'));
end;

procedure TOposServiceDevice19.SetFreezeEvents(const Value: Boolean);
begin
  if Value <> FreezeEvents then
  begin
    if not Value then
    begin
      FEventThread := TNotifyThread.Create(True);
      FEventThread.OnExecute := EventProc;
      FEventThread.Resume;
    end else
    begin
      FEventThread.Free;
      FEventThread := nil;
    end;
  end;
end;

procedure TOposServiceDevice19.FireEvent(Event: TOposEvent);
begin
  Events.Add(Event);
end;

// Execute events from queue
procedure TOposServiceDevice19.EventProc(Sender: TObject);
var
  Event: TOposEvent;
begin
  try
    while not FEventThread.Terminated do
    begin
      repeat
        Event := FEvents.Remove(0);
        if Event = nil then
        begin
          Sleep(10);
          Continue;
        end;
        Event.Execute(FOposEvents);
        Event.Free;
      until Event = nil;
    end;
  except
    on E: Exception do
      Logger.Error('EventProc: ', E);
  end;
end;

procedure TOposServiceDevice19.SetDeviceEnabled(const Value: Boolean);
begin
  FDeviceEnabled := Value;
end;

procedure TOposServiceDevice19.ErrorEvent(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer);
begin
  Logger.Debug(Format('ErrorEvent: %d, %d, %d', [
    ResultCode, ResultCodeExtended, ErrorLocus]));
  FireEvent(TErrorEvent.Create(ResultCode, ResultCodeExtended, ErrorLocus, Logger));
end;

procedure TOposServiceDevice19.StatusUpdateEvent(Data: Integer);
begin
  Logger.Debug('StatusUpdateEvent: ' + GetStatusUpdateEventText(Data));
  FireEvent(TStatusUpdateEvent.Create(Data, Logger));
end;

procedure TOposServiceDevice19.SetPowerState(const Value: Integer);
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

function TOposServiceDevice19.ConvertBinary(const Data: WideString): WideString;

  // First character = 0x30 + bits 7-4 of the data byte.
  // Second character = 0x30 + bits 3-0 of the data byte.

  function NibbleConversion(const Data: WideString): WideString;
  var
    C: Char;
    Item: WideString;
    Text: WideString;
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

  function DecimalConversion(const Data: WideString): WideString;
  var
    Item: WideString;
    Text: WideString;
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
    RaiseOposException(OPOS_E_ILLEGAL, _('Invalid BinaryConversion property value'));
  end;
end;

function TOposServiceDevice19.ClearResult: Integer;
begin
  FErrorString := '';
  Result := OPOS_SUCCESS;
  FResultCode := OPOS_SUCCESS;
  FResultCodeExtended := OPOS_SUCCESS;
end;

function TOposServiceDevice19.SetResultCode(Value: Integer): Integer;
begin
  FErrorString := '';
  Result := Value;
  FResultCode := Value;
  FResultCodeExtended := OPOS_SUCCESS;
  Logger.Error(EOPOSException.GetResultCodeText(Result));
end;

function TOposServiceDevice19.HandleException(const OPOSError: TOPOSError): Integer;
var
  Line: WideString;
begin
  FErrorString := OPOSError.ErrorString;
  FResultCode := OPOSError.ResultCode;
  FResultCodeExtended := OPOSError.ResultCodeExtended;
  Result := FResultCode;

  Line := Tnt_WideFormat('%s, %s, "%s"', [GetResultCodeText(FResultCode),
    GetResultCodeExtendedText(FResultCodeExtended), FErrorString]);
  Logger.Error(Line);

  if ErrorEventEnabled then
    ErrorEvent(FResultCode, FResultCodeExtended, OPOS_EL_OUTPUT);
end;

function TOposServiceDevice19.GetFreezeEvents: Boolean;
begin
  Result := FEventThread = nil;
end;

end.
