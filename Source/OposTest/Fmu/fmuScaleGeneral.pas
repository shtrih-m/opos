unit fmuScaleGeneral;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls,
  // Opos
  Opos, OposUtils, OposScale, OposScalUtils,
  // This
  untPages, BStdUtil;

type
  TfmScaleGeneral = class(TPage)
    lblDeviceName: TLabel;
    btnOpen: TButton;
    btnClose: TButton;
    btnRelease: TButton;
    btnClaim: TButton;
    edtTimeout: TEdit;
    lblTimeout: TLabel;
    lblOpenResult: TLabel;
    edtOpenResult: TEdit;
    btnUpdateDevices: TButton;
    cbDeviceName: TComboBox;
    chbDeviceEnabled: TCheckBox;
    chbFreezeEvents: TCheckBox;
    chbAsyncMode: TCheckBox;
    chbAutoDisable: TCheckBox;
    chbDataEventEnabled: TCheckBox;
    Bevel2: TBevel;
    lblPowerNotify: TLabel;
    cbPowerNotify: TComboBox;
    lblStatusNotify: TLabel;
    cbStatusNotify: TComboBox;
    lblTareWeight: TLabel;
    edtTareWeight: TEdit;
    btnSetTareWeight: TButton;
    lblUnitPrice: TLabel;
    edtUnitPrice: TEdit;
    btnSetUnitPrice: TButton;
    btnUpdatePage: TButton;
    chbZeroValid: TCheckBox;
    memEvents: TMemo;
    btnClearEvents: TButton;
    Bevel1: TBevel;
    lblText: TLabel;
    lblWeightData: TLabel;
    Label1: TLabel;
    btnDisplayText: TButton;
    edtScaleText: TEdit;
    btnReadWeight: TButton;
    edtWeightData: TEdit;
    edtReadWeightTimeout: TEdit;
    btnZeroScale: TButton;
    Label2: TLabel;
    lblLiveWeight: TLabel;
    edtLiveWeight: TEdit;
    Timer: TTimer;
    lblSalesPrice: TLabel;
    edtSalesPrice: TEdit;
    chbLiveWeightUpdate: TCheckBox;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnClaimClick(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnUpdateDevicesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbDeviceEnabledClick(Sender: TObject);
    procedure chbAutoDisableClick(Sender: TObject);
    procedure chbDataEventEnabledClick(Sender: TObject);
    procedure chbFreezeEventsClick(Sender: TObject);
    procedure chbAsyncModeClick(Sender: TObject);
    procedure cbPowerNotifyChange(Sender: TObject);
    procedure cbStatusNotifyChange(Sender: TObject);
    procedure btnSetTareWeightClick(Sender: TObject);
    procedure btnSetUnitPriceClick(Sender: TObject);
    procedure btnUpdatePageClick(Sender: TObject);
    procedure btnReadWeightClick(Sender: TObject);
    procedure btnZeroScaleClick(Sender: TObject);
    procedure btnDisplayTextClick(Sender: TObject);
    procedure chbZeroValidClick(Sender: TObject);
    procedure btnClearEventsClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure chbLiveWeightUpdateClick(Sender: TObject);
  private
    procedure UpdateDevices;
  public
    procedure UpdatePage; override;

    procedure DataEvent(ASender: TObject; Status: Integer);
    procedure StatusUpdateEvent(Sender: TObject; Data: Integer);
    procedure DirectIOEvent(Sender: TObject; EventNumber: Integer;
      var pData: Integer; var pString: WideString);
    procedure ErrorEvent(Sender: TObject; ResultCode: Integer;
      ResultCodeExtended: Integer; ErrorLocus: Integer;
      var pErrorResponse: Integer);
  end;

implementation

{$R *.DFM}

function AmountToStr(Value: Double): string;
begin
  Result := Format('%.2f', [Value]);
end;

{ TfmScaleGeneral }

procedure TfmScaleGeneral.UpdateDevices;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS;
    if Reg.OpenKey('SOFTWARE\OLEforRetail\ServiceOPOS\Scale', False) then
      Reg.GetKeyNames(cbDeviceName.Items);
    if cbDeviceName.Items.Count > 0 then
      cbDeviceName.ItemIndex := 0;
  finally
    Reg.Free;
  end;
end;

procedure TfmScaleGeneral.btnOpenClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.Open(cbDeviceName.Text);
    edtOpenResult.Text := GetResultCodeText(Scale.OpenResult);
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.btnCloseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.Close;
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.btnClaimClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.ClaimDevice(StrToInt(edtTimeout.Text));
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.btnReleaseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.ReleaseDevice;
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.btnUpdateDevicesClick(Sender: TObject);
begin
  UpdateDevices;
end;

procedure TfmScaleGeneral.FormCreate(Sender: TObject);
begin
  UpdateDevices;
  (*
  Scale.OnDataEvent := DataEvent;
  Scale.OnErrorEvent := ErrorEvent;
  Scale.OnDirectIOEvent := DirectIOEvent;
  Scale.OnStatusUpdateEvent := StatusUpdateEvent;
  *)
end;

procedure TfmScaleGeneral.chbDeviceEnabledClick(Sender: TObject);
begin
  Scale.DeviceEnabled := chbDeviceEnabled.Checked;
  UpdatePage;
end;

procedure TfmScaleGeneral.chbAutoDisableClick(Sender: TObject);
begin
  Scale.AutoDisable := chbAutoDisable.Checked;
  UpdatePage;
end;

procedure TfmScaleGeneral.UpdatePage;
begin
  inherited UpdatePage;
  cbPowerNotify.ItemIndex := Scale.PowerNotify;
  cbStatusNotify.ItemIndex := Scale.StatusNotify;
  edtTareWeight.Text := IntToStr(Scale.TareWeight);
  edtUnitPrice.Text := AmountToStr(Scale.UnitPrice);
  edtSalesPrice.Text := AmountToStr(Scale.SalesPrice);
  SafeSetChecked(chbAutoDisable, Scale.AutoDisable);
  SafeSetChecked(chbDeviceEnabled, Scale.DeviceEnabled);
  SafeSetChecked(chbDataEventEnabled, Scale.DataEventEnabled);
  SafeSetChecked(chbFreezeEvents, Scale.FreezeEvents);
  SafeSetChecked(chbAsyncMode, Scale.AsyncMode);
  SafeSetChecked(chbZeroValid, Scale.ZeroValid);
end;

procedure TfmScaleGeneral.chbDataEventEnabledClick(Sender: TObject);
begin
  Scale.DataEventEnabled := chbDataEventEnabled.Checked;
  UpdatePage;
end;

procedure TfmScaleGeneral.chbFreezeEventsClick(Sender: TObject);
begin
  Scale.FreezeEvents := chbFreezeEvents.Checked;
  UpdatePage;
end;

procedure TfmScaleGeneral.chbAsyncModeClick(Sender: TObject);
begin
  Scale.AsyncMode := chbAsyncMode.Checked;
  UpdatePage;
end;

procedure TfmScaleGeneral.cbPowerNotifyChange(Sender: TObject);
begin
  Scale.PowerNotify := cbPowerNotify.ItemIndex;
  UpdatePage;
end;

procedure TfmScaleGeneral.cbStatusNotifyChange(Sender: TObject);
begin
  Scale.StatusNotify := cbStatusNotify.ItemIndex;
  UpdatePage;
end;

procedure TfmScaleGeneral.btnSetTareWeightClick(Sender: TObject);
begin
  Scale.TareWeight := StrToInt(edtTareWeight.Text);
  UpdatePage;
end;

procedure TfmScaleGeneral.btnSetUnitPriceClick(Sender: TObject);
begin
  Scale.UnitPrice := StrToFloat(edtUnitPrice.Text);
  UpdatePage;
end;

procedure TfmScaleGeneral.btnUpdatePageClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.DataEvent(ASender: TObject; Status: Integer);
var
  S: string;
begin
  S := Format('DataEvent(Weight: %d)', [Status]);
  memEvents.Lines.Add(S);
  UpdatePage;
end;

procedure TfmScaleGeneral.DirectIOEvent(Sender: TObject; EventNumber: Integer;
  var pData: Integer; var pString: WideString);
var
  S: string;
begin
  S := Format('DirectIOEvent(%d, %d, %s)', [EventNumber, pData, pString]);
  memEvents.Lines.Add(S);
  UpdatePage;
end;

procedure TfmScaleGeneral.ErrorEvent(Sender: TObject; ResultCode,
  ResultCodeExtended, ErrorLocus: Integer; var pErrorResponse: Integer);
var
  S: string;
begin
  S := Format('ErrorEvent: %s, %s, %s, %s)', [
    GetResultCodeText(ResultCode),
    GetResultCodeExtendedText(ResultCodeExtended),
    GetErrorLocusText(ErrorLocus),
    GetErrorResponseText(pErrorResponse)]);
  memEvents.Lines.Add(S);
  UpdatePage;
end;

procedure TfmScaleGeneral.StatusUpdateEvent(Sender: TObject; Data: Integer);
var
  S: string;
begin
  S := Format('StatusUpdateEvent(%s)', [GetScaleStatusUpdateEventText(Data)]);
  memEvents.Lines.Add(S);
  UpdatePage;
end;

procedure TfmScaleGeneral.btnReadWeightClick(Sender: TObject);
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
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.btnZeroScaleClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.ZeroScale;
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.btnDisplayTextClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.DisplayText(edtScaleText.Text);
    UpdatePage;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleGeneral.chbZeroValidClick(Sender: TObject);
begin
  Scale.ZeroValid := chbZeroValid.Checked;
  UpdatePage;
end;

procedure TfmScaleGeneral.btnClearEventsClick(Sender: TObject);
begin
  memEvents.Clear;
end;

procedure TfmScaleGeneral.TimerTimer(Sender: TObject);
begin
  edtLiveWeight.Text := IntToStr(Scale.ScaleLiveWeight);
end;

procedure TfmScaleGeneral.chbLiveWeightUpdateClick(Sender: TObject);
begin
  Timer.Enabled := chbLiveWeightUpdate.Checked;
end;

end.
