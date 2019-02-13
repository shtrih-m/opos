unit PrinterParameters;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  Oposhi, PrinterTypes, PayType, LogFile, FileUtils, DirectIOAPI, VatCode;

const
  /////////////////////////////////////////////////////////////////////////////
  // ItemTextMode constants

  ItemTextModeNone  = 0; // Item text not changed
  ItemTextModeTrim  = 1; // Trim item text on print width
  ItemTextModePrint = 2; // Print item text with text lines

  /////////////////////////////////////////////////////////////////////////////
  // DiscountMode constants

  DiscountModeChangePrice = 0; // Discount change price
  DiscountModeNone        = 1; // Discount does not change price

  /////////////////////////////////////////////////////////////////////////////
  // PrintRecMessageMode

  PrintRecMessageModeNormal = 0;
  PrintRecMessageModeBefore = 1;
  DefPrintRecMessageMode = PrintRecMessageModeBefore;

  /////////////////////////////////////////////////////////////////////////////
  // Maximum block size for FF31 command, read FS data block
  MinDocumentBlockSize = 10;
  MaxDocumentBlockSize = 151;
  DefDocumentBlockSize = 50;

  /////////////////////////////////////////////////////////////////////////////
  // QuantityLength constants
  QuantityDecimalPlaces3 = 0;
  QuantityDecimalPlaces6 = 1;
  DefQuantityDecimalPlaces = QuantityDecimalPlaces3;

  MaxRetryCountInfinite = 0;
  DefPrintSingleQuantity = True;

  /////////////////////////////////////////////////////////////////////////////
  // PrinterProtocol constants

  PrinterProtocol10 = 0;
  PrinterProtocol20 = 1;
  DefPrinterProtocol = PrinterProtocol10;

  /////////////////////////////////////////////////////////////////////////////
  // RecPrintType constants

  RecPrintTypePrinter  = 0;
  RecPrintTypeDriver   = 1;
  RecPrintTypeTemplate = 2;


  /////////////////////////////////////////////////////////////////////////////
  // ByteTimeout constants

  MinByteTimeout = 100; // 100 ms.

  /////////////////////////////////////////////////////////////////////////////
  // CutType constants

  CutTypeFull     = 0;
  CutTypePartial  = 1;
  CutTypeNone     = 2;

  CutTypeMin      = CutTypeFull;
  CutTypeMax      = CutTypeNone;

  /////////////////////////////////////////////////////////////////////////////
  // Encoding constants

  EncodingWindows       = 0;
  Encoding866           = 1;

  EncodingMin = EncodingWindows;
  EncodingMax = Encoding866;

  /////////////////////////////////////////////////////////////////////////////
  // FontNumber constants

  FontNumberMin = 1;
  FontNumberMax = 10;

  /////////////////////////////////////////////////////////////////////////////
  // Header and trailer parameters

  MinHeaderLines  = 0;
  MaxHeaderLines  = 100;
  MinTrailerLines = 0;
  MaxTrailerLines = 100;

  /////////////////////////////////////////////////////////////////////////////
  // Storage parameter values

  StorageReg      = 0;
  StorageIni      = 1;
  StorageRegIBT   = 2;
  StorageRegHKLM  = 3;

  /////////////////////////////////////////////////////////////////////////////
  // ReceiptType constants

  ReceiptTypeNormal     = 0;
  ReceiptTypeSingleSale = 1;
  ReceiptTypeGlobus     = 2;
  ReceiptTypeGlobus2    = 3;

  ReceiptTypeMin    = ReceiptTypeNormal;
  ReceiptTypeMax    = ReceiptTypeGlobus2;

  /////////////////////////////////////////////////////////////////////////////
  // CompatLevel constants

  CompatLevelNone   = 0;
  CompatLevel1      = 1;
  CompatLevel2      = 2;

  CompatLevelMin    = CompatLevelNone;
  CompatLevelMax    = CompatLevel2;

  /////////////////////////////////////////////////////////////////////////////
  // Connection type constants

  ConnectionTypeLocal   = 0;
  ConnectionTypeDCOM    = 1;
  ConnectionTypeTCP     = 2;
  ConnectionTypeSocket  = 3;

  ConnectionTypeMin     = ConnectionTypeLocal;
  ConnectionTypeMax     = ConnectionTypeSocket;

  /////////////////////////////////////////////////////////////////////////////
  // Valid connecion types

  ConnectionTypes: array [0..3] of Integer =
  (
    ConnectionTypeLocal,
    ConnectionTypeDCOM,
    ConnectionTypeTCP,
    ConnectionTypeSocket
  );

  //////////////////////////////////////////////////////////////////////////////
  // Logo position constants

  LogoAfterHeader     = 0;    // Print logo after header
  LogoBeforeHeader    = 1;    // Print logo before header
  LogoBeforeTrailer   = 2;    // Print logo before trailer
  LogoAfterTrailer    = 3;    // Print logo after trailer
  LogoAfterTotal      = 4;    // Print logo after TOTAL line

  LogoPositionMin     = LogoAfterHeader;
  LogoPositionMax     = LogoAfterTotal;

  //////////////////////////////////////////////////////////////////////////////
  // Status command constants

  // Driver will select command to read printer status
  StatusCommandDriver = 0;

  // Short status command
  StatusCommandShort = 1;

  // Long status command
  StatusCommandLong = 2;

  StatusCommandMin = StatusCommandDriver;
  StatusCommandMax = StatusCommandLong;

  /////////////////////////////////////////////////////////////////////////////
  // Header type constants

  HeaderTypePrinter = 0;
  HeaderTypeDriver  = 1;
  HeaderTypeNone    = 2;

  HeaderTypeMin     = HeaderTypePrinter;
  HeaderTypeMax     = HeaderTypeNone;



  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';

  //////////////////////////////////////////////////////////////////////////////
  // ZeroReceiptType constants

  // Normal receipt
  ZERO_RECEIPT_NORMAL         = 0;

  // Document header is printed after all receipt items
  ZERO_RECEIPT_NONFISCAL      = 1;

  /////////////////////////////////////////////////////////////////////////////
  // "CCOType" constants

  CCOTYPE_RCS  = 0;
  CCOTYPE_NCR  = 1;
  CCOTYPE_NONE = 2;

  CCOTYPE_MIN = CCOTYPE_RCS;
  CCOTYPE_MAX = CCOTYPE_NONE;

  /////////////////////////////////////////////////////////////////////////////
  // Barcode byte mode

  BarLineByteModeAuto     = 0;
  BarLineByteModeStraight = 1;
  BarLineByteModeReverse  = 2;

  BarLineByteModeMin  = BarLineByteModeAuto;
  BarLineByteModeMax  = BarLineByteModeReverse;

  /////////////////////////////////////////////////////////////////////////////
  // SeparatorLine constants

  SeparatorLineNone       = 0;
  SeparatorLineDashes     = 1;
  SeparatorLineGraphics   = 2;

  /////////////////////////////////////////////////////////////////////////////
  // PropertyUpdateMode constants

  PropertyUpdateModeNone        = 0;
  PropertyUpdateModePolling     = 1;
  PropertyUpdateModeQuery       = 2;

  /////////////////////////////////////////////////////////////////////////////
  // "AmountDecimalPlaces" constants

  AmountDecimalPlaces_0       = 0;
  AmountDecimalPlaces_2       = 1;
  AmountDecimalPlaces_Printer = 2;

  /////////////////////////////////////////////////////////////////////////////
  // "CapRecNearEndSensorMode" constants

  SensorModeAuto  = 0;
  SensorModeTrue  = 1;
  SensorModeFalse = 2;

  /////////////////////////////////////////////////////////////////////////////
  // "XReport" constants

  FptrXReport              = 0;
  FptrFSCalculationsReport = 1;

  /////////////////////////////////////////////////////////////////////////////
  // Default parameters


  // Time update only in driver methods
  TimeUpdateModeNormal =  0;

  // Time update only before fiscal day open command
  TimeUpdateModeOpenDay = 1;

  // Time update only before fiscal day open command without cancel
  TimeUpdateModeOpenDayNoCancel = 2;

  DefTimeUpdateMode = TimeUpdateModeNormal;

  /////////////////////////////////////////////////////////////////////////////
  // Default parameters

  DefRemoteHost = '192.168.137.111';
  DefRemotePort = 7778;
  DefConnectionType = ConnectionTypeLocal;
  DefPortNumber = 1;
  DefBaudRate = CBR_4800;
  DefSysPassword = 30;
  DefUsrPassword = 1;
  DefSubtotalText = 'SUBTOTAL';
  DefCloseRecText = '';
  DefVoidRecText = 'RECEIPT VOIDED';
  DefFontNumber = 1;
  DefByteTimeout = 1000;
  DefDeviceByteTimeout = 1000;
  DefMaxRetryCount = 3;
  DefPollIntervalInSeconds = 5;
  DefStatusInterval = 100;
  DefSearchByPortEnabled = False;
  DefSearchByBaudRateEnabled = True;
  DefLogFileEnabled = False;
  DefCutType = CutTypePartial;
  DefLogoPosition = LogoAfterHeader;
  DefNumHeaderLines = 6;
  DefNumTrailerLines = 4;
  DefHeaderFont = 1;
  DefTrailerFont = 1;
  DefEncoding = EncodingWindows;
  DefBarLinePrintDelay = 100;
  DefStatusCommand = StatusCommandDriver;
  DefHeaderType = HeaderTypeDriver;
  DefCompatLevel = CompatLevelNone;
  DefLogoSize = 0;
  DefDepartment = 1;
  DefLogoCenter = True;
  DefLogoReloadEnabled = False;
  DefReceiptType = ReceiptTypeNormal;
  DefZeroReceiptType = ZERO_RECEIPT_NORMAL;
  DefZeroReceiptNumber = 1;
  DefCCOType = CCOTYPE_RCS;
  DefTableEditEnabled = True;
  DefHeader =
    'Header line 1'#13#10 +
    'Header line 2'#13#10 +
    'Header line 3'#13#10 +
    'Header line 4'#13#10 +
    'Header line 5'#13#10 +
    'Header line 6';

  DefTrailer =
    'Trailer line 1'#13#10 +
    'Trailer line 2'#13#10 +
    'Trailer line 3'#13#10 +
    'Trailer line 4';

  DefHeaderPrinted = False;
  DefXmlZReportEnabled = False;
  DefCsvZReportEnabled = False;
  DefLogMaxCount = 0;
  DefVoidReceiptOnMaxItems = False;
  DefMaxReceiptItems = 100;
  DefJournalPrintHeader = True;
  DefJournalPrintTrailer = True;
  DefCacheReceiptNumber = False;
  DefBarLineByteMode = BarLineByteModeAuto;
  DefPrintRecSubtotal = True;
  DefStatusTimeout = 60;
  DefSetHeaderLineEnabled = True;
  DefSetTrailerLineEnabled = True;
  DefRFAmountLength = 10;
  DefRFQuantityLength = 10;
  DefRFShowTaxLetters = False;
  DefRFSeparatorLine = SeparatorLineDashes;
  DefMonitoringPort = 50000;
  DefMonitoringEnabled = False;
  DefPropertyUpdateMode = PropertyUpdateModeNone;
  DefReceiptReportEnabled = False;
  DefZReceiptBeforeZReport = True;
  DefDepartmentInText = false;
  DefCenterHeader = False;
  DefAmountDecimalPlaces = AmountDecimalPlaces_2;
  DefCapRecNearEndSensorMode = SensorModeAuto;
  DefReportDateStamp = False;
  DefFSUpdatePrice = False;
  DefWrapText = True;
  DefReceiptItemsHeader   =  '------------------------------------------';
  DefReceiptItemsTrailer  = '------------------------------------------';
  DefReceiptItemFormat    = '%3cPOS% %20lTITLE% %6lSUM% * %6QUAN% =%10TOTAL_TAX%';
  DefRecPrintType = RecPrintTypePrinter;
  DefVatCodeEnabled = False;
  DefHandleErrorCode = False;
  DefPrintUnitName = False;
  DefOpenReceiptEnabled = False;
  DefPingEnabled = False;

  DefEkmServerHost = '80.243.2.202';
  DefEkmServerPort = 2003;
  DefEkmServerTimeout = 5;
  DefEkmServerEnabled = False;
  DefCheckItemCodeEnabled = False;
  DefNewItemStatus = SMFP_ITEM_STATUS_RETAILED;
  DefItemCheckMode = SMFP_CHECK_MODE_FULL;
  DefDiscountMode = DiscountModeChangePrice;
  DefIgnoreDirectIOErrors = False;
  DefModelId = -1;
  DefItemTextMode = ItemTextModeNone;
  DefCorrectCashlessAmount = false;


type
  { TPrinterParameters }

  TPrinterParameters = class(TPersistent)
  private
    FLogger: ILogFile;
    FStorage: Integer;
    FPayTypes: TPayTypes;
    FVatCodes: TVatCodes;
    FPortNumber: Integer;
    FBaudRate: Integer;
    FSysPassword: Integer;        // system administrator password
    FUsrPassword: Integer;        // operator password
    FSubtotalText: WideString;
    FCloseRecText: WideString;
    FVoidRecText: WideString;
    FFontNumber: Integer;
    FByteTimeout: Integer;              // driver byte timeout
    FDeviceByteTimeout: Integer;        // device byte timeout
    FMaxRetryCount: Integer;
    FPollIntervalInSeconds: Integer;             // printer polling interval
    FSearchByPortEnabled: Boolean;
    FSearchByBaudRateEnabled: Boolean;
    FStatusInterval: Integer;              // time to sleep when printer is busy
    FLogFileEnabled: Boolean;
    FCutType: Integer;                  // receipt cut type: full or partial
    FLogoPosition: Integer;             // Logo position
    FNumHeaderLines: Integer;           // number of header lines
    FNumTrailerLines: Integer;          // number of trailer lines
    FHeaderFont: Integer;
    FTrailerFont: Integer;
    FEncoding: Integer;
    FRemoteHost: WideString;
    FRemotePort: Integer;
    FConnectionType: Integer;
    FStatusCommand: Integer;
    FHeaderType: Integer;
    FBarLinePrintDelay: Integer;
    FCompatLevel: Integer;
    FCCOType: Integer;
    FHeader: WideString;
    FTrailer: WideString;
    FDepartment: Integer;
    FLogoCenter: Boolean;
    FHeaderPrinted: Boolean;
    FLogoSize: Integer;
    FLogoReloadEnabled: Boolean;
    FLogoFileName: WideString;
    FIsLogoLoaded: Boolean;
    FReceiptType: Integer;
    FZeroReceiptType: Integer;
    FZeroReceiptNumber: Integer;
    FTableEditEnabled: Boolean;
    FXmlZReportEnabled: Boolean;
    FCsvZReportEnabled: Boolean;
    FXmlZReportFileName: WideString;
    FCsvZReportFileName: WideString;
    FLogMaxCount: Integer;
    FVoidReceiptOnMaxItems: Boolean;
    FMaxReceiptItems: Integer;
    FJournalPrintHeader: Boolean;
    FJournalPrintTrailer: Boolean;
    FCacheReceiptNumber: Boolean;
    FBarLineByteMode: Integer;
    FPrintRecSubtotal: Boolean;
    FStatusTimeout: Integer;
    FSetHeaderLineEnabled: Boolean;
    FSetTrailerLineEnabled: Boolean;
    FRFAmountLength: Integer;
    FRFQuantityLength: Integer;
    FRFShowTaxLetters: Boolean;
    FRFSeparatorLine: Integer;
    FMonitoringPort: Integer;
    FMonitoringEnabled: Boolean;
    FPropertyUpdateMode: Integer;
    FReceiptReportEnabled: Boolean;
    FReceiptReportFileName: WideString;
    FZReceiptBeforeZReport: Boolean;
    FDepartmentInText: Boolean;
    FCenterHeader: Boolean;
    FAmountDecimalPlaces: Integer;
    FCapRecNearEndSensorMode: Integer;
    FQuantityDecimalPlaces: Integer;
    FDocumentBlockSize: Integer;
    FDiscountMode: Byte;

    procedure LogText(const Caption, Text: WideString);
    procedure SetLogoPosition(const Value: Integer);
    procedure SetNumHeaderLines(const Value: Integer);
    procedure SetNumTrailerLines(const Value: Integer);
    procedure SetByteTimeout(const Value: Integer);
    procedure SetDeviceByteTimeout(const Value: Integer);
    procedure SetFontNumber(const Value: Integer);
    procedure SetAmountDecimalPlaces(const Value: Integer);
    procedure SetPropertyUpdateMode(const Value: Integer);
    procedure SetRFSeparatorLine(const Value: Integer);
    procedure SetRFQuantityLength(const Value: Integer);
    procedure SetRFAmountLength(const Value: Integer);
    procedure SetStatusTimeout(const Value: Integer);
    procedure SetBarLineByteMode(const Value: Integer);
    procedure SetCCOType(const Value: Integer);
    procedure SetReceiptType(const Value: Integer);
    procedure SetDepartment(const Value: Integer);
    procedure SetCompatLevel(const Value: Integer);
    procedure SetConnectionType(const Value: Integer);
    procedure SetStatusCommand(const Value: Integer);
    procedure SetHeaderFont(const Value: Integer);
    procedure SetHeaderType(const Value: Integer);
    procedure SetEncoding(const Value: Integer);
    procedure SetCutType(const Value: Integer);
    procedure SetBaudRate(const Value: Integer);
    procedure SetPortNumber(const Value: Integer);
    procedure SetPollIntervalInSeconds(const Value: Integer);
    procedure SetMaxRetryCount(const Value: Integer);
    procedure SetQuantityDecimalPlaces(const Value: Integer);
    procedure SetDocumentBlockSize(const Value: Integer);
    procedure SetDiscountMode(const Value: Byte);
  public
    XReport: Integer;
    FSBarcodeEnabled: Boolean;
    FSAddressEnabled: Boolean;
    FPSerial: WideString;
    LogFilePath: WideString;
    ReportDateStamp: Boolean;
    FSUpdatePrice: Boolean;

    BarcodePrefix: WideString;
    BarcodeHeight: Integer;
    BarcodeType: Integer;
    BarcodeModuleWidth: Integer;
    BarcodeAlignment: Integer;
    BarcodeParameter1: Integer;
    BarcodeParameter2: Integer;

    BarcodeParameter3: Integer;
    WrapText: Boolean;
    WritePaymentNameEnabled: Boolean;
    TimeUpdateMode: Integer;
    ReceiptItemsHeader: WideString;
    ReceiptItemsTrailer: WideString;
    ReceiptItemFormat: WideString;
    RecPrintType: Integer;
    PrintSingleQuantity: Boolean;
    TableFilePath: WideString;
    DefTableFilePath: WideString;
    VatCodeEnabled: Boolean;
    HandleErrorCode: Boolean;
    FSServiceEnabled: Boolean;
    PrinterProtocol: Integer;

    Parameter1: WideString;
    Parameter2: WideString;
    Parameter3: WideString;
    Parameter4: WideString;
    Parameter5: WideString;
    Parameter6: WideString;
    Parameter7: WideString;
    Parameter8: WideString;
    Parameter9: WideString;
    Parameter10: WideString;
    PrintUnitName: Boolean;
    OpenReceiptEnabled: Boolean;
    PingEnabled: Boolean;
    Barcode: WideString;
    MarkType: Integer;
    PrintRecMessageMode: Integer;
    EkmServerHost: WideString;
    EkmServerPort: Integer;
    EkmServerTimeout: Integer;
    EkmServerEnabled: Boolean;
    CheckItemCodeEnabled: Boolean;
    NewItemStatus: Integer;
    ItemCheckMode: Integer;

    CorrectionType: Byte; // Òèï êîððåêöèè :1 áàéò
    CalculationSign: Int64; // Ïðèçíàê ðàñ÷åòà:1áàéò
    Amount1: Int64; // Ñóììà ðàñ÷¸òà :5 áàéò
    Amount2: Int64; // Ñóììà ïî ÷åêó íàëè÷íûìè:5 áàéò
    Amount3: Int64; // Ñóììà ïî ÷åêó ýëåêòðîííûìè:5 áàéò
    Amount4: Int64; // Ñóììà ïî ÷åêó ïðåäîïëàòîé:5 áàéò
    Amount5: Int64; // Ñóììà ïî ÷åêó ïîñòîïëàòîé:5 áàéò
    Amount6: Int64; // Ñóììà ïî ÷åêó âñòðå÷íûì ïðåäñòàâëåíèåì:5 áàéò
    Amount7: Int64; // Ñóììà ÍÄÑ 20%:5 áàéò
    Amount8: Int64; // Ñóììà ÍÄÑ 10%:5 áàéò
    Amount9: Int64; // Ñóììà ðàñ÷¸òà ïî ñòàâêå 0%:5 áàéò
    Amount10: Int64; // Ñóììà ðàñ÷¸òà ïî ÷åêó áåç ÍÄÑ:5 áàéò
    Amount11: Int64; // Ñóììà ðàñ÷¸òà ïî ðàñ÷. ñòàâêå 18/118:5 áàéò
    Amount12: Int64; // Ñóììà ðàñ÷¸òà ïî ðàñ÷. ñòàâêå 10/110:5 áàéò
    TaxType: Byte; // Ïðèìåíÿåìàÿ ñèñòåìà íàëîãîîáëîæåíèÿ:1áàéò
    IgnoreDirectIOErrors: Boolean;
    ModelId: Integer;
    ItemTextMode: Integer;
    CorrectCashlessAmount: Boolean;
    SingleQuantityOnZeroUnitPrice: Boolean;
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    procedure SetDefaults;
    procedure WriteLogParameters;
    function IsLocalConnection: Boolean;
    class function DefXmlZReportFileName: WideString;
    class function DefCsvZReportFileName: WideString;
    class function DefReceiptReportFileName: WideString;
    function GetPrinterMessage(ID: Integer): WideString;
    function GetVatInfo(AppVatCode: Integer): Integer;
    procedure SetPrinterMessage(ID: Integer; const S: WideString);
  published
    property Storage: Integer read FStorage write FStorage;
    property BaudRate: Integer read FBaudRate write SetBaudRate;
    property PortNumber: Integer read FPortNumber write SetPortNumber;
    property FontNumber: Integer read FFontNumber write SetFontNumber;
    property SysPassword: Integer read FSysPassword write FSysPassword;
    property UsrPassword: Integer read FUsrPassword write FUsrPassword;
    property ByteTimeout: Integer read FByteTimeout write SetByteTimeout;
    property StatusInterval: Integer read FStatusInterval write FStatusInterval;
    property SubtotalText: WideString read FSubtotalText write FSubtotalText;
    property CloseRecText: WideString read FCloseRecText write FCloseRecText;
    property VoidRecText: WideString read FVoidRecText write FVoidRecText;
    property PollIntervalInSeconds: Integer read FPollIntervalInSeconds write SetPollIntervalInSeconds;
    property MaxRetryCount: Integer read FMaxRetryCount write SetMaxRetryCount;
    property DeviceByteTimeout: Integer read FDeviceByteTimeout write SetDeviceByteTimeout;
    property SearchByPortEnabled: Boolean read FSearchByPortEnabled write FSearchByPortEnabled;
    property SearchByBaudRateEnabled: Boolean read FSearchByBaudRateEnabled write FSearchByBaudRateEnabled;
    property CutType: Integer read FCutType write SetCutType;
    property LogMaxCount: Integer read FLogMaxCount write FLogMaxCount;
    property PayTypes: TPayTypes read FPayTypes;
    property VatCodes: TVatCodes read FVatCodes;
    property Encoding: Integer read FEncoding write SetEncoding;
    property RemoteHost: WideString read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property HeaderType: Integer read FHeaderType write SetHeaderType;
    property HeaderFont: Integer read FHeaderFont write SetHeaderFont;
    property TrailerFont: Integer read FTrailerFont write FTrailerFont;
    property LogoPosition: Integer read FLogoPosition write SetLogoPosition;
    property StatusCommand: Integer read FStatusCommand write SetStatusCommand;
    property ConnectionType: Integer read FConnectionType write SetConnectionType;
    property LogFileEnabled: Boolean read FLogFileEnabled write FLogFileEnabled;
    property NumHeaderLines: Integer read FNumHeaderLines write SetNumHeaderLines;
    property NumTrailerLines: Integer read FNumTrailerLines write SetNumTrailerLines;
    property BarLinePrintDelay: Integer read FBarLinePrintDelay write FBarLinePrintDelay;
    property CompatLevel: Integer read FCompatLevel write SetCompatLevel;
    property Header: WideString read FHeader write FHeader;
    property Trailer: WideString read FTrailer write FTrailer;
    property LogoSize: Integer read FLogoSize write FLogoSize;
    property LogoCenter: Boolean read FLogoCenter write FLogoCenter;
    property LogoFileName: WideString read FLogoFileName write FLogoFileName;
    property IsLogoLoaded: Boolean read FIsLogoLoaded write FIsLogoLoaded;

    property Department: Integer read FDepartment write SetDepartment;
    property LogoReloadEnabled: Boolean read FLogoReloadEnabled write FLogoReloadEnabled;
    property HeaderPrinted: Boolean read FHeaderPrinted write FHeaderPrinted;
    property ReceiptType: Integer read FReceiptType write SetReceiptType;
    property ZeroReceiptType: Integer read FZeroReceiptType write FZeroReceiptType;
    property ZeroReceiptNumber: Integer read FZeroReceiptNumber write FZeroReceiptNumber;
    property CCOType: Integer read FCCOType write SetCCOType;
    property TableEditEnabled: Boolean read FTableEditEnabled write FTableEditEnabled;
    property XmlZReportEnabled: Boolean read FXmlZReportEnabled write FXmlZReportEnabled;
    property CsvZReportEnabled: Boolean read FCsvZReportEnabled write FCsvZReportEnabled;
    property XmlZReportFileName: WideString read FXmlZReportFileName write FXmlZReportFileName;
    property CsvZReportFileName: WideString read FCsvZReportFileName write FCsvZReportFileName;
    property VoidReceiptOnMaxItems: Boolean read FVoidReceiptOnMaxItems write FVoidReceiptOnMaxItems;
    property MaxReceiptItems: Integer read FMaxReceiptItems write FMaxReceiptItems;
    property JournalPrintHeader: Boolean read FJournalPrintHeader write FJournalPrintHeader;
    property JournalPrintTrailer: Boolean read FJournalPrintTrailer write FJournalPrintTrailer;
    property CacheReceiptNumber: Boolean read FCacheReceiptNumber write FCacheReceiptNumber;
    property BarLineByteMode: Integer read FBarLineByteMode write SetBarLineByteMode;
    property PrintRecSubtotal: Boolean read FPrintRecSubtotal write FPrintRecSubtotal;
    property StatusTimeout: Integer read FStatusTimeout write SetStatusTimeout;
    property SetHeaderLineEnabled: Boolean read FSetHeaderLineEnabled write FSetHeaderLineEnabled;
    property SetTrailerLineEnabled: Boolean read FSetTrailerLineEnabled write FSetTrailerLineEnabled;
    property RFAmountLength: Integer read FRFAmountLength write SetRFAmountLength;
    property RFQuantityLength: Integer read FRFQuantityLength write SetRFQuantityLength;
    property RFShowTaxLetters: Boolean read FRFShowTaxLetters write FRFShowTaxLetters;
    property RFSeparatorLine: Integer read FRFSeparatorLine write SetRFSeparatorLine;
    property MonitoringPort: Integer read FMonitoringPort write FMonitoringPort;
    property MonitoringEnabled: Boolean read FMonitoringEnabled write FMonitoringEnabled;
    property PropertyUpdateMode: Integer read FPropertyUpdateMode write SetPropertyUpdateMode;
    property ReceiptReportFileName: WideString read FReceiptReportFileName write FReceiptReportFileName;
    property ReceiptReportEnabled: Boolean read FReceiptReportEnabled write FReceiptReportEnabled;
    property ZReceiptBeforeZReport: Boolean read FZReceiptBeforeZReport write FZReceiptBeforeZReport;
    property DepartmentInText: Boolean read FDepartmentInText write FDepartmentInText;
    property CenterHeader: Boolean read FCenterHeader write FCenterHeader;
    property AmountDecimalPlaces: Integer read FAmountDecimalPlaces write SetAmountDecimalPlaces;
    property CapRecNearEndSensorMode: Integer read FCapRecNearEndSensorMode write FCapRecNearEndSensorMode;
    property Logger: ILogFile read FLogger;
    property QuantityDecimalPlaces: Integer read FQuantityDecimalPlaces write SetQuantityDecimalPlaces;
    property DocumentBlockSize: Integer read FDocumentBlockSize write SetDocumentBlockSize;
    property DiscountMode: Byte read FDiscountMode write SetDiscountMode;
  end;

const
  MsgTrainModeText            = 0;
  MsgTrainCashInText          = 1;
  MsgTrainCashOutText         = 2;
  MsgTrainSaleText            = 3;
  MsgTrainBuyText             = 4;
  MsgTrainRetBuyText          = 5;
  MsgTrainRetSaleText         = 6;
  MsgTrainVoidRecText         = 7;
  MsgTrainTotalText           = 8;
  MsgTrainCashPayText         = 9;
  MsgTrainPay2Text            = 10;
  MsgTrainPay3Text            = 11;
  MsgTrainPay4Text            = 12;
  MsgTrainChangeText          = 13;
  MsgTrainStornoText          = 14;
  MsgTrainDiscountText        = 15;
  MsgTrainChargeText          = 16;
  MsgTrainVoidDiscountText    = 17;
  MsgTrainVoidChargeText      = 18;

  TrainModeMessagesRus: array [0..18] of WideString = (
    ' ÐÅÆÈÌ ÒÐÅÍÈÐÎÂÊÈ ',
    'ÂÍÅÑÅÍÈÅ',
    'ÂÛÏËÀÒÀ',
    'ÏÐÎÄÀÆÀ',
    'ÏÎÊÓÏÊÀ',
    'ÂÎÇÂÐÀÒ ÏÎÊÓÏÊÈ',
    'ÂÎÇÂÐÀÒ ÏÐÎÄÀÆÈ',
    '×ÅÊ ÎÒÌÅÍÅÍ',
    'ÈÒÎÃÎ',
    'ÍÀËÈ×ÍÛÌÈ' ,
    'ÊÐÅÄÈÒÎÌ' ,
    'ÒÀÐÎÉ',
    'ÏËÀÒ. ÊÀÐÒÎÉ' ,
    'ÑÄÀ×À',
    'ÑÒÎÐÍÎ',
    'ÑÊÈÄÊÀ',
    'ÍÀÄÁÀÂÊÀ',
    'ÑÒÎÐÍÎ ÑÊÈÄÊÈ',
    'ÑÒÎÐÍÎ ÍÀÄÁÀÂÊÈ');

  TrainModeMessagesEng: array [0..18] of WideString = (
    ' TRAINING MODE ',
    'CASH IN',
    'CASH OUT',
    'SALE',
    'BUY',
    'BUY RETURN',
    'SALE RETURN',
    'RECEIPT VOIDED',
    'TOTAL',
    'CASH' ,
    'PAY TYPE 1' ,
    'PAY TYPE 2',
    'PAY TYPE 3' ,
    'CHANGE',
    'VOID',
    'DISCOUNT',
    'CHARGE',
    'VOID DISCOUNT',
    'VOID CHARGE');

implementation

function GetItemTextMode(Value: Integer): string;
begin
  case Value of
    ItemTextModeNone: Result := 'ItemTextModeNone';
    ItemTextModeTrim: Result := 'ItemTextModeTrim';
    ItemTextModePrint: Result := 'ItemTextModePrint';
  else
    Result := 'Unknown';
  end;
end;

{ TPrinterParameters }

constructor TPrinterParameters.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FPayTypes := TPayTypes.Create;
  FVatCodes := TVatCodes.Create;
  DefTableFilePath := GetModulePath + 'Tables';
  MarkType := 5;
  SetDefaults;
end;

destructor TPrinterParameters.Destroy;
begin
  FPayTypes.Free;
  FVatCodes.Free;
  inherited Destroy;
end;

procedure TPrinterParameters.SetByteTimeout(const Value: Integer);
begin
  if (Value >= MinByteTimeout) then
    FByteTimeout := Value;
end;

procedure TPrinterParameters.SetDeviceByteTimeout(const Value: Integer);
begin
  if (Value >= MinByteTimeout) then
    FDeviceByteTimeout := Value;
end;

procedure TPrinterParameters.SetDefaults;
var
  i: Integer;
begin
  Logger.Debug('TPrinterParameters.SetDefaults');
  FPortNumber := DefPortNumber;
  FBaudRate := DefBaudRate;
  FSysPassword := DefSysPassword;
  FUsrPassword := DefUsrPassword;
  FSubtotalText := DefSubtotalText;
  FCloseRecText := DefCloseRecText;
  FVoidRecText := DefVoidRecText;
  FFontNumber := DefFontNumber;
  FByteTimeout := DefByteTimeout;
  FDeviceByteTimeout := DefDeviceByteTimeout;
  FMaxRetryCount := DefMaxRetryCount;
  FPollIntervalInSeconds := DefPollIntervalInSeconds;
  FStatusInterval := DefStatusInterval;
  FSearchByPortEnabled := DefSearchByPortEnabled;
  FSearchByBaudRateEnabled := DefSearchByBaudRateEnabled;
  FLogFileEnabled := DefLogFileEnabled;
  FCutType := DefCutType;
  LogoPosition := DefLogoPosition;
  FNumHeaderLines := DefNumHeaderLines;
  FNumTrailerLines := DefNumTrailerLines;
  FHeaderFont := DefHeaderFont;
  FTrailerFont := DefTrailerFont;
  FEncoding := DefEncoding;
  FBarLinePrintDelay := DefBarLinePrintDelay;
  HeaderType := DefHeaderType;
  CompatLevel := DefCompatLevel;
  FStatusCommand := DefStatusCommand;
  FLogoSize := DefLogoSize;
  FLogoFileName := '';
  FIsLogoLoaded := False;
  FDepartment := DefDepartment;
  FLogoCenter := DefLogoCenter;
  FLogoReloadEnabled := DefLogoReloadEnabled;
  FReceiptType := DefReceiptType;
  FZeroReceiptType := DefZeroReceiptType;
  FZeroReceiptNumber := DefZeroReceiptNumber;
  FCCOType := DefCCOType;
  TableEditEnabled := DefTableEditEnabled;
  Header := DefHeader;
  Trailer := DefTrailer;
  RemoteHost := DefRemoteHost;
  RemotePort := DefRemotePort;
  ConnectionType := DefConnectionType;
  HeaderPrinted := DefHeaderPrinted;
  PayTypes.Clear;
  for i := 0 to 15 do
  begin
    PayTypes.Add(i, IntToStr(i));
  end;

  FXmlZReportEnabled := DefXmlZReportEnabled;
  FCsvZReportEnabled := DefCsvZReportEnabled;
  FXmlZReportFileName := DefXmlZReportFileName;
  FCsvZReportFileName := DefCsvZReportFileName;
  FLogMaxCount := DefLogMaxCount;
  FVoidReceiptOnMaxItems := DefVoidReceiptOnMaxItems;
  MaxReceiptItems := DefMaxReceiptItems;
  JournalPrintHeader := DefJournalPrintHeader;
  JournalPrintTrailer := DefJournalPrintTrailer;
  CacheReceiptNumber := DefCacheReceiptNumber;
  BarLineByteMode := DefBarLineByteMode;
  FPrintRecSubtotal := DefPrintRecSubtotal;
  StatusTimeout := DefStatusTimeout;
  SetHeaderLineEnabled := DefSetHeaderLineEnabled;
  SetTrailerLineEnabled := DefSetTrailerLineEnabled;
  FRFAmountLength := DefRFAmountLength;
  FRFQuantityLength := DefRFQuantityLength;
  FRFShowTaxLetters := DefRFShowTaxLetters;
  FRFSeparatorLine := DefRFSeparatorLine;
  FMonitoringPort := DefMonitoringPort;
  FMonitoringEnabled := DefMonitoringEnabled;
  PropertyUpdateMode := DefPropertyUpdateMode;
  ReceiptReportFileName := DefReceiptReportFileName;
  ReceiptReportEnabled := DefReceiptReportEnabled;
  ZReceiptBeforeZReport := DefZReceiptBeforeZReport;
  DepartmentInText := DefDepartmentInText;
  CenterHeader := DefCenterHeader;
  AmountDecimalPlaces := DefAmountDecimalPlaces;
  FCapRecNearEndSensorMode := SensorModeAuto;

  LogFilePath := GetModulePath + 'Logs';
  ReportDateStamp := DefReportDateStamp;
  FSBarcodeEnabled := False;
  FSAddressEnabled := False;

  BarcodePrefix := 'BARCODE:';
  BarcodeHeight := 100;
  BarcodeType := DIO_BARCODE_EAN13_INT;
  BarcodeModuleWidth := 2;
  BarcodeAlignment := BARCODE_ALIGNMENT_CENTER;
  BarcodeParameter1 := 0;
  BarcodeParameter2 := 0;
  BarcodeParameter3 := 0;
  XReport := FptrXReport;
  FSUpdatePrice := DefFSUpdatePrice;
  WrapText := DefWrapText;
  WritePaymentNameEnabled := True;
  TimeUpdateMode := DefTimeUpdateMode;
  MonitoringEnabled := False;
  ReceiptItemsHeader := DefReceiptItemsHeader;
  ReceiptItemsTrailer := DefReceiptItemsTrailer;
  ReceiptItemFormat := DefReceiptItemFormat;
  RecPrintType := DefRecPrintType;
  PrintSingleQuantity := DefPrintSingleQuantity;
  TableFilePath := DefTableFilePath;

  VatCodeEnabled := DefVatCodeEnabled;
  VatCodes.Clear;
  VatCodes.Add(1, 3); // 1, Íàëîã 0%
  VatCodes.Add(2, 2); // 2, Íàëîã 10%
  VatCodes.Add(4, 1); // 4, Íàëîã 20%

  HandleErrorCode := DefHandleErrorCode;
  FSServiceEnabled := False;
  PrinterProtocol := DefPrinterProtocol;
  PrintUnitName := DefPrintUnitName;
  OpenReceiptEnabled := DefOpenReceiptEnabled;
  QuantityDecimalPlaces := DefQuantityDecimalPlaces;
  PingEnabled := DefPingEnabled;
  DocumentBlockSize := DefDocumentBlockSize;
  PrintRecMessageMode := DefPrintRecMessageMode;

  EkmServerHost := DefEkmServerHost;
  EkmServerPort := DefEkmServerPort;
  EkmServerTimeout := DefEkmServerTimeout;
  EkmServerEnabled := DefEkmServerEnabled;
  CheckItemCodeEnabled := DefCheckItemCodeEnabled;

  NewItemStatus := SMFP_ITEM_STATUS_RETAILED;
  ItemCheckMode := SMFP_CHECK_MODE_FULL;
  DiscountMode := DiscountModeChangePrice;
  IgnoreDirectIOErrors := DefIgnoreDirectIOErrors;
  ModelId := DefModelId;
  ItemTextMode := DefItemTextMode;
  CorrectCashlessAmount := DefCorrectCashlessAmount;
  SingleQuantityOnZeroUnitPrice := True;
end;

procedure TPrinterParameters.LogText(const Caption, Text: WideString);
var
  i: Integer;
  Lines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  try
    Lines.Text := Text;
    if Lines.Count = 1 then
    begin
      Logger.Debug(Format('%s: ''%s''', [Caption, Lines[0]]));
    end else
    begin
      for i := 0 to Lines.Count-1 do
      begin
        Logger.Debug(Format('%s.%d: ''%s''', [Caption, i, Lines[i]]));
      end;
    end;
  finally
    Lines.Free;
  end;
end;

procedure TPrinterParameters.WriteLogParameters;
var
  i: Integer;
  PayType: TPayType;
begin
  Logger.Debug('TPrinterParameters.WriteLogParameters');

  Logger.Debug('Storage: ' + IntToStr(Storage));
  LogText('Header', Header);
  LogText('Trailer', Trailer);
  Logger.Debug('RemoteHost: ' + RemoteHost);
  Logger.Debug('RemotePort: ' + IntToStr(RemotePort));
  Logger.Debug('ConnectionType: ' + IntToStr(ConnectionType));
  Logger.Debug('PrinterProtocol: ' + IntToStr(PrinterProtocol));
  Logger.Debug('PortNumber: ' + IntToStr(PortNumber));
  Logger.Debug('BaudRate: ' + IntToStr(BaudRate));
  Logger.Debug('SysPassword: ' + IntToStr(SysPassword));
  Logger.Debug('UsrPassword: ' + IntToStr(UsrPassword));
  Logger.Debug('SubtotalText: ' + SubtotalText);
  Logger.Debug('CloseRecText: ' + CloseRecText);
  Logger.Debug('VoidRecText: ' + VoidRecText);
  Logger.Debug('FontNumber: ' + IntToStr(FontNumber));
  Logger.Debug('ByteTimeout: ' + IntToStr(ByteTimeout));
  Logger.Debug('MaxRetryCount: ' + IntToStr(MaxRetryCount));
  Logger.Debug('SearchByPortEnabled: ' + BoolToStr(SearchByPortEnabled));
  Logger.Debug('SearchByBaudRateEnabled: ' + BoolToStr(SearchByBaudRateEnabled));
  Logger.Debug('PollIntervalInSeconds: ' + IntToStr(PollIntervalInSeconds));
  Logger.Debug('StatusInterval: ' + IntToStr(StatusInterval));
  Logger.Debug('DeviceByteTimeout: ' + IntToStr(DeviceByteTimeout));
  Logger.Debug('LogFileEnabled: ' + BoolToStr(LogFileEnabled));
  Logger.Debug('CutType: ' + IntToStr(CutType));
  Logger.Debug('LogoPosition: ' + IntToStr(LogoPosition));
  Logger.Debug('NumHeaderLines: ' + IntToStr(NumHeaderLines));
  Logger.Debug('NumTrailerLines: ' + IntToStr(NumTrailerLines));
  Logger.Debug('Encoding: ' + IntToStr(Encoding));
  Logger.Debug('HeaderType: ' + IntToStr(HeaderType));
  Logger.Debug('HeaderFont: ' + IntToStr(HeaderFont));
  Logger.Debug('TrailerFont: ' + IntToStr(TrailerFont));
  Logger.Debug('StatusCommand: ' + IntToStr(StatusCommand));
  Logger.Debug('BarLinePrintDelay: ' + IntToStr(BarLinePrintDelay));
  Logger.Debug('CompatLevel: ' + IntToStr(CompatLevel));
  Logger.Debug('ReceiptType: ' + IntToStr(ReceiptType));
  Logger.Debug('ZeroReceiptType: ' + IntToStr(ZeroReceiptType));
  Logger.Debug('ZeroReceiptNumber: ' + IntToStr(ZeroReceiptNumber));
  Logger.Debug('LogoSize: ' + IntToStr(LogoSize));
  Logger.Debug('LogoFileName: "' + LogoFileName + '"');
  Logger.Debug('IsLogoLoaded: ' + BoolToStr(IsLogoLoaded));
  Logger.Debug('LogoCenter: ' + BoolToStr(LogoCenter));
  Logger.Debug('Department: ' + IntToStr(Department));
  Logger.Debug('LogoReloadEnabled: ' + BoolToStr(LogoReloadEnabled));
  Logger.Debug('HeaderPrinted: ' + BoolToStr(HeaderPrinted));
  Logger.Debug('CCOType: ' + IntToStr(CCOType));
  Logger.Debug('TableEditEnabled: ' + BoolToStr(TableEditEnabled));
  Logger.Debug('XmlZReportEnabled: ' + BoolToStr(XmlZReportEnabled));
  Logger.Debug('CsvZReportEnabled: ' + BoolToStr(CsvZReportEnabled));
  Logger.Debug('XmlZReportFileName: ' + XmlZReportFileName);
  Logger.Debug('CsvZReportFileName: ' + CsvZReportFileName);
  Logger.Debug('LogMaxCount: ' + IntToStr(LogMaxCount));
  Logger.Debug('VoidReceiptOnMaxItems: ' + BoolToStr(VoidReceiptOnMaxItems));
  Logger.Debug('JournalPrintHeader: ' + BoolToStr(JournalPrintHeader));
  Logger.Debug('JournalPrintTrailer: ' + BoolToStr(JournalPrintTrailer));
  Logger.Debug('CacheReceiptNumber: ' + BoolToStr(CacheReceiptNumber));
  Logger.Debug('StatusTimeout: ' + IntToStr(StatusTimeout));
  Logger.Debug('RFAmountLength: ' + IntToStr(RFAmountLength));
  Logger.Debug('RFSeparatorLine: ' + IntToStr(RFSeparatorLine));
  Logger.Debug('RFQuantityLength: ' + IntToStr(RFQuantityLength));
  Logger.Debug('RFShowTaxLetters: ' + BoolToStr(RFShowTaxLetters));
  Logger.Debug('MonitoringPort: ' + IntToStr(MonitoringPort));
  Logger.Debug('MonitoringEnabled: ' + BoolToStr(MonitoringEnabled));
  Logger.Debug('PropertyUpdateMode: ' + IntToStr(PropertyUpdateMode));
  Logger.Debug('ReceiptReportEnabled: ' + BoolToStr(ReceiptReportEnabled));
  Logger.Debug('ReceiptReportFileName: "' + ReceiptReportFileName + '"');
  Logger.Debug('DepartmentInText: ' + BoolToStr(DepartmentInText));
  Logger.Debug('CenterHeader: ' + BoolToStr(CenterHeader));
  Logger.Debug('AmountDecimalPlaces: ' + IntToStr(AmountDecimalPlaces));
  Logger.Debug('CapRecNearEndSensorMode: ' + IntToStr(CapRecNearEndSensorMode));
  Logger.Debug('FSAddressEnabled: ' + BoolToStr(FSAddressEnabled));
  Logger.Debug('FSUpdatePrice: ' + BoolToStr(FSUpdatePrice));

  Logger.Debug('BarcodePrefix: ' + BarcodePrefix);
  Logger.Debug('BarcodeHeight: ' + IntToStr(BarcodeHeight));
  Logger.Debug('BarcodeType: ' + IntToStr(BarcodeType));
  Logger.Debug('BarcodeModuleWidth: ' + IntToStr(BarcodeModuleWidth));
  Logger.Debug('BarcodeAlignment: ' + IntToStr(BarcodeAlignment));
  Logger.Debug('BarcodeParameter1: ' + IntToStr(BarcodeParameter1));
  Logger.Debug('BarcodeParameter2: ' + IntToStr(BarcodeParameter2));
  Logger.Debug('BarcodeParameter3: ' + IntToStr(BarcodeParameter3));
  Logger.Debug('WrapText: ' + BoolToStr(WrapText));
  Logger.Debug('WritePaymentNameEnabled: ' + BoolToStr(WritePaymentNameEnabled));
  Logger.Debug('TimeUpdateMode: ' + IntToStr(TimeUpdateMode));
  Logger.Debug('MonitoringEnabled: ' + BoolToStr(MonitoringEnabled));
  Logger.Debug('ReceiptItemsHeader: ' + ReceiptItemsHeader);
  Logger.Debug('ReceiptItemsTrailer: ' + ReceiptItemsTrailer);
  Logger.Debug('ReceiptItemFormat: ' + ReceiptItemFormat);
  Logger.Debug('RecPrintType: ' + IntToStr(RecPrintType));
  Logger.Debug('TableFilePath: ' + TableFilePath);
  Logger.Debug('VatCodeEnabled: ' + BoolToStr(VatCodeEnabled));
  Logger.Debug('HandleErrorCode: ' + BoolToStr(HandleErrorCode));
  Logger.Debug('FSServiceEnabled: ' + BoolToStr(FSServiceEnabled));
  Logger.Debug('PrintUnitName: ' + BoolToStr(PrintUnitName));
  Logger.Debug('OpenReceiptEnabled: ' + BoolToStr(OpenReceiptEnabled));
  Logger.Debug('QuantityDecimalPlaces: ' + IntToStr(QuantityDecimalPlaces));
  Logger.Debug('PingEnabled: ' + BoolToStr(PingEnabled));
  Logger.Debug('DocumentBlockSize: ' + IntToStr(DocumentBlockSize));
  Logger.Debug('PrintRecMessageMode: ' + IntToStr(PrintRecMessageMode));
  Logger.Debug('EkmServerHost: ' + EkmServerHost);
  Logger.Debug('EkmServerPort: ' + IntToStr(EkmServerPort));
  Logger.Debug('EkmServerTimeout: ' + IntToStr(EkmServerTimeout));
  Logger.Debug('EkmServerEnabled: ' + BoolToStr(EkmServerEnabled));
  Logger.Debug('CheckItemCodeEnabled: ' + BoolToStr(CheckItemCodeEnabled));
  Logger.Debug('NewItemStatus: ' + IntToStr(NewItemStatus));
  Logger.Debug('ItemCheckMode: ' + IntToStr(ItemCheckMode));
  Logger.Debug('DiscountMode: ' + IntToStr(DiscountMode));
  Logger.Debug('IgnoreDirectIOErrors: ' + BoolToStr(IgnoreDirectIOErrors));
  Logger.Debug(Format('ItemTextMode: %d, %s', [ItemTextMode, GetItemTextMode(ItemTextMode)]));
  Logger.Debug('CorrectCashlessAmount: ' + BoolToStr(CorrectCashlessAmount));
  Logger.Debug('SingleQuantityOnZeroUnitPrice: ' + BoolToStr(SingleQuantityOnZeroUnitPrice));


  for i := 0 to PayTypes.Count-1 do
  begin
    PayType := PayTypes[i];
    Logger.Debug(Format('PayType %d: %s', [PayType.Code, PayType.Text]));
  end;

  Logger.Debug(Logger.Separator);
end;

procedure TPrinterParameters.SetLogoPosition(const Value: Integer);
begin
  if Value in [LogoPositionMin..LogoPositionMax] then
    FLogoPosition := Value;
end;

class function TPrinterParameters.DefXmlZReportFileName: WideString;
begin
  Result := GetModulePath + 'ZReport.xml';
end;

class function TPrinterParameters.DefCsvZReportFileName: WideString;
begin
  Result := GetModulePath + 'ZReport.csv';
end;

class function TPrinterParameters.DefReceiptReportFileName: WideString;
begin
  Result := GetModulePath + 'ZCheckReport.xml';
end;

procedure TPrinterParameters.SetNumHeaderLines(const Value: Integer);
begin
  if Value in [MinHeaderLines..MaxHeaderLines] then
    FNumHeaderLines := Value;
end;

procedure TPrinterParameters.SetNumTrailerLines(const Value: Integer);
begin
  if Value in [MinTrailerLines..MaxTrailerLines] then
    FNumTrailerLines := Value;
end;

procedure TPrinterParameters.SetHeaderFont(const Value: Integer);
begin
  if Value in [FontNumberMin..FontNumberMax] then
    FHeaderFont := Value;
end;

procedure TPrinterParameters.SetFontNumber(const Value: Integer);
begin
  if Value in [FontNumberMin..FontNumberMax] then
    FFontNumber := Value;
end;

procedure TPrinterParameters.SetAmountDecimalPlaces(const Value: Integer);
begin
  if Value in [0..2] then
    FAmountDecimalPlaces := Value;
end;

procedure TPrinterParameters.SetPropertyUpdateMode(const Value: Integer);
begin
  if Value in [0..2] then
    FPropertyUpdateMode := Value;
end;

procedure TPrinterParameters.SetRFSeparatorLine(const Value: Integer);
begin
  if Value in [0..2] then
    FRFSeparatorLine := Value;
end;

procedure TPrinterParameters.SetRFQuantityLength(const Value: Integer);
begin
  if (Value > 6)and(Value < 100) then
    FRFQuantityLength := Value;
end;

procedure TPrinterParameters.SetRFAmountLength(const Value: Integer);
begin
  if (Value > 6)and(Value < 100) then
    FRFAmountLength := Value;
end;

procedure TPrinterParameters.SetStatusTimeout(const Value: Integer);
begin
  if Value > 0 then
    FStatusTimeout := Value;
end;

procedure TPrinterParameters.SetBarLineByteMode(const Value: Integer);
begin
  if Value in [BarLineByteModeMin..BarLineByteModeMax] then
    FBarLineByteMode := Value;
end;

procedure TPrinterParameters.SetCCOType(const Value: Integer);
begin
  if Value in [CCOTYPE_MIN..CCOTYPE_MAX] then
    FCCOType := Value;
end;

procedure TPrinterParameters.SetReceiptType(const Value: Integer);
begin
  if Value in [ReceiptTypeMin..ReceiptTypeMax] then
    FReceiptType := Value;
end;

procedure TPrinterParameters.SetDepartment(const Value: Integer);
begin
  if Value in [0..16] then
    FDepartment := Value;
end;

procedure TPrinterParameters.SetCompatLevel(const Value: Integer);
begin
  if Value in [CompatLevelMin..CompatLevelMax] then
    FCompatLevel := Value;
end;

procedure TPrinterParameters.SetConnectionType(const Value: Integer);
begin
  if Value in [ConnectionTypeMin..ConnectionTypeMax] then
    FConnectionType := Value;
end;

procedure TPrinterParameters.SetStatusCommand(const Value: Integer);
begin
  if Value in [StatusCommandMin..StatusCommandMax] then
    FStatusCommand := Value;
end;

procedure TPrinterParameters.SetHeaderType(const Value: Integer);
begin
  if Value in [HeaderTypeMin..HeaderTypeMax] then
    FHeaderType := Value;
end;

procedure TPrinterParameters.SetEncoding(const Value: Integer);
begin
  if Value in [EncodingMin..EncodingMax] then
    FEncoding := Value;
end;

procedure TPrinterParameters.SetCutType(const Value: Integer);
begin
  if Value in [CutTypeMin..CutTypeMax] then
    FCutType := Value;
end;

procedure TPrinterParameters.SetBaudRate(const Value: Integer);
begin
  if Value >= 1200 then
    FBaudRate := Value;
end;

procedure TPrinterParameters.SetPortNumber(const Value: Integer);
begin
  if Value > 0 then
    FPortNumber := Value;
end;

function TPrinterParameters.GetPrinterMessage(ID: Integer): WideString;
begin
  Result := '';
  if (ID < Low(TrainModeMessagesRus))or(ID > High(TrainModeMessagesRus)) then Exit;
  Result := TrainModeMessagesRus[ID];
end;

procedure TPrinterParameters.SetPrinterMessage(ID: Integer;
  const S: WideString);
begin
  { !!! }
end;

function TPrinterParameters.GetVatInfo(AppVatCode: Integer): Integer;
var
  VatCode: TVatCode;
begin
  Result := AppVatCode;
  if VatCodeEnabled then
  begin
    VatCode := VatCodes.ItemByAppVatCode(AppVatCode);
    if VatCode <> nil then
    begin
      Result := VatCode.FptrVatCode;
    end;
  end;
end;

function TPrinterParameters.IsLocalConnection: Boolean;
begin
  Result := ConnectionType = ConnectionTypeLocal;
end;

procedure TPrinterParameters.SetPollIntervalInSeconds(
  const Value: Integer);
begin
  if Value in [1..60] then
    FPollIntervalInSeconds := Value;
end;

procedure TPrinterParameters.SetMaxRetryCount(const Value: Integer);
begin
  if Value in [0..10] then
    FMaxRetryCount := Value;
end;

procedure TPrinterParameters.SetQuantityDecimalPlaces(
  const Value: Integer);
begin
  if Value in [0..1] then
    FQuantityDecimalPlaces := Value;
end;

procedure TPrinterParameters.SetDocumentBlockSize(const Value: Integer);
begin
  if (Value >= MinDocumentBlockSize)and(Value <= MaxDocumentBlockSize) then
    FDocumentBlockSize := Value;
end;

procedure TPrinterParameters.SetDiscountMode(const Value: Byte);
begin
  if Value in [0..1] then
    FDiscountMode := Value;
end;

end.
