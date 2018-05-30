unit TrainingReceiptPrinter;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  ReceiptPrinter, FiscalPrinterDevice, PrinterParameters, StringUtils,
  PrinterTypes, SharedPrinter, FiscalPrinterTypes, DeviceTables, MathUtils,
  WException, gnugettext;

type
  { TTrainingReceiptPrinter }

  TTrainingReceiptPrinter = class(TReceiptPrinter, IReceiptPrinter)
  private
    FTotal: Int64;
    FIsRecOpened: Boolean;
    FCashInNumber: Integer;
    FCashOutNumber: Integer;
    FSalesRecNumber: Integer;
    FRetSaleRecNumber: Integer;
    FRetBuyRecNumber: Integer;
    FBuyRecNumber: Integer;
    FRecType: Integer;

    procedure ResetState;
    procedure CheckRecOpened;
    procedure CheckRecType(ARecType: Integer);
    function GetPrintWidth: Integer;
  public
    constructor Create(ASharedPrinter: ISharedPrinter); override;
    // IReceiptPrinter
    procedure PrintMode;
    procedure PrintZReport;
    procedure ReceiptCancel;
    function GetSubtotal: Int64;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Buy(Operation: TPriceReg);
    procedure RetBuy(Operation: TPriceReg);
    procedure Sale(Operation: TPriceReg);
    procedure Storno(Operation: TPriceReg);
    procedure RetSale(Operation: TPriceReg);
    procedure ReceiptClose(Params: TCloseReceiptParams);
    procedure ReceiptDiscount(Operation: TAmountOperation);
    procedure ReceiptCharge(Operation: TAmountOperation);
    procedure ReceiptStornoDiscount(Operation: TAmountOperation);
    procedure ReceiptStornoCharge(Operation: TAmountOperation);
    function ReadCashRegister(ID: Byte): Int64;
    function ReadOperatingRegister(ID: Byte): Word;
    procedure PrintSubtotal;
    procedure PrintText(const Data: TTextRec); overload;
    procedure PrintText2(const Text: WideString; Station, Font: Integer;
      Alignment: TTextAlignment);
    function GetTables: TDeviceTables;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function GetTaxTotals(Amount: Int64): TTaxTotals;

    property PrintWidth: Integer read GetPrintWidth;
  end;

implementation


function GetTaxLetter(Tax: Integer): WideString;
const
  TaxLetter = '¿¡¬√';
begin
  Result := '';
  if Tax in [1..4] then
    Result := TaxLetter[Tax];
end;

function GetTaxLetters(Tax1, Tax2, Tax3, Tax4: Integer): WideString;
begin
  Result := '';
  Result := Result + GetTaxLetter(Tax1);
  Result := Result + GetTaxLetter(Tax2);
  Result := Result + GetTaxLetter(Tax3);
  Result := Result + GetTaxLetter(Tax4);
  if Result <> '' then
    Result := '_' + Result;
end;

procedure NotImplemented;
begin
  { !!! }
end;

{ TTrainingReceiptPrinter }

constructor TTrainingReceiptPrinter.Create(ASharedPrinter: ISharedPrinter);
begin
  inherited Create(ASharedPrinter);
  ResetState;
end;

procedure TTrainingReceiptPrinter.ResetState;
begin
  FCashInNumber := 1;
  FCashOutNumber := 1;
  FSalesRecNumber := 1;
  FIsRecOpened := False;
end;

procedure TTrainingReceiptPrinter.PrintMode;
var
  Line: WideString;
  L1, L2: Integer;
begin
  Line := Parameters.GetPrinterMessage(MsgTrainModeText);
  L1 := (Printer.PrintWidth - Length(Line)) div 2;
  L2 := Printer.PrintWidth - Length(Line) - L1;
  Line := StringOfChar('*', L1) + Line + StringOfChar('*', L2);
  Printer.PrintRecText(Line);
end;

procedure TTrainingReceiptPrinter.CashIn(Amount: Int64);
begin
  Printer.PrintDocHeader(Parameters.GetPrinterMessage(MsgTrainCashInText), FCashInNumber);

  Device.WaitForPrinting;
  Printer.PrintCurrency('', IntToCurrency(Amount));
  Inc(FCashInNumber);
end;

procedure TTrainingReceiptPrinter.CashOut(Amount: Int64);
begin
  Printer.PrintDocHeader(Parameters.GetPrinterMessage(MsgTrainCashOutText), FCashOutNumber);
  Device.WaitForPrinting;
  Printer.PrintCurrency('', IntToCurrency(Amount));
  Inc(FCashOutNumber);
end;

procedure TTrainingReceiptPrinter.Sale(Operation: TPriceReg);
var
  S: WideString;
  Total: Int64;
begin
  OpenReceipt(RecTypeSale);
  Printer.PrintRecText(Operation.Text);

  Total := Round2(Operation.Price*Operation.Quantity/1000);
  FTotal := FTotal + Total;

  S := '=' + CurrencyToStr(IntToCurrency(FTotal)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines('', S);
end;

procedure TTrainingReceiptPrinter.Buy(Operation: TPriceReg);
var
  S: WideString;
  Total: Int64;
begin
  OpenReceipt(RecTypeBuy);
  Printer.PrintRecText(Operation.Text);

  Total := Round2(Operation.Price*Operation.Quantity/1000);
  FTotal := FTotal + Total;
  S := '=' + CurrencyToStr(IntToCurrency(FTotal)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines('', S);
end;

procedure TTrainingReceiptPrinter.RetBuy(Operation: TPriceReg);
var
  S: WideString;
  Total: Int64;
begin
  OpenReceipt(RecTypeRetBuy);
  Printer.PrintRecText(Operation.Text);

  Total := Round2(Operation.Price*Operation.Quantity/1000);
  FTotal := FTotal + Total;
  S := '=' + CurrencyToStr(IntToCurrency(FTotal)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines('', S);
end;

procedure TTrainingReceiptPrinter.PrintZReport;
begin
  { !!! }
  ResetState;
end;

procedure TTrainingReceiptPrinter.ReceiptCancel;
begin
  Printer.PrintLine(Printer.Station, Parameters.GetPrinterMessage(MsgTrainVoidRecText));
  FIsRecOpened := False;
end;

procedure TTrainingReceiptPrinter.ReceiptClose(Params: TCloseReceiptParams);
var
  Line: WideString;
  CashAmount: Int64;
  ChangeAmount: Int64;
  CashlessAmount: Int64;
begin
  CashAmount := Params.CashAmount;
  CashlessAmount := Params.Amount2 + Params.Amount3 + Params.Amount4;
  if CashlessAmount > FTotal then
    Printer.Check($4D); // Cashless sum is larger than receipt sum
  if (CashAmount + CashlessAmount) < FTotal then
    Printer.Check($45); // All payment types sum is less than receipt sum
  ChangeAmount := CashAmount + CashlessAmount - FTotal;

  Line := Printer.FormatBoldLines(Parameters.GetPrinterMessage(MsgTrainTotalText), '=' +
    Printer.CurrencyToStr(IntToCurrency(FTotal)));
  Printer.PrintBoldString(Printer.Station, Line);

  if Params.CashAmount <> 0 then
    Printer.PrintCurrency(Parameters.GetPrinterMessage(MsgTrainCashPayText), IntToCurrency(Params.CashAmount));

  if Params.Amount2 <> 0 then
    Printer.PrintCurrency(Parameters.GetPrinterMessage(MsgTrainPay2Text), IntToCurrency(Params.Amount2));

  if Params.Amount3 <> 0 then
    Printer.PrintCurrency(Parameters.GetPrinterMessage(MsgTrainPay3Text), IntToCurrency(Params.Amount3));

  if Params.Amount4 <> 0 then
    Printer.PrintCurrency(Parameters.GetPrinterMessage(MsgTrainPay4Text), IntToCurrency(Params.Amount4));

  if ChangeAmount <> 0 then
    Printer.PrintCurrency(Parameters.GetPrinterMessage(MsgTrainChangeText), IntToCurrency(ChangeAmount));

  Printer.PrintRecText(' ');
  Printer.PrintRecText(' ');
  FIsRecOpened := False;
end;

function TTrainingReceiptPrinter.GetSubtotal: Int64;
begin
  if not FIsRecOpened then
    raiseException(_('Receipt is not opened'));
  Result := FTotal;
end;

procedure TTrainingReceiptPrinter.ReceiptDiscount(Operation: TAmountOperation);
var
  S1: WideString;
  S2: WideString;
begin
  CheckRecOpened;
  Printer.PrintRecText(Operation.Text);
  S1 := Parameters.GetPrinterMessage(MsgTrainDiscountText);
  S2 := '=' + CurrencyToStr(IntToCurrency(Operation.Amount)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines(S1, S2);
  FTotal := FTotal - Operation.Amount;
end;

procedure TTrainingReceiptPrinter.ReceiptCharge(Operation: TAmountOperation);
var
  S1: WideString;
  S2: WideString;
begin
  CheckRecOpened;
  Printer.PrintRecText(Operation.Text);
  S1 := Parameters.GetPrinterMessage(MsgTrainChargeText);
  S2 := '=' + CurrencyToStr(IntToCurrency(Operation.Amount)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines(S1, S2);
  FTotal := FTotal + Operation.Amount;
end;

procedure TTrainingReceiptPrinter.RetSale(Operation: TPriceReg);
var
  S: WideString;
  Total: Int64;
begin
  OpenReceipt(RecTypeRetSale);
  Printer.PrintRecText(Operation.Text);

  Total := Round2(Operation.Price*Operation.Quantity/1000);
  FTotal := FTotal + Total;
  S := '=' + CurrencyToStr(IntToCurrency(FTotal)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines('', S);
end;

procedure TTrainingReceiptPrinter.Storno(Operation: TPriceReg);
var
  Total: Int64;
begin
  CheckRecOpened;
  Printer.PrintRecText(Parameters.GetPrinterMessage(MsgTrainStornoText));

  Total := Round2(Operation.Price*Operation.Quantity/1000);
  if Total > FTotal then
    Printer.Check($65);
  FTotal := FTotal - Total;
  Printer.PrintCurrency('', IntToCurrency(FTotal));
end;

procedure TTrainingReceiptPrinter.ReceiptStornoDiscount(
  Operation: TAmountOperation);
var
  S1: WideString;
  S2: WideString;
begin
  CheckRecOpened;
  Printer.PrintRecText(Operation.Text);
  S1 := Parameters.GetPrinterMessage(MsgTrainVoidDiscountText);
  S2 := '=' + CurrencyToStr(IntToCurrency(Operation.Amount)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines(S1, S2);
  FTotal := FTotal + Operation.Amount;
end;

procedure TTrainingReceiptPrinter.ReceiptStornoCharge(
  Operation: TAmountOperation);
var
  S1: WideString;
  S2: WideString;
begin
  CheckRecOpened;
  Printer.PrintRecText(Operation.Text);
  S1 := Parameters.GetPrinterMessage(MsgTrainVoidChargeText);
  S2 := '=' + CurrencyToStr(IntToCurrency(Operation.Amount)) +
    GetTaxLetters(Operation.Tax1, Operation.Tax2, Operation.Tax3, Operation.Tax4);
  Printer.PrintLines(S1, S2);
  FTotal := FTotal - Operation.Amount;
end;

procedure TTrainingReceiptPrinter.CheckRecOpened;
begin
  if not FIsRecOpened then
    Printer.Check($4A); // Receipt is opened. Command is invalid
end;

procedure TTrainingReceiptPrinter.CheckRecType(ARecType: Integer);
begin
  if ARecType <> FRecType then
    Printer.Check($49); // Command is invalid in opened receipt of this type
end;

function TTrainingReceiptPrinter.ReadCashRegister(ID: Byte): Int64;
begin
  Result := 0;
end;

function TTrainingReceiptPrinter.ReadOperatingRegister(ID: Byte): Word;
begin
  Result := 0;
end;

procedure TTrainingReceiptPrinter.PrintSubtotal;
begin
  if IsReceiptOpened then
    Printer.PrintSubtotal(GetSubtotal);
end;

procedure TTrainingReceiptPrinter.PrintText(const Data: TTextRec);
begin
  Device.PrintText(Data);
end;

procedure TTrainingReceiptPrinter.PrintText2(const Text: WideString; Station,
  Font: Integer; Alignment: TTextAlignment);
begin

end;

function TTrainingReceiptPrinter.GetPrintWidth: Integer;
begin
  Result := 0;
end;

function TTrainingReceiptPrinter.GetTables: TDeviceTables;
begin
  Result := Device.Tables;
end;

function TTrainingReceiptPrinter.OpenReceipt(ReceiptType: Byte): Integer;
begin
  Result := 0;
  if not FIsRecOpened then
  begin
    case ReceiptType of
      RecTypeSale: Printer.PrintDocHeader(
        Parameters.GetPrinterMessage(MsgTrainSaleText), FSalesRecNumber);
      RecTypeRetSale: Printer.PrintDocHeader(
        Parameters.GetPrinterMessage(MsgTrainRetSaleText), FRetSaleRecNumber);
      RecTypeBuy:  Printer.PrintDocHeader(
        Parameters.GetPrinterMessage(MsgTrainBuyText), FBuyRecNumber);
      RecTypeRetBuy:  Printer.PrintDocHeader(
        Parameters.GetPrinterMessage(MsgTrainRetBuyText), FRetBuyRecNumber);
    end;
    FIsRecOpened := True;
    FRecType := ReceiptType;
    Device.WaitForPrinting;
  end;
  CheckRecType(ReceiptType);
end;

function TTrainingReceiptPrinter.GetTaxTotals(Amount: Int64): TTaxTotals;
begin

end;

end.
