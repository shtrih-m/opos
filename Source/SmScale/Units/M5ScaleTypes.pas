unit M5ScaleTypes;

interface

uses
  // VCL
  Windows, SysUtils;

type
  TBaudRates = array [0..6] of Integer;

  { TM5Params }

  TM5Params = record
    Port: Integer;
    BaudRate: Integer;
    Timeout: Integer;
  end;

  { TM5StatusFlags }

  TM5StatusFlags = record
    Value: Integer;
    isWeightFixed: Boolean;      // бит 0 - признак фиксации веса
    isAutoZeroOn: Boolean;       // бит 1 - признак работы автонуля
    isChannelEnabled: Boolean;   // бит 2 - "0"- канал выключен, "1"- канал включен.
    isTareSet: Boolean;          // бит 3 - признак тары
    isWeightStable: Boolean;     // бит 4 - признак успокоения веса
    isAutoZeroError: Boolean;    // бит 5 - ошибка автонуля при включении
    isOverweight: Boolean;       // бит 6 - перегрузка по весу
    isReadWeightError: Boolean;  // бит 7 - ошибка при получении измерения
    isWeightTooLow: Boolean;     // бит 8 - весы недогружены
    isADCNotResponding: Boolean; // бит 9 - нет ответа от АЦП
  end;

  { TM5Status }

  TM5Status = record
    Flags: TM5StatusFlags;
    Weight: Integer; // Вес (4 байта со знаком), диапазон -НПВ..НПВ.
    Tare: Integer; // Тара (2 байта), диапазон 0..ТАРА (значение задано в характеристиках канала).
  end;

  { TGraduationPoint }

  TGraduationPoint = record
    Number: Integer;
    Weight: Integer;
  end;

  { TGraduationStatus }

  TGraduationStatus = record
    ChannelNumber: Integer; // Номер канала (1 байт): текущий выбранный весовой канал.
    PointNumber: Integer; // Реперная точка (2 байта) : вес в текущей реперной точке.
    PointStatus: Integer; // Состояние реперной точки (1 байт):
  end;

  { TScaleChannel }

  TScaleChannel = record
    Number: Integer;
    Flags: Integer; // Флаги (1 байт) :
    ChannelType: Integer;
    isTareSampling: Boolean;  // бит 2 - Выборка массы тары из диапазона взвешивания.
    isRangeFlag1: Boolean; // бит3 - +2e при переключении диапазонов.
    isRangeFlag2: Boolean; // бит4 - НПВ +9е.
    PointPosition: Integer; // Положение десятичной точки (1 байт) : Диапазон 0..6.
    Power: ShortInt; // Степень (1 байт), диапазон: -127..128.
    MaxWeight: Integer;
    MinWeight: Integer;
    MaxTare: Integer;
    Range1: Integer; // Диапазон1 (2 байта), диапазон 0..65535
    Range2: Integer; // Диапазон2 (2 байта), диапазон 0..65535
    Range3: Integer; // Диапазон3 (2 байта), диапазон 0..65535
    Discreteness1: Integer; // Дискретность1 (1 байт), диапазон 0..255
    Discreteness2: Integer; // Дискретность2 (1 байт), диапазон 0..255
    Discreteness3: Integer; // Дискретность3 (1 байт), диапазон 0..255
    Discreteness4: Integer; // Дискретность4 (1 байт), диапазон 0..255
    PointCount: Integer; // Количество градуировочных точек
    CalibrationsCount: Integer;
  end;

  { TDeviceMetrics }

  TDeviceMetrics = record
    MajorType: Integer;
    MinorType: Integer;
    MajorVersion: Integer;
    MinorVersion: Integer;
    Model: Integer;
    Language: Integer;
    Name: string;
  end;

  { TM5Status2  }

  TM5Status2 = record
    Mode: Integer;
    Weight: Integer;
    Tare: Integer;
    ItemType: Integer;   // 0..1
    Quantity: Integer;   // 0..99
    Price: Integer;
    Amount: Integer;
    LastKey: Integer;
  end;

  { TM5WareItem }

  TM5WareItem = record
    ItemType: Integer;
    Quantity: Integer;
    Price: Integer;
  end;

  { TM5PowerReport }

  TM5PowerReport = record
    Voltage5: Integer;
    Voltage12: Integer;
    VoltageX: Integer;
    VoltageFlags: Integer;
    VoltageX1: Integer;
  end;

  { IM5ScaleDevice }

  IM5ScaleDevice = interface
  ['{FE8BEB3C-373A-4A99-B5F4-990E31A3EE9F}']
    function LockKeyboard: Integer;
    function UnlockKeyboard: Integer;
    function WriteMode(Mode: Integer): Integer;
    function SendKeyCode(Code: Integer): Integer;
    function ReadMode(var Mode: Integer): Integer;
    function ReadParams(var P: TM5Params): Integer;
    function WriteParams(const P: TM5Params): Integer;
    function WritePassword(const NewPassword: Integer): Integer;
    function Zero: Integer;
    function Tare: Integer;
    function WriteTareValue(Value: Integer): Integer;
    function ReadStatus(var R: TM5Status): Integer;
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
    function GetCommandTimeout: Integer;
    function GetPassword: Integer;
    function WriteWare(const P: TM5WareItem): Integer;
    function ReadFirmwareCRC(var R: Integer): Integer;
    function ReadPowerReport(var R: TM5PowerReport): Integer;
    function TestGet(var R: string): Integer;
    function TestClr: Integer;
    procedure Check(Code: Integer);
    procedure SetPassword(const Value: Integer);
    procedure SetCommandTimeout(const Value: Integer);
    function ReadStatus2(var R: TM5Status2): Integer;
    function SendCommand(const Command: string; var Answer: string): Integer;
    function HandleException(E: Exception): Integer;
    function GetResultCode: Integer;
    function GetResultText: WideString;
    function ClearResult: Integer;
    function GetModeText(Mode: Integer): WideString;
    function GetLanguageText(Code: Integer): WideString;
    function GetBaudRates: TBaudRates;
    function ReadWeightFactor: Double;

    property ResultCode: Integer read GetResultCode;
    property BaudRates: TBaudRates read GetBaudRates;
    property ResultText: WideString read GetResultText;
    property Password: Integer read GetPassword write SetPassword;
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout;
  end;

  { IScaleUIController }

  IScaleUIController = interface
  ['{FC5210F5-33FE-47A6-B971-2B20EC4ABF0C}']
    procedure ShowScaleDlg;
  end;


const
  /////////////////////////////////////////////////////////////////////////////
  // Mode constants

  M5SCALE_MODE_NORMAL = 0; // Normal mode
  M5SCALE_MODE_CALIBR = 1; // Graduation mode
  M5SCALE_MODE_DATA   = 2; // Data mode

  /////////////////////////////////////////////////////////////////////////////
  // Mode text constants

  S_M5SCALE_MODE_NORMAL  = 'Normal mode';
  S_M5SCALE_MODE_CALIBR  = 'Graduation mode';
  S_M5SCALE_MODE_DATA    = 'Data mode';
  S_M5SCALE_MODE_UNKNOWN = 'Unknown mode';

  /////////////////////////////////////////////////////////////////////////////
  // ResultCode constants

  E_M5SCALE_NOERROR       = 0;
  E_M5SCALE_NOCONNECTION  = -1;
  E_M5SCALE_ANSWERLENGTH  = -2;
  E_M5SCALE_UNKNOWN       = -100;

  /////////////////////////////////////////////////////////////////////////////
  // Command names

  S_COMMAND_07h = 'Перейти в режим';
  S_COMMAND_08h = 'Эмуляция клавиатуры';
  S_COMMAND_09h = 'Блокировка/разблокировка клавиатуры';
  S_COMMAND_11h = 'Запрос текущего режима весового модуля 2';
  S_COMMAND_12h = 'Запрос текущего режима весового модуля';
  S_COMMAND_14h = 'Установка параметров обмена';
  S_COMMAND_15h = 'Чтение параметров обмена';
  S_COMMAND_16h = 'Изменение пароля администратора';
  S_COMMAND_30h = 'Установить ноль';
  S_COMMAND_31h = 'Установить тару';
  S_COMMAND_32h = 'Задать тару';
  S_COMMAND_33h = 'Записать параметры товара';
  S_COMMAND_3Ah = 'Запрос состояния весового канала';
  S_COMMAND_70h = 'Записать градуировочную точку';
  S_COMMAND_71h = 'Прочитать градуировочную точку';
  S_COMMAND_72h = 'Начать градуировку';
  S_COMMAND_73h = 'Запрос состояния процесса градуировки';
  S_COMMAND_74h = 'Прервать процесс градуировки';
  S_COMMAND_75h = 'Получить показания АЦП для текущего канала';
  S_COMMAND_90h = 'Запрос состояния клавиатуры';
  S_COMMAND_E5h = 'Прочитать количество весовых каналов';
  S_COMMAND_E6h = 'Выбрать весовой канал';
  S_COMMAND_E7h = 'Включить / выключить текущий весовой канал';
  S_COMMAND_E8h = 'Прочитать характеристики весового канала';
  S_COMMAND_E9h = 'Записать характеристики весового канала';
  S_COMMAND_EAh = 'Получить номер текущего весового канала';
  S_COMMAND_EFh = 'Перезапуск текущего весового канала';
  S_COMMAND_F0h = 'Сброс';
  S_COMMAND_F1h = 'Тест 1';
  S_COMMAND_F2h = 'Прочитать CRC прошивки';
  S_COMMAND_F3h = 'Прочитать отчет о питании';
  S_COMMAND_F8h = 'Тест 2';
  S_COMMAND_FCh = 'Получить тип устройства';
  S_COMMAND_UNKNOWN = 'Неизвестная команда';


  /////////////////////////////////////////////////////////////////////////////
  // Error text

  S_ERROR_00  = 'Ошибок нет';
  S_ERROR_17  = 'Ошибка в значении тары';
  S_ERROR_120 = 'Неизвестная команда';
  S_ERROR_121 = 'Неверная длина данных команды';
  S_ERROR_122 = 'Неверный пароль';
  S_ERROR_123 = 'Команда не реализуется в данном режиме';
  S_ERROR_124 = 'Неверное значение параметра';
  S_ERROR_150 = 'Ошибка при попытке установки нуля';
  S_ERROR_151 = 'Ошибка при установке тары';
  S_ERROR_152 = 'Вес не фиксирован';
  S_ERROR_166 = 'Сбой энергонезависимой памяти';
  S_ERROR_167 = 'Команда не реализуется интерфейсом';
  S_ERROR_170 = 'Исчерпан лимит попыток обращения с неверным паролем';
  S_ERROR_180 = 'Режим градуировки блокирован градуировочным переключателем';
  S_ERROR_181 = 'Клавиатура заблокирована';
  S_ERROR_182 = 'Нельзя поменять тип текущего канала';
  S_ERROR_183 = 'Нельзя выключить текущий канал';
  S_ERROR_184 = 'С данным каналом ничего нельзя делать';
  S_ERROR_185 = 'Неверный номер канала';
  S_ERROR_186 = 'Нет ответа от АЦП';

  S_ERROR_UNKNOWN = 'Неизвестная ошибка';
  S_ERROR_ANSWERLENGTH = 'Answer data length is too short';

  /////////////////////////////////////////////////////////////////////////////
  // Point status

  S_POINT_STATUS_0 = 'Точка готова для измерения';
  S_POINT_STATUS_1 = 'Точка измеряется, успокоения нет';
  S_POINT_STATUS_2 = 'Точка измеряется, успокоение есть';
  S_POINT_STATUS_3 = 'Градуировка закончена успешно';
  S_POINT_STATUS_4 = 'Градуировка закончена с ошибкой';
  S_POINT_STATUS_UNKNOWN = 'Неизвестное состояние точки';


const
  M5BaudRates: TBaudRates =
  (
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_19200,
    CBR_38400,
    CBR_57600,
    CBR_115200
  );



function IntToBaudRate(Value: Integer): Integer;
function BaudRateToInt(Value: Integer): Integer;

implementation

function BaudRateToInt(Value: Integer): Integer;
begin
  case Value of
    CBR_2400   : Result := 0;
    CBR_4800   : Result := 1;
    CBR_9600   : Result := 2;
    CBR_19200  : Result := 3;
    CBR_38400  : Result := 4;
    CBR_57600  : Result := 5;
    CBR_115200 : Result := 6;
  else
    Result := 1;
  end;
end;

function IntToBaudRate(Value: Integer): Integer;
begin
  case Value of
    0: Result := CBR_2400;
    1: Result := CBR_4800;
    2: Result := CBR_9600;
    3: Result := CBR_19200;
    4: Result := CBR_38400;
    5: Result := CBR_57600;
    6: Result := CBR_115200;
  else
    Result := 1;
  end;
end;

end.
