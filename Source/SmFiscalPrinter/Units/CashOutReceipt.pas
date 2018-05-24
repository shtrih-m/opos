unit CashOutReceipt;

interface

uses
  // VCL
  SysUtils, 
  // This
  CustomReceipt, OposFptr, ByteUtils, PrinterTypes, PayType,
  Opos, OposException, LogFile;

type
  { TCashOutReceipt }

  TCashOutReceipt = class(TCustomReceipt)
  private
    FTotal: Int64;
    FPayment: Int64;
    FIsVoided: Boolean;
  public
    procedure CheckTotal(Total: Currency);
    procedure PrintRecCash(Amount: Currency); override;
    procedure PrintRecVoid(const Description: WideString); override;
    procedure EndFiscalReceipt; override;
    procedure PrintRecTotal(Total, Payment: Currency;
      const Description: WideString); override;
  end;

implementation

{ TCashOutReceipt }

procedure TCashOutReceipt.CheckTotal(Total: Currency);
begin
  if Printer.CheckTotal then
  begin
    if FTotal <> Total then
    begin
      FIsVoided := True;
      State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
    end;
  end;
end;


procedure TCashOutReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: WideString);
begin
  CheckAmount(Total);
  CheckAmount(Payment);

  FPayment := FPayment + Printer.CurrencyToInt(Payment);
  if FPayment >= FTotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
end;

procedure TCashOutReceipt.PrintRecCash(Amount: Currency);
begin
  PrintPreLine;
  FTotal := FTotal + Printer.CurrencyToInt(Amount);
  PrintPostLine;
end;

procedure TCashOutReceipt.PrintRecVoid(const Description: WideString);
begin
  PrintPreLine;
  Printer.PrintTextLine(Description);
  FIsVoided := True;
  PrintPostLine;
end;

procedure TCashOutReceipt.EndFiscalReceipt;
var
  Amount: Int64;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  PrintPreLine;
  if FIsVoided then
  begin
    Printer.PrintCancelReceipt;
  end else
  begin
    Amount := Printer.ReadCashRegister(241);
    Logger.Debug('Cash in ECR: ' + IntToStr(Amount));
    if FTotal > Amount then
      Logger.Error(Format('ECR cash amount less then receipt total (%d < %d)',
        [Amount, FTotal]));

    Printer.CashOut(FTotal);
  end;
  PrintPostLine;
end;

end.
