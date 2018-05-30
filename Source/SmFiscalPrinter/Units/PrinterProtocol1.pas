unit PrinterProtocol1;

interface

uses
  // VCL
  Windows, SysUtils,
  // This
  LogFile, StringUtils, DriverError, PrinterConnection,
  CommunicationError, PrinterPort, WException, gnugettext;

type
  { TPrinterProtocol1 }

  TPrinterProtocol1 = class(TInterfacedObject, IPrinterConnection)
  private
    FOutput: AnsiString;                    // Received data
    FLogger: ILogFile;
    FPort: IPrinterPort;

    procedure Purge;
    procedure Write(const Data: AnsiString);
    procedure SetCmdTimeout(Value: DWORD);
    procedure AddData(const Data: AnsiString);
    procedure ReadAnswer(WaitNAK: Boolean);
    function ReadChar(var C: Char): Boolean;
    procedure SendCommand(const Data: AnsiString);
    function Read(Count: DWORD; var Value: AnsiString): Boolean;
    function ReadAnswerData(var CRCError: Boolean): Boolean;
    function ReadControlChar(var C: Char): Boolean;

    property Port: IPrinterPort read FPort;
    property Logger: ILogFile read FLogger;
  public
    NakCount: Integer;          // Count of received NAK
    MaxCmdCount: Integer;       // Max command try to send count
    MaxAnsCount: Integer;       // Max answer try to read count
    MaxENQCount: Integer;       // Max ENQ request count

    constructor Create(ALogger: ILogFile; APort: IPrinterPort);
    destructor Destroy; override;

    // IPrinterConnection
    procedure ClosePort;
    procedure ReleaseDevice;
    procedure CloseReceipt;
    procedure OpenReceipt(Password: Integer);
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    function Send(Timeout: Integer; const Data: AnsiString): AnsiString;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

  { TPrinterFrame }

  TPrinterFrame = class
  public
    class function GetCRC(const Data: AnsiString): Byte;
    class function Encode(const Data: AnsiString): AnsiString;
  end;

implementation

const
  STX = #2;
  ENQ = #5;
  ACK = #6;
  NAK = #21;

{ TPrinterProtocol1 }

{ Read answer on command }

constructor TPrinterProtocol1.Create(ALogger: ILogFile; APort: IPrinterPort);
begin
  inherited Create;
  MaxCmdCount := 3;
  MaxAnsCount := 3;
  MaxENQCount := 3;
  FLogger := ALogger;
  FPort := APort;
end;

destructor TPrinterProtocol1.Destroy;
begin
  inherited Destroy;
end;

procedure TPrinterProtocol1.AddData(const Data: AnsiString);
begin
  FOutput := FOutput + Data;
end;

procedure TPrinterProtocol1.Purge;
begin
  Port.Purge;
end;

procedure TPrinterProtocol1.SetCmdTimeout(Value: DWORD);
begin
  Port.SetCmdTimeout(Value);
end;

function TPrinterProtocol1.ReadControlChar(var C: Char): Boolean;
begin
  Result := False;
  while True do
  begin
    Result := ReadChar(C);
    if not Result then Break;
    if C <> #$FF then Break;
  end;
end;

function TPrinterProtocol1.ReadChar(var C: Char): Boolean;
begin
  Result := Port.ReadChar(C);
  if Result then
    Logger.Debug('<- ' + StrToHex(C))
  else
    Logger.Debug('<- ');
end;

procedure TPrinterProtocol1.Write(const Data: AnsiString);
begin
  Logger.WriteTxData(Data);
  Port.Write(Data);
end;

function TPrinterProtocol1.Read(Count: DWORD; var Value: AnsiString): Boolean;
begin
  Result := True;
  Value := Port.Read(Count);
  Logger.WriteRxData(Value);
end;

// flush data before change port baudrate
// fiscal printer changes baudrate after last ACK received
// if we not flush data, last ACK will not be transmitted

function TPrinterProtocol1.ReadAnswerData(var CRCError: Boolean): Boolean;
var
  RxChar: Char;
  DataLen: Byte;
  RxData: AnsiString;
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
    raise ECommunicationError.Create(_('Error reading answer'));
  end;
  AddData(RxData);
  { Receive CRC of frame }
  RxChar := RxData[Length(RxData)];
  RxData := Copy(RxData, 1, Length(RxData)-1);

  if TPrinterFrame.GetCRC(Chr(DataLen) + RxData) = Ord(RxChar) then
  begin
    { CRC is correct - send ACK}
    Write(ACK);
    Result := True;
  end else
  begin
    { CRC is not correct - send NACK}
    Write(NAK);
    CRCError := True;
  end;
end;

procedure TPrinterProtocol1.ReadAnswer(WaitNAK: Boolean);
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
    if ReadControlChar(RxChar) then
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
              raise ECommunicationError.Create(_('Error reading answer'));
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
      raise ECommunicationError.Create(_('No connection') + ', MaxENQCount');

    if AnsCount > MaxAnsCount then
      raise ECommunicationError.Create(_('No connection') + ', MaxAnsCount');
  until False;
end;

{ Send command }

procedure TPrinterProtocol1.SendCommand(const Data: AnsiString);
var
  RxChar: char;
  CmdCount: Integer;
begin
  CmdCount := 1;
  repeat
    Write(Data);
    if not ReadControlChar(RxChar) then
      raise ECommunicationError.Create(_('No connection'));

    case RxChar of
      ACK : Break;
      NAK:
      begin
        Inc(CmdCount);
        Inc(NakCount);
      end;
    else
      raise ECommunicationError.Create(_('No connection'));
    end;

    if CmdCount > MaxCmdCount then
      raise ECommunicationError.Create(_('No connection'));

  until False;
end;

function TPrinterProtocol1.Send(Timeout: Integer; const Data: AnsiString): AnsiString;
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
      SendCommand(TPrinterFrame.Encode(Data));
      { 3. Read answer }
      SetCmdTimeout(Timeout);
      if not ReadAnswerData(CRCError) then
      begin
        if CRCError then ReadAnswer(False)
        else
        begin
          raise ECommunicationError.Create(_('No connection'));
        end;
      end;
      Result := Copy(FOutput, 3, Length(FOutput)-3);
      Logger.Debug(Logger.Separator);
    finally
      Port.Unlock;
    end;
  except
    on E: Exception do
      raise ECommunicationError.Create(GetExceptionMessage(E));
  end;
end;

procedure TPrinterProtocol1.ClosePort;
begin
  Port.Close;
end;

procedure TPrinterProtocol1.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
begin
  Port.BaudRate := BaudRate;
  Port.Timeout := ByteTimeout;
  Port.Open;
end;

procedure TPrinterProtocol1.ClaimDevice(PortNumber, Timeout: Integer);
begin
  { !!! }
end;

procedure TPrinterProtocol1.ReleaseDevice;
begin
  Port.Close;
end;

procedure TPrinterProtocol1.CloseReceipt;
begin
  { !!! }
end;

procedure TPrinterProtocol1.OpenReceipt(Password: Integer);
begin
  { !!! }
end;

{ TPrinterFrame }

class function TPrinterFrame.Encode(const Data: AnsiString): AnsiString;
const
  STX = #2;
var
  DataLen: Integer;
begin
  DataLen := Length(Data);
  Result := Chr(DataLen) + Data;
  Result := STX + Result + Chr(GetCRC(Result));
end;

class function TPrinterFrame.GetCRC(const Data: AnsiString): Byte;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Data) do
    Result := Result xor Ord(Data[i]);
end;

end.
