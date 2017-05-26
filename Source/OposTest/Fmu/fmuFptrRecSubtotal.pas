unit fmuFptrRecSubtotal;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecSubtotal = class(TPage)
    lblAmount: TLabel;
    edtAmount: TEdit;
    btnPrintRecSubtotal: TButton;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
    lblPostLine: TLabel;
    edtPostLine: TEdit;
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
