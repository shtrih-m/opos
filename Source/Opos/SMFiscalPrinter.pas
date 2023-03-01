unit SMFiscalPrinter;

interface

uses
  // VCL
  Windows, SysUtils, Variants, ComObj, ActiveX,
  // Tnt
  TntSysUtils,
  // This
  Opos, OposFptrUtils, PrinterEncoding, PrinterParameters, PrinterParametersX,
  DirectIOAPI, OposFiscalPrinter_1_12_Lib_TLB, OposFiscalPrinter_1_13_Lib_TLB,
  StringUtils, LogFile, WException, PrinterTypes;

const
  ValueDelimiters = [';'];

type
  { TBarcodeRec }

  TBarcodeRec = record
    Data: WideString; // barcode data
    Text: WideString; // barcode text
    Height: Integer;
    BarcodeType: Integer;
    ModuleWidth: Integer;
    Alignment: Integer;
  end;

  { TSMFiscalPrinter }

  TSMFiscalPrinter = class
  private
    FLogger: ILogFile;
    FEncoding: Integer;
    FDriver: TOPOSFiscalPrinter;
    function GetDriver: TOPOSFiscalPrinter;
  public
    property Logger: ILogFile read FLogger;
    property Driver: TOPOSFiscalPrinter read GetDriver;
  public
    constructor Create;
    destructor Destroy; override;
    //
    function EncodeString(const Text: WideString): WideString;
    function DecodeString(const Text: WideString): WideString;
    function Get_FontNumber: Integer;
    procedure Set_FontNumber(const Value: Integer);
    function GetIntParameter(ParamID: Integer): Integer;
    function SetIntParameter(ParamID, Value: Integer): Integer;
    procedure Check(AResultCode: Integer);
    // IOPOSFiscalPrinter_1_6
    procedure SODataDummy(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; var pErrorResponse: Integer); safecall;
    procedure SOOutputComplete(OutputID: Integer); safecall;
    procedure SOStatusUpdate(Data: Integer); safecall;
    function SOProcessID: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    function Get_BinaryConversion: Integer; safecall;
    procedure Set_BinaryConversion(Value: Integer); safecall;
    function Get_CapPowerReporting: Integer; safecall;
    function Get_CheckHealthText: WideString; safecall;
    function Get_Claimed: WordBool; safecall;
    function Get_DeviceEnabled: WordBool; safecall;
    procedure Set_DeviceEnabled(Value: WordBool); safecall;
    function Get_FreezeEvents: WordBool; safecall;
    procedure Set_FreezeEvents(Value: WordBool); safecall;
    function Get_OutputID: Integer; safecall;
    function Get_PowerNotify: Integer; safecall;
    procedure Set_PowerNotify(Value: Integer); safecall;
    function Get_PowerState: Integer; safecall;
    function Get_ResultCode: Integer; safecall;
    function Get_ResultCodeExtended: Integer; safecall;
    function Get_State: Integer; safecall;
    function Get_ControlObjectDescription: WideString; safecall;
    function Get_ControlObjectVersion: Integer; safecall;
    function Get_ServiceObjectDescription: WideString; safecall;
    function Get_ServiceObjectVersion: Integer; safecall;
    function Get_DeviceDescription: WideString; safecall;
    function Get_DeviceName: WideString; safecall;
    function CheckHealth(Level: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearOutput: Integer; safecall;
    function Close: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; overload; safecall;
    function DirectIO2(Command: Integer; const pData: Integer; const pString: WideString): Integer; overload; safecall;
    function GetData2(DataItem: Integer; const OptArgs: Integer; const Data: WideString): Integer;
    function Open(const DeviceName: WideString): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function Get_AmountDecimalPlaces: Integer; safecall;
    function Get_AsyncMode: WordBool; safecall;
    procedure Set_AsyncMode(Value: WordBool); safecall;
    function Get_CapAdditionalLines: WordBool; safecall;
    function Get_CapAmountAdjustment: WordBool; safecall;
    function Get_CapAmountNotPaid: WordBool; safecall;
    function Get_CapCheckTotal: WordBool; safecall;
    function Get_CapCoverSensor: WordBool; safecall;
    function Get_CapDoubleWidth: WordBool; safecall;
    function Get_CapDuplicateReceipt: WordBool; safecall;
    function Get_CapFixedOutput: WordBool; safecall;
    function Get_CapHasVatTable: WordBool; safecall;
    function Get_CapIndependentHeader: WordBool; safecall;
    function Get_CapItemList: WordBool; safecall;
    function Get_CapJrnEmptySensor: WordBool; safecall;
    function Get_CapJrnNearEndSensor: WordBool; safecall;
    function Get_CapJrnPresent: WordBool; safecall;
    function Get_CapNonFiscalMode: WordBool; safecall;
    function Get_CapOrderAdjustmentFirst: WordBool; safecall;
    function Get_CapPercentAdjustment: WordBool; safecall;
    function Get_CapPositiveAdjustment: WordBool; safecall;
    function Get_CapPowerLossReport: WordBool; safecall;
    function Get_CapPredefinedPaymentLines: WordBool; safecall;
    function Get_CapReceiptNotPaid: WordBool; safecall;
    function Get_CapRecEmptySensor: WordBool; safecall;
    function Get_CapRecNearEndSensor: WordBool; safecall;
    function Get_CapRecPresent: WordBool; safecall;
    function Get_CapRemainingFiscalMemory: WordBool; safecall;
    function Get_CapReservedWord: WordBool; safecall;
    function Get_CapSetHeader: WordBool; safecall;
    function Get_CapSetPOSID: WordBool; safecall;
    function Get_CapSetStoreFiscalID: WordBool; safecall;
    function Get_CapSetTrailer: WordBool; safecall;
    function Get_CapSetVatTable: WordBool; safecall;
    function Get_CapSlpEmptySensor: WordBool; safecall;
    function Get_CapSlpFiscalDocument: WordBool; safecall;
    function Get_CapSlpFullSlip: WordBool; safecall;
    function Get_CapSlpNearEndSensor: WordBool; safecall;
    function Get_CapSlpPresent: WordBool; safecall;
    function Get_CapSlpValidation: WordBool; safecall;
    function Get_CapSubAmountAdjustment: WordBool; safecall;
    function Get_CapSubPercentAdjustment: WordBool; safecall;
    function Get_CapSubtotal: WordBool; safecall;
    function Get_CapTrainingMode: WordBool; safecall;
    function Get_CapValidateJournal: WordBool; safecall;
    function Get_CapXReport: WordBool; safecall;
    function Get_CheckTotal: WordBool; safecall;
    procedure Set_CheckTotal(Value: WordBool); safecall;
    function Get_CountryCode: Integer; safecall;
    function Get_CoverOpen: WordBool; safecall;
    function Get_DayOpened: WordBool; safecall;
    function Get_DescriptionLength: Integer; safecall;
    function Get_DuplicateReceipt: WordBool; safecall;
    procedure Set_DuplicateReceipt(pDuplicateReceipt: WordBool); safecall;
    function Get_ErrorLevel: Integer; safecall;
    function Get_ErrorOutID: Integer; safecall;
    function Get_ErrorState: Integer; safecall;
    function Get_ErrorStation: Integer; safecall;
    function Get_ErrorString: WideString; safecall;
    function Get_FlagWhenIdle: WordBool; safecall;
    procedure Set_FlagWhenIdle(pFlagWhenIdle: WordBool); safecall;
    function Get_JrnEmpty: WordBool; safecall;
    function Get_JrnNearEnd: WordBool; safecall;
    function Get_MessageLength: Integer; safecall;
    function Get_NumHeaderLines: Integer; safecall;
    function Get_NumTrailerLines: Integer; safecall;
    function Get_NumVatRates: Integer; safecall;
    function Get_PredefinedPaymentLines: WideString; safecall;
    function Get_PrinterState: Integer; safecall;
    function Get_QuantityDecimalPlaces: Integer; safecall;
    function Get_QuantityLength: Integer; safecall;
    function Get_RecEmpty: WordBool; safecall;
    function Get_RecNearEnd: WordBool; safecall;
    function Get_RemainingFiscalMemory: Integer; safecall;
    function Get_ReservedWord: WideString; safecall;
    function Get_SlipSelection: Integer; safecall;
    procedure Set_SlipSelection(pSlipSelection: Integer); safecall;
    function Get_SlpEmpty: WordBool; safecall;
    function Get_SlpNearEnd: WordBool; safecall;
    function Get_TrainingModeActive: WordBool; safecall;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; safecall;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; safecall;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; safecall;
    function BeginInsertion(Timeout: Integer): Integer; safecall;
    function BeginItemList(VatID: Integer): Integer; safecall;
    function BeginNonFiscal: Integer; safecall;
    function BeginRemoval(Timeout: Integer): Integer; safecall;
    function BeginTraining: Integer; safecall;
    function ClearError: Integer; safecall;
    function EndFiscalDocument: Integer; safecall;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; safecall;
    function EndFixedOutput: Integer; safecall;
    function EndInsertion: Integer; safecall;
    function EndItemList: Integer; safecall;
    function EndNonFiscal: Integer; safecall;
    function EndRemoval: Integer; safecall;
    function EndTraining: Integer; safecall;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; safecall;
    function GetDate(out Date: WideString): Integer; safecall;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; safecall;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; safecall;
    function PrintDuplicateReceipt: Integer; safecall;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; safecall;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; safecall;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; overload; safecall;
    function PrintNormal(Station, Font: Integer; const Data: WideString): Integer; overload; safecall;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; safecall;
    function PrintPowerLossReport: Integer; safecall;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; safecall;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecMessage(const Message: WideString): Integer; safecall;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; safecall;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecSubtotal(Amount: Currency): Integer; safecall;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; Amount: Currency): Integer; safecall;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; safecall;
    function PrintRecVoid(const Description: WideString): Integer; safecall;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; safecall;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; safecall;
    function PrintXReport: Integer; safecall;
    function PrintZReport: Integer; safecall;
    function ResetPrinter: Integer; safecall;
    function SetDate(const Date: WideString): Integer; safecall;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; safecall;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; safecall;
    function SetStoreFiscalID(const ID: WideString): Integer; safecall;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; safecall;
    function SetVatTable: Integer; safecall;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; safecall;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; safecall;
    function Get_ActualCurrency: Integer; safecall;
    function Get_AdditionalHeader: WideString; safecall;
    procedure Set_AdditionalHeader(const pAdditionalHeader: WideString); safecall;
    function Get_AdditionalTrailer: WideString; safecall;
    procedure Set_AdditionalTrailer(const pAdditionalTrailer: WideString); safecall;
    function Get_CapAdditionalHeader: WordBool; safecall;
    function Get_CapAdditionalTrailer: WordBool; safecall;
    function Get_CapChangeDue: WordBool; safecall;
    function Get_CapEmptyReceiptIsVoidable: WordBool; safecall;
    function Get_CapFiscalReceiptStation: WordBool; safecall;
    function Get_CapFiscalReceiptType: WordBool; safecall;
    function Get_CapMultiContractor: WordBool; safecall;
    function Get_CapOnlyVoidLastItem: WordBool; safecall;
    function Get_CapPackageAdjustment: WordBool; safecall;
    function Get_CapPostPreLine: WordBool; safecall;
    function Get_CapSetCurrency: WordBool; safecall;
    function Get_CapTotalizerType: WordBool; safecall;
    function Get_ChangeDue: WideString; safecall;
    procedure Set_ChangeDue(const pChangeDue: WideString); safecall;
    function Get_ContractorId: Integer; safecall;
    procedure Set_ContractorId(pContractorId: Integer); safecall;
    function Get_DateType: Integer; safecall;
    procedure Set_DateType(pDateType: Integer); safecall;
    function Get_FiscalReceiptStation: Integer; safecall;
    procedure Set_FiscalReceiptStation(pFiscalReceiptStation: Integer); safecall;
    function Get_FiscalReceiptType: Integer; safecall;
    procedure Set_FiscalReceiptType(pFiscalReceiptType: Integer); safecall;
    function Get_MessageType: Integer; safecall;
    procedure Set_MessageType(pMessageType: Integer); safecall;
    function Get_PostLine: WideString; safecall;
    procedure Set_PostLine(const pPostLine: WideString); safecall;
    function Get_PreLine: WideString; safecall;
    procedure Set_PreLine(const pPreLine: WideString); safecall;
    function Get_TotalizerType: Integer; safecall;
    procedure Set_TotalizerType(pTotalizerType: Integer); safecall;
    function PrintRecCash(Amount: Currency): Integer; safecall;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; SpecialTax: Currency; const SpecialTaxName: WideString): Integer; safecall;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; SpecialTax: Currency): Integer; safecall;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; const VatAdjustment: WideString): Integer; safecall;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; safecall;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; safecall;
    function PrintRecTaxID(const TaxID: WideString): Integer; safecall;
    function SetCurrency(NewCurrency: Integer): Integer; safecall;
    function GetBoolParameter(ParamID: Integer): Boolean;
    function GetParameter(ParamID: Integer): WideString;
    function SetBoolParameter(ParamID: Integer; Value: Boolean): Integer;
    function SetParameter(ParamID: Integer; const Value: WideString): Integer; overload;
    function SetParameter(ParamID: Integer; const Value: Integer): Integer; overload;
    procedure PrintImage(const FileName: WideString);
    procedure PrintImageScale(const FileName: WideString; Scale: Integer);
    procedure PrintBarcode(const Data: WideString; BarcodeType: Integer);
    function PrintBarcode2(const Barcode: TBarcodeRec): Integer;
    function PrintBarcodeHex(const Barcode: TBarcodeRec): Integer;
    function PrintBarcodeHex2(const Barcode: TBarcodeRec): Integer;
    function SetAdjustmentAmount(Amount: Integer): Integer;
    function FSReadTicketHex(Number: Integer; var Ticket: WideString): Integer;
    function FSReadTicketStr(Number: Integer; var Ticket: WideString): Integer;
    function WriteFPParameter(ParamId: Integer; const Value: WideString): Integer;
    function PrintFSDocument(Number: Integer): Integer;
    function ReadFSDocument(Number: Integer; var S: WideString): Integer;
    function CheckItemBarcode(const Barcode: WideString): Integer;
    function AddItemBarcode(const Barcode: WideString): Integer;
    function FSCheckItemCode(const P: TFSCheckItemCode; var R: TFSCheckItemResult): Integer;
    function FSSyncRegisters: Integer;
    function FSReadMemory(var R: TFSReadMemoryResult): Integer;
    function FSWriteTLVFromBuffer: Integer;
    function FSRandomData(var Data: AnsiString): Integer;
    function FSAuthorize(const DataToAuthorize: AnsiString): Integer;
    function FSReadTicketStatus(var R: TFSTicketStatus): Integer;

    property OpenResult: Integer read Get_OpenResult;
    property BinaryConversion: Integer read Get_BinaryConversion write Set_BinaryConversion;
    property CapPowerReporting: Integer read Get_CapPowerReporting;
    property CheckHealthText: WideString read Get_CheckHealthText;
    property Claimed: WordBool read Get_Claimed;
    property DeviceEnabled: WordBool read Get_DeviceEnabled write Set_DeviceEnabled;
    property FreezeEvents: WordBool read Get_FreezeEvents write Set_FreezeEvents;
    property OutputID: Integer read Get_OutputID;
    property PowerNotify: Integer read Get_PowerNotify write Set_PowerNotify;
    property PowerState: Integer read Get_PowerState;
    property ResultCode: Integer read Get_ResultCode;
    property ResultCodeExtended: Integer read Get_ResultCodeExtended;
    property State: Integer read Get_State;
    property ControlObjectDescription: WideString read Get_ControlObjectDescription;
    property ControlObjectVersion: Integer read Get_ControlObjectVersion;
    property ServiceObjectDescription: WideString read Get_ServiceObjectDescription;
    property ServiceObjectVersion: Integer read Get_ServiceObjectVersion;
    property DeviceDescription: WideString read Get_DeviceDescription;
    property DeviceName: WideString read Get_DeviceName;
    property AmountDecimalPlaces: Integer read Get_AmountDecimalPlaces;
    property AsyncMode: WordBool read Get_AsyncMode write Set_AsyncMode;
    property CapAdditionalLines: WordBool read Get_CapAdditionalLines;
    property CapAmountAdjustment: WordBool read Get_CapAmountAdjustment;
    property CapAmountNotPaid: WordBool read Get_CapAmountNotPaid;
    property CapCheckTotal: WordBool read Get_CapCheckTotal;
    property CapCoverSensor: WordBool read Get_CapCoverSensor;
    property CapDoubleWidth: WordBool read Get_CapDoubleWidth;
    property CapDuplicateReceipt: WordBool read Get_CapDuplicateReceipt;
    property CapFixedOutput: WordBool read Get_CapFixedOutput;
    property CapHasVatTable: WordBool read Get_CapHasVatTable;
    property CapIndependentHeader: WordBool read Get_CapIndependentHeader;
    property CapItemList: WordBool read Get_CapItemList;
    property CapJrnEmptySensor: WordBool read Get_CapJrnEmptySensor;
    property CapJrnNearEndSensor: WordBool read Get_CapJrnNearEndSensor;
    property CapJrnPresent: WordBool read Get_CapJrnPresent;
    property CapNonFiscalMode: WordBool read Get_CapNonFiscalMode;
    property CapOrderAdjustmentFirst: WordBool read Get_CapOrderAdjustmentFirst;
    property CapPercentAdjustment: WordBool read Get_CapPercentAdjustment;
    property CapPositiveAdjustment: WordBool read Get_CapPositiveAdjustment;
    property CapPowerLossReport: WordBool read Get_CapPowerLossReport;
    property CapPredefinedPaymentLines: WordBool read Get_CapPredefinedPaymentLines;
    property CapReceiptNotPaid: WordBool read Get_CapReceiptNotPaid;
    property CapRecEmptySensor: WordBool read Get_CapRecEmptySensor;
    property CapRecNearEndSensor: WordBool read Get_CapRecNearEndSensor;
    property CapRecPresent: WordBool read Get_CapRecPresent;
    property CapRemainingFiscalMemory: WordBool read Get_CapRemainingFiscalMemory;
    property CapReservedWord: WordBool read Get_CapReservedWord;
    property CapSetHeader: WordBool read Get_CapSetHeader;
    property CapSetPOSID: WordBool read Get_CapSetPOSID;
    property CapSetStoreFiscalID: WordBool read Get_CapSetStoreFiscalID;
    property CapSetTrailer: WordBool read Get_CapSetTrailer;
    property CapSetVatTable: WordBool read Get_CapSetVatTable;
    property CapSlpEmptySensor: WordBool read Get_CapSlpEmptySensor;
    property CapSlpFiscalDocument: WordBool read Get_CapSlpFiscalDocument;
    property CapSlpFullSlip: WordBool read Get_CapSlpFullSlip;
    property CapSlpNearEndSensor: WordBool read Get_CapSlpNearEndSensor;
    property CapSlpPresent: WordBool read Get_CapSlpPresent;
    property CapSlpValidation: WordBool read Get_CapSlpValidation;
    property CapSubAmountAdjustment: WordBool read Get_CapSubAmountAdjustment;
    property CapSubPercentAdjustment: WordBool read Get_CapSubPercentAdjustment;
    property CapSubtotal: WordBool read Get_CapSubtotal;
    property CapTrainingMode: WordBool read Get_CapTrainingMode;
    property CapValidateJournal: WordBool read Get_CapValidateJournal;
    property CapXReport: WordBool read Get_CapXReport;
    property CheckTotal: WordBool read Get_CheckTotal write Set_CheckTotal;
    property CountryCode: Integer read Get_CountryCode;
    property CoverOpen: WordBool read Get_CoverOpen;
    property DayOpened: WordBool read Get_DayOpened;
    property DescriptionLength: Integer read Get_DescriptionLength;
    property DuplicateReceipt: WordBool read Get_DuplicateReceipt write Set_DuplicateReceipt;
    property ErrorLevel: Integer read Get_ErrorLevel;
    property ErrorOutID: Integer read Get_ErrorOutID;
    property ErrorState: Integer read Get_ErrorState;
    property ErrorStation: Integer read Get_ErrorStation;
    property ErrorString: WideString read Get_ErrorString;
    property FlagWhenIdle: WordBool read Get_FlagWhenIdle write Set_FlagWhenIdle;
    property JrnEmpty: WordBool read Get_JrnEmpty;
    property JrnNearEnd: WordBool read Get_JrnNearEnd;
    property MessageLength: Integer read Get_MessageLength;
    property NumHeaderLines: Integer read Get_NumHeaderLines;
    property NumTrailerLines: Integer read Get_NumTrailerLines;
    property NumVatRates: Integer read Get_NumVatRates;
    property PredefinedPaymentLines: WideString read Get_PredefinedPaymentLines;
    property PrinterState: Integer read Get_PrinterState;
    property QuantityDecimalPlaces: Integer read Get_QuantityDecimalPlaces;
    property QuantityLength: Integer read Get_QuantityLength;
    property RecEmpty: WordBool read Get_RecEmpty;
    property RecNearEnd: WordBool read Get_RecNearEnd;
    property RemainingFiscalMemory: Integer read Get_RemainingFiscalMemory;
    property ReservedWord: WideString read Get_ReservedWord;
    property SlipSelection: Integer read Get_SlipSelection write Set_SlipSelection;
    property SlpEmpty: WordBool read Get_SlpEmpty;
    property SlpNearEnd: WordBool read Get_SlpNearEnd;
    property TrainingModeActive: WordBool read Get_TrainingModeActive;
    property ActualCurrency: Integer read Get_ActualCurrency;
    property AdditionalHeader: WideString read Get_AdditionalHeader write Set_AdditionalHeader;
    property AdditionalTrailer: WideString read Get_AdditionalTrailer write Set_AdditionalTrailer;
    property CapAdditionalHeader: WordBool read Get_CapAdditionalHeader;
    property CapAdditionalTrailer: WordBool read Get_CapAdditionalTrailer;
    property CapChangeDue: WordBool read Get_CapChangeDue;
    property CapEmptyReceiptIsVoidable: WordBool read Get_CapEmptyReceiptIsVoidable;
    property CapFiscalReceiptStation: WordBool read Get_CapFiscalReceiptStation;
    property CapFiscalReceiptType: WordBool read Get_CapFiscalReceiptType;
    property CapMultiContractor: WordBool read Get_CapMultiContractor;
    property CapOnlyVoidLastItem: WordBool read Get_CapOnlyVoidLastItem;
    property CapPackageAdjustment: WordBool read Get_CapPackageAdjustment;
    property CapPostPreLine: WordBool read Get_CapPostPreLine;
    property CapSetCurrency: WordBool read Get_CapSetCurrency;
    property CapTotalizerType: WordBool read Get_CapTotalizerType;
    property ChangeDue: WideString read Get_ChangeDue write Set_ChangeDue;
    property ContractorId: Integer read Get_ContractorId write Set_ContractorId;
    property DateType: Integer read Get_DateType write Set_DateType;
    property FiscalReceiptStation: Integer read Get_FiscalReceiptStation write Set_FiscalReceiptStation;
    property FiscalReceiptType: Integer read Get_FiscalReceiptType write Set_FiscalReceiptType;
    property MessageType: Integer read Get_MessageType write Set_MessageType;
    property PostLine: WideString read Get_PostLine write Set_PostLine;
    property PreLine: WideString read Get_PreLine write Set_PreLine;
    property TotalizerType: Integer read Get_TotalizerType write Set_TotalizerType;
  public
    // IOPOSFiscalPrinter_1_8
    function Get_CapStatisticsReporting: WordBool; safecall;
    function Get_CapUpdateStatistics: WordBool; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    property CapStatisticsReporting: WordBool read Get_CapStatisticsReporting;
    property CapUpdateStatistics: WordBool read Get_CapUpdateStatistics;
  public
    // IOPOSFiscalPrinter_1_9
    function Get_CapCompareFirmwareVersion: WordBool; safecall;
    function Get_CapUpdateFirmware: WordBool; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    property CapCompareFirmwareVersion: WordBool read Get_CapCompareFirmwareVersion;
    property CapUpdateFirmware: WordBool read Get_CapUpdateFirmware;
  public
    // IOPOSFiscalPrinter_1_11
    function Get_CapPositiveSubtotalAdjustment: WordBool; safecall;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; safecall;
    property CapPositiveSubtotalAdjustment: WordBool read Get_CapPositiveSubtotalAdjustment;
  public
    // IOPOSFiscalPrinter_1_12
    function PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; safecall;
    function PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; safecall;
  public
    function LoadLogo(const FileName: WideString): Integer; safecall;
    function PrintLogo: Integer; safecall;
    function PrintSeparator(Height: Integer): Integer; overload; safecall;
    function PrintSeparator(Height, SeparatorType: Integer): Integer; overload; safecall;
    function CommandStr(Code: Integer; const InParams: WideString; var OutParams: WideString): Integer;
    function CommandStr2(Code: Integer; const InParams: WideString; var OutParams: WideString): Integer;
    function ReadCashRegister(RegisterNumber: Integer): Int64;
    procedure DisableNextHeader;
    function FSWriteTLV(const Data: WideString): Integer;
    function FSWriteTag(TagID: Integer; const Data: WideString): Integer;
    function FSWriteTagOperation(TagID: Integer; const Data: WideString): Integer;
    function WriteCustomerAddress(const Address: WideString): Integer;
    function PrintText(const Text: WideString; Font: Integer): Integer;
    function ReadTable(Table, Row, Field: Integer; var Value: WideString): Integer;
    function FSPrintCalcReport: Integer;
    function STLVBegin(TagNumber: Integer): Integer;
    function STLVAddTag(TagNumber: Integer; const TagValue: string): Integer;
    function STLVWrite: Integer;
    function STLVWriteOp: Integer;
    function STLVGetHex: string;

    property FontNumber: Integer read Get_FontNumber write Set_FontNumber;
  end;

  { FiscalPrinterError }

  FiscalPrinterError = class(WideException);

implementation

function BoolToStr(Value: Boolean): WideString;
begin
  if Value then
    Result := '1'
  else
    Result := '0';
end;

function StrToBool(const Value: WideString): Boolean;
begin
  Result := Value <> '0';
end;

///////////////////////////////////////////////////////////////////////////////
//
// Wrapper class to encode - decode WideStrings and to implement DirectIO features
//
// Appliication -> Encode WideStrings -> Driver
// Appliication <- Decode WideStrings <- Driver
//
///////////////////////////////////////////////////////////////////////////////

{ TSMFiscalPrinter }

constructor TSMFiscalPrinter.Create;
begin
  inherited Create;
  FLogger := TLogFile.Create;
end;

destructor TSMFiscalPrinter.Destroy;
begin
  if FDriver <> nil then
    FDriver.Close;
  FDriver.Free;
  FLogger := nil;
  inherited Destroy;
end;

function TSMFiscalPrinter.DecodeString(const Text: WideString): WideString;
begin
  Result := DecodeText(FEncoding, Text);
end;

function TSMFiscalPrinter.EncodeString(const Text: WideString): WideString;
begin
  Result := EncodeText(FEncoding, Text);
end;

function TSMFiscalPrinter.GetDriver: TOPOSFiscalPrinter;
begin
  if FDriver = nil then
  begin
    try
      FDriver := TOPOSFiscalPrinter.Create(nil);
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object FiscalPrinter:'#13#10 + E.Message;
        raise;
      end;
    end;
  end;
  Result := FDriver;
end;

// IOPOSFiscalPrinter_1_6

procedure TSMFiscalPrinter.SODataDummy(Status: Integer);
begin
  Driver.SODataDummy(Status);
end;

procedure TSMFiscalPrinter.SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString);
begin
  pString := EncodeString(pString);
  Driver.SODirectIO(EventNumber, pData, pString);
  pString := DecodeString(pString);
end;

procedure TSMFiscalPrinter.SOOutputComplete(OutputID: Integer);
begin
  Driver.SOOutputComplete(OutputID);
end;

procedure TSMFiscalPrinter.SOStatusUpdate(Data: Integer);
begin
  Driver.SOStatusUpdate(Data);
end;

function TSMFiscalPrinter.SOProcessID: Integer;
begin
  Result := Driver.SOProcessID;
end;

function TSMFiscalPrinter.Get_OpenResult: Integer;
begin
  Result := Driver.OpenResult;
end;

function TSMFiscalPrinter.Get_BinaryConversion: Integer;
begin
  Result := Driver.BinaryConversion;
end;

procedure TSMFiscalPrinter.Set_BinaryConversion(Value: Integer);
begin
  Driver.BinaryConversion := Value;
end;

function TSMFiscalPrinter.Get_CapPowerReporting: Integer;
begin
  Result := Driver.CapPowerReporting;
end;

function TSMFiscalPrinter.Get_CheckHealthText: WideString;
begin
  Result := DecodeString(Driver.CheckHealthText);
end;

function TSMFiscalPrinter.Get_Claimed: WordBool;
begin
  Result := Driver.Claimed;
end;

function TSMFiscalPrinter.Get_DeviceEnabled: WordBool;
begin
  Result := Driver.DeviceEnabled;
end;

procedure TSMFiscalPrinter.Set_DeviceEnabled(Value: WordBool);
begin
  Driver.DeviceEnabled := Value;
end;

function TSMFiscalPrinter.Get_FreezeEvents: WordBool;
begin
  Result := Driver.FreezeEvents;
end;

procedure TSMFiscalPrinter.Set_FreezeEvents(Value: WordBool);
begin
  Driver.FreezeEvents := Value;
end;

function TSMFiscalPrinter.Get_OutputID: Integer;
begin
  Result := Driver.OutputID;
end;

function TSMFiscalPrinter.Get_PowerNotify: Integer;
begin
  Result := Driver.PowerNotify;
end;

procedure TSMFiscalPrinter.Set_PowerNotify(Value: Integer);
begin
  Driver.PowerNotify := Value;
end;

function TSMFiscalPrinter.Get_PowerState: Integer;
begin
  Result := Driver.PowerState;
end;

function TSMFiscalPrinter.Get_ResultCode: Integer;
begin
  Result := Driver.ResultCode;
end;

function TSMFiscalPrinter.Get_ResultCodeExtended: Integer;
begin
  Result := Driver.ResultCodeExtended;
end;

function TSMFiscalPrinter.Get_State: Integer;
begin
  Result := Driver.State;
end;

function TSMFiscalPrinter.Get_ControlObjectDescription: WideString;
begin
  Result := DecodeString(Driver.ControlObjectDescription);
end;

function TSMFiscalPrinter.Get_ControlObjectVersion: Integer;
begin
  Result := Driver.ControlObjectVersion;
end;

function TSMFiscalPrinter.Get_ServiceObjectDescription: WideString;
begin
  Result := DecodeString(Driver.ServiceObjectDescription);
end;

function TSMFiscalPrinter.Get_ServiceObjectVersion: Integer;
begin
  Result := Driver.ServiceObjectVersion;
end;

function TSMFiscalPrinter.Get_DeviceDescription: WideString;
begin
  Result := DecodeString(Driver.DeviceDescription);
end;

function TSMFiscalPrinter.Get_DeviceName: WideString;
begin
  Result := DecodeString(Driver.DeviceName);
end;

function TSMFiscalPrinter.CheckHealth(Level: Integer): Integer;
begin
  Result := Driver.CheckHealth(Level);
end;

function TSMFiscalPrinter.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := Driver.ClaimDevice(Timeout);
end;

function TSMFiscalPrinter.ClearOutput: Integer;
begin
  Result := Driver.ClearOutput;
end;

function TSMFiscalPrinter.Close: Integer;
begin
  Result := Driver.Close;
  if Result = 0 then
  begin
    FDriver.Free;
    FDriver := nil;
    CoFreeUnusedLibraries;
  end;
end;

function TSMFiscalPrinter.DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
begin
  pString := EncodeString(pString);
  Result := Driver.DirectIO(Command, pData, pString);
  pString := DecodeString(pString);
end;

function TSMFiscalPrinter.GetData2(DataItem: Integer; const OptArgs: Integer; const Data: WideString): Integer;
var
  pData: WideString;
  pOptArgs: Integer;
begin
  pOptArgs := OptArgs;
  pData := Data;
  Result := Driver.GetData(DataItem, pOptArgs, pData);
end;

function TSMFiscalPrinter.DirectIO2(Command: Integer; const pData: Integer; const pString: WideString): Integer;
var
  pData2: Integer;
  pString2: WideString;
begin
  pData2 := pData;
  pString2 := EncodeString(pString);
  Result := Driver.DirectIO(Command, pData2, pString2);
end;

function TSMFiscalPrinter.Open(const DeviceName: WideString): Integer;
begin
  Result := Driver.Open(EncodeString(DeviceName));
  FEncoding := ReadEncoding(DeviceName, Logger);
end;

function TSMFiscalPrinter.ReleaseDevice: Integer;
begin
  Result := Driver.ReleaseDevice;
end;

function TSMFiscalPrinter.Get_AmountDecimalPlaces: Integer;
begin
  Result := Driver.AmountDecimalPlaces;
end;

function TSMFiscalPrinter.Get_AsyncMode: WordBool;
begin
  Result := Driver.AsyncMode;
end;

procedure TSMFiscalPrinter.Set_AsyncMode(Value: WordBool);
begin
  Driver.AsyncMode := Value;
end;

function TSMFiscalPrinter.Get_CapAdditionalLines: WordBool;
begin
  Result := Driver.CapAdditionalLines;
end;

function TSMFiscalPrinter.Get_CapAmountAdjustment: WordBool;
begin
  Result := Driver.CapAmountAdjustment;
end;

function TSMFiscalPrinter.Get_CapAmountNotPaid: WordBool;
begin
  Result := Driver.CapAmountNotPaid;
end;

function TSMFiscalPrinter.Get_CapCheckTotal: WordBool;
begin
  Result := Driver.CapCheckTotal;
end;

function TSMFiscalPrinter.Get_CapCoverSensor: WordBool;
begin
  Result := Driver.CapCoverSensor;
end;

function TSMFiscalPrinter.Get_CapDoubleWidth: WordBool;
begin
  Result := Driver.CapDoubleWidth;
end;

function TSMFiscalPrinter.Get_CapDuplicateReceipt: WordBool;
begin
  Result := Driver.CapDuplicateReceipt;
end;

function TSMFiscalPrinter.Get_CapFixedOutput: WordBool;
begin
  Result := Driver.CapFixedOutput;
end;

function TSMFiscalPrinter.Get_CapHasVatTable: WordBool;
begin
  Result := Driver.CapHasVatTable;
end;

function TSMFiscalPrinter.Get_CapIndependentHeader: WordBool;
begin
  Result := Driver.CapIndependentHeader;
end;

function TSMFiscalPrinter.Get_CapItemList: WordBool;
begin
  Result := Driver.CapItemList;
end;

function TSMFiscalPrinter.Get_CapJrnEmptySensor: WordBool;
begin
  Result := Driver.CapJrnEmptySensor;
end;

function TSMFiscalPrinter.Get_CapJrnNearEndSensor: WordBool;
begin
  Result := Driver.CapJrnNearEndSensor;
end;

function TSMFiscalPrinter.Get_CapJrnPresent: WordBool;
begin
  Result := Driver.CapJrnPresent;
end;

function TSMFiscalPrinter.Get_CapNonFiscalMode: WordBool;
begin
  Result := Driver.CapNonFiscalMode;
end;

function TSMFiscalPrinter.Get_CapOrderAdjustmentFirst: WordBool;
begin
  Result := Driver.CapOrderAdjustmentFirst;
end;

function TSMFiscalPrinter.Get_CapPercentAdjustment: WordBool;
begin
  Result := Driver.CapPercentAdjustment;
end;

function TSMFiscalPrinter.Get_CapPositiveAdjustment: WordBool;
begin
  Result := Driver.CapPositiveAdjustment;
end;

function TSMFiscalPrinter.Get_CapPowerLossReport: WordBool;
begin
  Result := Driver.CapPowerLossReport;
end;

function TSMFiscalPrinter.Get_CapPredefinedPaymentLines: WordBool;
begin
  Result := Driver.CapPredefinedPaymentLines;
end;

function TSMFiscalPrinter.Get_CapReceiptNotPaid: WordBool;
begin
  Result := Driver.CapReceiptNotPaid;
end;

function TSMFiscalPrinter.Get_CapRecEmptySensor: WordBool;
begin
  Result := Driver.CapRecEmptySensor;
end;

function TSMFiscalPrinter.Get_CapRecNearEndSensor: WordBool;
begin
  Result := Driver.CapRecNearEndSensor;
end;

function TSMFiscalPrinter.Get_CapRecPresent: WordBool;
begin
  Result := Driver.CapRecPresent;
end;

function TSMFiscalPrinter.Get_CapRemainingFiscalMemory: WordBool;
begin
  Result := Driver.CapRemainingFiscalMemory;
end;

function TSMFiscalPrinter.Get_CapReservedWord: WordBool;
begin
  Result := Driver.CapReservedWord;
end;

function TSMFiscalPrinter.Get_CapSetHeader: WordBool;
begin
  Result := Driver.CapSetHeader;
end;

function TSMFiscalPrinter.Get_CapSetPOSID: WordBool;
begin
  Result := Driver.CapSetPOSID;
end;

function TSMFiscalPrinter.Get_CapSetStoreFiscalID: WordBool;
begin
  Result := Driver.CapSetStoreFiscalID;
end;

function TSMFiscalPrinter.Get_CapSetTrailer: WordBool;
begin
  Result := Driver.CapSetTrailer;
end;

function TSMFiscalPrinter.Get_CapSetVatTable: WordBool;
begin
  Result := Driver.CapSetVatTable;
end;

function TSMFiscalPrinter.Get_CapSlpEmptySensor: WordBool;
begin
  Result := Driver.CapSlpEmptySensor;
end;

function TSMFiscalPrinter.Get_CapSlpFiscalDocument: WordBool;
begin
  Result := Driver.CapSlpFiscalDocument;
end;

function TSMFiscalPrinter.Get_CapSlpFullSlip: WordBool;
begin
  Result := Driver.CapSlpFullSlip;
end;

function TSMFiscalPrinter.Get_CapSlpNearEndSensor: WordBool;
begin
  Result := Driver.CapSlpNearEndSensor;
end;

function TSMFiscalPrinter.Get_CapSlpPresent: WordBool;
begin
  Result := Driver.CapSlpPresent;
end;

function TSMFiscalPrinter.Get_CapSlpValidation: WordBool;
begin
  Result := Driver.CapSlpValidation;
end;

function TSMFiscalPrinter.Get_CapSubAmountAdjustment: WordBool;
begin
  Result := Driver.CapSubAmountAdjustment;
end;

function TSMFiscalPrinter.Get_CapSubPercentAdjustment: WordBool;
begin
  Result := Driver.CapSubPercentAdjustment;
end;

function TSMFiscalPrinter.Get_CapSubtotal: WordBool;
begin
  Result := Driver.CapSubtotal;
end;

function TSMFiscalPrinter.Get_CapTrainingMode: WordBool;
begin
  Result := Driver.CapTrainingMode;
end;

function TSMFiscalPrinter.Get_CapValidateJournal: WordBool;
begin
  Result := Driver.CapValidateJournal;
end;

function TSMFiscalPrinter.Get_CapXReport: WordBool;
begin
  Result := Driver.CapXReport;
end;

function TSMFiscalPrinter.Get_CheckTotal: WordBool;
begin
  Result := Driver.CheckTotal;
end;

procedure TSMFiscalPrinter.Set_CheckTotal(Value: WordBool);
begin
  Driver.CheckTotal := Value;
end;

function TSMFiscalPrinter.Get_CountryCode: Integer;
begin
  Result := Driver.CountryCode;
end;

function TSMFiscalPrinter.Get_CoverOpen: WordBool;
begin
  Result := Driver.CoverOpen;
end;

function TSMFiscalPrinter.Get_DayOpened: WordBool;
begin
  Result := Driver.DayOpened;
end;

function TSMFiscalPrinter.Get_DescriptionLength: Integer;
begin
  Result := Driver.DescriptionLength;
end;

function TSMFiscalPrinter.Get_DuplicateReceipt: WordBool;
begin
  Result := Driver.DuplicateReceipt;
end;

procedure TSMFiscalPrinter.Set_DuplicateReceipt(pDuplicateReceipt: WordBool);
begin
  Driver.DuplicateReceipt := pDuplicateReceipt;
end;

function TSMFiscalPrinter.Get_ErrorLevel: Integer;
begin
  Result := Driver.ErrorLevel;
end;

function TSMFiscalPrinter.Get_ErrorOutID: Integer;
begin
  Result := Driver.ErrorOutID;
end;

function TSMFiscalPrinter.Get_ErrorState: Integer;
begin
  Result := Driver.ErrorState;
end;

function TSMFiscalPrinter.Get_ErrorStation: Integer;
begin
  Result := Driver.ErrorStation;
end;

function TSMFiscalPrinter.Get_ErrorString: WideString;
begin
  Result := DecodeString(Driver.ErrorString);
end;

function TSMFiscalPrinter.Get_FlagWhenIdle: WordBool;
begin
  Result := Driver.FlagWhenIdle;
end;

procedure TSMFiscalPrinter.Set_FlagWhenIdle(pFlagWhenIdle: WordBool);
begin
  Driver.FlagWhenIdle := pFlagWhenIdle;
end;

function TSMFiscalPrinter.Get_JrnEmpty: WordBool;
begin
  Result := Driver.JrnEmpty;
end;

function TSMFiscalPrinter.Get_JrnNearEnd: WordBool;
begin
  Result := Driver.JrnNearEnd;
end;

function TSMFiscalPrinter.Get_MessageLength: Integer;
begin
  Result := Driver.MessageLength;
end;

function TSMFiscalPrinter.Get_NumHeaderLines: Integer;
begin
  Result := Driver.NumHeaderLines;
end;

function TSMFiscalPrinter.Get_NumTrailerLines: Integer;
begin
  Result := Driver.NumTrailerLines;
end;

function TSMFiscalPrinter.Get_NumVatRates: Integer;
begin
  Result := Driver.NumVatRates;
end;

function TSMFiscalPrinter.Get_PredefinedPaymentLines: WideString;
begin
  Result := DecodeString(Driver.PredefinedPaymentLines);
end;

function TSMFiscalPrinter.Get_PrinterState: Integer;
begin
  Result := Driver.PrinterState;
end;

function TSMFiscalPrinter.Get_QuantityDecimalPlaces: Integer;
begin
  Result := Driver.QuantityDecimalPlaces;
end;

function TSMFiscalPrinter.Get_QuantityLength: Integer;
begin
  Result := Driver.QuantityLength;
end;

function TSMFiscalPrinter.Get_RecEmpty: WordBool;
begin
  Result := Driver.RecEmpty;
end;

function TSMFiscalPrinter.Get_RecNearEnd: WordBool;
begin
  Result := Driver.RecNearEnd;
end;

function TSMFiscalPrinter.Get_RemainingFiscalMemory: Integer;
begin
  Result := Driver.RemainingFiscalMemory;
end;

function TSMFiscalPrinter.Get_ReservedWord: WideString;
begin
  Result := DecodeString(Driver.ReservedWord);
end;

function TSMFiscalPrinter.Get_SlipSelection: Integer;
begin
  Result := Driver.SlipSelection;
end;

procedure TSMFiscalPrinter.Set_SlipSelection(pSlipSelection: Integer);
begin
  Driver.SlipSelection := pSlipSelection;
end;

function TSMFiscalPrinter.Get_SlpEmpty: WordBool;
begin
  Result := Driver.SlpEmpty;
end;

function TSMFiscalPrinter.Get_SlpNearEnd: WordBool;
begin
  Result := Driver.SlpNearEnd;
end;

function TSMFiscalPrinter.Get_TrainingModeActive: WordBool;
begin
  Result := Driver.TrainingModeActive;
end;

function TSMFiscalPrinter.BeginFiscalDocument(DocumentAmount: Integer): Integer;
begin
  Result := Driver.BeginFiscalDocument(DocumentAmount);
end;

function TSMFiscalPrinter.BeginFiscalReceipt(PrintHeader: WordBool): Integer;
begin
  Result := Driver.BeginFiscalReceipt(PrintHeader);
end;

function TSMFiscalPrinter.BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer;
begin
  Result := Driver.BeginFixedOutput(Station, DocumentType);
end;

function TSMFiscalPrinter.BeginInsertion(Timeout: Integer): Integer;
begin
  Result := Driver.BeginInsertion(Timeout);
end;

function TSMFiscalPrinter.BeginItemList(VatID: Integer): Integer;
begin
  Result := Driver.BeginItemList(VatID);
end;

function TSMFiscalPrinter.BeginNonFiscal: Integer;
begin
  Result := Driver.BeginNonFiscal;
end;

function TSMFiscalPrinter.BeginRemoval(Timeout: Integer): Integer;
begin
  Result := Driver.BeginRemoval(Timeout);
end;

function TSMFiscalPrinter.BeginTraining: Integer;
begin
  Result := Driver.BeginTraining;
end;

function TSMFiscalPrinter.ClearError: Integer;
begin
  Result := Driver.ClearError;
end;

function TSMFiscalPrinter.EndFiscalDocument: Integer;
begin
  Result := Driver.EndFiscalDocument;
end;

function TSMFiscalPrinter.EndFiscalReceipt(PrintHeader: WordBool): Integer;
begin
  Result := Driver.EndFiscalReceipt(PrintHeader);
end;

function TSMFiscalPrinter.EndFixedOutput: Integer;
begin
  Result := Driver.EndFixedOutput;
end;

function TSMFiscalPrinter.EndInsertion: Integer;
begin
  Result := Driver.EndInsertion;
end;

function TSMFiscalPrinter.EndItemList: Integer;
begin
  Result := Driver.EndItemList;
end;

function TSMFiscalPrinter.EndNonFiscal: Integer;
begin
  Result := Driver.EndNonFiscal;
end;

function TSMFiscalPrinter.EndRemoval: Integer;
begin
  Result := Driver.EndRemoval;
end;

function TSMFiscalPrinter.EndTraining: Integer;
begin
  Result := Driver.EndTraining;
end;

function TSMFiscalPrinter.GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer;
begin
  Result := Driver.GetData(DataItem, OptArgs, Data);
  Data := DecodeString(Data);
end;

function TSMFiscalPrinter.GetDate(out Date: WideString): Integer;
begin
  Result := Driver.GetDate(Date);
  Date := DecodeString(Date);
end;

function TSMFiscalPrinter.GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer;
begin
  Result := Driver.GetTotalizer(VatID, OptArgs, Data);
  Data := DecodeString(Data);
end;

function TSMFiscalPrinter.GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer;
begin
  Result := Driver.GetVatEntry(VatID, OptArgs, VatRate);
end;

function TSMFiscalPrinter.PrintDuplicateReceipt: Integer;
begin
  Result := Driver.PrintDuplicateReceipt;
end;

function TSMFiscalPrinter.PrintFiscalDocumentLine(const DocumentLine: WideString): Integer;
begin
  Result := Driver.PrintFiscalDocumentLine(EncodeString(DocumentLine));
end;

function TSMFiscalPrinter.PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer;
begin
  Result := Driver.PrintFixedOutput(DocumentType, LineNumber, EncodeString(Data));
end;

function TSMFiscalPrinter.PrintNormal(Station: Integer; const Data: WideString): Integer;
begin
  Result := Driver.PrintNormal(Station, EncodeString(Data));
end;

function TSMFiscalPrinter.PrintNormal(Station, Font: Integer; const Data: WideString): Integer;
begin
  Set_FontNumber(Font);
  Result := Driver.PrintNormal(Station, EncodeString(Data));
end;

function TSMFiscalPrinter.PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer;
begin
  Result := Driver.PrintPeriodicTotalsReport(EncodeString(Date1), EncodeString(Date2));
end;

function TSMFiscalPrinter.PrintPowerLossReport: Integer;
begin
  Result := Driver.PrintPowerLossReport;
end;

function TSMFiscalPrinter.PrintRecMessage(const Message: WideString): Integer;
begin
  Result := Driver.PrintRecMessage(EncodeString(Message));
end;

function TSMFiscalPrinter.PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer;
begin
  Result := Driver.PrintRecNotPaid(EncodeString(Description), Amount);
end;

function TSMFiscalPrinter.PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer;
begin
  Result := Driver.PrintRecRefund(EncodeString(Description), Amount, VatInfo);
end;

function TSMFiscalPrinter.PrintRecSubtotal(Amount: Currency): Integer;
begin
  Result := Driver.PrintRecSubtotal(Amount);
end;

function TSMFiscalPrinter.PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer;
begin
  Result := Driver.PrintRecTotal(Total, Payment, EncodeString(Description));
end;

function TSMFiscalPrinter.PrintRecVoid(const Description: WideString): Integer;
begin
  Result := Driver.PrintRecVoid(EncodeString(Description));
end;

function TSMFiscalPrinter.PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer;
begin
  Result := Driver.PrintReport(ReportType, EncodeString(StartNum), EncodeString(EndNum));
end;

function TSMFiscalPrinter.PrintXReport: Integer;
begin
  Result := Driver.PrintXReport;
end;

function TSMFiscalPrinter.PrintZReport: Integer;
begin
  Result := Driver.PrintZReport;
end;

function TSMFiscalPrinter.ResetPrinter: Integer;
begin
  Result := Driver.ResetPrinter;
end;

function TSMFiscalPrinter.SetDate(const Date: WideString): Integer;
begin
  Result := Driver.SetDate(EncodeString(Date));
end;

function TSMFiscalPrinter.SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer;
begin
  Result := Driver.SetHeaderLine(LineNumber, EncodeString(Text), DoubleWidth);
end;

function TSMFiscalPrinter.SetPOSID(const POSID: WideString; const CashierID: WideString): Integer;
begin
  Result := Driver.SetPOSID(EncodeString(POSID), EncodeString(CashierID));
end;

function TSMFiscalPrinter.SetStoreFiscalID(const ID: WideString): Integer;
begin
  Result := Driver.SetStoreFiscalID(EncodeString(ID));
end;

function TSMFiscalPrinter.SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer;
begin
  Result := Driver.SetTrailerLine(LineNumber, EncodeString(Text), DoubleWidth);
end;

function TSMFiscalPrinter.SetVatTable: Integer;
begin
  Result := Driver.SetVatTable;
end;

function TSMFiscalPrinter.SetVatValue(VatID: Integer; const VatValue: WideString): Integer;
begin
  Result := Driver.SetVatValue(VatID, EncodeString(VatValue));
end;

function TSMFiscalPrinter.VerifyItem(const ItemName: WideString; VatID: Integer): Integer;
begin
  Result := Driver.VerifyItem(EncodeString(ItemName), VatID);
end;

function TSMFiscalPrinter.Get_ActualCurrency: Integer;
begin
  Result := Driver.ActualCurrency;
end;

function TSMFiscalPrinter.Get_AdditionalHeader: WideString;
begin
  Result := DecodeString(Driver.AdditionalHeader);
end;

procedure TSMFiscalPrinter.Set_AdditionalHeader(const pAdditionalHeader: WideString);
begin
  Driver.AdditionalHeader := EncodeString(pAdditionalHeader);
end;

function TSMFiscalPrinter.Get_AdditionalTrailer: WideString;
begin
  Result := DecodeString(Driver.AdditionalTrailer);
end;

procedure TSMFiscalPrinter.Set_AdditionalTrailer(const pAdditionalTrailer: WideString);
begin
  Driver.AdditionalTrailer := EncodeString(pAdditionalTrailer);
end;

function TSMFiscalPrinter.Get_CapAdditionalHeader: WordBool;
begin
  Result := Driver.CapAdditionalHeader;
end;

function TSMFiscalPrinter.Get_CapAdditionalTrailer: WordBool;
begin
  Result := Driver.CapAdditionalTrailer;
end;

function TSMFiscalPrinter.Get_CapChangeDue: WordBool;
begin
  Result := Driver.CapChangeDue;
end;

function TSMFiscalPrinter.Get_CapEmptyReceiptIsVoidable: WordBool;
begin
  Result := Driver.CapEmptyReceiptIsVoidable;
end;

function TSMFiscalPrinter.Get_CapFiscalReceiptStation: WordBool;
begin
  Result := Driver.CapFiscalReceiptStation;
end;

function TSMFiscalPrinter.Get_CapFiscalReceiptType: WordBool;
begin
  Result := Driver.CapFiscalReceiptType;
end;

function TSMFiscalPrinter.Get_CapMultiContractor: WordBool;
begin
  Result := Driver.CapMultiContractor;
end;

function TSMFiscalPrinter.Get_CapOnlyVoidLastItem: WordBool;
begin
  Result := Driver.CapOnlyVoidLastItem;
end;

function TSMFiscalPrinter.Get_CapPackageAdjustment: WordBool;
begin
  Result := Driver.CapPackageAdjustment;
end;

function TSMFiscalPrinter.Get_CapPostPreLine: WordBool;
begin
  Result := Driver.CapPostPreLine;
end;

function TSMFiscalPrinter.Get_CapSetCurrency: WordBool;
begin
  Result := Driver.CapSetCurrency;
end;

function TSMFiscalPrinter.Get_CapTotalizerType: WordBool;
begin
  Result := Driver.CapTotalizerType;
end;

function TSMFiscalPrinter.Get_ChangeDue: WideString;
begin
  Result := DecodeString(Driver.ChangeDue);
end;

procedure TSMFiscalPrinter.Set_ChangeDue(const pChangeDue: WideString);
begin
  Driver.ChangeDue := EncodeString(pChangeDue);
end;

function TSMFiscalPrinter.Get_ContractorId: Integer;
begin
  Result := Driver.ContractorId;
end;

procedure TSMFiscalPrinter.Set_ContractorId(pContractorId: Integer);
begin
  Driver.ContractorId := pContractorId;
end;

function TSMFiscalPrinter.Get_DateType: Integer;
begin
  Result := Driver.DateType;
end;

procedure TSMFiscalPrinter.Set_DateType(pDateType: Integer);
begin
  Driver.DateType := pDateType;
end;

function TSMFiscalPrinter.Get_FiscalReceiptStation: Integer;
begin
  Result := Driver.FiscalReceiptStation;
end;

procedure TSMFiscalPrinter.Set_FiscalReceiptStation(pFiscalReceiptStation: Integer);
begin
  Driver.FiscalReceiptStation := pFiscalReceiptStation;
end;

function TSMFiscalPrinter.Get_FiscalReceiptType: Integer;
begin
  Result := Driver.FiscalReceiptType;
end;

procedure TSMFiscalPrinter.Set_FiscalReceiptType(pFiscalReceiptType: Integer);
begin
  Driver.FiscalReceiptType := pFiscalReceiptType;
end;

function TSMFiscalPrinter.Get_MessageType: Integer;
begin
  Result := Driver.MessageType;
end;

procedure TSMFiscalPrinter.Set_MessageType(pMessageType: Integer);
begin
  Driver.MessageType := pMessageType;
end;

function TSMFiscalPrinter.Get_PostLine: WideString;
begin
  Result := DecodeString(Driver.PostLine);
end;

procedure TSMFiscalPrinter.Set_PostLine(const pPostLine: WideString);
begin
  Driver.PostLine := EncodeString(pPostLine);
end;

function TSMFiscalPrinter.Get_PreLine: WideString;
begin
  Result := DecodeString(Driver.PreLine);
end;

procedure TSMFiscalPrinter.Set_PreLine(const pPreLine: WideString);
begin
  Driver.PreLine := EncodeString(pPreLine);
end;

function TSMFiscalPrinter.Get_TotalizerType: Integer;
begin
  Result := Driver.TotalizerType;
end;

procedure TSMFiscalPrinter.Set_TotalizerType(pTotalizerType: Integer);
begin
  Driver.TotalizerType := pTotalizerType;
end;

function TSMFiscalPrinter.PrintRecCash(Amount: Currency): Integer;
begin
  Result := Driver.PrintRecCash(Amount);
end;

function TSMFiscalPrinter.PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer;
begin
  Result := Driver.PrintRecPackageAdjustVoid(AdjustmentType, EncodeString(VatAdjustment));
end;

function TSMFiscalPrinter.PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer;
begin
  Result := Driver.PrintRecRefundVoid(EncodeString(Description), Amount, VatInfo);
end;

function TSMFiscalPrinter.PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer;
begin
  Result := Driver.PrintRecSubtotalAdjustVoid(AdjustmentType, Amount);
end;

function TSMFiscalPrinter.PrintRecTaxID(const TaxID: WideString): Integer;
begin
  Result := Driver.PrintRecTaxID(EncodeString(TaxID));
end;

function TSMFiscalPrinter.SetCurrency(NewCurrency: Integer): Integer;
begin
  Result := Driver.SetCurrency(NewCurrency);
end;

// IOPOSFiscalPrinter_1_8

function TSMFiscalPrinter.Get_CapStatisticsReporting: WordBool;
begin
  Result := Driver.CapStatisticsReporting;
end;

function TSMFiscalPrinter.Get_CapUpdateStatistics: WordBool;
begin
  Result := Driver.CapUpdateStatistics;
end;

function TSMFiscalPrinter.ResetStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := Driver.ResetStatistics(EncodeString(StatisticsBuffer));
end;

function TSMFiscalPrinter.RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
begin
  pStatisticsBuffer := EncodeString(pStatisticsBuffer);
  Result := Driver.RetrieveStatistics(pStatisticsBuffer);
  pStatisticsBuffer := DecodeString(pStatisticsBuffer);
end;

function TSMFiscalPrinter.UpdateStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := Driver.UpdateStatistics(EncodeString(StatisticsBuffer));
end;

// IOPOSFiscalPrinter_1_9

function TSMFiscalPrinter.Get_CapCompareFirmwareVersion: WordBool;
begin
  Result := Driver.CapCompareFirmwareVersion;
end;

function TSMFiscalPrinter.Get_CapUpdateFirmware: WordBool;
begin
  Result := Driver.CapUpdateFirmware;
end;

function TSMFiscalPrinter.CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
begin
  Result := Driver.CompareFirmwareVersion(EncodeString(FirmwareFileName), pResult);
end;

function TSMFiscalPrinter.UpdateFirmware(const FirmwareFileName: WideString): Integer;
begin
  Result := Driver.UpdateFirmware(EncodeString(FirmwareFileName));
end;

// IOPOSFiscalPrinter_1_11

function TSMFiscalPrinter.Get_CapPositiveSubtotalAdjustment: WordBool;
begin
  Result := Driver.CapPositiveSubtotalAdjustment;
end;

function TSMFiscalPrinter.PrintRecItem(const Description: WideString; Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer;
begin
  Result := Driver.PrintRecItem(EncodeString(Description), Price, Quantity, VatInfo, UnitPrice, EncodeString(UnitName));
end;

function TSMFiscalPrinter.PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; Amount: Currency; VatInfo: Integer): Integer;
begin
  Result := Driver.PrintRecItemAdjustment(AdjustmentType, EncodeString(Description), Amount, VatInfo);
end;

function TSMFiscalPrinter.PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; Amount: Currency; VatInfo: Integer): Integer;
begin
  Result := Driver.PrintRecItemAdjustmentVoid(AdjustmentType, EncodeString(Description), Amount, VatInfo);
end;

function TSMFiscalPrinter.PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; SpecialTax: Currency; const SpecialTaxName: WideString): Integer;
begin
  Result := Driver.PrintRecItemFuel(EncodeString(Description), Price, Quantity, VatInfo, UnitPrice, EncodeString(UnitName), SpecialTax, EncodeString(SpecialTaxName));
end;

function TSMFiscalPrinter.PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; SpecialTax: Currency): Integer;
begin
  Result := Driver.PrintRecItemFuelVoid(EncodeString(Description), Price, VatInfo, SpecialTax);
end;

function TSMFiscalPrinter.PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer;
begin
  Result := Driver.PrintRecItemRefund(EncodeString(Description), Amount, Quantity, VatInfo, UnitAmount, EncodeString(UnitName));
end;

function TSMFiscalPrinter.PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer;
begin
  Result := Driver.PrintRecItemRefundVoid(EncodeString(Description), Amount, Quantity, VatInfo, UnitAmount, EncodeString(UnitName));
end;

function TSMFiscalPrinter.PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer;
begin
  Result := Driver.PrintRecItemVoid(EncodeString(Description), Price, Quantity, VatInfo, UnitPrice, EncodeString(UnitName));
end;

function TSMFiscalPrinter.PrintRecPackageAdjustment(AdjustmentType: Integer; const Description, VatAdjustment: WideString): Integer;
begin
  Result := Driver.PrintRecPackageAdjustment(AdjustmentType, EncodeString(Description), EncodeString(VatAdjustment));
end;

function TSMFiscalPrinter.PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; Amount: Currency): Integer;
begin
  Result := Driver.PrintRecSubtotalAdjustment(AdjustmentType, EncodeString(Description), Amount);
end;

function TSMFiscalPrinter.PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity, AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer;
begin
  Result := Driver.PrintRecVoidItem(EncodeString(Description), Amount, Quantity, AdjustmentType, Adjustment, VatInfo);
end;

procedure TSMFiscalPrinter.SOError(ResultCode, ResultCodeExtended, ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  Driver.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

function TSMFiscalPrinter.GetParameter(ParamID: Integer): WideString;
var
  pData: Integer;
  pString: WideString;
begin
  pData := ParamID;
  pString := '';
  Check(Driver.DirectIO(DIO_GET_DRIVER_PARAMETER, pData, pString));
  Result := pString;
end;

function TSMFiscalPrinter.GetIntParameter(ParamID: Integer): Integer;
begin
  Result := StrToInt(GetParameter(ParamID));
end;

function TSMFiscalPrinter.GetBoolParameter(ParamID: Integer): Boolean;
begin
  Result := StrToBool(GetParameter(ParamID));
end;

function TSMFiscalPrinter.SetParameter(ParamID: Integer; const Value: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := ParamID;
  pString := Value;
  Result := Driver.DirectIO(DIO_SET_DRIVER_PARAMETER, pData, pString);
end;

function TSMFiscalPrinter.AddItemBarcode(const Barcode: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := Barcode;
  Result := Driver.DirectIO(DIO_ADD_ITEM_CODE, pData, pString);
end;

function TSMFiscalPrinter.SetParameter(ParamID: Integer; const Value: Integer): Integer;
begin
  Result := SetParameter(ParamID, IntToStr(Value));
end;

function TSMFiscalPrinter.SetIntParameter(ParamID, Value: Integer): Integer;
begin
  Result := SetParameter(ParamID, IntToStr(Value));
end;

function TSMFiscalPrinter.SetBoolParameter(ParamID: Integer; Value: Boolean): Integer;
begin
  Result := SetParameter(ParamID, BoolToStr(Value));
end;

function TSMFiscalPrinter.Get_FontNumber: Integer;
begin
  Result := GetIntParameter(DriverParameterFontNumber);
end;

procedure TSMFiscalPrinter.Set_FontNumber(const Value: Integer);
begin
  SetIntParameter(DriverParameterFontNumber, Value);
end;

function TSMFiscalPrinter.PrintSeparator(Height: Integer): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Height;
  pString := '';
  Result := Driver.DirectIO(DIO_PRINT_SEPARATOR, pData, pString)
end;

function TSMFiscalPrinter.PrintSeparator(Height, SeparatorType: Integer): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Height;
  pString := IntToStr(SeparatorType);
  Result := Driver.DirectIO(DIO_PRINT_SEPARATOR, pData, pString)
end;

function TSMFiscalPrinter.LoadLogo(const FileName: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := FileName;
  Result := Driver.DirectIO(DIO_LOAD_LOGO, pData, pString);
end;

function TSMFiscalPrinter.PrintLogo: Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_PRINT_LOGO, pData, pString);
end;

procedure TSMFiscalPrinter.Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    raise FiscalPrinterError.Create(OposFptrGetErrorText(Driver.OleObject));
  end;
end;

function TSMFiscalPrinter.CommandStr(Code: Integer; const InParams: WideString; var OutParams: WideString): Integer;
var
  P: Integer;
  ResultCode: WideString;
  Params: WideString;
begin
  Params := InParams;
  Check(Driver.DirectIO(DIO_COMMAND_PRINTER_STR, Code, Params));
  P := Pos(';', Params);

  OutParams := Params;
  ResultCode := Params;
  if P <> 0 then
  begin
    OutParams := Copy(Params, P + 1, Length(Params));
    ResultCode := Copy(Params, 1, P - 1);
  end;
  Result := StrToInt(ResultCode);
end;

function TSMFiscalPrinter.CommandStr2(Code: Integer; const InParams: WideString; var OutParams: WideString): Integer;
var
  Params: WideString;
begin
  Params := InParams;
  Result := Driver.DirectIO(DIO_COMMAND_PRINTER_STR2, Code, Params);
  OutParams := Params;
end;

function TSMFiscalPrinter.ReadCashRegister(RegisterNumber: Integer): Int64;
var
  pData: Integer;
  pString: WideString;
begin
  pData := RegisterNumber;
  Check(Driver.DirectIO(DIO_READ_CASH_REG, pData, pString));
  Result := StrToInt64(pString);
end;

procedure TSMFiscalPrinter.PrintImage(const FileName: WideString);
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := FileName;
  Check(Driver.DirectIO(DIO_PRINT_IMAGE, pData, pString));
end;

procedure TSMFiscalPrinter.PrintImageScale(const FileName: WideString; Scale: Integer);
var
  pData: Integer;
  pString: WideString;
begin
  pData := Scale;
  pString := FileName;
  Check(Driver.DirectIO(DIO_PRINT_IMAGE, pData, pString));
end;

procedure TSMFiscalPrinter.PrintBarcode(const Data: WideString; BarcodeType: Integer);
var
  pData: Integer;
  pString: WideString;
begin
  pData := BarcodeType;
  pString := Data;
  Check(Driver.DirectIO(DIO_PRINT_BARCODE, pData, pString));
end;

function TSMFiscalPrinter.PrintBarcode2(const Barcode: TBarcodeRec): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Barcode.BarcodeType;
  pString := Tnt_WideFormat('%s;%s;%d;%d;%d;', [Barcode.Data, Barcode.Text,
    Barcode.Height, Barcode.ModuleWidth, Barcode.Alignment]);
  Result := Driver.DirectIO(DIO_PRINT_BARCODE, pData, pString);
end;

function TSMFiscalPrinter.PrintBarcodeHex(const Barcode: TBarcodeRec): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Barcode.BarcodeType;
  pString := Tnt_WideFormat('%s;%s;%d;%d;%d;', [StrToHexText(Barcode.Data), Barcode.Text, Barcode.Height, Barcode.ModuleWidth, Barcode.Alignment]);
  Result := Driver.DirectIO(DIO_PRINT_BARCODE_HEX, pData, pString);
end;

function TSMFiscalPrinter.PrintBarcodeHex2(const Barcode: TBarcodeRec): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Barcode.BarcodeType;
  pString := Tnt_WideFormat('%s;%s;%d;%d;%d;', [StrToHexText(Barcode.Data), StrToHexText(Barcode.Text), Barcode.Height, Barcode.ModuleWidth, Barcode.Alignment]);
  Result := Driver.DirectIO(DIO_PRINT_BARCODE_HEX2, pData, pString);
end;

function TSMFiscalPrinter.SetAdjustmentAmount(Amount: Integer): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Amount;
  pString := '';
  Result := Driver.DirectIO(DIO_SET_ADJUSTMENT_AMOUNT, pData, pString);
end;

function TSMFiscalPrinter.PrintText(const Text: WideString; Font: Integer): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Font;
  pString := Text;
  Result := Driver.DirectIO(DIO_PRINT_TEXT, pData, pString);
end;

procedure TSMFiscalPrinter.DisableNextHeader;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 1;
  pString := '';
  Driver.DirectIO(DIO_DISABLE_NEXT_HEADER, pData, pString);
end;

function TSMFiscalPrinter.FSWriteTag(TagID: Integer; const Data: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := TagID;
  pString := Data;
  Result := Driver.DirectIO(DIO_WRITE_FS_STRING_TAG, pData, pString);
end;

function TSMFiscalPrinter.FSWriteTagOperation(TagID: Integer; const Data: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := TagID;
  pString := Data;
  Result := Driver.DirectIO(DIO_WRITE_FS_STRING_TAG_OP, pData, pString);
end;

function TSMFiscalPrinter.FSWriteTLV(const Data: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := Data;
  Result := Driver.DirectIO(DIO_WRITE_FS_TLV_DATA, pData, pString);
end;

function TSMFiscalPrinter.WriteCustomerAddress(const Address: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := Address;
  Result := Driver.DirectIO(DIO_WRITE_FS_CUSTOMER_ADDRESS, pData, pString);
end;

function TSMFiscalPrinter.ReadTable(Table, Row, Field: Integer; var Value: WideString): Integer;
var
  pData: Integer;
begin
  pData := 0;
  Value := Tnt_WideFormat('%d;%d;%d', [Table, Row, Field]);
  Result := Driver.DirectIO(DIO_READ_TABLE, pData, Value);
end;

function TSMFiscalPrinter.FSPrintCalcReport: Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_FS_PRINT_CALC_REPORT, pData, pString);
end;

function TSMFiscalPrinter.FSReadTicketHex(Number: Integer; var Ticket: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := DIO_FS_PARAMETER_TICKET_HEX;
  pString := IntToStr(Number);
  Result := Driver.DirectIO(DIO_READ_FS_PARAMETER, pData, pString);
  Ticket := pString;
end;

function TSMFiscalPrinter.FSReadTicketStr(Number: Integer; var Ticket: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := DIO_FS_PARAMETER_TICKET_STR;
  pString := IntToStr(Number);
  Result := Driver.DirectIO(DIO_READ_FS_PARAMETER, pData, pString);
  Ticket := pString;
end;

function TSMFiscalPrinter.WriteFPParameter(ParamId: Integer; const Value: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := ParamId;
  pString := Value;
  Result := Driver.DirectIO(DIO_WRITE_FPTR_PARAMETER, pData, pString);
end;

function TSMFiscalPrinter.PrintFSDocument(Number: Integer): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Number;
  pString := '';
  Result := Driver.DirectIO(DIO_PRINT_FS_DOCUMENT, pData, pString);
end;

function TSMFiscalPrinter.ReadFSDocument(Number: Integer; var S: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := Number;
  pString := '';
  Result := Driver.DirectIO(DIO_READ_FS_DOCUMENT, pData, pString);
  S := pString;
end;

function TSMFiscalPrinter.CheckItemBarcode(const Barcode: WideString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := Barcode;
  Result := Driver.DirectIO(DIO_CHECK_ITEM_CODE, pData, pString);
end;

function TSMFiscalPrinter.STLVBegin(TagNumber: Integer): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := TagNumber;
  pString := '';
  Result := Driver.DirectIO(DIO_STLV_BEGIN, pData, pString);
end;

function TSMFiscalPrinter.STLVAddTag(TagNumber: Integer;
  const TagValue: string): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := TagNumber;
  pString := TagValue;
  Result := Driver.DirectIO(DIO_STLV_ADD_TAG, pData, pString);
end;

function TSMFiscalPrinter.STLVWrite: Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_STLV_WRITE, pData, pString);
end;

function TSMFiscalPrinter.STLVWriteOp: Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_STLV_WRITE_OP, pData, pString);
end;

function TSMFiscalPrinter.STLVGetHex: string;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Check(Driver.DirectIO(DIO_STLV_GET_HEX, pData, pString));
  Result := pString;
end;

function TSMFiscalPrinter.FSCheckItemCode(const P: TFSCheckItemCode;
  var R: TFSCheckItemResult): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := Format('%d;%d;%s;%s', [P.ItemStatus, P.ProcessMode,
    StrToHexText(P.CMData), StrToHexText(P.TLVData)]);
  Result := Driver.DirectIO(DIO_CHECK_ITEM_CODE2, pData, pString);
  if Result = OPOS_SUCCESS then
  begin
    R.LocalCheckResult := GetInteger(pString, 1, ValueDelimiters);
    R.LocalCheckError := GetInteger(pString, 2, ValueDelimiters);
    R.SymbolicType := GetInteger(pString, 3, ValueDelimiters);
    R.DataLength := GetInteger(pString, 4, ValueDelimiters);
    R.FSResultCode := GetInteger(pString, 5, ValueDelimiters);
    R.ServerCheckStatus := GetInteger(pString, 6, ValueDelimiters);
    R.ServerTLVData := HexToStr(GetString(pString, 7, ValueDelimiters));
  end;
end;

function TSMFiscalPrinter.FSSyncRegisters: Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_FS_SYNC_REGISTERS, pData, pString);
end;

function TSMFiscalPrinter.FSReadMemory(
  var R: TFSReadMemoryResult): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_FS_READ_MEM_STATUS, pData, pString);
  if Result = OPOS_SUCCESS then
  begin
    R.FreeDocCount := GetInteger(pString, 1, ValueDelimiters);
    R.FreeMemorySizeInKB := GetInteger(pString, 2, ValueDelimiters);
    R.UsedMCTicketStorageInPercents := GetInteger(pString, 3, ValueDelimiters);
  end;
end;

function TSMFiscalPrinter.FSWriteTLVFromBuffer: Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_FS_WRITE_TLV_BUFFER, pData, pString);
end;

function TSMFiscalPrinter.FSRandomData(var Data: AnsiString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_FS_GENERATE_RANDOM_DATA, pData, pString);
  if Result = OPOS_SUCCESS then
  begin
    Data := HexToStr(pString);
  end;
end;

function TSMFiscalPrinter.FSAuthorize(
  const DataToAuthorize: AnsiString): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := StrToHexText(DataToAuthorize);
  Result := Driver.DirectIO(DIO_FS_AUTHORIZE, pData, pString);
end;

function TSMFiscalPrinter.FSReadTicketStatus(
  var R: TFSTicketStatus): Integer;
var
  pData: Integer;
  pString: WideString;
begin
  pData := 0;
  pString := '';
  Result := Driver.DirectIO(DIO_FS_READ_TICKET_STATUS, pData, pString);
  if Result = OPOS_SUCCESS then
  begin
    R.TicketStatus := GetInteger(pString, 1, ValueDelimiters);
    R.TicketCount := GetInteger(pString, 2, ValueDelimiters);
    R.TicketNumber := GetInteger(pString, 3, ValueDelimiters);
    R.TicketDate := DecodeOposDateTime(GetString(pString, 4, ValueDelimiters));
    R.TicketStorageUsageInPercents := GetInteger(pString, 5, ValueDelimiters);
  end;
end;

end.

