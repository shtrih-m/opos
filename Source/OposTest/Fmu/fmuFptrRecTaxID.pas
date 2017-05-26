unit fmuFptrRecTaxID;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecTaxID = class(TPage)
    btnExecute: TButton;
    lblTaxID: TLabel;
    edtTaxID: TEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecTaxID.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecTaxID(edtTaxID.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
