unit M5ScaleDevice;

interface

uses
  // VCL
  Windows, SysUtils, SyncObjs, Math,
  // Tnt
  TntSysUtils,
  // This
  StringUtils, ByteUtils, ScaleTypes, ScaleFrame,
  CommunicationError, DriverError, M5ScaleTypes,
  DebugUtils, SerialPort, LogFile;

type
  { TM5ScaleDevice }

  TM5ScaleDevice = class(TInterfacedObject, IM5ScaleDevice)
  private
    FLogger: ILogFile;
    FPassword: Integer;
    FLock: TCriticalSection;
    FResultCode: Integer;
    FResultText: WideString;
    FCommandTimeout: Integer;
    FConnection: IScaleConnection;


    procedure Lock;
    procedure Unlock;
    procedure CheckMinLength(const Data: string; MinLength: Integer);

    property Logger: ILogFile read FLogger;
  public
    constructor Create(ALogger: ILogFile; AConnection: IScaleConnection);
    destructor Destroy; override;

    function LockKeyboard: Integer;
    function UnlockKeyboard: Integer;
    function GetBaudRates: TBaudRates;
    function WriteMode(Mode: Integer): Integer;
    function SendKeyCode(Code: Integer): Integer;
    function ReadMode(var Mode: Integer): Integer;
    function ReadParams(var P: TM5Params): Integer;
    function SendCommand(const Command: string): Integer; overload;
    function SendCommand(const Command: string; var Answer: string): Integer; overload;
    function WriteParams(const P: TM5Params): Integer;
    function WritePassword(const NewPassword: Integer): Integer;
    function Zero: Integer;
    function Tare: Integer;
    function WriteTareValue(Value: Integer): Integer;
    function ReadStatus(var R: TM5Status): Integer;
    function ReadStatus2(var R: TM5Status2): Integer;
    function WriteGraduationPoint(const P: TGraduationPoint): Integer;
    function ReadGraduationPoint(var R: TGraduationPoint): Integer;
    function StartGraduation: Integer;
    function StopGraduation: Integer;
    function ReadGraduationStatus(var R: TGraduationStatus): Integer;
    function ReadADC(var R: Integer): Integer;
    function ReadKeyboardStatus(var R: Integer): Integer;
    function ReadChannelCount(var Count: Integer): Integer;
    function SelectChannel(const Number: Integer): Integer;
    function EnableChannel: Integer;
    function DisableChannel: Integer;
    function ReadChannel(var R: TScaleChannel): Integer;
    function WriteChannel(const R: TScaleChannel): Integer;
    function ReadChannelNumber(var Number: Integer): Integer;
    function ResetChannel: Integer;
    function Reset: Integer;
    function ReadDeviceMetrics(var R: TDeviceMetrics): Integer;
    function GetErrorText(Code: Integer): string;
    function GetCommandText(Code: Integer): string;
    function GetFullErrorText(Code: Integer): string;
    function GetPointStatusText(Code: Integer): string;
    procedure Check(Code: Integer);
    function DecodeFlags(Flags: Integer): TM5StatusFlags;
    function GetCommandTimeout: Integer;
    procedure SetCommandTimeout(const Value: Integer);
    function GetPassword: Integer;
    procedure SetPassword(const Value: Integer);
    function WriteWare(const P: TM5WareItem): Integer;
    function ReadFirmwareCRC(var R: Integer): Integer;
    function ReadPowerReport(var R: TM5PowerReport): Integer;
    function TestGet(var R: string): Integer;
    function TestClr: Integer;
    function HandleException(E: Exception): Integer;
    function GetResultCode: Integer;
    function GetResultText: WideString;
    function ClearResult: Integer;
    function GetModeText(Mode: Integer): WideString;
    function GetLanguageText(Code: Integer): WideString;
    function ReadWeightFactor: Double;

    property BaudRates: TBaudRates read GetBaudRates;
    property Password: Integer read GetPassword write SetPassword;
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout;
  end;

implementation

{ TM5ScaleDevice }

constructor TM5ScaleDevice.Create(ALogger: ILogFile; AConnection: IScaleConnection);
begin
  inherited Create;
  FLogger := ALogger;
  FConnection := AConnection;
  FLock := TCriticalSection.Create;
end;

destructor TM5ScaleDevice.Destroy;
begin
  FLock.Free;
  FLogger := nil;
  inherited Destroy;
end;

procedure TM5ScaleDevice.Lock;
begin
  FLock.Enter;
end;

procedure TM5ScaleDevice.Unlock;
begin
  FLock.Leave;
end;

procedure TM5ScaleDevice.CheckMinLength(const Data: string;
  MinLength: Integer);
begin
  if Length(Data) < MinLength then
    raiseError(E_M5SCALE_ANSWERLENGTH, S_ERROR_ANSWERLENGTH);
end;

function TM5ScaleDevice.GetCommandTimeout: Integer;
begin
  Result := FCommandTimeout;
end;

procedure TM5ScaleDevice.SetCommandTimeout(const Value: Integer);
begin
  FCommandTimeout := Value;
end;

function TM5ScaleDevice.GetPassword: Integer;
begin
  Result := FPassword;
end;

procedure TM5ScaleDevice.SetPassword(const Value: Integer);
begin
  FPassword := Value;
end;

procedure TM5ScaleDevice.Check(Code: Integer);
begin
  if Code <> 0 then
    RaiseError(Code, GetFullErrorText(Code));
end;

function TM5ScaleDevice.SendCommand(const Command: string): Integer;
var
  Answer: string;
begin
  try
    Result := SendCommand(Command, Answer);

    FResultCode := Result;
    FResultText := GetErrorText(FResultCode);
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TM5ScaleDevice.SendCommand(
  const Command: string;
  var Answer: string): Integer;
var
  CommandText: string;
  CommandCode: Integer;
begin
  Lock;
  try
    CommandCode := Ord(Command[1]);
    CommandText := Tnt_WideFormat('%.2xh, %s', [CommandCode, GetCommandText(CommandCode)]);
    Logger.Debug(CommandText);

    ODS('-> ' + StrToHex(Command));
    Answer := FConnection.Send(CommandTimeout, Command);
    ODS('<- ' + StrToHex(Answer));

    Result := Ord(Answer[2]);
    Answer := Copy(Answer, 3, Length(Answer));
  finally
    Unlock;
  end;
end;

function TM5ScaleDevice.GetCommandText(Code: Integer): string;
begin
  case Code of
    $07: Result := S_COMMAND_07h;
    $08: Result := S_COMMAND_08h;
    $09: Result := S_COMMAND_09h;
    $11: Result := S_COMMAND_11h;
    $12: Result := S_COMMAND_12h;
    $14: Result := S_COMMAND_14h;
    $15: Result := S_COMMAND_15h;
    $16: Result := S_COMMAND_16h;
    $30: Result := S_COMMAND_30h;
    $31: Result := S_COMMAND_31h;
    $32: Result := S_COMMAND_32h;
    $33: Result := S_COMMAND_33h;
    $3A: Result := S_COMMAND_3Ah;
    $70: Result := S_COMMAND_70h;
    $71: Result := S_COMMAND_71h;
    $72: Result := S_COMMAND_72h;
    $73: Result := S_COMMAND_73h;
    $74: Result := S_COMMAND_74h;
    $75: Result := S_COMMAND_75h;
    $90: Result := S_COMMAND_90h;
    $E5: Result := S_COMMAND_E5h;
    $E6: Result := S_COMMAND_E6h;
    $E7: Result := S_COMMAND_E7h;
    $E8: Result := S_COMMAND_E8h;
    $E9: Result := S_COMMAND_E9h;
    $EA: Result := S_COMMAND_EAh;
    $EF: Result := S_COMMAND_EFh;
    $F0: Result := S_COMMAND_F0h;
    $F1: Result := S_COMMAND_F1h;
    $F2: Result := S_COMMAND_F2h;
    $F3: Result := S_COMMAND_F3h;
    $F8: Result := S_COMMAND_F8h;
    $FC: Result := S_COMMAND_FCh;
  else
    Result := S_COMMAND_UNKNOWN;
  end;
end;

function TM5ScaleDevice.GetFullErrorText(Code: Integer): string;
begin
  Result := Tnt_WideFormat('(%d), %s', [Code, GetErrorText(Code)]);
end;

function TM5ScaleDevice.GetErrorText(Code: Integer): string;
begin
  case Code of
    00: Result := S_ERROR_00;
    17: Result := S_ERROR_17;
    120: Result := S_ERROR_120;
    121: Result := S_ERROR_121;
    122: Result := S_ERROR_122;
    123: Result := S_ERROR_123;
    124: Result := S_ERROR_124;
    150: Result := S_ERROR_150;
    151: Result := S_ERROR_151;
    152: Result := S_ERROR_152;
    166: Result := S_ERROR_166;
    167: Result := S_ERROR_167;
    170: Result := S_ERROR_170;
    180: Result := S_ERROR_180;
    181: Result := S_ERROR_181;
    182: Result := S_ERROR_182;
    183: Result := S_ERROR_183;
    184: Result := S_ERROR_184;
    185: Result := S_ERROR_185;
    186: Result := S_ERROR_186;
  else
    Result := S_ERROR_UNKNOWN;
  end;
end;

function TM5ScaleDevice.GetPointStatusText(Code: Integer): string;
begin
  case Code of
    0: Result := S_POINT_STATUS_0;
    1: Result := S_POINT_STATUS_1;
    2: Result := S_POINT_STATUS_2;
    3: Result := S_POINT_STATUS_3;
    4: Result := S_POINT_STATUS_4;
  else
    Result := S_POINT_STATUS_UNKNOWN;
  end;
end;

// 07h Перейти в режим

function TM5ScaleDevice.WriteMode(Mode: Integer): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WriteMode(%d)', [Mode]));
  Command := #$07 + IntToBin(Password, 4) + Chr(Mode);
  Result := SendCommand(Command);
end;

// 08h Эмуляция клавиатуры

function TM5ScaleDevice.SendKeyCode(Code: Integer): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('SendKeyCode(%d)', [Code]));
  Command := #$08 + IntToBin(Password, 4) + Chr(Code);
  Result := SendCommand(Command);
end;

// 09h Блокировка/разблокировка клавиатуры

function TM5ScaleDevice.LockKeyboard: Integer;
var
  Command: string;
begin
  Logger.Debug('LockKeyboard');
  Command := #$09 + IntToBin(Password, 4) + #1;
  Result := SendCommand(Command);
end;

// 09h Блокировка/разблокировка клавиатуры

function TM5ScaleDevice.UnlockKeyboard: Integer;
var
  Command: string;
begin
  Logger.Debug('UnlockKeyboard');
  Command := #$09 + IntToBin(Password, 4) + #0;
  Result := SendCommand(Command);
end;

// 12h Запрос текущего режима весового модуля

function TM5ScaleDevice.ReadMode(var Mode: Integer): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadMode');
  Command := #$12 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 1);
    Mode := Ord(Answer[1]);
  end;
end;

// 14h, Установка параметров обмена

function TM5ScaleDevice.WriteParams(const P: TM5Params): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WriteParams(%d, %d, %d)', [P.Port, P.BaudRate, P.Timeout]));
  Command := #$14 +
    IntToBin(Password, 4) +
    Chr(P.Port) +
    Chr(P.BaudRate) +
    Chr(P.Timeout);
  Result := SendCommand(Command);
end;

// 15h Чтение параметров обмена

function TM5ScaleDevice.ReadParams(var P: TM5Params): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug(Format('ReadParams(%d)', [P.Port]));
  Command := #$15 + IntToBin(Password, 4) + Chr(P.Port);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 2);
    P.BaudRate := Ord(Answer[1]);
    P.Timeout := Ord(Answer[2]);
  end;
end;

// 16h Изменение пароля администратора

function TM5ScaleDevice.WritePassword(const NewPassword: Integer): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WritePassword(%d)', [NewPassword]));
  Command := #$16 + IntToBin(Password, 4) + IntToBin(NewPassword, 4);
  Result := SendCommand(Command);
  if Result = 0 then
  begin
    Password := NewPassword;
  end;
end;

// 30h Установить ноль

function TM5ScaleDevice.Zero: Integer;
var
  Command: string;
begin
  Logger.Debug('Zero');
  Command := #$30 + IntToBin(Password, 4);
  Result := SendCommand(Command);
end;

// 31h Установить тару

function TM5ScaleDevice.Tare: Integer;
var
  Command: string;
begin
  Logger.Debug('Tare');
  Command := #$31 + IntToBin(Password, 4);
  Result := SendCommand(Command);
end;

function TM5ScaleDevice.WriteTareValue(Value: Integer): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WriteTareValue(%d)', [Value]));
  Command := #$32 + IntToBin(Password, 4) + IntToBin(Value, 2);
  Result := SendCommand(Command);
end;

// 3Ah, Запрос состояния весового канала
// 3A 00 14 00 02 00 00 00 00 00 08 2F


function TM5ScaleDevice.ReadStatus(var R: TM5Status): Integer;
var
  Flags: Integer;
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadStatus');
  Command := #$3A + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    Flags := BinToInteger(Answer, 1, 2);
    R.Flags := DecodeFlags(Flags);
    R.Weight := BinToInteger(Answer, 3, 4);
    R.Tare := BinToInteger(Answer, 7, 2);
  end;
end;

function TM5ScaleDevice.DecodeFlags(Flags: Integer): TM5StatusFlags;
begin
  Result.Value := Flags;
  Result.isWeightFixed := TestBit(Flags, 0);
  Result.isAutoZeroOn := TestBit(Flags, 1);
  Result.isChannelEnabled := TestBit(Flags, 2);
  Result.isTareSet := TestBit(Flags, 3);
  Result.isWeightStable := TestBit(Flags, 4);
  Result.isAutoZeroError := TestBit(Flags, 5);
  Result.isOverweight := TestBit(Flags, 6);
  Result.isReadWeightError := TestBit(Flags, 7);
  Result.isWeightTooLow := TestBit(Flags, 8);
  Result.isADCNotResponding := TestBit(Flags, 9);
end;

// 70h Записать градуировочную точку

function TM5ScaleDevice.WriteGraduationPoint(
  const P: TGraduationPoint): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WriteGraduationPoint(%d, %d)', [P.Number, P.Weight]));
  Command := #$70 +
    IntToBin(Password, 4) +
    Chr(P.Number) +
    IntToBin(P.Weight, 2);
  Result := SendCommand(Command);
end;

// 71h Прочитать градуировочную точку

function TM5ScaleDevice.ReadGraduationPoint(
  var R: TGraduationPoint): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug(Format('ReadGraduationPoint(%d)', [R.Number]));
  Command := #$71 + IntToBin(Password, 4) + Chr(R.Number);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 2);
    R.Weight := BinToInteger(Answer, 1, 2);
  end;
end;

// 72h Начать градуировку

function TM5ScaleDevice.StartGraduation: Integer;
var
  Command: string;
begin
  Logger.Debug('StartGraduation');
  Command := #$72 + IntToBin(Password, 4);
  Result := SendCommand(Command);
end;

// 73h Запрос состояния процесса градуировки

function TM5ScaleDevice.ReadGraduationStatus(
  var R: TGraduationStatus): Integer;
var
  Answer: string;
  Command: string;
begin
  Logger.Debug('ReadGraduationStatus');
  Command := #$73 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 4);
    R.ChannelNumber := Ord(Answer[1]);
    R.PointNumber := BinToInteger(Answer, 2, 2);
    R.PointStatus := Ord(Answer[4]);
  end;
end;

// 74h Прервать процесс градуировки

function TM5ScaleDevice.StopGraduation: Integer;
var
  Command: string;
begin
  Logger.Debug('StopGraduation');
  Command := #$74 + IntToBin(Password, 4);
  Result := SendCommand(Command);
end;

// 75h Получить показания АЦП для текущего канала

function TM5ScaleDevice.ReadADC(var R: Integer): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadADC');
  Command := #$75 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 4);
    R := BinToInteger(Answer, 1, 4);
  end;
end;

function TM5ScaleDevice.ReadKeyboardStatus(var R: Integer): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadKeyboardStatus');
  Command := #$90 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 1);
    R := BinToInteger(Answer, 1, 1);
  end;
end;

// E5h Прочитать количество весовых каналов 8

function TM5ScaleDevice.ReadChannelCount(var Count: Integer): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadChannelCount');
  Command := #$E5 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 1);
    Count := BinToInteger(Answer, 1, 1);
  end;
end;

// E6h Выбрать весовой канал

function TM5ScaleDevice.SelectChannel(const Number: Integer): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('SelectChannel(%d)', [Number]));
  Command := #$E6 + IntToBin(Password, 4) + Chr(Number);
  Result := SendCommand(Command);
end;

// E7h Включить / выключить текущий весовой канал

function TM5ScaleDevice.DisableChannel: Integer;
var
  Command: string;
begin
  Logger.Debug('DisableChannel');
  Command := #$E7 + IntToBin(Password, 4) + #0;
  Result := SendCommand(Command);
end;

function TM5ScaleDevice.EnableChannel: Integer;
var
  Command: string;
begin
  Logger.Debug('EnableChannel');
  Command := #$E7 + IntToBin(Password, 4) + #1;
  Result := SendCommand(Command);
end;

// E8h Прочитать характеристики весового канала

function TM5ScaleDevice.ReadChannel(var R: TScaleChannel): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug(Format('ReadChannel(%d)', [R.Number]));
  Command := #$E8 + Chr(R.Number);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 22);

    R.Flags := BinToInteger(Answer, 1, 2);
    R.PointPosition := Ord(Answer[3]);
    R.Power := ShortInt(Answer[4]);
    R.MaxWeight := BinToInteger(Answer, 5, 2);
    R.MinWeight := BinToInteger(Answer, 7, 2);
    R.MaxTare := BinToInteger(Answer, 9, 2);
    R.Range1 := BinToInteger(Answer, 11, 2);
    R.Range2 := BinToInteger(Answer, 13, 2);
    R.Range3 := BinToInteger(Answer, 15, 2);
    R.Discreteness1 := BinToInteger(Answer, 17, 1);
    R.Discreteness2 := BinToInteger(Answer, 18, 1);
    R.Discreteness3 := BinToInteger(Answer, 19, 1);
    R.Discreteness4 := BinToInteger(Answer, 20, 1);
    R.PointCount := BinToInteger(Answer, 21, 1);
    R.CalibrationsCount := BinToInteger(Answer, 22, 1);
    // Decode flags
    R.ChannelType := R.Flags and 3;
    R.isTareSampling := TestBit(R.Flags, 2);
    R.isRangeFlag1 := TestBit(R.Flags, 3);
    R.isRangeFlag2 := TestBit(R.Flags, 4);
  end;
end;

// E9h Записать характеристики весового канала 10

function TM5ScaleDevice.WriteChannel(const R: TScaleChannel): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WriteChannel(%d)', [R.Number]));
  Command := #$E9 +
    IntToBin(Password, 4) +
    Chr(R.Number) +
    IntToBin(R.Flags, 2) +
    Chr(R.PointPosition) +
    Chr(R.Power) +
    IntToBin(R.MaxWeight, 2) +
    IntToBin(R.MinWeight, 2) +
    IntToBin(R.MaxTare, 2) +
    IntToBin(R.Range1, 2) +
    IntToBin(R.Range2, 2) +
    IntToBin(R.Range3, 2) +
    Chr(R.Discreteness1) +
    Chr(R.Discreteness2) +
    Chr(R.Discreteness3) +
    Chr(R.Discreteness4) +
    Chr(R.PointCount) +
    Chr(R.CalibrationsCount);

  ODS('WriteChannel: ' + StrToHex(Command));
  Result := SendCommand(Command);
end;

function TM5ScaleDevice.ReadChannelNumber(var Number: Integer): Integer;
var
  Answer: string;
begin
  Logger.Debug('ReadChannelNumber');
  Result := SendCommand(#$EA, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 1);
    Number := Ord(Answer[1]);
  end;
end;

// EFh Перезапуск текущего весового канала

function TM5ScaleDevice.ResetChannel: Integer;
var
  Command: string;
begin
  Logger.Debug('ResetChannel');
  Command := #$EF + IntToBin(Password, 4);
  Result := SendCommand(Command);
end;

// F0h Сброс
function TM5ScaleDevice.Reset: Integer;
var
  Command: string;
begin
  Logger.Debug('Reset');
  Command := #$F0 + IntToBin(Password, 4);
  Result := SendCommand(Command);
end;

// FCh Получить тип устройства

function TM5ScaleDevice.ReadDeviceMetrics(var R: TDeviceMetrics): Integer;
var
  Answer: string;
begin
  Logger.Debug('ReadDeviceMetrics');
  Result := SendCommand(#$FC, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 6);
    R.MajorType := Ord(Answer[1]);
    R.MinorType := Ord(Answer[2]);
    R.MajorVersion := Ord(Answer[3]);
    R.MinorVersion := Ord(Answer[4]);
    R.Model := Ord(Answer[5]);
    R.Language := Ord(Answer[6]);
    R.Name := Copy(Answer, 7, Length(Answer)-6);
  end;
end;

///////////////////////////////////////////////////////////////////////////////
// 11h, Запрос состояния весового канала 2

function TM5ScaleDevice.ReadStatus2(var R: TM5Status2): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadStatus2');
  Command := #$11 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 18);
    R.Mode := BinToInteger(Answer, 1, 2);
    R.Weight := BinToInteger(Answer, 3, 4);
    R.Tare := BinToInteger(Answer, 7, 2);
    R.ItemType := BinToInteger(Answer, 10, 1);
    R.Quantity := BinToInteger(Answer, 11, 1);
    R.Price := BinToInteger(Answer, 12, 3);
    R.Amount := BinToInteger(Answer, 15, 3);
    R.LastKey := BinToInteger(Answer, 18, 1);
  end;
end;

function TM5ScaleDevice.WriteWare(const P: TM5WareItem): Integer;
var
  Command: string;
begin
  Logger.Debug(Format('WriteWare(%d, %d, %d)', [
    P.ItemType, P.Quantity, P.Price]));

  Command := #$33 + IntToBin(Password, 4) +
    Chr(P.ItemType) +
    Chr(P.Quantity) +
    IntToBin(P.Price, 3);
  Result := SendCommand(Command);
end;

function TM5ScaleDevice.TestGet(var R: string): Integer;
var
  Answer: string;
begin
  Logger.Debug('TestGet');
  Result := SendCommand(#$F1, Answer);
  if Result = 0 then
  begin
    R := Answer;
  end;
end;

function TM5ScaleDevice.ReadFirmwareCRC(var R: Integer): Integer;
var
  Answer: string;
begin
  Logger.Debug('ReadFirmwareCRC');
  Result := SendCommand(#$F2, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 2);
    R := BinToInteger(Answer, 1, 2);
  end;
end;

function TM5ScaleDevice.ReadPowerReport(var R: TM5PowerReport): Integer;
var
  Command: string;
  Answer: string;
begin
  Logger.Debug('ReadPowerReport');
  Command := #$F3 + IntToBin(Password, 4);
  Result := SendCommand(Command, Answer);
  if Result = 0 then
  begin
    CheckMinLength(Answer, 8);
    R.Voltage5 := BinToInteger(Answer, 1, 2);
    R.Voltage12 := BinToInteger(Answer, 3, 2);
    R.VoltageX := BinToInteger(Answer, 5, 2);
    R.VoltageFlags := BinToInteger(Answer, 7, 1);
    R.VoltageX1 := BinToInteger(Answer, 8, 1);
  end;
end;

function TM5ScaleDevice.TestClr: Integer;
begin
  Logger.Debug('TestClr');
  Result := SendCommand(#$F8);
end;

function TM5ScaleDevice.GetResultCode: Integer;
begin
  Result := FResultCode;
end;

function TM5ScaleDevice.GetResultText: WideString;
begin
  Result := FResultText;
end;

function TM5ScaleDevice.HandleException(E: Exception): Integer;
var
  DriverError: EDriverError;
begin
  FResultText := E.Message;
  FResultCode := E_M5SCALE_UNKNOWN;
  if E is EDriverError then
  begin
    DriverError := E as EDriverError;
    FResultCode := DriverError.ErrorCode;
  end;
  if E is ESerialPortError then
  begin
    FResultCode := E_M5SCALE_NOCONNECTION;
  end;
  Result := FResultCode;
end;

function TM5ScaleDevice.ClearResult: Integer;
begin
  Result := 0;
  FResultCode := 0;
  FResultText := S_ERROR_00;
end;

function TM5ScaleDevice.GetModeText(Mode: Integer): WideString;
begin
  case Mode of
    M5SCALE_MODE_NORMAL : Result := S_M5SCALE_MODE_NORMAL;
    M5SCALE_MODE_CALIBR : Result := S_M5SCALE_MODE_CALIBR;
    M5SCALE_MODE_DATA   : Result := S_M5SCALE_MODE_DATA;
  else
    Result := S_M5SCALE_MODE_UNKNOWN;
  end;
end;

function TM5ScaleDevice.GetLanguageText(Code: Integer): WideString;
begin
  case Code of
    0: Result := 'Russian';
    1: Result := 'English';
  else
    Result := 'Unknown language';
  end;
end;

function TM5ScaleDevice.GetBaudRates: TBaudRates;
begin
  Result := M5BaudRates;
end;

function TM5ScaleDevice.ReadWeightFactor: Double;
var
  Channel: TScaleChannel;
  ChannelNumber: Integer;
begin
  Check(ReadChannelNumber(ChannelNumber));
  Channel.Number := ChannelNumber;
  Check(ReadChannel(Channel));
  Result := Power(10, Channel.Power + 3);
end;


end.
