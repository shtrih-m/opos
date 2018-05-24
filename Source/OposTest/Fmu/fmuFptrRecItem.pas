unit fmuFptrRecItem;

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
  TfmFptrRecItem = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblPrice: TTntLabel;
    edtPrice: TTntEdit;
    lblQuantity: TTntLabel;
    edtQuantity: TTntEdit;
    lblVatInfo: TTntLabel;
    edtVatInfo: TTntEdit;
    lblUnitPrice: TTntLabel;
    edtUnitPrice: TTntEdit;
    lblUnitName: TTntLabel;
    edtUnitName: TTntEdit;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    lblPostLine: TTntLabel;
    edtPostLine: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecItem.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PostLine := edtPostLine.Text;
    FiscalPrinter.PrintRecItem(
      edtDescription.Text,
      StrToCurr(edtPrice.Text),
      StrToInt(edtQuantity.Text),
      StrToInt(edtVatInfo.Text),
      StrToCurr(edtUnitPrice.Text),
      edtUnitName.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
