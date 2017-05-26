unit fmuCashWait;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Forms, SysUtils,
  Registry, ComCtrls, Graphics,
  // This
  untPages, OposCashDrawer;

type
  { TfmCashWait }

  TfmCashWait = class(TPage)
    lblBeepTimeout: TLabel;
    edtbeepTimeout: TEdit;
    edtbeepFrequency: TEdit;
    edtbeepDuration: TEdit;
    edtbeepDelay: TEdit;
    lblbeepDelay: TLabel;
    lblbeepDuration: TLabel;
    lblbeepFrequency: TLabel;
    btnWaitForDrawerClose: TButton;
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
