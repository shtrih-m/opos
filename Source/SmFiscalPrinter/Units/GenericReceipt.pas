unit GenericReceipt;

interface

uses
  // This
  CustomReceipt, OposFptr;

type
  { TGenericReceipt }

  TGenericReceipt = class(TCustomReceipt)
  public
    procedure EndFiscalReceipt; override;
    procedure BeginFiscalReceipt(PrintHeader: Boolean); override;
  end;

implementation

const
  GenericRecNumber: Integer = 1;

{ TGenericReceipt }

procedure TGenericReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  inherited BeginFiscalReceipt(PrintHeader);
  Printer.PrintDocHeader('GENERIC', GenericRecNumber);
  Inc(GenericRecNumber);
  Printer.WaitForPrinting;
end;

procedure TGenericReceipt.EndFiscalReceipt;
begin
  Printer.PrintDocHeaderEnd;
end;

end.
