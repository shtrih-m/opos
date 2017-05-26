unit OposFptrhi;

//////////////////////////////////////////////////////////////////////
//
// OposFptr.hi
//
//   Fiscal Printer header file for OPOS Controls and Service Objects.
//
// Modification history
// -------------------------------------------------------------------
// 1998-03-06 OPOS Release 1.3                                   PDU
// 2001-07-15 OPOS Release 1.6                                   TNN
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Remove validation functions.
// 2007-01-30 OPOS Release 1.11                                  CRM
//
//////////////////////////////////////////////////////////////////////

interface

uses
  // This
  Oposhi;

const

//////////////////////////////////////////////////////////////////////
// Numeric Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDXFptr_AmountDecimalPlaces =   1 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_AsyncMode           =   2 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CheckTotal          =   3 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CountryCode         =   4 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CoverOpen           =   5 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_DayOpened           =   6 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_DescriptionLength   =   7 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_DuplicateReceipt    =   8 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_ErrorLevel          =   9 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_ErrorOutID          =  10 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_ErrorState          =  11 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_ErrorStation        =  12 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_FlagWhenIdle        =  13 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_JrnEmpty            =  14 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_JrnNearEnd          =  15 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_MessageLength       =  16 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_NumHeaderLines      =  17 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_NumTrailerLines     =  18 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_NumVatRates         =  19 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_PrinterState        =  20 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_QuantityDecimalPlaces
                                        =  21 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_QuantityLength      =  22 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_RecEmpty            =  23 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_RecNearEnd          =  24 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_RemainingFiscalMemory
                                        =  25 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_SlpEmpty            =  26 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_SlpNearEnd          =  27 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_SlipSelection       =  28 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_TrainingModeActive  =  29 + PIDX_FPTR+PIDX_NUMBER;

//      Added for Release 1.6:
  PIDXFptr_ActualCurrency      =  30 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_ContractorId        =  31 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_DateType            =  32 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_FiscalReceiptStation
                                        =  33 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_FiscalReceiptType   =  34 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_MessageType         =  35 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_TotalizerType       =  36 + PIDX_FPTR+PIDX_NUMBER;


// * Capabilities *

  PIDXFptr_CapAdditionalLines  = 501 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapAmountAdjustment = 502 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapAmountNotPaid    = 503 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapCheckTotal       = 504 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapCoverSensor      = 505 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapDoubleWidth      = 506 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapDuplicateReceipt = 507 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapFixedOutput      = 508 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapHasVatTable      = 509 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapIndependentHeader
                                        = 510 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapItemList         = 511 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_CapJrnEmptySensor   = 512 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapJrnNearEndSensor = 513 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapJrnPresent       = 514 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_CapNonFiscalMode    = 515 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapOrderAdjustmentFirst
                                        = 516 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapPercentAdjustment
                                        = 517 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapPositiveAdjustment
                                        = 518 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapPowerLossReport  = 519 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapPredefinedPaymentLines
                                        = 520 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapReceiptNotPaid   = 521 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_CapRecEmptySensor   = 522 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapRecNearEndSensor = 523 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapRecPresent       = 524 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_CapRemainingFiscalMemory
                                        = 525 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapReservedWord     = 526 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSetHeader        = 527 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSetPOSID         = 528 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSetStoreFiscalID = 529 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSetTrailer       = 530 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSetVatTable      = 531 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_CapSlpEmptySensor   = 532 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSlpFiscalDocument
                                        = 533 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSlpFullSlip      = 534 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSlpNearEndSensor = 535 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSlpPresent       = 536 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSlpValidation    = 537 + PIDX_FPTR+PIDX_NUMBER;

  PIDXFptr_CapSubAmountAdjustment
                                        = 538 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSubPercentAdjustment
                                        = 539 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSubtotal         = 540 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapTrainingMode     = 541 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapValidateJournal  = 542 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapXReport          = 543 + PIDX_FPTR+PIDX_NUMBER;

//      Added for Release 1.6:
  PIDXFptr_CapAdditionalHeader = 544 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapAdditionalTrailer
                                        = 545 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapChangeDue        = 546 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapEmptyReceiptIsVoidable
                                        = 547 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapFiscalReceiptStation
                                        = 548 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapFiscalReceiptType
                                        = 549 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapMultiContractor  = 550 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapOnlyVoidLastItem = 551 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapPackageAdjustment
                                        = 552 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapPostPreLine      = 553 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapSetCurrency      = 554 + PIDX_FPTR+PIDX_NUMBER;
  PIDXFptr_CapTotalizerType    = 555 + PIDX_FPTR+PIDX_NUMBER;

//      Added for Release 1.11:
  PIDXFptr_CapPositiveSubtotalAdjustment
                                        = 556 + PIDX_FPTR+PIDX_NUMBER;


//////////////////////////////////////////////////////////////////////
// String Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDXFptr_ErrorString         =   1 + PIDX_FPTR+PIDX_STRING;
  PIDXFptr_PredefinedPaymentLines
                                        =   2 + PIDX_FPTR+PIDX_STRING;
  PIDXFptr_ReservedWord        =   3 + PIDX_FPTR+PIDX_STRING;

//      Added for Release 1.6:
  PIDXFptr_AdditionalHeader    =   4 + PIDX_FPTR+PIDX_STRING;
  PIDXFptr_AdditionalTrailer   =   5 + PIDX_FPTR+PIDX_STRING;
  PIDXFptr_ChangeDue           =   6 + PIDX_FPTR+PIDX_STRING;
  PIDXFptr_PostLine            =   7 + PIDX_FPTR+PIDX_STRING;
  PIDXFptr_PreLine             =   8 + PIDX_FPTR+PIDX_STRING;

implementation


end.
