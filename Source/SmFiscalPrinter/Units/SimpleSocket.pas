unit SimpleSocket;

interface

uses
  // VCL
  WinSock, SysUtils,
  // This
  LogFile;

type
  { TSimpleSocket }

  TSimpleSocket = class
  private
    FSocket: TSocket;
  public
    constructor Create;
    destructor Destroy; override;

    function Accept: TSocket;
    function Listen(Backlog: Integer): Boolean;
    function WaitRead(Timeout: Integer): Integer;
    function WaitWrite(Timeout: Integer): Integer;
    function ReadLn(const Separator: string): string;

    procedure Close;
    procedure Disconnect;
    procedure Send(const Data: string);
    function Bind(Family: Integer; const IP: string; Port: Integer): Boolean;

    property Socket: TSocket read FSocket write FSocket;
  end;

implementation

procedure LogError(const Msg: string);
begin
  // Logger.Error(Msg); { !!! }
end;

{ TSimpleSocket }

constructor TSimpleSocket.Create;
begin
  inherited Create;
  FSocket := INVALID_SOCKET;
end;

destructor TSimpleSocket.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TSimpleSocket.Close;
begin
  if FSocket <> INVALID_SOCKET then
    CloseSocket(FSocket);
end;

function TSimpleSocket.Bind(Family: Integer; const IP: string; Port: Integer): Boolean;
var
  service: TSockAddrIn;
begin
  Result := True;
  service.sin_family := Family;
  service.sin_addr.s_addr := inet_addr(PChar(IP));
  service.sin_port := htons(Port);
  if WinSock.bind(FSocket, service, sizeof(service)) = SOCKET_ERROR then
  begin
    Result := False;
    LogError(Format('Bind failed with error: %d', [WSAGetLastError()]));
  end;
end;

function TSimpleSocket.Listen(Backlog: Integer): Boolean;
begin
  Result := True;
  if WinSock.Listen(FSocket, Backlog) = SOCKET_ERROR then
  begin
    Result := False;
    LogError(Format('Listen failed with error: %d', [WSAGetLastError()]));
  end;
end;

function TSimpleSocket.WaitRead(Timeout: Integer): Integer;
var
  tv: TTimeVal;
  ReadFds: TFDset;
begin
  FD_ZERO(ReadFds);
  FD_SET(FSocket, ReadFds);
  tv.tv_sec := Timeout div 1000;
  tv.tv_usec :=  1000 * (Timeout mod 1000);
  Result := WinSock.select(FSocket + 1, @ReadFds, nil, nil, @tv);
  if Result = SOCKET_ERROR then
    LogError(Format('Select failed with error: %d', [WSAGetLastError()]));
end;

function TSimpleSocket.WaitWrite(Timeout: Integer): Integer;
var
  tv: TTimeVal;
  WriteFds: TFDset;
begin
  FD_ZERO(WriteFds);
  FD_SET(FSocket, WriteFds);
  tv.tv_sec := Timeout div 1000;
  tv.tv_usec :=  1000 * (Timeout mod 1000);
  Result := WinSock.select(FSocket + 1, nil, @WriteFds, nil, @tv);
  if Result = SOCKET_ERROR then
    LogError(Format('Select failed with error: %d', [WSAGetLastError()]));
end;

function TSimpleSocket.accept: TSocket;
begin
  Result := WinSock.accept(FSocket, nil, nil);
  if Result = INVALID_SOCKET then
    LogError(Format('Accept failed with error: %d', [WSAGetLastError()]));
end;

procedure TSimpleSocket.Disconnect;
var
  Buf: array [byte] of char;
begin
  shutdown(FSocket, SD_SEND);
  while recv(FSocket, Buf[0], SizeOf(Buf), 0) > 0 do;
end;

function TSimpleSocket.ReadLn(const Separator: string): string;
var
  S: string;
  rc: Integer;
  Buf: array [byte] of char;
begin
  Result := '';
  repeat
    rc := WinSock.recv(FSocket, Buf[0], SizeOf(Buf), 0);
    if rc = SOCKET_ERROR then
    begin
      LogError(Format('Recv failed with error: %d', [WSAGetLastError()]));
      EXit;
    end;

    if rc > 0 then
    begin
      SetString(S, Buf, rc);
      Result := Result + S;
      if Pos(Separator, Result) <> 0 then Break;
    end;
  until rc <= 0;
end;

procedure TSimpleSocket.Send(const Data: string);
var
  rc: Integer;
  Buf: array [byte] of char;
begin
  Move(Data[1], Buf[0], Length(Data));
  rc := WinSock.Send(FSocket, Buf[0], Length(Data), 0);
  if rc = SOCKET_ERROR then
    LogError(Format('Send failed with error: %d', [WSAGetLastError()]));
end;

end.
