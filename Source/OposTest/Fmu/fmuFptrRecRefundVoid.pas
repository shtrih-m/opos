unit fmuFptrRecRefundVoid;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecRefundVoid = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblAmount: TLabel;
    edtAmount: TEdit;
    lblVatInfo: TLabel;
    edtVatInfo: TEdit;
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
