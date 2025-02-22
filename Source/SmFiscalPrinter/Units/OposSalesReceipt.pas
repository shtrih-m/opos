unit OposSalesReceipt;

interface

uses
  // VCL
  SysUtils,
  // This
  Opos, OposFptr, OposException, CustomReceipt, PrinterTypes, ReceiptItem,
  RegExpr, StringUtils, SmResourceStrings, MathUtils, PrinterParameters;

type
  { TOposSalesReceipt }

  TOposSalesReceipt = class(TCustomReceipt)
  private
    FOpened: Boolean;
    FRecType: Integer;
    FIsVoided: Boolean;
    FPayments: TPayments;
    FLastItem: TFSSaleItem;
    FDiscounts: TReceiptItems;
    FHasReceiptItems: Boolean;
    FReceiptItems: TReceiptItems;
    FRecDiscount: TDiscountReceiptItem;
    FAdjustmentAmount: Integer;

    function GetIsCashPayment: Boolean;
    function IsCashlessPayCode(PayCode: Integer): Boolean;

    procedure CheckTotal(Total: Currency);
    procedure AddItemDiscount(Discount: TAmountOperation);
    procedure RecSubtotalAdjustment(const Description: string;
      AdjustmentType: Integer; Amount: Currency);
    procedure CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
    procedure SubtotalDiscount(Amount: Int64; const Description: string);

    procedure ClearReceipt;
    procedure SetRefundReceipt;
    procedure UpdateReceiptItems;
    procedure AddSale(const P: TFSSale);
    function IsLoyaltyCard(const Text: string): Boolean;
    procedure PrintDiscounts;
    function GetTax(const ItemName: string; Tax: Integer): Integer;
    function GetCapReceiptDiscount2: Boolean;
    procedure PrintText2(const Text: string);
    procedure AddTextItem(const Text: string; Station: Integer);
    procedure ParseReceiptItemsLines(Items: TReceiptItems);
    procedure ParseReceiptItemsLines2(Items: TReceiptItems);
    procedure printReceiptItemAsText(Item: TFSSaleItem);
    procedure PrintTotalAndTax(const Item: TFSSaleItem);

    procedure PrintDiscount(Discount: TAmountOperation);

    function GetAdjustmentAmount(AdjustmentType: Integer;
      Amount: Currency): Int64;
    function GetLastItem: TFSSaleItem;

  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
    destructor Destroy; override;

    function GetTotal: Int64; override;

    procedure CheckRececiptState;
    procedure OpenReceipt(ARecType: Integer); override;
    procedure SetAdjustmentAmount(Amount: Integer); override;

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

    function GetPaymentTotal: Int64; override;
    function GetCashlessTotal: Int64;
    procedure PaymentAdjustment(Amount: Int64); override;

    procedure PrintNormal(const Text: string; Station: Integer); override;

    procedure PrintRecMessage(const Message: string); override;
    procedure PrintText(const Data: TTextRec); override;
    procedure PrintBarcode(const Barcode: TBarcodeRec); override;
    procedure FSWriteTLV(const TLVData: string); override;

    property IsVoided: Boolean read FIsVoided;
    property IsCashPayment: Boolean read GetIsCashPayment;
    property ReceiptItems: TReceiptItems read FReceiptItems;
  end;

implementation

// Parse price and quantity

function ParsePrice(const Line: string;
  var Price, Quantity: Double): Boolean;
var
  S: string;
  R: TRegExpr;
begin
  R := TRegExpr.Create;
  try
    R.Expression := '[0-9]+[.,][0-9 ]+[X*][0-9 ]+[.,][0-9]+';
    Result := R.Exec(Line);
    if not Result then Exit;

    S := Trim(R.Match[0]);
    R.Expression := '[0-9]+[.,][0-9]+';
    Result := R.Exec(S);
    if not Result then Exit;


    Quantity := StrToDouble(R.Match[0]);
    Result := R.ExecNext;
    if not Result then Exit;

    Price := StrToDouble(R.Match[0]);
  finally
    R.Free;
  end;
end;

{ TOposSalesReceipt }

constructor TOposSalesReceipt.CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
  FDiscounts := TReceiptItems.Create;
  FReceiptItems := TReceiptItems.Create;
  ClearReceipt;
end;

destructor TOposSalesReceipt.Destroy;
begin
  FDiscounts.Free;
  FReceiptItems.Free;
  inherited Destroy;
end;

function TOposSalesReceipt.GetTax(const ItemName: string; Tax: Integer): Integer;
begin
  Result := Tax;
  {$IFDEF MALINA}
   end;
    Result := FRetalix.ReadTaxGroup(ItemName);
    if Result = -1 then
      Result := Tax;
  end;
  {$ENDIF}
  Result := Parameters.GetVatInfo(Result);
  if not (Result in [0..6]) then Result := 0;
end;

procedure TOposSalesReceipt.PrintText2(const Text: string);
begin
  Printer.Printer.PrintText(Text);
end;

procedure TOposSalesReceipt.AddSale(const P: TFSSale);
begin
  FLastItem := TFSSaleItem.Create(FReceiptItems);
  FLastItem.Data := P;
  FLastItem.PreLine := Printer.Printer.PreLine;
  FLastItem.PostLine := Printer.Printer.PostLine;
  Printer.Printer.PreLine := '';
  Printer.Printer.PostLine := '';
  FHasReceiptItems := True;
end;

function TOposSalesReceipt.GetLastItem: TFSSaleItem;
begin
  if FLastItem = nil then
    raiseException(MsgLastReceiptItemNotDefined);
  Result := FLastItem;
end;

procedure TOposSalesReceipt.AddItemDiscount(Discount: TAmountOperation);
var
  ItemAmount: Int64;
  DiscountAmount: Int64;
  Item: TDiscountReceiptItem;
begin
  if IsLoyaltyCard(Discount.Text) then
  begin
    Discount.Text := ReplaceRegExpr(GetMalinaParams.RosneftCardMask,
      Discount.Text, GetMalinaParams.RosneftCardName);
    if FRecDiscount = nil then
    begin
      Item := TDiscountReceiptItem.Create(FReceiptItems);
      Item.PreLine := Printer.Printer.PreLine;
      Item.PostLine := Printer.Printer.PostLine;
      Item.Data := Discount;
      FRecDiscount := Item;
    end else
    begin
      FRecDiscount.Data.Amount := FRecDiscount.Data.Amount + Discount.Amount;
    end;
    Printer.Printer.PreLine := '';
    Printer.Printer.PostLine := '';
    Exit;
  end else
  begin
    Item := TDiscountReceiptItem.Create(GetLastItem.Discounts);
    Item.PreLine := Printer.Printer.PreLine;
    Item.PostLine := Printer.Printer.PostLine;
    Item.Data := Discount;
  end;

  if Discount.Amount > 0 then
  begin
    ItemAmount := Round2(GetLastItem.Quantity/1000 * GetLastItem.Price);
    DiscountAmount := GetLastItem.Discount + Abs(Discount.Amount);
    if DiscountAmount > (ItemAmount + GetLastItem.Charge) then
      raiseException(MsgDiscountAmountMoreItemAmount);
    GetLastItem.Discount := GetLastItem.Discount + Abs(Discount.Amount);
  end else
  begin
    GetLastItem.Charge := GetLastItem.Charge + Abs(Discount.Amount);
  end;
  if GetLastItem.AdjText = '' then
    GetLastItem.AdjText := Discount.Text
  else
    GetLastItem.AdjText := '';
end;

function TOposSalesReceipt.IsCashlessPayCode(PayCode: Integer): Boolean;
begin
  Result := PayCode in [1..15];
end;

function TOposSalesReceipt.GetPaymentTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := Low(FPayments) to High(FPayments) do
  begin
    Result := Result + FPayments[i];
  end;
end;

function TOposSalesReceipt.GetCashlessTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := (Low(FPayments)+1) to High(FPayments) do
  begin
    Result := Result + FPayments[i];
  end;
end;

function TOposSalesReceipt.GetIsCashPayment: Boolean;
begin
  Result := GetCashlessTotal = 0;
end;

procedure TOposSalesReceipt.PrintRecVoid(const Description: string);
begin
  OpenReceipt(RecTypeSale);
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TOposSalesReceipt.CheckTotal(Total: Currency);
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

procedure TOposSalesReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
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

procedure TOposSalesReceipt.PrintRecItem(const Description: string; Price: Currency;
  Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  Operation: TFSSale;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);

(*
  !!!
  if Parameters.QuantityDecimalPlaces = QuantityDecimalPlaces3 then
    Operation.Quantity := Quantity/1000
  else
    Operation.Quantity := Quantity/1000000;
*)

  if UnitPrice = 0 then
  begin
    // If no price - use single quanity cost
    if Price <> 0  then Operation.Quantity := 1;
    Operation.Price := Printer.CurrencyToInt(Price);
  end else
  begin
    if Quantity = 0 then Operation.Quantity := 1;
    Operation.Price := Printer.CurrencyToInt(UnitPrice);
  end;
  Operation.Tax := VatInfo;
  Operation.Text := Description;
  Operation.UnitName := UnitName;
  Operation.RecType := FRecType;
  Operation.Department := Parameters.Department;
  Operation.Charge := 0;
  Operation.Discount := 0;
  Operation.Barcode := 0;
  Operation.AdjText := '';
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.PrintRecItemAdjustment(
  AdjustmentType: Integer;
  const Description: string;
  Amount: Currency;
  VatInfo: Integer);
var
  Operation: TAmountOperation;
begin
  CheckDescription(Description);
  CheckAdjAmount(AdjustmentType, Amount);

  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT:
    begin
      Operation.Amount := Printer.CurrencyToInt(Amount);
      Operation.Tax1 := GetTax(Description, VatInfo);
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      AddItemDiscount(Operation);
    end;

    FPTR_AT_AMOUNT_SURCHARGE:
    begin
      Operation.Amount := -Printer.CurrencyToInt(Amount);
      Operation.Tax1 := GetTax(Description, VatInfo);
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      AddItemDiscount(Operation);
    end;
    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Operation.Amount := Round2(GetLastItem.GetAmount * Amount/100);
      Operation.Tax1 := GetTax(Description, VatInfo);
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      AddItemDiscount(Operation);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Operation.Amount := -Round2(GetLastItem.GetAmount * Amount/100);
      Operation.Tax1 := GetTax(Description, VatInfo);
      Operation.Tax2 := 0;
      Operation.Tax3 := 0;
      Operation.Tax4 := 0;
      Operation.Text := Description;
      Operation.Department := Parameters.Department;
      AddItemDiscount(Operation);
    end;
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TOposSalesReceipt.PrintRecPackageAdjustment(
  AdjustmentType: Integer;
  const Description, VatAdjustment: string);
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

procedure TOposSalesReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: string);
begin
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
end;

procedure TOposSalesReceipt.PrintRecRefund(const Description: string;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TFSSale;
begin
  SetRefundReceipt;
  CheckAmount(Amount);

  Operation.Quantity := 1;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Tax := VatInfo;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  Operation.RecType := FRecType;
  Operation.Charge := 0;
  Operation.Discount := 0;
  Operation.Barcode := 0;
  Operation.AdjText := '';
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.PrintRecRefundVoid(
  const Description: string;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TFSSale;
begin
  SetRefundReceipt;
  CheckDescription(Description);
  CheckAmount(Amount);

  Operation.Quantity := -1;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Tax := VatInfo;
  Operation.Text := Description;
  Operation.Department := Parameters.Department;
  Operation.RecType := FRecType;
  Operation.Charge := 0;
  Operation.Discount := 0;
  Operation.Barcode := 0;
  Operation.AdjText := '';
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.PrintRecSubtotal(Amount: Currency);
var
  Text: string;
begin
  Text := Printer.CurrencyToStr(GetTotal/100);
  Text := Printer.Printer.Device.FormatLines(Parameters.SubtotalText, '=' + Text);
  PrintNormal(Text, PRINTER_STATION_REC);
end;

procedure TOposSalesReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: string; Amount: Currency);
begin
  CheckDescription(Description);
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment(Description, AdjustmentType, Amount);
end;

// Discount void consider to taxes turnover

procedure TOposSalesReceipt.SubtotalDiscount(Amount: Int64; const Description: string);
var
  Item: TDiscountReceiptItem;
begin
  Item := TDiscountReceiptItem.Create(FDiscounts);
  Item.PreLine := Printer.Printer.PreLine;
  Item.PostLine := Printer.Printer.PostLine;
  Item.Data.Amount := Amount;
  Item.Data.Department := Parameters.Department;
  Item.Data.Tax1 := GetTax(Description, 0);
  Item.Data.Tax2 := 0;
  Item.Data.Tax3 := 0;
  Item.Data.Tax4 := 0;
  Item.Data.Text := Description;

  Printer.Printer.PreLine := '';
  Printer.Printer.PostLine := '';
end;

function TOposSalesReceipt.GetTotal: Int64;
begin
  Result := FReceiptItems.GetTotal - FDiscounts.GetTotal;
end;

function TOposSalesReceipt.GetAdjustmentAmount(
 AdjustmentType: Integer; Amount: Currency): Int64;
begin
  Result := 0;
  case AdjustmentType of
    FPTR_AT_AMOUNT_DISCOUNT: Result := Round2(Amount*100);
    FPTR_AT_AMOUNT_SURCHARGE: Result := -Round2(Amount*100);
    FPTR_AT_PERCENTAGE_DISCOUNT: Result := Round2(FReceiptItems.GetTotal * Amount/100);
    FPTR_AT_PERCENTAGE_SURCHARGE: Result := -Round2(FReceiptItems.GetTotal * Amount/100);
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TOposSalesReceipt.RecSubtotalAdjustment(const Description: string;
  AdjustmentType: Integer; Amount: Currency);
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
      SubtotalDiscount(-Summ, Description);
    end;

    FPTR_AT_PERCENTAGE_DISCOUNT:
    begin
      Summ := Round2(FReceiptItems.GetTotal * Amount/100);
      SubtotalDiscount(Summ, Description);
    end;

    FPTR_AT_PERCENTAGE_SURCHARGE:
    begin
      Summ := Round2(FReceiptItems.GetTotal * Amount/100);
      SubtotalDiscount(-Summ, Description);
    end;
  else
    InvalidParameterValue('AdjustmentType', IntToStr(AdjustmentType));
  end;
end;

procedure TOposSalesReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment('', AdjustmentType, Amount);
end;

procedure TOposSalesReceipt.ParseReceiptItemsLines(Items: TReceiptItems);
var
  i: Integer;
  Item: TFSSaleItem;
  Price, Quantity: Double;
  ReceiptItem: TReceiptItem;
  ParsedText: Boolean;
  ParsedPreLine: Boolean;
  ParsedPostLine: Boolean;
begin
  for i := 0 to Items.Count-1 do
  begin
    ReceiptItem := Items[i];
    if ReceiptItem is TFSSaleItem then
    begin
      Item := ReceiptItem as TFSSaleItem;

      ParsedText := ParsePrice(Item.Text, Price, Quantity);
      ParsedPreLine := ParsePrice(Item.PreLine, Price, Quantity);
      ParsedPostLine := ParsePrice(Item.PostLine, Price, Quantity);

      if ParsedText or ParsedPreLine or ParsedPostLine then
      begin
        Item.Data.Price := Round2(Price * 100);
        Item.Data.Quantity := Round2(Quantity * 1000);
      end;
      if ParsedText then
      begin
        Item.Text := Item.PreLine;
        Item.PreLine := '';
      end;
      if ParsedPreLine then Item.PreLine := '';
      if ParsedPostLine then Item.PostLine := '';
    end;
  end;
end;

procedure TOposSalesReceipt.ParseReceiptItemsLines2(Items: TReceiptItems);
var
  i: Integer;
  Item: TFSSaleItem;
  Price, Quantity: Double;
  ReceiptItem: TReceiptItem;
  ParsedPreLine: Boolean;
  ParsedPostLine: Boolean;
begin
  for i := 0 to Items.Count-1 do
  begin
    ReceiptItem := Items[i];
    if ReceiptItem is TFSSaleItem then
    begin
      Item := ReceiptItem as TFSSaleItem;

      ParsedPreLine := ParsePrice(Item.PreLine, Price, Quantity);
      if not ParsedPreLine then
      begin
        ParsedPostLine := ParsePrice(Item.PostLine, Price, Quantity);
        if ParsedPostLine then
        begin
          Item.PreLine := Item.PostLine;
          Item.PostLine := '';
        end;
      end else
      begin
        ParsedPostLine := ParsePrice(Item.PostLine, Price, Quantity);
        if ParsedPostLine then
        begin
          Item.PostLine := '';
        end;
      end;
    end;
  end;
end;

procedure TOposSalesReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: string);
var
  Subtotal: Int64;
  PayCode: Integer;
  PayAmount: Int64;
  Items2: TReceiptItems;
begin
  // Check parameters
  CheckAmount(Total);
  CheckAmount(Payment);
  CheckTotal(Total);

  // Check payment code
  PayCode := Printer.GetPayCode(Description);
  Subtotal := GetTotal;
  PayAmount := Printer.CurrencyToInt(Payment);
  if IsCashlessPayCode(PayCode) and ((PayAmount + GetPaymentTotal) > Subtotal) then
    PayAmount := Subtotal - GetPaymentTotal;

  FPayments[PayCode] := FPayments[PayCode] + PayAmount;

  if GetMalinaParams.RosneftDryReceiptEnabled then
  begin
    Items2 := TReceiptItems.Create;
    try
      Items2.Assign(FReceiptItems);
      ParseReceiptItemsLines(Items2);
      if GetPaymentTotal >= (Items2.GetTotal-FAdjustmentAmount) then
      begin
        ParseReceiptItemsLines(FReceiptItems);
        State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
      end else
      begin
        if GetPaymentTotal >= (FReceiptItems.GetTotal-FAdjustmentAmount) then
        begin
          ParseReceiptItemsLines2(FReceiptItems);
          State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
        end else
        begin
          State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
        end;
      end;
    finally
      Items2.Free;
    end;
  end else
  begin
    if GetPaymentTotal >= GetTotal then
    begin
      ParseReceiptItemsLines(FReceiptItems);
      State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
    end else
    begin
      State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
    end;
  end;
end;

procedure TOposSalesReceipt.CheckRececiptState;
begin
  if GetPaymentTotal >= GetTotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
end;

procedure TOposSalesReceipt.OpenReceipt(ARecType: Integer);
begin
  Logger.Debug('TOposSalesReceipt.OpenReceipt');

  if not FOpened then
  begin
    if Device.CapOpenReceipt then
    begin
      if not Device.IsRecOpened then
      begin
        Device.Check(Device.OpenReceipt(ARecType));
      end;
    end;
    FOpened := True;
  end;
end;

procedure TOposSalesReceipt.ClearReceipt;
var
  i: Integer;
begin
  FOpened := False;
  FIsVoided := False;
  FReceiptItems.Clear;
  FPrintEnabled := True;
  FLastItem := nil;
  FHasReceiptItems := False;
  FRecDiscount := nil;
  Printer.Printer.PreLine := '';
  Printer.Printer.PostLine := '';
  for i := Low(FPayments) to High(FPayments) do
    FPayments[i] := 0;
  FAdjustmentAmount := 0;
  ClearRecMessages;

  Parameters.Parameter1 := '';
  Parameters.Parameter2 := '';
  Parameters.Parameter3 := '';
  Parameters.Parameter4 := '';
  Parameters.Parameter5 := '';
  Parameters.Parameter6 := '';
  Parameters.Parameter7 := '';
  Parameters.Parameter8 := '';
  Parameters.Parameter9 := '';
  Parameters.Parameter10 := '';
end;

procedure TOposSalesReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  ClearReceipt;
  if Parameters.OpenReceiptEnabled then
  begin
    OpenReceipt(FRecType);
  end;
end;

(*
��� ������������� ���� ����������� �� ���. 1.
��� ����������������� ���� ����������� �� ���. 2.
���������:
������ ���������� �� �������� ������ �� ������ ������� � ����, ��. ���������� ������ ������ �� ���. 1.
�������� ������ � ������� �����, ��. ���������� ������ �� ���. 2, ���:
������ �������� - �����-���������;
�700599######0040� - ����� �����, � �������
�7005� - �������-���������;
�99� - 7-� � 8-� ������� �� ������ ����� � ������ �3% Loyalty 000302992000000040� ������������� ���� (��. ���.1);
�######� - ������� ������������;
�0040� - ��������� 4 ������� �� ������ ����� � ������ �3% Loyalty 000302992000000040� ������������� ���� (��. ���.1).
�������� ����� � ������ �������û �� ����� ���� � ������ ��� ����� ������ (� �������: 95.00+37.90+49.90+199.82=382.62);
������� ���������� �� ����� ������ �� ��� � ������ (� �������: 2.85+1.14+1.50+5.98=11.47).

*)

function GetTaxLetter(Tax: Integer): string;
const
  TaxLetter = '����';
begin
  Result := '';
  if Tax in [1..4] then
    Result := TaxLetter[Tax];
  if Result <> '' then
    Result := '_' + Result;
end;

procedure TOposSalesReceipt.UpdateReceiptItems;
var
  i: Integer;
  ItemNumber: Integer;
  FSSaleItem: TFSSaleItem;
  SplittedItem: TFSSaleItem;
  ReceiptItem: TReceiptItem;
begin
  for i := 0 to FReceiptItems.Count-1 do
  begin
    ReceiptItem := ReceiptItems[i];
    if ReceiptItem is TFSSaleItem then
    begin
      FSSaleItem := ReceiptItem as TFSSaleItem;
      FSSaleItem.UpdatePrice;
      SplittedItem := FSSaleItem.SplittedItem;
      if SplittedItem <> nil then
      begin
        FReceiptItems.Insert(i+1, SplittedItem);
      end;
    end;
  end;

  ItemNumber := 1;
  for i := 0 to FReceiptItems.Count-1 do
  begin
    ReceiptItem := ReceiptItems[i];
    if ReceiptItem is TFSSaleItem then
    begin
      FSSaleItem := ReceiptItem as TFSSaleItem;
      FSSaleItem.Pos := ItemNumber;
      Inc(ItemNumber);
    end;
  end;
end;

procedure TOposSalesReceipt.printReceiptItemAsText(Item: TFSSaleItem);
var
  Amount: Int64;
  TaxNumber: Integer;
  Line1, Line2: string;
begin
  if Item.Quantity < 0 then
  begin
    Printer.Printer.PrintLines('������', '');
    Item.Quantity := Abs(Item.Quantity);
  end;

  Line1 := Item.Text;

  TaxNumber := Item.Tax;
  if TaxNumber = 0 then TaxNumber := 4;

  Amount := Round2(Item.Quantity/1000 * Item.Price);
  if ((Item.Quantity = 1000) and (not Parameters.PrintSingleQuantity)) then
  begin
    Line2 := Tnt_WideFormat('= %s', [AmountToStr(Amount/100)]) +  GetTaxLetter(TaxNumber);
  end else
  begin
    Line2 := QuantityToStr(Item.Quantity/1000);
    if Parameters.PrintUnitName then
      Line2 := Line2 + ' ' + Item.Data.UnitName;
    Line2 := Tnt_WideFormat('%s X %s = %s', [Line2, AmountToStr(Item.Price/100),
      AmountToStr(Amount/100)]) +  GetTaxLetter(TaxNumber);
  end;
  if Length(Line1 + Line2) > Device.GetPrintWidth then
  begin
    PrintText2(Line1);
    Printer.Printer.PrintLines('', Line2);
  end else
  begin
    Printer.Printer.PrintLines(Line1, Line2);
  end;
  PrintTotalAndTax(Item);
end;

procedure TOposSalesReceipt.PrintTotalAndTax(const Item: TFSSaleItem);
var
  Tax: Integer;
  Line: string;
  TaxRate: Double;
  TaxAmount: Int64;
begin
  Tax := Item.Tax;
  if (Tax = 0) then Tax := 4;
  TaxRate := Device.ReadTableInt(6, Tax, 1)/10000;
  TaxAmount := Round2(Item.GetTotal * TaxRate / (1 + TaxRate));
  Line := Device.ReadTableStr(6, Tax, 2);
  Printer.Printer.PrintLines(Line, AmountToStr(TaxAmount/100));
end;

function TOposSalesReceipt.IsLoyaltyCard(const Text: string): Boolean;
begin
  Result := ExecRegExpr(GetMalinaParams.RosneftCardMask, Text);
end;

function TOposSalesReceipt.GetCapReceiptDiscount2: Boolean;
begin
  Result := Device.CapReceiptDiscount2;
end;

procedure TOposSalesReceipt.PrintDiscounts;
var
  i: Integer;
  Item: TReceiptItem;
  Discount: TAmountOperation;
begin
  if not Device.CapDiscount then Exit;
  for i := 0 to FDiscounts.Count-1 do
  begin
    Item := FDiscounts[i];
    if Item is TDiscountReceiptItem then
    begin
      Discount := (Item as TDiscountReceiptItem).Data;
      PrintDiscount(Discount);
    end;
  end;
end;

procedure TOposSalesReceipt.PrintDiscount(Discount: TAmountOperation);
var
  ResultCode: Integer;
  Discount2: TReceiptDiscount2;
begin
  if GetCapReceiptDiscount2 then
  begin
    Discount2.Discount := 0;
    Discount2.Charge := 0;
    Discount2.Tax := Discount.Tax1;
    Discount2.Text := Discount.Text;

    if Discount.Amount > 0 then
      Discount2.Discount := Discount.Amount
    else
      Discount2.Charge := Abs(Discount.Amount);
    ResultCode := Device.ReceiptDiscount2(Discount2);
    if ResultCode <> ERROR_COMMAND_NOT_SUPPORTED then
    begin
      Device.Check(ResultCode);
      Exit;
    end;
  end;

  if Discount.Amount > 0 then
  begin
    Device.Check(Device.ReceiptDiscount(Discount));
  end else
  begin
    Discount.Amount := Abs(Discount.Amount);
    Device.Check(Device.ReceiptCharge(Discount));
  end;
end;

procedure TOposSalesReceipt.PrintRecVoidItem(const Description: string;
  Amount: Currency; Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
var
  Operation: TFSSale;
  DiscountAmount: Int64;
begin
  CheckAmount(Amount);
  CheckQuantity(Quantity);
  CheckDescription(Description);

  DiscountAmount := GetAdjustmentAmount(AdjustmentType, Adjustment);

  Operation.RecType := FRecType;
  Operation.Price := Printer.CurrencyToInt(Amount);
  Operation.Quantity := -Abs(Quantity);
  Operation.Department := Parameters.Department;
  Operation.Tax := VatInfo;
  Operation.Text := Description;
  Operation.Charge := 0;
  Operation.Discount := 0;
  if DiscountAmount > 0 then
    Operation.Discount := DiscountAmount
  else
    Operation.Charge := Abs(DiscountAmount);
  Operation.Barcode := 0;
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.PrintRecItemVoid(const Description: string;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  Operation: TFSSale;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);

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

  Operation.Quantity := -Abs(Operation.Quantity);
  Operation.Tax := VatInfo;
  Operation.Text := Description;
  Operation.UnitName := UnitName;
  Operation.Department := Parameters.Department;
  Operation.RecType := FRecType;
  Operation.Charge := 0;
  Operation.Discount := 0;
  Operation.Barcode := 0;
  Operation.AdjText := '';
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.SetRefundReceipt;
begin
  if FReceiptItems.Count = 0 then
    FRecType := RecTypeRetSale;
end;

procedure TOposSalesReceipt.PrintRecItemRefund(const ADescription: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
var
  Operation: TFSSale;
begin
  SetRefundReceipt;
  CheckAmount(Amount);
  CheckAmount(UnitAmount);
  CheckQuantity(Quantity);

  Operation.Quantity := Quantity;
  if (UnitAmount = 0)or(Operation.Quantity = 0) then
  begin
    // If no price - use single quantity cost
    if UnitAmount <> 0 then Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Amount);
  end else
  begin
    if Operation.Quantity = 0 then Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(UnitAmount);
  end;
  Operation.Tax := VatInfo;
  Operation.Text := ADescription;
  Operation.UnitName := AUnitName;
  Operation.Department := Parameters.Department;
  Operation.RecType := FRecType;
  Operation.Charge := 0;
  Operation.Discount := 0;
  Operation.Barcode := 0;
  Operation.AdjText := '';
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.PrintRecItemRefundVoid(const ADescription: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
var
  Operation: TFSSale;
begin
  SetRefundReceipt;
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

  Operation.Quantity := -Abs(Operation.Quantity);
  Operation.Tax := VatInfo;
  Operation.Text := ADescription;
  Operation.UnitName := AUnitName;
  Operation.Department := Parameters.Department;
  Operation.RecType := FRecType;
  Operation.Charge := 0;
  Operation.Discount := 0;
  Operation.Barcode := 0;
  Operation.AdjText := '';
  Operation.Parameter1 := Parameters.Parameter1;
  Operation.Parameter2 := Parameters.Parameter2;
  Operation.Parameter3 := Parameters.Parameter3;
  Operation.Parameter4 := Parameters.Parameter4;
  AddSale(Operation);
end;

procedure TOposSalesReceipt.PaymentAdjustment(Amount: Int64);
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

procedure TOposSalesReceipt.PrintRecMessage(const Message: string);
begin
  PrintNormal(Message, PRINTER_STATION_REC);
end;

procedure TOposSalesReceipt.PrintNormal(const Text: string; Station: Integer);
begin
  if not FHasReceiptItems then
  begin
    if Printer.Printer.PreLine <> '' then
      AddRecMessage(Printer.Printer.PreLine, Station, 0);
    AddRecMessage(Text, Station, 0);
    if Printer.Printer.PostLine <> '' then
      AddRecMessage(Printer.Printer.PostLine, Station, 0);
    Printer.Printer.PreLine := '';
    Printer.Printer.PostLine := '';
    Exit;
  end;

  if State.State = FPTR_PS_FISCAL_RECEIPT_ENDING then
  begin
    if Printer.Printer.PreLine <> '' then
      AddRecMessage(Printer.Printer.PreLine, Station, 2);
    AddRecMessage(Text, Station, 2);
    if Printer.Printer.PostLine <> '' then
      AddRecMessage(Printer.Printer.PostLine, Station, 2);
    Printer.Printer.PreLine := '';
    Printer.Printer.PostLine := '';
    Exit;
  end;


  if Printer.Printer.PreLine <> '' then
    AddTextItem(Printer.Printer.PreLine, Station);
  AddTextItem(Text, Station);
  if Printer.Printer.PostLine <> '' then
    AddTextItem(Printer.Printer.PostLine, Station);
  Printer.Printer.PreLine := '';
  Printer.Printer.PostLine := '';
end;

procedure TOposSalesReceipt.AddTextItem(const Text: string; Station: Integer);
var
  Data: TTextRec;
  Item: TTextReceiptItem;
begin
  Data.Text := Text;
  Data.Font := Parameters.FontNumber;
  Data.Station := Station;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;

  Item := TTextReceiptItem.Create(FReceiptItems);
  Item.Data := Data;
end;

procedure TOposSalesReceipt.SetAdjustmentAmount(Amount: Integer);
begin
  FAdjustmentAmount := Amount;
  if GetPaymentTotal >= (GetTotal - FAdjustmentAmount) then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
end;

procedure TOposSalesReceipt.PrintText(const Data: TTextRec);
var
  Item: TTextReceiptItem;
begin
  Item := TTextReceiptItem.Create(FReceiptItems);
  Item.Data := Data;
end;

procedure TOposSalesReceipt.PrintBarcode(const Barcode: TBarcodeRec);
var
  Item: TBarcodeReceiptItem;
begin
  Item := TBarcodeReceiptItem.Create(FReceiptItems);
  Item.Data := Barcode;
end;

procedure TOposSalesReceipt.FSWriteTLV(const TLVData: string);
var
  Item: TTLVReceiptItem;
begin
  Item := TTLVReceiptItem.Create(FReceiptItems);
  Item.Data := TLVData;
end;

end.

