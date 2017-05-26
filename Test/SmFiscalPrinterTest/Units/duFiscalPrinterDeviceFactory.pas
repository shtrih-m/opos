unit duFiscalPrinterDeviceFactory;

interface

uses
  // VCL
  Windows,
  // This
  FiscalPrinterTypes, PrinterCommand, PrinterFrame, PrinterTypes, BinStream,
  StringUtils, SerialPort, PrinterTable, ByteUtils, DeviceTables,
  FiscalPrinterDeviceFactory, SysPrinterParameters,
  UsrPrinterParameters, PrinterConnection;

type
  { TTestFiscalPrinterDevice }

  TTestFiscalPrinterDevice = class(TInterfacedObject, IFiscalPrinterDevice)
  private
    FPort: TSerialPort;
    function GetPort: TSerialPort;
    function GetPrinterFlags(Flags: Word): TPrinterFlags;
    function GetStatus: TPrinterStatus;
    procedure Initialize(SysParameters: TSysPrinterParameters;
      UsrParameters: TUsrPrinterParameters);
    function IsReceiptOpened: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure FullCut;
    procedure PartialCut;
    procedure InterruptReport;
    procedure StopDump;
    procedure SetLongSerial(Serial: Int64);
    procedure SetPortParams(Port: Byte; const PortParams: TPortParams);
    procedure PrintDocHeader(const DocName: string; DocNumber: Word);
    procedure StartTest(Interval: Byte);
    procedure WriteLicense(License: Int64);
    procedure WriteTableInt(Table, Row, Field, Value: Integer);
    procedure DoWriteTable(Table, Row, Field: Integer; const FieldValue: string);
    procedure WriteTable(Table, Row, Field: Integer; const FieldValue: string);
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

    function StartDump(DeviceCode: Integer): Integer;
    function GetDumpBlock: TDumpBlock;
    function GetLongSerial: TGetLongSerial;
    function GetShortStatus: TShortPrinterStatus;
    function GetLongStatus: TLongPrinterStatus;
    function GetFMFlags(Flags: Byte): TFMFlags;
    function PrintBoldString(Flags: Byte; const Text: string): Integer;
    function Beep: Integer;
    function GetPortParams(Port: Byte): TPortParams;
    function ReadCashTotalizer(ID: Byte): Int64;
    function ReadActnTotalizer(ID: Byte): Word;
    function ReadLicense: Int64;
    function ReadTableBin(Table, Row, Field: Integer): string;
    function ReadTableStr(Table, Row, Field: Integer): string;
    function ReadTableInt(Table, Row, Field: Integer): Integer;
    function ReadFontInfo(FontNumber: Byte): TFontInfo;
    function ReadFMTotals(Flags: Byte): TFMTotals;
    function OpenSlipDoc(Params: TSlipParams): TDocResult;
    function OpenStdSlip(Params: TStdSlipParams): TDocResult;
    function SlipOperation(Params: TSlipOperation; Operation: TPriceReg): Integer;
    function SlipStdOperation(LineNumber: Byte; Operation: TPriceReg): Integer;
    function SlipDiscount(Params: TSlipDiscountParams; Discount: TSlipDiscount): Integer;
    function SlipStdDiscount(Discount: TSlipDiscount): Integer;
    function SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ContinuePrint: Integer;
    function LoadGraphics(Line: Byte; Data: string): Integer;
    function PrintGraphics(Line1, Line2: Byte): Integer;
    function PrintBarcode(Barcode: Int64): Integer;
    function PrintGraphics2(Line1, Line2: Word): Integer;
    function LoadGraphics2(Line: Word; Data: string): Integer;
    function PrintBarLine(Height: Word; Data: string): Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetDayDiscountTotal: Int64;
    function GetRecDiscountTotal: Int64;
    function GetDayItemTotal: Int64;
    function GetRecItemTotal: Int64;
    function GetDayItemVoidTotal: Int64;
    function GetRecItemVoidTotal: Int64;
    function ReadTableStructure(Table: Byte): TPrinterTableRec;
    function ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
    function GetEJSesssionResult(Number: Word; var Text: string): Integer;
    function GetEJReportLine(var Line: string): Integer;
    function EJReportStop: Integer;
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    function Execute(const Data: string): string;
    function ExecuteStream(Stream: TBinStream): Integer;
    function ExecutePrinterCommand(Command: TPrinterCommand): Integer;
    function GetPrintWidth: Integer;
    function GetSysPassword: DWORD;
    function GetTaxPassword: DWORD;
    function GetUsrPassword: DWORD;
    function Sale(Operation: TPriceReg): Integer;
    function Buy(Operation: TPriceReg): Integer;
    function RetSale(Operation: TPriceReg): Integer;
    function RetBuy(Operation: TPriceReg): Integer;
    function Storno(Operation: TPriceReg): Integer;
    function ReceiptClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ReceiptDiscount(Operation: TAmountOperation): Integer;
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
    function ReadShiftsRange: TShiftRange;
    function ReadFMLastRecordDate: TFMRecordDate;
    function ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
    function LongFisc(NewPassword: DWORD; PrinterID, FiscalID: Int64): TLongFiscResult;
    function Fiscalization(Password, PrinterID, FiscalID: Int64): TFiscalizationResult;
    function ReportOnDateRange(ReportType: Byte; Range: TShiftDateRange): TShiftRange;
    function ReportOnNumberRange(ReportType: Byte; Range: TShiftNumberRange): TShiftRange;
    function DecodeEJFlags(Flags: Byte): TEJFlags;
    function ReadTableInfo(Table: Byte): TPrinterTableRec;
    function GetLine(const Text: string): string; overload;
    function GetLine(const Text: string; MinLength, MaxLength: Integer): string; overload;
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: string): Integer;
    function ReadFieldInfo(Table, Field: Byte): TPrinterFieldRec;
    function ExecuteData(const Data: string; var RxData: string): Integer;
    function ExecuteCommand(var Command: TCommandRec): Integer;
    function SendCommand(var Command: TCommandRec): Integer;
    function AlignLines(const Line1, Line2: string; LineWidth: Integer): string;
    function GetModel: TModelInfo;
    function GetOnCommand: TCommandEvent;
    function GetTables: TDeviceTables;
    procedure PrintTextFont(Station, Font: Integer; const Text: string);
    procedure SetTables(const Value: TDeviceTables);

    procedure ClosePort;
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
    procedure Open(AConnection: IPrinterConnection);
    procedure UpdateModel;

    property Model: TModelInfo read GetModel;
    property Tables: TDeviceTables read GetTables write SetTables;
  end;

var
  FModel: TModelInfo;
  FStatus: TPrinterStatus;
  FDeviceMetrics: TDeviceMetrics;
  FLongStatus: TLongPrinterStatus;
  FShortStatus: TShortPrinterStatus;

implementation

{ TTestFiscalPrinterDevice }

constructor TTestFiscalPrinterDevice.Create;
begin
  FPort := TSerialPort.Create;
end;

destructor TTestFiscalPrinterDevice.Destroy;
begin
  FPort.Free;
  inherited Destroy;
end;

function TTestFiscalPrinterDevice.AlignLines(const Line1, Line2: string;
  LineWidth: Integer): string;
begin

end;

function TTestFiscalPrinterDevice.Beep: Integer;
begin

end;

function TTestFiscalPrinterDevice.BinToFieldValue(
  FieldInfo: TPrinterFieldRec; const Value: string): string;
begin

end;

function TTestFiscalPrinterDevice.Buy(Operation: TPriceReg): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.CashIn(Amount: Int64);
begin

end;

procedure TTestFiscalPrinterDevice.CashOut(Amount: Int64);
begin

end;

procedure TTestFiscalPrinterDevice.Check(Value: Integer);
begin

end;

procedure TTestFiscalPrinterDevice.ClosePort;
begin

end;

procedure TTestFiscalPrinterDevice.ConfirmDate(const Date: TPrinterDate);
begin

end;

function TTestFiscalPrinterDevice.ContinuePrint: Integer;
begin

end;

procedure TTestFiscalPrinterDevice.CutPaper(CutType: Byte);
begin

end;

function TTestFiscalPrinterDevice.DecodeEJFlags(Flags: Byte): TEJFlags;
begin

end;

procedure TTestFiscalPrinterDevice.DoWriteTable(Table, Row, Field: Integer;
  const FieldValue: string);
begin

end;

procedure TTestFiscalPrinterDevice.EjectSlip(Direction: Byte);
begin

end;

function TTestFiscalPrinterDevice.EJReportStop: Integer;
begin

end;

procedure TTestFiscalPrinterDevice.EJTotalsReportDate(
  const Parameters: TDateReport);
begin

end;

procedure TTestFiscalPrinterDevice.EJTotalsReportNumber(
  const Parameters: TNumberReport);
begin

end;

function TTestFiscalPrinterDevice.Execute(const Data: string): string;
begin

end;

function TTestFiscalPrinterDevice.ExecuteCommand(
  var Command: TCommandRec): Integer;
begin

end;

function TTestFiscalPrinterDevice.ExecuteData(const Data: string;
  var RxData: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.ExecutePrinterCommand(
  Command: TPrinterCommand): Integer;
begin

end;

function TTestFiscalPrinterDevice.ExecuteStream(
  Stream: TBinStream): Integer;
begin

end;

function TTestFiscalPrinterDevice.ExecuteStream2(
  Stream: TBinStream): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.FeedPaper(Station, Lines: Byte);
begin

end;

function TTestFiscalPrinterDevice.FieldToInt(FieldInfo: TPrinterFieldRec;
  const Value: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.FieldToStr(FieldInfo: TPrinterFieldRec;
  const Value: string): string;
begin

end;

function TTestFiscalPrinterDevice.Fiscalization(Password, PrinterID,
  FiscalID: Int64): TFiscalizationResult;
begin

end;

function TTestFiscalPrinterDevice.FormatBoldLines(const Line1,
  Line2: string): string;
begin

end;

function TTestFiscalPrinterDevice.FormatLines(const Line1,
  Line2: string): string;
begin

end;

procedure TTestFiscalPrinterDevice.FullCut;
begin

end;

function TTestFiscalPrinterDevice.GetDayDiscountTotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetDayItemTotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetDayItemVoidTotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetDeviceMetrics: TDeviceMetrics;
begin
  Result := FDeviceMetrics;
end;

function TTestFiscalPrinterDevice.GetDumpBlock: TDumpBlock;
begin

end;

function TTestFiscalPrinterDevice.GetEJReportLine(
  var Line: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.GetEJSesssionResult(Number: Word;
  var Text: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.GetEJStatus1(
  var Status: TEJStatus1): Integer;
begin

end;

function TTestFiscalPrinterDevice.GetFieldValue(
  FieldInfo: TPrinterFieldRec; const Value: string): string;
begin

end;

function TTestFiscalPrinterDevice.GetFMFlags(Flags: Byte): TFMFlags;
begin

end;

function TTestFiscalPrinterDevice.GetLine(const Text: string; MinLength,
  MaxLength: Integer): string;
begin

end;

function TTestFiscalPrinterDevice.GetLine(const Text: string): string;
begin

end;

function TTestFiscalPrinterDevice.GetLongSerial: TGetLongSerial;
begin

end;

function TTestFiscalPrinterDevice.GetModel: TModelInfo;
begin
  Result := FModel;
end;

function TTestFiscalPrinterDevice.GetOnCommand: TCommandEvent;
begin

end;

function TTestFiscalPrinterDevice.GetPort: TSerialPort;
begin
  Result := FPort;
end;

function TTestFiscalPrinterDevice.GetPortParams(Port: Byte): TPortParams;
begin

end;

function TTestFiscalPrinterDevice.GetPrinterFlags(
  Flags: Word): TPrinterFlags;
begin

end;

function TTestFiscalPrinterDevice.GetPrintWidth: Integer;
begin

end;

function TTestFiscalPrinterDevice.GetRecDiscountTotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetRecItemTotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetRecItemVoidTotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetShortStatus: TShortPrinterStatus;
begin
  Result := FShortStatus;
end;

function TTestFiscalPrinterDevice.GetStatus: TPrinterStatus;
begin
  Result := FStatus;
end;

function TTestFiscalPrinterDevice.GetSubtotal: Int64;
begin

end;

function TTestFiscalPrinterDevice.GetSysPassword: DWORD;
begin

end;

function TTestFiscalPrinterDevice.GetTaxPassword: DWORD;
begin

end;

function TTestFiscalPrinterDevice.GetUsrPassword: DWORD;
begin

end;

procedure TTestFiscalPrinterDevice.InitFiscalMemory;
begin

end;

procedure TTestFiscalPrinterDevice.InitializeTables;
begin

end;

procedure TTestFiscalPrinterDevice.InterruptReport;
begin

end;

function TTestFiscalPrinterDevice.LoadGraphics(Line: Byte;
  Data: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.LoadGraphics2(Line: Word;
  Data: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.LongFisc(NewPassword: DWORD; PrinterID,
  FiscalID: Int64): TLongFiscResult;
begin

end;

procedure TTestFiscalPrinterDevice.OpenDrawer(DrawerNumber: Byte);
begin

end;

function TTestFiscalPrinterDevice.OpenReceipt(ReceiptType: Byte): Integer;
begin

end;

function TTestFiscalPrinterDevice.OpenSlipDoc(
  Params: TSlipParams): TDocResult;
begin

end;

function TTestFiscalPrinterDevice.OpenStdSlip(
  Params: TStdSlipParams): TDocResult;
begin

end;

procedure TTestFiscalPrinterDevice.PartialCut;
begin

end;

procedure TTestFiscalPrinterDevice.PrintActnTotalizers;
begin

end;

function TTestFiscalPrinterDevice.PrintBarcode(Barcode: Int64): Integer;
begin

end;

function TTestFiscalPrinterDevice.PrintBarLine(Height: Word;
  Data: string): Integer;
begin

end;

function TTestFiscalPrinterDevice.PrintBoldString(Flags: Byte;
  const Text: string): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.PrintDepartmentsReport;
begin

end;

procedure TTestFiscalPrinterDevice.PrintDocHeader(const DocName: string;
  DocNumber: Word);
begin

end;

procedure TTestFiscalPrinterDevice.PrintDocTrailer(Flags: Byte);
begin

end;

function TTestFiscalPrinterDevice.PrintGraphics(Line1,
  Line2: Byte): Integer;
begin

end;

function TTestFiscalPrinterDevice.PrintGraphics2(Line1,
  Line2: Word): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.PrintHeader;
begin

end;

function TTestFiscalPrinterDevice.PrintReceiptCopy: Integer;
begin

end;

procedure TTestFiscalPrinterDevice.PrintString(Stations: Byte;
  const Text: string);
begin

end;

procedure TTestFiscalPrinterDevice.PrintStringFont(Station, Font: Byte;
  const Line: string);
begin

end;

procedure TTestFiscalPrinterDevice.PrintTaxReport;
begin

end;

procedure TTestFiscalPrinterDevice.PrintTrailer;
begin

end;

procedure TTestFiscalPrinterDevice.PrintXReport;
begin

end;

procedure TTestFiscalPrinterDevice.PrintZReport;
begin

end;

function TTestFiscalPrinterDevice.ReadActnTotalizer(ID: Byte): Word;
begin

end;

function TTestFiscalPrinterDevice.ReadCashTotalizer(ID: Byte): Int64;
begin

end;

function TTestFiscalPrinterDevice.ReadFieldInfo(Table,
  Field: Byte): TPrinterFieldRec;
begin

end;

function TTestFiscalPrinterDevice.ReadFieldStructure(Table,
  Field: Byte): TPrinterFieldRec;
begin

end;

function TTestFiscalPrinterDevice.ReadFiscInfo(
  FiscNumber: Byte): TFiscInfo;
begin

end;

function TTestFiscalPrinterDevice.ReadFMLastRecordDate: TFMRecordDate;
begin

end;

function TTestFiscalPrinterDevice.ReadFMTotals(Flags: Byte): TFMTotals;
begin

end;

function TTestFiscalPrinterDevice.ReadFontInfo(
  FontNumber: Byte): TFontInfo;
begin

end;

function TTestFiscalPrinterDevice.ReadLicense: Int64;
begin

end;

function TTestFiscalPrinterDevice.ReadShiftsRange: TShiftRange;
begin

end;

function TTestFiscalPrinterDevice.ReadTableBin(Table, Row,
  Field: Integer): string;
begin

end;

function TTestFiscalPrinterDevice.ReadTableInfo(
  Table: Byte): TPrinterTableRec;
begin

end;

function TTestFiscalPrinterDevice.ReadTableInt(Table, Row,
  Field: Integer): Integer;
begin

end;

function TTestFiscalPrinterDevice.ReadTableStr(Table, Row,
  Field: Integer): string;
begin

end;

function TTestFiscalPrinterDevice.ReadTableStructure(
  Table: Byte): TPrinterTableRec;
begin

end;

function TTestFiscalPrinterDevice.ReceiptCancel: Integer;
begin

end;

function TTestFiscalPrinterDevice.ReceiptCharge(
  Operation: TAmountOperation): Integer;
begin

end;

function TTestFiscalPrinterDevice.ReceiptClose(
  Params: TCloseReceiptParams): TCloseReceiptResult;
begin

end;

function TTestFiscalPrinterDevice.ReceiptDiscount(
  Operation: TAmountOperation): Integer;
begin

end;

function TTestFiscalPrinterDevice.ReceiptStornoCharge(
  Operation: TAmountOperation): Integer;
begin

end;

function TTestFiscalPrinterDevice.ReceiptStornoDiscount(
  Operation: TAmountOperation): Integer;
begin

end;

function TTestFiscalPrinterDevice.ReportOnDateRange(ReportType: Byte;
  Range: TShiftDateRange): TShiftRange;
begin

end;

function TTestFiscalPrinterDevice.ReportOnNumberRange(ReportType: Byte;
  Range: TShiftNumberRange): TShiftRange;
begin

end;

procedure TTestFiscalPrinterDevice.ResetFiscalMemory;
begin

end;

procedure TTestFiscalPrinterDevice.ResetTotalizers;
begin

end;

function TTestFiscalPrinterDevice.RetBuy(Operation: TPriceReg): Integer;
begin

end;

function TTestFiscalPrinterDevice.RetSale(Operation: TPriceReg): Integer;
begin

end;

function TTestFiscalPrinterDevice.Sale(Operation: TPriceReg): Integer;
begin

end;

function TTestFiscalPrinterDevice.SendCommand(
  var Command: TCommandRec): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.SetDate(const Date: TPrinterDate);
begin

end;

procedure TTestFiscalPrinterDevice.SetLongSerial(Serial: Int64);
begin

end;

procedure TTestFiscalPrinterDevice.SetOnCommand(Value: TCommandEvent);
begin

end;

procedure TTestFiscalPrinterDevice.SetPointPosition(PointPosition: Byte);
begin

end;

procedure TTestFiscalPrinterDevice.SetPortParams(Port: Byte;
  const PortParams: TPortParams);
begin

end;

procedure TTestFiscalPrinterDevice.SetSysPassword(const Value: DWORD);
begin

end;

procedure TTestFiscalPrinterDevice.SetTaxPassword(const Value: DWORD);
begin

end;

procedure TTestFiscalPrinterDevice.SetTime(const Time: TPrinterTime);
begin

end;

procedure TTestFiscalPrinterDevice.SetUsrPassword(const Value: DWORD);
begin

end;

function TTestFiscalPrinterDevice.SlipClose(
  Params: TCloseReceiptParams): TCloseReceiptResult;
begin

end;

function TTestFiscalPrinterDevice.SlipDiscount(Params: TSlipDiscountParams;
  Discount: TSlipDiscount): Integer;
begin

end;

function TTestFiscalPrinterDevice.SlipOperation(Params: TSlipOperation;
  Operation: TPriceReg): Integer;
begin

end;

function TTestFiscalPrinterDevice.SlipStdDiscount(
  Discount: TSlipDiscount): Integer;
begin

end;

function TTestFiscalPrinterDevice.SlipStdOperation(LineNumber: Byte;
  Operation: TPriceReg): Integer;
begin

end;

function TTestFiscalPrinterDevice.StartDump(DeviceCode: Integer): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.StartTest(Interval: Byte);
begin

end;

procedure TTestFiscalPrinterDevice.StopDump;
begin

end;

procedure TTestFiscalPrinterDevice.StopTest;
begin

end;

function TTestFiscalPrinterDevice.Storno(Operation: TPriceReg): Integer;
begin

end;

procedure TTestFiscalPrinterDevice.WriteLicense(License: Int64);
begin

end;

procedure TTestFiscalPrinterDevice.WriteSerial(Serial: DWORD);
begin

end;

procedure TTestFiscalPrinterDevice.WriteTable(Table, Row, Field: Integer;
  const FieldValue: string);
begin

end;

procedure TTestFiscalPrinterDevice.WriteTableInt(Table, Row, Field,
  Value: Integer);
begin

end;

procedure TTestFiscalPrinterDevice.PrintTextFont(Station, Font: Integer;
  const Text: string);
begin
  { !!! }
end;

function TTestFiscalPrinterDevice.GetTables: TDeviceTables;
begin

end;

procedure TTestFiscalPrinterDevice.SetTables(const Value: TDeviceTables);
begin

end;

procedure TTestFiscalPrinterDevice.Open(AConnection: IPrinterConnection);
begin

end;

procedure TTestFiscalPrinterDevice.ClaimDevice(PortNumber, Timeout: Integer);
begin

end;

procedure TTestFiscalPrinterDevice.Initialize(
  SysParameters: TSysPrinterParameters;
  UsrParameters: TUsrPrinterParameters);
begin

end;

procedure TTestFiscalPrinterDevice.ReleaseDevice;
begin

end;

function TTestFiscalPrinterDevice.IsReceiptOpened: Boolean;
begin

end;

procedure TTestFiscalPrinterDevice.OpenPort(PortNumber, BaudRate,
  ByteTimeout: Integer);
begin

end;

function TTestFiscalPrinterDevice.GetLongStatus: TLongPrinterStatus;
begin
  Result := FLongStatus;
end;

procedure TTestFiscalPrinterDevice.UpdateModel;
begin

end;

(*
function TTestFiscalPrinterDevice.GetPrinterMode: TPrinterMode;
begin
  Result.Mode := MODE_REC;
  Result.AdvancedMode := 0;
  Result.OperatorNumber := 1;
end;
*)


end.
