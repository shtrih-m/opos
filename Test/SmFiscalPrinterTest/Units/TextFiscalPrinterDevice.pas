unit TextFiscalPrinterDevice;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  FiscalPrinterTypes, PrinterCommand, PrinterFrame, PrinterTypes, BinStream,
  StringUtils, SerialPort, PrinterTable, ByteUtils, DeviceTables,
  PrinterParameters, PrinterConnection, DriverTypes,
  FiscalPrinterStatistics, DefaultModel, DriverContext;

type
  { TTextFiscalPrinterDevice }

  TTextFiscalPrinterDevice = class(TInterfacedObject, IFiscalPrinterDevice)
  private
    FRecStation: TStrings;
    FJrnStation: TStrings;
    FModel: TPrinterModelRec;
    FPrinterStatus: TPrinterStatus;
    FStatistics: TFiscalPrinterStatistics;
    FDeviceMetrics: TDeviceMetrics;
    FLongStatus: TLongPrinterStatus;
    FShortStatus: TShortPrinterStatus;
    FContext: TDriverContext;
    FTaxInfo: TTaxInfoList;

    FPort: TSerialPort;
    function GetCapFiscalStorage: Boolean;
    function GetCapReceiptDiscount: Boolean;
    function GetParameters: TPrinterParameters;
    function GetCapSubtotalRound: Boolean;
    procedure SetCapFiscalStorage(const Value: Boolean);
  public
    FCapFiscalStorage: Boolean;
    FSCloseReceiptResult2: TFSCloseReceiptResult2;

    constructor Create;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    function GetPort: TSerialPort;
    function WaitForPrinting: TPrinterStatus;
    function GetPrinterFlags(Flags: Word): TPrinterFlags;
    function GetStatus: TPrinterStatus;
    procedure Initialize(Parameters: TPrinterParameters);
    function IsReceiptOpened: Boolean;
    function GetCapOpenReceipt: Boolean;
    function IsRecOpened: Boolean;

    procedure OpenDay;
    procedure Lock;
    procedure Unlock;
    procedure FullCut;
    procedure PartialCut;
    procedure InterruptReport;
    procedure StopDump;
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
    procedure PrintString(Stations: Byte; const Text: WideString);
    procedure SetSysPassword(const Value: DWORD);
    procedure SetTaxPassword(const Value: DWORD);
    procedure SetUsrPassword(const Value: DWORD);
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure EJTotalsReportDate(const Parameters: TDateReport);
    procedure EJTotalsReportNumber(const Parameters: TNumberReport);
    procedure SetOnCommand(Value: TCommandEvent);
    procedure PrintJournal(DayNumber: Integer);
    procedure SetFlags(Flags: TPrinterFlags);

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
    function PrintBarcode(const Barcode: WideString): Integer;
    procedure PrintBarcode2(const Barcode: TBarcodeRec);
    function PrintGraphics(Line1, Line2: Word): Integer;
    function LoadGraphics(Line: Word; Data: AnsiString): Integer;
    function PrintBarLine(Height: Word; Data: AnsiString): Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetDayDiscountTotal: Int64;
    function GetRecDiscountTotal: Int64;
    function GetDayItemTotal: Int64;
    function GetRecItemTotal: Int64;
    function GetDayItemVoidTotal: Int64;
    function GetRecItemVoidTotal: Int64;
    function ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
    function GetEJSesssionResult(Number: Word; var Text: WideString): Integer;
    function GetEJReportLine(var Line: WideString): Integer;
    function ReadEJActivation(var Line: WideString): Integer;
    function EJReportStop: Integer;
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    function Execute(const Data: AnsiString): AnsiString;
    function ExecuteStream(Stream: TBinStream): Integer;
    function ExecutePrinterCommand(Command: TPrinterCommand): Integer;
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
    function ReceiptClose(const P: TCloseReceiptParams;
      var R: TCloseReceiptResult): Integer;
    function ReceiptClose2(const P: TFSCloseReceiptParams2;
      var R: TFSCloseReceiptResult2): Integer;
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
    function ReadTableInfo(Table: Byte; var R: TPrinterTableRec): Integer;
    function ReadTableStructure(Table: Byte; var R: TPrinterTableRec): Integer;
    function GetLine(const Text: WideString): WideString; overload;
    function GetLine(const Text: WideString; MinLength, MaxLength: Integer): WideString; overload;
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: WideString): Integer;
    function ReadFieldInfo(Table, Field: Byte; var R: TPrinterFieldRec): Integer;
    function ExecuteData(const Data: AnsiString; var RxData: AnsiString): Integer;
    function ExecuteCommand(var Command: TCommandRec): Integer;
    function SendCommand(var Command: TCommandRec): Integer;
    function AlignLines(const Line1, Line2: WideString; LineWidth: Integer): WideString;
    function GetModel: TPrinterModelRec;
    function GetOnCommand: TCommandEvent;
    function GetTables: TDeviceTables;
    procedure SetTables(const Value: TDeviceTables);

    procedure ClosePort;
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
    procedure Open(AConnection: IPrinterConnection);
    procedure Close;
    procedure UpdateModel;
    function CapGraphics: Boolean;
    function CapShortEcrStatus: Boolean;
    function CapPrintStringFont: Boolean;
    procedure WriteParameter(ParamID, ValueID: Integer);
    function ReadParameter(ParamID: Integer): Integer;
    function GetStatistics: TFiscalPrinterStatistics;
    procedure LoadModels;
    procedure SaveModels;
    function GetResultCode: Integer;
    function GetResultText: WideString;
    function QueryEJActivation: TEJActivation;
    function GetIsOnline: Boolean;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetOnConnect(const Value: TNotifyEvent);
    procedure SetOnDisconnect(const Value: TNotifyEvent);
    procedure AddFilter(AFilter: IFiscalPrinterFilter);
    procedure RemoveFilter(AFilter: IFiscalPrinterFilter);
    procedure PrintText(const Data: TTextRec); overload;
    procedure PrintText(Station: Integer; const Text: WideString); overload;
    procedure PrintTextFont(Station: Integer; Font: Integer; const Text: WideString);

    function CenterLine(const Line: WideString): WideString;
    procedure CheckGraphicsSize(Line: Word);
    function IsDayOpened(Mode: Integer): Boolean;
    function GetAmountDecimalPlaces: Integer;
    procedure SetAmountDecimalPlaces(const Value: Integer);
    function LoadImage(const FileName: WideString; StartLine: Integer): Integer;
    procedure PrintImage(const FileName: WideString; StartLine: Integer);
    procedure PrintImageScale(const FileName: WideString; StartLine, Scale: Integer);
    function ReadEJDocumentText(MACNumber: Integer): WideString;
    function ReadEJDocument(MACNumber: Integer; var Line: WideString): Integer;
    function ParseEJDocument(const Text: WideString): TEJDocument;

    function FSReadState(var R: TFSState): Integer;
    function FSWriteTLV(const TLVData: AnsiString): Integer;
    procedure FSWriteTLV2(const TLVData: AnsiString);
    function FSSale(P: TFSSale): Integer;
    function FSSale2(P: TFSSale2): Integer;
    function GetCapFSCloseReceipt2: Boolean;
    function FSStorno(P: TFSSale): Integer;
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

    function ReadPrinterStatus: TPrinterStatus;
    function GetErrorText(Code: Integer): WideString;
    function OpenFiscalDay: Boolean;
    function ReadSysOperatorNumber: Integer;
    function ReadUsrOperatorNumber: Integer;
    function GetTaxInfo(Tax: Integer): TTaxInfo;
    function ReadFPParameter(ParamId: Integer): WideString;
    function ReadFSParameter(ParamID: Integer; const pString: WideString): WideString;
    function GetDiscountMode: Integer;
    procedure WriteFPParameter(ParamId: Integer; const Value: WideString);
    function GetIsFiscalized: Boolean;
    function FSReadTotals(var R: TFMTotals): Integer;
    function ReadDayTotals: TFMTotals;
    function ReadFPTotals(Flags: Integer): TFMTotals;
    function FSPrintCorrectionReceipt(var Command: TFSCorrectionReceipt): Integer;
    function FSPrintCorrectionReceipt2(var Data: TFSCorrectionReceipt2): Integer;
    procedure LoadTables(const Path: WideString);
    function FSReadTicket(var R: TFSTicket): Integer;
    function GetContext: TDriverContext;
    function GetCapDiscount: Boolean;
    function ReadLoaderVersion(var Version: WideString): Integer;
    procedure CancelReceipt;
    function FSFiscalization(const P: TFSFiscalization; var R: TFDDocument): Integer;
    function FSReFiscalization(const P: TFSReFiscalization; var R: TFDDocument): Integer;
    function IsCapFooterFlag: Boolean;
    procedure SetFooterFlag(Value: Boolean);
    procedure SetBeforeCommand(Value: TCommandEvent);
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
    function GetFSCloseReceiptResult2: TFSCloseReceiptResult2;
    function FSStartCorrectionReceipt: Integer;
    function GetLastDocNumber: Int64;
    function GetLastDocMac: Int64;
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
    function FSBindItemCode(P: TFSBindItemCode; var R: TFSBindItemCodeResult): Integer;
    function FSReadTicketStatus(var R: TFSTicketStatus): Integer;
    function FSReadMarkStatus(var R: TFSMarkStatus): Integer;
    function FSStartReadTickets(var R: TFSTicketParams): Integer;
    function FSReadNextTicket(var R: TFSTicketData): Integer;
    function FSConfirmTicket(const P: TFSTicketNumber): Integer;
    function FSReadDeviceInfo(var R: string): Integer;
    function FSReadDocSize(var R: TFSDocSize): Integer;
    function FSClearMCCheckResults: Integer;

    procedure STLVBegin(TagID: Integer);
    procedure STLVAddTag(TagID: Integer; TagValue: string);
    function STLVGetHex: string;
    procedure STLVWrite;
    procedure STLVWriteOp;
    procedure ResetPrinter;
    procedure WriteTLVItems;
    function GetDocPrintMode: Integer;
    function ReadDocData: WideString;
    function GetLastDocTotal: Int64;
    function GetLastDocDate: TPrinterDate;
    function GetLastDocTime: TPrinterTime;
    procedure CheckPrinterStatus;
    procedure CorrectDate;
    procedure UpdateInfo;
    function GetHeaderHeight: Integer;
    function GetTrailerHeight: Integer;
    function GetFont(Font: Integer): TFontInfo;
    function GetTaxInfoList: TTaxInfoList;
    function GetTaxCount: Integer;
    procedure WriteTaxRate(Tax, Rate: Integer);

    property RecStation: TStrings read FRecStation;
    property JrnStation: TStrings read FJrnStation;
    property Context: TDriverContext read FContext;
    property Parameters: TPrinterParameters read GetParameters;
    property CapSubtotalRound: Boolean read GetCapSubtotalRound;
    property CapFiscalStorage: Boolean read GetCapFiscalStorage write SetCapFiscalStorage;
    property Model: TPrinterModelRec read GetModel write FModel;
    property Tables: TDeviceTables read GetTables write SetTables;
    property CapReceiptDiscount: Boolean read GetCapReceiptDiscount;
    property LongStatus: TLongPrinterStatus read FLongStatus write FLongStatus;
    property ShortStatus: TShortPrinterStatus read FShortStatus write FShortStatus;
    property DeviceMetrics: TDeviceMetrics read FDeviceMetrics write FDeviceMetrics;
    property PrinterStatus: TPrinterStatus read FPrinterStatus write FPrinterStatus;
    property TaxInfoList: TTaxInfoList read GetTaxInfoList;
    property TaxCount: Integer read GetTaxCount;
  end;

implementation

{ TTextFiscalPrinterDevice }

constructor TTextFiscalPrinterDevice.Create;
begin
  inherited Create;
  FContext := TDriverContext.Create;
  FModel := PrinterModelDefault;
  FPort := TSerialPort.Create(2, FContext.Logger);
  FStatistics := TFiscalPrinterStatistics.Create(FContext.Logger);
  FRecStation := TStringList.Create;
  FJrnStation := TStringList.Create;
end;

destructor TTextFiscalPrinterDevice.Destroy;
begin
  FPort.Free;
  FRecStation.Free;
  FJrnStation.Free;
  FStatistics.Free;
  FContext.Free;
  inherited Destroy;
end;

function TTextFiscalPrinterDevice.AlignLines(const Line1, Line2: WideString;
  LineWidth: Integer): WideString;
begin

end;

function TTextFiscalPrinterDevice.Beep: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.BinToFieldValue(
  FieldInfo: TPrinterFieldRec; const Value: WideString): WideString;
begin

end;

function TTextFiscalPrinterDevice.Buy(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.CashIn(Amount: Int64);
begin

end;

procedure TTextFiscalPrinterDevice.CashOut(Amount: Int64);
begin

end;

procedure TTextFiscalPrinterDevice.Check(Value: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.ClosePort;
begin

end;

procedure TTextFiscalPrinterDevice.ConfirmDate(const Date: TPrinterDate);
begin

end;

function TTextFiscalPrinterDevice.ContinuePrint: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.DecodeEJFlags(Flags: Byte): TEJFlags;
begin

end;

function TTextFiscalPrinterDevice.DoWriteTable(
  Table, Row, Field: Integer;
  const FieldValue: WideString): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.EjectSlip(Direction: Byte);
begin

end;

function TTextFiscalPrinterDevice.EJReportStop: Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.EJTotalsReportDate(
  const Parameters: TDateReport);
begin

end;

procedure TTextFiscalPrinterDevice.EJTotalsReportNumber(
  const Parameters: TNumberReport);
begin

end;

function TTextFiscalPrinterDevice.Execute(const Data: AnsiString): AnsiString;
begin

end;

function TTextFiscalPrinterDevice.ExecuteCommand(
  var Command: TCommandRec): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ExecuteData(const Data: AnsiString;
  var RxData: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ExecutePrinterCommand(
  Command: TPrinterCommand): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ExecuteStream(
  Stream: TBinStream): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ExecuteStream2(
  Stream: TBinStream): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.FeedPaper(Station, Lines: Byte);
begin
end;

function TTextFiscalPrinterDevice.FieldToInt(FieldInfo: TPrinterFieldRec;
  const Value: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FieldToStr(FieldInfo: TPrinterFieldRec;
  const Value: WideString): WideString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.Fiscalization(Password, PrinterID,
  FiscalID: Int64): TFiscalizationResult;
begin

end;

function TTextFiscalPrinterDevice.FormatBoldLines(const Line1,
  Line2: WideString): WideString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.FormatLines(const Line1,
  Line2: WideString): WideString;
begin
  Result := Line1 + ' ' + Line2;
end;

procedure TTextFiscalPrinterDevice.FullCut;
begin
  RecStation.Add('FullCut');
end;

function TTextFiscalPrinterDevice.GetDayDiscountTotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetDayItemTotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetDayItemVoidTotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetDeviceMetrics: TDeviceMetrics;
begin
  Result := FDeviceMetrics;
end;

function TTextFiscalPrinterDevice.GetDumpBlock: TDumpBlock;
begin

end;

function TTextFiscalPrinterDevice.GetEJReportLine(
  var Line: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadEJActivation(var Line: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetEJSesssionResult(Number: Word;
  var Text: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetEJStatus1(
  var Status: TEJStatus1): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetFieldValue(
  FieldInfo: TPrinterFieldRec; const Value: WideString): AnsiString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.GetFMFlags(Flags: Byte): TFMFlags;
begin

end;

function TTextFiscalPrinterDevice.GetLine(const Text: WideString; MinLength,
  MaxLength: Integer): WideString;
begin

end;

function TTextFiscalPrinterDevice.GetLine(const Text: WideString): WideString;
begin

end;

function TTextFiscalPrinterDevice.GetLongSerial: TGetLongSerial;
begin

end;

function TTextFiscalPrinterDevice.GetModel: TPrinterModelRec;
begin
  Result := FModel;
end;

function TTextFiscalPrinterDevice.GetOnCommand: TCommandEvent;
begin

end;

function TTextFiscalPrinterDevice.GetPort: TSerialPort;
begin
  Result := FPort;
end;

function TTextFiscalPrinterDevice.GetPortParams(Port: Byte): TPortParams;
begin

end;

function TTextFiscalPrinterDevice.GetPrinterFlags(
  Flags: Word): TPrinterFlags;
begin

end;

function TTextFiscalPrinterDevice.GetPrintWidth: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetRecDiscountTotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetRecItemTotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetRecItemVoidTotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadShortStatus: TShortPrinterStatus;
begin
  Result := FShortStatus;
end;

function TTextFiscalPrinterDevice.ReadPrinterStatus: TPrinterStatus;
begin
  Result := FPrinterStatus;
end;

function TTextFiscalPrinterDevice.GetSubtotal: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetSysPassword: DWORD;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetTaxPassword: DWORD;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetUsrPassword: DWORD;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.InitFiscalMemory;
begin

end;

procedure TTextFiscalPrinterDevice.InitializeTables;
begin

end;

procedure TTextFiscalPrinterDevice.InterruptReport;
begin

end;

function TTextFiscalPrinterDevice.LoadGraphics(Line: Word;
  Data: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.LongFisc(NewPassword: DWORD; PrinterID,
  FiscalID: Int64): TLongFiscResult;
begin

end;

procedure TTextFiscalPrinterDevice.OpenDrawer(DrawerNumber: Byte);
begin

end;

function TTextFiscalPrinterDevice.OpenReceipt(ReceiptType: Byte): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.OpenSlipDoc(
  Params: TSlipParams): TDocResult;
begin

end;

function TTextFiscalPrinterDevice.OpenStdSlip(
  Params: TStdSlipParams): TDocResult;
begin

end;

procedure TTextFiscalPrinterDevice.CutPaper(CutType: Byte);
begin
  RecStation.Add(Format('CutPaper(%d)', [CutType]));
end;

procedure TTextFiscalPrinterDevice.PartialCut;
begin
  RecStation.Add('PartialCut');
end;

procedure TTextFiscalPrinterDevice.PrintActnTotalizers;
begin

end;

function TTextFiscalPrinterDevice.PrintBarcode(const Barcode: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.PrintBarLine(Height: Word;
  Data: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.PrintBoldString(Flags: Byte;
  const Text: WideString): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.PrintDepartmentsReport;
begin

end;

procedure TTextFiscalPrinterDevice.PrintDocHeader(const DocName: WideString;
  DocNumber: Word);
begin

end;

procedure TTextFiscalPrinterDevice.PrintDocTrailer(Flags: Byte);
begin

end;

function TTextFiscalPrinterDevice.PrintGraphics(Line1,
  Line2: Word): Integer;
begin
  FRecStation.Add(Format('PrintGraphics(%d,%d', [Line1, Line2]));
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.PrintHeader;
begin

end;

function TTextFiscalPrinterDevice.PrintReceiptCopy: Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.PrintString(Stations: Byte;
  const Text: WideString);
begin
  PrintText(Stations, Text);
end;

procedure TTextFiscalPrinterDevice.PrintStringFont(Station, Font: Byte;
  const Line: WideString);
begin
  PrintText(Station, Line);
end;

procedure TTextFiscalPrinterDevice.PrintTaxReport;
begin

end;

procedure TTextFiscalPrinterDevice.PrintTrailer;
begin

end;

procedure TTextFiscalPrinterDevice.PrintXReport;
begin

end;

procedure TTextFiscalPrinterDevice.PrintZReport;
begin

end;

function TTextFiscalPrinterDevice.ReadOperatingRegister(ID: Byte): Word;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadCashRegister(ID: Integer): Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadFieldInfo(Table, Field: Byte;
  var R: TPrinterFieldRec): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadFieldStructure(Table,
  Field: Byte): TPrinterFieldRec;
begin
end;

function TTextFiscalPrinterDevice.ReadFiscInfo(
  FiscNumber: Byte): TFiscInfo;
begin

end;

function TTextFiscalPrinterDevice.ReadFMLastRecordDate: TFMRecordDate;
begin

end;

function TTextFiscalPrinterDevice.ReadFontInfo(
  FontNumber: Byte): TFontInfo;
begin

end;

function TTextFiscalPrinterDevice.ReadLicense: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadDaysRange: TDayRange;
begin

end;

function TTextFiscalPrinterDevice.ReadTableBin(Table, Row,
  Field: Integer): WideString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.ReadTableInt(Table, Row,
  Field: Integer): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadTableStr(Table, Row,
  Field: Integer): WideString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.ReceiptCancel: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReceiptCharge(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReceiptDiscount(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReceiptStornoCharge(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReceiptStornoDiscount(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReportOnDateRange(ReportType: Byte;
  Range: TDayDateRange): TDayRange;
begin

end;

function TTextFiscalPrinterDevice.ReportOnNumberRange(ReportType: Byte;
  Range: TDayNumberRange): TDayRange;
begin

end;

procedure TTextFiscalPrinterDevice.ResetFiscalMemory;
begin

end;

procedure TTextFiscalPrinterDevice.ResetTotalizers;
begin

end;

function TTextFiscalPrinterDevice.RetBuy(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.RetSale(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.Sale(Operation: TPriceReg): Integer;
var
  Line: WideString;
  Amount: Currency;
begin
  Result := 0;
  Amount := Operation.Price/100 * Operation.Quantity/1000;
  Line := Format('%d %s %.2f X %.3f = %.2f', [Operation.Department,
    Operation.Text, Operation.Price/100, Operation.Quantity/1000, Amount]);
  FRecStation.Add(Line);
end;

function TTextFiscalPrinterDevice.SendCommand(
  var Command: TCommandRec): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.WriteDate(const Date: TPrinterDate);
begin

end;

procedure TTextFiscalPrinterDevice.SetLongSerial(Serial: Int64);
begin

end;

procedure TTextFiscalPrinterDevice.SetOnCommand(Value: TCommandEvent);
begin

end;

procedure TTextFiscalPrinterDevice.SetPointPosition(PointPosition: Byte);
begin

end;

function TTextFiscalPrinterDevice.SetPortParams(Port: Byte;
  const PortParams: TPortParams): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.SetSysPassword(const Value: DWORD);
begin

end;

procedure TTextFiscalPrinterDevice.SetTaxPassword(const Value: DWORD);
begin

end;

procedure TTextFiscalPrinterDevice.SetTime(const Time: TPrinterTime);
begin

end;

procedure TTextFiscalPrinterDevice.SetUsrPassword(const Value: DWORD);
begin

end;

function TTextFiscalPrinterDevice.SlipClose(
  Params: TCloseReceiptParams): TCloseReceiptResult;
begin

end;

function TTextFiscalPrinterDevice.SlipDiscount(Params: TSlipDiscountParams;
  Discount: TSlipDiscount): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.SlipOperation(Params: TSlipOperation;
  Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.SlipStdDiscount(
  Discount: TSlipDiscount): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.SlipStdOperation(LineNumber: Byte;
  Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.StartDump(DeviceCode: Integer): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.StartTest(Interval: Byte);
begin

end;

procedure TTextFiscalPrinterDevice.StopDump;
begin

end;

procedure TTextFiscalPrinterDevice.StopTest;
begin

end;

function TTextFiscalPrinterDevice.Storno(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.WriteLicense(License: Int64);
begin

end;

procedure TTextFiscalPrinterDevice.WriteSerial(Serial: DWORD);
begin

end;

function TTextFiscalPrinterDevice.WriteTable(
  Table, Row, Field: Integer;
  const FieldValue: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.WriteTableInt(
  Table, Row, Field,
  Value: Integer): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetTables: TDeviceTables;
begin

end;

procedure TTextFiscalPrinterDevice.SetTables(const Value: TDeviceTables);
begin

end;

procedure TTextFiscalPrinterDevice.Open(AConnection: IPrinterConnection);
begin

end;

procedure TTextFiscalPrinterDevice.ClaimDevice(PortNumber, Timeout: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.Initialize(Parameters: TPrinterParameters);
begin

end;

procedure TTextFiscalPrinterDevice.ReleaseDevice;
begin

end;

function TTextFiscalPrinterDevice.IsReceiptOpened: Boolean;
begin
  Result := False;
end;

procedure TTextFiscalPrinterDevice.OpenPort(PortNumber, BaudRate,
  ByteTimeout: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.UpdateModel;
begin

end;

(*
function TTextFiscalPrinterDevice.GetPrinterMode: TPrinterMode;
begin
  Result.Mode := MODE_REC;
  Result.AdvancedMode := 0;
  Result.OperatorNumber := 1;
end;
*)


function TTextFiscalPrinterDevice.CapPrintStringFont: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.CapShortEcrStatus: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.CapGraphics: Boolean;
begin
  Result := True;
end;

procedure TTextFiscalPrinterDevice.PrintJournal(DayNumber: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.Lock;
begin

end;

procedure TTextFiscalPrinterDevice.Unlock;
begin

end;

function TTextFiscalPrinterDevice.ReadParameter(ParamID: Integer): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.WriteParameter(ParamID,
  ValueID: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.LoadModels;
begin

end;

procedure TTextFiscalPrinterDevice.SaveModels;
begin

end;

function TTextFiscalPrinterDevice.ReadTableInfo(Table: Byte;
  var R: TPrinterTableRec): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadTableStructure(Table: Byte;
  var R: TPrinterTableRec): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadCashReg(ID: Integer;
  var R: TCashRegisterRec): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadOperatingReg(ID: Byte;
  var R: TOperRegisterRec): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetStatistics: TFiscalPrinterStatistics;
begin
  Result := FStatistics;
end;

function TTextFiscalPrinterDevice.GetResultCode: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetResultText: WideString;
begin

end;

function TTextFiscalPrinterDevice.QueryEJActivation: TEJActivation;
begin

end;

function TTextFiscalPrinterDevice.GetIsOnline: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.GetOnConnect: TNotifyEvent;
begin

end;

function TTextFiscalPrinterDevice.GetOnDisconnect: TNotifyEvent;
begin

end;

procedure TTextFiscalPrinterDevice.SetOnConnect(const Value: TNotifyEvent);
begin

end;

procedure TTextFiscalPrinterDevice.SetOnDisconnect(
  const Value: TNotifyEvent);
begin

end;

procedure TTextFiscalPrinterDevice.AddFilter(
  AFilter: IFiscalPrinterFilter);
begin

end;

procedure TTextFiscalPrinterDevice.RemoveFilter(
  AFilter: IFiscalPrinterFilter);
begin

end;

procedure TTextFiscalPrinterDevice.OpenDay;
begin

end;

procedure TTextFiscalPrinterDevice.PrintText(const Data: TTextRec);
begin
  PrintText(Data.Station, Data.Text);
end;

procedure TTextFiscalPrinterDevice.PrintText(Station: Integer; const Text: WideString);
begin
  if (Station and PRINTER_STATION_REC) <> 0 then
    FRecStation.Add(Text);

  if (Station and PRINTER_STATION_JRN) <> 0 then
    FJrnStation.Add(Text);
end;

function TTextFiscalPrinterDevice.CenterLine(const Line: WideString): WideString;
begin
  Result := Line;
end;

procedure TTextFiscalPrinterDevice.CheckGraphicsSize(Line: Word);
begin

end;

function TTextFiscalPrinterDevice.IsDayOpened(Mode: Integer): Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.GetAmountDecimalPlaces: Integer;
begin
  Result := 2;
end;

procedure TTextFiscalPrinterDevice.SetAmountDecimalPlaces(
  const Value: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.SetFlags(Flags: TPrinterFlags);
begin
  FLongStatus.Flags := EncodePrinterFlags(Flags);
  FShortStatus.Flags := EncodePrinterFlags(Flags);
end;

function TTextFiscalPrinterDevice.ReceiptClose(
  const P: TCloseReceiptParams; var R: TCloseReceiptResult): Integer;
begin
  Result := 0;
  FRecStation.Add('����');
end;

procedure TTextFiscalPrinterDevice.PrintBarcode2(
  const Barcode: TBarcodeRec);
begin
  { !!! }
end;

function TTextFiscalPrinterDevice.LoadImage(const FileName: WideString;
  StartLine: Integer): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.PrintImage(const FileName: WideString;
  StartLine: Integer);
begin

end;

procedure TTextFiscalPrinterDevice.Connect;
begin

end;

procedure TTextFiscalPrinterDevice.Disconnect;
begin

end;

procedure TTextFiscalPrinterDevice.PrintTextFont(Station, Font: Integer;
  const Text: WideString);
begin

end;

function TTextFiscalPrinterDevice.ReadFMTotals(Flags: Byte;
  var R: TFMTotals): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.PrintImageScale(const FileName: WideString;
  StartLine, Scale: Integer);
begin

end;

function TTextFiscalPrinterDevice.ParseEJDocument(
  const Text: WideString): TEJDocument;
begin

end;

function TTextFiscalPrinterDevice.ReadEJDocument(MACNumber: Integer;
  var Line: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadEJDocumentText(
  MACNumber: Integer): WideString;
begin

end;

function TTextFiscalPrinterDevice.WaitForPrinting: TPrinterStatus;
begin

end;

function TTextFiscalPrinterDevice.FSSale(P: TFSSale): Integer;
begin
  Result := 0;

end;

function TTextFiscalPrinterDevice.FSStorno(P: TFSSale): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSWriteTLV(
  const TLVData: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadBlock(const P: TFSBlockRequest;
  var Block: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadBlockData: AnsiString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.FSReadStatus(var R: TFSStatus): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSStartWrite(DataSize: Word;
  var BlockSize: Byte): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSWriteBlock(
  const Block: TFSBlock): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.FSWriteBlockData(
  const BlockData: AnsiString);
begin

end;

function TTextFiscalPrinterDevice.GetErrorText(Code: Integer): WideString;
begin

end;

function TTextFiscalPrinterDevice.GetCapFiscalStorage: Boolean;
begin
  Result := FCapFiscalStorage;
end;

function TTextFiscalPrinterDevice.OpenFiscalDay: Boolean;
begin
  Result := False;
end;

function TTextFiscalPrinterDevice.ReceiptDiscount2(
  Operation: TReceiptDiscount2): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetCapReceiptDiscount: Boolean;
begin
  Result := False;
end;

function TTextFiscalPrinterDevice.ReadSysOperatorNumber: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadUsrOperatorNumber: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetTaxInfo(Tax: Integer): TTaxInfo;
begin

end;

function TTextFiscalPrinterDevice.FSFindDocument(DocNumber: Integer;
  var R: TFSDocument): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSPrintCalcReport(
  var R: TFSCalcReport): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadCommStatus(
  var R: TFSCommStatus): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadDocMac(var DocMac: Int64): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadExpiration(var R: TCommandFF03): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadFiscalResult(
  var R: TFSFiscalResult): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadState(var R: TFSState): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSWriteTag(TagID: Integer;
  const Data: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.WriteCustomerAddress(
  const Value: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetDiscountMode: Integer;
begin
  Result := 2;
end;

function TTextFiscalPrinterDevice.ReadFPParameter(
  ParamId: Integer): WideString;
begin
  Result := '';
end;

procedure TTextFiscalPrinterDevice.WriteFPParameter(ParamId: Integer;
  const Value: WideString);
begin

end;

function TTextFiscalPrinterDevice.GetIsFiscalized: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.FSReadTotals(var R: TFMTotals): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadDayTotals: TFMTotals;
begin

end;

function TTextFiscalPrinterDevice.ReadFPTotals(Flags: Integer): TFMTotals;
begin

end;

function TTextFiscalPrinterDevice.FSPrintCorrectionReceipt(
  var Command: TFSCorrectionReceipt): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.LoadTables(const Path: WideString);
begin

end;

function TTextFiscalPrinterDevice.ReadFSParameter(ParamID: Integer;
  const pString: WideString): WideString;
begin
  Result := '';
end;

function TTextFiscalPrinterDevice.FSReadTicket(var R: TFSTicket): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.Close;
begin

end;

function TTextFiscalPrinterDevice.GetParameters: TPrinterParameters;
begin
  Result := FContext.Parameters;
end;

function TTextFiscalPrinterDevice.GetContext: TDriverContext;
begin
  Result := FContext;
end;

function TTextFiscalPrinterDevice.GetCapOpenReceipt: Boolean;
begin
  Result := False;
end;

function TTextFiscalPrinterDevice.IsRecOpened: Boolean;
begin
  Result := False;
end;

procedure TTextFiscalPrinterDevice.CancelReceipt;
begin

end;

function TTextFiscalPrinterDevice.GetCapDiscount: Boolean;
begin
  Result := False;
end;

function TTextFiscalPrinterDevice.GetCapSubtotalRound: Boolean;
begin
  Result := False;
end;

function TTextFiscalPrinterDevice.ReadLoaderVersion(
  var Version: WideString): Integer;
begin
  Version := '127';
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSSale2(P: TFSSale2): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetCapFSCloseReceipt2: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.ReceiptClose2(
  const P: TFSCloseReceiptParams2; var R: TFSCloseReceiptResult2): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSFiscalization(
  const P: TFSFiscalization; var R: TFDDocument): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReFiscalization(
  const P: TFSReFiscalization; var R: TFDDocument): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetPrintWidth(Font: Integer): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.IsCapFooterFlag: Boolean;
begin
  Result := False;
end;

procedure TTextFiscalPrinterDevice.SetFooterFlag(Value: Boolean);
begin

end;

procedure TTextFiscalPrinterDevice.SetBeforeCommand(Value: TCommandEvent);
begin

end;

function TTextFiscalPrinterDevice.GetOnPrinterStatus: TNotifyEvent;
begin

end;

function TTextFiscalPrinterDevice.GetStatus: TPrinterStatus;
begin

end;

function TTextFiscalPrinterDevice.ReadLongStatus: TLongPrinterStatus;
begin
  Result := FLongStatus;
end;

procedure TTextFiscalPrinterDevice.SetOnPrinterStatus(Value: TNotifyEvent);
begin

end;

function TTextFiscalPrinterDevice.GetPrinterStatus: TPrinterStatus;
begin

end;

function TTextFiscalPrinterDevice.IsCapBarcode2D: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.IsCapEnablePrint: Boolean;
begin
  Result := True;
end;

function TTextFiscalPrinterDevice.ReadCashReg2(RegID: Integer): Int64;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.PrintFSDocument(Number: Integer);
begin

end;

function TTextFiscalPrinterDevice.ReadFSDocument(Number: Integer): WideString;
begin

end;

function TTextFiscalPrinterDevice.FSPrintCorrectionReceipt2(
  var Data: TFSCorrectionReceipt2): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSStartOpenDay: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSWriteTLVOperation(
  const AData: AnsiString): Integer;
begin
  Result := 0;
end;


function TTextFiscalPrinterDevice.SendItemBarcode(const Barcode: WideString;
  MarkType: Integer): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetFSCloseReceiptResult2: TFSCloseReceiptResult2;
begin
  Result := FSCloseReceiptResult2;
end;

function TTextFiscalPrinterDevice.FSStartCorrectionReceipt: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetLastDocNumber: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetLastDocMac: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadLastDocNum2: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadLastDocNum: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadLastMacValue: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadLastMacValue2: Int64;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.CheckItemCode(
  const Barcode: WideString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSAcceptItemCode(
  Action: Integer): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSBindItemCode(P: TFSBindItemCode;
  var R: TFSBindItemCodeResult): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSCheckItemCode(P: TFSCheckItemCode;
  var R: TFSCheckItemResult): Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.STLVAddTag(TagID: Integer;
  TagValue: string);
begin

end;

procedure TTextFiscalPrinterDevice.STLVBegin(TagID: Integer);
begin

end;

function TTextFiscalPrinterDevice.STLVGetHex: string;
begin

end;

procedure TTextFiscalPrinterDevice.STLVWrite;
begin

end;

procedure TTextFiscalPrinterDevice.STLVWriteOp;
begin

end;

procedure TTextFiscalPrinterDevice.FSWriteTLV2(const TLVData: AnsiString);
begin

end;

procedure TTextFiscalPrinterDevice.ResetPrinter;
begin

end;

procedure TTextFiscalPrinterDevice.WriteTLVItems;
begin

end;

function TTextFiscalPrinterDevice.GetDocPrintMode: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.ReadDocData: WideString;
begin
  Result := '';
end;

procedure TTextFiscalPrinterDevice.CheckPrinterStatus;
begin

end;

procedure TTextFiscalPrinterDevice.CorrectDate;
begin

end;

procedure TTextFiscalPrinterDevice.SetCapFiscalStorage(
  const Value: Boolean);
begin
  FCapFiscalStorage := Value;
end;

function TTextFiscalPrinterDevice.GetLastDocDate: TPrinterDate;
begin
  Result := GetCurrentPrinterDate;
end;

function TTextFiscalPrinterDevice.GetLastDocTime: TPrinterTime;
begin
  Result := GetCurrentPrinterTime;
end;

function TTextFiscalPrinterDevice.GetLastDocTotal: Int64;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.UpdateInfo;
begin

end;

function TTextFiscalPrinterDevice.GetFont(Font: Integer): TFontInfo;
begin

end;

function TTextFiscalPrinterDevice.GetHeaderHeight: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetTrailerHeight: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSAuthorize(
  const DataToAuthorize: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSConfirmTicket(
  const P: TFSTicketNumber): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSRandomData(
  var Data: AnsiString): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadDeviceInfo(var R: string): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadDocSize(
  var R: TFSDocSize): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadMarkStatus(
  var R: TFSMarkStatus): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadMemory(
  var R: TFSReadMemoryResult): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadNextTicket(
  var R: TFSTicketData): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSReadTicketStatus(
  var R: TFSTicketStatus): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSStartReadTickets(
  var R: TFSTicketParams): Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSSyncRegisters: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSWriteTLVFromBuffer: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.FSClearMCCheckResults: Integer;
begin
  Result := 0;
end;

function TTextFiscalPrinterDevice.GetTaxInfoList: TTaxInfoList;
begin
  Result := FTaxInfo;
end;

function TTextFiscalPrinterDevice.GetTaxCount: Integer;
begin
  Result := 0;
end;

procedure TTextFiscalPrinterDevice.WriteTaxRate(Tax, Rate: Integer);
begin
  { !!! }
end;

end.
