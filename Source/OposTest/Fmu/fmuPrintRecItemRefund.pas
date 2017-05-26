unit fmuPrintRecItemRefund;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmPrintRecItemRefund = class(TPage)
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

procedure TfmPrintRecItemRefund.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecItemRefund(
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
