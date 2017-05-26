unit TCPServer;

interface

uses
  // VCL
  Windows, Messages, Forms, SConnect, SysUtils, ScktCnst, Classes, ComServ,
  // This
  dmuServer, LogFile;

type
  { TTCPServer }

  TTCPServer = class
  private
    FPort: Integer;
    FLogger: TLogFile;
    FEnabled: Boolean;
    FServer: TdmServer;

    procedure Start;
    procedure Close;
    function Stop: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function Update: Boolean;
    property Logger: TLogFile read FLogger;
    property Port: Integer read FPort write FPort;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

implementation

{ TTCPServer }

constructor TTCPServer.Create;
begin
  inherited Create;
  FLogger := TLogFile.Create;
  FServer := TdmServer.CreateServer(Logger);
end;

destructor TTCPServer.Destroy;
begin
  Close;
  FLogger.Free;
  FServer.Free;
  inherited Destroy;
end;

procedure TTCPServer.Close;
begin
  FServer.Stop;
end;

function TTCPServer.Update: Boolean;
begin
  Result := False;
  if (FServer = nil)or
    (Port <> FServer.TCPServer.DefaultPort) or
    (Enabled <> FServer.TCPServer.Active) then
  begin
    if not Stop then Exit;
  end;
  if Enabled then Start;
  Result := True;
end;

function TTCPServer.Stop: Boolean;
begin
  FServer.Stop;
  Result := True;
end;

procedure TTCPServer.Start;
begin
  Close;
  FServer.TCPServer.DefaultPort := FPort;
  FServer.TCPServer.Active := True;
end;

end.
