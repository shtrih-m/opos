unit FiscalPrinterTypes;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // Opos
  OposUtils,
  // This
  PrinterTypes, BinStream, PrinterCommand, SerialPort, DeviceTables,
  PrinterConnection, DriverTypes, FiscalPrinterStatistics, FixedStrings,
  NotifyLink, PrinterParameters, MalinaParams, DriverContext, TntSysUtils,
  StringUtils;

type
  { TFSDocument1 }

  TFSDocument1 = record
    Date: TPrinterDateTime;
    DocNum: Int64;
    DocMac: Int64;
    TaxID: WideString;
    EcrRegNum: WideString;
    TaxType: Byte;
    WorkMode: Byte;
  end;

  { TFSDocument11 }

  TFSDocument11 = record
    Date: TPrinterDateTime;
    DocNum: Int64;
    DocMac: Int64;
    TaxID: WideString;
    EcrRegNum: WideString;
    TaxType: Byte;
    WorkMode: Byte;
    ReasonCode: Byte;
  end;

  { TFSDocument6 }

  TFSDocument6 = record
    Date: TPrinterDateTime;
    DocNum: Int64;
    DocMac: Int64;
    TaxID: WideString;
    EcrRegNum: WideString;
  end;

  { TFSDocument2 }

  TFSDocument2 = record
    Date: TPrinterDateTime;
    DocNum: Int64;
    DocMac: Int64;
    DayNum: Integer;
  end;

  { TFSDocument3 }

  TFSDocument3 = record
    Date: TPrinterDateTime;
    DocNum: Int64;
    DocMac: Int64;
    OperationType: Byte;
    Amount: Int64;
  end;

  { TFSDocument21 }

  TFSDocument21 = record
    Date: TPrinterDateTime;
    DocNum: Int64;
    DocMac: Int64;
    DocCount: Integer;
    DocDate: TPrinterDateTime;
  end;

  { TFSStatus }

  TFSState = record
    State: Byte;
    Document: Byte;
    DocReceived: Byte;
    DayOpened: Byte;
    WarningFlags: Byte;
    Date: TPrinterDate;
    Time: TPrinterTime;
    FSNumber: string[16];
    DocNumber: Int64;
  end;


  { TFSStatus }

  TFSStatus = record
    DataSize: Word;
    BlockSize: Byte;
  end;

  { TFSBlockRequest }

  TFSBlockRequest = record
    Offset: Word;
    Size: Byte;
  end;

  { TFSBlock }

  TFSBlock = record
    Offset: Word;
    Size: Byte;
    Data: AnsiString;
  end;

  { TFSDocument }

  TFSDocument = record
    DocType: Byte;
    TicketReceived: Boolean;
    TlvData: AnsiString;
    DocType1: TFSDocument1;
    DocType2: TFSDocument2;
    DocType3: TFSDocument3;
    DocType6: TFSDocument6;
    DocType11: TFSDocument11;
    DocType21: TFSDocument21;
  end;

  { TFSFiscalResult }

  TFSFiscalResult = record
    Date: TPrinterDateTime;
    TaxID: WideString;
    EcrRegNum: WideString;
    TaxType: Byte;
    WorkMode: Byte;
    DocNum: Int64;
    DocMac: Int64;
  end;

  { TEJDocument }

  TEJDocument = record
    Text: WideString;
    MACValue: Int64;
    MACNumber: Int64;
  end;

  { TPaperStatus }

  TPaperStatus = record
    IsEmpty: Boolean;
    IsNearEnd: Boolean;
    Status: Integer;
  end;

  { TLoadGraphics3 }

  TLoadGraphics3 = record
    Data: AnsiString;
    FirstLineNum: Word;
    NextLinesNum: Word;
  end;

  { TPrintGraphics3 }

  TPrintGraphics3 = record
    FirstLine: Word;
    LastLine: Word;
    VScale: Byte;
    HScale: Byte;
    Flags: Byte;
  end;

  TCommandEvent = procedure(Sender: TObject; var Command: TCommandRec) of object;

  { IFiscalPrinterFilter }

  IFiscalPrinterFilter = interface
    ['{8A91E3B4-B81A-4E22-B665-83F651BFE8E6}']
    procedure BeforeCashIn;
    procedure BeforeCashOut;
    procedure BeforeCloseReceipt;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(var Operation: TPriceReg);
    procedure Buy(var Operation: TPriceReg);
    procedure RetSale(var Operation: TPriceReg);
    procedure RetBuy(var Operation: TPriceReg);
    procedure Storno(var Operation: TPriceReg);
    procedure ReceiptDiscount(var Operation: TAmountOperation);
    procedure ReceiptCharge(var Operation: TAmountOperation);
    procedure OpenReceipt(var ReceiptType: Byte);
    procedure CloseReceipt(const P: TCloseReceiptParams; const R: TCloseReceiptResult);
    procedure CancelReceipt;
    procedure OpenDay;
    procedure PrintZReport;
  end;

  { TFSReadRegTagCommand }

  TFSReadRegTagCommand = record
    RegID: Byte;
    TagID: Word;
    TLV: AnsiString;
  end;

  { IFiscalPrinterDevice }

  IFiscalPrinterDevice = interface
    procedure Lock;
    procedure Unlock;
    procedure Connect;
    procedure Disconnect;
    procedure OpenDay;
    procedure LoadModels;
    procedure SaveModels;
    procedure FullCut;
    procedure PartialCut;
    procedure InterruptReport;
    procedure StopDump;
    procedure UpdateInfo;
    procedure SetLongSerial(Serial: Int64);
    function SetPortParams(Port: Byte; const PortParams: TPortParams): Integer;
    procedure PrintDocHeader(const DocName: WideString; DocNumber: Word);
    procedure StartTest(Interval: Byte);
    procedure WriteLicense(License: Int64);
    function WriteTableInt(Table, Row, Field, Value: Integer): Integer;
    function WriteTable(Table, Row, Field: Integer; const FieldValue: WideString): Integer;
    function DoWriteTable(Table, Row, Field: Integer; const FieldValue: WideString): Integer;
    procedure SetPointPosition(PointPosition: Byte);
    procedure SetTime(const Time: TPrinterTime);
    procedure WriteDate(const Date: TPrinterDate);
    procedure ConfirmDate(const Date: TPrinterDate);
    procedure InitializeTables;
    procedure CutPaper(CutType: Byte);
    procedure ResetFiscalMemory;
    procedure ResetTotalizers;
    procedure OpenDrawer(DrawerNumber: Byte);
    procedure FeedPaper(Station: Byte; Lines: Byte);
    procedure EjectSlip(Direction: Byte);
    procedure StopTest;
    procedure PrintActnTotalizers;
    procedure PrintStringFont(Station, Font: Byte; const Line: WideString);
    procedure PrintXReport;
    procedure PrintZReport;
    procedure PrintDepartmentsReport;
    procedure PrintTaxReport;
    procedure PrintHeader;
    procedure PrintDocTrailer(Flags: Byte);
    procedure PrintTrailer;
    procedure WriteSerial(Serial: DWORD);
    procedure InitFiscalMemory;
    procedure Check(Value: Integer);
    procedure PrintString(Flags: Byte; const Text: WideString);
    procedure SetSysPassword(const Value: DWORD);
    procedure SetTaxPassword(const Value: DWORD);
    procedure SetUsrPassword(const Value: DWORD);
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure EJTotalsReportDate(const Parameters: TDateReport);
    procedure EJTotalsReportNumber(const Parameters: TNumberReport);
    procedure SetOnCommand(Value: TCommandEvent);
    procedure SetBeforeCommand(Value: TCommandEvent);
    procedure PrintJournal(DayNumber: Integer);
    function GetResultCode: Integer;
    function GetResultText: WideString;
    function StartDump(DeviceCode: Integer): Integer;
    function GetDumpBlock: TDumpBlock;
    function GetLongSerial: TGetLongSerial;
    function ReadShortStatus: TShortPrinterStatus;
    function ReadLongStatus: TLongPrinterStatus;
    function GetFMFlags(Flags: Byte): TFMFlags;
    function PrintBoldString(Flags: Byte; const Text: WideString): Integer;
    function Beep: Integer;
    function GetPortParams(Port: Byte): TPortParams;
    function ReadCashReg2(RegID: Integer): Int64;
    function ReadCashRegister(ID: Integer): Int64;
    function ReadCashReg(ID: Integer; var R: TCashRegisterRec): Integer;
    function ReadOperatingRegister(ID: Byte): Word;
    function ReadOperatingReg(ID: Byte; var R: TOperRegisterRec): Integer;
    function ReadLicense: Int64;
    function ReadTableBin(Table, Row, Field: Integer): WideString;
    function ReadTableStr(Table, Row, Field: Integer): WideString;
    function ReadTableInt(Table, Row, Field: Integer): Integer;
    function ReadFontInfo(FontNumber: Byte): TFontInfo;
    function ReadFMTotals(Flags: Byte; var R: TFMTotals): Integer;
    function OpenSlipDoc(Params: TSlipParams): TDocResult;
    function OpenStdSlip(Params: TStdSlipParams): TDocResult;
    function SlipOperation(Params: TSlipOperation; Operation: TPriceReg): Integer;
    function SlipStdOperation(LineNumber: Byte; Operation: TPriceReg): Integer;
    function SlipDiscount(Params: TSlipDiscountParams; Discount: TSlipDiscount): Integer;
    function SlipStdDiscount(Discount: TSlipDiscount): Integer;
    function SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ContinuePrint: Integer;
    function PrintGraphics(Line1, Line2: Word): Integer;
    function PrintBarcode(const Barcode: WideString): Integer;
    procedure CheckGraphicsSize(Line: Word);
    function LoadGraphics(Line: Word; Data: AnsiString): Integer;
    function PrintBarLine(Height: Word; Data: AnsiString): Integer;
    function GetDeviceMetrics: TDeviceMetrics;
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
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    function GetPrintWidth: Integer; overload;
    function GetPrintWidth(Font: Integer): Integer; overload;
    function GetSysPassword: DWORD;
    function GetTaxPassword: DWORD;
    function GetUsrPassword: DWORD;
    function Sale(Operation: TPriceReg): Integer;
    function Buy(Operation: TPriceReg): Integer;
    function RetSale(Operation: TPriceReg): Integer;
    function RetBuy(Operation: TPriceReg): Integer;
    function Storno(Operation: TPriceReg): Integer;
    function ReceiptClose(const P: TCloseReceiptParams; var R: TCloseReceiptResult): Integer;
    function ReceiptClose2(const P: TFSCloseReceiptParams2; var R: TFSCloseReceiptResult2): Integer;
    function ReceiptDiscount(Operation: TAmountOperation): Integer;
    function ReceiptDiscount2(Operation: TReceiptDiscount2): Integer;
    function ReceiptCharge(Operation: TAmountOperation): Integer;
    function ReceiptCancel: Integer;
    function GetSubtotal: Int64;
    function ReceiptStornoDiscount(Operation: TAmountOperation): Integer;
    function ReceiptStornoCharge(Operation: TAmountOperation): Integer;
    function PrintReceiptCopy: Integer;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function FormatLines(const Line1, Line2: WideString): WideString;
    function FormatBoldLines(const Line1, Line2: WideString): WideString;
    function ExecuteStream2(Stream: TBinStream): Integer;
    function GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: WideString): AnsiString;
    function FieldToStr(FieldInfo: TPrinterFieldRec; const Value: WideString): WideString;
    function BinToFieldValue(FieldInfo: TPrinterFieldRec; const Value: WideString): WideString;
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
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: WideString): Integer;
    function ReadFieldInfo(Table, Field: Byte; var R: TPrinterFieldRec): Integer;
    function Execute(const Data: AnsiString): AnsiString;
    function ExecuteStream(Stream: TBinStream): Integer;
    function ExecutePrinterCommand(Command: TPrinterCommand): Integer;
    function ExecuteData(const Data: AnsiString; var RxData: AnsiString): Integer;
    function ExecuteCommand(var Command: TCommandRec): Integer;
    function SendCommand(var Command: TCommandRec): Integer;
    function GetModel: TPrinterModelRec;
    function GetOnCommand: TCommandEvent;
    function GetTables: TDeviceTables;
    function CapGraphics: Boolean;
    function CapShortEcrStatus: Boolean;
    function CapPrintStringFont: Boolean;
    function CenterLine(const Line: WideString): WideString;
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure Close;
    procedure Open(AConnection: IPrinterConnection);
    procedure SetTables(const Value: TDeviceTables);
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
    procedure PrintText(const Data: TTextRec); overload;
    procedure PrintText(Station: Integer; const Text: WideString); overload;
    procedure WriteParameter(ParamID, ValueID: Integer);
    function ReadParameter(ParamID: Integer): Integer;
    function GetStatistics: TFiscalPrinterStatistics;
    function QueryEJActivation: TEJActivation;
    function GetIsOnline: Boolean;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetOnConnect(const Value: TNotifyEvent);
    procedure SetOnDisconnect(const Value: TNotifyEvent);
    procedure AddFilter(AFilter: IFiscalPrinterFilter);
    procedure RemoveFilter(AFilter: IFiscalPrinterFilter);
    function IsDayOpened(Mode: Integer): Boolean;
    function GetAmountDecimalPlaces: Integer;
    procedure SetAmountDecimalPlaces(const Value: Integer);
    procedure PrintBarcode2(const Barcode: TBarcodeRec);
    function LoadImage(const FileName: WideString; StartLine: Integer): Integer;
    procedure PrintImage(const FileName: WideString; StartLine: Integer);
    procedure PrintImageScale(const FileName: WideString; StartLine, Scale: Integer);
    procedure PrintTextFont(Station: Integer; Font: Integer; const Text: WideString);
    procedure FSWriteTLV2(const TLVData: AnsiString);
    function ReadEJDocumentText(MACNumber: Integer): WideString;
    function ReadEJDocument(MACNumber: Integer; var Line: WideString): Integer;
    function ParseEJDocument(const Text: WideString): TEJDocument;
    function WaitForPrinting: TPrinterStatus;
    function ReadPrinterStatus: TPrinterStatus;
    function FSReadState(var R: TFSState): Integer;
    function FSWriteTLV(const TLVData: AnsiString): Integer;
    function FSSale(P: TFSSale): Integer;
    function FSSale2(P: TFSSale2): Integer;
    function FSReadStatus(var R: TFSStatus): Integer;
    function FSReadBlock(const P: TFSBlockRequest; var Block: AnsiString): Integer;
    function FSStartWrite(DataSize: Word; var BlockSize: Byte): Integer;
    function FSWriteBlock(const Block: TFSBlock): Integer;
    function FSReadBlockData: AnsiString;
    procedure FSWriteBlockData(const BlockData: AnsiString);
    function FSPrintCalcReport(var R: TFSCalcReport): Integer;
    function FSFindDocument(DocNumber: Integer; var R: TFSDocument): Integer;
    function FSReadDocMac(var DocMac: Int64): Integer;
    function FSReadExpiration(var R: TCommandFF03): Integer;
    function FSReadCommStatus(var R: TFSCommStatus): Integer;
    function FSReadFiscalResult(var R: TFSFiscalResult): Integer;
    function FSWriteTag(TagID: Integer; const Data: WideString): Integer;
    function WriteCustomerAddress(const Value: WideString): Integer;
    function FSReadTotals(var R: TFMTotals): Integer;
    function GetErrorText(Code: Integer): WideString;
    function GetCapFiscalStorage: Boolean;
    procedure SetCapFiscalStorage(const Value: Boolean);
    function OpenFiscalDay: Boolean;
    function GetCapReceiptDiscount: Boolean;
    function ReadSysOperatorNumber: Integer;
    function ReadUsrOperatorNumber: Integer;
    function GetTaxInfo(Tax: Integer): TTaxInfo;
    function ReadFPParameter(ParamId: Integer): WideString;
    function GetDiscountMode: Integer;
    function GetIsFiscalized: Boolean;
    function ReadDayTotals: TFMTotals;
    function ReadFPTotals(Flags: Integer): TFMTotals;
    procedure WriteFPParameter(ParamId: Integer; const Value: WideString);
    function FSPrintCorrectionReceipt(var Command: TFSCorrectionReceipt): Integer;
    function FSPrintCorrectionReceipt2(var Data: TFSCorrectionReceipt2): Integer;
    procedure LoadTables(const Path: WideString);
    function FSReadTicket(var R: TFSTicket): Integer;
    function GetParameters: TPrinterParameters;
    function GetContext: TDriverContext;
    function IsRecOpened: Boolean;
    function GetCapDiscount: Boolean;
    function GetCapSubtotalRound: Boolean;
    procedure CancelReceipt;
    function ReadLoaderVersion(var Version: WideString): Integer;
    function FSFiscalization(const P: TFSFiscalization; var R: TFDDocument): Integer;
    function FSReFiscalization(const P: TFSReFiscalization; var R: TFDDocument): Integer;
    function IsCapFooterFlag: Boolean;
    procedure SetFooterFlag(Value: Boolean);
    function GetOnPrinterStatus: TNotifyEvent;
    procedure SetOnPrinterStatus(Value: TNotifyEvent);
    function GetPrinterStatus: TPrinterStatus;
    function IsCapBarcode2D: Boolean;
    function IsCapEnablePrint: Boolean;
    function ReadFSDocument(Number: Integer): WideString;
    procedure PrintFSDocument(Number: Integer);
    function FSStartOpenDay: Integer;
    function CheckItemCode(const Barcode: WideString): Integer;
    function FSWriteTLVOperation(const AData: AnsiString): Integer;
    function SendItemBarcode(const Barcode: WideString; MarkType: Integer): Integer;
    function FSStartCorrectionReceipt: Integer;
    function GetLastDocNumber: Int64;
    function GetLastDocMac: Int64;
    function FSReadLastDocNum: Int64;
    function FSReadLastDocNum2: Int64;
    function FSReadLastMacValue: Int64;
    function FSReadLastMacValue2: Int64;
    function FSCheckItemCode(P: TFSCheckItemCode; var R: TFSCheckItemResult): Integer;
    
    function FSSyncRegisters: Integer;
    function FSReadMemory(var R: TFSReadMemoryResult): Integer;
    function FSWriteTLVFromBuffer: Integer;
    function FSRandomData(var Data: AnsiString): Integer;
    function FSAuthorize(const DataToAuthorize: AnsiString): Integer;
    function FSAcceptItemCode(Action: Integer): Integer;
    function FSBindItemCode(P: TFSBindItemCode; var R: TFSBindItemCodeResult): Integer;
    function FSReadTicketStatus(var R: TFSTicketStatus): Integer;
    function FSReadMarkStatus(var R: TFSMarkStatus): Integer;
    function FSStartReadTickets(var R: TFSTicketParams): Integer;
    function FSReadNextTicket(var R: TFSTicketData): Integer;
    function FSConfirmTicket(const P: TFSTicketNumber): Integer;
    function FSReadDeviceInfo(var R: string): Integer;
    function FSReadDocSize(var R: TFSDocSize): Integer;

    procedure STLVBegin(TagID: Integer);
    procedure STLVAddTag(TagID: Integer; TagValue: string);
    function STLVGetHex: string;
    procedure STLVWrite;
    procedure STLVWriteOp;
    procedure ResetPrinter;
    procedure WriteTLVItems;
    function GetDocPrintMode: Integer;
    function ReadDocData: WideString;
    procedure CheckPrinterStatus;
    procedure CorrectDate;
    function GetLastDocTotal: Int64;
    function GetLastDocDate: TPrinterDate;
    function GetLastDocTime: TPrinterTime;
    function GetHeaderHeight: Integer;
    function GetTrailerHeight: Integer;
    function GetFont(Font: Integer): TFontInfo;

    property LastDocMac: Int64 read GetLastDocMac;
    property LastDocNumber: Int64 read GetLastDocNumber;
    property LastDocTotal: Int64 read GetLastDocTotal;
    property LastDocDate: TPrinterDate read GetLastDocDate;
    property LastDocTime: TPrinterTime read GetLastDocTime;
    property IsOnline: Boolean read GetIsOnline;
    property Model: TPrinterModelRec read GetModel;
    property ResultText: WideString read GetResultText;
    property ResultCode: Integer read GetResultCode;
    property DiscountMode: Integer read GetDiscountMode;
    property IsFiscalized: Boolean read GetIsFiscalized;
    property Parameters: TPrinterParameters read GetParameters;
    property CapFiscalStorage: Boolean read GetCapFiscalStorage write SetCapFiscalStorage;
    property Tables: TDeviceTables read GetTables write SetTables;
    property Statistics: TFiscalPrinterStatistics read GetStatistics;
    property AmountDecimalPlaces: Integer read GetAmountDecimalPlaces write SetAmountDecimalPlaces;
    property CapReceiptDiscount: Boolean read GetCapReceiptDiscount;
    property Context: TDriverContext read GetContext;
    property CapDiscount: Boolean read GetCapDiscount;
    property CapSubtotalRound: Boolean read GetCapSubtotalRound;
    property PrinterStatus: TPrinterStatus read GetPrinterStatus;
    property OnConnect: TNotifyEvent read GetOnConnect write SetOnConnect;
    property OnDisconnect: TNotifyEvent read GetOnDisconnect write SetOnDisconnect;
    property OnPrinterStatus: TNotifyEvent read GetOnPrinterStatus write SetOnPrinterStatus;
  end;

type
  { IFiscalPrinterInternal }

  IFiscalPrinterInternal = interface
    ['{17C01750-13B6-410B-BE0A-92CC9B5FB602}']
    procedure Connect;
    procedure PrintNonFiscalEnd;
    function GetDevice: IFiscalPrinterDevice;
    function GetPrinterSemaphoreName: WideString;
    procedure PrintTextFont(Station, Font: Integer; const Text: WideString);
    property Device: IFiscalPrinterDevice read GetDevice;
  end;

  { ISharedPrinter }

  ISharedPrinter = interface
    ['{91F29940-3969-474C-B6E5-6237FE2FC34C}']
    procedure Close;
    procedure Open(const DeviceName: WideString);
    procedure ReleaseDevice;
    procedure ClaimDevice(Timeout: Integer);
    procedure Connect;
    procedure CutPaper;
    procedure Disconnect;
    procedure ReadTables;
    procedure SaveParameters;
    function GetPrintWidth: Integer;
    function GetPrintWidthInDots: Integer;
    procedure PrintCancelReceipt;
    procedure PrintCurrency(const Line: WideString; Value: Currency);
    procedure PrintDocHeader(const DocName: WideString; DocNumber: Word);
    procedure PrintFakeReceipt;
    procedure PrintLine(Stations: Integer; const Line: WideString);
    procedure PrintLines(const Line1, Line2: WideString);
    procedure PrintRecText(const Text: WideString);
    procedure PrintText(const Text: WideString); overload;
    procedure PrintText(Station: Integer; const Text: WideString); overload;
    procedure PrintText(const Text: WideString; Station: Integer; Font: Integer; Alignment: TTextAlignment); overload;
    procedure Check(Value: Integer);
    function FormatBoldLines(const Line1, Line2: WideString): WideString;
    procedure PrintBoldString(Flags: Byte; const Text: WideString);
    procedure PrintZReport;
    procedure ReceiptCancel;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(Operation: TPriceReg);
    procedure Buy(Operation: TPriceReg);
    procedure RetBuy(Operation: TPriceReg);
    procedure Storno(Operation: TPriceReg);
    procedure RetSale(Operation: TPriceReg);
    procedure ReceiptClose(Params: TCloseReceiptParams);
    procedure ReceiptDiscount(Operation: TAmountOperation);
    procedure ReceiptCharge(Operation: TAmountOperation);
    procedure ReceiptStornoDiscount(Operation: TAmountOperation);
    procedure ReceiptStornoCharge(Operation: TAmountOperation);
    procedure PrintSubtotal(Value: Int64);
    procedure SetCheckTotal(const Value: Boolean);
    procedure LoadLogo(const FileName: WideString);
    procedure PrintImage(const FileName: WideString);
    procedure PrintImageScale(const FileName: WideString; Scale: Integer);
    procedure SetOnProgress(const Value: TProgressEvent);
    procedure PrintSeparator(SeparatorType, SeparatorHeight: Integer);
    function GetHeader: TFixedStrings;
    function GetTrailer: TFixedStrings;
    function GetDeviceName: WideString;
    function GetDevice: IFiscalPrinterDevice;
    function GetCheckTotal: Boolean;
    function GetOnProgress: TProgressEvent;
    function GetPollEnabled: Boolean;
    procedure SetPollEnabled(const Value: Boolean);
    procedure AddStatusLink(Link: TNotifyLink);
    procedure AddConnectLink(Link: TNotifyLink);
    procedure RemoveStatusLink(Link: TNotifyLink);
    function GetStation: Integer;
    procedure SetStation(Value: Integer);
    function GetPostLine: WideString;
    function GetPreLine: WideString;
    procedure SetPostLine(const Value: WideString);
    procedure SetPreLine(const Value: WideString);
    procedure PrintLogo;
    procedure ClearLogo;
    function GetNumHeaderLines: Integer;
    function GetNumTrailerLines: Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetLongPrinterStatus: TLongPrinterStatus;
    function GetEJStatus1: TEJStatus1;
    function GetEJActivation: TEJActivation;
    function CurrencyToInt(Value: Currency): Int64;
    function IntToCurrency(Value: Int64): Currency;
    function IsDecimalPoint: Boolean;
    function CurrencyToStr(Value: Currency): WideString;
    procedure UpdateParams;
    procedure ReleasePrinter;
    procedure ClaimPrinter(Timeout: Integer);
    function GetPrinterSemaphoreName: WideString;
    procedure SetDevice(Value: IFiscalPrinterDevice);
    function GetConnection: IPrinterConnection;
    procedure SetConnection(const Value: IPrinterConnection);
    procedure SetDeviceName(const Value: WideString);
    function GetParameters: TPrinterParameters;
    procedure StartPing;
    procedure StopPing;
    property Header: TFixedStrings read GetHeader;
    property Trailer: TFixedStrings read GetTrailer;
    property PrintWidth: Integer read GetPrintWidth;
    property Device: IFiscalPrinterDevice read GetDevice write SetDevice;
    property PrintWidthInDots: Integer read GetPrintWidthInDots;
    property CheckTotal: Boolean read GetCheckTotal write SetCheckTotal;
    property OnProgress: TProgressEvent read GetOnProgress write SetOnProgress;
    property PollEnabled: Boolean read GetPollEnabled write SetPollEnabled;
    property Station: Integer read GetStation write SetStation;
    property PreLine: WideString read GetPreLine write SetPreLine;
    property PostLine: WideString read GetPostLine write SetPostLine;
    property NumHeaderLines: Integer read GetNumHeaderLines;
    property NumTrailerLines: Integer read GetNumTrailerLines;
    property DeviceMetrics: TDeviceMetrics read GetDeviceMetrics;
    property LongPrinterStatus: TLongPrinterStatus read GetLongPrinterStatus;
    property EJStatus1: TEJStatus1 read GetEJStatus1;
    property EJActivation: TEJActivation read GetEJActivation;
    property DeviceName: WideString read GetDeviceName write SetDeviceName;
    property Connection: IPrinterConnection read GetConnection write SetConnection;
    property Parameters: TPrinterParameters read GetParameters;
  end;

  { ISharedPrinterFactory }

  ISharedPrinterFactory = interface
    function CreateObject: ISharedPrinter;
  end;

  { IFptrService }

  IFptrService = interface
    ['{1CA47524-F229-45A5-AC8E-ECF60CAA20B2}']
    function Get_OpenResult: Integer; safecall;
    function COFreezeEvents(Freeze: WordBool): Integer; safecall;
    function GetPropertyNumber(PropIndex: Integer): Integer; safecall;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); safecall;
    function GetPropertyString(PropIndex: Integer): WideString; safecall;
    procedure SetPropertyString(PropIndex: Integer; const Text: WideString); safecall;
    function OpenService(const DeviceClass: WideString; const DeviceName: WideString; const pDispatch: IDispatch): Integer; safecall;
    function CloseService: Integer; safecall;
    function CheckHealth(Level: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearOutput: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
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
    function PrintNormal(Station: Integer; const Data: WideString): Integer; safecall;
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
    function PrintRecCash(Amount: Currency): Integer; safecall;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; SpecialTax: Currency; const SpecialTaxName: WideString): Integer; safecall;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; SpecialTax: Currency): Integer; safecall;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; const VatAdjustment: WideString): Integer; safecall;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; safecall;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; safecall;
    function PrintRecTaxID(const TaxID: WideString): Integer; safecall;
    function SetCurrency(NewCurrency: Integer): Integer; safecall;
    function GetOpenResult: Integer; safecall;
    function Open(const DeviceClass: WideString; const DeviceName: WideString; const pDispatch: IDispatch): Integer; safecall;
    function Close: Integer; safecall;
    function Claim(Timeout: Integer): Integer; safecall;
    function Release1: Integer; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; safecall;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; safecall;
    function PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; safecall;
    function PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; safecall;
    property OpenResult: Integer read Get_OpenResult;
    // Extended
    procedure CancelReceipt;
    procedure SetPrinterState(Value: Integer);
    function GetPrinter: ISharedPrinter;
    property Printer: ISharedPrinter read GetPrinter;
  end;

function TicketToStr(const Ticket: TFSTicket): string;

implementation

function TicketToStr(const Ticket: TFSTicket): string;
begin
  Result := Tnt_WideFormat('%s;%s;%s;%s', [
    PrinterDateTimeToStr3(Ticket.Date),
    StrToHexText(Ticket.DocumentMac),
    IntToStr(Ticket.DocumentNum),
    StrToHexText(Ticket.Data)]);
end;

end.

