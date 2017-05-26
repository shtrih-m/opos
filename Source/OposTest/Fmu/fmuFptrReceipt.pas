unit fmuFptrReceipt;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrReceipt = class(TPage)
    btnBeginFisclReceipt: TButton;
    btnEndFiscalReceipt: TButton;
    chbPrintHeader: TCheckBox;
    btnPrintDuplicateReceipt: TButton;
    lblFiscalReceiptStation: TLabel;
    cbFiscalReceiptStation: TComboBox;
    lblFiscalReceiptType: TLabel;
    cbFiscalReceiptType: TComboBox;
    lblDescription: TLabel;
    btnPrintRecVoid: TButton;
    edtDescription: TEdit;
    procedure btnBeginFisclReceiptClick(Sender: TObject);
    procedure btnEndFiscalReceiptClick(Sender: TObject);
    procedure btnPrintDuplicateReceiptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintRecVoidClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrReceipt.btnBeginFisclReceiptClick(Sender: TObject);
var
  AdditionalHeader: string;
begin
  EnableButtons(False);
  try
    FiscalPrinter.FiscalReceiptStation := cbFiscalReceiptStation.ItemIndex + 1;
    FiscalPrinter.FiscalReceiptType := cbFiscalReceiptType.ItemIndex + 1;

    AdditionalHeader :=
      '****  AdditionalHeader Line 1  ****' + #13#10 +
      '****  AdditionalHeader Line 2  ****';

    FiscalPrinter.AdditionalHeader := AdditionalHeader;
    FiscalPrinter.BeginFiscalReceipt(chbPrintHeader.Checked);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrReceipt.btnEndFiscalReceiptClick(Sender: TObject);
var
  AdditionalTrailer: string;
begin
  EnableButtons(False);
  try
    AdditionalTrailer :=
      '**** AdditionalTrailer Line1 ****' + #13#10 +
      '**** AdditionalTrailer Line2 ****' + #13#10 +
      '**** AdditionalTrailer Line3 ****' + #13#10 +
      '**** AdditionalTrailer Line4 ****';

    FiscalPrinter.AdditionalTrailer := AdditionalTrailer;
    FiscalPrinter.EndFiscalReceipt(chbPrintHeader.Checked);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrReceipt.btnPrintDuplicateReceiptClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintDuplicateReceipt;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrReceipt.FormCreate(Sender: TObject);
begin
  cbFiscalReceiptType.ItemIndex := 3;
  if cbFiscalReceiptStation.Items.Count > 0 then
    cbFiscalReceiptStation.ItemIndex := 0;
end;

procedure TfmFptrReceipt.btnPrintRecVoidClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintRecVoid(edtDescription.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
