unit fmuFptrRecRefund;

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
  TfmFptrRecRefund = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    lblVatInfo: TTntLabel;
    edtVatInfo: TTntEdit;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecRefund.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PrintRecRefund(edtDescription.Text,
      StrToCurr(edtAmount.Text), StrToInt(edtVatInfo.Text));
  finally
    EnableButtons(True);
  end;
end;

end.
