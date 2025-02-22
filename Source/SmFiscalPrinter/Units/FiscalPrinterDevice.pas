unit FiscalPrinterDevice;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Variants, SyncObjs, Graphics, Math, StrUtils,
  DateUtils,
  // 3'd
  TntClasses, JvGIF, JvPCX, PngImage, uZintBarcode, uZintInterface,
  // Opos
  Opos, OposException, OposFptr, OposFptrHi, OposUtils, OposFptrUtils,
  // This
  PrinterCommand, PrinterTypes, BinStream, StringUtils,
  SerialPort, PrinterTable, LogFile, ByteUtils, FiscalPrinterTypes,
  DeviceTables, PrinterModel, XmlModelReader, PrinterConnection,
  CommunicationError, VersionInfo, DefaultModel, DriverTypes,
  TableParameter, DebugUtils, ClassLogger, DriverError,
  FiscalPrinterStatistics, ParameterValue, EJReportParser,
  PrinterParameters, DirectIOAPI, FileUtils,
  PrinterDeviceFilter, TLV, CsvPrinterTableFormat, MalinaParams, DriverContext,
  PrinterFonts, TLVParser, TLVTags, GS1Barcode, EKMClient, WException,
  TntSysUtils, gnugettext, RegExpr;

type
  { TFiscalPrinterDevice }

  TFiscalPrinterDevice = class(TInterfacedObject, IFiscalPrinterDevice)
  protected
    FFFDVersion: TFFDVersion;
    FContext: TDriverContext;
    FCapSubtotalRound: Boolean;
    FCapDiscount: Boolean;
    FCapBarLine: Boolean;
    FCapScaleGraphics: Boolean;
    FCapBarcode2D: Boolean;
    FCapGraphics1: Boolean;
    FCapGraphics2: Boolean;
    FCapGraphics512: Boolean;
    FCapFiscalStorage: Boolean;
    FCapReceiptDiscount: Boolean;
    FCapFontInfo: Boolean;
    FDiscountMode: Integer;
    FDocPrintMode: Integer;
    FIsFiscalized: Boolean;
    FCapParameters2: Boolean;
    FParameters2: TPrinterParameters2;
    FIsOnline: Boolean;
    FResultCode: Integer;
    FResultText: WideString;
    FLogger: TClassLogger;
    FTaxPassword: DWORD;        // tax officer password
    FSysPassword: DWORD;        // system administrator password
    FUsrPassword: DWORD;        // regular user password
    FModel: TPrinterModel;
    FModelData: TPrinterModelRec;
    FTables: TPrinterTables;
    FFields: TPrinterFields;
    FModels: TPrinterModels;
    FOnCommand: TCommandEvent;
    FOnPrinterStatus: TNotifyEvent;
    FBeforeCommand: TCommandEvent;
    FDeviceTables: TDeviceTables;
    FConnection: IPrinterConnection;
    FValidDeviceMetrics: Boolean;
    FDeviceMetrics: TDeviceMetrics;
    FLock: TCriticalSection;
    FStatistics: TFiscalPrinterStatistics;
    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FFilter: TFiscalPrinterFilter;
    FAmountDecimalPlaces: Integer;
    FOnProgress: TProgressEvent;
    FFontInfo: TFontInfoList;
    FTaxInfo: TTaxInfoList;
    FPrinterStatus: TPrinterStatus;
    FLongStatus: TLongPrinterStatus;
    FShortStatus: TShortPrinterStatus;
    FCapFooterFlag: Boolean;
    FFooterFlag: Boolean;
    FCapEnablePrint: Boolean;
    FLastDocMac: Int64;
    FLastDocNumber: Int64;
    FLastDocTotal: Int64;
    FLastDocDate: TPrinterDate;
    FLastDocTime: TPrinterTime;
    FSTLVTag: TTLV;
    FSTLVStarted: Boolean;
    FTLVItems: TStrings;
    FCondensedFont: Boolean;
    FHeadToCutterDistanse: Integer;
    FCutterToCombDistanse: Integer;

    procedure PrintLineFont(const Data: TTextRec);
    procedure SetPrinterStatus(Value: TPrinterStatus);
    procedure WriteLogModelParameters(const Model: TPrinterModelRec);

    function GetModelsFileName: WideString;
    function SelectModel: TPrinterModel;
    function GetPrinterModel: TPrinterModel;
    function GetDeviceMetrics: TDeviceMetrics;
    function MinProtocolVersion(V1, V2: Integer): Boolean;
    function CenterLine(const Line: WideString): WideString;
    function AlignLine(const Line: WideString; PrintWidth: Integer;
      Alignment: TTextAlignment = taLeft): WideString;
    procedure SplitText(const Text: WideString; Font: Integer;
      Lines: TTntStrings);
    function ValidFieldValue(const FieldInfo: TPrinterFieldRec;
      const FieldValue: WideString): Boolean;
    function GetStatistics: TFiscalPrinterStatistics;
    function GetResultCode: Integer;
    function GetResultText: WideString;
    function ReadEJActivationText(MaxCount: Integer): WideString;
    function GetIsOnline: Boolean;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetOnConnect(const Value: TNotifyEvent);
    procedure SetOnDisconnect(const Value: TNotifyEvent);
    procedure SetIsOnline(Value: Boolean);
    procedure OpenDay;
    procedure UpdateDepartment(var P: TPriceReg);
    procedure CheckGraphicsSize(Line: Word);
    function GetAmountDecimalPlaces: Integer;
    procedure SetAmountDecimalPlaces(const Value: Integer);
    procedure PrintBarcodeZInt(const Barcode: TBarcodeRec);
    function DrawScale(const P: TDrawScale): Integer;
    function Is1DBarcode(Symbology: Integer): Boolean;
    procedure LoadBitmap(StartLine: Integer; Bitmap: TBitmap);
    function GetLineData(Bitmap: TBitmap; Index: Integer): AnsiString;
    procedure ProgressEvent(Progress: Integer);
    function Is2DBarcode(Symbology: Integer): Boolean;
    procedure Connect;
    procedure Disconnect;
    function WaitForPrinting: TPrinterStatus;
    function ReadPrinterStatus: TPrinterStatus;
    procedure AlignBitmap(Bitmap: TBitmap; const Barcode: TBarcodeRec;
      HScale: Integer; PrintWidthInDots: Integer);
    function PrintBarcode2D(const Barcode: TBarcode2D): Integer;
    function LoadBarcode2D(const Data: TBarcode2DData): Integer;
    function PrintQRCode2D(Barcode: TBarcodeRec): Integer;
    function GetMaxGraphicsHeight: Integer;
    function GetMaxGraphicsWidth: Integer;
    procedure LoadBitmap320(StartLine: Integer; Bitmap: TBitmap);
    procedure LoadBitmap512(StartLine: Integer; Bitmap: TBitmap;
      Scale: Integer);
    function TestCommand(Code: Integer): Boolean;
    function ReadEJDocumentText(MACNumber: Integer): WideString;
    function ReadEJDocument(MACNumber: Integer; var Line: WideString): Integer;
    function ParseEJDocument(const Text: WideString): TEJDocument;
    function FSSale(P: TFSSale): Integer;
    function FSSale2(P: TFSSale2): Integer;

    function ProcessLine(const Line: WideString): Boolean;
    function FSReadStatus(var R: TFSStatus): Integer;
    function FSFindDocument(DocNumber: Integer; var R: TFSDocument): Integer;
    function FSReadDocMac(var DocMac: Int64): Integer;

    function FSReadBlock(const P: TFSBlockRequest;
      var Block: AnsiString): Integer;
    function FSStartWrite(DataSize: Word; var BlockSize: Byte): Integer;
    function FSWriteBlock(const Block: TFSBlock): Integer;
    function FSReadBlockData: AnsiString;
    procedure FSWriteBlockData(const BlockData: AnsiString);
    function FSReadState(var R: TFSState): Integer;
    function ReadCapFiscalStorage: Boolean;
    function GetErrorText(Code: Integer): WideString;
    function OpenFiscalDay: Boolean;
    function GetCapFiscalStorage: Boolean;
    function GetCapReceiptDiscount: Boolean;
    procedure PrintCommStatus;
    procedure WriteFPParameter(ParamId: Integer; const Value: WideString);
    function GetDiscountMode: Integer;
    function GetIsFiscalized: Boolean;
    function ReadDayTotalsByReceiptType(Index: Integer): Int64;
    function ReadFPTotals(Flags: Integer): TFMTotals;
    function ReadDayTotals: TFMTotals;
    function LoadPicture(Picture: TPicture; StartLine: Integer): Integer;

    procedure PrintString(Flags: Byte; const Line: WideString);
    procedure WriteFields(Table: TPrinterTable);
    function FSReadTicket(var R: TFSTicket): Integer;
    function GetLogger: ILogFile;
    function GetMalinaParams: TMalinaParams;
    function GetCapDiscount: Boolean;
    function ReadLoaderVersion(var Version: WideString): Integer;
    function ReceiptCancelPassword(Password: Integer): Integer;
    function IsSupported(ResultCode: Integer): Boolean;
    function IsCapFooterFlag: Boolean;
    function GetPrintFlags(Flags: Integer): Integer;
    procedure SetFooterFlag(Value: Boolean);
    procedure PrintQRCode3(Barcode: TBarcodeRec);
    function GetBlockSize(BlockSize: Integer): Integer;
    function ReadFSDocument(Number: Integer): WideString;
    procedure PrintFSDocument(Number: Integer);
    function FSReadDocData(var P: TFSReadDocData): Integer;
    function FSReadDocument(var P: TFSReadDocument): Integer;
    function FSStartOpenDay: Integer;
    function IsMobilePrinter: Boolean;
    procedure EkmCheckBarcode(const Barcode: TGS1Barcode);
    function CheckItemCode(const Barcode: WideString): Integer;
    function LoadBarcodeData(BlockType: Integer; const Barcode: WideString): Integer;
    function SendItemBarcode(const Barcode: WideString;
      MarkType: Integer): Integer;
    function IsFSDocumentOpened: Boolean;
    function FSCancelDocument: Integer;
    function GetLastDocNumber: Int64;
    function GetLastDocMac: Int64;
    function GetLastDocTotal: Int64;
    function GetLastDocDate: TPrinterDate;
    function GetLastDocTime: TPrinterTime;
    function PrintItemText(const S: WideString): WideString;
    procedure WriteTLVItems;
    function ReadDocPrintMode: Integer;
    procedure Initialize;
    procedure CorrectDate;
    function ReadDocData: WideString;
    procedure CheckPrinterStatus;
    procedure SetCapFiscalStorage(const Value: Boolean);
    function FilterTLV(Data: AnsiString): AnsiString;
    function GetFFDVersion: TFFDVersion;
    function GetFont(Font: Integer): TFontInfo;
    function ValidFont(Font: Integer): Boolean;
  protected
    function GetMaxGraphicsWidthInBytes: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
    procedure FullCut;
    procedure StopDump;
    procedure UpdateInfo;
    procedure PartialCut;
    procedure LoadModels;
    procedure SaveModels;
    procedure ReadModelParameters;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure SetLongSerial(Serial: Int64);
    procedure SetSysPassword(const Value: DWORD);
    procedure SetTaxPassword(const Value: DWORD);
    procedure SetUsrPassword(const Value: DWORD);
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);

    function Beep: Integer;
    function GetDumpBlock: TDumpBlock;
    function GetLongSerial: TGetLongSerial;
    function ReadLongStatus: TLongPrinterStatus;
    function GetFMFlags(Flags: Byte): TFMFlags;
    function ReadShortStatus: TShortPrinterStatus;
    function StartDump(DeviceCode: Integer): Integer;
    function PrintBoldString(Flags: Byte; const Text: WideString): Integer;
    function GetPortParams(Port: Byte): TPortParams;
    function SetPortParams(Port: Byte; const PortParams: TPortParams): Integer;
    procedure PrintDocHeader(const DocName: WideString; DocNumber: Word);
    procedure StartTest(Interval: Byte);
    function ReadCashRegister(ID: Integer): Int64;
    function ReadCashReg2(RegID: Integer): Int64;
    function ReadOperatingRegister(ID: Byte): Word;
    function ReadOperatingReg(ID: Byte; var R: TOperRegisterRec): Integer;
    procedure WriteLicense(License: Int64);
    function ReadLicense: Int64;
    function WriteTable(Table, Row, Field: Integer; const FieldValue: WideString): Integer;
    function WriteTableInt(Table, Row, Field, Value: Integer): Integer;
    function DoWriteTable(Table, Row, Field: Integer;
      const FieldValue: WideString): Integer;
    function ReadTableBin(Table, Row, Field: Integer): WideString;
    function ReadTableStr(Table, Row, Field: Integer): WideString;
    function ReadTableInt(Table, Row, Field: Integer): Integer;
    procedure SetPointPosition(PointPosition: Byte);
    procedure SetTime(const Time: TPrinterTime);
    procedure WriteDate(const Date: TPrinterDate);
    procedure ConfirmDate(const Date: TPrinterDate);
    procedure InitializeTables;
    procedure CutPaper(CutType: Byte);
    function ReadFontInfo(FontNumber: Byte): TFontInfo;
    procedure ResetFiscalMemory;
    procedure ResetTotalizers;
    procedure OpenDrawer(DrawerNumber: Byte);
    procedure FeedPaper(Station: Byte; Lines: Byte);
    procedure EjectSlip(Direction: Byte);
    procedure StopTest;
    procedure PrintActnTotalizers;
    procedure PrintXReport;
    procedure PrintZReport;
    procedure PrintDepartmentsReport;
    procedure PrintTaxReport;
    procedure PrintHeader;
    procedure PrintDocTrailer(Flags: Byte);
    procedure PrintTrailer;
    procedure WriteSerial(Serial: DWORD);
    procedure InitFiscalMemory;
    function OpenSlipDoc(Params: TSlipParams): TDocResult;
    function OpenStdSlip(Params: TStdSlipParams): TDocResult;
    function SlipOperation(Params: TSlipOperation; Operation: TPriceReg): Integer;
    function SlipStdOperation(LineNumber: Byte; Operation: TPriceReg): Integer;
    function SlipDiscount(Params: TSlipDiscountParams; Discount: TSlipDiscount): Integer;
    function SlipStdDiscount(Discount: TSlipDiscount): Integer;
    function SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ReadFMTotals(Flags: Byte; var R: TFMTotals): Integer;
    function ContinuePrint: Integer;

    function PrintBarcode(const Barcode: WideString): Integer;
    function PrintGraphics(Line1, Line2: Word): Integer;
    function PrintGraphics1(Line1, Line2: Byte): Integer;
    function PrintGraphics2(Line1, Line2: Word): Integer;
    function PrintGraphics3(Line1, Line2: Word): Integer; overload;
    function PrintGraphics3(const P: TPrintGraphics3): Integer; overload;
    function LoadGraphics(Line: Word; Data: AnsiString): Integer;
    function LoadGraphics1(Line: Byte; Data: AnsiString): Integer;
    function LoadGraphics2(Line: Word; Data: AnsiString): Integer;
    function LoadGraphics3(Line: Word; Data: AnsiString): Integer; overload;
    function LoadGraphics3(const P: TLoadGraphics3): Integer; overload;
    function PrintBarLine(Height: Word; Data: AnsiString): Integer;
    function PrintGraphicsLine(Height: Word; Flags: Byte; Data: WideString): Integer;
    function ReadDeviceMetrics: TDeviceMetrics;
    function GetDayDiscountTotal: Int64;
    function GetRecDiscountTotal: Int64;
    function GetDayItemTotal: Int64;
    function GetRecItemTotal: Int64;
    function GetDayItemVoidTotal: Int64;
    function GetRecItemVoidTotal: Int64;
    function ReadTableInfo(Table: Byte; var R: TPrinterTableRec): Integer;
    function ReadTableStructure(Table: Byte; var R: TPrinterTableRec): Integer;
    function ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
    function GetEJSesssionResult(Number: Word; var Text: WideString): Integer;
    function GetEJReportLine(var Line: WideString): Integer;
    function ReadEJActivation(var Line: WideString): Integer;
    function EJReportStop: Integer;
    procedure Check(Code: Integer);
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    procedure PrintStringFont(Flags, Font: Byte; const Line: WideString);
    procedure PrintJournal(DayNumber: Integer);

    function GetSysPassword: DWORD;
    function GetTaxPassword: DWORD;
    function GetUsrPassword: DWORD;
    function GetPrintWidth: Integer; overload;
    function GetPrintWidth(Font: Integer): Integer; overload;

    function Execute(const Data: AnsiString): AnsiString;
    function ExecuteStream(Stream: TBinStream): Integer;
    function ExecutePrinterCommand(Command: TPrinterCommand): Integer;

    function GetSubtotal: Int64;
    function ReceiptCancel: Integer;
    procedure CancelReceipt;
    function Sale(Operation: TPriceReg): Integer;
    function Buy(Operation: TPriceReg): Integer;
    function RetSale(Operation: TPriceReg): Integer;
    function RetBuy(Operation: TPriceReg): Integer;
    function Storno(Operation: TPriceReg): Integer;
    function ReceiptClose(const P: TCloseReceiptParams;
      var R: TCloseReceiptResult): Integer;
    function ReceiptClose2(const P: TFSCloseReceiptParams2;
      var R: TFSCloseReceiptResult2): Integer;

    function ReceiptDiscount(Operation: TAmountOperation): Integer;
    function ReceiptDiscount2(Operation: TReceiptDiscount2): Integer;
    function ReceiptCharge(Operation: TAmountOperation): Integer;
    function ReceiptStornoDiscount(Operation: TAmountOperation): Integer;
    function ReceiptStornoCharge(Operation: TAmountOperation): Integer;
    function PrintReceiptCopy: Integer;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function FormatLines(const Line1, Line2: WideString): WideString;
    procedure PrintLines(const Line1, Line2: WideString);
    function FormatBoldLines(const Line1, Line2: WideString): WideString;
    procedure EJTotalsReportDate(const Parameters: TDateReport);
    procedure EJTotalsReportNumber(const Parameters: TNumberReport);
    function ExecuteStream2(Stream: TBinStream): Integer;
    function GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: WideString): AnsiString;
    function FieldToStr(FieldInfo: TPrinterFieldRec; const Value: WideString): WideString;
    function BinToFieldValue(FieldInfo: TPrinterFieldRec; const Value: WideString): WideString;
    class function ByteToTimeout(Value: Byte): DWORD;
    class function TimeoutToByte(Value: Integer): Byte;
    procedure InterruptReport;
    function ReadDaysRange: TDayRange;
    function ReadFMLastRecordDate: TFMRecordDate;
    function ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
    function LongFisc(NewPassword: DWORD; PrinterID, FiscalID: Int64): TLongFiscResult;
    function Fiscalization(Password, PrinterID, FiscalID: Int64): TFiscalizationResult;
    function ReportOnDateRange(ReportType: Byte; Range: TDayDateRange): TDayRange;
    function ReportOnNumberRange(ReportType: Byte; Range: TDayNumberRange): TDayRange;
    function DecodeEJFlags(Flags: Byte): TEJFlags;
    function GetLine(const Text: WideString): WideString; overload;
    function GetLine(const Text: WideString; MinLength, MaxLength: Integer): WideString; overload;
    function GetText(const Text: WideString; MinLength: Integer): WideString;
    class function BaudRateToCode(BaudRate: Integer): Integer;
    class function CodeToBaudRate(BaudRate: Integer): Integer;
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: WideString): Integer;
    function ReadFieldInfo(Table, Field: Byte; var R: TPrinterFieldRec): Integer;
    function ExecuteData(const TxData: AnsiString): Integer; overload;
    function ExecuteData(const TxData: AnsiString; var RxData: AnsiString): Integer; overload;
    function ExecuteCommand(var Command: TCommandRec): Integer;

    function SendCommand(var Command: TCommandRec): Integer;
    function GetModel: TPrinterModelRec;
    function GetOnCommand: TCommandEvent;
    function GetOnPrinterStatus: TNotifyEvent;
    function GetBeforeCommand: TCommandEvent;
    procedure SetOnPrinterStatus(Value: TNotifyEvent);
    procedure SetOnCommand(Value: TCommandEvent);
    procedure SetBeforeCommand(Value: TCommandEvent);
    procedure PrintText(const Data: TTextRec); overload;
    procedure PrintText(Station: Integer; const Text: WideString); overload;
    function GetTables: TDeviceTables;
    procedure SetTables(const Value: TDeviceTables);

    procedure ClosePort;
    procedure Close;
    procedure Open(AConnection: IPrinterConnection);
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function CapGraphics: Boolean;
    function CapShortEcrStatus: Boolean;
    function CapPrintStringFont: Boolean;
    function CapParameter(ParamID: Integer): Boolean;
    function ReadParameter(ParamID: Integer): Integer;
    function ValidField(Table, Field: Integer): Boolean;
    function ValidParameter(const Parameter: TTableParameter): Boolean;
    function ValidRow(Table, Row: Integer): Boolean;
    procedure WriteParameter(ParamID, ValueID: Integer);
    procedure ReadModelData;
    procedure ReadModelTables;
    function QueryEJActivation: TEJActivation;
    procedure AddFilter(AFilter: IFiscalPrinterFilter);
    procedure RemoveFilter(AFilter: IFiscalPrinterFilter);
    function IsDayOpened(Mode: Integer): Boolean;
    procedure PrintBarcode2(const Barcode: TBarcodeRec);
    function GetStartLine: Integer;
    function LoadImage(const FileName: WideString; StartLine: Integer): Integer;
    procedure PrintImage(const FileName: WideString; StartLine: Integer);
    procedure PrintImageScale(const FileName: WideString; StartLine, Scale: Integer);
    procedure PrintTextFont(Station: Integer; Font: Integer; const Text: WideString);
    procedure LoadTables(const Path: WideString);
    procedure FSWriteTLV2(const TLVData: AnsiString);

    function FSWriteTLV(const TLVData: AnsiString): Integer;
    function FSPrintCalcReport(var R: TFSCalcReport): Integer;
    function FSReadCommStatus(var R: TFSCommStatus): Integer;
    function FSReadExpiration(var R: TCommandFF03): Integer;
    function FSReadFiscalResult(var R: TFSFiscalResult): Integer;
    function FSWriteTag(TagID: Integer; const Data: WideString): Integer;

    function ReadSysOperatorNumber: Integer;
    function ReadUsrOperatorNumber: Integer;
    function readOperatorNumber(Password: Integer): Integer;
    function WriteCustomerAddress(const Value: WideString): Integer;

    function ReadShortStatus2(Password: Integer): TShortPrinterStatus;
    function GetTaxInfo(Tax: Integer): TTaxInfo;
    function ReadDiscountMode: Integer;
    function ReadFPParameter(ParamId: Integer): WideString;
    function FSReadTotals(var R: TFMTotals): Integer;
    function FSReadCorrectionTotals(var R: TFMTotals): Integer;
    function FSReadTotalsByPayType(RecType: Byte; var R: TFSTotalsByPayType): Integer;
    function ReadFPDayTotals(Flags: Integer): TFMTotals;
    function ReadTotalsByReceiptType(Index: Integer): Int64;
    function FSPrintCorrectionReceipt(var Command: TFSCorrectionReceipt): Integer;
    function FSPrintCorrectionReceipt2(var Data: TFSCorrectionReceipt2): Integer;
    function GetParameters: TPrinterParameters;
    function GetContext: TDriverContext;
    function IsRecOpened: Boolean;
    function GetCapSubtotalRound: Boolean;
    function ReadParameters2(var R: TPrinterParameters2): Integer;
    function FSFiscalization(const P: TFSFiscalization; var R: TFDDocument): Integer;
    function FSReFiscalization(const P: TFSReFiscalization; var R: TFDDocument): Integer;
    function GetPrinterStatus: TPrinterStatus;
    function IsCapBarcode2D: Boolean;
    function IsCapEnablePrint: Boolean;
    function ReadCashReg(ID: Integer; var R: TCashRegisterRec): Integer;
    function FSWriteTLVOperation(const AData: AnsiString): Integer;
    function FSStartCorrectionReceipt: Integer;
    function FSReadLastDocNum: Int64;
    function FSReadLastDocNum2: Int64;
    function FSReadLastMacValue: Int64;
    function FSReadLastMacValue2: Int64;
    function FSCheckItemCode(P: TFSCheckItemCode;
      var R: TFSCheckItemResult): Integer;
    function FSSyncRegisters: Integer;
    function FSReadMemory(var R: TFSReadMemoryResult): Integer;
    function FSWriteTLVFromBuffer: Integer;
    function FSRandomData(var Data: AnsiString): Integer;
    function FSAuthorize(const DataToAuthorize: AnsiString): Integer;
    function FSAcceptItemCode(Action: Integer): Integer;
    function FSClearMCCheckResults: Integer;
    function FSBindItemCode(P: TFSBindItemCode;
      var R: TFSBindItemCodeResult): Integer;
    function FSReadTicketStatus(var R: TFSTicketStatus): Integer;
    function FSReadMarkStatus(var R: TFSMarkStatus): Integer;
    function FSStartReadTickets(var R: TFSTicketParams): Integer;
    function FSReadNextTicket(var R: TFSTicketData): Integer;
    function FSConfirmTicket(const P: TFSTicketNumber): Integer;
    function FSReadDeviceInfo(var R: string): Integer;
    function FSReadDocSize(var R: TFSDocSize): Integer;
    procedure STLVWrite;
    procedure STLVWriteOp;
    function STLVGetHex: string;
    procedure STLVBegin(TagID: Integer);
    procedure STLVAddTag(TagID: Integer; TagValue: string);
    procedure ResetPrinter;
    function BeginZReport: Integer;
    function GetDocPrintMode: Integer;
    function IsCorrectItemCode(const P: TFSCheckItemResult): Boolean;
    procedure CheckCorrectItemCode(const P: TFSCheckItemResult);
    function BarcodeTo1162Value(const Barcode: AnsiString): AnsiString;
    function FSReadRegTag(var R: TFSReadRegTagCommand): Integer;
    function GetHeaderHeight: Integer;
    function GetTrailerHeight: Integer;
    function GetTaxInfoList: TTaxInfoList;
    function GetTaxCount: Integer;
    function ReadTaxInfoList: TTaxInfoList;
    function ReadFontInfoList: TFontInfoList;
    procedure WriteTaxRate(Tax, Rate: Integer);

    property IsOnline: Boolean read GetIsOnline;
    property Tables: TPrinterTables read FTables;
    property Fields: TPrinterFields read FFields;
    property Model: TPrinterModelRec read GetModel;
    property ResultText: WideString read GetResultText;
    property ResultCode: Integer read GetResultCode;
    property Connection: IPrinterConnection read FConnection write FConnection;
    property CapFiscalStorage: Boolean read GetCapFiscalStorage write SetCapFiscalStorage;
    property DiscountMode: Integer read GetDiscountMode;
    property CapReceiptDiscount: Boolean read GetCapReceiptDiscount;
    property PrinterModel: TPrinterModel read GetPrinterModel;
    property Statistics: TFiscalPrinterStatistics read GetStatistics;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
    property OnConnect: TNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    property AmountDecimalPlaces: Integer read GetAmountDecimalPlaces write SetAmountDecimalPlaces;
    property Parameters: TPrinterParameters read GetParameters;
    property Logger: ILogFile read GetLogger;
    property MalinaParams: TMalinaParams read GetMalinaParams;
    property CapDiscount: Boolean read GetCapDiscount;
    property CapSubtotalRound: Boolean read GetCapSubtotalRound;
    property LastDocMac: Int64 read GetLastDocMac;
    property LastDocNumber: Int64 read GetLastDocNumber;
    property CondensedFont: Boolean read FCondensedFont;
    property TaxInfoList: TTaxInfoList read GetTaxInfoList;
    property TaxCount: Integer read GetTaxCount;
  end;

  { EDisabledException }

  EDisabledException = class(WideException);
  EFiscalPrinterException = class(WideException);

const
  PrinterBaudRates: array [0..6] of Integer = (
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_19200,
    CBR_38400,
    CBR_57600,
    CBR_115200);


implementation

function GetDataBlock(const Data: AnsiString;
  MinLength, MaxLength: Integer): AnsiString;
begin
  Result := Copy(Data, 1, MaxLength);
  Result := Result + StringOfChar(#0, MinLength - Length(Result));
end;

function TLVToText(const TLVData: AnsiString): AnsiString;
var
  Parser: TTLVParser;
begin
  Parser := TTLVParser.Create;
  try
    Parser.ShowTagNumbers := True;
    Result := Parser.ParseTLV(TLVData);
  finally
    Parser.Free;
  end;
end;

procedure CheckParam(Value, Min, Max: Int64; const ParamName: WideString);
begin
  if (Value < Min)or(Value > Max) then
    raise Exception.Create(Format('%s, %s', [_('Invalid parameter value'), ParamName]));
end;

// 0	�� ������ ����
// 1	�� ������
// 2	�� ������� ����
function IntToAlignment(Alignment: Integer): Integer;
begin
  Result := 1;
  case Alignment of
    BARCODE_ALIGNMENT_CENTER: Result := 1;
    BARCODE_ALIGNMENT_LEFT: Result := 0;
    BARCODE_ALIGNMENT_RIGHT: Result := 2;
  end;
end;

{ ��������� �������� ���������� ������� }
function GetCommandTimeout(Command: Word): Integer;
begin
  case Command of
    $01: Result := 3000; // Get dump
    $02: Result := 3000; // Get data block from dump
    $03: Result := 3000; // Interrupt data stream
    $0D: Result := 3000; // Fiscalization/refiscalization with long ECRRN
    $0E: Result := 3000; // Set long serial number
    $0F: Result := 3000; // Get long serial number and long ECRRN
    $10: Result := 3000; // Get short ECR status
    $11: Result := 3000; // Get ECR status
    $12: Result := 3000; // Print bold AnsiString
    $13: Result := 3000; // Beep
    $14: Result := 3000; // Set communication parameters
    $15: Result := 3000; // Read communication parameters
    $16: Result := 60000; // Technological reset
    $17: Result := 3000; // Print AnsiString
    $18: Result := 3000; // Print document header
    $19: Result := 10000; // Test run
    $1A: Result := 3000; // Get cash totalizer value
    $1B: Result := 3000; // Get operation totalizer value
    $1C: Result := 3000; // Write license
    $1D: Result := 3000; // Read license
    $1E: Result := 3000; // Write table
    $1F: Result := 3000; // Read table
    $20: Result := 3000; // Set decimal point position
    $21: Result := 3000; // Set clock time
    $22: Result := 3000; // Set calendar date
    $23: Result := 3000; // Confirm date
    $24: Result := 3000; // Initialize tables with default values
    $25: Result := 10000; // Cut receipt
    $26: Result := 3000; // Get font parameters
    $27: Result := 30000; // Common clear
    $28: Result := 10000; // Open cash drawer
    $29: Result := 3000; // Feed
    $2A: Result := 3000; // Eject slip
    $2B: Result := 3000; // Interrupt test
    $2C: Result := 30000; // Print operation totalizers report
    $2D: Result := 3000; // Get table structure
    $2E: Result := 3000; // Get field structure
    $2F: Result := 3000; // Print AnsiString with font
    $40: Result := 30000; // Daily report without cleaning
    $41: Result := 30000; // Daily report with cleaning
    $42: Result := 30000; // Print Department report
    $43: Result := 30000; // Print tax report
    $4D: Result := 3000; // Print graphics 512
    $4E: Result := 3000; // Load graphics 512
    $4F: Result := 3000; // Print scaled graphics
    $50: Result := 10000; // Cash in
    $51: Result := 10000; // Cash out
    $52: Result := 10000; // Print fixed document header
    $53: Result := 10000; // Print document footer
    $54: Result := 10000; // Print trailer
    $60: Result := 3000; // Set serial number
    $61: Result := 30000; // Initialize FM
    $62: Result := 30000; // Get FM totals
    $63: Result := 30000; // Get last FM record date
    $64: Result := 30000; // Get dates and sessions range
    $65: Result := 30000; // Fiscalization/refiscalization
    $66: Result := 30000; // Fiscal report in dates range
    $67: Result := 30000; // Fiscal report in days range
    $68: Result := 30000; // Interrupt full report
    $69: Result := 30000; // Get fiscalization parameters
    $70: Result := 30000; // Open fiscal slip
    $71: Result := 30000; // Open standard fiscal slip
    $72: Result := 30000; // Transaction on slip
    $73: Result := 30000; // Standard transaction on slip
    $74: Result := 30000; // Discount/charge on slip
    $75: Result := 30000; // Standard discount/charge on slip
    $76: Result := 30000; // Close fiscal slip
    $77: Result := 30000; // Close standard fiscal slip
    $78: Result := 30000; // Slip configuration
    $79: Result := 30000; // Standard slip configuration
    $7A: Result := 30000; // Fill slip buffer with nonfiscal information
    $7B: Result := 30000; // Clear slip buffer AnsiString
    $7C: Result := 30000; // Clear slip buffer
    $7D: Result := 30000; // Print slip
    $7E: Result := 30000; // Common slip configuration
    $80: Result := 10000; // Sale
    $81: Result := 10000; // Buy
    $82: Result := 10000; // Sale refund
    $83: Result := 10000; // Buy refund
    $84: Result := 10000; // Void transaction
    $85: Result := 30000; // Close receipt
    $86: Result := 10000; // Discount
    $87: Result := 10000; // Charge
    $88: Result := 10000; // Cancel receipt
    $89: Result := 10000; // Receipt subtotal
    $8A: Result := 10000; // Void discount
    $8B: Result := 10000; // Void charge
    $8C: Result := 30000; // Print last receipt duplicate
    $8D: Result := 10000; // Open receipt
    $90: Result := 30000; // Oil products sale receipt in defined dose pre-payment mode
    $91: Result := 30000; // Oil products sale receipt in defined sum pre-payment mode
    $92: Result := 30000; // Correction receipt on incomplete oil-products sale
    $93: Result := 30000; // Set fuel-dispensing unit dose in milliliters
    $94: Result := 30000; // Set fuel-dispensing unit dose in cash units
    $95: Result := 30000; // Oil products sale
    $96: Result := 30000; // Stop fuel-dispensing unit
    $97: Result := 30000; // Start fuel-dispensing unit
    $98: Result := 30000; // Reset fuel-dispensing unit
    $99: Result := 30000; // Reset all fuel-dispensing units
    $9A: Result := 30000; // Set fuel-dispensing unit parameters
    $9B: Result := 30000; // Read liter totals counter
    $9E: Result := 30000; // Get current fuel-dispensing unit dose
    $9F: Result := 30000; // Get fuel-dispensing unit status
    $A0: Result := 30000; // EJ department report in dates range
    $A1: Result := 30000; // EJ department report in days range
    $A2: Result := 30000; // EJ day report in dates range
    $A3: Result := 30000; // EJ day report in days range
    $A4: Result := 30000; // Print day totals by EJ day number
    $A5: Result := 30000; // Print pay document from EJ by KPK number
    $A6: Result := 30000; // Print EJ journal by day number
    $A7: Result := 30000; // Interrupt full EJ report
    $A8: Result := 30000; // Print EJ activization result
    $A9: Result := 30000; // EJ activization
    $AA: Result := 30000; // Close EJ archive
    $AB: Result := 30000; // Get EJ serial number
    $AC: Result := 30000; // Interrupt EJ
    $AD: Result := 30000; // Get EJ status by code 1
    $AE: Result := 30000; // Get EJ status by code 2
    $AF: Result := 30000; // Test EJ integrity
    $B0: Result := 10000; // Continue printing
    $B1: Result := 10000; // Get EJ version
    $B2: Result := 150000; // Initialize EJ
    $B3: Result := 30000; // Get EJ report data
    $B4: Result := 30000; // Get EJ journal
    $B5: Result := 30000; // Get EJ document
    $B6: Result := 150000; // Get department EJ report in dates range
    $B7: Result := 150000; // Get EJ department report in days range
    $B8: Result := 150000; // Get EJ day report in dates range
    $B9: Result := 150000; // Get EJ day report in days range
    $BA: Result := 150000; // Get EJ day totals by day number
    $BB: Result := 150000; // Get EJ activization result
    $BC: Result := 30000; // Get EJ error
    $C0: Result := 10000; // Load graphics
    $C1: Result := 10000; // Print graphics
    $C2: Result := 10000; // Print barcode
    $C3: Result := 10000; // Print exteneded graphics
    $C4: Result := 10000; // Load extended graphics
    $C5: Result := 10000; // Print line
    $C8: Result := 30000; // Get line count in printing buffer
    $C9: Result := 30000; // Get line from printing buffer
    $CA: Result := 30000; // Clear printing buffer
    $D0: Result := 30000; // Get ECR IBM status
    $D1: Result := 30000; // Get short ECR IBM status
    $DE: Result := 30000; // Print barcode 2D
    $F0: Result := 30000; // Change shutter position
    $F1: Result := 30000; // Discharge receipt from presenter
    $F3: Result := 30000; // Set service center password
    $FC: Result := 30000; // Get device type
    $FD: Result := 30000; // Send commands to external device port
    $E0: Result := 100000; // Open fiscal day
    $E1: Result := 30000; // Finish slip
    $E2: Result := 30000; // Close nonfiscal document
    $E4: Result := 30000; // Print attribute
    $FF01: Result := 30000; // FS: Read status
    $FF02: Result := 30000; // FS: Read number
    $FF03: Result := 30000; // FS: Read expiration time
    $FF04: Result := 30000; // FS: Read version
    $FF05: Result := 30000; // FS: Start activation
    $FF06: Result := 30000; // FS: Do activation
    $FF07: Result := 30000; // FS: Clear status
    $FF08: Result := 30000; // FS: Void document
    $FF09: Result := 30000; // FS: Read activation result
    $FF0A: Result := 30000; // FS: Find document by number
    $FF0B: Result := 30000; // FS: Open day
    $FF0C: Result := 30000; // FS: Send TLV data
    $FF0D: Result := 30000; // FS: Registration with discount/charge
    $FF0E: Result := 30000; // FS: Read open parameter
    $FF30: Result := 30000; // FS: Read data in buffer
    $FF31: Result := 30000; // FS: Read data block from buffer
    $FF32: Result := 30000; // FS: Start write buffer
    $FF33: Result := 30000; // FS: Write data block in buffer
    $FF34: Result := 30000; // FS: Create fiscalization report
    $FF35: Result := 30000; // FS: Start correction receipt
    $FF36: Result := 30000; // FS: Create correction receipt
    $FF37: Result := 30000; // FS: Start report on calculations
    $FF38: Result := 30000; // FS: Create report on calculations
    $FF39: Result := 30000; // FS: Read data transfer status
    $FF3A: Result := 30000; // FS: Read fiscal document in TLV format
    $FF3B: Result := 30000; // FS: Read fiscal document TLV
    $FF3C: Result := 30000; // FS: Read server ticket on document number
    $FF3D: Result := 30000; // FS: Start close fiscal mode
    $FF3E: Result := 30000; // FS: Close fiscal mode
    $FF3F: Result := 30000; // FS: Read fiscal documents count without server ticket
    $FF40: Result := 30000; // FS: Read fiscal day parameters
    $FF41: Result := 30000; // FS: Start opening fiscal day
    $FF42: Result := 30000; // FS: Start closing fiscal day
    $FF43: Result := 30000; // FS: Close day
    $FF44: Result := 30000; // FS: Registration with discount/charge 2
    $FF45: Result := 30000; // FS: Close receipt extended
    $FF4B: Result := 30000; // FS: Print receipt discount
  else
    Result := 30000;
  end;
end;

function CenterGraphicsLine(const Data: AnsiString; MaxLen, Scale: Integer): AnsiString;
begin
  if Scale = 0 then
    raiseException('Scale = 0');

  Result := Data;
  Result := Copy(Result, 1, MaxLen);
  Result := StringOfChar(#0, (MaxLen - Length(Result)*Scale) div (2 * Scale)) + Result;
  Result := Result + StringOfChar(#0, (MaxLen - Length(Result)*Scale) div (2 * Scale));
  Result := Copy(Result, 1, MaxLen);
end;

const
  MinLineWidth = 40;

function PrinterDateToBin(Value: TPrinterDate): AnsiString;
begin
  SetLength(Result, Sizeof(Value));
  Move(Value, Result[1], Sizeof(Value));
end;

procedure CheckMinLength(const Data: AnsiString; MinLength: Integer);
begin
  if Length(Data) < MinLength then
    raise ECommunicationError.Create(_('Answer data length is too short'));
end;

{ TFiscalPrinterDevice }

constructor TFiscalPrinterDevice.Create;
begin
  inherited Create;
  SetLength(FTaxInfo, 4);
  FTLVItems := TStringList.Create;
  FSTLVTag := TTLV.Create(nil);
  FContext := TDriverContext.Create;
  FLogger := TClassLogger.Create('TFiscalPrinterDevice', FContext.Logger);
  FLock := TCriticalSection.Create;
  FFields := TPrinterFields.Create;
  FTables := TPrinterTables.Create;
  FModels := TPrinterModels.Create;
  FStatistics := TFiscalPrinterStatistics.Create(Parameters.Logger);
  FFilter := TFiscalPrinterFilter.Create(Parameters.Logger);
  FAmountDecimalPlaces := 2;
  FCapReceiptDiscount := True;
  FCapGraphics1 := True;
  LoadModels;
  Initialize;
end;

destructor TFiscalPrinterDevice.Destroy;
begin
  FLock.Free;
  FFields.Free;
  FTables.Free;
  FModels.Free;
  FConnection := nil;
  FLogger.Free;
  FStatistics.Free;
  FFilter.Free;
  FContext.Free;
  FSTLVTag.Free;
  FTLVItems.Free;
  inherited Destroy;
end;

procedure TFiscalPrinterDevice.Disconnect;
begin
  Initialize;
end;

procedure TFiscalPrinterDevice.Initialize;
begin
  Tables.Clear;
  Fields.Clear;
  FValidDeviceMetrics := False;
  FCapSubtotalRound := False;
  FCapDiscount := False;
  FCapBarLine := True;
  FCapScaleGraphics := False;
  FCapBarcode2D := False;
  FCapGraphics1 := True;
  FCapGraphics2 := True;
  FCapGraphics512 := False;
  FCapFiscalStorage := False;
  FCapReceiptDiscount := False;
  FCapFontInfo := False;
  FIsFiscalized := False;
  FCapParameters2 := False;
  FIsOnline := False;
  FCapFooterFlag := False;
  FFooterFlag := False;
  FCapEnablePrint := False;
  FFFDVersion := TFFDVersion(-1);
end;

function TFiscalPrinterDevice.GetCapSubtotalRound: Boolean;
begin
  Result := FCapSubtotalRound;
end;

function TFiscalPrinterDevice.GetCapDiscount: Boolean;
begin
  Result := FCapDiscount;
end;

function TFiscalPrinterDevice.GetParameters: TPrinterParameters;
begin
  Result := FContext.Parameters;
end;

function TFiscalPrinterDevice.GetLogger: ILogFile;
begin
  Result := FContext.Logger;
end;

function TFiscalPrinterDevice.GetMalinaParams: TMalinaParams;
begin
  Result := FContext.MalinaParams;
end;

function TFiscalPrinterDevice.GetCapReceiptDiscount: Boolean;
begin
  Result := FCapReceiptDiscount;
end;

procedure TFiscalPrinterDevice.AddFilter(AFilter: IFiscalPrinterFilter);
begin
  FFilter.AddFilter(AFilter);
end;

procedure TFiscalPrinterDevice.RemoveFilter(AFilter: IFiscalPrinterFilter);
begin
  FFilter.RemoveFilter(AFilter);
end;

function TFiscalPrinterDevice.GetResultCode: Integer;
begin
  Result := FResultCode;
end;

function TFiscalPrinterDevice.GetResultText: WideString;
begin
  Result := FResultText;
end;

function TFiscalPrinterDevice.GetStatistics: TFiscalPrinterStatistics;
begin
  Result := FStatistics;
end;

procedure TFiscalPrinterDevice.Lock;
begin
  FLock.Enter;
end;

procedure TFiscalPrinterDevice.Unlock;
begin
  FLock.Leave;
end;

function TFiscalPrinterDevice.GetModelsFileName: WideString;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(GetDllFileName)) +
      ModelsFileName;
end;

procedure TFiscalPrinterDevice.LoadModels;
var
  Reader: TXmlModelReader;
begin
  Reader := TXmlModelReader.Create(FModels);
  try
    Reader.Load(GetModelsFileName);
  except
    on E: Exception do
      Logger.Error('TFiscalPrinterDevice.LoadModels', E);
  end;
  Reader.Free;
end;

procedure TFiscalPrinterDevice.ReadModelData;
begin
  ReadModelTables;
  ReadModelParameters;
end;

procedure TFiscalPrinterDevice.ReadModelTables;
var
  FieldValue: AnsiString;
  RowNumber: Integer;
  FieldNumber: Integer;
  ResultCode: Integer;
  TableNumber: Integer;
  Tables: TPrinterTables;
  Table: TPrinterTable;
  Field: TPrinterField;
  FieldRec: TPrinterFieldRec;
  TableRec: TPrinterTableRec;
begin
  Tables := GetPrinterModel.Tables;

  Tables.Clear;
  TableNumber := 1;
  repeat
    ResultCode := ReadTableStructure(TableNumber, TableRec);
    if ResultCode <> 0 then Break;

    Table := Tables.Add(TableRec);
    for RowNumber := 1 to Table.RowCount do
    begin
      for FieldNumber := 1 to Table.FieldCount do
      begin
        FieldRec := ReadFieldStructure(TableNumber, FieldNumber);
        FieldValue := ReadTableStr(TableNumber, RowNumber, FieldNumber);
        Field := Table.Fields.Add(FieldRec);
        Field.Value := FieldValue;
      end;
    end;
    Inc(TableNumber);
  until ResultCode <> 0;
end;

procedure TFiscalPrinterDevice.ReadModelParameters;
var
  Text: AnsiString;
  ParameterID: Integer;
  FieldValue: AnsiString;
  RowNumber: Integer;
  FieldNumber: Integer;
  ResultCode: Integer;
  TableNumber: Integer;
  FieldRec: TPrinterFieldRec;
  TableRec: TPrinterTableRec;

  Parameters: TTableParameters;
  ParameterRec: TTableParameterRec;
begin
  ParameterID := 1;
  Parameters := GetPrinterModel.Parameters;

  Parameters.Clear;
  TableNumber := 1;
  repeat
    ResultCode := ReadTableStructure(TableNumber, TableRec);
    if ResultCode <> 0 then Break;


    Text := Tnt_WideFormat('// %d, %s', [TableRec.Number, TableRec.Name]);
    OutputDebugString(PChar(Text));

    for RowNumber := 1 to TableRec.RowCount do
    begin
      for FieldNumber := 1 to TableRec.FieldCount do
      begin
        FieldRec := ReadFieldStructure(TableNumber, FieldNumber);
        FieldValue := ReadTableStr(TableNumber, RowNumber, FieldNumber);

        ParameterRec.ID := ParameterID;
        ParameterRec.Name := FieldRec.Name;
        ParameterRec.Table := TableNumber;
        ParameterRec.Row := RowNumber;
        ParameterRec.Field := FieldNumber;
        ParameterRec.Size := FieldRec.Size;
        ParameterRec.FieldType := FieldRec.FieldType;
        ParameterRec.MinValue := FieldRec.MinValue;
        ParameterRec.MaxValue := FieldRec.MaxValue;
        ParameterRec.DefValue := FieldValue;
        Parameters.Add(ParameterRec);

        Text := Tnt_WideFormat('PARAMID_%d = %d; // %d,%d,%d %s, "%s"', [
          ParameterID, ParameterID, TableNumber, RowNumber, FieldNumber,
          FieldRec.Name, FieldValue]);

        OutputDebugString(PChar(Text));
        Inc(ParameterID);
      end;
    end;
    Inc(TableNumber);
  until ResultCode <> 0;
end;

procedure TFiscalPrinterDevice.SaveModels;
var
  Reader: TXmlModelReader;
begin
  Reader := TXmlModelReader.Create(FModels);
  try
    //ReadModelParameters;
    Reader.SetDefaults;
    Reader.Save(GetModelsFileName);
  finally
    Reader.Free;
  end;
end;

function TFiscalPrinterDevice.GetLine(const Text: WideString): WideString;
begin
  Result := GetLine(Text, MinLineWidth, GetPrintWidth);
end;

function TFiscalPrinterDevice.GetLine(const Text: WideString;
  MinLength, MaxLength: Integer): WideString;
begin
  Result := Copy(Text, 1, MaxLength);
  Result := Result + StringOfChar(#0, MinLength - Length(Result));
end;

function TFiscalPrinterDevice.GetText(const Text: WideString;
  MinLength: Integer): WideString;
begin
  Result := Text;
  if Parameters.ItemTextMode = ItemTextModeTrim then
  begin
    if not FCapFiscalStorage then
      Result := Copy(Result, 1, GetPrintWidth);
  end else
  begin
    Result := Copy(Result, 1, 200);
  end;
  if Length(Result) < MinLength then
    Result := Result + StringOfChar(#0, MinLength - Length(Result));
end;

function TFiscalPrinterDevice.GetPrintWidth: Integer;
begin
  Result := GetPrintWidth(Parameters.FontNumber);
end;

function TFiscalPrinterDevice.ValidFont(Font: Integer): Boolean;
begin
  Result := (Font >= 1) and (Font <= Length(FFontInfo));
end;

function TFiscalPrinterDevice.GetPrintWidth(Font: Integer): Integer;
begin
  Result := 0;
  if ValidFont(Font) then
  begin
    if FFontInfo[Font-1].CharWidth <> 0 then
      Result := FFontInfo[Font-1].PrintWidth div FFontInfo[Font-1].CharWidth;
  end;
  if Result = 0 then Result := 40;
end;

function TFiscalPrinterDevice.GetSysPassword: DWORD;
begin
  Result := FSysPassword;
end;

function TFiscalPrinterDevice.GetTaxPassword: DWORD;
begin
  Result := FTaxPassword;
end;

function TFiscalPrinterDevice.GetUsrPassword: DWORD;
begin
  Result := FUsrPassword;
end;

procedure TFiscalPrinterDevice.SetSysPassword(const Value: DWORD);
begin
  FSysPassword := Value;
end;

procedure TFiscalPrinterDevice.SetTaxPassword(const Value: DWORD);
begin
  FTaxPassword := Value;
end;

procedure TFiscalPrinterDevice.SetUsrPassword(const Value: DWORD);
begin
  FUsrPassword := Value;
end;

function TFiscalPrinterDevice.ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
var
  AField: TPrinterField;
begin
  AField := Fields.Find(Table, Field);
  if AField <> nil then
  begin
    Result := AField.Data;
  end else
  begin
    Check(ReadFieldInfo(Table, Field, Result));
    TPrinterField.Create(Fields, Result);
  end;
end;

function TFiscalPrinterDevice.ValidFieldValue(
  const FieldInfo: TPrinterFieldRec;
  const FieldValue: WideString): Boolean;
var
  I: Integer;
begin
  Result := True;
  if FieldInfo.FieldType = PRINTER_FIELD_TYPE_INT then
  begin
    I := StrToInt(FieldValue);
    Result := (I >= FieldInfo.MinValue)and(I <= FieldInfo.MaxValue);
  end;
end;


function TFiscalPrinterDevice.ReadTableStructure(Table: Byte;
  var R: TPrinterTableRec): Integer;
var
  ATable: TPrinterTable;
begin
  ATable := Tables.ItemByNumber(Table);
  if ATable <> nil then
  begin
    Result := 0;
    R := ATable.Data;
  end else
  begin
    Result := ReadTableInfo(Table, R);
    if Result = 0 then
      TPrinterTable.Create(Tables, R);
  end;
end;

class function TFiscalPrinterDevice.BaudRateToCode(BaudRate: Integer): Integer;
begin
  case BaudRate of
    CBR_2400    : Result := 0;
    CBR_4800    : Result := 1;
    CBR_9600    : Result := 2;
    CBR_19200   : Result := 3;
    CBR_38400   : Result := 4;
    CBR_57600   : Result := 5;
    CBR_115200  : Result := 6;
  else
    Result := 1;
  end;
end;

class function TFiscalPrinterDevice.CodeToBaudRate(BaudRate: Integer): Integer;
begin
  case BaudRate of
    0: Result := CBR_2400;
    1: Result := CBR_4800;
    2: Result := CBR_9600;
    3: Result := CBR_19200;
    4: Result := CBR_38400;
    5: Result := CBR_57600;
    6: Result := CBR_115200;
  else
    Result := CBR_4800;
  end;
end;

class function TFiscalPrinterDevice.ByteToTimeout(Value: Byte): DWORD;
begin
  case Value of
    0..150   : Result := Value;
    151..249 : Result := (Value-149)*150;
  else
    Result := (Value-248)*15000;
  end;
end;

class function TFiscalPrinterDevice.TimeoutToByte(Value: Integer): Byte;
begin
  case Value of
    0..150        : Result := Value;
    151..15000    : Result := Round(Value/150) + 149;
    15001..105000 : Result := Round(Value/15000) + 248;
  else
    Result := Value;
  end;
end;

procedure TFiscalPrinterDevice.SetIsOnline(Value: Boolean);
begin
  if Value <> IsOnline then
  begin
    FIsOnline := Value;
    if Value then
    begin
      if Assigned(FOnConnect) then FOnConnect(Self); { !!! }
    end else
    begin
      if Assigned(FOnDisconnect) then FOnDisconnect(Self); { !!! }
    end;
  end;
end;

function CanRepeatCommand(Code: Integer): Boolean;
begin
  Result := False;
  case Code of
    $01, // Get dump
    $02, // Get data block from dump
    $03, // Interrupt data stream
    $0F, // Get long serial number and long ECRRN
    $10, // Get short ECR status
    $11, // Get ECR status
    $12, // Print bold AnsiString
    $13, // Beep
    $14, // Set communication parameters
    $15, // Read communication parameters
    $16, // Technological reset
    $17, // Print AnsiString
    $18, // Print document header
    $19, // Test run
    $1A, // Get cash totalizer value
    $1B, // Get operation totalizer value
    $1C, // Write license
    $1D, // Read license
    $1E, // Write table
    $1F, // Read table
    $20, // Set decimal point position
    $21, // Set clock time
    $22, // Set calendar date
    $23, // Confirm date
    $24, // Initialize tables with default values
    $25, // Cut receipt
    $26, // Get font parameters
    $27, // Common clear
    $28, // Open cash drawer
    $29, // Feed
    $2A, // Eject slip
    $2B, // Interrupt test
    $2C, // Print operation totalizers report
    $2D, // Get table structure
    $2E, // Get field structure
    $2F, // Print AnsiString with font
    $40, // Daily report without cleaning
    $41, // Daily report with cleaning
    $42, // Print Department report
    $43, // Print tax report
    $4D, // Print graphics 512
    $4E, // Load graphics 512
    $4F, // Print scaled graphics
    $52, // Print fixed document header
    $53, // Print document footer
    $54, // Print trailer
    $60, // Set serial number
    $61, // Initialize FM
    $62, // Get FM totals
    $63, // Get last FM record date
    $64, // Get dates and sessions range
    $66, // Fiscal report in dates range
    $67, // Fiscal report in days range
    $68, // Interrupt full report
    $69, // Get fiscalization parameters
    $70, // Open fiscal slip
    $71, // Open standard fiscal slip
    $72, // Transaction on slip
    $73, // Standard transaction on slip
    $74, // Discount/charge on slip
    $75, // Standard discount/charge on slip
    $78, // Slip configuration
    $79, // Standard slip configuration
    $7A, // Fill slip buffer with nonfiscal information
    $7B, // Clear slip buffer AnsiString
    $7C, // Clear slip buffer
    $7D, // Print slip
    $7E, // Common slip configuration
    $89, // Receipt subtotal
    $8C, // Print last receipt duplicate
    $8D, // Open receipt
    $A0, // EJ department report in dates range
    $A1, // EJ department report in days range
    $A2, // EJ day report in dates range
    $A3, // EJ day report in days range
    $A4, // Print day totals by EJ day number
    $A5, // Print pay document from EJ by KPK number
    $A6, // Print EJ journal by day number
    $A7, // Interrupt full EJ report
    $A8, // Print EJ activization result
    $A9, // EJ activization
    $AA, // Close EJ archive
    $AB, // Get EJ serial number
    $AC, // Interrupt EJ
    $AD, // Get EJ status by code 1
    $AE, // Get EJ status by code 2
    $AF, // Test EJ integrity
    $B0, // Continue printing
    $B1, // Get EJ version
    $B2, // Initialize EJ
    $B3, // Get EJ report data
    $B4, // Get EJ journal
    $B5, // Get EJ document
    $B6, // Get department EJ report in dates range
    $B7, // Get EJ department report in days range
    $B8, // Get EJ day report in dates range
    $B9, // Get EJ day report in days range
    $BA, // Get EJ day totals by day number
    $BB, // Get EJ activization result
    $BC, // Get EJ error
    $C0, // Load graphics
    $C1, // Print graphics
    $C2, // Print barcode
    $C3, // Print exteneded graphics
    $C4, // Load extended graphics
    $C5, // Print line
    $C8, // Get line count in printing buffer
    $C9, // Get line from printing buffer
    $CA, // Clear printing buffer
    $D0, // Get ECR IBM status
    $D1, // Get short ECR IBM status
    $DE, // Print barcode 2D
    $F0, // Change shutter position
    $F1, // Discharge receipt from presenter
    $F3, // Set service center password
    $FC, // Get device type
    $FD, // Send commands to external device port
    $E4, // Print attribute
    $FF01, // FS: Read status
    $FF02, // FS: Read number
    $FF03, // FS: Read expiration time
    $FF04, // FS: Read version
    $FF05, // FS: Start activation
    $FF06, // FS: Do activation
    $FF07, // FS: Clear status
    $FF08, // FS: Void document
    $FF09, // FS: Read activation result
    $FF0A, // FS: Find document by number
    $FF0B, // FS: Open day
    $FF0C, // FS: Send TLV data
    $FF0D, // FS: Registration with discount/charge
    $FF0E, // FS: Read open parameter
    $FF30, // FS: Read data in buffer
    $FF31, // FS: Read data block from buffer
    $FF32, // FS: Start write buffer
    $FF33, // FS: Write data block in buffer
    $FF34, // FS: Create fiscalization report
    $FF35, // FS: Start correction receipt
    $FF36, // FS: Create correction receipt
    $FF37, // FS: Start report on Calc
    $FF38, // FS: Create report on Calc
    $FF39, // FS: Read data transfer status
    $FF3A, // FS: Read fiscal document in TLV format
    $FF3B, // FS: Read fiscal document TLV
    $FF3C, // FS: Read server ticket on document number
    $FF3D, // FS: Start close fiscal mode
    $FF3E, // FS: Close fiscal mode
    $FF3F, // FS: Read fiscal documents count without server ticket
    $FF40, // FS: Read fiscal day parameters
    $FF41, // FS: Start opening fiscal day
    $FF42, // FS: Start closing fiscal day
    $FF43, // FS: Close day
    $FF44: // FS: Registration with discount/charge 2
      Result := True;
  end;
end;

function TFiscalPrinterDevice.SendCommand(var Command: TCommandRec): Integer;
var
  i: Integer;
  Index: Integer;
  CommandCode: Integer;
begin
  i := 0;
  while (Parameters.MaxRetryCount = MaxRetryCountInfinite)or(i < Parameters.MaxRetryCount) do
  begin
    try
      Logger.Debug(Format('0x%.2X, %s', [Command.Code, GetCommandName(Command.Code)]));
      if (i <> 0) then
      begin
        Logger.Debug(Format('Retry %d...', [i]));
      end;

      Command.RxData := Connection.Send(Command.Timeout, Command.TxData);
      SetIsOnline(True);
      Break;
    except
      on E: Exception do
      begin
        Logger.Error(E.Message);

        SetIsOnline(False);
        if not CanRepeatCommand(Command.Code) then Break;
        if (i = (Parameters.MaxRetryCount-1)) then
          raise ECommunicationError.Create(_('��� �����'));
      end;
    end;
    if Parameters.MaxRetryCount > 0 then
    begin
      Inc(i);
    end;
  end;

  if Length(Command.RxData) < 1 then
    raise ECommunicationError.Create(_('Invalid answer length'));

  CommandCode := Ord(Command.RxData[1]);

  Index := 2;
  if CommandCode = $FF then
  begin
    Index := 3;
    CommandCode := $FF00 + Ord(Command.RxData[2]);
    if CommandCode <> Command.Code then
      Result := Ord(Command.RxData[2])
    else
      Result := Ord(Command.RxData[3]);
  end else
  begin
    if CommandCode <> Command.Code then
      raise ECommunicationError.Create(_('Invalid answer code'));
    Result := Ord(Command.RxData[2]);
  end;

  FResultCode := Result;
  FResultText := GetErrorText(Result);
  Command.ResultCode := Result;
  Command.RxData := Copy(Command.RxData, Index + 1, Length(Command.RxData));
  if FResultCode <> 0 then
  begin
    Logger.Error(GetFullErrorText(FResultCode, FCapFiscalStorage));
  end;
end;

function TFiscalPrinterDevice.GetErrorText(Code: Integer): WideString;
begin
  Result := PrinterTypes.GetErrorText(Code, FCapFiscalStorage);
end;

function TFiscalPrinterDevice.ExecuteCommand(var Command: TCommandRec): Integer;
begin
  Lock;
  try
    repeat
      Command.RepeatFlag := False;
      if Assigned(FBeforeCommand) then
        FBeforeCommand(Self, Command);

      if Command.Code = $8D then
      begin
        CheckPrinterStatus;
      end;
      if Command.Code = $0E then
      begin
        CheckPrinterStatus;
        CorrectDate;
      end;

      SendCommand(Command);

      if Assigned(FOnCommand) then
        FOnCommand(Self, Command);

      Result := Command.ResultCode;

      if not Command.RepeatFlag then Break;
    until false;
  finally
    Unlock;
  end;
end;

function TFiscalPrinterDevice.ExecuteData(const TxData: AnsiString): Integer;
var
  RxData: AnsiString;
begin
  Result := ExecuteData(TxData, RxData);
end;

function TFiscalPrinterDevice.ExecuteData(const TxData: AnsiString;
  var RxData: AnsiString): Integer;

function GetCommandCode(const TxData: AnsiString): Integer;
begin
  Result := 0;
  if Length(TxData) > 0 then
    Result := Ord(TxData[1]);
  if Result = $FF then
    Result := (Result shl 8) + Ord(TxData[2]);
end;

var
  Command: TCommandRec;
begin
  Command.Code := GetCommandCode(TxData);
  Command.Timeout := GetCommandTimeout(Command.Code);
  Command.TxData := TxData;
  Result := ExecuteCommand(Command);
  RxData := Command.RxData;
end;

function TFiscalPrinterDevice.ExecuteStream(Stream: TBinStream): Integer;
var
  RxData: AnsiString;
  TxData: AnsiString;
begin
  RxData := '';
  TxData := Stream.Data;
  Result := ExecuteData(TxData, RxData);
  Stream.Data := RxData;
end;

function TFiscalPrinterDevice.ExecuteStream2(Stream: TBinStream): Integer;
var
  RxData: AnsiString;
  TxData: AnsiString;
begin
  RxData := '';
  TxData := Stream.Data;
  Result := ExecuteData(TxData, RxData);
  Stream.Data := Chr(Result) + RxData;
end;

function TFiscalPrinterDevice.ExecutePrinterCommand(Command: TPrinterCommand): Integer;
var
  RxData: AnsiString;
  TxData: AnsiString;
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Command.Encode(Stream);
    TxData := Chr(Command.GetCode) + Stream.Data;
    Result := ExecuteData(TxData, RxData);
    Stream.Data := RxData;
    Command.ResultCode := Result;
    if Command.ResultCode = 0 then
      Command.Decode(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TFiscalPrinterDevice.CashIn(Amount: Int64);
var
  Command: TCashInCommand;
begin
  FLogger.Debug(Format('CashIn(%d)', [Amount]));

  FFilter.BeforeCashIn;
  Command := TCashInCommand.Create;
  try
    Command.Password := GetUsrPassword;
    Command.Amount := Amount;
    Check(ExecutePrinterCommand(Command));

    FFilter.CashIn(Amount);
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterDevice.CashOut(Amount: Int64);
var
  Command: TCashOutCommand;
begin
  FLogger.Debug(Format('CashOut(%d)', [Amount]));

  FFilter.BeforeCashOut;
  Command := TCashOutCommand.Create;
  try
    Command.Password := GetUsrPassword;
    Command.Amount := Amount;
    Check(ExecutePrinterCommand(Command));
    FFilter.CashOut(Amount);
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterDevice.StartDump(DeviceCode: Integer): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('StartDump(%d)', [DeviceCode]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_START_DUMP);
    Stream.WriteDWORD(GetTaxPassword);
    Stream.WriteByte(DeviceCode);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.GetDumpBlock: TDumpBlock;
var
  Command: TGetDumpBlockCommand;
begin
  Command := TGetDumpBlockCommand.Create;
  try
    Command.Password := GetTaxPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.DumpBlock;
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterDevice.StopDump;
var
  Command: TStopDumpCommand;
begin
  Command := TStopDumpCommand.Create;
  try
    Command.Password := GetTaxPassword;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterDevice.LongFisc(NewPassword: DWORD;
  PrinterID, FiscalID: Int64): TLongFiscResult;
var
  Command: TLongFiscalizationCommand;
begin
  FLogger.Debug(Format('LongFisc(%d,%d,%d)',
    [NewPassword, PrinterID, FiscalID]));

  Command := TLongFiscalizationCommand.Create;
  try
    Command.TaxPassword := GetTaxPassword;
    Command.NewPassword := NewPassword;
    Command.PrinterID := PrinterID;
    Command.FiscalID := FiscalID;
    Check(ExecutePrinterCommand(Command));
    Result := Command.FiscResult;
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterDevice.SetLongSerial(Serial: Int64);
var
  Command: TSetLongSerialCommand;
begin
  FLogger.Debug(Format('SetLongSerial(%d)', [Serial]));

  Command := TSetLongSerialCommand.Create;
  try
    Command.Password := 0;
    Command.Serial := Serial;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get Long Serial Number And Long ECRRN

  Command:	0FH. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		0FH. Length: 16 bytes.
  �	Result Code (1 byte)
  �	Long Serial Number (7 bytes) 00000000000000�99999999999999
  �	Long ECRRN (7 bytes) 00000000000000�99999999999999

******************************************************************************)

function TFiscalPrinterDevice.GetLongSerial: TGetLongSerial;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_LONG_SERIAL);
    Stream.WriteDWORD(GetUsrPassword);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Short FP Status

  Command:	10H. Length: 5 bytes.
  �	Operator password (4 bytes)

  Answer:		10H. Length: 16 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	FP flags (2 bytes)
  �	FP mode (1 byte)
  �	FP submode (1 byte)
  �	Quantity of operations on the current receipt (1 byte) lower byte of a two-byte digit (see below)
  �	Battery voltage (1 byte)
  �	Power source voltage (1 byte)
  �	Fiscal Memory error code (1 byte)
  �	EKLZ error code (1 byte) EKLZ=Electronic Cryptographic Journal
  �	Quantity of operations on the current receipt (1 byte) upper byte of a two-byte digit (see below)
  �	Reserved (3 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadOperatorNumber(Password: Integer): Integer;
begin
  Result := ReadShortStatus2(Password).OperatorNumber;
end;

function TFiscalPrinterDevice.ReadUsrOperatorNumber: Integer;
begin
  Result := ReadShortStatus2(GetUsrPassword).OperatorNumber;
end;

function TFiscalPrinterDevice.ReadSysOperatorNumber: Integer;
begin
  Result := ReadShortStatus2(GetSysPassword).OperatorNumber;
end;

function TFiscalPrinterDevice.ReadShortStatus2(Password: Integer): TShortPrinterStatus;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_SHORT_STATUS);
    Stream.WriteDWORD(Password);
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
    FShortStatus := Result;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.ReadShortStatus: TShortPrinterStatus;
var
  Stream: TBinStream;
  Status: TPrinterStatus;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_SHORT_STATUS);
    Stream.WriteDWORD(GetUsrPassword);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));

    FShortStatus := Result;
    Status.Mode := Result.Mode;
    Status.AdvancedMode := Result.AdvancedMode;
    Status.OperatorNumber := Result.OperatorNumber;
    Status.Flags := DecodePrinterFlags(Result.Flags);
    SetPrinterStatus(Status);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get FP Status
  Command:	11H. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		11H. Length: 48 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	FP firmware version (2 bytes)
  �	FP firmware build (2 bytes)
  �	FP firmware date (3 bytes) DD-MM-YY
  �	Number of FP in checkout line (1 byte)
  �	Current receipt number (2 bytes)
  �	FP flags (2 bytes)
  �	FP mode (1 byte)
  �	FP submode (1 byte)
  �	FP port (1 byte)
  �	FM firmware version (2 bytes)
  �	FM firmware build (2 bytes)
  �	FM firmware date (3 bytes) DD-MM-YY
  �	Current date (3 bytes) DD-MM-YY
  �	Current time (3 bytes) HH-MM-SS
  �	FM flags (1 byte)
  �	Serial number (4 bytes)
  �	Number of last daily totals record in FM (2 bytes) 0000�2100
  �	Quantity of free daily totals records left in FM (2 bytes)
  �	Last fiscalization/refiscalization record number in FM (1 byte) 1�16
  �	Quantity of free fiscalization/refiscalization records left in FM (1 byte) 0�15
  �	Taxpayer ID (6 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadLongStatus: TLongPrinterStatus;
var
  Status: TPrinterStatus;
  Command: TLongStatusCommand;
begin
  Command := TLongStatusCommand.Create;
  try
    Command.Password := GetUsrPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.Status;

    FLongStatus := Command.Status;
    Status.Mode := FLongStatus.Mode;
    Status.AdvancedMode := FLongStatus.AdvancedMode;
    Status.OperatorNumber := FLongStatus.OperatorNumber;
    Status.Flags := DecodePrinterFlags(FLongStatus.Flags);
    SetPrinterStatus(Status);
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterDevice.GetFMFlags(Flags: Byte): TFMFlags;
begin
  Result.FM1Present := TestBit(Flags, 0);
  Result.FM2Present := TestBit(Flags, 1);
  Result.LicenseEntered := TestBit(Flags, 2);
  Result.Overflow := TestBit(Flags, 3);
  Result.LowBattery := TestBit(Flags, 4);
  Result.LastRecordCorrupted := TestBit(Flags, 5);
  Result.DayOpened := TestBit(Flags, 6);
  Result.Is24HoursLeft := TestBit(Flags, 7);
end;

(******************************************************************************

  Print String In Bold Type

  Command:	12H. Length: 26 bytes.
  �	Operator password (4 bytes)
  �	Flags (1 byte) Bit 0 - print on journal station, Bit 1 - print on receipt
    station.
  �	String of characters (20 bytes)
  Answer:		12H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.PrintBoldString(Flags: Byte; const Text: WideString): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('PrintBoldString(%d,''%s'')',
    [Flags, Text]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_PRINT_BOLD_LINE);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Flags);
    Stream.WriteString(GetLine(Text, 20, GetPrintWidth(2)));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Beep
  
  Command:	13H. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		13H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.Beep: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_BEEP);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Set Communication Parameters
  
  Command:	14H. Length: 8 bytes.
  �	System Administrator password (4 bytes) 30
  �	Port number (1 byte) 0�255
  �	Baud rate (1 byte) 0�6
  �	Inter-character time out (1 byte) 0�255
  Answer:		14H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

function TFiscalPrinterDevice.SetPortParams(Port: Byte;
  const PortParams: TPortParams): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('SetPortParams(%d,%d,%d)',
    [Port, PortParams.BaudRate, PortParams.Timeout]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_SET_PORT_PARAMS);
    Stream.WriteDWORD(GetSysPassword);
    Stream.WriteByte(Port);
    Stream.WriteByte(BaudRateToCode(PortParams.BaudRate));
    Stream.WriteByte(TimeoutToByte(PortParams.Timeout));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Communication Parameters

  Command:	15H. Length: 6 bytes.
  �	System Administrator password (4 bytes) 30
  �	Port number (1 byte) 0�255
  Answer:		15H. Length: 4 bytes.
  �	Result Code (1 byte)
  �	Baud rate (1 byte) 0�6
  �	Inter-character time out (1 byte) 0�255

******************************************************************************)
                       
function TFiscalPrinterDevice.GetPortParams(Port: Byte): TPortParams;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('GetPortParams(%d)',  [Port]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_GET_PORT_PARAMS);
    Stream.WriteDWORD(GetSysPassword);
    Stream.WriteByte(Port);
    Check(ExecuteStream(Stream));
    Result.BaudRate := CodeToBaudRate(Stream.ReadByte);
    Result.Timeout := ByteToTimeout(Stream.ReadByte);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Reset FM

  Command:	16H. Length: 1 byte.
  Answer:		16H. Length: 2 bytes.
  �	Result Code (1 byte)


******************************************************************************)

procedure TFiscalPrinterDevice.ResetFiscalMemory;
begin
  Execute(Chr(SMFP_COMMAND_RESETFM));
end;

(******************************************************************************

  Print String

  Command:	17H. Length: 46 bytes.
  �	Operator password (4 bytes)
  �	Flags (1 byte) Bit 0 - print on journal station, Bit 1 - print on receipt station.
  �	String of characters to print (40 bytes)
  Answer:		17H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.GetPrintFlags(Flags: Integer): Integer;
begin
  Result := Flags;
  if FCapFooterFlag and FFooterFlag then
  begin
    Result := Result or PRINTER_FLAG_FOOTER;
  end;
end;

procedure TFiscalPrinterDevice.PrintString(Flags: Byte;
  const Line: WideString);
var
  Text: AnsiString;
begin
  FLogger.Debug(Format('PrintString(%d,''%s'')', [Flags, Line]));

  Text := Line;
  if Text = '' then Text := ' ';
  Text := Copy(Text, 1, GetPrintWidth);

  Flags := GetPrintFlags(Flags);
  Execute(#$17 + IntToBin(GetUsrPassword, 4) + Chr(Flags) +
    GetLine(Text, 40, GetPrintWidth(1)));
end;

(******************************************************************************

  ������� �����

�������: E0H. ����� ���������: 5����.
������ ��������� (4 �����)
�����: E0H. ����� ���������: 2 �����.
���������� ����� ��������� (1 ����) 1�30
����������: ������� ��������� ����� � �� � ��������� �� � ����� ���������
������.

******************************************************************************)

function TFiscalPrinterDevice.OpenFiscalDay: Boolean;
var
  Status: TPrinterStatus;
begin
  Result := False;
  if CapFiscalStorage then
  begin
    Status := WaitForPrinting;
    if not IsDayOpened(Status.Mode) then
    begin
      if FTLVItems.Count > 0 then
      begin
        Check(FSStartOpenDay);
        WriteTLVItems;
      end;

      OpenDay;
      WaitForPrinting;
      Result := True;
    end;
  end;
end;

procedure TFiscalPrinterDevice.OpenDay;
begin
  Execute(#$E0 + IntToBin(GetUsrPassword, 4));
  FFilter.OpenDay;
end;


(******************************************************************************

  Print Receipt Header

  Command:	18H. Length: 37 bytes.
  �	Operator password (4 bytes)
  �	Receipt title (30 bytes)
  �	Receipt number (2 bytes)
  Answer:		18H. Length: 5 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Current receipt number (2 bytes)

******************************************************************************)

procedure TFiscalPrinterDevice.PrintDocHeader(const DocName: WideString; DocNumber: Word);
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('PrintDocHeader(''%s'', %d)',
    [DocName, DocNumber]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_PRINT_DOC_HEADER);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteString(GetLine(DocName, 30, 30));
    Stream.WriteInt(DocNumber, 2);

    Check(ExecuteStream(Stream));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Start Test

  Command:	19H. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Test time out (1 byte) 1�99
  Answer:		19H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.StartTest(Interval: Byte);
begin
  FLogger.Debug(Format('StartTest(%d)', [Interval]));

  Execute(#$19 + IntToBin(GetUsrPassword, 4) + Chr(Interval));
end;

(******************************************************************************

  Get Cash Totalizer Value

  Command:	1AH. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Cash totalizer number (1 byte) 0�255
  Answer:		1AH. Length: 9 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Cash totalizer value (6 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadCashReg(ID: Integer; var R: TCashRegisterRec): Integer;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('ReadCashRegister(%d)', [ID]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(SMFP_COMMAND_READ_CASH_TOTALIZER);
    Stream.WriteDWORD(GetUsrPassword);
    if (ID <= $FF) then
      Stream.WriteByte(ID)
    else
      Stream.WriteWord(ID);
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      R.Operator := Stream.ReadByte; // Operator number
      R.Value := Stream.ReadInt(6); // Register value
    end;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.ReadCashReg2(RegID: Integer): Int64;

  function ReadDayTotals(RecType: Integer): Int64;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to 15 do
    begin
      Result := Result + ReadCashRegister(121 + RecType + i*4);
    end;
  end;

var
  T: TFMTotals;
begin
  case RegID of
    SMFPTR_CASHREG_GRAND_TOTAL:
    begin
      T := ReadFPTotals(0);
      Result := T.SaleTotal - T.BuyTotal - T.RetSale + T.RetBuy;
    end;

    SMFPTR_CASHREG_LASTFISC_TOTAL:
    begin
      T := ReadFPTotals(1);
      Result := T.SaleTotal - T.BuyTotal - T.RetSale + T.RetBuy;
    end;

    SMFPTR_CASHREG_DAY_TOTAL_SALE:
      Result := ReadDayTotals(0);

    SMFPTR_CASHREG_DAY_TOTAL_RETSALE:
      Result := ReadDayTotals(2);

    SMFPTR_CASHREG_DAY_TOTAL_BUY:
      Result := ReadDayTotals(1);

    SMFPTR_CASHREG_DAY_TOTAL_RETBUY:
      Result := ReadDayTotals(3);

    SMFPTR_CASHREG_GRAND_TOTAL_SALE:
    begin
      T := ReadFPTotals(0);
      Result := T.SaleTotal;
    end;

    SMFPTR_CASHREG_GRAND_TOTAL_RETSALE:
    begin
      T := ReadFPTotals(0);
      Result := T.RetSale;
    end;

    SMFPTR_CASHREG_GRAND_TOTAL_BUY:
    begin
      T := ReadFPTotals(0);
      Result := T.BuyTotal;
    end;

    SMFPTR_CASHREG_GRAND_TOTAL_RETBUY:
    begin
      T := ReadFPTotals(0);
      Result := T.RetBuy;
    end;

    SMFPTR_CASHREG_CORRECTION_TOTAL_SALE:
    begin
      Check(FSReadCorrectionTotals(T));
      Result := T.SaleTotal;
    end;

    SMFPTR_CASHREG_CORRECTION_TOTAL_RETSALE:
    begin
      Check(FSReadCorrectionTotals(T));
      Result := T.RetSale;
    end;

    SMFPTR_CASHREG_CORRECTION_TOTAL_BUY:
    begin
      Check(FSReadCorrectionTotals(T));
      Result := T.BuyTotal;
    end;

    SMFPTR_CASHREG_CORRECTION_TOTAL_RETBUY:
    begin
      Check(FSReadCorrectionTotals(T));
      Result := T.RetBuy;
    end;
  else
    Result := ReadCashRegister(RegID);
  end;
end;

function TFiscalPrinterDevice.ReadCashRegister(ID: Integer): Int64;
var
  R: TCashRegisterRec;
begin
  Check(ReadCashReg(ID, R));
  Result := R.Value;
end;

(******************************************************************************

  Get Operation Totalizer Value

  Command:	1BH. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Operation totalizer number (1 byte) 0�255
  Answer:		1BH. Length: 5 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Operation totalizer value (2 bytes)

******************************************************************************)

function TFiscalPrinterDevice.ReadOperatingReg(ID: Byte;
  var R: TOperRegisterRec): Integer;
var
  Data: AnsiString;
  Command: AnsiString;
begin
  FLogger.Debug(Format('ReadOperatingRegister(%d)', [ID]));

  Command := #$1B + IntToBin(GetUsrPassword, 4) + Chr(ID);
  Result := ExecuteData(Command, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 3);
    R.Operator := Ord(Data[1]);
    R.Value := BinToInt(Data, 2, 2);
  end;
end;

function TFiscalPrinterDevice.ReadOperatingRegister(ID: Byte): Word;
var
  R: TOperRegisterRec;
begin
  Check(ReadOperatingReg(ID, R));
  Result := R.Value;
end;

(******************************************************************************

  Set License

  Command:	1CH. Length: 10 bytes.
  �	System Administrator password (4 bytes) 30
  �	License (5 bytes) 0000000000�9999999999
  Answer:		1CH. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.WriteLicense(License: Int64);
var
  Command: TWriteLicenseCommand;
begin
  FLogger.Debug(Format('WriteLicense(%d)', [License]));

  Command := TWriteLicenseCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Command.License := License;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get License

  Command:	1DH. Length: 5 bytes.
  �	System Administrator password (4 bytes) 30
  Answer:		1DH. Length: 7 bytes.
  �	Result Code (1 byte)
  �	License (5 bytes) 0000000000�9999999999

******************************************************************************)

function TFiscalPrinterDevice.ReadLicense: Int64;
var
  Command: TReadLicenseCommand;
begin
  Command := TReadLicenseCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.License;
  finally
    Command.Free;
  end;
end;

(******************************************************************************
******************************************************************************)

function TFiscalPrinterDevice.DoWriteTable(
  Table, Row, Field: Integer;
  const FieldValue: WideString): Integer;
var
  Command: TWriteTableCommand;
begin
  FLogger.Debug(Format('DoWriteTable(%d,%d,%d,%s)',
    [Table, Row, Field, StrToHexText(FieldValue)]));

  Command := TWriteTableCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Command.Table := Table;
    Command.Row := Row;
    Command.Field := Field;
    Command.FieldValue := FieldValue;
    Result := ExecutePrinterCommand(Command);
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get Table Field Value

  Command:	1FH. Length: 9 bytes.
  �	System Administrator password (4 bytes) 30
  �	Table (1 byte)
  �	Row (2 bytes)
  �	Field (1 byte)
  Answer:		1FH. Length: (2+X) bytes.
  �	Result Code (1 byte)
  �	Value (X bytes) up to 40 bytes

******************************************************************************)

function TFiscalPrinterDevice.ReadTableBin(Table, Row,
  Field: Integer): WideString;
var
  Command: TReadTableCommand;
begin
  FLogger.Debug(Format('ReadTableBin(%d,%d,%d)',
    [Table, Row, Field]));

  Command := TReadTableCommand.Create;
  try
    Command.SysPassword := GetSysPassword;
    Command.Table := Table;
    Command.Row := Row;
    Command.Field := Field;
    Check(ExecutePrinterCommand(Command));
    Result := Command.FieldValue;
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Set Decimal Dot Position
  
  Command:	20H. Length: 6 bytes.
  �	System Administrator password (4 bytes) 30
  �	Decimal dot position (1 byte) '0' - 0 digits after the dot, '1' - 2 digits after the dot
  Answer:		20H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.SetPointPosition(PointPosition: Byte);
begin
  FLogger.Debug(Format('SetPointPosition(%d)',
    [PointPosition]));

  Execute(#$20 + IntToBin(GetSysPassword, 4) + Chr(PointPosition));
end;

(******************************************************************************

  Set Clock Time

  Command:	21H. Length: 8 bytes.
  �	System Administrator password (4 bytes) 30
  �	Time (3 bytes) HH-MM-SS
  Answer:		21H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.SetTime(const Time: TPrinterTime);
begin
  FLogger.Debug(Format('SetTime(%s)',
    [PrinterTimeToStr(Time)]));

  Execute(#$21 + IntToBin(GetSysPassword, 4) +
    Chr(Time.Hour) + Chr(Time.Min) + Chr(Time.Sec));
end;

(******************************************************************************

  Set Calendar Date

  Command:	22H. Length: 8 bytes.
  �	System Administrator password (4 bytes) 30
  �	Date (3 bytes) DD-MM-YY
  Answer:		22H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.WriteDate(const Date: TPrinterDate);
begin
  FLogger.Debug(Format('WriteDate(%s)',
    [PrinterDateToStr(Date)]));

  Execute(#$22 + IntToBin(GetSysPassword, 4) +
    Chr(Date.Day) + Chr(Date.Month) + Chr(Date.Year));
end;

(******************************************************************************

  Confirm Date

  Command:	23H. Length: 8 bytes.
  �	System Administrator password (4 bytes) 30
  �	Date (3 bytes) DD-MM-YY
  Answer:		23H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.ConfirmDate(const Date: TPrinterDate);
begin
  FLogger.Debug(Format('ConfirmDate(%.2d.%.2d.%.4d)',
    [Date.Day, Date.Month, Date.Year + 2000]));

  Execute(#$23 + IntToBin(GetSysPassword, 4) +
    Chr(Date.Day) + Chr(Date.Month) + Chr(Date.Year));
end;

(******************************************************************************

  Set Table With Default Values

  Command:	24H. Length: 5 bytes.
  �	System Administrator password (4 bytes) 30
  Answer:		24H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.InitializeTables;
begin
  Execute(#$24 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Cut
  
  Command:	25H. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Cut type (1 byte) '0' - complete, '1' - incomplete
  Answer:		25H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.CutPaper(CutType: Byte);
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  if not FParameters2.Flags.CapCutter then Exit;
  FLogger.Debug(Format('CutPaper(%d)', [CutType]));

  Command := #$25 + IntToBin(GetUsrPassword, 4) + Chr(CutType);
  ExecuteData(Command, Answer);
end;

procedure TFiscalPrinterDevice.FullCut;
begin
  CutPaper(PRINTER_CUTTYPE_FULL);
end;

procedure TFiscalPrinterDevice.PartialCut;
begin
  CutPaper(PRINTER_CUTTYPE_PARTIAL);
end;

(******************************************************************************

  Get Font Parameters
  
  Command:	26H. Length: 6 bytes.
  �	System Administrator password (4 bytes) 30
  �	Font type (1 byte)
  Answer:		26H. Length: 7 bytes.
  �	Result Code (1 byte)
  �	Print width in dots (2 bytes)
  �	Character width in dots (1 byte) the width is given together with inter-character spacing
  �	Character height in dots (1 byte) the height is given together with inter-line spacing
  �	Number of fonts in FP (1 byte)

******************************************************************************)

function TFiscalPrinterDevice.ReadFontInfo(FontNumber: Byte): TFontInfo;
var
  Data: AnsiString;
begin
  FLogger.Debug(Format('ReadFontInfo(%d)', [FontNumber]));
  Data := Execute(#$26 + IntToBin(GetSysPassword, 4) + Chr(FontNumber));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Clear All Totalizers

  Command:	27H. Length: 5 bytes.
  �	System Administrator password (4 bytes) 30
  Answer:		27H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.ResetTotalizers;
begin
  Execute(#$27 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Open Cash Drawer
  
  Command:	28H. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Cash drawer number (1 byte) 0, 1
  Answer:		28H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.OpenDrawer(DrawerNumber: Byte);
begin
  FLogger.Debug(Format('OpenDrawer(%d)', [DrawerNumber]));
  Execute(#$28 + IntToBin(GetUsrPassword, 4) + Chr(DrawerNumber));
end;

(******************************************************************************

  Feed

  Command:	29H. Length: 7 bytes.
  �	Operator password (4 bytes)
  �	Flags (1 byte) Bit 0 - journal station, Bit 1 - receipt station, Bit 2 - slip station
  �	Number of lines to feed (1 byte) 1�255 - the maximum number of lines to feed is limited by the size of print buffer, but does not exceed 255
  Answer:		29H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.FeedPaper(Station: Byte; Lines: Byte);
begin
  FLogger.Debug(Format('FeedPaper(%d,%d)',
    [Station, Lines]));

  Execute(#$29 + IntToBin(GetUsrPassword, 4) + Chr(Station) + Chr(Lines));
end;

(******************************************************************************

  Eject Slip
  
  Command:	2AH. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Slip paper eject direction (1 byte) '0' - down, '1' - up
  Answer:		2AH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.EjectSlip(Direction: Byte);
begin
  FLogger.Debug(Format('EjectSlip(%d)',
    [Direction]));

  Execute(#$2A + IntToBin(GetUsrPassword, 4) + Chr(Direction));
end;

(******************************************************************************

  Interrupt Test

  Command:	2BH. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		2BH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.StopTest;
begin
  Execute(#$2B + IntToBin(GetUsrPassword, 4));
end;

(******************************************************************************

  Print Operation Totalizers Report

  Command:	2CH. Length: 5 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		2CH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintActnTotalizers;
begin
  Execute(#$2C + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Get Table Structure

  Command:	2DH. Length: 6 bytes.
  �	System Administrator password (4 bytes) 30
  �	Table number (1 byte)
  Answer:		2DH. Length: 45 bytes.
  �	Result Code (1 byte)
  �	Table name (40 bytes)
  �	Number of rows (2 bytes)
  �	Number of fields (1 byte)

******************************************************************************)

function TFiscalPrinterDevice.ReadTableInfo(Table: Byte;
  var R: TPrinterTableRec): Integer;
var
  Data: AnsiString;
  Command: AnsiString;
begin
  FLogger.Debug(Format('ReadTableInfo(%d)', [Table]));
  Command := #$2D + IntToBin(GetSysPassword, 4) + Chr(Table);
  Result := ExecuteData(Command, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 43);
    R.Number := Table;
    R.Name := Copy(Data, 1, 40);
    R.RowCount := BinToInt(Data, 41, 2);
    R.FieldCount := BinToInt(Data, 43, 1);
  end;
end;

(******************************************************************************

  Get Field Structure

  Command:	2EH. Length: 7 bytes.
  �	System Administrator password (4 bytes) 30
  �	Table number (1 byte)
  �	Field number (1 byte)
  Answer:		2EH. Length: (44+X+X) bytes.
  �	Result Code (1 byte)
  �	Field name (40 bytes)
  �	Field type (1 byte) '0' - BIN, '1' - CHAR
  �	Number of bytes - X (1 byte)
  �	Field minimum value (X bytes) for BIN-type fields only
  �	Field maximum value (X bytes) for BIN-type fields only


******************************************************************************)

function TFiscalPrinterDevice.ReadFieldInfo(Table, Field: Byte;
  var R: TPrinterFieldRec): Integer;
var
  Data: AnsiString;
  Command: AnsiString;
begin
  FLogger.Debug(Format('ReadFieldInfo(%d,%d)', [Table, Field]));
  Command := #$2E + IntToBin(GetSysPassword, 4) + Chr(Table) + Chr(Field);
  Result := ExecuteData(Command, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 42);
    R.Table := Table;
    R.Field := Field;
    R.Name := TrimRight(Copy(Data, 1, 40));
    R.FieldType := Ord(Data[41]);
    R.Size := Ord(Data[42]);
    if (R.FieldType = 0)and(Length(Data) >= (42 + R.Size*2)) then
    begin
      R.MinValue := 0;
      Move(Data[43], R.MinValue, R.Size);
      R.MaxValue := 0;
      Move(Data[43 + R.Size], R.MaxValue, R.Size);
    end;
  end;
end;

(******************************************************************************

  Print String With Specific Font

  Command:	2FH. Length: 47 bytes.
  �	Operator password (4 bytes)
  �	Flags (1 byte) Bit 0 - print on journal station, Bit 1 - print on receipt station
  �	Font number (1 byte) 0�255
  �	String of characters to print (40 bytes)
  Answer:		2FH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintStringFont(Flags, Font: Byte;
  const Line: WideString);
var
  Text: AnsiString;
begin
  Text := Line;
  Flags := GetPrintFlags(Flags);

  if Text = '' then Text := ' ';
  FLogger.Debug(Format('PrintStringFont(%d,%d, ''%s'')',
    [Flags, Font, Text]));

  Execute(#$2F + IntToBin(GetUsrPassword, 4) + Chr(Flags) + Chr(Font) +
    GetLine(Text, 40, GetPrintWidth(Font)));
end;

(******************************************************************************

  Print X-Report

  Command:	40H. Length: 5 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		40H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintXReport;
begin
  Execute(#$40 + IntToBin(GetSysPassword, 4));
  try
    PrintCommStatus;
  except
    on E: Exception do
    begin
      Logger.Debug('PrintXReport: ' + GetExceptionMessage(E));
    end;
  end;
end;

procedure TFiscalPrinterDevice.PrintLines(const Line1, Line2: WideString);
begin
  PrintStringFont(PRINTER_STATION_REC, Parameters.FontNumber,
    FormatLines(Line1, Line2));
end;

procedure TFiscalPrinterDevice.PrintCommStatus;
var
  i: Integer;
  R: TFSCommStatus;
begin
  if not CapFiscalStorage then Exit;

  WaitForPrinting;
  for i := 1 to 10 do
  begin
    if FSReadCommStatus(R) = 0 then
    begin
      PrintText(PRINTER_STATION_REC, StringOfChar('-', GetPrintWidth));
      PrintLines('���������� ��������� ��� ���:', IntToStr(R.DocumentCount));
      PrintLines('����� ������� ��������� ��� ���:', IntToStr(R.DocumentNumber));
      PrintLines('���� ������� ���������:', PrinterDateTimeToStr2(R.DocumentDate));
      Break;
    end;
    Sleep(1000)
  end;
end;

(******************************************************************************
������ �������� ����� FF42H

��� ������� FF42h. ����� ���������: 6 ����.
  ������ ���������� ��������������: 4 �����
�����: FF42h ����� ���������: 1 ����.
  ��� ������: 1 ����

******************************************************************************)

function TFiscalPrinterDevice.BeginZReport: Integer;
var
  Answer: string;
begin
  Result := ExecuteData(#$FF#$42 + IntToBin(GetSysPassword, 4), Answer);
end;

(******************************************************************************

  Print Z-Report

  Command:	41H. Length: 5 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		41H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintZReport;
var
  FSState: TFSState;
begin
  if CapFiscalStorage then
  begin
    if FTLVItems.Count > 0 then
    begin
      Check(BeginZReport);
      WriteTLVItems;
    end;
  end;

  Execute(#$41 + IntToBin(GetSysPassword, 4));
  FFilter.PrintZReport;
  try
    // Update document number
    if CapFiscalStorage then
    begin
      Check(FSReadState(FSState));
      Check(FSReadDocMac(FLastDocMac));
      FLastDocNumber := FSState.DocNumber;
    end;
    PrintCommStatus;
  except
    on E: Exception do
    begin
      Logger.Debug('PrintZReport: ' + GetExceptionMessage(E));
    end;
  end;
end;

(******************************************************************************

  Print Department Report
  
  Command:	42H. Length: 5 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		42H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintDepartmentsReport;
begin
  Execute(#$42 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Print Taxes Report
  
  Command:	43H. Length: 5 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		43H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintTaxReport;
begin
  Execute(#$43 + IntToBin(GetSysPassword, 4));
end;

(******************************************************************************

  Print Fixed Header
  
  Command:	52H. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		52H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintHeader;
begin
  Execute(#$52 + IntToBin(GetUsrPassword, 4));
end;

(******************************************************************************

  End document

  Command:	53H. Length: 6 bytes
  �	Operator password (4 bytes)
  �	Parameter (1 bytes)
  �	0 - Without trailer
  �	1 - With trailer
  Answer:		53H. Length: 3 bytes.
  �	Result code (1 bytes)
  �	Operator index number (1 bytes) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintDocTrailer(Flags: Byte);
begin
  FLogger.Debug(Format('PrintDocTrailer(%d)', [Flags]));
  Execute(#$53 + IntToBin(GetUsrPassword, 4) + Chr(Flags));
end;

(******************************************************************************

  Print trailer
  Command:	54H. Length:5 bytes.
  �	Operator password (4 bytes)
  Answer:		54H. Length: 3 bytes.
  �	Result code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.PrintTrailer;
begin
  Execute(#$54 + IntToBin(GetUsrPassword, 4));
end;

(******************************************************************************

  Set Serial Number

  Command:	60H. Length: 9 bytes.
  �	Password (4 bytes) (default value is '0')
  �	Serial number (4 bytes) 00000000�99999999
  Answer:		60H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.WriteSerial(Serial: DWORD);
begin
  FLogger.Debug(Format('WriteSerial(%d)', [Serial]));
  Execute(#$60 + IntToBin(0, 4) + IntToBin(Serial, 4));
end;

(******************************************************************************

  Initialize FM

  Command:	61H. Length: 1 byte.
  Answer:		61H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.InitFiscalMemory;
begin
  Execute(#$61);
end;

(******************************************************************************

  Get FM Totals

  Command:	62H. Length: 6 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  �	Report type (1 byte) '0' - grand totals, '1' - grand totals after the last
    refiscalization
  Answer:		62H. Length: 29 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30
  �	Grand totals of sales (8 bytes)
  �	Grand totals of buys (6 bytes) If there is no FM2, the value is
    FFh FFh FFh FFh FFh FFh
  �	Grand totals of sale refunds (6 bytes) If there is no FM2, the value is
    FFh FFh FFh FFh FFh FFh
  �	Grand totals of buy refunds (6 bytes) If there is no FM2, the value is
    FFh FFh FFh FFh FFh FFh

******************************************************************************)

function BinToInt2(const Data: AnsiString; Index, Size: Integer): Int64;
begin
  Result := 0;
  if Copy(Data, Index, Size) <> StringOfChar(#$FF, Size) then
    Result := BinToInt(Data, Index, Size);
end;

function TFiscalPrinterDevice.ReadFMTotals(Flags: Byte; var R: TFMTotals): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  FLogger.Debug(Format('ReadFMTotals(%d)', [Flags]));
  Command := #$62 + IntToBin(GetSysPassword, 4) + Chr(Flags);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 27);
    R.OperatorNumber := Ord(Answer[1]);
    R.SaleTotal := BinToInt2(Answer, 2, 8);
    R.BuyTotal := BinToInt2(Answer, 10, 6);
    R.RetSale := BinToInt2(Answer, 16, 6);
    R.RetBuy := BinToInt2(Answer, 22, 6);
  end;
end;

(******************************************************************************

  Get Date of Last Record In FM

  Command:	63H. Length: 5 bytes.
  �	Administrator or System Administrator password (4 bytes) 29, 30
  Answer:		63H. Length: 7 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 29, 30
  �	Type of last record in FM (1 byte) '0' - fiscalization/refiscalization,
    '1' - daily totals
  �	Date (3 bytes) DD-MM-YY


******************************************************************************)

function TFiscalPrinterDevice.ReadFMLastRecordDate: TFMRecordDate;
var
  Data: AnsiString;
begin
  Data := Execute(#$63 + IntToBin(GetTaxPassword, 4));
  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Get Dates And Days Ranges In FM

  Command:	64H. Length: 5 bytes.
  �	Tax Officer password (4 bytes)
  Answer:		64H. Length: 12 bytes.
  �	Result Code (1 byte)
  �	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  �	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  �	Number of first daily totals record in FM (2 bytes) 0000�2100
  �	Number of last daily totals record in FM (2 bytes) 0000�2100

******************************************************************************)

function TFiscalPrinterDevice.ReadDaysRange: TDayRange;
var
  Data: AnsiString;
begin
  Data := Execute(#$64 + IntToBin(GetTaxPassword, 4));
  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Fiscalize/Refiscalize Printer

  Command:	65H. Length: 20 bytes.
  �	Tax Officer old password (4 bytes)
  �	Tax Officer new password (4 bytes)
  �	ECRRN (5 bytes) 0000000000�9999999999
  �	Taxpayer ID (6 bytes) 000000000000�999999999999
  Answer:		65H. Length: 9 bytes.
  �	Result Code (1 byte)
  �	Fiscalization/Refiscalization number (1 byte) 1�16
  �	Quantity of free fiscalization/refiscalization records left in FM (1 byte) 0�15
  �	Number of last daily totals record in FM (2 bytes) 0000�2100
  �	Fiscalization/Refiscalization date (3 bytes) DD-MM-YY

******************************************************************************)

function TFiscalPrinterDevice.Fiscalization(Password, PrinterID,
  FiscalID: Int64): TFiscalizationResult;
var
  Data: AnsiString;
begin
  FLogger.Debug(Format('Fiscalization(%d,%d,%d)',
    [Password, PrinterID, FiscalID]));

  Data := Execute(#$65 +
    IntToBin(GetTaxPassword, 4) +
    IntToBin(Password, 4) +
    IntToBin(PrinterID, 4) +
    IntToBin(FiscalID, 4));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Periodic Daily Totals Fiscal Report

  Command:	66H. Length: 12 bytes.
  �	Tax Officer password (4 bytes)
  �	Report type (1 byte) '0' - short, '1' - full
  �	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  �	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  Answer:		66H. Length: 12 bytes.
  �	Result Code (1 byte)
  �	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  �	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  �	Number of first daily totals record in FM (2 bytes) 0000�2100
  �	Number of last daily totals record in FM (2 bytes) 0000�2100

******************************************************************************)

function TFiscalPrinterDevice.ReportOnDateRange(ReportType: Byte;
  Range: TDayDateRange): TDayRange;
var
  Data: AnsiString;
begin
  FLogger.Debug(Format('ReportOnDateRange(%d,%s,%s)',
    [ReportType, PrinterDateToStr(Range.Date1), PrinterDateToStr(Range.Date2)]));

  Data := Execute(#$66 +
    IntToBin(GetTaxPassword, 4) +
    Chr(ReportType) +
    PrinterDateToBin(Range.Date1) +
    PrinterDateToBin(Range.Date2));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Fiscal Report For Daily Totals Numbers Range

  Command:	67H. Length: 10 bytes.
  �	Tax Officer password (4 bytes)
  �	Report type (1 byte) '0' - short, '1' - full
  �	Day number of first daily totals record in FM (2 bytes) 0000�2100
  �	Day number of last daily totals record in FM (2 bytes) 0000�2100
  Answer:		67H. Length: 12 bytes.
  �	Result Code (1 byte)
  �	Date of first daily totals record in FM (3 bytes) DD-MM-YY
  �	Date of last daily totals record in FM (3 bytes) DD-MM-YY
  �	Number of first daily totals record in FM (2 bytes) 0000�2100
  �	Number of last daily totals record in FM (2 bytes) 0000�2100

******************************************************************************)

function TFiscalPrinterDevice.ReportOnNumberRange(ReportType: Byte;
  Range: TDayNumberRange): TDayRange;
var
  Data: AnsiString;
begin
  FLogger.Debug(Format('ReportOnDateRange(%d,%d,%d)',
    [ReportType, Range.Number1, Range.Number2]));

  Data := Execute(#$67 +
    IntToBin(GetTaxPassword, 4) +
    Chr(ReportType) +
    IntToBin(Range.Number1, 2) +
    IntToBin(Range.Number2, 2));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Interrupt Full Report

  Command:	68H. Length: 5 bytes.
  �	Tax Officer password (4 bytes)
  Answer:		68H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.InterruptReport;
begin
  Execute(#$68 + IntToBin(GetTaxPassword, 4));
end;

(******************************************************************************

  Get Fiscalization/Refiscalization Parameters

  Command:	69H. Length: 6 bytes.
  �	Tax Officer password (4 bytes) password of Tax Officer who fiscalized the printer
  �	Fiscalization/Refiscalization number (1 byte) 1�16
  Answer:		69H. Length: 22 bytes.
  �	Result Code (1 byte)
  �	Password (4 bytes)
  �	ECRRN (5 bytes) 0000000000�9999999999
  �	Taxpayer ID (6 bytes) 000000000000�999999999999
  �	Number of the last daily totals record in FM before fiscalization/refiscalization (2 bytes) 0000�2100
  �	Fiscalization/Refiscalization date (3 bytes) DD-MM-YY

******************************************************************************)

function TFiscalPrinterDevice.ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
var
  Stream: TBinStream;
begin
  FLogger.Debug(Format('ReadFiscInfo((%d)',
    [FiscNumber]));

  Stream := TBinStream.Create;
  try
    Stream.Data := Execute(#$69 + IntToBin(GetTaxPassword, 4) + Chr(FiscNumber));

    Result.Password := Stream.ReadInt(4);
    Result.PrinterID := Stream.ReadInt(5);
    Result.FiscalID := Stream.ReadInt(6);
    Result.DayNumber := Stream.ReadInt(2);
    Stream.Read(Result.Date, Sizeof(Result.Date));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Open Fiscal Slip

  Command:	70H. Length: 26 bytes.
  �	Operator password (4 bytes)
  �	Slip type (1 byte) '0' - Sale, '1' - Buy, '2' - Sale Refund, '3' - Buy Refund
  �	Slip duplicates type (1 byte) '0' - duplicates as columns, '1' - duplicates as line blocks
  �	Number of duplicates (1 byte) 0�5
  �	Spacing between Original and Duplicate 1 (1 byte) *
  �	Spacing between Duplicate 1 and Duplicate 2 (1 byte) *
  �	Spacing between Duplicate 2 and Duplicate 3 (1 byte) *
  �	Spacing between Duplicate 3 and Duplicate 4 (1 byte) *
  �	Spacing between Duplicate 4 and Duplicate 5 (1 byte) *
  �	Font number of fixed header (1 byte)
  �	Font number of header (1 byte)
  �	Font number of EKLZ serial number (1 byte)
  �	Font number of KPK value and KPK number (1 byte)
  �	Vertical position of the first line of fixed header (1 byte)
  �	Vertical position of the first line of header (1 byte)
  �	Vertical position of line with EKLZ number (1 byte)
  �	Vertical position of line with duplicate marker (1 byte)
  �	Horizontal position of fixed header in line (1 byte)
  �	Horizontal position of header in line (1 byte)
  �	Horizontal position of EKLZ number in line (1 byte)
  �	Horizontal position of KPK value and KPK number in line (1 byte)
  �	Horizontal position of duplicate marker in line (1 byte)
  Answer:		70H. Length: 5 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Current receipt number (2 bytes)

******************************************************************************)

function TFiscalPrinterDevice.OpenSlipDoc(Params: TSlipParams): TDocResult;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($70);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Open Standard Fiscal Slip

  Command:	71H. Length: 13 bytes.
  �	Operator password (4 bytes)
  �	Slip type (1 byte) '0' - Sale, '1' - Buy, '2' - Sale Refund, '3' - Buy Refund
  �	Slip duplicates type (1 byte) '0' - duplicates as columns, '1' - duplicates as line blocks
  �	Number of duplicates (1 byte) 0�5
  �	Spacing between Original and Duplicate 1 (1 byte) *
  �	Spacing between Duplicate 1 and Duplicate 2 (1 byte) *
  �	Spacing between Duplicate 2 and Duplicate 3 (1 byte) *
  �	Spacing between Duplicate 3 and Duplicate 4 (1 byte) *
  �	Spacing between Duplicate 4 and Duplicate 5 (1 byte) *
  Answer:		71H. Length: 5 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Current receipt number (2 bytes)

******************************************************************************)

function TFiscalPrinterDevice.OpenStdSlip(Params: TStdSlipParams): TDocResult;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($71);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Transaction On Slip

  Command:	72H. Length: 82 bytes.
  �	Operator password (4 bytes)
  �	Quantity format (1 byte) '0' - no digits after decimal dot, '1' - digits after decimal dot
  �	Number of lines in transaction block (1 byte) 1�3
  �	Line number of Text element in transaction block (1 byte) 0�3, '0' - do not print
  �	Line number of Quantity Times Unit Price element in transaction block (1 byte) 0�3, '0' - do not print
  �	Line number of Transaction Sum element in transaction block (1 byte) 1�3
  �	Line number of Department element in transaction block (1 byte) 1�3
  �	Font type of Text element (1 byte)
  �	Font type of Quantity element (1 byte)
  �	Font type of Multiplication sign element (1 byte)
  �	Font type of Unit Price element (1 byte)
  �	Font type of Transaction Sum element (1 byte)
  �	Font type of Department element (1 byte)
  �	Length of Text element in characters (1 byte)
  �	Length of Quantity element in characters (1 byte)
  �	Length of Unit Price element in characters (1 byte)
  �	Length of Transaction Sum element in characters (1 byte)
  �	Length of Department element in characters (1 byte)
  �	Position in line of Text element (1 byte)
  �	Position in line of Quantity Times Unit Price element (1 byte)
  �	Position in line of Transaction Sum element (1 byte)
  �	Position in line of Department element (1 byte)
  �	Slip line number with the first line of transaction block (1 byte)
  �	Quantity (5 bytes)
  �	Unit Price (5 bytes)
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		72H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.SlipOperation(Params: TSlipOperation;
  Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($72);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Standard Transaction On Slip
  
  Command:	73H. Length: 61 bytes.
  �	Operator password (4 bytes)
  �	Slip line number with the first line of transaction block (1 byte)
  �	Quantity (5 bytes)
  �	Unit Price (5 bytes)
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		73H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.SlipStdOperation(LineNumber: Byte;
  Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($73);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(LineNumber);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Discount/Surcharge On Slip
  
  Command:	74H. Length: 68 bytes.
  �	Operator password (4 bytes)
  �	Number of lines in transaction block (1 byte) 1�2
  �	Line number of Text element in transaction block (1 byte) 0�2, '0' - do not print
  �	Line number of Transaction Name element in transaction block (1 byte) 1�2
  �	Line number of Transaction Sum element in transaction block (1 byte) 1�2
  �	Font type of Text element (1 byte)
  �	Font type of Transaction Name element (1 byte)
  �	Font type of Transaction Sum element (1 byte)
  �	Length of Text element in characters (1 byte)
  �	Length of Transaction Sum element in characters (1 byte)
  �	Position in line of Text element (1 byte)
  �	Position in line of Transaction Name element (1 byte)
  �	Position in line of Transaction Sum element (1 byte)
  �	Transaction type (1 byte) '0' - Discount, '1' - Surcharge
  �	Slip line number with the first line of Discount/Surcharge block (1 byte)
  �	Transaction Sum (5 bytes)
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		74H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.SlipDiscount(Params: TSlipDiscountParams;
  Discount: TSlipDiscount): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($74);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(GetText(Discount.Text, 40));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Standard Discount/Surcharge On Slip

  Command:	75H. Length: 56 bytes.
  �	Operator password (4 bytes)
  �	Transaction type (1 byte) '0' - Discount, '1' - Surcharge
  �	Slip line number with the first line of Discount/Surcharge block (1 byte)
  �	Transaction Sum (5 bytes)
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		75H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.SlipStdDiscount(Discount: TSlipDiscount): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($75);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(GetText(Discount.Text, 40));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Close Fiscal Slip
  
  Command:	76H. Length: 182 bytes.
  �	Operator password (4 bytes)
  �	Number of lines in transaction block (1 byte) 1�17
  �	Line number of Receipt Total element in transaction block (1 byte) 1�17
  �	Line number of Text element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Cash Payment element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Payment Type 2 element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Payment Type 3 element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Payment Type 4 element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Change element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 1 Turnover element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 2 Turnover element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 3 Turnover element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 4 Turnover element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 1 Sum element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 2 Sum element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 3 Sum element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Tax 4 Sum element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Receipt Subtotal Before Discount/Surcharge element in transaction block (1 byte) 0�17, '0' - do not print
  �	Line number of Discount/Surcharge Value element in transaction block (1 byte) 0�17, '0' - do not print
  �	Font type of Text element (1 byte)
  �	Font type of 'TOTAL' element (1 byte)
  �	Font type of Receipt Total Value element (1 byte)
  �	Font type of 'CASH' element (1 byte)
  �	Font type of Cash Payment Value element (1 byte)
  �	Font type of Payment Type 2 Name element (1 byte)
  �	Font type of Payment Type 2 Value element (1 byte)
  �	Font type of Payment Type 3 Name element (1 byte)
  �	Font type of Payment Type 3 Value element (1 byte)
  �	Font type of Payment Type 4Name element (1 byte)
  �	Font type of Payment Type 4Value element (1 byte)
  �	Font type of 'CHANGE' element (1 byte)
  �	Font type of Change Value element (1 byte)
  �	Font type of Tax 1 Name element (1 byte)
  �	Font type of Tax 1 Turnover Value element (1 byte)
  �	Font type of Tax 1 Rate element (1 byte)
  �	Font type of Tax 1 Value element (1 byte)
  �	Font type of Tax 2 Name element (1 byte)
  �	Font type of Tax 2 Turnover Value element (1 byte)
  �	Font type of Tax 2 Rate element (1 byte)
  �	Font type of Tax 2 Value element (1 byte)
  �	Font type of Tax 3 Name element (1 byte)
  �	Font type of Tax 3 Turnover Value element (1 byte)
  �	Font type of Tax 3 Rate element (1 byte)
  �	Font type of Tax 3 Value element (1 byte)
  �	Font type of Tax 4 Name element (1 byte)
  �	Font type of Tax 4 Turnover Value element (1 byte)
  �	Font type of Tax 4 Rate element (1 byte)
  �	Font type of Tax 4 Value element (1 byte)
  �	Font type of 'SUBTOTAL' element (1 byte)
  �	Font type of Receipt Subtotal Before Discount/Surcharge Value element (1 byte)
  �	Font type of 'DISCOUNT XX.XX%' element (1 byte)
  �	Font type of Receipt Discount Value element (1 byte)
  �	Length of Text element in characters (1 byte)
  �	Length of Receipt Total Value element in characters (1 byte)
  �	Length of Cash Payment Value element in characters (1 byte)
  �	Length of Payment Type 2 Value element in characters (1 byte)
  �	Length of Payment Type 3 Value element in characters (1 byte)
  �	Length of Payment Type 4Value element in characters (1 byte)
  �	Length of Change Value element in characters (1 byte)
  �	Length of Tax 1 Name element in characters (1 byte)
  �	Length of Tax 1 Turnover element in characters (1 byte)
  �	Length of Tax 1 Rate element in characters (1 byte)
  �	Length of Tax 1 Value element in characters (1 byte)
  �	Length of Tax 2 Name element in characters (1 byte)
  �	Length of Tax 2 Turnover element in characters (1 byte)
  �	Length of Tax 2 Rate element in characters (1 byte)
  �	Length of Tax 2 Value element in characters (1 byte)
  �	Length of Tax 3 Name element in characters (1 byte)
  �	Length of Tax 3 Turnover element in characters (1 byte)
  �	Length of Tax 3 Rate element in characters (1 byte)
  �	Length of Tax 3 Value element in characters (1 byte)
  �	Length of Tax 4 Name element in characters (1 byte)
  �	Length of Tax 4 Turnover element in characters (1 byte)
  �	Length of Tax 4 Rate element in characters (1 byte)
  �	Length of Tax 4 Value element in characters (1 byte)
  �	Length of Receipt Subtotal Before Discount/Surcharge Value element in characters (1 byte)
  �	Length of 'DISCOUNT XX.XX%' element in characters (1 byte)
  �	Length of Receipt Discount Value element in characters (1 byte)
  �	Position in line of Text element (1 byte)
  �	Position in line of 'TOTAL' element (1 byte)
  �	Position in line of Receipt Total Value element (1 byte)
  �	Position in line of 'CASH' element (1 byte)
  �	Position in line of Cash Payment Value element (1 byte)
  �	Position in line of Payment Type 2 Name element (1 byte)
  �	Position in line of Payment Type 2 Value element (1 byte)
  �	Position in line of Payment Type 3 Name element (1 byte)
  �	Position in line of Payment Type 3 Value element (1 byte)
  �	Position in line of Payment Type 4 Name element (1 byte)
  �	Position in line of Payment Type 4 Value element (1 byte)
  �	Position in line of 'CHANGE' element (1 byte)
  �	Position in line of Change Value element (1 byte)
  �	Position in line of Tax 1 Name element (1 byte)
  �	Position in line of Tax 1 Turnover Value element (1 byte)
  �	Position in line of Tax 1 Rate element (1 byte)
  �	Position in line of Tax 1 Value element (1 byte)
  �	Position in line of Tax 2 Name element (1 byte)
  �	Position in line of Tax 2 Turnover Value element (1 byte)
  �	Position in line of Tax 2 Rate element (1 byte)
  �	Position in line of Tax 2 Value element (1 byte)
  �	Position in line of Tax 3 Name element (1 byte)
  �	Position in line of Tax 3 Turnover Value element (1 byte)
  �	Position in line of Tax 3 Rate element (1 byte)
  �	Position in line of Tax 3 Value element (1 byte)
  �	Position in line of Tax 4 Name element (1 byte)
  �	Position in line of Tax 4 Turnover Value element (1 byte)
  �	Position in line of Tax 4 Rate element (1 byte)
  �	Position in line of Tax 4 Value element (1 byte)
  �	Position in line of 'SUBTOTAL' element (1 byte)
  �	Position in line of Receipt Subtotal Before Discount/Surcharge Value element (1 byte)
  �	Position in line of 'DISCOUNT XX.XX%' element (1 byte)
  �	Position in line of Receipt Discount Value element (1 byte)
  �	Slip line number with the first line of Close Fiscal Slip block (1 byte)
  �	Cash Payment value (5 bytes)
  �	Payment Type 2 value (5 bytes)
  �	Payment Type 3 value (5 bytes)
  �	Payment Type 4 value (5 bytes)
  �	Receipt Discount Value 0 to 99,99 % (2 bytes) 0000�9999
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		76H. Length: 8 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Change value (5 bytes) 0000000000�9999999999

******************************************************************************)

function TFiscalPrinterDevice.SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
begin
(*
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($76);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.Write(Params, sizeof(Params));

    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(Discount.Text, PrintWidth);

    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
  *)
end;


(******************************************************************************

  Sale

  Command:	80H. Length: 60 bytes.
  �	Operator password (4 bytes)
  �	Quantity (5 bytes) 0000000000�9999999999
  �	Unit Price (5 bytes) 0000000000�9999999999
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		80H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

procedure TFiscalPrinterDevice.UpdateDepartment(var P: TPriceReg);
var
  S: AnsiString;
  V, Code: Integer;
begin
  if Parameters.DepartmentInText then
  begin
    S := Copy(P.Text, 1, 2);
    Val(S, V, Code);
    if (Code = 0)and(V in [1..16]) then
    begin
      P.Department := V;
      P.Text := Copy(P.Text, 3, Length(P.Text));
    end;
  end;
end;

function TFiscalPrinterDevice.PrintItemText(const S: WideString): WideString;
var
  i: Integer;
  Line: AnsiString;
  Lines: TTntStrings;
begin
  Result := S;
  if Parameters.ItemTextMode <> ItemTextModePrint then exit;

  Lines := TTntStringList.Create;
  try
    SplitText(S, 1, Lines);
    if Lines.Count = 1 then Exit;

    for i := 0 to Lines.Count-2 do
    begin
      Line := Lines[i];
      PrintStringFont(PRINTER_STATION_REC, 1, Line)
    end;
    Result := Lines[Lines.Count-1];
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.Sale(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Operation.Text := PrintItemText(Operation.Text);
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($80);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.Sale(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Buy

  Command:	81H. Length: 60 bytes.
  �	Operator password (4 bytes)
  �	Quantity (5 bytes) 0000000000�9999999999
  �	Unit Price (5 bytes) 0000000000�9999999999
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		81H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.Buy(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($81);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.Buy(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Sale Refund

  Command:	82H. Length: 60 bytes.
  �	Operator password (4 bytes)
  �	Quantity (5 bytes) 0000000000�9999999999
  �	Unit Price (5 bytes) 0000000000�9999999999
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		82H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.RetSale(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($82);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.RetSale(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Buy Refund

  Command:	83H. Length: 60 bytes.
  �	Operator password (4 bytes)
  �	Quantity (5 bytes) 0000000000�9999999999
  �	Unit Price (5 bytes) 0000000000�9999999999
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		83H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.RetBuy(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  UpdateDepartment(Operation);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($83);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.RetBuy(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Void Transaction
  
  Command:	84H. Length: 60 bytes.
  �	Operator password (4 bytes)
  �	Quantity (5 bytes) 0000000000�9999999999
  �	Unit Price (5 bytes) 0000000000�9999999999
  �	Department (1 byte) 0�16
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		84H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.Storno(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($84);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.Storno(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Close Receipt
  
  Command:	85H. Length: 71 bytes.
  �	Operator password (4 bytes)
  �	Cash Payment value (5 bytes) 0000000000�9999999999
  �	Payment Type 2 value (5 bytes) 0000000000�9999999999
  �	Payment Type 3 value (5 bytes) 0000000000�9999999999
  �	Payment Type 4 value (5 bytes) 0000000000�9999999999
  �	Receipt Percentage Discount/Surcharge Value 0 to 99,99 % (2 bytes with sign) -9999�9999, surcharge if value is negative
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		85H. Length: 8 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Change value (5 bytes) 0000000000�9999999999

******************************************************************************)

function TFiscalPrinterDevice.ReceiptClose(const P: TCloseReceiptParams;
  var R: TCloseReceiptResult): Integer;
var
  Stream: TBinStream;
begin
  WriteTLVItems;
  FFilter.BeforeCloseReceipt;
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($85);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(P.CashAmount, 5);
    Stream.WriteInt(P.Amount2, 5);
    Stream.WriteInt(P.Amount3, 5);
    Stream.WriteInt(P.Amount4, 5);
    Stream.WriteInt(P.PercentDiscount, 2);
    Stream.WriteInt(P.Tax1, 1);
    Stream.WriteInt(P.Tax2, 1);
    Stream.WriteInt(P.Tax3, 1);
    Stream.WriteInt(P.Tax4, 1);
    Stream.WriteString(GetText(P.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      Stream.Read(R, sizeof(R));
      FFilter.CloseReceipt(P, R);
    end;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Discount

  Command:	86H. Length: 54 bytes.
  �	Operator password (4 bytes)
  �	Discount value (5 bytes) 0000000000�9999999999
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		86H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptDiscount(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($86);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.ReceiptDiscount(Operation);
  finally
    Stream.Free;
  end;
end;

(*
������, ��������  �� ��� ��� �������� FF4BH
  ��� ������� FF4Bh . ����� ���������:  145 ����.
  ������ ���������� ��������������: 4 �����
  ������:         5 ����
  ��������:    5 ����
  �����:  1 ����
  �������� ������ ��� ��������: 128 ���� ASCII
�����:    FF4Bh ����� ���������: 1 ����.
  ��� ������: 1 ����

*)

function TFiscalPrinterDevice.ReceiptDiscount2(
  Operation: TReceiptDiscount2): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$4B +
    IntToBin(GetUsrPassword, 4) +
    IntToBin(Operation.Discount, 5) +
    IntToBin(Operation.Charge, 5) +
    IntToBin(Operation.Tax, 1) +
    GetText(Operation.Text, 40);
  Result := ExecuteData(Command, Answer);
  FCapReceiptDiscount := IsSupported(Result);
end;

(******************************************************************************

  Surcharge

  Command:	87H. Length: 54 bytes.
  �	Operator password (4 bytes)
  �	Surcharge value (5 bytes) 0000000000�9999999999
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		87H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptCharge(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($87);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.ReceiptCharge(Operation);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Cancel Receipt

  Command:	88H. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		88H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptCancel: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($88);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.CancelReceipt;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.ReceiptCancelPassword(Password: Integer): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($88);
    Stream.WriteDWORD(Password);
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.CancelReceipt;
  finally
    Stream.Free;
  end;
end;

procedure TFiscalPrinterDevice.CancelReceipt;
var
  i: Integer;
  Password: Integer;
begin
  if IsRecOpened then
  begin
    if ReceiptCancelPassword(GetUsrPassword) = 0 then
    begin
      WaitForPrinting;
      Exit;
    end;
    if ReceiptCancelPassword(GetSysPassword) = 0 then
    begin
      WaitForPrinting;
      Exit;
    end;
    for i := 1 to 29 do
    begin
      Password := ReadTableInt(2, i, 1);
      if ReceiptCancelPassword(Password) = 0 then
      begin
        WaitForPrinting;
        Exit;
      end;
    end;
  end;
  if IsFSDocumentOpened then
  begin
    Check(FSCancelDocument);
  end;
end;


(******************************************************************************

  Get Receipt Subtotal

  Command:	89H. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		89H. Length: 8 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30
  �	Receipt Subtotal (5 bytes) 0000000000�9999999999

******************************************************************************)

function TFiscalPrinterDevice.GetSubtotal: Int64;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($89);
    Stream.WriteDWORD(GetUsrPassword);
    Check(ExecuteStream(Stream));
    Stream.ReadByte;
    Result := Stream.ReadInt(5);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Void Discount

  Command:	8AH. Length: 54 bytes.
  �	Operator password (4 bytes)
  �	Void Discount value (5 bytes) 0000000000�9999999999
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		8AH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptStornoDiscount(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8A);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Void Surcharge

  Command:	8BH. Length: 54 bytes.
  �	Operator password (4 bytes)
  �	Void Surcharge value (5 bytes) 0000000000�9999999999
  �	Tax 1 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 2 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 3 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Tax 4 (1 byte) '0' - no tax, '1'�'4' - tax ID
  �	Text (40 bytes)
  Answer:		8BH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.ReceiptStornoCharge(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8B);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(GetText(Operation.Text, 40));
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Last Receipt Duplicate

  Command:	8CH. Length: 5 bytes.
  �	Operator password (4 bytes)
  Answer:		8CH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.PrintReceiptCopy: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8C);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Open Receipt

  Command:	8DH. Length: 6 bytes.
  �	Operator password (4 bytes)
  �	Receipt type (1 byte):		0 - Sale;
  1 - Buy;
  2 - Sale Refund;
  3 - Buy Refund.
  Answer:		8DH. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.OpenReceipt(ReceiptType: Byte): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8D);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(ReceiptType);
    Result := ExecuteStream(Stream);
    if Result = 0 then
      FFilter.OpenReceipt(ReceiptType);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Continue Printing

  Command:	B0H. Length: 5 bytes.
  �	Operator, Administrator or System Administrator password (4 bytes)
  Answer:		B0H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.ContinuePrint: Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($B0);
    Stream.WriteDWORD(GetUsrPassword);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Load Graphics In FP

  Command: 	C0H. Length: 46 bytes.
  �	Operator password (4 bytes)
  �	Graphics line number (1 byte) 0�199
  �	Graphical data (40 bytes)
  Answer:		C0H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.LoadGraphics1(Line: Byte; Data: AnsiString): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C0);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Line);
    Stream.WriteString(GetDataBlock(Data, 40, 40));
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
    begin
      FCapGraphics1 := False;
      FModelData.CapGraphics := False;
    end;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Graphics

  Command:	C1H. Length: 7 bytes.
  �	Operator password (4 bytes)
  �	Number of first line of preloaded graphics to be printed (1 byte) 1�200
  �	Number of last line of preloaded graphics to be printed (1 byte) 1�200
  Answer:		C1H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.PrintGraphics1(Line1, Line2: Byte): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C1);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteByte(Line1);
    Stream.WriteByte(Line2);
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
      FModelData.CapGraphics := False;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Bar Code

  Command:	C2H. Length: 10 bytes.
  �	Operator password (4 bytes)
  �	Bar code (5 bytes) 000000000000�999999999999
  Answer:		C2H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.PrintBarcode(const Barcode: WideString): Integer;
var
  IBarcode: Int64;
  Stream: TBinStream;
begin
  IBarcode := StrToInt64(Copy(Barcode, 1, 12));
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C2);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(IBarcode, 5);
    Result := ExecuteStream(Stream);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Extended Graphics Load In FP

  Command: 	C3H. Length: 47 bytes.
  �	Operator password (4 bytes)
  �	Graphics line number (2 bytes) 0�1199
  �	Graphical data (40 bytes)
  Answer:		C3H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.PrintGraphics2(Line1, Line2: Word): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C3);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Line1, 2);
    Stream.WriteInt(Line2, 2);
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
      FModelData.CapGraphicsEx := False;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Extended Graphics

  Command:	C4H. Length: 9 bytes.
  �	Operator password (4 bytes)
  �	Number of first line of preloaded graphics to be printed (1 byte) 1�1200
  �	Number of last line of preloaded graphics to be printed (1 byte) 1�1200
  Answer:		C4H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.LoadGraphics2(Line: Word; Data: AnsiString): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C4);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Line, 2);
    Stream.WriteString(GetDataBlock(Data, 40, 40));
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
    begin
      FCapGraphics2 := False;
      FModelData.CapGraphicsEx := False;
    end;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Print Graphical Line

  Command: 	C5H. Length: X + 7 bytes.
  �	Operator password (4 bytes)
  �	Number of repetitions (2 bytes)
  �	Flags (1 byte)
  �	Graphical data (X bytes)
  Answer:		C5H. Length: 3 bytes.
  �	Result Code (1 byte)
  �	Operator index number (1 byte) 1�30

******************************************************************************)

function TFiscalPrinterDevice.PrintGraphicsLine(Height: Word; Flags: Byte;
  Data: WideString): Integer;
var
  Stream: TBinStream;
begin
  Flags := GetPrintFlags(Flags);
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C5);
    Stream.WriteDWORD(GetUsrPassword);
    Stream.WriteInt(Height, 2);
    if FCapParameters2 and FParameters2.Flags.CapFlagsGraphicsEx then
    begin
      Stream.WriteByte(Flags);
    end;
    Stream.WriteString(Data);
    Result := ExecuteStream(Stream);
    if Result = ERROR_COMMAND_NOT_SUPPORTED then
    begin
      FCapBarLine := False;
    end;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Device Type

  Command:	FCH. Length: 1 byte.
  Answer:		FCH. Length: (8+X) bytes.
  �	Result Code (1 byte)
  �	Device type (1 byte) 0�255
  �	Device subtype (1 byte) 0�255
  �	Protocol version supported by device (1 byte) 0�255
  �	Subprotocol version supported by device (1 byte) 0�255
  �	Device model (1 byte) 0�255
  �	Language (1 byte) 0�255, '0' - Russian, '1' - English
  �	Device name (X bytes) AnsiString of WIN1251 code page characters;
    AnsiString length in bytes depends on device model

******************************************************************************)

function TFiscalPrinterDevice.ReadDeviceMetrics: TDeviceMetrics;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($FC);
    Check(ExecuteStream(Stream));
    Result.DeviceType := Stream.ReadByte;
    Result.DeviceSubType := Stream.ReadByte;
    Result.ProtocolVersion := Stream.ReadByte;
    Result.ProtocolSubVersion := Stream.ReadByte;
    Result.Model := Stream.ReadByte;
    Result.Language := Stream.ReadByte;
    Result.DeviceName := Stream.ReadString;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.FieldToInt(FieldInfo: TPrinterFieldRec;
  const Value: WideString): Integer;
begin
  Result := 0;
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := BinToInt(Value, 1, FieldInfo.Size);
    PRINTER_FIELD_TYPE_STR: raiseException(_('Field type is not integer'));
  else
    raiseException(_('Invalid field type'));
  end;
end;

function TFiscalPrinterDevice.FieldToStr(FieldInfo: TPrinterFieldRec;
  const Value: WideString): WideString;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToStr(BinToInt(Value, 1, FieldInfo.Size));
    PRINTER_FIELD_TYPE_STR: Result := PWideChar(Value);
  else
    raiseException(_('Invalid field type'));
  end;
end;

function TFiscalPrinterDevice.BinToFieldValue(
  FieldInfo: TPrinterFieldRec;
  const Value: WideString): WideString;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToStr(BinToInt(Value, 1, FieldInfo.Size));
    PRINTER_FIELD_TYPE_STR: Result := Value;
  else
    raiseException(_('Invalid field type'));
  end;
end;

function TFiscalPrinterDevice.GetFieldValue(FieldInfo: TPrinterFieldRec;
  const Value: WideString): AnsiString;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToBin(StrToInt(Value), FieldInfo.Size);
    PRINTER_FIELD_TYPE_STR: Result := GetDataBlock(Value, FieldInfo.Size, FieldInfo.Size);
  else
    raiseException(_('Invalid field type'));
  end;
end;

function TFiscalPrinterDevice.WriteTable(
  Table, Row, Field: Integer;
  const FieldValue: WideString): Integer;
var
  Data: AnsiString;
  FieldInfo: TPrinterFieldRec;
begin
  Result := 0;
  //if ReadTableStr(Table, Row, Field) = FieldValue then Exit; { !!! }

  FieldInfo := ReadFieldStructure(Table, Field);
  if ValidFieldValue(FieldInfo, FieldValue) then
  begin
    Data := GetFieldValue(FieldInfo, FieldValue);
    Result := DoWriteTable(Table, Row, Field, Data);
    if Result = 0 then
    begin
      if (Table = 17)and(Row = 1)and(Field=7) then
      begin
        FDocPrintMode := StrToInt(FieldValue);
      end;
    end;
  end else
  begin
    Logger.Error(Format('%s, "%s"', [_('Invalid field value'), FieldValue]));
  end;
end;

function TFiscalPrinterDevice.WriteTableInt(
  Table, Row, Field, Value: Integer): Integer;
begin
  Result := WriteTable(Table, Row, Field, IntToStr(Value));
end;

function TFiscalPrinterDevice.ReadTableInt(Table, Row, Field: Integer): Integer;
var
  Data: AnsiString;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := ReadTableBin(Table, Row, Field);
  Result := FieldToInt(FieldInfo, Data);
end;

function TFiscalPrinterDevice.ReadTableStr(Table, Row, Field: Integer): WideString;
var
  Data: AnsiString;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := ReadTableBin(Table, Row, Field);
  Result := FieldToStr(FieldInfo, Data);
end;

(*******************************************************************************

  Read discount totals in day

  185, Discounts accumulation on sales in day
  186, Discounts accumulation on buys in day
  187, Discounts accumulation on sale refunds in day
  188, Discounts accumulation on buy refunds in day

*******************************************************************************)

function TFiscalPrinterDevice.GetDayDiscountTotal: Int64;
begin
  Result :=
    ReadCashRegister(185) +
    ReadCashRegister(188) -
    ReadCashRegister(186) -
    ReadCashRegister(187);
end;

(*******************************************************************************

  Discounts accumulation in receipt

  64, Discounts accumulation from sales in receipt
  65, Discounts accumulation from buys in receipt
  66, Discounts accumulation from sale refunds in receipt
  67, Discounts accumulation from buy refunds in receipt

*******************************************************************************)

function TFiscalPrinterDevice.GetRecDiscountTotal: Int64;
begin
  Result :=
    ReadCashRegister(64) +
    ReadCashRegister(67) -
    ReadCashRegister(65) -
    ReadCashRegister(66);
end;

(*******************************************************************************

  Sales accumulation in day

    121, Sales accumulation in 1 department in day
    125, Sales accumulation in 2 department in day
    129, Sales accumulation in 3 department in day
    133, Sales accumulation in 4 department in day
    137, Sales accumulation in 5 department in day
    141, Sales accumulation in 6 department in day
    145, Sales accumulation in 7 department in day
    149, Sales accumulation in 8 department in day
    153, Sales accumulation in 9 department in day
    157, Sales accumulation in 10 department in day
    161, Sales accumulation in 11 department in day
    165, Sales accumulation in 12 department in day
    169, Sales accumulation in 13 department in day
    173, Sales accumulation in 14 department in day
    177, Sales accumulation in 15 department in day
    181, Sales accumulation in 16 department in day

*******************************************************************************)

function TFiscalPrinterDevice.GetDayItemTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(121 + 4*i);
end;

(*******************************************************************************

  Sales accumulation in receipt

    0, Sales accumulation in 1 department in receipt
    4, Sales accumulation in 2 department in receipt
    8, Sales accumulation in 3 department in receipt
    12, Sales accumulation in 4 department in receipt
    16, Sales accumulation in 5 department in receipt
    20, Sales accumulation in 6 department in receipt
    24, Sales accumulation in 7 department in receipt
    28, Sales accumulation in 8 department in receipt
    32, Sales accumulation in 9 department in receipt
    36, Sales accumulation in 10 department in receipt
    40, Sales accumulation in 11 department in receipt
    44, Sales accumulation in 12 department in receipt
    48, Sales accumulation in 13 department in receipt
    52, Sales accumulation in 14 department in receipt
    56, Sales accumulation in 15 department in receipt
    60, Sales accumulation in 16 department in receipt

*******************************************************************************)

function TFiscalPrinterDevice.GetRecItemTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(4*i);
end;

(*******************************************************************************

  Sales refund accumulation in day

    123, Sales refund accumulation in 1 department in day
    127, Sales refund accumulation in 2 department in day
    131, Sales refund accumulation in 3 department in day
    135, Sales refund accumulation in 4 department in day
    139, Sales refund accumulation in 5 department in day
    143, Sales refund accumulation in 6 department in day
    147, Sales refund accumulation in 7 department in day
    151, Sales refund accumulation in 8 department in day
    155, Sales refund accumulation in 9 department in day
    159, Sales refund accumulation in 10 department in day
    163, Sales refund accumulation in 11 department in day
    167, Sales refund accumulation in 12 department in day
    171, Sales refund accumulation in 13 department in day
    175, Sales refund accumulation in 14 department in day
    179, Sales refund accumulation in 15 department in day
    183, Sales refund accumulation in 16 department in day

*******************************************************************************)

function TFiscalPrinterDevice.GetDayItemVoidTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(123 + 4*i);
end;

(*******************************************************************************

  Sales refund accumulation in receipt

    2, Sales refund accumulation in 1 department in receipt
    6, Sales refund accumulation in 2 department in receipt
    10, Sales refund accumulation in 3 department in receipt
    14, Sales refund accumulation in 4 department in receipt
    18, Sales refund accumulation in 5 department in receipt
    22, Sales refund accumulation in 6 department in receipt
    26, Sales refund accumulation in 7 department in receipt
    30, Sales refund accumulation in 8 department in receipt
    34, Sales refund accumulation in 9 department in receipt
    38, Sales refund accumulation in 10 department in receipt
    42, Sales refund accumulation in 11 department in receipt
    46, Sales refund accumulation in 12 department in receipt
    50, Sales refund accumulation in 13 department in receipt
    54, Sales refund accumulation in 14 department in receipt
    58, Sales refund accumulation in 15 department in receipt
    62, Sales refund accumulation in 16 department in receipt

*******************************************************************************)

function TFiscalPrinterDevice.GetRecItemVoidTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashRegister(2 + 4*i);
end;

(*******************************************************************************

  Get Data Of EKLZ Daily Totals Report

  Command:	BAH. Length: 7 bytes.
  �	System Administrator password (4 bytes) 30
  �	Number of daily totals (2 bytes) 0000�2100
  Answer:		BAH. Length: 18 bytes.
  �	Result Code (1 byte)
  �	ECR model (16 bytes) AnsiString of WIN1251 code page characters

*******************************************************************************)

function TFiscalPrinterDevice.GetEJSesssionResult(Number: Word;
  var Text: WideString): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  Command := #$BA + IntToBin(GetSysPassword, 4) + IntToBin(Number, 2);
  Result := ExecuteData(Command, Answer);
  Text := Answer;
end;

(*******************************************************************************

������ ����� ����������� ����
�������: BBH. ����� ���������: 5 ����.
������ ���������� �������������� (4 �����)
�����: BBH. ����� ���������: 18 ����.
��� ������ (1 ����)
��� ��� � ������ �������� � ��������� WIN1251 (16 ����)

*******************************************************************************)

function TFiscalPrinterDevice.ReadEJActivation(var Line: WideString): Integer;
var
  Answer: AnsiString;
begin
  Result := ExecuteData(#$BB + IntToBin(GetSysPassword, 4), Answer);
  Line := TrimRight(PChar(Answer));
end;

(*******************************************************************************

  Get Data Of EKLZ Report

  Command:	B3H. Length: 5 bytes.
  �	System Administrator password (4 bytes) 30
  Answer:		B3H. Length: (2+X) bytes.
  �	Result Code (1 byte)
  �	Report part or line (X bytes)

*******************************************************************************)

function TFiscalPrinterDevice.GetEJReportLine(var Line: WideString): Integer;
var
  Answer: AnsiString;
begin
  Result := ExecuteData(#$B3 + IntToBin(GetSysPassword, 4), Answer);
  Line := TrimRight(PChar(Answer));
end;

(*******************************************************************************

  Cancel Active EKLZ Operation

  Command:	ACH. Length: 5 bytes.
  �	System Administrator password (4 bytes) 30
  Answer:		ACH. Length: 2 bytes.
  �	Result Code (1 byte)

*******************************************************************************)

function TFiscalPrinterDevice.EJReportStop: Integer;
var
  RxData: AnsiString;
begin
  Result := ExecuteData(#$AC + IntToBin(GetSysPassword, 4), RxData);
end;

function TFiscalPrinterDevice.DecodeEJFlags(Flags: Byte): TEJFlags;
begin
  Result.DocType := Flags and $03;      // bits 0,1
  Result.ArcOpened := TestBit(Flags, 2);
  Result.Activated := TestBit(Flags, 3);
  Result.ReportMode := TestBit(Flags, 4);
  Result.DocOpened := TestBit(Flags, 5);
  Result.DayOpened := TestBit(Flags, 6);
  Result.ErrorFlag := TestBit(Flags, 7);
end;

(*******************************************************************************

  Get EKLZ Status 1

  Command:	ADH. Length: 5 bytes.
  �	System Administrator password (4 bytes) 30
  Answer:		ADH. Length: 22 bytes.
  �	Result Code (1 byte)
  �	KPK value of last fiscal receipt (5 bytes) 0000000000�9999999999
  �	Date of last KPK (3 bytes) DD-MM-YY
  �	Time of last KPK (2 bytes) HH-MM
  �	Number of last KPK (4 bytes) 00000000�99999999
  �	EKLZ serial number (5 bytes) 0000000000�9999999999
  �	EKLZ flags (1 byte)

*******************************************************************************)

function TFiscalPrinterDevice.GetEJStatus1(var Status: TEJStatus1): Integer;
var
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($AD);
    Stream.WriteDWORD(GetSysPassword);
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      Status.DocAmount := Stream.ReadInt(5);
      Stream.Read(Status.DocDate, sizeof(Status.DocDate));
      Stream.Read(Status.DocTime, sizeof(Status.DocTime));
      Stream.Read(Status.DocNumber, sizeof(Status.DocNumber));
      Status.EJNumber := Stream.ReadInt(5);
      Status.Flags := DecodeEJFlags(Stream.ReadByte);
    end;
  finally
    Stream.Free;
  end;
end;

function TFiscalPrinterDevice.FormatLines(const Line1, Line2: WideString): WideString;
begin
  Result := AlignLines(Line1, Line2, GetPrintWidth);
end;

function TFiscalPrinterDevice.FormatBoldLines(const Line1, Line2: WideString): WideString;
begin
  Result := AlignLines(Line1, Line2, GetPrintWidth div 2);
end;

(******************************************************************************

  Print Daily Totals Report In Dates Range From EKLZ

  Command:	A2H. Length: 12 bytes.
  �	System Administrator password (4 bytes) 30
  �	Report type (1 byte) '0' - short, '1' - full
  �	Date of first daily totals in range (3 bytes) DD-MM-YY
  �	Date of last daily totals in range (3 bytes) DD-MM-YY
  Answer:		A2H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.EJTotalsReportDate(
  const Parameters: TDateReport);
begin
  Execute(#$A2 +
    IntToBin(GetSysPassword, 4) +
    Chr(Parameters.ReportType) +
    PrinterDateToBin(Parameters.Date1) +
    PrinterDateToBin(Parameters.Date2));
end;

(******************************************************************************

  Print Daily Totals Report In Daily Totals Numbers Range From EKLZ

  Command:	A3H. Length: 10 bytes.
  �	System Administrator password (4 bytes) 30
  �	Report type (1 byte) '0' - short, '1' - full
  �	Number of first daily totals in range (2 bytes) 0000�2100
  �	Number of last daily totals in range (2 bytes) 0000�2100
  Answer:		A3H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.EJTotalsReportNumber(
  const Parameters: TNumberReport);
begin
  Execute(#$A3 +
    IntToBin(GetSysPassword, 4) +
    Chr(Parameters.ReportType) +
    IntToBin(Parameters.Number1, 2) +
    IntToBin(Parameters.Number2, 2));
end;

function TFiscalPrinterDevice.GetModel: TPrinterModelRec;
begin
  Result := FModelData;
end;

function TFiscalPrinterDevice.GetPrinterModel: TPrinterModel;
begin
  if FModel = nil then
  begin
    FModel := SelectModel;
  end;
  Result := FModel;
end;

function TFiscalPrinterDevice.SelectModel: TPrinterModel;
var
  ModelID: Integer;
begin
  ModelID := Parameters.ModelID;
  Result := FModels.ItemByID(ModelID);
  if Result = nil then
  begin
    ModelID := GetDeviceMetrics.Model;
    Result := FModels.ItemByID(ModelID);
    if Result = nil then
    begin
      ModelID := DefaultModelID;
      Result := FModels.ItemByID(ModelID);
    end;
  end;

  if Result = nil then
    raiseExceptionFmt('%s, ID=%d', [_('Device model not found'), ModelID]);

  FModelData := Result.Data;
  FModelData.CapGraphics := True;
  FModelData.CapGraphicsEx := True;

  WriteLogModelParameters(FModelData);
end;

function TFiscalPrinterDevice.GetOnCommand: TCommandEvent;
begin
  Result := FOnCommand;
end;

procedure TFiscalPrinterDevice.SetOnCommand(Value: TCommandEvent);
begin
  FOnCommand := Value;
end;

function TFiscalPrinterDevice.GetBeforeCommand: TCommandEvent;
begin
  Result := FBeforeCommand;
end;

procedure TFiscalPrinterDevice.SetBeforeCommand(Value: TCommandEvent);
begin
  FBeforeCommand := Value;
end;

function TFiscalPrinterDevice.AlignLine(const Line: WideString;
  PrintWidth: Integer; Alignment: TTextAlignment = taLeft): WideString;
var
  L: Integer;
  L1: Integer;
  L2: Integer;
begin
  Result := Copy(Line, 1, PrintWidth);
  L := Length(Result);
  case Alignment of
    taCenter:
    begin
      L1 := (PrintWidth - L) div 2;
      L2 := PrintWidth - L -L1;
      Result := StringOfChar(' ', L1) + Result + StringOfChar(' ', L2);
    end;
    taRight:
    begin
      Result := StringOfChar(' ', PrintWidth-L) + Result;
    end;
  end;
end;

function TFiscalPrinterDevice.CenterLine(const Line: WideString): WideString;
var
  L: Integer;
  L1: Integer;
  L2: Integer;
begin
  Result := Trim(Line);
  Result := Copy(Result, 1, GetPrintWidth);
  L := Length(Result);
  L1 := (GetPrintWidth - L) div 2;
  L2 := GetPrintWidth - L -L1;
  Result := StringOfChar(' ', L1) + Result + StringOfChar(' ', L2);
end;

function TFiscalPrinterDevice.ProcessLine(const Line: WideString): Boolean;
var
  Barcode: TBarcodeRec;
begin
  Result := (Parameters.BarcodePrefix <> '')and(Pos(Parameters.BarcodePrefix, Line) = 1);
  if not Result then Exit;
  Barcode.Data := Copy(Line, Length(Parameters.BarcodePrefix) + 1, Length(Line));
  Barcode.Text := Barcode.Data;
  Barcode.Height := Parameters.BarcodeHeight;
  Barcode.BarcodeType := Parameters.BarcodeType;
  Barcode.ModuleWidth := Parameters.BarcodeModuleWidth;
  Barcode.Alignment := Parameters.BarcodeAlignment;
  Barcode.Parameter1 := Parameters.BarcodeParameter1;
  Barcode.Parameter2 := Parameters.BarcodeParameter2;
  Barcode.Parameter3 := Parameters.BarcodeParameter3;
  PrintBarcode2(Barcode);
end;

procedure TFiscalPrinterDevice.PrintLineFont(const Data: TTextRec);
var
  i: Integer;
  Line: AnsiString;
  Lines: TTntStrings;
  PrintWidth: Integer;
begin
  PrintWidth := GetPrintWidth(Data.Font);
  Lines := TTntStringList.Create;
  try
    if ProcessLine(Data.Text) then Exit;

    if Data.Wrap then
    begin
      SplitText(Data.Text, Data.Font, Lines);
    end else
    begin
      Lines.Add(Data.Text);
    end;

    for i := 0 to Lines.Count-1 do
    begin
      Line := Lines[i];
      Line := AlignLine(Line, PrintWidth, Data.Alignment);
      if CapPrintStringFont then
        PrintStringFont(Data.Station, Data.Font, Line)
      else
        PrintStringFont(Data.Station, Parameters.FontNumber, Line);
    end;
  finally
    Lines.Free;
  end;
end;

procedure TFiscalPrinterDevice.SplitText(const Text: WideString; Font: Integer;
  Lines: TTntStrings);
var
  Line: WideString;
  AText: WideString;
  PrintWidth: Integer;
begin
  Lines.Clear;
  PrintWidth := GetPrintWidth(Font);
  AText := Text;
  Line := Copy(AText, 1, PrintWidth);
  AText := Copy(AText, PrintWidth + 1, Length(AText));
  repeat
    Lines.Add(Line);
    Line := Copy(AText, 1, PrintWidth);
    AText := Copy(AText, PrintWidth + 1, Length(AText));
  until Line = '';
end;

procedure TFiscalPrinterDevice.PrintTextFont(Station: Integer;
  Font: Integer; const Text: WideString);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Font;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  PrintText(Data);
end;

procedure TFiscalPrinterDevice.PrintText(Station: Integer; const Text: WideString);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Parameters.FontNumber;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  PrintText(Data);
end;

procedure TFiscalPrinterDevice.PrintText(const Data: TTextRec);
var
  i: Integer;
  Text: AnsiString;
  Line: TTextRec;
  Lines: TTntStrings;
begin
  Line := Data;
  Text := Data.Text;
  if Text = '' then Text := ' ';

  Lines := TTntStringList.Create;
  try
    Lines.Text := Text;
    for i := 0 to Lines.Count-1 do
    begin
      Line.Text := Lines[i];
      PrintLineFont(Line);
    end;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.GetTables: TDeviceTables;
begin
  Result := FDeviceTables;
end;

procedure TFiscalPrinterDevice.SetTables(const Value: TDeviceTables);
begin
  FDeviceTables := Value;
end;

procedure TFiscalPrinterDevice.OpenPort(
  PortNumber, BaudRate, ByteTimeout: Integer);
begin
  Logger.Debug(Format('OpenPort(COM%d, %d, %d)', [PortNumber, BaudRate, ByteTimeout]));
  Connection.OpenPort(PortNumber, BaudRate, ByteTimeout);
end;

procedure TFiscalPrinterDevice.ClaimDevice(PortNumber, Timeout: Integer);
begin
  Connection.ClaimDevice(PortNumber, Timeout);
end;

procedure TFiscalPrinterDevice.ReleaseDevice;
begin
  Connection.ReleaseDevice;
end;

procedure TFiscalPrinterDevice.Close;
begin
  FConnection := nil;
  FIsOnline := False;
end;

procedure TFiscalPrinterDevice.Open(AConnection: IPrinterConnection);
begin
  FConnection := AConnection;
end;

procedure TFiscalPrinterDevice.ClosePort;
begin
  Connection.ClosePort;
  FIsOnline := False;
end;

procedure TFiscalPrinterDevice.WriteLogModelParameters(const Model: TPrinterModelRec);
begin
  Logger.Debug(Logger.Separator);
  Logger.LogParam('Model.ID', Model.ID);
  Logger.LogParam('Model.Name', Model.Name);
  Logger.LogParam('Model.CapShortEcrStatus', Model.CapShortEcrStatus);
  Logger.LogParam('Model.CapCoverSensor', Model.CapCoverSensor);
  Logger.LogParam('Model.CapJrnPresent', Model.CapJrnPresent);
  Logger.LogParam('Model.CapJrnEmptySensor', Model.CapJrnEmptySensor);
  Logger.LogParam('Model.CapJrnNearEndSensor', Model.CapJrnNearEndSensor);
  Logger.LogParam('Model.CapRecPresent', Model.CapRecPresent);
  Logger.LogParam('Model.CapRecEmptySensor', Model.CapRecEmptySensor);
  Logger.LogParam('Model.CapRecNearEndSensor', Model.CapRecNearEndSensor);
  Logger.LogParam('Model.CapSlpFullSlip', Model.CapSlpFullSlip);
  Logger.LogParam('Model.CapSlpEmptySensor', Model.CapSlpEmptySensor);
  Logger.LogParam('Model.CapSlpFiscalDocument', Model.CapSlpFiscalDocument);
  Logger.LogParam('Model.CapSlpNearEndSensor', Model.CapSlpNearEndSensor);
  Logger.LogParam('Model.CapSlpPresent', Model.CapSlpPresent);
  Logger.LogParam('Model.CapSetHeader', Model.CapSetHeader);
  Logger.LogParam('Model.CapSetTrailer', Model.CapSetTrailer);
  Logger.LogParam('Model.CapRecLever', Model.CapRecLever);
  Logger.LogParam('Model.CapJrnLever', Model.CapJrnLever);
  Logger.LogParam('Model.CapFixedTrailer', Model.CapFixedTrailer);
  Logger.LogParam('Model.CapDisableTrailer', Model.CapDisableTrailer);
  Logger.LogParam('Model.NumHeaderLines', Model.NumHeaderLines);
  Logger.LogParam('Model.NumTrailerLines', Model.NumTrailerLines);
  Logger.LogParam('Model.StartHeaderLine', Model.StartHeaderLine);
  Logger.LogParam('Model.StartTrailerLine', Model.StartTrailerLine);
  Logger.LogParam('Model.BaudRates', Model.BaudRates);
  Logger.LogParam('Model.PrintWidth', Model.PrintWidth);
  Logger.LogParam('Model.MaxGraphicsWidth', Model.MaxGraphicsWidth);
  Logger.LogParam('Model.MaxGraphicsHeight', Model.MaxGraphicsHeight);
  Logger.LogParam('Model.CapFullCut', Model.CapFullCut);
  Logger.LogParam('Model.CapPartialCut', Model.CapPartialCut);
  Logger.Debug(Logger.Separator);
end;

procedure TFiscalPrinterDevice.Check(Code: Integer);
begin
  if Code = 0 then Exit;
  RaiseError(Code, GetErrorText(Code));
end;

function TFiscalPrinterDevice.Execute(const Data: AnsiString): AnsiString;
begin
  Check(ExecuteData(Data, Result));
end;

function TFiscalPrinterDevice.GetDeviceMetrics: TDeviceMetrics;
begin
  if not FValidDeviceMetrics then
  begin
    FDeviceMetrics := ReadDeviceMetrics;
    FValidDeviceMetrics := True;
  end;
  Result := FDeviceMetrics;
end;

function TFiscalPrinterDevice.MinProtocolVersion(V1, V2: Integer): Boolean;
var
  DM: TDeviceMetrics;
begin
  DM := GetDeviceMetrics;
  Result := (DM.ProtocolVersion > V1)or
    ((DM.ProtocolVersion = V1) and (DM.ProtocolSubVersion >= V2));
end;

function TFiscalPrinterDevice.CapShortEcrStatus: Boolean;
begin
  Result := MinProtocolVersion(1, 1);
end;

function TFiscalPrinterDevice.CapPrintStringFont: Boolean;
begin
  Result := MinProtocolVersion(1, 1);
end;

function TFiscalPrinterDevice.CapGraphics: Boolean;
begin
  Result := MinProtocolVersion(1, 3);
end;

(******************************************************************************

  Print Daily Log Report For Daily Totals Number From EKLZ

  Command:	A6H. Length: 7 bytes.
  �	System Administrator password (4 bytes) 30
  �	Day number (2 bytes) 0000�2100

  Answer:		A6H. Length: 2 bytes.
  �	Result Code (1 byte)

******************************************************************************)

procedure TFiscalPrinterDevice.PrintJournal(DayNumber: Integer);
begin
  Execute(#$A6 + IntToBin(GetSysPassword, 4) + IntToBin(DayNumber, 2));
end;

function TFiscalPrinterDevice.ValidRow(Table, Row: Integer): Boolean;
var
  TableInfo: TPrinterTableRec;
begin
  Check(ReadTableStructure(Table, TableInfo));
  Result := (Row >= 1)and(Row <= TableInfo.RowCount);
end;

function TFiscalPrinterDevice.ValidField(Table, Field: Integer): Boolean;
var
  TableInfo: TPrinterTableRec;
begin
  Check(ReadTableStructure(Table, TableInfo));
  Result := (Field >= 1)and(Field <= TableInfo.FieldCount);
end;

function TFiscalPrinterDevice.CapParameter(ParamID: Integer): Boolean;
begin
  Result := PrinterModel.Parameters.ItemByID(ParamID) <> nil;
end;

function TFiscalPrinterDevice.ValidParameter(const Parameter: TTableParameter): Boolean;
begin
  Result := ValidRow(Parameter.Table, Parameter.Row) and
    ValidField(Parameter.Table, Parameter.Field);
end;

procedure TFiscalPrinterDevice.WriteParameter(ParamID, ValueID: Integer);
var
  Parameter: TTableParameter;
  ParameterValue: TParameterValue;
begin
  Parameter := PrinterModel.Parameters.ItemByID(ParamID);
  if Parameter <> nil then
  begin
    if ValidParameter(Parameter) then
    begin
      ParameterValue := Parameter.Values.ItemByID(ValueID);
      if ParameterValue <> nil then
      begin
        WriteTableInt(Parameter.Table, Parameter.Row, Parameter.Field,
        ParameterValue.Value);
      end;
    end;
  end;
end;

function TFiscalPrinterDevice.ReadParameter(ParamID: Integer): Integer;
var
  Parameter: TTableParameter;
begin
  Result := 0;
  Parameter := PrinterModel.Parameters.ItemByID(ParamID);
  if Parameter <> nil then
  begin
    if ValidParameter(Parameter) then
      Result := ReadTableInt(Parameter.Table, Parameter.Row, Parameter.Field);
  end;
end;

function TFiscalPrinterDevice.ReadEJDocument(MACNumber: Integer;
  var Line: WideString): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  Command := #$B5 + IntToBin(GetSysPassword, 4) + IntToBin(MACNumber, 4);
  Result := ExecuteData(Command, Answer);
  Line := Answer;
end;


function TFiscalPrinterDevice.ReadEJDocumentText(MACNumber: Integer): WideString;
var
  Line: WideString;
  Lines: TTntStrings;
begin
  Result := '';
  Lines := TTntStringList.Create;
  try
    if EJReportStop <> 0 then Exit;
    if ReadEJDocument(MACNumber, Line) <> 0 then Exit;
    Lines.Add(Line);

    while GetEJReportLine(Line) = 0 do
    begin
      Lines.Add(Line);
    end;
    EJReportStop;
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

// 00000068 #049021
function TFiscalPrinterDevice.ParseEJDocument(const Text: WideString): TEJDocument;
var
  Line: WideString;
  Lines: TTntStrings;
begin
  Result.Text := Text;
  Result.MACValue := 0;
  Result.MACNumber := 0;

  Lines := TTntStringList.Create;
  try
    Lines.Text := Text;
    if Lines.Count > 0 then
    begin
      Line := Trim(Lines[Lines.Count-1]);
      Result.MACNumber := StrToInt64(Copy(Line, 1, 8));
      Result.MACValue := StrToInt64(Copy(Line, 11, 6));
    end;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.ReadEJActivationText(MaxCount: Integer): WideString;
var
  i: Integer;
  Line: WideString;
  Lines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  try
    if EJReportStop <> 0 then Exit;
    if ReadEJActivation(Line) <> 0 then Exit;
    Lines.Add(Line);

    for i := 1 to MaxCount do
    begin
      if GetEJReportLine(Line) <> 0 then Break;
      Lines.Add(Line);
    end;
    EJReportStop;
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

function TFiscalPrinterDevice.QueryEJActivation: TEJActivation;
begin
  Result := TEJReportParser.ParseActivation(ReadEJActivationText(6));
end;

function TFiscalPrinterDevice.GetIsOnline: Boolean;
begin
  Result := FIsOnline;
end;

function TFiscalPrinterDevice.GetOnConnect: TNotifyEvent;
begin
  Result := FOnConnect;
end;

function TFiscalPrinterDevice.GetOnDisconnect: TNotifyEvent;
begin
  Result := FOnDisconnect;
end;

procedure TFiscalPrinterDevice.SetOnConnect(const Value: TNotifyEvent);
begin
  FOnConnect := Value;
end;

procedure TFiscalPrinterDevice.SetOnDisconnect(const Value: TNotifyEvent);
begin
  FOnDisconnect := Value;
end;

function TFiscalPrinterDevice.LoadGraphics(Line: Word;
  Data: AnsiString): Integer;
begin
  Result := 0;
  if FCapGraphics2 then
  begin
    Result := LoadGraphics2(Line, Data);
    Exit;
  end;
  if FCapGraphics1 then
  begin
    Result := LoadGraphics1(Line, Data);
    Exit;
  end;
  raiseException(_('Graphics is not supported'));
end;

function TFiscalPrinterDevice.PrintGraphics(Line1, Line2: Word): Integer;
begin
  Result := 0;
  CheckGraphicsSize(Line1);
  CheckGraphicsSize(Line2);

(*
  if FModel.Data.ID in [0, 4] then
  begin
    Line1 := Line1 + 1;
    Line2 := Line2 + 2;
  end;
  if FModel.Data.ID = 250 then
  begin
    Line1 := Line1 + 1;
    Line2 := Line2 + 1;
  end;
  if FModel.Data.ID in [7, 14] then
  begin
    Line2 := Line2 + 1;
  end;
*)
  if FCapGraphics512 then
  begin
    Result := PrintGraphics3(Line1, Line2);
    Exit;
  end;
  if FCapGraphics2 then
  begin
    Result := PrintGraphics2(Line1, Line2);
    Exit;
  end;
  if FCapGraphics1 then
  begin
    Result := PrintGraphics1(Line1, Line2);
    Exit;
  end;
  raiseException(_('Graphics is not supported'));
end;

function TFiscalPrinterDevice.IsDayOpened(Mode: Integer): Boolean;
begin
  Result := (Mode and $0F) in [MODE_24NOTOVER, MODE_24OVER, MODE_REC, MODE_SLP];
end;


function TFiscalPrinterDevice.GetAmountDecimalPlaces: Integer;
begin
  Result := FAmountDecimalPlaces;
end;

procedure TFiscalPrinterDevice.SetAmountDecimalPlaces(
  const Value: Integer);
begin
  FAmountDecimalPlaces := Value;
end;

procedure TFiscalPrinterDevice.PrintBarcode2(const Barcode: TBarcodeRec);

  procedure PrintBarcodeEAN13Zint(ABarcode: TBarcodeRec);
  var
    Line: AnsiString;
  begin
    ABarcode.Height := 80;
    ABarcode.Data := Copy(ABarcode.Data, 1, 12);
    ABarcode.Text := ABarcode.Data;
    ABarcode.Alignment := BARCODE_ALIGNMENT_CENTER;
    ABarcode.BarcodeType := DIO_BARCODE_EAN13;
    PrintBarcodeZInt(ABarcode);
    WaitForPrinting;
    Line := AlignLine(ABarcode.Data, GetPrintWidth, taCenter);
    PrintStringFont(PRINTER_STATION_REC, Parameters.FontNumber, Line);
  end;

  procedure PrintBarcodeEAN13Int(ABarcode: TBarcodeRec);
  begin
    Check(PrintBarcode(Copy(ABarcode.Data, 1, 12)));
    WaitForPrinting;
  end;

  procedure PrintBarcodeEAN13(ABarcode: TBarcodeRec);
  begin
    if Length(ABarcode.Data) in [12, 13] then
    begin
      PrintBarcodeEAN13Int(ABarcode);
    end else
    begin
      PrintBarcodeEAN13ZInt(ABarcode);
    end;
  end;

  function PrintBarcode2D_2(Barcode: TBarcodeRec): Integer;
  var
    Barcode2D: TBarcode2D;
  begin
    Barcode.Data := Barcode.Data + #0;
    Result := LoadBarcodeData(0, Barcode.Data);
    if Result <> 0 then Exit;

    Barcode2D.BarcodeType := Barcode.BarcodeType;
    Barcode2D.DataLength := Length(Barcode.Data);
    Barcode2D.BlockNumber := 0;
    Barcode2D.Parameter1 := Barcode.Parameter1;
    Barcode2D.Parameter2 := Barcode.Parameter2;
    Barcode2D.Parameter3 := Barcode.Parameter3;
    Barcode2D.Parameter4 := Barcode.Parameter4;
    Barcode2D.Parameter5 := Barcode.Parameter5;
    Barcode2D.Alignment := IntToAlignment(Barcode.Alignment);
    Result := PrintBarcode2D(Barcode2D);
  end;

  function IntTo2DBarcodeType(BarcodeType: Integer): Integer;
  begin
    case BarcodeType of
      DIO_BARCODE_DEVICE_PDF417     : Result := 0;
      DIO_BARCODE_DEVICE_DATAMATRIX : Result := 1;
      DIO_BARCODE_DEVICE_AZTEC      : Result := 2;
      DIO_BARCODE_DEVICE_QR         : Result := 3;
      DIO_BARCODE_DEVICE_EGAIS      : Result := $83;
    else
      raise Exception.Create('Invalid barcode type');
    end;
  end;

var
  TickCount: Integer;
  ABarcode: TBarcodeRec;
begin
  ABarcode := Barcode;
  Logger.Debug('PrintBarcode2');
  TickCount := GetTickCount;

  if ABarcode.BarcodeType = DIO_BARCODE_EAN13_INT then
  begin
    PrintBarcodeEAN13(ABarcode);
  end else
  begin
    if not FCapBarcode2D then
    begin
      if ABarcode.BarcodeType = DIO_BARCODE_QRCODE3 then
      begin
        PrintQRCode3(ABarcode);
      end else
      begin
        PrintBarcodeZInt(ABarcode);
      end;
    end else
    begin
      case ABarcode.BarcodeType of
        DIO_BARCODE_EAN13_INT: PrintBarcodeEAN13(ABarcode);
        DIO_BARCODE_QRCODE:
          Check(PrintQRCode2D(ABarcode));

        DIO_BARCODE_QRCODE2,
        DIO_BARCODE_QRCODE4:
        begin
          ABarcode.Data := ABarcode.Data + ' ' + ABarcode.Text;
          ABarcode.Text := '';
          Check(PrintQRCode2D(ABarcode))
        end;
        DIO_BARCODE_DEVICE_PDF417,
        DIO_BARCODE_DEVICE_DATAMATRIX,
        DIO_BARCODE_DEVICE_AZTEC,
        DIO_BARCODE_DEVICE_QR,
        DIO_BARCODE_DEVICE_EGAIS:
        begin
          ABarcode.BarcodeType := IntTo2DBarcodeType(ABarcode.BarcodeType);
          Check(PrintBarcode2D_2(ABarcode));
        end;
      else
        PrintBarcodeZInt(ABarcode);
      end;
    end;
  end;
  Logger.Debug('PrintBarcode2.OK');
  Logger.Debug(Format('Barcode printed in %d ms', [Integer(GetTickCount) - TickCount]));
  WaitForPrinting;
end;

function TFiscalPrinterDevice.LoadBarcodeData(BlockType: Integer;
  const Barcode: WideString): Integer;
const
  DATA_BLOCK_SIZE = 64;
var
  i: Integer;
  Count: Integer;
  Block: TBarcode2DData;
begin
  Result := 0;
  Count := (Length(Barcode) + DATA_BLOCK_SIZE -1) div DATA_BLOCK_SIZE;
  for i := 0 to Count-1 do
  begin
    Block.BlockType := BlockType;
    Block.BlockNumber := i;
    Block.BlockData := Copy(Barcode, 1 + i * DATA_BLOCK_SIZE, DATA_BLOCK_SIZE);
    Result := LoadBarcode2D(Block);
    if Result <> 0 then Exit;
  end;
end;

function TFiscalPrinterDevice.PrintQRCode2D(Barcode: TBarcodeRec): Integer;
var
  Barcode2D: TBarcode2D;
begin
  Barcode.Data := Barcode.Data + #0;
  Result := LoadBarcodeData(0, Barcode.Data);
  if Result <> 0 then Exit;

  case Barcode.BarcodeType of
    DIO_BARCODE_QRCODE: Barcode2D.BarcodeType := 3;
    DIO_BARCODE_QRCODE2: Barcode2D.BarcodeType := $83;
    DIO_BARCODE_QRCODE3: Barcode2D.BarcodeType := $83;
    DIO_BARCODE_QRCODE4: Barcode2D.BarcodeType := $C3;
  else
    Barcode2D.BarcodeType := 3;
  end;
  Barcode2D.DataLength := Length(Barcode.Data);
  Barcode2D.BlockNumber := 0;
  Barcode2D.Parameter1 := Barcode.Parameter1;
  Barcode2D.Parameter2 := Barcode.Parameter2;
  Barcode2D.Parameter3 := Barcode.ModuleWidth;
  Barcode2D.Parameter4 := 0;
  Barcode2D.Parameter5 := Barcode.Parameter3;
  Barcode2D.Alignment := IntToAlignment(Barcode.Alignment);
  Result := PrintBarcode2D(Barcode2D);
end;

function TFiscalPrinterDevice.DrawScale(const P: TDrawScale): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
  LastLine: Integer;
begin
  LastLine := P.LastLine;
  if GetPrinterModel.Data.ID in [7, 14] then
  begin
    LastLine := LastLine - 1;
  end;

  Command := #$4F +
    IntToBin(GetUsrPassword, 4) +
    Chr(P.FirstLine) +
    Chr(LastLine) +
    Chr(P.VScale) +
    Chr(P.HScale);
  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.GetStartLine: Integer;
begin
  Result := 1;
  if Parameters.IsLogoLoaded and (Parameters.LogoSize > 0) then
  begin
    Result := Parameters.LogoSize + 1;
  end;
end;

function TFiscalPrinterDevice.Is1DBarcode(Symbology: Integer): Boolean;
begin
  Result := not Is2DBarcode(Symbology);
end;

function TFiscalPrinterDevice.Is2DBarcode(Symbology: Integer): Boolean;
begin
  Result := Symbology in [
    DIO_BARCODE_QRCODE,
    DIO_BARCODE_QRCODE2,
    DIO_BARCODE_QRCODE3,
    DIO_BARCODE_QRCODE4,
    DIO_BARCODE_AZTEC,
    DIO_BARCODE_MICROQR,
    DIO_BARCODE_AZRUNE,
    DIO_BARCODE_PDF417,
    DIO_BARCODE_PDF417TRUNC,
    DIO_BARCODE_MICROPDF417,
    DIO_BARCODE_MAXICODE,
    DIO_BARCODE_DATAMATRIX
  ];
end;

function GetZIntBarcodeType(DIOBarcodeType: Integer): TZBType;
begin
  Result := tBARCODE_CODE11;
  case DIOBarcodeType of
    DIO_BARCODE_EAN13_INT           : Result := tBARCODE_EANX;
    DIO_BARCODE_CODE128A            : Result := tBARCODE_CODE128;
    DIO_BARCODE_CODE128B            : Result := tBARCODE_CODE128B;
    DIO_BARCODE_CODE128C            : Result := tBARCODE_CODE128;
    DIO_BARCODE_CODE39              : Result := tBARCODE_CODE39;
    DIO_BARCODE_CODE25INTERLEAVED   : Result := tBARCODE_C25INTER;
    DIO_BARCODE_CODE25INDUSTRIAL    : Result := tBARCODE_C25IND;
    DIO_BARCODE_CODE25MATRIX        : Result := tBARCODE_C25MATRIX;
    DIO_BARCODE_CODE39EXTENDED      : Result := tBARCODE_EXCODE39;
    DIO_BARCODE_CODE93              : Result := tBARCODE_CODE93;
    DIO_BARCODE_CODE93EXTENDED      : Result := tBARCODE_CODE93;
    DIO_BARCODE_MSI                 : Result := tBARCODE_MSI_PLESSEY;
    DIO_BARCODE_POSTNET             : Result := tBARCODE_POSTNET;
    DIO_BARCODE_CODABAR             : Result := tBARCODE_CODABAR;
    DIO_BARCODE_EAN8                : Result := tBARCODE_EANX;
    DIO_BARCODE_EAN13               : Result := tBARCODE_EANX;
    DIO_BARCODE_UPC_A               : Result := tBARCODE_UPCA;
    DIO_BARCODE_UPC_E0              : Result := tBARCODE_UPCE;
    DIO_BARCODE_UPC_E1              : Result := tBARCODE_UPCE;
    DIO_BARCODE_UPC_S2              : Result := tBARCODE_UPCE;
    DIO_BARCODE_UPC_S5              : Result := tBARCODE_UPCE;
    DIO_BARCODE_EAN128A             : Result := tBARCODE_EAN128;
    DIO_BARCODE_EAN128B             : Result := tBARCODE_EAN128;
    DIO_BARCODE_EAN128C             : Result := tBARCODE_EAN128;

    DIO_BARCODE_CODE11              : Result := tBARCODE_CODE11;
    DIO_BARCODE_C25IATA             : Result := tBARCODE_C25IATA;
    DIO_BARCODE_C25LOGIC            : Result := tBARCODE_C25LOGIC;
    DIO_BARCODE_DPLEIT              : Result := tBARCODE_DPLEIT;
    DIO_BARCODE_DPIDENT             : Result := tBARCODE_DPIDENT;
    DIO_BARCODE_CODE16K             : Result := tBARCODE_CODE16K;
    DIO_BARCODE_CODE49              : Result := tBARCODE_CODE49;
    DIO_BARCODE_FLAT                : Result := tBARCODE_FLAT;
    DIO_BARCODE_RSS14               : Result := tBARCODE_RSS14;
    DIO_BARCODE_RSS_LTD             : Result := tBARCODE_RSS_LTD;
    DIO_BARCODE_RSS_EXP             : Result := tBARCODE_RSS_EXP;
    DIO_BARCODE_TELEPEN             : Result := tBARCODE_TELEPEN;
    DIO_BARCODE_FIM                 : Result := tBARCODE_FIM;
    DIO_BARCODE_LOGMARS             : Result := tBARCODE_LOGMARS;
    DIO_BARCODE_PHARMA              : Result := tBARCODE_PHARMA;
    DIO_BARCODE_PZN                 : Result := tBARCODE_PZN;
    DIO_BARCODE_PHARMA_TWO          : Result := tBARCODE_PHARMA_TWO;
    DIO_BARCODE_PDF417              : Result := tBARCODE_PDF417;
    DIO_BARCODE_PDF417TRUNC         : Result := tBARCODE_PDF417TRUNC;
    DIO_BARCODE_MAXICODE            : Result := tBARCODE_MAXICODE;
    DIO_BARCODE_QRCODE              : Result := tBARCODE_QRCODE;
    DIO_BARCODE_QRCODE2             : Result := tBARCODE_QRCODE;
    DIO_BARCODE_QRCODE3             : Result := tBARCODE_QRCODE;
    DIO_BARCODE_AUSPOST             : Result := tBARCODE_AUSPOST;
    DIO_BARCODE_AUSREPLY            : Result := tBARCODE_AUSREPLY;
    DIO_BARCODE_AUSROUTE            : Result := tBARCODE_AUSROUTE;
    DIO_BARCODE_AUSREDIRECT         : Result := tBARCODE_AUSREDIRECT;
    DIO_BARCODE_ISBNX               : Result := tBARCODE_ISBNX;
    DIO_BARCODE_RM4SCC              : Result := tBARCODE_RM4SCC;
    DIO_BARCODE_DATAMATRIX          : Result := tBARCODE_DATAMATRIX;
    DIO_BARCODE_EAN14               : Result := tBARCODE_EAN14;
    DIO_BARCODE_CODABLOCKF          : Result := tBARCODE_CODABLOCKF;
    DIO_BARCODE_NVE18               : Result := tBARCODE_NVE18;
    DIO_BARCODE_JAPANPOST           : Result := tBARCODE_JAPANPOST;
    DIO_BARCODE_KOREAPOST           : Result := tBARCODE_KOREAPOST;
    DIO_BARCODE_RSS14STACK          : Result := tBARCODE_RSS14STACK;
    DIO_BARCODE_RSS14STACK_OMNI     : Result := tBARCODE_RSS14STACK_OMNI;
    DIO_BARCODE_RSS_EXPSTACK        : Result := tBARCODE_RSS_EXPSTACK;
    DIO_BARCODE_PLANET              : Result := tBARCODE_PLANET;
    DIO_BARCODE_MICROPDF417         : Result := tBARCODE_MICROPDF417;
    DIO_BARCODE_ONECODE             : Result := tBARCODE_ONECODE;
    DIO_BARCODE_PLESSEY             : Result := tBARCODE_PLESSEY;
    DIO_BARCODE_TELEPEN_NUM         : Result := tBARCODE_TELEPEN_NUM;
    DIO_BARCODE_ITF14               : Result := tBARCODE_ITF14;
    DIO_BARCODE_KIX                 : Result := tBARCODE_KIX;
    DIO_BARCODE_AZTEC               : Result := tBARCODE_AZTEC;
    DIO_BARCODE_DAFT                : Result := tBARCODE_DAFT;
    DIO_BARCODE_MICROQR             : Result := tBARCODE_MICROQR;
    DIO_BARCODE_HIBC_128            : Result := tBARCODE_HIBC_128;
    DIO_BARCODE_HIBC_39             : Result := tBARCODE_HIBC_39;
    DIO_BARCODE_HIBC_DM             : Result := tBARCODE_HIBC_DM;
    DIO_BARCODE_HIBC_QR             : Result := tBARCODE_HIBC_QR;
    DIO_BARCODE_HIBC_PDF            : Result := tBARCODE_HIBC_PDF;
    DIO_BARCODE_HIBC_MICPDF         : Result := tBARCODE_HIBC_MICPDF;
    DIO_BARCODE_HIBC_BLOCKF         : Result := tBARCODE_HIBC_BLOCKF;
    DIO_BARCODE_HIBC_AZTEC          : Result := tBARCODE_HIBC_AZTEC;
    DIO_BARCODE_AZRUNE              : Result := tBARCODE_AZRUNE;
    DIO_BARCODE_CODE32              : Result := tBARCODE_CODE32;
    DIO_BARCODE_EANX_CC             : Result := tBARCODE_EANX_CC;
    DIO_BARCODE_EAN128_CC           : Result := tBARCODE_EAN128_CC;
    DIO_BARCODE_RSS14_CC            : Result := tBARCODE_RSS14_CC;
    DIO_BARCODE_RSS_LTD_CC          : Result := tBARCODE_RSS_LTD_CC;
    DIO_BARCODE_RSS_EXP_CC          : Result := tBARCODE_RSS_EXP_CC;
    DIO_BARCODE_UPCA_CC             : Result := tBARCODE_UPCA_CC;
    DIO_BARCODE_UPCE_CC             : Result := tBARCODE_UPCE_CC;
    DIO_BARCODE_RSS14STACK_CC       : Result := tBARCODE_RSS14STACK_CC;
    DIO_BARCODE_RSS14_OMNI_CC       : Result := tBARCODE_RSS14_OMNI_CC;
    DIO_BARCODE_RSS_EXPSTACK_CC     : Result := tBARCODE_RSS_EXPSTACK_CC;
    DIO_BARCODE_CHANNEL             : Result := tBARCODE_CHANNEL;
    DIO_BARCODE_CODEONE             : Result := tBARCODE_CODEONE;
    DIO_BARCODE_GRIDMATRIX          : Result := tBARCODE_GRIDMATRIX;
  else
    raiseExceptionFmt('%s, %d', [_('Invalid barcode type'), DIOBarcodeType]);
  end;
end;

function IsPDF417(BarcodeType: Integer): Boolean;
begin
  Result := BarcodeType in [DIO_BARCODE_PDF417,
    DIO_BARCODE_PDF417TRUNC, DIO_BARCODE_MICROPDF417];
end;

procedure RenderBarcode(Bitmap: TBitmap; Symbol: PZSymbol; Is1D: Boolean);
var
  B: Byte;
  X, Y: Integer;
begin
  Bitmap.Monochrome := True;
  Bitmap.PixelFormat := pf1Bit;
  Bitmap.Width := Symbol.width;
  if Is1D then
    Bitmap.Height := Symbol.Height
  else
    Bitmap.Height := Symbol.rows;

  for X := 0 to Symbol.width-1 do
  for Y := 0 to Symbol.Height-1 do
  begin
    Bitmap.Canvas.Pixels[X, Y] := clWhite;
    if Is1D then
      B := Byte(Symbol.encoded_data[0][X div 7])
    else
      B := Byte(Symbol.encoded_data[Y][X div 7]);

    if (B and (1 shl (X mod 7))) <> 0 then
      Bitmap.Canvas.Pixels[X, Y] := clBlack;
  end;
end;

procedure ScaleBitmap(Bitmap: TBitmap; Xscale, YSCale: Integer);
var
  P: TPoint;
  DstBitmap: TBitmap;
begin
  DstBitmap := TBitmap.Create;
  try
    DstBitmap.Monochrome := True;
    DstBitmap.PixelFormat := pf1Bit;
    P.X := Bitmap.Width * XScale;
    P.Y := Bitmap.Height * YScale;
    DstBitmap.Width := P.X;
    DstBitmap.Height := P.Y;
    DstBitmap.Canvas.StretchDraw(Rect(0, 0, P.X, P.Y), Bitmap);
    Bitmap.Assign(DstBitmap);
  finally
    DstBitmap.Free;
  end;
end;

procedure TFiscalPrinterDevice.AlignBitmap(Bitmap: TBitmap;
  const Barcode: TBarcodeRec; HScale: Integer; PrintWidthInDots: Integer);
var
  Bmp: TBitmap;
  XOffset: Integer;
begin
  if Barcode.Alignment = BARCODE_ALIGNMENT_LEFT then Exit;
  if HScale = 0 then
    raiseException('HScale = 0');
  PrintWidthInDots := PrintWidthInDots div HScale;

  XOffset := 0;
  case Barcode.Alignment of
    BARCODE_ALIGNMENT_CENTER:
    begin
      XOffset := (PrintWidthInDots - Bitmap.Width) div 2;
    end;
    BARCODE_ALIGNMENT_RIGHT:
    begin
      XOffset := PrintWidthInDots - Bitmap.Width;
    end;
  end;
  Bmp := TBitmap.Create;
  try
    Bmp.Monochrome := True;
    Bmp.PixelFormat := pf1Bit;
    Bmp.Width := Bitmap.Width + XOffset;
    Bmp.Height := Bitmap.Height;
    Bmp.Canvas.Draw(XOffset, 0, Bitmap);
    Bitmap.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

function TFiscalPrinterDevice.GetMaxGraphicsHeight: Integer;
begin
  Result := 0;
  if FCapGraphics1 then
    Result := 200;
  if FCapGraphics2 then
    Result := 1200;
  if FCapGraphics512 then
    Result := 600;
end;

function TFiscalPrinterDevice.GetMaxGraphicsWidth: Integer;
begin
  Result := 0;
  if ValidFont(1) then
    Result := FFontInfo[0].PrintWidth;
end;

function TFiscalPrinterDevice.GetMaxGraphicsWidthInBytes: Integer;
begin
  Result := GetMaxGraphicsWidth div 8;
end;

procedure TFiscalPrinterDevice.PrintQRCode3(Barcode: TBarcodeRec);

  procedure DrawQRCodeText(URL, Sign: AnsiString; Bitmap: TBitmap;
    BitmapWidth: Integer);
  var
    Y: Integer;
    Bits: TBits;
    i, j, k: Integer;
    Line: AnsiString;
    Lines: TTntStrings;
    LineLength: Integer;
    CharLine: Integer;
  begin
    Bitmap.Canvas.Brush.Style := bsSolid;

    LineLength := 35;
    Bits := TBits.Create;
    Lines := TTntStringList.Create;
    try
      while Length(URL) > 0 do
      begin
        Lines.Add(Copy(URL, 1, LineLength));
        URL := Copy(URL, LineLength+1, Length(URL));
      end;
      while Length(Sign) > 0 do
      begin
        Lines.Add(Copy(Sign, 1, LineLength));
        Sign := Copy(Sign, LineLength+1, Length(Sign));
      end;
      for i := 0 to Lines.Count-1 do
      begin
        Line := Lines[i];
        for k := 0 to 13 do
        begin
          Y := k + 18*i;
          if Y > Bitmap.Height then Break;

          Bits.Clear;
          for j := 1 to Length(Line) do
          begin
            CharLine := cFont14x8[Ord(Line[j]) * FONT_5_HEIGHT + k];
            Bits.add(CharLine, 8);
            Bits.add(0, 2);
          end;
          Bits.UpdateBytes;
          for j := 0 to Bits.SizeInBytes-1 do
          begin
            PByteArray(Bitmap.ScanLine[Y])[j] := Bits.Bytes(j) xor $FF;
          end;
        end;
      end;
    finally
      Bits.Free;
      Lines.Free;
    end;
  end;

var
  P: Integer;
  URLText: AnsiString;
  SignText: AnsiString;
  Bitmap: TBitmap;
  StartLine: Integer;
  BitmapWidth: Integer;
  Render: TZintBarcode;
  MaxGraphicsWidth: Integer;
  MaxGraphicsHeight: Integer;
  Graphics3: TPrintGraphics3;
begin
  SignText := '';
  URLText := Barcode.Data;
  P := Pos(' ', Barcode.Data);
  if P <> 0 then
  begin
    URLText := Copy(Barcode.Data, 1, P-1);
    SignText := Copy(Barcode.Data, P+1, Length(Barcode.Data));
  end;
  Barcode.Data := URLText;
  Barcode.Alignment := BARCODE_ALIGNMENT_RIGHT;
  MaxGraphicsHeight := GetMaxGraphicsHeight;
  MaxGraphicsWidth := GetMaxGraphicsWidth;

  Bitmap := TBitmap.Create;
  Render := TZintBarcode.Create;
  try
    Render.BorderWidth := 0;
    Render.FGColor := clBlack;
    Render.BGColor := clWhite;
    Render.Scale := 1;
    Render.Height := Barcode.Height;
    Render.BarcodeType := GetZIntBarcodeType(Barcode.BarcodeType);
    Render.Data := Barcode.Data;
    Render.ShowHumanReadableText := False;
    Render.EncodeNow;
    RenderBarcode(Bitmap, Render.Symbol, Is1DBarcode(Barcode.BarcodeType));

    ScaleBitmap(Bitmap, Barcode.ModuleWidth, Barcode.ModuleWidth);


    if Bitmap.Width > MaxGraphicsWidth then
      raiseExceptionFmt('%s, %d > %d', [_('Bitmap width more than maximum'),
        Bitmap.Width, MaxGraphicsWidth]);

    if Bitmap.Height > MaxGraphicsHeight then
      raiseExceptionFmt('%s, %d > %d', [_('Bitmap height more than maximum'),
        Bitmap.Height, MaxGraphicsHeight]);

    BitmapWidth := Bitmap.Width;
    AlignBitmap(Bitmap, Barcode, 1, MaxGraphicsWidth);

    DrawQRCodeText(URLText, SignText, Bitmap, BitmapWidth);

    StartLine := GetStartLine;
    LoadBitmap(StartLine, Bitmap);
    if FCapGraphics512 then
    begin
      Graphics3.FirstLine := StartLine;
      Graphics3.LastLine := StartLine + Bitmap.Height -1;
      Graphics3.VScale := 1;
      Graphics3.HScale := 1;
      Graphics3.Flags := PRINTER_STATION_REC;
      Check(PrintGraphics3(Graphics3));
    end else
    begin
      Check(PrintGraphics(StartLine, Bitmap.Height + StartLine));
    end;
  finally
    Render.Free;
    Bitmap.Free;
  end;
end;

procedure TFiscalPrinterDevice.PrintBarcodeZInt(const Barcode: TBarcodeRec);
var
  P: TDrawScale;
  Bitmap: TBitmap;
  StartLine: Integer;
  ModuleWidth: Integer;
  Render: TZintBarcode;
  VScale, HScale: Integer;
  MaxGraphicsWidth: Integer;
  MaxGraphicsHeight: Integer;
  Graphics3: TPrintGraphics3;
begin
  MaxGraphicsHeight := GetMaxGraphicsHeight;
  MaxGraphicsWidth := GetMaxGraphicsWidth;
  if Is2DBarcode(Barcode.BarcodeType) or (not FCapBarLine) then
  begin
    if FCapGraphics512 then
    begin
      MaxGraphicsWidth := Min(512, MaxGraphicsWidth);
    end else
    begin
      if not FCapScaleGraphics then
      begin
        MaxGraphicsWidth := 320;
      end;
    end;
  end;

  ModuleWidth := Barcode.ModuleWidth;
  StartLine := GetStartLine;

  Bitmap := TBitmap.Create;
  Render := TZintBarcode.Create;
  try
    Render.BorderWidth := 0;
    Render.FGColor := clBlack;
    Render.BGColor := clWhite;
    Render.Scale := 1;
    Render.Height := Barcode.Height;
    Render.BarcodeType := GetZIntBarcodeType(Barcode.BarcodeType);
    Render.Data := Barcode.Data;
    Render.ShowHumanReadableText := False;
    Render.EncodeNow;
    RenderBarcode(Bitmap, Render.Symbol, Is1DBarcode(Barcode.BarcodeType));

    VScale := 1;
    HScale := ModuleWidth;
    if Is2DBarcode(Barcode.BarcodeType) then
    begin
      if Model.ID <> 19 then
      begin
        VScale := 1;
        HScale := 1;
        ScaleBitmap(Bitmap, ModuleWidth, ModuleWidth);
      end else
      begin
        if IsPDF417(Barcode.BarcodeType) then
          VScale := ModuleWidth*3
        else
          VScale := ModuleWidth;
      end;
    end;

    if Is1DBarcode(Barcode.BarcodeType)and FCapBarLine then
    begin
      ScaleBitmap(Bitmap, HScale, 1);
      HScale := 1;
    end else
    begin
      if not FCapGraphics512 then
      begin
        if FCapScaleGraphics then
        begin
          ScaleBitmap(Bitmap, HScale, 1);
        end else
        begin
          ScaleBitmap(Bitmap, HScale, VScale);
          VScale := 1;
        end;
        HScale := 1;
      end;
    end;

    if Bitmap.Width > MaxGraphicsWidth then
      raiseExceptionFmt('%s, %d > %d', [_('Bitmap width more than maximum'),
        Bitmap.Width, MaxGraphicsWidth]);

    if Bitmap.Height > MaxGraphicsHeight then
      raiseExceptionFmt('%s, %d > %d', [_('Bitmap height more than maximum'),
        Bitmap.Height, MaxGraphicsHeight]);

    AlignBitmap(Bitmap, Barcode, HScale, MaxGraphicsWidth);

    if Is1DBarcode(Barcode.BarcodeType) then
    begin
      if FCapBarLine then
      begin
        PrintBarLine(Barcode.Height, GetLineData(Bitmap, 0));
      end else
      begin
        LoadBitmap(StartLine, Bitmap);
        Check(PrintGraphics(StartLine, Bitmap.Height + StartLine));
      end;
    end else
    begin
      LoadBitmap(StartLine, Bitmap);
      if FCapGraphics512 then
      begin
        Graphics3.FirstLine := StartLine;
        Graphics3.LastLine := StartLine + Bitmap.Height -1;
        Graphics3.VScale := VScale;
        Graphics3.HScale := HScale;
        Graphics3.Flags := PRINTER_STATION_REC;
        Check(PrintGraphics3(Graphics3));
      end else
      begin
        if FCapScaleGraphics then
        begin
          P.FirstLine := StartLine;
          P.LastLine := StartLine + Bitmap.Height;
          P.VScale := VScale;
          P.HScale := 0;
          Check(DrawScale(P));
        end else
        begin
          Check(PrintGraphics(StartLine, Bitmap.Height + StartLine));
        end;
      end;
    end;
  finally
    Render.Free;
    Bitmap.Free;
  end;
end;

procedure TFiscalPrinterDevice.PrintImage(const FileName: WideString;
  StartLine: Integer);
var
  ImageHeight: Integer;
begin
  ImageHeight := LoadImage(FileName, StartLine);
  Check(PrintGraphics(StartLine, StartLine + ImageHeight - 1));
end;

procedure TFiscalPrinterDevice.PrintImageScale(const FileName: WideString;
  StartLine, Scale: Integer);
var
  Bitmap: TBitmap;
  Picture: TPicture;
  P: TPrintGraphics3;
begin
  if not(Scale in [1..10]) then
    Scale := 1;

  Bitmap := TBitmap.Create;
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(FileName);

    Bitmap.PixelFormat := pf1Bit;
    Bitmap.Monochrome := True;
    Bitmap.Width := Picture.Width;
    Bitmap.Height := Picture.Height;
    Bitmap.Canvas.Draw(0, 0, Picture.Graphic);

    if FCapGraphics512 then
    begin
      LoadBitmap512(StartLine, Bitmap, Scale);
    end else
    begin
      LoadBitmap320(StartLine, Bitmap);
    end;

    if FCapGraphics512 then
    begin
      P.FirstLine := StartLine;
      P.LastLine := StartLine + Bitmap.Height-1;
      P.VScale := Scale;
      P.HScale := Scale;
      P.Flags := PRINTER_STATION_REC;
      Check(PrintGraphics3(P));
    end else
    begin
      Check(PrintGraphics(StartLine, StartLine + Bitmap.Height-1));
    end;
  finally
    Bitmap.Free;
    Picture.Free;
  end;
end;

procedure AlignBitmapWidth(Bitmap: TBitmap; const NewWidth: Integer);
var
  NewHeight: Integer;
begin
  if Bitmap.Width = 0 then
    raiseException('Bitmap.Width = 0');

  NewHeight := Trunc(Bitmap.Height*(NewWidth/Bitmap.Width));
  Bitmap.Canvas.StretchDraw(
    Rect(0, 0, NewWidth, NewHeight),
    Bitmap);
  Bitmap.Width := NewWidth;
  Bitmap.Height := NewHeight;
end;

function IsInversedPalette(Bitmap: TBitmap): Boolean;
var
  PaletteSize: Integer;
  PalEntry: TPaletteEntry;
begin
  Result := False;
  if Bitmap.Palette <> 0 then
  begin
    PaletteSize := 0;
    if GetObject(Bitmap.Palette, SizeOf(PaletteSize), @PaletteSize) = 0 then Exit;
    if PaletteSize = 0 then Exit;
    GetPaletteEntries(Bitmap.Palette, 0, 1, PalEntry);
    Result := (PalEntry.peRed = $FF)and(PalEntry.peGreen = $FF)and(PalEntry.peBlue = $FF);
  end;
end;

function Inverse(const S: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + Chr(Ord(S[i]) xor $FF);
end;

function TFiscalPrinterDevice.GetLineData(Bitmap: TBitmap; Index: Integer): AnsiString;
var
  B: Byte;
  i: Integer;
  Len: Integer;
const
  Mask: array [0..7] of Byte = ($FF, $80, $C0, $E0, $F0, $F8, $FC, $FE);
begin
  Result := '';
  Len := (Bitmap.Width + 7 )div 8;
  for i := 0 to Len-1 do
  begin
    B := $FF - PByteArray(Bitmap.ScanLine[Index])[i];
    if i = (Len-1) then
      B := B and Mask[Bitmap.Width mod 8];
    Result := Result + Chr(SwapByte(B));
  end;

  // If palette is inverse
  if IsInversedPalette(Bitmap) then
    Result := Inverse(Result);
end;

procedure TFiscalPrinterDevice.ProgressEvent(Progress: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Progress);
end;

procedure TFiscalPrinterDevice.LoadBitmap(StartLine: Integer; Bitmap: TBitmap);
begin
  Bitmap.Monochrome := True;
  Bitmap.PixelFormat := pf1Bit;

  if Bitmap.Height = 0 then
    raiseException(_('Image height is zero, must be > 0'));

  if Bitmap.Width = 0 then
    raiseException(_('Image width is zero, must be > 0'));

  if Bitmap.Width > GetMaxGraphicsWidth then
    AlignBitmapWidth(Bitmap, GetMaxGraphicsWidth);

  Bitmap.Height := Min(Bitmap.Height, GetMaxGraphicsHeight);
  if FCapGraphics512 then
  begin
    LoadBitmap512(StartLine, Bitmap, 1);
  end else
  begin
    LoadBitmap320(StartLine, Bitmap);
  end;
end;

procedure TFiscalPrinterDevice.LoadBitmap320(StartLine: Integer; Bitmap: TBitmap);
var
  i: Integer;
  Data: AnsiString;
  Count: Integer;
  Progress: Integer;
  NewProgress: Integer;
  ProgressStep: Double;
begin
  Progress := 0;
  Count := Bitmap.Height;
  ProgressStep := Bitmap.Height/100;
  for i := 0 to Count-1 do
  begin
    Data := GetLineData(Bitmap, i);
    Data := GetDataBlock(Data, 40, 40);
    Check(LoadGraphics(i+ StartLine, Data));
    NewProgress := 0;
    if ProgressStep <> 0 then
      NewProgress := Round(i/ProgressStep);

    if (NewProgress <> Progress)and(NewProgress <= 100) then
    begin
      Progress := NewProgress;
      ProgressEvent(NewProgress);
    end;
  end;
  ProgressEvent(100);
end;

procedure TFiscalPrinterDevice.LoadBitmap512(StartLine: Integer;
  Bitmap: TBitmap; Scale: Integer);
var
  i, j: Integer;
  Line: AnsiString;
  Row: Integer;
  Answer: AnsiString;
  Command: AnsiString;
  Progress: Integer;
  NewProgress: Integer;
  ProgressStep: Double;
  CommandCount: Integer;
  RowsPerCommand: Integer;
  LineLength: Integer;
  RowCount: Integer;
const
  BytesPerCommand = 240;
begin
  Progress := 0;
  LineLength := (Bitmap.Width + 7) div 8;
  RowsPerCommand := 0;
  if LineLength <> 0 then
    RowsPerCommand := BytesPerCommand div LineLength;
  if RowsPerCommand = 0 then
    raiseException('RowsPerCommand = 0');
  CommandCount := (Bitmap.Height + RowsPerCommand -1) div RowsPerCommand;
  ProgressStep := CommandCount/100;
  Row := 0;
  for i := 0 to CommandCount-1 do
  begin
    Line := '';
    RowCount := 0;
    for j := 0 to RowsPerCommand-1 do
    begin
      Line := Line + GetLineData(Bitmap, Row);
      Inc(Row);
      Inc(RowCount);
      if Row >= Bitmap.Height then Break;
    end;
    Command := #$4E + IntToBin(GetUsrPassword, 4) + Chr(LineLength) +
      IntToBin(StartLine, 2) + IntToBin(RowCount, 2) + #1 + Line;

    Check(ExecuteData(Command, Answer));
    Inc(StartLine, RowsPerCommand);
    NewProgress := 0;
    if ProgressStep <> 0 then
      NewProgress := Round(i/ProgressStep);
    if (NewProgress <> Progress)and(NewProgress <= 100) then
    begin
      Progress := NewProgress;
      ProgressEvent(NewProgress);
    end;
  end;
  ProgressEvent(100);
end;

function TFiscalPrinterDevice.LoadImage(const FileName: WideString;
  StartLine: Integer): Integer;
var
  Picture: TPicture;
begin
  Picture := TPicture.Create;
  try
    Picture.LoadFromFile(FileName);
    Result := LoadPicture(Picture, StartLine);
  finally
    Picture.Free;
  end;
end;

function TFiscalPrinterDevice.LoadPicture(Picture: TPicture;
  StartLine: Integer): Integer;
var
  Bitmap: TBitmap;
  XOffset: Integer;
begin
  XOffset := 0;
  if Parameters.LogoCenter then
  begin
    XOffset := (GetMaxGraphicsWidth - Picture.Width) div 2;
  end;

  Bitmap := TBitmap.Create;
  try
    Bitmap.PixelFormat := pf1Bit;
    Bitmap.Monochrome := True;
    Bitmap.Width := Picture.Width + XOffset;
    Bitmap.Height := Picture.Height;
    Bitmap.Canvas.Draw(XOffset, 0, Picture.Graphic);


    LoadBitmap(StartLine, Bitmap);
    Result := Bitmap.Height;
  finally
    Bitmap.Free;
  end;
end;

function IntToFFDVersion(Value: Integer): TFFDVersion;
begin
  case Value of
    1: Result := ffd10;
    2: Result := ffd105;
    3: Result := ffd11;
    4: Result := ffd12;
  else
    Result := ffdUnknown;
  end;
end;

// 17,1,17,1,0,4,4,'Rus ������ ��','4'
function TFiscalPrinterDevice.GetFFDVersion: TFFDVersion;
begin
  if FFFDVersion = TFFDVersion(-1) then
    FFFDVersion := IntToFFDVersion(ReadTableInt(17,1,17));
  Result := FFFDVersion;
end;

procedure TFiscalPrinterDevice.Connect;
begin
  GetDeviceMetrics;
end;

procedure TFiscalPrinterDevice.UpdateInfo;
begin
  GetPrinterModel;
  FCapParameters2 := ReadParameters2(FParameters2) = 0;
  if FCapParameters2 then
  begin
    FCapGraphics512 := FParameters2.Flags.CapGraphics512;
    FCapScaleGraphics := FParameters2.Flags.CapScaleGraphics;

    FModelData.CapCoverSensor := FParameters2.Flags.CapCoverSensor;
    FModelData.CapJrnPresent := FParameters2.Flags.CapJrnPresent;
    FModelData.CapJrnEmptySensor := FParameters2.Flags.CapJrnEmptySensor;
    FModelData.CapJrnNearEndSensor := FParameters2.Flags.CapJrnNearEndSensor;
    FModelData.CapRecEmptySensor := FParameters2.Flags.CapRecEmptySensor;
    FModelData.CapRecNearEndSensor := FParameters2.Flags.CapRecNearEndSensor;
    FModelData.CapSlpEmptySensor := FParameters2.Flags.CapSlpEmptySensor;
    FModelData.CapSlpNearEndSensor := FParameters2.Flags.CapSlpNearEndSensor;
    FModelData.CapSlpPresent := FParameters2.Flags.CapSlpPresent;
    FModelData.CapRecLever := FParameters2.Flags.CapRecLeverSensor;
    FModelData.CapJrnLever := FParameters2.Flags.CapJrnLeverSensor;
  end else
  begin
    FCapGraphics512 := True;
    FCapScaleGraphics := True;
    //FCapGraphics512 := TestCommand($4E);
    //FCapScaleGraphics := TestCommand($4F);
  end;
  FCapFooterFlag := FCapParameters2 and FParameters2.Flags.CapFlagsGraphicsEx;

  ReadLongStatus;
  FCapBarcode2D := True;
  //FCapBarcode2D := TestCommand($DE);

  FCapFiscalStorage := False;
  if Parameters.ModelId <> MODEL_ID_WEB_CASSA then
    FCapFiscalStorage := ReadCapFiscalStorage;

  FCapFontInfo := True;
  //FCapFontInfo := TestCommand($26);
  if FCapFontInfo then
  begin
    FFontInfo := ReadFontInfoList;
  end;
  FTaxInfo := ReadTaxInfoList;

  if FCapFiscalStorage then
  begin
    FDiscountMode := ReadDiscountMode;
    FDocPrintMode := ReadDocPrintMode;
  end;
  FCapEnablePrint := GetDeviceMetrics.Model <> 19;
  FIsFiscalized := FCapFiscalStorage or (FLongStatus.RegistrationNumber <> 0);
  FCapDiscount := not FCapFiscalStorage;
  FCapSubtotalRound := FCapFiscalStorage;
  FCondensedFont := ReadTableInt(1, 1, PARAMID_CONDENSED_FONT) = 1;
  FHeadToCutterDistanse := ReadTableInt(10, 1, 1);
  FCutterToCombDistanse := ReadTableInt(10, 1, 2);
  if FHeadToCutterDistanse <> 0 then
  begin
    FModelData.NumHeaderLines := FHeadToCutterDistanse div FFontInfo[1].CharHeight;
  end;
end;

function TFiscalPrinterDevice.GetTaxCount: Integer;
begin
  Result := Length(FTaxInfo);
end;

// Read font info
function TFiscalPrinterDevice.ReadFontInfoList: TFontInfoList;
var
  i: Integer;
  FontInfo: TFontInfo;
begin
  SetLength(Result, 0);
  FontInfo := ReadFontInfo(1);
  if FontInfo.FontCount > 0 then
  begin
    SetLength(Result, FontInfo.FontCount);
    Result[0] := FontInfo;
    for i := 2 to FontInfo.FontCount do
    begin
      Result[i-1] := ReadFontInfo(i);
    end;
  end;
end;

// Read tax Info
function TFiscalPrinterDevice.ReadTaxInfoList: TTaxInfoList;
var
  i: Integer;
  Table: TPrinterTableRec;
begin
  SetLength(Result, 0);
  Check(ReadTableStructure(PRINTER_TABLE_TAX, Table));
  if Table.RowCount > 0 then
  begin
    SetLength(Result, Table.RowCount);
    for i := 1 to Table.RowCount do
    begin
      Result[i-1].Rate := ReadTableInt(PRINTER_TABLE_TAX, i, 1);
      Result[i-1].Name := ReadTableStr(PRINTER_TABLE_TAX, i, 2);
    end;
  end;
end;

// Is fiscal printer firmware 2 (Semenov)
function TFiscalPrinterDevice.IsMobilePrinter: Boolean;
begin
  Result := GetDeviceMetrics.Model = 19;
end;

function TFiscalPrinterDevice.GetTaxInfo(Tax: Integer): TTaxInfo;
begin
  Result.Rate := 0;
  Result.Name := '';
  if (Tax >= 1)and(Tax <= Length(FTaxInfo)) then
    Result := FTaxInfo[Tax-1];
end;

function TFiscalPrinterDevice.ReadCapFiscalStorage: Boolean;
var
  R: TFSState;
begin
  try
    Result := FSReadState(R) = 0;
  except
    Result := False;
  end;
end;

function TFiscalPrinterDevice.IsSupported(ResultCode: Integer): Boolean;
begin
  Result := ResultCode <> ERROR_COMMAND_NOT_SUPPORTED;
end;

function TFiscalPrinterDevice.TestCommand(Code: Integer): Boolean;
var
  RxData: AnsiString;
begin
  if Code > $FF then
  begin
    Result := IsSupported(ExecuteData(Chr(Hi(Code)) + Chr(Lo(Code)), RxData));
  end else
  begin
    Result := IsSupported(ExecuteData(Chr(Code), RxData));
  end;
end;

function TFiscalPrinterDevice.WaitForPrinting: TPrinterStatus;
var
  Mode: Byte;
  TryCount: Integer;
  TickCount: Integer;
const
  MaxTryCount = 3;
begin
  Logger.Debug('TSharedPrinter.WaitForPrinting');
  TryCount := 0;
  TickCount := GetTickCount;
  repeat
    if Integer(GetTickCount) > (TickCount + Parameters.StatusTimeout*1000) then
      raiseException(SStatusWaitTimeout);

    Result := ReadPrinterStatus;
    Mode := Result.Mode and $0F;
    case Result.AdvancedMode of
      AMODE_IDLE:
      begin
        case Mode of
          MODE_FULLREPORT,
          MODE_EKLZREPORT,
          MODE_SLPPRINT:
            Sleep(Parameters.StatusInterval);
        else
          Exit;
        end;
      end;

      AMODE_PASSIVE,
      AMODE_ACTIVE:
      begin
        // No receipt paper
        if GetModel.CapRecPresent and Result.Flags.RecEmpty then
          raiseOposFptrRecEmpty;
        // No control paper
        if GetModel.CapJrnPresent and Result.Flags.JrnEmpty then
          raiseOposFptrJrnEmpty;
        // Cover is opened
        if GetModel.CapCoverSensor and Result.Flags.CoverOpened then
          raiseOposFptrCoverOpened;

        raiseOposFptrRecEmpty;
      end;

      AMODE_AFTER:
      begin
        if TryCount > MaxTryCount then
          raiseException(_('Failed to continue print'));
        ContinuePrint;
        Inc(TryCount);
      end;

      AMODE_REPORT,
      AMODE_PRINT:
        Sleep(Parameters.StatusInterval);
    else
      Sleep(Parameters.StatusInterval);
    end;
  until False;
end;

function TFiscalPrinterDevice.GetPrinterStatus: TPrinterStatus;
begin
  Result := FPrinterStatus;
end;

function TFiscalPrinterDevice.ReadPrinterStatus: TPrinterStatus;
begin
  Logger.Debug('TSharedPrinter.ReadPrinterStatus');
  case Parameters.StatusCommand of
    // Driver will select command to read printer status
    StatusCommandDriver:
    begin
      if CapShortEcrStatus then
      begin
        ReadShortStatus;
      end else
      begin
        ReadLongStatus;
      end;
    end;
    // Short status command
    StatusCommandShort: ReadShortStatus;
  else
    // Long status command
    ReadLongStatus;
  end;
  Result := FPrinterStatus;
end;

function TFiscalPrinterDevice.PrintBarLine(Height: Word; Data: AnsiString): Integer;
var
  IsSwapBytes: Boolean;
begin
  case Parameters.BarLineByteMode of
    BarLineByteModeAuto:
    begin
      if FCapParameters2 then
      begin
        IsSwapBytes := not FParameters2.Flags.SwapGraphicsLine;
      end else
      begin
        IsSwapBytes := Model.BarcodeSwapBytes;
      end;
    end;
    BarLineByteModeStraight: IsSwapBytes := False;
    BarLineByteModeReverse: IsSwapBytes := True;
  else
    IsSwapBytes := False;
  end;
  if IsSwapBytes then
  begin
    Data := SwapBytes(Data);
  end;

  Result := PrintGraphicsLine(Height, PRINTER_STATION_REC, Data);
  if Result = 0 then
  begin
    Sleep(Parameters.BarLinePrintDelay);
  end;
end;

function TFiscalPrinterDevice.LoadBarcode2D(const Data: TBarcode2DData): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$DD +
      IntToBin(GetUsrPassword, 4) +
      Chr(Data.BlockType) +
      Chr(Data.BlockNumber) +
      Data.BlockData;
  Result := ExecuteData(Command, Answer);
end;

(*
������ ������������ �����-����
�������: DEH. ����� ���������: 15 ����.
"	������ (4 �����)
"	��� �����-���� (1 ����)
"	����� ������ �����-���� (2 �����) 1...70891
"	����� ���������� ����� ������ (1 ����) 0...127
"	�������� 1 (1 ����)
"	�������� 2 (1 ����)
"	�������� 3 (1 ����)
"	�������� 4 (1 ����)
"	�������� 5 (1 ����)
"	������������ (1 ����)
	�����:		DEH. ����� ���������: 3 ���� ��� 122 ����.
"	��� ������ (1 ����)
"	���������� ����� ��������� (1 ����) 1�30
"	�������� 1 (1 ����) 2
"	�������� 2 (1 ����) 2
"	�������� 3 (1 ����) 2
"	�������� 4 (1 ����) 2
"	�������� 5 (1 ����) 2
"	������ �����-���� (��������������) � ������ (2 �����) 2
"	������ �����-���� (������������) � ������ (2 �����) 2

��� �����-����	�����-���
0	PDF 417
1	DATAMATRIX
2	AZTEC
3	QR code
1312	QR code2

����� ���������	PDF 417	DATAMATRIX	AZTEC	QR Code
1	Number of columns	Encoding scheme	Encoding scheme	Version, 0=auto; 40 (max)
2	Number of rows	Rotate	-	Mask; 8 (max)
3	Width of module	Dot size	Dot size	Dot size; 3...8
4	Module height	Symbol size	Symbol size	-
5	Error correction level	-	Error correction level	Error correction level; 0...3=L,M,Q,H

������������	��� ������������
0	�� ������ ����
1	�� ������
2	�� ������� ����
����������:
1 - � ����������� �� ������ ����������� QR ���� � ���� ������;
2 - ��� ���� �����-���� (QR ���).
*)

function TFiscalPrinterDevice.PrintBarcode2D(const Barcode: TBarcode2D): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  Command := #$DE +
    IntToBin(GetUsrPassword, 4) +
    Chr(Barcode.BarcodeType) +
    IntToBin(Barcode.DataLength, 2) +
    Chr(Barcode.BlockNumber) +
    Chr(Barcode.Parameter1) +
    Chr(Barcode.Parameter2) +
    Chr(Barcode.Parameter3) +
    Chr(Barcode.Parameter4) +
    Chr(Barcode.Parameter5) +
    Chr(Barcode.Alignment);
  Result := ExecuteData(Command, Answer);
end;

(*
�������� �������-512
�������: 	4EH. ����� ���������: 11+X2 ����.
������ ��������� (4 �����)
����� ����� L (1 ����) 1�40 ��� T = 0; 1�643 ��� T = 1
����� ��������� ����� (2 �����) 1�12004 ��� T = 0; 1�6005 ��� T = 1
���������� ����������� ����� N6 (2 �����) 1�12004 ��� T = 0; 1�6005 ��� T = 1
��� ������������ ������ T (1 ����) 0 - ��� ������ [�����������] �������; 1 - ��� ������ �������-512
����������� ���������� (X2 = N * L ����)
�����:		4EH. ����� ���������: 3 �����.
��� ������ (1 ����)
���������� ����� ��������� (1 ����) 1�30
*)

function TFiscalPrinterDevice.LoadGraphics3(Line: Word; Data: AnsiString): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  if Length(Data) > 64 then
    raiseException(_('Image data length > 64 bytes'));

  Command := #$4E + IntToBin(GetUsrPassword, 4) + Chr(Length(Data)) +
    IntToBin(Line, 2) + IntToBin(1, 2) + #1 + Data;
  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.LoadGraphics3(const P: TLoadGraphics3): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$4E + IntToBin(GetUsrPassword, 4) + Chr(Length(P.Data)) +
    IntToBin(P.FirstLineNum, 2) + IntToBin(P.NextLinesNum, 2) +
    #1 + P.Data;
  Result := ExecuteData(Command, Answer);
end;

(*
������ �������-512 � ����������������1
�������:	4DH. ����� ���������: 12 ����.
������ ��������� (4 �����)
��������� ����� (2 �����) 1�600
�������� ����� (2 �����) 1�600
����������� ��������������� ����� �� ��������� (1 ����) 1�255
����������� ��������������� ����� �� ����������� (1 ����) 1�6
����� (1 ����) ��� 0 - ����������� �����2, ��� 1 - ������� �����, ��� 23 - ���������� ��������, ��� 34 - ���� ���; ��� 75 - ���������� ������ �������
�����:		4DH. ����� ���������: 3 �����.
��� ������ (1 ����)
���������� ����� ��������� (1 ����) 1�30
����������:
1 - � ����������� �� ������ ��� (��� ��������� ������ ��� 42, ��. ������� F7H);
2 - � ����������� �� ������ ��� (��� ��������� ������ ��� 20, ��. ������� F7H);
3 - � ����������� �� ������ ��� (��� ��������� ������ ��� 21, ��. ������� F7H);
4 - � ����������� �� ������ ��� (��� ��������� ������ ��� 34, ��. ������� F7H); ���� ��� 7 ���������� � ���������� ��� ������ � ����������� ��������� "������ ���� �� ��������" � ������� 1, �� ������� ����� ����������� ����� ���������� �����; ���� �� ���������� ��� 7, �� ������� ���������� ����������; ��������� ������ ����� ��������� �������� 10H;
*)

function TFiscalPrinterDevice.PrintGraphics3(Line1, Line2: Word): Integer;
var
  P: TPrintGraphics3;
begin
  P.FirstLine := Line1;
  P.LastLine := Line2;
  P.VScale := 1;
  P.HScale := 1;
  P.Flags := PRINTER_STATION_REC;
  Result := PrintGraphics3(P);
end;

function TFiscalPrinterDevice.PrintGraphics3(const P: TPrintGraphics3): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
  Flags: Byte;
begin
  Flags := GetPrintFlags(P.Flags);
  Command := #$4D + IntToBin(GetUsrPassword, 4) +
    IntToBin(P.FirstLine, 2) +
    IntToBin(P.LastLine, 2) +
    Chr(P.VScale) + Chr(P.HScale) + Chr(Flags);
  Result := ExecuteData(Command, Answer);
end;

procedure TFiscalPrinterDevice.CheckGraphicsSize(Line: Word);
begin

end;

function TFiscalPrinterDevice.FilterTLV(Data: AnsiString): AnsiString;
var
  Tag: TTLVTag;
  Item: TTLVItem;
  Tags: TTLVTags;
  IsValid: Boolean;
begin
  Result := '';
  Tags := TTLVTags.Create;
  try
    while TTLVReader.Read(Data, Item) do
    begin
      Tag := Tags.Find(Item.ID);
      IsValid := True;
      if Tag <> nil then
      begin
        IsValid := GetFFDVersion in Tag.Versions;
      end;

      if IsValid then
        Result := Result + TTLVWriter.Write(Item);
    end;
  finally
    Tags.Free;
  end;
end;

function TFiscalPrinterDevice.FSWriteTLV(const TLVData: AnsiString): Integer;
var
  Data: AnsiString;
  Answer: AnsiString;
  Command: AnsiString;
begin
  Result := 0;
  Data := FilterTLV(TLVData);
  if Length(Data) = 0 then Exit;

  Command := #$FF#$0C + IntToBin(GetSysPassword, 4) + Copy(Data, 1, 250);
  Result := ExecuteData(Command, Answer);
end;

function GetFSTaxBits(Value: Integer): Integer;
begin
  Result := 0;
  if Value > 0 then
    Result := 1 shl (Value-1);
end;


(******************************************************************************
�������� �� �������� � ���������� FF0DH
��� ������� FF0Dh . ����� ���������:  254 ����.
  ������ ���������� ��������������: 4 �����
  ��� ��������: 1 ����
  1 � ������,
  2 � ������� �������,
  3 � ������,
  4 � ������� �������
  ����������: 5 ���� 0000000000�9999999999
  ����:             5 ���� 0000000000�9999999999
  ������:         5 ���� 0000000000�9999999999
  ��������:    5 ���� 0000000000�9999999999
  ����� ������: 1 ����
  0�16 � ����� ��������� �������, 255 � ����� ������� �� ���� ������
  �����:  1 ����
  ��� 1 �0� � ���, �1� � 1 ��������� ������
  ��� 2 �0� � ���, �1� � 2 ��������� ������
  ��� 3 �0� � ���, �1� � 3 ��������� ������
  ��� 4 �0� � ���, �1� � 4 ��������� ������
  �����-���: 5 ����  000000000000�999999999999
  �����: 220 ����� ������ - �������� ������ � ������
  ����������: ���� ������ ���������� ���������, �� ��� ��������� �� ������
    ��� �� �� ���������� �� �����. �������� ������ � ������ ������
    ������������� ���� (���� ��������������� ������).
�����:    FF0Dh ����� ���������: 1 ����.
  ��� ������: 1 ����
******************************************************************************)

function TFiscalPrinterDevice.FSSale(P: TFSSale): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  P.Text := PrintItemText(P.Text);
  Command := #$FF#$0D + IntToBin(GetUsrPassword, 4) +
    Chr(Abs(P.RecType)) +
    IntToBin(Abs(Round(P.Quantity * 1000)), 5) +
    IntToBin(Abs(P.Price), 5) +
    IntToBin(Abs(P.Discount), 5) +
    IntToBin(Abs(P.Charge), 5) +
    Chr(Abs(P.Department)) +
    Chr(GetFSTaxBits(Abs(P.Tax))) +
    IntToBin(P.Barcode, 5) +
    Copy(P.Text, 1, 109) + #0 +
    Copy(P.AdjText, 1, 109) + #0;

  Result := ExecuteData(Command, Answer);
end;

(*
�������� V2 FF46H
��� ������� FF46h . ����� ���������:  160 �����.
������: 4 �����
��� ��������: 1 ����
1 - ������,
2 - ������� �������,
3 - ������,
4 - ������� �������
����������: 6 ���� ( 6 ������ ����� ������� )
����:             5 ����
����� �������� 5 ���� *
�����:           5 ���� **
��������� ������:  1 ����
����� ������: 1 ����
0�16 - ����� ��������� �������, 255 - ����� ������� �� ���� ������
������� ������� ������� : 1 ����
������� �������� �������: 1 ����
������������ ������: 0-128 ���� ASCII

*)

function TFiscalPrinterDevice.FSSale2(P: TFSSale2): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  P.Text := PrintItemText(P.Text);
  Command := #$FF#$46 + IntToBin(GetUsrPassword, 4) +
    Chr(Abs(P.RecType)) +
    IntToBin(Abs(Round(P.Quantity * 1000000)), 6) +
    IntToBin(Abs(P.Price), 5) +
    IntToBin(Abs(P.Total), 5) +
    IntToBin(Abs(P.TaxAmount), 5) +
    Chr(GetFSTaxBits(Abs(P.Tax))) +
    Chr(P.Department) +
    Chr(P.PaymentType) +
    Chr(P.PaymentItem) +
    Copy(P.Text, 1, 128);

  Result := ExecuteData(Command, Answer);
end;

(*
������ ��������� �������� ��
��� ������� 	FF0Eh. ����� ���������: 9 ����.
������ ���������� �������������� (4 �����)
���������� ����� ������ � �����������/��������������� (1 ����)
����� ���� (��� �, TLV ���������) (2 �����)
���� T=FFFFh2, �� ������ TLV ��������� �������� FF3Bh
�����: 		FF0Eh. ����� ���������: 3+X1 ����.
��� ������ (1 ����)
TLV ��������� (X1 ����)
����������:
1 - ����� ��������� ��������� ������� �� TLV ���������, ������������ �� �� �������� ����� ���� (����� FFFFh);
2 - ��� ������� ���� ����� TLV ��������� �� ������������ (X=0).

*)

function TFiscalPrinterDevice.FSReadRegTag(var R: TFSReadRegTagCommand): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$0E + IntToBin(GetSysPassword, 4) +
    IntToBin(R.RegID, 1) +
    IntToBin(R.TagID, 2);
  Result := ExecuteData(Command, Answer);
  if Succeeded(Result) then
  begin
    R.TLV := Answer;
  end;
end;

(*
��������� ���� �����: 1 ����
��� 0 � ��������� ��������� �� 
��� 1 � ������ ���������� ����� 
��� 2 � ������ ���������� ����� 
��� 3 � ��������� �������� ���������� ������ � ��� 
������� ��������: 1 ����
00h � ��� ��������� ��������� 
01h � ����� � ������������ 
02h � ����� �� �������� ����� 
04h � �������� ��� 
08h � ����� � �������� ����� 
10h � ����� � �������� ����������� ������ 
11h � ����� ������� ����������
12h - ����� �� ��������� ���������� ����������� ��� � ����� � ������� ��
13h � ����� �� ��������� ���������� ����������� ���
14h � �������� ��� ���������
15h � ��� ���������
17h � ����� � ������� ��������� ��������
������ ���������:  1 ����
00 � ��� ������ ��������� 
01 � �������� ������ ��������� 
��������� �����: 1 ����
00 � ����� ������� 
01 � ����� ������� 
����� ��������������: 1 ����
���� � �����: 5 ����
����� ��: 16 ���� ASCII
����� ���������� ��: 4 �����

*)

function TFiscalPrinterDevice.FSReadState(var R: TFSState): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$01 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 30);
    R.State := BinToInt(Answer, 1, 1);
    R.Document := BinToInt(Answer, 2, 1);
    R.DocReceived := BinToInt(Answer, 3, 1);
    R.DayOpened := BinToInt(Answer, 4, 1) ;
    R.WarningFlags := BinToInt(Answer, 5, 1);
    R.Date.Year := BinToInt(Answer, 6, 1);
    R.Date.Month := BinToInt(Answer, 7, 1);
    R.Date.Day := BinToInt(Answer, 8, 1);
    R.Time.Hour := BinToInt(Answer, 9, 1);
    R.Time.Min := BinToInt(Answer, 10, 1);
    R.Time.Sec := 0;
    R.FSNumber := Copy(Answer, 11, 16);
    R.DocNumber := BinToInt(Answer, 27, 4);
  end;
end;

(*
�������� �������� � �� FF08H
��� ������� FF08h. ����� ���������: 6 ����.
������ ���������� ��������������: 4 �����
�����: FF08h ����� ���������: 1 ����.
��� ������: 1 ����
*)

function TFiscalPrinterDevice.FSCancelDocument: Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$08 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
end;

(*

��������� ������� ������ � ������
��� ������� FF30h . ����� ���������: 6 ����.
������ ���������� ��������������: 4 �����
�����:	    FF30h ����� ���������: 4 �����.
��� ������ (1 ����)
���������� ���� � ������ ( 2 ����� )  0 � ��� ������
������������ ������ ����� ������ ( 1 ����)

*)

function TFiscalPrinterDevice.FSReadStatus(var R: TFSStatus): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$30 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 3);
    R.DataSize := BinToInt(Answer, 1, 2);
    R.BlockSize := BinToInt(Answer, 3, 1);
  end;
end;

(*

����� ���������� �������� �� ������
��� ������� FF0Ah . ����� ���������: 10 ����.
������ ���������� ��������������: 4 �����
����� ����������� ���������: 4 �����
�����: FF0�h ����� ��������� 3+N ����.
��� ������: 1 ����
��� ����������� ���������: 1 ����
�������� �� ��������� �� ���: 1 ����
1- ��
0 -���
������ ����������� ��������� � ����������� �� ���� ��������: N ����

*)

function TFiscalPrinterDevice.FSFindDocument(DocNumber: Integer;
  var R: TFSDocument): Integer;

  (*
  //SDocType1 = '����� � �����������';

  ���� � �����	DATE_TIME	5
  ����� ��	Uint32, LE	4
  ���������� �������	Uint32, LE	4
  ���	ASCII	12
  ��������������� ����� ���	ASCII	20
  ��� ���������������	Byte	1
  ����� ������	Byte	1}
  *)

  procedure DecodeDocType1(const Data: AnsiString; var R: TFSDocument1);
  begin
    CheckMinLength(Data, 47);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.TaxID := TrimRight(Copy(Data, 14, 12));
    R.EcrRegNum := TrimRight(Copy(Data, 26, 20));
    R.TaxType := Ord(Data[46]);
    R.WorkMode := Ord(Data[47]);
  end;

  (*
  //SDocType2 = '����� �� �������� �����';
  ���� � �����	DATE_TIME	5
  ����� ��	Uint32, LE	4
  ���������� �������	Uint32, LE	4
  ����� �����	Uint16, LE	2}
  *)

  procedure DecodeDocType2(const Data: AnsiString; var R: TFSDocument2);
  begin
    CheckMinLength(Data, 15);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.DayNum := BinToInt(Data, 14, 2);
  end;

  (*
  SDocType3 = '�������� ���';
  ���� � �����	DATE_TIME	5
  ����� ��	Uint32, LE	4
  ���������� �������	Uint32, LE	4
  ��� ��������	Byte	1
  ����� ��������	Uint40, LE	5
  *)

  procedure DecodeDocType3(const Data: AnsiString; var R: TFSDocument3);
  begin
    CheckMinLength(Data, 19);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.OperationType := Ord(Data[14]);
    R.Amount := BinToInt(Data, 15, 5);
  end;

  (*6 ����� � �������� ����������� ����������
  ���� � �����	DATE_TIME	5
  ����� ��	Uint32, LE	4
  ���������� �������	Uint32, LE	4
  ���	ASCII	12
  ��������������� ����� ���	ASCII	20 *)

  procedure DecodeDocType6(const Data: AnsiString; var R: TFSDocument6);
  begin
    CheckMinLength(Data, 45);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.TaxID := Copy(Data, 14, 12);
    R.EcrRegNum := Copy(Data, 26, 20);
  end;

  //11 ����� �� ��������� ���������� �����������
  {���� � �����	DATE_TIME	5
  ����� ��	Uint32, LE	4
  ���������� �������	Uint32, LE	4
  ���	ASCII	12
  ��������������� ����� ���	ASCII	20
  ��� ���������������	Byte	1
  ����� ������	Byte	1
  ��� ������� ���������������	Byte	1}

  procedure DecodeDocType11(const Data: AnsiString; var R: TFSDocument11);
  begin
    CheckMinLength(Data, 48);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.TaxID := Copy(Data, 14, 12);
    R.EcrRegNum := Copy(Data, 26, 20);
    R.TaxType := Ord(Data[46]);
    R.WorkMode := Ord(Data[47]);
    R.ReasonCode := Ord(Data[48]);
  end;

  //21 ����� � ��������� ��������
  {���� � �����	DATE_TIME	5
  ����� ��	Uint32, LE	4
  ���������� �������	Uint32, LE	4
  ���-�� ���������������� ����������	Uint32, LE	4
  ���� ������� ����������������� ���������	DATE_TIME	5}

  procedure DecodeDocType21(const Data: AnsiString; var R: TFSDocument21);
  begin
    CheckMinLength(Data, 20);
    R.Date := BinToPrinterDateTime2(Data);
    R.DocNum := BinToInt(Data, 6, 4);
    R.DocMac := BinToInt(Data, 10, 4);
    R.DocCount := BinToInt(Data, 14, 2);
    R.DocDate := BinToPrinterDateTime2(Copy(Data, 16, 5));
  end;

var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$0A + IntToBin(GetSysPassword, 4) + IntToBin(DocNumber, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 3);
    R.DocType := Ord(Answer[1]);
    R.TicketReceived := Ord(Answer[2]) = 1;
    R.TlvData := Copy(Answer, 3, Length(Answer));
    case R.DocType of
      1: DecodeDocType1(R.TlvData, R.DocType1);
      2: DecodeDocType2(R.TlvData, R.DocType2);
      3: DecodeDocType3(R.TlvData, R.DocType3);
      4: DecodeDocType3(R.TlvData, R.DocType3);
      5: DecodeDocType2(R.TlvData, R.DocType2);
      6: DecodeDocType6(R.TlvData, R.DocType6);
      11: DecodeDocType11(R.TlvData, R.DocType11);
      21: DecodeDocType21(R.TlvData, R.DocType21);
      31: DecodeDocType3(R.TlvData, R.DocType3);
    end;
  end;
end;

function TFiscalPrinterDevice.FSReadDocMac(var DocMac: Int64): Integer;
var
  FSState: TFSState;
  FSDocument: TFSDocument;
begin
  Result := FSReadState(FSState);
  if Result <> 0 then Exit;

  Result := FSFindDocument(FSState.DocNumber, FSDocument);
  DocMac := 0;
  case FSDocument.DocType of
    1: DocMac := FSDocument.DocType1.DocMac;
    2: DocMac := FSDocument.DocType2.DocMac;
    3: DocMac := FSDocument.DocType3.DocMac;
    4: DocMac := FSDocument.DocType3.DocMac;
    5: DocMac := FSDocument.DocType2.DocMac;
    6: DocMac := FSDocument.DocType6.DocMac;
    11: DocMac := FSDocument.DocType11.DocMac;
    21: DocMac := FSDocument.DocType21.DocMac;
    31: DocMac := FSDocument.DocType3.DocMac;
  end;
end;

(*
��������� ���� ������ ������ �� ������
��� ������� FF31h . ����� ���������: 6 ����.
������ ���������� ��������������: (4 �����)
��������� ��������: 2 �����
���������� ������������� ������ (1 ����)
        �����:	    FF31h ����� ���������: 1+N ����.
��� ������ (1 ����)
������ (N ����)
*)

function TFiscalPrinterDevice.FSReadBlock(const P: TFSBlockRequest;
  var Block: AnsiString): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$31 + IntToBin(GetSysPassword, 4) +
    IntToBin(P.Offset, 2) + Chr(P.Size);

  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    Block := Answer;
  end;
end;

(*
������ ������ ������ � �����
��� ������� FF32h . ����� ���������: 8 ����.
������ ���������� ��������������: (4 �����)
������ ������ ( 2 �����)
        �����:	    FF32h ����� ���������: 2 �����.
��� ������ (1 ����)
������������ ������ ���� ������ (1 ����)
*)

function TFiscalPrinterDevice.FSStartWrite(DataSize: Word;
  var BlockSize: Byte): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$32 + IntToBin(GetSysPassword, 4) + IntToBin(DataSize, 2);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 1);
    BlockSize := Ord(Answer[1]);
  end;
end;

(*

�������� ���� ������ � �����
��� ������� FF33h . ����� ���������: 9+N ����.
������ ���������� ��������������: (4 �����)
��������� ��������: (2 �����)
������ ������  (1 ����)
������ ��� ������ ( N ����)
         �����:	    FF33h ����� ���������: 1 ����.
��� ������ (1 ����)

*)

function TFiscalPrinterDevice.FSWriteBlock(const Block: TFSBlock): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$33 + IntToBin(GetSysPassword, 4) +
    IntToBin(Block.Offset, 2) + IntToBin(Length(Block.Data), 1) +
    Block.Data;

  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.GetBlockSize(BlockSize: Integer): Integer;
begin
  Result := BlockSize;
  if Result = 0 then
    Result := DefDocumentBlockSize;

  if (GetDeviceMetrics.Model = 19)and(BlockSize > GetParameters.DocumentBlockSize) then
    Result := GetParameters.DocumentBlockSize;
end;

function TFiscalPrinterDevice.FSReadBlockData: AnsiString;
var
  i: Integer;
  Count: Integer;
  Block: AnsiString;
  BlockData: AnsiString;
  Status: TFSStatus;
  DataSize: Integer;
  BlockSize: Integer;
  BlockRequest: TFSBlockRequest;
begin
  Lock;
  try
    BlockData := '';
    BlockRequest.Offset := 0;
    Check(FSReadStatus(Status));
    if Status.DataSize = 0 then Exit;
    if Status.BlockSize = 0 then Exit;
    Status.BlockSize := GetBlockSize(Status.BlockSize);

    Count := (Status.DataSize + Status.BlockSize-1) div Status.BlockSize;
    DataSize := Status.DataSize;
    for i := 0 to Count-1 do
    begin
      BlockSize := Min(Status.BlockSize, DataSize);
      BlockRequest.Offset := i*Status.BlockSize;
      BlockRequest.Size := BlockSize;
      Check(FSReadBlock(BlockRequest, Block));
      BlockData := BlockData + Block;
      DataSize := DataSize - BlockSize;
    end;
    BlockData := Copy(BlockData, 1, Status.DataSize);
    Result := BlockData;
  finally
    Unlock;
  end;
end;

procedure TFiscalPrinterDevice.FSWriteBlockData(const BlockData: AnsiString);
var
  i: Integer;
  Count: Integer;
  BlockSize: Byte;
  Block: TFSBlock;
begin
  Lock;
  try
    Check(FSStartWrite(Length(BlockData), BlockSize));
    if BlockSize = 0 then
      raiseException('BlockSize = 0');

    BlockSize := GetBlockSize(BlockSize);
    Count := (Length(BlockData)+ BlockSize-1) div BlockSize;
    for i := 0 to Count-1 do
    begin
      Block.Offset := BlockSize*i;
      Block.Size := BlockSize;
      Block.Data := Copy(BlockData, BlockSize*i + 1, BlockSize);
      Check(FSWriteBlock(Block));
    end;
  finally
    Unlock;
  end;
end;

{******************************************************************************
������������ ����� � ��������� �������� FF38H
��� ������� FF38h . ����� ���������: 6 ����.
  ������ ���������� ��������������: 4 �����
�����:	    FF38h ����� ���������: 16 ����.
  ��� ������: 1 ����
  ����� ��: 4 �����
  ���������� �������: 4 �����
  ���������� ��������������� ����������: 4 �����
  ���� ������� ���������������� ���������: 3 ����� ��,��,��
******************************************************************************}

function TFiscalPrinterDevice.FSPrintCalcReport(var R: TFSCalcReport): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$38 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 15);

    R.DocNumber := BinToInt(Answer, 1, 4);
    R.FiscalSign := BinToInt(Answer, 5, 4);
    R.OutstandDocCount := BinToInt(Answer, 9, 4);
    R.OutstandDocDate.Year := Ord(Answer[13]);
    R.OutstandDocDate.Month := Ord(Answer[14]);
    R.OutstandDocDate.Day := Ord(Answer[15]);
  end;
end;

(*
�������� ������ ��������������� ������
��� ������� FF39h . ����� ���������: 6 ����.
  ������ ���������� ��������������: 4 �����
�����: FF39h ����� ���������: 14 ����.
  ��� ������: 1 ����
  ������ ��������������� ������: 1 ����
  (0 � ���, 1 � ��)
  ��� 0 � ������������ ���������� �����������
  ��� 1 � ���� ��������� ��� �������� � ���
  ��� 2 � �������� ��������� ��������� (���������) �� ���
  ��� 3 � ���� ������� �� ���
  ��� 4 � ���������� ��������� ���������� � ���
  ��� 5 � �������� ������ �� ������� �� ���
  ��������� ������ ���������: 1 ���� 1 � ��, 0 -���
  ���������� ��������� ��� ���: 2 �����
  ����� ��������� ��� ��� ������� � �������: 4 �����
  ���� � ����� ��������� ��� ��� ������� � �������: 5 ����

*)

function TFiscalPrinterDevice.FSReadCommStatus(
  var R: TFSCommStatus): Integer;

  function DecodeFSWriteStatus(Value: Integer): TFSWriteStatus;
  begin
    Result.IsConnected := TestBit(Value, 0);
    Result.HasMessageToSend := TestBit(Value, 1);
    Result.IsWaitForTicket := TestBit(Value, 2);
    Result.IsServerCommand := TestBit(Value, 3);
    Result.ConnParamsChanged := TestBit(Value, 4);
    Result.IsWaitForAnswer := TestBit(Value, 5);
  end;

var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$39 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 11);
    R.WriteStatus := BinToInt(Answer, 1, 1);
    R.FSWriteStatus := DecodeFSWriteStatus(R.WriteStatus);
    R.ReadStatus := BinToInt(Answer, 2, 1);
    R.DocumentCount := BinToInt(Answer, 3, 2);
    R.DocumentNumber := BinToInt(Answer, 5, 4);
    R.DocumentDate := BinToPrinterDateTime2(Copy(Answer, 9, Length(Answer)));
  end;
end;

(*
������ ����� �������� ��
��� ������� FF03h . ����� ���������: 6 ����.
������ ���������� ��������������: 4 �����
�����: FF03h ����� ���������: 4 ����.
��� ������: 1 ����
���� ��������: 3 ����� ��,��,��
*)

function TFiscalPrinterDevice.FSReadExpiration(var R: TCommandFF03): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$03 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 5);
    R.ExpDate := BinToPrinterDate(Answer);
    R.RegLeft := Ord(Answer[4]);
    R.RegNumber := Ord(Answer[5]);
  end;
end;

(*
  ������ ������ ������������

  ��� ������� FF09h . ����� ���������: 6 ����.
    ������ ���������� ��������������: 4 �����

  �����: FF09h ����� ���������: 48 ����.
    ��� ������ : 1 ����
    ���� � �����: 5 ���� DATE_TIME
    ��� : 12 ���� ASCII
    ��������������� ����� ��T: 20 ���� ASCII
    ��� ���������������: 1 ����
    ����� ������: 1 ����
    ����� ��: 4 �����
    ���������� �������: 4 �����
*)

function TFiscalPrinterDevice.FSReadFiscalResult(var R: TFSFiscalResult): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$09 + IntToBin(GetSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 47);
    R.Date := BinToPrinterDateTime2(Answer);
    R.TaxID := TrimRight(Copy(Answer, 6, 12));
    R.EcrRegNum := TrimRight(Copy(Answer, 18, 20));
    R.TaxType := BinToInt(Answer, 38, 1);
    R.WorkMode := BinToInt(Answer, 39, 1);
    R.DocNum := BinToInt(Answer, 40, 4);
    R.DocMac := BinToInt(Answer, 44, 4);
  end;
end;

(*
������ ��������� � ��������� ������ � ��� �� ������
���������
��� ������� FF3�h . ����� ���������: 11 ����.
������ ���������� ��������������: 4 �����
����� ����������� ���������: 4 �����
�����: FF3�h ����� ���������: 1+N ����.
��� ������: 1 ����
���������: N ����
*)

function TFiscalPrinterDevice.FSReadTicket(var R: TFSTicket): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$3C + IntToBin(GetSysPassword, 4) + IntToBin(R.Number, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R.Data := Answer;
    if Length(Answer) >= 27 then
    begin
      R.Date := BinToPrinterDateTime2(R.Data);
      R.DocumentMac := Copy(R.Data, 6, 18);
      R.DocumentNum := BinToInt(R.Data, 24, 4);
    end;
  end;
end;


function TFiscalPrinterDevice.GetCapFiscalStorage: Boolean;
begin
  Result := FCapFiscalStorage;
end;

function TFiscalPrinterDevice.WriteCustomerAddress(const Value: WideString): Integer;
begin
  Result := FSWriteTag(1008, Value);
end;

function TFiscalPrinterDevice.FSWriteTag(TagID: Integer; const Data: WideString): Integer;
begin
  Result := FSWriteTLV(TagToStr(TagID, Data));
end;

function TFiscalPrinterDevice.ReadFPParameter(ParamId: Integer): WideString;
begin
  case ParamId of
    DIO_FPTR_PARAMETER_QRCODE_ENABLED:
    begin
      // 1,1,41,1,0,0,1,'����������� ���������� ����','1'
      Result := ReadTableStr(1, 1, 41);
    end;
    DIO_FPTR_PARAMETER_OFD_ADDRESS:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(15, 1, 1)
      else
        Result := ReadTableStr(19, 1, 1);
    end;

    DIO_FPTR_PARAMETER_OFD_PORT:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(15, 1, 2)
      else
        Result := ReadTableStr(19, 1, 2);
    end;

    DIO_FPTR_PARAMETER_OFD_TIMEOUT:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(15, 1, 3)
      else
        Result := ReadTableStr(19, 1, 3);
    end;

    DIO_FPTR_PARAMETER_RNM:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(14, 1, 3)
      else
        Result := ReadTableStr(18, 1, 3);
    end;

    DIO_FPTR_PARAMETER_INN:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(14, 1, 2)
      else
        Result := ReadTableStr(18, 1, 2);
    end;
    DIO_FPTR_PARAMETER_TAXSYSTEM:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(14, 1, 5)
      else
        Result := ReadTableStr(18, 1, 5);
    end;
    DIO_FPTR_PARAMETER_WORKMODE:
    begin
      if IsMobilePrinter then
        Result := ReadTableStr(14, 1, 6)
      else
        Result := ReadTableStr(18, 1, 6);
    end;

    DIO_FPTR_PARAMETER_ENABLE_PRINT:
    begin
      Result := '0';
      if FCapEnablePrint then
      begin
        Result := ReadTableStr(17, 1, 7);
      end;
    end;
  else
    raiseExceptionFmt('%s, %d', [_('Invalid parameter ID value'), ParamId]);
  end;
end;

procedure TFiscalPrinterDevice.WriteFPParameter(ParamId: Integer;
  const Value: WideString);
begin
  case ParamId of
    DIO_FPTR_PARAMETER_QRCODE_ENABLED:
    begin
      WriteTable(1, 1, 41, Value);
    end;
    DIO_FPTR_PARAMETER_OFD_ADDRESS:
    begin
      WriteTable(19, 1, 1, Value);
    end;

    DIO_FPTR_PARAMETER_OFD_PORT:
    begin
      WriteTable(19, 1, 2, Value);
    end;

    DIO_FPTR_PARAMETER_OFD_TIMEOUT:
    begin
      WriteTable(19, 1, 3, Value);
    end;

    DIO_FPTR_PARAMETER_ENABLE_PRINT:
    begin
      if FCapEnablePrint then
      begin
        WriteTable(17, 1, 7, Value);
      end;
    end;

  else
    raiseExceptionFmt('%s, %d', [_('Invalid parameter ID value'), ParamId]);
  end;
end;


function TFiscalPrinterDevice.ReadDiscountMode: Integer;
var
  R: TPrinterTableRec;
begin
  Result := 0;
  try
    if ReadTableStructure(17, R) = 0 then
    begin
      Result := ReadTableInt(17, 1, 3);
    end;
  except
    on E: Exception do
    begin
      Result := 0;
    end;
  end;
end;

function TFiscalPrinterDevice.ReadDocPrintMode: Integer;
var
  R: TPrinterTableRec;
begin
  Result := 0;
  try
    if ReadTableStructure(17, R) = 0 then
    begin
      Result := ReadTableInt(17, 1, 7);
    end;
  except
    on E: Exception do
    begin
      Result := 0;
    end;
  end;
end;

function TFiscalPrinterDevice.GetDiscountMode: Integer;
begin
  Result := FDiscountMode;
end;

function TFiscalPrinterDevice.GetIsFiscalized: Boolean;
begin
  Result := FIsFiscalized;
end;

///////////////////////////////////////////////////////////////////////////////
//  �������� ������ ������������ ���� ����� ��������� ������� 1
// (FE F4 00 00 00 00), ���������� 4 8-�� ������� �����.

function TFiscalPrinterDevice.FSReadTotals(var R: TFMTotals): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  FLogger.Debug('FSReadTotals');
  Command := #$FE#$F4#$00#$00#$00#$00;
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 32);
    R.OperatorNumber := 0;
    R.SaleTotal := BinToInt2(Answer, 1, 8);
    R.RetSale := BinToInt2(Answer, 9, 8);
    R.BuyTotal := BinToInt2(Answer, 17, 8);
    R.RetBuy := BinToInt2(Answer, 25, 8);
  end;
end;

function TFiscalPrinterDevice.FSReadCorrectionTotals(var R: TFMTotals): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  FLogger.Debug('FSReadCorrectionTotals');
  Command := #$FE#$F4#$05#$00#$00#$00;
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 32);
    R.OperatorNumber := 0;
    R.SaleTotal := BinToInt2(Answer, 1, 8);
    R.RetSale := BinToInt2(Answer, 9, 8);
    R.BuyTotal := BinToInt2(Answer, 17, 8);
    R.RetBuy := BinToInt2(Answer, 25, 8);
  end;
end;

(*
0xF4    ������ ������������ ����.
������ �������� �������� �� ��� ������������� ����
"	FE F4 00 00 00 00 - ���������� 4 8-�� ������� ����� (������, ������� �������, ������, ������� �������). ��� �� ��� ����������� �� ����� ������
"	FE F4 01 00 00 00 - ���������� 16 8-�� ������� ����� (������). ��� �� � ������������ �� 16-�� ����� ������
"	FE F4 02 00 00 00 - ���������� 16 8-�� ������� ����� (������� �������). ��� �� � ������������ �� 16-�� ����� ������
"	FE F4 03 00 00 00 - ���������� 16 8-�� ������� ����� (������). ��� �� � ������������ �� 16-�� ����� ������
"	FE F4 04 00 00 00 - ���������� 16 8-�� ������� ����� (������� �������). ��� �� � ������������ �� 16-�� ����� ������
"	FE F4 05 00 00 00 - ���������� 4 8-�� ������� ����� (��������� �������, ��������� �������� �������, ��������� �������, ��������� �������� �������)
�����.  ����� ���������: 33(129) ����.
"	��� ������ (1 ����)
"	������ (X ����). X � ����������� �� ���� ������������� ������.

*)

function TFiscalPrinterDevice.FSReadTotalsByPayType(RecType: Byte;
  var R: TFSTotalsByPayType): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  FLogger.Debug(Format('FSReadTotalsByPayType(%d)', [RecType]));
  CheckParam(RecType, 1, 4, 'RecType');
  Command := #$FE#$F4 + Chr(RecType) + #$00#$00#$00;
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 128);
    Move(Answer[1], R, Sizeof(R));
  end;
end;


(*

���������� �� ����� ������ �� 4 ����� �������� �������� (�������, �������,
������� �������, ������� �������) �� �����:
193�196 � ���������;
197�200 � ����� ������ 2;
201�204 � ����� ������ 3;
205�208 � ����� ������ 4;

*)

function TFiscalPrinterDevice.ReadDayTotalsByReceiptType(Index: Integer): Int64;
begin
  Result := ReadCashRegister(193 + Index) +
    ReadCashRegister(197 + Index) +
    ReadCashRegister(201 + Index) +
    ReadCashRegister(205 + Index);
end;

(*
���������� �� ����� ������ �� 4 ����� �������� �������� (�������, �������,
������� �������, ������� �������) � ����:
72�75 � ���������;
76�79 � ����� ������ 2;
80�83 � ����� ������ 3;
84�87 � ����� ������ 4;
*)

function TFiscalPrinterDevice.ReadTotalsByReceiptType(Index: Integer): Int64;
begin
  Result :=
    ReadCashRegister(72 + Index) +
    ReadCashRegister(76 + Index) +
    ReadCashRegister(80 + Index) +
    ReadCashRegister(84 + Index);
end;

function TFiscalPrinterDevice.ReadDayTotals: TFMTotals;
begin
  Result.SaleTotal := 0;
  Result.BuyTotal := 0;
  Result.RetSale := 0;
  Result.RetBuy := 0;
  if GetIsFiscalized then
  begin
    Result.SaleTotal := ReadDayTotalsByReceiptType(0);
    Result.BuyTotal := ReadDayTotalsByReceiptType(1);
    Result.RetSale := ReadDayTotalsByReceiptType(2);
    Result.RetBuy := ReadDayTotalsByReceiptType(3);
  end else
  begin
    Result.SaleTotal := ReadDayTotalsByReceiptType(0);
    Result.BuyTotal := 0;
    Result.RetSale := 0;
    Result.RetBuy := 0;
  end;
end;

function TFiscalPrinterDevice.ReadFPTotals(Flags: Integer): TFMTotals;
begin
  Result.SaleTotal := 0;
  Result.BuyTotal := 0;
  Result.RetSale := 0;
  Result.RetBuy := 0;
  if CapFiscalStorage then
  begin
    Check(FSReadTotals(Result));
  end else
  begin
    if GetIsFiscalized then
    begin
      Check(ReadFMTotals(Flags, Result));
    end else
    begin
      Result.SaleTotal := ReadCashRegister(244);
    end;
  end;
end;

function TFiscalPrinterDevice.ReadFPDayTotals(Flags: Integer): TFMTotals;
var
  FPTotals: TFMTotals;
  DayTotals: TFMTotals;
begin
  FPTotals := ReadFPTotals(Flags);
  DayTotals := ReadDayTotals;
  Result.SaleTotal := FPTotals.SaleTotal + DayTotals.SaleTotal;
  Result.BuyTotal := FPTotals.BuyTotal + DayTotals.BuyTotal;
  Result.RetSale := FPTotals.RetSale + DayTotals.RetSale;
  Result.RetBuy := FPTotals.RetBuy + DayTotals.RetBuy;
end;

(*
������������ ��� ��������� FF36H
��� ������� FF36h . ����� ���������: 12 ����.
������ ���������� ��������������: 4 �����
���� ����: 5 ���� 0000000000�9999999999
��� �������� 1 ����

�����: FF36h ����� ���������: 11 ����.
��� ������: 1 ����
����� ����: 2 �����
����� ��: 4 �����
���������� �������: 4 ����
*)

function TFiscalPrinterDevice.FSPrintCorrectionReceipt(
  var Command: TFSCorrectionReceipt): Integer;
var
  Cmd: AnsiString;
  Data: AnsiString;
begin
  OpenFiscalDay;

  Cmd := #$FF#$36 +
    IntToBin(GetSysPassword, 4) +
    IntToBin(Command.Total, 5) +
    IntToBin(Command.RecType, 1);
  Result := ExecuteData(Cmd, Data);
  if Result = 0 then
  begin
    CheckMinLength(Data, 10);
    Command.ResultCode := Result;
    Command.ReceiptNumber := BinToInt(Data, 1, 2);
    Command.DocumentNumber := BinToInt(Data, 3, 4);
    Command.DocumentMac := BinToInt(Data, 7, 4);
  end;
end;

(*
������������ ��� ��������� V2 FF4AH
��� ������� FF4Ah . ����� ���������: 69 ����.
������ ���������� ��������������: 4 �����
��� ��������� :1 ����
������� �������:1����
����� ������� :5 ����
����� �� ���� ���������:5 ����
����� �� ���� ������������:5 ����
����� �� ���� �����������:5 ����
����� �� ���� �����������:5 ����
����� �� ���� ��������� ��������������:5 ����
����� ��� 20%:5 ����
����� ��� 10%:5 ����
����� ������� �� ������ 0%:5 ����
����� ������� �� ���� ��� ���:5 ����
����� ������� �� ����. ������ 20/120:5 ����
����� ������� �� ����. ������ 10/110:5 ����
����������� ������� ���������������:1����
*)

function TFiscalPrinterDevice.FSPrintCorrectionReceipt2(
  var Data: TFSCorrectionReceipt2): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  OpenFiscalDay;

  Command := #$FF#$4A +
    IntToBin(GetSysPassword, 4) +
    IntToBin(Data.CorrectionType, 1) +
    IntToBin(Data.CalculationSign, 1) +
    IntToBin(Data.Amount1, 5) +
    IntToBin(Data.Amount2, 5) +
    IntToBin(Data.Amount3, 5) +
    IntToBin(Data.Amount4, 5) +
    IntToBin(Data.Amount5, 5) +
    IntToBin(Data.Amount6, 5) +
    IntToBin(Data.Amount7, 5) +
    IntToBin(Data.Amount8, 5) +
    IntToBin(Data.Amount9, 5) +
    IntToBin(Data.Amount10, 5) +
    IntToBin(Data.Amount11, 5) +
    IntToBin(Data.Amount12, 5) +
    IntToBin(Data.TaxType, 1);

  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 10);
    Data.ResultCode := Result;
    Data.ReceiptNumber := BinToInt(Answer, 1, 2);
    Data.DocumentNumber := BinToInt(Answer, 3, 4);
    Data.DocumentMac := BinToInt(Answer, 7, 4);
  end;
end;

procedure TFiscalPrinterDevice.LoadTables(const Path: WideString);
var
  i: Integer;
  j: Integer;
  Mask: AnsiString;
  F: TSearchRec;
  DeviceName: AnsiString;
  FileName: AnsiString;
  ResultCode: Integer;
  FileNames: TTntStrings;
  Tables: TPrinterTables;
  Reader: TCsvPrinterTableFormat;
begin
  Logger.Debug('LoadTables("' + Path + '")');

  DeviceName := GetDeviceMetrics.DeviceName;
  FileNames := TTntStringList.Create;
  Reader := TCsvPrinterTableFormat.Create(nil);
  Tables := TPrinterTables.Create;
  try
    Mask := WideIncludeTrailingPathDelimiter(Path) + '*.csv';
    ResultCode := FindFirst(Mask, faAnyFile, F);
    if ResultCode = 0 then
    begin
      while ResultCode = 0 do
      begin
        FileName := ExtractFilePath(Mask) + F.FindData.cFileName;
        FileNames.Add(FileName);
        ResultCode := FindNext(F);
      end;
      FindClose(F);
    end;

    for i := 0 to FileNames.Count-1 do
    begin
      Reader.LoadFromFile(FileNames[i], Tables);
      if Tables.DeviceName = DeviceName then
      begin
        Logger.Debug('Tables file name: ' + FileNames[i]);
        Logger.Debug('Tables count = ' + IntToStr(Tables.Count));
        for j := 0 to Tables.Count - 1 do
        begin
          WriteFields(Tables[j]);
        end;
        Break;
      end;
    end;
  except
    on E: Exception do
    begin
      Logger.Error('LoadTables: ' + GetExceptionMessage(E));
    end;
  end;
  Tables.Free;
  Reader.Free;
  FileNames.Free;
end;

procedure TFiscalPrinterDevice.WriteFields(Table: TPrinterTable);
var
  i: Integer;
  Data: AnsiString;
  Field: TPrinterField;
  FieldValue: WideString;
begin
  for i := 0 to Table.Fields.Count-1 do
  begin
    Field := Table.Fields[i];
    Data := ReadTableBin(Field.Table, Field.Row, Field.Field);
    FieldValue := FieldToStr(Field.Data, Data);
    if FieldValue <> Field.Value then
    begin
      WriteTable(Field.Table, Field.Row, Field.Field, Field.Value);
    end;
  end;
end;

function TFiscalPrinterDevice.GetContext: TDriverContext;
begin
  Result := FContext;
end;

function TFiscalPrinterDevice.IsFSDocumentOpened: Boolean;
var
  FSState: TFSState;
begin
  Result := False;
  if GetCapFiscalStorage then
  begin
    Check(FSReadState(FSState));
    Result := FSState.Document <> 0;
  end;
end;

function TFiscalPrinterDevice.IsRecOpened: Boolean;
begin
  Result := (ReadPrinterStatus.Mode and $0F) = MODE_REC;
end;

function TFiscalPrinterDevice.ReadLoaderVersion(var Version: WideString): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FE#$EC#$00#$00#$00#$00;
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    Version := IntTostr(BinToInt(Answer, 1, 4));
  end;
end;

(*
�������� ���� ����������� ������� V2 FF45H
��� ������� FF45H. ����� ���������: 182 ����.
������ ���������� ��������������: 4 �����
����� �������� (5 ����)
����� ���� ������ 2 (5 ����)
����� ���� ������ 3 (5 ����)
����� ���� ������ 4 (5 ����)
����� ���� ������ 5 (5 ����)
����� ���� ������ 6 (5 ����)
����� ���� ������ 7 (5 ����)
����� ���� ������ 8 (5 ����)
����� ���� ������ 9 (5 ����)
����� ���� ������ 10 (5 ����)
����� ���� ������ 11 (5 ����)
����� ���� ������ 12 (5 ����)
����� ���� ������ 13 (5 ����)
����� ���� ������ 14 (5 ����) (����������)
����� ���� ������ 15 (5 ����) (����������)
����� ���� ������ 16 (5 ����) (��������� �������������)
���������� �� ����� � �������� (1 ����)
����� 1 (5 ����) (��� 20%)
����� 2 (5 ����) (��� 10%)
������ �� ������ 3 (5 ����) (��� 0%)
������ �� ������ 4 (5 ����) (��� ���)
����� 5 (5 ����) (��� ����. 18/118)
����� 6 (5 ����) (��� ����. 10/110)
������� ���������������(1 ����)
����� (0-64 ����)
_______________________________________________________
����������:
���� ������ 2-13 ��� �������� � ��� ����������� � ���������� ��� ������ "������������".
� ������ ���������� ������� 0 ( 1 �������) ����� ������������ ������ �������������� ������ �� ����������� � ��������� �������� � ������ ���������� � ������� ������������. � ������ ���������� ������� 1 ������ ������ ���� ����������� �������� �� �������� ��.

�����:   FF45h ����� ���������: 14 ����.
��� ������: 1 ����
����� ( 5 ����)
����� �� :4 �����
���������� �������: 4 �����

-------------------------------------------------------------------------------
�������� ���� ����������� ������� �2

��� �������  FF45h. ����� ���������: 118 - 182 ����� ��� 202 ����� 4
- ������ ���������� �������������� (4 �����)
- ����� �������� (5 ����)
- ����� ���� ������ 2 (5 ����)
- ����� ���� ������ 3 (5 ����)
- ����� ���� ������ 4 (5 ����)
- ����� ���� ������ 5 (5 ����)
- ����� ���� ������ 6 (5 ����)
- ����� ���� ������ 7 (5 ����)
- ����� ���� ������ 8 (5 ����)
- ����� ���� ������ 9 (5 ����)
- ����� ���� ������ 10 (5 ����)
- ����� ���� ������ 11 (5 ����)
- ����� ���� ������ 12 (5 ����)
- ����� ���� ������ 13 (5 ����)
- ����� ���� ������ 14 (5 ����) ����� 5
- ����� ���� ������ 15 (5 ����) ������
- ����� ���� ������ 16 (5 ����) ��������� �������������
- ���������� �� ����� � �������� (1 ����)
- ����� 1 (5 ����) ��� 18%
- ����� 2 (5 ����) ��� 10%
- ������ �� ������ 3 (5 ����) ��� 0%
- ������ �� ������ 4 (5 ����) ��� ���
- ����� 5 (5 ����) ��� ����. 18/118
- ����� 6 (5 ����) ��� ����. 10/110
- ������� ��������������� (1 ����)1
- ��� 0 � ���
- ��� 1 � ��� �����
- ��� 2 � ��� ����� ����� ������
- ��� 3 � ����
- ��� 4 � ���
- ��� 5 � ���
- ����� (0-64 ����) 4
- ����� 7 (5 ����) ��� 5% 4
- ����� 8 (5 ����) ��� 7% 4
- ����� 9 (5 ����) ��� ����. 5/105 4
- ����� 10 (5 ����) ��� ����. 7/107 4

�����:  FF45h.  ����� ���������: 16 (21) ����2.
- ��� ������ (1 ����)
- ����� (5 ����)
- ����� �� (4 �����)
- ���������� ������� (4 �����)
- ���� � ����� (5 ����) DATE_TIME3

*)

function TFiscalPrinterDevice.ReceiptClose2(
  const P: TFSCloseReceiptParams2;
  var R: TFSCloseReceiptResult2): Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
  Status: TLongPrinterStatus;
  //IsExtendedCommand: Boolean;
const
  SInvalidDiscountValue =  'Invalid discount value, %d. Valid discount value is [0..99].';
begin
  WriteTLVItems;

  if not ((P.Discount) in [0..99]) then
    RaiseIllegalError(Format(SInvalidDiscountValue, [P.Discount]));

  FLastDocTotal := GetSubtotal;
  Command := #$FF#$45 + IntToBin(GetUsrPassword, 4) +
    IntToBin(P.Payments[0], 5) +
    IntToBin(P.Payments[1], 5) +
    IntToBin(P.Payments[2], 5) +
    IntToBin(P.Payments[3], 5) +
    IntToBin(P.Payments[4], 5) +
    IntToBin(P.Payments[5], 5) +
    IntToBin(P.Payments[6], 5) +
    IntToBin(P.Payments[7], 5) +
    IntToBin(P.Payments[8], 5) +
    IntToBin(P.Payments[9], 5) +
    IntToBin(P.Payments[10], 5) +
    IntToBin(P.Payments[11], 5) +
    IntToBin(P.Payments[12], 5) +
    IntToBin(P.Payments[13], 5) +
    IntToBin(P.Payments[14], 5) +
    IntToBin(P.Payments[15], 5) +
    Chr(P.Discount) +
    IntToBin(P.TaxAmount[1], 5) +
    IntToBin(P.TaxAmount[2], 5) +
    IntToBin(P.TaxAmount[3], 5) +
    IntToBin(P.TaxAmount[4], 5) +
    IntToBin(P.TaxAmount[5], 5) +
    IntToBin(P.TaxAmount[6], 5) +
    Chr(P.TaxSystem) +
    P.Text;

  (*
  IsExtendedCommand := IsFiscalPrinterRR and((P.TaxAmount[7] <> 0)or(P.TaxAmount[8] <> 0)or
    (P.TaxAmount[9] <> 0)or(P.TaxAmount[10] <> 0));
  if IsExtendedCommand then
  begin
    Command := Command +
    IntToBin(P.TaxAmount[7], 5) +
    IntToBin(P.TaxAmount[8], 5) +
    IntToBin(P.TaxAmount[9], 5) +
    IntToBin(P.TaxAmount[10], 5);
  end;
  *)

  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 13);
    R.Change := BinToInt(Answer, 1, 5);
    R.DocNumber := BinToInt(Answer, 6, 4);
    R.MacValue := BinToInt(Answer, 10, 4);
    if (Length(Answer) >= 18) then
    begin
      R.DocDate := BinToPrinterDate(Copy(Answer, 14, 3));
      R.DocTime := BinToPrinterTime2(Copy(Answer, 17, 2));
    end else
    begin
      try
        Status := ReadLongStatus;
        R.DocDate := Status.Date;
        R.DocTime := Status.Time;
      except
        R.DocDate := GetCurrentPrinterDate;
        R.DocTime := GetCurrentPrinterTime;
      end;
    end;

    FLastDocNumber := R.DocNumber;
    FLastDocMac := R.MacValue;
    FLastDocDate := R.DocDate;
    FLastDocTime := R.DocTime;
  end;
end;

(******************************************************************************
����������� ������
�������: F7H. ����� ���������: 2+X �����.
��� ������� (1 ����) 0�255
������ (X1 ����)
�����: F7H. ����� ���������: 2+Y1 ����.
��� ������ (1 ����)
������ (Y1 ����)
��� ������� 1 � ��������� ������
������ (Y1 = 31):
�������� ����
��������� ������
(8 ����)
������� ���� (���������� ���):
0 � ������� ������ ����������� �����
1 � ������� ������ ������� �����
2 � ���������� ������ ����������� �����
3 � ���������� ������ ������� �����
4 � ������ ������
5 � ����� ������������ ����������� �����
6 � ����� ������������ ������� �����
7 � ������� ������ ����������� ���������
8 � ������ ������ ����������� ���������
9 � ��������� ��������������
10 � ��������� ������ ������ � �����������
11 � ���� ���������� ����
12 � ���� ��������������
13 � �������� ��������������
14 � ��������� �� ��� ������ ������ � ����������
15 � ������ ��������� �����
16 � ������ ������ �� ����� � ���������
17 � ������ ������ �� ������ �� ����������
������������
82
18 � �������������� ��������������
19 � ���������� �� ��������������
20 � ����������� ����� ��������������
21 � ���������� �������� ��������������
22 � ��������� ������ ������������� ���������
23 � ��������� ��������� ��������� ���� (cashcore)
24 � ������� ���� � ���
25 � ������� ���� � ���
26 � �������������� ����� ��� ������ �����
27 � ���������� ��� �� ��������� ������ ���������� ����������
28 � ��������� ��������������� ������� ������ ��������� ���
29 � ��������� �������� ����� �������� '\n' (��� 10) � �������� ������
����� 12H, 17H, 2FH
30 � ��������� �������� ����� ������� ������ (���� 1�9) � �������
������ ����� 2FH
31 � ��������� �������� ����� �������� '\n' (��� 10) � ����������
�������� 80H�87H, 8AH, 8BH
32 � ��������� �������� ����� ������� ������ (���� 1�9) �
���������� �������� 80H�87H, 8AH, 8BH
33 � ����� "������� ������" (28) �� ������ �������: X,
������������ ���������, �� �������, �� �������, �� ��������,
����������, �� �������
34 � ��������� ��� 3 "���� ���" � �������� ������: ����� 12H, 17H, 2FH,
����������� ������� 4DH, C3H, ����������� ����� C5H; ���������
���� "��������� ��������� ������" � ������� 10H ��������� �������
��������� ���
35 � ��������� ������� �������� ������� � ������� C4H
36 � ��������� ������� 6BH "������� �������� �������"
37 � ��������� ������ ������ ��� ������ ������ ����������� �������
C3H � ������ ����������� ����� C5H
38 � ���������������
39 � ��������� ���
40 � ��������� ����5
41 � ������ ������� � ���������������� (������� 4FH)
42 � �������� � ������ �������-512 (������� 4DH, 4EH)
43�63 � ���������������
- ������ ������ ������� 1 (1 ����)
  0 � ��������� �������� 26H "��������� ��������� ������"; 1�255
- ������ ������ ������� 2 (1 ����)
  0 � ��������� �������� 26H "��������� ��������� ������"; 1�255
- ����� ������ ���������� ����� � ������� (1 ����)
  0, 1, 2
- ���������� ���� � ��� (1 ����)
  12, 13, 14
- ���������� ���� � ��� (1 ����)
  8, 10
- ���������� ���� � ������� ��� (1 ����)
  0 � ������� ��� �� ��������������; 8, 14
- ���������� ���� � ������� ��������� ������ (1 ����)
  0 � ������� ��������� ����� �� ��������������; 10, 12, 14
- ������ ���������� ���������� �� ��������� (4 �����)
  00000000�99999999
- ������ ����.������ �� ��������� (4 �����)
  00000000�99999999
- ����� ������� "BLUETOOTH ������������ ������" �������� Bluetooth (1 ����)
  0 � ������� �� ��������������; 1�255
- ����� ���� "���������� �������" (1 ����)
  0 � ���� �� ��������������; 1�255
- ������������ ����� ������� (N/LEN16)(2 �����)
  0 � �� ���������; >>1�65535
- ������ ������������ ����������� ����� � ������ (������
  ����������� �����-����) (1 ����)
  40 � ��� ����� ���������; 64, 72 � ��� ������� ���������
- ������ ����������� ����� � ������ �������-512 (1 ����)
  0 � ���� �� ��������������; 64
- ���������� ����� � ������ �������-512 (2 �����)
  0 � ���� �� ��������������

*******************************************************************************)

function TFiscalPrinterDevice.ReadParameters2(
  var R: TPrinterParameters2): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$F7#$01;
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    FillChar(R, Sizeof(R), 0);
    R.FlagsValue := BinToInt(Answer, 1, 8);
    R.Flags.CapJrnNearEndSensor := TestBit(R.FlagsValue, 0);      // 0 � ������� ������ ����������� �����
    R.Flags.CapRecNearEndSensor := TestBit(R.FlagsValue, 1);      // 1 � ������� ������ ������� �����
    R.Flags.CapJrnEmptySensor := TestBit(R.FlagsValue, 2);        // 2 � ���������� ������ ����������� �����
    R.Flags.CapRecEmptySensor := TestBit(R.FlagsValue, 3);        // 3 � ���������� ������ ������� �����
    R.Flags.CapCoverSensor := TestBit(R.FlagsValue, 4);           // 4 � ������ ������
    R.Flags.CapJrnLeverSensor := TestBit(R.FlagsValue, 5);        // 5 � ����� ������������ ����������� �����
    R.Flags.CapRecLeverSensor := TestBit(R.FlagsValue, 6);        // 6 � ����� ������������ ������� �����
    R.Flags.CapSlpNearEndSensor := TestBit(R.FlagsValue, 7);      // 7 � ������� ������ ����������� ���������
    R.Flags.CapSlpEmptySensor := TestBit(R.FlagsValue, 8);        // 8 � ������ ������ ����������� ���������
    R.Flags.CapPresenter := TestBit(R.FlagsValue, 9);             // 9 � ��������� ��������������
    R.Flags.CapPresenterCommands := TestBit(R.FlagsValue, 10);    // 10 � ��������� ������ ������ � �����������
    R.Flags.CapEJNearFull := TestBit(R.FlagsValue, 11);           // 11 � ���� ���������� ����
    R.Flags.CapEJ := TestBit(R.FlagsValue, 12);                   // 12 � ���� ��������������
    R.Flags.CapCutter := TestBit(R.FlagsValue, 13);               // 13 � �������� ��������������
    R.Flags.CapDrawerStateAsPaper := TestBit(R.FlagsValue, 14);   // 14 � ��������� �� ��� ������ ������ � ����������
    R.Flags.CapDrawerSensor := TestBit(R.FlagsValue, 15);         // 15 � ������ ��������� �����
    R.Flags.CapPrsInSensor := TestBit(R.FlagsValue, 16);          // 16 � ������ ������ �� ����� � ���������
    R.Flags.CapPrsOutSensor := TestBit(R.FlagsValue, 17);         // 17 � ������ ������ �� ������ �� ����������
    R.Flags.CapBillAcceptor := TestBit(R.FlagsValue, 18);         // 18 � �������������� ��������������
    R.Flags.CapTaxKeyPad := TestBit(R.FlagsValue, 19);            // 19 � ���������� �� ��������������
    R.Flags.CapJrnPresent := TestBit(R.FlagsValue, 20);           // 20 � ����������� ����� ��������������
    R.Flags.CapSlpPresent := TestBit(R.FlagsValue, 21);           // 21 � ���������� �������� ��������������
    R.Flags.CapNonfiscalDoc := TestBit(R.FlagsValue, 22);         // 22 � ��������� ������ ������������� ���������
    R.Flags.CapCashCore := TestBit(R.FlagsValue, 23);             // 23 � ��������� ��������� ��������� ���� (cashcore)
    R.Flags.CapInnLeadingZero := TestBit(R.FlagsValue, 24);       // 24 � ������� ���� � ���
    R.Flags.CapRnmLeadingZero := TestBit(R.FlagsValue, 25);       // 25 � ������� ���� � ���
    R.Flags.SwapGraphicsLine := TestBit(R.FlagsValue, 26);        // 26 � �������������� ����� ��� ������ �����
    R.Flags.CapTaxPasswordLock := TestBit(R.FlagsValue, 27);      // 27 � ���������� ��� �� ��������� ������ ���������� ����������
    R.Flags.CapProtocol2 := TestBit(R.FlagsValue, 28);            // 28 � ��������� ��������������� ������� ������ ��������� ���
    R.Flags.CapLFInPrintText := TestBit(R.FlagsValue, 29);        // 29 � ��������� �������� ����� �������� '\n' (��� 10) � �������� ������ ����� 12H, 17H, 2FH
    R.Flags.CapFontInPrintText := TestBit(R.FlagsValue, 30);      // 30 � ��������� �������� ����� ������� ������ (���� 1�9) � ������� ������ ����� 2FH
    R.Flags.CapLFInFiscalCommands := TestBit(R.FlagsValue, 31);   // 31 � ��������� �������� ����� �������� '\n' (��� 10) � ���������� �������� 80H�87H, 8AH, 8BH
    R.Flags.CapFontInFiscalCommands := TestBit(R.FlagsValue, 32); // 32 � ��������� �������� ����� ������� ������ (���� 1�9) � ���������� �������� 80H�87H, 8AH, 8BH
    R.Flags.CapTopCashierReports := TestBit(R.FlagsValue, 33);    // 33 � ����� "������� ������" (28) �� ������ �������: X, ������������ ���������, �� �������, �� �������, �� ��������, ����������, �� �������
    R.Flags.CapSlpInPrintCommands := TestBit(R.FlagsValue, 34);   // 34 � ��������� ��� 3 "���� ���" � �������� ������: ����� 12H, 17H, 2FH,����������� ������� 4DH, C3H, ����������� ����� C5H; ���������
    R.Flags.CapGraphicsC4 := TestBit(R.FlagsValue, 35);           // 35 � ��������� ������� �������� ������� � ������� C4H
    R.Flags.CapCommand6B := TestBit(R.FlagsValue, 36);            // 36 � ��������� ������� 6BH "������� �������� �������"
    R.Flags.CapFlagsGraphicsEx := TestBit(R.FlagsValue, 37);      // 37 � ��������� ������ ������ ��� ������ ������ ����������� ������� C3H � ������ ����������� ����� C5H
    R.Flags.CapMFP := TestBit(R.FlagsValue, 39);                  // 39 � ��������� ���
    R.Flags.CapEJ5 := TestBit(R.FlagsValue, 40);                  // 40 � ��������� ����5
    R.Flags.CapScaleGraphics := TestBit(R.FlagsValue, 41);        // 41 � ������ ������� � ���������������� (������� 4FH)
    R.Flags.CapGraphics512 := TestBit(R.FlagsValue, 42);          // 42 � �������� � ������ �������-512 (������� 4DH, 4EH)

    if Length(Answer) < 9 then Exit;
    R.Font1Width := Ord(Answer[9]);
    if Length(Answer) < 10 then Exit;
    R.Font2Width := Ord(Answer[10]);
    if Length(Answer) < 11 then Exit;
    R.GraphicsStartLine := Ord(Answer[11]);
    if Length(Answer) < 12 then Exit;
    R.InnDigits := Ord(Answer[12]);
    if Length(Answer) < 13 then Exit;
    R.RnmDigits := Ord(Answer[13]);
    if Length(Answer) < 14 then Exit;
    R.LongRnmDigits := Ord(Answer[14]);
    if Length(Answer) < 15 then Exit;
    R.LongSerialDigits := Ord(Answer[15]);
    if Length(Answer) < 19 then Exit;
    R.DefTaxPassword := BinToInt(Answer, 16, 4);
    if Length(Answer) < 23 then Exit;
    R.DefSysPassword := BinToInt(Answer, 20, 4);
    if Length(Answer) < 24 then Exit;
    R.BluetoothTable := Ord(Answer[24]);
    if Length(Answer) < 25 then Exit;
    R.TaxFieldNumber := Ord(Answer[25]);
    if Length(Answer) < 27 then Exit;
    R.MaxCommandLength := BinToInt(Answer, 26, 2);
    if Length(Answer) < 28 then Exit;
    R.GraphicsWidthInBytes := Ord(Answer[28]);
    if Length(Answer) < 29 then Exit;
    R.Graphics512WidthInBytes := Ord(Answer[29]);
    if Length(Answer) < 31 then Exit;
    R.Graphics512MaxHeight := BinToInt(Answer, 30, 2);
  end;
end;

(******************************************************************************
  ������������ ����� � ����������� ���

  ��� ������� FF06h . ����� ���������: 40 ����.
  ������ ���������� ��������������: 4 �����
  ��� : 12 ���� ASCII
  ��������������� ����� ���: 20 ���� ASCII
  ��� ���������������: 1 ����
  ����� ������: 1 ����

  �����: FF06h ����� ���������: 9 ����.
  ��� ������: 1 ����
  ����� ��: 4 �����
  ���������� �������: 4 �����

******************************************************************************)

function TFiscalPrinterDevice.FSFiscalization(const P: TFSFiscalization;
  var R: TFDDocument): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$06 +
    IntToBin(GetSysPassword, 4) +
    AddTrailingSpaces(P.TaxID, 12) +
    AddTrailingSpaces(P.RegID, 20) +
    Chr(P.TaxCode) +
    Chr(P.WorkMode);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.DocNumber := BinToInt(Answer, 1, 4);
    R.DocMac := BinToInt(Answer, 5, 4);
  end;
end;

function TFiscalPrinterDevice.FSReFiscalization(const P: TFSReFiscalization;
  var R: TFDDocument): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$34 +
    IntToBin(GetSysPassword, 4) +
    AddTrailingSpaces(P.TaxID, 12) +
    AddTrailingSpaces(P.RegID, 20) +
    Chr(P.TaxCode) +
    Chr(P.WorkMode) +
    Chr(P.ReasonCode);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.DocNumber := BinToInt(Answer, 1, 4);
    R.DocMac := BinToInt(Answer, 5, 4);
  end;
end;

function TFiscalPrinterDevice.IsCapFooterFlag: Boolean;
begin
  Result := FCapFooterFlag;
end;

procedure TFiscalPrinterDevice.SetFooterFlag(Value: Boolean);
begin
  FFooterFlag := Value;
end;

function TFiscalPrinterDevice.GetOnPrinterStatus: TNotifyEvent;
begin
  Result := FOnPrinterStatus;
end;

procedure TFiscalPrinterDevice.SetOnPrinterStatus(Value: TNotifyEvent);
begin
  FOnPrinterStatus := Value;
end;

procedure TFiscalPrinterDevice.SetPrinterStatus(Value: TPrinterStatus);
begin
  if not IsEqual(FPrinterStatus, Value) then
  begin
    FPrinterStatus := Value;

    Logger.Debug(Format('Mode: $%.2x, amode: $%.2x, Flags: $%.4x',
      [FPrinterStatus.Mode, FPrinterStatus.AdvancedMode, FPrinterStatus.Flags.Value]));

    if Assigned(FOnPrinterStatus) then
      FOnPrinterStatus(Self);
  end;
end;

function TFiscalPrinterDevice.IsCapBarcode2D: Boolean;
begin
  Result := FCapBarcode2D;
end;

function TFiscalPrinterDevice.IsCapEnablePrint: Boolean;
begin
  Result := FCapEnablePrint;
end;

function TFiscalPrinterDevice.ReadFSDocument(Number: Integer): WideString;
var
  P: TFSReadDocument;
begin
  Result := '';
  P.Number := Number;
  P.Password := FSysPassword;
  Check(FSReadDocument(P));
  Result := ReadDocData;
end;

function TFiscalPrinterDevice.ReadDocData: WideString;
var
  FSDocData: TFSReadDocData;
begin
  Result := '';
  FSDocData.Password := FSysPassword;
  while FSReadDocData(FSDocData) = 0 do
  begin
    Result := Result + FSDocData.TLVData;
  end;
  Result := TLVToText(Result);
end;

procedure TFiscalPrinterDevice.PrintFSDocument(Number: Integer);
begin
  PrintText(PRINTER_STATION_REC, ReadFSDocument(Number));
end;

(*
��������� ���������� �������� � TLV �������
��� ������� FF3�h . ����� ���������: 10 ����.
  ������ ���������� ��������������: 4 �����
  ����� ����������� ���������: 4 �����
�����: FF3�h ����� ���������: 5 ����.
  ��� ������: 1 ����
  ��� ����������� ���������: 2 ����� STLV
  ����� ����������� ���������: 2 �����
*)

function TFiscalPrinterDevice.FSReadDocument(var P: TFSReadDocument): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$3A + IntToBin(P.Password, 4) + IntToBin(P.Number, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 4);
    P.DocType := BinToInt(Answer, 1, 2);
    P.DocLength := BinToInt(Answer, 3, 2);
  end;
end;

(*
������ TLV ����������� ���������
��� ������� FF3Bh . ����� ���������: 6 ����.
  ������ ���������� ��������������: 4 �����
�����: FF3Bh ����� ���������: 1+N ����.
  ��� ������:1 ����
  TLV ���������: N ����

*)

function TFiscalPrinterDevice.FSReadDocData(var P: TFSReadDocData): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$3B + IntToBin(P.Password, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    P.TLVData := Answer;
  end;
end;

function TFiscalPrinterDevice.FSStartOpenDay: Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$41 + IntToBin(FSysPassword, 4);
  Result := ExecuteData(Command, Answer);
end;

procedure TFiscalPrinterDevice.EkmCheckBarcode(const Barcode: TGS1Barcode);
var
  Client: TEkmClient;
  SaleEnabled: Boolean;
begin
  Client := TEkmClient.Create;
  try
    Client.Host := Parameters.EkmServerHost;
    Client.Port := Parameters.EkmServerPort;
    Client.Timeout := Parameters.EkmServerTimeout;
    SaleEnabled := Client.ReadSaleEnabled(Barcode.GTIN, Barcode.Serial);
    if not SaleEnabled then
      raiseError(E_SALE_NOT_ENABLED, _('������� ������ ���������'));
  finally
    Client.Free;
  end;
end;

function TFiscalPrinterDevice.CheckItemCode(const Barcode: WideString): Integer;
var
  CheckItemCode: TFSCheckItemCode;
  CheckItemResult: TFSCheckItemResult;
begin
  Result := 0;
  if Barcode = '' then Exit;
  if Parameters.CheckItemCodeEnabled then
  begin
    if Result = 0 then
    begin
      CheckItemCode.ItemStatus := Parameters.NewItemStatus;
      CheckItemCode.ProcessMode := 0;
      CheckItemCode.TLVData := '';
      CheckItemCode.CMData := Barcode;

      Result := FSCheckItemCode(CheckItemCode, CheckItemResult);
      if Result = 0 then
      begin
        CheckCorrectItemCode(CheckItemResult);
      end;
    end;
  end;
end;

procedure TFiscalPrinterDevice.CheckCorrectItemCode(const P: TFSCheckItemResult);
begin

  if P.LocalCheckResult = SMFP_LOCAL_CHECK_FAILED then
    raise Exception.Create(_('Barcode is not valid'));

(*
  if (P.ProcessingCode = 0) then
  begin
    if P.SellPermission <> SMFP_SELL_PERMISSION_OK then
      raise Exception.Create(_('Item is forbidden to sold'));

    if P.ServerResult <> SMFP_SERVER_RESULT_OK then
      raise Exception.Create(getServerResultCodeText(P.ServerResult));
  end;
*)
end;

function TFiscalPrinterDevice.IsCorrectItemCode(const P: TFSCheckItemResult): Boolean;
begin
  if P.LocalCheckResult = SMFP_LOCAL_CHECK_FAILED then
  begin
    Result := False;
    Exit;
  end;
(*
  if (P.ProcessingCode = 0) then
  begin
    if P.SellPermission <> SMFP_SELL_PERMISSION_OK then
    begin
      Result := False;
      Exit;
    end;
    if P.ServerResult <> SMFP_SERVER_RESULT_OK then
    begin
      Result := False;
      Exit;
    end;
  end;
*)
  Result := True;
end;


function TFiscalPrinterDevice.SendItemBarcode(const Barcode: WideString;
  MarkType: Integer): Integer;
var
  Data: AnsiString;
begin
  Data := BarcodeTo1162Value(Barcode);
  Data := TTLVTag.Int2ValueTLV(1162, 2) + TTLVTag.Int2ValueTLV(Length(Data), 2) + Data;
  Result := FSWriteTLVOperation(Data);
end;

function GetEANCrc(const data: string): Integer;
var
  i: Integer;
  len: Integer;
  sum: Integer;
begin
	sum := 0;
	len := Length(data);
	for i:=1 to Length(data) do
	begin
		if (len mod 2) = 0 then
			sum := sum + (StrToInt(data[i])*1)
		else
			sum := sum + (StrToInt(data[i])*3);
		dec(len);
	end;
  sum := sum mod 10;
	if sum <> 0 then
		sum := 10 - sum;
  Result := sum;
end;

function CheckEANCRC(const Barcode: AnsiString): Boolean;
var
  Crc: Integer;
begin
  Result := False;
  if Length(Barcode) > 1 then
  begin
    Crc := GetEANCrc(Copy(Barcode, 1, Length(Barcode)-1));
    Result := Crc = StrToInt(Barcode[Length(Barcode)]);
  end;
end;

function TFiscalPrinterDevice.BarcodeTo1162Value(
  const Barcode: AnsiString): AnsiString;
var
  gtin: AnsiString;
  serial: AnsiString;
  Data: AnsiString;
  Tokens: TGS1Tokens;
  BarcodeType: Integer;
begin
  Data := Barcode;
  BarcodeType := KTN_UNKNOWN;
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeGS1(Barcode);
    if Tokens.HasItem('01') and Tokens.HasItem('21') then
    begin
      BarcodeType := KTN_DM;
      gtin := Tokens.ItemByID('01').Data;
      if Length(gtin) > 24 then
        gtin := Copy(gtin, 1, 24);

      Data := IntToBinBE(StrToInt64(gtin), 6);
      serial := Tokens.ItemByID('21').Data;
      Data := Data + Serial;

      if Tokens.HasItem('8005') then
      begin
        Data := Data + Tokens.ItemByID('8005').Data;
      end;
    end else
    begin
      case Length(Barcode) of
        8:
          if IsMatch(Barcode, '\d+') and CheckEANCRC(Barcode) then
          begin
            BarcodeType := KTN_EAN8;
            Data := IntToBinBE(StrToInt64(Barcode), 6);
          end;

        10:
          if IsMatch(Barcode, '\d+') then
          begin
            BarcodeType := KTN_FUEL;
            Data := IntToBinBE(StrToInt64(Barcode), 6);
          end;

        13:
          if IsMatch(Barcode, '\d+') and CheckEANCrc(Barcode) then
          begin
            BarcodeType := KTN_EAN13;
            Data := IntToBinBE(StrToInt64(Barcode), 6);
          end;

        14:
          if IsMatch(Barcode, '\d+') then
          begin
            BarcodeType := KTN_ITF14;
            Data := IntToBinBE(StrToInt64(Barcode), 6);
          end;

        21:
          // �������� �� ������ '��-������-�����������'
          if IsMatch(Barcode, '\w{2}-\d{6}-\w{11}') then
            BarcodeType := KTN_RF;

        29:
        begin
          BarcodeType := KTN_DM;
          gtin := Copy(Barcode, 1, 14);
          Data := IntToBinBE(StrToInt64(gtin), 6);
          Data := Data + Copy(Barcode, 15, 11) + '  ';
        end;

        68:
        begin
          BarcodeType := KTN_EGAIS2;
          Data := Copy(Barcode, 9, 23);
        end;

        150:
        begin
          BarcodeType := KTN_EGAIS3;
          Data := Copy(Barcode, 1, 14);
        end;
      end;
    end;
    if BarcodeType = KTN_UNKNOWN then
      Data := Copy(Barcode, 1, 30);

  finally
    Tokens.Free;
  end;
  Result := IntToBinBE(BarcodeType, 2) + Data;
end;

function TFiscalPrinterDevice.FSWriteTLVOperation(const AData: AnsiString): Integer;
var
  Data: AnsiString;
  Command: AnsiString;
  Answer: AnsiString;
begin
  Result := 0;
  Data := FilterTLV(AData);
  if Length(Data) = 0 then Exit;

  if Length(Data) > 249 then
    raiseException(_('TLV data length too big'));

  Command := #$FF#$4D + IntToBin(FSysPassword, 4) + Copy(Data, 1, 249);
  Result := ExecuteData(Command, Answer);
end;

(*
������ ������������ ���� ���������
��� ������� FF35h . ����� ���������: 6 ����.
������ ���������� ��������������: 4 �����
�����: FF35h ����� ���������: 1 ����.
��� ������: 1 ����
*)

function TFiscalPrinterDevice.FSStartCorrectionReceipt: Integer;
var
  Command: AnsiString;
  Answer: AnsiString;
begin
  Command := #$FF#$35 + IntToBin(FSysPassword, 4);
  Result := ExecuteData(Command, Answer);
end;

function TFiscalPrinterDevice.GetLastDocNumber: Int64;
begin
  Result := FLastDocNumber;
end;

function TFiscalPrinterDevice.GetLastDocMac: Int64;
begin
  Result := FLastDocMac;
end;

function TFiscalPrinterDevice.GetLastDocTotal: Int64;
begin
  Result := FLastDocTotal;
end;

function TFiscalPrinterDevice.GetLastDocDate: TPrinterDate;
begin
  Result := FLastDocDate;
end;

function TFiscalPrinterDevice.GetLastDocTime: TPrinterTime;
begin
  Result := FLastDocTime;
end;

function TFiscalPrinterDevice.FSReadLastDocNum2: Int64;
var
  FSState: TFSState;
begin
  Result := 0;
  if CapFiscalStorage then
  begin
    Check(FSReadState(FSState));
    Result := FSState.DocNumber;
  end;
end;

function TFiscalPrinterDevice.FSReadLastDocNum: Int64;
begin
  if FLastDocNumber = 0 then
    FLastDocNumber := FSReadLastDocNum2;
  Result := FLastDocNumber;
end;

function TFiscalPrinterDevice.FSReadLastMacValue: Int64;
begin
  if FLastDocMac = 0 then
    FLastDocMac := FSReadLastMacValue2;
  Result := FLastDocMac;
end;

function TFiscalPrinterDevice.FSReadLastMacValue2: Int64;
var
  LastMacValue: Int64;
begin
  LastMacValue := 0;
  if CapFiscalStorage then
  begin
    Check(FSReadDocMac(LastMacValue));
  end;
  Result := LastMacValue;
end;

(******************************************************************************
  �������� �������������� ������

  ��� ������� 	FF61h. ����� ���������: 10+X+Y ����.
  ������ ��������� (4 �����)
  ������� ������ (4+X+Y ����)

  ������ ������� ������:

  ��������	�����	��������	��������
  0	1 ����	����������� ������	��� 2003
  1	1 ����	����� ���������	��� 2102 (������ ������ "0")
  2	1 ����	����� ���� ���������� (��) � ������ (X)	������ ����� ��
  3	1 ����	����� ������ TLV � ������	������ ����� ������ TLV
  4	X ����	��	��� ��, ��� �� ��� �������� ��������
  4+X	Y ����	������ TLV	���� ����������� ��������� ������� ��������������
            ������ (�������� � ����� 2003), �� ���������� ������������ �����
            �� ����� 2108 (����) � 1023 (����������) � �������� ��� �����

  �����:		FF61h. ����� ���������: 9+X ����.
  ��� ������ (1 ����)
  ��������� �������� (6+N ����)

  ������ ������ ���������� ��������:

  ��������	�����	��������	��������	����������
  0	1 ����	������ ��������� ��������	��� 2004
  1	1 ����	�������, �� ������� �� ���� ��������� ��������� ��������
  2	1 ����	������������ ��� ��	��� 2100
  3	1 ����	����� �������������� ����������	����� ������, ������ �����
            ���� ���������� ����� ��� ���� ������ �� ������� � ������� ��������, �� "0"
  4	1 ����	��� ������ �� �� ������� ������-��������
            � ������������ � ������ ������ ��	���� 0x20, �� � ��������� �����
            ������������ ������� � ������������ � ����������� 2 ����
  5	1 ����	��������� �������� ��	��� 2106	������ ���� ������ ������� ��� ������
  6	N ����	������ ���������� ������ �������	TLV List	������ ���� ������ ������� ��� ������

******************************************************************************)

function TFiscalPrinterDevice.FSCheckItemCode(P: TFSCheckItemCode;
  var R: TFSCheckItemResult): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  P.CMData := CorrectGS1(P.CMData);
  Command := #$FF#$61 + IntToBin(FSysPassword, 4) +
    Chr(P.ItemStatus) + Chr(P.ProcessMode) +
    Chr(Length(P.CMData)) + Chr(Length(P.TLVData)) +
    P.CMData + P.TLVData;

  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 4);
    R.LocalCheckResult := Ord(Answer[1]);
    R.LocalCheckError := Ord(Answer[2]);
    R.SymbolicType := Ord(Answer[3]);
    R.DataLength := Ord(Answer[4]);
    if R.DataLength > 1 then
    begin
      R.FSResultCode := Ord(Answer[5]);
      R.ServerCheckStatus := Ord(Answer[6]);
      R.ServerTLVData := Copy(Answer, 7, Length(Answer));
    end;
  end;
end;

(******************************************************************************

  ���������������� �������� �� ��������� ��

  ��� ������� 	FF62h. ����� ���������: 6 ����.
    ������ ���������� �������������� (4 �����)

  �����: 		FF62h. ����� ���������: 3 �����.
      ��� ������ (1 ����)

******************************************************************************)

function TFiscalPrinterDevice.FSSyncRegisters: Integer;
var
  Command: AnsiString;
begin
  Command := #$FF#$62 + IntToBin(FSysPassword, 4);
  Result := ExecuteData(Command);
end;


(******************************************************************************

  ������ ������� ��������� ������ � ��

  ��� ������� 	FF63h. ����� ���������: 6 ����.
  ������ ���������� �������������� (4 �����)

  �����: 		FF63h. ����� ���������: 11 ����.
  ��� ������ (1 ����)
  ������ ������ 5 ������� �������� 1 (4 �����)
  ������ ������ 30 �������� �������� 2 (4 �����)
  ������ ��� �������� ����������� � ���������� �������������� ������3 (1 ����)
  ����������:
  1 - ��������������� ���������� ����������, ������� ����� ������� � ��.
  2 - ������ ��������� ������� (� ����������) ��� ������ ���������� 30 ���� ��������.
      ����� 30 ���� ������ �������� ����� ���������� �� ���������� ������.
  3 - ������� ���������� ������� �������� ����������� � ���������� �������������
      ������� ��� ����. �������� �� ������������ ���� �� ��������������� �
      ������ ��� ��������� ������ � ������������� ��������.

******************************************************************************)

function TFiscalPrinterDevice.FSReadMemory(var R: TFSReadMemoryResult): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$63 + IntToBin(FSysPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R.FreeDocCount := BinToInt(Answer, 1, 4);
    R.FreeMemorySizeInKB := BinToInt(Answer, 5, 4);
    R.UsedMCTicketStorageInPercents := BinToInt(Answer, 5, 4);
  end;
end;

(******************************************************************************

  �������� � �� TLV �� ������

  ��� ������� 	FF64h. ����� ���������: 6 ����.
  ������ ���������� �������������� (4 �����)

  �����: 		FF64h. ����� ���������: 3 �����.
  ��� ������ (1 ����)
  ����������:
  ��������� �������� � �� �������������� ����������� � ����� TLV ���������.
  ��������� �������� TLV ������� 250 ����. ����� ��� �� ��� � ��� �������� ����������.

******************************************************************************)

function TFiscalPrinterDevice.FSWriteTLVFromBuffer: Integer;
var
  Command: AnsiString;
begin
  Command := #$FF#$64 + IntToBin(FSysPassword, 4);
  Result := ExecuteData(Command);
end;

(******************************************************************************

  �������� ��������� ������������������

  ��� ������� 	FF65h. ����� ���������: 6 ����.
  ������ ��������� (4 �����)

  �����: 		FF65h. ����� ���������: 19 ����.
  ��� ������ (1 ����)
  ������ (16 ����)

******************************************************************************)

function TFiscalPrinterDevice.FSRandomData(var Data: AnsiString): Integer;
var
  Command: AnsiString;
begin
  Command := #$FF#$65 + IntToBin(FSysPassword, 4);
  Result := ExecuteData(Command, Data);
end;

(******************************************************************************
  ��������������
  ��� ������� 	FF66h. ����� ���������: 22 �����.
  ������ ��������� (4 �����)
  ������ ��� ����������� (16 ����)

  �����: 		FF66h. ����� ���������: 3 �����.
  ��� ������ (1 ����)

******************************************************************************)

function TFiscalPrinterDevice.FSAuthorize(const DataToAuthorize: AnsiString): Integer;
var
  Command: AnsiString;
begin
  Command := #$FF#$66 + IntToBin(FSysPassword, 4) + Copy(DataToAuthorize, 1, 16);
  Result := ExecuteData(Command);
end;

(******************************************************************************

  �������� �������������� ������ � �������

  ��� ������� 	FF67h. ����� ���������: 7+N ����.
  ������ ��������� (4 �����)
  ����� ���� ���������� (1 ����)
  ������ ���������� (N ����)
  ������� ��� (1 ����) 1 �������-�������� ���� (���)

  �����: 		FF67h. ����� ���������: 6+(6+N)4 ����.
  ��� ������ (1 ����)
  ������������ ��� ���� (2 �����) 2
  ��� Data Matrix (1 ����) 3
  0 - �� 88
  1 - �� ������������
  2 - �� ��������
  3 - �� 44
  0 xFF- GS-1 ��� ����������
  ��������� �������� (6+N ����)4 ����� ������������� (��. ���������� 1)

  ����������:
  1 - ����� �������������. ��� ���������� ������� �� ��� ���� �������� �������� 0xFF.
  2 - ������� ���������� ��������:
  ��� ����	��������
  EAN8	0x45 0x08
  EAN13	0x45 0x0D
  ITF14	0x49 0x0E
  GS-1 Data Matrix		0x44 0x4D
  RF ����� ������� �������	0x52 0x46
  �����-3	0xC5 0x14
  �����-3	0xC5 0x1E
  ��� EAN8		0x4F 0x08
  ��� EAN13	0x4F 0x0D
  ��� GTIN ITF14	0x4F 0x0E
  �������������� ���	0x00 0x00
  3 - ���� ����� ����� ������ ���� ��� ��������� ��� GS-1 Data Matrix, � ��������� ������ ��������� �������� 0.
  4 - � ������ ���� ��� ���������� �� ���������� ����� �������� FF61h "�������� �������������� ������", ��� ���� � ������ � ������� ����� �� �� � ������ �� ������� FF67h.


  ������ ������ ���������� ��������:

  ��������	�����	��������	��������	����������
  0	1 ����	������ ��������� ��������	��� 2004
  1	1 ����	�������, �� ������� �� ���� ��������� ��������� ��������	��. ���������� 2 ����
  2	1 ����	������������ ��� ��	��� 2100
  3	1 ����	����� �������������� ����������	����� ������, ������ �����	���� ���������� �����, �� "0"
  4	1 ����	��� ������ �� �� ������� ������-��������	� ������������ � ������ ������ ��	���� 0x20, �� � ��������� ����� ������������ ������� � ������������ � ����������� 3 ����
  �������� 0xFF, ���� ������ �� ������� � ������� ��������.
  5	1 ����	��������� �������� ��	��� 2106	������ ���� ������ ������� ��� ������
  6	N ����	������ ���������� ������ �������	TLV List	������ ���� ������ ������� ��� ������

******************************************************************************)


function TFiscalPrinterDevice.FSBindItemCode(P: TFSBindItemCode;
  var R: TFSBindItemCodeResult): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  P.Code := CorrectGS1(P.Code);
  Command := #$FF#$67 + IntToBin(FUsrPassword, 4) + Chr(Length(P.Code)) + P.Code;
  if P.IsAccounted then
    Command := Command + #$FF;

  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 3);
    R.ItemCode := BinToInt(Answer, 1, 2);
    R.CodeType := BinToInt(Answer, 3, 1);
    if Length(Answer) >= 7 then
    begin
      R.CheckResult.LocalCheckResult := Ord(Answer[4]);
      R.CheckResult.LocalCheckError := Ord(Answer[5]);
      R.CheckResult.SymbolicType := Ord(Answer[6]);
      R.CheckResult.DataLength := Ord(Answer[7]);
      if R.CheckResult.DataLength > 1 then
      begin
        R.CheckResult.FSResultCode := Ord(Answer[8]);
        R.CheckResult.ServerCheckStatus := Ord(Answer[9]);
        R.CheckResult.ServerTLVData := Copy(Answer, 10, Length(Answer));
      end;
    end;
  end;
end;

(******************************************************************************

  �������� ��������� �� �������� ����������� � ���������� ������������� �������
  ��� ������� 	FF68h. ����� ���������: 6 ����.
  ������ ��������� (4 �����)
  �����:		FF68h. ����� ���������: 13 ����.
  ��� ������ (1 ����)

  ������������	���	�����	��������
  ��������� �� �������� �����������	Byte	1	0 - ��� ��������� ������;
  1 - ������ ������ �����������;
  2 - �������� ��������� �� �����������;
  ���������� ����������� � �������	Uint16, LE	2	0, ���� �� ��� ����������� ���� �������� ���������
  ����� �������� �����������	Uint32, LE	4	����� ����������� ��� ��������, ��� �����������, �� ������� ��������� ���������
  ���� � ����� �������� �����������	DATE_TIME	5	0, ���� �� ��� ����������� �������� ���������
  ������� ���������� ������� �������� �����������	Byte	1

  ��� ������ (1 ����) ����� ��������� ��������� ��������:
  ��� ������	��������	����������� (�������� ���)

  00h	��� ������

  02h	�������� ��������� ��	�� ��� ����������� � ���������� ������ ��� ���
      ������ ������ ����������� � ��������� �� �������� ����������� �����
      �������� "1" - "������ ������ �����������": ���������� ��������� ���
      �������� ������� ������ �����������

  32h	��������� ������ � �������������� ��������	��� ����������� �� �� ���
      ������ ������� ������ � �������������� ��������

******************************************************************************)

function TFiscalPrinterDevice.FSReadTicketStatus(var R: TFSTicketStatus): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$68 + IntToBin(FUsrPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 13);
    R.TicketStatus := BinToInt(Answer, 1, 1);
    R.TicketCount := BinToInt(Answer, 2, 2);
    R.TicketNumber := BinToInt(Answer, 4, 4);
    R.TicketDate := BinToPrinterDateTime2(Copy(Answer, 8, 5));
    R.TicketStorageUsageInPercents := Ord(Answer[13]);
  end;
end;

(******************************************************************************

  ������� ��� ���������� ��������� ��� ���������� FF69H

  ��� ������� FF69h. ����� ���������: 7 ����.
  ������ ���������: 4 �����
  ������� : 1 ����. 0 - ����������, 1 - �������, 2 - �������� ����� ��
  ������� ���������� �������� ����� �������� ������� ��.

  �����: FF69h	    ����� ���������: 1 ����.
  ��� ������: 1 ����

******************************************************************************)

function TFiscalPrinterDevice.FSAcceptItemCode(Action: Integer): Integer;
var
  Command: AnsiString;
begin
  Command := #$FF#$69 + IntToBin(FUsrPassword, 4) + Chr(Action);
  Result := ExecuteData(Command);
end;

function TFiscalPrinterDevice.FSClearMCCheckResults: Integer;
begin
  Result := FSAcceptItemCode(2);
end;


(******************************************************************************

  ������ ������� �� ������ � ������ ����������

  ��� ������� 	FF70h. ����� ���������: 6 ����.
  ������ ��������� (4 �����)

  �����:		FF70h. ����� ���������: 11 ����.
  ��� ������ (1 ����)
  ������ ������ � ������ ���������� (8 ����)

  ������������	���	�����	��������
  ��������� �� �������� ��	Byte	1	0 - ������� �������� �� �����������
    1 - ��� �� �� ��������
    2 - ������� �� � ������� B1h
    3 - ����������� ������ � ���� ���������� ��� ������ ������� B5h
    4 - ������� � ������� � �� ����� �� ������ ��� ������ ������� B6h
  ��������� �� ������������ ����������� � ���������� �������������� ������	Byte	1
    0 - ����������� � ���������� �������������� ������ �� �����������
    1 - ������ ������������ ����������� � ���������� �������������� ������
    2 - ������������ ����������� ������������� ��-�� ������������ ������� ���������� ��������
  ����� ���������� ������ ������ � ��	Byte	1	��. ������� "����� ���������� ������ ������ � ��" ����
  ���������� ����������� ����������� �������� ��	Byte	1
  ���������� ��, ���������� �������� ������� ��������� � �� �������� B2h c ����� "1"
  ���������� ��, ���������� � ����������� � ���������� �������������� ������	Byte	1
  �������������� � ���������� ������� �������� ����������� � ���������� �������������� ������	Byte	1
    � ���� ��������� �� ����������� ��� � ���������� ������� �������� ����������� � ���������� �������������� ������.
    ��������� ��������� �������� ���������:
    0 - ������� ��������� ����� ��� �� 50%
    1 - ������� ��������� �� 50 �� 80%
    2 - ������� ��������� �� 80 �� 90%
    3 - ������� ��������� ����� ��� �� 90%
    4 - ������� ��������� ���������, ������������ ����� ����������� ����������
  ���������� ����������� � �������	Uint16, LE	2
    ���������� ��������������� ��� ������������� ����������� � ���������� �������������� ������
  ����� ���������� ������ ������ � ��

  ��� 7	��� 6	��� 5	��� 4	��� 3	��� 2	��� 1	��� 0	��� ����������� �������
  0	0	0	0	0	0	0	1	B1h
  0	0	0	0	0	0	1	0	B2h
  0	0	0	0	0	1	0	0	B3h
  0	0	0	0	1	0	0	0	B5h
  0	0	0	1	0	0	0	0	B6h
  0	0	1	0	0	0	0	0	B7h � �������������� ����� 1
  0	1	0	0	0	0	0	0	B7h � �������������� ����� 2
  1	0	0	0	0	0	0	0	B7h � �������������� ����� 3

******************************************************************************)

function TFiscalPrinterDevice.FSReadMarkStatus(var R: TFSMarkStatus): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$70 + IntToBin(FUsrPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.MarkCheckStatus := Ord(Answer[1]);
    R.TicketStatus := Ord(Answer[2]);
    R.CommandFlags := Ord(Answer[3]);
    R.MCSavedCount := Ord(Answer[4]);
    R.MCTicketCount := Ord(Answer[5]);
    R.TicketStorageStatus := Ord(Answer[6]);
    R.TicketCount := BinToInt(Answer, 7, 2);
  end;
end;

(******************************************************************************

  ������ �������� ����������� � ���������� ������������� ������� (� ���������� ������)

  ��� ������� 	FF71h. ����� ���������: 6 ����.
  ������ ��������� (4 �����)

  �����:		FF71h. ����� ���������: 11 ����.
  ��� ������ (1 ����)
  ����� ����� ����������� (2 �����)
  ����� ������� ����������� (4 �����)
  ������ ������� ����������� (2 �����)

******************************************************************************)

function TFiscalPrinterDevice.FSStartReadTickets(var R: TFSTicketParams): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$71 + IntToBin(FUsrPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.TicketCount := BinToInt(Answer, 1, 2);
    R.FirstTicketNumber := BinToInt(Answer, 3, 4);
    R.FirstTicketSize := BinToInt(Answer, 7, 2);
  end;
end;

(******************************************************************************

  ��������� ���� ����������� (� ���������� ������)

  ��� ������� 	FF72h. ����� ���������: 6 ����.
  ������ ���������: 4 �����

  �����:		FF72h. ����� ���������: 11+N ����.
  ��� ������ (1 ����)
  ����� �������� ����������� (4 �����)
  ������ ������ �������� ����������� (2 �����)
  �������� �� ������ �������� ����������� (2 �����)
  ���� ������ (N ����)

  ����������:
  ��� ��������� ��������� ������ ���� ��������� �����������
  (����������� ��� ����� ��������� ���� 128 ����).
  ������� �������� ������� �� ��������� ������ "��� ������" ��� �� ���������
  ������ ����� �����������, ����������� ������� ������� FF71h.
  ����������� ��������� ���� ����� ����������� � ����������� ��.
  � ����� ������ �� ������������� ������ ����� ������� ������� FF71h �
  ������ ������ ���������������� ����������� ������.

******************************************************************************)

function TFiscalPrinterDevice.FSReadNextTicket(var R: TFSTicketData): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$72 + IntToBin(FUsrPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.Number := BinToInt(Answer, 1, 4);
    R.Size := BinToInt(Answer, 5, 2);
    R.Offset := BinToInt(Answer, 7, 2);
    R.Data := Copy(Answer, 9, Length(Answer));
  end;
end;

(******************************************************************************

  ����������� �������� ����������� (� ���������� ������)

  ��� ������� 	FF73h. ����� ���������: 14 ����.
  ������ ��������� (4 �����)
  ����� ����������� (4 �����) ���������� �� ������ �� ������� FF72h
  CRC16 (4 �����) ����������� ����� �����������

  �����:		FF73h. ����� ���������: 3 �����.
  ��� ������ (1 ����)

******************************************************************************)

function TFiscalPrinterDevice.FSConfirmTicket(const P: TFSTicketNumber): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$73 + IntToBin(FUsrPassword, 4) +
    IntToBin(P.Number, 4) + IntToBin(P.Crc16, 4);
  Result := ExecuteData(Command, Answer);
end;

(******************************************************************************

  ������ ���������� ��

  ��� ������� 	FF74h. ����� ���������: 6 ����.
  ������ ��������� (4 �����)

  �����:		FF74h. ����� ���������: 51 ����.
  ��� ������ (1 ����)
  ������ ���������� ��  (48 ����)  ASCII

******************************************************************************)

function TFiscalPrinterDevice.FSReadDeviceInfo(var R: string): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$74 + IntToBin(FUsrPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    R := Answer;
  end;
end;

(******************************************************************************

  ������ ������ ������� ������ ��������� � ��

  ��� ������� 	FF75h. ����� ���������: 14 ����.
  ������ ��������� (4 �����)
  �����:		FF75h. ����� ���������: 11 ����.
  ��� ������ (1 ����)
  ������ � ������ �������� ��������� ��� ��� ( 4 �����)
  ������ � ������ �������� ����������� � ���������� ������������� ������� ��� ���� ( 4 �����)

******************************************************************************)

function TFiscalPrinterDevice.FSReadDocSize(var R: TFSDocSize): Integer;
var
  Answer: AnsiString;
  Command: AnsiString;
begin
  Command := #$FF#$75 + IntToBin(FUsrPassword, 4);
  Result := ExecuteData(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.DocSize := BinToInt(Answer, 1, 4);
    R.TicketSize := BinToInt(Answer, 5, 4);
  end;
end;

procedure TFiscalPrinterDevice.STLVBegin(TagID: Integer);
begin
  FSTLVTag.Items.Clear;
  FSTLVTag.Tag := TagId;
  FSTLVStarted := True;
end;

procedure TFiscalPrinterDevice.STLVAddTag(TagID: Integer;
  TagValue: string);
begin
  if not FSTLVStarted then
    raise Exception.Create('Call STLVBegin first');
  FSTLVTag.Items.Add(TagID).Data := TagToStr(TagID, TagValue);
end;

function TFiscalPrinterDevice.STLVGetHex: string;
begin
  Result := StrToHexText(FSTLVTag.RawData);
end;

procedure TFiscalPrinterDevice.STLVWrite;
begin
  Check(FSWriteTLV(FSTLVTag.RawData));
end;

procedure TFiscalPrinterDevice.STLVWriteOp;
begin
  Check(FSWriteTLVOperation(FSTLVTag.RawData));
end;

procedure TFiscalPrinterDevice.WriteTLVItems;
var
  i: Integer;
begin
  for i := 0 to FTLVItems.Count-1 do
  begin
    FSWriteTLV(FTLVItems[i]);
  end;
  FTLVItems.Clear;
end;

procedure TFiscalPrinterDevice.FSWriteTLV2(const TLVData: AnsiString);
begin
  FTLVItems.Add(TLVData);
end;

procedure TFiscalPrinterDevice.ResetPrinter;
begin
  FTLVItems.Clear;
  if FDocPrintMode = 1 then
    FDocPrintMode := 0;
end;

function TFiscalPrinterDevice.GetDocPrintMode: Integer;
begin
  Result := FDocPrintMode;
end;

procedure TFiscalPrinterDevice.CorrectDate;
var
  PDate: TPrinterDate;
  TimeDiffInSecs: Int64;
  PrinterDate: TDateTime;
  Status: TLongPrinterStatus;
begin
  Logger.Debug('CorrectDate');
  if Parameters.ValidTimeDiffInSecs > 0 then
  begin
    Status := ReadLongStatus;
    PrinterDate := PrinterDateToDate(Status.Date) + PrinterTimeToTime(Status.Time);
    TimeDiffInSecs := SecondsBetween(Now, PrinterDate);
    if TimeDiffInSecs > Parameters.ValidTimeDiffInSecs then
    begin
      PDate := GetCurrentPrinterDate;
      WriteDate(PDate);
      ConfirmDate(PDate);
      SetTime(GetCurrentPrinterTime);
    end;
  end;
end;

procedure TFiscalPrinterDevice.CheckPrinterStatus;

  function GetStateErrorMessage(const Mode: Integer): WideString;
  begin
    Result := Tnt_WideFormat('%s: %d, %s', [_('���������� �������� ���������'), Mode, GetModeText(Mode)]);
  end;

const
  MaxStateCount = 3;
var
  Mode: Byte;
  TickCount: Integer;
  PrinterStatus: TPrinterStatus;
  PrinterDate: TPrinterDate;
  WaitDateCount: Integer;
  ModeTechCount: Integer;
  ModeTestCount: Integer;
  ModePointCount: Integer;
  ModeDumpCount: Integer;
  LockedCount: Integer;
begin
  WaitDateCount := 0;
  ModeTechCount := 0;
  ModeTestCount := 0;
  ModePointCount := 0;
  ModeDumpCount := 0;
  LockedCount := 0;
  TickCount := GetTickCount;
  repeat
    if Integer(GetTickCount) > (TickCount + Parameters.StatusTimeout*1000) then
      raiseException(SStatusWaitTimeout);

    PrinterStatus := ReadPrinterStatus;
    Mode := PrinterStatus.Mode and $0F;

    case Mode of
      // Dump mode
      MODE_DUMPMODE:
      begin
        ReadDocData;
        //Device.StopDump;

        Inc(ModeDumpCount);
        if ModeDumpCount >= MaxStateCount then
          raiseOposException(OPOS_E_FAILURE, GetStateErrorMessage(Mode));
      end;

      // Fiscal day opened, 24 hours is not over
      MODE_24NOTOVER: Exit;

      // Fiscal day opened, 24 hours is over
      MODE_24OVER: Exit;

      // Fiscal day closed
      MODE_CLOSED: Exit;

      // ECR blocked by incorrect tax offecer password
      MODE_LOCKED:
      begin
        if StartDump(1) = 0 then
          StopDump;
        Inc(LockedCount);
        if LockedCount >= MaxStateCount then
          raiseOposException(OPOS_E_FAILURE, GetStateErrorMessage(Mode));
      end;

      // Waiting for date confirm
      MODE_WAITDATE:
      begin
        ConfirmDate(ReadLongStatus.Date);
        Inc(WaitDateCount);
        if WaitDateCount >= MaxStateCount then
          raiseOposException(OPOS_E_FAILURE, GetStateErrorMessage(Mode));
      end;

      // Permission to cange decimal point position
      MODE_POINTPOS:
      begin
        SetPointPosition(PRINTER_POINT_POSITION_2);
        Inc(ModePointCount);
        if ModePointCount >= MaxStateCount then
          raiseOposException(OPOS_E_FAILURE, GetStateErrorMessage(Mode));
      end;

      // Opened document
      MODE_REC: Exit;

      // Tech reset permission
      MODE_TECH:
      begin
        ResetFiscalMemory;
        PrinterDate := GetCurrentPrinterDate;
        WriteDate(PrinterDate);
        ConfirmDate(PrinterDate);
        SetTime(GetCurrentPrinterTime);

        Inc(ModeTechCount);
        if ModeTechCount >= MaxStateCount then
          raiseOposException(OPOS_E_FAILURE, GetStateErrorMessage(Mode));
      end;
      // Test run
      MODE_TEST:
      begin
        StopTest;
        Inc(ModeTestCount);
        if ModeTestCount >= MaxStateCount then
          raiseOposException(OPOS_E_FAILURE, GetStateErrorMessage(Mode));
      end;
      // Full fiscal report printing
      MODE_FULLREPORT:
      begin
        Sleep(Parameters.StatusInterval);
      end;
      // EJ report printing
      MODE_EKLZREPORT:
      begin
        Sleep(Parameters.StatusInterval);
      end;
      // Opened fiscal slip
      MODE_SLP: Exit;
      // Slip printing
      MODE_SLPPRINT: Exit;
      // Fiscal slip is ready
      MODE_SLPREADY: Exit;
    else
      Break;
    end;
  until False;
end;


procedure TFiscalPrinterDevice.SetCapFiscalStorage(const Value: Boolean);
begin
  FCapFiscalStorage := Value;
end;

function TFiscalPrinterDevice.GetTrailerHeight: Integer;
var
  Font: TFontInfo;
begin
  Font := GetFont(Parameters.TrailerFont);
  Result := GetModel.NumTrailerLines * Font.CharHeight;
end;

function TFiscalPrinterDevice.GetFont(Font: Integer): TFontInfo;
begin
  if not ValidFont(Font) then
    Font := 1;
  Result := FFontInfo[Font];
end;

function TFiscalPrinterDevice.GetHeaderHeight: Integer;
var
  Font: TFontInfo;
begin
  if FHeadToCutterDistanse <> 0 then
  begin
    Result := FHeadToCutterDistanse;
  end else
  begin
    Font := GetFont(Parameters.HeaderFont);
    Result := GetModel.NumHeaderLines * Font.CharHeight;
  end;
end;

function TFiscalPrinterDevice.GetTaxInfoList: TTaxInfoList;
begin
  Result := FTaxInfo;
end;

procedure TFiscalPrinterDevice.WriteTaxRate(Tax, Rate: Integer);
begin
  if (Tax < 1)or(Tax > Length(FTaxInfo)) then
    raise Exception.CreateFmt('Invalid tax number, %d', [Tax]);

  WriteTableInt(PRINTER_TABLE_TAX, Tax, 1, Rate);
end;


end.
