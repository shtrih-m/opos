unit oleCashDrawer;

interface

uses
  // VCL
  Windows, ComObj, ActiveX, StdVcl, ComServ, SysUtils, Variants, SyncObjs,
  // Opos
  Opos, Oposhi, OposUtils, OposException, OposEvents, OposCash, OposCashhi,
  OposCashUtils, OposServiceDevice19, OposMessages,
  // This
  SmFiscalPrinterLib_TLB, SerialPort, VersionInfo,
  FiscalPrinterDevice, CashDrawerParameters, LogFile, SharedPrinter,
  PrinterTypes, FiscalPrinterTypes, ServiceVersion, StringUtils,
  OposEventsRCS, OposEventsNull, NotifyLink, PrinterParameters,
  DriverError;

type
  { ToleCashDrawer }

  ToleCashDrawer = class(TAutoObject, ICashDrawer)
  private
    FConnected: Boolean;
    FCapStatus: Boolean;
    FDrawerOpened: Boolean;
    FDeviceEnabled: Boolean;
    FLock: TCriticalSection;
    FStatusLink: TNotifyLink;
    FPrinter: ISharedPrinter;
    FCapStatusMultiDrawerDetect: Boolean;
    FParameters: TCashDrawerParameters;
    FOposDevice: TOposServiceDevice19;

    procedure Lock;
    procedure UnLock;
    procedure Connect;
    procedure CheckEnabled;
    function DoClose: Integer;
    function DoRelease: Integer;
    procedure InternalInit;
    function ClearResult: Integer;
    function GetPrinter: ISharedPrinter;
    function GetDevice: IFiscalPrinterDevice;
    procedure SetDeviceEnabled(Value: Boolean);
    procedure StatusUpdateEvent(Data: Integer);
    procedure SetDrawerOpened(DrawerOpened: Boolean);
    function HandleException(E: Exception): Integer;
    procedure LoadParameters(const DeviceName: string);
    function DoOpen(const DeviceClass, DeviceName: WideString;
      const pDispatch: IDispatch): Integer;

    property Printer: ISharedPrinter read GetPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
    property Parameters: TCashDrawerParameters read FParameters;
    function DecodeString(const S: string): string;
    function EncodeString(const S: string): string;
    function IllegalError: Integer;
    function GetEventInterface(FDispatch: IDispatch): IOposEvents;
    procedure StatusChanged(Sender: TObject);
    function HandleDriverError(E: EDriverError): TOPOSError;
    function GetLogger: ILogFile;
  public
    procedure LogDispatch(pDispatch: IDispatch);
  protected
    // ICashDrawer
    function  Get_OpenResult: Integer; safecall;
    function  COFreezeEvents(Freeze: WordBool): Integer; safecall;
    function  GetPropertyNumber(PropIndex: Integer): Integer; safecall;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); safecall;
    function  GetPropertyString(PropIndex: Integer): WideString; safecall;
    procedure SetPropertyString(PropIndex: Integer; const String_: WideString); safecall;
    function  Open(const DeviceClass: WideString; const DeviceName: WideString;
                   const pDispatch: IDispatch): Integer; safecall;
    function  Close: Integer; safecall;
    function  Claim(Timeout: Integer): Integer; safecall;
    function  Release1: Integer; safecall;
    function  OpenService(const DeviceClass: WideString; const DeviceName: WideString;
                          const pDispatch: IDispatch): Integer; safecall;
    function  CloseService: Integer; safecall;
    function  ClaimDevice(Timeout: Integer): Integer; safecall;
    function  ReleaseDevice: Integer; safecall;
    function  CheckHealth(Level: Integer): Integer; safecall;
    function  ClearOutput: Integer; safecall;
    function  DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function  OpenDrawer: Integer; safecall;
    function  WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer;
                                 BeepDuration: Integer; BeepDelay: Integer): Integer; safecall;
    property OpenResult: Integer read Get_OpenResult;
    function  ResetStatistics(const AStatisticsBuffer: WideString): Integer; safecall;
    function  RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function  UpdateStatistics(const AStatisticsBuffer: WideString): Integer; safecall;
    function  CompareFirmwareVersion(const AFirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function  UpdateFirmware(const AFirmwareFileName: WideString): Integer; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    property Logger: ILogFile read GetLogger;
  end;

implementation

{ TCashDrawer }

procedure ToleCashDrawer.Initialize;
begin
  inherited Initialize;
  FPrinter := SharedPrinter.GetPrinter('');
  FLock := TCriticalSection.Create;
  FOposDevice := TOposServiceDevice19.Create(Logger);
  FParameters := TCashDrawerParameters.Create(Logger);
  FStatusLink := TNotifyLink.Create;
  FStatusLink.OnChange := StatusChanged;

  InternalInit;
end;

destructor ToleCashDrawer.Destroy;
begin
  if FOposDevice.Opened then
    Close;

  FStatusLink.Free;
  FParameters.Free;
  FOposDevice.Free;
  FLock.Free;
  FPrinter := nil;
  inherited Destroy;
end;

function ToleCashDrawer.IllegalError: Integer;
begin
  Result := FOposDevice.SetResultCode(OPOS_E_ILLEGAL);
end;

procedure ToleCashDrawer.CheckEnabled;
begin
  FOposDevice.CheckEnabled;
end;

function ToleCashDrawer.DecodeString(const S: string): string;
begin
  case Parameters.Encoding of
    Encoding866: Result := Str866To1251(S);
  else
    Result := S;
  end;
end;

function ToleCashDrawer.EncodeString(const S: string): string;
begin
  case Parameters.Encoding of
    Encoding866: Result := Str1251To866(S);
  else
    Result := S;
  end;
end;

procedure ToleCashDrawer.Lock;
begin
  FLock.Enter;
end;

procedure ToleCashDrawer.UnLock;
begin
  FLock.Leave;
end;

procedure ToleCashDrawer.InternalInit;
begin
  // common
  FConnected := False;
  FOposDevice.ServiceObjectVersion := GenericServiceVersion;
  FOposDevice.PhysicalDeviceDescription := '';
  FOposDevice.ServiceObjectDescription := 'Cash Drawer OPOS Service Driver, (C) 2008 SHTRIH-M';
  FOposDevice.FreezeEvents := False;
  FDrawerOpened := False;
  // specific
  FCapStatus := True;
  FCapStatusMultiDrawerDetect := False;
end;

function ToleCashDrawer.GetPrinter: ISharedPrinter;
begin
  if FPrinter = nil then
    raise Exception.Create('Shared printer = nil');
  Result := FPrinter;
end;

function ToleCashDrawer.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Device;
end;

// private methods

function ToleCashDrawer.HandleException(E: Exception): Integer;
var
  OPOSError: TOPOSError;
  OPOSException: EOPOSException;
begin
  if E is EDriverError then
  begin
    OPOSError := HandleDriverError(E as EDriverError);
    FOposDevice.HandleException(OPOSError);
    Result := OPOSError.ResultCode;
    Exit;
  end;

  if E is EOPOSException then
  begin
    OPOSException := E as EOPOSException;
    OPOSError.ErrorString := E.Message;
    OPOSError.ResultCode := OPOSException.ResultCode;
    OPOSError.ResultCodeExtended := OPOSException.ResultCodeExtended;
    FOposDevice.HandleException(OPOSError);
    Result := OPOSError.ResultCode;
    Exit;
  end;

  OPOSError.ErrorString := E.Message;
  OPOSError.ResultCode := OPOS_E_FAILURE;
  OPOSError.ResultCodeExtended := OPOS_SUCCESS;
  FOposDevice.HandleException(OPOSError);
  Result := OPOSError.ResultCode;
end;

function ToleCashDrawer.HandleDriverError(E: EDriverError): TOPOSError;
begin
  Result.ResultCode := OPOS_E_EXTENDED;
  Result.ErrorString := E.Message;
  Result.ResultCodeExtended := OPOSERREXT + FPTR_ERROR_BASE + E.ErrorCode;
end;

procedure ToleCashDrawer.LoadParameters(const DeviceName: string);
begin
  Logger.Debug('ToleCashDrawer.LoadParameters', DeviceName);
  try
    Parameters.Load(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('ToleCashDrawer.LoadParameters: ', E);
      RaiseOposException(OPOS_ORS_CONFIG, E.Message);
    end;
  end;
end;

function ToleCashDrawer.DoOpen(const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  try
    FOposDevice.Open(DeviceClass, DeviceName, GetEventInterface(pDispatch));
    LoadParameters(DeviceName);

    FPrinter := SharedPrinter.GetPrinter(Parameters.FptrDeviceName);
    FPrinter.AddStatusLink(FStatusLink);
    FPrinter.Open(Parameters.FptrDeviceName);

    Logger.Debug(Logger.Separator);
    Logger.Debug('  LOG START');
    Logger.Debug('  ' + FOposDevice.ServiceObjectDescription);
    Logger.Debug('  ServiceObjectVersion     : ' + IntToStr(FOposDevice.ServiceObjectVersion));
    Logger.Debug('  File version             : ' + GetFileVersionInfoStr);
    Logger.Debug(Logger.Separator);
    //LogDispatch(pDispatch);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  FOposDevice.OpenResult := Result;
end;

procedure ToleCashDrawer.LogDispatch(pDispatch: IDispatch);
var
  pData: Integer;
  pString: WideString;
  Events: OleVariant;
begin
  try
    Events := pDispatch;
    Events.DirectIOEvent(1, pData, pString);
    Events.StatusUpdateEvent(1);
  except
    on E: Exception do
      Logger.Error('ToleCashDrawer.LogDispatch', E);
  end;
end;

function ToleCashDrawer.GetEventInterface(FDispatch: IDispatch): IOposEvents;
begin
  case Parameters.CCOType of
    CCOTYPE_RCS:
      Result := TOposEventsRCS.Create(FDispatch);
    //CCOTYPE_NCR:
    //  Result := TOposCashDrawerNCR.Create(FDispatch);
  else
    Result := TOposEventsNull.Create;
  end;
end;

function ToleCashDrawer.DoClose: Integer;
begin
  try
    FOposDevice.Close;
    SetDeviceEnabled(False);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function ToleCashDrawer.DoRelease: Integer;
begin
  try
    SetDeviceEnabled(False);
    FOposDevice.ReleaseDevice;
    Printer.ReleaseDevice;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure ToleCashDrawer.StatusUpdateEvent(Data: Integer);
begin
  FOposDevice.FireEvent(TStatusUpdateEvent.Create(Data, Logger));
end;

procedure ToleCashDrawer.SetDeviceEnabled(Value: Boolean);
begin
  Logger.Debug(Format('ToleCashDrawer.SetDeviceEnabled(%s)', [
    BoolToStr(Value)]));

  if Value <> FDeviceEnabled then
  begin
    if Value then
    begin
      Connect;
    end else
    begin
      FOposDevice.PowerState := OPOS_PS_UNKNOWN;
    end;
    FDeviceEnabled := Value;
    FOposDevice.DeviceEnabled := Value;
  end;
end;

procedure ToleCashDrawer.Connect;
begin
  Logger.Debug('ToleCashDrawer.Connect');
  try
    if not FConnected then
    begin
      Printer.Connect;
      FConnected := True;
    end;
  except
    on E: Exception do
    begin
      Logger.Error('ToleCashDrawer.Connect', E);
      HandleException(E);
    end;
  end;
end;

procedure ToleCashDrawer.SetDrawerOpened(DrawerOpened: Boolean);
begin
  if DrawerOpened <> FDrawerOpened then
  begin
    if DrawerOpened then StatusUpdateEvent(CASH_SUE_DRAWEROPEN)
    else StatusUpdateEvent(CASH_SUE_DRAWERCLOSED);
    FDrawerOpened := DrawerOpened;
  end;
end;

// ICashDrawer

function ToleCashDrawer.CheckHealth(Level: Integer): Integer;
begin
  try
    Logger.Debug(Format('ToleCashDrawer.CheckHealth(%d)', [Level]));

    FOposDevice.CheckEnabled;
    RaiseOposException(OPOS_E_ILLEGAL, MsgNotImplemented);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function ToleCashDrawer.Claim(Timeout: Integer): Integer;
begin
  Logger.Debug(Format('ToleCashDrawer.Claim(%d)', [Timeout]));
  try
    FOposDevice.ClaimDevice(Timeout);
    Printer.ClaimDevice(Timeout);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function ToleCashDrawer.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := Claim(Timeout);
end;

function ToleCashDrawer.ClearOutput: Integer;
begin
  Logger.Debug('ToleCashDrawer.ClearOutput');
  try
    FOposDevice.CheckClaimed;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function ToleCashDrawer.Close: Integer;
begin
  Result := DoClose;
  Logger.Debug(Format('ToleCashDrawer.Close = %d', [Result]));
end;

function ToleCashDrawer.CloseService: Integer;
begin
  Result := DoClose;
  Logger.Debug(Format('ToleCashDrawer.CloseService = %d', [Result]));
end;

function ToleCashDrawer.COFreezeEvents(Freeze: WordBool): Integer;
begin
  Logger.Debug(Format('ToleCashDrawer.COFreezeEvents(%s)', [VarToStr(Freeze)]));

  try
    FOposDevice.FreezeEvents := Freeze;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function ToleCashDrawer.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  try
    FOposDevice.CheckOpened;
    RaiseOposException(OPOS_E_ILLEGAL);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;

  Logger.Debug(Format(
  'ToleCashDrawer.DirectIO(' +
  'Command = %d,' +
  'Data = %d,' +
  'String = ''%s''' +
  ') = %d',
  [Command, pData, pString, Result]));
end;

function ToleCashDrawer.Get_OpenResult: Integer;
begin
  Result := FOposDevice.OpenResult;
  Logger.Debug('ToleCashDrawer.Get_OpenResult');
end;

function ToleCashDrawer.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  try
    case PropIndex of
      // standard
      PIDX_Claimed                    : Result := BoolToInt[FOposDevice.Claimed];
      PIDX_DataEventEnabled           : Result := BoolToInt[FOposDevice.DataEventEnabled];
      PIDX_DeviceEnabled              : Result := BoolToInt[FDeviceEnabled];
      PIDX_FreezeEvents               : Result := BoolToInt[FOposDevice.FreezeEvents];
      PIDX_OutputID                   : Result := FOposDevice.OutputID;
      PIDX_ResultCode                 : Result := FOposDevice.ResultCode;
      PIDX_ResultCodeExtended         : Result := FOposDevice.ResultCodeExtended;
      PIDX_ServiceObjectVersion       : Result := FOposDevice.ServiceObjectVersion;
      PIDX_State                      : Result := FOposDevice.State;
      PIDX_AutoDisable                : Result := BoolToInt[FOposDevice.AutoDisable];
      PIDX_BinaryConversion           : Result := FOposDevice.BinaryConversion;
      PIDX_DataCount                  : Result := FOposDevice.DataCount;
      PIDX_PowerNotify                : Result := FOposDevice.PowerNotify;
      PIDX_PowerState                 : Result := FOposDevice.PowerState;
      PIDX_CapPowerReporting          : Result := FOposDevice.CapPowerReporting;
      PIDX_CapStatisticsReporting     : Result := BoolToInt[FOposDevice.CapStatisticsReporting];
      PIDX_CapUpdateStatistics        : Result := BoolToInt[FOposDevice.CapUpdateStatistics];
      PIDX_CapCompareFirmwareVersion  : Result := BoolToInt[FOposDevice.CapCompareFirmwareVersion];
      PIDX_CapUpdateFirmware          : Result := BoolToInt[FOposDevice.CapUpdateFirmware];
      // specific
      PIDXCash_DrawerOpened           :
      begin
        SetDrawerOpened(Printer.GetPrinterStatus.Flags.DrawerOpened);
        Result := BoolToInt[FDrawerOpened];
      end;
      PIDXCash_CapStatus              : Result := BoolToInt[FCapStatus];
      PIDXCash_CapStatusMultiDrawerDetect: Result := BoolToInt[FCapStatusMultiDrawerDetect];
    else
      RaiseOposException(OPOS_E_ILLEGAL);
    end;
    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;

  Logger.Debug(Format('ToleCashDrawer.GetPropertyNumber(%s) = %d',
    [GetCashPropertyName(PropIndex), Result]));
end;

function ToleCashDrawer.GetPropertyString(PropIndex: Integer): WideString;
begin
  case PropIndex of
    // commmon
    PIDX_CheckHealthText                : Result := FOposDevice.CheckHealthText;
    PIDX_DeviceDescription              : Result := FOposDevice.PhysicalDeviceDescription;
    PIDX_DeviceName                     : Result := FOposDevice.PhysicalDeviceName;
    PIDX_ServiceObjectDescription       : Result := FOposDevice.ServiceObjectDescription;
    // specific
  else
    Result := '';
  end;

  Logger.Debug(Format('ToleCashDrawer.GetPropertyString(%s) = ''%s''',
    [GetCashPropertyName(PropIndex), Result]));
end;

function ToleCashDrawer.OpenDrawer: Integer;
begin
  Logger.Debug('ToleCashDrawer.OpenDrawer');
  try
    FOposDevice.CheckEnabled;
    Device.OpenDrawer(Parameters.DrawerNumber);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function ToleCashDrawer.Open(const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  Result := DoOpen(DeviceClass, DeviceName, pDispatch);
  Logger.Debug(Format('ToleCashDrawer.Open(%s, %s) = %d',
    [DeviceClass, DeviceName, Result]));
end;

function ToleCashDrawer.OpenService(const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  Result := DoOpen(DeviceClass, DeviceName, pDispatch);
  Logger.Debug(Format('ToleCashDrawer.OpenService(%s, %s) = %d',
    [DeviceClass, DeviceName, Result]));
end;

function ToleCashDrawer.Release1: Integer;
begin
  Result := DoRelease;
  Logger.Debug(Format('ToleCashDrawer.Release= %d', [Result]));
end;

function ToleCashDrawer.ReleaseDevice: Integer;
begin
  Result := DoRelease;
  Logger.Debug(Format('ToleCashDrawer.ReleaseDevice= %d', [Result]));
end;

procedure ToleCashDrawer.SetPropertyNumber(PropIndex, Number: Integer);
begin
  Logger.Debug(Format('ToleCashDrawer.SetPropertyNumber(' +
    'PropIndex = %s,Number = %d)', [GetCashPropertyName(PropIndex), Number]));

  try
    case PropIndex of
      // common
      PIDX_DeviceEnabled          : SetDeviceEnabled(IntToBool(Number));
      PIDX_DataEventEnabled       : FOposDevice.DataEventEnabled := IntToBool(Number);
      PIDX_PowerNotify            : FOposDevice.PowerNotify := Number;
    else
      RaiseOposException(OPOS_E_ILLEGAL);
    end;

    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

procedure ToleCashDrawer.SetPropertyString(PropIndex: Integer;
  const String_: WideString);
begin
  try
    Logger.Debug(Format('ToleCashDrawer.SetPropertyString(' +
      'PropIndex = %s,String = ''%s'')', [GetCashPropertyName(PropIndex), String_]));

    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

function ToleCashDrawer.WaitForDrawerClose(BeepTimeout, BeepFrequency,
  BeepDuration, BeepDelay: Integer): Integer;
var
  TimeLeft: Integer;
  StartTime: Integer;
  CurrentTime: Integer;
begin
  Logger.Debug(Format('ToleCashDrawer.WaitForDrawerClose(' +
    'BeepTimeout=%d,BeepFrequency=%d,BeepDuration=%d,BeepDelay=%d)',
    [BeepTimeout, BeepFrequency, BeepDuration, BeepDelay]));

  try
    FOposDevice.CheckEnabled;
    StartTime := GetTickCount;
    while FDrawerOpened do
    begin
      CurrentTime := GetTickCount;
      TimeLeft := StartTime - CurrentTime;
      if TimeLeft > BeepTimeout then
      begin
        Windows.Beep(BeepFrequency, BeepDuration);
        Sleep(BeepDelay);
      end;
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Logger.debug('ToleCashDrawer.WaitForDrawerClose: OK');
end;

function ToleCashDrawer.ClearResult: Integer;
begin
  Result := FOposDevice.ClearResult;
end;

function ToleCashDrawer.CompareFirmwareVersion(
  const AFirmwareFileName: WideString; out pResult: Integer): Integer;
var
  FirmwareFileName: string;
begin
  Lock;
  FirmwareFileName := DecodeString(AFirmwareFileName);
  Logger.Debug(Format('ToleCashDrawer.CompareFirmwareVersion(%s)',
    [FirmwareFileName]));
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Logger.Debug(Format('ToleCashDrawer.CompareFirmwareVersion=%d', [Result]));
  UnLock;
end;

function ToleCashDrawer.ResetStatistics(
  const AStatisticsBuffer: WideString): Integer;
var
  StatisticsBuffer: string;
begin
  Lock;
  try
    StatisticsBuffer := DecodeString(AStatisticsBuffer);
    Logger.Debug(Format('ToleCashDrawer.ResetStatistics(%s)', [StatisticsBuffer]));

    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Logger.Debug('ToleCashDrawer.ResetStatistics=' + IntToStr(Result));
  UnLock;
end;

function ToleCashDrawer.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleCashDrawer.RetrieveStatistics');
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Logger.Debug('ToleCashDrawer.RetrieveStatistics=' + IntToStr(Result));
  pStatisticsBuffer := EncodeString(pStatisticsBuffer);
  UnLock;
end;

function ToleCashDrawer.UpdateFirmware(
  const AFirmwareFileName: WideString): Integer;
var
  FirmwareFileName: string;
begin
  Lock;
  FirmwareFileName := DecodeString(AFirmwareFileName);
  Logger.Debug(Format('ToleCashDrawer.UpdateFirmware(%s)',
    [FirmwareFileName]));
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Logger.Debug('ToleCashDrawer.UpdateFirmware=' + IntToStr(Result));
  UnLock;
end;

function ToleCashDrawer.UpdateStatistics(
  const AStatisticsBuffer: WideString): Integer;
var
  StatisticsBuffer: string;
begin
  Lock;
  try
    StatisticsBuffer := DecodeString(AStatisticsBuffer);
    Logger.Debug('ToleCashDrawer.UpdateStatistics');

    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Logger.Debug('ToleCashDrawer.UpdateStatistics=' + IntToStr(Result));
  UnLock;
end;

procedure ToleCashDrawer.StatusChanged(Sender: TObject);
begin
  if Printer.Device.IsOnline then
  begin
    FOposDevice.PowerState := OPOS_PS_ONLINE;
    SetDrawerOpened(Printer.Status.Flags.DrawerOpened);
  end else
  begin
    FOposDevice.PowerState := OPOS_PS_OFF_OFFLINE;
  end;
end;

function ToleCashDrawer.GetLogger: ILogFile;
begin
  Result := FPrinter.Device.Context.Logger;
end;

initialization
  ComServer.SetServerName('OposShtrih');
  TAutoObjectFactory.Create(ComServer, ToleCashDrawer, Class_CashDrawer,
    ciMultiInstance, tmApartment);
end.
