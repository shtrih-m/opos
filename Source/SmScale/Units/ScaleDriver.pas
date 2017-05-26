unit ScaleDriver;

interface

uses
  // VCL
  SysUtils,
  // Opos
  Opos, Oposhi, OposScal, OposScalhi, OposEvents, OposException,
  OposEventsRCS, OposEventsNull,
  // This
  M5ScaleTypes, M5OposDevice, ScaleParameters, ScaleTypes, LogFile,
  FileUtils, ServiceVersion, LocalConnection, M5ScaleDevice, BinStream,
  CommandDef, VersionInfo, ScaleStatistics, UIController;

type
  { TScaleDriver }

  TScaleDriver = class
  private
    FDevice: TM5OposDevice;
    FScaleDevice: IM5ScaleDevice;
    FCommands: TCommandDefs;
    FParameters: TScaleParameters;
    FStatistics: TScaleStatistics;

    function GetLogger: TLogFile;
    function GetDevice: TM5OposDevice;
    function GetParameters: TScaleParameters;
    function HandleException(E: Exception): Integer;
    procedure LoadParameters(const DeviceName: string);
    function GetEventInterface(FDispatch: IDispatch): IOposEvents;
  public
    function ClearResult: Integer;
  public
    constructor Create; overload;
    constructor Create(
      ADevice: IM5ScaleDevice;
      AConnection: IScaleConnection;
      ACommands: TCommandDefs;
      AParameters: TScaleParameters;
      AStatistics: TScaleStatistics;
      AUIController: IScaleUIController); overload;

    destructor Destroy; override;

    function CheckHealth(Level: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearInput: Integer; safecall;
    function ClearOutput: Integer; safecall;
    function CloseService: Integer; safecall;
    function COFreezeEvents(Freeze: WordBool): Integer; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function DisplayText(const Data: WideString): Integer; safecall;
    function GetPropertyNumber(PropIndex: Integer): Integer; safecall;
    function GetPropertyString(PropIndex: Integer): WideString; safecall;
    function OpenService(const DeviceClass: WideString; const DeviceName: WideString;
                         const pDispatch: IDispatch): Integer; safecall;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); safecall;
    procedure SetPropertyString(PropIndex: Integer; const Text: WideString); safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function ZeroScale: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    function GetSalesPrice: Currency; safecall;
    function GetUnitPrice: Currency; safecall;
    procedure SetUnitPrice(Value: Currency); safecall;
    property OpenResult: Integer read Get_OpenResult;
  public
    property Logger: TLogFile read GetLogger;
    property Device: TM5OposDevice read GetDevice;
    property SalesPrice: Currency read GetSalesPrice;
    property Parameters: TScaleParameters read GetParameters;
    property UnitPrice: Currency read GetUnitPrice write SetUnitPrice;
  end;

implementation


{ TScaleDriver }

constructor TScaleDriver.Create(
  ADevice: IM5ScaleDevice;
  AConnection: IScaleConnection;
  ACommands: TCommandDefs;
  AParameters: TScaleParameters;
  AStatistics: TScaleStatistics;
  AUIController: IScaleUIController);
begin
  inherited Create;
  FCommands := ACommands;
  FParameters := AParameters;
  FStatistics := AStatistics;
  FScaleDevice := ADevice;
  FDevice := TM5OposDevice.Create(ADevice, AConnection,
    ACommands, AParameters, AStatistics, AUIController);
end;

constructor TScaleDriver.Create;
var
  Connection: IScaleConnection;
  UIController: IScaleUIController;
begin
  inherited Create;
  Connection := TLocalConnection.Create(Device.Logger);
  FScaleDevice := TM5ScaleDevice.Create(Connection);
  FCommands := TCommandDefs.Create(Device.Logger);
  FParameters := TScaleParameters.Create(Device.Logger);
  FStatistics := TScaleStatistics.Create(Device.Logger);
  UIController := TUIController.Create(FScaleDevice);
  FDevice := TM5OposDevice.Create(FScaleDevice, Connection, FCommands, FParameters,
    FStatistics, UIController);
end;

destructor TScaleDriver.Destroy;
begin
  FDevice.Free;
  FCommands.Free;
  FParameters.Free;
  FStatistics.Free;
  inherited Destroy;
end;

function TScaleDriver.GetParameters: TScaleParameters;
begin
  Result := FDevice.Parameters;
end;

function TScaleDriver.GetDevice: TM5OposDevice;
begin
  if FDevice = nil then
    RaiseOposException(OPOS_E_CLOSED);
  Result := FDevice;
end;

function TScaleDriver.GetEventInterface(FDispatch: IDispatch): IOposEvents;
begin
  case Parameters.CCOType of
    CCOTYPE_RCS:
      Result := TOposEventsRCS.Create(FDispatch);
  else
    Result := TOposEventsNull.Create;
  end;
end;

function TScaleDriver.ClearResult: Integer;
begin
  Result := Device.ClearResult;
end;

function TScaleDriver.HandleException(E: Exception): Integer;
begin
  Result := Device.HandleException(E);
end;

procedure TScaleDriver.LoadParameters(const DeviceName: string);
begin
  try
    Parameters.Load(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TScaleDriver.LoadParameters: ', E);
      RaiseOposException(OPOS_ORS_CONFIG, E.Message);
    end;
  end;
end;

function TScaleDriver.CheckHealth(Level: Integer): Integer;
begin
  Result := Device.CheckHealth(Level);
end;

function TScaleDriver.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := Device.ClaimDevice(Timeout);
end;

function TScaleDriver.ClearInput: Integer;
begin
  Result := Device.ClearInput;
end;

function TScaleDriver.ClearOutput: Integer;
begin
  Result := Device.ClearOutput;
end;

function TScaleDriver.CloseService: Integer;
begin
  Result := Device.CloseService;
end;

function TScaleDriver.COFreezeEvents(Freeze: WordBool): Integer;
begin
  Result := Device.COFreezeEvents(Freeze);
end;

function TScaleDriver.CompareFirmwareVersion(
  const FirmwareFileName: WideString;
  out pResult: Integer): Integer;
begin
  Result := Device.CompareFirmwareVersion(FirmwareFileName, pResult);
end;

function TScaleDriver.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  Result := Device.DirectIO(Command, pData, pString);
end;

function TScaleDriver.Get_OpenResult: Integer;
begin
  Result := Device.OpenResult;
end;

function TScaleDriver.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  Result := Device.GetPropertyNumber(PropIndex);
end;

function TScaleDriver.GetPropertyString(PropIndex: Integer): WideString;
begin
  Result := Device.GetPropertyString(PropIndex);
end;

function TScaleDriver.OpenService(const DeviceClass,
  DeviceName: WideString; const pDispatch: IDispatch): Integer;
begin
  try
    LoadParameters(DeviceName);
    Logger.MaxCount := Parameters.LogMaxCount;
    Logger.Enabled := Parameters.LogFileEnabled;
    Logger.FilePath := IncludeTrailingBackSlash(ExtractFilePath(GetModuleFileName)) + 'Logs';

    Logger.Debug(Logger.Separator);
    Logger.Debug('  LOG START');
    Logger.Debug('  ' + Device.ServiceObjectDescription);
    Logger.Debug('  ServiceObjectVersion     : ' + IntToStr(Device.ServiceObjectVersion));
    Logger.Debug('  File version             : ' + GetFileVersionInfoStr);
    Logger.Debug(Logger.Separator);
    Parameters.WriteLogParameters;

    FScaleDevice.Password := Parameters.Password;
    FScaleDevice.CommandTimeout := Parameters.CommandTimeout;
    Result := Device.Open(DeviceClass, DeviceName, GetEventInterface(pDispatch));
  except
    on E: Exception do
    begin
      Result := HandleException(E);
      Device.OpenResult := Result;
    end;
  end;
end;

procedure TScaleDriver.SetPropertyNumber(PropIndex, Number: Integer);
begin
  Device.SetPropertyNumber(PropIndex, Number);
end;

procedure TScaleDriver.SetPropertyString(PropIndex: Integer;
  const Text: WideString);
begin
  Device.ClearResult;
end;

function TScaleDriver.ReleaseDevice: Integer;
begin
  Result := Device.ReleaseDevice;
end;

function TScaleDriver.ResetStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  Result := Device.ResetStatistics(StatisticsBuffer);
end;

function TScaleDriver.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  Result := Device.RetrieveStatistics(pStatisticsBuffer);
end;

function TScaleDriver.UpdateFirmware(
  const FirmwareFileName: WideString): Integer;
begin
  Result := Device.UpdateFirmware(FirmwareFileName);
end;

function TScaleDriver.UpdateStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  Result := Device.UpdateStatistics(StatisticsBuffer)
end;

function TScaleDriver.DisplayText(const Data: WideString): Integer;
begin
  Result := Device.DisplayText(Data);
end;

function TScaleDriver.ZeroScale: Integer;
begin
  Result := Device.ZeroScale;
end;

function TScaleDriver.ReadWeight(
  out pWeightData: Integer;
  Timeout: Integer): Integer;
begin
  Result := Device.ReadWeight(pWeightData, Timeout);
end;

function TScaleDriver.GetSalesPrice: Currency;
begin
  Result := Device.SalesPrice;
end;

function TScaleDriver.GetUnitPrice: Currency;
begin
  Result := Device.UnitPrice;
end;

procedure TScaleDriver.SetUnitPrice(Value: Currency);
begin
  Device.UnitPrice := Value;
end;

function TScaleDriver.GetLogger: TLogFile;
begin
  Result := Device.Logger;
end;

end.
