unit fmuFptrRecSubtotalAdjustVoid;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecSubtotalAdjustVoid = class(TPage)
    btnExecute: TButton;
    lblAmount: TLabel;
    edtAmount: TEdit;
    cbAdjustmentType: TComboBox;
    lblPreLine: TLabel;
    edtPreLine: TEdit;
    Label1: TLabel;
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecSubtotalAdjustVoid.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PreLine := edtPreLine.Text;
    FiscalPrinter.PrintRecSubtotalAdjustVoid(
      cbAdjustmentType.ItemIndex + 1,
      StrToCurr(edtAmount.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrRecSubtotalAdjustVoid.FormCreate(Sender: TObject);
begin
  cbAdjustmentType.ItemIndex := 0;
end;

end.
