unit fmuFptrRecTotal;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecTotal = class(TPage)
    btnExecute: TTntButton;
    lblTotal: TTntLabel;
    edtTotal: TTntEdit;
    lblPayment: TTntLabel;
    edtPayment: TTntEdit;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    lblPostLine: TTntLabel;
    edtPostLine: TTntEdit;
    chbCheckTotal: TTntCheckBox;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecTotal.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.CheckTotal := chbCheckTotal.Checked;
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PostLine := edtPostLine.Text;
    FiscalPrinter.PrintRecTotal(
      StrToCurr(edtTotal.Text),
      StrToCurr(edtPayment.Text),
      edtDescription.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
