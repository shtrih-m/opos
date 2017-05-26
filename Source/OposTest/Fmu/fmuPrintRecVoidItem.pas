unit fmuPrintRecVoidItem;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmPrintRecVoidItem = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblAmount: TLabel;
    edtAmount: TEdit;
    lblQuantity: TLabel;
    edtQuantity: TEdit;
    lblVatInfo: TLabel;
    edtVatInfo: TEdit;
    lblAdjustmentType: TLabel;
    edtAdjustmentType: TEdit;
    lblAdjustment: TLabel;
    edtAdjustment: TEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmPrintRecVoidItem.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecVoidItem(
    	edtDescription.Text,
      StrToCurr(edtAmount.Text),
      StrToInt(edtQuantity.Text),
      StrToInt(edtAdjustmentType.Text),
      StrToCurr(edtAdjustment.Text),
      StrToInt(edtVatInfo.Text));
  finally
    EnableButtons(True);
  end;
end;

end.
