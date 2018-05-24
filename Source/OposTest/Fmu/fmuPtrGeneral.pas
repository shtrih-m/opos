unit fmuPtrGeneral;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, Opos, OposUtils, OposPosPrinter;

type
  TfmPtrGeneral = class(TPage)
    lblDeviceName: TTntLabel;
    btnOpen: TTntButton;
    btnClose: TTntButton;
    btnRelease: TTntButton;
    btnClaim: TTntButton;
    edtTimeout: TTntEdit;
    lblTimeout: TTntLabel;
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
    chbDeviceEnabled: TTntCheckBox;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnClaimClick(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnUpdatePrinterDeviceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCheckHealthClick(Sender: TObject);
    procedure chbDeviceEnabledClick(Sender: TObject);
  private
    procedure LoadPrinterDevices;
  end;

implementation

{$R *.DFM}

procedure TfmPtrGeneral.LoadPrinterDevices;
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS;
    if Reg.OpenKey('SOFTWARE\OLEforRetail\ServiceOPOS\PosPrinter', False) then
      Reg.GetKeyNames(cbPrinterDeviceName.Items);
    if cbPrinterDeviceName.Items.Count > 0 then
      cbPrinterDeviceName.ItemIndex := 0;
  finally
    Reg.Free;
  end;
end;

procedure TfmPtrGeneral.btnOpenClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    PosPrinter.Open(cbPrinterDeviceName.Text);
    edtOpenResult.Text := GetResultCodeText(PosPrinter.OpenResult);
    PosPrinter.PowerNotify := OPOS_PN_ENABLED;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmPtrGeneral.btnCloseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    PosPrinter.Close;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmPtrGeneral.btnClaimClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    PosPrinter.ClaimDevice(StrToInt(edtTimeout.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmPtrGeneral.btnReleaseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    PosPrinter.ReleaseDevice;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmPtrGeneral.btnUpdatePrinterDeviceClick(Sender: TObject);
begin
  LoadPrinterDevices;
end;

procedure TfmPtrGeneral.FormCreate(Sender: TObject);
begin
  LoadPrinterDevices;
  cbLevel.ItemIndex := 0;
end;

procedure TfmPtrGeneral.btnCheckHealthClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    PosPrinter.CheckHealth(cbLevel.ItemIndex + 1);
    CheckHealthText.Text := PosPrinter.CheckHealthText;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmPtrGeneral.chbDeviceEnabledClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    PosPrinter.DeviceEnabled := chbDeviceEnabled.Checked;
  finally
    EnableButtons(True);
  end;
end;

end.
