unit fmuCashGeneral;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Forms, SysUtils,
  Registry, ComCtrls, Graphics,
  // Opos
  Opos, OposCashDrawer, OposUtils, OposCash,
  // This
  untPages, untUtil;

type
  { TfmCashGeneral }

  TfmCashGeneral = class(TPage)
    lblCashDeviceName: TLabel;
    cbCashDeviceName: TComboBox;
    btnUpdateCashDevice: TButton;
    btnOpen: TButton;
    btnClose: TButton;
    btnRelease: TButton;
    btnClaim: TButton;
    btnOpenDrawer: TButton;
    btnGetStatus: TButton;
    btnClearEvents: TButton;
    memEvents: TMemo;
    lblEvents: TLabel;
    lblStatus: TLabel;
    edtStatus: TEdit;
    edtCashOpenResult: TEdit;
    lblCashOpenResult: TLabel;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    chbDeviceEnabled: TCheckBox;
    cbDeviceType: TComboBox;
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnClaimClick(Sender: TObject);
    procedure btnReleaseClick(Sender: TObject);
    procedure btnOpenDrawerClick(Sender: TObject);
    procedure btnGetStatusClick(Sender: TObject);
    procedure btnUpdateCashDeviceClick(Sender: TObject);
    procedure chbDeviceEnabledClick(Sender: TObject);
    procedure btnClearEventsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadCashDevices;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure StatusUpdateEvent(Sender: TObject; Data: Integer);
    procedure DirectIOEvent(ASender: TObject; EventNumber: Integer;
      var pData: Integer; var pString: WideString);
  end;

var
  fmCashGeneral: TfmCashGeneral;

implementation

{$R *.DFM}

const
  REGSTR_KEY_PARAMS = '\SOFTWARE\ShtrihM\Tests\DrvFROPOS\Param';

{ TfmMain }

constructor TfmCashGeneral.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  //LoadFormParams(Self, REGSTR_KEY_PARAMS);
  LoadCashDevices;
end;

destructor TfmCashGeneral.Destroy;
begin
  SaveFormParams(Self, REGSTR_KEY_PARAMS);
  inherited Destroy;
end;

procedure TfmCashGeneral.LoadCashDevices;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access := KEY_QUERY_VALUE + KEY_ENUMERATE_SUB_KEYS;
    if Reg.OpenKey('SOFTWARE\OLEforRetail\ServiceOPOS\CashDrawer', False) then
      Reg.GetKeyNames(cbCashDeviceName.Items);
    if cbCashDeviceName.Items.Count > 0 then
      cbCashDeviceName.ItemIndex := 0;
  finally
    Reg.Free;
  end;
end;

// Events

procedure TfmCashGeneral.btnOpenClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    try
      CreateCashDrawer(cbDeviceType.ItemIndex);
      CashDrawer.Open(cbCashDeviceName.Text);
      CashDrawer.PowerNotify := OPOS_PN_ENABLED;
      //CashDrawer.OnDirectIOEvent := DirectIOEvent;
      //CashDrawer.OnStatusUpdateEvent := StatusUpdateEvent;

      edtCashOpenResult.Text := GetResultCodeText(CashDrawer.OpenResult);
    except
      FreeCashDrawer;
      raise;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmCashGeneral.btnCloseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    CashDrawer.Close;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmCashGeneral.btnClaimClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    CashDrawer.ClaimDevice(StrToInt(edtTimeout.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmCashGeneral.btnReleaseClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    CashDrawer.ReleaseDevice;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmCashGeneral.btnOpenDrawerClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    CashDrawer.OpenDrawer;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmCashGeneral.btnGetStatusClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    if CashDrawer.DrawerOpened then edtStatus.Text := 'drawer opened'
    else edtStatus.Text := 'drawer closed';
  finally
    EnableButtons(True);
  end;
end;

procedure TfmCashGeneral.btnUpdateCashDeviceClick(Sender: TObject);
begin
  LoadCashDevices;
end;

procedure TfmCashGeneral.chbDeviceEnabledClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    CashDrawer.DeviceEnabled := chbDeviceEnabled.Checked;
  finally
    chbDeviceEnabled.Checked := CashDrawer.DeviceEnabled;
    EnableButtons(True);
  end;
end;

function GetStatusUpdateEventText(Data: Integer): string;
begin
  case Data of
    CASH_SUE_DRAWERCLOSED : Result := 'CASH_SUE_DRAWERCLOSED';
    CASH_SUE_DRAWEROPEN   : Result := 'CASH_SUE_DRAWEROPEN';
  else
    Result := IntToStr(Data);
  end;
end;

procedure TfmCashGeneral.StatusUpdateEvent(Sender: TObject; Data: Integer);
begin
  memEvents.Lines.Add(GetStatusUpdateEventText(Data));
end;

procedure TfmCashGeneral.DirectIOEvent(ASender: TObject; EventNumber: Integer;
  var pData: Integer; var pString: WideString);
var
  Text: string;
begin
  Text := Format('DirectIOEvent(%d, %d, "%s")', [
    ASender, EventNumber, pData, pString]);
  memEvents.Lines.Add(Text);
end;

procedure TfmCashGeneral.btnClearEventsClick(Sender: TObject);
begin
  memEvents.Clear;
end;

procedure TfmCashGeneral.FormCreate(Sender: TObject);
begin
  if cbDeviceType.Items.Count > 0 then
    cbDeviceType.ItemIndex := 0;
end;

end.
