unit CorrectionReceipt;

interface

uses
  // Opos
  OposFptr,
  // This
  CustomReceipt, PrinterTypes;

type
  { TCorrectionReceipt }

  TCorrectionReceipt = class(TCustomReceipt)
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

{ TCorrectionReceipt }

procedure TCorrectionReceipt.PrintRecCash(Amount: Currency);
begin
  PrintPreLine;
  FTotal := FTotal + Printer.CurrencyToInt(Amount);
  PrintPostLine;
end;

procedure TCorrectionReceipt.PrintRecVoid(const Description: string);
begin
  PrintPreLine;
  Printer.PrintTextLine(Description);
  FIsVoided := True;
  PrintPostLine;
end;

procedure TCorrectionReceipt.PrintRecTotal(Total: Currency; Payment: Currency;
  const Description: string);
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

procedure TCorrectionReceipt.EndFiscalReceipt;
var
  Command: TFSCorrectionReceipt;
begin
  State.CheckState(FPTR_PS_FISCAL_RECEIPT_ENDING);

  PrintPreLine;
  if FIsVoided then
  begin
    Printer.PrintCancelReceipt;
  end else
  begin
    Command.RecType := RecType;
    Command.Total := FTotal;
    Device.Check(Device.FSPrintCorrectionReceipt(Command));
  end;
  PrintPostLine;
end;

procedure TCorrectionReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  inherited;
  FTotal := 0;
  FPayment := 0;
  FIsVoided := False;
  Device.Check(Device.FSStartCorrectionReceipt);
end;

function TCorrectionReceipt.GetTotal: Int64;
begin
  Result := FTotal;
end;

end.
