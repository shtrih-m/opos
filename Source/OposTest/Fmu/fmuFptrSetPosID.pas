unit fmuFptrSetPosID;

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
  TfmFptrSetPosId = class(TPage)
    btnSetPosID: TTntButton;
    lblPOSID: TTntLabel;
    edtPOSID: TTntEdit;
    lblVatValue: TTntLabel;
    edtCashierID: TTntEdit;
    procedure btnSetPosIDClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmProps }

procedure TfmFptrSetPosId.btnSetPosIDClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.SetPosID(edtPOSID.Text, edtCashierID.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
