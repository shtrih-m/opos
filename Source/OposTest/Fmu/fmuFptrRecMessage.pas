unit fmuFptrRecMessage;

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
  TfmFptrRecMessage = class(TPage)
    btnExecute: TTntButton;
    lblMessage: TTntLabel;
    edtMessage: TTntEdit;
    procedure btnExecuteClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrRecMessage.btnExecuteClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecMessage(edtMessage.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
