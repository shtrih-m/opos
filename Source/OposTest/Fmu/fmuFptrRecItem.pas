unit fmuFptrRecItem;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecItem = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblPrice: TLabel;
    edtPrice: TEdit;
    lblQuantity: TLabel;
    edtQuantity: TEdit;
    lblVatInfo: TLabel;
    edtVatInfo: TEdit;
    lblUnitPrice: TLabel;
    edtUnitPrice: TEdit;
    lblUnitName: TLabel;
    edtUnitName: TEdit;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
    lblPostLine: TLabel;
    edtPostLine: TEdit;
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
