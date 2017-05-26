unit FiscalPrinterCommand;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // This
  PrinterCommand, PrinterFrame, PrinterProtocol, PrinterTypes,
  BinStream, StringUtils, SerialPort, PrinterTable, AppLog;

type
  { TCommandRec }

  TCommandRec = record
    Code: Byte;                 // command code
    TxData: string;             // tx data
    RxData: string;             // rx data
    ResultCode: Byte;           // result code
    RepeatFlag: Boolean;        // repeat command
    Timeout: Integer;           // command timeout
  end;

  TCommandEvent = procedure(Sender: TObject; var Command: TCommandRec) of object;

  { TFiscalPrinterCommand }

  TFiscalPrinterCommand = class
  private
    FPort: TSerialPort;
    FEnabled: Boolean;
    FTaxPassword: DWORD;        // tax officer password
    FSysPassword: DWORD;        // system administrator password
    FUsrPassword: DWORD;       // regular user password
    FPrintWidth: Integer;
    FTables: TPrinterTables;
    FFields: TPrinterFields;
    FProtocol: TPrinterProtocol;
    FOnCommand: TCommandEvent;

    function GetLine(const Text: string): string;
    function DecodeEJFlags(Flags: Byte): TEJFlags;
    class function ByteToTimeout(Value: Byte): DWORD;
    class function TimeoutToByte(Value: Integer): Byte;
    function ReadTableInfo(Table: Byte): TPrinterTableRec;
    class function BaudRateToCode(BaudRate: Integer): Integer;
    class function CodeToBaudRate(BaudRate: Integer): Integer;
    function FieldToStr(FieldInfo: TPrinterFieldRec; const Value: string): string;
    function FieldToInt(FieldInfo: TPrinterFieldRec; const Value: string): Integer;
    function GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
    function ReadFieldInfo(Table, Field: Byte): TPrinterFieldRec;
    function ExecuteData(const Data: string; var RxData: string): Integer;
    function ExecuteCommand(var Command: TCommandRec): Integer;

    property Tables: TPrinterTables read FTables;
    property Fields: TPrinterFields read FFields;
    property Protocol: TPrinterProtocol read FProtocol;
    function SendCommand(var Command: TCommandRec): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure OpenPort;
    procedure ClosePort;
    function GetLineLength(const Text: string; MaxLength: Integer): string;
    function StartDump(DeviceCode: Integer): Integer;
    function GetDumpBlock: TDumpBlock;
    procedure StopDump;
    function LongFisc(NewPassword: DWORD; PrinterID, FiscalID: Int64): TLongFiscResult;
    procedure SetLongSerial(Serial: Int64);
    function GetLongSerial: TGetLongSerial;
    function GetShortStatus: TPrinterShortStatus;
    function GetStatus: TPrinterStatus;
    function GetFMFlags(Flags: Byte): TFMFlags;
    function GetPrinterFlags(Flags: Word): TPrinterFlags;
    function PrintBoldString(Flags: Byte; const Text: string): Integer;
    function Beep: Integer;
    function GetPortParams(Port: Byte): TPortParams;
    procedure SetPortParams(Port: Byte; const PortParams: TPortParams);
    procedure PrintDocHeader(const DocName: string; DocNumber: Word);
    procedure StartTest(Interval: Byte);
    function ReadCashTotalizer(ID: Byte): Int64;
    function ReadActnTotalizer(ID: Byte): Word;
    procedure WriteLicense(License: Int64);
    function ReadLicense: Int64;
    procedure WriteTableInt(Table, Row, Field, Value: Integer);
    procedure DoWriteTable(Table, Row, Field: Integer; const FieldValue: string);
    procedure WriteTable(Table, Row, Field: Integer; const FieldValue: string);
    function ReadTableBin(Table, Row, Field: Integer): string;
    function ReadTableStr(Table, Row, Field: Integer): string;
    function ReadTableInt(Table, Row, Field: Integer): Integer;
    procedure SetPointPosition(PointPosition: Byte);
    procedure SetTime(const Time: TPrinterTime);
    procedure SetDate(const Date: TPrinterDate);
    procedure ConfirmDate(const Date: TPrinterDate);
    procedure InitializeTables;
    procedure CutPaper(CutType: Byte);
    function ReadFontInfo(FontNumber: Byte): TFontInfo;
    procedure ResetFiscalMemory;
    procedure ResetTotalizers;
    procedure OpenDrawer(DrawerNumber: Byte);
    procedure FeedPaper(Station: Byte; Lines: Byte);
    procedure EjectSlip(Direction: Byte);
    procedure StopTest;
    procedure PrintActnTotalizers;
    procedure PrintStringFont(Station, Font: Byte; const Line: string);
    procedure PrintXReport;
    procedure PrintZReport;
    procedure PrintDepartmentsReport;
    procedure PrintTaxReport;
    procedure PrintHeader;
    procedure PrintDocTrailer(Flags: Byte);
    procedure PrintTrailer;
    procedure WriteSerial(Serial: DWORD);
    procedure InitFiscalMemory;
    function ReadFMTotals(Flags: Byte): TFMTotals;
    function ReadFMLastRecordDate: TFMRecordDate;
    function ReadShiftsRange: TShiftRange;
    function Fiscalization(Password, PrinterID, FiscalID: Int64): TFiscalizationResult;
    function ReportOnDateRange(ReportType: Byte; Range: TShiftDateRange): TShiftRange;
    function ReportOnNumberRange(ReportType: Byte; Range: TShiftNumberRange): TShiftRange;
    procedure InterruptReport;
    function ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
    function OpenSlipDoc(Params: TSlipParams): TDocResult;
    function OpenStdSlip(Params: TStdSlipParams): TDocResult;
    function SlipOperation(Params: TSlipOperation; Operation: TPriceReg): Integer;
    function SlipStdOperation(LineNumber: Byte; Operation: TPriceReg): Integer;
    function SlipDiscount(Params: TSlipDiscountParams; Discount: TSlipDiscount): Integer;
    function SlipStdDiscount(Discount: TSlipDiscount): Integer;
    function SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ContinuePrint: Integer;
    function LoadGraphics(Line: Byte; Data: string): Integer;
    function PrintGraphics(Line1, Line2: Byte): Integer;
    function PrintBarcode(Barcode: Int64): Integer;
    function PrintGraphics2(Line1, Line2: Word): Integer;
    function LoadGraphics2(Line: Word; Data: string): Integer;
    function PrintBarLine(Height: Word; Data: string): Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetDayDiscountTotal: Int64;
    function GetRecDiscountTotal: Int64;
    function GetDayItemTotal: Int64;
    function GetRecItemTotal: Int64;
    function GetDayItemVoidTotal: Int64;
    function GetRecItemVoidTotal: Int64;
    function ReadTableStructure(Table: Byte): TPrinterTableRec;
    function ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
    function GetEJSesssionResult(Number: Word; var Text: string): Integer;
    function GetEJReportLine(var Line: string): Integer;
    function EJReportStop: Integer;
    procedure Check(Value: Integer);
    function GetEJStatus1(var Status: TEJStatus1): Integer;
    procedure PrintString(Stations: Byte; const Text: string);
    function Execute(const Data: string): string;
    function ExecuteStream(Stream: TBinStream): Integer;
    function ExecutePrinterCommand(Command: TPrinterCommand): Integer;
    function GetEnabled: Boolean;
    function GetPrintWidth: Integer;
    function GetSysPassword: DWORD;
    function GetTaxPassword: DWORD;
    function GetUsrPassword: DWORD;
    procedure SetEnabled(const Value: Boolean);
    procedure SetSysPassword(const Value: DWORD);
    procedure SetTaxPassword(const Value: DWORD);
    procedure SetUsrPassword(const Value: DWORD);

    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    function Sale(Operation: TPriceReg): Integer;
    function Buy(Operation: TPriceReg): Integer;
    function RetSale(Operation: TPriceReg): Integer;
    function RetBuy(Operation: TPriceReg): Integer;
    function Storno(Operation: TPriceReg): Integer;
    function ReceiptClose(Params: TCloseReceiptParams): TCloseReceiptResult;
    function ReceiptDiscount(Operation: TAmountOperation): Integer;
    function ReceiptCharge(Operation: TAmountOperation): Integer;
    function ReceiptCancel: Integer;
    function GetSubtotal: Int64;
    function ReceiptStornoDiscount(Operation: TAmountOperation): Integer;
    function ReceiptStornoCharge(Operation: TAmountOperation): Integer;
    function PrintReceiptCopy: Integer;
    function OpenReceipt(ReceiptType: Byte): Integer;
    function FormatLines(const Line1, Line2: string): string;
    function FormatBoldLines(const Line1, Line2: string): string;

    property Port: TSerialPort read FPort;
    property PrintWidth: Integer read GetPrintWidth;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property OnCommand: TCommandEvent read FOnCommand write FOnCommand;
    property TaxPassword: DWORD read GetTaxPassword write SetTaxPassword;
    property SysPassword: DWORD read GetSysPassword write SetSysPassword;
    property UsrPassword: DWORD read GetUsrPassword write SetUsrPassword;
  end;

  { EDisabledException }

  EDisabledException = class(Exception);
  EFiscalPrinterException = class(Exception);

const
  PrinterBaudRates: array [0..6] of Integer = (
    CBR_2400,
    CBR_4800,
    CBR_9600,
    CBR_19200,
    CBR_38400,
    CBR_57600,
    CBR_115200);

function FormatLineLength(const Text: string; MaxLength: Integer): string;

implementation

const
  MinLineWidth = 40;

function TestBit(Value, Bit: Integer): Boolean;
begin
  Result := (Value and (1 shl Bit)) <> 0;
end;

function PrinterDateToBin(Value: TPrinterDate): string;
begin
  SetLength(Result, Sizeof(Value));
  Move(Value, Result[1], Sizeof(Value));
end;

procedure CheckMinLength(const Data: string; MinLength: Integer);
begin
  if Length(Data) < MinLength then
    raise ECommunicationError.Create('Недостаточная длина данных ответа');
end;

function PrinterTimeToStr(Time: TPrinterTime): string;
begin
  Result := Format('%.2d:%.2d:%.2d)', [Time.Hour, Time.Min, Time.Sec]);
end;

function PrinterDateToStr(Date: TPrinterDate): string;
begin
  Result := Format('%.2d.%.2d.%.4d)', [Date.Day, Date.Month, Date.Year + 2000]);
end;

function FormatLineLength(const Text: string; MaxLength: Integer): string;
begin
  Result := Copy(Text, 1, MaxLength);
  Result := Result + StringOfChar(' ', MaxLength - Length(Result));
end;

{ TFiscalPrinterCommand }

constructor TFiscalPrinterCommand.Create;
begin
  inherited Create;
  FPort := TSerialPort.Create;
  FProtocol := TPrinterProtocol.Create(FPort);
  FFields := TPrinterFields.Create;
  FTables := TPrinterTables.Create;
end;

destructor TFiscalPrinterCommand.Destroy;
begin
  FPort.Free;
  FFields.Free;
  FTables.Free;
  FProtocol.Free;
  inherited Destroy;
end;

function TFiscalPrinterCommand.GetLine(const Text: string): string;
begin
  Result := GetLineLength(Text, PrintWidth);
end;

function TFiscalPrinterCommand.GetLineLength(const Text: string; MaxLength: Integer): string;
begin
  Result := Copy(Text, 1, MaxLength);
  Result := Result + StringOfChar(#0, MaxLength - Length(Result));
end;

function TFiscalPrinterCommand.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TFiscalPrinterCommand.GetPrintWidth: Integer;
begin
  Result := FPrintWidth;
end;

function TFiscalPrinterCommand.GetSysPassword: DWORD;
begin
  Result := FSysPassword;
end;

function TFiscalPrinterCommand.GetTaxPassword: DWORD;
begin
  Result := FTaxPassword;
end;

function TFiscalPrinterCommand.GetUsrPassword: DWORD;
begin
  Result := FUsrPassword;
end;

procedure TFiscalPrinterCommand.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TFiscalPrinterCommand.SetSysPassword(const Value: DWORD);
begin
  FSysPassword := Value;
end;

procedure TFiscalPrinterCommand.SetTaxPassword(const Value: DWORD);
begin
  FTaxPassword := Value;
end;

procedure TFiscalPrinterCommand.SetUsrPassword(const Value: DWORD);
begin
  FUsrPassword := Value;
end;

function TFiscalPrinterCommand.ReadFieldStructure(Table, Field: Byte): TPrinterFieldRec;
var
  AField: TPrinterField;
begin
  Logger.Debug('TFiscalPrinterCommand.ReadFieldStructure');
  AField := Fields.Find(Table, Field);
  if AField <> nil then
  begin
    Result := AField.Data;
  end else
  begin
    Result := ReadFieldInfo(Table, Field);
    TPrinterField.Create(Fields, Result);
  end;
end;

function TFiscalPrinterCommand.ReadTableStructure(Table: Byte): TPrinterTableRec;
var
  ATable: TPrinterTable;
begin
  Logger.Debug('TFiscalPrinterCommand.ReadTableStructure');
  ATable := Tables.ItemByNumber(Table);
  if ATable <> nil then
  begin
    Result := ATable.Data;
  end else
  begin
    Result := ReadTableInfo(Table);
    TPrinterTable.Create(Tables, Result);
  end;
end;

class function TFiscalPrinterCommand.BaudRateToCode(BaudRate: Integer): Integer;
begin
  case BaudRate of
    CBR_2400    : Result := 0;
    CBR_4800    : Result := 1;
    CBR_9600    : Result := 2;
    CBR_19200   : Result := 3;
    CBR_38400   : Result := 4;
    CBR_57600   : Result := 5;
    CBR_115200  : Result := 6;
  else
    Result := 1;
  end;
end;

class function TFiscalPrinterCommand.CodeToBaudRate(BaudRate: Integer): Integer;
begin
  case BaudRate of
    0: Result := CBR_2400;
    1: Result := CBR_4800;
    2: Result := CBR_9600;
    3: Result := CBR_19200;
    4: Result := CBR_38400;
    5: Result := CBR_57600;
    6: Result := CBR_115200;
  else
    Result := CBR_4800;
  end;
end;

class function TFiscalPrinterCommand.ByteToTimeout(Value: Byte): DWORD;
begin
  case Value of
    0..150   : Result := Value;
    151..249 : Result := (Value-149)*150;
  else
    Result := (Value-248)*15000;
  end;
end;

class function TFiscalPrinterCommand.TimeoutToByte(Value: Integer): Byte;
begin
  case Value of
    0..150        : Result := Value;
    151..15000    : Result := Round(Value/150) + 149;
    15001..105000 : Result := Round(Value/15000) + 248;
  else
    Result := Value;
  end;
end;

procedure TFiscalPrinterCommand.Check(Value: Integer);
begin
  if Value <> 0 then
    raise EFiscalPrinterException.Create(GetErrorText(Value));
end;

function TFiscalPrinterCommand.SendCommand(var Command: TCommandRec): Integer;
var
  CommandCode: Byte;
begin
  Command.RxData := Protocol.Send(Command.Timeout, Command.TxData);
  Command.RxData := Copy(Command.RxData, 3, Length(Command.RxData)-3);
  CommandCode := Ord(Command.RxData[1]);
  if CommandCode <> Command.Code then
    raise ECommunicationError.Create('Invalid answer code');

  Result := Ord(Command.RxData[2]);
  Command.ResultCode := Result;
  Command.RxData := Copy(Command.RxData, 3, Length(Command.RxData));
end;

function TFiscalPrinterCommand.ExecuteCommand(var Command: TCommandRec): Integer;
begin
  repeat
    Command.RepeatFlag := False;
    SendCommand(Command);
    if Assigned(FOnCommand) then FOnCommand(Self, Command);
    Result := Command.ResultCode;
    if not Command.RepeatFlag then Break;
  until false;
end;

function TFiscalPrinterCommand.ExecuteData(const Data: string; var RxData: string): Integer;
var
  Command: TCommandRec;
begin
  Command.Code := Ord(Data[1]);
  Command.Timeout := 10000; { !!! }
  Command.TxData := TPrinterFrame.Encode(Data);
  Result := ExecuteCommand(Command);
  RxData := Command.RxData;
end;

function TFiscalPrinterCommand.Execute(const Data: string): string;
begin
  Check(ExecuteData(Data, Result));
end;

function TFiscalPrinterCommand.ExecuteStream(Stream: TBinStream): Integer;
var
  RxData: string;
  TxData: string;
begin
  RxData := '';
  TxData := Stream.Data;
  Result := ExecuteData(TxData, RxData);
  Stream.Data := RxData;
end;

function TFiscalPrinterCommand.ExecutePrinterCommand(Command: TPrinterCommand): Integer;
var
  RxData: string;
  TxData: string;
  Stream: TBinStream;
begin
  Stream := TBinStream.Create;
  try
    Command.Encode(Stream);
    TxData := Chr(Command.GetCode) + Stream.Data;
    Result := ExecuteData(TxData, RxData);
    Stream.Data := RxData;
    Command.ResultCode := Result;
    if Command.ResultCode = 0 then
      Command.Decode(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TFiscalPrinterCommand.CashIn(Amount: Int64);
var
  Command: TCashInCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.CashIn(%d)', [Amount]));

  Command := TCashInCommand.Create;
  try
    Command.Password := UsrPassword;
    Command.Amount := Amount;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterCommand.CashOut(Amount: Int64);
var
  Command: TCashOutCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.CashOut(%d)', [Amount]));

  Command := TCashOutCommand.Create;
  try
    Command.Password := UsrPassword;
    Command.Amount := Amount;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterCommand.StartDump(DeviceCode: Integer): Integer;
var
  Command: TStartDumpCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.StartDump(%d)', [DeviceCode]));

  Command := TStartDumpCommand.Create;
  try
    Command.Password := SysPassword;
    Command.DeviceCode := DeviceCode;
    Check(ExecutePrinterCommand(Command));
    Result := Command.BlockCount;
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterCommand.GetDumpBlock: TDumpBlock;
var
  Command: TGetDumpBlockCommand;
begin
  Logger.Debug('TFiscalPrinterCommand.GetDumpBlock');

  Command := TGetDumpBlockCommand.Create;
  try
    Command.Password := SysPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.DumpBlock;
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterCommand.StopDump;
var
  Command: TStopDumpCommand;
begin
  Logger.Debug('TFiscalPrinterCommand.StopDump');

  Command := TStopDumpCommand.Create;
  try
    Command.Password := SysPassword;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterCommand.LongFisc(NewPassword: DWORD;
  PrinterID, FiscalID: Int64): TLongFiscResult;
var
  Command: TLongFiscalizationCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.LongFisc(%d,%d,%d)',
    [NewPassword, PrinterID, FiscalID]));

  Command := TLongFiscalizationCommand.Create;
  try
    Command.TaxPassword := TaxPassword;
    Command.NewPassword := NewPassword;
    Command.PrinterID := PrinterID;
    Command.FiscalID := FiscalID;
    Check(ExecutePrinterCommand(Command));
    Result := Command.FiscResult;
  finally
    Command.Free;
  end;
end;

procedure TFiscalPrinterCommand.SetLongSerial(Serial: Int64);
var
  Command: TSetLongSerialCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.SetLongSerial(%d)', [Serial]));

  Command := TSetLongSerialCommand.Create;
  try
    Command.Password := 0;
    Command.Serial := Serial;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Get Long Serial Number And Long ECRRN

  Command:	0FH. Length: 5 bytes.
  ·	Operator password (4 bytes)
  Answer:		0FH. Length: 16 bytes.
  ·	Result Code (1 byte)
  ·	Long Serial Number (7 bytes) 00000000000000…99999999999999
  ·	Long ECRRN (7 bytes) 00000000000000…99999999999999

******************************************************************************)

function TFiscalPrinterCommand.GetLongSerial: TGetLongSerial;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.GetLongSerial');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_GET_LONG_SERIAL);
    Stream.WriteDWORD(UsrPassword);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get Short FP Status

  Command:	10H. Length: 5 bytes.
  ·	Operator password (4 bytes)

  Answer:		10H. Length: 16 bytes.
  ·	Result Code (1 byte)
  ·	Operator index number (1 byte) 1…30
  ·	FP flags (2 bytes)
  ·	FP mode (1 byte)
  ·	FP submode (1 byte)
  ·	Quantity of operations on the current receipt (1 byte) lower byte of a two-byte digit (see below)
  ·	Battery voltage (1 byte)
  ·	Power source voltage (1 byte)
  ·	Fiscal Memory error code (1 byte)
  ·	EKLZ error code (1 byte) EKLZ=Electronic Cryptographic Journal
  ·	Quantity of operations on the current receipt (1 byte) upper byte of a two-byte digit (see below)
  ·	Reserved (3 bytes)

******************************************************************************)

function TFiscalPrinterCommand.GetShortStatus: TPrinterShortStatus;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.GetShortStatus');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_GET_SHORT_STATUS);
    Stream.WriteDWORD(UsrPassword);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Get FP Status
  Command:	11H. Length: 5 bytes.
  ·	Operator password (4 bytes)
  Answer:		11H. Length: 48 bytes.
  ·	Result Code (1 byte)
  ·	Operator index number (1 byte) 1…30
  ·	FP firmware version (2 bytes)
  ·	FP firmware build (2 bytes)
  ·	FP firmware date (3 bytes) DD-MM-YY
  ·	Number of FP in checkout line (1 byte)
  ·	Current receipt number (2 bytes)
  ·	FP flags (2 bytes)
  ·	FP mode (1 byte)
  ·	FP submode (1 byte)
  ·	FP port (1 byte)
  ·	FM firmware version (2 bytes)
  ·	FM firmware build (2 bytes)
  ·	FM firmware date (3 bytes) DD-MM-YY
  ·	Current date (3 bytes) DD-MM-YY
  ·	Current time (3 bytes) HH-MM-SS
  ·	FM flags (1 byte)
  ·	Serial number (4 bytes)
  ·	Number of last daily totals record in FM (2 bytes) 0000…2100
  ·	Quantity of free daily totals records left in FM (2 bytes)
  ·	Last fiscalization/refiscalization record number in FM (1 byte) 1…16
  ·	Quantity of free fiscalization/refiscalization records left in FM (1 byte) 0…15
  ·	Taxpayer ID (6 bytes)

******************************************************************************)

function TFiscalPrinterCommand.GetStatus: TPrinterStatus;
var
  Command: TGetEcrStatusCommand;
begin
  Logger.Debug('TFiscalPrinterCommand.GetStatus');

  Command := TGetEcrStatusCommand.Create;
  try
    Command.Password := UsrPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.Status;
  finally
    Command.Free;
  end;
end;

function TFiscalPrinterCommand.GetFMFlags(Flags: Byte): TFMFlags;
begin
  Result.FM1Present := TestBit(Flags, 0);
  Result.FM2Present := TestBit(Flags, 1);
  Result.LicenseEntered := TestBit(Flags, 2);
  Result.Overflow := TestBit(Flags, 3);
  Result.LowBattery := TestBit(Flags, 4);
  Result.LastRecordCorrupted := TestBit(Flags, 5);
  Result.DayOpened := TestBit(Flags, 6);
  Result.Is24HoursLeft := TestBit(Flags, 7);
end;

function TFiscalPrinterCommand.GetPrinterFlags(Flags: Word): TPrinterFlags;
begin
  Result.JrnNearEnd := not TestBit(Flags, 0);
  Result.RecNearEnd := not TestBit(Flags, 1);
  Result.SlpUpSensor := TestBit(Flags, 2);
  Result.SlpLoSensor := TestBit(Flags, 3);
  Result.DecimalPosition := TestBit(Flags, 4);
  Result.EJPresent := not TestBit(Flags, 5);
  Result.JrnEmpty := not TestBit(Flags, 6);
  Result.RecEmpty := not TestBit(Flags, 7);
  Result.JrnLeverUp := not TestBit(Flags, 8);
  Result.RecLeverUp := not TestBit(Flags, 9);
  Result.CoverOpened := TestBit(Flags, 10);
  Result.DrawerOpened := TestBit(Flags, 11);
  Result.Bit12 := TestBit(Flags, 12);
  Result.Bit13 := TestBit(Flags, 13);
  Result.EJNearEnd := TestBit(Flags, 14);
  Result.Bit15 := TestBit(Flags, 15);
end;

(******************************************************************************

  Печать жирной строки

  Команда:	12H. Длина сообщения: 26 байт.
  ·	Пароль оператора (4 байта)
  ·	Флаги (1 байт) Бит 0 - контрольная лента, Бит 1 - чековая лента.
  ·	Печатаемые символы (20 байт)
  Ответ:		12H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  Примечание: Печатаемые символы - символы в кодовой странице WIN1251.
  Символы с кодами 0…31 не отображаются.

******************************************************************************)

function TFiscalPrinterCommand.PrintBoldString(Flags: Byte; const Text: string): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.PrintBoldString(%d,''%s'')',
    [Flags, Text]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_PRINT_BOLD_LINE);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(Flags);
    Stream.WriteString(Text, PrintWidth div 2);

    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Гудок
  Команда:	13H. Длина сообщения: 5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		13H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.Beep: Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.Beep');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_BEEP);
    Stream.WriteDWORD(UsrPassword);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Установка параметров обмена
  Команда:	14H. Длина сообщения: 8 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Номер порта (1 байт) 0…255
  ·	Код скорости обмена (1 байт) 0…6
  ·	Тайм аут приема байта (1 байт) 0…255
  Ответ:		14H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.SetPortParams(Port: Byte;
  const PortParams: TPortParams);
var
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.SetPortParams(%d,%d,%d)',
    [Port, PortParams.BaudRate, PortParams.Timeout]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_SET_PORT_PARAMS);
    Stream.WriteDWORD(SysPassword);
    Stream.WriteByte(Port);
    Stream.WriteByte(BaudRateToCode(PortParams.BaudRate));
    Stream.WriteByte(TimeoutToByte(PortParams.Timeout));
    Check(ExecuteStream(Stream));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Чтение параметров обмена
  Команда:	15H. Длина сообщения: 6 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Номер порта (1 байт) 0…255
  Ответ:		15H. Длина сообщения: 4 байта.
  ·	Код ошибки (1 байт)
  ·	Код скорости обмена (1 байт) 0…6
  ·	Тайм аут приема байта (1 байт) 0…255

******************************************************************************)


function TFiscalPrinterCommand.GetPortParams(Port: Byte): TPortParams;
var
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.GetPortParams(%d)',  [Port]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_GET_PORT_PARAMS);
    Stream.WriteDWORD(SysPassword);
    Stream.WriteByte(Port);
    Check(ExecuteStream(Stream));
    Result.BaudRate := CodeToBaudRate(Stream.ReadByte);
    Result.Timeout := ByteToTimeout(Stream.ReadByte);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Технологическое обнуление
  Команда:	16H. Длина сообщения: 1 байт.
  Ответ:		16H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.ResetFiscalMemory;
begin
  Logger.Debug('TFiscalPrinterCommand.ResetFiscalMemory');
  Execute(Chr(COMMAND_RESETFM));
end;

(******************************************************************************

  Печать строки
  Команда:	17H. Длина сообщения: 46 байт.
  ·	Пароль оператора (4 байта)
  ·	Флаги (1 байт) Бит 0 - контрольная лента, Бит 1 - чековая лента.
  ·	Печатаемые символы (40 байт)
  Ответ:		17H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintString(Stations: Byte; const Text: string);
var
  Line: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.PrintString(%d,''%s'')',
    [Stations, Text]));

  Line := Text;
  if Line = '' then Line := ' ';
  Execute(#$17 + IntToBin(UsrPassword, 4) + Chr(Stations) + GetLine(Line));
end;

(******************************************************************************

  Печать заголовка документа
  Команда:	18H. Длина сообщения: 37 байт.
  ·	Пароль оператора (4 байта)
  ·	Наименование документа (30 байт)
  ·	Номер документа (2 байта)
  Ответ:		18H. Длина сообщения: 5 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  ·	Сквозной номер документа (2 байта)

******************************************************************************)

procedure TFiscalPrinterCommand.PrintDocHeader(const DocName: string; DocNumber: Word);
var
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.PrintDocHeader(''%s'', %d)',
    [DocName, DocNumber]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_PRINT_DOC_HEADER);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteString(DocName, 30);
    Stream.WriteInt(DocNumber, 2);

    Check(ExecuteStream(Stream));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Тестовый прогон
  Команда:	19H. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Период вывода в минутах (1 байт) 1…99
  Ответ:		19H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.StartTest(Interval: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.StartTest(%d)', [Interval]));

  Execute(#$19 + IntToBin(UsrPassword, 4) + Chr(Interval));
end;

(******************************************************************************

  Запрос денежного регистра
  Команда:	1AH. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Номер регистра (1 байт) 0… 255
  Ответ:		1AH. Длина сообщения: 9 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  ·	Содержимое регистра (6 байт)

******************************************************************************)

function TFiscalPrinterCommand.ReadCashTotalizer(ID: Byte): Int64;
var
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadCashTotalizer(%d)', [ID]));

  Stream := TBinStream.Create;
  try
    Stream.WriteByte(COMMAND_READ_CASH_TOTALIZER);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(ID);
    Check(ExecuteStream(Stream));

    Stream.ReadByte;                    // номер оператора
    Result := Stream.ReadInt(6);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Запрос операционного регистра
  Команда:	1BH. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Номер регистра (1 байт) 0… 255
  Ответ:		1BH. Длина сообщения: 5 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  ·	Содержимое регистра (2 байта)

******************************************************************************)

function TFiscalPrinterCommand.ReadActnTotalizer(ID: Byte): Word;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadActnTotalizer(%d)', [ID]));

  Data := Execute(#$1B + IntToBin(UsrPassword, 4) + Chr(ID));
  Result := BinToInt(Data, 2, 2);
end;


(******************************************************************************

  Запись лицензии
  Команда:	1CH. Длина сообщения: 10 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Лицензия (5 байт) 0000000000…9999999999
  Ответ:		1CH. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.WriteLicense(License: Int64);
var
  Command: TWriteLicenseCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.WriteLicense(%d)', [License]));

  Command := TWriteLicenseCommand.Create;
  try
    Command.SysPassword := SysPassword;
    Command.License := License;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Чтение лицензии
  Команда:	1DH. Длина сообщения: 5 байт.
  ·	Пароль системного администратора (4 байта)
  Ответ:		1DH. Длина сообщения: 7 байт.
  ·	Код ошибки (1 байт)
  ·	Лицензия (5 байт) 0000000000…9999999999

******************************************************************************)

function TFiscalPrinterCommand.ReadLicense: Int64;
var
  Command: TReadLicenseCommand;
begin
  Logger.Debug('TFiscalPrinterCommand.ReadLicense');

  Command := TReadLicenseCommand.Create;
  try
    Command.SysPassword := SysPassword;
    Check(ExecutePrinterCommand(Command));
    Result := Command.License;
  finally
    Command.Free;
  end;
end;

(******************************************************************************
******************************************************************************)

procedure TFiscalPrinterCommand.DoWriteTable(Table, Row, Field: Integer;
  const FieldValue: string);
var
  Command: TWriteTableCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.DoWriteTable(%d,%d,%d,%s)',
    [Table, Row, Field, FieldValue]));

  Command := TWriteTableCommand.Create;
  try
    Command.SysPassword := SysPassword;
    Command.Table := Table;
    Command.Row := Row;
    Command.Field := Field;
    Command.FieldValue := FieldValue;
    Check(ExecutePrinterCommand(Command));
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Чтение таблицы
  Команда:	1FH. Длина сообщения: 9 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Таблица (1 байт)
  ·	Ряд (2 байта)
  ·	Поле (1 байт)
  Ответ:		1FH. Длина сообщения: (2+X) байт.
  ·	Код ошибки (1 байт)
  ·	Значение (X байт) до 40 байт

******************************************************************************)

function TFiscalPrinterCommand.ReadTableBin(Table, Row,
  Field: Integer): string;
var
  Command: TReadTableCommand;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadTableBin(%d,%d,%d)',
    [Table, Row, Field]));

  Command := TReadTableCommand.Create;
  try
    Command.SysPassword := SysPassword;
    Command.Table := Table;
    Command.Row := Row;
    Command.Field := Field;
    Check(ExecutePrinterCommand(Command));
    Result := Command.FieldValue;
  finally
    Command.Free;
  end;
end;

(******************************************************************************

  Запись положения десятичной точки
  Команда:	20H. Длина сообщения: 6 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Положение десятичной точки (1 байт) "0"- 0 разряд, "1"- 2 разряд
  Ответ:		20H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)


******************************************************************************)

procedure TFiscalPrinterCommand.SetPointPosition(PointPosition: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.SetPointPosition(%d)',
    [PointPosition]));

  Execute(#$20 + IntToBin(SysPassword, 4) + Chr(PointPosition));
end;

(******************************************************************************

  Программирование времени
  Команда:	21H. Длина сообщения: 8 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Время (3 байта) ЧЧ-ММ-СС
  Ответ:		21H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.SetTime(const Time: TPrinterTime);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.SetTime(%s)',
    [PrinterTimeToStr(Time)]));

  Execute(#$21 + IntToBin(SysPassword, 4) +
    Chr(Time.Hour) + Chr(Time.Min) + Chr(Time.Sec));
end;

(******************************************************************************

  Программирование даты
  Команда:	22H. Длина сообщения: 8 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Дата (3 байта) ДД-ММ-ГГ
  Ответ:		22H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.SetDate(const Date: TPrinterDate);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.SetDate(%s)',
    [PrinterDateToStr(Date)]));

  Execute(#$22 + IntToBin(SysPassword, 4) +
    Chr(Date.Day) + Chr(Date.Month) + Chr(Date.Year));
end;

(******************************************************************************

  Подтверждение программирования даты
  Команда:	23H. Длина сообщения: 8 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Дата (3 байта) ДД-ММ-ГГ
  Ответ:		23H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.ConfirmDate(const Date: TPrinterDate);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ConfirmDate(%.2d.%.2d.%.4d)',
    [Date.Day, Date.Month, Date.Year + 2000]));

  Execute(#$23 + IntToBin(SysPassword, 4) +
    Chr(Date.Day) + Chr(Date.Month) + Chr(Date.Year));
end;

(******************************************************************************

  Инициализация таблиц начальными значениями
  Команда:	24H. Длина сообщения: 5 байт.
  ·	Пароль системного администратора (4 байта)
  Ответ:		24H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.InitializeTables;
begin
  Logger.Debug('TFiscalPrinterCommand.InitializeTables');
  Execute(#$24 + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Отрезка чека
  Команда:	25H. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Тип отрезки (1 байт) "0" - полная, "1" - неполная
  Ответ:		25H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.CutPaper(CutType: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.CutPaper(%d)', [CutType]));
  Execute(#$25 + IntToBin(UsrPassword, 4) + Chr(CutType));
end;

(******************************************************************************

  Прочитать параметры шрифта
  Команда:	26H. Длина сообщения: 6 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Номер шрифта (1 байт)
  Ответ:		26H. Длина сообщения: 7 байт.
  ·	Код ошибки (1 байт)
  ·	Ширина области печати в точках (2 байта)
  ·	Ширина символа с учетом межсимвольного интервала в точках (1 байт)
  ·	Высота символа с учетом межстрочного интервала в точках (1 байт)
  ·	Количество шрифтов в ФР (1 байт)

******************************************************************************)

function TFiscalPrinterCommand.ReadFontInfo(FontNumber: Byte): TFontInfo;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadFontInfo(%d)', [FontNumber]));

  Data := Execute(#$26 + IntToBin(SysPassword, 4) + Chr(FontNumber));
  //CheckMinLength(Data, Sizeof(Result)); { !!! }
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Общее гашение
  Команда:	27H. Длина сообщения: 5 байт.
  ·	Пароль системного администратора (4 байта)
  Ответ:		27H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.ResetTotalizers;
begin
  Logger.Debug('TFiscalPrinterCommand.ResetTotalizers');
  Execute(#$27 + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Открыть денежный ящик
  Команда:	28H. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Номер денежного ящика (1 байт) 0, 1
  Ответ:		28H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.OpenDrawer(DrawerNumber: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.OpenDrawer(%d)', [DrawerNumber]));
  Execute(#$28 + IntToBin(UsrPassword, 4) + Chr(DrawerNumber));
end;

(******************************************************************************

  Протяжка
  Команда:	29H. Длина сообщения: 7 байт.
  ·	Пароль оператора (4 байта)
  ·	Флаги (1 байт)
        Бит 0 - контрольная лента,
        Бит 1 - чековая лента,
        Бит 2 - подкладной документ.

  ·	Количество строк (1 байт) 1…255 - максимальное количество строк
        ограничивается размером буфера печати, но не превышает 255

  Ответ:		29H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.FeedPaper(Station: Byte; Lines: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.FeedPaper(%d,%d)',
    [Station, Lines]));

  Execute(#$29 + IntToBin(UsrPassword, 4) + Chr(Station) + Chr(Lines));
end;

(******************************************************************************

  Выброс подкладного документа
  Команда:	2AH. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Направление выброса подкладного документа (1 байт) "0" - вниз, "1" - вверх
  Ответ:		2AH. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.EjectSlip(Direction: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.EjectSlip(%d)',
    [Direction]));

  Execute(#$2A + IntToBin(UsrPassword, 4) + Chr(Direction));
end;

(******************************************************************************

  Прерывание тестового прогона
  Команда:	2BH. Длина сообщения: 5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		2BH. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.StopTest;
begin
  Logger.Debug('TFiscalPrinterCommand.StopTest');

  Execute(#$2B + IntToBin(UsrPassword, 4));
end;

(******************************************************************************

Снятие показаний операционных регистров
Команда:	2СH. Длина сообщения: 5 байт.
·	Пароль администратора или системного администратора (4 байта)
Ответ:		2СH. Длина сообщения: 3 байта.
·	Код ошибки (1 байт)
·	Порядковый номер оператора (1 байт) 29, 30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintActnTotalizers;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintActnTotalizers');

  Execute(#$2C + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Запрос структуры таблицы
  Команда:	2DH. Длина сообщения: 6 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Номер таблицы (1 байт)
  Ответ:		2DH. Длина сообщения: 45 байт.
  ·	Код ошибки (1 байт)
  ·	Название таблицы (40 байт)
  ·	Количество рядов (2 байта)
  ·	Количество полей (1 байт)

******************************************************************************)

function TFiscalPrinterCommand.ReadTableInfo(Table: Byte): TPrinterTableRec;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadTableInfo(%d)', [Table]));

  Data := Execute(#$2D + IntToBin(SysPassword, 4) + Chr(Table));
  CheckMinLength(Data, 43);
  Result.Number := Table;
  Result.Name := Copy(Data, 1, 40);
  Result.RowCount := BinToInt(Data, 41, 2);
  Result.FieldCount := BinToInt(Data, 43, 1);
end;

(******************************************************************************

  Запрос структуры поля
  Команда:	2EH. Длина сообщения: 7 байт.
  ·	Пароль системного администратора (4 байта)
  ·	Номер таблицы (1 байт)
  ·	Номер поля (1 байт)
  Ответ:		2EH. Длина сообщения: (44+X+X) байт.
  ·	Код ошибки (1 байт)
  ·	Название поля (40 байт)
  ·	Тип поля (1 байт) "0" - BIN, "1" - CHAR
  ·	Количество байт - X (1 байт)
  ·	Минимальное значение поля - для полей типа BIN (X байт)
  ·	Максимальное значение поля - для полей типа BIN (X байт)

******************************************************************************)

function TFiscalPrinterCommand.ReadFieldInfo(Table, Field: Byte): TPrinterFieldRec;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadFieldInfo(%d,%d)', [Table, Field]));

  Data := Execute(#$2E + IntToBin(SysPassword, 4) + Chr(Table) + Chr(Field));
  CheckMinLength(Data, 42);

  Result.Table := Table;
  Result.Field := Field;
  Result.Name := Copy(Data, 1, 40);
  Result.FieldType := Ord(Data[41]);
  Result.Size := Ord(Data[42]);
  if (Result.FieldType = 0)and(Length(Data) >= (42 + Result.Size*2)) then
  begin
    Result.MinValue := 0;
    Move(Data[43], Result.MinValue, Result.Size);
    Result.MaxValue := 0;
    Move(Data[43 + Result.Size], Result.MaxValue, Result.Size);
  end;
end;

(******************************************************************************

  Печать строки данным шрифтом
  Команда:	2FH. Длина сообщения: 47 байт.
  ·	Пароль оператора (4 байта)
  ·	Флаги (1 байт) Бит 0 - контрольная лента, Бит 1 - чековая лента.
  ·	Номер шрифта (1 байт) 0…255
  ·	Печатаемые символы (40 байт)
  Ответ:		2FH. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintStringFont(Station, Font: Byte;
  const Line: string);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.PrintStringFont(%d,%d)',
    [Station, Font]));

  Execute(#$2F + IntToBin(UsrPassword, 4) + Chr(Station) + Chr(Font) + GetLine(Line));
end;

(******************************************************************************

  Суточный отчет без гашения
  Команда:	40H. Длина сообщения: 5 байт.
  ·	Пароль администратора или системного администратора (4 байта)
  Ответ:		40H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 29, 30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintXReport;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintXReport');

  Execute(#$40 + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Суточный отчет с гашением
  Команда:	41H. Длина сообщения: 5 байт.
  ·	Пароль администратора или системного администратора (4 байта)
  Ответ:		41H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 29, 30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintZReport;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintZReport');
  Execute(#$41 + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Отчёт по секциям
  Команда:	42H. Длина сообщения: 5 байт.
  ·	Пароль администратора или системного администратора (4 байта)
  Ответ:		42H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 29, 30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintDepartmentsReport;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintDepartmentsReport');
  Execute(#$42 + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Отчёт по налогам
  Команда:	43H. Длина сообщения: 5 байт.
  ·	Пароль администратора или системного администратора (4 байта)
  Ответ:		43H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 29, 30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintTaxReport;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintTaxReport');
  Execute(#$43 + IntToBin(SysPassword, 4));
end;

(******************************************************************************

  Печать клише
  Команда:	52H. Длина сообщения: 5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		52H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintHeader;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintHeader');
  Execute(#$43 + IntToBin(UsrPassword, 4));
end;

(******************************************************************************

  Конец Документа
  Команда:	53H. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Параметр (1 байт)
  ·	0- без рекламного текста
  ·	1 - с рекламным тестом
  Ответ:		53H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintDocTrailer(Flags: Byte);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.PrintDocTrailer(%d)', [Flags]));
  Execute(#$53 + IntToBin(UsrPassword, 4) + Chr(Flags));
end;

(******************************************************************************

  Печать рекламного текста
  Команда:	54H. Длина сообщения:5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		54H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

procedure TFiscalPrinterCommand.PrintTrailer;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintTrailer');
  Execute(#$54 + IntToBin(UsrPassword, 4));
end;

(******************************************************************************

  Ввод заводского номера
  Команда:	60H. Длина сообщения: 9 байт.
  ·	Пароль (4 байта) (пароль "0")
  ·	Заводской номер (4 байта) 00000000…99999999
  Ответ:		60H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.WriteSerial(Serial: DWORD);
begin
  Logger.Debug(Format('TFiscalPrinterCommand.WriteSerial(%d)', [Serial]));
  Execute(#$60 + IntToBin(0, 4) + IntToBin(Serial, 4));
end;

(******************************************************************************

  Инициализация ФП
  Команда:	61H. Длина сообщения: 1 байт.
  Ответ:		61H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.InitFiscalMemory;
begin
  Logger.Debug('TFiscalPrinterCommand.InitFiscalMemory');
  Execute(#$61);
end;

(******************************************************************************

Запрос суммы записей в ФП
Команда:	62H. Длина сообщения: 6 байт.
·	Пароль администратора или системного администратора (4 байта)
·	Тип запроса (1 байт) "0" - сумма всех записей, "1" - сумма записей после последней перерегистрации
Ответ:		62H. Длина сообщения: 29 байт.
·	Код ошибки (1 байт)
·	Порядковый номер оператора (1 байт) 29, 30
·	Сумма сменных итогов продаж (8 байт)
·	Сумма сменных итог покупок (6 байт) При отсутствии ФП 2: FFh FFh FFh FFh FFh FFh
·	Сумма сменных возвратов продаж (6 байт) При отсутствии ФП 2: FFh FFh FFh FFh FFh FFh
·	Сумма сменных возвратов покупок (6 байт) При отсутствии ФП 2: FFh FFh FFh FFh FFh FFh

******************************************************************************)

function TFiscalPrinterCommand.ReadFMTotals(Flags: Byte): TFMTotals;
var
  Data: string;
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadFMTotals(%d)', [Flags]));

  Data := Execute(#$62 + IntToBin(SysPassword, 4) + Chr(Flags));
  CheckMinLength(Data, 27);

  Stream := TBinStream.Create;
  try
    Stream.Data := Data;
    Result.OperatorNumber := Stream.ReadByte;
    Result.SaleTotal := Stream.ReadInt(8);
    Result.BuyTotal := Stream.ReadInt(6);
    Result.RetSale := Stream.ReadInt(6);
    Result.RetBuy := Stream.ReadInt(6);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Запрос даты последней записи в ФП
  Команда:	63H. Длина сообщения: 5 байт.
  ·	Пароль налогового инспектора (4 байта)
  Ответ:		63H. Длина сообщения: 7 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 29, 30
  ·	Тип последней записи (1 байт) "0" - фискализация (перерегистрация), "1" - сменный итог
  ·	Дата (3 байта) ДД-ММ-ГГ

******************************************************************************)

function TFiscalPrinterCommand.ReadFMLastRecordDate: TFMRecordDate;
var
  Data: string;
begin
  Logger.Debug('TFiscalPrinterCommand.ReadFMLastRecordDate');

  Data := Execute(#$63 + IntToBin(TaxPassword, 4));
  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Запрос диапазона дат и смен
  Команда:	64H. Длина сообщения: 5 байт.
  ·	Пароль налогового инспектора (4 байта)
  Ответ:		64H. Длина сообщения: 12 байт.
  ·	Код ошибки (1 байт)
  ·	Дата первой смены (3 байта) ДД-ММ-ГГ
  ·	Дата последней смены (3 байта) ДД-ММ-ГГ
  ·	Номер первой смены (2 байта) 0000…2100
  ·	Номер последней смены (2 байта) 0000…2100

******************************************************************************)

function TFiscalPrinterCommand.ReadShiftsRange: TShiftRange;
var
  Data: string;
begin
  Logger.Debug('TFiscalPrinterCommand.ReadShiftsRange');

  Data := Execute(#$64 + IntToBin(TaxPassword, 4));
  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Фискализация (перерегистрация)
  Команда:	65H. Длина сообщения: 20 байт.
  ·	Пароль старый (4 байта)
  ·	Пароль новый (4 байта)
  ·	РНМ (5 байт) 0000000000…9999999999
  ·	ИНН (6 байт) 000000000000…999999999999
  Ответ:		65H. Длина сообщения: 9 байт.
  ·	Код ошибки (1 байт)
  ·	Номер фискализации (перерегистрации) (1 байт) 1…16
  ·	Количество оставшихся перерегистраций (1 байт) 0…15
  ·	Номер последней закрытой смены (2 байта) 0000…2100
  ·	Дата фискализации (перерегистрации) (3 байта) ДД-ММ-ГГ

******************************************************************************)

function TFiscalPrinterCommand.Fiscalization(Password, PrinterID,
  FiscalID: Int64): TFiscalizationResult;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.Fiscalization(%d,%d,%d)',
    [Password, PrinterID, FiscalID]));

  Data := Execute(#$65 +
    IntToBin(TaxPassword, 4) +
    IntToBin(Password, 4) +
    IntToBin(PrinterID, 4) +
    IntToBin(FiscalID, 4));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Фискальный отчет по диапазону дат

  Команда:	66H. Длина сообщения: 12 байт.
  ·	Пароль налогового инспектора (4 байта)
  ·	Тип отчета (1 байт) "0" - короткий, "1" - полный
  ·	Дата первой смены (3 байта) ДД-ММ-ГГ
  ·	Дата последней смены (3 байта) ДД-ММ-ГГ
  Ответ:		66H. Длина сообщения: 12 байт.
  ·	Код ошибки (1 байт)
  ·	Дата первой смены (3 байта) ДД-ММ-ГГ
  ·	Дата последней смены (3 байта) ДД-ММ-ГГ
  ·	Номер первой смены (2 байта) 0000…2100
  ·	Номер последней смены (2 байта) 0000…2100

******************************************************************************)

function TFiscalPrinterCommand.ReportOnDateRange(ReportType: Byte;
  Range: TShiftDateRange): TShiftRange;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReportOnDateRange(%d,%s,%s)',
    [ReportType, PrinterDateToStr(Range.Date1), PrinterDateToStr(Range.Date2)]));

  Data := Execute(#$66 +
    IntToBin(TaxPassword, 4) +
    Chr(ReportType) +
    PrinterDateToBin(Range.Date1) +
    PrinterDateToBin(Range.Date2));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Фискальный отчет по диапазону смен

  Команда:	67H. Длина сообщения: 10 байт.
  ·	Пароль налогового инспектора (4 байта)
  ·	Тип отчета (1 байт) "0" - короткий, "1" - полный
  ·	Номер первой смены (2 байта) 0000…2100
  ·	Номер последней смены (2 байта) 0000…2100
  Ответ:		67H. Длина сообщения: 12 байт.
  ·	Код ошибки (1 байт)
  ·	Дата первой смены (3 байта) ДД-ММ-ГГ
  ·	Дата последней смены (3 байта) ДД-ММ-ГГ
  ·	Номер первой смены (2 байта) 0000…2100
  ·	Номер последней смены (2 байта) 0000…2100

******************************************************************************)

function TFiscalPrinterCommand.ReportOnNumberRange(ReportType: Byte;
  Range: TShiftNumberRange): TShiftRange;
var
  Data: string;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReportOnDateRange(%d,%d,%d)',
    [ReportType, Range.Number1, Range.Number2]));

  Data := Execute(#$67 +
    IntToBin(TaxPassword, 4) +
    Chr(ReportType) +
    IntToBin(Range.Number1, 2) +
    IntToBin(Range.Number2, 2));

  CheckMinLength(Data, Sizeof(Result));
  Move(Data[1], Result, Sizeof(Result));
end;

(******************************************************************************

  Прерывание полного отчета
  Команда:	68H. Длина сообщения: 5 байт.
  ·	Пароль налогового инспектора (4 байта)
  Ответ:		68H. Длина сообщения: 2 байта.
  ·	Код ошибки (1 байт)

******************************************************************************)

procedure TFiscalPrinterCommand.InterruptReport;
begin
  Logger.Debug('TFiscalPrinterCommand.InterruptReport');

  Execute(#$68 + IntToBin(TaxPassword, 4));
end;

(******************************************************************************

Чтение параметров фискализации (перерегистрации)
Команда:	69H. Длина сообщения: 6 байт.
·	Пароль налогового инспектора, при котором была проведена данная фискализация (4 байта)
·	Номер фискализации (перерегистрации) (1 байт) 1…16
Ответ:		69H. Длина сообщения: 22 байта.
·	Код ошибки (1 байт)
·	Пароль (4 байта)
·	РНМ (5 байт) 0000000000…9999999999
·	ИНН (6 байт) 000000000000…999999999999
·	Номер смены перед фискализацией (перерегистрацией) (2 байта) 0000…2100
·	Дата фискализации (перерегистрации) (3 байта) ДД-ММ-ГГ

******************************************************************************)

function TFiscalPrinterCommand.ReadFiscInfo(FiscNumber: Byte): TFiscInfo;
var
  Stream: TBinStream;
begin
  Logger.Debug(Format('TFiscalPrinterCommand.ReadFiscInfo((%d)',
    [FiscNumber]));

  Stream := TBinStream.Create;
  try
    Stream.Data := Execute(#$69 + IntToBin(TaxPassword, 4) + Chr(FiscNumber));

    Result.Password := Stream.ReadInt(4);
    Result.PrinterID := Stream.ReadInt(5);
    Result.FiscalID := Stream.ReadInt(6);
    Result.ShiftNumber := Stream.ReadInt(2);
    Stream.Read(Result.Date, Sizeof(Result.Date));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Открыть фискальный подкладной документ
  Команда:	70H. Длина сообщения: 26 байт.
  ·	Пароль оператора (4 байта)
  ·	Тип документа (1 байт) "0" - продажа, "1" - покупка, "2" - возврат продажи, "3" - возврат покупки
  ·	Дублирование печати (извещение, квитанция) (1 байт) "0" - колонки, "1" - блоки строк
  ·	Количество дублей (1 байт) 0…5
  ·	Смещение между оригиналом и 1-ым дублем печати (1 байт) *
  ·	Смещение между 1-ым и 2-ым дублями печати (1 байт) *
  ·	Смещение между 2-ым и 3-им дублями печати (1 байт) *
  ·	Смещение между 3-им и 4-ым дублями печати (1 байт) *
  ·	Смещение между 4-ым и 5-ым дублями печати (1 байт) *
  ·	Номер шрифта клише (1 байт)
  ·	Номер шрифта заголовка документа (1 байт)
  ·	Номер шрифта номера ЭКЛЗ (1 байт)
  ·	Номер шрифта значения КПК и номера КПК (1 байт)
  ·	Номер строки клише (1 байт)
  ·	Номер строки заголовка документа (1 байт)
  ·	Номер строки номера ЭКЛЗ (1 байт)
  ·	Номер строки признака повтора документа (1 байт)
  ·	Смещение клише в строке (1 байт)
  ·	Смещение заголовка документа в строке (1 байт)
  ·	Смещение номера ЭКЛЗ в строке (1 байт)
  ·	Смещение КПК и номера КПК в строке (1 байт)
  ·	Смещение признака повтора документа в строке (1 байт)
  Ответ:		70H. Длина сообщения: 5 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  ·	Сквозной номер документа (2 байта)

******************************************************************************)

function TFiscalPrinterCommand.OpenSlipDoc(Params: TSlipParams): TDocResult;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.OpenSlipDoc');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($70);
    Stream.WriteDWORD(UsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

Открыть стандартный фискальный подкладной документ
Команда:	71H. Длина сообщения: 13 байт.
·	Пароль оператора (4 байта)
·	Тип документа (1 байт) "0" - продажа, "1" - покупка, "2" - возврат продажи, "3" - возврат покупки
·	Дублирование печати (извещение, квитанция) (1 байт) "0" - колонки, "1" - блоки строк
·	Количество дублей (1 байт) 0…5
·	Смещение между оригиналом и 1-ым дублем печати (1 байт) *
·	Смещение между 1-ым и 2-ым дублями печати (1 байт) *
·	Смещение между 2-ым и 3-им дублями печати (1 байт) *
·	Смещение между 3-им и 4-ым дублями печати (1 байт) *
·	Смещение между 4-ым и 5-ым дублями печати (1 байт) *
Ответ:		71H. Длина сообщения: 5 байт.
·	Код ошибки (1 байт)
·	Порядковый номер оператора (1 байт) 1…30
·	Сквозной номер документа (2 байта)

******************************************************************************)

function TFiscalPrinterCommand.OpenStdSlip(Params: TStdSlipParams): TDocResult;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.OpenStdSlip');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($71);
    Stream.WriteDWORD(UsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Check(ExecuteStream(Stream));
    Stream.Read(Result, Sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Формирование операции на подкладном документе
  Команда:	72H. Длина сообщения: 82 байта.
  ·	Пароль оператора (4 байта)
  ·	Формат целого количества (1 байт) "0" - без цифр после запятой, "1" - с цифрами после запятой
  ·	Количество строк в операции (1 байт) 1…3
  ·	Номер текстовой строки в операции (1 байт) 0…3, "0" - не печатать
  ·	Номер строки произведения количества на цену в операции (1 байт) 0…3, "0" - не печатать
  ·	Номер строки суммы в операции (1 байт) 1…3
  ·	Номер строки отдела в операции (1 байт) 1…3
  ·	Номер шрифта текстовой строки (1 байт)
  ·	Номер шрифта количества (1 байт)
  ·	Номер шрифта знака умножения количества на цену (1 байт)
  ·	Номер шрифта цены (1 байт)
  ·	Номер шрифта суммы (1 байт)
  ·	Номер шрифта отдела (1 байт)
  ·	Количество символов поля текстовой строки (1 байт)
  ·	Количество символов поля количества (1 байт)
  ·	Количество символов поля цены (1 байт)
  ·	Количество символов поля суммы (1 байт)
  ·	Количество символов поля отдела (1 байт)
  ·	Смещение поля текстовой строки в строке (1 байт)
  ·	Смещение поля произведения количества на цену в строке (1 байт)
  ·	Смещение поля суммы в строке (1 байт)
  ·	Смещение поля отдела в строке (1 байт)
  ·	Номер строки ПД с первой строкой блока операции (1 байт)
  ·	Количество (5 байт)
  ·	Цена (5 байт)
  ·	Отдел (1 байт) 0…16
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		72H. Длина сообщения: 3 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.SlipOperation(Params: TSlipOperation;
  Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.SlipOperation');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($72);
    Stream.WriteDWORD(UsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

Формирование стандартной операции на подкладном документе
Команда:	73H. Длина сообщения: 61 байт.
·	Пароль оператора (4 байта)
·	Номер строки ПД с первой строкой блока операции (1 байт)
·	Количество (5 байт)
·	Цена (5 байт)
·	Отдел (1 байт) 0…16
·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Текст (40 байт)
Ответ:		73H. Длина сообщения: 3 байта.
·	Код ошибки (1 байт)
·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.SlipStdOperation(LineNumber: Byte;
  Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.SlipStdOperation');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($73);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(LineNumber);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Формирование скидки/надбавки на подкладном документе
  Команда:	74H. Длина сообщения: 68 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество строк в операции (1 байт) 1…2
  ·	Номер текстовой строки в операции (1 байт) 0…2, "0" - не печатать
  ·	Номер строки названия операции в операции (1 байт) 1…2
  ·	Номер строки суммы в операции (1 байт) 1…2
  ·	Номер шрифта текстовой строки (1 байт)
  ·	Номер шрифта названия операции (1 байт)
  ·	Номер шрифта суммы (1 байт)
  ·	Количество символов поля текстовой строки (1 байт)
  ·	Количество символов поля суммы (1 байт)
  ·	Смещение поля текстовой строки в строке (1 байт)
  ·	Смещение поля названия операции в строке (1 байт)
  ·	Смещение поля суммы в строке (1 байт)
  ·	Тип операции (1 байт) "0" - скидка, "1" - надбавка
  ·	Номер строки ПД с первой строкой блока скидки/надбавки (1 байт)
  ·	Сумма (5 байт)
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		74H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.SlipDiscount(Params: TSlipDiscountParams;
  Discount: TSlipDiscount): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.SlipDiscount');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($74);
    Stream.WriteDWORD(UsrPassword);
    Stream.Write(Params, Sizeof(Params));
    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(Discount.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Формирование стандартной скидки/надбавки на подкладном документе
  Команда:	75H. Длина сообщения: 56 байт.
  ·	Пароль оператора (4 байта)
  ·	Тип операции (1 байт) "0" - скидка, "1" - надбавка
  ·	Номер строки ПД с первой строкой блока скидки/надбавки (1 байт)
  ·	Сумма (5 байт)
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		75H. Длина сообщения: 3 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.SlipStdDiscount(Discount: TSlipDiscount): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.SlipStdDiscount');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($75);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(Discount.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

Формирование закрытия чека на подкладном документе
Команда:	76H. Длина сообщения: 182 байта.
·	Пароль оператора (4 байта)
·	Количество строк в операции (1 байт) 1…17
·	Номер строки итога в операции (1 байт) 1…17
·	Номер текстовой строки в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки наличных в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки типа оплаты 2 в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки типа оплаты 3 в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки типа оплаты 4 в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки сдачи в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки оборота по налогу А в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки оборота по налогу Б в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки оборота по налогу В в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки оборота по налогу Г в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки суммы по налогу А в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки суммы по налогу Б в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки суммы по налогу В в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки суммы по налогу Г в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки суммы до начисления скидки в операции (1 байт) 0…17, "0" - не печатать
·	Номер строки суммы скидки в операции (1 байт) 0…17, "0" - не печатать
·	Номер шрифта текстовой строки (1 байт)
·	Номер шрифта "ИТОГ" (1 байт)
·	Номер шрифта суммы итога (1 байт)
·	Номер шрифта "НАЛИЧНЫМИ" (1 байт)
·	Номер шрифта суммы наличных (1 байт)
·	Номер шрифта названия типа оплаты 2 (1 байт)
·	Номер шрифта суммы типа оплаты 2 (1 байт)
·	Номер шрифта названия типа оплаты 3 (1 байт)
·	Номер шрифта суммы типа оплаты 3 (1 байт)
·	Номер шрифта названия типа оплаты 4 (1 байт)
·	Номер шрифта суммы типа оплаты 4 (1 байт)
·	Номер шрифта "СДАЧА" (1 байт)
·	Номер шрифта суммы сдачи (1 байт)
·	Номер шрифта названия налога А (1 байт)
·	Номер шрифта оборота налога А (1 байт)
·	Номер шрифта ставки налога А (1 байт)
·	Номер шрифта суммы налога А (1 байт)
·	Номер шрифта названия налога Б (1 байт)
·	Номер шрифта оборота налога Б (1 байт)
·	Номер шрифта ставки налога Б (1 байт)
·	Номер шрифта суммы налога Б (1 байт)
·	Номер шрифта названия налога В (1 байт)
·	Номер шрифта оборота налога В (1 байт)
·	Номер шрифта ставки налога В (1 байт)
·	Номер шрифта суммы налога В (1 байт)
·	Номер шрифта названия налога Г (1 байт)
·	Номер шрифта оборота налога Г (1 байт)
·	Номер шрифта ставки налога Г (1 байт)
·	Номер шрифта суммы налога Г (1 байт)
·	Номер шрифта "ВСЕГО" (1 байт)
·	Номер шрифта суммы до начисления скидки (1 байт)
·	Номер шрифта "СКИДКА ХХ.ХХ %" (1 байт)
·	Номер шрифта суммы скидки на чек (1 байт)
·	Количество символов поля текстовой строки (1 байт)
·	Количество символов поля суммы итога (1 байт)
·	Количество символов поля суммы наличных (1 байт)
·	Количество символов поля суммы типа оплаты 2 (1 байт)
·	Количество символов поля суммы типа оплаты 3 (1 байт)
·	Количество символов поля суммы типа оплаты 4 (1 байт)
·	Количество символов поля суммы сдачи (1 байт)
·	Количество символов поля названия налога А (1 байт)
·	Количество символов поля оборота налога А (1 байт)
·	Количество символов поля ставки налога А (1 байт)
·	Количество символов поля суммы налога А (1 байт)
·	Количество символов поля названия налога Б (1 байт)
·	Количество символов поля оборота налога Б (1 байт)
·	Количество символов поля ставки налога Б (1 байт)
·	Количество символов поля суммы налога Б (1 байт)
·	Количество символов поля названия налога В (1 байт)
·	Количество символов поля оборота налога В (1 байт)
·	Количество символов поля ставки налога В (1 байт)
·	Количество символов поля суммы налога В (1 байт)
·	Количество символов поля названия налога Г (1 байт)
·	Количество символов поля оборота налога Г (1 байт)
·	Количество символов поля ставки налога Г (1 байт)
·	Количество символов поля суммы налога Г (1 байт)
·	Количество символов поля суммы до начисления скидки (1 байт)
·	Количество символов поля процентной скидки на чек (1 байт)
·	Количество символов поля суммы скидки на чек (1 байт)
·	Смещение поля текстовой строки в строке (1 байт)
·	Смещение поля "ИТОГ" в строке (1 байт)
·	Смещение поля суммы итога в строке (1 байт)
·	Смещение поля "НАЛИЧНЫМИ" в строке (1 байт)
·	Смещение поля суммы наличных в строке (1 байт)
·	Смещение поля названия типа оплаты 2 в строке (1 байт)
·	Смещение поля суммы типа оплаты 2 в строке (1 байт)
·	Смещение поля названия типа оплаты 3 в строке (1 байт)
·	Смещение поля суммы типа оплаты 3 в строке (1 байт)
·	Смещение поля названия типа оплаты 4 в строке (1 байт)
·	Смещение поля суммы типа оплаты 4 в строке (1 байт)
·	Смещение поля "СДАЧА" в строке (1 байт)
·	Смещение поля суммы сдачи в строке (1 байт)
·	Смещение поля названия налога А в строке (1 байт)
·	Смещение поля оборота налога А в строке (1 байт)
·	Смещение поля ставки налога А в строке (1 байт)
·	Смещение поля суммы налога А в строке (1 байт)
·	Смещение поля названия налога Б в строке (1 байт)
·	Смещение поля оборота налога Б в строке (1 байт)
·	Смещение поля ставки налога Б в строке (1 байт)
·	Смещение поля суммы налога Б в строке (1 байт)
·	Смещение поля названия налога В в строке (1 байт)
·	Смещение поля оборота налога В в строке (1 байт)
·	Смещение поля ставки налога В в строке (1 байт)
·	Смещение поля суммы налога В в строке (1 байт)
·	Смещение поля названия налога Г в строке (1 байт)
·	Смещение поля оборота налога Г в строке (1 байт)
·	Смещение поля ставки налога Г в строке (1 байт)
·	Смещение поля суммы налога Г в строке (1 байт)
·	Смещение поля "ВСЕГО" в строке (1 байт)
·	Смещение поля суммы до начисления скидки в строке (1 байт)
·	Смещение поля "СКИДКА ХХ.ХХ %" в строке (1 байт)
·	Смещение поля суммы скидки в строке (1 байт)
·	Номер строки ПД с первой строкой блока операции (1 байт)
·	Сумма наличных (5 байт)
·	Сумма типа оплаты 2 (5 байт)
·	Сумма типа оплаты 3 (5 байт)
·	Сумма типа оплаты 4 (5 байт)
·	Скидка в % на чек от 0 до 99,99 % (2 байта) 0000…9999
·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Текст (40 байт)
Ответ:		76H. Длина сообщения: 8 байт.
·	Код ошибки (1 байт)
·	Порядковый номер оператора (1 байт) 1…30
·	Сдача (5 байт) 0000000000…9999999999

******************************************************************************)

function TFiscalPrinterCommand.SlipClose(Params: TCloseReceiptParams): TCloseReceiptResult;
begin
  Logger.Debug('TFiscalPrinterCommand.SlipClose');
(*
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($76);
    Stream.WriteDWORD(UsrPassword);
    Stream.Write(Params, sizeof(Params));

    Stream.WriteByte(Discount.OperationType);
    Stream.WriteByte(Discount.LineNumber);
    Stream.WriteInt(Discount.Amount, 5);
    Stream.WriteInt(Discount.Department, 1);
    Stream.WriteInt(Discount.Tax1, 1);
    Stream.WriteInt(Discount.Tax2, 1);
    Stream.WriteInt(Discount.Tax3, 1);
    Stream.WriteInt(Discount.Tax4, 1);
    Stream.WriteString(Discount.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
  *)
end;


(******************************************************************************

  Продажа
  Команда:	80H. Длина сообщения: 60 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество (5 байт) 0000000000…9999999999
  ·	Цена (5 байт) 0000000000…9999999999
  ·	Номер отдела (1 байт) 0…16
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		80H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.Sale(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin

  Logger.Debug('TFiscalPrinterCommand.Sale');
  Stream := TBinStream.Create;
  try
    Stream.WriteByte($80);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Покупка
  Команда:	81H. Длина сообщения: 60 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество (5 байт) 0000000000…9999999999
  ·	Цена (5 байт) 0000000000…9999999999
  ·	Номер отдела (1 байт) 0…16
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		81H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.Buy(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.Buy');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($81);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Возврат продажи
  Команда:	82H. Длина сообщения: 60 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество (5 байт) 0000000000…9999999999
  ·	Цена (5 байт) 0000000000…9999999999
  ·	Номер отдела (1 байт) 0…16
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		82H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.RetSale(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.RetSale');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($82);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Возврат покупки
  Команда:	83H. Длина сообщения: 60 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество (5 байт) 0000000000…9999999999
  ·	Цена (5 байт) 0000000000…9999999999
  ·	Номер отдела (1 байт) 0…16
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		83H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.RetBuy(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.RetBuy');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($83);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Сторно
  Команда:	84H. Длина сообщения: 60 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество (5 байт) 0000000000…9999999999
  ·	Цена (5 байт) 0000000000…9999999999
  ·	Номер отдела (1 байт) 0…16
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		84H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.Storno(Operation: TPriceReg): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.Storno');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($84);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Quantity, 5);
    Stream.WriteInt(Operation.Price, 5);
    Stream.WriteInt(Operation.Department, 1);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Закрытие чека
  Команда:	85H. Длина сообщения: 71 байт.
  ·	Пароль оператора (4 байта)
  ·	Сумма наличных (5 байт) 0000000000…9999999999
  ·	Сумма типа оплаты 2 (5 байт) 0000000000…9999999999
  ·	Сумма типа оплаты 3 (5 байт) 0000000000…9999999999
  ·	Сумма типа оплаты 4 (5 байт) 0000000000…9999999999
  ·	Скидка/Надбавка(в случае отрицательного значения) в % на чек от 0 до 99,99 % (2 байта со знаком) -9999…9999
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		85H. Длина сообщения: 8 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  ·	Сдача (5 байт) 0000000000…9999999999

******************************************************************************)

function TFiscalPrinterCommand.ReceiptClose(Params: TCloseReceiptParams): TCloseReceiptResult;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ReceiptClose');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($85);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Params.CashAmount, 5);
    Stream.WriteInt(Params.Amount2, 5);
    Stream.WriteInt(Params.Amount3, 5);
    Stream.WriteInt(Params.Amount4, 5);
    Stream.WriteInt(Params.PercentDiscount, 2);
    Stream.WriteInt(Params.Tax1, 1);
    Stream.WriteInt(Params.Tax2, 1);
    Stream.WriteInt(Params.Tax3, 1);
    Stream.WriteInt(Params.Tax4, 1);
    Stream.WriteString(Params.Text, PrintWidth);
    Check(ExecuteStream(Stream));
    Stream.Read(Result, sizeof(Result));
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Скидка
  Команда:	86H. Длина сообщения: 54 байт.
  ·	Пароль оператора (4 байта)
  ·	Сумма (5 байт) 0000000000…9999999999
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		86H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.ReceiptDiscount(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ReceiptDiscount');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($86);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Надбавка
  Команда:	87H. Длина сообщения: 54 байт.
  ·	Пароль оператора (4 байта)
  ·	Сумма (5 байт) 0000000000…9999999999
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		87H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.ReceiptCharge(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ReceiptCharge');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($87);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Аннулирование чека
  Команда:	88H. Длина сообщения: 5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		88H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.ReceiptCancel: Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ReceiptCancel');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($88);
    Stream.WriteDWORD(UsrPassword);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Подытог чека
  Команда:	89H. Длина сообщения: 5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		89H. Длина сообщения: 8 байт.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30
  ·	Подытог чека (5 байт) 0000000000…9999999999

******************************************************************************)

function TFiscalPrinterCommand.GetSubtotal: Int64;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.GetSubtotal');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($89);
    Stream.WriteDWORD(UsrPassword);
    Check(ExecuteStream(Stream));
    Stream.ReadByte;
    Result := Stream.ReadInt(5);
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

Сторно скидки
Команда:	8AH. Длина сообщения: 54 байта.
·	Пароль оператора (4 байта)
·	Сумма (5 байт) 0000000000…9999999999
·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
·	Текст (40 байт)
Ответ:		8AH. Длина сообщения: 3 байта.
·	Код ошибки (1 байт)
·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.ReceiptStornoDiscount(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ReceiptStornoDiscount');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8A);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Сторно надбавки
  Команда:	8BH. Длина сообщения: 54 байта.
  ·	Пароль оператора (4 байта)
  ·	Сумма (5 байт) 0000000000…9999999999
  ·	Налог 1 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 2 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 3 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Налог 4 (1 байт) "0" - нет, "1"…"4" - налоговая группа
  ·	Текст (40 байт)
  Ответ:		8BH. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.ReceiptStornoCharge(
  Operation: TAmountOperation): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ReceiptStornoCharge');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8B);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Operation.Amount, 5);
    Stream.WriteInt(Operation.Tax1, 1);
    Stream.WriteInt(Operation.Tax2, 1);
    Stream.WriteInt(Operation.Tax3, 1);
    Stream.WriteInt(Operation.Tax4, 1);
    Stream.WriteString(Operation.Text, PrintWidth);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Повтор документа
  Команда:	8CH. Длина сообщения: 5 байт.
  ·	Пароль оператора (4 байта)
  Ответ:		8CH. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.PrintReceiptCopy: Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintReceiptCopy');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8C);
    Stream.WriteDWORD(UsrPassword);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Открыть чек
  Команда:	8DH. Длина сообщения: 6 байт.
  ·	Пароль оператора (4 байта)
  ·	Тип документа (1 байт):  0 - продажа;
  1 - покупка;
  2 - возврат продажи;
  3 - возврат покупки
  Ответ:		8DH. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.OpenReceipt(ReceiptType: Byte): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.OpenReceipt');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($8D);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(ReceiptType);

    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Продолжение печати
  Команда:	B0H. Длина сообщения: 5 байт.
  ·	Пароль оператора, администратора или системного администратора (4 байта)
  Ответ:		B0H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.ContinuePrint: Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.ContinuePrint');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($B0);
    Stream.WriteDWORD(UsrPassword);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Загрузка графики
  Команда: 	C0H. Длина сообщения: 46 байт.
  ·	Пароль оператора (4 байта)
  ·	Номер линии (1 байт) 0…199
  ·	Графическая информация (40 байт)
  Ответ:		C0H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.LoadGraphics(Line: Byte; Data: string): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.LoadGraphics');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C0);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(Line);
    Stream.WriteString(Data, 40);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Печать графики
  Команда:	C1H. Длина сообщения: 7 байт.
  ·	Пароль оператора (4 байта)
  ·	Начальная линия (1 байт) 1…200
  ·	Конечная линия (1 байт) 1…200
  Ответ:		С1H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.PrintGraphics(Line1, Line2: Byte): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintGraphics');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C1);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteByte(Line1);
    Stream.WriteByte(Line2);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Печать штрих-кода
  Команда:	C2H. Длина сообщения: 10 байт.
  ·	Пароль оператора (4 байта)
  ·	Штрих-код (5 байт) 000000000000…999999999999
  Ответ:		С2H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.PrintBarcode(Barcode: Int64): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintBarcode');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C2);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Barcode, 5);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Печать расширенной графики
  Команда:	C3H. Длина сообщения: 9 байт.
  ·	Пароль оператора (4 байта)
  ·	Начальная линия (2 байта) 1…1200
  ·	Конечная линия (2 байта) 1…1200
  Ответ:		C3H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.PrintGraphics2(Line1, Line2: Word): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintGraphics2');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C3);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Line1, 2);
    Stream.WriteInt(Line2, 2);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Загрузка расширенной графики
  Команда: 	C4H. Длина сообщения: 47 байт.
  ·	Пароль оператора (4 байта)
  ·	Номер линии (2 байта) 0…1199
  ·	Графическая информация (40 байт)
  Ответ:		С4H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.LoadGraphics2(Line: Word; Data: string): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.LoadGraphics2');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C4);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Line, 2);
    Stream.WriteString(Data, 40);
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Печать линии
  Команда: 	C5H. Длина сообщения: X + 7 байт.
  ·	Пароль оператора (4 байта)
  ·	Количество повторов (2 байта)
  ·	Графическая информация (X байт)
  Ответ:		C5H. Длина сообщения: 3 байта.
  ·	Код ошибки (1 байт)
  ·	Порядковый номер оператора (1 байт) 1…30

******************************************************************************)

function TFiscalPrinterCommand.PrintBarLine(Height: Word; Data: string): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.PrintBarLine');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($C5);
    Stream.WriteDWORD(UsrPassword);
    Stream.WriteInt(Height, 2);
    Stream.WriteString(Data, Length(Data));
    Check(ExecuteStream(Stream));
    Result := Stream.ReadByte;
  finally
    Stream.Free;
  end;
end;

(******************************************************************************

  Получить тип устройства
  Команда:	FCH. Длина сообщения: 1 байт.
  Ответ:		FCH. Длина сообщения: (8+X) байт.
  ·	Код ошибки (1 байт)
  ·	Тип устройства (1 байт) 0…255
  ·	Подтип устройства (1 байт) 0…255
  ·	Версия протокола для данного устройства (1 байт) 0…255
  ·	Подверсия протокола для данного устройства (1 байт) 0…255
  ·	Модель устройства (1 байт) 0…255
  ·	Язык устройства (1 байт) 0…255 русский - 0; английский - 1;
  ·	Название устройства - строка символов в кодировке WIN1251.
  Количество байт, отводимое под название устройства, определяется в
  каждом конкретном случае самостоятельно разработчиками устройства (X байт)

******************************************************************************)

function TFiscalPrinterCommand.GetDeviceMetrics: TDeviceMetrics;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.GetDeviceMetrics');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($FC);
    Check(ExecuteStream(Stream));
    Result.DeviceType := Stream.ReadByte;
    Result.DeviceSubType := Stream.ReadByte;
    Result.ProtocolVersion := Stream.ReadByte;
    Result.ProtocolSubVersion := Stream.ReadByte;
    Result.Model := Stream.ReadByte;
    Result.Language := Stream.ReadByte;
    Result.DeviceName := Stream.ReadString;
  finally
    Stream.Free;
  end;
  FPrintWidth := GetModelDescription(Result.Model).PrintWidth;
end;

function TFiscalPrinterCommand.FieldToInt(FieldInfo: TPrinterFieldRec;
  const Value: string): Integer;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := BinToInt(Value, 1, FieldInfo.Size);
    PRINTER_FIELD_TYPE_STR: raise Exception.Create('Field type is not integer');
  else
    raise Exception.Create('Invalid field type');
  end;
end;

function TFiscalPrinterCommand.FieldToStr(FieldInfo: TPrinterFieldRec;
  const Value: string): string;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: raise Exception.Create('Field type is not string');
    PRINTER_FIELD_TYPE_STR: Result := Value;
  else
    raise Exception.Create('Invalid field type');
  end;
end;

function TFiscalPrinterCommand.GetFieldValue(FieldInfo: TPrinterFieldRec; const Value: string): string;
begin
  case FieldInfo.FieldType of
    PRINTER_FIELD_TYPE_INT: Result := IntToBin(StrToInt(Value), FieldInfo.Size);
    PRINTER_FIELD_TYPE_STR: Result := GetLineLength(Value, FieldInfo.Size);
  else
    raise Exception.Create('Invalid field type');
  end;
end;

procedure TFiscalPrinterCommand.WriteTable(Table, Row, Field: Integer;
  const FieldValue: string);
var
  Data: string;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := GetFieldValue(FieldInfo, FieldValue);
  DoWriteTable(Table, Row, Field, Data);
end;

procedure TFiscalPrinterCommand.WriteTableInt(Table, Row, Field, Value: Integer);
begin
  WriteTable(Table, Row, Field, IntToStr(Value));
end;

function TFiscalPrinterCommand.ReadTableInt(Table, Row, Field: Integer): Integer;
var
  Data: string;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := ReadTableBin(Table, Row, Field);
  Result := FieldToInt(FieldInfo, Data);
end;

function TFiscalPrinterCommand.ReadTableStr(Table, Row, Field: Integer): string;
var
  Data: string;
  FieldInfo: TPrinterFieldRec;
begin
  FieldInfo := ReadFieldStructure(Table, Field);
  Data := ReadTableBin(Table, Row, Field);
  Result := TrimRight(FieldToStr(FieldInfo, Data));
end;

(*******************************************************************************

  Чтение суммы скидок в смене

  185, Накопление скидок с продаж в смене
  186, Накопление скидок с покупок в смене
  187, Накопление скидок с возврата продаж в смене
  188, Накопление скидок с возврата покупок в смене

*******************************************************************************)

function TFiscalPrinterCommand.GetDayDiscountTotal: Int64;
begin
  Result :=
    ReadCashTotalizer(185) +
    ReadCashTotalizer(188) -
    ReadCashTotalizer(186) -
    ReadCashTotalizer(187);
end;

(*******************************************************************************

  Накопление скидок в чеке

  64, Накопление скидок с продаж в чеке
  65, Накопление скидок с покупок в чеке
  66, Накопление скидок с возврата продаж в чеке
  67, Накопление скидок с возврата покупок в чеке

*******************************************************************************)

function TFiscalPrinterCommand.GetRecDiscountTotal: Int64;
begin
  Result :=
    ReadCashTotalizer(64) +
    ReadCashTotalizer(67) -
    ReadCashTotalizer(65) -
    ReadCashTotalizer(66);
end;

(*******************************************************************************

  Накопление продаж в смене

    121, Накопление продаж в 1 отдел в смене
    125, Накопление продаж в 2 отдел в смене
    129, Накопление продаж в 3 отдел в смене
    133, Накопление продаж в 4 отдел в смене
    137, Накопление продаж в 5 отдел в смене
    141, Накопление продаж в 6 отдел в смене
    145, Накопление продаж в 7 отдел в смене
    149, Накопление продаж в 8 отдел в смене
    153, Накопление продаж в 9 отдел в смене
    157, Накопление продаж в 10 отдел в смене
    161, Накопление продаж в 11 отдел в смене
    165, Накопление продаж в 12 отдел в смене
    169, Накопление продаж в 13 отдел в смене
    173, Накопление продаж в 14 отдел в смене
    177, Накопление продаж в 15 отдел в смене
    181, Накопление продаж в 16 отдел в смене

*******************************************************************************)

function TFiscalPrinterCommand.GetDayItemTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashTotalizer(121 + 4*i);
end;

(*******************************************************************************

  Накопление продаж в чеке

    0, Накопление продаж в 1 отдел в чеке
    4, Накопление продаж в 2 отдел в чеке
    8, Накопление продаж в 3 отдел в чеке
    12, Накопление продаж в 4 отдел в чеке
    16, Накопление продаж в 5 отдел в чеке
    20, Накопление продаж в 6 отдел в чеке
    24, Накопление продаж в 7 отдел в чеке
    28, Накопление продаж в 8 отдел в чеке
    32, Накопление продаж в 9 отдел в чеке
    36, Накопление продаж в 10 отдел в чеке
    40, Накопление продаж в 11 отдел в чеке
    44, Накопление продаж в 12 отдел в чеке
    48, Накопление продаж в 13 отдел в чеке
    52, Накопление продаж в 14 отдел в чеке
    56, Накопление продаж в 15 отдел в чеке
    60, Накопление продаж в 16 отдел в чеке

*******************************************************************************)

function TFiscalPrinterCommand.GetRecItemTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashTotalizer(4*i);
end;

(*******************************************************************************

  Накопление возвратов продаж в смене

    123, Накопление возвратов продаж в 1 отдел в смене
    127, Накопление возвратов продаж в 2 отдел в смене
    131, Накопление возвратов продаж в 3 отдел в смене
    135, Накопление возвратов продаж в 4 отдел в смене
    139, Накопление возвратов продаж в 5 отдел в смене
    143, Накопление возвратов продаж в 6 отдел в смене
    147, Накопление возвратов продаж в 7 отдел в смене
    151, Накопление возвратов продаж в 8 отдел в смене
    155, Накопление возвратов продаж в 9 отдел в смене
    159, Накопление возвратов продаж в 10 отдел в смене
    163, Накопление возвратов продаж в 11 отдел в смене
    167, Накопление возвратов продаж в 12 отдел в смене
    171, Накопление возвратов продаж в 13 отдел в смене
    175, Накопление возвратов продаж в 14 отдел в смене
    179, Накопление возвратов продаж в 15 отдел в смене
    183, Накопление возвратов продаж в 16 отдел в смене

*******************************************************************************)

function TFiscalPrinterCommand.GetDayItemVoidTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashTotalizer(123 + 4*i);
end;

(*******************************************************************************

  Накопление возвратов продаж в чеке

    2, Накопление возвратов продаж в 1 отдел в чеке
    6, Накопление возвратов продаж в 2 отдел в чеке
    10, Накопление возвратов продаж в 3 отдел в чеке
    14, Накопление возвратов продаж в 4 отдел в чеке
    18, Накопление возвратов продаж в 5 отдел в чеке
    22, Накопление возвратов продаж в 6 отдел в чеке
    26, Накопление возвратов продаж в 7 отдел в чеке
    30, Накопление возвратов продаж в 8 отдел в чеке
    34, Накопление возвратов продаж в 9 отдел в чеке
    38, Накопление возвратов продаж в 10 отдел в чеке
    42, Накопление возвратов продаж в 11 отдел в чеке
    46, Накопление возвратов продаж в 12 отдел в чеке
    50, Накопление возвратов продаж в 13 отдел в чеке
    54, Накопление возвратов продаж в 14 отдел в чеке
    58, Накопление возвратов продаж в 15 отдел в чеке
    62, Накопление возвратов продаж в 16 отдел в чеке

*******************************************************************************)

function TFiscalPrinterCommand.GetRecItemVoidTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 15 do
    Result := Result + ReadCashTotalizer(2 + 4*i);
end;

(*******************************************************************************

  Запрос в ЭКЛЗ итогов смены по номеру смены
  Команда:	BAH. Длина сообщения: 7 байт.
  "	Пароль системного администратора (4 байта)
  "	Номер смены (2 байта) 0000…2100
  Ответ:		BAH. Длина сообщения: 18 байт.
  "	Код ошибки (1 байт)
  "	Тип ККМ - строка символов в кодировке WIN1251 (16 байт)
  Примечание: Время выполнения команды - до 40 секунд.

*******************************************************************************)

function TFiscalPrinterCommand.GetEJSesssionResult(Number: Word;
  var Text: string): Integer;
var
  Data: string;
begin
  Data := #$BA + IntToBin(SysPassword, 4) + IntToBin(Number, 2);
  Result := ExecuteData(Data, Text);
end;

(*******************************************************************************

  Запрос данных отчёта ЭКЛЗ
  Команда:	B3H. Длина сообщения: 5 байт.
  "	Пароль системного администратора (4 байта)
  Ответ:		B3H. Длина сообщения: (2+Х) байт.
  "	Код ошибки (1 байт)
  "	Строка или фрагмент отчета (см. спецификацию ЭКЛЗ) (X байт)

*******************************************************************************)

function TFiscalPrinterCommand.GetEJReportLine(var Line: string): Integer;
begin
  Result := ExecuteData(#$B3 + IntToBin(SysPassword, 4), Line);
end;

(*******************************************************************************

  Прекращение ЭКЛЗ
  Команда:	ACH. Длина сообщения: 5 байт.
  "	Пароль системного администратора (4 байта)
  Ответ:		ACH. Длина сообщения: 2 байта.
  "	Код ошибки (1 байт)

*******************************************************************************)

function TFiscalPrinterCommand.EJReportStop: Integer;
var
  RxData: string;
begin
  Result := ExecuteData(#$AC + IntToBin(SysPassword, 4), RxData);
end;

function TFiscalPrinterCommand.DecodeEJFlags(Flags: Byte): TEJFlags;
begin
  Result.DocType := Flags and $03;      // bits 0,1
  Result.ArcOpened := TestBit(Flags, 2);
  Result.Activated := TestBit(Flags, 3);
  Result.ReportMode := TestBit(Flags, 4);
  Result.DocOpened := TestBit(Flags, 5);
  Result.DayOpened := TestBit(Flags, 6);
  Result.ErrorFlag := TestBit(Flags, 7);
end;

(*******************************************************************************

  Запрос состояния по коду 1 ЭКЛЗ
  Команда:	ADH. Длина сообщения: 5 байт.
  "	Пароль системного администратора (4 байта)
  Ответ:		ADH. Длина сообщения: 22 байта.
  "	Код ошибки (1 байт)
  "	Итог документа последнего КПК (5 байт) 0000000000…9999999999
  "	Дата последнего КПК (3 байта) ДД-ММ-ГГ
  "	Время последнего КПК (2 байта) ЧЧ-ММ
  "	Номер последнего КПК (4 байта) 00000000…99999999
  "	Номер ЭКЛЗ (5 байт) 0000000000…9999999999
  "	Флаги ЭКЛЗ (см. описание ЭКЛЗ) (1 байт)

*******************************************************************************)

function TFiscalPrinterCommand.GetEJStatus1(var Status: TEJStatus1): Integer;
var
  Stream: TBinStream;
begin
  Logger.Debug('TFiscalPrinterCommand.GetLongSerial');

  Stream := TBinStream.Create;
  try
    Stream.WriteByte($AC);
    Stream.WriteDWORD(SysPassword);
    Result := ExecuteStream(Stream);
    if Result = 0 then
    begin
      Status.DocAmount := Stream.ReadInt(5);
      Stream.Read(Status.DocDate, sizeof(Status.DocDate));
      Stream.Read(Status.DocTime, sizeof(Status.DocTime));
      Stream.Read(Status.DocNumber, sizeof(Status.DocNumber));
      Status.EJNumber := Stream.ReadInt(5);
      Status.Flags := DecodeEJFlags(Stream.ReadByte);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TFiscalPrinterCommand.ClosePort;
begin
  Port.Close;
end;

procedure TFiscalPrinterCommand.OpenPort;
begin
  Port.Open;
end;

function TFiscalPrinterCommand.FormatLines(const Line1, Line2: string): string;
begin
  Result := FormatLineLength(Line1, PrintWidth - Length(Line2)) + Line2;
end;

function TFiscalPrinterCommand.FormatBoldLines(const Line1, Line2: string): string;
begin
  Result := FormatLineLength(Line1, (PrintWidth div 2) - Length(Line2)) + Line2;
end;

end.
