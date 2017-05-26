unit fmuFptrBarcode;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, Spin,
  // This
  FiscalPrinterDevice, FptrTypes, ExtCtrls;

type
  { TfmFptrBarcode }

  TfmFptrBarcode = class(TFptrPage)
    lblBarLinePrintDelay: TLabel;
    cbBarLineByteMode: TComboBox;
    lblBarLineByteMode: TLabel;
    seBarLinePrintDelay: TSpinEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    edtBarcodePrefix: TEdit;
    lblBarcodePrefix: TLabel;
    seBarcodeHeight: TSpinEdit;
    lblBarcodeHeight: TLabel;
    lblBarcodeType: TLabel;
    cbBarcodeType: TComboBox;
    seBarcodeModuleWidth: TSpinEdit;
    lblBarcodeModuleWidth: TLabel;
    cbBarcodeAlignment: TComboBox;
    lblBarcodeAlignment: TLabel;
    lblBarcodeParameter1: TLabel;
    seBarcodeParameter1: TSpinEdit;
    lblBarcodeParameter2: TLabel;
    seBarcodeParameter2: TSpinEdit;
    lblBarcodeParameter3: TLabel;
    seBarcodeParameter3: TSpinEdit;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmFptrBarcode: TfmFptrBarcode;

implementation

{$R *.dfm}

{ TfmFptrBarcode }

procedure TfmFptrBarcode.UpdatePage;
begin
  seBarLinePrintDelay.Value := Parameters.BarLinePrintDelay;
  cbBarLineByteMode.ItemIndex := Parameters.BarLineByteMode;

  edtBarcodePrefix.Text := Parameters.BarcodePrefix;
  seBarcodeHeight.Value := Parameters.BarcodeHeight;
  cbBarcodeType.ItemIndex :=
    cbBarcodeType.Items.IndexOfObject(TObject(Parameters.BarcodeType));
  seBarcodeModuleWidth.Value := Parameters.BarcodeModuleWidth;
  cbBarcodeAlignment.ItemIndex := Parameters.BarcodeAlignment;
  seBarcodeParameter1.Value := Parameters.BarcodeParameter1;
  seBarcodeParameter2.Value := Parameters.BarcodeParameter2;
  seBarcodeParameter3.Value := Parameters.BarcodeParameter3;
end;

procedure TfmFptrBarcode.UpdateObject;
begin
  Parameters.BarLinePrintDelay := seBarLinePrintDelay.Value;
  Parameters.BarLineByteMode := cbBarLineByteMode.ItemIndex;

  Parameters.BarcodePrefix := edtBarcodePrefix.Text;
  Parameters.BarcodeHeight := seBarcodeHeight.Value;
  Parameters.BarcodeType :=
    Integer(cbBarcodeType.Items.Objects[cbBarcodeType.ItemIndex]);
  Parameters.BarcodeModuleWidth := seBarcodeModuleWidth.Value;
  Parameters.BarcodeAlignment := cbBarcodeAlignment.ItemIndex;
  Parameters.BarcodeParameter1 := seBarcodeParameter1.Value;
  Parameters.BarcodeParameter2 := seBarcodeParameter2.Value;
  Parameters.BarcodeParameter3 := seBarcodeParameter3.Value;
end;

type
  { TBarcodeType }

  TBarcodeType = record
    Name: string;
    Code: Integer;
  end;

const
  BarcodeTypes: array [0..92] of TBarcodeType = (
  (Name: 'EAN13_INT'; Code: 0),
  (Name: 'CODE128A'; Code: 1),
  (Name: 'CODE128B'; Code: 2),
  (Name: 'CODE128C'; Code: 3),
  (Name: 'CODE39'; Code: 4),
  (Name: 'CODE25INTERLEAVED'; Code: 5),
  (Name: 'CODE25INDUSTRIAL'; Code: 6),
  (Name: 'CODE25MATRIX'; Code: 7),
  (Name: 'CODE39EXTENDED'; Code: 8),
  (Name: 'CODE93'; Code: 9),
  (Name: 'CODE93EXTENDED'; Code: 10),
  (Name: 'MSI'; Code: 11),
  (Name: 'POSTNET'; Code: 12),
  (Name: 'CODABAR'; Code: 13),
  (Name: 'EAN8'; Code: 14),
  (Name: 'EAN13'; Code: 15),
  (Name: 'UPC_A'; Code: 16),
  (Name: 'UPC_E0'; Code: 17),
  (Name: 'UPC_E1'; Code: 18),
  (Name: 'UPC_S2'; Code: 19),
  (Name: 'UPC_S5'; Code: 20),
  (Name: 'EAN128A'; Code: 21),
  (Name: 'EAN128B'; Code: 22),
  (Name: 'EAN128C'; Code: 23),
  (Name: 'CODE11'; Code: 24),
  (Name: 'C25IATA'; Code: 25),
  (Name: 'C25LOGIC'; Code: 26),
  (Name: 'DPLEIT'; Code: 27),
  (Name: 'DPIDENT'; Code: 28),
  (Name: 'CODE16K'; Code: 29),
  (Name: 'CODE49'; Code: 30),
  (Name: 'FLAT'; Code: 31),
  (Name: 'RSS14'; Code: 32),
  (Name: 'RSS_LTD'; Code: 33),
  (Name: 'RSS_EXP'; Code: 34),
  (Name: 'TELEPEN'; Code: 35),
  (Name: 'FIM'; Code: 36),
  (Name: 'LOGMARS'; Code: 37),
  (Name: 'PHARMA'; Code: 38),
  (Name: 'PZN'; Code: 39),
  (Name: 'PHARMA_TWO'; Code: 40),
  (Name: 'PDF417'; Code: 41),
  (Name: 'PDF417TRUNC'; Code: 42),
  (Name: 'MAXICODE'; Code: 43),
  (Name: 'QRCODE'; Code: 44),
  (Name: 'AUSPOST'; Code: 45),
  (Name: 'AUSREPLY'; Code: 46),
  (Name: 'AUSROUTE'; Code: 47),
  (Name: 'AUSREDIRECT'; Code: 48),
  (Name: 'ISBNX'; Code: 49),
  (Name: 'RM4SCC'; Code: 50),
  (Name: 'DATAMATRIX'; Code: 51),
  (Name: 'EAN14'; Code: 52),
  (Name: 'CODABLOCKF'; Code: 53),
  (Name: 'NVE18'; Code: 54),
  (Name: 'JAPANPOST'; Code: 55),
  (Name: 'KOREAPOST'; Code: 56),
  (Name: 'RSS14STACK'; Code: 57),
  (Name: 'RSS14STACK_OMNI'; Code: 58),
  (Name: 'RSS_EXPSTACK'; Code: 59),
  (Name: 'PLANET'; Code: 60),
  (Name: 'MICROPDF417'; Code: 61),
  (Name: 'ONECODE'; Code: 62),
  (Name: 'PLESSEY'; Code: 63),
  (Name: 'TELEPEN_NUM'; Code: 64),
  (Name: 'ITF14'; Code: 65),
  (Name: 'KIX'; Code: 66),
  (Name: 'AZTEC'; Code: 67),
  (Name: 'DAFT'; Code: 68),
  (Name: 'MICROQR'; Code: 69),
  (Name: 'HIBC_128'; Code: 70),
  (Name: 'HIBC_39'; Code: 71),
  (Name: 'HIBC_DM'; Code: 72),
  (Name: 'HIBC_QR'; Code: 73),
  (Name: 'HIBC_PDF'; Code: 74),
  (Name: 'HIBC_MICPDF'; Code: 75),
  (Name: 'HIBC_BLOCKF'; Code: 76),
  (Name: 'HIBC_AZTEC'; Code: 77),
  (Name: 'AZRUNE'; Code: 78),
  (Name: 'CODE32'; Code: 79),
  (Name: 'EANX_CC'; Code: 80),
  (Name: 'EAN128_CC'; Code: 81),
  (Name: 'RSS14_CC'; Code: 82),
  (Name: 'RSS_LTD_CC'; Code: 83),
  (Name: 'RSS_EXP_CC'; Code: 84),
  (Name: 'UPCA_CC'; Code: 85),
  (Name: 'UPCE_CC'; Code: 86),
  (Name: 'RSS14STACK_CC'; Code: 87),
  (Name: 'RSS14_OMNI_CC'; Code: 88),
  (Name: 'RSS_EXPSTACK_CC'; Code: 89),
  (Name: 'CHANNEL'; Code: 90),
  (Name: 'CODEONE'; Code: 91),
  (Name: 'GRIDMATRIX'; Code: 92));

procedure TfmFptrBarcode.FormCreate(Sender: TObject);
var
  i: Integer;
  B: TBarcodeType;
begin
  cbBarcodeType.Items.BeginUpdate;
  try
    cbBarcodeType.Items.Clear;
    for i := Low(BarcodeTypes) to High(BarcodeTypes) do
    begin
      B := BarcodeTypes[i];
      cbBarcodeType.Items.AddObject(B.Name, TObject(B.Code));
    end;
  finally
    cbBarcodeType.Items.EndUpdate;
  end;
end;

end.
