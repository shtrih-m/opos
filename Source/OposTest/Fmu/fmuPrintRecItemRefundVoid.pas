unit fmuPrintRecItemRefundVoid;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmPrintRecItemRefundVoid = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblAmount: TLabel;
    edtAmount: TEdit;
    lblQuantity: TLabel;
    edtQuantity: TEdit;
    lblVatInfo: TLabel;
    edtVatInfo: TEdit;
    lblUnitAmount: TLabel;
    edtUnitAmount: TEdit;
    lblUnitName: TLabel;
    edtUnitName: TEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmPrintRecItemRefundVoid.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecItemRefundVoid(
    	edtDescription.Text,
      StrToCurr(edtAmount.Text),
      StrToInt(edtQuantity.Text),
      StrToInt(edtVatInfo.Text),
      StrToCurr(edtUnitAmount.Text),
      edtUnitName.Text,
      );
  finally
    EnableButtons(True);
  end;
end;

end.
