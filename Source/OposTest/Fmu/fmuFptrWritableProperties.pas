unit fmuFptrWritableProperties;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrWritableProperties = class(TPage)
    chbDeviceEnabled: TTntCheckBox;
    chbFreezeEvents: TTntCheckBox;
    chbPowerNotify: TTntCheckBox;
    chbAsyncMode: TTntCheckBox;
    chbCheckTotal: TTntCheckBox;
    chbDuplicateReceipt: TTntCheckBox;
    chbFlagWhenIdle: TTntCheckBox;
    lblSlipSelection: TTntLabel;
    cbSlipSelection: TTntComboBox;
    lblChangeDue: TTntLabel;
    edtChangeDue: TTntEdit;
    lblDateType: TTntLabel;
    cbDateType: TTntComboBox;
    lblFiscalReceiptStation: TTntLabel;
    cbFiscalReceiptStation: TTntComboBox;
    lblFiscalReceiptType: TTntLabel;
    cbFiscalReceiptType: TTntComboBox;
    lblMessageType: TTntLabel;
    cbMessageType: TTntComboBox;
    lblPreLine: TTntLabel;
    lblPostLine: TTntLabel;
    edtPreLine: TTntEdit;
    edtPostLine: TTntEdit;
    btnUpdate: TTntButton;
    procedure chbDeviceEnabledClick(Sender: TObject);
    procedure chbFreezeEventsClick(Sender: TObject);
    procedure chbPowerNotifyClick(Sender: TObject);
    procedure chbAsyncModeClick(Sender: TObject);
    procedure chbCheckTotalClick(Sender: TObject);
    procedure chbDuplicateReceiptClick(Sender: TObject);
    procedure chbFlagWhenIdleClick(Sender: TObject);
    procedure cbSlipSelectionChange(Sender: TObject);
    procedure edtChangeDueChange(Sender: TObject);
    procedure cbDateTypeChange(Sender: TObject);
    procedure cbFiscalReceiptStationChange(Sender: TObject);
    procedure cbFiscalReceiptTypeChange(Sender: TObject);
    procedure cbMessageTypeChange(Sender: TObject);
    procedure edtPreLineChange(Sender: TObject);
    procedure edtPostLineChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    procedure UpdateForm;
  end;

implementation

{$R *.DFM}

const
  BoolToInt: array [Boolean] of Integer = (0, 1);

{ TfmProps }

procedure TfmFptrWritableProperties.UpdateForm;
begin
end;

procedure TfmFptrWritableProperties.chbDeviceEnabledClick(Sender: TObject);
begin
  FiscalPrinter.DeviceEnabled := chbDeviceEnabled.Checked;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.chbFreezeEventsClick(Sender: TObject);
begin
  FiscalPrinter.FreezeEvents := chbFreezeEvents.Checked;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.chbPowerNotifyClick(Sender: TObject);
begin
  FiscalPrinter.PowerNotify := BoolToInt[chbPowerNotify.Checked];
  UpdateForm;
end;

procedure TfmFptrWritableProperties.chbAsyncModeClick(Sender: TObject);
begin
  FiscalPrinter.AsyncMode := chbAsyncMode.Checked;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.chbCheckTotalClick(Sender: TObject);
begin
  FiscalPrinter.CheckTotal := chbCheckTotal.Checked;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.chbDuplicateReceiptClick(Sender: TObject);
begin
  FiscalPrinter.DuplicateReceipt := chbDuplicateReceipt.Checked;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.chbFlagWhenIdleClick(Sender: TObject);
begin
  FiscalPrinter.FlagWhenIdle := chbFlagWhenIdle.Checked;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.cbSlipSelectionChange(Sender: TObject);
begin
  FiscalPrinter.SlipSelection := cbSlipSelection.ItemIndex + 1;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.edtChangeDueChange(Sender: TObject);
begin
  FiscalPrinter.ChangeDue := edtChangeDue.Text;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.cbDateTypeChange(Sender: TObject);
begin
  FiscalPrinter.DateType := cbDateType.ItemIndex + 1;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.cbFiscalReceiptStationChange(Sender: TObject);
begin
  FiscalPrinter.FiscalReceiptStation := cbFiscalReceiptStation.ItemIndex + 1;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.cbFiscalReceiptTypeChange(Sender: TObject);
begin
  FiscalPrinter.FiscalReceiptType := cbFiscalReceiptType.ItemIndex + 1;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.cbMessageTypeChange(Sender: TObject);
begin
  FiscalPrinter.MessageType := cbMessageType.ItemIndex + 1;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.edtPreLineChange(Sender: TObject);
begin
  FiscalPrinter.PreLine := edtPreLine.Text;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.edtPostLineChange(Sender: TObject);
begin
  FiscalPrinter.PostLine := edtPostLine.Text;
  UpdateForm;
end;

procedure TfmFptrWritableProperties.FormShow(Sender: TObject);
begin
  UpdateForm;
end;

procedure TfmFptrWritableProperties.btnUpdateClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    chbDeviceEnabled.Checked := FiscalPrinter.DeviceEnabled;
    chbFreezeEvents.Checked := FiscalPrinter.FreezeEvents;
    chbPowerNotify.Checked := FiscalPrinter.PowerNotify <> 0;
    chbAsyncMode.Checked := FiscalPrinter.AsyncMode;
    chbCheckTotal.Checked := FiscalPrinter.CheckTotal;
    chbDuplicateReceipt.Checked := FiscalPrinter.DuplicateReceipt;
    chbFlagWhenIdle.Checked := FiscalPrinter.FlagWhenIdle;
    cbSlipSelection.ItemIndex := FiscalPrinter.SlipSelection - 1;
    edtChangeDue.Text := FiscalPrinter.ChangeDue;
    cbDateType.ItemIndex := FiscalPrinter.DateType - 1;
    cbFiscalReceiptStation.ItemIndex := FiscalPrinter.FiscalReceiptStation - 1;
    cbFiscalReceiptType.ItemIndex := FiscalPrinter.FiscalReceiptType - 1;
    cbMessageType.ItemIndex := FiscalPrinter.MessageType -1;
    edtPreLine.Text := FiscalPrinter.PreLine;
    edtPostLine.Text := FiscalPrinter.PostLine;
  finally
    EnableButtons(True);
  end;
end;

end.
