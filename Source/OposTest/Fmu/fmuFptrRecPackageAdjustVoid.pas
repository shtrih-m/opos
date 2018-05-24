unit fmuFptrRecPackageAdjustVoid;

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
  { TfmPAVoid }
  
  TfmFptrRecPackageAdjustVoid = class(TPage)
    btnExecute: TTntButton;
    lblAdjustmentType: TTntLabel;
    edtAdjustmentType: TTntEdit;
    lblVatAdjustment: TTntLabel;
    edtVatAdjustment: TTntEdit;
    cbAdjustmentType: TTntComboBox;
    Label1: TTntLabel;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbAdjustmentTypeChange(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecPackageAdjustVoid.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PrintRecPackageAdjustVoid(StrToInt(edtAdjustmentType.Text),
      edtVatAdjustment.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrRecPackageAdjustVoid.FormCreate(Sender: TObject);
begin
  cbAdjustmentType.ItemIndex := 0;
end;

procedure TfmFptrRecPackageAdjustVoid.cbAdjustmentTypeChange(Sender: TObject);
begin
  edtAdjustmentType.Text := IntToStr(cbAdjustmentType.ItemIndex + 1);
end;

end.
