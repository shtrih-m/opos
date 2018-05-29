unit fmuFptrDirectIOFS;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Spin,
  // Tnt
  TntStdCtrls,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos, OposFptr, SMFiscalPrinter;

type
  { TfmFptrDirectIOFS }

  TfmFptrDirectIOFS = class(TPage)
    Memo: TTntMemo;
    lblDocNumber: TTntLabel;
    seDocumentNumber: TSpinEdit;
    btnReadFSDocument: TTntButton;
    btnPrintFSDocument: TTntButton;
    procedure btnReadFSDocumentClick(Sender: TObject);
    procedure btnPrintFSDocumentClick(Sender: TObject);
  private
  end;

implementation

{$R *.DFM}

{ TfmFptrDirectIOFS }

procedure TfmFptrDirectIOFS.btnReadFSDocumentClick(Sender: TObject);
var
  S: WideString;
begin
  EnableButtons(False);
  try
    Memo.Clear;
    FiscalPrinter.ReadFSDocument(seDocumentNumber.Value, S);
    Memo.Text := S;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOFS.btnPrintFSDocumentClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintFSDocument(seDocumentNumber.Value);
  finally
    EnableButtons(True);
  end;
end;

end.
