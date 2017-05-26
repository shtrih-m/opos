unit MalinaParams;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ComServ,
  // Tnt
  TntRegistry, TntClasses, TntSysUtils,
  // This
  Oposhi, PrinterTypes, LogFile, FileUtils,
  //SmFiscalPrinterLib_TLB,
  StringUtils, TextMap, RegUtils;

const
  /////////////////////////////////////////////////////////////////////////////
  // PawnTicketMode constants

  PawnTicketModeNone    = 0;
  PawnTicketModeFirst   = 1;
  PawnTicketModeAll     = 2;

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
  DefRetalixSearchCI = false;



  REGSTR_UNIPOS_MALINA = 'SOFTWARE\Unipos\Malina';

type
  { TMalinaParams }

  TMalinaParams = class
  private
    FReplacements: TTextMap;
    FFuelAmountPrecision: Currency;
    FLogger: TLogFile;

    procedure LoadSysParameters(const DeviceName: WideString);
    class function GetSysKeyName(const DeviceName: WideString): WideString;
    procedure LogText(const Caption, Text: WideString);
    procedure SetReplacements(const Value: TTextMap);
    procedure SetFuelAmountPrecision(const Value: Currency);
    procedure CheckFuelAmountPrecision(const Value: Currency);
    function ValidFuelAmountPrecision(const Value: Currency): Boolean;

    property Logger: TLogFile read FLogger;
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
    UniposFilesPath: WideString;
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
    FuelItemText: WideString;
    FuelAmountStep: Currency;
    RosneftDiscountCards: Boolean;
    RosneftCardMask: string;
    RosneftCardName: string;
    RosneftAddTextEnabled: Boolean;
    RosneftItemName: string;
    RosneftItemDepartment: Integer;
    RosneftAddText: string;
    RetalixDBPath: string;
    RetalixDBEnabled: Boolean;
    RetalixSearchCI: Boolean;
    RosneftDryReceiptEnabled: Boolean;

    constructor Create(ALogger: TLogFile);
    destructor Destroy; override;

    procedure SetDefaults;
    procedure WriteLogParameters;
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);
    procedure SaveSysParameters(const DeviceName: WideString);
    class function DeviceExists(const DeviceName: WideString): Boolean;
    // Fuel
    property Replacements: TTextMap read FReplacements write SetReplacements;
    property FuelAmountPrecision: Currency read FFuelAmountPrecision write SetFuelAmountPrecision;
  end;

implementation

const
  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';
  MsgKeyOpenError = 'Error opening registry key: %s';

{ TMalinaParams }

procedure TMalinaParams.SetReplacements(const Value: TTextMap);
begin
  FReplacements.Assign(Value);
end;

procedure TMalinaParams.SetFuelAmountPrecision(const Value: Currency);
begin
  if Value <> FuelAmountPrecision then
  begin
    CheckFuelAmountPrecision(Value);
    FFuelAmountPrecision := Value;
  end;
end;

procedure TMalinaParams.CheckFuelAmountPrecision(const Value: Currency);
begin
  if not ValidFuelAmountPrecision(Value) then
    raise Exception.CreateFmt('Invalid FuelAmountPrecision value, %.2f', [Value]);
end;

function TMalinaParams.ValidFuelAmountPrecision(const Value: Currency): Boolean;
begin
  Result := (Value >= 0) and (Value <= 1);
end;

constructor TMalinaParams.Create(ALogger: TLogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FReplacements := TTextMap.Create;
  SetDefaults;
end;

destructor TMalinaParams.Destroy;
begin
  FReplacements.Free;
  inherited Destroy;
end;

procedure TMalinaParams.SetDefaults;
begin
  Logger.Debug('TMalinaParams.SetDefaults');

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
  UniposFilesPath := GetModulePath + 'Unipos\';


  TankReportKey := DefTankReportKey;
  TankReportHeader := DefTankReportHeader;
  TankReportTrailer := DefTankReportTrailer;
  TankReportItem := DefTankReportItem;
  TankManualLine := DefTankManualLine;
  CompleteZReportMode := True;
  FuelItemText := DefFuelItemText;
  FuelAmountStep := DefFuelAmountStep;
  FuelAmountPrecision := DefFuelAmountPrecision;
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
  RosneftDiscountCards := False;
  RosneftCardMask := '^.+Loyalty.+[0-9]{6}99[0-9]{6}';
  RosneftCardName := 'КАРТА КОМАНДА 700599######';
  RosneftAddTextEnabled := False;
  RosneftItemName := 'Пополнение бан.к.ВБР';
  RosneftItemDepartment := 15;
  RosneftAddText := '';
  RetalixDBPath := 'c:\Positive\DataPdx\';
  RetalixDBEnabled := True;
  RetalixSearchCI := DefRetalixSearchCI;
  RosneftDryReceiptEnabled := False;
end;

class function TMalinaParams.GetSysKeyName(const DeviceName: WideString): WideString;
begin
  Result := Format('%s\%s\%s\', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

class function TMalinaParams.DeviceExists(
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

procedure TMalinaParams.LogText(const Caption, Text: WideString);
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

procedure TMalinaParams.Load(const DeviceName: WideString);
begin
  try
    LoadSysParameters(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TMalinaParams.Load', E);
    end;
  end;
  WriteLogParameters;
end;

procedure TMalinaParams.Save(const DeviceName: WideString);
begin
  try
    SaveSysParameters(DeviceName);
  except
    on E: Exception do
      Logger.Error('TMalinaParams.Save', E);
  end;
end;

procedure TMalinaParams.LoadSysParameters(const DeviceName: WideString);
var
  KeyName: WideString;
  Reg: TTntRegistry;
  CurrencyValue: Currency;
begin
  Logger.Debug('TMalinaParams.Load', [DeviceName]);

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetSysKeyName(DeviceName);
    if Reg.OpenKey(KeyName, False) then
    begin
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

      if Reg.ValueExists('UniposFilesPath') then
        UniposFilesPath := Reg.ReadString('UniposFilesPath');


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

      if Reg.ValueExists('RosneftDiscountCards') then
        RosneftDiscountCards := Reg.ReadBool('RosneftDiscountCards');

      if Reg.ValueExists('RosneftCardMask') then
        RosneftCardMask := Reg.ReadString('RosneftCardMask');

      if Reg.ValueExists('RosneftCardName') then
        RosneftCardName := Reg.ReadString('RosneftCardName');

      if Reg.ValueExists('RosneftAddTextEnabled') then
        RosneftAddTextEnabled := Reg.ReadBool('RosneftAddTextEnabled');

      if Reg.ValueExists('RosneftItemName') then
        RosneftItemName := Reg.ReadString('RosneftItemName');

      if Reg.ValueExists('RosneftItemDepartment') then
        RosneftItemDepartment := Reg.ReadInteger('RosneftItemDepartment');

      if Reg.ValueExists('RosneftAddText') then
        RosneftAddText := Reg.ReadString('RosneftAddText');

      if Reg.ValueExists('RetalixDBPath') then
        RetalixDBPath := Reg.ReadString('RetalixDBPath');

      if Reg.ValueExists('RetalixDBEnabled') then
        RetalixDBEnabled := Reg.ReadBool('RetalixDBEnabled');

      if Reg.ValueExists('RetalixSearchCI') then
        RetalixSearchCI := Reg.ReadBool('RetalixSearchCI');

      if Reg.ValueExists('RosneftDryReceiptEnabled') then
        RosneftDryReceiptEnabled := Reg.ReadBool('RosneftDryReceiptEnabled');

    end;
    Replacements.LoadFromRegistry(KeyName + REGSTR_KEY_TEXTMAP);
  finally
    Reg.Free;
  end;
end;

procedure TMalinaParams.SaveSysParameters(const DeviceName: WideString);
var
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
    Reg.WriteString('UniposFilesPath', UniposFilesPath);
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
    Reg.WriteBool('RosneftDiscountCards', RosneftDiscountCards);
    Reg.WriteString('RosneftCardMask', RosneftCardMask);
    Reg.WriteString('RosneftCardName', RosneftCardName);
    Reg.WriteBool('RosneftAddTextEnabled', RosneftAddTextEnabled);
    Reg.WriteString('RosneftItemName', RosneftItemName);
    Reg.WriteInteger('RosneftItemDepartment', RosneftItemDepartment);
    Reg.WriteString('RosneftAddText', RosneftAddText);
    Reg.WriteString('RetalixDBPath', RetalixDBPath);
    Reg.WriteBool('RetalixDBEnabled', RetalixDBEnabled);
    Reg.WriteBool('RetalixSearchCI', RetalixSearchCI);
    Reg.WriteBool('RosneftDryReceiptEnabled', RosneftDryReceiptEnabled);


    Reg.CloseKey;
    Replacements.SaveToRegistry(KeyName + REGSTR_KEY_TEXTMAP);
  finally
    Reg.Free;
  end;
end;

procedure TMalinaParams.WriteLogParameters;
var
  i: Integer;
begin
  Logger.Debug('MalinaPromoText: ' + MalinaPromoText);
  Logger.Debug('MalinaCardPrefix: ' + MalinaCardPrefix);
  Logger.Debug('MalinaPointsText: ' + MalinaPointsText);
  Logger.Debug('MalinaPoints: ' + IntToStr(MalinaPoints));
  Logger.Debug('MalinaPoints: ' + IntToStr(MalinaCoefficient));
  Logger.Debug('MalinaPoints: ' + MalinaRegistryKey);
  Logger.Debug('MalinaClearRegistry: ' + BoolToStr(MalinaClearRegistry));

  Logger.Debug('UniposTextFont: ' + IntToStr(UniposTextFont));
  Logger.Debug('UniposHeaderFont: ' + IntToStr(UniposHeaderFont));
  Logger.Debug('UniposTrailerFont: ' + IntToStr(UniposTrailerFont));
  Logger.Debug('UniposPollPeriod: ' + IntToStr(UniposPollPeriod));
  Logger.Debug(Format('UniposSalesErrorText: ''%s''', [UniposSalesErrorText]));
  Logger.Debug(Format('UniposUniqueItemPrefix: ''%s''', [UniposUniqueItemPrefix]));
  Logger.Debug(Format('UniposRefundErrorText: ''%s''', [UniposRefundErrorText]));
  Logger.Debug(Format('UniposFilesPath: ''%s''', [UniposFilesPath]));
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
  Logger.Debug(Format('RosneftDiscountCards: ''%s''', [
    BoolToStr(RosneftDiscountCards)]));

  Logger.Debug('RosneftCardMask: ' + RosneftCardMask);
  Logger.Debug('RosneftCardName: ' + RosneftCardName);
  Logger.Debug('MalinaClearRegistry: ' + BoolToStr(MalinaClearRegistry));
  Logger.Debug('UniposFilterEnabled: ' + BoolToStr(UniposFilterEnabled));
  Logger.Debug('UniposPrinterEnabled: ' + BoolToStr(UniposPrinterEnabled));
  Logger.Debug('FuelRoundEnabled: ' + BoolToStr(FuelRoundEnabled));
  Logger.Debug('CashRoundEnabled: ' + BoolToStr(CashRoundEnabled));
  Logger.Debug('MalinaFilterEnabled: ' + BoolToStr(MalinaFilterEnabled));
  Logger.Debug('TextReplacementEnabled: ' + BoolToStr(TextReplacementEnabled));
  Logger.Debug('EmptyReceiptBeforeZReportEnabled: ' + BoolToStr(EmptyReceiptBeforeZReportEnabled));
  Logger.Debug('RosneftDiscountCards: ' + BoolToStr(RosneftDiscountCards));
  Logger.Debug('CashInProcessingEnabled: ' + BoolToStr(CashInProcessingEnabled));
  Logger.Debug('AntiFroudFilterEnabled: ' + BoolToStr(AntiFroudFilterEnabled));
  Logger.Debug('TankReportKey: ' + TankReportKey);
  Logger.Debug('TankReportHeader: ' + TankReportHeader);
  Logger.Debug('TankReportTrailer: ' + TankReportTrailer);
  Logger.Debug('TankReportItem: ' + TankReportItem);
  Logger.Debug('TankManualLine: ' + TankManualLine);
  Logger.Debug('CompleteZReportMode: ' + BoolToStr(CompleteZReportMode));
  Logger.Debug('LogFileLifeTime: ' + IntToStr(LogFileLifeTime));
  Logger.Debug('CashInTextPattern: ' + CashInTextPattern);
  Logger.Debug('PawnTicketMode: ' + IntToStr(PawnTicketMode));
  Logger.Debug('PawnTicketText: ' + PawnTicketText);
  Logger.Debug('RosneftAddTextEnabled: ' + BoolToStr(RosneftAddTextEnabled));
  Logger.Debug('RosneftItemName: ' + RosneftItemName);
  Logger.Debug('RosneftItemDepartment: ' + IntToStr(RosneftItemDepartment));
  Logger.Debug('RosneftAddText: ' + RosneftAddText);
  Logger.Debug('RetalixDBPath: ' + RetalixDBPath);
  Logger.Debug('RetalixDBEnabled: ' + BoolToStr(RetalixDBEnabled));
  Logger.Debug('RetalixSearchCI: ' + BoolToStr(RetalixSearchCI));
  Logger.Debug('RosneftDryReceiptEnabled: ' + BoolToStr(RosneftDryReceiptEnabled));

  Logger.Debug(Logger.Separator);
end;

end.
