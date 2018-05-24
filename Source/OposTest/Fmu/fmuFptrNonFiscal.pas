unit fmuFptrNonFiscal;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter;

type
  { TfmNonFisc }

  TfmFptrNonFiscal = class(TPage)
    btnEndNonFiscal: TTntButton;
    lblStation: TTntLabel;
    edtStation: TTntEdit;
    lblData: TTntLabel;
    btnBeginNonFiscal: TTntButton;
    btnPrintNormal: TTntButton;
    chbReceipt: TTntCheckBox;
    chbJournal: TTntCheckBox;
    chbSlip: TTntCheckBox;
    Memo: TTntMemo;
    procedure btnEndNonFiscalClick(Sender: TObject);
    procedure btnBeginNonFiscalClick(Sender: TObject);
    procedure btnPrintNormalClick(Sender: TObject);
    procedure chbReceiptClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

const
  FPTR_S_JOURNAL = 1;
  FPTR_S_RECEIPT = 2;
  FPTR_S_SLIP    = 4;

procedure TfmFptrNonFiscal.btnBeginNonFiscalClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.BeginNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrNonFiscal.btnEndNonFiscalClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.EndNonFiscal;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrNonFiscal.btnPrintNormalClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintNormal(StrToInt(edtStation.Text), Memo.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrNonFiscal.chbReceiptClick(Sender: TObject);
var
  I: Integer;
begin
  I := 0;
  if chbReceipt.Checked then I := FPTR_S_RECEIPT;
  if chbJournal.Checked then I := I + FPTR_S_JOURNAL;
  if chbSlip.Checked then I := I + FPTR_S_SLIP;
  edtStation.Text := IntToStr(I);
end;

end.
