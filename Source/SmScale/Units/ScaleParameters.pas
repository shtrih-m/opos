unit ScaleParameters;

interface

uses
  // VCL
  Windows, SysUtils, Registry,
  // Opos
  Opos, Oposhi, OposException,
  // Shared
  LogFile,
  // this
  ScaleTypes, StringUtils;

const
  /////////////////////////////////////////////////////////////////////////////
  // "CCOType" constants

  CCOTYPE_RCS   = 0;
  CCOTYPE_NCR   = 1;
  CCOTYPE_NONE  = 2;

type
  { TScaleParameters }

  TScaleParameters = class
  public
    CCOType: Integer;
    Password: Integer;
    Encoding: Integer;
    PortNumber: Integer;
    BaudRate: Integer;
    ByteTimeout: Integer;
    CommandTimeout: Integer;
    MaxRetryCount: Integer;
    SearchByPortEnabled: Boolean;
    SearchByBaudRateEnabled: Boolean;
    LogFileEnabled: Boolean;
    LogMaxCount: Integer;
    CapPrice: Boolean;
    PollPeriod: Integer;
    FLogger: ILogFile;
  public
    constructor Create(ALogger: ILogFile);
    procedure SetDefaults; virtual;
    procedure WriteLogParameters;
    procedure Load(const DeviceName: string); virtual;
    procedure Save(const DeviceName: string); virtual;
    class procedure DeleteKey(const DeviceName: string);
    class procedure CreateKey(const DeviceName: string);
    class function GetKeyName(const DeviceName: string): string;
    property Logger: ILogFile read FLogger;
  end;

const
  DefCCOType                  = CCOTYPE_RCS;
  DefPortNumber               = 1;         // COM1
  DefByteTimeout              = 1000;      // 1000 ms
  DefBaudRate                 = CBR_4800;  // 4800
  DefCommandTimeout           = 1000;      // 1000 ms
  DefPassword                 = 30;
  DefEncoding                 = EncodingWindows;
  DefMaxRetryCount            = 3;
  DefSearchByPortEnabled      = False;
  DefSearchByBaudRateEnabled  = False;
  DefLogFileEnabled           = True;
  DefLogMaxCount              = 10;
  DefCapPrice                 = True;
  DefPollPeriod               = 100;
  ScaleProgID                 = 'OposShtrih.Scale';

  /////////////////////////////////////////////////////////////////////////////
  // DriverParameter conatants

  ParamCCOType                  = 0;
  ParamPassword                 = 1;
  ParamEncoding                 = 2;
  ParamPortNumber               = 3;
  ParamBaudRate                 = 4;
  ParamByteTimeout              = 5;
  ParamCommandTimeout           = 6;
  ParamMaxRetryCount            = 7;
  ParamSearchByPortEnabled      = 8;
  ParamSearchByBaudRateEnabled  = 9;
  ParamLogFileEnabled           = 10;
  ParamLogMaxCount              = 11;
  ParamCapPrice                 = 12;
  ParamPollPeriod               = 13;


implementation

const
  REGSTR_VAL_PASSWORD               = 'Password';
  REGSTR_VAL_ENCODING               = 'Encoding';
  REGSTR_VAL_PORTNUMBER             = 'PortNumber';
  REGSTR_VAL_BAUDRATE               = 'BaudRate';
  REGSTR_VAL_BYTETIMEOUT            = 'ByteTimeout';
  REGSTR_VAL_COMMANDTIMEOUT         = 'CommandTimeout';
  REGSTR_VAL_MAXRETRYCOUNT          = 'MaxRetryCount';
  REGSTR_VAL_PORTSEARCHENABLED      = 'SearchByPortEnabled';
  REGSTR_VAL_BAUDRATESEARCHENABLED  = 'SearchByBaudRateEnabled';
  REGSTR_VAL_CCOTYPE                = 'CCOType';
  REGSTR_VAL_LOGFILEENABLED         = 'LogFileEnabled';
  REGSTR_VAL_LOGMAXCOUNT            = 'LogMaxCount';
  REGSTR_VAL_CAPPRICE               = 'CapPrice';
  REGSTR_VAL_POLLPERIOD             = 'PollPeriod';

  REGSTR_KEY_OPEN_ERROR             = 'Registry key open error';

{ TScaleParameters }

constructor TScaleParameters.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  SetDefaults;
end;

procedure TScaleParameters.SetDefaults;
begin
  Password := DefPassword;
  Encoding := DefEncoding;
  PortNumber := DefPortNumber;
  BaudRate := DefBaudRate;
  ByteTimeout := DefByteTimeout;
  CommandTimeout := DefCommandTimeout;
  MaxRetryCount := DefMaxRetryCount;
  SearchByPortEnabled := DefSearchByPortEnabled;
  SearchByBaudRateEnabled := DefSearchByBaudRateEnabled;
  CCOType := DefCCOType;
  LogFileEnabled := DefLogFileEnabled;
  LogMaxCount := DefLogMaxCount;
  CapPrice := DefCapPrice;
  PollPeriod := DefPollPeriod;
end;

procedure TScaleParameters.WriteLogParameters;
begin
  Logger.Debug('Password                : ' + IntToStr(Password));
  Logger.Debug('Encoding                : ' + IntToStr(Encoding));
  Logger.Debug('PortNumber              : ' + IntToStr(PortNumber));
  Logger.Debug('BaudRate                : ' + IntToStr(BaudRate));
  Logger.Debug('ByteTimeout             : ' + IntToStr(ByteTimeout));
  Logger.Debug('CommandTimeout          : ' + IntToStr(CommandTimeout));
  Logger.Debug('MaxRetryCount           : ' + IntToStr(MaxRetryCount));
  Logger.Debug('SearchByPortEnabled     : ' + BoolToStr(SearchByPortEnabled));
  Logger.Debug('SearchByBaudRateEnabled : ' + BoolToStr(SearchByBaudRateEnabled));
  Logger.Debug('CCOType                 : ' + IntToStr(CCOType));
  Logger.Debug('LogFileEnabled          : ' + BoolToStr(LogFileEnabled));
  Logger.Debug('LogMaxCount             : ' + IntToStr(LogMaxCount));
  Logger.Debug('CapPrice                : ' + BoolToStr(CapPrice));
  Logger.Debug('PollPeriod              : ' + IntToStr(PollPeriod));
end;

class function TScaleParameters.GetKeyName(const DeviceName: string): string;
begin
  Result := Format('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_SCAL, DeviceName]);
end;

class procedure TScaleParameters.DeleteKey(const DeviceName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.DeleteKey(GetKeyName(DeviceName));
  finally
    Reg.Free;
  end;
end;

class procedure TScaleParameters.CreateKey(const DeviceName: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.CreateKey(GetKeyName(DeviceName));
  finally
    Reg.Free;
  end;
end;

procedure TScaleParameters.Load(const DeviceName: string);
var
  Reg: TRegistry;
begin
  Logger.Debug('TScaleParameters.Load', DeviceName);

  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(GetKeyName(DeviceName), False) then
      raiseOposException(OPOS_OR_REGBADNAME);

    if Reg.ValueExists(REGSTR_VAL_PASSWORD) then
      Password := Reg.ReadInteger(REGSTR_VAL_PASSWORD);

    if Reg.ValueExists(REGSTR_VAL_ENCODING) then
      Encoding := Reg.ReadInteger(REGSTR_VAL_ENCODING);

    if Reg.ValueExists(REGSTR_VAL_PORTNUMBER) then
      PortNumber := Reg.ReadInteger(REGSTR_VAL_PORTNUMBER);

    if Reg.ValueExists(REGSTR_VAL_BAUDRATE) then
      BaudRate := Reg.ReadInteger(REGSTR_VAL_BAUDRATE);

    if Reg.ValueExists(REGSTR_VAL_BYTETIMEOUT) then
      ByteTimeout := Reg.ReadInteger(REGSTR_VAL_BYTETIMEOUT);

    if Reg.ValueExists(REGSTR_VAL_COMMANDTIMEOUT) then
      CommandTimeout := Reg.ReadInteger(REGSTR_VAL_COMMANDTIMEOUT);

    if Reg.ValueExists(REGSTR_VAL_MAXRETRYCOUNT) then
      MaxRetryCount := Reg.ReadInteger(REGSTR_VAL_MAXRETRYCOUNT);

    if Reg.ValueExists(REGSTR_VAL_PORTSEARCHENABLED) then
      SearchByPortEnabled := Reg.ReadBool(REGSTR_VAL_PORTSEARCHENABLED);

    if Reg.ValueExists(REGSTR_VAL_BAUDRATESEARCHENABLED) then
      SearchByBaudRateEnabled := Reg.ReadBool(REGSTR_VAL_BAUDRATESEARCHENABLED);

    if Reg.ValueExists(REGSTR_VAL_CCOTYPE) then
      CCOType := Reg.ReadInteger(REGSTR_VAL_CCOTYPE);

    if Reg.ValueExists(REGSTR_VAL_LOGFILEENABLED) then
      LogFileEnabled := Reg.ReadBool(REGSTR_VAL_LOGFILEENABLED);

    if Reg.ValueExists(REGSTR_VAL_LOGMAXCOUNT) then
      LogMaxCount := Reg.ReadInteger(REGSTR_VAL_LOGMAXCOUNT);

    if Reg.ValueExists(REGSTR_VAL_CAPPRICE) then
      CapPrice := Reg.ReadBool(REGSTR_VAL_CAPPRICE);

    if Reg.ValueExists(REGSTR_VAL_POLLPERIOD) then
      PollPeriod := Reg.ReadInteger(REGSTR_VAL_POLLPERIOD);
  finally
    Reg.Free;
  end;
  WriteLogParameters;
end;

procedure TScaleParameters.Save(const DeviceName: string);
var
  Reg: TRegistry;
begin
  Logger.Debug('TScaleParameters.Save', DeviceName);

  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if not Reg.OpenKey(GetKeyName(DeviceName), True) then
      raise Exception.Create(REGSTR_KEY_OPEN_ERROR);

    Reg.WriteString('', ScaleProgID);
    Reg.WriteInteger(REGSTR_VAL_PASSWORD, Password);
    Reg.WriteInteger(REGSTR_VAL_ENCODING, Encoding);
    Reg.WriteInteger(REGSTR_VAL_PORTNUMBER, PortNumber);
    Reg.WriteInteger(REGSTR_VAL_BAUDRATE, BaudRate);
    Reg.WriteInteger(REGSTR_VAL_BYTETIMEOUT, ByteTimeout);
    Reg.WriteInteger(REGSTR_VAL_COMMANDTIMEOUT, CommandTimeout);
    Reg.WriteInteger(REGSTR_VAL_MAXRETRYCOUNT, MaxRetryCount);
    Reg.WriteBool(REGSTR_VAL_PORTSEARCHENABLED, SearchByPortEnabled);
    Reg.WriteBool(REGSTR_VAL_BAUDRATESEARCHENABLED, SearchByBaudRateEnabled);
    Reg.WriteInteger(REGSTR_VAL_CCOTYPE, CCOType);
    Reg.WriteBool(REGSTR_VAL_LOGFILEENABLED, LogFileEnabled);
    Reg.WriteInteger(REGSTR_VAL_LOGMAXCOUNT, LogMaxCount);
    Reg.WriteBool(REGSTR_VAL_CAPPRICE, CapPrice);
    Reg.WriteInteger(REGSTR_VAL_POLLPERIOD, PollPeriod);
  finally
    Reg.Free;
  end;
end;

end.
