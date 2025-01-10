unit SalesReceipt;

interface

uses
  // VCL
  SysUtils, Classes,
  // This
  CustomReceipt, PrinterTypes, ByteUtils, OposFptr, OposException,
  Opos, PayType, ReceiptPrinter, FiscalPrinterState,
  RecItem, RecDiscount, PrinterParameters, MathUtils;

type
  { TSalesReceipt }

  TSalesReceipt = class(TCustomReceipt)
  private
    FOpened: Boolean;
    FRecType: Integer;
    FIsVoided: Boolean;
    FLastItemSumm: Int64;
    FPayments: TPayments;
    FItems: TRecItems;
    FDiscounts: TRecDiscounts;
    FItemBarcodes: TStrings;

    function GetItemCount: Integer;
    function GetDiscountCount: Integer;

    procedure CheckTotal(Total: Currency);
    procedure SubtotalCharge(Summ: Int64);
    procedure SubtotalDiscount(Summ: Int64);
    procedure CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
    procedure RecSubtotalAdjustment(AdjustmentType: Integer; Amount: Currency);

    procedure PrintDiscount(Operation: TAmountOperation);
    function GetIsCashPayment: Boolean;
    procedure SendItemBarcode;
  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
    destructor Destroy; override;

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
    procedure AddItemCode(const Code: WideString); override;

    property IsVoided: Boolean read FIsVoided;
    property Items: TRecItems read FItems;
    property ItemCount: Integer read GetItemCount;
    property Discounts: TRecDiscounts read FDiscounts;
    property DiscountCount: Integer read GetDiscountCount;
    property IsCashPayment: Boolean read GetIsCashPayment;
  end;

implementation

{ TSalesReceipt }

constructor TSalesReceipt.CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
  FItems := TRecItems.Create;
  FDiscounts := TRecDiscounts.Create;
  FItemBarcodes := TStringList.Create;
end;

destructor TSalesReceipt.Destroy;
begin
  FItems.Free;
  FDiscounts.Free;
  FItemBarcodes.Free;
  inherited Destroy;
end;

function TSalesReceipt.GetPaymentTotal: Int64;
begin
  Result := FPayments[0] + FPayments[1] + FPayments[2] + FPayments[3];
end;

function TSalesReceipt.GetCashlessTotal: Int64;
begin
  Result := FPayments[1] + FPayments[2] + FPayments[3];
end;

function TSalesReceipt.GetIsCashPayment: Boolean;
begin
  Result := GetCashlessTotal = 0;
end;

procedure TSalesReceipt.PrintRecVoid(const Description: WideString);
begin
  OpenReceipt(RecTypeSale);
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TSalesReceipt.CheckTotal(Total: Currency);
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

procedure TSalesReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
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

procedure TSalesReceipt.PrintRecItem(const Description: WideString; Price: Currency;
  Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
  const UnitName: WideString);
var
  Operation: TPriceReg;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);
  OpenReceipt(RecTypeSale);

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
    Quantity := CorrectQuantity(Quantity);
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
  SendItemBarcode;
  PrintPostLine;
end;

procedure TSalesReceipt.SendItemBarcode;
var
  i: Integer;
  P: TFSBindItemCode;
  R: TFSBindItemCodeResult;
begin
  if Parameters.ModelID <> MODEL_ID_WEB_CASSA then Exit;

  if Parameters.Barcode <> '' then
  begin
    FItemBarcodes.Add(Parameters.Barcode);
    Parameters.Barcode := '';
  end;
  for i := 0 to FItemBarcodes.Count-1 do
  begin
    P.Code := FItemBarcodes[i];
    P.IsAccounted := False;
    Device.FSBindItemCode(P, R);
  end;
  FItemBarcodes.Clear;
end;

procedure TSalesReceipt.PrintRecItemAdjustment(
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

procedure TSalesReceipt.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const Description, VatAdjustment: WideString);
begin
  CheckDescription(Description);

  PrintPreLine;
  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT,
    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Printer.PrintLines(Description, VatAdjustment);
    end;
  else
    RaiseOposException(OPOS_E_ILLEGAL);
  end;
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: WideString);
begin
  PrintPreLine;
  CheckDescription(VatAdjustment);
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

procedure TSalesReceipt.PrintRecRefund(const Description: WideString;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
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
  FItems.Add(Operation);
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecRefundVoid(
  const Description: WideString;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckDescription(Description);
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
  Printer.Storno(Operation);
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecSubtotal(Amount: Currency);
begin
  CheckAmount(Amount);
  CheckTotal(Amount);
  PrintPreLine;
  Printer.PrintSubtotal;
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: WideString; Amount: Currency);
begin
  CheckDescription(Description);
  CheckAdjAmount(AdjustmentType, Amount);
  PrintPreLine;
  RecSubtotalAdjustment(AdjustmentType, Amount);
  PrintPostLine;
end;

// Discount void consider to taxes turnover

procedure TSalesReceipt.SubtotalDiscount(Summ: Int64);
var
  i: Integer;
  TaxTotals: TTaxTotals;
  Operation: TAmountOperation;
begin
  if Summ = 0 then Exit;
  TaxTotals := Printer.GetTaxTotals(Summ);
  for i := 0 to Length(TaxTotals)-1 do
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

procedure TSalesReceipt.SubtotalCharge(Summ: Int64);
var
  i: Integer;
  TaxTotals: TTaxTotals;
  Operation: TAmountOperation;
begin
  if Summ = 0 then Exit;
  TaxTotals := Printer.GetTaxTotals(Summ);
  for i := 0 to Length(TaxTotals)-1 do
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

procedure TSalesReceipt.RecSubtotalAdjustment(
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
      Summ := PercentDiscount(Printer.GetSubtotal, Amount);
      SubtotalDiscount(Summ);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Summ := PercentDiscount(Printer.GetSubtotal, Amount);
      SubtotalCharge(Summ);
    end;
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TSalesReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  PrintPreLine;
  RecSubtotalAdjustment(AdjustmentType, Amount);
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
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
  PrintPreLine;

  // Check payment code
  PayCode := Printer.GetPayCode(Description);
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
  PrintPostLine;
end;

procedure TSalesReceipt.CheckRececiptState;
begin
  if GetPaymentTotal >= Printer.GetSubtotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
end;

procedure TSalesReceipt.OpenReceipt(ARecType: Integer);
begin
  if not FOpened then
  begin
    if Device.CapFiscalStorage then
    begin
      if not Device.IsRecOpened then
        Printer.OpenReceipt(ARecType);
    end;
    FOpened := True;
  end;
end;

procedure TSalesReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  FOpened := False;
  FIsVoided := False;
  inherited BeginFiscalReceipt(PrintHeader);
end;

procedure TSalesReceipt.EndFiscalReceipt;
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
      SendItemBarcode;
    end;

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
end;

procedure TSalesReceipt.PrintRecVoidItem(const Description: WideString;
  Amount: Currency; Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckQuantity(Quantity);
  CheckDescription(Description);
  PrintPreLine;

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
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecItemVoid(const Description: WideString;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
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
    // If no price - use single quantity cost
    if Parameters.SingleQuantityOnZeroUnitPrice then
      Operation.Quantity := 1000;

    Operation.Price := Printer.CurrencyToInt(Price);
  end else
  begin
    Quantity := CorrectQuantity(Quantity);
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
  PrintPostLine;
end;

procedure TSalesReceipt.PrintRecItemRefund(const ADescription: WideString;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: WideString);
var
  Operation: TPriceReg;
begin
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);
  OpenReceipt(RecTypeRetSale);

  PrintPreLine;
  if (UnitAmount = 0)or(Quantity = 0) then
  begin
    // If no price - use single quantity cost
    Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Amount);
  end else
  begin
    Quantity := CorrectQuantity(Quantity);
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

procedure TSalesReceipt.PrintRecItemRefundVoid(const ADescription: WideString;
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
    Quantity := CorrectQuantity(Quantity);
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
  FLastItemSumm := -Round2(Operation.Price * Operation.Quantity/1000);
end;

function TSalesReceipt.GetDiscountCount: Integer;
begin
  Result := FDiscounts.Count;
end;

function TSalesReceipt.GetItemCount: Integer;
begin
  Result := FItems.Count;
end;

procedure TSalesReceipt.PrintDiscount(Operation: TAmountOperation);
begin
  Printer.ReceiptDiscount(Operation);
  FDiscounts.Add(Operation);
end;

procedure TSalesReceipt.PaymentAdjustment(Amount: Int64);
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

procedure TSalesReceipt.AddItemCode(const Code: WideString);
begin
  FItemBarcodes.Add(Code);
end;



end.
