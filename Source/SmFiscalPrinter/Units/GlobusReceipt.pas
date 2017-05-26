unit GlobusReceipt;

interface

uses
  // This
  SalesReceipt, DirectIOAPI, PrinterTypes, FiscalPrinterTypes;

type
  { TGlobusReceipt }

  TGlobusReceipt = class(TSalesReceipt)
  private
    procedure PrintSeparator;
  public
    procedure BeginFiscalReceipt(PrintHeader: Boolean); override;
    procedure EndFiscalReceipt; override;
    procedure PrintNormal(const Text: string; Station: Integer); override;
  end;

implementation

{ TGlobusReceipt }

procedure TGlobusReceipt.PrintSeparator;
var
  Separator: string;
begin
  Separator := StringOfChar('-', Printer.PrintWidth);
  Printer.PrintTextLine(Separator);
(*
  Printer.PrintSeparator(DIO_SEPARATOR_WHITE, 5);
  Printer.PrintSeparator(DIO_SEPARATOR_BLACK, 3);
  Printer.PrintSeparator(DIO_SEPARATOR_WHITE, 5);
*)
end;

procedure TGlobusReceipt.BeginFiscalReceipt(PrintHeader: Boolean);
begin
  PrintSeparator;
  inherited BeginFiscalReceipt(PrintHeader);
end;

procedure TGlobusReceipt.EndFiscalReceipt;
begin
  PrintSeparator;
  inherited EndFiscalReceipt;
end;

procedure TGlobusReceipt.PrintNormal(const Text: string; Station: Integer);
begin
  Printer.PrintText2(Text, Station, PRINTER_STATION_REC, taLeft);
end;


end.
