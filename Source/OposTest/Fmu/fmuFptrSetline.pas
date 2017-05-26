unit fmuFptrSetline;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrSetLine = class(TPage)
    lblLineNumber: TLabel;
    lblHeaderLine: TLabel;
    btnSetHeaderLine: TButton;
    edtLineNumber: TEdit;
    edtHeaderLine: TEdit;
    chbDoubleWidth: TCheckBox;
    btnSetTrailerLine: TButton;
    lblTrailerLine: TLabel;
    edtTrailerLine: TEdit;
    procedure btnSetHeaderLineClick(Sender: TObject);
    procedure btnSetTrailerLineClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrSetLine.btnSetHeaderLineClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.SetHeaderLine(
      StrToInt(edtLineNumber.Text),
      edtHeaderLine.Text,
      chbDoubleWidth.Checked);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSetLine.btnSetTrailerLineClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.SetTrailerLine(
      StrToInt(edtLineNumber.Text),
      edtTrailerLine.Text,
      chbDoubleWidth.Checked);
  finally
    EnableButtons(True);
  end;
end;

end.
