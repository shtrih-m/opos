unit SocketConnection;

interface

uses
  // VCL
  Windows, Messages, Classes, MConnect, ComObj, SysUtils, Variants, WinSock, SyncObjs,
  // Indy
  IdTCPClient, IdGlobal, IdStack, IdWinsock2,
  // This
  PrinterProtocol, DriverError, StringUtils, FptrServerLib_TLB, VSysUtils,
  LogFile, CommunicationError, PrinterFrame, OposMessages;

type
  { TSocketConnection }

  TSocketConnection = class(TInterfacedObject, IPrinterProtocol)
  private
    FOutput: string;                    // Received data
    FRemoteHost: string;
    FRemotePort: Integer;
    FByteTimeout: Integer;
    FLock: TCriticalsection;
    FConnection: TIdTCPClient;
    FLogger: ILogFile;

    procedure Connect;
    procedure Disconnect;
    procedure ReadAnswer(WaitNAK: Boolean);
    function ReadChar(var C: Char): Boolean;
    function ReadControlChar(var C: Char): Boolean;
    function ReadAnswerData(var CRCError: Boolean): Boolean;
    procedure AddData(const Data: string);
    procedure SetCmdTimeout(Value: DWORD);
    function Read(Count: DWORD; var Value: string): Boolean;
    procedure SendCommand(const Data: string);
    procedure Write(const Data: string);

    property Logger: ILogFile read FLogger;
  public
    NakCount: Integer;          // Count of received NAK
    MaxCmdCount: Integer;       // Max command try to send count
    MaxAnsCount: Integer;       // Max answer try to read count
    MaxENQCount: Integer;       // Max ENQ request count

    constructor Create(const ARemoteHost: string; ARemotePort: Integer;
      ALogger: ILogFile);
    destructor Destroy; override;

    procedure ClosePort;
    procedure ReleaseDevice;
    procedure CloseReceipt;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure OpenReceipt(Password: Integer);
    function Send(Timeout: Integer; const Data: string): string;
    procedure OpenPort;
  end;

implementation

const
  STX = #2;
  ENQ = #5;
  ACK = #6;
  NAK = #21;

var
  Ports: TThreadList = nil;

procedure DeletePorts;
var
  List: TList;
begin
  List := Ports.LockList;
  try
    while List.Count > 0 do
    begin
      TIdTCPClient(List[0]).Free;
      List.Delete(0);
    end;
  finally
    Ports.UnlockList;
  end;
end;

function GetPortsCount: Integer;
var
  List: TList;
begin
  List := Ports.LockList;
  try
    Result := List.Count;
  finally
    Ports.UnlockList;
  end;
end;

function GetPort(const Host: string): TIdTCPClient;
var
  i: Integer;
  List: TList;
begin
  List := Ports.LockList;
  try
    for i := 0 to List.Count-1 do
    begin
      Result := TIdTCPClient(List[i]);
      if Result.Host = Host then
      begin
        Exit;
      end;
    end;
    Result := TIdTCPClient.Create();
    Result.Host := Host;
    Ports.Add(Result);
  finally
    Ports.UnlockList;
  end;
end;

{ TSocketConnection }

constructor TSocketConnection.Create(const ARemoteHost: string; ARemotePort: Integer;
  ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FRemoteHost := ARemoteHost;
  FRemotePort := ARemotePort;
  FConnection := GetPort(ARemoteHost);
  FLock := TCriticalsection.Create;
end;

destructor TSocketConnection.Destroy;
begin
  FLock.Free;
  Disconnect;
  inherited Destroy;
end;

procedure TSocketConnection.Connect;
begin
  if not FConnection.Connected then
  begin
    FConnection.Port := FRemotePort;
    FConnection.ReuseSocket := rsTrue;
    FConnection.ReadTimeout := FByteTimeout;
    FConnection.ConnectTimeout := FByteTimeout;

    Logger.Debug('TSocketConnection.Connect(' + FConnection.Host + ',' +
      IntToStr(FConnection.Port) + ')');

    FConnection.Connect();
  end;
end;

procedure TSocketConnection.Disconnect;
begin
  try
    FConnection.Disconnect;
    if FConnection.IOHandler <> nil then
      FConnection.IOHandler.InputBuffer.Clear;
  except
    on E: Exception do
      Logger.Error(GetExceptionMessage(E));
  end;
end;

procedure TSocketConnection.OpenPort;
begin
  //FByteTimeout := ByteTimeout; !!!
  Connect;
end;

procedure TSocketConnection.Write(const Data: string);
var
  i: Integer;
  Buffer: TIdBytes;
begin
  Logger.DebugData('-> ', Data);
  try
    Connect;
    SetLength(Buffer, Length(Data));
    for i := 1 to Length(Data) do
    begin
      Buffer[i-1] := Ord(Data[i]);
    end;
    FConnection.Socket.Write(Buffer);
  except
    on E: Exception do
    begin
      Disconnect;
      raise;
    end;
  end;
end;

function TSocketConnection.Read(Count: DWORD; var Value: string): Boolean;
var
  C: Char;
  i: Integer;
begin
  Result := True;
  try
    for i := 1 to Count do
    begin
      C := Chr(FConnection.Socket.ReadByte());
      Value := Value + C;
    end;
  except
    on E: Exception do
    begin
      Disconnect;
      Result := False;
      Logger.Debug('<- ');
    end;
  end;
  Logger.DebugData('<- ', Value);
end;

function TSocketConnection.ReadChar(var C: Char): Boolean;
begin
  Result := True;
  try
    C := Chr(FConnection.Socket.ReadByte());
    Logger.Debug('<- ' + StrToHex(C));
  except
    on E: Exception do
    begin
      Disconnect;
      Result := False;
      Logger.Debug('<- ');
    end;
  end;
end;

procedure TSocketConnection.AddData(const Data: string);
begin
  FOutput := FOutput + Data;
end;

procedure TSocketConnection.SetCmdTimeout(Value: DWORD);
begin
  FConnection.Socket.ReadTimeout := Value;
end;

function TSocketConnection.ReadAnswerData(var CRCError: Boolean): Boolean;
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
  SetCmdTimeout(FByteTimeout);
  { Receive data }
  if not Read(DataLen + 1, RxData) then
  begin
    AddData(RxData);
    raise ECommunicationError.Create(MsgErrorReadingAnswer);
  end;
  AddData(RxData);
  { Receive CRC of frame }
  RxChar := RxData[Length(RxData)];
  RxData := Copy(RxData, 1, Length(RxData)-1);

  if TPrinterFrame.GetCRC(Chr(DataLen) + RxData) = Ord(RxChar) then
  begin
    { CRC is correct - send ACK}
    Write(ACK);
    //Port.Flush; { !!! }
    Result := True;
  end else
  begin
    { CRC is not correct - send NACK}
    Write(NAK);
    //Port.Flush; { !!! }
    CRCError := True;
  end;
end;

procedure TSocketConnection.ReadAnswer(WaitNAK: Boolean);
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
              raise ECommunicationError.Create(MsgErrorReadingAnswer);
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
      raise ECommunicationError.Create('��� �����, MaxENQCount');

    if AnsCount > MaxAnsCount then
      raise ECommunicationError.Create('��� �����, MaxAnsCount');
  until False;
end;

function TSocketConnection.Send(Timeout: Integer; const Data: string): string;
var
  CRCError: Boolean;
begin
  try
    FLock.Enter;
    try
      Logger.Debug(Logger.Separator);
      { 1. Read answer if it present}
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
          raise ECommunicationError.Create('��� �����');
        end;
      end;
      Result := FOutput;
      Logger.Debug(Logger.Separator);
    finally
      FLock.Leave;
    end;
  except
    on E: Exception do
      raise ECommunicationError.Create(GetExceptionMessage(E));
  end;
end;

procedure TSocketConnection.ClosePort;
begin
  Disconnect;
end;

procedure TSocketConnection.OpenReceipt(Password: Integer);
begin
  { !!! }
end;

procedure TSocketConnection.CloseReceipt;
begin
  { !!! }
end;

procedure TSocketConnection.ClaimDevice(PortNumber, Timeout: Integer);
begin
  { !!! }
end;

procedure TSocketConnection.ReleaseDevice;
begin
  Disconnect;
end;

function TSocketConnection.ReadControlChar(var C: Char): Boolean;
begin
  Result := False;
  while True do
  begin
    Result := ReadChar(C);
    if not Result then Break;
    if C <> #$FF then Break;
  end;
end;

procedure TSocketConnection.SendCommand(const Data: string);
var
  RxChar: char;
  CmdCount: Integer;
begin
  CmdCount := 1;
  repeat
    Write(Data);
    if not ReadControlChar(RxChar) then
      raise ECommunicationError.Create('��� �����');

    case RxChar of
      ACK : Break;
      NAK:
      begin
        Inc(CmdCount);
        Inc(NakCount);
      end;
    else
      raise ECommunicationError.Create('��� �����');
    end;

    if CmdCount > MaxCmdCount then
      raise ECommunicationError.Create('��� �����');

  until False;
end;

initialization
  Ports := TThreadList.Create;

finalization
  DeletePorts;
  Ports.Free;
  Ports := nil;

end.
