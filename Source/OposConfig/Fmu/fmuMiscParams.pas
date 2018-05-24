unit fmuMiscParams;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, untUtil, FptrTypes, PrinterParameters;

type
  { TfmZReport }

  TfmMiscParams = class(TFptrPage)
    chbVoidReceiptOnMaxItems: TTntCheckBox;
    lblMaxReceiptItems: TTntLabel;
    seMaxReceiptItems: TSpinEdit;
    chbPrintRecSubtotal: TTntCheckBox;
    lblMonitoringPort: TTntLabel;
    seMonitoringPort: TSpinEdit;
    chbDepartmentInText: TTntCheckBox;
    chbMonitoringEnabled: TTntCheckBox;
    Bevel1: TBevel;
    lblAmountDecimalPlaces: TTntLabel;
    cbAmountDecimalPlaces: TTntComboBox;
    Bevel2: TBevel;
    lblCapRecNearEndSensorMode: TTntLabel;
    cbCapRecNearEndSensorMode: TTntComboBox;
    chbWrapText: TTntCheckBox;
    Bevel3: TBevel;
    lblTimeUpdateMode: TTntLabel;
    cbTimeUpdateMode: TTntComboBox;
    chbFSServiceEnabled: TTntCheckBox;
    chbPingEnabled: TTntCheckBox;
    lblDocumentBlockSize: TTntLabel;
    seDocumentBlockSize: TSpinEdit;
    btnSetMaxDocumentBlockSize: TTntButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSetMaxDocumentBlockSizeClick(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmMiscParams: TfmMiscParams;

implementation

{$R *.dfm}

{ TfmZReport }

procedure TfmMiscParams.UpdateObject;
begin
  Parameters.VoidReceiptOnMaxItems := chbVoidReceiptOnMaxItems.Checked;
  Parameters.MaxReceiptItems := seMaxReceiptItems.Value;
  Parameters.PrintRecSubtotal := chbPrintRecSubtotal.Checked;
  Parameters.DepartmentInText := chbDepartmentInText.Checked;
  Parameters.MonitoringEnabled := chbMonitoringEnabled.Checked;
  Parameters.MonitoringPort := seMonitoringPort.Value;
  Parameters.AmountDecimalPlaces := cbAmountDecimalPlaces.ItemIndex;
  Parameters.CapRecNearEndSensorMode := cbCapRecNearEndSensorMode.ItemIndex;
  Parameters.WrapText := chbWrapText.Checked;
  Parameters.TimeUpdateMode := cbTimeUpdateMode.ItemIndex;
  Parameters.FSServiceEnabled := chbFSServiceEnabled.Checked;
  Parameters.PingEnabled := chbPingEnabled.Checked;
  Parameters.DocumentBlockSize := seDocumentBlockSize.Value;
end;

procedure TfmMiscParams.UpdatePage;
begin
  seMaxReceiptItems.Value := Parameters.MaxReceiptItems;
  chbVoidReceiptOnMaxItems.Checked := Parameters.VoidReceiptOnMaxItems;
  chbPrintRecSubtotal.Checked := Parameters.PrintRecSubtotal;
  chbDepartmentInText.Checked := Parameters.DepartmentInText;
  seMonitoringPort.Value := Parameters.MonitoringPort;
  chbMonitoringEnabled.Checked := Parameters.MonitoringEnabled;
  cbAmountDecimalPlaces.ItemIndex := Parameters.AmountDecimalPlaces;
  cbCapRecNearEndSensorMode.ItemIndex := Parameters.CapRecNearEndSensorMode;
  chbWrapText.Checked := Parameters.WrapText;
  cbTimeUpdateMode.ItemIndex := Parameters.TimeUpdateMode;
  chbFSServiceEnabled.Checked := Parameters.FSServiceEnabled;
  chbPingEnabled.Checked := Parameters.PingEnabled;
  seDocumentBlockSize.Value := Parameters.DocumentBlockSize;
end;

procedure TfmMiscParams.FormCreate(Sender: TObject);
begin
  seDocumentBlockSize.MinValue := MinDocumentBlockSize;
  seDocumentBlockSize.MaxValue := MaxDocumentBlockSize;
end;

procedure TfmMiscParams.btnSetMaxDocumentBlockSizeClick(Sender: TObject);
begin
  seDocumentBlockSize.Value := MaxDocumentBlockSize;
end;

end.
