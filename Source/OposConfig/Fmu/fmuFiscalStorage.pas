unit fmuFiscalStorage;

interface

uses
  // VCL
  StdCtrls, Controls, Classes, ComObj, SysUtils, Spin, ExtCtrls,
  // 3'd
  SynMemo, SynEdit,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  PrinterParameters, FiscalPrinterDevice, FptrTypes, DirectIOAPI;


type
  { TfmFiscalStorage }

  TfmFiscalStorage = class(TFptrPage)
    chbFSBarcodeEnabled: TTntCheckBox;
    chbFSAddressEnabled: TTntCheckBox;
    chbFSUpdatePrice: TTntCheckBox;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

procedure TfmFiscalStorage.PageChange(Sender: TObject);
begin
  Modified;
end;

procedure TfmFiscalStorage.UpdatePage;
begin
  chbFSUpdatePrice.Checked := Parameters.FSUpdatePrice;
  chbFSAddressEnabled.Checked := Parameters.FSAddressEnabled;
  chbFSBarcodeEnabled.Checked := Parameters.FSBarcodeEnabled;
end;

procedure TfmFiscalStorage.UpdateObject;
begin
  Parameters.FSUpdatePrice := chbFSUpdatePrice.Checked;
  Parameters.FSAddressEnabled := chbFSAddressEnabled.Checked;
  Parameters.FSBarcodeEnabled := chbFSBarcodeEnabled.Checked;
end;

end.

