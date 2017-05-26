unit fmuFptrJournal;

interface

uses
  // VCL
  ComCtrls, StdCtrls, Controls, Classes,
  // This
  FiscalPrinterDevice, FptrTypes;

type
  { TfmFptrJournal }

  TfmFptrJournal = class(TFptrPage)
    chbJournalPrintHeader: TCheckBox;
    chbJournalPrintTrailer: TCheckBox;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrJournal }

procedure TfmFptrJournal.UpdatePage;
begin
  chbJournalPrintHeader.Checked := Parameters.JournalPrintHeader;
  chbJournalPrintTrailer.Checked := Parameters.JournalPrintTrailer;
end;

procedure TfmFptrJournal.UpdateObject;
begin
  Parameters.JournalPrintHeader := chbJournalPrintHeader.Checked;
  Parameters.JournalPrintTrailer := chbJournalPrintTrailer.Checked;
end;

procedure TfmFptrJournal.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
