unit GlobusTextReceipt;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  CustomReceipt, PrinterTypes, ByteUtils, OposFptr, OposException,
  Opos, PayType, ReceiptPrinter, FiscalPrinterState, FiscalPrinterTypes,
  PrinterParameters, PrinterParametersX, DirectIOAPI, TextItem, MathUtils,
  StringUtils, gnugettext;

type
  { TGlobusTextReceipt }

  TGlobusTextReceipt = class(TCustomReceipt)
  private
    FTotal: Int64;
    FRecType: Integer;
    FIsVoided: Boolean;
    FPayments: TPayments;
    FItemsCount: Integer;
    FPreLines: TTextItems;
    FLastItemAmount: Int64;
    FIsReceiptOpened: Boolean;
    FEndSeparatorPrinted: Boolean;
    FVatAmount: array [0..4] of Int64;
    FChargeAmount: array [0..4] of Int64;
    FDiscountAmount: array [0..4] of Int64;

    function GetPayment: Int64;
    procedure SubtotalCharge(const Description: WideString; Amount: Int64);
    procedure SubtotalDiscount(const Description: WideString; Amount: Int64);
    function GetTaxTotals(Amount: Int64): TTaxTotals;
    function IsCashlessPayCode(PayCode: Integer): Boolean;
    procedure CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
    procedure RecSubtotalAdjustment(const Description: WideString;
      AdjustmentType: Integer; Amount: Currency);
    procedure PrintReceiptItem(const Description: string; Price: Currency;
      Quantity: Double; VatInfo: Integer);
    procedure PrintDiscount(const Description: string; Amount: Int64;
      VatInfo: Integer);
    procedure PrintCharge(const Description: string; Amount: Int64;
      VatInfo: Integer);
    procedure PrintItem(const PriceReg: TPriceReg);
    function GetVatText(VatInfo: Integer): string;
    procedure UpdateRecType;
    procedure PrintFiscalReceipt;
    function IsZeroReceipt: Boolean;
    procedure PrintNonFiscalReceipt;
    procedure PrintSeparator;
    procedure DoOpenReceipt;
    procedure PrintEndSeparator;
    procedure CheckDiscountAmount(Amount: Int64);
  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
    destructor Destroy; override;

    procedure PrintReceiptItems;

    function IsSingleQuantity(Quantity: Integer): Boolean;
    procedure OpenReceipt(ARecType: Integer); override;

    procedure PrintRecVoid(const Description: string); override;

    procedure PrintRecItem(const Description: string; Price: Currency;
      Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
      const UnitName: string); override;

    procedure PrintRecItemAdjustment(AdjustmentType: Integer;
      const Description: string; Amount: Currency;
      VatInfo: Integer); override;

    procedure PrintRecPackageAdjustment(AdjustmentType: Integer;
      const Description, VatAdjustment: string); override;

    procedure PrintRecPackageAdjustVoid(AdjustmentType: Integer;
      const VatAdjustment: string); override;

    procedure PrintRecRefund(const Description: string; Amount: Currency;
      VatInfo: Integer); override;

    procedure PrintRecRefundVoid(const Description: string;
      Amount: Currency; VatInfo: Integer); override;

    procedure PrintRecSubtotal(Amount: Currency); override;

    procedure PrintRecSubtotalAdjustment(AdjustmentType: Integer;
      const Description: string; Amount: Currency); override;

    procedure PrintRecTotal(ATotal, Payment: Currency;
      const Description: string); override;

    procedure PrintRecVoidItem(const Description: string; Amount: Currency;
      Quantity: Integer; AdjustmentType: Integer; Adjustment: Currency;
      VatInfo: Integer);  override;

    procedure PrintRecItemVoid(const Description: string;
      Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
      const UnitName: string); override;

    procedure BeginFiscalReceipt(PrintHeader: Boolean); override;
    procedure EndFiscalReceipt;  override;
    procedure AfterEndFiscalReceipt; override;

    procedure PrintRecSubtotalAdjustVoid(AdjustmentType: Integer;
      Amount: Currency); override;

    procedure PrintRecItemRefund(
      const Description: string;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: string); override;

    procedure PrintRecItemRefundVoid(
      const Description: string;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: string); override;

    function GetCashlessTotal: Int64;
    procedure PrintText2(const Text: string; Station, Font: Integer;
      Alignment: TTextAlignment);

    procedure PrintNormal(const Text: string; Station: Integer); override;
  end;

implementation

{ TGlobusTextReceipt }

constructor TGlobusTextReceipt.CreateReceipt(AContext: TReceiptContext;
  ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
  FPreLines := TTextItems.Create;
end;

destructor TGlobusTextReceipt.Destroy;
begin
  FPreLines.Free;
  inherited Destroy;
end;

function TGlobusTextReceipt.GetVatText(VatInfo: Integer): string;
begin
  Result := '';
  if Parameters.RFShowTaxLetters then
  begin
    case VatInfo of
      1: Result := '_À';
      2: Result := '_Á';
      3: Result := '_Â';
      4: Result := '_Ã';
    end;
  end;
end;

function TGlobusTextReceipt.IsCashlessPayCode(PayCode: Integer): Boolean;
begin
  Result := PayCode in [1..3];
end;

function TGlobusTextReceipt.GetPayment: Int64;
begin
  Result := FPayments[0] + FPayments[1] + FPayments[2] + FPayments[3];
end;

function TGlobusTextReceipt.GetCashlessTotal: Int64;
begin
  Result := FPayments[1] + FPayments[2] + FPayments[3];
end;

procedure TGlobusTextReceipt.PrintRecVoid(const Description: string);
begin
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TGlobusTextReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
begin
  case AdjustmentType of

    FPTR_AT_AMOUNT_DISCOUNT,
    FPTR_AT_AMOUNT_SURCHARGE:
      CheckAmount(Amount);

    FPTR_AT_PERCENTAGE_DISCOUNT,
    FPTR_AT_PERCENTAGE_SURCHARGE:
      CheckPercents(Amount);
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

function TGlobusTextReceipt.IsSingleQuantity(Quantity: Integer): Boolean;
begin
  Result := Quantity = 1000;
end;

procedure TGlobusTextReceipt.PrintRecItem(
  const Description: string; Price: Currency;
  Quantity: Integer; VatInfo: Integer;
  UnitPrice: Currency; const UnitName: string);
var
  ItemPrice: Currency;
  ItemQuantity: Double;
begin
  DoOpenReceipt;
  PrintPreLine;

  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);

  if UnitPrice = 0 then
  begin
    // If no price - use single quanity cost
    ItemQuantity := 1;
    ItemPrice := Price;
  end else
  begin
    ItemQuantity := Quantity/1000;
    if Quantity = 0 then
      ItemQuantity := 1;
    ItemPrice := UnitPrice;
  end;
  PrintReceiptItem(Description, ItemPrice, ItemQuantity, VatInfo);
  PrintPostLine;
end;

function QuantityToStr(Value: Currency): string;
var
  IsFractional: Boolean;
  FormatSettings: TFormatSettings;
begin
  IsFractional := Round2(Frac(Value) * 1000) <> 0;
  if IsFractional then
  begin
    FormatSettings.DecimalSeparator := '.';
    FormatSettings.ThousandSeparator := #0;
    Result := FormatFloat('0.000', Value, FormatSettings);
  end else
  begin
    Result := IntToStr(Round2(Value));
  end;
end;

procedure TGlobusTextReceipt.PrintReceiptItem(
  const Description: string; Price: Currency;
  Quantity: Double;
  VatInfo: Integer);
var
  Text: string;
  IAmount: Int64;
  Amount: Currency;
  PriceText: string;
  AmountText: string;
  QuantityText: string;
  ItemAmount: Currency;
begin
  Amount := Price * Quantity;
  IAmount := Printer.CurrencyToInt(Amount);

  Inc(FItemsCount);
  FTotal := FTotal + IAmount;
  FLastItemAmount := Abs(IAmount);
  FVatAmount[VatInfo] := FVatAmount[VatInfo] + IAmount;

  if Quantity < 0 then
    Printer.PrintTextLine(PrinterItemVoidText);


  ItemAmount := RoundAmount(Price*Quantity);
  PriceText := AmountToStr(Price);
  AmountText := AmountToStr(ItemAmount);
  QuantityText := QuantityToStr(Quantity);

  Text := Format('%s x %s', [QuantityText, PriceText]);
  Text := Format('%-*s = %*s%s', [
    Parameters.RFQuantityLength, Text,
    Parameters.RFAmountLength, AmountText, GetVatText(VatInfo)]);

  Printer.PrintLines(Description, Text);
end;

procedure TGlobusTextReceipt.CheckDiscountAmount(Amount: Int64);
begin
  if Amount > FTotal then
    RaiseExtendedError(OPOS_EFPTR_NEGATIVE_TOTAL, _('Negative receipt total'));
end;

procedure TGlobusTextReceipt.PrintDiscount(const Description: string;
  Amount: Int64; VatInfo: Integer);
var
  Text: string;
begin
  CheckDiscountAmount(Amount);

  FDiscountAmount[VatInfo] := FDiscountAmount[VatInfo] + Amount;
  FTotal := FTotal - Amount;

  if Printer.IsDecimalPoint then
  Text := Format('= %s%s', [
    Printer.CurrencyToStr(Printer.IntToCurrency(Abs(Amount))),
    GetVatText(VatInfo)]);
  Printer.PrintLines(PrinterDiscountText + ' ' + Description, Text);
end;

procedure TGlobusTextReceipt.PrintCharge(const Description: string;
  Amount: Int64; VatInfo: Integer);
var
  Text: string;
begin
  FChargeAmount[VatInfo] := FChargeAmount[VatInfo] + Amount;
  FTotal := FTotal + Amount;

  Text := Format('= %s%s', [
    Printer.CurrencyToStr(Printer.IntToCurrency(Abs(Amount))),
    GetVatText(VatInfo)]);

  Printer.PrintLines(PrinterChargeText + ' ' + Description, Text);
end;

procedure TGlobusTextReceipt.PrintRecItemAdjustment(
  AdjustmentType: Integer;
  const Description: string;
  Amount: Currency;
  VatInfo: Integer);
var
  ItemAmount: Int64;
begin
  DoOpenReceipt;
  PrintPreLine;

  CheckAdjAmount(AdjustmentType, Amount);

  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT:
    begin
      ItemAmount := Printer.CurrencyToInt(Amount);
      PrintDiscount(Description, ItemAmount, VatInfo);
    end;

    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      ItemAmount := Printer.CurrencyToInt(Amount);
      PrintCharge(Description, ItemAmount, VatInfo);
    end;

    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      ItemAmount := Round2(FLastItemAmount*Amount/100);
      PrintDiscount(Description, ItemAmount, VatInfo);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      ItemAmount := Round2(FLastItemAmount*Amount/100);
      PrintCharge(Description, ItemAmount, VatInfo);
    end;
  else
    RaiseOposException(OPOS_E_ILLEGAL, _('Invalid AdjustmentType parameter'));
  end;
end;

procedure TGlobusTextReceipt.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const Description, VatAdjustment: string);
begin
  DoOpenReceipt;
  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT,
    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Printer.PrintLines(Description, VatAdjustment);
    end;
  else
    RaiseOposException(OPOS_E_ILLEGAL);
  end;
end;

procedure TGlobusTextReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: string);
begin
  DoOpenReceipt;
  PrintPreLine;

  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT,
    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Printer.PrintTextLine(VatAdjustment);
    end;
  else
    RaiseOposException(OPOS_E_ILLEGAL);
  end;
end;

procedure TGlobusTextReceipt.UpdateRecType;
begin
  if (FItemsCount = 0)and(FRecType = RecTypeSale) then
  begin
    FRecType := RecTypeRetSale;
  end;
end;

procedure TGlobusTextReceipt.PrintRecRefund(const Description: string;
  Amount: Currency; VatInfo: Integer);
begin
  CheckAmount(Amount);
  UpdateRecType;
  DoOpenReceipt;
  PrintPreLine;
  PrintReceiptItem(Description, Amount, 1, VatInfo);
  PrintPostLine;
end;

procedure TGlobusTextReceipt.PrintRecRefundVoid(
  const Description: string;
  Amount: Currency; VatInfo: Integer);
begin
  DoOpenReceipt;
  CheckAmount(Amount);
  PrintReceiptItem(Description, Amount, -1, VatInfo);
end;

procedure TGlobusTextReceipt.PrintRecSubtotal(Amount: Currency);
begin
  DoOpenReceipt;
  PrintEndSeparator;
  PrintPreLine;
  CheckAmount(Amount);
  Printer.PrintCurrency(Parameters.SubtotalText, Printer.IntToCurrency(FTotal));
  PrintPostLine;
end;

procedure TGlobusTextReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: string; Amount: Currency);
begin
  PrintPreLine;
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment(Description, AdjustmentType, Amount);
  PrintPostLine;
end;

procedure TGlobusTextReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment('', AdjustmentType, -Amount);
end;

function TGlobusTextReceipt.GetTaxTotals(Amount: Int64): TTaxTotals;
var
  i: Integer;
  TaxAmount: Int64;
  NoTaxSumm: Int64;
begin
  NoTaxSumm := Amount;
  for i := 0 to 4 do
  begin
    Result[i] := 0;
    TaxAmount := FVatAmount[i] - FDiscountAmount[i] + FChargeAmount[i];
    if TaxAmount <> 0 then
    begin
      Result[i] := Round2(Amount * TaxAmount / FTotal);
      NoTaxSumm := NoTaxSumm - Result[i];
    end;
  end;

  for i := 0 to 4 do
  begin
    if Result[i] <> 0 then
      Result[i] := Result[i] + NoTaxSumm;
  end;
end;

procedure TGlobusTextReceipt.SubtotalDiscount(const Description: WideString;
  Amount: Int64);
var
  i: Integer;
  Text: WideString;
  TaxAmounts: TTaxTotals;
begin
  CheckDiscountAmount(Amount);

  Text := Format('= %.2f', [Abs(Amount/100)]);
  Printer.PrintLines(PrinterDiscountText + ' ' + Description, Text);

  TaxAmounts := GetTaxTotals(Amount);
  for i := 0 to 4 do
  begin
    FDiscountAmount[i] := FDiscountAmount[i] + TaxAmounts[i];
  end;
  FTotal := FTotal - Amount;
end;

procedure TGlobusTextReceipt.SubtotalCharge(const Description: WideString;
  Amount: Int64);
var
  i: Integer;
  Text: WideString;
  TaxAmounts: TTaxTotals;
begin
  if Amount = 0 then Exit;

  Text := Format('= %.2f', [Abs(Amount/100)]);
  Printer.PrintLines(PrinterChargeText + ' ' + Description, Text);

  TaxAmounts := GetTaxTotals(Amount);
  for i := 0 to 4 do
  begin
    FChargeAmount[i] := FChargeAmount[i] + TaxAmounts[i];
  end;
  FTotal := FTotal + Amount;
end;

procedure TGlobusTextReceipt.RecSubtotalAdjustment(const Description: WideString;
  AdjustmentType: Integer; Amount: Currency);
var
  Summ: Int64;
begin
  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT:
    begin
      Summ := Round2(Amount*100);
      SubtotalDiscount(Description, Summ);
    end;

    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Summ := Round2(Amount*100);
      SubtotalCharge(Description, Summ);
    end;

    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Summ := Round2(FTotal*Amount/100);
      SubtotalDiscount(Description, Summ);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Summ := Round2(FTotal*Amount/100);
      SubtotalCharge(Description, Summ);
    end;
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TGlobusTextReceipt.PrintRecTotal(ATotal: Currency; Payment: Currency;
  const Description: string);
var
  PayCode: Integer;
  PayAmount: Int64;
begin
  // Check parameters
  CheckAmount(ATotal);
  CheckAmount(Payment);

  // Check payment code
  PayCode := Printer.GetPayCode(Description);
  if not (PayCode in [0..3]) then
    raiseOposException(OPOS_E_ILLEGAL, _('Invalid payment code'));

  PayAmount := Printer.CurrencyToInt(Payment);
  if IsCashlessPayCode(PayCode) and ((PayAmount + GetPayment) > FTotal) then
    PayAmount := FTotal - GetPayment;

  FPayments[PayCode] := FPayments[PayCode] + PayAmount;

  if GetPayment >= FTotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
  PrintPostLine;
end;

procedure TGlobusTextReceipt.OpenReceipt(ARecType: Integer);
begin
  if not FIsReceiptOpened then
  begin
    Printer.OpenReceipt(ARecType);
    FIsReceiptOpened := True;
  end;
end;

procedure TGlobusTextReceipt.PrintEndSeparator;
begin
  if (not FEndSeparatorPrinted) then
  begin
    PrintSeparator;
    FEndSeparatorPrinted := True;
  end;
end;

procedure TGlobusTextReceipt.PrintSeparator;
begin
  if Parameters.RFSeparatorLine = SeparatorLineDashes then
  begin
    Printer.PrintTextLine(StringOfChar('-', Printer.PrintWidth));
  end;

  if Parameters.RFSeparatorLine = SeparatorLineGraphics then
  begin
    Printer.PrintSeparator(DIO_SEPARATOR_WHITE, 5);
    Printer.PrintSeparator(DIO_SEPARATOR_BLACK, 3);
    Printer.PrintSeparator(DIO_SEPARATOR_WHITE, 5);
  end;
end;

procedure TGlobusTextReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
var
  i: Integer;
begin
  inherited BeginFiscalReceipt(PrintHeader);
  FTotal := 0;
  FItemsCount := 0;
  FIsVoided := False;
  for i := 0 to 4 do
  begin
    FVatAmount[i] := 0;
    FChargeAmount[i] := 0;
    FDiscountAmount[i] := 0;
  end;
  FIsReceiptOpened := False;
  FEndSeparatorPrinted := False;
end;

procedure TGlobusTextReceipt.EndFiscalReceipt;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  if not FIsVoided then
  begin
    if IsZeroReceipt then
    begin
      case Parameters.ZeroReceiptType of
        ZERO_RECEIPT_NONFISCAL:
        begin
          PrintNonFiscalReceipt;
        end;
      else
        PrintFiscalReceipt;
      end;
    end else
    begin
      PrintFiscalReceipt;
    end;
  end;
  FIsReceiptOpened := False;
end;

procedure TGlobusTextReceipt.AfterEndFiscalReceipt;
begin
end;

function TGlobusTextReceipt.IsZeroReceipt: Boolean;
begin
  Result := FTotal = 0;
end;

procedure TGlobusTextReceipt.PrintNonFiscalReceipt;
var
  Line: string;
begin
  Printer.WaitForPrinting;
  Printer.PrintDocHeader('ÏÐÎÄÀÆÀ', Parameters.ZeroReceiptNumber);
  Parameters.ZeroReceiptNumber := Parameters.ZeroReceiptNumber + 1;
  Printer.WaitForPrinting;

  Line := Printer.FormatBoldLines('ÈÒÎÃÎ', '=0');
  Printer.PrintBoldString(Printer.Station, Line);
  Printer.WaitForPrinting;
end;

procedure TGlobusTextReceipt.PrintFiscalReceipt;
var
  CloseParams: TCloseReceiptParams;
begin
  PrintEndSeparator;
  PrintReceiptItems;
  Printer.PrintTextLine(' ');

  Printer.Printer.PrintText(AdditionalText);

  CloseParams.CashAmount := FPayments[0];
  CloseParams.Amount2 := FPayments[1];
  CloseParams.Amount3 := FPayments[2];
  CloseParams.Amount4 := FPayments[3];
  CloseParams.PercentDiscount := 0;
  CloseParams.Tax1 := 0;
  CloseParams.Tax2 := 0;
  CloseParams.Tax3 := 0;
  CloseParams.Tax4 := 0;
  CloseParams.Text := Parameters.CloseRecText;
  Printer.ReceiptClose(CloseParams);
end;

procedure TGlobusTextReceipt.PrintReceiptItems;
var
  i: Integer;
  PriceReg: TPriceReg;
  Operation: TAmountOperation;
begin
  if FTotal = 0 then
  begin
    PriceReg.Price := 0;
    PriceReg.Quantity := 1000;
    PriceReg.Department := Parameters.Department;
    PriceReg.Tax1 := 0;
    PriceReg.Tax2 := 0;
    PriceReg.Tax3 := 0;
    PriceReg.Tax4 := 0;
    PriceReg.Text := '';
    PrintItem(PriceReg);
  end else
  begin
    for i := 0 to 4 do
    begin
      FVatAmount[i] := FVatAmount[i] - FDiscountAmount[i] + FChargeAmount[i];
    end;
    // Items
    for i := 0 to 4 do
    begin
      if FVatAmount[i] > 0 then
      begin
        PriceReg.Quantity := 1000;
        PriceReg.Price := FVatAmount[i];
        PriceReg.Department := Parameters.Department;
        PriceReg.Tax1 := i;
        PriceReg.Tax2 := 0;
        PriceReg.Tax3 := 0;
        PriceReg.Tax4 := 0;
        PriceReg.Text := '';
        if (i > 0) then
        begin
          PriceReg.Text := Printer.Tables.Taxes[i].Name;
        end;
        PrintItem(PriceReg);
      end;
    end;
    // Discount
    for i := 0 to 4 do
    begin
      if FVatAmount[i] < 0 then
      begin
        Operation.Amount := Abs(FVatAmount[i]);
        Operation.Department := Parameters.Department;
        Operation.Tax1 := i;
        Operation.Tax2 := 0;
        Operation.Tax3 := 0;
        Operation.Tax4 := 0;
        Operation.Text := '';
        Printer.ReceiptDiscount(Operation);
      end;
    end;
  end;
end;

procedure TGlobusTextReceipt.PrintItem(const PriceReg: TPriceReg);
begin
  case FRecType of
    RecTypeSale    : Printer.Sale(PriceReg);
    RecTypeBuy     : Printer.Buy(PriceReg);
    RecTypeRetSale : Printer.RetSale(PriceReg);
    RecTypeRetBuy  : Printer.RetBuy(PriceReg);
  end;
end;

procedure TGlobusTextReceipt.PrintRecVoidItem(const Description: string;
  Amount: Currency; Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
var
  ItemQuantity: Double;
begin
  DoOpenReceipt;
  CheckAmount(Amount);
  CheckQuantity(Quantity);

  ItemQuantity := 1;
  if Quantity > 0 then
    ItemQuantity := Quantity/1000;

  PrintReceiptItem(Description, Amount, -ItemQuantity, VatInfo);
end;

procedure TGlobusTextReceipt.PrintRecItemVoid(const Description: string;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  ItemPrice: Currency;
  ItemQuantity: Double;
begin
  DoOpenReceipt;
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);

  if UnitPrice = 0 then
  begin
    ItemPrice := Price;
    ItemQuantity := 1;
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    ItemQuantity := Quantity/1000;
    ItemPrice := UnitPrice;
  end;
  PrintReceiptItem(Description, ItemPrice, -ItemQuantity, VatInfo);
end;

procedure TGlobusTextReceipt.PrintRecItemRefund(const Description: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
var
  ItemPrice: Currency;
  ItemQuantity: Double;
begin
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);

  if (UnitAmount = 0)or(Quantity = 0) then
  begin
    ItemQuantity := 1;
    ItemPrice := Amount;
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    ItemQuantity := Quantity/1000;
    ItemPrice := UnitAmount;
  end;
  UpdateRecType;
  DoOpenReceipt;
  PrintPreLine;
  PrintReceiptItem(Description, ItemPrice, ItemQuantity, VatInfo);
end;

procedure TGlobusTextReceipt.PrintRecItemRefundVoid(
  const Description: string;
  Amount: Currency;
  Quantity, VatInfo: Integer;
  UnitAmount: Currency;
  const AUnitName: string);
var
  ItemPrice: Currency;
  ItemQuantity: Double;
begin
  DoOpenReceipt;
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);

  if (UnitAmount = 0)or(Quantity = 0) then
  begin
    ItemQuantity := 1;
    ItemPrice := Amount;
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    ItemQuantity := Quantity/1000;
    ItemPrice := UnitAmount;
  end;
  PrintReceiptItem(Description, ItemPrice, -ItemQuantity, VatInfo);
end;

procedure TGlobusTextReceipt.PrintNormal(const Text: string; Station: Integer);
begin
  PrintText2(Text, Station, Parameters.FontNumber, taLeft);
end;

procedure TGlobusTextReceipt.PrintText2(const Text: string; Station: Integer;
  Font: Integer; Alignment: TTextAlignment);
var
  ItemData: TTextRec;
begin
  if not FIsReceiptOpened then
  begin
    ItemData.Text := Text;
    ItemData.Station := Station;
    ItemData.Font := Parameters.FontNumber;
    ItemData.Alignment := Alignment;
    FPreLines.Add(ItemData);
  end else
  begin
    Printer.PrintText2(Text, Station, 3, Alignment);
  end;
end;


procedure TGlobusTextReceipt.DoOpenReceipt;
var
  i: Integer;
  Item: TTextRec;
begin
  if not Device.IsRecOpened then
  begin
    OpenReceipt(FRecType);
    PrintSeparator;
    for i := 0 to FPreLines.Count-1 do
    begin
      Item := FPreLines[i].Data;
      Printer.PrintText2(Item.Text, Item.Station, Item.Font, Item.Alignment);
    end;
    FPreLines.Clear;
  end;
end;

end.
