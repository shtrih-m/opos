unit fmuReceiptFormat;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, untUtil, FptrTypes, PrinterParameters, ComCtrls;

type
  { TfmReceiptFormat }

  TfmReceiptFormat = class(TFptrPage)
    PageControl1: TPageControl;
    tsReceiptFormat: TTabSheet;
    TabSheet2: TTabSheet;
    lblMaxReceiptItems: TTntLabel;
    Label1: TTntLabel;
    lblRecPrintType: TTntLabel;
    Label2: TTntLabel;
    memReceiptItemsHeader: TTntMemo;
    memReceiptItemFormat: TTntMemo;
    cbRecPrintType: TTntComboBox;
    chbPrintSingleQuantity: TTntCheckBox;
    memReceiptItemsTrailer: TTntMemo;
    Memo: TTntMemo;
    chbPrintUnitName: TTntCheckBox;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmReceiptFormat: TfmReceiptFormat;

implementation

{$R *.dfm}

{ TfmZReport }

procedure TfmReceiptFormat.UpdateObject;
begin
  Parameters.RecPrintType := cbRecPrintType.ItemIndex;
  Parameters.PrintSingleQuantity := chbPrintSingleQuantity.Checked;
  Parameters.ReceiptItemsHeader := memReceiptItemsHeader.Text;
  Parameters.ReceiptItemFormat := memReceiptItemFormat.Text;
  Parameters.ReceiptItemsTrailer := memReceiptItemsTrailer.Text;
  Parameters.PrintUnitName := chbPrintUnitName.Checked;
end;

procedure TfmReceiptFormat.UpdatePage;
begin
  cbRecPrintType.ItemIndex := Parameters.RecPrintType;
  chbPrintSingleQuantity.Checked := Parameters.PrintSingleQuantity;
  memReceiptItemsHeader.Text := Parameters.ReceiptItemsHeader;
  memReceiptItemFormat.Text := Parameters.ReceiptItemFormat;
  memReceiptItemsTrailer.Text := Parameters.ReceiptItemsTrailer;
  chbPrintUnitName.Checked := Parameters.PrintUnitName;
end;

end.
