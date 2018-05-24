unit CashInReceipt;

interface

uses
  // This
  CustomReceipt, OposFptr, ByteUtils, PrinterTypes, PayType,
  Opos, OposException;

type
  { TCashInReceipt }

  TCashInReceipt = class(TCustomReceipt)
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

{ TCashInReceipt }

procedure TCashInReceipt.PrintRecCash(Amount: Currency);
begin
  PrintPreLine;
  FTotal := FTotal + Printer.CurrencyToInt(Amount);
  PrintPostLine;
end;

procedure TCashInReceipt.PrintRecVoid(const Description: WideString);
begin
  PrintPreLine;
  Printer.PrintTextLine(Description);
  FIsVoided := True;
  PrintPostLine;
end;

procedure TCashInReceipt.CheckTotal(Total: Currency);
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

procedure TCashInReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: WideString);
begin
  CheckAmount(Total);
  CheckAmount(Payment);
  PrintPreLine;
  FPayment := FPayment + Printer.CurrencyToInt(Payment);
  if FPayment >= FTotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
  PrintPostLine;
end;

procedure TCashInReceipt.EndFiscalReceipt;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);

  PrintPreLine;
  if FIsVoided then
  begin
    Printer.PrintCancelReceipt;
  end else
  begin
    Printer.CashIn(FTotal);
  end;
  PrintPostLine;
end;

end.
