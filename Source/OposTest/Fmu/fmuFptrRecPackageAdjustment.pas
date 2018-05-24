unit fmuFptrRecPackageAdjustment;

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
  TfmFptrRecPackageAdjustment = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblAdjustmentType: TTntLabel;
    edtAdjustmentType: TTntEdit;
    lblVatAdjustment: TTntLabel;
    edtVatAdjustment: TTntEdit;
    cbAdjustmentType: TTntComboBox;
    Label1: TTntLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAdjustmentTypeChange(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecPackageAdjustment.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecPackageAdjustment(StrToInt(edtAdjustmentType.Text),
      edtDescription.Text, edtVatAdjustment.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrRecPackageAdjustment.FormCreate(Sender: TObject);
begin
  cbAdjustmentType.ItemIndex := 0;
end;

procedure TfmFptrRecPackageAdjustment.cbAdjustmentTypeChange(Sender: TObject);
begin
  edtAdjustmentType.Text := IntToStr(cbAdjustmentType.ItemIndex + 1);
end;

end.
