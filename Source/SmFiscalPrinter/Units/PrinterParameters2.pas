unit PrinterParameters;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ComServ,
  // Tnt
  TntRegistry, TntClasses, TntSysUtils,
  // This
  Oposhi, PrinterTypes, PayType, LogFile, FileUtils, SmFiscalPrinterLib_TLB,
  StringUtils, TextMap, RegUtils;

const
  /////////////////////////////////////////////////////////////////////////////
  // PawnTicketMode constants

  PawnTicketModeNone    = 0;
  PawnTicketModeFirst   = 1;
  PawnTicketModeAll     = 2;

  /////////////////////////////////////////////////////////////////////////////
  // Connection type constants

  ConnectionTypeLocal   = 0;
  ConnectionTypeDCOM    = 1;
  ConnectionTypeTCP     = 2;

  /////////////////////////////////////////////////////////////////////////////
  // Valid connecion types

  ConnectionTypes: array [0..2] of Integer =
  (
    ConnectionTypeLocal,
    ConnectionTypeDCOM,
    ConnectionTypeTCP
  );

  //////////////////////////////////////////////////////////////////////////////
  // Logo position constants

  LogoAfterHeader     = 0;    // Print logo after header
  LogoBeforeHeader    = 1;    // Print logo before header

  //////////////////////////////////////////////////////////////////////////////
  // Status command constants

  // Driver will select command to read printer status
  StatusCommandDriver = 0;

  // Short status command
  StatusCommandShort = 1;

  // Long status command
  StatusCommandLong = 2;


  /////////////////////////////////////////////////////////////////////////////
  // Header type constants

  HeaderTypePrinter = 0;
  HeaderTypeDriver  = 1;

  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';

  DefTankReportHeader: WideString =
    '--------------------------------------------------' + CRLF +
    '  Отчет о состоянии резервуаров                   ' + CRLF +
    '  Дата печати: [PRINT_DATE]                       ' + CRLF +
    '  Дата измерений: [AFT_TRANS_DATE]                ' + CRLF +
    '--------------------------------------------------';

  DefTankReportTrailer: WideString = '';

  DefTankReportItem: WideString =
    ' [TANK_NAME]: [GRADENAME] &FONT=2;' + CRLF +
    ' Объем                  : [CLOSE_QTE] л' + CRLF +
    ' Уровень                : [NET_STICK] мм' + CRLF +
    ' Вода                   : [WATER_VOLUME] л' + CRLF +
    ' Уровень                : [WATER_STICK] мм' + CRLF +
    ' Вместимость            : [VOLUME_QTY] л' + CRLF +
    ' Температура            : [TANK_TEMP] C' + CRLF +
    ' Плотность              : [DENSITY]' + CRLF +
    ' Свободный объем        : [EMPTY_VOLUME] л' + CRLF +
    '--------------------------------------------------';

  DefTankReportKey: WideString = 'Отчет о состоянии резервуаров';
  DefTankManualLine: WideString = ' Ручной замер           : [TIME_MANUAL]';
  DefLogFileLifeTime = 30;

  REGSTR_KEY_TEXTMAP  = 'TextMap';
  REGSTR_KEY_PAYTYPES = 'PaymentTypes';

  DefFuelItemText =
    'АИ-76' + CRLF +
    'АИ-92' + CRLF +
    'АИ-95' + CRLF +
    'АИ-98';
  DefFuelAmountStep = 50;
  DefFuelAmountPrecision = 1;
  DefUniposUniqueItemPrefix = '+++';
  DefUniposRefundErrorText = 'Возврат пополнения или перевода запрещен';
  DefUniposSalesErrorText = 'Пополнение или перевод денег в составе смешанной продажи';
  DefFuelRoundEnabled = False;
  DefCashRoundEnabled = False;
  DefMalinaFilterEnabled = False;
  DefAntiFroudFilterEnabled = False;
  DefUniposFilterEnabled = False;
  DefUniposPrinterEnabled = False;
  DefCashInTextPattern = 'Внесение предоплаты на БПК';
  DefCashInProcessingEnabled = True;
  DefNumHeaderLines = 6;
  DefHeaderFont = 1;
  DefHeader = '';
  DefPawnTicketMode = PawnTicketModeAll;
  DefPawnTicketText = 'Залоговая квитанция';


  REGSTR_UNIPOS_MALINA = 'SOFTWARE\Unipos\Malina';

type
  { TPrinterParameters }

  TPrinterParameters = class
  private
    FPayTypes: TPayTypes;
    FPortNumber: Integer;
    FBaudRate: Integer;
    FSysPassword: Integer;              // system administrator password
    FUsrPassword: Integer;              // operator password
    FSubtotalText: WideString;
    FCloseRecText: WideString;
    FVoidRecText: WideString;
    FFontNumber: Integer;
    FByteTimeout: Integer;              // driver byte timeout
    FDeviceByteTimeout: Integer;        // device byte timeout
    FMaxRetryCount: Integer;
    FPollInterval: Integer;             // printer polling interval
    FSearchByPortEnabled: Boolean;
    FSearchByBaudRateEnabled: Boolean;
    FTimeToSleep: Integer;              // time to sleep when printer is busy
    FMonitoringEnabled: Boolean;
    FStatusEventsEnabled: Boolean;
    FLogFileEnabled: Boolean;
    FLogFilePath: WideString;
    FCutType: Integer;                  // receipt cut type: full or partial
    FLogoPosition: Integer;             // Logo position
    FNumHeaderLines: Integer;           // number of header lines
    FNumTrailerLines: Integer;          // number of trailer lines
    FHeaderFont: Integer;
    FTrailerFont: Integer;
    FEncoding: Integer;

    //Training mode text WideStrings
    FTrainModeText: WideString;
    FTrainCashInText: WideString;
    FTrainCashOutText: WideString;
    FTrainSaleText: WideString;
    FTrainVoidRecText: WideString;
    FTrainTotalText: WideString;
    FTrainCashPayText: WideString;
    FTrainPay2Text: WideString;
    FTrainPay3Text: WideString;
    FTrainPay4Text: WideString;
    FTrainChangeText: WideString;
    FTrainStornoText: WideString;
    FRemoteHost: WideString;
    FRemotePort: Integer;
    FConnectionType: Integer;
    FStatusCommand: Integer;
    FHeaderType: Integer;
    FBarcodePrintDelay: Integer;

    FHeader: WideString;
    FTrailer: WideString;
    FDepartment: Integer;
    FLogoCenter: Boolean;
    FHeaderPrinted: Boolean;
    FLogoSize: Integer;
    FLogoEnabled: Boolean;
    FFuelItemText: WideString;
    FFuelAmountStep: Currency;
    FFuelAmountPrecision: Currency;
    FReplacements: TTextMap;

    procedure SetLogoPosition(const Value: Integer);
    procedure LoadSysParameters(const DeviceName: WideString);
    procedure LoadUsrParameters(const DeviceName: WideString);

    function GetDefLogFilePath: WideString;
    class function GetSysKeyName(const DeviceName: WideString): WideString;
    class function GetUsrKeyName(const DeviceName: WideString): WideString;
    procedure LogText(const Caption, Text: WideString);
    procedure LoadPayTypes(const KeyName: WideString);
    procedure SetReplacements(const Value: TTextMap);
    procedure SetFuelAmountPrecision(const Value: Currency);
    procedure CheckFuelAmountPrecision(const Value: Currency);
    function ValidFuelAmountPrecision(const Value: Currency): Boolean;
  public
    MalinaPromoText: WideString;
    MalinaCardPrefix: WideString;
    MalinaPointsText: WideString;
    MalinaPoints: Integer;
    MalinaCoefficient: Integer;
    MalinaRegistryKey: WideString;
    MalinaClearRegistry: Boolean;

    UniposTextFont: Integer;
    UniposHeaderFont: Integer;
    UniposTrailerFont: Integer;
    UniposPollPeriod: Integer;
    UniposUniqueItemPrefix: WideString;
    UniposSalesErrorText: WideString;
    UniposRefundErrorText: WideString;

    TankReportKey: WideString;
    TankReportHeader: WideString;
    TankReportTrailer: WideString;
    TankReportItem: WideString;
    TankManualLine: WideString;
    FuelRoundEnabled: Boolean;
    CashRoundEnabled: Boolean;
    CompleteZReportMode: Boolean;

    MalinaFilterEnabled: Boolean;
    AntiFroudFilterEnabled: Boolean;
    UniposFilterEnabled: Boolean;
    UniposPrinterEnabled: Boolean;
    LogFileLifeTime: Integer;
    EmptyReceiptBeforeZReportEnabled: Boolean;
    TextReplacementEnabled: Boolean;

    CashInTextPattern: string;
    CashInProcessingEnabled: Boolean;
    PawnTicketMode: Integer;
    PawnTicketText: WideString;

    constructor Create;
    destructor Destroy; override;

    procedure SetDefaults;
    procedure WriteLogParameters;
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);
    procedure SaveSysParameters(const DeviceName: WideString);
    procedure SaveUsrParameters(const DeviceName: WideString);
    class function DeviceExists(const DeviceName: WideString): Boolean;

    property BaudRate: Integer read FBaudRate write FBaudRate;
    property PortNumber: Integer read FPortNumber write FPortNumber;
    property FontNumber: Integer read FFontNumber write FFontNumber;
    property SysPassword: Integer read FSysPassword write FSysPassword;
    property UsrPassword: Integer read FUsrPassword write FUsrPassword;
    property ByteTimeout: Integer read FByteTimeout write FByteTimeout;
    property TimeToSleep: Integer read FTimeToSleep write FTimeToSleep;
    property SubtotalText: WideString read FSubtotalText write FSubtotalText;
    property CloseRecText: WideString read FCloseRecText write FCloseRecText;
    property VoidRecText: WideString read FVoidRecText write FVoidRecText;
    property PollInterval: Integer read FPollInterval write FPollInterval;
    property MaxRetryCount: Integer read FMaxRetryCount write FMaxRetryCount;
    property DeviceByteTimeout: Integer read FDeviceByteTimeout write FDeviceByteTimeout;
    property SearchByPortEnabled: Boolean read FSearchByPortEnabled write FSearchByPortEnabled;
    property SearchByBaudRateEnabled: Boolean read FSearchByBaudRateEnabled write FSearchByBaudRateEnabled;
    property MonitoringEnabled: Boolean read FMonitoringEnabled write FMonitoringEnabled;
    property StatusEventsEnabled: Boolean read FStatusEventsEnabled write FStatusEventsEnabled;
    property CutType: Integer read FCutType write FCutType;

    property PayTypes: TPayTypes read FPayTypes;
    property Encoding: Integer read FEncoding write FEncoding;
    property RemoteHost: WideString read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property HeaderType: Integer read FHeaderType write FHeaderType;
    property HeaderFont: Integer read FHeaderFont write FHeaderFont;
    property TrailerFont: Integer read FTrailerFont write FTrailerFont;
    property TrainModeText: WideString read FTrainModeText write FTrainModeText;
    property LogoPosition: Integer read FLogoPosition write SetLogoPosition;
    property TrainSaleText: WideString read FTrainSaleText write FTrainSaleText;
    property TrainPay2Text: WideString read FTrainPay2Text write FTrainPay2Text;
    property TrainPay3Text: WideString read FTrainPay3Text write FTrainPay3Text;
    property TrainPay4Text: WideString read FTrainPay4Text write FTrainPay4Text;
    property StatusCommand: Integer read FStatusCommand write FStatusCommand;
    property TrainTotalText: WideString read FTrainTotalText write FTrainTotalText;
    property ConnectionType: Integer read FConnectionType write FConnectionType;
    property LogFilePath: WideString read FLogFilePath write FLogFilePath;
    property LogFileEnabled: Boolean read FLogFileEnabled write FLogFileEnabled;
    property NumHeaderLines: Integer read FNumHeaderLines write FNumHeaderLines;
    property TrainChangeText: WideString read FTrainChangeText write FTrainChangeText;
    property TrainStornoText: WideString read FTrainStornoText write FTrainStornoText;
    property TrainCashInText: WideString read FTrainCashInText write FTrainCashInText;
    property NumTrailerLines: Integer read FNumTrailerLines write FNumTrailerLines;
    property TrainCashOutText: WideString read FTrainCashOutText write FTrainCashOutText;
    property TrainVoidRecText: WideString read FTrainVoidRecText write FTrainVoidRecText;
    property TrainCashPayText: WideString read FTrainCashPayText write FTrainCashPayText;
    property BarcodePrintDelay: Integer read FBarcodePrintDelay write FBarcodePrintDelay;
    // User parameters
    property Header: WideString read FHeader write FHeader;
    property Trailer: WideString read FTrailer write FTrailer;
    property LogoSize: Integer read FLogoSize write FLogoSize;
    property LogoCenter: Boolean read FLogoCenter write FLogoCenter;
    property Department: Integer read FDepartment write FDepartment;
    property LogoEnabled: Boolean read FLogoEnabled write FLogoEnabled;
    property HeaderPrinted: Boolean read FHeaderPrinted write FHeaderPrinted;
    // Fuel
    property Replacements: TTextMap read FReplacements write SetReplacements;
    property FuelItemText: WideString read FFuelItemText write FFuelItemText;
    property FuelAmountStep: Currency read FFuelAmountStep write FFuelAmountStep;
    property FuelAmountPrecision: Currency read FFuelAmountPrecision write SetFuelAmountPrecision;
  end;

implementation

resourcestring
  MsgKeyOpenError = 'Error opening registry key: %s';

function ExtractQuotedStr(const Src: String): String;
begin
  Result := Src;
  if Src[1] = '"' then Delete(Result, 1, 1);;
  if Result[Length(Result)] = '"' then
    SetLength(Result, Length(Result) - 1);
end;

function CLSIDToFileName(const CLSID: TGUID): String;
var
  Reg: TTntRegistry;
  strCLSID: String;
begin
  Result := '';
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey:= HKEY_CLASSES_ROOT;
    strCLSID := GUIDToString(CLSID);
    if Reg.OpenKey(Format('CLSID\%s\InProcServer32', [strCLSID]), False)
       or Reg.OpenKey(Format('CLSID\%s\LocalServer32', [strCLSID]), False) then
    begin
      try
        Result := ExtractQuotedStr(Reg.ReadString(''));
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure DeleteRegKey(const KeyName: string);
var
  i: Integer;
  Reg: TTntRegistry;
  Strings: TTntStrings;
begin
  Reg := TTntRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Strings := TTntStringList.Create;
  try
    if Reg.OpenKey(KeyName, False) then
    begin
      Reg.GetKeyNames(Strings);
      for i := 0 to Strings.Count-1 do
      begin
        DeleteRegKey(KeyName + '\' + Strings[i]);
      end;
      Reg.CloseKey;
      Reg.DeleteKey(KeyName);
    end;
  finally
    Reg.Free;
    Strings.Free;
  end;
end;

{ TPrinterParameters }

constructor TPrinterParameters.Create;
begin
  inherited Create;
  FPayTypes := TPayTypes.Create;
  FReplacements := TTextMap.Create;
  SetDefaults;
end;

destructor TPrinterParameters.Destroy;
begin
  FPayTypes.Free;
  FReplacements.Free;
  inherited Destroy;
end;

procedure TPrinterParameters.SetDefaults;
begin
  Logger.Debug('TPrinterParameters.SetDefaults');

  FPortNumber := 1;
  FBaudRate := CBR_4800;
  FSysPassword := 30;
  FUsrPassword := 1;
  FSubtotalText := 'SUBTOTAL';
  FCloseRecText := '';
  FVoidRecText := 'RECEIPT VOIDED';
  FFontNumber := 1;
  FByteTimeout := 1000;
  FDeviceByteTimeout := 1000;
  FMaxRetryCount := 5;
  FPollInterval := 100;
  FSearchByPortEnabled := False;
  FSearchByBaudRateEnabled := True;
  FTimeToSleep := 100;
  FMonitoringEnabled := False;
  FStatusEventsEnabled := False;
  // Log
  FLogFileEnabled := False;
  FLogFilePath := GetDefLogFilePath;
  LogFileLifeTime := DefLogFileLifeTime;

  FCutType := PRINTER_CUTTYPE_PARTIAL;
  LogoPosition := LogoAfterHeader;
  FNumHeaderLines := 6;
  FNumTrailerLines := 4;
  FHeaderFont := DefHeaderFont;
  FTrailerFont := 1;
  FEncoding := EncodingWindows;
  FBarcodePrintDelay := 100;

  // Training mode text params
  FTrainModeText := ' TRAINING MODE ';
  FTrainCashInText := 'CASH IN';
  FTrainCashOutText := 'CASH OUT';
  FTrainSaleText := 'SALE';
  FTrainVoidRecText := 'RECEIPT VOIDED';
  FTrainTotalText := 'TOTAL';
  FTrainCashPayText := 'CASH' ;
  FTrainPay2Text := 'PAY TYPE 1' ;
  FTrainPay3Text := 'PAY TYPE 2';
  FTrainPay4Text := 'PAY TYPE 3' ;
  FTrainChangeText := 'CHANGE';
  FTrainStornoText := 'VOID';

  PayTypes.Clear;
  PayTypes.Add(0, '0');  // Cash
  PayTypes.Add(1, '1');  // Cashless 1
  PayTypes.Add(2, '2');  // Cashless 2
  PayTypes.Add(3, '3');  // Cashless 3
  FStatusCommand := StatusCommandLong;

  HeaderType := HeaderTypeDriver;
  FHeader := '';
  FTrailer := '';

  FLogoSize := 0;
  FDepartment := 1;
  FLogoCenter := True;
  FLogoEnabled := False;

  MalinaPromoText := 'PROMO TEXT';
  MalinaCardPrefix := 'CARD NUMBER:';
  MalinaPointsText := 'MALINA POINTS: %d';
  MalinaRegistryKey := REGSTR_UNIPOS_MALINA;
  MalinaPoints := 40;
  MalinaCoefficient := 300;
  MalinaClearRegistry := True;

  UniposTextFont := 1;
  UniposHeaderFont := 1;
  UniposTrailerFont := 1;
  UniposPollPeriod := 1;
  UniposSalesErrorText := DefUniposSalesErrorText;
  UniposUniqueItemPrefix := DefUniposUniqueItemPrefix;
  UniposRefundErrorText := DefUniposRefundErrorText;

  TankReportKey := DefTankReportKey;
  TankReportHeader := DefTankReportHeader;
  TankReportTrailer := DefTankReportTrailer;
  TankReportItem := DefTankReportItem;
  TankManualLine := DefTankManualLine;
  CompleteZReportMode := True;
  FFuelItemText := DefFuelItemText;
  FFuelAmountStep := DefFuelAmountStep;
  FFuelAmountPrecision := DefFuelAmountPrecision;
  FuelRoundEnabled := DefFuelRoundEnabled;
  CashRoundEnabled := DefCashRoundEnabled;
  MalinaFilterEnabled := DefMalinaFilterEnabled;
  AntiFroudFilterEnabled := DefAntiFroudFilterEnabled;
  UniposFilterEnabled := DefUniposFilterEnabled;
  UniposPrinterEnabled := DefUniposPrinterEnabled;
  EmptyReceiptBeforeZReportEnabled := True;
  TextReplacementEnabled := False;
  CashInTextPattern := DefCashInTextPattern;
  CashInProcessingEnabled := DefCashInProcessingEnabled;
  PawnTicketMode := DefPawnTicketMode;
  PawnTicketText := DefPawnTicketText;
end;

function TPrinterParameters.GetDefLogFilePath: WideString;
begin
  Result := ExtractFilePath(
    ShortToLongFileName(CLSIDToFileName(CLASS_FiscalPrinter)));
end;

class function TPrinterParameters.GetSysKeyName(const DeviceName: WideString): WideString;
begin
  Result := Format('%s\%s\%s\', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

class function TPrinterParameters.DeviceExists(
  const DeviceName: WideString): Boolean;
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Result := Reg.KeyExists(GetSysKeyName(DeviceName));
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParameters.LogText(const Caption, Text: WideString);
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
  Logger.Debug('DeviceByteTimeout: ' + IntToStr(DeviceByteTimeout));
  Logger.Debug('TimeToSleep: ' + IntToStr(TimeToSleep));
  Logger.Debug('MonitoringEnabled: ' + BoolToStr(MonitoringEnabled));
  Logger.Debug('StatusEventsEnabled: ' + BoolToStr(StatusEventsEnabled));
  // Log
  Logger.Debug('LogFileEnabled: ' + BoolToStr(LogFileEnabled));
  Logger.Debug(Format('LogFilePath: ''%s''', [LogFilePath]));
  Logger.Debug('LogFileLifeTime: ' + IntToStr(LogFileLifeTime));

  Logger.Debug('CutType: ' + IntToStr(CutType));
  Logger.Debug('LogoPosition: ' + IntToStr(LogoPosition));
  Logger.Debug('NumHeaderLines: ' + IntToStr(NumHeaderLines));
  Logger.Debug('NumTrailerLines: ' + IntToStr(NumTrailerLines));
  Logger.Debug('Encoding: ' + IntToStr(Encoding));
  Logger.Debug('HeaderType: ' + IntToStr(HeaderType));
  Logger.Debug('HeaderFont: ' + IntToStr(HeaderFont));
  Logger.Debug('TrailerFont: ' + IntToStr(TrailerFont));
  Logger.Debug('StatusCommand: ' + IntToStr(StatusCommand));
  Logger.Debug('BarcodePrintDelay: ' + IntToStr(BarcodePrintDelay));
  Logger.Debug('TrainModeText: ' + TrainModeText);
  Logger.Debug('TrainCashInText: ' + TrainCashInText);
  Logger.Debug('TrainCashOutText: ' + TrainCashOutText);
  Logger.Debug('TrainSaleText: ' + TrainSaleText);
  Logger.Debug('TrainVoidRecText: ' + TrainVoidRecText);
  Logger.Debug('TrainTotalText: ' + TrainTotalText);
  Logger.Debug('TrainCashPayText: ' + TrainCashPayText);
  Logger.Debug('TrainPay2Text: ' + TrainPay2Text);
  Logger.Debug('TrainPay3Text: ' + TrainPay3Text);
  Logger.Debug('TrainPay4Text: ' + TrainPay4Text);
  Logger.Debug('TrainChangeText: ' + TrainChangeText);
  Logger.Debug('TrainStornoText: ' + TrainStornoText);

  for i := 0 to PayTypes.Count-1 do
  begin
    PayType := PayTypes[i];
    Logger.Debug(Format('PayType %d: %s', [PayType.Code, PayType.Text]));
  end;

  Logger.Debug('LogoSize: ' + IntToStr(LogoSize));
  Logger.Debug('LogoCenter: ' + BoolToStr(LogoCenter));
  Logger.Debug('Department: ' + IntToStr(Department));
  Logger.Debug('LogoEnabled: ' + BoolToStr(LogoEnabled));
  Logger.Debug('HeaderPrinted: ' + BoolToStr(HeaderPrinted));

  Logger.Debug('UniposTextFont: ' + IntToStr(UniposTextFont));
  Logger.Debug('UniposHeaderFont: ' + IntToStr(UniposHeaderFont));
  Logger.Debug('UniposTrailerFont: ' + IntToStr(UniposTrailerFont));
  Logger.Debug('UniposPollPeriod: ' + IntToStr(UniposPollPeriod));
  Logger.Debug(Format('UniposSalesErrorText: ''%s''', [UniposSalesErrorText]));
  Logger.Debug(Format('UniposUniqueItemPrefix: ''%s''', [UniposUniqueItemPrefix]));
  Logger.Debug(Format('UniposRefundErrorText: ''%s''', [UniposRefundErrorText]));

  LogText('FuelItemText', FuelItemText);
  Logger.Debug('FuelAmountStep: ' + CurrToStr(FuelAmountStep));
  Logger.Debug('FuelAmountPrecision: ' + CurrToStr(FuelAmountPrecision));
  // TextReplacement
  Logger.Debug('TextReplacementEnabled: ' + BoolToStr(TextReplacementEnabled));
  for i := 0 to Replacements.Count-1 do
  begin
    Logger.Debug(Format('TextToReplace_%d: "%s"', [i, Replacements[i].Item1]));
    Logger.Debug(Format('ReplacementText_%d: "%s"', [i, Replacements[i].Item2]));
  end;
  LogText('CashInTextPattern', CashInTextPattern);
  Logger.Debug(Format('CashInProcessingEnabled: ''%s''', [
    BoolToStr(CashInProcessingEnabled)]));
  Logger.Debug(Logger.Separator);
end;

procedure TPrinterParameters.Load(const DeviceName: WideString);
begin
  try
    LoadSysParameters(DeviceName);
    LoadUsrParameters(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TPrinterParameters.Load', E);
    end;
  end;
end;

procedure TPrinterParameters.Save(const DeviceName: WideString);
begin
  try
    SaveSysParameters(DeviceName);
    SaveUsrParameters(DeviceName);
  except
    on E: Exception do
      Logger.Error('TPrinterParameters.Save', E);
  end;
end;

procedure TPrinterParameters.LoadSysParameters(const DeviceName: WideString);
var
  KeyName: WideString;
  Reg: TTntRegistry;
  CurrencyValue: Currency;
begin
  Logger.Debug('TPrinterParameters.Load', [DeviceName]);

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetSysKeyName(DeviceName);
    if Reg.OpenKey(KeyName, False) then
    begin
      if Reg.ValueExists('RemoteHost') then
        RemoteHost := Reg.ReadString('RemoteHost');

      if Reg.ValueExists('RemotePort') then
        RemotePort := Reg.ReadInteger('RemotePort');

      if Reg.ValueExists('ConnectionType') then
        ConnectionType := Reg.ReadInteger('ConnectionType');

      if Reg.ValueExists('ComNumber') then
        FPortNumber := Reg.ReadInteger('ComNumber');

      if Reg.ValueExists('BaudRate') then
        FBaudRate := Reg.ReadInteger('BaudRate');

      if Reg.ValueExists('SysPassword') then
        FSysPassword := Reg.ReadInteger('SysPassword');

      if Reg.ValueExists('UsrPassword') then
        FUsrPassword := Reg.ReadInteger('UsrPassword');

      if Reg.ValueExists('SubtotalText') then
        FSubtotalText := Reg.ReadString('SubtotalText');

      if Reg.ValueExists('CloseRecText') then
        FCloseRecText := Reg.ReadString('CloseRecText');

      if Reg.ValueExists('VoidRecText') then
        FVoidRecText := Reg.ReadString('VoidRecText');

      if Reg.ValueExists('FontNumber') then
        FFontNumber := Reg.ReadInteger('FontNumber');

      if Reg.ValueExists('ByteTimeout') then
        FByteTimeout := Reg.ReadInteger('ByteTimeout');

      if Reg.ValueExists('MaxRetryCount') then
        FMaxRetryCount := Reg.ReadInteger('MaxRetryCount');

      if Reg.ValueExists('SearchByPortEnabled') then
        FSearchByPortEnabled := Reg.ReadBool('SearchByPortEnabled');

      if Reg.ValueExists('SearchByBaudRateEnabled') then
        FSearchByBaudRateEnabled := Reg.ReadBool('SearchByBaudRateEnabled');

      if Reg.ValueExists('PollInterval') then
        FPollInterval := Reg.ReadInteger('PollInterval');

      if Reg.ValueExists('DeviceByteTimeout') then
        FDeviceByteTimeout := Reg.ReadInteger('DeviceByteTimeout');

      if Reg.ValueExists('TimeToSleep') then
        FTimeToSleep := Reg.ReadInteger('TimeToSleep');

      if Reg.ValueExists('MonitoringEnabled') then
        FMonitoringEnabled := Reg.ReadBool('MonitoringEnabled');

      if Reg.ValueExists('StatusEventsEnabled') then
        FStatusEventsEnabled := Reg.ReadBool('StatusEventsEnabled');

      if Reg.ValueExists('LogFileEnabled') then
        FLogFileEnabled := Reg.ReadBool('LogFileEnabled');

      if Reg.ValueExists('LogFilePath') then
        FLogFilePath := Reg.ReadString('LogFilePath');

      if Reg.ValueExists('LogFileLifeTime') then
        LogFileLifeTime := Reg.ReadInteger('LogFileLifeTime');

      if Reg.ValueExists('CutType') then
        FCutType := Reg.ReadInteger('CutType');

      if Reg.ValueExists('LogoPosition') then
        FLogoPosition := Reg.ReadInteger('LogoPosition');

      if Reg.ValueExists('NumHeaderLines') then
        FNumHeaderLines := Reg.ReadInteger('NumHeaderLines');

      if Reg.ValueExists('NumTrailerLines') then
        FNumTrailerLines := Reg.ReadInteger('NumTrailerLines');

      if Reg.ValueExists('HeaderFont') then
        FHeaderFont := Reg.ReadInteger('HeaderFont');

      if Reg.ValueExists('TrailerFont') then
        FTrailerFont := Reg.ReadInteger('TrailerFont');

      if Reg.ValueExists('Encoding') then
        FEncoding := Reg.ReadInteger('Encoding');

      // Training mode text params

      if Reg.ValueExists('TrainModeText') then
        FTrainModeText := Reg.ReadString('TrainModeText');

      if Reg.ValueExists('TrainCashInText') then
        FTrainCashInText := Reg.ReadString('TrainCashInText');

      if Reg.ValueExists('TrainCashOutText') then
        FTrainCashOutText := Reg.ReadString('TrainCashOutText');

      if Reg.ValueExists('TrainSaleText') then
        FTrainSaleText := Reg.ReadString('TrainSaleText');

      if Reg.ValueExists('TrainVoidRecText') then
        FTrainVoidRecText := Reg.ReadString('TrainVoidRecText');

      if Reg.ValueExists('TrainTotalText') then
        FTrainTotalText := Reg.ReadString('TrainTotalText');

      if Reg.ValueExists('TrainCashPayText') then
        FTrainCashPayText := Reg.ReadString('TrainCashPayText');

      if Reg.ValueExists('TrainPay2Text') then
        FTrainPay2Text := Reg.ReadString('TrainPay2Text');

      if Reg.ValueExists('TrainPay3Text') then
        FTrainPay3Text := Reg.ReadString('TrainPay3Text');

      if Reg.ValueExists('TrainPay4Text') then
        FTrainPay4Text := Reg.ReadString('TrainPay4Text');

      if Reg.ValueExists('TrainChangeText') then
        FTrainChangeText := Reg.ReadString('TrainChangeText');

      if Reg.ValueExists('TrainStornoText') then
        FTrainStornoText := Reg.ReadString('TrainStornoText');

      if Reg.ValueExists('StatusCommand') then
        FStatusCommand := Reg.ReadInteger('StatusCommand');

      if Reg.ValueExists('HeaderType') then
        HeaderType := Reg.ReadInteger('HeaderType');

      if Reg.ValueExists('BarcodePrintDelay') then
        BarcodePrintDelay := Reg.ReadInteger('BarcodePrintDelay');

      if Reg.ValueExists('MalinaPromoText') then
        MalinaPromoText := Reg.ReadString('MalinaPromoText');

      if Reg.ValueExists('MalinaCardPrefix') then
        MalinaCardPrefix := Reg.ReadString('MalinaCardPrefix');

      if Reg.ValueExists('MalinaPointsText') then
        MalinaPointsText := Reg.ReadString('MalinaPointsText');

      if Reg.ValueExists('MalinaRegistryKey') then
        MalinaRegistryKey := Reg.ReadString('MalinaRegistryKey');

      if Reg.ValueExists('MalinaCoefficient') then
        MalinaCoefficient := Reg.ReadInteger('MalinaCoefficient');

      if Reg.ValueExists('MalinaPoints') then
        MalinaPoints := Reg.ReadInteger('MalinaPoints');

      if Reg.ValueExists('ClearRegistry') then
        MalinaClearRegistry := Reg.ReadBool('ClearRegistry');

      if Reg.ValueExists('MalinaFilterEnabled') then
        MalinaFilterEnabled := Reg.ReadBool('MalinaFilterEnabled');

      // Unipos
      if Reg.ValueExists('UniposTextFont') then
        UniposTextFont := Reg.ReadInteger('UniposTextFont');

      if Reg.ValueExists('UniposHeaderFont') then
        UniposHeaderFont := Reg.ReadInteger('UniposHeaderFont');

      if Reg.ValueExists('UniposTrailerFont') then
        UniposTrailerFont := Reg.ReadInteger('UniposTrailerFont');

      if Reg.ValueExists('UniposPollPeriod') then
        UniposPollPeriod := Reg.ReadInteger('UniposPollPeriod');

      if Reg.ValueExists('UniposSalesErrorText') then
        UniposSalesErrorText := Reg.ReadString('UniposSalesErrorText');

      if Reg.ValueExists('UniposUniqueItemPrefix') then
        UniposUniqueItemPrefix := Reg.ReadString('UniposUniqueItemPrefix');

      if Reg.ValueExists('UniposRefundErrorText') then
        UniposRefundErrorText := Reg.ReadString('UniposRefundErrorText');

      if Reg.ValueExists('AntiFroudFilterEnabled') then
        AntiFroudFilterEnabled := Reg.ReadBool('AntiFroudFilterEnabled');

      if Reg.ValueExists('UniposFilterEnabled') then
        UniposFilterEnabled := Reg.ReadBool('UniposFilterEnabled');

      if Reg.ValueExists('UniposPrinterEnabled') then
        UniposPrinterEnabled := Reg.ReadBool('UniposPrinterEnabled');

      // Tank report
      if Reg.ValueExists('TankReportKey') then
        TankReportKey := Reg.ReadString('TankReportKey');

      if Reg.ValueExists('TankReportHeader') then
        TankReportHeader := Reg.ReadString('TankReportHeader');

      if Reg.ValueExists('TankReportTrailer') then
        TankReportTrailer := Reg.ReadString('TankReportTrailer');

      if Reg.ValueExists('TankReportItem') then
        TankReportItem := Reg.ReadString('TankReportItem');

      if Reg.ValueExists('TankManualLine') then
        TankManualLine := Reg.ReadString('TankManualLine');

      if Reg.ValueExists('CompleteZReportMode') then
        CompleteZReportMode := Reg.ReadBool('CompleteZReportMode');
      // Fuel
      if Reg.ValueExists('FuelItemText') then
        FuelItemText := Reg.ReadString('FuelItemText');

      if Reg.ValueExists('FuelAmountStep') then
        FuelAmountStep := Reg.ReadFloat('FuelAmountStep');

      if Reg.ValueExists('FuelAmountPrecision') then
      begin
        CurrencyValue := Reg.ReadFloat('FuelAmountPrecision');
        if ValidFuelAmountPrecision(CurrencyValue) then
          FFuelAmountPrecision := CurrencyValue;
      end;

      if Reg.ValueExists('FuelRoundEnabled') then
        FuelRoundEnabled := Reg.ReadBool('FuelRoundEnabled');

      if Reg.ValueExists('CashRoundEnabled') then
        CashRoundEnabled := Reg.ReadBool('CashRoundEnabled');

      if Reg.ValueExists('EmptyReceiptBeforeZReportEnabled') then
        EmptyReceiptBeforeZReportEnabled := Reg.ReadBool('EmptyReceiptBeforeZReportEnabled');

      if Reg.ValueExists('TextReplacementEnabled') then
        TextReplacementEnabled := Reg.ReadBool('TextReplacementEnabled');

      if Reg.ValueExists('CashInProcessingEnabled') then
        CashInProcessingEnabled := Reg.ReadBool('CashInProcessingEnabled');

      if Reg.ValueExists('CashInTextPattern') then
        CashInTextPattern := Reg.ReadString('CashInTextPattern');

      if Reg.ValueExists('PawnTicketMode') then
        PawnTicketMode := Reg.ReadInteger('PawnTicketMode');

      if Reg.ValueExists('PawnTicketText') then
        PawnTicketText := Reg.ReadString('PawnTicketText');
    end;
    LoadPayTypes(KeyName);
    Replacements.LoadFromRegistry(KeyName + REGSTR_KEY_TEXTMAP);
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParameters.LoadPayTypes(const KeyName: WideString);
var
  i: Integer;
  Reg: TTntRegistry;
  PayTypeText: WideString;
  PayTypeCode: Integer;
  PayTypeNames: TTntStrings;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyName + REGSTR_KEY_PAYTYPES, False) then
    begin
      PayTypes.Clear;
      PayTypeNames := TTntStringList.Create;
      try
        Reg.GetValueNames(PayTypeNames);
        for i := 0 to PayTypeNames.Count-1 do
        begin
          PayTypeText := PayTypeNames[i];
          if Reg.ValueExists(PayTypeText) then
          begin
            PayTypeCode := Reg.ReadInteger(PayTypeText);
            PayTypes.Add(PayTypeCode, PayTypeText);
          end;
        end;
      finally
        PayTypeNames.Free;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParameters.SaveSysParameters(const DeviceName: WideString);
var
  i: Integer;
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetSysKeyName(DeviceName);
    if not Reg.OpenKey(KeyName, True) then
      raise Exception.CreateFmt(MsgKeyOpenError, [KeyName]);

    Reg.WriteString('', FiscalPrinterProgID);
    Reg.WriteInteger('ConnectionType', ConnectionType);
    Reg.WriteInteger('RemotePort', RemotePort);
    Reg.WriteString('RemoteHost', RemoteHost);
    Reg.WriteInteger('ComNumber', PortNumber);
    Reg.WriteInteger('BaudRate', BaudRate);
    Reg.WriteInteger('SysPassword', SysPassword);
    Reg.WriteInteger('UsrPassword', UsrPassword);
    Reg.WriteString('SubtotalText', SubtotalText);
    Reg.WriteString('CloseRecText', CloseRecText);
    Reg.WriteString('VoidRecText', VoidRecText);
    Reg.WriteInteger('FontNumber', FontNumber);
    Reg.WriteInteger('ByteTimeout', ByteTimeout);
    Reg.WriteInteger('MaxRetryCount', MaxRetryCount);
    Reg.WriteBool('SearchByPortEnabled', SearchByPortEnabled);
    Reg.WriteBool('SearchByBaudRateEnabled', SearchByBaudRateEnabled);
    Reg.WriteInteger('PollInterval', PollInterval);
    Reg.WriteInteger('DeviceByteTimeout', DeviceByteTimeout);

    Reg.WriteInteger('TimeToSleep', FTimeToSleep);
    Reg.WriteBool('MonitoringEnabled', MonitoringEnabled);
    Reg.WriteBool('StatusEventsEnabled', StatusEventsEnabled);
    // Log
    Reg.WriteBool('LogFileEnabled', LogFileEnabled);
    Reg.WriteString('LogFilePath', LogFilePath);
    Reg.WriteInteger('LogFileLifeTime', LogFileLifeTime);

    Reg.WriteInteger('CutType', CutType);
    Reg.WriteInteger('LogoPosition', LogoPosition);
    Reg.WriteInteger('NumHeaderLines', NumHeaderLines);
    Reg.WriteInteger('NumTrailerLines', NumTrailerLines);
    Reg.WriteInteger('HeaderFont', HeaderFont);
    Reg.WriteInteger('TrailerFont', TrailerFont);
    Reg.WriteInteger('Encoding', Encoding);
    Reg.WriteInteger('BarcodePrintDelay', BarcodePrintDelay);

    // Training mode text params
    Reg.WriteString('TrainModeText', TrainModeText);
    Reg.WriteString('TrainCashInText', TrainCashInText);
    Reg.WriteString('TrainCashOutText', TrainCashOutText);
    Reg.WriteString('TrainSaleText', TrainSaleText);
    Reg.WriteString('TrainVoidRecText', TrainVoidRecText);
    Reg.WriteString('TrainTotalText', TrainTotalText);
    Reg.WriteString('TrainCashPayText', TrainCashPayText);
    Reg.WriteString('TrainPay2Text', TrainPay2Text);
    Reg.WriteString('TrainPay3Text', TrainPay3Text);
    Reg.WriteString('TrainPay4Text', TrainPay4Text);
    Reg.WriteString('TrainChangeText', TrainChangeText);
    Reg.WriteString('TrainStornoText', TrainStornoText);
    Reg.WriteInteger('StatusCommand', StatusCommand);
    Reg.WriteInteger('HeaderType', HeaderType);
    // Malina
    Reg.WriteString('MalinaPromoText', MalinaPromoText);
    Reg.WriteString('MalinaCardPrefix', MalinaCardPrefix);
    Reg.WriteString('MalinaPointsText', MalinaPointsText);
    Reg.WriteString('MalinaRegistryKey', MalinaRegistryKey);
    Reg.WriteInteger('MalinaPoints', MalinaPoints);
    Reg.WriteInteger('MalinaCoefficient', MalinaCoefficient);
    Reg.WriteBool('MalinaFilterEnabled', MalinaFilterEnabled);
    Reg.WriteBool('ClearRegistry', MalinaClearRegistry);
    // Unipos
    Reg.WriteInteger('UniposTextFont', UniposTextFont);
    Reg.WriteInteger('UniposHeaderFont', UniposHeaderFont);
    Reg.WriteInteger('UniposTrailerFont', UniposTrailerFont);
    Reg.WriteInteger('UniposPollPeriod', UniposPollPeriod);
    Reg.WriteString('UniposSalesErrorText', UniposSalesErrorText);
    Reg.WriteString('UniposUniqueItemPrefix', UniposUniqueItemPrefix);
    Reg.WriteString('UniposRefundErrorText', UniposRefundErrorText);
    Reg.WriteBool('AntiFroudFilterEnabled', AntiFroudFilterEnabled);
    Reg.WriteBool('UniposFilterEnabled', UniposFilterEnabled);
    Reg.WriteBool('UniposPrinterEnabled', UniposPrinterEnabled);
    // Tank report
    Reg.WriteString('TankReportKey', TankReportKey);
    Reg.WriteString('TankReportHeader', TankReportHeader);
    Reg.WriteString('TankReportTrailer', TankReportTrailer);
    Reg.WriteString('TankReportItem', TankReportItem);
    Reg.WriteString('TankManualLine', TankManualLine);
    Reg.WriteBool('CompleteZReportMode', CompleteZReportMode);
    // Fuel
    Reg.WriteString('FuelItemText', FuelItemText);
    Reg.WriteFloat('FuelAmountStep', FuelAmountStep);
    Reg.WriteFloat('FuelAmountPrecision', FuelAmountPrecision);
    Reg.WriteBool('FuelRoundEnabled', FuelRoundEnabled);
    Reg.WriteBool('CashRoundEnabled', CashRoundEnabled);
    Reg.WriteBool('EmptyReceiptBeforeZReportEnabled', EmptyReceiptBeforeZReportEnabled);
    Reg.WriteBool('TextReplacementEnabled', TextReplacementEnabled);
    Reg.WriteBool('CashInProcessingEnabled', CashInProcessingEnabled);
    Reg.WriteString('CashInTextPattern', CashInTextPattern);
    Reg.WriteInteger('PawnTicketMode', PawnTicketMode);
    Reg.WriteString('PawnTicketText', PawnTicketText);

    Reg.DeleteKey(REGSTR_KEY_PAYTYPES);
    if Reg.OpenKey(REGSTR_KEY_PAYTYPES, True) then
    begin
      for i := 0 to FPayTypes.Count-1 do
      begin
        Reg.WriteInteger(FPayTypes[i].Text, FPayTypes[i].Code);
      end;
    end;
    Reg.CloseKey;
    Replacements.SaveToRegistry(KeyName + REGSTR_KEY_TEXTMAP);
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParameters.SetLogoPosition(const Value: Integer);
resourcestring
  SInvalidLogoPosition = 'Invalid LogoPosition value (%d).';
begin
  if Value <> LogoPosition then
  begin
    if not Value in [LogoAfterHeader, LogoBeforeHeader] then
      raise Exception.CreateFmt(SInvalidLogoPosition, [Value]);

    FLogoPosition := Value;
  end;
end;

class function TPrinterParameters.GetUsrKeyName(const DeviceName: WideString): WideString;
begin
  Result := Format('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

procedure TPrinterParameters.LoadUsrParameters(const DeviceName: WideString);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TPrinterParameters.LoadUsrParameters', [DeviceName]);
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(GetUsrKeyName(DeviceName), False) then
    begin
      if Reg.ValueExists('Header') then
        FHeader := Reg.ReadString('Header');

      if Reg.ValueExists('Trailer') then
        FTrailer := Reg.ReadString('Trailer');

      if Reg.ValueExists('HeaderPrinted') then
        FHeaderPrinted := Reg.ReadBool('HeaderPrinted');

      if Reg.ValueExists('LogoSize') then
        FLogoSize := Reg.ReadInteger('LogoSize');

      if Reg.ValueExists('LogoEnabled') then
        FLogoEnabled := Reg.ReadBool('LogoEnabled');

      if Reg.ValueExists('LogoCenter') then
        FLogoCenter := Reg.ReadBool('LogoCenter');

      if Reg.ValueExists('Department') then
        FDepartment := Reg.ReadInteger('Department');
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParameters.SaveUsrParameters(const DeviceName: WideString);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TPrinterParameters.SaveUsrParameters', [DeviceName]);

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(GetUsrKeyName(DeviceName), True) then
    begin
      Reg.WriteString('Header', Header);
      Reg.WriteString('Trailer', Trailer);
      Reg.WriteBool('HeaderPrinted', HeaderPrinted);
      Reg.WriteInteger('LogoSize', LogoSize);
      Reg.WriteBool('LogoEnabled', LogoEnabled);
      Reg.WriteBool('LogoCenter', LogoCenter);
      Reg.WriteInteger('Department', Department);
    end else
    begin
      raise Exception.Create('Registry key open error');
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParameters.SetReplacements(const Value: TTextMap);
begin
  FReplacements.Assign(Value);
end;

procedure TPrinterParameters.SetFuelAmountPrecision(const Value: Currency);
begin
  if Value <> FuelAmountPrecision then
  begin
    CheckFuelAmountPrecision(Value);
    FFuelAmountPrecision := Value;
  end;
end;

procedure TPrinterParameters.CheckFuelAmountPrecision(const Value: Currency);
begin
  if not ValidFuelAmountPrecision(Value) then
    raise Exception.CreateFmt('Invalid FuelAmountPrecision value, %.2f', [Value]);
end;

function TPrinterParameters.ValidFuelAmountPrecision(const Value: Currency): Boolean;
begin
  Result := (Value >= 0) and (Value <= 1);
end;

end.
