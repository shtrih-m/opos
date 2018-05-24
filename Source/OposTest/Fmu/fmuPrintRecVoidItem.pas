unit fmuPrintRecVoidItem;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposFiscalPrinter;

type
  TfmPrintRecVoidItem = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    lblQuantity: TTntLabel;
    edtQuantity: TTntEdit;
    lblVatInfo: TTntLabel;
    edtVatInfo: TTntEdit;
    lblAdjustmentType: TTntLabel;
    edtAdjustmentType: TTntEdit;
    lblAdjustment: TTntLabel;
    edtAdjustment: TTntEdit;
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
