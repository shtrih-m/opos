unit fmuFptrStatistics;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  untPages, OposFiscalPrinter, SynEditHighlighter, SynHighlighterXML,
  SynEdit;

type
  TfmFptrStatistics = class(TPage)
    btnResetStatistics: TButton;
    btnRetrieveStatistics: TButton;
    btnUpdateStatistics: TButton;
    SynXMLSyn1: TSynXMLSyn;
    btnClear: TButton;
    mmData: TSynEdit;
    procedure btnResetStatisticsClick(Sender: TObject);
    procedure btnRetrieveStatisticsClick(Sender: TObject);
    procedure btnUpdateStatisticsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmSetDate }

procedure TfmFptrStatistics.btnResetStatisticsClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetStatistics(mmData.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrStatistics.btnRetrieveStatisticsClick(Sender: TObject);
var
  Text: WideString;
begin
  EnableButtons(False);
  try
    FiscalPrinter.RetrieveStatistics(Text);
    mmData.Text := Text;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrStatistics.btnUpdateStatisticsClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.ResetStatistics(mmData.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrStatistics.btnClearClick(Sender: TObject);
begin
  mmData.Clear;
end;

end.
