unit DirectIOAPI;

interface

uses
  // VCL
  Windows;

const
  /////////////////////////////////////////////////////////////////////////////
  // Virtual cash registers for DIO_READ_CASH_REG request

  SMFPTR_CASHREG_GRAND_TOTAL          = 1000;
  SMFPTR_CASHREG_LASTFISC_TOTAL       = 1001;
  // Day totals
  SMFPTR_CASHREG_DAY_TOTAL_SALE       = 1002;
  SMFPTR_CASHREG_DAY_TOTAL_RETSALE    = 1003;
  SMFPTR_CASHREG_DAY_TOTAL_BUY        = 1004;
  SMFPTR_CASHREG_DAY_TOTAL_RETBUY     = 1005;
  // grand totals
  SMFPTR_CASHREG_GRAND_TOTAL_SALE     = 1006;
  SMFPTR_CASHREG_GRAND_TOTAL_RETSALE  = 1007;
  SMFPTR_CASHREG_GRAND_TOTAL_BUY      = 1008;
  SMFPTR_CASHREG_GRAND_TOTAL_RETBUY   = 1009;
  // Correction totals
  SMFPTR_CASHREG_CORRECTION_TOTAL_SALE    = 1010;
  SMFPTR_CASHREG_CORRECTION_TOTAL_RETSALE = 1011;
  SMFPTR_CASHREG_CORRECTION_TOTAL_BUY     = 1012;
  SMFPTR_CASHREG_CORRECTION_TOTAL_RETBUY  = 1013;


const
  DIO_COMMAND_PRINTER_XML       = 1;
  DIO_COMMAND_PRINTER_HEX       = 2;
  DIO_CHECK_END_DAY             = 3;
  DIO_LOAD_LOGO                 = 4;  // load logo
  DIO_PRINT_LOGO                = 5;  // print logo
  DIO_LOGO_DLG                  = 6;  // show load logo dialog
  DIO_PRINT_BARCODE             = 7;  // print barcode
  DIO_COMMAND_PRINTER_STR       = 8;  // string parameters command
  DIO_PRINT_TEXT                = 9;  // print text
  DIO_WRITE_TAX_NAME            = 10; // write tax name
  DIO_READ_TAX_NAME             = 11; // write tax name
  DIO_WRITE_PAYMENT_NAME        = 12; // write payment name
  DIO_READ_PAYMENT_NAME         = 13; // read payment name
  DIO_WRITE_TABLE               = 14; // write table value
  DIO_READ_TABLE                = 15; // read table value
  DIO_GET_DEPARTMENT            = 16; // get department value
  DIO_SET_DEPARTMENT            = 17; // set department value
  DIO_READ_CASH_REG             = 18; // read cash register
  DIO_READ_OPER_REG             = 19; // read operating register
  DIO_WAIT_FOR_PRINT            = 20; // Wait for printing operation
  DIO_PRINT_HEADER              = 21; // print header
  DIO_PRINT_TRAILER             = 22; // print trailer
  DIO_PRINT_ZREPORT_XML         = 23; // save ZReport in XML
  DIO_PRINT_ZREPORT_CSV         = 24; // save ZReport in CSV
  DIO_PRINT_ZREPORT             = 25; // save ZReport
  DIO_GET_LAST_ERROR            = 26; // read last error
  DIO_GET_PRINTER_STATION       = 27; // read printer station
  DIO_SET_PRINTER_STATION       = 28; // write printer station
  DIO_GET_DRIVER_PARAMETER      = 29; // read internal driver parameter
  DIO_SET_DRIVER_PARAMETER      = 30; // write internal driver parameter
  DIO_PRINT_SEPARATOR           = 31; // print separator line
  DIO_COMMAND_PRINTER_STR2      = 32; // execute command
  DIO_READ_EJ_ACTIVATION        = 33; // read EJ activation parameters
  DIO_READ_FM_TOTALS            = 34; // read fiscal memory totalizers
  DIO_READ_GRAND_TOTALS         = 35; // read grand totalizers
  DIO_PRINT_IMAGE               = 36; // Print image
  DIO_PRINT_IMAGE_SCALE         = 37; // Print image and scale
  DIO_WRITE_FS_TLV_DATA         = 38; // Write fiscal storage tag
  DIO_WRITE_FS_CUSTOMER_ADDRESS = 39; // Write customer address
  DIO_WRITE_FS_STRING_TAG       = 40; // Write string tag
  DIO_READ_FS_PARAMETER         = 41; // Read fiscal storage parameter
  DIO_READ_FPTR_PARAMETER       = 42; // Read fiscal printer parameter
  DIO_WRITE_FPTR_PARAMETER      = 43; // Write fiscal printer parameter
  DIO_PRINT_BARCODE_HEX         = 44; // print barcode data from hex
  DIO_SET_ADJUSTMENT_AMOUNT     = 45; // set receipt adjustment amount
  DIO_DISABLE_NEXT_HEADER       = 46; // disable next header printing
  DIO_WRITE_TABLE_FILE          = 47; // write table file
  DIO_FS_READ_DOCUMENT          = 48; // FS read document
  DIO_FS_PRINT_CALC_REPORT      = 49; // FS print calculations report
  DIO_OPEN_CASH_DRAWER          = 50; // Open cash drawer
  DIO_READ_CASH_DRAWER_STATE    = 51; // Read cash drawer state
  DIO_FS_FISCALIZE              = 52; // Print FS fiscalization report
  DIO_FS_REFISCALIZE            = 53; // Print FS refiscalization report
  DIO_GET_PRINT_WIDTH           = 54; // Get print width
  DIO_PRINT_BARCODE_HEX2        = 55; // print barcode data from hex 2
  DIO_PRINT_CORRECTION          = 56; // print correction receipt 1
  DIO_PRINT_CORRECTION2         = 57; // print correction receipt 2
  DIO_START_OPEN_DAY            = 58; // start open day
  DIO_OPEN_DAY                  = 59; // open day
  DIO_CHECK_ITEM_CODE           = 60; // check marking
  DIO_START_CORRECTION          = 61; // start correction receipt
  DIO_WRITE_FS_TLV_HEX          = 62; // Write fiscal storage tag
  DIO_WRITE_FS_TLV_OP_HEX       = 63; // Write TLV operation
  DIO_CLEAR_LOGO                = 64; // Clear Logo
  DIO_WRITE_FS_STRING_TAG_OP    = 65; // Write string tag bound to operation

  DIO_STLV_BEGIN                = 66; // Clear TLV
  DIO_STLV_ADD_TAG              = 67; // Add tag value
  DIO_STLV_GET_HEX              = 68; // Get TLV value
  DIO_STLV_WRITE                = 69; // Write tag value
  DIO_STLV_WRITE_OP             = 70; // Write tag value to operation

  DIO_ADD_ITEM_CODE             = 71; // add item code


  // Read document from fiscal storage device
  DIO_READ_FS_DOCUMENT            = 96;
  // Print document from fiscal storage device
  DIO_PRINT_FS_DOCUMENT           = 97;
  // Set receipt field value for receipt template
  DIO_SET_RECEIPT_FIELD           = 98;



  DIO_PRINT_TEXT2                = 1000;  // print text

  /////////////////////////////////////////////////////////////////////////////
  // Old driver version compatibility codes

  DIO2_PRINT_REC_REFUND         = 01;
  DIO2_PRINT_JOURNAL            = 02;
  DIO2_READ_DAY_NUMBER          = 03;
  DIO2_SET_TENDER_NAME          = 74;

  /////////////////////////////////////////////////////////////////////////////
  // DirectIO events

  DIRECTIO_EVENT_PROGRESS       = 1;

  /////////////////////////////////////////////////////////////////////////////
  // device codes

  DEVICE_CODE_FM1       = 1;
  DEVICE_CODE_FM2       = 2;
  DEVICE_CODE_RTC       = 3;
  DEVICE_CODE_NVRAM     = 4;
  DEVICE_CODE_FMCPU     = 5;
  DEVICE_CODE_ROM       = 6;
  DEVICE_CODE_RAM       = 7;

  /////////////////////////////////////////////////////////////////////////////
  // barcode types

  DIO_BARCODE_EAN13_INT           = 0; // internal EAN-13 barcode
  DIO_BARCODE_CODE128A            = 1; // Code 128A
  DIO_BARCODE_CODE128B            = 2; // Code 128B
  DIO_BARCODE_CODE128C            = 3; // Code 128C
  DIO_BARCODE_CODE39              = 4; // Code39
  DIO_BARCODE_CODE25INTERLEAVED   = 5;
  DIO_BARCODE_CODE25INDUSTRIAL    = 6;
  DIO_BARCODE_CODE25MATRIX        = 7;
  DIO_BARCODE_CODE39EXTENDED      = 8;
  DIO_BARCODE_CODE93              = 9;
  DIO_BARCODE_CODE93EXTENDED      = 10;
  DIO_BARCODE_MSI                 = 11;
  DIO_BARCODE_POSTNET             = 12;
  DIO_BARCODE_CODABAR             = 13;
  DIO_BARCODE_EAN8                = 14;
  DIO_BARCODE_EAN13               = 15;
  DIO_BARCODE_UPC_A               = 16;
  DIO_BARCODE_UPC_E0              = 17;
  DIO_BARCODE_UPC_E1              = 18;
  DIO_BARCODE_UPC_S2              = 19;
  DIO_BARCODE_UPC_S5              = 20;
  DIO_BARCODE_EAN128A             = 21;
  DIO_BARCODE_EAN128B             = 22;
  DIO_BARCODE_EAN128C             = 23;
  DIO_BARCODE_CODE11              = 24;
  DIO_BARCODE_C25IATA             = 25;
  DIO_BARCODE_C25LOGIC            = 26;
  DIO_BARCODE_DPLEIT              = 27;
  DIO_BARCODE_DPIDENT             = 28;
  DIO_BARCODE_CODE16K             = 29;
  DIO_BARCODE_CODE49              = 30;
  DIO_BARCODE_FLAT                = 31;
  DIO_BARCODE_RSS14               = 32;
  DIO_BARCODE_RSS_LTD             = 33;
  DIO_BARCODE_RSS_EXP             = 34;
  DIO_BARCODE_TELEPEN             = 35;
  DIO_BARCODE_FIM                 = 36;
  DIO_BARCODE_LOGMARS             = 37;
  DIO_BARCODE_PHARMA              = 38;
  DIO_BARCODE_PZN                 = 39;
  DIO_BARCODE_PHARMA_TWO          = 40;
  DIO_BARCODE_PDF417              = 41;
  DIO_BARCODE_PDF417TRUNC         = 42;
  DIO_BARCODE_MAXICODE            = 43;
  DIO_BARCODE_QRCODE              = 44;
  DIO_BARCODE_AUSPOST             = 45;
  DIO_BARCODE_AUSREPLY            = 46;
  DIO_BARCODE_AUSROUTE            = 47;
  DIO_BARCODE_AUSREDIRECT         = 48;
  DIO_BARCODE_ISBNX               = 49;
  DIO_BARCODE_RM4SCC              = 50;
  DIO_BARCODE_DATAMATRIX          = 51;
  DIO_BARCODE_EAN14               = 52;
  DIO_BARCODE_CODABLOCKF          = 53;
  DIO_BARCODE_NVE18               = 54;
  DIO_BARCODE_JAPANPOST           = 55;
  DIO_BARCODE_KOREAPOST           = 56;
  DIO_BARCODE_RSS14STACK          = 57;
  DIO_BARCODE_RSS14STACK_OMNI     = 58;
  DIO_BARCODE_RSS_EXPSTACK        = 59;
  DIO_BARCODE_PLANET              = 60;
  DIO_BARCODE_MICROPDF417         = 61;
  DIO_BARCODE_ONECODE             = 62;
  DIO_BARCODE_PLESSEY             = 63;
  DIO_BARCODE_TELEPEN_NUM         = 64;
  DIO_BARCODE_ITF14               = 65;
  DIO_BARCODE_KIX                 = 66;
  DIO_BARCODE_AZTEC               = 67;
  DIO_BARCODE_DAFT                = 68;
  DIO_BARCODE_MICROQR             = 69;
  DIO_BARCODE_HIBC_128            = 70;
  DIO_BARCODE_HIBC_39             = 71;
  DIO_BARCODE_HIBC_DM             = 72;
  DIO_BARCODE_HIBC_QR             = 73;
  DIO_BARCODE_HIBC_PDF            = 74;
  DIO_BARCODE_HIBC_MICPDF         = 75;
  DIO_BARCODE_HIBC_BLOCKF         = 76;
  DIO_BARCODE_HIBC_AZTEC          = 77;
  DIO_BARCODE_AZRUNE              = 78;
  DIO_BARCODE_CODE32              = 79;
  DIO_BARCODE_EANX_CC             = 80;
  DIO_BARCODE_EAN128_CC           = 81;
  DIO_BARCODE_RSS14_CC            = 82;
  DIO_BARCODE_RSS_LTD_CC          = 83;
  DIO_BARCODE_RSS_EXP_CC          = 84;
  DIO_BARCODE_UPCA_CC             = 85;
  DIO_BARCODE_UPCE_CC             = 86;
  DIO_BARCODE_RSS14STACK_CC       = 87;
  DIO_BARCODE_RSS14_OMNI_CC       = 88;
  DIO_BARCODE_RSS_EXPSTACK_CC     = 89;
  DIO_BARCODE_CHANNEL             = 90;
  DIO_BARCODE_CODEONE             = 91;
  DIO_BARCODE_GRIDMATRIX          = 92;
  // Компактный вид QR кода, печатается быстро средствами ФР, перепечатываться не будет
  DIO_BARCODE_QRCODE2             = 93;
  // Компактный вид QR кода, печатается медленно в графике, перепечатываться будет
  DIO_BARCODE_QRCODE3             = 94;
  // Компактный вид QR кода, печатается быстро средствами ФР, перепечатываться будет
  DIO_BARCODE_QRCODE4             = 95;

  // Barcodes prints with command DEh
  DIO_BARCODE_DEVICE_PDF417       = 96;
  DIO_BARCODE_DEVICE_DATAMATRIX   = 97;
  DIO_BARCODE_DEVICE_AZTEC        = 98;
  DIO_BARCODE_DEVICE_QR           = 99;
  DIO_BARCODE_DEVICE_EGAIS        = 100;
  

  DIO_BARCODE_MIN = 0;
  DIO_BARCODE_MAX = 100;

  /////////////////////////////////////////////////////////////////////////////
  // BarcodeAlignment values

  BARCODE_ALIGNMENT_CENTER    = 0;
  BARCODE_ALIGNMENT_LEFT      = 1;
  BARCODE_ALIGNMENT_RIGHT     = 2;

  /////////////////////////////////////////////////////////////////////////////
  // DriverParameterxxx constants
  DriverParameterStorage                  = 0;
  DriverParameterBaudRate                 = 1;
  DriverParameterPortNumber               = 2;
  DriverParameterFontNumber               = 3;
  DriverParameterSysPassword              = 4;
  DriverParameterUsrPassword              = 5;
  DriverParameterByteTimeout              = 6;
  DriverParameterStatusInterval           = 7;
  DriverParameterSubtotalText             = 8;
  DriverParameterCloseRecText             = 9;
  DriverParameterVoidRecText              = 10;
  DriverParameterPollInterval             = 11;
  DriverParameterMaxRetryCount            = 12;
  DriverParameterDeviceByteTimeout        = 13;
  DriverParameterSearchByPortEnabled      = 14;
  DriverParameterSearchByBaudRateEnabled  = 15;
  DriverParameterPropertyUpdateMode       = 16;
  DriverParameterCutType                  = 17;
  DriverParameterLogMaxCount              = 18;
  DriverParameterPayTypes                 = 19;
  DriverParameterEncoding                 = 20;
  DriverParameterRemoteHost               = 21;
  DriverParameterRemotePort               = 22;
  DriverParameterHeaderType               = 23;
  DriverParameterHeaderFont               = 24;
  DriverParameterTrailerFont              = 25;
  DriverParameterTrainModeText            = 26;
  DriverParameterLogoPosition             = 27;
  DriverParameterTrainSaleText            = 28;
  DriverParameterTrainPay2Text            = 29;
  DriverParameterTrainPay3Text            = 30;
  DriverParameterTrainPay4Text            = 31;
  DriverParameterStatusCommand            = 32;
  DriverParameterTrainTotalText           = 33;
  DriverParameterConnectionType           = 34;
  DriverParameterLogFileEnabled           = 35;
  DriverParameterNumHeaderLines           = 36;
  DriverParameterTrainChangeText          = 37;
  DriverParameterTrainStornoText          = 38;
  DriverParameterTrainCashInText          = 39;
  DriverParameterNumTrailerLines          = 40;
  DriverParameterTrainCashOutText         = 41;
  DriverParameterTrainVoidRecText         = 42;
  DriverParameterTrainCashPayText         = 43;
  DriverParameterBarLinePrintDelay        = 44;
  DriverParameterCompatLevel              = 45;
  DriverParameterHeader                   = 46;
  DriverParameterTrailer                  = 47;
  DriverParameterLogoSize                 = 48;
  DriverParameterLogoCenter               = 49;
  DriverParameterDepartment               = 50;
  DriverParameterLogoEnabled              = 51;
  DriverParameterHeaderPrinted            = 52;
  DriverParameterReceiptType              = 53;
  DriverParameterZeroReceiptType          = 54;
  DriverParameterZeroReceiptNumber        = 55;
  DriverParameterCCOType                  = 56;
  DriverParameterTableEditEnabled         = 57;
  DriverParameterXmlZReportEnabled        = 58;
  DriverParameterCsvZReportEnabled        = 59;
  DriverParameterXmlZReportFileName       = 60;
  DriverParameterCsvZReportFileName       = 61;
  DriverParameterVoidReceiptOnMaxItems    = 62;
  DriverParameterMaxReceiptItems          = 63;
  DriverParameterJournalPrintHeader       = 64;
  DriverParameterJournalPrintTrailer      = 65;
  DriverParameterCacheReceiptNumber       = 66;
  DriverParameterBarLineByteMode          = 67;
  DriverParameterLogFilePath              = 68;
  DriverParameterLogFileName              = 69;

  DriverParameterParam1                   = 70;
  DriverParameterParam2                   = 71;
  DriverParameterParam3                   = 72;
  DriverParameterParam4                   = 73;
  DriverParameterParam5                   = 74;
  DriverParameterParam6                   = 75;
  DriverParameterParam7                   = 76;
  DriverParameterParam8                   = 77;
  DriverParameterParam9                   = 78;
  DriverParameterParam10                  = 79;
  DriverParameterBarcode                  = 80;
  DriverParameterMarkType                 = 81;
  DriverParameterCorrectionType           = 82;
  DriverParameterCalculationSign          = 83;
  DriverParameterAmount2                  = 84;
  DriverParameterAmount3                  = 85;
  DriverParameterAmount4                  = 86;
  DriverParameterAmount5                  = 87;
  DriverParameterAmount6                  = 88;
  DriverParameterAmount7                  = 89;
  DriverParameterAmount8                  = 90;
  DriverParameterAmount9                  = 91;
  DriverParameterAmount10                 = 92;
  DriverParameterAmount11                 = 93;
  DriverParameterAmount12                 = 94;
  DriverParameterTaxType                  = 95;
  DriverParameterMessage                  = 96;
  DriverParameterErrorMessage             = 97;
  DriverParameterDiscountMode             = 98;
  DriverParameterCapFiscalStorage         = 99;
  DriverParameterLastDocMac               = 100;
  DriverParameterLastDocNum               = 101;
  DriverParameterLastDocTotal             = 102;
  DriverParameterLastDocDateTime          = 103;

  /////////////////////////////////////////////////////////////////////////////
  // Separator type

  DIO_SEPARATOR_BLACK    = 0;
  DIO_SEPARATOR_WHITE    = 1;
  DIO_SEPARATOR_DOTTED_1 = 2;
  DIO_SEPARATOR_DOTTED_2 = 3;


  /////////////////////////////////////////////////////////////////////////////
  // DIO_READ_EJ_ACTIVATION parameters

  ParamReadEJActivationAll        = 0; // All parameters
  ParamReadEJActivationDate       = 1; // Only date

  /////////////////////////////////////////////////////////////////////////////
  // DIO_READ_FS_PARAMETER command parameters

  DIO_FS_PARAMETER_SERIAL         = 0; // Fiscal storage device serial
  DIO_FS_PARAMETER_LAST_DOC_NUM   = 1; // Document number
  DIO_FS_PARAMETER_LAST_DOC_MAC   = 2; // Document message authentication code (MAC)
  DIO_FS_PARAMETER_QUEUE_SIZE     = 3; // Documents to send queue size
  DIO_FS_PARAMETER_FIRST_DOC_NUM  = 4; // First document number
  DIO_FS_PARAMETER_FIRST_DOC_DATE = 5; // First document date
  DIO_FS_PARAMETER_FISCAL_DATE    = 6; // Fiscalization date
  DIO_FS_PARAMETER_EXPIRE_DATE    = 7; // Expiration date
  DIO_FS_PARAMETER_OFD_ONLINE     = 8; // OFD connection established
  DIO_FS_PARAMETER_TICKET_HEX     = 9; // FDO ticket data in hex format
  DIO_FS_PARAMETER_TICKET_STR     = 10; // FDO ticket data in text format
  DIO_FS_PARAMETER_LAST_DOC_NUM2  = 11; // Document number
  DIO_FS_PARAMETER_LAST_DOC_MAC2  = 12; // Document message authentication code (MAC)


  /////////////////////////////////////////////////////////////////////////////
  // DIO_READ_FPTR_PARAMETER DIO_WRITE_FPTR_PARAMETER command parameters

  DIO_FPTR_PARAMETER_QRCODE_ENABLED = 0;
  DIO_FPTR_PARAMETER_OFD_ADDRESS    = 1;
  DIO_FPTR_PARAMETER_OFD_PORT       = 2;
  DIO_FPTR_PARAMETER_OFD_TIMEOUT    = 3;
  DIO_FPTR_PARAMETER_RNM            = 4;
  DIO_FPTR_PARAMETER_INN            = 5;
  DIO_FPTR_PARAMETER_TAXSYSTEM      = 6;
  DIO_FPTR_PARAMETER_WORKMODE       = 7;
  DIO_FPTR_PARAMETER_ENABLE_PRINT   = 8;

  /////////////////////////////////////////////////////////////////////////////
  // FPTR_RT_CORRECTION receipt type

  FPTR_RT_CORRECTION_SALE              =  100;
  FPTR_RT_CORRECTION_RETSALE           =  101;
  FPTR_RT_CORRECTION_BUY               =  102;
  FPTR_RT_CORRECTION_RETBUY            =  103;

  /////////////////////////////////////////////////////////////////////////////
  // FPTR_RT_CORRECTION2 receipt type

  FPTR_RT_CORRECTION2_SALE              =  104;
  FPTR_RT_CORRECTION2_BUY               =  105;
  FPTR_RT_CORRECTION2_RETSALE           =  106;
  FPTR_RT_CORRECTION2_RETBUY            =  107;

  /////////////////////////////////////////////////////////////////////////////
  // FPTR_RT_SALES receipt type

  FPTR_RT_SALES_SALE                    =  108;
  FPTR_RT_SALES_RETSALE                 =  109;
  FPTR_RT_SALES_BUY                     =  110;
  FPTR_RT_SALES_RETBUY                  =  111;

implementation

//GetData(41, 11, '')

end.
