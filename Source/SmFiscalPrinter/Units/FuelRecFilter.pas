unit FuelRecFilter;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  FiscalPrinterTypes, NonfiscalDoc, RecItem, PrinterTypes,
  LogFile, SalesReceipt, FptrFilter, CustomReceipt, MalinaParams,
  MathUtils;

type
  { TFuelRecFilter }

  TFuelRecFilter = class(TFptrFilter)
  private
    function GetLogger: ILogFile;
    function GetParams: TMalinaParams;
  private
    FDoc: TCustomReceipt;
    FPrinter: ISharedPrinter;
    FDiscountChecked: Boolean;

    procedure CheckDiscount;
    function IsFuelReceipt(Receipt: TSalesReceipt): Boolean;

    property Doc: TCustomReceipt read FDoc;
    property Logger: ILogFile read GetLogger;
    property Params: TMalinaParams read GetParams;
  public
    constructor Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);

    procedure BeginFiscalReceipt2(ADoc: TCustomReceipt); override;
    procedure BeforeCloseReceipt; override;
    property Printer: ISharedPrinter read FPrinter;
  end;

implementation

{ TFuelRecFilter }

constructor TFuelRecFilter.Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);
begin
  inherited Create(AOwner);
  FPrinter := APrinter;
end;

function TFuelRecFilter.IsFuelReceipt(Receipt: TSalesReceipt): Boolean;
var
  i: Integer;
  ItemText: string;
  Strings: TStrings;
begin
  Result := False;
  if Receipt.ItemCount = 1 then
  begin
    ItemText := Receipt.Items[0].Data.Text;

    Strings := TStringList.Create;
    try
      Strings.Text := Params.FuelItemText;
      for i := 0 to Strings.Count-1 do
      begin
        Result := Pos(Strings[i], ItemText) <> 0;
        if Result then Break;
      end;
    finally
      Strings.Free;
    end;
  end;
end;

(*

- сумма проданного топлива находится в диапазоне
[(N*SUM_STEP+0,01)…..( N* SUM_STEP + K)]руб,
где N - целое число, SUM_STEP - сумма "шага ровной суммы"
(например, 100 руб или 50 руб),
K - стоимость одной дискреты наиболее дорогого топлива;

*)

procedure TFuelRecFilter.BeforeCloseReceipt;
begin
  if not FDiscountChecked then
  begin
    CheckDiscount;
    FDiscountChecked := True;
  end;
end;

procedure TFuelRecFilter.CheckDiscount;
var
  K: Integer;
  ReceiptTotal: Int64;
  AmountStep: Integer;
  Data: TAmountOperation;
  AmountPrecision: Integer;
  Receipt: TSalesReceipt;
begin
  Logger.Debug('TFuelRecFilter.EndFiscalReceipt3');
  if not(Doc is TSalesReceipt) then
  begin
    Logger.Debug('Document is not sales receipt');
    Exit;
  end;
  Receipt := Doc as TSalesReceipt;

  if Receipt.IsVoided then
  begin
    Logger.Debug('Receipt is voided');
    Exit;
  end;

  if not IsFuelReceipt(Receipt) then
  begin
    Logger.Debug('Receipt is not fuel sales receipt');
    Exit;
  end;

  if (Params.CashRoundEnabled)and(not Receipt.IsCashPayment) then
  begin
    Logger.Debug('Only cash receipt round enabled');
    Exit;
  end;

  if Receipt.DiscountCount <> 0 then
  begin
    Logger.Debug('Receipt has discount');
    Exit;
  end;

  AmountStep := Abs(Round2(Params.FuelAmountStep*100));
  AmountPrecision := Abs(Round2(Params.FuelAmountPrecision*100));

  ReceiptTotal := FPrinter.Device.GetSubtotal;
  K := ReceiptTotal mod AmountStep;
  if K > AmountPrecision then
  begin
    Logger.Debug('Receipt precision more than maximum precision');
    Exit;
  end;
  if K <> 0 then
  begin
    Data.Amount := K;
    Data.Department := 1;
    Data.Tax1 := 0;
    Data.Tax2 := 0;
    Data.Tax3 := 0;
    Data.Tax4 := 0;
    Data.Text := '';
    FPrinter.ReceiptDiscount(Data);
    Receipt.CheckRececiptState;

    K := FDoc.GetPaymentTotal mod AmountStep;
    if K < AmountPrecision then
    begin
      FDoc.PaymentAdjustment(K);
    end;
  end;
end;

procedure TFuelRecFilter.BeginFiscalReceipt2(ADoc: TCustomReceipt);
begin
  FDoc := ADoc;
  FDiscountChecked := False;
end;

function TFuelRecFilter.GetLogger: ILogFile;
begin
  Result := FPrinter.Device.Context.Logger;
end;

function TFuelRecFilter.GetParams: TMalinaParams;
begin
  Result := FPrinter.Device.Context.MalinaParams;
end;

end.
