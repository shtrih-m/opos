unit fmuFptrRecItemAdjust;

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
  TfmFptrRecItemAdjust = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblAdjustmentType: TTntLabel;
    edtAdjustmentType: TTntEdit;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    lblVatInfo: TTntLabel;
    edtVatInfo: TTntEdit;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    cbAdjustmentType: TTntComboBox;
    Label1: TTntLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure cbAdjustmentTypeChange(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecItemAdjust.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PrintRecItemAdjustment(
      StrToInt(edtAdjustmentType.Text),
      edtDescription.Text,
      StrToCurr(edtAmount.Text),
      StrToInt(edtVatInfo.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrRecItemAdjust.cbAdjustmentTypeChange(Sender: TObject);
begin
  edtAdjustmentType.Text := IntToStr(cbAdjustmentType.ItemIndex + 1);
end;

end.
