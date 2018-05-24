unit fmuFptrSetline;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Tnt
  TntStdCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrSetLine = class(TPage)
    lblLineNumber: TTntLabel;
    lblHeaderLine: TTntLabel;
    btnSetHeaderLine: TTntButton;
    edtLineNumber: TTntEdit;
    edtHeaderLine: TTntEdit;
    chbDoubleWidth: TTntCheckBox;
    btnSetTrailerLine: TTntButton;
    lblTrailerLine: TTntLabel;
    edtTrailerLine: TTntEdit;
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
