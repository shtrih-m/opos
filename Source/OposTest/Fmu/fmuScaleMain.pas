unit fmuScaleMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ActiveX, ComObj,
  // This
  untPages, OposScale;

type
  { TfmScaleMain }

  TfmScaleMain = class(TPage)
    btnDisplayText: TButton;
    lblText: TLabel;
    edtText: TEdit;
    btnReadWeight: TButton;
    lblWeightData: TLabel;
    edtWeightData: TEdit;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    btnZeroScale: TButton;
    procedure btnDisplayTextClick(Sender: TObject);
    procedure btnReadWeightClick(Sender: TObject);
    procedure btnZeroScaleClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmScaleMain.btnDisplayTextClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.DisplayText(edtText.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleMain.btnReadWeightClick(Sender: TObject);
var
  Timeout: Integer;
  pWeightData: Integer;
begin
  EnableButtons(False);
  try
    edtWeightData.Clear;
    Timeout := StrToInt(edtTimeout.Text);
    if Scale.ReadWeight(pWeightData, Timeout) = 0 then
    begin
      edtWeightData.Text := IntToStr(pWeightData);
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleMain.btnZeroScaleClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.ZeroScale;
  finally
    EnableButtons(True);
  end;
end;

end.
