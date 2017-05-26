unit fmuFptrRecPackageAdjustment;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecPackageAdjustment = class(TPage)
    btnExecute: TButton;
    lblDescription: TLabel;
    edtDescription: TEdit;
    lblAdjustmentType: TLabel;
    edtAdjustmentType: TEdit;
    lblVatAdjustment: TLabel;
    edtVatAdjustment: TEdit;
    cbAdjustmentType: TComboBox;
    Label1: TLabel;
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
