unit FSSalesReceipt;

interface

uses
  // VCL
  Windows, SysUtils, Forms, Controls, Classes, Messages,
  // This
  CustomReceipt, PrinterTypes, ByteUtils, OposFptr, OposException,
  Opos, PayType, ReceiptPrinter, FiscalPrinterState,
  ReceiptItem, RecDiscount, PrinterParameters, TextItem, MathUtils,
  fmuSelect, fmuPhone, fmuEMail, TLV, LogFile, RegExpr, MalinaParams,
  StringUtils, Retalix, FiscalPrinterTypes, ReceiptTemplate,
  SmResourceStrings, DirectioAPI;

type
  { TFSSalesReceipt }

  TFSSalesReceipt = class(TCustomReceipt)
  private
    FOpened: Boolean;
    FRecType: Integer;
    FIsVoided: Boolean;
    FRetalix: TRetalix;
    FPayments: TPayments;
    FLastItem: TFSSaleItem;
    FDiscounts: TReceiptItems;
    FHasReceiptItems: Boolean;
    FReceiptItems: TReceiptItems;
    FRecDiscount: TDiscountReceiptItem;
    FAdjustmentAmount: Integer;
    FTemplate: TReceiptTemplate;
    FAdditionalHeader: string;

    procedure PrintReceiptItems;
    procedure CheckTotal(Total: Currency);
    procedure SubtotalDiscount(Amount: Int64; const Description: string);
    procedure CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
    procedure RecSubtotalAdjustment(const Description: string;
      AdjustmentType: Integer; Amount: Currency);


    function GetIsCashPayment: Boolean;
    function GetDevice: IFiscalPrinterDevice;
    function IsCashlessPayCode(PayCode: Integer): Boolean;

    procedure BeforeCloseReceipt;
    procedure AddItemDiscount(Discount: TAmountOperation);
    function GetAdjustmentAmount(AdjustmentType: Integer;
      Amount: Currency): Int64;
    function GetLastItem: TFSSaleItem;
    procedure AddSale(const P: TFSSale);
    procedure ClearReceipt;
    procedure SetRefundReceipt;
    procedure UpdateDiscounts;
    function IsLoyaltyCard(const Text: string): Boolean;
    procedure PrintDiscounts;
    function GetTax(const ItemName: string; Tax: Integer): Integer;
    function GetCapReceiptDiscount2: Boolean;
    procedure PrintText2(const Text: string);
    procedure PrintFSSale(Item: TFSSaleItem);
    procedure AddTextItem(const Text: string; Station: Integer);
    procedure ParseReceiptItemsLines(Items: TReceiptItems);
    procedure ParseReceiptItemsLines2(Items: TReceiptItems);
    procedure PrintFSSale0(Item: TFSSaleItem);
    procedure PrintFSSale2(SaleItem: TFSSaleItem);
    procedure DoPrintFSSale(Item: TFSSaleItem);
    procedure printReceiptItemAsText(Item: TFSSaleItem);
    procedure PrintTotalAndTax(const Item: TFSSaleItem);
    procedure printReceiptItemTemplate(Item: TFSSaleItem);

    property Template: TReceiptTemplate read FTemplate;
    property Device: IFiscalPrinterDevice read GetDevice;
    procedure UpdateReceiptItems;
    procedure PrintDiscount(Discount: TAmountOperation);
  public
    constructor CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
    destructor Destroy; override;

    procedure CorrectPayments;
    function GetTotal: Int64; override;

    procedure PrintPreLine;
    procedure PrintPostLine;

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
    procedure WriteFPParameter(ParamId: Integer; const Value: string); override;
    procedure PrintAdditionalHeader(const AdditionalHeader: string); override;

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

{ TFSSalesReceipt }

constructor TFSSalesReceipt.CreateReceipt(AContext: TReceiptContext; ARecType: Integer);
begin
  inherited Create(AContext);
  FRecType := ARecType;
  FDiscounts := TReceiptItems.Create;
  FReceiptItems := TReceiptItems.Create;
  ClearReceipt;

  FTemplate := TReceiptTemplate.Create;
  FTemplate.Template := AContext.Printer.Printer.Parameters.ReceiptItemFormat;
end;

destructor TFSSalesReceipt.Destroy;
begin
  FRetalix.Free;
  FTemplate.Free;
  FDiscounts.Free;
  FReceiptItems.Free;
  inherited Destroy;
end;

function TFSSalesReceipt.GetTax(const ItemName: string; Tax: Integer): Integer;
begin
  Result := Tax;
  {$IFDEF MALINA}
  if GetMalinaParams.RetalixDBEnabled then
  begin
    if FREtalix = nil then
    begin
      FRetalix := TRetalix.Create(GetMalinaParams.RetalixDBPath, Device.Context);
      FRetalix.Open;
    end;
    Result := FRetalix.ReadTaxGroup(ItemName);
    if Result = -1 then
      Result := Tax;
  end;
  {$ENDIF}
  Result := Parameters.GetVatInfo(Result);
  if not (Result in [0..6]) then Result := 0;
end;

procedure TFSSalesReceipt.PrintText2(const Text: string);
begin
  Printer.Printer.PrintText(Text);
end;

procedure TFSSalesReceipt.AddSale(const P: TFSSale);
begin
  FLastItem := TFSSaleItem.Create(FReceiptItems);
  FLastItem.Data := P;
  FLastItem.PreLine := Printer.Printer.PreLine;
  FLastItem.PostLine := Printer.Printer.PostLine;
  Printer.Printer.PreLine := '';
  Printer.Printer.PostLine := '';
  FHasReceiptItems := True;
end;

function TFSSalesReceipt.GetLastItem: TFSSaleItem;
begin
  if FLastItem = nil then
    raise Exception.Create(MsgLastReceiptItemNotDefined);
  Result := FLastItem;
end;

procedure TFSSalesReceipt.AddItemDiscount(Discount: TAmountOperation);
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
      raise Exception.Create(MsgDiscountAmountMoreItemAmount);
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

function TFSSalesReceipt.IsCashlessPayCode(PayCode: Integer): Boolean;
begin
  Result := PayCode in [1..15];
end;

function TFSSalesReceipt.GetPaymentTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := Low(FPayments) to High(FPayments) do
  begin
    Result := Result + FPayments[i];
  end;
end;

function TFSSalesReceipt.GetCashlessTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := (Low(FPayments)+1) to High(FPayments) do
  begin
    Result := Result + FPayments[i];
  end;
end;

function TFSSalesReceipt.GetIsCashPayment: Boolean;
begin
  Result := GetCashlessTotal = 0;
end;

procedure TFSSalesReceipt.PrintRecVoid(const Description: string);
begin
  OpenReceipt(RecTypeSale);
  Printer.PrintTextLine(Description);
  FIsVoided := True;
end;

procedure TFSSalesReceipt.CheckTotal(Total: Currency);
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

procedure TFSSalesReceipt.CheckAdjAmount(AdjustmentType: Integer; Amount: Currency);
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

procedure TFSSalesReceipt.PrintRecItem(const Description: string; Price: Currency;
  Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
var
  Operation: TFSSale;
begin
  CheckPrice(Price);
  CheckQuantity(Quantity);
  CheckPrice(UnitPrice);

  Operation.Quantity := Quantity;
  if UnitPrice = 0 then
  begin
    // If no price - use single quanity cost
    if Price <> 0  then Operation.Quantity := 1000;
    Operation.Price := Printer.CurrencyToInt(Price);
  end else
  begin
    if Quantity = 0 then Operation.Quantity := 1000;
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

procedure TFSSalesReceipt.PrintRecItemAdjustment(
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

procedure TFSSalesReceipt.PrintRecPackageAdjustment(
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

procedure TFSSalesReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
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

procedure TFSSalesReceipt.PrintRecRefund(const Description: string;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TFSSale;
begin
  SetRefundReceipt;
  CheckAmount(Amount);

  Operation.Quantity := 1000;
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

procedure TFSSalesReceipt.PrintRecRefundVoid(
  const Description: string;
  Amount: Currency; VatInfo: Integer);
var
  Operation: TFSSale;
begin
  SetRefundReceipt;
  CheckDescription(Description);
  CheckAmount(Amount);

  Operation.Quantity := -1000;
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

procedure TFSSalesReceipt.PrintRecSubtotal(Amount: Currency);
var
  Text: string;
begin
  Text := Printer.CurrencyToStr(GetTotal/100);
  Text := Printer.Printer.Device.FormatLines(Parameters.SubtotalText, '=' + Text);
  PrintNormal(Text, PRINTER_STATION_REC);
end;

procedure TFSSalesReceipt.PrintRecSubtotalAdjustment(AdjustmentType: Integer;
  const Description: string; Amount: Currency);
begin
  CheckDescription(Description);
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment(Description, AdjustmentType, Amount);
end;

// Discount void consider to taxes turnover

procedure TFSSalesReceipt.SubtotalDiscount(Amount: Int64; const Description: string);
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

function TFSSalesReceipt.GetTotal: Int64;
begin
  Result := FReceiptItems.GetTotal - FDiscounts.GetTotal;
end;

function TFSSalesReceipt.GetAdjustmentAmount(
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

procedure TFSSalesReceipt.RecSubtotalAdjustment(const Description: string;
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

procedure TFSSalesReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  CheckAdjAmount(AdjustmentType, Amount);
  RecSubtotalAdjustment('', AdjustmentType, Amount);
end;

procedure TFSSalesReceipt.ParseReceiptItemsLines(Items: TReceiptItems);
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

procedure TFSSalesReceipt.ParseReceiptItemsLines2(Items: TReceiptItems);
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

procedure TFSSalesReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
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

procedure TFSSalesReceipt.CheckRececiptState;
begin
  if GetPaymentTotal >= GetTotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
end;

procedure TFSSalesReceipt.OpenReceipt(ARecType: Integer);
begin
  Logger.Debug('TFSSalesReceipt.OpenReceipt');

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

procedure TFSSalesReceipt.ClearReceipt;
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

procedure TFSSalesReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  ClearReceipt;
  if Parameters.OpenReceiptEnabled then
  begin
    OpenReceipt(FRecType);
  end;
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

function GetTaxLetter(Tax: Integer): string;
const
  TaxLetter = 'АБВГ';
begin
  Result := '';
  if Tax in [1..4] then
    Result := TaxLetter[Tax];
  if Result <> '' then
    Result := '_' + Result;
end;

procedure TFSSalesReceipt.UpdateReceiptItems;
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

procedure TFSSalesReceipt.PrintReceiptItems;
var
  i: Integer;
  ReceiptItem: TReceiptItem;
begin
  if Parameters.RecPrintType = RecPrintTypeTemplate then
  begin
    Printer.Printer.PrintText(Parameters.ReceiptItemsHeader);
  end;

  for i := 0 to FReceiptItems.Count-1 do
  begin
    ReceiptItem := ReceiptItems[i];
    if ReceiptItem is TFSSaleItem then
    begin
      PrintFSSale(ReceiptItem as TFSSaleItem);
    end;
    if ReceiptItem is TTextReceiptItem then
    begin
      Printer.PrintText((ReceiptItem as TTextReceiptItem).Data);
    end;
    if ReceiptItem is TBarcodeReceiptItem then
    begin
      Device.PrintBarcode2((ReceiptItem as TBarcodeReceiptItem).Data);
    end;
  end;
  // Write tags after all items
  for i := 0 to FReceiptItems.Count-1 do
  begin
    ReceiptItem := ReceiptItems[i];
    if ReceiptItem is TTLVReceiptItem then
    begin
      Device.FsWriteTLV((ReceiptItem as TTLVReceiptItem).Data);
    end;
  end;
end;

procedure TFSSalesReceipt.PrintFSSale(Item: TFSSaleItem);
begin
  if Device.CapDiscount then
  begin
    PrintFSSale0(Item);
  end else
  begin
    PrintFSSale2(Item);
  end;
end;

(*
  if Parameters.FSUpdatePrice then
  begin
    Item.Data.Price := Item.Data.Price -
      Round2((Item.Data.Discount - Item.Data.Charge)*1000/Item.Data.Quantity);
  end;
*)

procedure TFSSalesReceipt.PrintFSSale0(Item: TFSSaleItem);
begin
  DoPrintFSSale(Item);
end;

procedure TFSSalesReceipt.PrintFSSale2(SaleItem: TFSSaleItem);
var
  Amount: Int64;
  Amount1: Int64;
begin
  if (SaleItem.Data.Discount > 0)or(SaleItem.Data.Charge > 0) then
  begin
    Amount := Round(SaleItem.Data.Price * SaleItem.Data.Quantity/1000) -
      SaleItem.Data.Discount + SaleItem.Data.Charge;

    SaleItem.Data.Price := 0;
    if SaleItem.Data.Quantity <> 0 then
    begin
      SaleItem.Data.Price := Trunc(Amount *1000 / SaleItem.Data.Quantity);
    end;

    Amount1 := Round(SaleItem.Data.Price * SaleItem.Data.Quantity/1000);
    SaleItem.Data.Discount := 0;
    SaleItem.Data.Charge := 0;
    DoPrintFSSale(SaleItem);

    SaleItem.Data.Price := Amount - Amount1;
    SaleItem.Data.Quantity := 1000;
    if SaleItem.Data.Price <> 0 then
    begin
      DoPrintFSSale(SaleItem);
    end;
  end else
  begin
    DoPrintFSSale(SaleItem);
  end;
end;

procedure TFSSalesReceipt.DoPrintFSSale(Item: TFSSaleItem);
var
  FSSale2: TFSSale2;
  FSRegistration: TFSSale;
  Operation: TPriceReg;
begin
  if Item.PreLine <> '' then
    PrintText2(Item.PreLine);

  FSRegistration := Item.Data;

  Operation.Quantity := Abs(FSRegistration.Quantity);
  if Parameters.QuantityLength = QuantityLength6 then
    Operation.Quantity := Round(Abs(FSRegistration.Quantity) / 1000);

  Operation.Price := FSRegistration.Price;
  Operation.Department := FSRegistration.Department;
  Operation.Tax1 := GetTax(FSRegistration.Text, FSRegistration.Tax);
  Operation.Tax2 := 0;
  Operation.Tax3 := 0;
  Operation.Tax4 := 0;
  Operation.Text := FSRegistration.Text;
  if Parameters.RecPrintType <> RecPrintTypePrinter then
  begin
    Operation.Text := '//' + FSRegistration.Text;
  end;

  if FSRegistration.Quantity >= 0 then
  begin
    if Device.CapFSCloseReceipt2 then
    begin
      FSSale2.RecType := FRecType;
      FSSale2.Quantity := Abs(FSRegistration.Quantity);
      if Parameters.QuantityLength = QuantityLength3 then
        FSSale2.Quantity := Abs(FSRegistration.Quantity) * 1000;

      FSSale2.Price := Item.PriceWithDiscount;
      FSSale2.Total := StrToInt64Def(FSRegistration.Parameter1, $FFFFFFFFFF);
      FSSale2.TaxAmount := StrToInt64Def(FSRegistration.Parameter2, $FFFFFFFFFF);
      FSSale2.Department := FSRegistration.Department;
      FSSale2.Tax := GetTax(FSRegistration.Text, FSRegistration.Tax);
      FSSale2.Text := Operation.Text;
      FSSale2.PaymentType := StrToInt64Def(FSRegistration.Parameter3, 0);
      FSSale2.PaymentItem := StrToInt64Def(FSRegistration.Parameter4, 0);
      Device.Check(Device.FSSale2(FSSale2));
    end else
    begin
      if FRecType = RecTypeSale then
        Printer.Sale(Operation)
      else
        Printer.RetSale(Operation);
    end;
  end else
  begin
    Printer.Storno(Operation);
  end;

  if Parameters.RecPrintType = RecPrintTypeDriver then
  begin
    printReceiptItemAsText(Item);
  end;
  if Parameters.RecPrintType = RecPrintTypeTemplate then
  begin
    printReceiptItemTemplate(Item);
  end;

  if Item.PostLine <> '' then
    PrintText2(Item.PostLine);
end;

procedure TFSSalesReceipt.printReceiptItemAsText(Item: TFSSaleItem);
var
  Amount: Int64;
  TaxNumber: Integer;
  Line1, Line2: string;
begin
  if Item.Quantity < 0 then
  begin
    Printer.Printer.PrintLines('СТОРНО', '');
    Item.Quantity := Abs(Item.Quantity);
  end;

  Line1 := Item.Text;

  TaxNumber := Item.Tax;
  if TaxNumber = 0 then TaxNumber := 4;

  Amount := Round2(Item.Quantity/1000 * Item.Price);
  if ((Item.Quantity = 1000) and (not Parameters.PrintSingleQuantity)) then
  begin
    Line2 := Format('= %s', [AmountToStr(Amount/100)]) +  GetTaxLetter(TaxNumber);
  end else
  begin
    Line2 := QuantityToStr(Item.Quantity/1000);
    if Parameters.PrintUnitName then
      Line2 := Line2 + ' ' + Item.Data.UnitName;
    Line2 := Format('%s X %s = %s', [Line2, AmountToStr(Item.Price/100),
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

procedure TFSSalesReceipt.PrintTotalAndTax(const Item: TFSSaleItem);
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

procedure TFSSalesReceipt.BeforeCloseReceipt;
var
  Selection: Integer;
  CustomerPhone: string;
  CustomerEMail: string;
begin
  if not FPrintEnabled then
  begin
    Device.WriteFPParameter(DIO_FPTR_PARAMETER_ENABLE_PRINT, '1');
  end;

  if Parameters.FSAddressEnabled then
  begin
    Selection := ShowSelectDlg;
    if Selection = SelectNone then Exit;
    if Selection = SelectPhone then
    begin
      CustomerPhone := '+7';
      if ShowPhoneDlg(CustomerPhone) then
      begin
        AddRecMessage('Номер телефона: ' + CustomerPhone, PRINTER_STATION_REC, 1);
        Device.WriteCustomerAddress(CustomerPhone);
      end;
    end;
    if Selection = SelectEMail then
    begin
      CustomerEMail := '';
      if ShowEMailDlg(CustomerEMail) then
      begin
        AddRecMessage('Электронная почта: ' + CustomerEMail, PRINTER_STATION_REC, 1);
        Device.WriteCustomerAddress(CustomerEMail);
      end;
    end;
  end;
end;

procedure TFSSalesReceipt.CorrectPayments;
var
  i: Integer;
  Total: Int64;
  PaidAmount: Int64;
begin
  PaidAmount := 0;
  Total := GetTotal;
  for i := High(FPayments) downto (Low(FPayments)+1) do
  begin
    if (PaidAmount + FPayments[i] > Total) then
    begin
      FPayments[i] := Total - PaidAmount;
    end;
    PaidAmount := PaidAmount + FPayments[i];
  end;
end;

procedure TFSSalesReceipt.EndFiscalReceipt;
var
  CloseParams: TCloseReceiptParams;
  CloseParams2: TFSCloseReceiptParams2;
  CloseResult2: TFSCloseReceiptResult2;
begin
  Device.Lock;
  try
    State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);
    if FIsVoided then
    begin
      Device.CancelReceipt;
    end else
    begin
      OpenReceipt(FRecType);
      Device.PrintText(PRINTER_STATION_REC, FAdditionalHeader);

      CorrectPayments;
      PrintRecMessages(0);
      UpdateDiscounts;
      UpdateReceiptItems;

      PrintReceiptItems;
      PrintDiscounts;

      BeforeCloseReceipt;
      if AdditionalText <> '' then
        PrintText2(AdditionalText);

      if Parameters.RecPrintType = RecPrintTypeTemplate then
      begin
        Printer.Printer.PrintText(Parameters.ReceiptItemsTrailer);
      end;

      Printer.WaitForPrinting;


      if Device.CapFSCloseReceipt2 then
      begin
        CloseParams2.Payments := FPayments;
        CloseParams2.Discount := FAdjustmentAmount;
        CloseParams2.TaxAmount[1] := StrToInt64Def(Parameters.Parameter1, 0);
        CloseParams2.TaxAmount[2] := StrToInt64Def(Parameters.Parameter2, 0);
        CloseParams2.TaxAmount[3] := StrToInt64Def(Parameters.Parameter3, 0);
        CloseParams2.TaxAmount[4] := StrToInt64Def(Parameters.Parameter4, 0);
        CloseParams2.TaxAmount[5] := StrToInt64Def(Parameters.Parameter5, 0);
        CloseParams2.TaxAmount[6] := StrToInt64Def(Parameters.Parameter6, 0);
        CloseParams2.TaxSystem := StrToInt64Def(Parameters.Parameter7, 0);
        CloseParams2.Text := Parameters.CloseRecText;
        Device.Check(Device.ReceiptClose2(CloseParams2, CloseResult2));

      end else
      begin
        CloseParams.CashAmount := FPayments[0];
        CloseParams.Amount2 := FPayments[1];
        CloseParams.Amount3 := FPayments[2];
        CloseParams.Amount4 := FPayments[3];
        CloseParams.PercentDiscount := FAdjustmentAmount;
        CloseParams.Tax1 := 0;
        CloseParams.Tax2 := 0;
        CloseParams.Tax3 := 0;
        CloseParams.Tax4 := 0;
        CloseParams.Text := Parameters.CloseRecText;
        Printer.ReceiptClose(CloseParams);
      end;

      try
        Printer.WaitForPrinting;
        PrintRecMessages(1);
        PrintRecMessages;
      except
        on E: Exception do
        begin
          Logger.Error(E.Message);
        end;
      end;
    end;
  finally
    Device.Unlock;
  end;
end;

function TFSSalesReceipt.IsLoyaltyCard(const Text: string): Boolean;
begin
  Result := ExecRegExpr(GetMalinaParams.RosneftCardMask, Text);
end;

function TFSSalesReceipt.GetCapReceiptDiscount2: Boolean;
begin
  Result := Device.CapReceiptDiscount2;
end;

procedure TFSSalesReceipt.PrintDiscounts;
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

procedure TFSSalesReceipt.PrintDiscount(Discount: TAmountOperation);
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

procedure TFSSalesReceipt.UpdateDiscounts;
var
  i: Integer;
  Amount: Int64;
  Item: TReceiptItem;
  SaleItem: TFSSaleItem;
  DiscountAmount: Int64;
begin
  DiscountAmount := Abs(FDiscounts.GetTotal);
  if DiscountAmount = 0 then Exit;

  if (Device.CapSubtotalRound) and (DiscountAmount < 100) then
  begin
    FDiscounts.Clear;
    FAdjustmentAmount := DiscountAmount;
    Exit;
  end;

  for i := 0 to FReceiptItems.Count-1 do
  begin
    Item := FReceiptItems[i];
    if Item is TFSSaleItem then
    begin
      SaleItem := Item as TFSSaleItem;
      Amount := DiscountAmount;
      if Amount > SaleItem.GetTotal then
        Amount := SaleItem.GetTotal;

      SaleItem.Discount := SaleItem.Discount + Amount;
      DiscountAmount := DiscountAmount - Amount;
      if DiscountAmount = 0 then Break;
    end;
  end;
end;

procedure TFSSalesReceipt.PrintRecVoidItem(const Description: string;
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

procedure TFSSalesReceipt.PrintRecItemVoid(const Description: string;
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

procedure TFSSalesReceipt.SetRefundReceipt;
begin
  if FReceiptItems.Count = 0 then
    FRecType := RecTypeRetSale;
end;

procedure TFSSalesReceipt.PrintRecItemRefund(const ADescription: string;
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

procedure TFSSalesReceipt.PrintRecItemRefundVoid(const ADescription: string;
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

procedure TFSSalesReceipt.PaymentAdjustment(Amount: Int64);
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

procedure TFSSalesReceipt.PrintRecMessage(const Message: string);
begin
  PrintNormal(Message, PRINTER_STATION_REC);
end;

procedure TFSSalesReceipt.PrintNormal(const Text: string; Station: Integer);
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

procedure TFSSalesReceipt.AddTextItem(const Text: string; Station: Integer);
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

procedure TFSSalesReceipt.PrintPostLine;
begin
  Printer.PrintPostLine;
end;

procedure TFSSalesReceipt.PrintPreLine;
begin
  Printer.PrintPreLine;
end;

procedure TFSSalesReceipt.SetAdjustmentAmount(Amount: Integer);
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

procedure TFSSalesReceipt.PrintText(const Data: TTextRec);
var
  Item: TTextReceiptItem;
begin
  Item := TTextReceiptItem.Create(FReceiptItems);
  Item.Data := Data;
end;

procedure TFSSalesReceipt.PrintBarcode(const Barcode: TBarcodeRec);
var
  Item: TBarcodeReceiptItem;
begin
  Item := TBarcodeReceiptItem.Create(FReceiptItems);
  Item.Data := Barcode;
end;

procedure TFSSalesReceipt.FSWriteTLV(const TLVData: string);
var
  Item: TTLVReceiptItem;
begin
  Item := TTLVReceiptItem.Create(FReceiptItems);
  Item.Data := TLVData;
end;

function TFSSalesReceipt.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TFSSalesReceipt.printReceiptItemTemplate(Item: TFSSaleItem);
var
  Text: string;
begin
  Text := Template.getItemText(Item);
  Printer.Printer.PrintText(Text);
end;

procedure TFSSalesReceipt.WriteFPParameter(ParamId: Integer;
  const Value: string);
begin
  if (ParamId = DIO_FPTR_PARAMETER_ENABLE_PRINT)and(Value = '1') then
  begin
    FPrintEnabled := False;
  end else
  begin
    Device.WriteFPParameter(ParamId, Value);
  end;
end;

procedure TFSSalesReceipt.PrintAdditionalHeader(
  const AdditionalHeader: string);
begin
  FAdditionalHeader := AdditionalHeader;
end;

end.

