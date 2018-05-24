unit fmuMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls, ComCtrls, Buttons,
  // Tnt
  TntSysUtils, TntClasses, TntStdCtrls, TntRegistry, TntButtons,
  // This
  BaseForm, OposDevice, FiscalPrinterDevice, CashDrawerDevice, ScaleDevice,
  fmuDevice;

type
  { TfmMain }

  TfmMain = class(TBaseForm)
    lbDevices: TTntListBox;
    lblDevices: TTntLabel;
    lblDeviceType: TTntLabel;
    Bevel1: TBevel;
    btnAddDevice: TTntBitBtn;
    btnDeleteDevice: TTntBitBtn;
    btnEditDevice: TTntBitBtn;
    lbDeviceType: TTntListBox;
    btnClose: TTntButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnAddDeviceClick(Sender: TObject);
    procedure btnDeleteDeviceClick(Sender: TObject);
    procedure EditDeviceClick(Sender: TObject);
    procedure lbDeviceTypeClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lbDevicesClick(Sender: TObject);
    procedure lbDevicesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FDeviceType: Integer;
    FDevices: TOposDevices;

    procedure UpdatePage;
    procedure EditDevice;
    procedure DeleteDevice;
    procedure UpdateButtons;
    procedure UpdateDeviceNames;
    procedure SetDeviceType(Value: Integer);

    property Devices: TOposDevices read FDevices;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

function ValidIndex(Value, Count: Integer): Boolean;
begin
  Result := (Value >= 0)and(Value < Count);
end;

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDevices := TOposDevices.Create;
  //TPosPrinterDevice.Create(Devices, 'PosPrinter', 'PosPrinter'); { !!! }
  TFiscalPrinterDevice.CreateDevice(Devices);
  TCashDrawerDevice.CreateDevice(Devices);
  TScaleDevice.CreateDevice(Devices);

  FDeviceType := -1;
  UpdatePage;
end;

destructor TfmMain.Destroy;
begin
  FDevices.Free;
  inherited Destroy;
end;

procedure TfmMain.UpdateDeviceNames;
begin
  if Devices.ValidIndex(FDeviceType) then
    Devices[FDeviceType].GetDeviceNames(lbDevices.Items);
end;

procedure TfmMain.UpdatePage;
var
  i: Integer;
  Device: TOposDevice;
begin
  lbDeviceType.Items.BeginUpdate;
  try
    lbDeviceType.Items.Clear;
    for i := 0 to Devices.Count-1 do
    begin
      Device := Devices[i];
      lbDeviceType.Items.AddObject(Device.Text, Device);
    end;
  finally
    lbDeviceType.Items.EndUpdate;
  end;
  UpdateDeviceNames;
end;

procedure TfmMain.EditDevice;
var
  Device: TOposDevice;
  DeviceName: string;
  DeviceType: Integer;
begin
  if lbDevices.ItemIndex = -1 then Exit;

  DeviceType := lbDeviceType.ItemIndex;
  DeviceName := lbDevices.Items[lbDevices.ItemIndex];
  if Devices.ValidIndex(DeviceType) then
  begin
    Device := Devices[DeviceType];
    Device.DeviceName := DeviceName;
    Device.ShowDialog;
  end;
end;

procedure TfmMain.UpdateButtons;
begin
  btnEditDevice.Enabled := lbDevices.ItemIndex <> -1;
  btnDeleteDevice.Enabled := lbDevices.ItemIndex <> -1;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  lbDeviceType.ItemIndex := 0;
  SetDeviceType(0);
end;

procedure TfmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.DeleteDevice;
var
  S: string;
  DeviceName: string;
begin
  DeviceName := lbDevices.Items[lbDevices.ItemIndex];
  S := Tnt_WideFormat('Delete device ''%s''?', [DeviceName]);
  if MessageBox(Handle, PChar(S), PChar(Application.Title),
    MB_YESNO or MB_ICONEXCLAMATION) = ID_YES then
  begin
    Devices[FDeviceType].Delete(DeviceName);
    UpdateDeviceNames;
  end;
  UpdateButtons;
end;

procedure TfmMain.btnAddDeviceClick(Sender: TObject);
var
  DeviceName: string;
begin
  DeviceName := 'NewDevice';
  if EditDeviceName(DeviceName) then
  begin
    Devices[FDeviceType].Add(DeviceName);
    UpdateDeviceNames;
  end;
end;

procedure TfmMain.btnDeleteDeviceClick(Sender: TObject);
begin
  DeleteDevice;
end;

procedure TfmMain.SetDeviceType(Value: Integer);
begin
  if Value <> FDeviceType then
  begin
    FDeviceType := Value;
    UpdateDeviceNames;
  end;
end;

procedure TfmMain.EditDeviceClick(Sender: TObject);
begin
  EditDevice;
end;

procedure TfmMain.lbDeviceTypeClick(Sender: TObject);
begin
  SetDeviceType(lbDeviceType.ItemIndex);
  UpdateButtons;
end;

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.lbDevicesClick(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfmMain.lbDevicesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN   : EditDevice;
    VK_DELETE   : DeleteDevice;
  end;
end;

end.


