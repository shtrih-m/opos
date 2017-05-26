unit fmuFptrRecTotal;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecTotal = class(TPage)
    btnExecute: TButton;
    lblTotal: TLabel;
    edtTotal: TEdit;
    lblPayment: TLabel;
    edtPayment: TEdit;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
    lblPostLine: TLabel;
    edtPostLine: TEdit;
    chbCheckTotal: TCheckBox;
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
