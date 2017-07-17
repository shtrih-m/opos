unit LocalConnection;

interface

uses
  // VCL
  Windows, SysUtils, SyncObjs,
  // This
  ScaleTypes, ScaleFrame, SerialPort, LogFile, StringUtils,
  CommunicationError;

type
  { TLocalConnection }

  TLocalConnection = class(TInterfacedObject, IScaleConnection)
  private
    FOutput: string;                    // Received data
    FLogger: ILogFile;
    FPort: TSerialPort;
    FLock: TCriticalSection;

    procedure Lock;
    procedure Unlock;
    procedure Purge;
    procedure Write(const Data: string);
    procedure SetCmdTimeout(Value: DWORD);
    procedure AddData(const Data: string);
    procedure ReadAnswer(WaitNAK: Boolean);
    function ReadChar(var C: Char): Boolean;
    procedure SendCommand(const Data: string);
    function Read(Count: DWORD; var Value: string): Boolean;
    function ReadAnswerData(var CRCError: Boolean): Boolean;

    property Port: TSerialPort read FPort;
    property Logger: ILogFile read FLogger;
  public
    NakCount: Integer;          // Count of received NAK
    MaxCmdCount: Integer;       // Max command try to send count
    MaxAnsCount: Integer;       // Max answer try to read count
    MaxENQCount: Integer;       // Max ENQ request count

    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    // IScaleConnection
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function Send(Timeout: Integer; const Data: string): string;
    function SendCmd(Timeout: Integer; const Data: string): string;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

implementation

const
  STX = #2;
  ENQ = #5;
  ACK = #6;
  NAK = #21;

{ TLocalConnection }

{ Read answer on command }

constructor TLocalConnection.Create(ALogger: ILogFile);
begin
  inherited Create;
  FPort := TSerialPort.Create(ALogger);
  FLock := TCriticalSection.Create;
  MaxCmdCount := 3;
  MaxAnsCount := 3;
  MaxENQCount := 3;
end;

destructor TLocalConnection.Destroy;
begin
  FPort.Free;
  FLock.Free;
  inherited Destroy;
end;

procedure TLocalConnection.Lock;
begin
  FLock.Enter;
end;

procedure TLocalConnection.Unlock;
begin
  FLock.Leave;
end;

procedure TLocalConnection.AddData(const Data: string);
begin
  FOutput := FOutput + Data;
end;

procedure TLocalConnection.Purge;
begin
  Port.Purge;
end;

procedure TLocalConnection.SetCmdTimeout(Value: DWORD);
begin
  Port.SetCmdTimeout(Value);
end;

function TLocalConnection.ReadChar(var C: Char): Boolean;
begin
  Result := Port.ReadChar(C);
  if Result then
    Logger.Debug('<- ' + StrToHex(C))
  else
    Logger.Debug('<- ');
end;

procedure TLocalConnection.Write(const Data: string);
begin
  Logger.DebugData('-> ', Data);
  Port.Write(Data);
end;

function TLocalConnection.Read(Count: DWORD; var Value: string): Boolean;
begin
  Result := True;
  Value := Port.Read(Count);
  Logger.DebugData('<- ', Value);
end;

// flush data before change port baudrate
// fiscal printer changes baudrate after last ACK received
// if we not flush data, last ACK will not be transmitted

function TLocalConnection.ReadAnswerData(var CRCError: Boolean): Boolean;
var
  RxChar: Char;
  DataLen: Byte;
  RxData: string;
begin
  FOutput := '';
  Result := False;
  CRCError := False;
  { Receive STX - if not received then repeat request }
  if not ReadChar(RxChar) then Exit;
  AddData(RxChar);
  { If not STX then repeat request }
  if RxChar <> STX then Exit;
  { Receive length byte }
  if not ReadChar(RxChar) then Exit;
  AddData(RxChar);
  DataLen := Ord(RxChar);
  { Return timeout }
  SetCmdTimeout(port.Timeout);
  { Receive data }
  if not Read(DataLen + 1, RxData) then
  begin
    AddData(RxData);
    raise ECommunicationError.Create('Error reading answer');
  end;
  AddData(RxData);
  { Receive CRC of frame }
  RxChar := RxData[Length(RxData)];
  RxData := Copy(RxData, 1, Length(RxData)-1);

  if TScaleFrame.GetCRC(Chr(DataLen) + RxData) = Ord(RxChar) then
  begin
    { CRC is correct - send ACK}
    Write(ACK);
    Port.Flush;
    Result := True;
  end else
  begin
    { CRC is not correct - send NACK}
    Write(NAK);
    Port.Flush;
    CRCError := True;
  end;
end;

procedure TLocalConnection.ReadAnswer(WaitNAK: Boolean);
var
  RxChar: Char;
  ENQCount: Integer;
  AnsCount: Integer;
  CRCError: Boolean;
begin
  ENQCount := 1;
  AnsCount := 1;
  repeat
    Write(ENQ);
    if ReadChar(RxChar) then
    begin
      case RxChar of
        ACK:
        begin
          if ReadAnswerData(CRCError) then
          begin
            if not WaitNAK then Break;
          end else
          begin
            if not CRCError then
              raise ECommunicationError.Create('Error reading answer');
          end;
          Inc(AnsCount);
        end;
        NAK:
        begin
          Break;
        end;
      else
        Inc(ENQCount);
      end;
    end else
    begin
      Inc(ENQCount);
    end;

    if ENQCount > MaxENQCount then
      raise ECommunicationError.Create('Not connected, MaxENQCount');

    if AnsCount > MaxAnsCount then
      raise ECommunicationError.Create('Not connected, MaxAnsCount');
  until False;
end;

{ Send command }

procedure TLocalConnection.SendCommand(const Data: string);
var
  RxChar: char;
  CmdCount: Integer;
begin
  CmdCount := 1;
  repeat
    Write(Data);
    if not ReadChar(RxChar) then
      raise ECommunicationError.Create('Not connected');

    case RxChar of
      ACK : Break;
      NAK:
      begin
        Inc(CmdCount);
        Inc(NakCount);
      end;
    else
      raise ECommunicationError.Create('Not connected');
    end;

    if CmdCount > MaxCmdCount then
      raise ECommunicationError.Create('Not connected');

  until False;
end;

function TLocalConnection.SendCmd(Timeout: Integer; const Data: string): string;
var
  CRCError: Boolean;
begin
  try
    Port.Lock;
    try
      Logger.Debug(Logger.Separator);
      Purge;
      { 1. Read answer if it present}
      SetCmdTimeout(port.Timeout);
      ReadAnswer(True);
      { 2. Send command }
      SendCommand(Data);
      { 3. Read answer }
      SetCmdTimeout(Timeout);
      if not ReadAnswerData(CRCError) then
      begin
        if CRCError then ReadAnswer(False)
        else
        begin
          raise ECommunicationError.Create('Not connected');
        end;
      end;
      Result := FOutput;
      Logger.Debug(Logger.Separator);
    finally
      Port.Unlock;
    end;
  except
    on E: Exception do
      raise ECommunicationError.Create(E.Message);
  end;
end;

procedure TLocalConnection.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
begin
  Logger.Debug(Format('TLocalConnection.OpenPort(%d, %d, %d)', [PortNumber, BaudRate, ByteTimeout]));
  Port.PortNumber := PortNumber;
  Port.BaudRate := BaudRate;
  Port.Timeout := ByteTimeout;
  Port.Open;
end;

procedure TLocalConnection.ClosePort;
begin
  Logger.Debug('TLocalConnection.ClosePort');
  Port.Close;
end;

procedure TLocalConnection.ClaimDevice(PortNumber, Timeout: Integer);
begin
  Logger.Debug(Format('TLocalConnection.ClaimDevice(%d, %d)', [PortNumber, Timeout]));
  Port.PortNumber := PortNumber;
  Port.Open;
end;

procedure TLocalConnection.ReleaseDevice;
begin
  Logger.Debug('TLocalConnection.ReleaseDevice');
  Port.Close;
end;

function TLocalConnection.Send(Timeout: Integer;
  const Data: string): string;
var
  TxData: string;
  RxData: string;
begin
  Lock;
  try
    TxData := TScaleFrame.Encode(Data);
    RxData := SendCmd(Timeout, TxData);
    RxData := Copy(RxData, 3, Length(RxData)-3);

    if Length(RxData) < 1 then
      raise ECommunicationError.Create('Invalid answer length');

    Result := RxData;
  finally
    Unlock;
  end;
end;

end.
