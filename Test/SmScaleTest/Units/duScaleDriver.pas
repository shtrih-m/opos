unit duScaleDriver;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs,
  // Opos
  Opos, Oposhi, OposScalhi, OposEvents, OposScal,
  // This
  M5ScaleTypes, MockM5ScaleDevice, M5OposDevice, MockM5ScaleDevice2,
  TestFramework, ScaleDriver, FileUtils, ScaleParameters, MockScaleConnection2,
  RCSEvents, RCSEvents_TLB, ServiceVersion, ScaleTypes2, ScaleDirectIO,
  StringUtils, MockCommandDef, MockScaleParameters, MockscaleStatistics,
  MockUIController, LogFile;

type
  { TScaleDriverTest }

  TScaleDriverTest = class(TTestCase, IOposEvents)
  private
    Events: IRCSEvents;
    FWaitEvent: TEvent;
    Driver: TScaleDriver;
    State: TOposScaleState;
    Device: TMockM5ScaleDevice2;
    Connection: TMockscaleConnection2;
    OposEvents: TOposEvents;
    Commands: TMockCommandDefs;
    Parameters: TMockScaleParameters;
    Statistics: TMockscaleStatistics;
    UIController: TMockUIController;
    Logger: ILogFile;

    procedure SaveState;
    procedure ClaimDevice;
    procedure OpenService;
    procedure CloseService;
    procedure EnableDevice;
    procedure DisableDevice;
    procedure ReleaseDevice;
    procedure WriteState(var State: TOposScaleState);

    procedure DataEvent(Status: Integer);
    procedure StatusUpdateEvent(Data: Integer);
    procedure OutputCompleteEvent(OutputID: Integer);

    procedure DirectIOEvent(
      EventNumber: Integer;
      var pData: Integer;
      var pString: WideString);

    procedure ErrorEvent(
      ResultCode: Integer;
      ResultCodeExtended: Integer;
      ErrorLocus: Integer;
      var pErrorResponse: Integer);
    procedure WaitForEvent;
    procedure CheckNoEvent;
    procedure AddEvent(Event: TOposEvent);
    procedure SaveParameters;
    procedure CheckParam(ParamID: Integer;
      const ParamValue, ParamName: string);
    procedure CheckDIOGetDriverParameter;
    procedure CheckCommandHex;
    procedure CheckCommandStr;
    procedure OpenClaimEnable;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  public
    procedure CheckOpen;
    procedure CheckClose;
    procedure CheckCommandXml;
    procedure CheckReleaseDevice;
    procedure CheckStateNotChanged;
    procedure CheckRetrieveStatistics;
  published
    procedure CheckOpenResult;
    procedure CheckCheckHealthText;
    procedure CheckClaimed;
    procedure CheckDeviceEnabled;
    procedure CheckFreezeEvents;
    procedure CheckResultCode;
    procedure CheckState;
    procedure CheckServiceObjectDescription;
    procedure CheckServiceObjectVersion;
    procedure CheckDeviceDescription;
    procedure CheckMaximumWeight;
    procedure CheckWeightUnits;
    procedure CheckBinaryConversion;
    procedure CheckCapDisplay;
    procedure CheckAutoDisable;
    procedure CheckCapPowerReporting;
    procedure CheckPowerNotify;
    procedure CheckAsyncMode;
    procedure CheckCapDisplayText;
    procedure CheckCapPriceCalculating;
    procedure CheckCapTareWeight;
    procedure CheckCapZeroScale;
    procedure CheckMaxDisplayTextChars;
    procedure CheckSalesPrice;
    procedure CheckTareWeight;
    procedure CheckUnitPrice;
    procedure CheckClearInput;
    procedure CheckDirectIO;
    procedure CheckReadWeight;
    procedure CheckDisplayText;
    procedure CheckZeroScale;
    procedure CheckScaleLiveWeight;
    procedure CheckZeroValid;

    procedure CheckResetStatistics;
    procedure CheckUpdateStatistics;
  end;

implementation

const
  DeviceName        = 'Scale1';
  CurrencyPrecision = 0.0001;
  EventWaitTimeout  = 50;
  CRLF = #13#10;

{ TScaleDriverTest }

procedure TScaleDriverTest.Setup;
begin
  Logger := TLogfile.Create;
  Device := TMockM5ScaleDevice2.Create;
  Connection := TMockScaleConnection2.Create;
  Commands := TMockCommandDefs.Create(Logger);
  Parameters := TMockScaleParameters.Create(Logger);
  Statistics := TMockscaleStatistics.Create(Logger);
  UIController := TMockUIController.Create;
  Driver := TScaleDriver.Create(Device, Connection, Commands, Parameters,
    Statistics, UIController);

  Events := TRCSEvents.Create(Self);
  OposEvents := TOposEvents.Create;
  FWaitEvent := TEvent.Create(nil, False, False, '');
  Parameters.PollPeriod := 10;
  Parameters.SearchByPortEnabled := False;
  Parameters.SearchByBaudRateEnabled := False;
end;

procedure TScaleDriverTest.TearDown;
begin
  Driver.Parameters.DeleteKey(DeviceName);
  Device := nil;
  Events := nil;
  Driver.Free;
  OposEvents.Free;
  FWaitEvent.Free;
  Logger := nil;
end;

procedure TScaleDriverTest.AddEvent(Event: TOposEvent);
begin
  OposEvents.Add(Event);
  FWaitEvent.SetEvent;
end;

procedure TScaleDriverTest.DataEvent(Status: Integer);
begin
  AddEvent(TDataEvent.Create(Status, EVENT_TYPE_INPUT, Logger));
end;

procedure TScaleDriverTest.DirectIOEvent(EventNumber: Integer;
  var pData: Integer; var pString: WideString);
begin
  AddEvent(TDirectIOEvent.Create(EventNumber, pData, pString, Logger));
end;

procedure TScaleDriverTest.ErrorEvent(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  AddEvent(TErrorEvent.Create(ResultCode, ResultCodeExtended, ErrorLocus, Logger));
end;

procedure TScaleDriverTest.OutputCompleteEvent(OutputID: Integer);
begin
  AddEvent(TOutputCompleteEvent.Create(OutputID, Logger));
end;

procedure TScaleDriverTest.StatusUpdateEvent(Data: Integer);
begin
  AddEvent(TStatusUpdateEvent.Create(Data, Logger));
end;

procedure TScaleDriverTest.SaveParameters;
begin
  Driver.Parameters.Save(DeviceName);
end;

procedure TScaleDriverTest.OpenService;
begin
  Driver.Parameters.CreateKey(DeviceName);
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, Events));
end;

procedure TScaleDriverTest.OpenClaimEnable;
begin
  OpenService;
  ClaimDevice;
  EnableDevice;
end;

procedure TScaleDriverTest.CloseService;
begin
  CheckEquals(OPOS_SUCCESS, Driver.CloseService, 'Driver.CloseService');
end;

procedure TScaleDriverTest.SaveState;
begin
  WriteState(State);
end;

procedure TScaleDriverTest.CheckStateNotChanged;
var
  AState: TOposScaleState;
begin
  WriteState(AState);

  CheckEquals(State.State, AState.State, 'State.State');
  CheckEquals(State.Claimed, AState.Claimed, 'State.Claimed');
  CheckEquals(State.DeviceName, AState.DeviceName, 'State.DeviceName');
  CheckEquals(State.DeviceClass, AState.DeviceClass, 'State.DeviceClass');
  CheckEquals(State.AutoDisable, AState.AutoDisable, 'State.AutoDisable');
  CheckEquals(State.CapCompareFirmwareVersion,
    AState.CapCompareFirmwareVersion,
    'State.CapCompareFirmwareVersion');
  CheckEquals(State.CapPowerReporting, AState.CapPowerReporting,
    'State.CapPowerReporting');
  CheckEquals(State.CapStatisticsReporting, AState.CapStatisticsReporting,
    'State.CapStatisticsReporting');
  CheckEquals(State.CapUpdateFirmware, AState.CapUpdateFirmware,
    'State.CapUpdateFirmware');
  CheckEquals(State.CapUpdateStatistics, AState.CapUpdateStatistics,
    'State.CapUpdateStatistics');
  CheckEquals(State.CheckHealthText, AState.CheckHealthText,
    'State.CheckHealthText');
  CheckEquals(State.DataCount, AState.DataCount, 'State.DataCount');
  CheckEquals(State.DataEventEnabled, AState.DataEventEnabled,
    'State.DataEventEnabled');
  CheckEquals(State.DeviceEnabled, AState.DeviceEnabled, 'State.DeviceEnabled');
  CheckEquals(State.FreezeEvents, AState.FreezeEvents, 'State.FreezeEvents');
  CheckEquals(State.OutputID, AState.OutputID, 'State.OutputID');
  CheckEquals(State.PowerNotify, AState.PowerNotify, 'State.PowerNotify');
  CheckEquals(State.PowerState, AState.PowerState, 'State.PowerState');
  CheckEquals(State.ServiceObjectDescription,
    AState.ServiceObjectDescription,
    'State.ServiceObjectDescription');

  CheckEquals(State.ServiceObjectVersion,
    AState.ServiceObjectVersion,
    'State.ServiceObjectVersion');

  CheckEquals(State.PhysicalDeviceDescription,
    AState.PhysicalDeviceDescription,
    'State.PhysicalDeviceDescription');
  CheckEquals(State.PhysicalDeviceName,
    AState.PhysicalDeviceName,
    'State.PhysicalDeviceName');
  CheckEquals(State.BinaryConversion,
    AState.BinaryConversion,
    'State.BinaryConversion');
  CheckEquals(State.ResultCode,
    AState.ResultCode,
    'State.ResultCode');
  CheckEquals(State.ErrorString, AState.ErrorString, 'State.ErrorString');
  CheckEquals(State.ResultCodeExtended, AState.ResultCodeExtended,
    'State.ResultCodeExtended');
  CheckEquals(State.OpenResult, AState.OpenResult, 'State.OpenResult');
  CheckEquals(State.CapDisplay, AState.CapDisplay, 'State.CapDisplay');
  CheckEquals(State.CapZeroScale, AState.CapZeroScale, 'State.CapZeroScale');
  CheckEquals(State.CapTareWeight, AState.CapTareWeight, 'State.CapTareWeight');
  CheckEquals(State.CapDisplayText, AState.CapDisplayText, 'State.CapDisplayText');
  CheckEquals(State.CapStatusUpdate, AState.CapStatusUpdate, 'State.CapStatusUpdate');
  CheckEquals(State.CapPriceCalculating, AState.CapPriceCalculating,
    'State.CapPriceCalculating');
  CheckEquals(State.MaximumWeight, AState.MaximumWeight, 'State.MaximumWeight');
  CheckEquals(State.WeightUnits, AState.WeightUnits, 'State.WeightUnits');
  CheckEquals(State.AsyncMode, AState.AsyncMode, 'State.AsyncMode');
  CheckEquals(State.MaxDisplayTextChars, AState.MaxDisplayTextChars,
    'State.MaxDisplayTextChars');
  CheckEquals(State.TareWeight, AState.TareWeight, 'State.TareWeight');
  CheckEquals(State.ScaleLiveWeight, AState.ScaleLiveWeight,
    'State.ScaleLiveWeight');
  CheckEquals(State.StatusNotify, AState.StatusNotify, 'State.StatusNotify');
  CheckEquals(State.ZeroValid, AState.ZeroValid, 'State.ZeroValid');
  CheckEquals(State.SalesPrice, AState.SalesPrice, 'State.SalesPrice');
  CheckEquals(State.UnitPrice, AState.UnitPrice, 'State.UnitPrice');
end;


procedure TScaleDriverTest.WriteState(var State: TOposScaleState);
begin
  // Common
  State.State := Driver.GetPropertyNumber(PIDX_State);
  State.Claimed := Driver.GetPropertyNumber(PIDX_Claimed);
  State.AutoDisable := Driver.GetPropertyNumber(PIDX_AutoDisable);
  State.CapCompareFirmwareVersion := Driver.GetPropertyNumber(PIDX_CapCompareFirmwareVersion);
  State.CapPowerReporting := Driver.GetPropertyNumber(PIDX_CapPowerReporting);
  State.CapStatisticsReporting := Driver.GetPropertyNumber(PIDX_CapStatisticsReporting);
  State.CapUpdateFirmware := Driver.GetPropertyNumber(PIDX_CapUpdateFirmware);
  State.CapUpdateStatistics := Driver.GetPropertyNumber(PIDX_CapUpdateStatistics);
  State.DataCount := Driver.GetPropertyNumber(PIDX_DataCount);
  State.DataEventEnabled := Driver.GetPropertyNumber(PIDX_DataEventEnabled);
  State.DeviceEnabled := Driver.GetPropertyNumber(PIDX_DeviceEnabled);
  State.FreezeEvents := Driver.GetPropertyNumber(PIDX_FreezeEvents);
  State.OutputID := Driver.GetPropertyNumber(PIDX_OutputID);
  State.PowerNotify := Driver.GetPropertyNumber(PIDX_PowerNotify);
  State.PowerState := Driver.GetPropertyNumber(PIDX_PowerState);
  State.ServiceObjectVersion := Driver.GetPropertyNumber(PIDX_ServiceObjectVersion);
  State.BinaryConversion := Driver.GetPropertyNumber(PIDX_BinaryConversion);
  State.ResultCode := Driver.GetPropertyNumber(PIDX_ResultCode);
  State.ResultCodeExtended := Driver.GetPropertyNumber(PIDX_ResultCodeExtended);
  State.OpenResult := Driver.OpenResult;
  State.CheckHealthText := Driver.GetPropertyString(PIDX_CheckHealthText);
  State.ServiceObjectDescription := Driver.GetPropertyString(PIDX_ServiceObjectDescription);
  State.PhysicalDeviceDescription := Driver.GetPropertyString(PIDX_DeviceDescription);
  State.PhysicalDeviceName := Driver.GetPropertyString(PIDX_DeviceName);
  // specific
  State.CapDisplay := Driver.GetPropertyNumber(PIDXScal_CapDisplay);
  State.CapZeroScale := Driver.GetPropertyNumber(PIDXScal_CapZeroScale);
  State.CapTareWeight := Driver.GetPropertyNumber(PIDXScal_CapTareWeight);
  State.CapDisplayText := Driver.GetPropertyNumber(PIDXScal_CapDisplayText);
  State.CapStatusUpdate := Driver.GetPropertyNumber(PIDXScal_CapStatusUpdate);
  State.CapPriceCalculating := Driver.GetPropertyNumber(PIDXScal_CapPriceCalculating);
  State.MaximumWeight := Driver.GetPropertyNumber(PIDXScal_MaximumWeight);
  State.WeightUnits := Driver.GetPropertyNumber(PIDXScal_WeightUnits);
  State.AsyncMode := Driver.GetPropertyNumber(PIDXScal_AsyncMode);
  State.MaxDisplayTextChars := Driver.GetPropertyNumber(PIDXScal_MaxDisplayTextChars);
  State.TareWeight := Driver.GetPropertyNumber(PIDXScal_TareWeight);
  State.ScaleLiveWeight := Driver.GetPropertyNumber(PIDXScal_ScaleLiveWeight);
  State.StatusNotify := Driver.GetPropertyNumber(PIDXScal_StatusNotify);
  State.ZeroValid := Driver.GetPropertyNumber(PIDXScal_ZeroValid);
  State.SalesPrice := Driver.SalesPrice;
  State.UnitPrice := Driver.UnitPrice;
end;

procedure TScaleDriverTest.CheckOpenResult;
begin
  CheckEquals(OPOS_SUCCESS, Driver.OpenResult, 'Driver.OpenResult');
  // OPOS_ORS_CONFIG
  Parameters.ExceptionOnLoad := True;
  Driver.Parameters.DeleteKey(DeviceName);
  Driver.OpenService('Scale', DeviceName, nil);
  CheckEquals(OPOS_ORS_CONFIG, Driver.OpenResult, 'Driver.OpenResult');
  Driver.CloseService;
  // OPOS_SUCCESS
  Parameters.ExceptionOnLoad := False;
  Driver.Parameters.CreateKey(DeviceName);
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, nil));
  CheckEquals(OPOS_SUCCESS, Driver.OpenResult, 'Driver.OpenResult');
  CheckEquals(OPOS_E_ILLEGAL, Driver.OpenService('Scale', DeviceName, nil));
  CheckEquals(OPOS_OR_ALREADYOPEN, Driver.OpenResult, 'Driver.OpenResult');
  Driver.CloseService;
  // OPOS_ORS_NOPORT
  Driver.Parameters.CreateKey(DeviceName);
  Connection.OpenPortFailed := True;
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, nil),
    'Driver.OpenService');
  CheckEquals(OPOS_SUCCESS, Driver.OpenResult, 'Driver.OpenResult');
  Driver.CloseService;
end;

procedure TScaleDriverTest.CheckCheckHealthText;
var
  Data: string;
begin
  Device.ResultCode := 0;
  Device.Status.Flags.isOverweight := False;

  // OPOS_CH_INTERNAL
  Driver.Parameters.CreateKey(DeviceName);
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, nil));
  CheckEquals('', Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');
  CheckEquals(OPOS_SUCCESS, Driver.CheckHealth(OPOS_CH_INTERNAL),
    'Driver.CheckHealth(OPOS_CH_INTERNAL)');
  Data := 'Internal HCheck: Successful';
  CheckEquals(Data, Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');

  // Internal HCheck: Weight overflow
  Device.Status.Flags.isOverweight := True;
  CheckEquals(OPOS_SUCCESS, Driver.CheckHealth(OPOS_CH_INTERNAL),
    'Driver.CheckHealth(OPOS_CH_INTERNAL)');
  Data := 'Internal HCheck: Weight overflow';
  CheckEquals(Data, Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');


  // OPOS_CH_EXTERNAL
  CheckEquals(OPOS_SUCCESS, Driver.CloseService, 'Driver.CloseService');
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, nil));
  CheckEquals('', Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');
  CheckEquals(OPOS_E_ILLEGAL, Driver.CheckHealth(OPOS_CH_EXTERNAL),
    'Driver.CheckHealth(OPOS_CH_EXTERNAL)');
  CheckEquals('', Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');

  CheckEquals(0, UIController.ShowScaleDlgCount, 'UIController.ShowScaleDlgCount');
  CheckEquals(OPOS_SUCCESS, Driver.CloseService, 'Driver.CloseService');
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, nil));
  CheckEquals('', Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');
  CheckEquals(OPOS_SUCCESS, Driver.CheckHealth(OPOS_CH_INTERACTIVE),
    'Driver.CheckHealth(OPOS_CH_EXTERNAL)');
  CheckEquals(
    S_CHECK_HEALTH_INTERACTIVE_SUCCESS,
    Driver.GetPropertyString(PIDX_CheckHealthText),
    'Driver.GetPropertyString(PIDX_CheckHealthText)');
end;

procedure TScaleDriverTest.ClaimDevice;
begin
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
  CheckEquals(OPOS_SUCCESS, Driver.ClaimDevice(0), 'Driver.ClaimDevice(0)');
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
end;

procedure TScaleDriverTest.ReleaseDevice;
begin
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
  CheckEquals(OPOS_SUCCESS, Driver.ReleaseDevice, 'Driver.ReleaseDevice');
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
end;

procedure TScaleDriverTest.EnableDevice;
var
  ResultCode: Integer;
begin
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  ResultCode := Driver.GetPropertyNumber(PIDX_ResultCode);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'OPOS_SUCCESS');
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

procedure TScaleDriverTest.DisableDevice;
var
  ResultCode: Integer;
begin
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 0);
  ResultCode := Driver.GetPropertyNumber(PIDX_ResultCode);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'OPOS_SUCCESS');
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

procedure TScaleDriverTest.CheckClaimed;
begin
  OpenService;
  ClaimDevice;

  SaveState;
  CheckEquals(OPOS_E_CLAIMED, Driver.ClaimDevice(0), 'Driver.ClaimDevice(0)');
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
end;

procedure TScaleDriverTest.CheckDeviceEnabled;
var
  ResultCode: Integer;
begin
  OpenService;
  // OPOS_E_NOTCLAIMED
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  ResultCode := Driver.GetPropertyNumber(PIDX_ResultCode);
  CheckEquals(OPOS_E_NOTCLAIMED, ResultCode, 'OPOS_E_NOTCLAIMED');
  // Claim
  ClaimDevice;
  EnableDevice;
  EnableDevice;
  DisableDevice;
  // Release
  EnableDevice;
  ReleaseDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

procedure TScaleDriverTest.WaitForEvent;
begin
  if FWaitEvent.WaitFor(EventWaitTimeout) <> wrSignaled then
    raise Exception.Create('Wait failed');
end;

procedure TScaleDriverTest.CheckNoEvent;
begin
  if FWaitEvent.WaitFor(EventWaitTimeout) <> wrTimeOut then
    raise Exception.Create('Event fired');
end;

procedure TScaleDriverTest.CheckFreezeEvents;
var
  Event: TStatusUpdateEvent;
begin
  // FreezeEvents = 0
  OpenService;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_FreezeEvents), 'FreezeEvents');
  CheckEquals(OPOS_PS_UNKNOWN, Driver.GetPropertyNumber(PIDX_PowerState), 'OPOS_PS_UNKNOWN');
  CheckEquals(OPOS_PN_DISABLED, Driver.GetPropertyNumber(PIDX_PowerNotify),
    'OPOS_PN_DISABLED');
  Driver.SetPropertyNumber(PIDX_PowerNotify, OPOS_PN_ENABLED);
  CheckEquals(OPOS_PN_ENABLED, Driver.GetPropertyNumber(PIDX_PowerNotify),
    'OPOS_PN_ENABLED');
  ClaimDevice;
  CheckEquals(0, OposEvents.Count, 'OposEvents.Count.0');
  EnableDevice;
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count.1');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(OPOS_SUE_POWER_ONLINE, Event.Data, 'Event.Data');
  CheckEquals(OPOS_PS_ONLINE, Driver.GetPropertyNumber(PIDX_PowerState), 'OPOS_PS_ONLINE');
  OposEvents.Clear;
  DisableDevice;
  CheckEquals(0, OposEvents.Count, 'OposEvents.Count.2');
  CheckEquals(OPOS_PS_UNKNOWN, Driver.GetPropertyNumber(PIDX_PowerState), 'OPOS_PS_UNKNOWN');

  // FreezeEvents = 1
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_FreezeEvents), 'FreezeEvents');
  EnableDevice;
  CheckEquals(OPOS_PS_ONLINE, Driver.GetPropertyNumber(PIDX_PowerState), 'OPOS_PS_ONLINE');
  CheckEquals(0, OposEvents.Count, 'OposEvents.Count.3');
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 0);
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count.4');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(OPOS_SUE_POWER_ONLINE, Event.Data, 'Event.Data');
end;

procedure TScaleDriverTest.CheckResultCode;
begin
  OpenClaimEnable;
  Device.ResultCode := 152;
  CheckEquals(OPOS_E_EXTENDED, Driver.ZeroScale, 'Driver.ZeroScale');
  CheckEquals(OPOS_E_EXTENDED, Driver.GetPropertyNumber(PIDX_ResultCode),
    'ResultCode');
  CheckEquals(152 + 300, Driver.GetPropertyNumber(PIDX_ResultCodeExtended),
    'ResultCodeExtended');
end;

procedure TScaleDriverTest.CheckState;
begin
  CheckEquals(OPOS_S_CLOSED, Driver.GetPropertyNumber(PIDX_State),
    'OPOS_S_CLOSED');
  OpenService;
  CheckEquals(OPOS_S_IDLE, Driver.GetPropertyNumber(PIDX_State),
    'OPOS_S_IDLE');
  CloseService;
  CheckEquals(OPOS_S_CLOSED, Driver.GetPropertyNumber(PIDX_State),
    'OPOS_S_CLOSED');
end;

procedure TScaleDriverTest.CheckServiceObjectDescription;
begin
  CheckEquals(S_SERVICE_OBJECT_DESCRIPTION,
    Driver.GetPropertyString(PIDX_ServiceObjectDescription),
    'PIDX_ServiceObjectDescription');
end;

procedure TScaleDriverTest.CheckServiceObjectVersion;
begin
  CheckEquals(GenericServiceVersion, Driver.GetPropertyNumber(PIDX_ServiceObjectVersion),
    'PIDX_ServiceObjectVersion');
end;

procedure TScaleDriverTest.CheckDeviceDescription;
var
  DeviceDescription: string;
begin
  Device.DeviceMetrics.MajorType := 1;
  Device.DeviceMetrics.MinorType := 2;
  Device.DeviceMetrics.MajorVersion := 3;
  Device.DeviceMetrics.MinorVersion := 4;
  Device.DeviceMetrics.Model := 5;
  Device.DeviceMetrics.Language := 6;
  Device.DeviceMetrics.Name := 'Device 1';

  OpenClaimEnable;
  DeviceDescription := 'Device 1, 1.2, model: 5';
  CheckEquals(DeviceDescription, Driver.GetPropertyString(PIDX_DeviceDescription),
    'PIDX_DeviceDescription');
  CheckEquals(Device.DeviceMetrics.Name,
    Driver.GetPropertyString(PIDX_DeviceName),
    'PIDX_DeviceName');
end;

procedure TScaleDriverTest.CheckMaximumWeight;
begin
  Device.ScaleChannel.MinWeight := 30;
  Device.ScaleChannel.MaxWeight := 5000;
  OpenClaimEnable;
  CheckEquals(5000, Driver.GetPropertyNumber(PIDXScal_MaximumWeight),
    'PIDX_MaximumWeight');
end;

procedure TScaleDriverTest.CheckWeightUnits;
begin
  CheckEquals(SCAL_WU_GRAM, Driver.GetPropertyNumber(PIDXScal_WeightUnits),
    'PIDX_WeightUnits');
end;

procedure TScaleDriverTest.CheckBinaryConversion;
begin
  CheckEquals(OPOS_BC_NONE, Driver.GetPropertyNumber(PIDX_BinaryConversion),
    'PIDX_BinaryConversion');
end;

procedure TScaleDriverTest.CheckCapDisplay;
begin
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_CapDisplay),
    'PIDXScal_CapDisplay');
end;

procedure TScaleDriverTest.CheckCapPowerReporting;
begin
  CheckEquals(OPOS_PR_STANDARD,
    Driver.GetPropertyNumber(PIDX_CapPowerReporting),
    'PIDX_CapPowerReporting');
end;

procedure TScaleDriverTest.CheckPowerNotify;
var
  Event: TStatusUpdateEvent;
begin
  // PowerNotify = OPOS_PN_DISABLED (default)
  OpenService;
  CheckEquals(OPOS_PN_DISABLED, Driver.GetPropertyNumber(PIDX_PowerNotify),
    'OPOS_PN_DISABLED');
  ClaimDevice;
  EnableDevice;
  CheckNoEvent;
  // PowerNotify = OPOS_PN_ENABLED
  DisableDevice;
  Driver.SetPropertyNumber(PIDX_PowerNotify, OPOS_PN_ENABLED);
  CheckEquals(OPOS_PN_ENABLED, Driver.GetPropertyNumber(PIDX_PowerNotify),
    'OPOS_PN_ENABLED');
  EnableDevice;
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(OPOS_SUE_POWER_ONLINE, Event.Data, 'Event.Data');
end;

procedure TScaleDriverTest.CheckAsyncMode;
var
  Event: TDataEvent;
  pWeightData: Integer;
begin
  OpenService;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXScal_AsyncMode), 'AsyncMode');
  Driver.SetPropertyNumber(PIDXScal_AsyncMode, 1);
  Driver.SetPropertyNumber(PIDX_DataEventEnabled, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_AsyncMode), 'AsyncMode');
  ClaimDevice;
  EnableDevice;

  Device.Status.Weight := 67853;
  Device.Status.Flags.isWeightFixed := True;

  pWeightData := 1234;
  CheckEquals(0, Driver.ReadWeight(pWeightData, 1267), 'ReadWeight');
  CheckEquals(0, pWeightData, 'pWeightData');
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count');
  Event := OposEvents[0] as TDataEvent;
  CheckEquals(Device.Status.Weight, Event.Status, 'Event.Status');
end;

procedure TScaleDriverTest.CheckCapDisplayText;
begin
  CheckEquals(0, Driver.GetPropertyNumber(PIDXScal_CapDisplayText),
    'CapDisplayText');
end;

procedure TScaleDriverTest.CheckCapPriceCalculating;
begin
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_CapPriceCalculating),
    'CapPriceCalculating');
end;

procedure TScaleDriverTest.CheckCapTareWeight;
begin
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_CapTareWeight),
    'CapTareWeight');
end;

procedure TScaleDriverTest.CheckCapZeroScale;
begin
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_CapZeroScale),
    'CapZeroScale');
end;

procedure TScaleDriverTest.CheckMaxDisplayTextChars;
begin
  CheckEquals(0, Driver.GetPropertyNumber(PIDXScal_MaxDisplayTextChars),
    'MaxDisplayTextChars');
end;

(*

For price-calculating scales, the application should set the UnitPrice property
before calling readWeight. After a weight is read (and just before the DataEvent
is delivered to the application, for asynchronous mode), the SalesPrice property is
set to the calculated price of the item.

*)

procedure TScaleDriverTest.CheckSalesPrice;
const
  UnitPrice = 123.45;
var
  WeightData: Integer;
begin
  // CapPrice = True
  Driver.Parameters.CapPrice := True;
  SaveParameters;
  Device.Status.Weight := 67853;
  Device.Status.Flags.isWeightFixed := True;
  Device.Status2.Amount := 837645;
  OpenService;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_CapPriceCalculating),
    'CapPriceCalculating');
  CheckEquals(0, Driver.UnitPrice, CurrencyPrecision, 'Driver.UnitPrice');
  CheckEquals(0, Driver.SalesPrice, CurrencyPrecision, 'Driver.SalesPrice');
  Driver.UnitPrice := UnitPrice;
  CheckEquals(UnitPrice, Driver.UnitPrice, CurrencyPrecision, 'Driver.UnitPrice');
  ClaimDevice;
  EnableDevice;
  CheckEquals(OPOS_SUCCESS, Driver.ReadWeight(WeightData, 0), 'ReadWeight');
  CheckEquals(8376.45, Driver.SalesPrice, CurrencyPrecision, 'SalesPrice');
  CloseService;

  // CapPrice = False
  Driver.Parameters.CapPrice := False;
  SaveParameters;
  Device.Status.Weight := 67853;
  Device.Status.Flags.isWeightFixed := True;
  Device.Status2.Amount := 837645;
  OpenService;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXScal_CapPriceCalculating),
    'CapPriceCalculating');
  CheckEquals(0, Driver.UnitPrice, CurrencyPrecision, 'Driver.UnitPrice');
  CheckEquals(0, Driver.SalesPrice, CurrencyPrecision, 'Driver.SalesPrice');
  Driver.UnitPrice := UnitPrice;
  CheckEquals(UnitPrice, Driver.UnitPrice, CurrencyPrecision, 'Driver.UnitPrice');
  ClaimDevice;
  EnableDevice;
  CheckEquals(OPOS_SUCCESS, Driver.ReadWeight(WeightData, 0), 'ReadWeight');
  CheckEquals(0, Driver.SalesPrice, CurrencyPrecision, 'SalesPrice');
end;

procedure TScaleDriverTest.CheckTareWeight;
const
  TareWeight = 12345;
begin
  Device.Status2.Tare := 0;

  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXScal_TareWeight), 'TareWeight');
  Driver.SetPropertyNumber(PIDXScal_TareWeight, TareWeight);
  CheckEquals(TareWeight, Device.Status2.Tare, 'TareWeight');
end;

procedure TScaleDriverTest.CheckUnitPrice;
begin
  Parameters.CapPrice := True;
  OpenClaimEnable;
  CheckEquals(0, Driver.UnitPrice, CurrencyPrecision, 'UnitPrice');
  Driver.UnitPrice := 123.45;
  CheckEquals(123.45, Driver.UnitPrice, CurrencyPrecision, 'UnitPrice');
  CheckEquals(12345, Device.WareItem.Price, CurrencyPrecision, 'Device.WareItem.Price');
end;


procedure TScaleDriverTest.CheckClearInput;
var
  Event: TDataEvent;
  pWeightData: Integer;
begin
  OposEvents.Clear;
  Device.Status.Weight := 67853;
  Device.Status.Flags.isWeightFixed := True;
  // No ClearInput call
  OpenService;
  Driver.SetPropertyNumber(PIDX_DataEventEnabled, 1);
  Driver.SetPropertyNumber(PIDXScal_AsyncMode, 1);
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 1);
  ClaimDevice;
  EnableDevice;
  pWeightData := 1234;
  CheckEquals(0, Driver.ReadWeight(pWeightData, 1267), 'ReadWeight');
  CheckEquals(0, pWeightData, 'pWeightData');
  CheckNoEvent;
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 0);
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count');
  Event := OposEvents[0] as TDataEvent;
  CheckEquals(Device.Status.Weight, Event.Status, 'Event.Status');
  CloseService;

  // ClearInput call
  OposEvents.Clear;
  OpenService;
  Driver.SetPropertyNumber(PIDXScal_AsyncMode, 1);
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 1);
  ClaimDevice;
  EnableDevice;
  pWeightData := 1234;
  CheckEquals(0, Driver.ReadWeight(pWeightData, 1267), 'ReadWeight');
  CheckEquals(0, pWeightData, 'pWeightData');
  CheckNoEvent;
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DataCount), 'DataCount');
  CheckEquals(OPOS_SUCCESS, Driver.ClearInput, 'Driver.ClearInput');
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DataCount), 'DataCount');
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 0);
  CheckNoEvent;
  CheckEquals(0, OposEvents.Count, 'OposEvents.Count');
  CloseService;
end;

procedure TScaleDriverTest.CheckDisplayText;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_E_ILLEGAL, Driver.DisplayText('ytrytr'), 'Driver.DisplayText');
end;

(*

 A ScaleLiveWeight property containing a value to be used for updating a
 customer display with the current scale weight.

  Contains the returned value for the weight measured by the scale if the
  StatusUpdateEvent Status is set to SCAL_SUE_STABLE_WEIGHT, else zero.

  The weight has an assumed decimal place located after the “thousands” digit
  position. For example, an actual value of 12345 represents 12.345, and an actual
  value of 5 represents 0.005.

  It is suggested that an application use the weight in this property only for display
  purposes. For a weight to use for sale purposes, it is suggested that the application
  call ReadWeight
 *)

procedure TScaleDriverTest.CheckScaleLiveWeight;
var
  LiveWeight: Integer;
  Event: TStatusUpdateEvent;
const
  Weight = 12345;
begin
  Device.Status.Weight := Weight;
  Device.Status.Flags.isWeightFixed := True;
  Device.Status.Flags.isWeightStable := True;
  Device.Status.Flags.isOverweight := False;

  OpenService;
  CheckEquals(SCAL_SN_DISABLED, Driver.GetPropertyNumber(PIDXscal_StatusNotify),
    'StatusNotify');
  Driver.SetPropertyNumber(PIDXscal_StatusNotify, SCAL_SN_ENABLED);
  CheckEquals(SCAL_SN_ENABLED,  Driver.GetPropertyNumber(PIDXscal_StatusNotify),
    'StatusNotify');
  ClaimDevice;
  EnableDevice;
  WaitForEvent;

  CheckEquals(1, OposEvents.Count, 'OposEvents.Count <> 1');
  LiveWeight := Driver.GetPropertyNumber(PIDXscal_ScaleLiveWeight);
  CheckEquals(LiveWeight, Weight, 'LiveWeight');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(SCAL_SUE_STABLE_WEIGHT, Event.Data, 'SCAL_SUE_STABLE_WEIGHT');

  OposEvents.Clear;
  Device.Status.Flags.isWeightStable := False;
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count <> 1');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(SCAL_SUE_WEIGHT_UNSTABLE, Event.Data, 'SCAL_SUE_WEIGHT_UNSTABLE');

  OposEvents.Clear;
  Device.Status.Weight := 0;
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count <> 1');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(SCAL_SUE_WEIGHT_ZERO, Event.Data, 'SCAL_SUE_WEIGHT_ZERO');

  OposEvents.Clear;
  Device.Status.Weight := -1;
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count <> 1');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(SCAL_SUE_WEIGHT_UNDER_ZERO, Event.Data, 'SCAL_SUE_WEIGHT_UNDER_ZERO');

  OposEvents.Clear;
  Device.Status.Flags.isOverweight := True;
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count <> 1');
  Event := OposEvents[0] as TStatusUpdateEvent;
  CheckEquals(SCAL_SUE_WEIGHT_OVERWEIGHT, Event.Data, 'SCAL_SUE_WEIGHT_OVERWEIGHT');
end;

procedure TScaleDriverTest.CheckAutoDisable;
var
  Event: TDataEvent;
  pWeightData: Integer;
begin
  OpenService;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DataEventEnabled), 'DataEventEnabled');
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_AutoDisable), 'AutoDisable');
  Driver.SetPropertyNumber(PIDX_AutoDisable, 1);
  Driver.SetPropertyNumber(PIDX_DataEventEnabled, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_AutoDisable), 'AutoDisable');
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DataEventEnabled), 'DataEventEnabled');
  Driver.SetPropertyNumber(PIDXScal_AsyncMode, 1);
  ClaimDevice;
  EnableDevice;

  Device.Status.Weight := 67853;
  Device.Status.Flags.isWeightFixed := True;

  pWeightData := 1234;
  CheckEquals(0, Driver.ReadWeight(pWeightData, 1267), 'ReadWeight');
  CheckEquals(0, pWeightData, 'pWeightData');
  WaitForEvent;
  CheckEquals(1, OposEvents.Count, 'OposEvents.Count');
  Event := OposEvents[0] as TDataEvent;
  CheckEquals(Device.Status.Weight, Event.Status, 'Event.Status');
  // After event delivered device must be disabled
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

procedure TScaleDriverTest.CheckZeroScale;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_SUCCESS, Driver.ZeroScale, 'Driver.ZeroScale');
  Device.ResultCode := 45;
  CheckEquals(OPOS_E_EXTENDED, Driver.ZeroScale, 'Driver.ZeroScale');
  CheckEquals(345, Driver.GetPropertyNumber(PIDX_ResultCodeExtended),
    'ResultCodeExtended');
end;

procedure TScaleDriverTest.CheckDirectIO;
begin
  OpenClaimEnable;
  CheckCommandHex;
  CheckCommandStr;
  CheckDIOGetDriverParameter;
end;

procedure TScaleDriverTest.CheckCommandStr;
var
  pData: Integer;
  pString: WideString;
  ResultCode: Integer;
const
  TxDataStr = '01;05';
  TxDataHex = '07 01 00 00 00 05';
  RxDataHex = '05';
begin
  Device.ResultCode := 0;
  Device.RxData := HexToStr(RxDataHex);
  pData := 7;
  pString := TxDataStr;
  ResultCode := Driver.DirectIO(DIO_COMMAND_STR, pData, pString);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'DirectIO');
  CheckEquals(TxDataHex, StrToHex(Device.TxData), 'TxDataHex');
  CheckEquals('5', pString, 'pString');
end;

procedure TScaleDriverTest.CheckCommandHex;
var
  pData: Integer;
  pString: WideString;
  ResultCode: Integer;
const
  TxDataHex = '11 34';
  RxDataHex = '12 67';
begin
  Device.ResultCode := 0;
  Device.RxData := HexToStr(RxDataHex);
  pString := TxDataHex;
  ResultCode := Driver.DirectIO(DIO_COMMAND_HEX, pData, pString);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'DirectIO');
  CheckEquals(StrToHex(Device.TxData), TxDataHex, 'TxDataHex');
  CheckEquals(RxDataHex, StrToHex(Device.RxData), 'RxDataHex');
end;

procedure TScaleDriverTest.CheckDIOGetDriverParameter;
var
  P: TScaleParameters;
begin
  P := Driver.Device.Parameters;
  CheckParam(ParamCCOType, IntToStr(P.CCOType), 'CCOType');
  CheckParam(ParamPassword, IntToStr(P.Password), 'Password');
  CheckParam(ParamEncoding, IntToStr(P.Encoding), 'Encoding');
  CheckParam(ParamPortNumber, IntToStr(P.PortNumber), 'PortNumber');
  CheckParam(ParamBaudRate, IntToStr(P.BaudRate), 'BaudRate');
  CheckParam(ParamByteTimeout, IntToStr(P.ByteTimeout), 'ByteTimeout');
  CheckParam(ParamCommandTimeout, IntToStr(P.CommandTimeout), 'CommandTimeout');
  CheckParam(ParamMaxRetryCount, IntToStr(P.MaxRetryCount), 'MaxRetryCount');
  CheckParam(ParamSearchByPortEnabled, StringUtils.BoolToStr(P.SearchByPortEnabled), 'SearchByPortEnabled');
  CheckParam(ParamSearchByBaudRateEnabled, StringUtils.BoolToStr(P.SearchByBaudRateEnabled), 'SearchByBaudRateEnabled');
  CheckParam(ParamLogFileEnabled, StringUtils.BoolToStr(P.LogFileEnabled), 'LogFileEnabled');
  CheckParam(ParamLogMaxCount, IntToStr(P.LogMaxCount), 'LogMaxCount');
  CheckParam(ParamCapPrice, StringUtils.BoolToStr(P.CapPrice), 'CapPrice');
  CheckParam(ParamPollPeriod, IntToStr(P.PollPeriod), 'PollPeriod');
end;

procedure TScaleDriverTest.CheckParam(ParamID: Integer;
  const ParamValue, ParamName: string);
var
  pData: Integer;
  pString: WideString;
  ResultCode: Integer;
begin
  pData := ParamID;
  ResultCode := Driver.DirectIO(DIO_GET_DRIVER_PARAMETER, pData, pString);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'DirectIO');
  CheckEquals(ParamValue, pString, ParamName);
end;


procedure TScaleDriverTest.CheckReadWeight;
var
  pWeightData: Integer;
begin
  OpenClaimEnable;
  Device.Status.Weight := 67853;
  Device.Status.Flags.isWeightFixed := True;
  Device.Status.Flags.isWeightStable := True;

  pWeightData := 0;
  CheckEquals(OPOS_SUCCESS, Driver.ReadWeight(pWeightData, 0), 'ReadWeight');
  CheckEquals(67853, pWeightData, 'pWeightData');
end;

procedure TScaleDriverTest.CheckZeroValid;
var
  pWeightData: Integer;
begin
  OpenClaimEnable;
  Device.Status.Weight := 0;
  Device.Status.Flags.isWeightFixed := True;
  Device.Status.Flags.isWeightStable := True;
  // ZeroValid = 1
  CheckEquals(1, Driver.GetPropertyNumber(PIDXScal_ZeroValid), 'ZeroValid');
  CheckEquals(OPOS_SUCCESS, Driver.ReadWeight(pWeightData, 0), 'ReadWeight');
  CheckEquals(0, pWeightData, 'pWeightData');
  // ZeroValid = 0
  Driver.SetPropertyNumber(PIDXScal_ZeroValid, 0);
  CheckEquals(0, Driver.GetPropertyNumber(PIDXScal_ZeroValid), 'ZeroValid');
  CheckEquals(OPOS_E_TIMEOUT, Driver.ReadWeight(pWeightData, 0), 'ReadWeight');
end;

procedure TScaleDriverTest.CheckReleaseDevice;
begin
  { !!! }
end;

procedure TScaleDriverTest.CheckClose;
begin
  { !!! }
end;

procedure TScaleDriverTest.CheckOpen;
begin
  { !!! }
end;

procedure TScaleDriverTest.CheckCommandXml;
begin
  { !!! }
end;


procedure TScaleDriverTest.CheckResetStatistics;
var
  Buffer: WideString;
const
  SrcFileName1 = 'SrcScaleStatistics1.txt';
  SrcFileName2 = 'SrcScaleStatistics2.txt';
  DstFileName1 = 'DstScaleStatistics1.txt';
  DstFileName2 = 'DstScaleStatistics2.txt';
begin
  Device.DeviceMetrics.MajorType := 1;
  Device.DeviceMetrics.MinorType := 2;
  Device.DeviceMetrics.MajorVersion := 3;
  Device.DeviceMetrics.MinorVersion := 4;
  Device.DeviceMetrics.Name := '82374682734687';
  OpenClaimEnable;

  Statistics.WeightReaded;
  Statistics.ReportHoursPowered(10);
  Statistics.CommunicationError;
  Statistics.CommunicationError;
  Buffer := '';
  CheckEquals(OPOS_SUCCESS, Driver.RetrieveStatistics(Buffer), 'RetrieveStatistics');
  DeleteFile(DstFileName2);
  WriteFileData(DstFileName2, Buffer);
  CheckEquals(ReadFileData(SrcFileName2), Buffer, 'Buffer');

  Buffer := '';
  CheckEquals(OPOS_SUCCESS, Driver.ResetStatistics(Buffer), 'ResetStatistics');
  Buffer := '';
  CheckEquals(OPOS_SUCCESS, Driver.RetrieveStatistics(Buffer), 'RetrieveStatistics');
  DeleteFile(DstFileName1);
  WriteFileData(DstFileName1, Buffer);
  CheckEquals(ReadFileData(SrcFileName1), Buffer, 'Buffer');
  DeleteFile(DstFileName1);
end;

(*

This is a comma-separated list of name-value pair(s), where an empty string name
(““”=value1”) means ALL resettable statistics are to be set to the value “value1”,
“U_=value2” means all UnifiedPOS defined resettable statistics are to be set to the
value “value2”, “M_=value3” means all manufacturer defined resettable statistics
are to be set to the value “value3”, and “actual_name1=value4,
actual_name2=value5” (from the XML file definitions) means that the specifically
defined resettable statistic(s) are to be set to the specified value(s).

*)

procedure TScaleDriverTest.CheckUpdateStatistics;
var
  Buffer: WideString;
const
  SrcFileName4 = 'SrcScaleStatistics4.txt';
  SrcFileName5 = 'SrcScaleStatistics5.txt';
  SrcFileName6 = 'SrcScaleStatistics6.txt';
  DstFileName4 = 'DstScaleStatistics4.txt';
  DstFileName5 = 'DstScaleStatistics5.txt';
  DstFileName6 = 'DstScaleStatistics6.txt';
begin
  Device.DeviceMetrics.MajorType := 1;
  Device.DeviceMetrics.MinorType := 2;
  Device.DeviceMetrics.MajorVersion := 3;
  Device.DeviceMetrics.MinorVersion := 4;
  Device.DeviceMetrics.Name := '82374682734687';
  OpenClaimEnable;

  // All
  Buffer := '""=123';
  CheckEquals(OPOS_SUCCESS, Driver.UpdateStatistics(Buffer), 'UpdateStatistics');
  Buffer := '';
  CheckEquals(OPOS_SUCCESS, Driver.RetrieveStatistics(Buffer), 'RetrieveStatistics');
  WriteFileData(DstFileName4, Buffer);
  CheckEquals(ReadFileData(SrcFileName4), Buffer, 'Buffer');
  DeleteFile(DstFileName4);
  // Upos
  Buffer := 'U_=234';
  CheckEquals(OPOS_SUCCESS, Driver.UpdateStatistics(Buffer), 'UpdateStatistics');
  Buffer := '';
  CheckEquals(OPOS_SUCCESS, Driver.RetrieveStatistics(Buffer), 'RetrieveStatistics');
  WriteFileData(DstFileName5, Buffer);
  CheckEquals(ReadFileData(SrcFileName5), Buffer, 'Buffer');
  DeleteFile(DstFileName5);
  // Selected
  Buffer := 'HoursPoweredCount=1,CommunicationErrorCount=2';
  CheckEquals(OPOS_SUCCESS, Driver.UpdateStatistics(Buffer), 'UpdateStatistics');
  Buffer := '';
  CheckEquals(OPOS_SUCCESS, Driver.RetrieveStatistics(Buffer), 'RetrieveStatistics');
  WriteFileData(DstFileName6, Buffer);
  CheckEquals(ReadFileData(SrcFileName6), Buffer, 'Buffer');
  DeleteFile(DstFileName6);
end;

procedure TScaleDriverTest.CheckRetrieveStatistics;
begin

end;


initialization
  RegisterTest('', TScaleDriverTest.Suite);

end.
