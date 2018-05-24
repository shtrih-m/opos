unit fmuFptrSetVatTable;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrSetVatTable = class(TPage)
    btnSetVatTable: TTntButton;
    btnSetVatValue: TTntButton;
    lblVatID: TTntLabel;
    edtVatID: TTntEdit;
    lblVatValue: TTntLabel;
    edtVatValue: TTntEdit;
    procedure btnSetVatValueClick(Sender: TObject);
    procedure btnSetVatTableClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmProps }

procedure TfmFptrSetVatTable.btnSetVatValueClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.SetVatValue(StrToInt(edtVatID.Text), edtVatValue.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSetVatTable.btnSetVatTableClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.SetVatTable;
  finally
    EnableButtons(True);
  end;
end;

end.
