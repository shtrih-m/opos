unit CachedSalesReceipt;

interface

uses
  // This
  CustomReceipt, PrinterTypes, ByteUtils, OposFptr, OposException,
  Opos, PayType, ReceiptPrinter, FiscalPrinterState, ReceiptItem,
  PrinterParameters, MathUtils;

type
  { TCachedSalesReceipt }

  TCachedSalesReceipt = class(TCustomReceipt)
  private
    FRecType: Integer;
    FIsVoided: Boolean;
    FLastItemSumm: Int64;
    FPayments: TPayments;
    FItems: TReceiptItems;
    FVatAmount: TTaxTotals;
    FIsReceiptOpened: Boolean;

    procedure CheckTotal(Total: Currency);
    procedure SubtotalCharge(Summ: Int64; Description: WideString = '');
    procedure SubtotalDiscount(Summ: Int64; Description: WideString = '');
    procedure CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
    procedure RecSubtotalAdjustment(AdjustmentType: Integer; Amount: Currency;
      const Description: WideString = '');
    procedure PrintStorno(const Data: TPriceReg);
    procedure PrintCharge(const Data: TAmountOperation);
    procedure PrintDiscount(const Data: TAmountOperation);
    procedure PrintStornoItems;
    function GetAmount(const Data: TPriceReg): Int64;
  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
    destructor Destroy; override;

    function GetPaymentTotal: Int64; override;

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

    procedure PrintRecTotal(Total, Payment: Currency;
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
      const ADescription: string;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: string); override;

    procedure PrintRecItemRefundVoid(
      const ADescription: string;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: string); override;

    function GetCashlessTotal: Int64;
  end;

implementation

{ TCachedSalesReceipt }

constructor TCachedSalesReceipt.CreateReceipt(AContext: TReceiptContext;
  ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
  FItems := TReceiptItems.Create;
end;

destructor TCachedSalesReceipt.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TCachedSalesReceipt.PrintCharge(const Data: TAmountOperation);
begin
  Printer.ReceiptCharge(Data);
  FVatAmount[Data.Tax1] := FVatAmount[Data.Tax1] + Data.Amount;
  PrintStornoItems;
end;

procedure TCachedSalesReceipt.PrintDiscount(const Data: TAmountOperation);
begin
  Printer.ReceiptDiscount(Data);
  FVatAmount[Data.Tax1] := FVatAmount[Data.Tax1] - Data.Amount;
  PrintStornoItems;
end;

function TCachedSalesReceipt.GetAmount(const Data: TPriceReg): Int64;
begin
  Result := Round2(Data.Price * Data.Quantity /1000);
end;

procedure TCachedSalesReceipt.PrintStornoItems;
var
  Index: Integer;
  Data: TPriceReg;
  VatAmount: Int64;
  Item: TReceiptItem;
  SaleItem: TSaleReceiptItem;
begin
  Index := 0;
  while Index < FItems.Count do
  begin
    Item := FItems[Index];
    if Item is TSaleReceiptItem then
    begin
      SaleItem := Item as TSaleReceiptItem;
      Data := SaleItem.Data;
      Printer.Printer.PrintText(SaleItem.PreLine);
      VatAmount := GetAmount(Data);
      if VatAmount <= FVatAmount[Data.Tax1] then
      begin
        Printer.Storno(Data);
        FVatAmount[Data.Tax1] := FVatAmount[Data.Tax1] - VatAmount;
        Item.Free;
      end else
      begin
        Inc(Index);
      end;
      Printer.Printer.PrintText(SaleItem.PostLine);
    end else
    begin
      Inc(Index);
    end;
  end;
end;

procedure TCachedSalesReceipt.PrintStorno(const Data: TPriceReg);
var
  VatAmount: Integer;
  Item: TSaleReceiptItem;
begin
  VatAmount := GetAmount(Data);
  if (Data.Tax1 = 0)or(VatAmount <= FVatAmount[Data.Tax1]) then
  begin
    Printer.Storno(Data);
    if Data.Tax1 > 0 then
    begin
      FVatAmount[Data.Tax1] := FVatAmount[Data.Tax1] - VatAmount;
    end;
  end else
  begin
    Item := TSaleReceiptItem.Create(FItems);
    Item.Data := Data;
    Item.PreLine := Printer.Printer.PreLine;
    Item.PostLine := Printer.Printer.PostLine;
  end;
  FLastItemSumm := Abs(Round2(Data.Price * Data.Quantity/1000));
end;

function TCachedSalesReceipt.GetPaymentTotal: Int64;
begin
  Result := FPayments[0] + FPayments[1] + FPayments[2] + FPayments[3];
end;

function TCachedSalesReceipt.GetCashlessTotal: Int64;
begin
  Result := FPayments[1] + FPayments[2] + FPayments[3];
end;

procedure TCachedSalesReceipt.PrintRecVoid(const Description: string);
begin
  OpenReceipt(RecTypeSale);
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TCachedSalesReceipt.CheckTotal(Total: Currency);
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

procedure TCachedSalesReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
begin
  case AdjustmentType of

    FPTR_AT_AMOUNT_DISCOUNT,
    FPTR_AT_AMOUNT_SURCHARGE:
      CheckAmount(Amount);

    FPTR_AT_PERCENTAGE_DISCOUNT,
    FPTR_AT_PERCENTAGE_SURCHARGE:
      CheckPercents(Amount);

  else
    RaiseOposException(OPOS_E_ILLEGAL, 'Invalid AdjustmentType parameter value');
  end;
end;

procedure TCachedSalesReceipt.PrintRecItem(const Description: string; Price: Currency;
  Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  Operation: TPriceReg;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);
  CheckVatInfo(VatInfo);

  OpenReceipt(RecTypeSale);
  PrintPreLine;

  if UnitPrice = 0 then
  begin
    // If no price - use single quanity cost
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
    RecTypeSale    : Printer.Sale(Operation);
    RecTypeBuy     : Printer.Buy(Operation);
    RecTypeRetSale : Printer.RetSale(Operation);
    RecTypeRetBuy  : Printer.RetBuy(Operation);
  end;
  FVatAmount[Operation.Tax1] := FVatAmount[Operation.Tax1] + GetAmount(Operation);
  FLastItemSumm := Abs(Round2(Operation.Price*Operation.Quantity/1000));
  Printer.PrintPostLine;
end;

procedure TCachedSalesReceipt.PrintRecItemAdjustment(
  AdjustmentType: Integer;
  const Description: string;
  Amount: Currency;
  VatInfo: Integer);
var
  Operation: TAmountOperation;
begin
  CheckAdjAmount(AdjustmentType, Amount);
  CheckVatInfo(VatInfo);

  OpenReceipt(RecTypeSale);
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
      PrintCharge(Operation);
    end;
    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Operation.Amount := Abs(Round2(FLastItemSumm*Amount/100));
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
      Operation.Amount := Abs(Round2(FLastItemSumm*Amount/100));
      Operation.Tax1 := VatInfo;
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      PrintCharge(Operation);
    end;
  else
    RaiseOposException(OPOS_E_ILLEGAL, 'Invalid AdjustmentType parameter');
  end;
end;

procedure TCachedSalesReceipt.PrintRecPackageAdjustment(
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

procedure TCachedSalesReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: string);
begin
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

procedure TCachedSalesReceipt.PrintRecRefund(const Description: string;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckVatInfo(VatInfo);

  OpenReceipt(RecTypeRetSale);
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

  Printer.PrintPostLine;
end;

procedure TCachedSalesReceipt.PrintRecRefundVoid(
  const Description: string;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckVatInfo(VatInfo);

  Operation.Quantity := 1000;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  PrintStorno(Operation);
end;

procedure TCachedSalesReceipt.PrintRecSubtotal(Amount: Currency);
begin
  CheckAmount(Amount);
  CheckTotal(Amount);
  PrintPreLine;
  Printer.PrintSubtotal;
  PrintPostLine;
end;

procedure TCachedSalesReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: string; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  OpenReceipt(RecTypeSale);
  PrintPreLine;
  RecSubtotalAdjustment(AdjustmentType, Amount, Description);
  Printer.PrintPostLine;
end;

// Discount void consider to taxes turnover

procedure TCachedSalesReceipt.SubtotalDiscount(Summ: Int64; Description: WideString);
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
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      PrintDiscount(Operation);
    end;
  end;
end;

// Charge void consider to taxes turnover

procedure TCachedSalesReceipt.SubtotalCharge(Summ: Int64; Description: WideString);
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
      Operation.Text := Description;
      PrintCharge(Operation);
    end;
  end;
end;

procedure TCachedSalesReceipt.RecSubtotalAdjustment(AdjustmentType: Integer;
  Amount: Currency; const Description: WideString);
var
  Summ: Int64;
begin
  case AdjustmentType of

    FPTR_AT_AMOUNT_DISCOUNT:
    begin
      Summ := Round2(Amount*100);
      SubtotalDiscount(Summ, Description);
    end;

    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Summ := Round2(Amount*100);
      SubtotalCharge(Summ, Description);
    end;

    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Summ := Round2(Printer.GetSubtotal* Amount/100);
      SubtotalDiscount(Summ, Description);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Summ := Round2(Printer.GetSubtotal* Amount/100);
      SubtotalCharge(Summ, Description);
    end;
  else
    RaiseOposException(OPOS_E_ILLEGAL, 'Invalid AdjustmentType parameter value');
  end;
end;

procedure TCachedSalesReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment(AdjustmentType, Amount);
end;

procedure TCachedSalesReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: string);
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
  if not (PayCode in [0..3]) then
    raiseOposException(OPOS_E_ILLEGAL, 'Invalid payment code');

  //
  Subtotal := Printer.GetSubtotal;
  PayAmount := Printer.CurrencyToInt(Payment);
  FPayments[PayCode] := FPayments[PayCode] + PayAmount;
  if GetPaymentTotal > Subtotal then
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

procedure TCachedSalesReceipt.OpenReceipt(ARecType: Integer);
begin
  if not Device.IsRecOpened then
  begin
    Printer.OpenReceipt(ARecType);
    FIsReceiptOpened := True;
    PrintRecMessages;
  end;
end;

procedure TCachedSalesReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
var
  i: Integer;
begin
  inherited BeginFiscalReceipt(PrintHeader);
  FItems.Clear;
  FIsVoided := False;
  FLastItemSumm := 0;
  for i := 0 to 4 do
    FVatAmount[i] := 0;
end;

procedure TCachedSalesReceipt.EndFiscalReceipt;
var
  PriceReg: TPriceReg;
  CloseParams: TCloseReceiptParams;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);

  if FIsVoided then
  begin
    if Device.IsRecOpened then
    begin
      Printer.ReceiptCancel;
    end;
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
        RecTypeSale    : Printer.Sale(PriceReg);
        RecTypeBuy     : Printer.Buy(PriceReg);
        RecTypeRetSale : Printer.RetSale(PriceReg);
        RecTypeRetBuy  : Printer.RetBuy(PriceReg);
      end;
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

procedure TCachedSalesReceipt.PrintRecVoidItem(const Description: string;
  Amount: Currency; Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckQuantity(Quantity);
  CheckVatInfo(VatInfo);

  Operation.Quantity := Quantity;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Department := Parameters.Department;
  Operation.Tax1 := VatInfo;
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  PrintStorno(Operation);

end;

procedure TCachedSalesReceipt.PrintRecItemVoid(const Description: string;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  Operation: TPriceReg;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);
  CheckVatInfo(VatInfo);

  if UnitPrice = 0 then
  begin
    // If no price - use single quantity cost
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
  PrintStorno(Operation);
end;

procedure TCachedSalesReceipt.PrintRecItemRefund(const ADescription: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);
  CheckVatInfo(VatInfo);

  OpenReceipt(RecTypeRetSale);
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
end;

procedure TCachedSalesReceipt.PrintRecItemRefundVoid(const ADescription: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);
  CheckVatInfo(VatInfo);

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
  PrintStorno(Operation);
end;

end.
