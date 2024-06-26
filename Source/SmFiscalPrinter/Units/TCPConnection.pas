unit TCPConnection;

interface

uses
  // VCL
  Windows, Messages, MConnect, ComObj, SysUtils, Variants,
  // Indy
  IdTCPClient,
  // This
  PrinterConnection, DriverError, StringUtils, FptrServerLib_TLB, VSysUtils,
  LogFile, TntSysUtils, WException;

type
  { TTCPConnection }

  TTCPConnection = class(TInterfacedObject, IPrinterConnection)
  private
    FLogger: ILogFile;
    FRemoteHost: AnsiString;
    FRemotePort: Integer;
    FConnection: TIdTCPClient;

    procedure Connect;
    function SendCommand(const Command: AnsiString): AnsiString;
    procedure DoConnect;
    procedure DoDisconnect;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(const ARemoteHost: AnsiString;
      ARemotePort: Integer; APortNumber, ABaudRate, AByteTimeout: Integer;
      ALogger: ILogFile);
    destructor Destroy; override;

    procedure ClosePort;
    procedure ReleaseDevice;
    procedure CloseReceipt;
    procedure ClaimDevice(PortNumber, Timeout: Integer);
    procedure OpenReceipt(Password: Integer);
    function Send(Timeout: Integer; const Data: AnsiString): AnsiString;
    procedure OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
  end;

implementation

{ TTCPConnection }

constructor TTCPConnection.Create(const ARemoteHost: AnsiString;
  ARemotePort: Integer; APortNumber, ABaudRate, AByteTimeout: Integer;
  ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
  FRemoteHost := ARemoteHost;
  FRemotePort := ARemotePort;
  FConnection := TIdTCPClient.Create(nil);
  FConnection.ReadTimeout := 5000;
end;

destructor TTCPConnection.Destroy;
begin
  DoDisconnect;
  FConnection.Free;
  inherited Destroy;
end;

procedure TTCPConnection.Connect;
begin
  if not FConnection.Connected then
  begin
    FConnection.Port := FRemotePort;
    FConnection.Host := FRemoteHost;
    FConnection.Connect;
    DoConnect;
  end;
end;

procedure TTCPConnection.DoConnect;
begin
  Logger.Debug('TTCPConnection.DoConnect');
  try
    SendCommand(Format('CONNECT %d %s %s', [
      GetCurrentProcessId, 'OposFiscalPrinter', GetCompName]));
  except
    on E: Exception do
      Logger.Error(GetExceptionMessage(E));
  end;
end;

procedure TTCPConnection.DoDisconnect;
begin
  Logger.Debug('TTCPConnection.DoDisconnect');
  try
    SendCommand('DISCONNECT');
  except
    on E: Exception do
      Logger.Error(GetExceptionMessage(E));
  end;
end;


function TTCPConnection.SendCommand(const Command: AnsiString): AnsiString;
var
  ResultText: AnsiString;
  ResultCode: Integer;
begin
  Connect;
  FConnection.SendCmd(Command);
  ResultCode := FConnection.LastCmdResult.NumericCode-300;
  if ResultCode <> 0 then
  begin
    ResultText := FConnection.LastCmdResult.Text.Text;
    RaiseError(ResultCode, ResultText);
  end;
  Result := TrimRight(FConnection.LastCmdResult.Text.Text);
end;

procedure TTCPConnection.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
var
  Command: AnsiString;
begin
  Command := Tnt_WideFormat('OPENPORT %d %d', [BaudRate, ByteTimeout]);
  SendCommand(Command);
end;

function TTCPConnection.Send(Timeout: Integer; const Data: AnsiString): AnsiString;
var
  Command: AnsiString;
begin
  Command := Tnt_WideFormat('SEND %d %s', [Timeout, StrToHexText(Data)]);
  Result := HexToStr(SendCommand(Command));
end;

procedure TTCPConnection.ClosePort;
begin
  SendCommand('CLOSEPORT');
end;

procedure TTCPConnection.OpenReceipt(Password: Integer);
begin
  SendCommand(Format('OPENRECEIPT %d', [Password]));
end;

procedure TTCPConnection.CloseReceipt;
begin
  SendCommand('CLOSERECEIPT');
end;

procedure TTCPConnection.ClaimDevice(PortNumber, Timeout: Integer);
begin
  SendCommand(Format('CLAIM %d %d', [PortNumber, Timeout]));
end;

procedure TTCPConnection.ReleaseDevice;
begin
  SendCommand('RELEASE');
end;

(*

  'OPENPORT %d %d %d', [PortNumber, BaudRate, ByteTimeout]);
  'CLOSEPORT'
  'CLAIM %d %d', [PortNumber, Timeout]));
  'RELEASE');
  'OPENRECEIPT %d', [Password]));
  'CLOSERECEIPT'
  'SEND %d %s', [Timeout, StrToHexText(Data)]);

*)

end.
