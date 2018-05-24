unit fmuFptrRecCash;

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
  TfmFptrRecCash = class(TPage)
    btnPrintRecCash: TTntButton;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    procedure btnPrintRecCashClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecCash.btnPrintRecCashClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecCash(StrToCurr(edtAmount.Text));
  finally
    EnableButtons(True);
  end;
end;

end.
