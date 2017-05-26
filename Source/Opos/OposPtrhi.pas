unit OposPtrhi;

//////////////////////////////////////////////////////////////////////
//
// OposPtr.hi
//
//   POS Printer header file for OPOS Controls and Service Objects.
//
// Modification history
// -------------------------------------------------------------------
// 1995-12-08 OPOS Release 1.0                                   CRM
// 1996-03-18 OPOS Release 1.01                                  CRM
//   Change ...Nearend to ...NearEnd.
//   Change ...Barcode to ...BarCode.
//   Corrected IsValidPtrNumericPidx function.
// 1996-04-22 OPOS Release 1.1                                   CRM
//   Add the following properties:
//     CapCharacterSet, CapTransaction, ErrorLevel, RotateSpecial,
//     ErrorString, FontTypefaceList, RecBarCodeRotationList,
//     SlpBarCodeRotationList
// 2000-09-24 OPOS Release 1.5                                   BKS
//   Add the following properties:
//     CapJrnCartridgeSensor, CapJrnColor, CapRecCartrdigeSensor,
//     CapRecColor, CapRecMarkFeed, CapSlpBothSidesPrint,
//     CapSlpCartridgeSensor, CapSlpColor, CartridgeNotify,
//     JrnCartridgeState, JrnCurrentCartridge, RecCartridgeState,
//     RecCurrentCartridge, SlpPrintSide, SlpCartridgeState,
//     SlpCurrentCartridge
// 2002-08-17 OPOS Release 1.7                                   CRM
//   Add the following properties:
//     MapCharacterSet, RecBitmapRotationList,
//     SlpBitmapRotationList
//   Added CapMapCharacterSet capability.
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Add the following properties:
//     CapConcurrentPageMode, CapRecPageMode, CapSlpPageMode,
//     PageModeArea, PageModeDescriptor, PageModeHorizontalPosition,
//     PageModePrintArea, PageModePrintDirection, PageModeStation,
//     PageModeVerticalPosition
//   Remove validation functions.
//
//////////////////////////////////////////////////////////////////////

interface

uses
  Oposhi;

const

//////////////////////////////////////////////////////////////////////
// Numeric Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDXPtr_AsyncMode                    =   1 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CharacterSet                 =   2 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CoverOpen                    =   3 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_ErrorStation                 =   4 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_FlagWhenIdle                 =   5 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_JrnEmpty                     =   6 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnLetterQuality             =   7 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnLineChars                 =   8 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnLineHeight                =   9 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnLineSpacing               =  10 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnLineWidth                 =  11 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnNearEnd                   =  12 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_MapMode                      =  13 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_RecEmpty                     =  14 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecLetterQuality             =  15 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecLineChars                 =  16 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecLineHeight                =  17 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecLineSpacing               =  18 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecLinesToPaperCut           =  19 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecLineWidth                 =  20 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecNearEnd                   =  21 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecSidewaysMaxChars          =  22 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecSidewaysMaxLines          =  23 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_SlpEmpty                     =  24 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpLetterQuality             =  25 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpLineChars                 =  26 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpLineHeight                =  27 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpLinesNearEndToEnd         =  28 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpLineSpacing               =  29 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpLineWidth                 =  30 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpMaxLines                  =  31 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpNearEnd                   =  32 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpSidewaysMaxChars          =  33 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpSidewaysMaxLines          =  34 + PIDX_PTR+PIDX_NUMBER;

//      Added for Release 1.1:
  PIDXPtr_ErrorLevel                   =  35 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RotateSpecial                =  36 + PIDX_PTR+PIDX_NUMBER;

//      Added for Release 1.5:
  PIDXPtr_CartridgeNotify              =  37 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnCartridgeState            =  38 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_JrnCurrentCartridge          =  39 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecCartridgeState            =  40 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_RecCurrentCartridge          =  41 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpPrintSide                 =  42 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpCartridgeState            =  43 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_SlpCurrentCartridge          =  44 + PIDX_PTR+PIDX_NUMBER;

// Added in Release 1.7
  PIDXPtr_MapCharacterSet              =  45 + PIDX_PTR+PIDX_NUMBER;

// Added in Release 1.9
  PIDXPtr_PageModeDescriptor           =  46 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_PageModeHorizontalPosition   =  47 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_PageModePrintDirection       =  48 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_PageModeStation              =  49 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_PageModeVerticalPosition     =  50 + PIDX_PTR+PIDX_NUMBER;

// * Capabilities *

  PIDXPtr_CapConcurrentJrnRec          = 501 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapConcurrentJrnSlp          = 502 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapConcurrentRecSlp          = 503 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapCoverSensor               = 504 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_CapJrn2Color                 = 505 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnBold                   = 506 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnDhigh                  = 507 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnDwide                  = 508 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnDwideDhigh             = 509 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnEmptySensor            = 510 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnItalic                 = 511 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnNearEndSensor          = 512 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnPresent                = 513 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnUnderline              = 514 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_CapRec2Color                 = 515 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecBarCode                = 516 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecBitmap                 = 517 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecBold                   = 518 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecDhigh                  = 519 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecDwide                  = 520 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecDwideDhigh             = 521 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecEmptySensor            = 522 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecItalic                 = 523 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecLeft90                 = 524 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecNearEndSensor          = 525 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecPapercut               = 526 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecPresent                = 527 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecRight90                = 528 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecRotate180              = 529 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecStamp                  = 530 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecUnderline              = 531 + PIDX_PTR+PIDX_NUMBER;

  PIDXPtr_CapSlp2Color                 = 532 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpBarCode                = 533 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpBitmap                 = 534 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpBold                   = 535 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpDhigh                  = 536 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpDwide                  = 537 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpDwideDhigh             = 538 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpEmptySensor            = 539 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpFullslip               = 540 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpItalic                 = 541 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpLeft90                 = 542 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpNearEndSensor          = 543 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpPresent                = 544 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpRight90                = 545 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpRotate180              = 546 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpUnderline              = 547 + PIDX_PTR+PIDX_NUMBER;

//      Added for Release 1.1:
  PIDXPtr_CapCharacterSet              = 548 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapTransaction               = 549 + PIDX_PTR+PIDX_NUMBER;

//      Added for Release 1.5:
  PIDXPtr_CapJrnCartridgeSensor        = 550 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapJrnColor                  = 551 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecCartridgeSensor        = 552 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecColor                  = 553 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecMarkFeed               = 554 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpBothSidesPrint         = 555 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpCartridgeSensor        = 556 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpColor                  = 557 + PIDX_PTR+PIDX_NUMBER;

// Added in Release 1.7
  PIDXPtr_CapMapCharacterSet           = 558 + PIDX_PTR+PIDX_NUMBER;

// Added in Release 1.9
  PIDXPtr_CapConcurrentPageMode        = 559 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapRecPageMode               = 560 + PIDX_PTR+PIDX_NUMBER;
  PIDXPtr_CapSlpPageMode               = 561 + PIDX_PTR+PIDX_NUMBER;


//////////////////////////////////////////////////////////////////////
// String Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDXPtr_CharacterSetList             =   1 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_JrnLineCharsList             =   2 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_RecLineCharsList             =   3 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_SlpLineCharsList             =   4 + PIDX_PTR+PIDX_STRING;

//      Added for Release 1.1:
  PIDXPtr_ErrorString                  =   5 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_FontTypefaceList             =   6 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_RecBarCodeRotationList       =   7 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_SlpBarCodeRotationList       =   8 + PIDX_PTR+PIDX_STRING;

// Added in Release 1.7
  PIDXPtr_RecBitmapRotationList        =   9 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_SlpBitmapRotationList        =  10 + PIDX_PTR+PIDX_STRING;

// Added in Release 1.9
  PIDXPtr_PageModeArea                 =  11 + PIDX_PTR+PIDX_STRING;
  PIDXPtr_PageModePrintArea            =  12 + PIDX_PTR+PIDX_STRING;


implementation

end.
