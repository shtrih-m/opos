unit PrinterProtocol2;

interface

uses
  // VCL
  Windows, SysUtils,
  // This
  LogFile, StringUtils, DriverError, PrinterConnection, CommunicationError,
  PrinterPort, PrinterParameters, WException, gnugettext;

const
  MaxAnsCount = 3;
  MaxCmdCount = 3;
  SyncTimeout = 100;

type
  { TPrinterProtocol2 }

  TPrinterProtocol2 = class(TInterfacedObject, IPrinterConnection)
  private
    FOutput: string;
    FRawInput: string;
    FRawOutput: string;
    FFrameNumber: Integer;
    FLogger: ILogFile;
    FPort: IPrinterPort;
    FSynchronized: Boolean;
    FParams: TPrinterParameters;


    property Port: IPrinterPort read FPort;
    property Logger: ILogFile read FLogger;
    function DeStuffing(const AStr: string;
      var IsFinalEsc: Boolean): string;
    function Encode(const Data: string): string;
    procedure NoHardwareError;
    procedure Purge;
    function ReadAnswer: Integer;
    function ReadChar(var C: Char): Boolean;
    function ReadEscChar(var C: Char): Boolean;
    function ReadRaw(Count: DWORD; var Value: string): Boolean;
    function ReadSignature: Boolean;
    function ReadWord(var Value: Word): Boolean;
    procedure SendCommand(const Data: string);
    procedure SetCmdTimeout(Value: DWORD);
    procedure StepFrameNumber;
    function Stuffing(const AStr: string): string;
    procedure SynchronizeFrames;
    procedure Write(const Data: string);
  public
    constructor Create(ALogger: ILogFile; APort: IPrinterPort; AParams: TPrinterParameters);
    destructor Destroy; override;

    procedure Sync;
    // IPrinterConnection
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure CloseReceipt;
    procedure OpenReceipt(Password: Integer);
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function Send(Timeout: Integer; const Data: string): string;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

implementation

const
  STX  = #$8F;
  ESC  = #$9F;
  TSTX = #$81;
  TESC = #$83;

function UpdateCRC(CRC: Word; Value: Byte): Word;
begin
  Result := (CRC shr 8) or (CRC shl 8);
  Result := Result xor Value;
  Result := Result xor ((Result and $00FF) shr 4);
  Result := Result xor (Result shl 12);
  Result := Result xor ((Result and $00FF) shl 5);
end;

function GetCRC(const Data: string): Word;
var
  i: Integer;
begin
  Result := $FFFF;
  for i := 1 to Length(Data) do
    Result := UpdateCRC(Result, Ord(Data[i]));
end;

{ TPrinterProtocol2 }

constructor TPrinterProtocol2.Create(ALogger: ILogFile; APort: IPrinterPort;
  AParams: TPrinterParameters);
begin
  inherited Create;
  FPort := APort;
  FParams := AParams;
  FLogger := ALogger;
  FSynchronized := False;
end;

function TPrinterProtocol2.Stuffing(const AStr: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(AStr) do
  begin
    if AStr[i] = STX then
      Result := Result + ESC + TSTX
    else
      if AStr[i] = ESC then
        Result := Result + ESC + TESC
      else
        Result := Result + AStr[i];
  end;
end;

function TPrinterProtocol2.DeStuffing(const AStr: string; var IsFinalEsc: Boolean): string;
var
  i: Integer;
begin
  Result := '';
  IsFinalEsc := False;
  i := 1;
  while  i <= Length(AStr) do
  begin
    if AStr[i] = ESC then
    begin
      if i = Length(AStr) then
      begin
        IsFinalEsc := True;
        Exit;
      end;
      if AStr[i + 1] = TSTX then
      begin
        Result := Result + STX;
        Inc(i);
      end
      else
        if AStr[i + 1] = TESC then
        begin
          Result := Result + ESC;
          Inc(i);
        end
        else
          raiseException(_('Некорректный формат пакета'));
    end
    else
      Result := Result + AStr[i];
    Inc(i);  
  end;
end;

destructor TPrinterProtocol2.Destroy;
begin
  FPort := nil;
  FLogger := nil;
  inherited Destroy;
end;

procedure TPrinterProtocol2.Purge;
begin
  Port.Purge;
end;

procedure TPrinterProtocol2.SetCmdTimeout(Value: DWORD);
begin
  Port.SetCmdTimeout(Value);
end;

function TPrinterProtocol2.ReadChar(var C: Char): Boolean;
begin
  Result := Port.ReadChar(C);
  if not Result then Exit;
  FRawOutput := FRawOutput + C;
  Logger.WriteRxData(C);
  if (C = ESC) and Result then
  begin
    Result := ReadChar(C);
    FRawOutput := FRawOutput + C;
    Logger.WriteRxData(C);
    if C = TSTX then
      C := STX
    else
      if C = TESC then
        C := ESC
      else
        Result := False;
  end;
end;

function TPrinterProtocol2.ReadEscChar(var C: Char): Boolean;
begin
  Result := Port.ReadChar(C);
  Logger.WriteRxData(C);
  FRawOutput := FRawOutput + C;
  if C = TSTX then
    C := STX
  else
    if C = TESC then
      C := ESC
    else
      Result := False;
end;

function TPrinterProtocol2.ReadWord(var Value: Word): Boolean;
var
  C1: Char;
  C2: Char;
begin
  Result := ReadChar(C1);
  if not Result then Exit;
  Result := ReadChar(C2);
  Value := MakeWord(Ord(C1), Ord(C2));
end;

procedure TPrinterProtocol2.Write(const Data: string);
begin
  Logger.WriteTxData(Data);
  Port.Write(Data);
end;

function TPrinterProtocol2.ReadRaw(Count: DWORD; var Value: string): Boolean;
begin
  Result := True;
  Value := '';
  if Count = 0 then Exit;
  Value := Port.Read(Count);
  FRawOutput := FRawOutput + Value;
  Logger.WriteRxData(Value);
end;

{ Посылка команды }

procedure TPrinterProtocol2.SendCommand(const Data: string);
var
  Frame: string;
begin
  Frame := Encode(Data);
  FRawInput := Frame;
  Write(Frame);
end;

function TPrinterProtocol2.Send(Timeout: Integer; const Data: string): string;
var
  FNum: Integer;
  SyncErrCount: Integer;
  NoAnswerErrCount: Integer;
begin
  Result := '';
  SyncErrCount := 0;
  NoAnswerErrCount := 0;
  FNum := 0;
  while True do
  begin
    Purge;
    FRawInput := '';
    FRawOutput := '';
    SetCmdTimeout(Timeout);
    SynchronizeFrames;
    SendCommand(Data);
    try
      SetCmdTimeout(Timeout);
      FNum := ReadAnswer;
      Result := FOutput;
    except
      begin
        Inc(NoAnswerErrCount);
        if NoAnswerErrCount >= MaxAnsCount then
          NoHardwareError;
        Continue;
      end;
    end;
    if FNum <> FFrameNumber then
    begin
      Inc(SyncErrCount);
      FSynchronized := False;
      if SyncErrCount >= MaxCmdCount then
        NoHardwareError;
      Continue;
    end;
    StepFrameNumber;
    Break;
  end;
end;

procedure TPrinterProtocol2.NoHardwareError;
begin
  raise ECommunicationError.Create(_('No connection'));
end;

// Синхронизация номеров пакетов
procedure TPrinterProtocol2.SynchronizeFrames;
begin
  if FSynchronized then Exit;
  SendCommand('');
  FFrameNumber := ReadAnswer;
  FSynchronized := True;
  StepFrameNumber;
  if SyncTimeout <> 0 then
  begin
    Logger.Debug(Format('Sleep SyncTimeout %d ms', [SyncTimeout]));
    Sleep(SyncTimeout);
  end;
end;

function TPrinterProtocol2.ReadAnswer: Integer;
var
  C: Char;
  Len: Word;
  Num: Word;
  Data: string;
  Crc: Word;
  i: Integer;
  IsFinalEsc: Boolean;
begin
  FOutput := '';
  if not ReadSignature then
    NoHardwareError;
  if not ReadWord(Len) then
    NoHardwareError;
  if not ReadWord(Num) then
    NoHardwareError;
  Result := Num;
  Data := '';
  ReadRaw(Len - 2, Data);
  Data := DeStuffing(Data, IsFinalEsc);
  if IsFinalEsc then
  begin
    if not ReadEscChar(C) then
      NoHardwareError;
    Data := Data + C;
  end;
  if Length(Data) < (Len - 2) then
  begin
    for i := 1 to (Len - 2 - Length(Data)) do
    begin
      if not ReadChar(C) then
        NoHardwareError;
      Data := Data + C;
    end;
  end;
  FOutput := Data;
  if not ReadWord(CRC) then NoHardwareError;
  if CRC <> GetCRC(IntToBin(Len, 2) + IntToBin(Num, 2) + Data) then
    NoHardwareError;
end;

procedure TPrinterProtocol2.StepFrameNumber;
begin
  if FFrameNumber = $FFFF then
    FFrameNumber := 0
  else
    Inc(FFrameNumber)
end;

function TPrinterProtocol2.ReadSignature: Boolean;
var
  C: Char;
begin
  repeat
    Result := ReadChar(C);
    if not Result then Exit;
  until  C = STX;
end;

function TPrinterProtocol2.Encode(const Data: string): string;
var
  Len: Word;
  CRC: Word;
begin
  Result := '';
  Len := Length(Data);
  if Len = 0 then
    Result := #$00#$00
  else
    Result := IntToBin(Len + 2, 2) + IntToBin(FFrameNumber, 2) + Data;
  CRC := GetCRC(Result);
  Result := STX + Stuffing(Result + IntToBin(CRC, 2));
end;

procedure TPrinterProtocol2.Sync;
begin
  FSynchronized := False;
  SynchronizeFrames
end;

procedure TPrinterProtocol2.ClosePort;
begin
  Port.Close;
end;

procedure TPrinterProtocol2.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
begin
  Port.BaudRate := BaudRate;
  Port.Timeout := ByteTimeout;
  Port.Open;
end;

procedure TPrinterProtocol2.ClaimDevice(PortNumber, Timeout: Integer);
begin

end;

procedure TPrinterProtocol2.CloseReceipt;
begin

end;

procedure TPrinterProtocol2.OpenReceipt(Password: Integer);
begin

end;

procedure TPrinterProtocol2.ReleaseDevice;
begin

end;

end.
