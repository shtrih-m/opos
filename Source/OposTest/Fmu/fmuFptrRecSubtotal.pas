unit fmuFptrRecSubtotal;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecSubtotal = class(TPage)
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    btnPrintRecSubtotal: TTntButton;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    lblPostLine: TTntLabel;
    edtPostLine: TTntEdit;
    procedure btnPrintRecSubtotalClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecSubtotal.btnPrintRecSubtotalClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PostLine := edtPostLine.Text;
    FiscalPrinter.PrintRecSubtotal(StrToCurr(edtAmount.Text));
  finally
    EnableButtons(True);
  end;
end;

end.
