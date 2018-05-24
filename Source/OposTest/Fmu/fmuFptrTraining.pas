unit fmuFptrTraining;

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
  { TfmFptrTraining }

  TfmFptrTraining = class(TPage)
    btnEndTraining: TTntButton;
    lblTrainingModeActive: TTntLabel;
    edtTrainingModeActive: TTntEdit;
    btnBeginTraining: TTntButton;
    procedure btnEndTrainingClick(Sender: TObject);
    procedure btnBeginTrainingClick(Sender: TObject);
  private
    procedure UpdateTrainingModeActive;
  end;

implementation

{$R *.DFM}

{ TfmFptrTraining }

procedure TfmFptrTraining.UpdateTrainingModeActive;
begin
  if FiscalPrinter.TrainingModeActive then
    edtTrainingModeActive.Text := 'True'
  else
    edtTrainingModeActive.Text := 'False';
end;

procedure TfmFptrTraining.btnBeginTrainingClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.BeginTraining;
    UpdateTrainingModeActive;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrTraining.btnEndTrainingClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.EndTraining;
    UpdateTrainingModeActive;
  finally
    EnableButtons(True);
  end;
end;

end.
