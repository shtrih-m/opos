unit fmuMode;

interface

uses
  // VCL
  Windows, Classes, SysUtils, StdCtrls, ExtCtrls, Controls, Spin,
  // This
  ScalePage, M5ScaleTypes, TntStdCtrls;

type
  TfmMode = class(TScalePage)
    gbConnectionParams: TTntGroupBox;
    lblComPort: TTntLabel;
    lblBaudRate: TTntLabel;
    lblTimeout: TTntLabel;
    cbBaudRate: TTntComboBox;
    btnReadParameters: TTntButton;
    btnWriteParameters: TTntButton;
    gbScaleMode: TTntGroupBox;
    rbWeightMode: TRadioButton;
    rbGraduationMode: TRadioButton;
    rbDataMode: TRadioButton;
    btnReadMode: TTntButton;
    btnWriteMode: TTntButton;
    sePortNumber: TSpinEdit;
    seTimeout: TSpinEdit;
    procedure btnReadParametersClick(Sender: TObject);
    procedure btnWriteParametersClick(Sender: TObject);
    procedure btnReadModeClick(Sender: TObject);
    procedure btnWriteModeClick(Sender: TObject);
  end;

var
  fmMode: TfmMode;

implementation

{$R *.DFM}

{ TfmMode }

procedure TfmMode.btnReadParametersClick(Sender: TObject);
var
  Params: TM5Params;
begin
  EnableButtons(False);
  try
    Params.Port := sePortNumber.Value;
    Device.Check(Device.ReadParams(Params));
    cbBaudRate.ItemIndex := Params.BaudRate;
    seTimeout.Value := Params.Timeout;
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  EnableButtons(True);
end;

procedure TfmMode.btnWriteParametersClick(Sender: TObject);
var
  Params: TM5Params;
begin
  EnableButtons(False);
  try
    Params.Port := sePortNumber.Value;
    Params.BaudRate := cbBaudRate.ItemIndex;
    Params.Timeout := seTimeout.Value;
    Device.Check(Device.WriteParams(Params));
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  EnableButtons(True);
end;

procedure TfmMode.btnReadModeClick(Sender: TObject);
var
  Mode: Integer;
begin
  EnableButtons(False);
  try
    Device.Check(Device.ReadMode(Mode));
    rbWeightMode.Checked := Mode = M5SCALE_MODE_NORMAL;
    rbGraduationMode.Checked := Mode = M5SCALE_MODE_CALIBR;
    rbDataMode.Checked := Mode = M5SCALE_MODE_DATA;
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  EnableButtons(True);
end;

procedure TfmMode.btnWriteModeClick(Sender: TObject);
var
  Mode: Integer;
begin
  EnableButtons(False);
  try
    Mode := M5SCALE_MODE_NORMAL;
    if rbGraduationMode.Checked then
      Mode := M5SCALE_MODE_CALIBR;
    if rbDataMode.Checked then
      Mode := M5SCALE_MODE_DATA;
    Device.Check(Device.WriteMode(Mode));
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  EnableButtons(True);
end;

end.

