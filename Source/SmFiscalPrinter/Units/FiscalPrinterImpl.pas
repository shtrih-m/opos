unit FiscalPrinterImpl;

interface

uses
  // VCL
  Windows, ComObj, ActiveX, StdVcl, ComServ, SysUtils, Classes,
  ExtCtrls, Graphics, Math, Variants, SyncObjs, DateUtils,
  // Opos
  Opos, OposFptr, Oposhi, OposFptrhi, OPOSException, OposUtils,
  OposFptrUtils, OposServiceDevice19,
  // 3'd
  TntSysUtils, TntClasses, gnugettext,
   // This
  MalinaParams,
  SmFiscalPrinterLib_TLB, LogFile, FiscalPrinterState, FiscalPrinterDevice,
  SerialPort, PrinterParameters, DIOHandler, NotifyThread, CommandDef,
  FileUtils, DirectIOAPI, PrinterTypes, PayType, StringUtils, OposEvents,
  SerialPorts, DebugUtils, ElectronicJournal, SharedPrinter,
  TrainingReceiptPrinter, ReceiptPrinter, FiscalReceiptPrinter, ByteUtils,
  CustomReceipt, CashInReceipt, CashOutReceipt, GenericReceipt, SalesReceipt,
  TextReceipt, FiscalPrinterStatistics, FiscalPrinterTypes, VersionInfo,
  PrinterModel, ServiceVersion, CommunicationError,
  EscFilter, DriverTypes, PrinterEncoding, OposEventsRCS, OposEventsNull,
  NotifyLink, ZReport, CachedSalesReceipt, GlobusReceipt, GlobusTextReceipt,
  PrinterParametersX, MonitoringServer, TextItem, FptrFilter, NonFiscalDoc,
  RosneftSalesReceipt, FSSalesReceipt, PrinterConnection, Retalix, RegExpr,
  TLV, DriverError, MathUtils, fmuTimeSync, CorrectionReceipt,
  CorrectionReceipt2, CsvPrinterTableFormat, PrinterTable, FSService,
  ReceiptItem, WException;

type
  { TFiscalPrinterImpl }

  TFiscalPrinterImpl = class(TComponent, IFptrService, IFiscalPrinterInternal)
  private
    FRetalix: TRetalix;
    FService: TFSService;
    FFilter: TEscFilter;
    FInitPrinter: Boolean;
    FLastErrorText: WideString;
    FFilters: TFptrFilters;
    FLastErrorCode: Integer;
    FReceipt: TCustomReceipt;
    FDeviceEnabled: Boolean;
    FStatusLink: TNotifyLink;
    FConnectLink: TNotifyLink;
    FCommandDefs: TCommandDefs;
    FDIOHandlers: TDIOHandlers;
    FJournal: TElectronicJournal;
    FDisconnectLink: TNotifyLink;
    FDeviceMetrics: TDeviceMetrics;
    FReceiptItems: Integer;
    FDocumentNumber: Integer;
    FMonitoring: TMonitoringServer;
    FNonFiscalDoc: TNonFiscalDoc;
    FOposDevice: TOposServiceDevice19;
    FPrinterState: TFiscalPrinterState;
    FVatValues: array [1..4] of Integer;
    FAfterCloseItems: TReceiptItems;
    FPrinter: ISharedPrinter;
    FReceiptPrinter: IReceiptPrinter;

    procedure UpdatePrinterDate;
    procedure CheckCapSetVatTable;
    procedure PrintTextFont(Station: Integer; Font: Integer; const Text: WideString);

    function GetLogger: ILogFile;
    function GetFilters: TFptrFilters;
    function GetMalinaParams: TMalinaParams;
    function GetNonFiscalDoc: TNonFiscalDoc;
    function GetPrinterSemaphoreName: WideString;
    function GetParameters: TPrinterParameters;
    function GetTrailerLine(N: Integer): WideString;
    function AddDateStamp(const FileName: WideString): WideString;
    function ParseCashierName(const Line: WideString): WideString;
    function HandleDriverError(E: EDriverError): TOPOSError;
    function CreateNormalSalesReceipt(RecType: Integer): TCustomReceipt;
    function EJHandleError(FPCode, ResultCodeExtended: Integer): Integer;
    function FSHandleError(FPCode, ResultCodeExtended: Integer): Integer;
    function GetTax(const ItemName: WideString; Tax: Integer): Integer;

    procedure PrintFiscalEnd;
    procedure PrintDocumentEnd;
    procedure PrintRecMessages;
    procedure PrintReceiptItems(Items: TReceiptItems);
    procedure PrintHeaderLines(Index1, Index2: Integer);

    property NonFiscalDoc: TNonFiscalDoc read GetNonFiscalDoc;
    procedure PrintEmptyHeader;
    procedure PrintHeaderBegin;
  public
    procedure ReadHeader;
    procedure CheckEndDay;
    procedure ReadTrailer;
    procedure CancelReceipt;
    procedure PrintReportEnd;
    procedure UpdateDioHandlers;
    procedure CreateDIOHandlers;
    procedure CreateDIOHandlers1;
    procedure CreateDIOHandlers2;
    procedure SetFreezeEvents(Value: Boolean);
    procedure ProgressEvent(Progress: Integer);
    procedure SetCoverState(CoverOpened: Boolean);
    procedure SetFiscalReceiptStation(Value: Integer);
    procedure SetJrnPaperState(IsEmpty, IsNearEnd: Boolean);
    procedure SetRecPaperState(IsEmpty, IsNearEnd: Boolean);
    procedure PrinterCommand(Sender: TObject; var Command: TCommandRec);
    procedure PrintImage(const FileName: WideString);
    procedure PrintImageScale(const FileName: WideString; Scale: Integer);
    procedure SetAdjustmentAmount(Amount: Integer);
    procedure PrintText(const Data: TTextRec); overload;

    function DoClose: Integer;
    function DoRelease: Integer;
    function GetFilter: TEscFilter;
    function DoCloseDevice: Integer;
    function GetReceipt: TCustomReceipt;
    function GetPrinter: ISharedPrinter;
    function WaitForPrinting: TPrinterStatus;
    function GetDevice: IFiscalPrinterDevice;
    function GetLongStatus: TLongPrinterStatus;
    function GetDayNumber(const ParamValue, ParamName: WideString): Integer;
    function ReadCashRegister(ID: Byte): Int64;
    function CreateReceipt(FiscalReceiptType: Integer): TCustomReceipt;
    function CreateSalesReceipt(RecType: Integer): TCustomReceipt;
    function CreateCorrectionReceipt(RecType: Integer): TCustomReceipt;
    function CreateCorrectionReceipt2(RecType: Integer): TCustomReceipt;
    function GetEventInterface(FDispatch: IDispatch): IOposEvents;
    procedure StatusChanged(Sender: TObject);
    procedure PrintText(const Text: WideString); overload;
    procedure PrintText(const Text: WideString; Station: Integer); overload;
    procedure DoPrintHeader;
    function GetStatistics: TFiscalPrinterStatistics;
    function GetDailyTotal(Code: Integer): Int64;
    function GetDailyTotalAll: Int64;
    function GetDailyTotalCash: Int64;
    function GetDailyTotalPT2: Int64;
    function GetDailyTotalPT3: Int64;
    function GetDailyTotalPT4: Int64;
    function GetPrinterStation(Station: Integer): Integer;
    function CreateNullReceipt: TCustomReceipt;
    procedure CheckInitPrinter;
    procedure PowerStateChanged(Sender: TObject);
    procedure UpdatePrinterStatus(PropIndex: Integer);
    function GetAppAmountDecimalPlaces: Integer;
    function GetCapRecNearEnd(Value: Boolean): Boolean;
    function ReadFSParameter(ParamID: Integer; const pString: WideString): WideString;
    procedure SetReceiptField(FieldNumber: Integer; const FieldValue: WideString);

    property Filter: TEscFilter read GetFilter;
    property Filters: TFptrFilters read GetFilters;
    property Receipt: TCustomReceipt read GetReceipt;
    property CommandDefs: TCommandDefs read FCommandDefs;
  private
    // boolean
    FDayOpened: Boolean;
    FCapAdditionalLines: Boolean;
    FCapAmountAdjustment: Boolean;
    FCapAmountNotPaid: Boolean;
    FCapCheckTotal: Boolean;
    FCapCoverSensor: Boolean;
    FCapDoubleWidth: Boolean;
    FCapDuplicateReceipt: Boolean;
    FCapFixedOutput: Boolean;
    FCapHasVatTable: Boolean;
    FCapIndependentHeader: Boolean;
    FCapItemList: Boolean;
    FCapJrnEmptySensor: Boolean;
    FCapJrnNearEndSensor: Boolean;
    FCapJrnPresent: Boolean;
    FCapNonFiscalMode: Boolean;
    FCapOrderAdjustmentFirst: Boolean;
    FCapPercentAdjustment: Boolean;
    FCapPositiveAdjustment: Boolean;
    FCapPowerLossReport: Boolean;
    FCapPredefinedPaymentLines: Boolean;
    FCapReceiptNotPaid: Boolean;
    FCapRecEmptySensor: Boolean;
    FCapRecNearEndSensor: Boolean;
    FCapRecPresent: Boolean;
    FCapRemainingFiscalMemory: Boolean;
    FCapReservedWord: Boolean;
    FCapSetPOSID: Boolean;
    FCapSetStoreFiscalID: Boolean;
    FCapSetVatTable: Boolean;
    FCapSlpEmptySensor: Boolean;
    FCapSlpFiscalDocument: Boolean;
    FCapSlpFullSlip: Boolean;
    FCapSlpNearEndSensor: Boolean;
    FCapSlpPresent: Boolean;
    FCapSlpValidation: Boolean;
    FCapSubAmountAdjustment: Boolean;
    FCapSubPercentAdjustment: Boolean;
    FCapSubtotal: Boolean;
    FCapTrainingMode: Boolean;
    FCapValidateJournal: Boolean;
    FCapXReport: Boolean;
    FCapAdditionalHeader: Boolean;
    FCapAdditionalTrailer: Boolean;
    FCapChangeDue: Boolean;
    FCapEmptyReceiptIsVoidable: Boolean;
    FCapFiscalReceiptStation: Boolean;
    FCapFiscalReceiptType: Boolean;
    FCapMultiContractor: Boolean;
    FCapOnlyVoidLastItem: Boolean;
    FCapPackageAdjustment: Boolean;
    FCapPostPreLine: Boolean;
    FCapSetCurrency: Boolean;
    FCapTotalizerType: Boolean;
    FCapPositiveSubtotalAdjustment: Boolean;
    FAsyncMode: Boolean;
    FDuplicateReceipt: Boolean;
    FFlagWhenIdle: Boolean;
    FCoverOpened: Boolean;
    FTrainingModeActive: Boolean;
    // integer
    FCountryCode: Integer;
    FErrorLevel: Integer;
    FErrorOutID: Integer;
    FErrorState: Integer;
    FErrorStation: Integer;

    FNumVatRates: Integer;
    FQuantityDecimalPlaces: Integer;
    FQuantityLength: Integer;
    FRecStatus: TPaperStatus;
    FSlpStatus: TPaperStatus;
    FJrnStatus: TPaperStatus;
    FSlipSelection: Integer;
    FActualCurrency: Integer;
    FContractorId: Integer;
    FDateType: Integer;
    FFiscalReceiptStation: Integer;
    FFiscalReceiptType: Integer;
    FMessageType: Integer;
    FTotalizerType: Integer;
    FStartHeaderLine: Integer;

    FAdditionalHeader: WideString;
    FAdditionalTrailer: WideString;
    FPredefinedPaymentLines: WideString;
    FReservedWord: WideString;
    FChangeDue: WideString;
    FSubtotalText: WideString;
    FHeaderEnabled: Boolean;

    procedure Connect;
    procedure SetDeviceEnabled(Value: Boolean);
    function GetModulePath: WideString;
    procedure InternalInit;
    procedure PrintNonFiscalEnd;
    procedure CheckHealthInternal;
    procedure CheckHealthExternal;
    function ClearResult: Integer;
    function IllegalError: Integer;
    procedure CheckCapSlpFiscalDocument;
    procedure CheckState(AState: Integer);
    function GetPrinterState: Integer;
    procedure SetPrinterState(Value: Integer);
    function HandleException(E: Exception): Integer;
    function DoOpen(const DeviceClass, DeviceName: WideString;
      const pDispatch: IDispatch): Integer;

    property Journal: TElectronicJournal read FJournal;
    property DIOHandlers: TDIOHandlers read FDIOHandlers;
    property PrinterState: Integer read GetPrinterState write SetPrinterState;
  public
    procedure SaveParameters;
    procedure SaveZReportFile;
    function GetCommandDefsFileName: WideString;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; safecall;
    function BeginFiscalReceipt(APrintHeader: WordBool): Integer; safecall;
    function BeginFixedOutput(Station, DocumentType: Integer): Integer;
      safecall;
    function BeginInsertion(Timeout: Integer): Integer; safecall;
    function BeginItemList(VatID: Integer): Integer; safecall;
    function BeginNonFiscal: Integer; safecall;
    function BeginRemoval(Timeout: Integer): Integer; safecall;
    function BeginTraining: Integer; safecall;
    function CheckHealth(Level: Integer): Integer; safecall;
    function Claim(Timeout: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearError: Integer; safecall;
    function ClearOutput: Integer; safecall;
    function Close: Integer; safecall;
    function CloseService: Integer; safecall;
    function COFreezeEvents(Freeze: WordBool): Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer;
      var pString: WideString): Integer; safecall;
    function EndFiscalDocument: Integer; safecall;
    function EndFiscalReceipt(APrintHeader: WordBool): Integer; safecall;
    function EndFixedOutput: Integer; safecall;
    function EndInsertion: Integer; safecall;
    function EndItemList: Integer; safecall;
    function EndNonFiscal: Integer; safecall;
    function EndRemoval: Integer; safecall;
    function EndTraining: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    function GetData(DataItem: Integer; out OptArgs: Integer;
      out Data: WideString): Integer; safecall;
    function GetDate(out Date: WideString): Integer; safecall;
    function GetOpenResult: Integer; safecall;
    function GetPropertyNumber(PropIndex: Integer): Integer; safecall;
    function GetPropertyString(PropIndex: Integer): WideString; safecall;
    function GetTotalizer(VatID, OptArgs: Integer;
      out Data: WideString): Integer; safecall;
    function GetVatEntry(VatID, OptArgs: Integer;
      out VatRate: Integer): Integer; safecall;
    function Open(const DeviceClass, DeviceName: WideString;
      const pDispatch: IDispatch): Integer; safecall;
    function OpenService(const DeviceClass, DeviceName: WideString;
      const pDispatch: IDispatch): Integer; safecall;
    function PrintDuplicateReceipt: Integer; safecall;
    function PrintFiscalDocumentLine(const ADocumentLine: WideString): Integer;
      safecall;
    function PrintFixedOutput(DocumentType, LineNumber: Integer;
      const AData: WideString): Integer; safecall;
    function PrintNormal(Station: Integer; const AData: WideString): Integer;
      safecall;
    function PrintPeriodicTotalsReport(const Date1,
      Date2: WideString): Integer; safecall;
    function PrintPowerLossReport: Integer; safecall;
    function PrintRecCash(Amount: Currency): Integer; safecall;
    function PrintRecItem(const ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString): Integer; safecall;
    function PrintRecItemAdjustment(AdjustmentType: Integer;
      const ADescription: WideString; Amount: Currency;
      VatInfo: Integer): Integer; safecall;
    function PrintRecItemFuel(const ADescription: WideString; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency;
      const AUnitName: WideString; SpecialTax: Currency;
      const ASpecialTaxName: WideString): Integer; safecall;
    function PrintRecItemFuelVoid(const ADescription: WideString;
      Price: Currency; VatInfo: Integer; SpecialTax: Currency): Integer;
      safecall;
    function PrintRecMessage(const AMessage: WideString): Integer; safecall;
    function PrintRecNotPaid(const Description: WideString;
      Amount: Currency): Integer; safecall;
    function PrintRecPackageAdjustment(AdjustmentType: Integer;
      const Description, VatAdjustment: WideString): Integer; safecall;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer;
      const VatAdjustment: WideString): Integer; safecall;

    function PrintRecRefund(
      const Description: WideString;
      Amount: Currency;
      VatInfo: Integer
      ): Integer; safecall;

    function PrintRecRefundVoid(
      const Description: WideString;
      Amount: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintRecSubtotal(Amount: Currency): Integer; safecall;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer;
      const Description: WideString; Amount: Currency): Integer; safecall;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer;
      Amount: Currency): Integer; safecall;
    function PrintRecTaxID(const TaxID: WideString): Integer; safecall;
    function PrintRecTotal(Total, Payment: Currency;
      const Description: WideString): Integer; safecall;
    function PrintRecVoid(const Description: WideString): Integer; safecall;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency;
      Quantity, AdjustmentType: Integer; Adjustment: Currency;
      VatInfo: Integer): Integer; safecall;

    function PrintReport(
      ReportType: Integer;
      const StartNum, EndNum: WideString
      ): Integer; safecall;

    function PrintXReport: Integer; safecall;
    function PrintZReport: Integer; safecall;
    function Release1: Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function ResetPrinter: Integer; safecall;
    function SetCurrency(NewCurrency: Integer): Integer; safecall;

    function SetDate(
      const Date: WideString): Integer; safecall;

    function SetHeaderLine(LineNumber: Integer; const AText: WideString;
      DoubleWidth: WordBool): Integer; safecall;
    function SetPOSID(
      const POSID, CashierID: WideString): Integer; safecall;

    function SetStoreFiscalID(const AID: WideString): Integer; safecall;
    function SetTrailerLine(LineNumber: Integer; const AText: WideString;
      DoubleWidth: WordBool): Integer; safecall;
    function SetVatTable: Integer; safecall;

    function SetVatValue(
      VatID: Integer;
      const AVatValue: WideString): Integer; safecall;

    function VerifyItem(const AItemName: WideString; VatID: Integer): Integer;
      safecall;
    procedure SetPropertyNumber(PropIndex, Number: Integer); safecall;

    procedure SetPropertyString(
      PropIndex: Integer;
      const Value: WideString); safecall;

    function ResetStatistics(
      const StatisticsBuffer: WideString): Integer; safecall;

    function  RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function  UpdateStatistics(
      const StatisticsBuffer: WideString): Integer; safecall;

    function  CompareFirmwareVersion(
      const FirmwareFileName: WideString;
      out pResult: Integer): Integer; safecall;

    function  UpdateFirmware(
      const FirmwareFileName: WideString): Integer; safecall;

    function  PrintRecItemAdjustmentVoid(
      AdjustmentType: Integer;
      const Description: WideString;
      Amount: Currency;
      VatInfo: Integer
      ): Integer; safecall;

    function PrintRecItemVoid(
      const Description: WideString;
      Price: Currency;
      Quantity: Integer;
      VatInfo: Integer;
      UnitPrice: Currency;
      const UnitName: WideString): Integer; safecall;

    function PrintRecItemRefund(
      const Description: WideString;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const UnitName: WideString): Integer; safecall;

    function PrintRecItemRefundVoid(
      const Description: WideString; Amount: Currency;
      Quantity: Integer; VatInfo: Integer; UnitAmount: Currency;
      const UnitName: WideString): Integer; safecall;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure OpenFiscalDay;
    procedure PrintLogo;
    procedure PrintLogo2(Position: Integer);
    procedure PrintHeader;
    procedure PrintTrailer;
    procedure CheckEnabled;
    procedure WriteDeviceTables;
    procedure LoadLogo(const FileName: WideString);
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString);
    function ReadEJActivation: WideString;
    procedure PrintBarcode(const Barcode: TBarcodeRec);
    function EncodeString(const S: WideString): WideString;
    function DecodeString(const Text: WideString): WideString;
    procedure DisableNextHeader;
    procedure FSWriteTLV(const TLVData: WideString);
    procedure FSWriteTlvOperation(const TLVData: WideString);
    procedure WriteCustomerAddress(const Value: WideString);
    procedure FSWriteTag(TagID: Integer; const Data: WideString);
    procedure FSWriteTagOperation(TagID: Integer; const Data: WideString);
    procedure SetPrinter(APrinter: ISharedPrinter);
    procedure WriteFPParameter(ParamId: Integer; const Value: WideString);
    function ReadFSDocument(Number: Integer): WideString;
    procedure PrintFSDocument(Number: Integer);
    function FSPrintCorrectionReceipt(var Command: TFSCorrectionReceipt): Integer;
    function FSPrintCorrectionReceipt2(var Data: TFSCorrectionReceipt2): Integer;
    procedure AddItemCode(const Code: WideString);

    property Logger: ILogFile read GetLogger;
    property Printer: ISharedPrinter read GetPrinter;
    property OposDevice: TOposServiceDevice19 read FOposDevice;
    property Statistics: TFiscalPrinterStatistics read GetStatistics;
    property Device: IFiscalPrinterDevice read GetDevice;
    property LastErrorCode: Integer read FLastErrorCode;
    property LastErrorText: WideString read FLastErrorText;
    property Parameters: TPrinterParameters read GetParameters;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

implementation

uses
  // VCL
  DIOHandlers, MalinaPlugin;

{ TFiscalPrinter }

constructor TFiscalPrinterImpl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStatusLink := TNotifyLink.Create;
  FStatusLink.OnChange := StatusChanged;
  FConnectLink := TNotifyLink.Create;
  FConnectLink.OnChange := PowerStateChanged;
  FDisconnectLink := TNotifyLink.Create;
  FDisconnectLink.OnChange := PowerStateChanged;
  FPrinterState := TFiscalPrinterState.Create;
  FJournal := TElectronicJournal.Create;
  FAfterCloseItems := TReceiptItems.Create;
end;

destructor TFiscalPrinterImpl.Destroy;
begin
  if FPrinter <> nil then
    DoCloseDevice;

  FMonitoring.Free;
  FService.Free;
  FFilters.Free;
  FFilter.Free;
  FDIOHandlers.Free;
  FCommandDefs.Free;
  FJournal.Free;
  FReceipt.Free;
  FPrinterState.Free;
  FOposDevice.Free;
  FStatusLink.Free;
  FConnectLink.Free;
  FDisconnectLink.Free;
  FNonFiscalDoc.Free;
  FRetalix.Free;
  FAfterCloseItems.Free;
  FPrinter := nil;
  inherited Destroy;
end;

function TFiscalPrinterImpl.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Device;
end;

function TFiscalPrinterImpl.DecodeString(const Text: WideString): WideString;
begin
  case Parameters.Encoding of
    Encoding866: Result := Str866To1251(Text);
  else
    Result := WideStringToAnsiString(1251, Text);
  end;
  {$IFDEF MALINA}
  if GetMalinaParams.TextReplacementEnabled then
    Result := GetMalinaParams.Replacements.Replace(Text);
  {$ENDIF}
end;


function TFiscalPrinterImpl.EncodeString(const S: WideString): WideString;
begin
  case Parameters.Encoding of
    Encoding866: Result := Str1251To866(S);
  else
    Result := AnsiStringToWideString(1251, S);
  end;
end;

function TFiscalPrinterImpl.GetNonFiscalDoc: TNonFiscalDoc;
var
  IsBuffered: Boolean;
begin
  if FNonFiscalDoc = nil then
  begin
    {$IFDEF MALINA}
    IsBuffered := True;
    {$ELSE}
    IsBuffered := False;
    {$ENDIF}
    FNonFiscalDoc := TNonFiscalDoc.Create(FReceiptPrinter, IsBuffered);
  end;
  Result := FNonFiscalDoc;
end;


function TFiscalPrinterImpl.GetFilters: TFptrFilters;
{$IFDEF MALINA}
var
  Filter: TMalinaPlugin;
{$ENDIF}
begin
  if FFilters = nil then
  begin
    FFilters := TFptrFilters.Create;
    {$IFDEF MALINA}
    Filter := TMalinaPlugin.Create(FFilters, Device.Context.MalinaParams);
    Filter.Init(Self, FOposDevice.DeviceName);
    {$ENDIF}
  end;
  Result := FFilters;
end;

function TFiscalPrinterImpl.GetStatistics: TFiscalPrinterStatistics;
begin
  Result := Device.Statistics;
end;

function TFiscalPrinterImpl.GetLongStatus: TLongPrinterStatus;
begin
  Result := Device.ReadLongStatus;
  FDocumentNumber := Result.DocumentNumber;
end;

function TFiscalPrinterImpl.GetFilter: TEscFilter;
begin
  if FFilter = nil then
    FFilter := TEscFilter.Create(GetPrinter);
  Result := FFilter;
end;

procedure TFiscalPrinterImpl.CreateDIOHandlers;
begin
  FDIOHandlers.Clear;
  TDIOCommandDef.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_XML, Self);
  TDIOHexCommand.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_HEX, Self);
  TDIOCheckEndDay.CreateCommand(FDIOHandlers, DIO_CHECK_END_DAY, Self);
  TDIOLoadLogo.CreateCommand(FDIOHandlers, DIO_LOAD_LOGO, Self);
  TDIOPrintLogo.CreateCommand(FDIOHandlers, DIO_PRINT_LOGO, Self);
  TDIOClearLogo.CreateCommand(FDIOHandlers, DIO_CLEAR_LOGO, Self);
  TDIOLogoDlg.CreateCommand(FDIOHandlers, DIO_LOGO_DLG, Self);
  TDIOBarcode.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE, Self);
  TDIOBarcodeHex.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE_HEX, Self);
  TDIOStrCommand.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_STR, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT, Self);
  TDIOWriteTaxName.CreateCommand(FDIOHandlers, DIO_WRITE_TAX_NAME, Self);
  TDIOReadTaxName.CreateCommand(FDIOHandlers, DIO_READ_TAX_NAME, Self);
  TDIOWritePaymentName.CreateCommand(FDIOHandlers, DIO_WRITE_PAYMENT_NAME, Self);
  TDIOReadPaymentName.CreateCommand(FDIOHandlers, DIO_READ_PAYMENT_NAME, Self);
  TDIOWriteTable.CreateCommand(FDIOHandlers, DIO_WRITE_TABLE, Self);
  TDIOReadTable.CreateCommand(FDIOHandlers, DIO_READ_TABLE, Self);
  TDIOGetDepartment.CreateCommand(FDIOHandlers, DIO_GET_DEPARTMENT, Self);
  TDIOSetDepartment.CreateCommand(FDIOHandlers, DIO_SET_DEPARTMENT, Self);
  TDIOReadCashRegister.CreateCommand(FDIOHandlers, DIO_READ_CASH_REG, Self);
  TDIOReadOperatingRegister.CreateCommand(FDIOHandlers, DIO_READ_OPER_REG, Self);
  TDIOWaitForPrint.CreateCommand(FDIOHandlers, DIO_WAIT_FOR_PRINT, Self);
  TDIOPrintHeader.CreateCommand(FDIOHandlers, DIO_PRINT_HEADER, Self);
  TDIOPrintTrailer.CreateCommand(FDIOHandlers, DIO_PRINT_TRAILER, Self);
  TDIOZReport.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT, Self);
  TDIOZReportXML.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT_XML, Self);
  TDIOZReportCSV.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT_CSV, Self);
  TDIOGetLastError.CreateCommand(FDIOHandlers, DIO_GET_LAST_ERROR, Self);
  TDIOGetPrinterStation.CreateCommand(FDIOHandlers, DIO_GET_PRINTER_STATION, Self);
  TDIOSetPrinterStation.CreateCommand(FDIOHandlers, DIO_SET_PRINTER_STATION, Self);
  TDIOGetDriverParameter.CreateCommand(FDIOHandlers, DIO_GET_DRIVER_PARAMETER, Self);
  TDIOSetDriverParameter.CreateCommand(FDIOHandlers, DIO_SET_DRIVER_PARAMETER, Self);
  TDIOPrintSeparator.CreateCommand(FDIOHandlers, DIO_PRINT_SEPARATOR, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT2, Self);
  TDIOStrCommand2.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_STR2, Self);
  TDIOReadEJActivation.CreateCommand(FDIOHandlers, DIO_READ_EJ_ACTIVATION, Self);
  TDIOReadFMTotals.CreateCommand(FDIOHandlers, DIO_READ_FM_TOTALS, Self);
  TDIOReadGrandTotals.CreateCommand(FDIOHandlers, DIO_READ_GRAND_TOTALS, Self);
  TDIOPrintImage.CreateCommand(FDIOHandlers, DIO_PRINT_IMAGE, Self);
  TDIOPrintImageScale.CreateCommand(FDIOHandlers, DIO_PRINT_IMAGE_SCALE, Self);

  TDIOWriteCustomerAddress.CreateCommand(FDIOHandlers, DIO_WRITE_FS_CUSTOMER_ADDRESS, Self);
  TDIOWriteTlvData.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_DATA, Self);
  TDIOWriteStringTag.CreateCommand(FDIOHandlers, DIO_WRITE_FS_STRING_TAG, Self);
  TDIOReadFSParameter.CreateCommand(FDIOHandlers, DIO_READ_FS_PARAMETER, Self);
  TDIOReadFPParameter.CreateCommand(FDIOHandlers, DIO_READ_FPTR_PARAMETER, Self);
  TDIOWriteFPParameter.CreateCommand(FDIOHandlers, DIO_WRITE_FPTR_PARAMETER, Self);
  TDIOSetAdjustmentAmount.CreateCommand(FDIOHandlers, DIO_SET_ADJUSTMENT_AMOUNT, Self);
  TDIODisableNextHeader.CreateCommand(FDIOHandlers, DIO_DISABLE_NEXT_HEADER, Self);
  TDIOWriteTableFile.CreateCommand(FDIOHandlers, DIO_WRITE_TABLE_FILE, Self);
  TDIOFSReadDocument.CreateCommand(FDIOHandlers, DIO_FS_READ_DOCUMENT, Self);
  TDIOFSPrintCalcReport.CreateCommand(FDIOHandlers, DIO_FS_PRINT_CALC_REPORT, Self);
  TDIOOpenCashDrawer.CreateCommand(FDIOHandlers, DIO_OPEN_CASH_DRAWER, Self);
  TDIOReadCashDrawerState.CreateCommand(FDIOHandlers, DIO_READ_CASH_DRAWER_STATE, Self);
  TDIOFSFiscalize.CreateCommand(FDIOHandlers, DIO_FS_FISCALIZE, Self);
  TDIOFSReFiscalize.CreateCommand(FDIOHandlers, DIO_FS_REFISCALIZE, Self);
  TDIOGetPrintWidth.CreateCommand(FDIOHandlers, DIO_GET_PRINT_WIDTH, Self);
  TDIOBarcodeHex2.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE_HEX2, Self);
  TDIOReadFSDocument.CreateCommand(FDIOHandlers, DIO_READ_FS_DOCUMENT, Self);
  TDIOPrintFSDocument.CreateCommand(FDIOHandlers, DIO_PRINT_FS_DOCUMENT, Self);
  TDIOPrintCorrection.CreateCommand(FDIOHandlers, DIO_PRINT_CORRECTION, Self);
  TDIOPrintCorrection2.CreateCommand(FDIOHandlers, DIO_PRINT_CORRECTION2, Self);
  TDIOStartOpenDay.CreateCommand(FDIOHandlers, DIO_START_OPEN_DAY, Self);
  TDIOOpenDay.CreateCommand(FDIOHandlers, DIO_OPEN_DAY, Self);
  TDIOCheckItemCode.CreateCommand(FDIOHandlers, DIO_CHECK_ITEM_CODE, Self);
  TDIOCheckItemCode2.CreateCommand(FDIOHandlers, DIO_CHECK_ITEM_CODE2, Self);
  TDIOStartCorrection.CreateCommand(FDIOHandlers, DIO_START_CORRECTION, Self);
  TDIOWriteTlvHex.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_HEX, Self);
  TDIOWriteTlvOperation.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_OP_HEX, Self);
  TDIOWriteStringTagOp.CreateCommand(FDIOHandlers, DIO_WRITE_FS_STRING_TAG_OP, Self);

  TDIOSTLVBegin.CreateCommand(FDIOHandlers, DIO_STLV_BEGIN, Self);
  TDIOSTLVAddTag.CreateCommand(FDIOHandlers, DIO_STLV_ADD_TAG, Self);
  TDIOSTLVWrite.CreateCommand(FDIOHandlers, DIO_STLV_WRITE, Self);
  TDIOSTLVWriteOp.CreateCommand(FDIOHandlers, DIO_STLV_WRITE_OP, Self);
  TDIOSTLVGetHex.CreateCommand(FDIOHandlers, DIO_STLV_GET_HEX, Self);
  TDIOSetReceiptField.CreateCommand(FDIOHandlers, DIO_SET_RECEIPT_FIELD, Self);
  TDIOAddItemCode.CreateCommand(FDIOHandlers, DIO_ADD_ITEM_CODE, Self);
  TDIOFSSyncRegisters.CreateCommand(FDIOHandlers, DIO_FS_SYNC_REGISTERS, Self);
  TDIOFSReadMemStatus.CreateCommand(FDIOHandlers, DIO_FS_READ_MEM_STATUS, Self);
  TDIOFSWriteTLVBuffer.CreateCommand(FDIOHandlers, DIO_FS_WRITE_TLV_BUFFER, Self);
  TDIOFSGenerateRandomData.CreateCommand(FDIOHandlers, DIO_FS_GENERATE_RANDOM_DATA, Self);
  TDIOFSAuthorize.CreateCommand(FDIOHandlers, DIO_FS_AUTHORIZE, Self);
  TDIOFSReadTicketStatus.CreateCommand(FDIOHandlers, DIO_FS_READ_TICKET_STATUS, Self);

end;

procedure TFiscalPrinterImpl.CreateDIOHandlers1;
const
  Offset = 100;
begin
  FDIOHandlers.Clear;
  TDIOPrintRecRefund.CreateCommand(FDIOHandlers, DIO2_PRINT_REC_REFUND, Self);
  TDIOPrintJournal.CreateCommand(FDIOHandlers, DIO2_PRINT_JOURNAL, Self);
  TDIOReadDayNumber.CreateCommand(FDIOHandlers, DIO2_READ_DAY_NUMBER, Self);
  TDIOWritePaymentName2.CreateCommand(FDIOHandlers, DIO2_SET_TENDER_NAME, Self);
  TDIOCommandDef.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_XML + Offset, Self);
  TDIOHexCommand.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_HEX + Offset, Self);
  TDIOCheckEndDay.CreateCommand(FDIOHandlers, DIO_CHECK_END_DAY + Offset, Self);
  TDIOLoadLogo.CreateCommand(FDIOHandlers, DIO_LOAD_LOGO, Self);
  TDIOPrintLogo.CreateCommand(FDIOHandlers, DIO_PRINT_LOGO, Self);
  TDIOClearLogo.CreateCommand(FDIOHandlers, DIO_CLEAR_LOGO, Self);
  TDIOLogoDlg.CreateCommand(FDIOHandlers, DIO_LOGO_DLG, Self);
  TDIOBarcode.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE, Self);
  TDIOBarcodeHex.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE_HEX, Self);
  TDIOStrCommand.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_STR, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT, Self);
  TDIOWriteTaxName.CreateCommand(FDIOHandlers, DIO_WRITE_TAX_NAME, Self);
  TDIOReadTaxName.CreateCommand(FDIOHandlers, DIO_READ_TAX_NAME, Self);
  TDIOWritePaymentName.CreateCommand(FDIOHandlers, DIO_WRITE_PAYMENT_NAME, Self);
  TDIOReadPaymentName.CreateCommand(FDIOHandlers, DIO_READ_PAYMENT_NAME, Self);
  TDIOWriteTable.CreateCommand(FDIOHandlers, DIO_WRITE_TABLE, Self);
  TDIOReadTable.CreateCommand(FDIOHandlers, DIO_READ_TABLE, Self);
  TDIOGetDepartment.CreateCommand(FDIOHandlers, DIO_GET_DEPARTMENT, Self);
  TDIOSetDepartment.CreateCommand(FDIOHandlers, DIO_SET_DEPARTMENT, Self);
  TDIOReadCashRegister.CreateCommand(FDIOHandlers, DIO_READ_CASH_REG, Self);
  TDIOReadOperatingRegister.CreateCommand(FDIOHandlers, DIO_READ_OPER_REG, Self);
  TDIOWaitForPrint.CreateCommand(FDIOHandlers, DIO_WAIT_FOR_PRINT, Self);
  TDIOPrintHeader.CreateCommand(FDIOHandlers, DIO_PRINT_HEADER, Self);
  TDIOPrintTrailer.CreateCommand(FDIOHandlers, DIO_PRINT_TRAILER, Self);
  TDIOZReport.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT, Self);
  TDIOZReportXML.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT_XML, Self);
  TDIOZReportCSV.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT_CSV, Self);
  TDIOGetLastError.CreateCommand(FDIOHandlers, DIO_GET_LAST_ERROR, Self);
  TDIOGetPrinterStation.CreateCommand(FDIOHandlers, DIO_GET_PRINTER_STATION, Self);
  TDIOSetPrinterStation.CreateCommand(FDIOHandlers, DIO_SET_PRINTER_STATION, Self);
  TDIOGetDriverParameter.CreateCommand(FDIOHandlers, DIO_GET_DRIVER_PARAMETER, Self);
  TDIOSetDriverParameter.CreateCommand(FDIOHandlers, DIO_SET_DRIVER_PARAMETER, Self);
  TDIOPrintSeparator.CreateCommand(FDIOHandlers, DIO_PRINT_SEPARATOR, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT2, Self);
  TDIOStrCommand2.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_STR2, Self);
  TDIOReadEJActivation.CreateCommand(FDIOHandlers, DIO_READ_EJ_ACTIVATION, Self);
  TDIOReadFMTotals.CreateCommand(FDIOHandlers, DIO_READ_FM_TOTALS, Self);
  TDIOReadGrandTotals.CreateCommand(FDIOHandlers, DIO_READ_GRAND_TOTALS, Self);
  TDIOPrintImage.CreateCommand(FDIOHandlers, DIO_PRINT_IMAGE, Self);
  TDIOPrintImageScale.CreateCommand(FDIOHandlers, DIO_PRINT_IMAGE_SCALE, Self);

  TDIOWriteCustomerAddress.CreateCommand(FDIOHandlers, DIO_WRITE_FS_CUSTOMER_ADDRESS, Self);
  TDIOWriteTlvData.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_DATA, Self);
  TDIOWriteStringTag.CreateCommand(FDIOHandlers, DIO_WRITE_FS_STRING_TAG, Self);
  TDIOReadFSParameter.CreateCommand(FDIOHandlers, DIO_READ_FS_PARAMETER, Self);
  TDIOReadFPParameter.CreateCommand(FDIOHandlers, DIO_READ_FPTR_PARAMETER, Self);
  TDIOWriteFPParameter.CreateCommand(FDIOHandlers, DIO_WRITE_FPTR_PARAMETER, Self);
  TDIOSetAdjustmentAmount.CreateCommand(FDIOHandlers, DIO_SET_ADJUSTMENT_AMOUNT, Self);
  TDIODisableNextHeader.CreateCommand(FDIOHandlers, DIO_DISABLE_NEXT_HEADER, Self);
  TDIOWriteTableFile.CreateCommand(FDIOHandlers, DIO_WRITE_TABLE_FILE, Self);
  TDIOFSReadDocument.CreateCommand(FDIOHandlers, DIO_FS_READ_DOCUMENT, Self);
  TDIOFSPrintCalcReport.CreateCommand(FDIOHandlers, DIO_FS_PRINT_CALC_REPORT, Self);
  TDIOOpenCashDrawer.CreateCommand(FDIOHandlers, DIO_OPEN_CASH_DRAWER, Self);
  TDIOReadCashDrawerState.CreateCommand(FDIOHandlers, DIO_READ_CASH_DRAWER_STATE, Self);
  TDIOFSFiscalize.CreateCommand(FDIOHandlers, DIO_FS_FISCALIZE, Self);
  TDIOFSReFiscalize.CreateCommand(FDIOHandlers, DIO_FS_REFISCALIZE, Self);
  TDIOGetPrintWidth.CreateCommand(FDIOHandlers, DIO_GET_PRINT_WIDTH, Self);
  TDIOBarcodeHex2.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE_HEX2, Self);
  TDIOReadFSDocument.CreateCommand(FDIOHandlers, DIO_READ_FS_DOCUMENT, Self);
  TDIOPrintFSDocument.CreateCommand(FDIOHandlers, DIO_PRINT_FS_DOCUMENT, Self);
  TDIOPrintCorrection.CreateCommand(FDIOHandlers, DIO_PRINT_CORRECTION, Self);
  TDIOPrintCorrection2.CreateCommand(FDIOHandlers, DIO_PRINT_CORRECTION2, Self);
  TDIOStartOpenDay.CreateCommand(FDIOHandlers, DIO_START_OPEN_DAY, Self);
  TDIOOpenDay.CreateCommand(FDIOHandlers, DIO_OPEN_DAY, Self);
  TDIOCheckItemCode.CreateCommand(FDIOHandlers, DIO_CHECK_ITEM_CODE, Self);
  TDIOCheckItemCode2.CreateCommand(FDIOHandlers, DIO_CHECK_ITEM_CODE2, Self);
  TDIOStartCorrection.CreateCommand(FDIOHandlers, DIO_START_CORRECTION, Self);
  TDIOWriteTlvHex.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_HEX, Self);
  TDIOWriteTlvOperation.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_OP_HEX, Self);
  TDIOWriteStringTagOp.CreateCommand(FDIOHandlers, DIO_WRITE_FS_STRING_TAG_OP, Self);
  TDIOSTLVBegin.CreateCommand(FDIOHandlers, DIO_STLV_BEGIN, Self);
  TDIOSTLVAddTag.CreateCommand(FDIOHandlers, DIO_STLV_ADD_TAG, Self);
  TDIOSTLVWrite.CreateCommand(FDIOHandlers, DIO_STLV_WRITE, Self);
  TDIOSTLVWriteOp.CreateCommand(FDIOHandlers, DIO_STLV_WRITE_OP, Self);
  TDIOSTLVGetHex.CreateCommand(FDIOHandlers, DIO_STLV_GET_HEX, Self);
  TDIOSetReceiptField.CreateCommand(FDIOHandlers, DIO_SET_RECEIPT_FIELD, Self);
  TDIOAddItemCode.CreateCommand(FDIOHandlers, DIO_ADD_ITEM_CODE, Self);
  TDIOFSSyncRegisters.CreateCommand(FDIOHandlers, DIO_FS_SYNC_REGISTERS, Self);
  TDIOFSReadMemStatus.CreateCommand(FDIOHandlers, DIO_FS_READ_MEM_STATUS, Self);
  TDIOFSWriteTLVBuffer.CreateCommand(FDIOHandlers, DIO_FS_WRITE_TLV_BUFFER, Self);
  TDIOFSGenerateRandomData.CreateCommand(FDIOHandlers, DIO_FS_GENERATE_RANDOM_DATA, Self);
  TDIOFSAuthorize.CreateCommand(FDIOHandlers, DIO_FS_AUTHORIZE, Self);
  TDIOFSReadTicketStatus.CreateCommand(FDIOHandlers, DIO_FS_READ_TICKET_STATUS, Self);
end;

procedure TFiscalPrinterImpl.CreateDIOHandlers2;
const
  Offset = 100;
begin
  FDIOHandlers.Clear;
  TDIOSetDepartment.CreateCommand(FDIOHandlers, 1, Self);
  TDIOGetDepartment.CreateCommand(FDIOHandlers, 2, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT2, Self);

  TDIOReadDayNumber.CreateCommand(FDIOHandlers, DIO2_READ_DAY_NUMBER, Self);
  TDIOWritePaymentName2.CreateCommand(FDIOHandlers, DIO2_SET_TENDER_NAME, Self);

  TDIOCommandDef.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_XML + Offset, Self);
  TDIOHexCommand.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_HEX + Offset, Self);
  TDIOCheckEndDay.CreateCommand(FDIOHandlers, DIO_CHECK_END_DAY + Offset, Self);

  TDIOLoadLogo.CreateCommand(FDIOHandlers, DIO_LOAD_LOGO, Self);
  TDIOPrintLogo.CreateCommand(FDIOHandlers, DIO_PRINT_LOGO, Self);
  TDIOClearLogo.CreateCommand(FDIOHandlers, DIO_CLEAR_LOGO, Self);
  TDIOLogoDlg.CreateCommand(FDIOHandlers, DIO_LOGO_DLG, Self);
  TDIOBarcodeHex.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE_HEX, Self);
  TDIOStrCommand.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_STR, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT, Self);
  TDIOWriteTaxName.CreateCommand(FDIOHandlers, DIO_WRITE_TAX_NAME, Self);
  TDIOReadTaxName.CreateCommand(FDIOHandlers, DIO_READ_TAX_NAME, Self);
  TDIOWritePaymentName.CreateCommand(FDIOHandlers, DIO_WRITE_PAYMENT_NAME, Self);
  TDIOReadPaymentName.CreateCommand(FDIOHandlers, DIO_READ_PAYMENT_NAME, Self);
  TDIOWriteTable.CreateCommand(FDIOHandlers, DIO_WRITE_TABLE, Self);
  TDIOReadTable.CreateCommand(FDIOHandlers, DIO_READ_TABLE, Self);
  TDIOGetDepartment.CreateCommand(FDIOHandlers, DIO_GET_DEPARTMENT, Self);
  TDIOSetDepartment.CreateCommand(FDIOHandlers, DIO_SET_DEPARTMENT, Self);
  TDIOReadCashRegister.CreateCommand(FDIOHandlers, DIO_READ_CASH_REG, Self);
  TDIOReadOperatingRegister.CreateCommand(FDIOHandlers, DIO_READ_OPER_REG, Self);
  TDIOWaitForPrint.CreateCommand(FDIOHandlers, DIO_WAIT_FOR_PRINT, Self);
  TDIOPrintHeader.CreateCommand(FDIOHandlers, DIO_PRINT_HEADER, Self);
  TDIOPrintTrailer.CreateCommand(FDIOHandlers, DIO_PRINT_TRAILER, Self);
  TDIOZReport.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT, Self);
  TDIOZReportXML.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT_XML, Self);
  TDIOZReportCSV.CreateCommand(FDIOHandlers, DIO_PRINT_ZREPORT_CSV, Self);
  TDIOGetLastError.CreateCommand(FDIOHandlers, DIO_GET_LAST_ERROR, Self);
  TDIOGetPrinterStation.CreateCommand(FDIOHandlers, DIO_GET_PRINTER_STATION, Self);
  TDIOSetPrinterStation.CreateCommand(FDIOHandlers, DIO_SET_PRINTER_STATION, Self);
  TDIOGetDriverParameter.CreateCommand(FDIOHandlers, DIO_GET_DRIVER_PARAMETER, Self);
  TDIOSetDriverParameter.CreateCommand(FDIOHandlers, DIO_SET_DRIVER_PARAMETER, Self);
  TDIOPrintSeparator.CreateCommand(FDIOHandlers, DIO_PRINT_SEPARATOR, Self);
  TDIOPrintText.CreateCommand(FDIOHandlers, DIO_PRINT_TEXT2, Self);
  TDIOStrCommand2.CreateCommand(FDIOHandlers, DIO_COMMAND_PRINTER_STR2, Self);
  TDIOReadEJActivation.CreateCommand(FDIOHandlers, DIO_READ_EJ_ACTIVATION, Self);
  TDIOReadFMTotals.CreateCommand(FDIOHandlers, DIO_READ_FM_TOTALS, Self);
  TDIOReadGrandTotals.CreateCommand(FDIOHandlers, DIO_READ_GRAND_TOTALS, Self);
  TDIOPrintImage.CreateCommand(FDIOHandlers, DIO_PRINT_IMAGE, Self);
  TDIOPrintImageScale.CreateCommand(FDIOHandlers, DIO_PRINT_IMAGE_SCALE, Self);

  TDIOWriteCustomerAddress.CreateCommand(FDIOHandlers, DIO_WRITE_FS_CUSTOMER_ADDRESS, Self);
  TDIOWriteTlvData.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_DATA, Self);
  TDIOWriteStringTag.CreateCommand(FDIOHandlers, DIO_WRITE_FS_STRING_TAG, Self);
  TDIOReadFSParameter.CreateCommand(FDIOHandlers, DIO_READ_FS_PARAMETER, Self);
  TDIOReadFPParameter.CreateCommand(FDIOHandlers, DIO_READ_FPTR_PARAMETER, Self);
  TDIOWriteFPParameter.CreateCommand(FDIOHandlers, DIO_WRITE_FPTR_PARAMETER, Self);
  TDIOSetAdjustmentAmount.CreateCommand(FDIOHandlers, DIO_SET_ADJUSTMENT_AMOUNT, Self);
  TDIODisableNextHeader.CreateCommand(FDIOHandlers, DIO_DISABLE_NEXT_HEADER, Self);
  TDIOWriteTableFile.CreateCommand(FDIOHandlers, DIO_WRITE_TABLE_FILE, Self);
  TDIOFSReadDocument.CreateCommand(FDIOHandlers, DIO_FS_READ_DOCUMENT, Self);
  TDIOFSPrintCalcReport.CreateCommand(FDIOHandlers, DIO_FS_PRINT_CALC_REPORT, Self);
  TDIOOpenCashDrawer.CreateCommand(FDIOHandlers, DIO_OPEN_CASH_DRAWER, Self);
  TDIOReadCashDrawerState.CreateCommand(FDIOHandlers, DIO_READ_CASH_DRAWER_STATE, Self);
  TDIOFSFiscalize.CreateCommand(FDIOHandlers, DIO_FS_FISCALIZE, Self);
  TDIOFSReFiscalize.CreateCommand(FDIOHandlers, DIO_FS_REFISCALIZE, Self);
  TDIOGetPrintWidth.CreateCommand(FDIOHandlers, DIO_GET_PRINT_WIDTH, Self);
  TDIOBarcodeHex2.CreateCommand(FDIOHandlers, DIO_PRINT_BARCODE_HEX2, Self);
  TDIOReadFSDocument.CreateCommand(FDIOHandlers, DIO_READ_FS_DOCUMENT, Self);
  TDIOPrintFSDocument.CreateCommand(FDIOHandlers, DIO_PRINT_FS_DOCUMENT, Self);
  TDIOPrintCorrection.CreateCommand(FDIOHandlers, DIO_PRINT_CORRECTION, Self);
  TDIOPrintCorrection2.CreateCommand(FDIOHandlers, DIO_PRINT_CORRECTION2, Self);
  TDIOStartOpenDay.CreateCommand(FDIOHandlers, DIO_START_OPEN_DAY, Self);
  TDIOOpenDay.CreateCommand(FDIOHandlers, DIO_OPEN_DAY, Self);
  TDIOCheckItemCode.CreateCommand(FDIOHandlers, DIO_CHECK_ITEM_CODE, Self);
  TDIOCheckItemCode2.CreateCommand(FDIOHandlers, DIO_CHECK_ITEM_CODE2, Self);
  TDIOStartCorrection.CreateCommand(FDIOHandlers, DIO_START_CORRECTION, Self);
  TDIOWriteTlvHex.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_HEX, Self);
  TDIOWriteTlvOperation.CreateCommand(FDIOHandlers, DIO_WRITE_FS_TLV_OP_HEX, Self);
  TDIOWriteStringTagOp.CreateCommand(FDIOHandlers, DIO_WRITE_FS_STRING_TAG_OP, Self);

  TDIOSTLVBegin.CreateCommand(FDIOHandlers, DIO_STLV_BEGIN, Self);
  TDIOSTLVAddTag.CreateCommand(FDIOHandlers, DIO_STLV_ADD_TAG, Self);
  TDIOSTLVWrite.CreateCommand(FDIOHandlers, DIO_STLV_WRITE, Self);
  TDIOSTLVWriteOp.CreateCommand(FDIOHandlers, DIO_STLV_WRITE_OP, Self);
  TDIOSTLVGetHex.CreateCommand(FDIOHandlers, DIO_STLV_GET_HEX, Self);
  TDIOSetReceiptField.CreateCommand(FDIOHandlers, DIO_SET_RECEIPT_FIELD, Self);
  TDIOAddItemCode.CreateCommand(FDIOHandlers, DIO_ADD_ITEM_CODE, Self);
  TDIOFSSyncRegisters.CreateCommand(FDIOHandlers, DIO_FS_SYNC_REGISTERS, Self);
  TDIOFSReadMemStatus.CreateCommand(FDIOHandlers, DIO_FS_READ_MEM_STATUS, Self);
  TDIOFSWriteTLVBuffer.CreateCommand(FDIOHandlers, DIO_FS_WRITE_TLV_BUFFER, Self);
  TDIOFSGenerateRandomData.CreateCommand(FDIOHandlers, DIO_FS_GENERATE_RANDOM_DATA, Self);
  TDIOFSAuthorize.CreateCommand(FDIOHandlers, DIO_FS_AUTHORIZE, Self);
  TDIOFSReadTicketStatus.CreateCommand(FDIOHandlers, DIO_FS_READ_TICKET_STATUS, Self);
end;

procedure TFiscalPrinterImpl.SetPrinter(APrinter: ISharedPrinter);
begin
  FMonitoring.Free;
  FOposDevice.Free;
  FCommandDefs.Free;
  FDIOHandlers.Free;
  FRetalix.Free;

  FPrinter := APrinter;
  FOposDevice := TOposServiceDevice19.Create(FPrinter.Device.Context.Logger);
  FOposDevice.ErrorEventEnabled := False;
  FCommandDefs := TCommandDefs.Create(FPrinter.Device.Context.Logger);
  FDIOHandlers := TDIOHandlers.Create(FPrinter.Device.Context);
  FRetalix := TRetalix.Create(FPrinter.Device.Context.MalinaParams.RetalixDBPath,
    FPrinter.Device.Context);
  FMonitoring := TMonitoringServer.Create;

  InternalInit;
end;


function TFiscalPrinterImpl.DoOpen(
  const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  try
    FInitPrinter := False;
    SetPrinter(SharedPrinter.GetPrinter(DeviceName));
    FPrinter.OnProgress := ProgressEvent;
    FPrinter.AddStatusLink(FStatusLink);
    FPrinter.AddConnectLink(FConnectLink);
    Printer.Open(DeviceName);
    FOposDevice.Open(DeviceClass, DeviceName, GetEventInterface(pDispatch));

    Logger.Debug(Logger.Separator);
    Logger.Debug('  LOG START');
    Logger.Debug('  ' + FOposDevice.ServiceObjectDescription);
    Logger.Debug('  ServiceObjectVersion     : ' + IntToStr(FOposDevice.ServiceObjectVersion));
    Logger.Debug('  File version             : ' + GetFileVersionInfoStr);
    Logger.Debug(Logger.Separator);

    if Parameters.QuantityDecimalPlaces = QuantityDecimalPlaces3 then
      FQuantityDecimalPlaces := 3;
    if Parameters.QuantityDecimalPlaces = QuantityDecimalPlaces6 then
      FQuantityDecimalPlaces := 6;


    Parameters.WriteLogParameters;
    Statistics.IniLoad('FiscalPrinter' + DeviceName);
    Statistics.DeviceCategory := 'FiscalPrinter';
    Statistics.UnifiedPOSVersion := '1.12.0';
    Statistics.ManufacturerName := 'SHTRIH-M';
    Statistics.InterfaceName := 'RS232';

    FReceiptPrinter := TFiscalReceiptPrinter.Create(Printer);

    Device.SetOnCommand(PrinterCommand);
    FCommandDefs.LoadFromFile(GetCommandDefsFileName);
    // initialize
    FSubtotalText := Parameters.SubtotalText;
    Filter.Enabled := Parameters.CompatLevel = CompatLevel2;
    UpdateDioHandlers;
    if Parameters.MonitoringEnabled then
    begin
      FMonitoring.Open(Parameters.MonitoringPort, Printer);
    end;
    {$IFDEF MALINA}
    FRetalix.Open;
    {$ENDIF}
    Result := ClearResult;
  except
    on E: Exception do
    begin
      DoCloseDevice;
      Result := HandleException(E);
    end;
  end;
end;

function TFiscalPrinterImpl.GetEventInterface(FDispatch: IDispatch): IOposEvents;
begin
  case Parameters.CCOType of
    CCOTYPE_RCS:
      Result := TOposEventsRCS.Create(FDispatch);
  else
    Result := TOposEventsNull.Create;
  end;
end;

function TFiscalPrinterImpl.GetDayNumber(
  const ParamValue, ParamName: WideString): Integer;
begin
  Result := 0;
  try
    Result := StrToInt(ParamValue);
  except
    on E: Exception do
      InvalidParameterValue(ParamName, ParamValue);
  end;

  if Result < 0 then
    RaiseOposException(OPOS_E_ILLEGAL, Tnt_WideFormat('%s < 0', [ParamName]));
end;

function TFiscalPrinterImpl.GetReceipt: TCustomReceipt;
var
  Context: TReceiptContext;
begin
  if FReceipt = nil then
  begin
    Context.Filter := Filter;
    Context.State := FPrinterState;
    Context.Printer := FReceiptPrinter;
    Context.FiscalReceiptStation := FFiscalReceiptStation;

    FReceipt := TCustomReceipt.Create(Context);
  end;
  Result := FReceipt;
end;

function TFiscalPrinterImpl.GetPrinter: ISharedPrinter;
begin
  if FPrinter = nil then
    raiseException('Printer = nil');

  Result := FPrinter;
end;

procedure TFiscalPrinterImpl.Connect;
var
  Status: TLongPrinterStatus;
  PrinterFlags: TPrinterFlags;
begin
  Printer.Connect;
  CancelReceipt;
  Device.UpdateInfo;
  Printer.ReadTables;
  Status := Device.ReadLongStatus;
  FDeviceMetrics := Device.GetDeviceMetrics;
  PrinterFlags := DecodePrinterFlags(Status.Flags);

  if PrinterFlags.DecimalPosition then
    Device.AmountDecimalPlaces := 2
  else
    Device.AmountDecimalPlaces := 0;

  // PhysicalDeviceName
  FOposDevice.PhysicalDeviceName := Tnt_WideFormat('%s, № %s', [
    FDeviceMetrics.DeviceName, Status.SerialNumber]);
  Logger.Debug('PhysicalDeviceName: ' + FOposDevice.PhysicalDeviceName);

  // PhysicalDeviceDescription
  FOposDevice.PhysicalDeviceDescription :=
    Tnt_WideFormat('%s, № %s, %s: %s.%s.%d %s, %s: %s.%s.%d %s', [
    FDeviceMetrics.DeviceName,
    Status.SerialNumber,
    _('ПО ФР'),
    Status.FirmwareVersionHi,
    Status.FirmwareVersionLo,
    Status.FirmwareBuild,
    PrinterDateToStr(Status.FirmwareDate),
    _('ПО ФП'),
    Status.FMVersionHi,
    Status.FMVersionLo,
    Status.FMBuild,
    PrinterDateToStr(Status.FMFirmwareDate)]);
  Logger.Debug('PhysicalDeviceDescription: ' + FOposDevice.PhysicalDeviceDescription);

  FCapCoverSensor := Device.GetModel.CapCoverSensor;
  FCapJrnPresent := Device.GetModel.CapJrnPresent;
  FCapJrnEmptySensor := Device.GetModel.CapJrnEmptySensor;
  FCapJrnNearEndSensor := Device.GetModel.CapJrnNearEndSensor;
  FCapRecPresent := Device.GetModel.CapRecPresent;
  FCapRecEmptySensor := Device.GetModel.CapRecEmptySensor;
  FCapRecNearEndSensor := GetCapRecNearEnd(Device.GetModel.CapRecNearEndSensor);
  FCapSlpFullSlip := Device.GetModel.CapSlpFullSlip;
  FCapSlpEmptySensor := Device.GetModel.CapSlpEmptySensor;
  FCapSlpFiscalDocument := Device.GetModel.CapSlpFiscalDocument;
  FCapSlpNearEndSensor := Device.GetModel.CapSlpNearEndSensor;
  FCapSlpPresent := Device.GetModel.CapSlpPresent;
  FStartHeaderLine := Device.GetModel.StartHeaderLine;
  FCapAmountAdjustment := True;
  FCapPositiveAdjustment := FCapAmountAdjustment;
  FCapPercentAdjustment := FCapAmountAdjustment;
  FCapSubPercentAdjustment := True;
  FCapSetVatTable := not Device.CapFiscalStorage;
  // update only at first connection
  FDayOpened := Status.Mode <> ECRMODE_CLOSED;
  Statistics.ModelName := FDeviceMetrics.DeviceName;
  Statistics.SerialNumber := Status.SerialNumber;
  Statistics.FirmwareRevision := Tnt_WideFormat('%s.%s, build %d', [
    Status.FirmwareVersionHi, Status.FirmwareVersionLo,
    Status.FirmwareBuild]);
  Statistics.InstallationDate := '';

  FDocumentNumber := GetLongStatus.DocumentNumber;

  WriteDeviceTables;
end;

function TFiscalPrinterImpl.GetCapRecNearEnd(Value: Boolean): Boolean;
begin
  Logger.Debug('GetCapRecNearEnd', [Value]);
  case Parameters.CapRecNearEndSensorMode of
    SensorModeAuto: Result := Value;
    SensorModeTrue: Result := True;
    SensorModeFalse: Result := False;
  else
    Result := Value;
  end;
  Logger.Debug('GetCapRecNearEnd', [Value], Result);
end;

procedure TFiscalPrinterImpl.PrinterCommand(Sender: TObject;
  var Command: TCommandRec);
begin
  // $50, Previous command is printing
  if Command.ResultCode = $50 then
  begin
    Sleep(1000);
    WaitForPrinting;
    Command.RepeatFlag := True;
    Exit;
  end;
  // $58, Waiting for continue printing command
  if (Command.ResultCode = $58)and(Command.Code <> $B0) then
  begin
    Device.ContinuePrint;
    Command.RepeatFlag := True;
    Exit;
  end;
end;

procedure TFiscalPrinterImpl.PrintLogo;
begin
  Printer.PrintLogo;
end;

procedure TFiscalPrinterImpl.PrintLogo2(Position: Integer);
begin
  if Parameters.LogoPosition = Position then
  begin
    Printer.PrintLogo;
  end;
end;

procedure TFiscalPrinterImpl.ProgressEvent(Progress: Integer);
var
  pData: Integer;
  pString: WideString;
begin
  pString := '';
  pData := Progress;
  DirectIOEvent(DIRECTIO_EVENT_PROGRESS, pData, pString);
end;

function TFiscalPrinterImpl.DoCloseDevice: Integer;
begin
  try
    SetDeviceEnabled(False);
    FOposDevice.Close;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.DoClose: Integer;
begin
  try
    Result := DoCloseDevice;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.DoRelease: Integer;
begin
  try
    FOposDevice.ReleaseDevice;
    SetDeviceEnabled(False);
    Printer.ReleaseDevice;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.DirectIOEvent(EventNumber: Integer;
  var pData: Integer; var pString: WideString);
begin
  FOposDevice.FireEvent(TDirectIOEvent.Create(EventNumber, pData, pString, Logger));
end;

procedure TFiscalPrinterImpl.SetFreezeEvents(Value: Boolean);
begin
  FOposDevice.FreezeEvents := Value;
end;

procedure TFiscalPrinterImpl.PrintText(const Text: WideString);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Printer.Station;
  Data.Font := Parameters.FontNumber;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

procedure TFiscalPrinterImpl.PrintText(const Text: WideString; Station: Integer);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Parameters.FontNumber;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

function TFiscalPrinterImpl.GetModulePath: WideString;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(GetModuleFileName));
end;

function TFiscalPrinterImpl.GetCommandDefsFileName: WideString;
begin
  Result :=  GetModulePath + 'commands.xml';
end;

procedure TFiscalPrinterImpl.SetDeviceEnabled(Value: Boolean);
begin
  if Value <> FDeviceEnabled then
  begin
    if Value then
    begin
      Connect;
      Printer.PollEnabled := Parameters.PropertyUpdateMode = PropertyUpdateModePolling;
      if (Parameters.PingEnabled and (Parameters.ConnectionType = ConnectionTypeSocket)) then
      begin
        Printer.StartPing;
      end;
    end else
    begin
      Printer.StopPing;
      Printer.PollEnabled := False;
      FOposDevice.PowerState := OPOS_PS_UNKNOWN;
      Printer.Disconnect;
    end;
    FDeviceEnabled := Value;
    FOposDevice.DeviceEnabled := Value;

    if Parameters.FSServiceEnabled then
    begin
      if Value then
      begin
        FService := TFSService.Create(Printer.Device);
      end else
      begin
        FService.Free;
        FService := nil;
      end;
    end;
    Filters.SetDeviceEnabled(Value);
  end;
end;

procedure TFiscalPrinterImpl.CancelReceipt;
var
  Data: TTextRec;
begin
  WaitForPrinting;
  if Device.CapFiscalStorage then
  begin
    Device.CancelReceipt;
    Exit;
  end;

  if Device.IsRecOpened then
  begin
    Device.CancelReceipt;
    PrintFiscalEnd;
  end else
  begin
    if (FPrinterState.State = FPTR_PS_FISCAL_RECEIPT) then
    begin
      Data.Text := Parameters.VoidRecText;
      Data.Station := PRINTER_STATION_REC;
      Data.Font := Parameters.FontNumber;
      Data.Alignment := taLeft;
      Data.Wrap := Parameters.WrapText;
      Device.PrintText(Data);
      PrintFiscalEnd;
    end;
    if (FPrinterState.State = FPTR_PS_NONFISCAL) then
    begin
      PrintFiscalEnd;
    end;
  end;
end;

procedure TFiscalPrinterImpl.WriteDeviceTables;
var
  i: Integer;
  TableInfo: TPrinterTableRec;
const
  BoolToStr: array [Boolean] of WideString = ('0', '1');
begin
  try
    Device.LoadTables(Parameters.TableFilePath);

    case Parameters.HeaderType of
      HeaderTypePrinter:
      begin
        ReadHeader;
        ReadTrailer;
        if Parameters.TableEditEnabled then
        begin
          Device.WriteParameter(PARAMID_CUT_TYPE, Parameters.CutType);
          Device.WriteParameter(PARAMID_PRINT_TRAILER, VALUEID_ENABLED);
        end;
      end;
      HeaderTypeDriver,
      HeaderTypeNone:
      begin
        if Parameters.TableEditEnabled then
        begin
          Device.Check(Device.ReadTableStructure(PRINTER_TABLE_TEXT, TableInfo));
          for i := 1 to TableInfo.RowCount do
            Device.WriteTable(PRINTER_TABLE_TEXT, i, 1, '');

          Device.WriteParameter(PARAMID_CUT_TYPE, VALUEID_CUT_NONE);
          Device.WriteParameter(PARAMID_PRINT_TRAILER, VALUEID_DISABLED);
        end;
      end;
    end;
  except
    on E: Exception do
      Logger.Error(GetExceptionMessage(E));
  end;
end;

procedure TFiscalPrinterImpl.ReadHeader;
var
  i: Integer;
  Row: Integer;
  Line: WideString;
  TableInfo: TPrinterTableRec;
begin
  Device.Check(Device.ReadTableStructure(PRINTER_TABLE_TEXT, TableInfo));
  for i := 0 to Printer.NumHeaderLines-1 do
  begin
    Row := Device.Model.StartHeaderLine + i;

    Line := '';
    if Row <= TableInfo.RowCount then
    begin
      Line := Device.ReadTableStr(PRINTER_TABLE_TEXT, Row, 1);
      if Line = '' then
      begin
        Line := Printer.Header[i];
        if Line = '' then Line := ' ';
        Device.WriteTable(PRINTER_TABLE_TEXT, Row, 1, Line);
      end;
    end;
    Printer.Header[i] := Line;
  end;
end;

procedure TFiscalPrinterImpl.ReadTrailer;
var
  i: Integer;
  Row: Integer;
  Line: WideString;
  TableInfo: TPrinterTableRec;
begin
  Device.Check(Device.ReadTableStructure(PRINTER_TABLE_TEXT, TableInfo));
  for i := 0 to Printer.NumTrailerLines-1 do
  begin
    Row := Device.Model.StartTrailerLine + i;
    Line := '';
    if Row <= TableInfo.RowCount then
    begin
      Line := Device.ReadTableStr(PRINTER_TABLE_TEXT, Row, 1);
      if Line = '' then
      begin
        Line := Printer.Trailer[i];
        if Line = '' then Line := ' ';
        Device.WriteTable(PRINTER_TABLE_TEXT, Row, 1, Line);
      end;
    end;
    Printer.Trailer[i] := Line;
  end;
end;

procedure TFiscalPrinterImpl.SetRecPaperState(IsEmpty, IsNearEnd: Boolean);
var
  PaperStatus: Integer;
begin
  FRecStatus.IsEmpty := False;
  FRecStatus.IsNearEnd := False;
  if FCapRecPresent then
  begin
    if FCapRecEmptySensor then
      FRecStatus.IsEmpty := IsEmpty;

    if FCapRecNearEndSensor then
      FRecStatus.IsNearEnd := IsNearEnd;

    PaperStatus := FPTR_SUE_REC_PAPEROK;
    if FCapRecNearEndSensor and IsNearEnd then
      PaperStatus := FPTR_SUE_REC_NEAREMPTY;

    if FCapRecEmptySensor and IsEmpty then
      PaperStatus := FPTR_SUE_REC_EMPTY;

    if PaperStatus <> FRecStatus.Status then
    begin
      FRecStatus.Status := PaperStatus;
      FOposDevice.StatusUpdateEvent(PaperStatus);
    end;
  end;
end;

procedure TFiscalPrinterImpl.SetJrnPaperState(IsEmpty, IsNearEnd: Boolean);
var
  PaperStatus: Integer;
begin
  FJrnStatus.IsEmpty := False;
  FJrnStatus.IsNearEnd := False;
  if FCapJrnPresent then
  begin
    if FCapJrnEmptySensor then
      FJrnStatus.IsEmpty := IsEmpty;
    if FCapJrnNearEndSensor then
      FJrnStatus.IsNearEnd := IsNearEnd;

    PaperStatus := FPTR_SUE_JRN_PAPEROK;
    if IsNearEnd then
      PaperStatus := FPTR_SUE_JRN_NEAREMPTY;
    if IsEmpty then
      PaperStatus := FPTR_SUE_JRN_EMPTY;

    if PaperStatus <> FJrnStatus.Status then
    begin
      FJrnStatus.Status := PaperStatus;
      FOposDevice.StatusUpdateEvent(PaperStatus);
    end;
  end;
end;

procedure TFiscalPrinterImpl.SetCoverState(CoverOpened: Boolean);
begin
  if FCapCoverSensor then
  begin
    if CoverOpened <> FCoverOpened then
    begin
      if CoverOpened then
      begin
        Statistics.ReceiptCoverOpened;
        FOposDevice.StatusUpdateEvent(FPTR_SUE_COVER_OPEN);
      end else
      begin
        FOposDevice.StatusUpdateEvent(FPTR_SUE_COVER_OK);
      end;
      FCoverOpened := CoverOpened;
    end;
  end;
end;

procedure TFiscalPrinterImpl.PowerStateChanged(Sender: TObject);
begin
  if Printer.Device.IsOnline then
  begin
    FOposDevice.PowerState := OPOS_PS_ONLINE;
  end else
  begin
    FOposDevice.PowerState := OPOS_PS_OFF_OFFLINE;
  end;
end;

procedure TFiscalPrinterImpl.StatusChanged(Sender: TObject);
var
  Flags: TPrinterFlags;
  Status: TPrinterStatus;
begin
  try
    Status := Device.PrinterStatus;
    Flags := Status.Flags;
    SetRecPaperState(Flags.RecEmpty, Flags.RecNearEnd);
    SetJrnPaperState(Flags.JrnEmpty, Flags.JrnNearEnd);
    SetCoverState(Flags.CoverOpened);
    FDayOpened := Device.IsDayOpened(Status.Mode);
    if Status.AdvancedMode = AMODE_AFTER then
    begin
      PrintNonFiscalEnd;
    end;
  except
    on E: Exception do
      Logger.Error('TFiscalPrinterImpl.StatusChanged', E);
  end;
end;

procedure TFiscalPrinterImpl.InternalInit;
begin
  FDayOpened := False;
  FCapAdditionalLines := True;
  FCapAmountAdjustment := True;
  FCapAmountNotPaid := False;
  FCapCheckTotal := True;
  FCapCoverSensor := True;
  FCapDoubleWidth := True;
  FCapDuplicateReceipt := True;
  FCapFixedOutput := False;
  FCapHasVatTable := True;
  FCapIndependentHeader := False;
  FCapItemList := False;
  FCapJrnEmptySensor := False;
  FCapJrnNearEndSensor := False;
  FCapJrnPresent := False;
  FCapNonFiscalMode := True;
  FCapOrderAdjustmentFirst := False;
  FCapPercentAdjustment := True;
  FCapPositiveAdjustment := True;
  FCapPowerLossReport := False;
  FCapPredefinedPaymentLines := True;
  FCapReceiptNotPaid := False;
  FCapRecEmptySensor := True;
  FCapRecNearEndSensor := False;
  FCapRecPresent := True;
  FCapRemainingFiscalMemory := True;
  FCapReservedWord := False;
  FCapSetPOSID := True;
  FCapSetStoreFiscalID := False;
  FCapSetVatTable := True;
  FCapSlpEmptySensor := False;
  FCapSlpFiscalDocument := False;
  FCapSlpFullSlip := False;
  FCapSlpNearEndSensor := False;
  FCapSlpPresent := False;
  FCapSlpValidation := False;
  FCapSubAmountAdjustment := True;
  FCapSubPercentAdjustment := True;
  FCapSubtotal := True;
  FCapTrainingMode := True;
  FCapValidateJournal := False;
  FCapXReport := True;
  FCapAdditionalHeader := True;
  FCapAdditionalTrailer := True;
  FCapChangeDue := False;
  FCapEmptyReceiptIsVoidable := True;
  FCapFiscalReceiptStation := True;
  FCapFiscalReceiptType := True;
  FCapMultiContractor := False;
  FCapOnlyVoidLastItem := False;
  FCapPackageAdjustment := True;
  FCapPostPreLine := True;
  FCapSetCurrency := False;
  FCapTotalizerType := True;
  FCapPositiveSubtotalAdjustment := True;

  FAsyncMode := False;
  FCoverOpened := False;
  FDuplicateReceipt := False;
  FFlagWhenIdle := False;
  // integer
  FOposDevice.ServiceObjectVersion := GenericServiceVersion;
  FCountryCode := FPTR_CC_RUSSIA;
  FErrorLevel := FPTR_EL_NONE;
  FErrorOutID := 0;
  FErrorState := FPTR_PS_MONITOR;
  FErrorStation := FPTR_S_RECEIPT;

  FJrnStatus.IsEmpty := False;
  FJrnStatus.IsNearEnd := False;
  FJrnStatus.Status := FPTR_SUE_JRN_PAPEROK;

  FRecStatus.IsEmpty := False;
  FRecStatus.IsNearEnd := False;
  FRecStatus.Status := FPTR_SUE_REC_PAPEROK;

  FSlpStatus.IsEmpty := False;
  FSlpStatus.IsNearEnd := False;
  FSlpStatus.Status := FPTR_SUE_SLP_PAPEROK;

  FNumVatRates := 4;
  SetPrinterState(FPTR_PS_MONITOR);
  FQuantityDecimalPlaces := 3;
  FQuantityLength := 10;
  FSlipSelection := FPTR_SS_FULL_LENGTH;
  FActualCurrency := FPTR_AC_RUR;
  FContractorId := FPTR_CID_SINGLE;
  FDateType := FPTR_DT_RTC;
  FFiscalReceiptStation := FPTR_RS_RECEIPT;
  FFiscalReceiptType := FPTR_RT_SALES;
  FMessageType := FPTR_MT_FREE_TEXT;
  FTotalizerType := FPTR_TT_DAY;

  FAdditionalHeader := '';
  FAdditionalTrailer := '';
  FOposDevice.PhysicalDeviceName := FPTR_DEVICE_DESCRIPTION;
  FOposDevice.PhysicalDeviceDescription := FPTR_DEVICE_DESCRIPTION;
  FOposDevice.ServiceObjectDescription := 'OPOS Fiscal Printer Service. SHTRIH-M, 2019';
  FPredefinedPaymentLines := '0,1,2,3';
  FReservedWord := '';
  FChangeDue := '';
  FHeaderEnabled := True;
  SetFreezeEvents(False);
end;

procedure TFiscalPrinterImpl.CheckEndDay;
begin
  if Device.ReadPrinterStatus.Mode = ECRMODE_24OVER then
    raiseExtendedError(OPOS_EFPTR_DAY_END_REQUIRED,
    _('Истекли 24 часа. Распечатайте Z отчет и попробуйте снова'));
end;

procedure TFiscalPrinterImpl.CheckCapSlpFiscalDocument;
begin
  { !!! }
end;

function TFiscalPrinterImpl.IllegalError: Integer;
begin
  Result := FOposDevice.SetResultCode(OPOS_E_ILLEGAL);
end;

procedure TFiscalPrinterImpl.CheckState(AState: Integer);
begin
  CheckEnabled;
  FPrinterState.CheckState(AState);
end;

function TFiscalPrinterImpl.GetPrinterState: Integer;
begin
  Result := FPrinterState.State;
end;

procedure TFiscalPrinterImpl.SetPrinterState(Value: Integer);
begin
  FPrinterState.SetState(Value);
end;

function TFiscalPrinterImpl.ClearResult: Integer;
begin
  Result := FOposDevice.ClearResult;
end;

procedure TFiscalPrinterImpl.CheckHealthExternal;
var
  PrinterStatus: TPrinterStatus;
begin
  FOposDevice.CheckHealthText := _('External HCheck: ');
  try
    PrinterStatus := WaitForPrinting;
    if (PrinterStatus.Mode <> ECRMODE_TEST) then
    begin
      Device.StartTest(1);
      WaitForPrinting;
    end;
    Device.StopTest;
    WaitForPrinting;
    FOposDevice.CheckHealthText := FOposDevice.CheckHealthText + 'OK.';
  except
    on E: Exception do
    begin
      FOposDevice.CheckHealthText := FOposDevice.CheckHealthText + GetExceptionMessage(E);
      raise;
    end;
  end;
end;

procedure TFiscalPrinterImpl.CheckHealthInternal;
var
  Lines: TTntStrings;
  FMFlags: TFMFlags;
  Status: TLongPrinterStatus;
  PrinterFlags: TPrinterFlags;
begin
  Lines := TTntStringList.Create;
  try
    Status := Device.ReadLongStatus;
    FMFlags := Device.GetFMFlags(Status.FMFlags);
    PrinterFlags := DecodePrinterFlags(Status.Flags);
    // Cover opened
    if FCapCoverSensor and PrinterFlags.CoverOpened then
    begin
      Lines.Add(_('Крышка открыта'));
    end;
    // Receipt paper
    if FCapRecPresent then
    begin
      if FCapRecEmptySensor and PrinterFlags.RecEmpty then
        Lines.Add(_('Нет чековой ленты'));

      if FCapRecNearEndSensor and PrinterFlags.RecNearEnd then
        Lines.Add(_('Чековая лента близка к завершению'));

      if Device.GetModel.CapRecLever and PrinterFlags.RecLeverUp then
        Lines.Add(_('Поднят рычаг чековой ленты'));
    end;
    // Journal paper
    if FCapJrnPresent then
    begin
      if FCapJrnEmptySensor and PrinterFlags.JrnEmpty then
      Lines.Add(_('Нет контрольной ленты'));

      if FCapJrnNearEndSensor and PrinterFlags.JrnNearEnd then
        Lines.Add(_('Контрольная лента близка к завершению'));

      if Device.GetModel.CapJrnLever and PrinterFlags.JrnLeverUp then
        Lines.Add(_('Поднят рычаг контрольной ленты'));
    end;
    // EJ
    if (PrinterFlags.EJPresent and PrinterFlags.EJNearEnd) then
      Lines.Add(_('ЭКЛЗ близка к заполнению'));

    // FM
    if FMFlags.Overflow then
      Lines.Add(_('Переполнение ФП'));

    if FMFlags.LowBattery then
      Lines.Add(_('Низкое напряжение батареи ФП'));

    if FMFlags.LastRecordCorrupted then
      Lines.Add(_('Последняя запись ФП повреждена'));

    if FMFlags.Is24HoursLeft then
      Lines.Add(_('Истекли 24 часа в ФП'));

    if Lines.Count <> 0 then
    begin
      Lines.Insert(0, _('Internal HCheck: '));
      FOposDevice.CheckHealthText := Lines.Text;
    end else
    begin
      FOposDevice.CheckHealthText := _('Internal HCheck: ') + 'OK';
    end;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterImpl.GetTrailerLine(N: Integer): WideString;
begin
  Result := Printer.Trailer.GetLine(N);
  if Parameters.CenterHeader then
    Result := Device.CenterLine(Result);
end;


procedure TFiscalPrinterImpl.PrintEmptyHeader;
var
  i: Integer;
  Data: TTextRec;
begin
  for i := 1 to Device.GetModel.NumHeaderLines do
  begin
    Data.Text := '';
    Data.Station := PRINTER_STATION_REC;
    Data.Font := Parameters.HeaderFont;
    Data.Alignment := taLeft;
    Data.Wrap := False;
    Device.PrintText(Data);
  end;
end;

procedure TFiscalPrinterImpl.PrintReportEnd;
begin
  try
    PrintNonFiscalEnd;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.PrintNonFiscalEnd;
begin
  if not FHeaderEnabled then
  begin
    FHeaderEnabled := True;
    Exit;
  end;

  WaitForPrinting;
  PrintLogo2(LogoAfterTotal);
  Receipt.PrintRecMessages;
  case Parameters.HeaderType of
    HeaderTypeNone: ;
    HeaderTypePrinter: ;
    HeaderTypeDriver:
    begin
      PrintTrailer;
      PrintHeader;
    end;
  end;
end;

procedure TFiscalPrinterImpl.PrintFiscalEnd;
begin
  if Device.GetDocPrintMode = 0 then
    PrintNonFiscalEnd;
end;

procedure TFiscalPrinterImpl.PrintTrailer;
var
  i: Integer;
  Data: TTextRec;
begin
  WaitForPrinting;
  PrintLogo2(LogoBeforeTrailer);
  if not Device.GetModel.CapFixedTrailer then
  begin
    for i := 0 to Parameters.NumTrailerLines-1 do
    begin
      Data.Text := GetTrailerLine(i);
      Data.Station := Printer.Station;
      Data.Font := Parameters.HeaderFont;
      Data.Alignment := taLeft;
      Data.Wrap := False;
      Device.PrintText(Data);
    end;
  end;
  PrintLogo2(LogoAfterTrailer);
  if FAdditionalTrailer <> '' then
    PrintText(FAdditionalTrailer, PRINTER_STATION_REC);
end;

procedure TFiscalPrinterImpl.PrintHeader;
var
  SaveStation: Integer;
begin
  SaveStation := Printer.Station;
  try
    if not Parameters.JournalPrintHeader then
      Printer.Station := PRINTER_STATION_REC;
    DoPrintHeader;
  finally
    Printer.Station := SaveStation;
  end;
end;

procedure TFiscalPrinterImpl.DoPrintHeader;
var
  Font: TFontInfo;
  LineCount: Integer;
begin
  if Parameters.LogoPosition = LogoBeforeHeader then
  begin
    if Parameters.LogoSize <= Device.GetHeaderHeight then
    begin
      PrintLogo2(LogoBeforeHeader);

      Font := Device.GetFont(Parameters.HeaderFont);
      LineCount := Device.GetModel.NumHeaderLines - 1 -
        (Parameters.LogoSize + Font.CharHeight - 1) div Font.CharHeight;

      if Device.GetModel.CapAutoFeedOnCut then
      begin
        Printer.CutPaper;
        PrintHeaderLines(0, Printer.Header.Count-1);
      end else
      begin
        PrintHeaderLines(0, LineCount-1);
        Printer.CutPaper;
        PrintHeaderLines(LineCount, Printer.Header.Count-1);
      end;
    end else
    begin
      if not Device.GetModel.CapAutoFeedOnCut then
      begin
        PrintEmptyHeader;
      end;
      Printer.CutPaper;
      PrintLogo2(LogoBeforeHeader);
      PrintHeaderLines(0, Printer.Header.Count-1);
    end;
  end else
  begin
    if Device.GetModel.CapAutoFeedOnCut then
    begin
      Printer.CutPaper;
      PrintHeaderLines(0, Printer.Header.Count-1);
    end else
    begin
      PrintHeaderLines(0, Device.GetModel.NumHeaderLines-1);
      Printer.CutPaper;
      PrintHeaderLines(Device.GetModel.NumHeaderLines, Printer.Header.Count-1);
    end;
  end;
  if FAdditionalHeader <> '' then
  begin
    Device.PrintText(PRINTER_STATION_REC, FAdditionalHeader);
    FAdditionalHeader := '';
  end;
  Parameters.HeaderPrinted := True;
  SaveParameters;
  PrintLogo2(LogoAfterHeader);
end;

procedure TFiscalPrinterImpl.PrintHeaderLines(Index1, Index2: Integer);
var
  i: Integer;
  Data: TTextRec;
begin
  for i := Index1 to Index2 do
  begin
    Data.Text := Printer.Header.GetLine(i);
    if Parameters.CenterHeader then
      Data.Text := Device.CenterLine(Data.Text);

    Data.Station := PRINTER_STATION_REC;
    Data.Font := Parameters.HeaderFont;
    Data.Alignment := taLeft;
    Data.Wrap := False;
    Device.PrintText(Data);
  end;
end;

// IFiscalPrinter

function TFiscalPrinterImpl.BeginFiscalDocument(
  DocumentAmount: Integer): Integer;
begin
  try
    CheckEnabled;
    CheckCapSlpFiscalDocument;
    CheckState(FPTR_PS_MONITOR);

    CheckEndDay;
    Device.ResetPrinter;

    SetPrinterState(FPTR_PS_FISCAL_DOCUMENT);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.CreateNullReceipt: TCustomReceipt;
var
  Context: TReceiptContext;
begin
  Context.State := FPrinterState;
  Context.Printer := FReceiptPrinter;
  Context.FiscalReceiptStation := FFiscalReceiptStation;
  Result := TCustomReceipt.Create(Context);
end;

function TFiscalPrinterImpl.CreateReceipt(FiscalReceiptType: Integer): TCustomReceipt;
var
  Context: TReceiptContext;
begin
  Context.State := FPrinterState;
  Context.Printer := FReceiptPrinter;
  Context.FiscalReceiptStation := FFiscalReceiptStation;

  case FiscalReceiptType of
    FPTR_RT_CASH_IN:
      Result := TCashInReceipt.Create(Context);

    FPTR_RT_CASH_OUT:
      Result := TCashOutReceipt.Create(Context);

    FPTR_RT_SALES,
    FPTR_RT_GENERIC,
    FPTR_RT_SERVICE,
    FPTR_RT_SIMPLE_INVOICE:
      Result := CreateSalesReceipt(RecTypeSale);

    FPTR_RT_REFUND:
      Result := CreateSalesReceipt(RecTypeRetSale);

    FPTR_RT_CORRECTION_SALE:
      Result := CreateCorrectionReceipt(1);

    FPTR_RT_CORRECTION_BUY:
      Result := CreateCorrectionReceipt(3);

    FPTR_RT_CORRECTION2_SALE:
      Result := CreateCorrectionReceipt2(1);

    FPTR_RT_CORRECTION2_BUY:
      Result := CreateCorrectionReceipt2(3);

    FPTR_RT_SALES_SALE:
      Result := CreateSalesReceipt(RecTypeSale);

    FPTR_RT_SALES_RETSALE:
      Result := CreateSalesReceipt(RecTypeRetSale);

    FPTR_RT_SALES_BUY:
      Result := CreateSalesReceipt(RecTypeBuy);

    FPTR_RT_SALES_RETBUY:
      Result := CreateSalesReceipt(RecTypeRetBuy);
  else
    Result := nil;
    InvalidPropertyValue('FiscalReceiptType', IntToStr(FiscalReceiptType));
  end;
end;

function TFiscalPrinterImpl.CreateNormalSalesReceipt(RecType: Integer): TCustomReceipt;
var
  Context: TReceiptContext;
begin
  Context.State := FPrinterState;
  Context.Printer := FReceiptPrinter;
  Context.FiscalReceiptStation := FFiscalReceiptStation;
  if Device.CapFiscalStorage then
  begin
    Result := TFSSalesReceipt.CreateReceipt(Context, RecType);
  end else
  begin
    {$IFDEF MALINA}
    if GetMalinaParams.RosneftDiscountCards then
      Result := TRosneftSalesReceipt.CreateReceipt(Context, RecType)
    else
    {$ENDIF}
      Result := TSalesReceipt.CreateReceipt(Context, RecType);
  end;
end;

function TFiscalPrinterImpl.CreateSalesReceipt(RecType: Integer): TCustomReceipt;
var
  Context: TReceiptContext;
begin
  Context.State := FPrinterState;
  Context.Printer := FReceiptPrinter;
  Context.FiscalReceiptStation := FFiscalReceiptStation;

  case Parameters.ReceiptType of
    ReceiptTypeNormal:
    begin
      Result := CreateNormalSalesReceipt(RecType);
    end;
    ReceiptTypeSingleSale:
    begin
      Result := TTextReceipt.CreateReceipt(Context, RecType);
    end;
    ReceiptTypeGlobus:
    begin
      Result := TGlobusReceipt.CreateReceipt(Context, RecType);
    end;
    ReceiptTypeGlobus2:
    begin
      Result := TGlobusTextReceipt.CreateReceipt(Context, RecType);
    end;
  else
    Result := CreateNormalSalesReceipt(RecType);
  end;
end;


function TFiscalPrinterImpl.CreateCorrectionReceipt(RecType: Integer): TCustomReceipt;
var
  Context: TReceiptContext;
begin
  Context.RecType := RecType;
  Context.State := FPrinterState;
  Context.Printer := FReceiptPrinter;
  Context.FiscalReceiptStation := FFiscalReceiptStation;
  Result := TCorrectionReceipt.Create(Context);
end;

function TFiscalPrinterImpl.CreateCorrectionReceipt2(RecType: Integer): TCustomReceipt;
var
  Context: TReceiptContext;
begin
  Context.RecType := RecType;
  Context.State := FPrinterState;
  Context.Printer := FReceiptPrinter;
  Context.FiscalReceiptStation := FFiscalReceiptStation;
  Result := TCorrectionReceipt2.Create(Context);
end;

procedure TFiscalPrinterImpl.CheckInitPrinter;
begin
  if not FInitPrinter then
  begin
    CancelReceipt;
    Device.CheckPrinterStatus;
    Device.CorrectDate;
    FInitPrinter := True;
  end;
end;

procedure TFiscalPrinterImpl.OpenFiscalDay;
begin
  if Device.CapFiscalStorage then
  begin
    if Device.OpenFiscalDay then
      PrintNonFiscalEnd;
  end;
end;

function TFiscalPrinterImpl.BeginFiscalReceipt(APrintHeader: WordBool): Integer;
begin
  try
    Printer.UpdateParams;
    CheckEnabled;
    CheckInitPrinter;
    CheckState(FPTR_PS_MONITOR);
    // In case of fiscal receipt
    case FFiscalReceiptType of
      FPTR_RT_SALES,
      FPTR_RT_GENERIC,
      FPTR_RT_SERVICE,
      FPTR_RT_SIMPLE_INVOICE,
      FPTR_RT_REFUND:
        CheckEndDay;
    end;
    UpdatePrinterDate;
    OpenFiscalDay;
    Filters.BeginFiscalReceipt;

    SetPrinterState(FPTR_PS_FISCAL_RECEIPT);

    FReceipt.Free;
    FReceipt := CreateReceipt(FFiscalReceiptType);
    Receipt.BeginFiscalReceipt(APrintHeader);
    Filters.BeginFiscalReceipt2(FReceipt);
    FAfterCloseItems.Clear;

    if Parameters.UsePrintHeaderParameter and APrintHeader then
    begin
      PrintHeaderBegin;
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.PrintHeaderBegin;
begin
  PrintLogo2(LogoBeforeHeader);
  PrintHeaderLines(0, Printer.Header.Count-1);
  if FAdditionalHeader <> '' then
  begin
    Device.PrintText(PRINTER_STATION_REC, FAdditionalHeader);
    FAdditionalHeader := '';
  end;
  PrintLogo2(LogoAfterHeader);

  Parameters.HeaderPrinted := True;
  SaveParameters;
end;

(*
1.	Добавляем в драйвер настройку, отключающую синхронизацию времени по
    команде ОПОС, и включающую автоматическую синхронизацию при открытии
    смены (перед собственно открытием).
    Это чтобы с момента снятия Z-отчёта прошло чуть больше времени.

2.	Если при переводе времени в ФН обнаруживается запись с более поздним
    временем - выводим модальное окно с предложением либо подождать N времени,
    либо отменить синхронизацию.

3.	Как вариант - третий вариант настройки, отключающий кнопку отмены синхронизации.
*)

procedure TFiscalPrinterImpl.UpdatePrinterDate;
var
  Seconds: Integer;
  PCDate: TDateTime;
  FSDate: TDateTime;
  FSState: TFSState;
  PrinterDate: TPrinterDate;
  PrinterTime: TPrinterTime;
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  if not Device.CapFiscalStorage then Exit;
  if (not Device.IsDayOpened(Device.WaitForPrinting.Mode)) then
  begin
    if Parameters.TimeUpdateMode > TimeUpdateModeNormal then
    begin
      Device.Check(Device.FSReadState(FSState));
      PCDate := Now;
      FSDate := PrinterDateToDate(FSState.Date) + PrinterTimeToTime(FSState.Time);
      if FSDate > PCDate then
      begin
        if MinutesBetween(FSDate, PCDate) > 60 then Exit;
        Seconds := SecondsBetween(FSDate, PCDate);
        if Seconds >= 3 then
        begin
          if not ShowTimeDialog(FSDate,
            Parameters.TimeUpdateMode = TimeUpdateModeOpenDay) then Exit;
        end else
        begin
          Sleep(3000);
        end;
        PCDate := Now;
        DecodeDate(PCDate, Year, Month, Day);
        DecodeTime(PCDate, Hour, Min, Sec, MSec);

        PrinterDate.Day := Day;
        PrinterDate.Month := Month;
        PrinterDate.Year := Year mod 100;
        PrinterTime.Hour := Hour;
        PrinterTime.Min := Min;
        PrinterTime.Sec := Sec;

        Device.WriteDate(PrinterDate);
        Device.ConfirmDate(PrinterDate);
        Device.SetTime(PrinterTime);
      end;
    end;
  end;
end;

function TFiscalPrinterImpl.BeginFixedOutput(Station,
  DocumentType: Integer): Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.BeginInsertion(Timeout: Integer): Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.BeginItemList(VatID: Integer): Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.BeginNonFiscal: Integer;
begin
  try
    CheckEnabled;
    CheckState(FPTR_PS_MONITOR);
    SetPrinterState(FPTR_PS_NONFISCAL);
    NonFiscalDoc.BeginNonFiscal;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.BeginRemoval(Timeout: Integer): Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.BeginTraining: Integer;
begin
  try
    CheckEnabled;
    CheckState(FPTR_PS_MONITOR);
    if not FCapTrainingMode then
      RaiseOposException(OPOS_E_ILLEGAL, _('Режим тренировки не поддерживается'));

    FTrainingModeActive := True;
    FReceiptPrinter := TTrainingReceiptPrinter.Create(Printer);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.CheckHealth(Level: Integer): Integer;
begin
  try
    CheckEnabled;
    case Level of
      OPOS_CH_INTERNAL:
        CheckHealthInternal;

      OPOS_CH_EXTERNAL:
        CheckHealthExternal;

      OPOS_CH_INTERACTIVE:
        RaiseOposException(OPOS_E_ILLEGAL, _('Не поддерживается'));
    else
      InvalidParameterValue('Level', IntToStr(Level));
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.Claim(Timeout: Integer): Integer;
begin
  try
    FOposDevice.ClaimDevice(Timeout);
    Printer.ClaimDevice(Timeout);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := Claim(Timeout);
end;

function TFiscalPrinterImpl.ClearError: Integer;
begin
  Result := ClearResult;
end;

function TFiscalPrinterImpl.ClearOutput: Integer;
begin
  try
    FOposDevice.CheckClaimed;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.Close: Integer;
begin
  Result := DoClose;
end;

function TFiscalPrinterImpl.CloseService: Integer;
begin
  Result := DoClose;
end;

function TFiscalPrinterImpl.COFreezeEvents(Freeze: WordBool): Integer;
begin
  try
    SetFreezeEvents(Freeze);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.DirectIO(
  Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  try
    FOposDevice.CheckOpened;
    DIOHandlers.ItemByCommand(Command).DirectIO(pData, pString);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  if Parameters.IgnoreDirectIOErrors then
    Result := ClearResult;
end;

function TFiscalPrinterImpl.EndFiscalDocument: Integer;
begin
  Result := IllegalError;
end;

procedure TFiscalPrinterImpl.PrintReceiptItems(Items: TReceiptItems);
var
  i: Integer;
  ReceiptItem: TReceiptItem;
begin
  for i := 0 to Items.Count-1 do
  begin
    ReceiptItem := Items[i];
    if ReceiptItem is TTextReceiptItem then
    begin
      Device.PrintText((ReceiptItem as TTextReceiptItem).Data);
    end;
    if ReceiptItem is TBarcodeReceiptItem then
    begin
      Device.PrintBarcode2((ReceiptItem as TBarcodeReceiptItem).Data);
    end;
  end;
  Items.Clear;
end;

function TFiscalPrinterImpl.EndFiscalReceipt(APrintHeader: WordBool): Integer;
begin
  try
    Filters.BeforeCloseReceipt;
    Receipt.EndFiscalReceipt2;

    if Parameters.PrintRecMessageMode = PrintRecMessageModeBefore then
      PrintRecMessages;

    Receipt.EndFiscalReceipt;
    try
      FDocumentNumber := Device.ReadLongStatus.DocumentNumber;
      Filters.AfterCloseReceipt;

      if Parameters.UsePrintHeaderParameter and APrintHeader then
      begin
        PrintDocumentEnd;
      end else
      begin
        PrintTrailer;
        if not Device.GetModel.CapAutoFeedOnCut then
        begin
          PrintEmptyHeader;
        end;
        Printer.CutPaper;
      end;
      Device.ResetPrinter;
    except
      on E: Exception do
      begin
        Logger.Error(E.Message);
      end;
    end;

    FReceipt.Free;
    FReceipt := CreateNullReceipt;
    SetPrinterState(FPTR_PS_MONITOR);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.EndFixedOutput: Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.EndInsertion: Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.EndItemList: Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.EndNonFiscal: Integer;
begin
  try
    CheckEnabled;
    CheckState(FPTR_PS_NONFISCAL);
    Filters.EndNonFiscal(NonFiscalDoc);
    if not NonFiscalDoc.Cancelled then
    begin
      NonFiscalDoc.EndNonFiscal;
      PrintNonFiscalEnd;
    end;
    SetPrinterState(FPTR_PS_MONITOR);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.EndRemoval: Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.EndTraining: Integer;
begin
  try
    CheckEnabled;
    if not FTrainingModeActive then
      RaiseOposException(OPOS_E_ILLEGAL, _('Training mode is not active'));

    FTrainingModeActive := False;
    FReceiptPrinter := TFiscalReceiptPrinter.Create(Printer);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.Get_OpenResult: Integer;
begin
  Result := FOposDevice.OpenResult;
end;

function TFiscalPrinterImpl.GetData(
  DataItem: Integer;
  out OptArgs: Integer;
  out Data: WideString): Integer;
var
  ReceiptTotal: Int64;
  Status: TLongPrinterStatus;
begin
  try
    case DataItem of
      FPTR_GD_FIRMWARE:
      begin
        Status := Device.ReadLongStatus;
        case OptArgs of
          // ECR firmware version
          0:  Data := Tnt_WideFormat('%s.%s', [Status.FirmwareVersionHi, Status.FirmwareVersionLo]);
          // ECR firmware build
          1: Data := Tnt_WideFormat('%d', [Status.FirmwareBuild]);
          // FM firmware version
          2: Data := Tnt_WideFormat('%s.%s', [Status.FMVersionHi, Status.FMVersionLo]);
          // FM firmware build
          3: Data := Tnt_WideFormat('%d', [Status.FMBuild]);
        else
          Data := Tnt_WideFormat('%s.%s', [Status.FirmwareVersionHi, Status.FirmwareVersionLo]);
        end;
      end;
      FPTR_GD_PRINTER_ID:
      begin
        Status := Device.ReadLongStatus;
        Data := Status.SerialNumber;
      end;
      FPTR_GD_CURRENT_TOTAL:
      begin
        ReceiptTotal := receipt.getTotal();
        Data := Printer.CurrencyToStr(Printer.IntToCurrency(ReceiptTotal));
      end;
      FPTR_GD_GRAND_TOTAL:
      begin
        ReceiptTotal := Device.ReadCashRegister(241);
        if (Device.AmountDecimalPlaces = 0)and(GetAppAmountDecimalPlaces = 2) then
          ReceiptTotal := ReceiptTotal * 100;
        Data := IntToStr(ReceiptTotal);
      end;

      FPTR_GD_DAILY_TOTAL:
      begin
        Data := Printer.CurrencyToStr(Printer.IntToCurrency(GetDailyTotal(optArgs)));
      end;

      FPTR_GD_Z_REPORT:
      begin
        if Device.IsFiscalized then
        begin
          Data := IntToStr(Device.ReadLongStatus.DayNumber);
        end else
        begin
          Data := IntToStr(Device.ReadOperatingRegister(159))
        end;
      end;

      FPTR_GD_RECEIPT_NUMBER:
      begin
        if not Parameters.CacheReceiptNumber then
        begin
          FDocumentNumber := GetLongStatus.DocumentNumber;
        end;
        Data := IntToStr(FDocumentNumber);
      end;

      FPTR_GD_DESCRIPTION_LENGTH:
      begin
        Data := IntToStr(Device.GetPrintWidth(OptArgs));
      end;
    else
      InvalidParameterValue('DataItem', IntToStr(DataItem));
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.GetAppAmountDecimalPlaces: Integer;
begin
  case Parameters.AmountDecimalPlaces of
    AmountDecimalPlaces_0: Result := 0;
    AmountDecimalPlaces_2: Result := 2;
  else
    Result := Device.AmountDecimalPlaces;
  end;
end;

function TFiscalPrinterImpl.GetDailyTotal(Code: Integer): Int64;
begin
  case Code of
    SMFPTR_DAILY_TOTAL_ALL  : Result := GetDailyTotalAll;
    SMFPTR_DAILY_TOTAL_CASH : Result := GetDailyTotalCash;
    SMFPTR_DAILY_TOTAL_PT2  : Result := GetDailyTotalPT2;
    SMFPTR_DAILY_TOTAL_PT3  : Result := GetDailyTotalPT3;
    SMFPTR_DAILY_TOTAL_PT4  : Result := GetDailyTotalPT4;
  else
    Result := GetDailyTotalAll;
  end;
end;

function TFiscalPrinterImpl.GetDailyTotalPT4: Int64;
begin
  Result := 0;
  Result := Result + readCashRegister(205);
  Result := Result - readCashRegister(206);
  Result := Result - readCashRegister(207);
  Result := Result + readCashRegister(208);
end;

function TFiscalPrinterImpl.GetDailyTotalPT3: Int64;
begin
  Result := 0;
  Result := Result + readCashRegister(201);
  Result := Result - readCashRegister(202);
  Result := Result - readCashRegister(203);
  Result := Result + readCashRegister(204);
end;

function TFiscalPrinterImpl.GetDailyTotalPT2: Int64;
begin
  Result := 0;
  Result := Result + readCashRegister(197);
  Result := Result - readCashRegister(198);
  Result := Result - readCashRegister(199);
  Result := Result + readCashRegister(200);
end;

function TFiscalPrinterImpl.GetDailyTotalCash: Int64;
begin
  Result := 0;
  Result := Result + readCashRegister(193);
  Result := Result - readCashRegister(194);
  Result := Result - readCashRegister(195);
  Result := Result + readCashRegister(196);
  Result := Result + readCashRegister(242);
  Result := Result - readCashRegister(243);
end;

function TFiscalPrinterImpl.GetDailyTotalAll: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 3 do
  begin
    Result := Result + readCashRegister(193 + i * 4);
    Result := Result - readCashRegister(194 + i * 4);
    Result := Result - readCashRegister(195 + i * 4);
    Result := Result + readCashRegister(196 + i * 4);
  end;
  Result := Result + readCashRegister(242);
  Result := Result - readCashRegister(243);
end;

function TFiscalPrinterImpl.ReadCashRegister(ID: Byte): Int64;
begin
  Result := printer.Device.ReadCashRegister(ID);
end;

function TFiscalPrinterImpl.GetDate(out Date: WideString): Integer;
var
  Status: TLongPrinterStatus;
begin
  try
    case FDateType of
      FPTR_DT_EOD:
      begin
        Date := Journal.ReadEJSesssionDate(Device, Device.ReadLongStatus.DayNumber);
      end;
      FPTR_DT_RTC:
      begin
        Status := Device.ReadLongStatus;
        Date := EncodeOposDate(Status.Date, Status.Time);
      end;
    else
      InvalidPropertyValue('DateType', IntToStr(FDateType));
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.GetOpenResult: Integer;
begin
  Result := FOposDevice.OpenResult;
end;

function TFiscalPrinterImpl.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  UpdatePrinterStatus(PropIndex);
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
    PIDXFptr_AmountDecimalPlaces    : Result := Device.AmountDecimalPlaces;
    PIDXFptr_AsyncMode              : Result := BoolToInt[FAsyncMode];
    PIDXFptr_CheckTotal             : Result := BoolToInt[Printer.CheckTotal];
    PIDXFptr_CountryCode            : Result := FCountryCode;
    PIDXFptr_CoverOpen              : Result := BoolToInt[FCoverOpened];
    PIDXFptr_DayOpened              : Result := BoolToInt[FDayOpened];
    PIDXFptr_DescriptionLength      : Result := Device.GetPrintWidth;
    PIDXFptr_DuplicateReceipt       : Result := BoolToInt[FDuplicateReceipt];
    PIDXFptr_ErrorLevel             : Result := FErrorLevel;
    PIDXFptr_ErrorOutID             : Result := FErrorOutID;
    PIDXFptr_ErrorState             : Result := FErrorState;
    PIDXFptr_ErrorStation           : Result := FErrorStation;
    PIDXFptr_FlagWhenIdle           : Result := BoolToInt[FFlagWhenIdle];
    PIDXFptr_JrnEmpty               : Result := BoolToInt[FJrnStatus.IsEmpty];
    PIDXFptr_JrnNearEnd             : Result := BoolToInt[FJrnStatus.IsNearEnd];
    PIDXFptr_MessageLength          : Result := Device.GetPrintWidth;
    PIDXFptr_NumHeaderLines         : Result := Printer.NumHeaderLines;
    PIDXFptr_NumTrailerLines        : Result := Printer.NumTrailerLines;
    PIDXFptr_NumVatRates            : Result := FNumVatRates;
    PIDXFptr_PrinterState           : Result := PrinterState;
    PIDXFptr_QuantityDecimalPlaces  : Result := FQuantityDecimalPlaces;
    PIDXFptr_QuantityLength         : Result := FQuantityLength;
    PIDXFptr_RecEmpty               : Result := BoolToInt[FRecStatus.IsEmpty];
    PIDXFptr_RecNearEnd             : Result := BoolToInt[FRecStatus.IsNearEnd];
    PIDXFptr_RemainingFiscalMemory  : Result := Device.ReadLongStatus.RemainingFiscalMemory;
    PIDXFptr_SlpEmpty               : Result := BoolToInt[FSlpStatus.IsEmpty];
    PIDXFptr_SlpNearEnd             : Result := BoolToInt[FSlpStatus.IsNearEnd];
    PIDXFptr_SlipSelection          : Result := FSlipSelection;
    PIDXFptr_TrainingModeActive     : Result := BoolToInt[FTrainingModeActive];
    PIDXFptr_ActualCurrency         : Result := FActualCurrency;
    PIDXFptr_ContractorId           : Result := FContractorId;
    PIDXFptr_DateType               : Result := FDateType;
    PIDXFptr_FiscalReceiptStation   : Result := FFiscalReceiptStation;
    PIDXFptr_FiscalReceiptType      : Result := FFiscalReceiptType;
    PIDXFptr_MessageType                : Result := FMessageType;
    PIDXFptr_TotalizerType              : Result := FTotalizerType;
    PIDXFptr_CapAdditionalLines         : Result := BoolToInt[FCapAdditionalLines];
    PIDXFptr_CapAmountAdjustment        : Result := BoolToInt[FCapAmountAdjustment];
    PIDXFptr_CapAmountNotPaid           : Result := BoolToInt[FCapAmountNotPaid];
    PIDXFptr_CapCheckTotal              : Result := BoolToInt[FCapCheckTotal];
    PIDXFptr_CapCoverSensor             : Result := BoolToInt[FCapCoverSensor];
    PIDXFptr_CapDoubleWidth             : Result := BoolToInt[FCapDoubleWidth];
    PIDXFptr_CapDuplicateReceipt        : Result := BoolToInt[FCapDuplicateReceipt];
    PIDXFptr_CapFixedOutput             : Result := BoolToInt[FCapFixedOutput];
    PIDXFptr_CapHasVatTable             : Result := BoolToInt[FCapHasVatTable];
    PIDXFptr_CapIndependentHeader       : Result := BoolToInt[FCapIndependentHeader];
    PIDXFptr_CapItemList                : Result := BoolToInt[FCapItemList];
    PIDXFptr_CapJrnEmptySensor          : Result := BoolToInt[FCapJrnEmptySensor];
    PIDXFptr_CapJrnNearEndSensor        : Result := BoolToInt[FCapJrnNearEndSensor];
    PIDXFptr_CapJrnPresent              : Result := BoolToInt[FCapJrnPresent];
    PIDXFptr_CapNonFiscalMode           : Result := BoolToInt[FCapNonFiscalMode];
    PIDXFptr_CapOrderAdjustmentFirst    : Result := BoolToInt[FCapOrderAdjustmentFirst];
    PIDXFptr_CapPercentAdjustment       : Result := BoolToInt[FCapPercentAdjustment];
    PIDXFptr_CapPositiveAdjustment      : Result := BoolToInt[FCapPositiveAdjustment];
    PIDXFptr_CapPowerLossReport         : Result := BoolToInt[FCapPowerLossReport];
    PIDXFptr_CapPredefinedPaymentLines  : Result := BoolToInt[FCapPredefinedPaymentLines];
    PIDXFptr_CapReceiptNotPaid          : Result := BoolToInt[FCapReceiptNotPaid];
    PIDXFptr_CapRecEmptySensor          : Result := BoolToInt[FCapRecEmptySensor];
    PIDXFptr_CapRecNearEndSensor        : Result := BoolToInt[FCapRecNearEndSensor];
    PIDXFptr_CapRecPresent              : Result := BoolToInt[FCapRecPresent];
    PIDXFptr_CapRemainingFiscalMemory   : Result := BoolToInt[FCapRemainingFiscalMemory];
    PIDXFptr_CapReservedWord            : Result := BoolToInt[FCapReservedWord];
    PIDXFptr_CapSetHeader               : Result := BoolToInt[Device.GetModel.CapSetHeader];
    PIDXFptr_CapSetPOSID                : Result := BoolToInt[FCapSetPOSID];
    PIDXFptr_CapSetStoreFiscalID        : Result := BoolToInt[FCapSetStoreFiscalID];
    PIDXFptr_CapSetTrailer              : Result := BoolToInt[Device.GetModel.CapSetTrailer];
    PIDXFptr_CapSetVatTable             : Result := BoolToInt[FCapSetVatTable];
    PIDXFptr_CapSlpEmptySensor          : Result := BoolToInt[FCapSlpEmptySensor];
    PIDXFptr_CapSlpFiscalDocument       : Result := BoolToInt[FCapSlpFiscalDocument];
    PIDXFptr_CapSlpFullSlip             : Result := BoolToInt[FCapSlpFullSlip];
    PIDXFptr_CapSlpNearEndSensor        : Result := BoolToInt[FCapSlpNearEndSensor];
    PIDXFptr_CapSlpPresent              : Result := BoolToInt[FCapSlpPresent];
    PIDXFptr_CapSlpValidation           : Result := BoolToInt[FCapSlpValidation];
    PIDXFptr_CapSubAmountAdjustment     : Result := BoolToInt[FCapSubAmountAdjustment];
    PIDXFptr_CapSubPercentAdjustment    : Result := BoolToInt[FCapSubPercentAdjustment];
    PIDXFptr_CapSubtotal                : Result := BoolToInt[FCapSubtotal];
    PIDXFptr_CapTrainingMode            : Result := BoolToInt[FCapTrainingMode];
    PIDXFptr_CapValidateJournal         : Result := BoolToInt[FCapValidateJournal];
    PIDXFptr_CapXReport                 : Result := BoolToInt[FCapXReport];
    PIDXFptr_CapAdditionalHeader        : Result := BoolToInt[FCapAdditionalHeader];
    PIDXFptr_CapAdditionalTrailer       : Result := BoolToInt[FCapAdditionalTrailer];
    PIDXFptr_CapChangeDue               : Result := BoolToInt[FCapChangeDue];
    PIDXFptr_CapEmptyReceiptIsVoidable  : Result := BoolToInt[FCapEmptyReceiptIsVoidable];
    PIDXFptr_CapFiscalReceiptStation    : Result := BoolToInt[FCapFiscalReceiptStation];
    PIDXFptr_CapFiscalReceiptType       : Result := BoolToInt[FCapFiscalReceiptType];
    PIDXFptr_CapMultiContractor         : Result := BoolToInt[FCapMultiContractor];
    PIDXFptr_CapOnlyVoidLastItem        : Result := BoolToInt[FCapOnlyVoidLastItem];
    PIDXFptr_CapPackageAdjustment       : Result := BoolToInt[FCapPackageAdjustment];
    PIDXFptr_CapPostPreLine             : Result := BoolToInt[FCapPostPreLine];
    PIDXFptr_CapSetCurrency             : Result := BoolToInt[FCapSetCurrency];
    PIDXFptr_CapTotalizerType           : Result := BoolToInt[FCapTotalizerType];
    PIDXFptr_CapPositiveSubtotalAdjustment: Result := BoolToInt[FCapPositiveSubtotalAdjustment];
  else
    Result := 0;
  end;
end;

procedure TFiscalPrinterImpl.UpdatePrinterStatus(PropIndex: Integer);
begin
  try
    if FOposDevice.DeviceEnabled and (Parameters.PropertyUpdateMode = PropertyUpdateModeQuery) then
    begin
      case PropIndex of
        PIDXFptr_CoverOpen,
        PIDXFptr_DayOpened,
        PIDXFptr_JrnEmpty,
        PIDXFptr_JrnNearEnd,
        PIDXFptr_SlpEmpty,
        PIDXFptr_SlpNearEnd,
        PIDXFptr_RecEmpty,
        PIDXFptr_RecNearEnd:
        begin
          Device.ReadPrinterStatus;
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      Logger.Error(GetExceptionMessage(E));
    end;
  end;
end;

function TFiscalPrinterImpl.GetPropertyString(PropIndex: Integer): WideString;
begin
  case PropIndex of
    // commmon
    PIDX_CheckHealthText                : Result := FOposDevice.CheckHealthText;
    PIDX_DeviceDescription              : Result := FOposDevice.PhysicalDeviceDescription;
    PIDX_DeviceName                     : Result := FOposDevice.PhysicalDeviceName;
    PIDX_ServiceObjectDescription       : Result := FOposDevice.ServiceObjectDescription;
    // specific
    PIDXFptr_ErrorString                : Result := FOposDevice.ErrorString;
    PIDXFptr_PredefinedPaymentLines     : Result := FPredefinedPaymentLines;
    PIDXFptr_ReservedWord               : Result := FReservedWord;
    PIDXFptr_AdditionalHeader           : Result := FAdditionalHeader;
    PIDXFptr_AdditionalTrailer          : Result := FAdditionalTrailer;
    PIDXFptr_ChangeDue                  : Result := FChangeDue;
    PIDXFptr_PostLine                   : Result := Printer.PostLine;
    PIDXFptr_PreLine                    : Result := Printer.PreLine;
  else
    Result := '';
  end;
end;

function TFiscalPrinterImpl.GetTotalizer(VatID, OptArgs: Integer;
  out Data: WideString): Integer;

  procedure TotalizerNotSupported;
  begin
    RaiseOposException(OPOS_E_ILLEGAL, _('Счетчик не поддерживается'));
  end;

begin
  try
    case OptArgs of
      FPTR_GT_GROSS       : TotalizerNotSupported;
      FPTR_GT_NET         : TotalizerNotSupported;

      FPTR_GT_DISCOUNT:
      begin
        case FTotalizerType of
          FPTR_TT_DAY:
            Data := Printer.CurrencyToStr(Printer.IntToCurrency(Device.GetDayDiscountTotal));

          FPTR_TT_DOCUMENT,
          FPTR_TT_RECEIPT:
            Data := Printer.CurrencyToStr(Printer.IntToCurrency(Device.GetRecDiscountTotal));
        else
          TotalizerNotSupported;
        end;
      end;
      FPTR_GT_DISCOUNT_VOID: TotalizerNotSupported;
      FPTR_GT_ITEM:
      begin
        case FTotalizerType of
          FPTR_TT_DAY:
            Data := Printer.CurrencyToStr(Printer.IntToCurrency(Device.GetDayItemTotal));

          FPTR_TT_DOCUMENT,
          FPTR_TT_RECEIPT:
            Data := Printer.CurrencyToStr(Printer.IntToCurrency(Device.GetRecItemTotal));
        else
          TotalizerNotSupported;
        end;
      end;
      FPTR_GT_ITEM_VOID:
      begin
        case FTotalizerType of
          FPTR_TT_DAY:
            Data := Printer.CurrencyToStr(Printer.IntToCurrency(Device.GetDayItemVoidTotal));

          FPTR_TT_DOCUMENT,
          FPTR_TT_RECEIPT:
            Data := Printer.CurrencyToStr(Printer.IntToCurrency(Device.GetRecItemVoidTotal));
        else
          TotalizerNotSupported;
        end;
      end;
      FPTR_GT_NOT_PAID: TotalizerNotSupported;
    else
      TotalizerNotSupported;
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.GetVatEntry(VatID, OptArgs: Integer;
  out VatRate: Integer): Integer;
begin
  try
    if (VatID < 1)or(VatID > 6) then
      InvalidParameterValue('VatID', IntToStr(VatID));

    VatRate := Device.ReadTableInt(PRINTER_TABLE_TAX, VatID, 1);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.Open(
  const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  Result := DoOpen(DeviceClass, DeviceName, pDispatch);
end;

function TFiscalPrinterImpl.OpenService(const DeviceClass,
  DeviceName: WideString; const pDispatch: IDispatch): Integer;
begin
  Result := DoOpen(DeviceClass, DeviceName, pDispatch);
end;

function TFiscalPrinterImpl.PrintDuplicateReceipt: Integer;
begin
  try
    if FCapDuplicateReceipt then
    begin
      CheckState(FPTR_PS_MONITOR);
      Device.PrintReceiptCopy;
      PrintNonFiscalEnd;
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintFiscalDocumentLine(
  const ADocumentLine: WideString): Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.PrintFixedOutput(
  DocumentType, LineNumber: Integer;
  const AData: WideString): Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.GetPrinterStation(Station: Integer): Integer;
var
  PrinterStation: Integer;
begin
  PrinterStation := 0;
  if (Station and FPTR_S_RECEIPT) <> 0 then
  begin
    if not FCapRecPresent then
      RaiseOposException(OPOS_E_ILLEGAL, _('Нет чекового принтера'));
    PrinterStation := PrinterStation + PRINTER_STATION_REC;
  end;

  if (Station and FPTR_S_JOURNAL) <> 0 then
  begin
    if not FCapJrnPresent then
      RaiseOposException(OPOS_E_ILLEGAL, _('Нет принтера контрольной ленты'));
    PrinterStation := PrinterStation + PRINTER_STATION_JRN;
  end;

  if (Station and FPTR_S_SLIP) <> 0 then
  begin
    if not FCapSlpPresent then
      RaiseOposException(OPOS_E_ILLEGAL, _('Slip station is not present'));
    PrinterStation := PrinterStation + PRINTER_STATION_SLP;
  end;
  if PrinterStation = 0 then
    RaiseOposException(OPOS_E_ILLEGAL, _('No station defined'));
  Result := PrinterStation;
end;

function TFiscalPrinterImpl.PrintNormal(Station: Integer;
  const AData: WideString): Integer;
var
  Data: WideString;
  PrinterStation: Integer;
begin
  try
    CheckEnabled;
    Data := AData;
    Filter.PrintText(Data);
    PrinterStation := GetPrinterStation(Station);
    Data := ParseCashierName(Data);

    if (Data <> '') or (AData = '') then
    begin
      Data := FOposDevice.ConvertBinary(Data);
    end;
    NonFiscalDoc.PrintNormal(PrinterStation, Data);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintPeriodicTotalsReport(
  const Date1, Date2: WideString): Integer;
var
  Parameters: TDateReport;
begin
  try
    Logger.Debug(Format('TFiscalPrinterImpl.PrintPeriodicTotalsReport(%s, %s)',
      [Date1, Date2]));

    CheckEnabled;
    CheckState(FPTR_PS_MONITOR);
    Parameters.ReportType := PRINTER_REPORT_TYPE_SHORT;
    Parameters.Date1 := DecodeOposDate(Date1);
    Parameters.Date2 := DecodeOposDate(Date2);
    if ComparePrinterDate(Parameters.Date1, Parameters.Date2) = 1 then
      RaiseOposException(OPOS_E_ILLEGAL, 'Date1 > Date2');

    Device.EJTotalsReportDate(Parameters);
    PrintReportEnd;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintPowerLossReport: Integer;
begin
  Result := IllegalError;
end;

function TFiscalPrinterImpl.PrintRecCash(Amount: Currency): Integer;
begin
  try
    Receipt.PrintRecCash(Amount);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.GetTax(const ItemName: WideString; Tax: Integer): Integer;
begin
  Result := Tax;
  {$IFDEF MALINA}
  if GetMalinaParams.RetalixDBEnabled then
  begin
    if FREtalix = nil then
    begin
      FRetalix := TRetalix.Create(GetMalinaParams.RetalixDBPath, Device.Context);
      FRetalix.Open;
    end;
    Result := FRetalix.ReadTaxGroup(ItemName);
    if Result = -1 then
      Result := Tax;
  end;
  {$ENDIF}
  Result := Parameters.GetVatInfo(Result);
  if not (Result in [0..6]) then Result := 0;
end;


function TFiscalPrinterImpl.PrintRecItem(
  const ADescription: WideString; Price: Currency;
  Quantity, VatInfo: Integer; UnitPrice: Currency;
  const AUnitName: WideString): Integer;
var
  UnitName: WideString;
  Description: WideString;
  Department: Integer;
begin
  UnitName := AUnitName;
  Description := ADescription;
  Department := Parameters.Department;
  try
    {$IFDEF MALINA}
    if GetMalinaParams.RosneftAddTextEnabled then
    begin
      if Pos(UpperCase(GetMalinaParams.RosneftItemName), UpperCase(Description)) <> 0 then
      begin
        Parameters.Department := GetMalinaParams.RosneftItemDepartment;
        Receipt.AdditionalText := GetMalinaParams.RosneftAddText;
      end;
    end;
    {$ENDIF}

    (*
    !!!
    Amount := Round2(UnitPrice * Quantity/100000)/100;
    if Price <> Amount then
    begin
      UnitPrice := 0;
    end;
    *)

    VatInfo := GetTax(Description, VatInfo);
    Filters.PrintRecItemBefore(Description, Price, Quantity, VatInfo,
      UnitPrice, AUnitName);

    Receipt.PrintRecItem(ADescription, Price, Quantity, VatInfo,
      UnitPrice, AUnitName);
    Inc(FReceiptItems);

    if Parameters.VoidReceiptOnMaxItems then
    begin
      if FReceiptItems >= Parameters.MaxReceiptItems then
      begin
        FReceiptItems := 0;
        WaitForPrinting;
        Device.CancelReceipt;
      end;
    end;
    Filters.PrintRecItemAfter(Description, Price, Quantity, VatInfo,
      UnitPrice, AUnitName);


    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
  Parameters.Department := Department;
end;

function TFiscalPrinterImpl.PrintRecItemAdjustment(
  AdjustmentType: Integer;
  const ADescription: WideString;
  Amount: Currency;
  VatInfo: Integer): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);

    VatInfo := GetTax(ADescription, VatInfo);

    Receipt.PrintRecItemAdjustment(
      AdjustmentType, ADescription, Amount, VatInfo);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecItemFuel(
  const ADescription: WideString;
  Price: Currency;
  Quantity, VatInfo: Integer;
  UnitPrice: Currency;
  const AUnitName: WideString;
  SpecialTax: Currency;
  const ASpecialTaxName: WideString): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);

    VatInfo := GetTax(ADescription, VatInfo);
    Receipt.PrintRecItemFuel(ADescription, Price, Quantity, VatInfo,
      UnitPrice, AUnitName, SpecialTax, ASpecialTaxName);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecItemFuelVoid(
  const ADescription: WideString;
  Price: Currency; VatInfo: Integer; SpecialTax: Currency): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);

    VatInfo := GetTax(ADescription, VatInfo);
    Receipt.PrintRecItemFuelVoid(ADescription, Price, VatInfo, SpecialTax);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecMessage(
  const AMessage: WideString): Integer;
var
  Text: WideString;
  Item: TTextReceiptItem;
begin
  try
    CheckEnabled;
    Text := AMessage;
    Text := ParseCashierName(Text);

    if Length(Text) = 0 then
      Text := ' ';

    if FPrinterState.IsReceiptEnding then
    begin
      Item := TTextReceiptItem.Create(FAfterCloseItems);
      Item.Data.Text := Text;
      Item.Data.Station := PRINTER_STATION_REC;
      Item.Data.Font := Parameters.FontNumber;
      Item.Data.Alignment := taLeft;
      Item.Data.Wrap := Parameters.WrapText;
    end else
    begin
      Receipt.PrintRecMessage(Text);
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.PrintText(const Data: TTextRec);
var
  Item: TTextReceiptItem;
begin
  if FPrinterState.IsReceiptEnding then
  begin
    Item := TTextReceiptItem.Create(FAfterCloseItems);
    Item.Data := Data;
  end else
  begin
    Receipt.PrintText(Data);
  end;
end;

procedure TFiscalPrinterImpl.PrintBarcode(const Barcode: TBarcodeRec);
var
  Item: TBarcodeReceiptItem;
begin
  if FPrinterState.IsReceiptEnding then
  begin
    Item := TBarcodeReceiptItem.Create(FAfterCloseItems);
    Item.Data := Barcode;
  end else
  begin
    Receipt.PrintBarcode(Barcode);
  end;
end;

function TFiscalPrinterImpl.PrintRecNotPaid(
  const Description: WideString;
  Amount: Currency): Integer;
begin
  try
    if not FCapReceiptNotPaid then
      RaiseOposException(OPOS_E_ILLEGAL, _('Not paid receipt is nor supported'));

    if (PrinterState <> FPTR_PS_FISCAL_RECEIPT_ENDING) and
      (PrinterState <> FPTR_PS_FISCAL_RECEIPT_TOTAL) then
      raiseExtendedError(OPOS_EFPTR_WRONG_STATE);

    Receipt.PrintRecNotPaid(Description, Amount);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const Description, VatAdjustment: WideString): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    Receipt.PrintRecPackageAdjustment(AdjustmentType,
      Description, VatAdjustment);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecPackageAdjustVoid(
  AdjustmentType: Integer;
  const VatAdjustment: WideString): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    Receipt.PrintRecPackageAdjustVoid(AdjustmentType, VatAdjustment);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecRefund(
  const Description: WideString;
  Amount: Currency; VatInfo: Integer): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    VatInfo := GetTax(Description, VatInfo);
    
    Filters.PrintRecRefundBefore(Description, Amount, VatInfo);
    Receipt.PrintRecRefund(Description, Amount, VatInfo);
    Filters.PrintRecRefundAfter(Description, Amount, VatInfo);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecRefundVoid(
  const Description: WideString;
  Amount: Currency; VatInfo: Integer): Integer;
begin
  try
    VatInfo := GetTax(Description, VatInfo);
    Receipt.PrintRecRefundVoid(Description, Amount, VatInfo);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecSubtotal(Amount: Currency): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    Receipt.PrintRecSubtotal(Amount);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecSubtotalAdjustment(
  AdjustmentType: Integer;
  const Description: WideString;
  Amount: Currency): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    Receipt.PrintRecSubtotalAdjustment(AdjustmentType, Description, Amount);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer;
  Amount: Currency): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    Receipt.PrintRecSubtotalAdjustVoid(AdjustmentType, Amount);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecTaxID(const TaxID: WideString): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    Receipt.PrintRecTaxID(TaxID);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecTotal(
  Total, Payment: Currency;
  const Description: WideString): Integer;
begin
  try
    if (PrinterState <> FPTR_PS_FISCAL_RECEIPT) and
      (PrinterState <> FPTR_PS_FISCAL_RECEIPT_TOTAL) then
      raiseExtendedError(OPOS_EFPTR_WRONG_STATE);

    Filters.PrintRecTotal;
    Receipt.PrintRecTotal(Total, Payment, Description);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecVoid(
  const Description: WideString): Integer;
begin
  try
    CheckEnabled;

    if (PrinterState <> FPTR_PS_FISCAL_RECEIPT) and
      (PrinterState <> FPTR_PS_FISCAL_RECEIPT_ENDING) and
      (PrinterState <> FPTR_PS_FISCAL_RECEIPT_TOTAL) then
      raiseExtendedError(OPOS_EFPTR_WRONG_STATE);

    WaitForPrinting;
    Receipt.PrintRecVoid(Description);
    SetPrinterState(FPTR_PS_FISCAL_RECEIPT_ENDING);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecVoidItem(
  const Description: WideString;
  Amount: Currency;
  Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer): Integer;
begin
  try
    CheckState(FPTR_PS_FISCAL_RECEIPT);
    VatInfo := GetTax(Description, VatInfo);
    Receipt.PrintRecVoidItem(Description, Amount, Quantity,
      AdjustmentType, Adjustment, VatInfo);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintReport(
  ReportType: Integer;
  const StartNum, EndNum: WideString): Integer;
var
  DateReport: TDateReport;
  NumberReport: TNumberReport;
begin
  try
    CheckState(FPTR_PS_MONITOR);
    case ReportType of
      FPTR_RT_ORDINAL: RaiseOposException(OPOS_E_ILLEGAL, _('Не поддерживается'));
      FPTR_RT_DATE:
      begin
        DateReport.ReportType := PRINTER_REPORT_TYPE_FULL;
        DateReport.Date1 := DecodeOposDate(StartNum);
        DateReport.Date2 := DecodeOposDate(EndNum);
        if ComparePrinterDate(DateReport.Date1, DateReport.Date2) = 1 then
          RaiseOposException(OPOS_E_ILLEGAL, 'StartNum > EndNum');

        Device.EJTotalsReportDate(DateReport);
        PrintReportEnd;
      end;
      FPTR_RT_EOD_ORDINAL:
      begin
        NumberReport.ReportType := PRINTER_REPORT_TYPE_FULL;
        NumberReport.Number1 := GetDayNumber(StartNum, 'StartNum');
        NumberReport.Number2 := GetDayNumber(EndNum, 'EndNum');
        if (NumberReport.Number2 <> 0)and(NumberReport.Number1 > NumberReport.Number2) then
          RaiseOposException(OPOS_E_ILLEGAL, 'StartNum > EndNum');
        if NumberReport.Number2 = 0 then NumberReport.Number2 := $FFFF;

        Device.EJTotalsReportNumber(NumberReport);
        PrintReportEnd;
      end;
    else
      InvalidParameterValue('ReportType', IntToStr(ReportType));
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintXReport: Integer;
var
  R: TFSCalcReport;
begin
  try
    CheckState(FPTR_PS_MONITOR);
    SetPrinterState(FPTR_PS_REPORT);
    try
      if Parameters.XReport = FptrFSCalculationsReport then
      begin
        Device.FSPrintCalcReport(R);
      end else
      begin
        Filters.BeforeXReport;
        Device.PrintXReport;
        Filters.AfterXReport;
      end;
      PrintReportEnd;
    finally
      SetPrinterState(FPTR_PS_MONITOR);
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintZReport: Integer;
begin
  try
    CheckState(FPTR_PS_MONITOR);
    SetPrinterState(FPTR_PS_REPORT);
    try
      if not Device.IsDayOpened(Device.ReadPrinterStatus.Mode) then
      begin
        Printer.Device.OpenDay;
      end;
      SaveZReportFile;
      Filters.BeforeZReport;
      Device.PrintZReport;
      Filters.AfterZReport;

      PrintReportEnd;
    finally
      SetPrinterState(FPTR_PS_MONITOR);
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

// HHmmDDMMYY
function TFiscalPrinterImpl.AddDateStamp(const FileName: WideString): WideString;
var
  Stamp: WideString;
begin
  Result := FileName;
  if Parameters.ReportDateStamp then
  begin
    Stamp := FormatDateTime('HHNNDDMMYY', Now);
    Result := ChangeFileExt(FileName, Stamp + ExtractFileExt(FileName));
  end;
end;

procedure TFiscalPrinterImpl.SaveZReportFile;
var
  ZReport: TZReport;
  FileName: WideString;
begin
  if (Parameters.XmlZReportEnabled or Parameters.CsvZReportEnabled) then
  begin
    ZReport := TZReport.Create(Device);
    try
      ZReport.Read;
      if Parameters.XmlZReportEnabled then
      begin
        FileName := AddDateStamp(Parameters.XmlZReportFileName);
        ZReport.SaveToXml(FileName);
      end;

      if Parameters.CsvZReportEnabled then
      begin
        FileName := AddDateStamp(Parameters.CsvZReportFileName);
        ZReport.SaveToCsv(FileName);
      end;
    except
      on E: Exception do
      begin
        Logger.Error(GetExceptionMessage(E));
      end;
    end;
    ZReport.Free;
  end;
end;

function TFiscalPrinterImpl.Release1: Integer;
begin
  Result := DoRelease;
end;

function TFiscalPrinterImpl.ReleaseDevice: Integer;
begin
  Result := DoRelease;
end;

function TFiscalPrinterImpl.ResetPrinter: Integer;
begin
  try
    CheckEnabled;
    CancelReceipt;
    Device.ResetPrinter;
    SetPrinterState(FPTR_PS_MONITOR);
    FAfterCloseItems.Clear;
    FReceiptItems := 0;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetCurrency(NewCurrency: Integer): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetDate(const Date: WideString): Integer;
var
  DateTime: TPrinterDateTime;
  PrinterDate: TPrinterDate;
  PrinterTime: TPrinterTime;
begin
  try
    CheckEnabled;
    if Parameters.TimeUpdateMode = TimeUpdateModeNormal then
    begin
      if FDayOpened then
        RaiseOposException(OPOS_E_ILLEGAL, _('Day is opened. Unable to change date'));

      DateTime := DecodeOposDateTime(Date);
      PrinterDate.Day := DateTime.Day;
      PrinterDate.Month := DateTime.Month;
      PrinterDate.Year := DateTime.Year;
      PrinterTime.Hour := DateTime.Hour;
      PrinterTime.Min := DateTime.Min;
      PrinterTime.Sec := 0;

      Device.WriteDate(PrinterDate);
      Device.ConfirmDate(PrinterDate);
      Device.SetTime(PrinterTime);
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetHeaderLine(
  LineNumber: Integer;
  const AText: WideString;
  DoubleWidth: WordBool): Integer;
var
  Text: WideString;
begin
  try
    if Parameters.SetHeaderLineEnabled then
    begin
      CheckEnabled;
      Text := AText;
      Filter.PrintHeaderText(Text);

      if (LineNumber < 1)or(LineNumber > Printer.NumHeaderLines) then
        InvalidParameterValue('LineNumber', IntToStr(LineNumber));

      if Parameters.HeaderType = HeaderTypePrinter then
      begin
        if Parameters.TableEditEnabled then
        begin
          Device.WriteTable(PRINTER_TABLE_TEXT,
            Device.GetModel.StartHeaderLine + LineNumber -1, 1, Text);
        end;
      end;
      if Parameters.CenterHeader then
        Text := Device.CenterLine(Text);
      Printer.Header[LineNumber-1] := Text;
      Parameters.Header := Printer.Header.Text;
      SaveParameters;
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetPOSID(
  const POSID, CashierID: WideString): Integer;
begin
  try
    CheckEnabled;

    if CashierID = '' then
     raiseException(_('Casier name connot be empty'));

    Device.WriteTable(PRINTER_TABLE_CASHIER,
      Device.ReadUsrOperatorNumber, 2, CashierID);

    Device.WriteTable(PRINTER_TABLE_CASHIER,
      Device.ReadSysOperatorNumber, 2, CashierID);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetStoreFiscalID(const AID: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetTrailerLine(
  LineNumber: Integer;
  const AText: WideString;
  DoubleWidth: WordBool): Integer;
var
  Text: WideString;
begin
  try
    if Parameters.SetTrailerLineEnabled then
    begin
      CheckEnabled;
      Text := AText;
      Filter.PrintText(Text);

      if (LineNumber < 1) or (LineNumber > Printer.NumTrailerLines) then
        InvalidParameterValue('LineNumber', IntToStr(LineNumber));

      if Parameters.HeaderType = HeaderTypePrinter then
      begin
        if Parameters.TableEditEnabled then
        begin
          Device.WriteTable(PRINTER_TABLE_TEXT,
            Device.GetModel.StartTrailerLine + LineNumber-1, 1, Text);
        end;
      end;
      if Parameters.CenterHeader then
        Text := Device.CenterLine(Text);
      Printer.Trailer[LineNumber-1] := Text;
      Parameters.Trailer := Printer.Trailer.Text;
      SaveParameters;
    end;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.SetVatTable: Integer;
var
  i: Integer;
begin
  try
    CheckEnabled;
    CheckCapSetVatTable;


    for i := 1 to 4 do
      Device.WriteTableInt(PRINTER_TABLE_TAX, i, 1, FVatValues[i]);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.CheckCapSetVatTable;
begin
  if not FCapSetVatTable then
    RaiseIllegalError(_('Not supported'));
end;

function TFiscalPrinterImpl.SetVatValue(
  VatID: Integer;
  const AVatValue: WideString): Integer;
var
  VatValueInt: Integer;
begin
  try
    CheckEnabled;
    CheckCapSetVatTable;

    // There are 6 taxes in Shtrih-M ECRs available
    if (VatID < 1)or(VatID > 6) then
      InvalidParameterValue('VatID', IntToStr(VatID));

    VatValueInt := StrToInt(AVatValue);
    if VatValueInt > 9999 then
      InvalidParameterValue('VatValue', AVatValue);

    FVatValues[VatID] := VatValueInt;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.VerifyItem(
  const AItemName: WideString;
  VatID: Integer): Integer;
begin
  Result := IllegalError;
end;

procedure TFiscalPrinterImpl.SetFiscalReceiptStation(Value: Integer);
begin
  if Value <> FFiscalReceiptStation then
  begin
    //CheckState(FPTR_PS_MONITOR);
    FFiscalReceiptStation := Value;
  end;
end;

procedure TFiscalPrinterImpl.SetPropertyNumber(PropIndex, Number: Integer);
begin
  try
    case PropIndex of
      // common
      PIDX_DeviceEnabled          : SetDeviceEnabled(IntToBool(Number));
      PIDX_DataEventEnabled       : FOposDevice.DataEventEnabled := IntToBool(Number);
      PIDX_PowerNotify            : FOposDevice.PowerNotify := Number;
      PIDX_BinaryConversion       : FOposDevice.BinaryConversion := Number;
      // Specific
      PIDXFptr_AsyncMode          : FAsyncMode := IntToBool(Number);
      PIDXFptr_CheckTotal         : Printer.CheckTotal := IntToBool(Number);
      PIDXFptr_DateType           : FDateType := Number;
      PIDXFptr_DuplicateReceipt   : FDuplicateReceipt := IntToBool(Number);

      PIDXFptr_FiscalReceiptStation: SetFiscalReceiptStation(Number);

      PIDXFptr_FiscalReceiptType:
      begin
        CheckState(FPTR_PS_MONITOR);
        FFiscalReceiptType := Number;
      end;

      PIDXFptr_FlagWhenIdle       : FFlagWhenIdle := IntToBool(Number);
      PIDXFptr_MessageType        : FMessageType := Number;
      PIDXFptr_SlipSelection      : FSlipSelection := Number;
      PIDXFptr_TotalizerType      : FTotalizerType := Number;
      PIDX_FreezeEvents           : SetFreezeEvents(Number <> 0);
    end;

    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.SetPropertyString(PropIndex: Integer;
  const Value: WideString);
begin
  try
    FOposDevice.CheckOpened;
    case PropIndex of
      PIDXFptr_AdditionalHeader   : FAdditionalHeader := Value;
      PIDXFptr_AdditionalTrailer  : FAdditionalTrailer := Value;
      PIDXFptr_PostLine           : Printer.PostLine := Value;
      PIDXFptr_PreLine            : Printer.PreLine := Value;
      PIDXFptr_ChangeDue          : FChangeDue := Value;
    end;
    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

function TFiscalPrinterImpl.CompareFirmwareVersion(
  const FirmwareFileName: WideString;
  out pResult: Integer): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecItemAdjustmentVoid(
  AdjustmentType: Integer;
  const Description: WideString;
  Amount: Currency;
  VatInfo: Integer): Integer;
begin
  try
    VatInfo := GetTax(Description, VatInfo);
    Receipt.PrintRecItemAdjustmentVoid(AdjustmentType, Description,
      Amount, VatInfo);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecItemVoid(
  const Description: WideString;
  Price: Currency;
  Quantity, VatInfo: Integer;
  UnitPrice: Currency;
  const UnitName: WideString): Integer;
var
  Amount: Currency;
begin
  try
    VatInfo := GetTax(Description, VatInfo);
    Amount := Round2(UnitPrice * Quantity/100000)/100;
    if Price <> Amount then
    begin
      UnitPrice := 0;
    end;

    Receipt.PrintRecItemVoid(Description, Price, Quantity, VatInfo,
      UnitPrice, UnitName);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.ResetStatistics(
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

function TFiscalPrinterImpl.RetrieveStatistics(
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

function TFiscalPrinterImpl.UpdateFirmware(
  const FirmwareFileName: WideString): Integer;
begin
  try
    CheckEnabled;
    Result := IllegalError;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.UpdateStatistics(
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

function TFiscalPrinterImpl.PrintRecItemRefund(
  const Description: WideString;
  Amount: Currency;
  Quantity, VatInfo: Integer;
  UnitAmount: Currency;
  const UnitName: WideString): Integer;
begin
  try
    VatInfo := GetTax(Description, VatInfo);
    Filters.PrintRecItemRefundBefore(Description,
      Amount, Quantity, VatInfo, UnitAmount, UnitName);
    Receipt.PrintRecItemRefund(Description, Amount, Quantity, VatInfo,
      UnitAmount, UnitName);
    Filters.PrintRecItemRefundAfter(Description,
      Amount, Quantity, VatInfo, UnitAmount, UnitName);

   Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFiscalPrinterImpl.PrintRecItemRefundVoid(
  const Description: WideString;
  Amount: Currency;
  Quantity, VatInfo: Integer;
  UnitAmount: Currency;
  const UnitName: WideString): Integer;
begin
  try
    VatInfo := GetTax(Description, VatInfo);
    Receipt.PrintRecItemRefundVoid(Description, Amount, Quantity, VatInfo,
      UnitAmount, UnitName);

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

procedure TFiscalPrinterImpl.CheckEnabled;
begin
  FOposDevice.CheckEnabled;
end;

function TFiscalPrinterImpl.WaitForPrinting: TPrinterStatus;
begin
  Result := Device.WaitForPrinting;
  FDayOpened := Device.IsDayOpened(Result.Mode);
end;

procedure TFiscalPrinterImpl.SaveParameters;
begin
  Printer.SaveParameters;
end;

procedure TFiscalPrinterImpl.PrintImage(const FileName: WideString);
begin
  Printer.PrintImage(FileName);
end;

procedure TFiscalPrinterImpl.PrintImageScale(const FileName: WideString;
  Scale: Integer);
begin
  Printer.PrintImageScale(FileName, Scale);
end;

procedure TFiscalPrinterImpl.LoadLogo(const FileName: WideString);
begin
  Printer.LoadLogo(FileName);
end;

procedure TFiscalPrinterImpl.UpdateDioHandlers;
begin
  case Parameters.CompatLevel of
    CompatLevelNone: CreateDIOHandlers;
    CompatLevel1: CreateDIOHandlers1;
    CompatLevel2: CreateDIOHandlers2;
  else
    CreateDIOHandlers;
  end;
end;

function TFiscalPrinterImpl.ReadEJActivation: WideString;
var
  Line: WideString;
  Count: Integer;
  Lines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  try
    if Device.ReadEJActivation(Line) <> 0 then Exit;
    Lines.Add(Line);

    Count := 1;
    while Device.GetEJReportLine(Line) = 0 do
    begin
      Lines.Add(Line);
      if Count = 20 then Break;
      Inc(Count);
    end;
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterImpl.GetPrinterSemaphoreName: WideString;
begin
  Result := FPrinter.GetPrinterSemaphoreName;
end;

procedure TFiscalPrinterImpl.PrintTextFont(Station, Font: Integer;
  const Text: WideString);
begin
  Device.PrintTextFont(Station, Font, Text);
end;

function TFiscalPrinterImpl.ParseCashierName(const Line: WideString): WideString;
var
  Cashier: WideString;
begin
  Cashier := '';
  Result := Line;
  {$IFDEF MALINA}
  if GetMalinaParams.RetalixDBEnabled then
  begin
    if FRetalix.ParseOperator(Line, Cashier) then
    begin
      Device.WriteTable(PRINTER_TABLE_CASHIER,
        Device.ReadUsrOperatorNumber, 2, Cashier);

      Device.WriteTable(PRINTER_TABLE_CASHIER,
        Device.ReadSysOperatorNumber, 2, Cashier);

      Result := FRetalix.ReplaceOperator(Line, Cashier);
    end;
  end;
  {$ENDIF}
end;

function TFiscalPrinterImpl.HandleException(E: Exception): Integer;
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
    OPOSError.ErrorString := GetExceptionMessage(E);
    OPOSError.ResultCode := OPOSException.ResultCode;
    OPOSError.ResultCodeExtended := OPOSException.ResultCodeExtended;
    FOposDevice.HandleException(OPOSError);
    Result := OPOSError.ResultCode;
    Exit;
  end;

  OPOSError.ErrorString := GetExceptionMessage(E);
  OPOSError.ResultCode := OPOS_E_FAILURE;
  OPOSError.ResultCodeExtended := OPOS_SUCCESS;
  FOposDevice.HandleException(OPOSError);
  Result := OPOSError.ResultCode;
end;

function TFiscalPrinterImpl.HandleDriverError(E: EDriverError): TOPOSError;
begin
  FLastErrorCode := E.ErrorCode;
  FLastErrorText := GetExceptionMessage(E);

  Result.ResultCode := OPOS_E_EXTENDED;
  Result.ErrorString := GetExceptionMessage(E);
  case E.ErrorCode of
    $6B: Result.ResultCodeExtended := OPOS_EFPTR_REC_EMPTY;
    $6C: Result.ResultCodeExtended := OPOS_EFPTR_JRN_EMPTY;
    $C6: Result.ResultCodeExtended := OPOS_EFPTR_SLP_EMPTY;
  else
    Result.ResultCodeExtended := OPOSERREXT + FPTR_ERROR_BASE + E.ErrorCode;
  end;

  if Parameters.HandleErrorCode then
  begin
    if Device.CapFiscalStorage then
      Result.ResultCodeExtended := FSHandleError(E.ErrorCode, Result.ResultCodeExtended)
    else
      Result.ResultCodeExtended := EJHandleError(E.ErrorCode, Result.ResultCodeExtended);
  end;
end;

function TFiscalPrinterImpl.FSHandleError(FPCode, ResultCodeExtended: Integer): Integer;
begin
  case FPCode of
    $1A, // FM fiscal area overflow
    $1B, // Serial number is not assigned
    $1C, // There is corrupted record in the defined range
    $1D, // Last day sum record is corrupted
    $1E, // FM fiscal area overflow
    $1F, // Registers memory is missing
    $22, // Invalid date
    $23, // Activation record is not found
    $25, // Activation with requested number is not found
    $27, // FM CRC are corrupted
    $2B, // Unable to cancel previous command
    $2C, // ECR is zero out (re-clearing is not available)
    $2F, // EKLZ not answered
    $30, // ECR is blocked. Waiting for enter tax password
    $32, // Common clearing is needed
    $35, // Incorrect command parameters for this settings
    $36, // Incorrect command parameters for this ECR implementation
    $38, // PROM error
    $39, // Internal software error
    $3C, // EKLZ: Invalid registration number
    $57, // Closed day count in EJ does not correspont to FM day count
    $64, // FM is missing
    $67, // FM connection error
    $6A, // Supply error when I2C active
    $71, // Cutter failure
    $74, // RAM failure
    $75, // Supply failure
    $76, // Printer failure: no impulse from tachometer generator
    $77, // Printer failure: no signal from sensors
    $7A, // Field is not editable
    $7B, // Hardware failure
    $7C, // Date does not match
    $7D, // Invalid date format
    $80, // FM connection error
    $81, // FM connection error
    $82, // FM connection error
    $83, // FM connection error
    $8F, // ECR is not fiscal
    $90, // Field size is larger than settings value
    $91, // Out of printing field area for this font settings
    $92, // Field overlay
    $94, // Receipt operation count overflow
    $A0, // EJ connection error
    $A1, // EJ is missing
    $A2, // EJ: Invalid parameter or command format
    $A3, // Invalid EJ state
    $A4, // EJ failure
    $A5, // EJ cryptoprocessor failure
    $A6, // EJ Time limit exceeded
    $A7, // EJ overflow
    $A8, // EJ: invalid date and time
    $A9, // EJ: no requested data available
    $AA, // EJ overflow (negative document sum)
    $B2, // EJ: Already activated
    $C0, // Date and time control(confirm date and time)
    $C1, // EJ: Z-report is not interruptable
    $C2, // Exceeding supply voltage
    $C3, // Receipt sum and EJ sum mismatch
    $C4, // Day numbers mismatch
    $C7, // Field is not editable in this mode
    $C8, // No impulses from tachometer sensor
    $E0, // Cash acceptor connection error
    $E1, // Cash acceptor is busy
    $E2, // Receipt sum does not correspond to cash acceptor sum
    $E3, // Cash acceptor error
    $E4: // Cash acceptor sum is not zero
    begin
      Result := OPOS_EFPTR_TECHNICAL_ASSISTANCE;
    end;
  else
    Result := ResultCodeExtended;
  end;
end;

function TFiscalPrinterImpl.EJHandleError(FPCode, ResultCodeExtended: Integer): Integer;
begin
  case FPCode of
    $01, // FM1, FM2 or RTC error
    $02, // FM1 missing
    $03, // FM2 missing
    $04, // Incorrect parameters in FM command
    $05, // No data requested available
    $06, // FM is in data output mode
    $07, // Invalid FM command parameters
    $08, // Command is not supported by FM
    $09, // Invalid command length
    $0A, // Data format is not BCD
    $0B, // FM memory cell failure
    $11, // License in not entered
    $12, // Serial number is already entered
    $13, // Current date is less than last FM record date
    $14, // FM day sum area overflow
    $1A, // FM fiscal area overflow
    $1B, // Serial number is not assigned
    $1C, // There is corrupted record in the defined range
    $1D, // Last day sum record is corrupted
    $1E, // FM fiscal area overflow
    $1F, // Registers memory is missing
    $22, // Invalid date
    $23, // Activation record is not found
    $25, // Activation with requested number is not found
    $27, // FM CRC are corrupted
    $2B, // Unable to cancel previous command
    $2C, // ECR is zero out (re-clearing is not available)
    $2F, // EKLZ not answered
    $30, // ECR is blocked. Waiting for enter tax password
    $32, // Common clearing is needed
    $35, // Incorrect command parameters for this settings
    $36, // Incorrect command parameters for this ECR implementation
    $38, // PROM error
    $39, // Internal software error
    $3C, // EKLZ: Invalid registration number
    $57, // Closed day count in EJ does not correspont to FM day count
    $64, // FM is missing
    $67, // FM connection error
    $6A, // Supply error when I2C active
    $71, // Cutter failure
    $74, // RAM failure
    $75, // Supply failure
    $76, // Printer failure: no impulse from tachometer generator
    $77, // Printer failure: no signal from sensors
    $7A, // Field is not editable
    $7B, // Hardware failure
    $7C, // Date does not match
    $7D, // Invalid date format
    $80, // FM connection error
    $81, // FM connection error
    $82, // FM connection error
    $83, // FM connection error
    $8F, // ECR is not fiscal
    $90, // Field size is larger than settings value
    $91, // Out of printing field area for this font settings
    $92, // Field overlay
    $94, // Receipt operation count overflow
    $A0, // EJ connection error
    $A1, // EJ is missing
    $A2, // EJ: Invalid parameter or command format
    $A3, // Invalid EJ state
    $A4, // EJ failure
    $A5, // EJ cryptoprocessor failure
    $A6, // EJ Time limit exceeded
    $A7, // EJ overflow
    $A8, // EJ: invalid date and time
    $A9, // EJ: no requested data available
    $AA, // EJ overflow (negative document sum)
    $B2, // EJ: Already activated
    $C0, // Date and time control(confirm date and time)
    $C1, // EJ: Z-report is not interruptable
    $C2, // Exceeding supply voltage
    $C3, // Receipt sum and EJ sum mismatch
    $C4, // Day numbers mismatch
    $C7, // Field is not editable in this mode
    $C8, // No impulses from tachometer sensor
    $E0, // Cash acceptor connection error
    $E1, // Cash acceptor is busy
    $E2, // Receipt sum does not correspond to cash acceptor sum
    $E3, // Cash acceptor error
    $E4: // Cash acceptor sum is not zero
    begin
      Result := OPOS_EFPTR_TECHNICAL_ASSISTANCE;
    end;
  else
    Result := ResultCodeExtended;
  end;
end;

procedure TFiscalPrinterImpl.SetAdjustmentAmount(Amount: Integer);
begin
  Receipt.SetAdjustmentAmount(Amount);
end;

procedure TFiscalPrinterImpl.DisableNextHeader;
begin
  FHeaderEnabled := False;
end;

procedure TFiscalPrinterImpl.WriteCustomerAddress(const Value: WideString);
begin
  FSWriteTag(1008, Value);
end;

procedure TFiscalPrinterImpl.FSWriteTag(TagID: Integer; const Data: WideString);
begin
  FSWriteTLV(TagToStr(TagID, Data));
end;

procedure TFiscalPrinterImpl.FSWriteTagOperation(TagID: Integer;
  const Data: WideString);
begin
  FSWriteTLVOperation(TagToStr(TagID, Data));
end;

procedure TFiscalPrinterImpl.FSWriteTLV(const TLVData: WideString);
begin
  Receipt.FSWriteTLV(TLVData);
end;

procedure TFiscalPrinterImpl.FSWriteTlvOperation(const TLVData: WideString);
begin
  Receipt.FSWriteTlvOperation(TLVData);
end;

function TFiscalPrinterImpl.GetParameters: TPrinterParameters;
begin
  Result := Printer.Parameters;
end;

function TFiscalPrinterImpl.GetMalinaParams: TMalinaParams;
begin
  Result := Device.Context.MalinaParams;
end;

function TFiscalPrinterImpl.GetLogger: ILogFile;
begin
  Result := Device.Context.Logger;
end;

procedure TFiscalPrinterImpl.WriteFPParameter(ParamId: Integer;
  const Value: WideString);
begin
  Receipt.WriteFPParameter(ParamId, Value);
end;

procedure TFiscalPrinterImpl.PrintFSDocument(Number: Integer);
begin
  Device.PrintFSDocument(Number);
  PrintNonFiscalEnd;
end;

function TFiscalPrinterImpl.ReadFSDocument(Number: Integer): WideString;
begin
  Result := Device.ReadFSDocument(Number);
end;


procedure TFiscalPrinterImpl.PrintRecMessages;
begin
  try
    PrintReceiptItems(FAfterCloseItems);
    FAfterCloseItems.Clear;
  except
    on E: Exception do
      Logger.Error('TFiscalPrinterImpl.PrintRecMessages', E);
  end;
end;

procedure TFiscalPrinterImpl.PrintDocumentEnd;
begin
  if Receipt.PrintEnabled then
  begin
    try
      if Parameters.PrintRecMessageMode = PrintRecMessageModeNormal then
        PrintRecMessages;

      PrintFiscalEnd;
      Receipt.AfterEndFiscalReceipt;
      Filters.AfterPrintReceipt;
    except
      on E: Exception do
        Logger.Error('TFiscalPrinterImpl.EndFiscalReceipt', E);
    end;
  end;
end;

function TFiscalPrinterImpl.FSPrintCorrectionReceipt(
  var Command: TFSCorrectionReceipt): Integer;
begin
  Result := Device.FSPrintCorrectionReceipt(Command);
  if Result = 0 then
  begin
    PrintDocumentEnd;
  end;
end;

function TFiscalPrinterImpl.FSPrintCorrectionReceipt2(
  var Data: TFSCorrectionReceipt2): Integer;
begin
  Result := Device.FSPrintCorrectionReceipt2(Data);
  if Result = 0 then
  begin
    PrintDocumentEnd;
  end;
end;

function TFiscalPrinterImpl.ReadFSParameter(ParamID: Integer;
  const pString: WideString): WideString;

  (*
  7.1.8 Формат квитанции, при выдаче из Архива ФН
  ------------------------------------------------
  Поле                        Тип            Длина
  ------------------------------------------------
  Дата и время                DATE_TIME      5
  Фискальный признак ОФД      DATA           18
  Номер ФД                    Uint32, LE     4
  ------------------------------------------------
  *)

var
  Ticket: TFSTicket;
  FSState: TFSState;
  CommandFF03: TCommandFF03;
  FSCommStatus: TFSCommStatus;
  FSFiscalResult: TFSFiscalResult;
begin
  case ParamID of
    DIO_FS_PARAMETER_SERIAL:
    begin
      Device.Check(Device.FSReadState(FSState));
      Result := String(FSState.FSNumber);
    end;

    DIO_FS_PARAMETER_LAST_DOC_NUM:
    begin
      Result := IntToStr(Device.FSReadLastDocNum);
    end;

    DIO_FS_PARAMETER_LAST_DOC_MAC:
    begin
      Result := IntToStr(Device.FSReadLastMacValue);
    end;

    DIO_FS_PARAMETER_QUEUE_SIZE:
    begin
      Device.Check(Device.FSReadCommStatus(FSCommStatus));
      Result := IntToStr(FSCommStatus.DocumentCount);
    end;

    DIO_FS_PARAMETER_EXPIRE_DATE:
    begin
      Device.Check(Device.FSReadExpiration(CommandFF03));
      Result := EncodeOposDate(CommandFF03.ExpDate);
    end;

    DIO_FS_PARAMETER_FIRST_DOC_NUM:
    begin
      Device.Check(Device.FSReadCommStatus(FSCommStatus));
      Result := IntToStr(FSCommStatus.DocumentNumber);
    end;

    DIO_FS_PARAMETER_FIRST_DOC_DATE:
    begin
      Device.Check(Device.FSReadCommStatus(FSCommStatus));
      Result := EncodeOposDate(FSCommStatus.DocumentDate);
    end;

    DIO_FS_PARAMETER_FISCAL_DATE:
    begin
      Device.Check(Device.FSReadFiscalResult(FSFiscalResult));
      Result := EncodeOposDate(FSFiscalResult.Date);
    end;

    DIO_FS_PARAMETER_OFD_ONLINE:
    begin
      Device.Check(Device.FSReadCommStatus(FSCommStatus));
      Result := BoolToStr(FSCommStatus.FSWriteStatus.IsConnected);
    end;

    DIO_FS_PARAMETER_TICKET_HEX:
    begin
      Ticket.Number := StrToInt(pString);
      Device.Check(Device.FSReadTicket(Ticket));
      Result := StrToHexText(Ticket.Data);
    end;

    DIO_FS_PARAMETER_TICKET_STR:
    begin
      Ticket.Number := StrToInt(pString);
      Device.Check(Device.FSReadTicket(Ticket));
      Result := TicketToStr(Ticket);
    end;

    DIO_FS_PARAMETER_LAST_DOC_NUM2:
    begin
      Result := IntToStr(Device.FSReadLastDocNum2);
    end;

    DIO_FS_PARAMETER_LAST_DOC_MAC2:
    begin
      Result := IntToStr(Device.FSReadLastMacValue2);
    end;
  else
    raiseException(_('Invalid pData parameter value'));
  end;
end;

procedure TFiscalPrinterImpl.SetReceiptField(FieldNumber: Integer;
  const FieldValue: WideString);
begin
  Parameters.SetReceiptField(FieldNumber, FieldValue);
end;

procedure TFiscalPrinterImpl.AddItemCode(const Code: WideString);
begin
  Receipt.AddItemCode(Code);
end;

end.
