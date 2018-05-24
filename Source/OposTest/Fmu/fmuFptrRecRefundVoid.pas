unit fmuFptrRecRefundVoid;

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
  TfmFptrRecRefundVoid = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    lblVatInfo: TTntLabel;
    edtVatInfo: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecRefundVoid.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecRefundVoid(edtDescription.Text,
      StrToCurr(edtAmount.Text), StrToInt(edtVatInfo.Text));
  finally
    EnableButtons(True);
  end;
end;

end.
