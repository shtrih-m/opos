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
    lblPollInterval: TLabel;
    cbComPort: TComboBox;
    cbBaudRate: TComboBox;
    chbSearchByPort: TCheckBox;
    chbSearchByBaudRate: TCheckBox;
    cbConnectionType: TComboBox;
    edtRemoteHost: TEdit;
    gbParams: TGroupBox;
    lblDefaultDepartment: TLabel;
    lblCutType: TLabel;
    lblEncoding: TLabel;
    lblStatusCommand: TLabel;
    lblHeaderType: TLabel;
    cbCutType: TComboBox;
    cbEncoding: TComboBox;
    cbStatusCommand: TComboBox;
    cbHeaderType: TComboBox;
    gbPassword: TGroupBox;
    lblUsrPassword: TLabel;
    lblSysPassword: TLabel;
    lblZeroReceipt: TLabel;
    cbZeroReceipt: TComboBox;
    lblCompatLevel: TLabel;
    cbCompatLevel: TComboBox;
    cbReceiptType: TComboBox;
    lblReceiptType: TLabel;
    lblZeroReceiptNumber: TLabel;
    lblEventsType: TLabel;
    cbCCOType: TComboBox;
    lblStatusInterval: TLabel;
    lblStorage: TLabel;
    cbStorage: TComboBox;
    chbCacheReceiptNumber: TCheckBox;
    seRemotePort: TSpinEdit;
    seByteTimeout: TSpinEdit;
    seMaxRetryCount: TSpinEdit;
    sePollInterval: TSpinEdit;
    seStatusInterval: TSpinEdit;
    seDepartment: TSpinEdit;
    seZeroReceiptNumber: TSpinEdit;
    seUsrPassword: TSpinEdit;
    seSysPassword: TSpinEdit;
    lblStatusTimeout: TLabel;
    seStatusTimeout: TSpinEdit;
    lblPropertyUpdateMode: TLabel;
    cbPropertyUpdateMode: TComboBox;
    chbZReceiptBeforeZReport: TCheckBox;
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
  edtRemoteHost.Text := Parameters.RemoteHost;
  seRemotePort.Value := Parameters.RemotePort;
  cbComPort.ItemIndex := Parameters.PortNumber-1;
  cbBaudRate.ItemIndex := BaudRateToInt(Parameters.BaudRate);
  seByteTimeout.Value := Parameters.ByteTimeout;
  seMaxRetryCount.Value := Parameters.MaxRetryCount;
  chbSearchByBaudRate.Checked := Parameters.SearchByBaudRateEnabled;
  chbSearchByPort.Checked := Parameters.SearchByPortEnabled;
  cbPropertyUpdateMode.ItemIndex := Parameters.PropertyUpdateMode;
  sePollInterval.Value := Parameters.PollInterval;
  seStatusInterval.Value := Parameters.StatusInterval;

  seDepartment.Value := Parameters.Department;
  cbCutType.ItemIndex := Parameters.CutType;
  cbEncoding.ItemIndex := Parameters.Encoding;
  cbStatusCommand.ItemIndex := Parameters.StatusCommand;
  cbHeaderType.ItemIndex := Parameters.HeaderType;
  cbCompatLevel.ItemIndex := Parameters.CompatLevel;
  cbReceiptType.ItemIndex := Parameters.ReceiptType;
  cbZeroReceipt.ItemIndex := Parameters.ZeroReceiptType;
  seZeroReceiptNumber.Value := Parameters.ZeroReceiptNumber;
  cbCCOType.ItemIndex := Parameters.CCOType;

  seUsrPassword.Value := Parameters.UsrPassword;
  seSysPassword.Value := Parameters.SysPassword;
  chbCacheReceiptNumber.Checked := Parameters.CacheReceiptNumber;
  cbStorage.ItemIndex := Parameters.Storage;
  seStatusTimeout.Value := Parameters.StatusTimeout;
  chbZReceiptBeforeZReport.Checked := Parameters.ZReceiptBeforeZReport;
end;

procedure TfmFptrConnection.UpdateObject;
begin
  Parameters.ConnectionType := cbConnectionType.ItemIndex;
  Parameters.RemoteHost := edtRemoteHost.Text;
  Parameters.RemotePort := seRemotePort.Value;
  Parameters.PortNumber := cbComPort.ItemIndex + 1;
  Parameters.BaudRate := IntToBaudRate(cbBaudRate.ItemIndex);
  Parameters.ByteTimeout := seByteTimeout.Value;
  Parameters.MaxRetryCount := seMaxRetryCount.Value;
  Parameters.SearchByBaudRateEnabled := chbSearchByBaudRate.Checked;
  Parameters.SearchByPortEnabled := chbSearchByPort.Checked;
  Parameters.PropertyUpdateMode := cbPropertyUpdateMode.ItemIndex;
  Parameters.PollInterval := sePollInterval.Value;
  Parameters.StatusInterval := seStatusInterval.Value;
  Parameters.Department := seDepartment.Value;
  Parameters.CutType := cbCutType.ItemIndex;
  Parameters.Encoding := cbEncoding.ItemIndex;
  Parameters.StatusCommand := cbStatusCommand.ItemIndex;
  Parameters.HeaderType := cbHeaderType.ItemIndex;
  Parameters.CompatLevel := cbCompatLevel.ItemIndex;
  Parameters.ReceiptType := cbReceiptType.ItemIndex;
  Parameters.ZeroReceiptType := cbZeroReceipt.ItemIndex;
  Parameters.ZeroReceiptNumber := seZeroReceiptNumber.Value;
  Parameters.CCOType := cbCCOType.ItemIndex;
  Parameters.UsrPassword := seUsrPassword.Value;
  Parameters.SysPassword := seSysPassword.Value;
  Parameters.Storage := cbStorage.ItemIndex;
  Parameters.CacheReceiptNumber := chbCacheReceiptNumber.Checked;
  Parameters.StatusTimeout := seStatusTimeout.Value;
  Parameters.ZReceiptBeforeZReport := chbZReceiptBeforeZReport.Checked;
end;

procedure TfmFptrConnection.FormCreate(Sender: TObject);
begin
  CreatePorts(cbComPort.Items);
end;

end.
