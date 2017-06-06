unit PrinterParameters;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // This
  Oposhi, PrinterTypes, PayType, LogFile, FileUtils, DirectIOAPI, VatCode;

const
  DefPrintSingleQuantity = True;

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

  DefRemoteHost = '';
  DefRemotePort = 0;
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
  DefPollInterval = 1000;
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
  DefLogoEnabled = True;
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
  DefLogMaxCount = 10;
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
  DefPropertyUpdateMode = PropertyUpdateModePolling;
  DefReceiptReportEnabled = False;
  DefZReceiptBeforeZReport = True;
  DefDepartmentInText = false;
  DefCenterHeader = False;
  DefAmountDecimalPlaces = AmountDecimalPlaces_2;
  DefCapRecNearEndSensorMode = SensorModeAuto;
  DefReportDateStamp = False;
  DefFSUpdatePrice = False;
  DefWrapText = False;

  DefReceiptFormatEnabled = False;
  DefReceiptItemsHeader =
    '------------------------------------------' + CRLF +
    ' ¹                  Öåíà ñî  Êîë-         ' + CRLF +
    ' ïï  Öåíà    Ñêèäêà ñêèäêîé  âî    ÈÒÎÃÎ  ' + CRLF +
    '------------------------------------------';

  DefReceiptItemsTrailer =
    '------------------------------------------';

  DefReceiptItemFormat =
    '%3cPOS% %38lTITLE%' + CRLF +
    '    %8lPRICE% %6lDISCOUNT% %8lSUM%*%3QUAN%%=$10TOTAL_TAX%';
  DefRecPrintType = RecPrintTypePrinter;
  DefVatCodeEnabled = False;
  DefHandleErrorCode = False;

type
  { TPrinterParameters }

  TPrinterParameters = class(TPersistent)
  private
    FLogger: TLogFile;
    FStorage: Integer;
    FPayTypes: TPayTypes;
    FVatCodes: TVatCodes;
    FPortNumber: Integer;
    FBaudRate: Integer;
    FSysPassword: Integer;        // system administrator password
    FUsrPassword: Integer;        // operator password
    FSubtotalText: string;
    FCloseRecText: string;
    FVoidRecText: string;
    FFontNumber: Integer;
    FByteTimeout: Integer;              // driver byte timeout
    FDeviceByteTimeout: Integer;        // device byte timeout
    FMaxRetryCount: Integer;
    FPollInterval: Integer;             // printer polling interval
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
    FRemoteHost: string;
    FRemotePort: Integer;
    FConnectionType: Integer;
    FStatusCommand: Integer;
    FHeaderType: Integer;
    FBarLinePrintDelay: Integer;
    FCompatLevel: Integer;
    FCCOType: Integer;
    FHeader: string;
    FTrailer: string;
    FDepartment: Integer;
    FLogoCenter: Boolean;
    FHeaderPrinted: Boolean;
    FLogoSize: Integer;
    FLogoEnabled: Boolean;
    FLogoReloadEnabled: Boolean;
    FLogoFileName: string;
    FIsLogoLoaded: Boolean;
    FReceiptType: Integer;
    FZeroReceiptType: Integer;
    FZeroReceiptNumber: Integer;
    FTableEditEnabled: Boolean;
    FXmlZReportEnabled: Boolean;
    FCsvZReportEnabled: Boolean;
    FXmlZReportFileName: string;
    FCsvZReportFileName: string;
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
    FReceiptReportFileName: string;
    FZReceiptBeforeZReport: Boolean;
    FDepartmentInText: Boolean;
    FCenterHeader: Boolean;
    FAmountDecimalPlaces: Integer;
    FCapRecNearEndSensorMode: Integer;

    procedure LogText(const Caption, Text: string);
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
  public
    XReport: Integer;
    FSBarcodeEnabled: Boolean;
    FSAddressEnabled: Boolean;
    FPSerial: string;
    LogFilePath: string;
    ReportDateStamp: Boolean;
    FSUpdatePrice: Boolean;

    BarcodePrefix: string;
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
    ReceiptItemsHeader: string;
    ReceiptItemsTrailer: string;
    ReceiptItemFormat: string;
    ReceiptFormatEnabled: Boolean;
    RecPrintType: Integer;
    PrintSingleQuantity: Boolean;
    TableFilePath: WideString;
    DefTableFilePath: string;
    VatCodeEnabled: Boolean;
    HandleErrorCode: Boolean;
    FSServiceEnabled: Boolean;
  public
    constructor Create(ALogger: TLogFile);
    destructor Destroy; override;

    procedure SetDefaults;
    procedure WriteLogParameters;
    class function DefXmlZReportFileName: string;
    class function DefCsvZReportFileName: string;
    class function DefReceiptReportFileName: string;
    function GetPrinterMessage(ID: Integer): string;
    function GetVatInfo(AppVatCode: Integer): Integer;
    procedure SetPrinterMessage(ID: Integer; const S: string);
  published
    property Storage: Integer read FStorage write FStorage;
    property BaudRate: Integer read FBaudRate write SetBaudRate;
    property PortNumber: Integer read FPortNumber write SetPortNumber;
    property FontNumber: Integer read FFontNumber write SetFontNumber;
    property SysPassword: Integer read FSysPassword write FSysPassword;
    property UsrPassword: Integer read FUsrPassword write FUsrPassword;
    property ByteTimeout: Integer read FByteTimeout write SetByteTimeout;
    property StatusInterval: Integer read FStatusInterval write FStatusInterval;
    property SubtotalText: string read FSubtotalText write FSubtotalText;
    property CloseRecText: string read FCloseRecText write FCloseRecText;
    property VoidRecText: string read FVoidRecText write FVoidRecText;
    property PollInterval: Integer read FPollInterval write FPollInterval;
    property MaxRetryCount: Integer read FMaxRetryCount write FMaxRetryCount;
    property DeviceByteTimeout: Integer read FDeviceByteTimeout write SetDeviceByteTimeout;
    property SearchByPortEnabled: Boolean read FSearchByPortEnabled write FSearchByPortEnabled;
    property SearchByBaudRateEnabled: Boolean read FSearchByBaudRateEnabled write FSearchByBaudRateEnabled;
    property CutType: Integer read FCutType write SetCutType;
    property LogMaxCount: Integer read FLogMaxCount write FLogMaxCount;
    property PayTypes: TPayTypes read FPayTypes;
    property VatCodes: TVatCodes read FVatCodes;
    property Encoding: Integer read FEncoding write SetEncoding;
    property RemoteHost: string read FRemoteHost write FRemoteHost;
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
    property Header: string read FHeader write FHeader;
    property Trailer: string read FTrailer write FTrailer;
    property LogoSize: Integer read FLogoSize write FLogoSize;
    property LogoCenter: Boolean read FLogoCenter write FLogoCenter;
    property LogoFileName: string read FLogoFileName write FLogoFileName;
    property IsLogoLoaded: Boolean read FIsLogoLoaded write FIsLogoLoaded;

    property Department: Integer read FDepartment write SetDepartment;
    property LogoEnabled: Boolean read FLogoEnabled write FLogoEnabled;
    property LogoReloadEnabled: Boolean read FLogoReloadEnabled write FLogoReloadEnabled;
    property HeaderPrinted: Boolean read FHeaderPrinted write FHeaderPrinted;
    property ReceiptType: Integer read FReceiptType write SetReceiptType;
    property ZeroReceiptType: Integer read FZeroReceiptType write FZeroReceiptType;
    property ZeroReceiptNumber: Integer read FZeroReceiptNumber write FZeroReceiptNumber;
    property CCOType: Integer read FCCOType write SetCCOType;
    property TableEditEnabled: Boolean read FTableEditEnabled write FTableEditEnabled;
    property XmlZReportEnabled: Boolean read FXmlZReportEnabled write FXmlZReportEnabled;
    property CsvZReportEnabled: Boolean read FCsvZReportEnabled write FCsvZReportEnabled;
    property XmlZReportFileName: string read FXmlZReportFileName write FXmlZReportFileName;
    property CsvZReportFileName: string read FCsvZReportFileName write FCsvZReportFileName;
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
    property ReceiptReportFileName: string read FReceiptReportFileName write FReceiptReportFileName;
    property ReceiptReportEnabled: Boolean read FReceiptReportEnabled write FReceiptReportEnabled;
    property ZReceiptBeforeZReport: Boolean read FZReceiptBeforeZReport write FZReceiptBeforeZReport;
    property DepartmentInText: Boolean read FDepartmentInText write FDepartmentInText;
    property CenterHeader: Boolean read FCenterHeader write FCenterHeader;
    property AmountDecimalPlaces: Integer read FAmountDecimalPlaces write SetAmountDecimalPlaces;
    property CapRecNearEndSensorMode: Integer read FCapRecNearEndSensorMode write FCapRecNearEndSensorMode;
    property Logger: TLogFile read FLogger;
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

  TrainModeMessagesRus: array [0..18] of string = (
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

  TrainModeMessagesEng: array [0..18] of string = (
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

{ TPrinterParameters }

constructor TPrinterParameters.Create(ALogger: TLogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FPayTypes := TPayTypes.Create;
  FVatCodes := TVatCodes.Create;
  DefTableFilePath := GetModulePath + 'Tables';
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
  FPollInterval := DefPollInterval;
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
  FLogoEnabled := DefLogoEnabled;
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
  PayTypes.Add(0, '0');  // Cash
  PayTypes.Add(1, '1');  // Cashless 1
  PayTypes.Add(2, '2');  // Cashless 2
  PayTypes.Add(3, '3');  // Cashless 3
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
  ReceiptFormatEnabled := DefReceiptFormatEnabled;
  RecPrintType := DefRecPrintType;
  PrintSingleQuantity := DefPrintSingleQuantity;
  TableFilePath := DefTableFilePath;

  VatCodeEnabled := DefVatCodeEnabled;
  VatCodes.Clear;
  VatCodes.Add(1, 3); // 1, Íàëîã 0%
  VatCodes.Add(2, 2); // 2, Íàëîã 10%
  VatCodes.Add(4, 1); // 4, Íàëîã 18%

  HandleErrorCode := DefHandleErrorCode;
  FSServiceEnabled := False;
end;

procedure TPrinterParameters.LogText(const Caption, Text: string);
var
  i: Integer;
  Lines: TStrings;
begin
  Lines := TStringList.Create;
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
  Logger.Debug('PollInterval: ' + IntToStr(PollInterval));
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
  Logger.Debug('LogoEnabled: ' + BoolToStr(LogoEnabled));
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
  Logger.Debug('ReceiptFormatEnabled: ' + BoolToStr(ReceiptFormatEnabled));
  Logger.Debug('RecPrintType: ' + IntToStr(RecPrintType));
  Logger.Debug('TableFilePath: ' + TableFilePath);
  Logger.Debug('VatCodeEnabled: ' + BoolToStr(VatCodeEnabled));
  Logger.Debug('HandleErrorCode: ' + BoolToStr(HandleErrorCode));
  Logger.Debug('FSServiceEnabled: ' + BoolToStr(FSServiceEnabled));

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

class function TPrinterParameters.DefXmlZReportFileName: string;
begin
  Result := GetModulePath + 'ZReport.xml';
end;

class function TPrinterParameters.DefCsvZReportFileName: string;
begin
  Result := GetModulePath + 'ZReport.csv';
end;

class function TPrinterParameters.DefReceiptReportFileName: string;
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

function TPrinterParameters.GetPrinterMessage(ID: Integer): string;
begin
  Result := '';
  if (ID < Low(TrainModeMessagesRus))or(ID > High(TrainModeMessagesRus)) then Exit;
  Result := TrainModeMessagesRus[ID];
end;

procedure TPrinterParameters.SetPrinterMessage(ID: Integer;
  const S: string);
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

end.
