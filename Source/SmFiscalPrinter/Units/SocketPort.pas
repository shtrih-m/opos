unit SocketPort;

interface

uses
  // VCL
  Windows, Messages, Classes, MConnect, ComObj, SysUtils, Variants, WinSock, SyncObjs,
  // Indy
  IdTCPClient, IdGlobal, IdStack, IdWinsock2,
  // This
  PrinterPort, DriverError, StringUtils, FptrServerLib_TLB, VSysUtils,
  LogFile, CommunicationError, OposMessages;

type
  { TSocketPort }

  TSocketPort = class(TInterfacedObject, IPrinterPort)
  private
    FBaudRate: DWORD;
    FRemoteHost: string;
    FRemotePort: Integer;
    FByteTimeout: Integer;
    FLock: TCriticalsection;
    FConnection: TIdTCPClient;
    FLogger: ILogFile;

    property Logger: ILogFile read FLogger;
  public
    constructor Create(const ARemoteHost: string; ARemotePort: Integer;
      ALogger: ILogFile);
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
    procedure Purge;
    procedure Close;
    procedure Open;
    procedure Write(const Data: string);
    procedure SetCmdTimeout(Value: DWORD);
    function ReadChar(var C: Char): Boolean;
    function Read(Count: DWORD): string;
    function GetTimeout: DWORD;
    function GetBaudRate: DWORD;
    function GetPortName: string;
    procedure SetTimeout(Value: DWORD);
    procedure SetBaudRate(Value: DWORD);
  end;


implementation

var
  Ports: TInterfaceList = nil;

function GetSocketPort(const ARemoteHost: string; ARemotePort: Integer;
  ALogger: ILogFile): IPrinterPort;
var
  i: Integer;
begin
  Ports.Lock;
  try
    for i := 0 to Ports.Count-1 do
    begin
      Result := IPrinterPort(Ports[i]);
      if Result.PortName = ARemoteHost then
      begin
        Exit;
      end;
    end;
    Result := TSocketPort.Create(ARemoteHost, ARemotePort, ALogger);
    Ports.Add(Result);
  finally
    Ports.Unlock;
  end;
end;

{ TSocketPort }

constructor TSocketPort.Create(const ARemoteHost: string; ARemotePort: Integer;
  ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FRemoteHost := ARemoteHost;
  FRemotePort := ARemotePort;
  FConnection := TIdTCPClient.Create;
  FLock := TCriticalsection.Create;
end;

destructor TSocketPort.Destroy;
begin
  Close;
  FLock.Free;
  FConnection.Free;
  inherited Destroy;
end;

procedure TSocketPort.Open;
begin
  if not FConnection.Connected then
  begin
    FConnection.Host := FRemoteHost;
    FConnection.Port := FRemotePort;
    FConnection.ReuseSocket := rsTrue;
    FConnection.ReadTimeout := FByteTimeout;
    FConnection.ConnectTimeout := FByteTimeout;

    Logger.Debug('TSocketPort.Connect(' + FConnection.Host + ',' +
      IntToStr(FConnection.Port) + ')');

    FConnection.Connect();
  end;
end;

procedure TSocketPort.Close;
begin
  try
    FConnection.Disconnect;
    if (FConnection.IOHandler <> nil)and(FConnection.IOHandler.InputBuffer <> nil) then
    begin
      FConnection.IOHandler.InputBuffer.Clear;
    end;
    //FConnection.Free;
    //FConnection := TIdTCPClient.Create;
  except
    on E: Exception do
      Logger.Error(E.Message);
  end;
end;

procedure TSocketPort.Write(const Data: string);
var
  i: Integer;
  Buffer: TIdBytes;
begin
  try
    Open;
    SetLength(Buffer, Length(Data));
    for i := 1 to Length(Data) do
    begin
      Buffer[i-1] := Ord(Data[i]);
    end;
    FConnection.Socket.Write(Buffer);
  except
    on E: Exception do
    begin
      Close;
      raise;
    end;
  end;
end;

function TSocketPort.Read(Count: DWORD): string;
var
  C: Char;
  i: Integer;
begin
  Open;
  Result := '';
  try
    for i := 1 to Count do
    begin
      C := Chr(FConnection.Socket.ReadByte());
      Result := Result + C;
    end;
  except
    on E: Exception do
    begin
      Close;
      raise;
    end;
  end;
end;

function TSocketPort.ReadChar(var C: Char): Boolean;
begin
  Open;
  Result := True;
  try
    C := Chr(FConnection.Socket.ReadByte());
  except
    on E: Exception do
    begin
      Close;
      Result := False;
    end;
  end;
end;

procedure TSocketPort.SetCmdTimeout(Value: DWORD);
begin
  FConnection.ReadTimeout := Value;
end;

function TSocketPort.GetTimeout: DWORD;
begin
  Result := FByteTimeout;
end;

procedure TSocketPort.Lock;
begin
  FLock.Enter;
end;

procedure TSocketPort.Purge;
begin

end;

procedure TSocketPort.Unlock;
begin
  FLock.Leave;
end;

function TSocketPort.GetPortName: string;
begin
  Result := FRemoteHost;
end;

procedure TSocketPort.SetTimeout(Value: DWORD);
begin
  FByteTimeout := Value;
end;

procedure TSocketPort.SetBaudRate(Value: DWORD);
begin
  FBaudRate := Value;
end;

function TSocketPort.GetBaudRate: DWORD;
begin
  Result := FBaudRate;
end;

initialization
  Ports := TInterfaceList.Create;

finalization
  Ports.Free;
  Ports := nil;

end.
