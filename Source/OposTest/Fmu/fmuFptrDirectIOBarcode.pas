unit fmuFptrDirectIOBarcode;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos, OposFptr, SMFiscalPrinter;

type
  { TfmDirectIOBarcode }

  TfmFptrDirectIOBarcode = class(TPage)
    btnPrintAll: TTntButton;
    btnPrint1D: TTntButton;
    btnPrint2D: TTntButton;
    gb2DBarcode: TTntGroupBox;
    lblBarcodeData: TTntLabel;
    lblModuleSize: TTntLabel;
    memBarcode: TTntMemo;
    btnPrintBarcode: TTntButton;
    cbModuleSize: TTntComboBox;
    lblAlignment: TTntLabel;
    cbAlignment: TTntComboBox;
    lblBarcodeType: TTntLabel;
    cbBarcodeType: TTntComboBox;
    btnPrintBarcodeHex: TTntButton;
    procedure btnPrintAllClick(Sender: TObject);
    procedure btnPrint1DClick(Sender: TObject);
    procedure btnPrint2DClick(Sender: TObject);
    procedure btnPrintBarcodeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintBarcodeHexClick(Sender: TObject);
  private
    procedure Print1DBarcodes;
    procedure Print2DBarcodes;
    procedure PrintBarcodeHex(BarcodeType: Integer; const Text,
      Barcode: WideString; ModuleWidth: Integer);
  public
    procedure PrintBarcode(BarcodeType: Integer; const Text, Barcode: WideString;
      ModuleWidth: Integer);
  end;

implementation

{$R *.DFM}

{ TfmDirectIOBarcode }

procedure TfmFptrDirectIOBarcode.PrintBarcode(BarcodeType: Integer;
  const Text, Barcode: WideString; ModuleWidth: Integer);
var
  TickCount: Integer;
  ResultCode: Integer;
  BC: TBarcodeRec;
begin
  //FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Text + ': ' + Barcode);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Text);

  TickCount := GetTickCount;
  BC.Data := Barcode;
  BC.Text := Text;
  BC.Height := 100;
  BC.BarcodeType := BarcodeType;
  BC.ModuleWidth := ModuleWidth;
  BC.Alignment := cbAlignment.ItemIndex;
  ResultCode := FiscalPrinter.PrintBarcode2(BC);
  if ResultCode = 0 then
  begin
    TickCount := Integer(GetTickCount) - TickCount;
    FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Tnt_WideFormat('Время печати: %d мс.', [TickCount]));
  end else
  begin
    FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, FiscalPrinter.ErrorString);
  end;
end;

procedure TfmFptrDirectIOBarcode.PrintBarcodeHex(BarcodeType: Integer;
  const Text, Barcode: WideString; ModuleWidth: Integer);
var
  TickCount: Integer;
  ResultCode: Integer;
  BC: TBarcodeRec;
begin
  //FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Text + ': ' + Barcode);
  FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Text);

  TickCount := GetTickCount;
  BC.Data := Barcode;
  BC.Text := Text;
  BC.Height := 100;
  BC.BarcodeType := BarcodeType;
  BC.ModuleWidth := ModuleWidth;
  BC.Alignment := cbAlignment.ItemIndex;
  ResultCode := FiscalPrinter.PrintBarcodeHex(BC);
  if ResultCode = 0 then
  begin
    TickCount := Integer(GetTickCount) - TickCount;
    FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, Tnt_WideFormat('Время печати: %d мс.', [TickCount]));
  end else
  begin
    FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, FiscalPrinter.ErrorString);
  end;
end;

procedure TfmFptrDirectIOBarcode.Print1DBarcodes;
const
  Barcode = '1234567';
begin
  PrintBarcode(DIO_BARCODE_EAN13_INT, 'EAN13', Barcode, 2);
  PrintBarcode(DIO_BARCODE_CODE128A, 'CODE128A', Barcode, 2);
  PrintBarcode(DIO_BARCODE_CODE128B, 'CODE128B', Barcode, 2);
  PrintBarcode(DIO_BARCODE_CODE128C, 'CODE128C', Barcode, 2);
  PrintBarcode(DIO_BARCODE_CODE39, 'CODE39', Barcode, 2);
  PrintBarcode(DIO_BARCODE_CODE39EXTENDED, 'CODE39EXTENDED', Barcode, 2);
  PrintBarcode(DIO_BARCODE_CODE93, 'CODE93', Barcode, 2);
  PrintBarcode(DIO_BARCODE_MSI, 'MSI', Barcode, 2);
  PrintBarcode(DIO_BARCODE_EAN8, 'EAN8', Barcode, 2);
  PrintBarcode(DIO_BARCODE_EAN13, 'EAN13', Barcode, 2);
  PrintBarcode(DIO_BARCODE_UPC_A, 'UPC_A', Barcode, 2);
end;

procedure TfmFptrDirectIOBarcode.Print2DBarcodes;
const
  Barcode = 'SHTRIH-M, Moscow';
begin
  PrintBarcode(DIO_BARCODE_QRCODE, 'QRCODE', Barcode, 4);
  PrintBarcode(DIO_BARCODE_AZTEC, 'AZTEC', Barcode, 4);
  PrintBarcode(DIO_BARCODE_DATAMATRIX, 'DATAMATRIX', Barcode, 4);
  PrintBarcode(DIO_BARCODE_PDF417, 'PDF417', Barcode, 2);
  PrintBarcode(DIO_BARCODE_MICROQR, 'MICROQR', Barcode, 4);
  PrintBarcode(DIO_BARCODE_AZRUNE, 'AZRUNE', '123456789', 3);
  PrintBarcode(DIO_BARCODE_PDF417TRUNC, 'PDF417TRUNC', Barcode, 2);
  PrintBarcode(DIO_BARCODE_MICROPDF417, 'MICROPDF417', Barcode, 2);
end;

procedure TfmFptrDirectIOBarcode.btnPrint1DClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetPrinter;
    FiscalPrinter.BeginNonFiscal;
    Print1DBarcodes;
    FiscalPrinter.EndNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOBarcode.btnPrint2DClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetPrinter;
    FiscalPrinter.BeginNonFiscal;
    Print2DBarcodes;
    FiscalPrinter.EndNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOBarcode.btnPrintAllClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetPrinter;
    FiscalPrinter.BeginNonFiscal;
    Print1DBarcodes;
    Print2DBarcodes;
    FiscalPrinter.EndNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOBarcode.btnPrintBarcodeClick(Sender: TObject);
const
  BarcodeTypes: array [0..7] of Integer = (
    DIO_BARCODE_QRCODE,
    DIO_BARCODE_MICROQR,
    DIO_BARCODE_AZTEC,
    DIO_BARCODE_AZRUNE,
    DIO_BARCODE_DATAMATRIX,
    DIO_BARCODE_PDF417,
    DIO_BARCODE_PDF417TRUNC,
    DIO_BARCODE_MICROPDF417);
var
  Barcode: WideString;
  BarcodeName: WideString;
  BarcodeType: Integer;
  ModuleSize: Integer;
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetPrinter;
    FiscalPrinter.BeginNonFiscal;

    BarcodeName := cbBarcodeType.Text;
    BarcodeType :=  BarcodeTypes[cbBarcodeType.ItemIndex];
    Barcode := memBarcode.Text;
    ModuleSize := cbModuleSize.ItemIndex + 1;


    PrintBarcode(BarcodeType, BarcodeName, Barcode, ModuleSize);

    FiscalPrinter.EndNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOBarcode.FormCreate(Sender: TObject);
begin
  cbBarcodeType.ItemIndex := 0;
  cbModuleSize.ItemIndex := 3;
  cbAlignment.ItemIndex := 0;
end;

procedure TfmFptrDirectIOBarcode.btnPrintBarcodeHexClick(Sender: TObject);
const
  BarcodeTypes: array [0..7] of Integer = (
    DIO_BARCODE_QRCODE,
    DIO_BARCODE_MICROQR,
    DIO_BARCODE_AZTEC,
    DIO_BARCODE_AZRUNE,
    DIO_BARCODE_DATAMATRIX,
    DIO_BARCODE_PDF417,
    DIO_BARCODE_PDF417TRUNC,
    DIO_BARCODE_MICROPDF417);
var
  Barcode: WideString;
  BarcodeName: WideString;
  BarcodeType: Integer;
  ModuleSize: Integer;
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetPrinter;
    FiscalPrinter.BeginNonFiscal;

    BarcodeName := cbBarcodeType.Text;
    BarcodeType :=  BarcodeTypes[cbBarcodeType.ItemIndex];
    Barcode := memBarcode.Text;
    ModuleSize := cbModuleSize.ItemIndex + 1;


    PrintBarcodeHex(BarcodeType, BarcodeName, Barcode, ModuleSize);

    FiscalPrinter.EndNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

end.
