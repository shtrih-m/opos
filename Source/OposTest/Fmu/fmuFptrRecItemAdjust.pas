unit fmuFptrRecItemAdjust;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecItemAdjust = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblAdjustmentType: TLabel;
    edtAdjustmentType: TEdit;
    lblAmount: TLabel;
    edtAmount: TEdit;
    lblVatInfo: TLabel;
    edtVatInfo: TEdit;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
    cbAdjustmentType: TComboBox;
    Label1: TLabel;
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
