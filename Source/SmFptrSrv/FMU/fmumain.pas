unit fmuMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, ImgList, ExtCtrls, ShellAPI, ComServ, Buttons,
  ScktCnst,
  // This
  PortConnection, fmuAbout, VersionInfo, oleMain, TrayIcon, TCPServer,
  SrvParams;

type
  { TfmMain }

  TfmMain = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ImageList: TImageList;
    PopupMenu: TPopupMenu;
    miClose: TMenuItem;
    N1: TMenuItem;
    miProperties: TMenuItem;
    miAbout: TMenuItem;
    PageControl: TPageControl;
    tsCommon: TTabSheet;
    tsPorts: TTabSheet;
    lvPorts: TListView;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    udTimeout: TUpDown;
    chbAutoCancel: TCheckBox;
    chbAutoUnlock: TCheckBox;
    btnApply: TButton;
    tsClients: TTabSheet;
    lvClients: TListView;
    lblClientCount: TLabel;
    edtClientCount: TEdit;
    Label1: TLabel;
    chbTCPEnabled: TCheckBox;
    edtTCPPort: TEdit;
    lblTCPPort: TLabel;
    lblComPort: TLabel;
    Bevel2: TBevel;
    btnReleasePort: TButton;
    Timer: TTimer;
    procedure miAboutClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure RxTrayIconClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lvPortsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure udTimeoutClick(Sender: TObject; Button: TUDBtnType);
    procedure ModifiedClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure miPropertiesClick(Sender: TObject);
    procedure edtTimeoutKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtTimeoutKeyPress(Sender: TObject; var Key: Char);
    procedure chbTCPEnabledClick(Sender: TObject);
    procedure btnReleasePortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    FServer: TTCPServer;
    FTrayIcon: TRxTrayIcon;
    FPortsLink: TPortsLink;
    FClientsLink: TClientsLink;

    procedure Modified;
    procedure UpdatePage;
    procedure UpdatePorts;
    procedure UpdateObject;
    procedure UpdateClients;
    procedure ShowProperties;

    function GetPorts: TPorts;
    function GetClients: TClients;
    procedure InsertPort(Port: TPort);
    procedure InsertClient(Client: TFptrServer);
    procedure UpdateButtons(ListItem: TListItem);
    procedure ApplicationRestore(Sender: TObject);
    procedure ApplicationMinimize(Sender: TObject);

    property Ports: TPorts read GetPorts;
    property Clients: TClients read GetClients;
  protected
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

const
  EditColor: array [Boolean] of TColor = (clBtnFace, clWindow);

procedure UpdatePortState(Port: TPort; ListItem: TListItem);
var
  S: string;
begin
  if Port.Claimed then S := 'claimed'
  else S := 'free';

  ListItem.SubItems.Clear;
  ListItem.SubItems.Add(S);
  if Port.Claimed then
  begin
    ListItem.SubItems.Add(Port.ClientInfo.CompName);
    ListItem.SubItems.Add(IntToStr(Port.ClientInfo.PID));
    ListItem.SubItems.Add(Port.ClientInfo.AppName);
  end;
  ListItem.Update;
end;

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServer := TTCPServer.Create;
  FPortsLink := TPortsLink.Create(FServer.Logger);
  FClientsLink := TClientsLink.Create;
  Params.LoadParams;
  UpdatePage;
  Ports.UpdateTimers;
  Application.OnRestore := ApplicationRestore;
  Application.OnMinimize := ApplicationMinimize;
  FTrayIcon := TRxTrayIcon.Create(Self);
  FTrayIcon.Icon.Handle := LoadIcon(hInstance, 'MAINICON');
  FTrayIcon.Hint := Application.Title;
  FTrayIcon.PopupMenu := PopupMenu;
  FTrayIcon.OnClick := RxTrayIconClick;
  UpdateObject;
end;

destructor TfmMain.Destroy;
begin
  FServer.Free;
  inherited Destroy;
  FPortsLink.Free;
  FClientsLink.Free;
end;

function TfmMain.GetPorts: TPorts;
begin
  Result := FPortsLink.Ports;
end;

function TfmMain.GetClients: TClients;
begin
  Result := FClientsLink.Clients;
end;

procedure TfmMain.ReadState(Reader: TReader);
var
  Value: Integer;
begin
  DisableAlign;
  try
    inherited ReadState(Reader);
    Value := GetSystemMetrics(SM_CYCAPTION);
    Height := Height + (Value-19);
  finally
    EnableAlign;
  end;
end;

procedure TfmMain.ApplicationRestore(Sender: TObject);
begin
  Visible := True;
  SetForegroundWindow(Handle);
end;

procedure TfmMain.ApplicationMinimize(Sender: TObject);
begin
  Hide;
end;

procedure TfmMain.miAboutClick(Sender: TObject);
var
  S: string;
begin
  S := 'Version: ' + GetFileVersionInfoStr;
  ShowAboutBox(Handle, Application.Title, [S]);
end;

procedure TfmMain.UpdatePorts;
var
  i: Integer;
  Port: TPort;
  ListItem: TListItem;
begin
  with lvPorts do
  begin
    Items.BeginUpdate;
    Ports.Lock;
    try
      Items.Clear;
      if Ports.Count = 0 then Exit;
      for i := 0 to Ports.Count-1 do
      begin
        Port := Ports[i];
        InsertPort(Port);
      end;
      if Items.Count > 0 then
      begin
        ListItem := Items[0];
        ListItem.MakeVisible(False);
        ListItem.Selected := True;
      end;
    finally
      Ports.Unlock;
      Items.EndUpdate;
    end;
  end;
end;

procedure TfmMain.InsertPort(Port: TPort);
var
  ListItem: TListItem;
begin
  ListItem := lvPorts.Items.Add;
  ListItem.Caption := Format('COM %d', [Port.PortNumber]);
  ListItem.Data := Pointer(Port.ID);
  UpdatePortState(Port, ListItem);
end;

procedure TfmMain.InsertClient(Client: TFptrServer);
var
  ListItem: TListItem;
begin
  ListItem := lvClients.Items.Add;
  ListItem.Caption := IntToStr(Client.Index + 1);
  ListItem.Data := Pointer(Client.ID);
  ListItem.SubItems.Add(Client.CompName);
  ListItem.SubItems.Add(IntToStr(Client.PID));
  ListItem.SubItems.Add(Client.AppName);
end;

procedure TfmMain.UpdateClients;
var
  i: Integer;
  Client: TFptrServer;
  ListItem: TListItem;
begin
  with lvClients do
  begin
    Items.BeginUpdate;
    Clients.Lock;
    try
      Items.Clear;
      if Clients.Count <> 0 then
      begin
        for i := 0 to Clients.Count-1 do
        begin
          Client := Clients[i];
          InsertClient(Client);
        end;
        ListItem := Items[0];
        ListItem.MakeVisible(False);
        ListItem.Selected := True;
      end;
      edtClientCount.Text := IntToStr(Clients.Count);
    finally
      Clients.Unlock;
      Items.EndUpdate;
    end;
  end;
end;

procedure TfmMain.UpdatePage;
begin
  UpdatePorts;
  UpdateClients;
  // TCP parameters
  chbTCPEnabled.Checked := Params.TCPEnabled;
  edtTCPPort.Text := IntToStr(Params.TCPPort);
  edtTCPPort.Enabled := Params.TCPEnabled;
  lblTCPPort.Enabled := Params.TCPEnabled;
  edtTCPPort.Color := EditColor[Params.TCPEnabled];
  // serial port parameters
  udTimeout.Position := Params.PortCloseTimeout;
  chbAutoUnlock.Checked := Params.AutoPortClose;
  chbAutoCancel.Checked := Params.AutoRecCancel;
end;

procedure TfmMain.UpdateButtons(ListItem: TListItem);
begin
  { !!! }
end;

procedure TfmMain.UpdateObject;
begin
  Params.TCPPort := StrToInt(edtTCPPort.Text);
  Params.TCPEnabled := chbTCPEnabled.Checked;
  Params.PortCloseTimeout := udTimeout.Position;
  Params.AutoPortClose := chbAutoUnlock.Checked;
  Params.AutoRecCancel := chbAutoCancel.Checked;

  FServer.Port := Params.TCPPort;
  FServer.Enabled := Params.TCPEnabled;
  try
    if FServer.Update then
    begin
      btnApply.Enabled := False;
      Params.SaveParams;
    end else
    begin
      FServer.Port := Params.TCPPort;
      FServer.Enabled := Params.TCPEnabled;
    end;
    Ports.UpdateTimers;
  except
    Params.TCPEnabled := False;
    chbTCPEnabled.Checked := False;
    raise;
  end;
end;

procedure TfmMain.ShowProperties;
var
  ApplyEnabled: Boolean;
begin
  UpdatePage;
  ApplyEnabled := btnApply.Enabled;
  Visible := True;
  Application.Restore;
  SetForegroundWindow(Handle);
  btnApply.Enabled := ApplyEnabled;
end;

// Events

procedure TfmMain.miCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.RxTrayIconClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowProperties;
end;

procedure TfmMain.btnCancelClick(Sender: TObject);
begin
  Hide;
end;

procedure TfmMain.btnOKClick(Sender: TObject);
begin
  UpdateObject;
  Hide;
end;

procedure TfmMain.lvPortsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if (Change = ctState)and(Item <> nil) then
    UpdateButtons(Item);
end;

procedure TfmMain.Modified;
begin
  btnApply.Enabled := True;
end;

procedure TfmMain.udTimeoutClick(Sender: TObject; Button: TUDBtnType);
begin
  Modified;
end;

procedure TfmMain.ModifiedClick(Sender: TObject);
begin
  Modified;
  chbAutoCancel.Enabled := chbAutoUnlock.Checked;
end;

procedure TfmMain.btnApplyClick(Sender: TObject);
begin
  UpdateObject;
end;

procedure TfmMain.miPropertiesClick(Sender: TObject);
begin
  ShowProperties;
end;

procedure TfmMain.edtTimeoutKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Timeout: Integer;
begin
  if Key = VK_RETURN then
  begin
    Timeout := StrToInt(edtTimeout.Text);
    if Timeout <> udTimeout.Position then
    begin
      udTimeout.Position := Timeout;
      Modified;
    end;
  end;
end;

procedure TfmMain.edtTimeoutKeyPress(Sender: TObject; var Key: Char);
begin
  if IsCharAlpha(Key) then Key := #0;
end;

procedure TfmMain.chbTCPEnabledClick(Sender: TObject);
var
  Value: Boolean;
begin
  Modified;
  Value := chbTCPEnabled.Checked;
  edtTCPPort.Enabled := Value;
  lblTCPPort.Enabled := Value;
  edtTCPPort.Color := EditColor[Value];
end;

procedure TfmMain.btnReleasePortClick(Sender: TObject);
var
  Port: TPort;
  ID: Integer;
  ListItem: TListItem;
  PortNumber: Integer;
begin
  ListItem := lvPorts.Selected;
  if ListItem <> nil then
  begin
    ID := Integer(ListItem.Data);
    Ports.Lock;
    try
      Port := Ports.ItemByID(ID);
      if Port <> nil then
      begin
        PortNumber := Port.PortNumber;
        ReleasePortByNumber(PortNumber);
      end;
    finally
      Ports.Unlock;
    end;
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Caption := Caption + ' ' + GetFileVersionInfoStr;
end;

procedure TfmMain.TimerTimer(Sender: TObject);
begin
  UpdatePorts;
  UpdateClients;
end;

end.
