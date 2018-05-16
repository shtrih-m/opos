unit CorrectionReceipt2;

interface

uses
  // Opos
  OposFptr,
  // This
  CustomReceipt, PrinterTypes;

type
  { TCorrectionReceipt2 }

  TCorrectionReceipt2 = class(TCustomReceipt)
  private
    FTotal: Int64;
    FPayment: Int64;
    FIsVoided: Boolean;
  public
    function GetTotal: Int64; override;
    procedure BeginFiscalReceipt(PrintHeader: Boolean); override;
    procedure PrintRecCash(Amount: Currency); override;
    procedure PrintRecVoid(const Description: string); override;
    procedure EndFiscalReceipt; override;
    procedure PrintRecTotal(Total, Payment: Currency;
      const Description: string); override;
  end;

implementation

{ TCorrectionReceipt2 }

procedure TCorrectionReceipt2.PrintRecCash(Amount: Currency);
begin
  PrintPreLine;
  FTotal := FTotal + Printer.CurrencyToInt(Amount);
  PrintPostLine;
end;

procedure TCorrectionReceipt2.PrintRecVoid(const Description: string);
begin
  PrintPreLine;
  Printer.PrintTextLine(Description);
  FIsVoided := True;
  PrintPostLine;
end;

function TCorrectionReceipt2.GetTotal: Int64;
begin
  Result := FTotal +
    Parameters.Amount1 +
    Parameters.Amount2 +
    Parameters.Amount3 +
    Parameters.Amount4 +
    Parameters.Amount5 +
    Parameters.Amount6 +
    Parameters.Amount7 +
    Parameters.Amount8 +
    Parameters.Amount9 +
    Parameters.Amount10 +
    Parameters.Amount11 +
    Parameters.Amount12;
end;

procedure TCorrectionReceipt2.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: string);
begin
  CheckAmount(Total);
  CheckAmount(Payment);
  PrintPreLine;
  FPayment := FPayment + Printer.CurrencyToInt(Payment);
  if FPayment >= GetTotal then
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_ENDING);
  end else
  begin
    State.SetState(FPTR_PS_FISCAL_RECEIPT_TOTAL);
  end;
  PrintPostLine;
end;

procedure TCorrectionReceipt2.EndFiscalReceipt;
var
  Command: TFSCorrectionReceipt2;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);

  PrintPreLine;
  if FIsVoided then
  begin
    Printer.PrintCancelReceipt;
  end else
  begin
    Command.CorrectionType := Parameters.CorrectionType;
    Command.CalculationSign := Parameters.CalculationSign;
    Command.Amount1 := FTotal;
    Command.Amount2 := Parameters.Amount2;
    Command.Amount3 := Parameters.Amount3;
    Command.Amount4 := Parameters.Amount4;
    Command.Amount5 := Parameters.Amount5;
    Command.Amount6 := Parameters.Amount6;
    Command.Amount7 := Parameters.Amount7;
    Command.Amount8 := Parameters.Amount8;
    Command.Amount9 := Parameters.Amount9;
    Command.Amount10 := Parameters.Amount10;
    Command.Amount11 := Parameters.Amount11;
    Command.Amount12 := Parameters.Amount12;
    Command.TaxType := Parameters.TaxType;
    Device.Check(Device.FSPrinTCorrectionReceipt2(Command));
  end;
  PrintPostLine;
end;

procedure TCorrectionReceipt2.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  inherited;
  FTotal := 0;
  FPayment := 0;
  FIsVoided := False;

  Parameters.CorrectionType := 0;
  Parameters.CalculationSign := 0;
  Parameters.Amount1 := 0;
  Parameters.Amount2 := 0;
  Parameters.Amount3 := 0;
  Parameters.Amount4 := 0;
  Parameters.Amount5 := 0;
  Parameters.Amount6 := 0;
  Parameters.Amount7 := 0;
  Parameters.Amount8 := 0;
  Parameters.Amount9 := 0;
  Parameters.Amount10 := 0;
  Parameters.Amount11 := 0;
  Parameters.Amount12 := 0;
  Parameters.TaxType := 0;

  Device.Check(Device.FSStartCorrectionReceipt);
end;

end.
