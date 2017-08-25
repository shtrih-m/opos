unit MockFiscalPrinterDevice;

interface

uses
  // VCL
  Windows, Classes,
  // This
  FiscalPrinterTypes, PrinterCommand, PrinterFrame, PrinterTypes, BinStream,
  StringUtils, SerialPort, PrinterTable, ByteUtils, DeviceTables,
  PrinterParameters, PrinterConnection, DriverTypes, FiscalPrinterStatistics,
  DefaultModel, DriverContext, LogFile;

type
  { TMockFiscalPrinterDevice }

  TMockFiscalPrinterDevice = class(TInterfacedObject, IFiscalPrinterDevice)
  private
    FPort: TSerialPort;
    FContext: TDriverContext;
    FModel: TPrinterModelRec;
    FStatus: TPrinterStatus;
    FStatistics: TFiscalPrinterStatistics;
    FDeviceMetrics: TDeviceMetrics;
    FLongStatus: TLongPrinterStatus;
    FShortStatus: TShortPrinterStatus;

    function GetLogger: ILogFile;
    function GetCapFiscalStorage: Boolean;
    function GetCapReceiptDiscount2: Boolean;
    function GetParameters: TPrinterParameters;
    function GetCapSubtotalRound: Boolean;
    function GetPrinterStatus: TPrinterStatus;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;
    function GetPort: TSerialPort;
    function WaitForPrinting: TPrinterStatus;
    function GetPrinterFlags(Flags: Word): TPrinterFlags;
    function GetStatus: TPrinterStatus;
    procedure Initialize(Parameters: TPrinterParameters);
    function IsReceiptOpened: Boolean;

    procedure OpenDay;
    procedure Lock;
    procedure Unlock;
    procedure FullCut;
    procedure PartialCut;
    procedure InterruptReport;
    procedure StopDump;
    procedure SetLongSerial(Serial: Int64);
    function SetPortParams(Port: Byte; const PortParams: TPortParams): Integer;
    procedure PrintDocHeader(const DocName: string; DocNumber: Word);
    procedure StartTest(Interval: Byte);
    procedure WriteLicense(License: Int64);
    function WriteTableInt(Table, Row, Field, Value: Integer): Integer;
    function WriteTable(Table, Row, Field: Integer; const FieldValue: string): Integer;
    function DoWriteTable(Table, Row, Field: Integer; const FieldValue: string): Integer;
    procedure SetPointPosition(PointPosition: Byte);
    procedure SetTime(const Time: TPrinterTime);
    procedure SetDate(const Date: TPrinterDate);
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
    procedure PrintStringFont(Station, Font: Byte; const Line: string);
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
    procedure PrintString(Stations: Byte; const Text: string);
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
    function PrintBoldString(Flags: Byte; const Text: string): Integer;
    function Beep: Integer;
    function GetPortParams(Port: Byte): TPortParams;
    function ReadCashRegister(ID: Byte): Int64;
    function ReadCashReg(ID: Byte; var R: TCashRegisterRec): Integer;
    function ReadOperatingRegister(ID: Byte): Word;
    function ReadOperatingReg(ID: Byte; var R: TOperRegisterRec): Integer;
    function ReadLicense: Int64;
    function ReadTableBin(Table, Row, Field: Integer): string;
    function ReadTableStr(Table, Row, Field: Integer): string;
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
    function PrintBarcode(const Barcode: string): Integer;
    procedure PrintBarcode2(const Barcode: TBarcodeRec);
    function PrintGraphics(Line1, Line2: Word): Integer;
    function LoadGraphics(Line: Word; Data: string): Integer;
    function PrintBarLine(Height: Word; Data: string): Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetDayDiscountTotal: Int64;
    function GetRecDiscountTotal: Int64;
    function GetDayItemTotal: Int64;
    function GetRecItemTotal: Int64;
    function GetDayItemVoidTotal: Int64;
    function GetRecItemVoidTotal: Int64;
    function ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
    function GetEJSesssionResult(Number: Word; var Text: string): Integer;
    function GetEJReportLine(var Line: string): Integer;
    function ReadEJActivation(var Line: string): Integer;
    function EJReportStop: Integer;
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    function Execute(const Data: string): string;
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
    function ReceiptDiscount(Operation: TAmountOperation): Integer;
    function ReceiptDiscount2(Operation: TReceiptDiscount2): Integer;
    function ReceiptCharge(Operation: TAmountOperation): Integer;
    function ReceiptCancel: Integer;
    function GetSubtotal: Int64;
    function ReceiptStornoDiscount(Operation: TAmountOperation): Integer;
    function ReceiptStornoCharge(Operation: TAmountOperation): Integer;
    function PrintReceiptCopy: Integer;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function FormatLines(const Line1, Line2: string): string;
    function FormatBoldLines(const Line1, Line2: string): string;
    function ExecuteStream2(Stream: TBinStream): Integer;
    function GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
    function FieldToStr(FieldInfo: TPrinterFieldRec; const Value: string): string;
    function BinToFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
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
    function GetLine(const Text: string): string; overload;
    function GetLine(const Text: string; MinLength, MaxLength: Integer): string; overload;
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: string): Integer;
    function ReadFieldInfo(Table, Field: Byte; var R: TPrinterFieldRec): Integer;
    function ExecuteData(const Data: string; var RxData: string): Integer;
    function ExecuteCommand(var Command: TCommandRec): Integer;
    function SendCommand(var Command: TCommandRec): Integer;
    function AlignLines(const Line1, Line2: string; LineWidth: Integer): string;
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
    function GetResultText: string;
    function QueryEJActivation: TEJActivation;
    function GetIsOnline: Boolean;
    function GetOnConnect: TNotifyEvent;
    function GetOnDisconnect: TNotifyEvent;
    procedure SetOnConnect(const Value: TNotifyEvent);
    procedure SetOnDisconnect(const Value: TNotifyEvent);
    procedure AddFilter(AFilter: IFiscalPrinterFilter);
    procedure RemoveFilter(AFilter: IFiscalPrinterFilter);
    procedure PrintText(const Data: TTextRec); overload;
    procedure PrintText(Station: Integer; const Text: string); overload;
    procedure PrintTextFont(Station: Integer; Font: Integer; const Text: string);


    function CenterLine(const Line: string): string;
    procedure CheckGraphicsSize(Line: Word);
    function IsDayOpened(Mode: Integer): Boolean;
    function GetAmountDecimalPlaces: Integer;
    procedure SetAmountDecimalPlaces(const Value: Integer);
    function LoadImage(const FileName: string; StartLine: Integer): Integer;
    procedure PrintImage(const FileName: string; StartLine: Integer);
    procedure PrintImageScale(const FileName: string; StartLine, Scale: Integer);
    function ReadEJDocumentText(MACNumber: Integer): string;
    function ReadEJDocument(MACNumber: Integer; var Line: string): Integer;
    function ParseEJDocument(const Text: string): TEJDocument;

    function FSReadState(var R: TFSState): Integer;
    function FSWriteTLV(const TLVData: string): Integer;
    function FSSale(const P: TFSSale): Integer;
    function FSStorno(const P: TFSSale): Integer;
    function FSReadStatus(var R: TFSStatus): Integer;
    function FSReadBlock(const P: TFSBlockRequest; var Block: string): Integer;
    function FSStartWrite(DataSize: Word; var BlockSize: Byte): Integer;
    function FSWriteBlock(const Block: TFSBlock): Integer;
    function FSReadBlockData: string;
    procedure FSWriteBlockData(const BlockData: string);
    function FSPrintCalcReport(var R: TFSCalcReport): Integer;
    function FSFindDocument(DocNumber: Integer; var R: TFSDocument): Integer;
    function FSReadDocMac(var DocMac: Int64): Integer;
    function FSReadExpireDate(var Date: TPrinterDate): Integer;
    function FSReadCommStatus(var R: TFSCommStatus): Integer;
    function FSReadFiscalResult(var R: TFSFiscalResult): Integer;
    function FSWriteTag(TagID: Integer; const Data: string): Integer;
    function WriteCustomerAddress(const Value: string): Integer;

    function ReadPrinterStatus: TPrinterStatus;
    function GetErrorText(Code: Integer): string;
    function OpenFiscalDay: Boolean;
    function ReadSysOperatorNumber: Integer;
    function ReadUsrOperatorNumber: Integer;
    function GetTaxInfo(Tax: Integer): TTaxInfo;
    function ReadFPParameter(ParamId: Integer): string;
    function ReadFSParameter(ParamID: Integer; const pString: string): string;
    function GetDiscountMode: Integer;
    function GetIsFiscalized: Boolean;
    procedure WriteFPParameter(ParamId: Integer; const Value: string);
    function FSReadTotals(var R: TFMTotals): Integer;
    function ReadDayTotals: TFMTotals;
    function ReadFPTotals(Flags: Integer): TFMTotals;
    function FSPrintCorrectionReceipt(var Command: TFSCorrectionReceipt): Integer;
    procedure LoadTables(const Path: WideString);
    function FSReadTicket(var R: TFSTicket): Integer;
    function GetContext: TDriverContext;
    function GetCapOpenReceipt: Boolean;
    function IsRecOpened: Boolean;
    function GetCapDiscount: Boolean;
    function ReadLoaderVersion(var Version: string): Integer;
    function ReceiptClose2(const P: TFSCloseReceiptParams2;
      var R: TFSCloseReceiptResult2): Integer;
    function FSSale2(const P: TFSSale2): Integer;
    function GetCapFSCloseReceipt2: Boolean;
    procedure CancelReceipt;
    function FSFiscalization(const P: TFSFiscalization; var R: TFDDocument): Integer;
    function FSReFiscalization(const P: TFSReFiscalization; var R: TFDDocument): Integer;
    function IsCapFooterFlag: Boolean;
    procedure SetFooterFlag(Value: Boolean);
    procedure SetBeforeCommand(Value: TCommandEvent);
    function GetOnPrinterStatus: TNotifyEvent;
    procedure SetOnPrinterStatus(Value: TNotifyEvent);
    function IsCapBarcode2D: Boolean;

    property Status: TPrinterStatus read FStatus write FStatus;
    property Parameters: TPrinterParameters read GetParameters;
    property CapFiscalStorage: Boolean read GetCapFiscalStorage;
    property Model: TPrinterModelRec read GetModel write FModel;
    property Tables: TDeviceTables read GetTables write SetTables;
    property LongStatus: TLongPrinterStatus read FLongStatus write FLongStatus;
    property ShortStatus: TShortPrinterStatus read FShortStatus write FShortStatus;
    property DeviceMetrics: TDeviceMetrics read FDeviceMetrics write FDeviceMetrics;
    property CapReceiptDiscount2: Boolean read GetCapReceiptDiscount2;
    property Logger: ILogFile read GetLogger;
    property CapSubtotalRound: Boolean read GetCapSubtotalRound;
  end;

implementation

{ TMockFiscalPrinterDevice }

constructor TMockFiscalPrinterDevice.Create;
begin
  inherited Create;
  FContext := TDriverContext.Create;
  FModel := PrinterModelDefault;
  FPort := TSerialPort.Create(1, FContext.Logger);
  FStatistics := TFiscalPrinterStatistics.Create(FContext.Logger);
end;

destructor TMockFiscalPrinterDevice.Destroy;
begin
  FPort.Free;
  FStatistics.Free;
  FContext.Free;
  inherited Destroy;
end;

function TMockFiscalPrinterDevice.GetParameters: TPrinterParameters;
begin
  Result := FContext.Parameters;
end;

function TMockFiscalPrinterDevice.GetLogger: ILogFile;
begin
  Result := FContext.Logger;
end;

function TMockFiscalPrinterDevice.GetContext: TDriverContext;
begin
  Result := FContext;
end;

function TMockFiscalPrinterDevice.AlignLines(const Line1, Line2: string;
  LineWidth: Integer): string;
begin

end;

function TMockFiscalPrinterDevice.Beep: Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.BinToFieldValue(
  FieldInfo: TPrinterFieldRec; const Value: string): string;
begin

end;

function TMockFiscalPrinterDevice.Buy(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.CashIn(Amount: Int64);
begin

end;

procedure TMockFiscalPrinterDevice.CashOut(Amount: Int64);
begin

end;

procedure TMockFiscalPrinterDevice.Check(Value: Integer);
begin

end;

procedure TMockFiscalPrinterDevice.ClosePort;
begin

end;

procedure TMockFiscalPrinterDevice.ConfirmDate(const Date: TPrinterDate);
begin

end;

function TMockFiscalPrinterDevice.ContinuePrint: Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.CutPaper(CutType: Byte);
begin

end;

function TMockFiscalPrinterDevice.DecodeEJFlags(Flags: Byte): TEJFlags;
begin

end;

function TMockFiscalPrinterDevice.DoWriteTable(
  Table, Row, Field: Integer;
  const FieldValue: string): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.EjectSlip(Direction: Byte);
begin

end;

function TMockFiscalPrinterDevice.EJReportStop: Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.EJTotalsReportDate(
  const Parameters: TDateReport);
begin

end;

procedure TMockFiscalPrinterDevice.EJTotalsReportNumber(
  const Parameters: TNumberReport);
begin

end;

function TMockFiscalPrinterDevice.Execute(const Data: string): string;
begin

end;

function TMockFiscalPrinterDevice.ExecuteCommand(
  var Command: TCommandRec): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ExecuteData(const Data: string;
  var RxData: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ExecutePrinterCommand(
  Command: TPrinterCommand): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ExecuteStream(
  Stream: TBinStream): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ExecuteStream2(
  Stream: TBinStream): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.FeedPaper(Station, Lines: Byte);
begin
end;

function TMockFiscalPrinterDevice.FieldToInt(FieldInfo: TPrinterFieldRec;
  const Value: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FieldToStr(FieldInfo: TPrinterFieldRec;
  const Value: string): string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.Fiscalization(Password, PrinterID,
  FiscalID: Int64): TFiscalizationResult;
begin

end;

function TMockFiscalPrinterDevice.FormatBoldLines(const Line1,
  Line2: string): string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.FormatLines(const Line1,
  Line2: string): string;
begin
  Result := '';
end;

procedure TMockFiscalPrinterDevice.FullCut;
begin

end;

function TMockFiscalPrinterDevice.GetDayDiscountTotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetDayItemTotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetDayItemVoidTotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetDeviceMetrics: TDeviceMetrics;
begin
  Result := FDeviceMetrics;
end;

function TMockFiscalPrinterDevice.GetDumpBlock: TDumpBlock;
begin

end;

function TMockFiscalPrinterDevice.GetEJReportLine(
  var Line: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadEJActivation(var Line: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetEJSesssionResult(Number: Word;
  var Text: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetEJStatus1(
  var Status: TEJStatus1): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetFieldValue(
  FieldInfo: TPrinterFieldRec; const Value: string): string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.GetFMFlags(Flags: Byte): TFMFlags;
begin

end;

function TMockFiscalPrinterDevice.GetLine(const Text: string; MinLength,
  MaxLength: Integer): string;
begin

end;

function TMockFiscalPrinterDevice.GetLine(const Text: string): string;
begin

end;

function TMockFiscalPrinterDevice.GetLongSerial: TGetLongSerial;
begin

end;

function TMockFiscalPrinterDevice.GetModel: TPrinterModelRec;
begin
  Result := FModel;
end;

function TMockFiscalPrinterDevice.GetOnCommand: TCommandEvent;
begin

end;

function TMockFiscalPrinterDevice.GetPort: TSerialPort;
begin
  Result := FPort;
end;

function TMockFiscalPrinterDevice.GetPortParams(Port: Byte): TPortParams;
begin

end;

function TMockFiscalPrinterDevice.GetPrinterFlags(
  Flags: Word): TPrinterFlags;
begin

end;

function TMockFiscalPrinterDevice.GetPrintWidth: Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetRecDiscountTotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetRecItemTotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetRecItemVoidTotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetStatus: TPrinterStatus;
begin
  Result := FStatus;
end;

function TMockFiscalPrinterDevice.GetSubtotal: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetSysPassword: DWORD;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetTaxPassword: DWORD;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetUsrPassword: DWORD;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.InitFiscalMemory;
begin

end;

procedure TMockFiscalPrinterDevice.InitializeTables;
begin

end;

procedure TMockFiscalPrinterDevice.InterruptReport;
begin

end;

function TMockFiscalPrinterDevice.LoadGraphics(Line: Word;
  Data: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.LongFisc(NewPassword: DWORD; PrinterID,
  FiscalID: Int64): TLongFiscResult;
begin

end;

procedure TMockFiscalPrinterDevice.OpenDrawer(DrawerNumber: Byte);
begin

end;

function TMockFiscalPrinterDevice.OpenReceipt(ReceiptType: Byte): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.OpenSlipDoc(
  Params: TSlipParams): TDocResult;
begin

end;

function TMockFiscalPrinterDevice.OpenStdSlip(
  Params: TStdSlipParams): TDocResult;
begin

end;

procedure TMockFiscalPrinterDevice.PartialCut;
begin

end;

procedure TMockFiscalPrinterDevice.PrintActnTotalizers;
begin

end;

function TMockFiscalPrinterDevice.PrintBarcode(const Barcode: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.PrintBarLine(Height: Word;
  Data: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.PrintBoldString(Flags: Byte;
  const Text: string): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.PrintDepartmentsReport;
begin

end;

procedure TMockFiscalPrinterDevice.PrintDocHeader(const DocName: string;
  DocNumber: Word);
begin

end;

procedure TMockFiscalPrinterDevice.PrintDocTrailer(Flags: Byte);
begin

end;

function TMockFiscalPrinterDevice.PrintGraphics(Line1,
  Line2: Word): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.PrintHeader;
begin

end;

function TMockFiscalPrinterDevice.PrintReceiptCopy: Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.PrintString(Stations: Byte;
  const Text: string);
begin

end;

procedure TMockFiscalPrinterDevice.PrintStringFont(Station, Font: Byte;
  const Line: string);
begin

end;

procedure TMockFiscalPrinterDevice.PrintTaxReport;
begin

end;

procedure TMockFiscalPrinterDevice.PrintTrailer;
begin

end;

procedure TMockFiscalPrinterDevice.PrintXReport;
begin

end;

procedure TMockFiscalPrinterDevice.PrintZReport;
begin

end;

function TMockFiscalPrinterDevice.ReadOperatingRegister(ID: Byte): Word;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadCashRegister(ID: Byte): Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadFieldStructure(Table,
  Field: Byte): TPrinterFieldRec;
begin

end;

function TMockFiscalPrinterDevice.ReadFiscInfo(
  FiscNumber: Byte): TFiscInfo;
begin

end;

function TMockFiscalPrinterDevice.ReadFMLastRecordDate: TFMRecordDate;
begin

end;

function TMockFiscalPrinterDevice.ReadFontInfo(
  FontNumber: Byte): TFontInfo;
begin

end;

function TMockFiscalPrinterDevice.ReadLicense: Int64;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadDaysRange: TDayRange;
begin

end;

function TMockFiscalPrinterDevice.ReadTableBin(Table, Row,
  Field: Integer): string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.ReadTableInt(Table, Row,
  Field: Integer): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadTableStr(Table, Row,
  Field: Integer): string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.ReceiptCancel: Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReceiptCharge(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReceiptDiscount(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReceiptStornoCharge(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReceiptStornoDiscount(
  Operation: TAmountOperation): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReportOnDateRange(ReportType: Byte;
  Range: TDayDateRange): TDayRange;
begin

end;

function TMockFiscalPrinterDevice.ReportOnNumberRange(ReportType: Byte;
  Range: TDayNumberRange): TDayRange;
begin

end;

procedure TMockFiscalPrinterDevice.ResetFiscalMemory;
begin

end;

procedure TMockFiscalPrinterDevice.ResetTotalizers;
begin

end;

function TMockFiscalPrinterDevice.RetBuy(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.RetSale(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.Sale(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.SendCommand(
  var Command: TCommandRec): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.SetDate(const Date: TPrinterDate);
begin

end;

procedure TMockFiscalPrinterDevice.SetLongSerial(Serial: Int64);
begin

end;

procedure TMockFiscalPrinterDevice.SetOnCommand(Value: TCommandEvent);
begin

end;

procedure TMockFiscalPrinterDevice.SetPointPosition(PointPosition: Byte);
begin

end;

function TMockFiscalPrinterDevice.SetPortParams(Port: Byte;
  const PortParams: TPortParams): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.SetSysPassword(const Value: DWORD);
begin

end;

procedure TMockFiscalPrinterDevice.SetTaxPassword(const Value: DWORD);
begin

end;

procedure TMockFiscalPrinterDevice.SetTime(const Time: TPrinterTime);
begin

end;

procedure TMockFiscalPrinterDevice.SetUsrPassword(const Value: DWORD);
begin

end;

function TMockFiscalPrinterDevice.SlipClose(
  Params: TCloseReceiptParams): TCloseReceiptResult;
begin

end;

function TMockFiscalPrinterDevice.SlipDiscount(Params: TSlipDiscountParams;
  Discount: TSlipDiscount): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.SlipOperation(Params: TSlipOperation;
  Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.SlipStdDiscount(
  Discount: TSlipDiscount): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.SlipStdOperation(LineNumber: Byte;
  Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.StartDump(DeviceCode: Integer): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.StartTest(Interval: Byte);
begin

end;

procedure TMockFiscalPrinterDevice.StopDump;
begin

end;

procedure TMockFiscalPrinterDevice.StopTest;
begin

end;

function TMockFiscalPrinterDevice.Storno(Operation: TPriceReg): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.WriteLicense(License: Int64);
begin

end;

procedure TMockFiscalPrinterDevice.WriteSerial(Serial: DWORD);
begin

end;

function TMockFiscalPrinterDevice.WriteTable(
  Table, Row, Field: Integer;
  const FieldValue: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.WriteTableInt(
  Table, Row, Field,
  Value: Integer): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetTables: TDeviceTables;
begin

end;

procedure TMockFiscalPrinterDevice.SetTables(const Value: TDeviceTables);
begin

end;

procedure TMockFiscalPrinterDevice.Open(AConnection: IPrinterConnection);
begin

end;

procedure TMockFiscalPrinterDevice.ClaimDevice(PortNumber, Timeout: Integer);
begin

end;

procedure TMockFiscalPrinterDevice.Initialize(Parameters: TPrinterParameters);
begin

end;

procedure TMockFiscalPrinterDevice.ReleaseDevice;
begin

end;

function TMockFiscalPrinterDevice.IsReceiptOpened: Boolean;
begin
  Result := False;
end;

procedure TMockFiscalPrinterDevice.OpenPort(PortNumber, BaudRate,
  ByteTimeout: Integer);
begin

end;

function TMockFiscalPrinterDevice.ReadLongStatus: TLongPrinterStatus;
begin
  Result := FLongStatus;
end;

procedure TMockFiscalPrinterDevice.UpdateModel;
begin

end;

(*
function TMockFiscalPrinterDevice.GetPrinterMode: TPrinterMode;
begin
  Result.Mode := MODE_REC;
  Result.AdvancedMode := 0;
  Result.OperatorNumber := 1;
end;
*)


function TMockFiscalPrinterDevice.CapPrintStringFont: Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.CapShortEcrStatus: Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.CapGraphics: Boolean;
begin
  Result := True;
end;

procedure TMockFiscalPrinterDevice.PrintJournal(DayNumber: Integer);
begin

end;

procedure TMockFiscalPrinterDevice.Lock;
begin

end;

procedure TMockFiscalPrinterDevice.Unlock;
begin

end;

function TMockFiscalPrinterDevice.ReadParameter(ParamID: Integer): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.WriteParameter(ParamID,
  ValueID: Integer);
begin

end;

procedure TMockFiscalPrinterDevice.LoadModels;
begin

end;

procedure TMockFiscalPrinterDevice.SaveModels;
begin

end;

function TMockFiscalPrinterDevice.ReadTableInfo(Table: Byte;
  var R: TPrinterTableRec): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadTableStructure(Table: Byte;
  var R: TPrinterTableRec): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadCashReg(ID: Byte;
  var R: TCashRegisterRec): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadOperatingReg(ID: Byte;
  var R: TOperRegisterRec): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetStatistics: TFiscalPrinterStatistics;
begin
  Result := FStatistics;
end;

function TMockFiscalPrinterDevice.GetResultCode: Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetResultText: string;
begin

end;

function TMockFiscalPrinterDevice.QueryEJActivation: TEJActivation;
begin

end;

function TMockFiscalPrinterDevice.GetIsOnline: Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.GetOnConnect: TNotifyEvent;
begin

end;

function TMockFiscalPrinterDevice.GetOnDisconnect: TNotifyEvent;
begin

end;

procedure TMockFiscalPrinterDevice.SetOnConnect(const Value: TNotifyEvent);
begin

end;

procedure TMockFiscalPrinterDevice.SetOnDisconnect(
  const Value: TNotifyEvent);
begin

end;

procedure TMockFiscalPrinterDevice.AddFilter(
  AFilter: IFiscalPrinterFilter);
begin

end;

procedure TMockFiscalPrinterDevice.RemoveFilter(
  AFilter: IFiscalPrinterFilter);
begin

end;

procedure TMockFiscalPrinterDevice.OpenDay;
begin

end;

procedure TMockFiscalPrinterDevice.PrintText(const Data: TTextRec);
begin

end;

procedure TMockFiscalPrinterDevice.PrintText(Station: Integer; const Text: string);
begin

end;

function TMockFiscalPrinterDevice.CenterLine(const Line: string): string;
begin
  Result := Line;
end;

procedure TMockFiscalPrinterDevice.CheckGraphicsSize(Line: Word);
begin

end;

function TMockFiscalPrinterDevice.IsDayOpened(Mode: Integer): Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.GetAmountDecimalPlaces: Integer;
begin
  Result := 2;
end;

procedure TMockFiscalPrinterDevice.SetAmountDecimalPlaces(
  const Value: Integer);
begin

end;

procedure TMockFiscalPrinterDevice.SetFlags(Flags: TPrinterFlags);
begin
  FLongStatus.Flags := EncodePrinterFlags(Flags);
  FShortStatus.Flags := EncodePrinterFlags(Flags);
end;

function TMockFiscalPrinterDevice.ReceiptClose(
  const P: TCloseReceiptParams; var R: TCloseReceiptResult): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.PrintBarcode2(
  const Barcode: TBarcodeRec);
begin
  { !!! }
end;

function TMockFiscalPrinterDevice.LoadImage(const FileName: string;
  StartLine: Integer): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.PrintImage(const FileName: string;
  StartLine: Integer);
begin

end;

procedure TMockFiscalPrinterDevice.Connect;
begin

end;

procedure TMockFiscalPrinterDevice.PrintTextFont(Station, Font: Integer;
  const Text: string);
begin

end;

function TMockFiscalPrinterDevice.ReadFMTotals(Flags: Byte;
  var R: TFMTotals): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.PrintImageScale(const FileName: string;
  StartLine, Scale: Integer);
begin

end;

function TMockFiscalPrinterDevice.ParseEJDocument(
  const Text: string): TEJDocument;
begin

end;

function TMockFiscalPrinterDevice.ReadEJDocument(MACNumber: Integer;
  var Line: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadEJDocumentText(
  MACNumber: Integer): string;
begin

end;

function TMockFiscalPrinterDevice.WaitForPrinting: TPrinterStatus;
begin

end;

function TMockFiscalPrinterDevice.GetPrinterStatus: TPrinterStatus;
begin

end;

function TMockFiscalPrinterDevice.FSSale(
  const P: TFSSale): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSStorno(
  const P: TFSSale): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSWriteTLV(
  const TLVData: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadBlock(const P: TFSBlockRequest;
  var Block: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadBlockData: string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.FSReadStatus(var R: TFSStatus): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSStartWrite(DataSize: Word;
  var BlockSize: Byte): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSWriteBlock(
  const Block: TFSBlock): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.FSWriteBlockData(
  const BlockData: string);
begin

end;

function TMockFiscalPrinterDevice.GetErrorText(Code: Integer): string;
begin

end;

function TMockFiscalPrinterDevice.GetCapFiscalStorage: Boolean;
begin
  Result := False;
end;

function TMockFiscalPrinterDevice.OpenFiscalDay: Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.ReceiptDiscount2(
  Operation: TReceiptDiscount2): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetCapReceiptDiscount2: Boolean;
begin
  Result := False;
end;

function TMockFiscalPrinterDevice.ReadSysOperatorNumber: Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadUsrOperatorNumber: Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetTaxInfo(Tax: Integer): TTaxInfo;
begin

end;

function TMockFiscalPrinterDevice.FSFindDocument(DocNumber: Integer;
  var R: TFSDocument): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSPrintCalcReport(
  var R: TFSCalcReport): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadCommStatus(
  var R: TFSCommStatus): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadDocMac(var DocMac: Int64): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadExpireDate(
  var Date: TPrinterDate): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadFiscalResult(
  var R: TFSFiscalResult): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReadState(var R: TFSState): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSWriteTag(TagID: Integer;
  const Data: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.WriteCustomerAddress(
  const Value: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetDiscountMode: Integer;
begin
  Result := 2;
end;

function TMockFiscalPrinterDevice.ReadFPParameter(
  ParamId: Integer): string;
begin
  Result := '';
end;

procedure TMockFiscalPrinterDevice.WriteFPParameter(ParamId: Integer;
  const Value: string);
begin

end;

function TMockFiscalPrinterDevice.GetIsFiscalized: Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.FSReadTotals(var R: TFMTotals): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadDayTotals: TFMTotals;
begin

end;

function TMockFiscalPrinterDevice.ReadFPTotals(Flags: Integer): TFMTotals;
begin

end;

function TMockFiscalPrinterDevice.FSPrintCorrectionReceipt(
  var Command: TFSCorrectionReceipt): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.ReadFieldInfo(Table, Field: Byte;
  var R: TPrinterFieldRec): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.LoadTables(const Path: WideString);
begin

end;

function TMockFiscalPrinterDevice.ReadFSParameter(ParamID: Integer;
  const pString: string): string;
begin
  Result := '';
end;

function TMockFiscalPrinterDevice.FSReadTicket(var R: TFSTicket): Integer;
begin
  Result := 0;
end;

procedure TMockFiscalPrinterDevice.Close;
begin

end;

function TMockFiscalPrinterDevice.GetCapOpenReceipt: Boolean;
begin
  Result := False;
end;

function TMockFiscalPrinterDevice.IsRecOpened: Boolean;
begin
  Result := False;
end;

procedure TMockFiscalPrinterDevice.CancelReceipt;
begin

end;

function TMockFiscalPrinterDevice.GetCapDiscount: Boolean;
begin
  Result := False;
end;

function TMockFiscalPrinterDevice.GetCapSubtotalRound: Boolean;
begin
  Result := False;
end;

function TMockFiscalPrinterDevice.ReadLoaderVersion(
  var Version: string): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSSale2(const P: TFSSale2): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetCapFSCloseReceipt2: Boolean;
begin
  Result := True;
end;

function TMockFiscalPrinterDevice.ReceiptClose2(
  const P: TFSCloseReceiptParams2; var R: TFSCloseReceiptResult2): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSFiscalization(
  const P: TFSFiscalization; var R: TFDDocument): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.FSReFiscalization(
  const P: TFSReFiscalization; var R: TFDDocument): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.GetPrintWidth(Font: Integer): Integer;
begin
  Result := 0;
end;

function TMockFiscalPrinterDevice.IsCapFooterFlag: Boolean;
begin
  Result := False;
end;

procedure TMockFiscalPrinterDevice.SetFooterFlag(Value: Boolean);
begin

end;

function TMockFiscalPrinterDevice.GetOnPrinterStatus: TNotifyEvent;
begin

end;

function TMockFiscalPrinterDevice.ReadPrinterStatus: TPrinterStatus;
begin

end;

function TMockFiscalPrinterDevice.ReadShortStatus: TShortPrinterStatus;
begin
  Result := FShortStatus;
end;

procedure TMockFiscalPrinterDevice.SetBeforeCommand(Value: TCommandEvent);
begin

end;

procedure TMockFiscalPrinterDevice.SetOnPrinterStatus(Value: TNotifyEvent);
begin

end;

function TMockFiscalPrinterDevice.IsCapBarcode2D: Boolean;
begin
  Result := False;
end;

end.
