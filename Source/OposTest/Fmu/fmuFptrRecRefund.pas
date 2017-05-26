unit fmuFptrRecRefund;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecRefund = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblAmount: TLabel;
    edtAmount: TEdit;
    lblVatInfo: TLabel;
    edtVatInfo: TEdit;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
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
