unit OposPtr;
/////////////////////////////////////////////////////////////////////
//
// OposPtr.h
//
//   POS Printer header file for OPOS Applications.
//
// Modification history
// ------------------------------------------------------------------
// 1995-12-08 OPOS Release 1.0                                   CRM
// 1996-04-22 OPOS Release 1.1                                   CRM
//   Add CapCharacterSet constants.
//   Add ErrorLevel constants.
//   Add TransactionPrint's Control constants.
// 1997-06-04 OPOS Release 1.2                                   CRM
//   Remove PTR_RP_NORMAL_ASYNC.
//   Add more barcode symbologies.
// 1998-03-06 OPOS Release 1.3                                   CRM
//   Add more PrintTwoNormal constants.
// 2000-09-24 OPOS Release 1.5                             EPSON/BKS
//   Add CapRecMarkFeed and MarkFeed's Type constants.
//   Add ChangePrintSide constants.
//   Add StatusUpdateEvent constants.
//   Add ResultCodeExtended constants.
//   Add CapXxxCartridgeSensor and XxxCartridgeState constants.
//   Add CartridgeNotify constants.
//   Add CapCharacterset and CharacterSet constants for UNICODE.
// 2003-05-29 OPOS Release 1.7                                   CRM
//   Add more RotatePrint's Rotation PTR_RP_* constants.
// 2004-03-22 OPOS Release 1.8                                   CRM
//   Add more constants for PrintBarCode method and StatusUpdateEvent.
// 2004-10-26 Add "CharacterSet" ANSI constant (from 1.5).       CRM
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Add PageModeDescriptor and PageModePrintDirection constants.
//   Add PageModePrint's Control constants.
// 2006-03-15 OPOS Release 1.10                                  CRM
//   Add PrintMemoryBitmap constants.
//
/////////////////////////////////////////////////////////////////////

interface

const

/////////////////////////////////////////////////////////////////////
// Printer Station Constants
/////////////////////////////////////////////////////////////////////

  PTR_S_JOURNAL        = 1;
  PTR_S_RECEIPT        = 2;
  PTR_S_SLIP           = 4;

  PTR_S_JOURNAL_RECEIPT    = $0003;
  PTR_S_JOURNAL_SLIP       = $0005;
  PTR_S_RECEIPT_SLIP       = $0006;

  PTR_TWO_RECEIPT_JOURNAL  = $8003; // (added in 1.3)
  PTR_TWO_SLIP_JOURNAL     = $8005; // (added in 1.3)
  PTR_TWO_SLIP_RECEIPT     = $8006; // (added in 1.3)


/////////////////////////////////////////////////////////////////////
// "CapCharacterSet" Property Constants (added in 1.1)
/////////////////////////////////////////////////////////////////////

  PTR_CCS_ALPHA        =   1;
  PTR_CCS_ASCII        = 998;
  PTR_CCS_KANA         =  10;
  PTR_CCS_KANJI        =  11;
  PTR_CCS_UNICODE      = 997; // (added in 1.5)


/////////////////////////////////////////////////////////////////////
// "CharacterSet" Property Constants
/////////////////////////////////////////////////////////////////////

  PTR_CS_UNICODE       = 997; // (added in 1.5)
  PTR_CS_ASCII         = 998;
  PTR_CS_WINDOWS       = 999;
  PTR_CS_ANSI          = 999;


/////////////////////////////////////////////////////////////////////
// "ErrorLevel" Property Constants (added in 1.1)
/////////////////////////////////////////////////////////////////////

  PTR_EL_NONE          = 1;
  PTR_EL_RECOVERABLE   = 2;
  PTR_EL_FATAL         = 3;


/////////////////////////////////////////////////////////////////////
// "MapMode" Property Constants
/////////////////////////////////////////////////////////////////////

  PTR_MM_DOTS          = 1;
  PTR_MM_TWIPS         = 2;
  PTR_MM_ENGLISH       = 3;
  PTR_MM_METRIC        = 4;


/////////////////////////////////////////////////////////////////////
// "CapXxxColor" Property Constants
/////////////////////////////////////////////////////////////////////

  PTR_COLOR_PRIMARY      = $00000001;
  PTR_COLOR_CUSTOM1      = $00000002;
  PTR_COLOR_CUSTOM2      = $00000004;
  PTR_COLOR_CUSTOM3      = $00000008;
  PTR_COLOR_CUSTOM4      = $00000010;
  PTR_COLOR_CUSTOM5      = $00000020;
  PTR_COLOR_CUSTOM6      = $00000040;
  PTR_COLOR_CYAN         = $00000100;
  PTR_COLOR_MAGENTA      = $00000200;
  PTR_COLOR_YELLOW       = $00000400;
  PTR_COLOR_FULL         = $80000000;


/////////////////////////////////////////////////////////////////////
// "CapXxxCartridgeSensor" and  "XxxCartridgeState" Property Constants
//   (added in 1.5)
/////////////////////////////////////////////////////////////////////

  PTR_CART_UNKNOWN         = $10000000;
  PTR_CART_OK              = $00000000;
  PTR_CART_REMOVED         = $00000001;
  PTR_CART_EMPTY           = $00000002;
  PTR_CART_NEAREND         = $00000004;
  PTR_CART_CLEANING        = $00000008;


/////////////////////////////////////////////////////////////////////
// "CartridgeNotify" Property Constants (added in 1.5)
/////////////////////////////////////////////////////////////////////

  PTR_CN_DISABLED        = $00000000;
  PTR_CN_ENABLED         = $00000001;


/////////////////////////////////////////////////////////////////////
// "PageModeDescriptor" Property Constants (added in 1.9)
/////////////////////////////////////////////////////////////////////

  PTR_PM_BITMAP         = $00000001;
  PTR_PM_BARCODE        = $00000002;
  PTR_PM_BM_ROTATE      = $00000004;
  PTR_PM_BC_ROTATE      = $00000008;
  PTR_PM_OPAQUE         = $00000010;


/////////////////////////////////////////////////////////////////////
// "PageModePrintDirection" Property Constants (added in 1.9)
/////////////////////////////////////////////////////////////////////

  PTR_PD_LEFT_TO_RIGHT = 1;
  PTR_PD_BOTTOM_TO_TOP = 2;
  PTR_PD_RIGHT_TO_LEFT = 3;
  PTR_PD_TOP_TO_BOTTOM = 4;


/////////////////////////////////////////////////////////////////////
// "CutPaper" Method Constant
/////////////////////////////////////////////////////////////////////

  PTR_CP_FULLCUT       = 100;


/////////////////////////////////////////////////////////////////////
// "PageModePrint" Method: "Control" Parameter Constants (added in 1.9)
/////////////////////////////////////////////////////////////////////

  PTR_PM_PAGE_MODE      = 1;
  PTR_PM_PRINT_SAVE     = 2;
  PTR_PM_NORMAL         = 3;
  PTR_PM_CANCEL         = 4;


/////////////////////////////////////////////////////////////////////
// "PrintBarCode" Method Constants:
/////////////////////////////////////////////////////////////////////

//   "Alignment" Parameter
//     Either the distance from the left-most print column to the start
//     of the bar code, or one of the following:

  PTR_BC_LEFT          = -1;
  PTR_BC_CENTER        = -2;
  PTR_BC_RIGHT         = -3;

//   "TextPosition" Parameter

  PTR_BC_TEXT_NONE     = -11;
  PTR_BC_TEXT_ABOVE    = -12;
  PTR_BC_TEXT_BELOW    = -13;

//   "Symbology" Parameter:

//     One dimensional symbologies
  PTR_BCS_UPCA         = 101;  // Digits
  PTR_BCS_UPCE         = 102;  // Digits
  PTR_BCS_JAN8         = 103;  // = EAN 8
  PTR_BCS_EAN8         = 103;  // = JAN 8 (added in 1.2)
  PTR_BCS_JAN13        = 104;  // = EAN 13
  PTR_BCS_EAN13        = 104;  // = JAN 13 (added in 1.2)
  PTR_BCS_TF           = 105;  // (Discrete 2 of 5) Digits
  PTR_BCS_ITF          = 106;  // (Interleaved 2 of 5) Digits
  PTR_BCS_Codabar      = 107;  // Digits, -, $, :, /, ., +;
                                        //   4 start/stop characters
                                        //   (a, b, c, d)
  PTR_BCS_Code39       = 108;  // Alpha, Digits, Space, -, .,
                                        //   $, /, +, %; start/stop (*)
                                        // Also has Full ASCII feature
  PTR_BCS_Code93       = 109;  // Same characters as Code 39
  PTR_BCS_Code128      = 110;  // 128 data characters
//        (Begin additions for 1.2)
  PTR_BCS_UPCA_S       = 111;  // UPC-A with supplemental
                                        //   barcode
  PTR_BCS_UPCE_S       = 112;  // UPC-E with supplemental
                                        //   barcode
  PTR_BCS_UPCD1        = 113;  // UPC-D1
  PTR_BCS_UPCD2        = 114;  // UPC-D2
  PTR_BCS_UPCD3        = 115;  // UPC-D3
  PTR_BCS_UPCD4        = 116;  // UPC-D4
  PTR_BCS_UPCD5        = 117;  // UPC-D5
  PTR_BCS_EAN8_S       = 118;  // EAN 8 with supplemental
                                        //   barcode
  PTR_BCS_EAN13_S      = 119;  // EAN 13 with supplemental
                                        //   barcode
  PTR_BCS_EAN128       = 120;  // EAN 128
  PTR_BCS_OCRA         = 121;  // OCR "A"
  PTR_BCS_OCRB         = 122;  // OCR "B"
//        (End additions for 1.2)
//        (Begin additions for 1.8)
  PTR_BCS_Code128_Parsed=123;  // Code 128 with parsing
  PTR_BCS_RSS14        = 131;  // Reduced Space Symbology - 14 digit GTIN
  PTR_BCS_RSS_EXPANDED = 132;  // RSS - 14 digit GTIN plus additional fields
//        (End additions for 1.8)

//     Two dimensional symbologies
  PTR_BCS_PDF417       = 201;
  PTR_BCS_MAXICODE     = 202;

//     Start of Printer-Specific bar code symbologies
  PTR_BCS_OTHER        = 501;


/////////////////////////////////////////////////////////////////////
// "PrintBitmap" and "PrintMemoryBitmap" Method Constants:
/////////////////////////////////////////////////////////////////////

//   "Width" Parameter
//     Either bitmap width or:

  PTR_BM_ASIS          = -11;  // One pixel per printer dot

//   "Alignment" Parameter
//     Either the distance from the left-most print column to the start
//     of the bitmap, or one of the following:

  PTR_BM_LEFT          = -1;
  PTR_BM_CENTER        = -2;
  PTR_BM_RIGHT         = -3;

//   "Type" Parameter ("PrintMemoryBitmap" only)
  PTR_BMT_BMP          = 1;
  PTR_BMT_JPEG         = 2;
  PTR_BMT_GIF          = 3;


/////////////////////////////////////////////////////////////////////
// "RotatePrint" Method: "Rotation" Parameter Constants
// "RotateSpecial" Property Constants
/////////////////////////////////////////////////////////////////////

  PTR_RP_NORMAL        = $0001;
  PTR_RP_RIGHT90       = $0101;
  PTR_RP_LEFT90        = $0102;
  PTR_RP_ROTATE180     = $0103;

// For "RotatePrint", one or both of the following values may be
// ORed with one of the above values.
  PTR_RP_BARCODE       = $1000; // (added in 1.7)
  PTR_RP_BITMAP        = $2000; // (added in 1.7)


/////////////////////////////////////////////////////////////////////
// "SetLogo" Method: "Location" Parameter Constants
/////////////////////////////////////////////////////////////////////

  PTR_L_TOP            = 1;
  PTR_L_BOTTOM         = 2;


/////////////////////////////////////////////////////////////////////
// "TransactionPrint" Method: "Control" Parameter Constants (added in 1.1)
/////////////////////////////////////////////////////////////////////

  PTR_TP_TRANSACTION   = 11;
  PTR_TP_NORMAL        = 12;


/////////////////////////////////////////////////////////////////////
// "MarkFeed" Method: "Type" Parameter Constants (added in 1.5)
// "CapRecMarkFeed" Property Constants (added in 1.5)
/////////////////////////////////////////////////////////////////////

  PTR_MF_TO_TAKEUP     = 1;
  PTR_MF_TO_CUTTER     = 2;
  PTR_MF_TO_CURRENT_TOF= 4;
  PTR_MF_TO_NEXT_TOF   = 8;


/////////////////////////////////////////////////////////////////////
// "ChangePrintSide" Method: "Side" Parameter Constants (added in 1.5)
/////////////////////////////////////////////////////////////////////

  PTR_PS_UNKNOWN       = 0;
  PTR_PS_SIDE1         = 1;
  PTR_PS_SIDE2         = 2;
  PTR_PS_OPPOSITE      = 3;


/////////////////////////////////////////////////////////////////////
// "StatusUpdateEvent" Event: "Data" Parameter Constants
/////////////////////////////////////////////////////////////////////

  PTR_SUE_COVER_OPEN              = 11;
  PTR_SUE_COVER_OK                = 12;
  PTR_SUE_JRN_COVER_OPEN          = 60;  // (added in 1.8)
  PTR_SUE_JRN_COVER_OK            = 61;  // (added in 1.8)
  PTR_SUE_REC_COVER_OPEN          = 62;  // (added in 1.8)
  PTR_SUE_REC_COVER_OK            = 63;  // (added in 1.8)
  PTR_SUE_SLP_COVER_OPEN          = 64;  // (added in 1.8)
  PTR_SUE_SLP_COVER_OK            = 65;  // (added in 1.8)

  PTR_SUE_JRN_EMPTY               = 21;
  PTR_SUE_JRN_NEAREMPTY           = 22;
  PTR_SUE_JRN_PAPEROK             = 23;

  PTR_SUE_REC_EMPTY               = 24;
  PTR_SUE_REC_NEAREMPTY           = 25;
  PTR_SUE_REC_PAPEROK             = 26;

  PTR_SUE_SLP_EMPTY               = 27;
  PTR_SUE_SLP_NEAREMPTY           = 28;
  PTR_SUE_SLP_PAPEROK             = 29;

  PTR_SUE_JRN_CARTRIDGE_EMPTY     = 41; // (added in 1.5)
  PTR_SUE_JRN_CARTRIDGE_NEAREMPTY = 42; // (added in 1.5)
  PTR_SUE_JRN_HEAD_CLEANING       = 43; // (added in 1.5)
  PTR_SUE_JRN_CARTRIDGE_OK        = 44; // (added in 1.5)

  PTR_SUE_REC_CARTRIDGE_EMPTY     = 45; // (added in 1.5)
  PTR_SUE_REC_CARTRIDGE_NEAREMPTY = 46; // (added in 1.5)
  PTR_SUE_REC_HEAD_CLEANING       = 47; // (added in 1.5)
  PTR_SUE_REC_CARTRIDGE_OK        = 48; // (added in 1.5)

  PTR_SUE_SLP_CARTRIDGE_EMPTY     = 49; // (added in 1.5)
  PTR_SUE_SLP_CARTRIDGE_NEAREMPTY = 50; // (added in 1.5)
  PTR_SUE_SLP_HEAD_CLEANING       = 51; // (added in 1.5)
  PTR_SUE_SLP_CARTRIDGE_OK        = 52; // (added in 1.5)

  PTR_SUE_IDLE                    = 1001;


/////////////////////////////////////////////////////////////////////
// "ResultCodeExtended" Property Constants
/////////////////////////////////////////////////////////////////////

  OPOS_EPTR_COVER_OPEN            = 201; // (Several)
  OPOS_EPTR_JRN_EMPTY             = 202; // (Several)
  OPOS_EPTR_REC_EMPTY             = 203; // (Several)
  OPOS_EPTR_SLP_EMPTY             = 204; // (Several)
  OPOS_EPTR_SLP_FORM              = 205; // EndRemoval
  OPOS_EPTR_TOOBIG                = 206; // PrintBitmap
  OPOS_EPTR_BADFORMAT             = 207; // PrintBitmap
  OPOS_EPTR_JRN_CARTRIDGE_REMOVED = 208; // (Several) (added in 1.5)
  OPOS_EPTR_JRN_CARTRIDGE_EMPTY   = 209; // (Several) (added in 1.5)
  OPOS_EPTR_JRN_HEAD_CLEANING     = 210; // (Several) (added in 1.5)
  OPOS_EPTR_REC_CARTRIDGE_REMOVED = 211; // (Several) (added in 1.5)
  OPOS_EPTR_REC_CARTRIDGE_EMPTY   = 212; // (Several) (added in 1.5)
  OPOS_EPTR_REC_HEAD_CLEANING     = 213; // (Several) (added in 1.5)
  OPOS_EPTR_SLP_CARTRIDGE_REMOVED = 214; // (Several) (added in 1.5)
  OPOS_EPTR_SLP_CARTRIDGE_EMPTY   = 215; // (Several) (added in 1.5)
  OPOS_EPTR_SLP_HEAD_CLEANING     = 216; // (Several) (added in 1.5)

implementation

end.
