unit fmuMiscParams;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // This
  FiscalPrinterDevice, untUtil, FptrTypes, PrinterParameters, Spin,
  ExtCtrls;

type
  { TfmZReport }

  TfmMiscParams = class(TFptrPage)
    chbVoidReceiptOnMaxItems: TCheckBox;
    lblMaxReceiptItems: TLabel;
    seMaxReceiptItems: TSpinEdit;
    chbPrintRecSubtotal: TCheckBox;
    lblMonitoringPort: TLabel;
    seMonitoringPort: TSpinEdit;
    chbDepartmentInText: TCheckBox;
    chbMonitoringEnabled: TCheckBox;
    Bevel1: TBevel;
    lblAmountDecimalPlaces: TLabel;
    cbAmountDecimalPlaces: TComboBox;
    Bevel2: TBevel;
    lblCapRecNearEndSensorMode: TLabel;
    cbCapRecNearEndSensorMode: TComboBox;
    chbWrapText: TCheckBox;
    Bevel3: TBevel;
    lblTimeUpdateMode: TLabel;
    cbTimeUpdateMode: TComboBox;
    chbFSServiceEnabled: TCheckBox;
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
end;

end.
