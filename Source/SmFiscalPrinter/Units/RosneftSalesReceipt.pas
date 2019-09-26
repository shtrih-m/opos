unit RosneftSalesReceipt;

interface

uses
  // VCL
  SysUtils, 
  // This
  CustomReceipt, PrinterTypes, ByteUtils, OposFptr, OposException,
  Opos, PayType, ReceiptPrinter, FiscalPrinterState,
  RecItem, RecDiscount, PrinterParameters, RegExpr,
  MalinaParams, MathUtils;

type
  { TRosneftSalesReceipt }

  TRosneftSalesReceipt = class(TCustomReceipt)
  private
    function GetMalinaParams: TMalinaParams;
  private
    FOpened: Boolean;
    FRecType: Integer;
    FIsVoided: Boolean;
    FLastItemSumm: Int64;
    FPayments: TPayments;
    FItems: TRecItems;
    FDicountAmount: Int64;
    FDiscounts: TRecDiscounts;

    function GetItemCount: Integer;

    procedure PrintDiscounts;
    procedure CheckTotal(Total: Currency);
    procedure SubtotalCharge(Summ: Int64);
    procedure SubtotalDiscount(Summ: Int64);
    procedure CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
    procedure RecSubtotalAdjustment(AdjustmentType: Integer; Amount: Currency);

    procedure PrintDiscount(Operation: TAmountOperation);
    function GetIsCashPayment: Boolean;

    property Discounts: TRecDiscounts read FDiscounts;
    function GetReceiptSubtotal: Int64;
  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
    destructor Destroy; override;

    function IsLoyaltyCard(const Text: WideString): Boolean;

    procedure CheckRececiptState;
    procedure OpenReceipt(ARecType: Integer); override;

    procedure PrintRecVoid(const Description: WideString); override;

    procedure PrintRecItem(const Description: WideString; Price: Currency;
      Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
      const UnitName: WideString); override;

    procedure PrintRecItemAdjustment(AdjustmentType: Integer;
      const Description: WideString; Amount: Currency;
      VatInfo: Integer); override;

    procedure PrintRecPackageAdjustment(AdjustmentType: Integer;
      const Description, VatAdjustment: WideString); override;

    procedure PrintRecPackageAdjustVoid(AdjustmentType: Integer;
      const VatAdjustment: WideString); override;

    procedure PrintRecRefund(const Description: WideString; Amount: Currency;
      VatInfo: Integer); override;

    procedure PrintRecRefundVoid(const Description: WideString;
      Amount: Currency; VatInfo: Integer); override;

    procedure PrintRecSubtotal(Amount: Currency); override;

    procedure PrintRecSubtotalAdjustment(AdjustmentType: Integer;
      const Description: WideString; Amount: Currency); override;

    procedure PrintRecTotal(Total, Payment: Currency;
      const Description: WideString); override;

    procedure PrintRecVoidItem(const Description: WideString; Amount: Currency;
      Quantity: Integer; AdjustmentType: Integer; Adjustment: Currency;
      VatInfo: Integer);  override;

    procedure PrintRecItemVoid(const Description: WideString;
      Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
      const UnitName: WideString); override;

    procedure BeginFiscalReceipt(PrintHeader: Boolean); override;
    procedure EndFiscalReceipt;  override;

    procedure PrintRecSubtotalAdjustVoid(AdjustmentType: Integer;
      Amount: Currency); override;

    procedure PrintRecItemRefund(
      const ADescription: WideString;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: WideString); override;

    procedure PrintRecItemRefundVoid(
      const ADescription: WideString;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: WideString); override;

    function GetPaymentTotal: Int64; override;
    function GetCashlessTotal: Int64;
    procedure PaymentAdjustment(Amount: Int64); override;

    property IsVoided: Boolean read FIsVoided;
    property Items: TRecItems read FItems;
    property ItemCount: Integer read GetItemCount;
    property IsCashPayment: Boolean read GetIsCashPayment;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

implementation

{ TRosneftSalesReceipt }

constructor TRosneftSalesReceipt.CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
  FItems := TRecItems.Create;
  FDiscounts := TRecDiscounts.Create;
end;

destructor TRosneftSalesReceipt.Destroy;
begin
  FItems.Free;
  FDiscounts.Free;
  inherited Destroy;
end;

function TRosneftSalesReceipt.GetPaymentTotal: Int64;
begin
  Result := FPayments[0] + FPayments[1] + FPayments[2] + FPayments[3];
end;

function TRosneftSalesReceipt.GetCashlessTotal: Int64;
begin
  Result := FPayments[1] + FPayments[2] + FPayments[3];
end;

function TRosneftSalesReceipt.GetIsCashPayment: Boolean;
begin
  Result := GetCashlessTotal = 0;
end;

procedure TRosneftSalesReceipt.PrintRecVoid(const Description: WideString);
begin
  OpenReceipt(RecTypeSale);
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TRosneftSalesReceipt.CheckTotal(Total: Currency);
begin
  if Printer.Printer.CheckTotal then
  begin
    if Printer.GetSubtotal <> Total then
    begin
      Device.CancelReceipt;
      State.SetState(FPTR_PS_MONITOR);
    end else
    begin
      Printer.PrintCurrency(Parameters.SubtotalText, Total/100);
    end;
  end;
end;

procedure TRosneftSalesReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
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

procedure TRosneftSalesReceipt.PrintRecItem(const Description: WideString; Price: Currency;
  Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
  const UnitName: WideString);
var
  Operation: TPriceReg;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);
  PrintPreLine;

  Operation.Quantity := Quantity;
  if UnitPrice = 0 then
  begin
    // If no price - use single quanity cost
    if Parameters.SingleQuantityOnZeroUnitPrice then
      Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Price);
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    Operation.Quantity := Quantity;
    Operation.Price := Printer.CurrencyToInt(UnitPrice);
  end;

  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  case FRecType of
    RecTypeSale: Printer.Sale(Operation);
    RecTypeBuy: Printer.Buy(Operation);
    RecTypeRetSale: Printer.RetSale(Operation);
    RecTypeRetBuy: Printer.RetBuy(Operation);
  end;
  FItems.Add(Operation);
  FLastItemSumm := Round2(Operation.Price*Operation.Quantity/1000);
  PrintPostLine;
end;

procedure TRosneftSalesReceipt.PrintRecItemAdjustment(
  AdjustmentType: Integer;
  const Description: WideString;
  Amount: Currency;
  VatInfo: Integer);
var
  Operation: TAmountOperation;
begin
  CheckDescription(Description);
  CheckAdjAmount(AdjustmentType, Amount);
  PrintPreLine;

  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT:
    begin
      Operation.Amount := Printer.CurrencyToInt(Amount);
      Operation.Tax1 := VatInfo;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      PrintDiscount(Operation);
    end;

    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Operation.Amount := Printer.CurrencyToInt(Amount);
      Operation.Tax1 := VatInfo;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      Printer.ReceiptCharge(Operation);
    end;
    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Operation.Amount := PercentDiscount(FLastItemSumm, Amount);
      Operation.Tax1 := VatInfo;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      PrintDiscount(Operation);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Operation.Amount := PercentDiscount(FLastItemSumm, Amount);
      Operation.Tax1 := VatInfo;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      Printer.ReceiptCharge(Operation);
    end;
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
  PrintPostLine;
end;

procedure TRosneftSalesReceipt.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const Description, VatAdjustment: WideString);
begin
  CheckDescription(Description);

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

procedure TRosneftSalesReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: WideString);
begin
  CheckDescription(VatAdjustment);
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
  PrintPostLine;
end;

procedure TRosneftSalesReceipt.PrintRecRefund(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  PrintPreLine;

  Operation.Quantity := 1000;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  Printer.RetSale(Operation);
  FItems.Add(Operation);
  PrintPostLine;
end;

procedure TRosneftSalesReceipt.PrintRecRefundVoid(
  const Description: WideString;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckDescription(Description);
  CheckAmount(Amount);

  Operation.Quantity := 1000;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  Printer.Storno(Operation);
end;

procedure TRosneftSalesReceipt.PrintRecSubtotal(Amount: Currency);
begin
  CheckAmount(Amount);
  CheckTotal(Amount);
  PrintPreLine;
  Printer.PrintSubtotal;
  PrintPostLine;
end;

procedure TRosneftSalesReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: WideString; Amount: Currency);
begin
  CheckDescription(Description);
  CheckAdjAmount(AdjustmentType, Amount);

  PrintPreLine;
  RecSubtotalAdjustment(AdjustmentType, Amount);
  PrintPostLine;
end;

// Discount void consider to taxes turnover

procedure TRosneftSalesReceipt.SubtotalDiscount(Summ: Int64);
var
  i: Integer;
  TaxTotals: TTaxTotals;
  Operation: TAmountOperation;
begin
  if Summ = 0 then Exit;
  TaxTotals := Printer.GetTaxTotals(Summ);
  for i := 0 to 4 do
  begin
    if TaxTotals[i] <> 0 then
    begin
      Operation.Amount := TaxTotals[i];
      Operation.Tax1 := i;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := '';
      Operation.Department := Parameters.Department;
      PrintDiscount(Operation);
    end;
  end;
end;

// Charge void consider to taxes turnover

procedure TRosneftSalesReceipt.SubtotalCharge(Summ: Int64);
var
  i: Integer;
  TaxTotals: TTaxTotals;
  Operation: TAmountOperation;
begin
  if Summ = 0 then Exit;
  TaxTotals := Printer.GetTaxTotals(Summ);
  for i := 0 to 4 do
  begin
    if TaxTotals[i] <> 0 then
    begin
      Operation.Amount := TaxTotals[i];
      Operation.Department := Parameters.Department;
      Operation.Tax1 := i;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := '';
      Printer.ReceiptCharge(Operation);
    end;
  end;
end;

procedure TRosneftSalesReceipt.RecSubtotalAdjustment(
  AdjustmentType: Integer; Amount: Currency);
var
  Summ: Int64;
begin
  case AdjustmentType of

    FPTR_AT_AMOUNT_DISCOUNT:
    begin
      Summ := Printer.CurrencyToInt(Amount);
      SubtotalDiscount(Summ);
    end;

    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Summ := Printer.CurrencyToInt(Amount);
      SubtotalCharge(Summ);
    end;

    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Summ := PercentDiscount(GetReceiptSubtotal, Amount);
      SubtotalDiscount(Summ);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Summ := PercentDiscount(GetReceiptSubtotal, Amount);
      SubtotalCharge(Summ);
    end;
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TRosneftSalesReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment(AdjustmentType, Amount);
end;

function TRosneftSalesReceipt.GetReceiptSubtotal: Int64;
begin
  Result := Printer.GetSubtotal - FDicountAmount;
end;

procedure TRosneftSalesReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: WideString);
var
  Subtotal: Int64;
  PayCode: Integer;
  PayAmount: Int64;
  DiffAmount: Int64;
begin
  // Check parameters
  CheckAmount(Total);
  CheckAmount(Payment);
  CheckTotal(Total);

  // Check payment code
  PayCode := Printer.GetPayCode(Description);
  PrintDiscounts;
  //
  Subtotal := Printer.GetSubtotal;
  PayAmount := Printer.CurrencyToInt(Payment);
  FPayments[PayCode] := FPayments[PayCode] + PayAmount;
  if Parameters.CorrectCashlessAmount and (GetPaymentTotal > Subtotal) then
  begin
    DiffAmount := Abs(GetPaymentTotal - Subtotal);
    if FPayments[0] < DiffAmount then
    begin
      FPayments[PayCode] := FPayments[PayCode] - DiffAmount;
    end;
  end;


  if GetPaymentTotal >= Subtotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
  Printer.PrintPostLine;
end;

procedure TRosneftSalesReceipt.CheckRececiptState;
begin
  if GetPaymentTotal >= GetReceiptSubtotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
end;

procedure TRosneftSalesReceipt.OpenReceipt(ARecType: Integer);
begin
  if not FOpened then
  begin
    if Device.CapOpenReceipt then
    begin
      if not Device.IsRecOpened then
        Printer.OpenReceipt(ARecType);
    end;
    FOpened := True;
  end;
end;

procedure TRosneftSalesReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  FOpened := False;
  FIsVoided := False;
  FDicountAmount := 0;
  FDiscounts.Clear;
  FLastItemSumm := 0;
  FItems.Clear;
  FDicountAmount := 0;
end;

(*
Вид оригинального чека представлен на рис. 1.
Вид модифицированного чека представлен на рис. 2.
Требуется:
убрать информацию по разбивке скидки на каждую позиции в чеке, см. выделенные строки желтым на рис. 1.
Добавить строку с номером карты, см. выделенное желтым на рис. 2, где:
«КАРТА КОМАНДА» - текст-константа;
«700599######0040» - номер карты, в котором
«7005» - префикс-константа;
«99» - 7-й и 8-й символы из номера карты в строке «3% Loyalty 000302992000000040» оригинального чека (см. рис.1);
«######» - символы маскирования;
«0040» - последние 4 символа из номера карты в строке «3% Loyalty 000302992000000040» оригинального чека (см. рис.1).
Изменить сумму в строке «ПОДИТОГ» на сумму чека в рублях без учета скидки (в примере: 95.00+37.90+49.90+199.82=382.62);
Указать информацию по общей скидке на чек в рублях (в примере: 2.85+1.14+1.50+5.98=11.47).

*)

procedure TRosneftSalesReceipt.PrintDiscounts;
var
  i: Integer;
  Item: TRecDiscount;
  Items: TRecDiscounts;
  Data: TAmountOperation;
begin
  Items := TRecDiscounts.Create;
  try
    // Collapse
    for i := 0 to Discounts.Count-1 do
    begin
      Data := FDiscounts[i].Data;
      Item := Items.ItemByTax1(Data.Tax1);
      if Item = nil then
      begin
        Items.Add(Data);
      end else
      begin
        Item.Amount := Item.Amount + Data.Amount;
      end;
    end;
    // Print
    for i := 0 to Items.Count-1 do
    begin
      Data := Items[i].Data;
      Data.Text := ReplaceRegExpr(GetMalinaParams.RosneftCardMask, Data.Text, GetMalinaParams.RosneftCardName);
      Printer.ReceiptDiscount(Data);
    end;
    FDiscounts.Clear;
  finally
    Items.Free;
  end;
end;

procedure TRosneftSalesReceipt.EndFiscalReceipt;
var
  PriceReg: TPriceReg;
  CloseParams: TCloseReceiptParams;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);

  if FIsVoided then
  begin
    Device.CancelReceipt;
  end else
  begin
    // If receipt is not opened then open
    if not Device.IsRecOpened then
    begin
      OpenReceipt(FRecType);

      PriceReg.Quantity := 0;
      PriceReg.Price := 0;
      PriceReg.Department := 1;
      PriceReg.Tax1 := 0;
      PriceReg.Tax2 := 0;
      PriceReg.Tax3 := 0;
      PriceReg.Tax4 := 0;
      PriceReg.Text := '';
      case FRecType of
        RecTypeSale: Printer.Sale(PriceReg);
        RecTypeBuy     : Printer.Buy(PriceReg);
        RecTypeRetSale : Printer.RetSale(PriceReg);
        RecTypeRetBuy  : Printer.RetBuy(PriceReg);
      end;
      FItems.Add(PriceReg);
    end;

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
end;

procedure TRosneftSalesReceipt.PrintRecVoidItem(const Description: WideString;
  Amount: Currency; Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckQuantity(Quantity);
  CheckDescription(Description);

  Operation.Quantity := Quantity;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Department := Parameters.Department;
  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  Printer.Storno(Operation);
end;

procedure TRosneftSalesReceipt.PrintRecItemVoid(const Description: WideString;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: WideString);
var
  Operation: TPriceReg;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);

  Operation.Quantity := Quantity;
  if UnitPrice = 0 then
  begin
    // If no price - use single quantity cost
    if Parameters.SingleQuantityOnZeroUnitPrice then
      Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Price);
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    Operation.Quantity := Quantity;
    Operation.Price := Printer.CurrencyToInt(UnitPrice);
  end;

  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  Printer.Storno(Operation);
  FLastItemSumm := -Round2(Operation.Price*Operation.Quantity/1000);
end;

procedure TRosneftSalesReceipt.PrintRecItemRefund(const ADescription: WideString;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: WideString);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);

  OpenReceipt(FRecType);
  PrintPreLine;

  if (UnitAmount = 0)or(Quantity = 0) then
  begin
    // If no price - use single quantity cost
    Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Amount);
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    Operation.Quantity := Quantity;
    Operation.Price := Printer.CurrencyToInt(UnitAmount);
  end;

  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := ADescription;
  Operation.Department := Parameters.Department;
  Printer.RetSale(Operation);
  FItems.Add(Operation);
  PrintPostLine;
end;

procedure TRosneftSalesReceipt.PrintRecItemRefundVoid(const ADescription: WideString;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: WideString);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);

  if (UnitAmount = 0)or(Quantity = 0) then
  begin
    // If no price - use single quantity cost
    Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Amount);
  end else
  begin
    if Quantity = 0 then Quantity := 1000;
    Operation.Quantity := Quantity;
    Operation.Price := Printer.CurrencyToInt(UnitAmount);
  end;

  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := ADescription;
  Operation.Department := Parameters.Department;
  Printer.Storno(Operation);
  FLastItemSumm := -Round2(Operation.Price*Operation.Quantity/1000);
end;

function TRosneftSalesReceipt.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

function TRosneftSalesReceipt.IsLoyaltyCard(const Text: WideString): Boolean;
begin
  Result := ExecRegExpr(GetMalinaParams.RosneftCardMask, Text);
end;

procedure TRosneftSalesReceipt.PrintDiscount(Operation: TAmountOperation);
begin
  if IsLoyaltyCard(OPeration.Text) then
  begin
    Discounts.Add(Operation);
    FDicountAmount := FDicountAmount + Operation.Amount;
  end else
  begin
    Printer.ReceiptDiscount(Operation);
  end;
end;

procedure TRosneftSalesReceipt.PaymentAdjustment(Amount: Int64);
var
  i: Integer;
begin
  for i := Low(FPayments) to High(FPayments) do
  begin
    if FPayments[i] >= Amount then
    begin
      FPayments[i] :=  FPayments[i] - Amount;
      Break;
    end;
  end;
end;

function TRosneftSalesReceipt.GetMalinaParams: TMalinaParams;
begin
  Result := Device.Context.MalinaParams;
end;

end.
