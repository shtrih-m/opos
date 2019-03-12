unit fmuFptrReceipt;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  untUtil, FptrTypes, PrinterParameters, FiscalPrinterDevice;

type
  { TfmFptrConnection }

  TfmFptrReceipt = class(TFptrPage)
    gbParams: TTntGroupBox;
    lblDefaultDepartment: TTntLabel;
    lblCutType: TTntLabel;
    lblEncoding: TTntLabel;
    lblStatusCommand: TTntLabel;
    lblHeaderType: TTntLabel;
    cbCutType: TTntComboBox;
    cbEncoding: TTntComboBox;
    cbStatusCommand: TTntComboBox;
    cbHeaderType: TTntComboBox;
    lblZeroReceipt: TTntLabel;
    cbZeroReceipt: TTntComboBox;
    lblCompatLevel: TTntLabel;
    cbCompatLevel: TTntComboBox;
    cbReceiptType: TTntComboBox;
    lblReceiptType: TTntLabel;
    lblZeroReceiptNumber: TTntLabel;
    chbCacheReceiptNumber: TTntCheckBox;
    seDepartment: TSpinEdit;
    seZeroReceiptNumber: TSpinEdit;
    chbZReceiptBeforeZReport: TTntCheckBox;
    chbOpenReceiptEnabled: TTntCheckBox;
    cbQuantityDecimalPlaces: TTntComboBox;
    lblQuantityLength: TTntLabel;
    lblPrintRecMessageMode: TTntLabel;
    cbPrintRecMessageMode: TTntComboBox;
    chbSingleQuantityOnZeroUnitPrice: TCheckBox;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmFptrReceipt: TfmFptrReceipt;

implementation

{$R *.dfm}

{ TfmFptrConnection }

procedure TfmFptrReceipt.UpdatePage;
begin
  seDepartment.Value := Parameters.Department;
  cbCutType.ItemIndex := Parameters.CutType;
  cbEncoding.ItemIndex := Parameters.Encoding;
  cbStatusCommand.ItemIndex := Parameters.StatusCommand;
  cbHeaderType.ItemIndex := Parameters.HeaderType;
  cbCompatLevel.ItemIndex := Parameters.CompatLevel;
  cbReceiptType.ItemIndex := Parameters.ReceiptType;
  cbZeroReceipt.ItemIndex := Parameters.ZeroReceiptType;
  seZeroReceiptNumber.Value := Parameters.ZeroReceiptNumber;
  chbCacheReceiptNumber.Checked := Parameters.CacheReceiptNumber;
  chbZReceiptBeforeZReport.Checked := Parameters.ZReceiptBeforeZReport;
  chbOpenReceiptEnabled.Checked := Parameters.OpenReceiptEnabled;
  cbQuantityDecimalPlaces.ItemIndex := Parameters.QuantityDecimalPlaces;
  cbPrintRecMessageMode.ItemIndex := Parameters.PrintRecMessageMode;
  chbSingleQuantityOnZeroUnitPrice.Checked := Parameters.SingleQuantityOnZeroUnitPrice;
end;

procedure TfmFptrReceipt.UpdateObject;
begin
  Parameters.Department := seDepartment.Value;
  Parameters.CutType := cbCutType.ItemIndex;
  Parameters.Encoding := cbEncoding.ItemIndex;
  Parameters.StatusCommand := cbStatusCommand.ItemIndex;
  Parameters.HeaderType := cbHeaderType.ItemIndex;
  Parameters.CompatLevel := cbCompatLevel.ItemIndex;
  Parameters.ReceiptType := cbReceiptType.ItemIndex;
  Parameters.ZeroReceiptType := cbZeroReceipt.ItemIndex;
  Parameters.ZeroReceiptNumber := seZeroReceiptNumber.Value;
  Parameters.CacheReceiptNumber := chbCacheReceiptNumber.Checked;
  Parameters.ZReceiptBeforeZReport := chbZReceiptBeforeZReport.Checked;
  Parameters.OpenReceiptEnabled := chbOpenReceiptEnabled.Checked;
  Parameters.QuantityDecimalPlaces := cbQuantityDecimalPlaces.ItemIndex;
  Parameters.PrintRecMessageMode := cbPrintRecMessageMode.ItemIndex;
  Parameters.SingleQuantityOnZeroUnitPrice := chbSingleQuantityOnZeroUnitPrice.Checked;
end;

end.
