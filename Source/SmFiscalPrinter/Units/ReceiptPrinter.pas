unit ReceiptPrinter;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  SharedPrinter, FiscalPrinterDevice, PrinterParameters, PrinterTypes,
  StringUtils, FiscalPrinterTypes, PayType, PrinterModel, DriverTypes,
  PrinterTable, DeviceTables;

type
  { IReceiptPrinter }

  IReceiptPrinter = interface
    ['{D8017478-A787-4899-9A19-15B52CEBF5D5}']
    procedure OpenDay;
    procedure PrintMode;
    procedure PrintZReport;
    procedure ReceiptCancel;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(Operation: TPriceReg);
    procedure Buy(Operation: TPriceReg);
    procedure Storno(Operation: TPriceReg);
    procedure RetSale(Operation: TPriceReg);
    procedure RetBuy(Operation: TPriceReg);
    procedure ReceiptClose(Params: TCloseReceiptParams);
    procedure ReceiptDiscount(Operation: TAmountOperation);
    procedure ReceiptCharge(Operation: TAmountOperation);
    procedure ReceiptStornoDiscount(Operation: TAmountOperation);
    procedure ReceiptStornoCharge(Operation: TAmountOperation);
    function ReadCashRegister(ID: Byte): Int64;
    function ReadOperatingRegister(ID: Byte): Word;
    function GetSubtotal: Int64;
    procedure PrintSubtotal;
    procedure PrintText(const Data: TTextRec);
    procedure PrintTextLine(const S: WideString);
    procedure PrintPreLine;
    procedure PrintPostLine;
    function CurrencyToInt(Value: Currency): Int64;
    function IntToCurrency(Value: Int64): Currency;
    function CheckTotal: Boolean;
    procedure PrintCancelReceipt;
    procedure PrintDocHeader(const DocName: WideString; DocNumber: Word);
    procedure WaitForPrinting;
    procedure PrintDocHeaderEnd;
    procedure PrintLines(const Line1, Line2: WideString);
    function ReadPrinterStatus: TPrinterStatus;
    function GetPayCode(const Description: WideString): Integer;
    function GetModel: TPrinterModelRec;
    function OpenReceipt(ReceiptType: Byte): Integer;
    procedure PrintCurrency(const Line: WideString; Value: Currency);
    procedure PrintSeparator(SeparatorType, SeparatorHeight: Integer);
    function DeviceName: WideString;
    function FormatBoldLines(const Line1, Line2: WideString): WideString;
    function PrintBoldString(Flags: Byte; const Text: WideString): Integer;
    function GetStation: Integer;
    procedure PrintText2(const Text: WideString; Station, Font: Integer;
      Alignment: TTextAlignment);
    function GetPrintWidth: Integer;
    function CurrencyToStr(Value: Currency): WideString;
    function IsDecimalPoint: Boolean;
    function GetTables: TDeviceTables;
    function IsDayOpened(Mode: Integer): Boolean;
    function FSSale(const P: TFSSale): Integer;
    function FSStorno(const P: TFSSale): Integer;
    function GetPrinter: ISharedPrinter;
    function GetTaxTotals(Amount: Int64): TTaxTotals;

    property Station: Integer read GetStation;
    property PrintWidth: Integer read GetPrintWidth;
    property Tables: TDeviceTables read GetTables;
    property Printer: ISharedPrinter read GetPrinter;
  end;

  { TReceiptPrinter }

  TReceiptPrinter = class(TInterfacedObject)
  private
    FPrinter: ISharedPrinter;
    function GetParameters: TPrinterParameters;
  public
    constructor Create(APrinter: ISharedPrinter); virtual;
    destructor Destroy; override;

    procedure OpenDay;
    function GetPrintWidth: Integer;
    function GetTables: TDeviceTables;
    function GetPrinter: ISharedPrinter;
    function GetStation: Integer;
    function IsReceiptOpened: Boolean;
    function ReadPrinterStatus: TPrinterStatus;
    function GetDevice: IFiscalPrinterDevice;

    procedure PrintPreLine;
    procedure PrintPostLine;
    procedure WaitForPrinting;
    procedure PrintCancelReceipt;
    procedure PrintDocHeaderEnd; virtual;
    procedure PrintTextLine(const S: WideString);
    procedure PrintText(const Data: TTextRec);

    procedure PrintLines(const Line1, Line2: WideString);
    procedure PrintDocHeader(const DocName: WideString; DocNumber: Word);
    procedure PrintCurrency(const Line: WideString; Value: Currency);
    procedure PrintSeparator(SeparatorType, SeparatorHeight: Integer);

    function CurrencyToInt(Value: Currency): Int64;
    function IntToCurrency(Value: Int64): Currency;
    function GetPayCode(const Description: WideString): Integer;
    function IsDecimalPoint: Boolean;
    function CurrencyToStr(Value: Currency): WideString;
    function CheckTotal: Boolean;
    function GetModel: TPrinterModelRec;
    function DeviceName: WideString;
    function FormatBoldLines(const Line1, Line2: WideString): WideString;
    function PrintBoldString(Flags: Byte; const Text: WideString): Integer;
    function IsDayOpened(Mode: Integer): Boolean;
    function FSSale(const P: TFSSale): Integer;
    function FSStorno(const P: TFSSale): Integer;
    procedure PrintText2(const Text: WideString; Station, Font: Integer;
      Alignment: TTextAlignment);

    property Station: Integer read GetStation;
    property Printer: ISharedPrinter read GetPrinter;
    property PrintWidth: Integer read GetPrintWidth;
    property Device: IFiscalPrinterDevice read GetDevice;
    property Tables: TDeviceTables read GetTables;
    property Parameters: TPrinterParameters read GetParameters;
  end;

implementation

{ TReceiptPrinter }

constructor TReceiptPrinter.Create(APrinter: ISharedPrinter);
begin
  inherited Create;
  FPrinter := APrinter;
end;

destructor TReceiptPrinter.Destroy;
begin
  FPrinter := nil;
  inherited Destroy;
end;

procedure TReceiptPrinter.PrintPreLine;
begin
  if Length(Printer.PreLine) > 0 then
  begin
    PrintTextLine(Printer.PreLine);
    Printer.PreLine := '';
  end;
end;

procedure TReceiptPrinter.PrintPostLine;
begin
  if Length(Printer.PostLine) > 0 then
  begin
    PrintTextLine(Printer.PostLine);
    Printer.PostLine := '';
  end;
end;

function TReceiptPrinter.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Device;
end;

procedure TReceiptPrinter.PrintCancelReceipt;
begin
  Printer.PrintCancelReceipt;
end;

procedure TReceiptPrinter.PrintCurrency(const Line: WideString;
  Value: Currency);
begin
  Printer.PrintCurrency(Line, Value);
end;

procedure TReceiptPrinter.PrintDocHeader(const DocName: WideString;
  DocNumber: Word);
begin
  Printer.PrintDocHeader(DocName, DocNumber);
end;

procedure TReceiptPrinter.PrintLines(const Line1, Line2: WideString);
begin
  Printer.PrintLines(Line1, Line2);
end;

function TReceiptPrinter.IsReceiptOpened: Boolean;
begin
  Result := (Device.ReadPrinterStatus.Mode and $0F) = MODE_REC;
end;

procedure TReceiptPrinter.PrintTextLine(const S: WideString);
begin
  Printer.PrintText(S);
end;

procedure TReceiptPrinter.WaitForPrinting;
begin
  Device.WaitForPrinting;
end;

procedure TReceiptPrinter.PrintDocHeaderEnd;
begin
end;

function TReceiptPrinter.ReadPrinterStatus: TPrinterStatus;
begin
  Result := Device.ReadPrinterStatus;
end;

function TReceiptPrinter.GetPayCode(const Description: WideString): Integer;
var
  PayType: TPayType;
begin
  PayType := Parameters.PayTypes.ItemByText(Description);
  if PayType <> nil then Result := PayType.Code
  else Result := 0;
end;

function TReceiptPrinter.GetStation: Integer;
begin
  Result := Printer.GetStation;
end;

procedure TReceiptPrinter.PrintSeparator(SeparatorType,
  SeparatorHeight: Integer);
begin
  Printer.PrintSeparator(SeparatorType, SeparatorHeight);
end;

function TReceiptPrinter.CurrencyToInt(Value: Currency): Int64;
begin
  Result := Printer.CurrencyToInt(Value);
end;

function TReceiptPrinter.IntToCurrency(Value: Int64): Currency;
begin
  Result := Printer.IntToCurrency(Value);
end;

function TReceiptPrinter.IsDecimalPoint: Boolean;
begin
  Result := Printer.IsDecimalPoint;
end;

function TReceiptPrinter.CurrencyToStr(Value: Currency): WideString;
begin
  Result := Printer.CurrencyToStr(Value);
end;

procedure TReceiptPrinter.PrintText(const Data: TTextRec);
begin
  Printer.Device.PrintText(Data);
end;

function TReceiptPrinter.CheckTotal: Boolean;
begin
  Result := Printer.CheckTotal;
end;

function TReceiptPrinter.GetModel: TPrinterModelRec;
begin
  Result := Device.Model;
end;

(*
procedure TReceiptPrinter.PrintSubtotal;
begin
  if IsReceiptOpened then
    Printer.PrintSubtotal(GetSubtotal);
end;

*)

function TReceiptPrinter.DeviceName: WideString;
begin
  Result := Printer.DeviceName;
end;

function TReceiptPrinter.FormatBoldLines(const Line1,
  Line2: WideString): WideString;
begin
  Result := Device.FormatBoldLines(Line1, Line2);
end;

function TReceiptPrinter.PrintBoldString(Flags: Byte;
  const Text: WideString): Integer;
begin
  Result := Device.PrintBoldString(Flags, Text);
end;

procedure TReceiptPrinter.PrintText2(const Text: WideString;
  Station, Font: Integer; Alignment: TTextAlignment);
var
  Data: TTextREc;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Font;
  Data.Alignment := Alignment;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

function TReceiptPrinter.GetPrintWidth: Integer;
begin
  Result := Device.GetPrintWidth;
end;

function TReceiptPrinter.GetTables: TDeviceTables;
begin
  Result := Device.Tables;
end;

function TReceiptPrinter.IsDayOpened(Mode: Integer): Boolean;
begin
  Result := Device.IsDayOpened(Mode);
end;

procedure TReceiptPrinter.OpenDay;
begin
  Device.OpenDay;
end;

function TReceiptPrinter.FSSale(const P: TFSSale): Integer;
begin
  Result := Device.FSSale(P);
end;

function TReceiptPrinter.FSStorno(const P: TFSSale): Integer;
begin
  Result := Device.FSStorno(P);
end;

function TReceiptPrinter.GetPrinter: ISharedPrinter;
begin
  Result := FPrinter;
end;

function TReceiptPrinter.GetParameters: TPrinterParameters;
begin
  Result := Printer.Parameters;
end;

end.
