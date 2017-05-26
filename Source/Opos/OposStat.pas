unit OposStat;

/////////////////////////////////////////////////////////////////////
//
// OposStat.h
//
//   Statistic names header file for OPOS Applications.
//
// Modification history
// ------------------------------------------------------------------
// 2004-07-14 OPOS Release 1.8.1                                  CRM
//   New file to define constants for Device Statistic names.
// 2007-01-30 OPOS Release 1.11                                   CRM
//   Add values for 1.10 and 1.11.
//
/////////////////////////////////////////////////////////////////////

interface

const
  // Common Statistics for all Device Categories.
  OPOS_STAT_HoursPoweredCount                 = 'HoursPoweredCount';
  OPOS_STAT_CommunicationErrorCount           = 'CommunicationErrorCount';

  // Statistics for the Biometrics device category.
  OPOS_STAT_SuccessfulMatchCount              = 'SuccessfulMatchCount';
  OPOS_STAT_UnsuccessfulMatchCount            = 'UnsuccessfulMatchCount';
  OPOS_STAT_AverageFAR                        = 'AverageFAR';
  OPOS_STAT_AverageFRR                        = 'AverageFRR';

  // Statistics for the BumpBar device category.
  OPOS_STAT_BumpCount                         = 'BumpCount';

  // Statistics for the CashDrawer device category.
  OPOS_STAT_DrawerGoodOpenCount               = 'DrawerGoodOpenCount';
  OPOS_STAT_DrawerFailedOpenCount             = 'DrawerFailedOpenCount';

  // Statistics for the ElectronicJournal device category.
  OPOS_STAT_WriteCount                        = 'WriteCount';
  OPOS_STAT_FailedWriteCount                  = 'FailedWriteCount';
  OPOS_STAT_EraseCount                        = 'EraseCount';
  OPOS_STAT_MediumRemovedCount                = 'MediumRemovedCount';
  OPOS_STAT_MediumSize                        = 'MediumSize';
  OPOS_STAT_MediumFreeSpace                   = 'MediumFreeSpace';

  // Statistics for the FiscalPrinter device category.
  OPOS_STAT_BarcodePrintedCount               = 'BarcodePrintedCount';
  OPOS_STAT_FormInsertionCount                = 'FormInsertionCount';
  OPOS_STAT_HomeErrorCount                    = 'HomeErrorCount';
  OPOS_STAT_JournalCharacterPrintedCount      = 'JournalCharacterPrintedCount';
  OPOS_STAT_JournalLinePrintedCount           = 'JournalLinePrintedCount';
  OPOS_STAT_MaximumTempReachedCount           = 'MaximumTempReachedCount';
  OPOS_STAT_NVRAMWriteCount                   = 'NVRAMWriteCount';
  OPOS_STAT_PaperCutCount                     = 'PaperCutCount';
  OPOS_STAT_FailedPaperCutCount               = 'FailedPaperCutCount';
  OPOS_STAT_PrinterFaultCount                 = 'PrinterFaultCount';
  OPOS_STAT_PrintSideChangeCount              = 'PrintSideChangeCount';
  OPOS_STAT_FailedPrintSideChangeCount        = 'FailedPrintSideChangeCount';
  OPOS_STAT_ReceiptCharacterPrintedCount      = 'ReceiptCharacterPrintedCount';
  OPOS_STAT_ReceiptCoverOpenCount             = 'ReceiptCoverOpenCount';
  OPOS_STAT_ReceiptLineFeedCount              = 'ReceiptLineFeedCount';
  OPOS_STAT_ReceiptLinePrintedCount           = 'ReceiptLinePrintedCount';
  OPOS_STAT_SlipCharacterPrintedCount         = 'SlipCharacterPrintedCount';
  OPOS_STAT_SlipCoverOpenCount                = 'SlipCoverOpenCount';
  OPOS_STAT_SlipLineFeedCount                 = 'SlipLineFeedCount';
  OPOS_STAT_SlipLinePrintedCount              = 'SlipLinePrintedCount';
  OPOS_STAT_StampFiredCount                   = 'StampFiredCount';

  // Statistics for the ImageScanner device category.
  OPOS_STAT_GoodReadCount                     = 'GoodReadCount';
  OPOS_STAT_NoReadCount                       = 'NoReadCount';
  OPOS_STAT_SessionCount                      = 'SessionCount';

  // Statistics for the Keylock device category.
  OPOS_STAT_LockPositionChangeCount           = 'LockPositionChangeCount';

  // Statistics for the LineDisplay device category.
  OPOS_STAT_OnlineTransitionCount             = 'OnlineTransitionCount';

  // Statistics for the MICR device category.
  OPOS_STAT_MICR_GoodReadCount                     = 'GoodReadCount';
  OPOS_STAT_MICR_FailedReadCount                   = 'FailedReadCount';
  OPOS_STAT_MICR_FailedDataParseCount              = 'FailedDataParseCount';

  // Statistics for the MotionSensor device category.
  OPOS_STAT_MotionEventCount                  = 'MotionEventCount';

  // Statistics for the MSR device category.
  OPOS_STAT_MSR_GoodReadCount                     = 'GoodReadCount';
  OPOS_STAT_MSR_FailedReadCount                   = 'FailedReadCount';
  OPOS_STAT_MSR_UnreadableCardCount               = 'UnreadableCardCount';
  OPOS_STAT_MSR_GoodWriteCount                    = 'GoodWriteCount';
  OPOS_STAT_MSR_FailedWriteCount                  = 'FailedWriteCount';
  OPOS_STAT_MSR_MissingStartSentinelTrack1Count   = 'MissingStartSentinelTrack1Count';
  OPOS_STAT_MSR_ParityLRCErrorTrack1Count         = 'ParityLRCErrorTrack1Count';
  OPOS_STAT_MSR_MissingStartSentinelTrack2Count   = 'MissingStartSentinelTrack2Count';
  OPOS_STAT_MSR_ParityLRCErrorTrack2Count         = 'ParityLRCErrorTrack2Count';
  OPOS_STAT_MSR_MissingStartSentinelTrack3Count   = 'MissingStartSentinelTrack3Count';
  OPOS_STAT_MSR_ParityLRCErrorTrack3Count         = 'ParityLRCErrorTrack3Count';
  OPOS_STAT_MSR_MissingStartSentinelTrack4Count   = 'MissingStartSentinelTrack4Count';
  OPOS_STAT_MSR_ParityLRCErrorTrack4Count         = 'ParityLRCErrorTrack4Count';

  // Statistics for the PINPad device category.
  OPOS_STAT_ValidPINEntryCount                = 'ValidPINEntryCount';
  OPOS_STAT_InvalidPINEntryCount              = 'InvalidPINEntryCount';

  // Statistics for the POSKeyboard device category.
  OPOS_STAT_KeyPressedCount                   = 'KeyPressedCount';

  // Statistics for the POSPrinter device category.
  OPOS_STAT_PPRN_BarcodePrintedCount               = 'BarcodePrintedCount';
  OPOS_STAT_PPRN_FormInsertionCount                = 'FormInsertionCount';
  OPOS_STAT_PPRN_HomeErrorCount                    = 'HomeErrorCount';
  OPOS_STAT_PPRN_JournalCharacterPrintedCount      = 'JournalCharacterPrintedCount';
  OPOS_STAT_PPRN_JournalLinePrintedCount           = 'JournalLinePrintedCount';
  OPOS_STAT_PPRN_MaximumTempReachedCount           = 'MaximumTempReachedCount';
  OPOS_STAT_PPRN_NVRAMWriteCount                   = 'NVRAMWriteCount';
  OPOS_STAT_PPRN_PaperCutCount                     = 'PaperCutCount';
  OPOS_STAT_PPRN_FailedPaperCutCount               = 'FailedPaperCutCount';
  OPOS_STAT_PPRN_PrinterFaultCount                 = 'PrinterFaultCount';
  OPOS_STAT_PPRN_PrintSideChangeCount              = 'PrintSideChangeCount';
  OPOS_STAT_PPRN_FailedPrintSideChangeCount        = 'FailedPrintSideChangeCount';
  OPOS_STAT_PPRN_ReceiptCharacterPrintedCount      = 'ReceiptCharacterPrintedCount';
  OPOS_STAT_PPRN_ReceiptCoverOpenCount             = 'ReceiptCoverOpenCount';
  OPOS_STAT_PPRN_ReceiptLineFeedCount              = 'ReceiptLineFeedCount';
  OPOS_STAT_PPRN_ReceiptLinePrintedCount           = 'ReceiptLinePrintedCount';
  OPOS_STAT_PPRN_SlipCharacterPrintedCount         = 'SlipCharacterPrintedCount';
  OPOS_STAT_PPRN_SlipCoverOpenCount                = 'SlipCoverOpenCount';
  OPOS_STAT_PPRN_SlipLineFeedCount                 = 'SlipLineFeedCount';
  OPOS_STAT_PPRN_SlipLinePrintedCount              = 'SlipLinePrintedCount';
  OPOS_STAT_PPRN_StampFiredCount                   = 'StampFiredCount';

  // Statistics for the Scale device category.
  OPOS_STAT_GoodWeightReadCount               = 'GoodWeightReadCount';

  // Statistics for the Scanner device category.
  OPOS_STAT_GoodScanCount                     = 'GoodScanCount';

  // Statistics for the SignatureCapture device category.
  OPOS_STAT_GoodSignatureReadCount            = 'GoodSignatureReadCount';
  OPOS_STAT_FailedSignatureReadCount          = 'FailedSignatureReadCount';

  // Statistics for the ToneIndicator device category.
  OPOS_STAT_ToneSoundedCount                  = 'ToneSoundedCount';

implementation

end.


