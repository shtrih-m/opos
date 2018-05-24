unit fmuFptrSlipInsertion;

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
  TfmFptrSlipInsertion = class(TPage)
    lblTimeout: TTntLabel;
    edtTimeout: TTntEdit;
    btnBeginInsertion: TTntButton;
    btnEndInsertion: TTntButton;
    btnBeginRemoval: TTntButton;
    btnEndRemoval: TTntButton;
    procedure btnBeginInsertionClick(Sender: TObject);
    procedure btnEndInsertionClick(Sender: TObject);
    procedure btnBeginRemovalClick(Sender: TObject);
    procedure btnEndRemovalClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrSlipInsertion.btnBeginInsertionClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.BeginInsertion(StrToInt(edtTimeout.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSlipInsertion.btnEndInsertionClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.EndInsertion;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSlipInsertion.btnBeginRemovalClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.BeginRemoval(StrToInt(edtTimeout.Text));
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSlipInsertion.btnEndRemovalClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.EndRemoval;
  finally
    EnableButtons(True);
  end;
end;

end.
