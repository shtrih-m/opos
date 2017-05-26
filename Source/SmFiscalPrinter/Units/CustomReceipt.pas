unit CustomReceipt;

interface

uses
  // This
  ReceiptPrinter, OposException, PrinterParameters, Opos, OposFptr,
  FiscalPrinterDevice, FiscalPrinterTypes, FiscalPrinterState,
  PrinterTypes, EscFilter, TextItem, LogFile, MalinaParams;

type
  { TReceiptContext }

  TReceiptContext = record
    RecType: Integer;
    Filter: TEscFilter;
    Printer: IReceiptPrinter;
    State: TFiscalPrinterState;
    FiscalReceiptStation: Integer;
  end;

  { TCustomReceipt }

  TCustomReceipt = class
  private
    FRecType: Integer;
    FFilter: TEscFilter;
    FRecMessages: TTextItems;
    FPrinter: IReceiptPrinter;
    FState: TFiscalPrinterState;
    FFiscalReceiptStation: Integer;
    FAdditionalText: string;

    function GetLogger: TLogFile;
    function GetDevice: IFiscalPrinterDevice;
    function GetParameters: TPrinterParameters;
  protected
    property State: TFiscalPrinterState read FState;
    property Printer: IReceiptPrinter read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
    property FiscalReceiptStation: Integer read FFiscalReceiptStation;
  public
    constructor Create(AContext: TReceiptContext); virtual;
    destructor Destroy; override;

    class procedure CheckPrice(Value: Currency);
    class procedure CheckPercents(Value: Currency);
    class procedure CheckQuantity(Quantity: Integer);
    class procedure CheckAmount(Amount: Currency);
    class procedure CheckVatInfo(VatInfo: Integer);

    procedure OpenReceipt(ARecType: Integer); virtual;
    procedure BeginFiscalReceipt(PrintHeader: Boolean); virtual;
    procedure AddRecMessage(const Message: string; Station: Integer; ID: Integer);

    procedure PrintPreLine;
    procedure PrintPostLine;
    procedure ClearRecMessages;
    procedure EndFiscalReceipt; virtual;
    procedure AfterEndFiscalReceipt; virtual;
    procedure PrintRecMessages; overload;
    procedure PrintRecMessages(ID: Integer); overload;
    procedure PrintRecCash(Amount: Currency); virtual;
    procedure PrintRecItem(const Description: string; Price: Currency;
      Quantity: Integer; VatInfo: Integer; UnitPrice: Currency;
      const UnitName: string); virtual;
    procedure PrintRecItemAdjustment(AdjustmentType: Integer;
      const Description: string; Amount: Currency;
      VatInfo: Integer); virtual;
    procedure PrintRecMessage(const Message: string); virtual;
    procedure PrintRecNotPaid(const Description: string;
      Amount: Currency); virtual;
    procedure PrintRecRefund(const Description: string; Amount: Currency;
      VatInfo: Integer); virtual;
    procedure PrintRecSubtotal(Amount: Currency); virtual;

    procedure PrintRecSubtotalAdjustment(AdjustmentType: Integer;
      const Description: string; Amount: Currency); virtual;

    procedure PrintRecTotal(Total: Currency; Payment: Currency;
      const Description: string); virtual;

    procedure PrintRecVoid(const Description: string); virtual;

    procedure PrintRecVoidItem(const Description: string; Amount: Currency;
      Quantity: Integer; AdjustmentType: Integer; Adjustment: Currency;
      VatInfo: Integer); virtual;

    procedure PrintRecItemFuel(const Description: string; Price: Currency;
      Quantity, VatInfo: Integer; UnitPrice: Currency; const UnitName: string;
      SpecialTax: Currency; const SpecialTaxName: string); virtual;

    procedure PrintRecItemFuelVoid(const Description: string;
      Price: Currency; VatInfo: Integer; SpecialTax: Currency); virtual;

    procedure PrintRecPackageAdjustment(AdjustmentType: Integer;
      const Description, VatAdjustment: string); virtual;

    procedure PrintRecPackageAdjustVoid(AdjustmentType: Integer;
      const VatAdjustment: string); virtual;

    procedure PrintRecRefundVoid(const Description: string;
      Amount: Currency; VatInfo: Integer); virtual;

    procedure PrintRecSubtotalAdjustVoid(AdjustmentType: Integer;
      Amount: Currency); virtual;

    procedure PrintRecTaxID(const TaxID: string); virtual;

    procedure PrintRecItemAdjustmentVoid(AdjustmentType: Integer;
      const Description: string; Amount: Currency;
      VatInfo: Integer); virtual;

    procedure PrintRecItemVoid(const Description: string;
      Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
      const UnitName: string); virtual;

    procedure PrintRecItemRefund(
      const ADescription: string;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: string); virtual;

    procedure PrintRecItemRefundVoid(
      const ADescription: string;
      Amount: Currency; Quantity: Integer;
      VatInfo: Integer; UnitAmount: Currency;
      const AUnitName: string); virtual;

    procedure PrintNormal(const Text: string; Station: Integer); virtual;

    function GetTotal: Int64; virtual;
    function GetPaymentTotal: Int64; virtual;
    procedure PaymentAdjustment(Amount: Int64); virtual;
    class procedure CheckDescription(const Description: string);
    procedure SetAdjustmentAmount(Amount: Integer); virtual;
    procedure PrintText(const Data: TTextRec); virtual;
    procedure PrintBarcode(const Barcode: TBarcodeRec); virtual;
    procedure FSWriteTLV(const TLVData: string); virtual;
    function GetMalinaParams: TMalinaParams;

    property RecType: Integer read FRecType;
    property RecMessages: TTextItems read FRecMessages;
    property AdditionalText: string read FAdditionalText write FAdditionalText;
    property Parameters: TPrinterParameters read GetParameters;
    property Logger: TLogFile read GetLogger;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

  TCustomReceiptClass = class of TCustomReceipt;

implementation

procedure RaiseIllegalError;
begin
  RaiseOposException(OPOS_E_ILLEGAL, 'Receipt method is not supported');
end;

{ TCustomReceipt }

constructor TCustomReceipt.Create(AContext: TReceiptContext);
begin
  inherited Create;
  FRecType := AContext.RecType;
  FState := AContext.State;
  FFilter := AContext.Filter;
  FPrinter := AContext.Printer;
  FFiscalReceiptStation := AContext.FiscalReceiptStation;
  FRecMessages := TTextItems.Create;
end;

destructor TCustomReceipt.Destroy;
begin
  FRecMessages.Free;
  inherited Destroy;
end;

procedure TCustomReceipt.OpenReceipt(ARecType: Integer);
begin

end;

procedure TCustomReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  Printer.PrintMode;
  FRecMessages.Clear;
  FAdditionalText := '';
end;

procedure TCustomReceipt.EndFiscalReceipt;
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItem(const Description: string;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItemAdjustment(AdjustmentType: Integer;
  const Description: string; Amount: Currency; VatInfo: Integer);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.ClearRecMessages;
begin
  FRecMessages.Clear;
end;

procedure TCustomReceipt.PrintRecMessages;
var
  i: Integer;
  Data: TTextRec;
begin
  for i := 0 to FRecMessages.Count-1 do
  begin
    Data := FRecMessages[i].Data;
    Printer.PrintText(Data);
  end;
  FRecMessages.Clear;
end;

procedure TCustomReceipt.PrintRecMessages(ID: Integer);
var
  i: Integer;
  Data: TTextRec;
begin
  for i := 0 to FRecMessages.Count-1 do
  begin
    Data := FRecMessages[i].Data;
    if Data.ID = ID then
      Printer.PrintText(Data);
  end;
  for i := FRecMessages.Count-1 downto 0 do
  begin
    Data := FRecMessages[i].Data;
    if Data.ID = ID then
      FRecMessages[i].Free;
  end;
end;

procedure TCustomReceipt.PrintRecNotPaid(const Description: string;
  Amount: Currency);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecRefund(const Description: string;
  Amount: Currency; VatInfo: Integer);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecSubtotal(Amount: Currency);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecSubtotalAdjustment(
  AdjustmentType: Integer; const Description: string; Amount: Currency);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecTotal(Total, Payment: Currency;
  const Description: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecVoid(const Description: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecCash(Amount: Currency);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItemFuel(const Description: string;
  Price: Currency; Quantity, VatInfo: Integer; UnitPrice: Currency;
  const UnitName: string; SpecialTax: Currency;
  const SpecialTaxName: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItemFuelVoid(const Description: string;
  Price: Currency; VatInfo: Integer; SpecialTax: Currency);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecPackageAdjustment(AdjustmentType: Integer;
  const Description, VatAdjustment: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecPackageAdjustVoid(AdjustmentType: Integer;
  const VatAdjustment: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecRefundVoid(const Description: string;
  Amount: Currency; VatInfo: Integer);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecSubtotalAdjustVoid(
  AdjustmentType: Integer; Amount: Currency);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecTaxID(const TaxID: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItemAdjustmentVoid(
  AdjustmentType: Integer; const Description: string; Amount: Currency;
  VatInfo: Integer);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecVoidItem(
  const Description: string;
  Amount: Currency;
  Quantity, AdjustmentType: Integer;
  Adjustment: Currency; VatInfo: Integer);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItemVoid(
  const Description: string;
  Price: Currency;
  Quantity, VatInfo: Integer;
  UnitPrice: Currency;
  const UnitName: string);
begin
  RaiseIllegalError;
end;

class procedure TCustomReceipt.CheckPrice(Value: Currency);
begin
  if Value < 0 then
    raiseExtendedError(OPOS_EFPTR_BAD_PRICE, 'Negative price');
end;

class procedure TCustomReceipt.CheckPercents(Value: Currency);
begin
  if (Value < 0)or(Value > 9999) then
    raiseExtendedError(OPOS_EFPTR_BAD_ITEM_AMOUNT, 'Invalid percents value');
end;

class procedure TCustomReceipt.CheckQuantity(Quantity: Integer);
begin
  if Quantity < 0 then
    raiseExtendedError(OPOS_EFPTR_BAD_ITEM_QUANTITY, 'Negative quantity');
end;

class procedure TCustomReceipt.CheckAmount(Amount: Currency);
begin
  if Amount < 0 then
    raiseExtendedError(OPOS_EFPTR_BAD_ITEM_AMOUNT, 'Negative amount');
end;

class procedure TCustomReceipt.CheckVatInfo(VatInfo: Integer);
begin
(*
  if not(VatInfo in [0..4]) then
    RaiseExtendedError(OPOS_EFPTR_BAD_VAT, 'Invalid VatInfo value');
*)
end;

procedure TCustomReceipt.PrintRecItemRefund(const ADescription: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintRecItemRefundVoid(const ADescription: string;
  Amount: Currency; Quantity, VatInfo: Integer; UnitAmount: Currency;
  const AUnitName: string);
begin
  RaiseIllegalError;
end;

procedure TCustomReceipt.PrintNormal(const Text: string; Station: Integer);
begin
  if State.State = FPTR_PS_FISCAL_RECEIPT_ENDING then
  begin
    AddRecMessage(Text, Station, 0);
  end else
  begin
    Printer.Printer.Device.PrintText(Station, Text);
  end;
end;

procedure TCustomReceipt.PrintRecMessage(const Message: string);
begin
  PrintNormal(Message, PRINTER_STATION_REC);
end;

procedure TCustomReceipt.AfterEndFiscalReceipt;
begin

end;

procedure TCustomReceipt.PrintPostLine;
begin
  Printer.PrintPostLine;
end;

procedure TCustomReceipt.PrintPreLine;
begin
  Printer.PrintPreLine;
end;

function TCustomReceipt.GetPaymentTotal: Int64;
begin
  Result := 0;
end;

procedure TCustomReceipt.PaymentAdjustment(Amount: Int64);
begin

end;

class procedure TCustomReceipt.CheckDescription(const Description: string);
begin
end;

function TCustomReceipt.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TCustomReceipt.AddRecMessage(const Message: string; Station: Integer;
  ID: Integer);
var
  TextItem: TTextRec;
begin
  TextItem.ID := ID;
  TextItem.Text := Message;
  TextItem.Wrap := Parameters.WrapText;
  TextItem.Font := Parameters.FontNumber;
  TextItem.Station := Station;
  TextItem.Alignment := taLeft;
  FRecMessages.Add(TextItem);
end;

procedure TCustomReceipt.SetAdjustmentAmount(Amount: Integer);
begin

end;

(*
// If beginFiscalReceipt called, but receipt in fiscal printer is not opened -
// just save lines
function TCustomReceipt.IsStoreMessages: Boolean;
begin
  Result := (State.State = FPTR_PS_FISCAL_RECEIPT_ENDING) or
    ((State.State = FPTR_PS_FISCAL_RECEIPT)and (not FIsReceiptOpened));
end;

var
  TextItem: TTextRec;
begin
  TextItem.Text := Text;
  TextItem.Station := Station;
  TextItem.Alignment := taLeft;
  TextItem.Wrap := Parameters.WrapText;
  TextItem.Font := Parameters.FontNumber;
  if IsStoreMessages then
  begin
    FRecMessages.Add(TextItem);
  end else
  begin
    Printer.PrintText(TextItem);
  end;
end;

*)

function TCustomReceipt.GetTotal: Int64;
begin
  Result := 0;
  if Device.IsRecOpened then
    Result := Device.GetSubtotal;
end;

procedure TCustomReceipt.PrintText(const Data: TTextRec);
begin
  Device.PrintText(Data);
end;

procedure TCustomReceipt.PrintBarcode(const Barcode: TBarcodeRec);
begin
  Device.PrintBarcode2(Barcode);
end;

procedure TCustomReceipt.FSWriteTLV(const TLVData: string);
begin
  Device.Check(Device.FSWriteTLV(TLVData));
end;


function TCustomReceipt.GetParameters: TPrinterParameters;
begin
  Result := Printer.Printer.Parameters;
end;

function TCustomReceipt.GetLogger: TLogFile;
begin
  Result := Device.Parameters.Logger;
end;

function TCustomReceipt.GetMalinaParams: TMalinaParams;
begin
  Result := Device.Context.MalinaParams;
end;

end.
