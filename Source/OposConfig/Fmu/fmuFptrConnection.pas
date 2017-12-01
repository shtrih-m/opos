unit fmuFptrConnection;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // This
  untUtil, PrinterParameters, FptrTypes, ComCtrls, Spin,
  FiscalPrinterDevice;

type
  { TfmFptrConnection }

  TfmFptrConnection = class(TFptrPage)
    gbConenctionParams: TGroupBox;
    lblComPort: TLabel;
    lblBaudRate: TLabel;
    lblByteTimeout: TLabel;
    lblMaxRetryCount: TLabel;
    lblConnectionType: TLabel;
    lblRemoteHost: TLabel;
    lblRemotePort: TLabel;
    cbComPort: TComboBox;
    cbBaudRate: TComboBox;
    chbSearchByPort: TCheckBox;
    chbSearchByBaudRate: TCheckBox;
    cbConnectionType: TComboBox;
    edtRemoteHost: TEdit;
    gbPassword: TGroupBox;
    lblUsrPassword: TLabel;
    lblSysPassword: TLabel;
    lblStorage: TLabel;
    cbStorage: TComboBox;
    seRemotePort: TSpinEdit;
    seByteTimeout: TSpinEdit;
    seUsrPassword: TSpinEdit;
    seSysPassword: TSpinEdit;
    lblPrinterProtocol: TLabel;
    cbPrinterProtocol: TComboBox;
    cbMaxRetryCount: TComboBox;
    GroupBox1: TGroupBox;
    lblPropertyUpdateMode: TLabel;
    cbPropertyUpdateMode: TComboBox;
    sePollInterval: TSpinEdit;
    lblPollInterval: TLabel;
    lblStatusInterval: TLabel;
    seStatusInterval: TSpinEdit;
    seStatusTimeout: TSpinEdit;
    lblStatusTimeout: TLabel;
    lblEventsType: TLabel;
    cbCCOType: TComboBox;
    procedure FormCreate(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmFptrConnection: TfmFptrConnection;

implementation

{$R *.dfm}

{ TfmFptrConnection }

procedure TfmFptrConnection.UpdatePage;
begin
  cbConnectionType.ItemIndex := Parameters.ConnectionType;
  cbPrinterProtocol.ItemIndex := Parameters.PrinterProtocol;
  edtRemoteHost.Text := Parameters.RemoteHost;
  seRemotePort.Value := Parameters.RemotePort;
  cbComPort.ItemIndex := Parameters.PortNumber-1;
  cbBaudRate.ItemIndex := BaudRateToInt(Parameters.BaudRate);
  seByteTimeout.Value := Parameters.ByteTimeout;
  cbMaxRetryCount.ItemIndex := Parameters.MaxRetryCount;
  chbSearchByBaudRate.Checked := Parameters.SearchByBaudRateEnabled;
  chbSearchByPort.Checked := Parameters.SearchByPortEnabled;
  cbPropertyUpdateMode.ItemIndex := Parameters.PropertyUpdateMode;
  sePollInterval.Value := Parameters.PollIntervalInSeconds;
  seStatusInterval.Value := Parameters.StatusInterval;
  cbCCOType.ItemIndex := Parameters.CCOType;
  seUsrPassword.Value := Parameters.UsrPassword;
  seSysPassword.Value := Parameters.SysPassword;
  cbStorage.ItemIndex := Parameters.Storage;
  seStatusTimeout.Value := Parameters.StatusTimeout;
end;

procedure TfmFptrConnection.UpdateObject;
begin
  Parameters.ConnectionType := cbConnectionType.ItemIndex;
  Parameters.PrinterProtocol := cbPrinterProtocol.ItemIndex;
  Parameters.RemoteHost := edtRemoteHost.Text;
  Parameters.RemotePort := seRemotePort.Value;
  Parameters.PortNumber := cbComPort.ItemIndex + 1;
  Parameters.BaudRate := IntToBaudRate(cbBaudRate.ItemIndex);
  Parameters.ByteTimeout := seByteTimeout.Value;
  Parameters.MaxRetryCount := cbMaxRetryCount.ItemIndex;
  Parameters.SearchByBaudRateEnabled := chbSearchByBaudRate.Checked;
  Parameters.SearchByPortEnabled := chbSearchByPort.Checked;
  Parameters.PropertyUpdateMode := cbPropertyUpdateMode.ItemIndex;
  Parameters.PollIntervalInSeconds := sePollInterval.Value;
  Parameters.StatusInterval := seStatusInterval.Value;
  Parameters.CCOType := cbCCOType.ItemIndex;
  Parameters.UsrPassword := seUsrPassword.Value;
  Parameters.SysPassword := seSysPassword.Value;
  Parameters.Storage := cbStorage.ItemIndex;
  Parameters.StatusTimeout := seStatusTimeout.Value;
end;

procedure TfmFptrConnection.FormCreate(Sender: TObject);
begin
  CreatePorts(cbComPort.Items);
end;

end.
