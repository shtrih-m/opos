unit fmuFptrFiscalDocument;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrFiscalDocument = class(TPage)
    btnBeginFiscalDocument: TTntButton;
    lblAmount: TTntLabel;
    edtAmount: TTntEdit;
    btnEndFiscalDocument: TTntButton;
    btnPrintFiscalDocumentLine: TTntButton;
    lblLine: TTntLabel;
    edtLine: TTntEdit;
    procedure btnBeginFiscalDocumentClick(Sender: TObject);
    procedure btnEndFiscalDocumentClick(Sender: TObject);
    procedure btnPrintFiscalDocumentLineClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrFiscalDocument.btnBeginFiscalDocumentClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.BeginFiscalDocument(StrToInt(edtAmount.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFiscalDocument.btnEndFiscalDocumentClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.EndFiscalDocument();
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFiscalDocument.btnPrintFiscalDocumentLineClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintFiscalDocumentLine(edtLine.Text);
  finally
    EnableButtons(True);
  end;
end;

end.
