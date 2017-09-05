unit TextReceipt;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  CustomReceipt, PrinterTypes, ByteUtils, OposFptr, OposException,
  Opos, PayType, ReceiptPrinter, FiscalPrinterState, FiscalPrinterTypes,
  PrinterParameters, PrinterParametersX, MathUtils, SmResourceStrings;

type
  { TTextReceipt }

  TTextReceipt = class(TCustomReceipt)
  private
    FTotal: Int64;
    FRecType: Integer;
    FIsVoided: Boolean;
    FPayments: TPayments;
    FItemsCount: Integer;
    FLastItemAmount: Int64;
    FIsReceiptOpened: Boolean;
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
      Quantity: Double; Amount: Currency; VatInfo: Integer);
    procedure PrintDiscount(const Description: string; Amount: Int64;
      VatInfo: Integer);
    procedure PrintCharge(const Description: string; Amount: Int64;
      VatInfo: Integer);
    procedure PrintItem(const PriceReg: TPriceReg);
    function GetVatText(VatInfo: Integer): string;
    procedure UpdateRecType;
    procedure PrintFiscalReceipt;
    procedure CheckDiscountAmount(Amount: Int64);
  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);

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

    procedure PrintNormal(const Text: string; Station: Integer); override;
  end;

implementation

{ TTextReceipt }

constructor TTextReceipt.CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
end;

function TTextReceipt.GetVatText(VatInfo: Integer): string;
begin
  Result := '';
  case VatInfo of
    1: Result := '_À';
    2: Result := '_Á';
    3: Result := '_Â';
    4: Result := '_Ã';
  end;
end;

function TTextReceipt.IsCashlessPayCode(PayCode: Integer): Boolean;
begin
  Result := PayCode in [1..3];
end;

function TTextReceipt.GetPayment: Int64;
begin
  Result := FPayments[0] + FPayments[1] + FPayments[2] + FPayments[3];
end;

function TTextReceipt.GetCashlessTotal: Int64;
begin
  Result := FPayments[1] + FPayments[2] + FPayments[3];
end;

procedure TTextReceipt.PrintRecVoid(const Description: string);
begin
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TTextReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
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

function TTextReceipt.IsSingleQuantity(Quantity: Integer): Boolean;
begin
  Result := Quantity = 1000;
end;

procedure TTextReceipt.PrintRecItem(
  const Description: string; Price: Currency;
  Quantity: Integer; VatInfo: Integer;
  UnitPrice: Currency; const UnitName: string);
var
  Amount: Currency;
  ItemPrice: Currency;
  ItemQuantity: Double;
begin
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
  Amount := RoundAmount(ItemQuantity * ItemPrice);
  PrintReceiptItem(Description, ItemPrice, ItemQuantity, Amount, VatInfo);
end;

procedure TTextReceipt.PrintReceiptItem(
  const Description: string; Price: Currency;
  Quantity: Double; Amount: Currency;
  VatInfo: Integer);
var
  Text: string;
begin
  OpenReceipt(FRecType);

  Inc(FItemsCount);
  FVatAmount[VatInfo] := FVatAmount[VatInfo] + Printer.CurrencyToInt(Amount);
  FTotal := FTotal + Printer.CurrencyToInt(Amount);
  FLastItemAmount := Abs(Printer.CurrencyToInt(Amount));

  if Quantity < 0 then
    Printer.PrintTextLine(PrinterItemVoidText);

  //Printer.PrintText(Description);
  Text := '';
  if Abs(Round2(Quantity*1000)) <> 1000 then
  begin
    Text := Format('%.2f X %.3f = %.2f%s', [
      Price, Abs(Quantity), Abs(Amount), GetVatText(VatInfo)]);
  end else
  begin
    Text := Format('= %.2f%s', [Abs(Amount), GetVatText(VatInfo)]);
  end;
  Printer.PrintLines(Description, Text);
end;

procedure TTextReceipt.PrintDiscount(const Description: string;
  Amount: Int64; VatInfo: Integer);
var
  Text: string;
begin
  CheckDiscountAmount(Amount);

  FDiscountAmount[VatInfo] := FDiscountAmount[VatInfo] + Amount;
  FTotal := FTotal - Amount;

  Text := Format('= %.2f%s', [Abs(Amount/100), GetVatText(VatInfo)]);
  Printer.PrintLines(PrinterDiscountText + ' ' + Description, Text);
end;

procedure TTextReceipt.PrintCharge(const Description: string;
  Amount: Int64; VatInfo: Integer);
var
  Text: string;
begin
  FChargeAmount[VatInfo] := FChargeAmount[VatInfo] + Amount;
  FTotal := FTotal + Amount;

  Text := Format('= %.2f%s', [Abs(Amount/100), GetVatText(VatInfo)]);
  Printer.PrintLines(PrinterChargeText + ' ' + Description, Text);
end;

procedure TTextReceipt.PrintRecItemAdjustment(
  AdjustmentType: Integer;
  const Description: string;
  Amount: Currency;
  VatInfo: Integer);
var
  ItemAmount: Int64;
begin
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
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TTextReceipt.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const Description, VatAdjustment: string);
begin
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

procedure TTextReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: string);
begin
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

procedure TTextReceipt.UpdateRecType;
begin
  if (FItemsCount = 0)and(FRecType = RecTypeSale) then
  begin
    FRecType := RecTypeRetSale;
  end;
end;

procedure TTextReceipt.PrintRecRefund(const Description: string;
  Amount: Currency; VatInfo: Integer);
begin
  CheckAmount(Amount);
  UpdateRecType;
  PrintReceiptItem(Description, Amount, 1, Amount, VatInfo);
end;

procedure TTextReceipt.PrintRecRefundVoid(
  const Description: string;
  Amount: Currency; VatInfo: Integer);
begin
  CheckAmount(Amount);

  PrintReceiptItem(Description, Amount, -1, -Amount, VatInfo);
end;

procedure TTextReceipt.PrintRecSubtotal(Amount: Currency);
begin
  CheckAmount(Amount);
  PrintPreLine;
  Printer.PrintCurrency(Parameters.SubtotalText, FTotal/100);
  PrintPostLine;
end;

procedure TTextReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: string; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment(Description, AdjustmentType, Amount);
end;

procedure TTextReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment('', AdjustmentType, -Amount);
end;

function TTextReceipt.GetTaxTotals(Amount: Int64): TTaxTotals;
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

procedure TTextReceipt.CheckDiscountAmount(Amount: Int64);
begin
  if Amount > FTotal then
    RaiseExtendedError(OPOS_EFPTR_NEGATIVE_TOTAL, MsgNegativeReceiptTotal);
end;

procedure TTextReceipt.SubtotalDiscount(const Description: WideString;
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

procedure TTextReceipt.SubtotalCharge(const Description: WideString;
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

procedure TTextReceipt.RecSubtotalAdjustment(const Description: WideString;
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

procedure TTextReceipt.PrintRecTotal(ATotal: Currency; Payment: Currency;
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
end;

procedure TTextReceipt.OpenReceipt(ARecType: Integer);
begin
  if not FIsReceiptOpened then
  begin
    Printer.OpenReceipt(ARecType);
    FIsReceiptOpened := True;
  end;
end;

procedure TTextReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
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
end;

procedure TTextReceipt.EndFiscalReceipt;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  if not FIsVoided then
  begin
    PrintFiscalReceipt;
  end;
  FIsReceiptOpened := False;
end;

procedure TTextReceipt.PrintFiscalReceipt;
var
  CloseParams: TCloseReceiptParams;
begin
  OpenReceipt(FRecType);
  PrintReceiptItems;

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

procedure TTextReceipt.PrintReceiptItems;
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

procedure TTextReceipt.PrintItem(const PriceReg: TPriceReg);
begin
  case FRecType of
    RecTypeSale    : Printer.Sale(PriceReg);
    RecTypeBuy     : Printer.Buy(PriceReg);
    RecTypeRetSale : Printer.RetSale(PriceReg);
    RecTypeRetBuy  : Printer.RetBuy(PriceReg);
  end;
end;

procedure TTextReceipt.PrintRecVoidItem(const Description: string;
  Amount: Currency; Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
var
  ItemPrice: Currency;
  ItemAmount: Currency;
  ItemQuantity: Double;
begin
  CheckAmount(Amount);
  CheckQuantity(Quantity);

  ItemQuantity := 1;
  if Quantity > 0 then
    ItemQuantity := Quantity/1000;

  ItemPrice := Amount;
  ItemAmount := ItemQuantity*ItemPrice;
  PrintReceiptItem(Description, ItemPrice, -ItemQuantity, -ItemAmount, VatInfo);
end;

procedure TTextReceipt.PrintRecItemVoid(const Description: string;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  ItemPrice: Currency;
  ItemQuantity: Double;
begin
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
  PrintReceiptItem(Description, ItemPrice, -ItemQuantity,
    -ItemPrice*ItemQuantity, VatInfo);
end;

procedure TTextReceipt.PrintRecItemRefund(const Description: string;
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
  PrintReceiptItem(Description, ItemPrice, ItemQuantity,
    ItemPrice*ItemQuantity, VatInfo);
end;

procedure TTextReceipt.PrintRecItemRefundVoid(
  const Description: string;
  Amount: Currency;
  Quantity, VatInfo: Integer;
  UnitAmount: Currency;
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
  PrintReceiptItem(Description, ItemPrice, -ItemQuantity,
    -ItemPrice*ItemQuantity, VatInfo);
end;

procedure TTextReceipt.PrintNormal(const Text: string; Station: Integer);
begin
  Printer.PrintText2(Text, Station, Parameters.FontNumber, taLeft);
end;

end.
