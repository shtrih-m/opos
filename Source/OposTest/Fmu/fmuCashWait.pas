unit fmuCashWait;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Forms, SysUtils,
  Registry, ComCtrls, Graphics,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposCashDrawer;

type
  { TfmCashWait }

  TfmCashWait = class(TPage)
    lblBeepTimeout: TTntLabel;
    edtbeepTimeout: TTntEdit;
    edtbeepFrequency: TTntEdit;
    edtbeepDuration: TTntEdit;
    edtbeepDelay: TTntEdit;
    lblbeepDelay: TTntLabel;
    lblbeepDuration: TTntLabel;
    lblbeepFrequency: TTntLabel;
    btnWaitForDrawerClose: TTntButton;
    procedure btnWaitForDrawerCloseClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmCashWait }

procedure TfmCashWait.btnWaitForDrawerCloseClick(Sender: TObject);
var
  BeepDelay: Integer;
  BeepTimeout: Integer;
  BeepDuration: Integer;
  BeepFrequency: Integer;
begin
  EnableButtons(False);
  try
    BeepDelay := StrToInt(edtBeepDelay.Text);
    BeepTimeout := StrToInt(edtBeepTimeout.Text);
    BeepFrequency := StrToInt(edtBeepFrequency.Text);
    BeepDuration := StrToInt(edtBeepDuration.Text);

    CashDrawer.waitForDrawerClose(BeepTimeout, BeepFrequency, BeepDuration,
      BeepDelay);
  finally
    EnableButtons(True);
  end;
end;

end.
