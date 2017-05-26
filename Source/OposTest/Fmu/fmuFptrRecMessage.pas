unit fmuFptrRecMessage;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrRecMessage = class(TPage)
    btnExecute: TButton;
    lblMessage: TLabel;
    edtMessage: TEdit;
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
