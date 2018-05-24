unit fmuFptrRecSubtotalAdjustment;

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
  TfmFptrRecSubtotalAdjustment = class(TPage)
    btnExecute: TTntButton;
    lblDescription: TTntLabel;
    edtDescription: TTntEdit;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    cbAdjustmentType: TTntComboBox;
    Label1: TTntLabel;
    lblPreLine: TTntLabel;
    edtPreLine: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmSTAdt }

procedure TfmFptrRecSubtotalAdjustment.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PrintRecSubtotalAdjustment(
      cbAdjustmentType.ItemIndex + 1,
      edtDescription.Text,
      StrToCurr(edtAmount.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrRecSubtotalAdjustment.FormCreate(Sender: TObject);
begin
  cbAdjustmentType.ItemIndex := 0;
end;

end.
