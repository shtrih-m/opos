unit fmuFptrDirectIOFS;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Spin,
  // This
  untPages, OposFiscalPrinter, DirectIOAPI, Opos, OposFptr, SMFiscalPrinter;

type
  { TfmFptrDirectIOFS }

  TfmFptrDirectIOFS = class(TPage)
    Memo: TMemo;
    lblDocNumber: TLabel;
    seDocumentNumber: TSpinEdit;
    btnReadFSDocument: TButton;
    btnPrintFSDocument: TButton;
    procedure btnReadFSDocumentClick(Sender: TObject);
    procedure btnPrintFSDocumentClick(Sender: TObject);
  private
  end;

implementation

{$R *.DFM}

{ TfmFptrDirectIOFS }

procedure TfmFptrDirectIOFS.btnReadFSDocumentClick(Sender: TObject);
var
  S: string;
begin
  EnableButtons(False);
  try
    FiscalPrinter.Check(FiscalPrinter.ReadFSDocument(seDocumentNumber.Value, S));
    Memo.Text := S;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrDirectIOFS.btnPrintFSDocumentClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.Check(FiscalPrinter.PrintFSDocument(seDocumentNumber.Value));
  finally
    EnableButtons(True);
  end;
end;

end.
