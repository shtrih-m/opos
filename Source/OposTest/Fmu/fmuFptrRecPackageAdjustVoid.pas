unit fmuFptrRecPackageAdjustVoid;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  { TfmPAVoid }
  
  TfmFptrRecPackageAdjustVoid = class(TPage)
    btnExecute: TButton;
    lblAdjustmentType: TLabel;
    edtAdjustmentType: TEdit;
    lblVatAdjustment: TLabel;
    edtVatAdjustment: TEdit;
    cbAdjustmentType: TComboBox;
    Label1: TLabel;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
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
