unit FiscalPrinterStatistics;

interface

uses
  // This
  OposStat, OposStatistics,
  // This
  LogFile;

type
  { TFiscalPrinterStatistics }

  TFiscalPrinterStatistics = class(TOposStatistics)
  private
  public
    constructor Create(ALogger: ILogFile); override;

    procedure PaperCutted;
    procedure PaperCutFailed;
    procedure BarcodePrinted;
    procedure FormInserted;
    procedure PrinterFaulted;
    procedure ReceiptLinePrinted;
    procedure JournalLinePrinted;
    procedure ReceiptCoverOpened;
    procedure JournalCharactersPrinted(Count: Integer);
    procedure ReceiptCharactersPrinted(Count: Integer);
    procedure ReceiptLineFeed;
  end;

implementation

{ TFiscalPrinterStatistics }

constructor TFiscalPrinterStatistics.Create(ALogger: ILogFile);
begin
  inherited Create(ALogger);
  // Statistics for the FiscalPrinter device category.
  Add(OPOS_STAT_BarcodePrintedCount);
  Add(OPOS_STAT_FormInsertionCount);
  Add(OPOS_STAT_HomeErrorCount);
  Add(OPOS_STAT_JournalCharacterPrintedCount);
  Add(OPOS_STAT_JournalLinePrintedCount);
  Add(OPOS_STAT_MaximumTempReachedCount);
  Add(OPOS_STAT_NVRAMWriteCount);
  Add(OPOS_STAT_PaperCutCount);
  Add(OPOS_STAT_FailedPaperCutCount);
  Add(OPOS_STAT_PrinterFaultCount);
  Add(OPOS_STAT_PrintSideChangeCount);
  Add(OPOS_STAT_FailedPrintSideChangeCount);
  Add(OPOS_STAT_ReceiptCharacterPrintedCount);
  Add(OPOS_STAT_ReceiptCoverOpenCount);
  Add(OPOS_STAT_ReceiptLineFeedCount);
  Add(OPOS_STAT_ReceiptLinePrintedCount);
  Add(OPOS_STAT_SlipCharacterPrintedCount);
  Add(OPOS_STAT_SlipCoverOpenCount);
  Add(OPOS_STAT_SlipLineFeedCount);
  Add(OPOS_STAT_SlipLinePrintedCount);
  Add(OPOS_STAT_StampFiredCount);
end;

procedure TFiscalPrinterStatistics.BarcodePrinted;
begin
  IncItem(OPOS_STAT_BarcodePrintedCount);
end;

procedure TFiscalPrinterStatistics.FormInserted;
begin
  IncItem(OPOS_STAT_FormInsertionCount);
end;

procedure TFiscalPrinterStatistics.JournalCharactersPrinted(Count: Integer);
begin
  IncItem(OPOS_STAT_JournalCharacterPrintedCount, Count);
end;

procedure TFiscalPrinterStatistics.JournalLinePrinted;
begin
  IncItem(OPOS_STAT_JournalLinePrintedCount);
end;

procedure TFiscalPrinterStatistics.PaperCutted;
begin
  IncItem(OPOS_STAT_PaperCutCount);
end;

procedure TFiscalPrinterStatistics.PaperCutFailed;
begin
  IncItem(OPOS_STAT_PaperCutCount);
end;

procedure TFiscalPrinterStatistics.PrinterFaulted;
begin
  IncItem(OPOS_STAT_PrinterFaultCount);
end;

procedure TFiscalPrinterStatistics.ReceiptCharactersPrinted(
  Count: Integer);
begin
  IncItem(OPOS_STAT_ReceiptCharacterPrintedCount, Count);
end;

procedure TFiscalPrinterStatistics.ReceiptLinePrinted;
begin
  IncItem(OPOS_STAT_ReceiptLinePrintedCount);
end;

procedure TFiscalPrinterStatistics.ReceiptLineFeed;
begin
  IncItem(OPOS_STAT_ReceiptLineFeedCount);
end;

procedure TFiscalPrinterStatistics.ReceiptCoverOpened;
begin
  IncItem(OPOS_STAT_ReceiptCoverOpenCount);
end;

end.
