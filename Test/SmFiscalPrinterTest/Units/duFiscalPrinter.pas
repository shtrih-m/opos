unit duFiscalPrinter;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ActiveX,
  // DUnit
  TestFramework,
  // Opos
  Opos, Oposhi, OposFptr, OposFptrHi,
  // This
  FiscalPrinterImpl, oleFiscalPrinter, CommandDef,
  OposFptrUtils, OPOSException, PrinterTypes, DirectIOAPI,
  TextFiscalPrinterDevice, MockSharedPrinter, SharedPrinterInterface,
  FiscalPrinterTypes, DriverTypes, PrinterParameters, PrinterParametersX,
  SharedPrinter, LogFile, StringUtils, MockPrinterConnection, DefaultModel,
  MalinaParams;

type
  { TFiscalPrinterTest }

  TFiscalPrinterTest = class(TTestCase)
  private
    FDriver: ToleFiscalPrinter;
    FPrinter: TFiscalPrinterImpl;
    FDevice: TTextFiscalPrinterDevice;
    FConnection: TMockPrinterConnection;

    procedure EmptyTest;
    procedure ClaimDevice;
    procedure OpenClaimEnable;
    procedure SetTestParameters;
    procedure CheckResult(ResultCode: Integer);

    function GetParameters: TPrinterParameters;
    property Parameters: TPrinterParameters read GetParameters;
  protected
    procedure Setup; override;
    procedure TearDown; override;

    procedure CheckCapJrnEmptySensor; // !!
    procedure CheckFiscalReceipt1;
  published
    procedure OpenDevice;
    // common properties
    procedure CheckCapCompareFirmwareVersion;
    procedure CheckCapPowerReporting;
    procedure CheckCapStatisticsReporting;
    procedure CheckCapUpdateFirmware;
    procedure CheckCapUpdateStatistics;
    procedure CheckCheckHealthText;
    procedure CheckClaimed;
    procedure CheckDataCount;
    procedure CheckDataEventEnabled;
    procedure CheckDeviceEnabled;
    procedure CheckFreezeEvents;
    procedure CheckOutputID;
    procedure CheckPowerNotify;
    procedure CheckPowerState;
    procedure CheckState;
    procedure CheckServiceObjectDescription;
    procedure CheckServiceObjectVersion;
    procedure CheckDeviceDescription;
    procedure CheckDeviceName;
    // common methods
    procedure CheckOpen;
    procedure CheckClose;
    procedure CheckClaim;
    procedure CheckRelease;
    procedure CheckCheckHealth;
    procedure CheckClearInput;
    procedure CheckClearInputProperties;
    procedure CheckClearOutput;
    procedure CheckDirectIO;
    procedure CheckCompareFirmwareVersion;
    procedure CheckResetStatistics;
    procedure CheckRetrieveStatistics;
    procedure CheckUpdateFirmware;
    procedure CheckUpdateStatistics;
    // specific properties
    procedure CheckAmountDecimalPlaces;
    procedure CheckAsyncMode;
    procedure CheckCheckTotal;
    procedure CheckCountryCode;
    procedure CheckCoverOpen;
    procedure CheckDayOpened;
    procedure CheckDescriptionLength;
    procedure CheckDuplicateReceipt;
    procedure CheckErrorLevel;
    procedure CheckErrorOutID;
    procedure CheckErrorState;
    procedure CheckErrorStation;
    procedure CheckFlagWhenIdle;
    procedure CheckJrnEmpty;
    procedure CheckJrnNearEnd;
    procedure CheckMessageLength;
    procedure CheckNumHeaderLines;
    procedure CheckNumTrailerLines;
    procedure CheckNumVatRates;
    procedure CheckPrinterState;
    procedure CheckQuantityDecimalPlaces;
    procedure CheckQuantityLength;
    procedure CheckRecEmpty;
    procedure CheckRemainingFiscalMemory;
    procedure CheckSlpEmpty;
    procedure CheckSlpNearEnd;
    procedure CheckSlipSelection;
    procedure CheckTrainingModeActive;
    procedure CheckActualCurrency;
    procedure CheckContractorId;
    procedure CheckDateType;
    procedure CheckFiscalReceiptStation;
    procedure CheckFiscalReceiptType;
    procedure CheckMessageType;
    procedure CheckTotalizerType;
    procedure CheckCapAdditionalLines;
    procedure CheckCapAmountAdjustment;
    procedure CheckCapAmountNotPaid;
    procedure CheckCapCheckTotal;
    procedure CheckCapCoverSensor;
    procedure CheckCapDoubleWidth;
    procedure CheckCapDuplicateReceipt;
    procedure CheckCapFixedOutput;
    procedure CheckCapHasVatTable;
    procedure CheckCapIndependentHeader;
    procedure CheckCapItemList;
    procedure CheckCapJrnNearEndSensor;
    procedure CheckCapJrnPresent;
    procedure CheckCapNonFiscalMode;
    procedure CheckCapOrderAdjustmentFirst;
    procedure CheckCapPercentAdjustment;
    procedure CheckCapPositiveAdjustment;
    procedure CheckCapPowerLossReport;
    procedure CheckCapPredefinedPaymentLines;
    procedure CheckCapReceiptNotPaid;
    procedure CheckCapRecEmptySensor;
    procedure CheckCapRecNearEndSensor;
    procedure CheckCapRecPresent;
    procedure CheckCapRemainingFiscalMemory;
    procedure CheckCapReservedWord;
    procedure CheckCapSetHeader;
    procedure CheckCapSetPOSID;
    procedure CheckCapSetStoreFiscalID;
    procedure CheckCapSetTrailer;
    procedure CheckCapSetVatTable;
    procedure CheckCapSlpEmptySensor;
    procedure CheckCapSlpFiscalDocument;
    procedure CheckCapSlpFullSlip;
    procedure CheckCapSlpNearEndSensor;
    procedure CheckCapSlpPresent;
    procedure CheckCapSlpValidation;
    procedure CheckCapSubAmountAdjustment;
    procedure CheckCapSubPercentAdjustment;
    procedure CheckCapSubtotal;
    procedure CheckCapTrainingMode;
    procedure CheckCapValidateJournal;
    procedure CheckCapXReport;
    procedure CheckCapAdditionalHeader;
    procedure CheckCapAdditionalTrailer;
    procedure CheckCapChangeDue;
    procedure CheckCapEmptyReceiptIsVoidable;
    procedure CheckCapFiscalReceiptStation;
    procedure CheckCapFiscalReceiptType;
    procedure CheckCapMultiContractor;
    procedure CheckCapOnlyVoidLastItem;
    procedure CheckCapPackageAdjustment;
    procedure CheckCapPostPreLine;
    procedure CheckCapSetCurrency;
    procedure CheckCapTotalizerType;
    procedure CheckCapPositiveSubtotalAdjustment;
    procedure CheckErrorString;
    procedure CheckPredefinedPaymentLines;
    procedure CheckReservedWord;
    procedure CheckAdditionalHeader;
    procedure CheckAdditionalTrailer;
    procedure CheckChangeDue;
    procedure CheckPostLine;
    procedure CheckPreLine;
    // specific methods
    procedure CheckBeginFiscalDocument;
    procedure CheckBeginFiscalReceipt;
    procedure CheckBeginFixedOutput;
    procedure CheckBeginInsertion;
    procedure CheckBeginItemList;
    procedure CheckBeginNonFiscal;
    procedure CheckBeginRemoval;
    procedure CheckBeginTraining;
    procedure CheckClearError;
    procedure CheckEndFiscalDocument;
    procedure CheckEndFiscalReceipt;
    procedure CheckEndFiscalReceipt2;
    procedure CheckEndFiscalReceipt3;

    procedure CheckEndFixedOutput;
    procedure CheckEndInsertion;
    procedure CheckEndItemList;
    procedure CheckEndNonFiscal;
    procedure CheckEndNonFiscal2;
    procedure CheckEndRemoval;
    procedure CheckEndTraining;
    procedure CheckGetData;
    procedure CheckGetDate;
    procedure CheckGetTotalizer;
    procedure CheckGetVatEntry;
    procedure CheckPrintDuplicateReceipt;
    procedure CheckPrintFiscalDocumentLine;
    procedure CheckPrintFixedOutput;
    procedure CheckPrintNormal;
    procedure CheckPrintPeriodicTotalsReport;
    procedure CheckPrintPowerLossReport;
    procedure CheckPrintRecItem;
    procedure CheckPrintRecItemAdjustment;
    procedure CheckPrintRecMessage;
    procedure CheckPrintRecNotPaid;
    procedure CheckPrintRecRefund;
    procedure CheckPrintRecSubtotal;
    procedure CheckPrintRecSubtotalAdjustment;
    procedure CheckPrintRecTotal;
    procedure CheckPrintRecVoid;
    procedure CheckPrintRecVoidItem;
    procedure CheckPrintReport;
    procedure CheckPrintXReport;
    procedure CheckPrintZReport;
    procedure CheckResetPrinter;
    procedure CheckSetDate;
    procedure CheckSetHeaderLine;
    procedure CheckSetPOSID;
    procedure CheckSetStoreFiscalID;
    procedure CheckSetTrailerLine;
    procedure CheckSetVatTable;
    procedure CheckSetVatValue;
    procedure CheckVerifyItem;
    procedure CheckPrintRecCash;
    procedure CheckPrintRecItemFuel;
    procedure CheckPrintRecItemFuelVoid;
    procedure CheckPrintRecPackageAdjustment;
    procedure CheckPrintRecPackageAdjustVoid;
    procedure CheckPrintRecRefundVoid;
    procedure CheckPrintRecSubtotalAdjustVoid;
    procedure CheckPrintRecTaxID;
    procedure CheckSetCurrency;
    procedure CheckGetOpenResult;
    procedure CheckPrintRecItemAdjustmentVoid;
    procedure CheckPrintRecItemVoid;

    procedure CheckStornoReceipt;
    procedure CheckRecNearEnd;
    procedure SaveTestDevice;
    procedure TestEncoding;

    procedure CheckNonFiscal;


    property Driver: ToleFiscalPrinter read FDriver;
    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: TTextFiscalPrinterDevice read FDevice;
  end;

implementation

const
  DeviceName = 'TestDeviceName';

{ TFiscalPrinterTest }

procedure TFiscalPrinterTest.Setup;
var
  Model: TPrinterModelRec;
  SPrinter: ISharedPrinter;
begin
  inherited Setup;
  CoInitialize(nil);

  LoadParametersEnabled := False;
  CommandDefsLoadEnabled := False;

  FDevice := TTextFiscalPrinterDevice.Create;
  FDevice.FCapFiscalStorage := True;
  Model := PrinterModelDefault;
  Model.NumHeaderLines := 0;
  Model.NumTrailerLines := 0;
  FDevice.Model := Model;

  FConnection := TMockPrinterConnection.Create;
  SPrinter := SharedPrinter.GetPrinter(DeviceName);
  SPrinter.Device := FDevice;
  SPrinter.Connection := FConnection;

  FPrinter := TFiscalPrinterImpl.Create(nil);
  FPrinter.SetPrinter(SPrinter);
  FDriver := ToleFiscalPrinter.Create(FPrinter);

  Parameters.SetDefaults;
  Parameters.NumHeaderLines := 0;
  Parameters.NumTrailerLines := 0;
  Parameters.LogFileEnabled := False;
  Parameters.PropertyUpdateMode := PropertyUpdateModeNone;
  Parameters.Header := '';
  Parameters.Trailer := '';
end;

procedure TFiscalPrinterTest.TearDown;
begin
  FDriver.Free;
  inherited TearDown;
end;

function TFiscalPrinterTest.GetParameters: TPrinterParameters;
begin
  Result := FPrinter.Parameters;
end;


procedure TFiscalPrinterTest.EmptyTest;
begin

end;

procedure TFiscalPrinterTest.OpenDevice;
begin
  CheckResult(Driver.Open('FiscalPrinter', DeviceName, nil));
end;

procedure TFiscalPrinterTest.ClaimDevice;
begin
  CheckResult(Driver.Claim(0));
end;

procedure TFiscalPrinterTest.OpenClaimEnable;
var
  Flags: TPrinterFlags;
begin
  Flags.JrnNearEnd := False;
  Flags.RecNearEnd := False;
  Flags.SlpUpSensor := False;
  Flags.SlpLoSensor := False;
  Flags.DecimalPosition := True;
  Flags.EJPresent := True;
  Flags.JrnEmpty := False;
  Flags.RecEmpty := False;
  Flags.JrnLeverUp := False;
  Flags.RecLeverUp := False;
  Flags.CoverOpened := False;
  Flags.DrawerOpened := False;
  Flags.EJNearEnd := False;
  //Driver.Device.Status.Flags := Flags; { !!! }


  OpenDevice;
  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
end;

procedure TFiscalPrinterTest.CheckResult(ResultCode: Integer);
var
  Text: string;
  ResultCodeExtended: Integer;
begin
  if ResultCode = OPOS_E_EXTENDED then
  begin
    ResultCodeExtended := Driver.GetPropertyNumber(PIDX_ResultCodeExtended);
    Text := 'OPOS_E_EXTENDED, ' + GetResultCodeExtendedText(ResultCodeExtended);
   Check(False, Text);
  end else
  begin
    CheckEquals(0, ResultCode, EOPOSException.GetResultCodeText(ResultCode));
  end;
end;

procedure TFiscalPrinterTest.CheckClaimed;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.Claim(0));
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.ReleaseDevice);
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.Claim(0));
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.Release1);
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed));
end;

// Syntax CapCompareFirmwareVersion: boolean { read-only, access after open }

procedure TFiscalPrinterTest.CheckCapCompareFirmwareVersion;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_CapCompareFirmwareVersion),
   'CapCompareFirmwareVersion');
end;

// CapPowerReporting Property { read-only, access after open }

procedure TFiscalPrinterTest.CheckCapPowerReporting;
begin
  OpenDevice;
  CheckEquals(OPOS_PR_STANDARD, Driver.GetPropertyNumber(PIDX_CapPowerReporting),
    'CapPowerReporting <> OPOS_PR_STANDARD');
end;

// CapStatisticsReporting { read-only, access after open }

procedure TFiscalPrinterTest.CheckCapStatisticsReporting;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_CapStatisticsReporting),
    'CapStatisticsReporting <> 1');
end;

// CapUpdateFirmware

procedure TFiscalPrinterTest.CheckCapUpdateFirmware;
begin
  OpenDevice;
 CheckEquals(0, Driver.GetPropertyNumber(PIDX_CapUpdateFirmware),
   'CapUpdateFirmware');
end;

// CapUpdateStatistics

procedure TFiscalPrinterTest.CheckCapUpdateStatistics;
begin
  OpenDevice;
 CheckEquals(1, Driver.GetPropertyNumber(PIDX_CapUpdateStatistics),
   'CapUpdateStatistics');
end;

procedure TFiscalPrinterTest.CheckCheckHealthText;
begin
  OpenDevice;
 CheckEquals('', Driver.GetPropertyString(PIDX_CheckHealthText),
   'CheckHealthText');
end;

procedure TFiscalPrinterTest.CheckDataCount;
begin
  OpenDevice;
 CheckEquals(0, Driver.GetPropertyNumber(PIDX_DataCount), 'DataCount');
end;

procedure TFiscalPrinterTest.CheckDataEventEnabled;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DataEventEnabled), 'DataEventEnabled');
  Driver.SetPropertyNumber(PIDX_DataEventEnabled, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DataEventEnabled), 'DataEventEnabled');
  Driver.SetPropertyNumber(PIDX_DataEventEnabled, 0);
 CheckEquals(0, Driver.GetPropertyNumber(PIDX_DataEventEnabled), 'DataEventEnabled');
end;

procedure TFiscalPrinterTest.CheckDeviceEnabled;
begin
  OpenDevice;
  ClaimDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 0);
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

// ServiceObjectDescription

procedure TFiscalPrinterTest.CheckServiceObjectDescription;
begin
  OpenDevice;
  CheckEquals(
    'OPOS Fiscal Printer Service. SHTRIH-M, 2019',
    Driver.GetPropertyString(PIDX_ServiceObjectDescription));
end;

procedure TFiscalPrinterTest.CheckServiceObjectVersion;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckFreezeEvents;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_FreezeEvents), 'FreezeEvents');
  Driver.SetPropertyNumber(PIDX_FreezeEvents, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_FreezeEvents), 'FreezeEvents');
end;

procedure TFiscalPrinterTest.CheckOutputID;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_OutputID), 'OutputID');
end;

procedure TFiscalPrinterTest.CheckDeviceDescription;
begin
  OpenDevice;
  CheckEquals('SHTRIH-M Fiscal Printer', Driver.GetPropertyString(PIDX_DeviceDescription));
end;

procedure TFiscalPrinterTest.CheckDeviceName;
var
  DeviceMetrics: TDeviceMetrics;
  LongStatus: TLongPrinterStatus;
begin
  LongStatus.SerialNumber := '12345';
  DeviceMetrics.DeviceName := 'PRINTER1';

  Device.LongStatus := LongStatus;
  Device.DeviceMetrics := DeviceMetrics;

  OpenClaimEnable;
  CheckEquals('PRINTER1, № 12345', Driver.GetPropertyString(PIDX_DeviceName));
end;

procedure TFiscalPrinterTest.CheckPowerNotify;
begin
  OpenDevice;
  CheckEquals(OPOS_PN_DISABLED, Driver.GetPropertyNumber(PIDX_PowerNotify),
    'PowerNotify');
  Driver.SetPropertyNumber(PIDX_PowerNotify, OPOS_PN_ENABLED);
  CheckEquals(OPOS_PN_ENABLED, Driver.GetPropertyNumber(PIDX_PowerNotify),
    'PowerNotify');
end;

procedure TFiscalPrinterTest.CheckPowerState;
begin
  OpenDevice;
  CheckEquals(OPOS_PS_UNKNOWN, Driver.GetPropertyNumber(PIDX_PowerState), 'PowerState');
  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  //Check(Driver.GetPropertyNumber(PIDX_PowerState) = OPOS_PS_ONLINE); { !!! }
end;

procedure TFiscalPrinterTest.CheckState;
begin
  OpenDevice;
  CheckEquals(OPOS_S_IDLE, Driver.GetPropertyNumber(PIDX_State), 'State');
end;

procedure TFiscalPrinterTest.CheckActualCurrency;
begin
  OpenDevice;
  CheckEquals(FPTR_AC_RUR, Driver.GetPropertyNumber(PIDXFptr_ActualCurrency),
    'ActualCurrency');
end;

procedure TFiscalPrinterTest.CheckAdditionalHeader;
const
  AdditionalHeaderValue = 'ahsgdfhagdsf';
begin
  OpenDevice;
  CheckEquals('', Driver.GetPropertyString(PIDXFptr_AdditionalHeader),
    'AdditionalHeader');
  Driver.SetPropertyString(PIDXFptr_AdditionalHeader, AdditionalHeaderValue);
  CheckEquals(AdditionalHeaderValue, Driver.GetPropertyString(PIDXFptr_AdditionalHeader),
    'AdditionalHeaderValue');
  Driver.SetPropertyString(PIDXFptr_AdditionalHeader, '');
  CheckEquals('', Driver.GetPropertyString(PIDXFptr_AdditionalHeader),
    'AdditionalHeader');
end;

procedure TFiscalPrinterTest.CheckAdditionalTrailer;
const
  AdditionalTrailerValue = 'ahsgdfhagdsf';
begin
  OpenDevice;
  CheckEquals('', Driver.GetPropertyString(PIDXFptr_AdditionalTrailer),
    'AdditionalTrailer');
  Driver.SetPropertyString(PIDXFptr_AdditionalTrailer, AdditionalTrailerValue);
  CheckEquals(AdditionalTrailerValue, Driver.GetPropertyString(PIDXFptr_AdditionalTrailer),
    'AdditionalTrailer');
  Driver.SetPropertyString(PIDXFptr_AdditionalTrailer, '');
  CheckEquals('', Driver.GetPropertyString(PIDXFptr_AdditionalTrailer),
    'AdditionalTrailer');
end;

procedure TFiscalPrinterTest.CheckAmountDecimalPlaces;
begin
  OpenDevice;
  CheckEquals(2, Driver.GetPropertyNumber(PIDXFptr_AmountDecimalPlaces),
    'AmountDecimalPlaces');
end;

procedure TFiscalPrinterTest.CheckAsyncMode;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_AsyncMode), 'AsyncMode');
  Driver.SetPropertyNumber(PIDXFptr_AsyncMode, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_AsyncMode), 'AsyncMode');
  Driver.SetPropertyNumber(PIDXFptr_AsyncMode, 0);
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_AsyncMode), 'AsyncMode');
end;

procedure TFiscalPrinterTest.CheckBeginFiscalDocument;
begin
  OpenClaimEnable;
  CheckResult(Driver.BeginFiscalDocument(0));
end;

procedure TFiscalPrinterTest.CheckBeginFiscalReceipt;
begin
  OpenClaimEnable;
  CheckResult(Driver.BeginFiscalReceipt(True));
end;

procedure TFiscalPrinterTest.CheckBeginFixedOutput;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_E_ILLEGAL, Driver.BeginFixedOutput(0,0), 'BeginFixedOutput');
end;

procedure TFiscalPrinterTest.CheckBeginInsertion;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_E_ILLEGAL, Driver.BeginInsertion(0), 'BeginInsertion');
end;

procedure TFiscalPrinterTest.CheckBeginItemList;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_E_ILLEGAL, Driver.BeginItemList(0), 'BeginItemList');
end;

procedure TFiscalPrinterTest.CheckBeginNonFiscal;
begin
  OpenClaimEnable;
  CheckResult(Driver.BeginNonFiscal);
end;

procedure TFiscalPrinterTest.CheckBeginRemoval;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_E_ILLEGAL, Driver.BeginRemoval(0), 'BeginRemoval');
end;

procedure TFiscalPrinterTest.CheckBeginTraining;
begin
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_TrainingModeActive),
    'TrainingModeActive');
  CheckResult(Driver.BeginTraining);
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_TrainingModeActive),
    'TrainingModeActive');
end;

procedure TFiscalPrinterTest.CheckCapAdditionalHeader;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapAdditionalHeader),
    'CapAdditionalHeader');
end;

procedure TFiscalPrinterTest.CheckCapAdditionalLines;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapAdditionalLines),
    'CapAdditionalLines');
end;

procedure TFiscalPrinterTest.CheckCapAdditionalTrailer;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapAdditionalTrailer),
    'CapAdditionalTrailer');
end;

procedure TFiscalPrinterTest.CheckCapAmountAdjustment;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapAmountAdjustment),
    'CapAmountAdjustment');
end;

procedure TFiscalPrinterTest.CheckCapAmountNotPaid;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapAmountNotPaid),
    'CapAmountNotPaid');
end;

procedure TFiscalPrinterTest.CheckCapChangeDue;
begin
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapChangeDue),
    'CapChangeDue');
end;

procedure TFiscalPrinterTest.CheckCapCheckTotal;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapCheckTotal),
    'CapCheckTotal');
end;

procedure TFiscalPrinterTest.CheckCapCoverSensor;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapCoverSensor),
    'CapCoverSensor');
end;

procedure TFiscalPrinterTest.CheckCapDoubleWidth;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapDoubleWidth),
    'CapDoubleWidth');
end;

procedure TFiscalPrinterTest.CheckCapDuplicateReceipt;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapDuplicateReceipt),
    'CapDuplicateReceipt');
end;

procedure TFiscalPrinterTest.CheckCapEmptyReceiptIsVoidable;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapEmptyReceiptIsVoidable),
    'CapEmptyReceiptIsVoidable');
end;

procedure TFiscalPrinterTest.CheckCapFiscalReceiptStation;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapFiscalReceiptStation),
    'CapFiscalReceiptStation');
end;

procedure TFiscalPrinterTest.CheckCapFiscalReceiptType;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapFiscalReceiptType),
    'CapFiscalReceiptType');
end;

procedure TFiscalPrinterTest.CheckCapFixedOutput;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapFixedOutput),
    'CapFixedOutput');
end;

procedure TFiscalPrinterTest.CheckCapHasVatTable;
begin
  OpenDevice;
 CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapHasVatTable),
   'CapHasVatTable');
end;

procedure TFiscalPrinterTest.CheckCapIndependentHeader;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapIndependentHeader),
    'CapIndependentHeader');
end;

procedure TFiscalPrinterTest.CheckCapItemList;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapItemList),
    'CapItemList');
end;

procedure TFiscalPrinterTest.CheckCapJrnEmptySensor;
var
  Model: TPrinterModelRec;
begin
  // False
  Model.CapJrnEmptySensor := False;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapJrnEmptySensor),
    'CapJrnEmptySensor');
  Driver.Close;
  // True
  Model.CapJrnEmptySensor := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapJrnEmptySensor),
    'CapJrnEmptySensor');
end;

procedure TFiscalPrinterTest.CheckCapJrnNearEndSensor;
var
  Model: TPrinterModelRec;
begin
  // False
  Model.CapJrnNearEndSensor := False;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapJrnNearEndSensor),
   'CapJrnNearEndSensor');
  Driver.Close;
  // True
  Model.CapJrnNearEndSensor := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapJrnNearEndSensor),
    'CapJrnNearEndSensor');
end;

procedure TFiscalPrinterTest.CheckCapJrnPresent;
var
  Model: TPrinterModelRec;
begin
  // False
  Model.CapJrnPresent := False;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapJrnPresent), 'CapJrnPresent');
  Driver.Close;
  // True
  Model.CapJrnPresent := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapJrnPresent), 'CapJrnPresent');
end;

procedure TFiscalPrinterTest.CheckCapMultiContractor;
begin
  OpenDevice;
 CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapMultiContractor),
   'CapMultiContractor');
end;

procedure TFiscalPrinterTest.CheckCapNonFiscalMode;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapNonFiscalMode),
    'CapNonFiscalMode');
end;

procedure TFiscalPrinterTest.CheckCapOnlyVoidLastItem;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapOnlyVoidLastItem),
    'CapOnlyVoidLastItem');
end;

procedure TFiscalPrinterTest.CheckCapOrderAdjustmentFirst;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapOrderAdjustmentFirst),
    'CapOrderAdjustmentFirst');
end;

procedure TFiscalPrinterTest.CheckCapPackageAdjustment;
begin
  OpenDevice;
 CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapPackageAdjustment),
   'CapPackageAdjustment');
end;

procedure TFiscalPrinterTest.CheckCapPercentAdjustment;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapPercentAdjustment),
    'CapPercentAdjustment');
end;

procedure TFiscalPrinterTest.CheckCapPositiveAdjustment;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapPositiveAdjustment),
    'CapPositiveAdjustment');
end;

procedure TFiscalPrinterTest.CheckCapPositiveSubtotalAdjustment;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapPositiveSubtotalAdjustment),
    'CapPositiveSubtotalAdjustment');
end;

procedure TFiscalPrinterTest.CheckCapPostPreLine;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapPostPreLine),
    'CapPostPreLine');
end;

procedure TFiscalPrinterTest.CheckCapPowerLossReport;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapPowerLossReport),
    'CapPowerLossReport');
end;

procedure TFiscalPrinterTest.CheckCapPredefinedPaymentLines;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapPredefinedPaymentLines),
    'CapPredefinedPaymentLines');
end;

procedure TFiscalPrinterTest.CheckCapReceiptNotPaid;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapReceiptNotPaid),
    'CapReceiptNotPaid');
end;

procedure TFiscalPrinterTest.CheckCapRecEmptySensor;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapRecEmptySensor),
    'CapRecEmptySensor');
end;

procedure TFiscalPrinterTest.CheckCapRecNearEndSensor;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapRecEmptySensor),
    'CapRecEmptySensor');
end;

procedure TFiscalPrinterTest.CheckCapRecPresent;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapRecPresent),
    'CapRecPresent');
end;

procedure TFiscalPrinterTest.CheckCapRemainingFiscalMemory;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapRemainingFiscalMemory),
    'CapRemainingFiscalMemory');
end;

procedure TFiscalPrinterTest.CheckCapReservedWord;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapReservedWord),
    'CapReservedWord');
end;

procedure TFiscalPrinterTest.CheckCapSetCurrency;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSetCurrency),
    'CapSetCurrency');
end;

procedure TFiscalPrinterTest.CheckCapSetHeader;
var
  Model: TPrinterModelRec;
begin
  // 0
  Model.CapSetHeader := False;
  Device.Model := Model;
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSetHeader), 'CapSetHeader');
  Driver.Close;
  // 1
  Model.CapSetHeader := True;
  Device.Model := Model;
  OpenDevice;
 CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSetHeader), 'CapSetHeader');
end;

procedure TFiscalPrinterTest.CheckCapSetPOSID;
begin
  OpenDevice;
 CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSetPOSID),
   'CapSetPOSID');
end;

procedure TFiscalPrinterTest.CheckCapSetStoreFiscalID;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSetStoreFiscalID),
    'CapSetStoreFiscalID');
end;

procedure TFiscalPrinterTest.CheckCapSetTrailer;
var
  Model: TPrinterModelRec;
begin
  // 0
  Model.CapSetTrailer := False;
  Device.Model := Model;
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSetTrailer),
    'CapSetTrailer');
  Driver.Close;
  // 1
  Model.CapSetTrailer := True;
  Device.Model := Model;
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSetTrailer),
    'CapSetTrailer');
end;

procedure TFiscalPrinterTest.CheckCapSetVatTable;
begin
  OpenDevice;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSetVatTable),
    'CapSetVatTable');
end;

procedure TFiscalPrinterTest.CheckCapSlpEmptySensor;
var
  Model: TPrinterModelRec;
begin
  // 0
  Model.CapSlpEmptySensor := False;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSlpEmptySensor),
    'CapSlpEmptySensor');
  Driver.Close;
  // 1
  Model.CapSlpEmptySensor := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSlpEmptySensor),
   'CapSlpEmptySensor');
end;

procedure TFiscalPrinterTest.CheckCapSlpFiscalDocument;
var
  Model: TPrinterModelRec;
begin
  // 0
  Model.CapSlpFiscalDocument := False;
  Device.Model := Model;

  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSlpFiscalDocument),
    'CapSlpFiscalDocument');
  Driver.Close;
  // 1
  Model.CapSlpFiscalDocument := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSlpFiscalDocument),
    'CapSlpFiscalDocument');
end;

procedure TFiscalPrinterTest.CheckCapSlpFullSlip;
begin
  OpenDevice;
 CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSlpFullSlip),
   'CapSlpFullSlip');
end;

procedure TFiscalPrinterTest.CheckCapSlpNearEndSensor;
var
  Model: TPrinterModelRec;
begin
  // 0
  Model.CapSlpNearEndSensor := False;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSlpNearEndSensor),
    'CapSlpFullSlip');
  Driver.Close;
  // 1
  Model.CapSlpNearEndSensor := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSlpNearEndSensor),
    'CapSlpNearEndSensor');
end;

procedure TFiscalPrinterTest.CheckCapSlpPresent;
var
  Model: TPrinterModelRec;
begin
  // 0
  Model.CapSlpPresent := False;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapSlpPresent), 'CapSlpPresent');
  Driver.Close;
  // 1
  Model.CapSlpPresent := True;
  Device.Model := Model;
  OpenClaimEnable;
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapSlpPresent), 'CapSlpPresent');
end;

procedure TFiscalPrinterTest.CheckCapSlpValidation;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapSubAmountAdjustment;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapSubPercentAdjustment;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapSubtotal;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapTotalizerType;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapTrainingMode;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapValidateJournal;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCapXReport;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckChangeDue;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCheckHealth;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCheckTotal;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckClaim;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckClearError;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckClearInput;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckClearInputProperties;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckClearOutput;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckClose;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCompareFirmwareVersion;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckContractorId;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCountryCode;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckCoverOpen;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckDateType;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckDayOpened;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckDescriptionLength;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckDirectIO;
var
  pData: Integer;
  pString: WideString;
  ResultCode: Integer;
begin
  OpenClaimEnable;

  // DIO_COMMAND_PRINTER_XML
  //Driver.DirectIO()

  // DIO_COMMAND_PRINTER_HEX
  pData := 0;
  pString := '01020304';
  ResultCode := Driver.DirectIO(DIO_COMMAND_PRINTER_HEX, pData, pString);
  CheckEquals(0, ResultCode, 'DIO_COMMAND_PRINTER_HEX');


(*
  DIO_CHECK_END_DAY             = 3;
  DIO_LOAD_LOGO                 = 4;  // load logo
  DIO_PRINT_LOGO                = 5;  // print logo
  DIO_LOGO_DLG                  = 6;  // show load logo dialog
  DIO_PRINT_BARCODE             = 7;  // print barcode
  DIO_COMMAND_PRINTER_STR       = 8;  // string parameters command
  DIO_PRINT_TEXT                = 9;  // print text
  DIO_WRITE_TAX_NAME            = 10; // write tax name
  DIO_READ_TAX_NAME             = 11; // write tax name
  DIO_WRITE_PAYMENT_NAME        = 12; // write payment name
  DIO_READ_PAYMENT_NAME         = 13; // read payment name
  DIO_WRITE_TABLE               = 14; // write table value
  DIO_READ_TABLE                = 15; // read table value
  DIO_GET_DEPARTMENT            = 16; // get department value
  DIO_SET_DEPARTMENT            = 17; // set department value
*)
end;

procedure TFiscalPrinterTest.CheckDuplicateReceipt;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckEndFiscalDocument;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckEndFiscalReceipt;
var
  Model: TPrinterModelRec;
begin
  OpenClaimEnable;

  Model := Device.Model;
  Model.CapAutoFeedOnCut := False;
  Model.NumHeaderLines := 3;
  Model.NumTrailerLines := 4;
  Device.Model := Model;

  Parameters.UsePrintHeaderParameter := True;
  Printer.Parameters.NumHeaderLines := 3;
  Printer.Parameters.NumTrailerLines := 4;

  Printer.Parameters.Trailer :=
    '  Trailer line 1' + CRLF +
    '  Trailer line 2' + CRLF +
    '  Trailer line 3' + CRLF +
    '  Trailer line 4';

  Printer.Parameters.Header :=
    '  Header line 1' + CRLF +
    '  Header line 2' + CRLF +
    '  Header line 3';

  CheckEquals(0, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals(0, Printer.BeginFiscalReceipt(False));
  CheckEquals(0, Printer.PrintRecItem('', 1, 1000, 0, 0, ''));
  CheckEquals(0, Printer.PrintRecTotal(1, 1, '0'));
  CheckEquals(0, Printer.EndFiscalReceipt(false));
  Driver.Close;

  CheckEquals(8, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals('  Trailer line 1', Device.RecStation[0], 'Device.RecStation[0]');
  CheckEquals('  Trailer line 2', Device.RecStation[1], 'Device.RecStation[1]');
  CheckEquals('  Trailer line 3', Device.RecStation[2], 'Device.RecStation[2]');
  CheckEquals('  Trailer line 4', Device.RecStation[3], 'Device.RecStation[3]');
  CheckEquals('', Device.RecStation[4], 'Device.RecStation[4]');
  CheckEquals('', Device.RecStation[5], 'Device.RecStation[5]');
  CheckEquals('', Device.RecStation[6], 'Device.RecStation[6]');
  CheckEquals('CutPaper(1)', Device.RecStation[7], 'Device.RecStation[7]');
end;

procedure TFiscalPrinterTest.CheckEndFiscalReceipt2;
var
  Model: TPrinterModelRec;
begin
  OpenClaimEnable;

  Model := Device.Model;
  Model.CapAutoFeedOnCut := True;
  Model.NumHeaderLines := 3;
  Model.NumTrailerLines := 4;
  Device.Model := Model;

  Parameters.UsePrintHeaderParameter := True;
  Printer.Parameters.NumHeaderLines := 3;
  Printer.Parameters.NumTrailerLines := 4;

  Printer.Parameters.Trailer :=
    '  Trailer line 1' + CRLF +
    '  Trailer line 2' + CRLF +
    '  Trailer line 3' + CRLF +
    '  Trailer line 4';

  Printer.Parameters.Header :=
    '  Header line 1' + CRLF +
    '  Header line 2' + CRLF +
    '  Header line 3';

  CheckEquals(0, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals(0, Printer.BeginFiscalReceipt(False));
  CheckEquals(0, Printer.PrintRecItem('', 1, 1000, 0, 0, ''));
  CheckEquals(0, Printer.PrintRecTotal(1, 1, '0'));
  CheckEquals(0, Printer.EndFiscalReceipt(false));
  Driver.Close;

  CheckEquals(5, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals('  Trailer line 1', Device.RecStation[0], 'Device.RecStation[0]');
  CheckEquals('  Trailer line 2', Device.RecStation[1], 'Device.RecStation[1]');
  CheckEquals('  Trailer line 3', Device.RecStation[2], 'Device.RecStation[2]');
  CheckEquals('  Trailer line 4', Device.RecStation[3], 'Device.RecStation[3]');
  CheckEquals('CutPaper(1)', Device.RecStation[4], 'Device.RecStation[4]');
end;

procedure TFiscalPrinterTest.CheckEndFiscalReceipt3;
var
  Model: TPrinterModelRec;
begin
  OpenClaimEnable;

  Model := Device.Model;
  Model.CapAutoFeedOnCut := True;
  Model.NumHeaderLines := 3;
  Model.NumTrailerLines := 4;
  Device.Model := Model;

  Printer.Parameters.NumHeaderLines := 3;
  Printer.Parameters.NumTrailerLines := 4;

  Printer.Parameters.Trailer :=
    '  Trailer line 1' + CRLF +
    '  Trailer line 2' + CRLF +
    '  Trailer line 3' + CRLF +
    '  Trailer line 4';

  Printer.Parameters.Header :=
    '  Header line 1' + CRLF +
    '  Header line 2' + CRLF +
    '  Header line 3';

  CheckEquals(0, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals(0, Printer.BeginFiscalReceipt(False));
  CheckEquals(0, Printer.PrintRecItem('', 1, 1000, 0, 0, ''));
  CheckEquals(0, Printer.PrintRecTotal(1, 1, '0'));
  CheckEquals(0, Printer.EndFiscalReceipt(True));
  Driver.Close;

  CheckEquals(8, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals('  Trailer line 1', Device.RecStation[0], 'Device.RecStation[0]');
  CheckEquals('  Trailer line 2', Device.RecStation[1], 'Device.RecStation[1]');
  CheckEquals('  Trailer line 3', Device.RecStation[2], 'Device.RecStation[2]');
  CheckEquals('  Trailer line 4', Device.RecStation[3], 'Device.RecStation[3]');
  CheckEquals('CutPaper(1)', Device.RecStation[4], 'Device.RecStation[4]');
  CheckEquals('  Header line 1', Device.RecStation[5], 'Device.RecStation[5]');
  CheckEquals('  Header line 2', Device.RecStation[6], 'Device.RecStation[6]');
  CheckEquals('  Header line 3', Device.RecStation[7], 'Device.RecStation[7]');
end;

procedure TFiscalPrinterTest.CheckEndNonFiscal;
var
  Model: TPrinterModelRec;
begin
  Model := Device.Model;
  Model.CapAutoFeedOnCut := True;
  Model.NumHeaderLines := 3;
  Model.NumTrailerLines := 4;
  Device.Model := Model;

  Printer.Parameters.NumHeaderLines := 3;
  Printer.Parameters.NumTrailerLines := 4;

  Printer.Parameters.Trailer :=
    '  Trailer line 1' + CRLF +
    '  Trailer line 2' + CRLF +
    '  Trailer line 3' + CRLF +
    '  Trailer line 4';

  Printer.Parameters.Header :=
    '  Header line 1' + CRLF +
    '  Header line 2' + CRLF +
    '  Header line 3';

  OpenClaimEnable;
  CheckEquals(0, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals(0, Printer.BeginNonFiscal, 'Printer.BeginNonFiscal');
  CheckEquals(0, Printer.PrintNormal(FPTR_S_RECEIPT, 'Text line 1'), 'Printer.PrintNormal');
  CheckEquals(0, Printer.EndNonFiscal, 'Printer.EndNonFiscal');

  CheckEquals(9, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals('Text line 1', Device.RecStation[0], 'Device.RecStation[0]');
  CheckEquals('  Trailer line 1', Device.RecStation[1], 'Device.RecStation[1]');
  CheckEquals('  Trailer line 2', Device.RecStation[2], 'Device.RecStation[2]');
  CheckEquals('  Trailer line 3', Device.RecStation[3], 'Device.RecStation[3]');
  CheckEquals('  Trailer line 4', Device.RecStation[4], 'Device.RecStation[4]');
  CheckEquals('CutPaper(1)', Device.RecStation[5], 'Device.RecStation[5]');
  CheckEquals('  Header line 1', Device.RecStation[6], 'Device.RecStation[6]');
  CheckEquals('  Header line 2', Device.RecStation[7], 'Device.RecStation[7]');
  CheckEquals('  Header line 3', Device.RecStation[8], 'Device.RecStation[8]');
end;

procedure TFiscalPrinterTest.CheckEndNonFiscal2;
var
  Model: TPrinterModelRec;
begin
  Model := Device.Model;
  Model.CapAutoFeedOnCut := False;
  Model.NumHeaderLines := 3;
  Model.NumTrailerLines := 4;
  Device.Model := Model;

  Printer.Parameters.NumHeaderLines := 3;
  Printer.Parameters.NumTrailerLines := 4;

  Printer.Parameters.Trailer :=
    '  Trailer line 1' + CRLF +
    '  Trailer line 2' + CRLF +
    '  Trailer line 3' + CRLF +
    '  Trailer line 4';

  Printer.Parameters.Header :=
    '  Header line 1' + CRLF +
    '  Header line 2' + CRLF +
    '  Header line 3';

  OpenClaimEnable;
  CheckEquals(0, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals(0, Printer.BeginNonFiscal, 'Printer.BeginNonFiscal');
  CheckEquals(0, Printer.PrintNormal(FPTR_S_RECEIPT, 'Text line 1'), 'Printer.PrintNormal');
  CheckEquals(0, Printer.EndNonFiscal, 'Printer.EndNonFiscal');

  CheckEquals(9, Device.RecStation.Count, 'Device.RecStation.Count');
  CheckEquals('Text line 1', Device.RecStation[0], 'Device.RecStation[0]');
  CheckEquals('  Trailer line 1', Device.RecStation[1], 'Device.RecStation[1]');
  CheckEquals('  Trailer line 2', Device.RecStation[2], 'Device.RecStation[2]');
  CheckEquals('  Trailer line 3', Device.RecStation[3], 'Device.RecStation[3]');
  CheckEquals('  Trailer line 4', Device.RecStation[4], 'Device.RecStation[4]');
  CheckEquals('  Header line 1', Device.RecStation[5], 'Device.RecStation[5]');
  CheckEquals('  Header line 2', Device.RecStation[6], 'Device.RecStation[6]');
  CheckEquals('  Header line 3', Device.RecStation[7], 'Device.RecStation[7]');
  CheckEquals('CutPaper(1)', Device.RecStation[8], 'Device.RecStation[8]');
end;

procedure TFiscalPrinterTest.CheckEndFixedOutput;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckEndInsertion;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckEndItemList;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckEndRemoval;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckEndTraining;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckErrorLevel;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckErrorOutID;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckErrorState;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckErrorStation;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckErrorString;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckFiscalReceiptStation;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckFiscalReceiptType;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckFlagWhenIdle;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckGetData;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckGetDate;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckGetOpenResult;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckGetTotalizer;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckGetVatEntry;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckJrnEmpty;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckJrnNearEnd;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckMessageLength;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckMessageType;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckNumHeaderLines;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckNumTrailerLines;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckNumVatRates;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckOpen;
//var
// i: Integer;
begin
  //for i := 1 to 10 do
  begin
    OpenDevice;
    CheckResult(Driver.Close);
  end;
end;

procedure TFiscalPrinterTest.CheckPostLine;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPredefinedPaymentLines;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPreLine;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintDuplicateReceipt;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrinterState;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintFiscalDocumentLine;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintFixedOutput;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintNormal;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintPeriodicTotalsReport;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintPowerLossReport;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecCash;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecItem;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecItemAdjustment;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecItemAdjustmentVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecItemFuel;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecItemFuelVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecItemVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecMessage;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecNotPaid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecPackageAdjustment;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecPackageAdjustVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecRefund;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecRefundVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecSubtotal;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecSubtotalAdjustment;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecSubtotalAdjustVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecTaxID;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecTotal;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecVoid;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintRecVoidItem;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintReport;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintXReport;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckPrintZReport;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckQuantityDecimalPlaces;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckQuantityLength;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckRecEmpty;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckRelease;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckRemainingFiscalMemory;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckReservedWord;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckResetPrinter;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckResetStatistics;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckRetrieveStatistics;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetCurrency;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetDate;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetHeaderLine;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetPOSID;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetStoreFiscalID;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetTrailerLine;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetVatTable;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSetVatValue;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSlipSelection;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSlpEmpty;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckSlpNearEnd;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckTotalizerType;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckTrainingModeActive;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckUpdateFirmware;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckUpdateStatistics;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckVerifyItem;
begin
  EmptyTest;
end;

procedure TFiscalPrinterTest.CheckStornoReceipt;
begin
  EmptyTest;
(*
  OpenDevice;
  // receipt
  Driver.SetPropertyNumber(PIDXFptr_FiscalReceiptStation, FPTR_RS_RECEIPT);
  Driver.SetPropertyNumber(PIDXFptr_FiscalReceiptType, FPTR_RT_SALES);
  Driver.SetPropertyString(PIDXFptr_AdditionalHeader, '');
  Driver.SetPropertyString(PIDXFptr_AdditionalTrailer, '');
  CheckResult(Driver.BeginFiscalReceipt(False));
  CheckResult(Driver.PrintRecItem('Receipt item 1', 123, 1, 1, 0, ''));
  CheckResult(Driver.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
      'Скидка суммой 10 руб', 10, 1));
  CheckResult(Driver.PrintRecItem('Receipt item 2', 178.98, 1, 2, 0, ''));
  CheckResult(Driver.PrintRecItemAdjustment(FPTR_AT_AMOUNT_DISCOUNT,
      'Скидка суммой 20 руб', 20, 2));
  CheckResult(Driver.PrintRecItemVoid('Receipt item 1', 123, 1, 1, 0, ''));
  CheckResult(Driver.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
      'Сторно скидки суммой 10 руб', 10, 1));
  CheckResult(Driver.PrintRecItemVoid('Receipt item 2', 178.98, 1, 2, 0, ''));
  CheckResult(Driver.PrintRecItemAdjustment(FPTR_AT_AMOUNT_SURCHARGE,
      'Скидка суммой 20 руб', 20, 2));
  CheckResult(Driver.PrintRecTotal(100, 100, '0'));
  CheckResult(Driver.EndFiscalReceipt(False));
*)
end;

procedure TFiscalPrinterTest.SetTestParameters;
const
  CRLF = #13#10;
  HeaderText =
    'Header line 1' + CRLF +
    'Header line 2' + CRLF +
    'Header line 3' + CRLF +
    'Header line 4' + CRLF +
    'Header line 5' + CRLF +
    'Header line 6';
  TrailerText = '';
begin
  Parameters.Storage := 2;
  Parameters.Header := HeaderText;
  Parameters.Trailer := TrailerText;
  Parameters.RemoteHost := '';
  Parameters.RemotePort := 0;
  Parameters.ConnectionType := 0;
  Parameters.PortNumber := 2;
  Parameters.BaudRate := 115200;
  Parameters.SysPassword := 30;
  Parameters.UsrPassword := 1;
  Parameters.SubtotalText := '';
  Parameters.CloseRecText := '';
  Parameters.VoidRecText := '';
  Parameters.FontNumber := 1;
  Parameters.ByteTimeout := 1000;
  Parameters.MaxRetryCount := 10;
  Parameters.SearchByPortEnabled := True;
  Parameters.SearchByBaudRateEnabled := True;
  Parameters.PollIntervalInSeconds := 1000;
  Parameters.StatusInterval := 1000;
  Parameters.DeviceByteTimeout := 1000;
  Parameters.LogFileEnabled := True;
  Parameters.CutType := 1;
  Parameters.LogoPosition := 1;
  Parameters.NumHeaderLines := 7;
  Parameters.NumTrailerLines := 4;
  Parameters.Encoding := 0;
  Parameters.HeaderType := 1;
  Parameters.HeaderFont := 1;
  Parameters.TrailerFont := 1;
  Parameters.StatusCommand := 1;
  Parameters.BarLinePrintDelay := 100;
  Parameters.CompatLevel := 1;
  Parameters.ReceiptType := 0;
  Parameters.ZeroReceiptType := 1;
  Parameters.ZeroReceiptNumber := 1;
  Parameters.LogoSize := 70;
  Parameters.LogoFileName := 'C:\Program Files\OPOS\SHTRIH-M\Bin\Logo\Logo5.bmp';
  Parameters.IsLogoLoaded := True;
  Parameters.LogoCenter := True;
  Parameters.Department := 1;
  Parameters.LogoReloadEnabled := False;
  Parameters.HeaderPrinted := True;
  Parameters.CCOType := 2;
  Parameters.TableEditEnabled := True;
  Parameters.XmlZReportEnabled := False;
  Parameters.CsvZReportEnabled := False;
  Parameters.XmlZReportFileName := 'C:\Program Files\OPOS\SHTRIH-M\ZReport.xml';
  Parameters.CsvZReportFileName := 'C:\Program Files\OPOS\SHTRIH-M\ZReport.csv';
  Parameters.LogMaxCount := 10;
  Parameters.VoidReceiptOnMaxItems := False;
  Parameters.JournalPrintHeader := False;
  Parameters.JournalPrintTrailer := False;
  Parameters.CacheReceiptNumber := False;
  Parameters.StatusTimeout := 60;
  Parameters.RFAmountLength := 10;
  Parameters.RFSeparatorLine := 1;
  Parameters.RFQuantityLength := 10;
  Parameters.RFShowTaxLetters := False;
  Parameters.MonitoringPort := 50000;
  Parameters.MonitoringEnabled := False;
  Parameters.PropertyUpdateMode := 0;
  Parameters.ReceiptReportEnabled := False;
  Parameters.ReceiptReportFileName := 'C:\Program Files\OPOS\SHTRIH-M\Bin\ZCheckReport.xml';
  Parameters.DepartmentInText := False;
  Parameters.CenterHeader := False;
  Parameters.AmountDecimalPlaces := 2;
  Parameters.CapRecNearEndSensorMode := 2;
  Parameters.PayTypes.Add(0, '0');
  Parameters.PayTypes.Add(1, '1');
  Parameters.PayTypes.Add(2, '2');
  Parameters.PayTypes.Add(3, '3');
end;

procedure TFiscalPrinterTest.CheckRecNearEnd;
var
  Flags: TPrinterFlags;
begin
  OpenDevice;

  SetTestParameters;
  Parameters.PropertyUpdateMode := PropertyUpdateModeNone;
  Parameters.CapRecNearEndSensorMode := SensorModeTrue;

  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);


  Flags.RecEmpty := False;
  Flags.RecNearEnd := True;
  FDevice.SetFlags(Flags);
  Printer.SetRecPaperState(False, True);
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapRecPresent),
    'GetPropertyNumber(PIDXFptr_CapRecPresent)');
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_CapRecNearEndSensor),
    'GetPropertyNumber(PIDXFptr_CapRecNearEndSensor)');
  CheckEquals(1, Driver.GetPropertyNumber(PIDXFptr_RecNearEnd),
    'Driver.GetPropertyNumber(PIDXFptr_RecNearEnd)');
  Driver.Close;

  OpenDevice;
  Parameters.CapRecNearEndSensorMode := SensorModeFalse;
  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);

  Printer.SetRecPaperState(False, True);
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapRecNearEndSensor),
    'Driver.GetPropertyNumber(PIDXFptr_CapRecNearEndSensor)');
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_RecNearEnd),
    'Driver.GetPropertyNumber(PIDXFptr_RecNearEnd)');

  CheckEquals(0, Printer.BeginFiscalReceipt(False));
  CheckEquals(0, Printer.PrintRecItem('', 1, 1000, 0, 0, ''));
  CheckEquals(0, Printer.PrintRecTotal(1, 1, '0'));
  CheckEquals(0, Printer.EndFiscalReceipt(false));
  CheckEquals(0, Printer.CheckHealth(1));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);

  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_CapRecNearEndSensor),
    'Driver.GetPropertyNumber(PIDXFptr_CapRecNearEndSensor)');
  CheckEquals(0, Driver.GetPropertyNumber(PIDXFptr_RecNearEnd),
    'Driver.GetPropertyNumber(PIDXFptr_RecNearEnd)');

  Driver.Close;
end;

procedure TFiscalPrinterTest.SaveTestDevice;
begin
  OpenDevice;
  SetTestParameters;
end;

procedure TFiscalPrinterTest.TestEncoding;
const
  Line1 = '     ****** ‘ЏЂ‘€ЃЋ ‡Ђ ЏЋЉ“ЏЉ“ ******     ';
  Line2 = '     ****** СПАСИБО ЗА ПОКУПКУ ******     ';
begin
  OpenClaimEnable;
  CheckEquals(Line2, Str866To1251(Line1));

  Parameters.Encoding := Encoding866;
  CheckEquals(Line2, Driver.DecodeString(Line1));
end;

procedure TFiscalPrinterTest.CheckNonFiscal;
begin
  OpenClaimEnable;
  CheckEquals(0, Printer.BeginNonFiscal, 'Printer.BeginNonFiscal');

  CheckEquals(0, Printer.PrintNormal(FPTR_S_RECEIPT, 'Text line 1'), 'Printer.PrintNormal');
  CheckEquals(0, Printer.PrintNormal(FPTR_S_RECEIPT, 'Text line 2'), 'Printer.PrintNormal');
  CheckEquals(0, Printer.PrintNormal(FPTR_S_RECEIPT, 'Text line 3'), 'Printer.PrintNormal');
  CheckEquals(0, Printer.EndNonFiscal, 'Printer.EndNonFiscal');

  CheckEquals(0, Device.JrnStation.Count, 'Device.JrnStation.Count');
  CheckEquals('Text line 1', Device.RecStation[0], 'Device.RecStation[0]');
  CheckEquals('Text line 2', Device.RecStation[1], 'Device.RecStation[1]');
  CheckEquals('Text line 3', Device.RecStation[2], 'Device.RecStation[2]');
end;

procedure TFiscalPrinterTest.CheckFiscalReceipt1;
begin
  Device.Context.MalinaParams.RetalixDBEnabled := True;
  {$IFDEF MALINA}
  OpenClaimEnable;

  CheckEquals(0, Printer.Printer.Header.Count, 'Printer.Printer.Header.Count');
  CheckEquals(0, Printer.Printer.Trailer.Count, 'Printer.Printer.Trailer.Count');

  CheckEquals(0, Printer.BeginFiscalReceipt(False), 'BeginFiscalReceipt');
  Printer.Receipt.AddRecMessage('EMail: user@user.com', PRINTER_STATION_REC, 1);

  CheckEquals(0, Printer.PrintRecItem(
    'ТРК 3:Аи-92-К5 (Фирменный)                  Трз0', 728.2, 1000, 0, 728.2, ''));

  CheckEquals(0, Printer.PrintRecSubtotal(0));
  CheckEquals(0, Printer.PrintRecTotal(728.2, 728.2, '0'));

  CheckEquals(0, Printer.PrintRecMessage('Оператор: ts ID:    3946246'));
  Printer.Receipt.AddRecMessage('Номер телефона: 28346827346', PRINTER_STATION_REC, 1);

  CheckEquals(0, Printer.EndFiscalReceipt(False));

  CheckEquals(0, Device.JrnStation.Count, 'Device.JrnStation.Count');
  CheckEquals(11, Device.RecStation.Count, 'Device.RecStation.Count');

  CheckEquals('ТРК 3:Аи-92-К5 (Фирменный)                  Трз0', Trim(Device.RecStation[0]), 'Device.RecStation[0]');
  CheckEquals('1.000 X 728.20', Trim(Device.RecStation[1]), 'Device.RecStation[1]');
  CheckEquals('1 =728.20_Г', Trim(Device.RecStation[2]), 'Device.RecStation[2]');
  CheckEquals('0.00', Trim(Device.RecStation[3]), 'Device.RecStation[3]');
  CheckEquals('SUBTOTAL =728.20', Trim(Device.RecStation[4]), 'Device.RecStation[4]');
  CheckEquals('ИТОГ', Trim(Device.RecStation[5]), 'Device.RecStation[5]');
  CheckEquals('EMail: user@user.com', Trim(Device.RecStation[6]), 'Device.RecStation[6]');
  CheckEquals('Номер телефона: 28346827346', Trim(Device.RecStation[7]), 'Device.RecStation[7]');
  CheckEquals('Диспетчер ts ID:    3946246', Trim(Device.RecStation[8]), 'Device.RecStation[8]');
  CheckEquals('', Trim(Device.RecStation[9]), 'Device.RecStation[9]');
  {$ENDIF}
end;


initialization
  RegisterTest('', TFiscalPrinterTest.Suite);

end.
