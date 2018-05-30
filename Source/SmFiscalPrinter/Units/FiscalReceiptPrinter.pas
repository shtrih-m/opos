unit FiscalReceiptPrinter;

interface

uses
  // VCL
  Windows, Classes,
  // This
  ReceiptPrinter, FiscalPrinterDevice, PrinterParameters, StringUtils,
  PrinterTypes, DeviceTables, MathUtils;

type
  { TFiscalReceiptPrinter }

  TFiscalReceiptPrinter = class(TReceiptPrinter, IReceiptPrinter)
  private
    function GetPrintWidth: Integer;
  public
    procedure PrintMode;
    procedure PrintZReport;
    procedure ReceiptCancel;
    function GetSubtotal: Int64;
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(Operation: TPriceReg);
    procedure Storno(Operation: TPriceReg);
    procedure RetSale(Operation: TPriceReg);
    procedure Buy(Operation: TPriceReg);
    procedure RetBuy(Operation: TPriceReg);
    function ReadCashRegister(ID: Byte): Int64;
    function ReadOperatingRegister(ID: Byte): Word;
    procedure PrintSubtotal;
    procedure PrintText2(const Text: WideString; Station, Font: Integer;
      Alignment: TTextAlignment);

    procedure ReceiptClose(Params: TCloseReceiptParams);
    procedure ReceiptDiscount(Operation: TAmountOperation);
    procedure ReceiptCharge(Operation: TAmountOperation);
    procedure ReceiptStornoDiscount(Operation: TAmountOperation);
    procedure ReceiptStornoCharge(Operation: TAmountOperation);
    function GetTables: TDeviceTables;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function GetTaxTotals(Amount: Int64): TTaxTotals;

    property PrintWidth: Integer read GetPrintWidth;
  end;

implementation

{ TFiscalReceiptPrinter }

procedure TFiscalReceiptPrinter.CashIn(Amount: Int64);
begin
  Printer.CashIn(Amount);
end;

procedure TFiscalReceiptPrinter.CashOut(Amount: Int64);
begin
  Printer.CashOut(Amount);
end;

function TFiscalReceiptPrinter.GetSubtotal: Int64;
begin
  Result := 0;
  if Device.IsRecOpened then
    Result := Device.GetSubtotal;
end;

procedure TFiscalReceiptPrinter.PrintZReport;
begin
  Printer.PrintZReport;
end;

procedure TFiscalReceiptPrinter.ReceiptCancel;
begin
  Printer.ReceiptCancel;
end;

procedure TFiscalReceiptPrinter.ReceiptClose(Params: TCloseReceiptParams);
begin
  Printer.ReceiptClose(Params);
end;

procedure TFiscalReceiptPrinter.Sale(Operation: TPriceReg);
begin
  Printer.Sale(Operation);
end;

procedure TFiscalReceiptPrinter.Buy(Operation: TPriceReg);
begin
  Printer.Buy(Operation);
end;

procedure TFiscalReceiptPrinter.RetBuy(Operation: TPriceReg);
begin
  Printer.RetBuy(Operation);
end;

procedure TFiscalReceiptPrinter.ReceiptDiscount(Operation: TAmountOperation);
begin
  Printer.ReceiptDiscount(Operation);
end;

procedure TFiscalReceiptPrinter.ReceiptCharge(Operation: TAmountOperation);
begin
  Printer.ReceiptCharge(Operation);
end;

procedure TFiscalReceiptPrinter.RetSale(Operation: TPriceReg);
begin
  Printer.RetSale(Operation);
end;

procedure TFiscalReceiptPrinter.Storno(Operation: TPriceReg);
begin
  Printer.Storno(Operation);
end;

procedure TFiscalReceiptPrinter.ReceiptStornoDiscount(
  Operation: TAmountOperation);
begin
  Printer.ReceiptStornoDiscount(Operation);
end;

procedure TFiscalReceiptPrinter.ReceiptStornoCharge(Operation: TAmountOperation);
begin
  Printer.ReceiptStornoCharge(Operation);
end;

procedure TFiscalReceiptPrinter.PrintMode;
begin
  // only in training mode prints 'Training mode' line
end;

procedure TFiscalReceiptPrinter.PrintSubtotal;
begin
  if IsReceiptOpened then
    Printer.PrintSubtotal(GetSubtotal);
end;

function TFiscalReceiptPrinter.ReadCashRegister(ID: Byte): Int64;
begin
  Result := Device.ReadCashReg2(ID);
end;

function TFiscalReceiptPrinter.ReadOperatingRegister(ID: Byte): Word;
begin
  Result := Device.ReadOperatingRegister(ID);
end;

procedure TFiscalReceiptPrinter.PrintText2(const Text: WideString; Station,
  Font: Integer; Alignment: TTextAlignment);
var
  Data: TTextRec;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Font;
  Data.Alignment := Alignment;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

function TFiscalReceiptPrinter.GetPrintWidth: Integer;
begin
  Result := Device.GetPrintWidth;
end;

function TFiscalReceiptPrinter.GetTables: TDeviceTables;
begin
  Result := Device.Tables;
end;

function TFiscalReceiptPrinter.OpenReceipt(ReceiptType: Byte): Integer;
begin
  Result := Device.OpenReceipt(ReceiptType);
end;

function TFiscalReceiptPrinter.GetTaxTotals(Amount: Int64): TTaxTotals;
var
  i: Integer;
  RecType: Integer;
  NoTaxSumm: Int64;
  ReceiptTotal: Int64;
  TotalizerID: Integer;
  TaxSumm: array [0..3] of Int64;
begin
  for i := Low(Result) to High(Result) do
  begin
    Result[i] := 0;
  end;
  ReceiptTotal := GetSubtotal;
  if ReceiptTotal = 0 then Exit;
  RecType := Device.ReadPrinterStatus.Mode shr 4;
  // Get taxes turnovers
  for i := 0 to 3 do
  begin
    TotalizerID := 88 + RecType + i*4;
    TaxSumm[i] := ReadCashRegister(TotalizerID);
  end;
  // Compute registration totals by tax groups
  NoTaxSumm := Amount;
  for i := 0 to 3 do
  begin
    Result[i+1] := 0;
    if TaxSumm[i] <> 0 then
    begin
      Result[i+1] := Round2(Amount * TaxSumm[i]/ReceiptTotal);
      NoTaxSumm := NoTaxSumm - Result[i+1];
    end;
  end;
  while (NoTaxSumm < 0) do
  begin
    for i := 1 to 3 do
    begin
      if Result[i] <> 0 then
      begin
        Result[i] := Result[i] -1;
        NoTaxSumm := NoTaxSumm + 1;
        if NoTaxSumm = 0 then Break;
      end;
    end;
  end;
  Result[0] := NoTaxSumm;
end;


end.
