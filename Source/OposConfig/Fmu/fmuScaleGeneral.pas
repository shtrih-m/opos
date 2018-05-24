unit fmuScaleGeneral;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls, ComCtrls, Spin,
  // Tnt
  TntClasses, TntStdCtrls, TntDialogs,
  // This
  untPages, untUtil, ScaleDevice, ScaleParameters, ScaleTypes,
  OposDevice;

type
  { TfmScaleGeneral }

  TfmScaleGeneral = class(TScalePage)
    OpenDialog: TTntOpenDialog;
    gbParams: TTntGroupBox;
    lblComPort: TTntLabel;
    lblBaudRate: TTntLabel;
    lblByteTimeout: TTntLabel;
    lblMaxRetryCount: TTntLabel;
    cbComPort: TTntComboBox;
    cbBaudRate: TTntComboBox;
    chbSearchByPort: TTntCheckBox;
    chbSearchByBaudRate: TTntCheckBox;
    seByteTimeout: TSpinEdit;
    seMaxRetryCount: TSpinEdit;
    lblCommandTimeout: TTntLabel;
    seCommandTimeout: TSpinEdit;
    sePassword: TSpinEdit;
    lblPassword: TTntLabel;
    lblEncoding: TTntLabel;
    cbEncoding: TTntComboBox;
    cbCCOType: TTntComboBox;
    lblCCOType: TTntLabel;
    chbCapPrice: TTntCheckBox;
    spPollPeriod: TSpinEdit;
    lblPollPeriod: TTntLabel;
    procedure btnDefaultsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmScale }

procedure TfmScaleGeneral.UpdatePage;
begin
  cbComPort.ItemIndex := Parameters.PortNumber-1;
  cbBaudRate.ItemIndex := BaudRateToInt(Parameters.BaudRate);
  seByteTimeout.Value := Parameters.ByteTimeout;
  seCommandTimeout.Value := Parameters.CommandTimeout;
  seMaxRetryCount.Value := Parameters.MaxRetryCount;
  chbSearchByBaudRate.Checked := Parameters.SearchByBaudRateEnabled;
  chbSearchByPort.Checked := Parameters.SearchByPortEnabled;
  sePassword.Value := Parameters.Password;
  cbEncoding.ItemIndex := Parameters.Encoding;
  cbCCOType.ItemIndex := Parameters.CCOType;
  chbCapPrice.Checked := Parameters.CapPrice;
  spPollPeriod.Value := Parameters.PollPeriod;
end;

procedure TfmScaleGeneral.UpdateObject;
begin
  Parameters.PortNumber := cbComPort.ItemIndex +1;
  Parameters.BaudRate := IntToBaudRate(cbBaudRate.ItemIndex);
  Parameters.ByteTimeout := seByteTimeout.Value;
  Parameters.CommandTimeout := seCommandTimeout.Value;
  Parameters.MaxRetryCount := seMaxRetryCount.Value;
  Parameters.SearchByBaudRateEnabled := chbSearchByBaudRate.Checked;
  Parameters.SearchByPortEnabled := chbSearchByPort.Checked;
  Parameters.Password := sePassword.Value;
  Parameters.Encoding := cbEncoding.ItemIndex;
  Parameters.CCOType := cbCCOType.ItemIndex;
  Parameters.CapPrice := chbCapPrice.Checked;
  Parameters.PollPeriod := spPollPeriod.Value;
end;

procedure TfmScaleGeneral.btnDefaultsClick(Sender: TObject);
begin
  Parameters.SetDefaults;
  UpdatePage;
end;

procedure TfmScaleGeneral.btnOKClick(Sender: TObject);
begin
  UpdateObject;
  ModalResult := mrOK;
end;

procedure TfmScaleGeneral.FormCreate(Sender: TObject);
begin
  CreatePorts(cbComPort.Items);
end;

end.
