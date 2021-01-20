unit fmuFptrGeneral;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, Opos, Oposhi, OposUtils, OposFiscalPrinter, OposDevice;

type
  TfmFptrGeneral = class(TPage)
    lblDeviceName: TTntLabel;
    btnOpen: TTntButton;
    btnClose: TTntButton;
    btnRelease: TTntButton;
    btnClaim: TTntButton;
    edtTimeout: TTntEdit;
    lblTimeout: TTntLabel;
    btnClearError: TTntButton;
    btnResetPrinter: TTntButton;
    lblOpenResult: TTntLabel;
    edtOpenResult: TTntEdit;
    btnUpdatePrinterDevice: TTntButton;
    cbPrinterDeviceName: TTntComboBox;
    lblLevel: TTntLabel;
    lblCheckHealthText: TTntLabel;
    cbLevel: TTntComboBox;
    btnCheckHealth: TTntButton;
    CheckHealthText: TTntMemo;
    Bevel1: TBevel;
    lblDeviceEnabled: TTntLabel;
    edtDeviceEnabled: TTntEdit;
    btnEnable: TTntButton;
    btnDisable: TTntButton;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnClaimClick(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnClearErrorClick(Sender: TObject);
    procedure btnResetPrinterClick(Sender: TObject);
    procedure btnUpdatePrinterDeviceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCheckHealthClick(Sender: TObject);
    procedure btnEnableClick(Sender: TObject);
    procedure btnDisableClick(Sender: TObject);
  private
    procedure LoadPrinterDevices;
    procedure UpdateDeviceEnabled;
  end;

implementation

{$R *.DFM}

{ TfmFptrGeneral }

procedure TfmFptrGeneral.UpdateDeviceEnabled;
begin
  edtDeviceEnabled.Text := BoolToStr(FiscalPrinter.DeviceEnabled, True);
end;

procedure TfmFptrGeneral.LoadPrinterDevices;
var
  Device: TOposDevice;
begin
  Device := TOposDevice.Create(nil, OPOS_CLASSKEY_FPTR, OPOS_CLASSKEY_FPTR,
    FiscalPrinterProgID);
  try
    Device.GetDeviceNames(cbPrinterDeviceName.Items);
    if cbPrinterDeviceName.Items.Count > 0 then
      cbPrinterDeviceName.ItemIndex := 0;
  finally
    Device.Free;
  end;
end;

procedure TfmFptrGeneral.btnOpenClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.Open(cbPrinterDeviceName.Text);

    edtOpenResult.Text := GetResultCodeText(FiscalPrinter.OpenResult);
    UpdateDeviceEnabled;

    FiscalPrinter.PowerNotify := OPOS_PN_ENABLED;
    FiscalPrinter.CheckTotal := False;

    FiscalPrinter.AdditionalHeader :=
      '  AdditionalHeader, line 1 ' + #13#10 +
      '  AdditionalHeader, line 2 ';

    FiscalPrinter.AdditionalTrailer :=
      '  AdditionalTrailer, line 1 ' + #13#10 +
      '  AdditionalTrailer, line 2 ';
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnCloseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.Close;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnClaimClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ClaimDevice(StrToInt(edtTimeout.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnReleaseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ReleaseDevice;
    UpdateDeviceEnabled;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnClearErrorClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ClearError;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnResetPrinterClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetPrinter;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnUpdatePrinterDeviceClick(Sender: TObject);
begin
  LoadPrinterDevices;
end;

procedure TfmFptrGeneral.FormCreate(Sender: TObject);
begin
  LoadPrinterDevices;
  if cbLevel.Items.Count > 0 then
    cbLevel.ItemIndex := 0;
end;

procedure TfmFptrGeneral.btnCheckHealthClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.CheckHealth(cbLevel.ItemIndex + 1);
    CheckHealthText.Text := FiscalPrinter.CheckHealthText;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnEnableClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.DeviceEnabled := True;
    UpdateDeviceEnabled;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrGeneral.btnDisableClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.DeviceEnabled := False;
    UpdateDeviceEnabled;
  finally
    EnableButtons(True);
  end;
end;

end.
