unit M5OposDevice;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs, Math,
  // Opos
  Opos, Oposhi, OposScal, OposScalhi, OposEvents, OposException,
  OposScalUtils, OposSemaphore,
  // Tnt
  TntSysUtils, TntClasses, 
  // Shared
  NotifyThread, SerialPort, LogFile,
  // This
  OposDevice, DriverError, ScaleParameters, M5ScaleTypes,
  ScaleTypes, LocalConnection, ServiceVersion, ScaleRequest, ReadWeightRequest,
  DIOHandler, CommandDef, ScaleCommands, FileUtils, ScaleDirectIO, BinStream,
  QueueThread, ScaleStatistics, SerialPorts;

type
  { TM5OposDevice }

  TM5OposDevice = class(TOposDevice)
  private
    FThread: TQueueThread;
    FPollEnabled: Boolean;
    FPollThread: TNotifyThread;
    FLock: TCriticalSection;
    FDevice: IM5ScaleDevice;
    FRequests: TScaleRequests;
    FConnection: IScaleConnection;
    FParameters: TScaleParameters;
    FDIOHandlers: TDIOHandlers;
    FCommands: TCommandDefs;
    FStatistics: TScaleStatistics;
    FUIController: IScaleUIController;
    FWeightFactor: Double;

    procedure Lock;
    procedure Unlock;
    procedure PollWeight;
    procedure InitCommandDefs;
    procedure ConnectDevice;
    procedure ProcessRequests;
    procedure CreateDIOHandlers;
    procedure CheckHealthInternal;
    procedure CheckHealthInteractive;
    procedure PollProc(Sender: TObject);
    procedure ThreadProc(Sender: TObject);
    procedure SetUnitPrice(const Value: Currency);
    procedure SetStatusNotify(const Value: Integer);
    procedure DoReadWeight(out pWeightData: Integer; Timeout: Integer);
    function SearchByBaudRate(PortNumber, BaudRate, ByteTimeout: Integer): Boolean;
    procedure SearchDevice;
    function Connect(PortNumber, Timeout: Integer): Boolean;
    function GetWeightFactor: Double;
  private
    FCapDisplay: Boolean;
    FCapZeroScale: Boolean;
    FCapTareWeight: Boolean;
    FCapDisplayText: Boolean;
    FCapStatusUpdate: Boolean;
    FCapPriceCalculating: Boolean;
    FMaximumWeight: Integer;
    FWeightUnits: Integer;
    FAsyncMode: Boolean;
    FMaxDisplayTextChars: Integer;
    FTareWeight: Integer;
    FScaleLiveWeight: Integer;
    FStatusNotify: Integer;
    FZeroValid: Boolean;
    FSalesPrice: Currency;
    FUnitPrice: Currency;
    FConnected: Boolean;
    FStatus: TM5Status;
    FDeviceMetrics: TDeviceMetrics;
    procedure DisconnectDevice;
    procedure SetTareWeight(const Value: Integer);
  protected
    procedure Initialize; override;
    procedure EnableDevice(const Value: Boolean); override;
  public
    function Send(Stream: TBinStream): Integer; overload;
    function Send(const TxData: string): string; overload;
    function GetErrorText(Code: Integer): string;
  public
    constructor Create(
      ALogger: ILogFile;
      ADevice: IM5ScaleDevice;
      AConnection: IScaleConnection;
      ACommands: TCommandDefs;
      AParameters: TScaleParameters;
      AStatistics: TScaleStatistics;
      AUIController: IScaleUIController);

    destructor Destroy; override;

    function Open(const ADeviceClass, ADeviceName: string;
      const AOposEvents: IOposEvents): Integer; override;
    function CheckHealth(Level: Integer): Integer; override;
    function DisplayText(const Data: WideString): Integer;
    function DirectIO(Command: Integer; var pData: Integer;
      var pString: WideString): Integer; override;
    function ZeroScale: Integer;
    function ReadWeight(out pWeightData: Integer;
      Timeout: Integer): Integer;
    function GetPropertyNumber(PropIndex: Integer): Integer; override;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); override;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; override;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; override;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; override;

    property CapDisplay: Boolean read FCapDisplay;
    property CapZeroScale: Boolean read FCapZeroScale;
    property CapTareWeight: Boolean read FCapTareWeight;
    property CapDisplayText: Boolean read FCapDisplayText;
    property CapStatusUpdate: Boolean read FCapStatusUpdate;
    property CapPriceCalculating: Boolean read FCapPriceCalculating;
    property MaximumWeight: Integer read FMaximumWeight;
    property WeightUnits: Integer read FWeightUnits;
    property AsyncMode: Boolean read FAsyncMode write FAsyncMode;
    property MaxDisplayTextChars: Integer read FMaxDisplayTextChars;
    property TareWeight: Integer read FTareWeight write SetTareWeight;
    property ScaleLiveWeight: Integer read FScaleLiveWeight;
    property StatusNotify: Integer read FStatusNotify write SetStatusNotify;
    property ZeroValid: Boolean read FZeroValid write FZeroValid;
    property SalesPrice: Currency read FSalesPrice;
    property UnitPrice: Currency read FUnitPrice write SetUnitPrice;

    property Device: IM5ScaleDevice read FDevice;
    property Commands: TCommandDefs read FCommands;
    property Parameters: TScaleParameters read FParameters;
    property Statistics: TScaleStatistics read FStatistics;
    property PollEnabled: Boolean read FPollEnabled write FPollEnabled;
  end;

const
  S_ZERO_WEIGHT = 'Zero weight';
  S_CHECK_HEALTH_SUCCESS = 'Internal HCheck: Successful';
  S_CHECK_HEALTH_INTERACTIVE_SUCCESS = 'Interactive HCheck: Successful';
  S_CHECK_HEALTH_WEIGHT_OVERWEIGHT = 'Internal HCheck: Weight overflow';
  S_SERVICE_OBJECT_DESCRIPTION = 'Scale OPOS Service Driver, (C) 2012 SHTRIH-M';

implementation

uses
  ScaleDIOHandlers;

{ TM5OposDevice }

constructor TM5OposDevice.Create(
  ALogger: ILogFile;
  ADevice: IM5ScaleDevice;
  AConnection: IScaleConnection;
  ACommands: TCommandDefs;
  AParameters: TScaleParameters;
  AStatistics: TScaleStatistics;
  AUIController: IScaleUIController);
begin
  inherited Create(ALogger);
  FDevice := ADevice;
  FCommands := ACommands;
  FConnection := AConnection;
  FParameters := AParameters;
  FStatistics := AStatistics;
  FUIController := AUIController;

  FLock := TCriticalSection.Create;
  FRequests := TScaleRequests.Create;
  FDIOHandlers := TDIOHandlers.Create;

  InitCommandDefs;
  CreateDIOHandlers;
  Initialize;

  FThread := TQueueThread.Create(True);
  FThread.OnExecute := ThreadProc;
  FThread.Resume;
  FPollEnabled := True;
end;

destructor TM5OposDevice.Destroy;
begin
  CloseService;
  FThread.Free;
  FPollThread.Free;

  FDevice := nil;
  FConnection := nil;
  FDIOHandlers.Free;
  FRequests.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TM5OposDevice.InitCommandDefs;
var
  FileName: string;
begin
  SetDefaultCommands(FCommands);
  FileName := ChangeFileExt(GetModuleFileName, '.xml');
  FCommands.LoadFromFile(FileName);
end;

procedure TM5OposDevice.CreateDIOHandlers;
begin
  FDIOHandlers.Clear;
  TDIOHexCommand.CreateCommand(FDIOHandlers, Self);
  TDIOXmlCommand.CreateCommand(FDIOHandlers, Self);
  TDIOStrCommand.CreateCommand(FDIOHandlers, Self);
  TDIOGetDriverParameter.CreateCommand(FDIOHandlers, Self);
  TDIOSetDriverParameter.CreateCommand(FDIOHandlers, Self);
end;

procedure TM5OposDevice.Lock;
begin
  FLock.Enter;
end;

procedure TM5OposDevice.Unlock;
begin
  FLock.Leave;
end;

procedure TM5OposDevice.Initialize;
begin
  inherited Initialize;
  FCapDisplay := True;
  FCapZeroScale := True;
  FCapTareWeight := True;
  FCapDisplayText := False;
  FCapStatusUpdate := True;
  FCapPriceCalculating := True;
  FMaximumWeight := 6000;
  FWeightUnits := SCAL_WU_KILOGRAM;
  FAsyncMode := False;
  FMaxDisplayTextChars := 0;
  FTareWeight := 0;
  FScaleLiveWeight := 0;
  FStatusNotify := SCAL_SN_DISABLED;
  FZeroValid := True;
  FSalesPrice := 0;
  FUnitPrice := 0;
  FConnected := False;
  FServiceObjectDescription := S_SERVICE_OBJECT_DESCRIPTION;
end;

function TM5OposDevice.Open(
  const ADeviceClass, ADeviceName: string;
  const AOposEvents: IOposEvents): Integer;
begin
  Result := inherited Open(ADeviceClass, ADeviceName, AOposEvents);
  FCapPriceCalculating := Parameters.CapPrice;

  Statistics.IniLoad(OPOS_CLASSKEY_SCAL + ADeviceName);
  Statistics.DeviceCategory := OPOS_CLASSKEY_SCAL;
  Statistics.UnifiedPOSVersion := '1.13.0';
  Statistics.ManufacturerName := 'SHTRIH-M';
  Statistics.InterfaceName := 'RS232';
end;

function TM5OposDevice.CheckHealth(Level: Integer): Integer;
begin
  try
    case Level of
      OPOS_CH_INTERNAL:
        CheckHealthInternal;
      (*
      OPOS_CH_EXTERNAL:
      begin

      end;
      *)
      OPOS_CH_INTERACTIVE:
        CheckHealthInteractive;
    else
      RaiseIllegalError;
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TM5OposDevice.CheckHealthInternal;
var
  Status: TM5Status;
begin
  Device.Check(Device.ReadStatus(Status));
  FCheckHealthText := S_CHECK_HEALTH_SUCCESS;
  if Status.Flags.isOverweight then
    FCheckHealthText := S_CHECK_HEALTH_WEIGHT_OVERWEIGHT;
end;

procedure TM5OposDevice.CheckHealthInteractive;
begin
  //FUIController.ShowScaleDlg; { !!! }
  FCheckHealthText := S_CHECK_HEALTH_INTERACTIVE_SUCCESS;
end;

function TM5OposDevice.ZeroScale: Integer;
begin
  try
    CheckEnabled;
    Device.Check(Device.Zero);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;


function TM5OposDevice.ReadWeight(
  out pWeightData: Integer;
  Timeout: Integer): Integer;
begin
  try
    CheckEnabled;
    if AsyncMode then
    begin
      pWeightData := 0;
      FRequests.Add(TReadWeightRequest.Create(Timeout));
      FThread.WakeUp;
    end else
    begin
      DoReadWeight(pWeightData, Timeout);
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TM5OposDevice.ThreadProc(Sender: TObject);
begin
  ProcessRequests;
end;

procedure TM5OposDevice.ProcessRequests;
var
  Request: TObject;
  WeightData: Integer;
  ReadWeightRequest: TReadWeightRequest;
begin
  Lock;
  try
    try
      if not DeviceEnabled then Exit;
      repeat
        Request := FRequests.GetItem;
        if Request = nil then Break;
        if Request is TReadWeightRequest then
        begin
          ReadWeightRequest := Request as TReadWeightRequest;
          DoReadWeight(WeightData, ReadWeightRequest.Timeout);

          FireEvent(TDataEvent.Create(WeightData, EVENT_TYPE_INPUT, Logger));
          ReadWeightRequest.Free;
          if AutoDisable then Break;
        end;
      until False;
    except
      on E: Exception do
      begin
        Logger.Error('EventProc: ', E);
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TM5OposDevice.PollProc(Sender: TObject);
begin
  while not FPollThread.Terminated do
  begin
    PollWeight;
    FPollThread.Sleep(Parameters.PollPeriod);
  end;
end;

function TM5OposDevice.GetWeightFactor: Double;
begin
  if FWeightFactor = 0 then
  begin
    FWeightFactor := Device.ReadWeightFactor;
  end;
  Result := FWeightFactor;
end;

procedure TM5OposDevice.PollWeight;
var
  Status: TM5Status;
begin
  Lock;
  try
    try
      Device.Check(Device.ReadStatus(Status));
      // WeightStable
      if Status.Flags.isWeightStable <> FStatus.Flags.isWeightStable then
      begin
        if Status.Flags.isWeightStable then
          StatusUpdateEvent(SCAL_SUE_STABLE_WEIGHT)
        else
          StatusUpdateEvent(SCAL_SUE_WEIGHT_UNSTABLE);
      end;
      if Status.Weight <> FStatus.Weight then
      begin
        if Status.Weight = 0 then
          StatusUpdateEvent(SCAL_SUE_WEIGHT_ZERO);

        if (Status.Weight < 0)and(FStatus.Weight >= 0) then
          StatusUpdateEvent(SCAL_SUE_WEIGHT_UNDER_ZERO);
      end;
      if Status.Flags.isOverweight <> FStatus.Flags.isOverweight then
      begin
        if Status.Flags.isOverweight then
          StatusUpdateEvent(SCAL_SUE_WEIGHT_OVERWEIGHT);
      end;

      FStatus := Status;
      FScaleLiveWeight := Round(Status.Weight * GetWeightFactor);
    except
      on E: Exception do
      begin
        Logger.Error('PollProc: ' + E.Message);
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TM5OposDevice.DoReadWeight(out pWeightData: Integer;
  Timeout: Integer);
var
  Status: TM5Status;
  Status2: TM5Status2;
  TickCount: Integer;
begin
  if Timeout = 0 then
  begin
    Device.Check(Device.ReadStatus(Status));
  end else
  begin
    TickCount := Integer(GetTickCount) + Timeout;
    repeat
      if Integer(GetTickCount) > TickCount then
      begin
        RaiseOposException(OPOS_E_TIMEOUT);

      end;

      Device.Check(Device.ReadStatus(Status));
      if Status.Weight = 0 then Break;
    until Status.Flags.isWeightFixed;
  end;
  if Status.Flags.isOverweight then
    RaiseExtendedError(OPOS_ESCAL_OVERWEIGHT);

  pWeightData := Round(Status.Weight * GetWeightFactor);

  if (not ZeroValid)and(pWeightData = 0) then
    RaiseOposException(OPOS_E_TIMEOUT, S_ZERO_WEIGHT);

  if FCapPriceCalculating then
  begin
    // Read sales price
    Device.Check(Device.ReadStatus2(Status2));
    FSalesPrice := Status2.Amount/100;
  end;
  Statistics.WeightReaded;
end;

function TM5OposDevice.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  try
    CheckOpened;
    FDIOHandlers.ItemByCommand(Command).DirectIO(pData, pString);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TM5OposDevice.DisconnectDevice;
begin
  FConnected := False;
  FWeightFactor := 0;
  FConnection.ClosePort;
  Statistics.IniSave(OPOS_CLASSKEY_SCAL + DeviceName);
end;

procedure TM5OposDevice.SearchDevice;
var
  i: Integer;
  Ports: TTntStringList;
  PortNumber: Integer;
  ByteTimeout: Integer;
begin
  ByteTimeout := FParameters.ByteTimeout;
  if Connect(FParameters.PortNumber, ByteTimeout) then Exit;
  if Parameters.SearchByPortEnabled then
  begin
    Ports := TTntStringList.Create;
    try
      TSerialPorts.GetSystemPorts(Ports);
      for i := 0 to Ports.Count-1 do
      begin
        PortNumber := Integer(Ports.Objects[i]);
        if PortNumber <> FParameters.PortNumber then
        begin
          if Connect(PortNumber, ByteTimeout) then Exit;
        end;
      end;
    finally
      Ports.Free;
    end;
  end;
  RaiseOPOSException(OPOS_E_NOHARDWARE, 'Device not found');
end;

function TM5OposDevice.Connect(PortNumber, Timeout: Integer): Boolean;
var
  i: Integer;
  BaudRate: Integer;
begin
  Logger.Debug('TM5OposDevice.SearchDevice');
  Result := SearchByBaudRate(PortNumber, FParameters.BaudRate, Timeout);
  if Result then Exit;

  if Parameters.SearchByBaudRateEnabled then
  begin
    for i := Low(Device.BaudRates) to High(Device.BaudRates) do
    begin
      BaudRate := Device.BaudRates[i];
      if BaudRate <> FParameters.BaudRate then
      begin
        Result := SearchByBaudRate(PortNumber, BaudRate, Timeout);
        if Result then Exit;
      end;
    end;
  end;
end;

function TM5OposDevice.SearchByBaudRate(
  PortNumber, BaudRate, ByteTimeout: Integer): Boolean;
begin
  Logger.Debug(Format('SearchByBaudRate(%d)', [BaudRate]));
  Result := True;
  try
    FConnection.OpenPort(PortNumber, BaudRate, ByteTimeout);
    Device.ReadDeviceMetrics(FDeviceMetrics);
  except
    on E: Exception do
    begin
      Result := False;
      Logger.Error(E.Message);
      if E is ENoPortError then raise;
    end;
  end;
end;

procedure TM5OposDevice.ConnectDevice;
var
  ChannelNumber: Integer;
  Channel: TScaleChannel;
begin
  try
    SearchDevice;
    FPhysicalDeviceName := FDeviceMetrics.Name;
    FPhysicalDeviceDescription := Tnt_WideFormat(
      '%s, %d.%d, model: %d', [FDeviceMetrics.Name, FDeviceMetrics.MajorType,
      FDeviceMetrics.MinorType, FDeviceMetrics.Model]);

    Device.Check(Device.ReadChannelNumber(ChannelNumber));
    Channel.Number := ChannelNumber;
    Device.Check(Device.ReadChannel(Channel));
    FWeightFactor := Power(10, Channel.Power + 3);
    FMaximumWeight := Round(Channel.MaxWeight * FWeightFactor);

    Statistics.ModelName := FDeviceMetrics.Name;
    Statistics.SerialNumber := '';
    Statistics.FirmwareRevision := Tnt_WideFormat('%d.%.3d, %d.%.3d', [
      FDeviceMetrics.MajorType, FDeviceMetrics.MinorType,
      FDeviceMetrics.MajorVersion, FDeviceMetrics.MinorVersion]);
    Statistics.InstallationDate := '';

    FConnected := True;
  except
    FConnected := False;
    FConnection.ClosePort;
    raise;
  end;
end;

procedure TM5OposDevice.SetStatusNotify(const Value: Integer);
begin
  try
    CheckDisabled;
    FStatusNotify := Value;
    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

procedure TM5OposDevice.SetPropertyNumber(PropIndex: Integer; Number: Integer);
begin
  case PropIndex of
    // specific
    PIDXScal_AsyncMode: AsyncMode := IntToBool(Number);
    PIDXScal_StatusNotify: StatusNotify := Number;
    PIDXScal_TareWeight: TareWeight := Number;
    PIDXScal_ZeroValid: ZeroValid := IntToBool(Number);
  else
    inherited SetPropertyNumber(PropIndex, Number);
  end;
end;

function TM5OposDevice.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  case PropIndex of
    // specific
    PIDXScal_MaximumWeight          : Result := FMaximumWeight;
    PIDXScal_WeightUnits            : Result := FWeightUnits;
    PIDXScal_AsyncMode              : Result := BoolToInt[FAsyncMode];
    PIDXScal_MaxDisplayTextChars    : Result := FMaxDisplayTextChars;
    PIDXScal_TareWeight             : Result := FTareWeight;
    PIDXScal_ScaleLiveWeight        : Result := FScaleLiveWeight;
    PIDXScal_StatusNotify           : Result := FStatusNotify;
    PIDXScal_CapDisplay             : Result := BoolToInt[FCapDisplay];
    PIDXScal_CapDisplayText         : Result := BoolToInt[FCapDisplayText];
    PIDXScal_CapPriceCalculating    : Result := BoolToInt[FCapPriceCalculating];
    PIDXScal_CapTareWeight          : Result := BoolToInt[FCapTareWeight];
    PIDXScal_CapZeroScale           : Result := BoolToInt[FCapZeroScale];
    PIDXScal_CapStatusUpdate        : Result := BoolToInt[FCapStatusUpdate];
    PIDXScal_ZeroValid              : Result := BoolToInt[FZeroValid];
  else
    Result := inherited GetPropertyNumber(PropIndex);
  end;
end;

function TM5OposDevice.DisplayText(const Data: WideString): Integer;
begin
  Result := IllegalError('DisplayText not supported');
end;

procedure TM5OposDevice.SetTareWeight(const Value: Integer);

  procedure WriteTareWeight(Value: Integer);
  begin
    try
      CheckEnabled;
      Device.Check(Device.WriteTareValue(Round(Value * GetWeightFactor)));
      ClearResult;
    except
      on E: Exception do
      begin
        Logger.Error('SetTareWeight failed: ' + E.Message);
        HandleException(E);
      end;
    end;
  end;

begin
  if Value <> TareWeight then
  begin
    WriteTareWeight(Value);
    FTareWeight := Value;
  end;
end;

procedure TM5OposDevice.SetUnitPrice(const Value: Currency);

  procedure WriteUnitPrice(Value: Currency);
  var
    Item: TM5WareItem;
  begin
    try
      if FCapPriceCalculating then
      begin
        Item.ItemType := 0;
        Item.Quantity := 0;
        Item.Price := Round(Value*100);
        Device.Check(Device.WriteWare(Item));
      end;
      ClearResult;
    except
      on E: Exception do
      begin
        Logger.Error('SetUnitPrice failed: ' + E.Message);
        HandleException(E);
      end;
    end;
  end;

begin
  if Value <> FUnitPrice then
  begin
    WriteUnitPrice(Value);
    FUnitPrice := Value;
  end;
end;

procedure TM5OposDevice.EnableDevice(const Value: Boolean);
begin
  if Value then
  begin
    ConnectDevice;
    PowerState := OPOS_PS_ONLINE;
    if PollEnabled then
    begin
      if FPollThread = nil then
      begin
        FPollThread := TNotifyThread.Create(True);
        FPollThread.OnExecute := PollProc;
        FPollThread.Resume;
      end;
    end;
  end else
  begin
    FPollThread.Free;
    FPollThread := nil;
    DisconnectDevice;
    PowerState := OPOS_PS_UNKNOWN;
  end;
end;

function TM5OposDevice.GetErrorText(Code: Integer): string;
begin
  Result := Device.GetErrorText(Code);
end;

function TM5OposDevice.Send(Stream: TBinStream): Integer;
var
  RxData: string;
  TxData: string;
begin
  RxData := '';
  TxData := Stream.Data;
  Result := Device.SendCommand(TxData, RxData);
  Stream.Data := RxData;
end;

function TM5OposDevice.Send(const TxData: string): string;
var
  RxData: string;
begin
  Device.Check(Device.SendCommand(TxData, RxData));
  Result := RxData;
end;

function TM5OposDevice.ResetStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  try
    CheckEnabled;
    Statistics.Reset(StatisticsBuffer);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TM5OposDevice.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  try
    CheckEnabled;
    Statistics.Retrieve(pStatisticsBuffer);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TM5OposDevice.UpdateStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  try
    CheckEnabled;
    Statistics.Update(StatisticsBuffer);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

end.
