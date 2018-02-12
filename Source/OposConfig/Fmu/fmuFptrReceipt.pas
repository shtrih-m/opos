unit fmuFptrReceipt;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin,
  // This
  untUtil, FptrTypes, PrinterParameters, FiscalPrinterDevice;

type
  { TfmFptrConnection }

  TfmFptrReceipt = class(TFptrPage)
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
    lblZeroReceipt: TLabel;
    cbZeroReceipt: TComboBox;
    lblCompatLevel: TLabel;
    cbCompatLevel: TComboBox;
    cbReceiptType: TComboBox;
    lblReceiptType: TLabel;
    lblZeroReceiptNumber: TLabel;
    chbCacheReceiptNumber: TCheckBox;
    seDepartment: TSpinEdit;
    seZeroReceiptNumber: TSpinEdit;
    chbZReceiptBeforeZReport: TCheckBox;
    chbOpenReceiptEnabled: TCheckBox;
    cbQuantityDecimalPlaces: TComboBox;
    lblQuantityLength: TLabel;
    lblPrintRecMessageMode: TLabel;
    cbPrintRecMessageMode: TComboBox;
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
end;

end.
