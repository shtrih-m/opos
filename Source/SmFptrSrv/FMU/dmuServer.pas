unit dmuServer;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  // Tnt
  TntClasses,
  // Indy
  IdBaseComponent, IdComponent, IdTCPServer, IdCmdTCPServer,
  IdCustomTCPServer, IdCommandHandlers, IdContext,
  // This
  LogFile, VersionInfo, CommunicationError, DriverError, Session,
  StringUtils, SrvParams, oleMain;

type
  { TServer }

  TdmServer = class(TDataModule)
    TCPServer: TIdCmdTCPServer;
    procedure chOpenPortCommand(ASender: TIdCommand);
    procedure chClosePortCommand(ASender: TIdCommand);
    procedure chSendCommand(ASender: TIdCommand);
    procedure chClaimDeviceCommand(ASender: TIdCommand);
    procedure chReleaseDeviceCommand(ASender: TIdCommand);
    procedure TCPServerchCloseReceiptCommand(ASender: TIdCommand);
    procedure TCPServerchConnectCommand(ASender: TIdCommand);
    procedure TCPServerchOpenReceiptCommand(ASender: TIdCommand);
    procedure TCPServerConnect(AContext: TIdContext);
    procedure TCPServerDisconnect(AContext: TIdContext);
    procedure TCPServerCommandHandlers8Command(ASender: TIdCommand);
  private
    FLogger: ILogFile;
    procedure StartServer;
    procedure HandleException(E: Exception; ASender: TIdCommand);
    procedure SendSuccessReply(ASender: TIdCommand);
  public
    constructor CreateServer(ALogger: ILogFile);

    procedure Stop;
    procedure Start;
    function Started: Boolean;
    property Logger: ILogFile read FLogger;
  end;

var
  dmServer: TdmServer;

implementation

{$R *.DFM}

function GetCompName: string;
var
  Size: DWORD;
  LocalMachine: array [0..MAX_COMPUTERNAME_LENGTH] of char;
begin
  Size := Sizeof(LocalMachine);
  if GetComputerName(LocalMachine, Size) then
    Result := LocalMachine else Result := '';
end;

function GetParam(Params: TStrings; Index: Integer): string;
begin
  Result := '';
  if Index < Params.Count then
    Result := Params[Index];
end;

{ TServer }

constructor TdmServer.CreateServer(ALogger: ILogFile);
begin
  inherited Create(nil);
  FLogger := ALogger;
  StartServer;
  Logger.Debug('TServer.Create');
  Logger.Info('ServerVersion: ' + GetFileVersionInfoStr);
end;

procedure TdmServer.StartServer;
begin
  Logger.Debug('TServer.StartServer');
  try
    Start;
  except
    on E: Exception do
      Application.ShowException(E)
  end;
end;

procedure TdmServer.SendSuccessReply(ASender: TIdCommand);
begin
  ASender.Reply.SetReply(300, S_NOERROR);
  ASender.SendReply;
end;

procedure TdmServer.HandleException(E: Exception; ASender: TIdCommand);
var
  ResultCode: Integer;
  ResultText: string;
begin
  Logger.Error('Ошибка: ', E);
  if E is ECommunicationError then
  begin
    ResultCode := E_NOHARDWARE;
    ResultText := 'Нет связи';
  end else
  begin
    if E is EDriverError then
    begin
      ResultCode := EDriverError(E).ErrorCode;
      ResultText := E.Message;
    end else
    begin
      ResultCode := E_UNKNOWN;
      ResultText := E.Message;
    end;
  end;
  ASender.Reply.SetReply(ResultCode + 300, ResultText);
  ASender.SendReply;
end;

procedure TdmServer.chOpenPortCommand(ASender: TIdCommand);
var
  BaudRate: Integer;
  Timeout: Integer;
  Session: TSession;
begin
  Logger.Debug(ASender.RawLine);
  try
    BaudRate := StrToInt(GetParam(ASender.Params, 0));
    Timeout := StrToInt(GetParam(ASender.Params, 1));

    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.Check(Session.OpenPort(BaudRate, Timeout));
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.chClosePortCommand(ASender: TIdCommand);
var
  Session: TSession;
begin
  Logger.Debug(ASender. RawLine);
  try
    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.ClosePort;
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.chSendCommand(ASender: TIdCommand);
var
  TxData: string;
  Answer: string;
  Timeout: Integer;
  Session: TSession;
  ResultCode: Integer;
begin
  Logger.Debug(ASender. RawLine);
  try
    Timeout := StrToInt(GetParam(ASender.Params, 0));
    TxData := GetParam(ASender.Params, 1);

    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Answer := Session.SendData(Timeout, TxData, ResultCode);
      Session.Check(ResultCode);
    finally
      Sessions.Unlock;
    end;

    ASender.Reply.SetReply(300, Answer);
    ASender.SendReply;
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

function TdmServer.Started: Boolean;
begin
  Result := TCPServer.Active;
end;

procedure TdmServer.Stop;
begin
  TCPServer.Active := False;
  Sessions.Clear;
end;

procedure TdmServer.Start;
begin
  //Logger.FileName := ChangeFileExt(GetDllFileName, '.log'); { !!! }
  Logger.Enabled := True;
  TCPServer.DefaultPort := Params.TCPPort;
  TCPServer.Active := True;
end;

procedure TdmServer.chClaimDeviceCommand(ASender: TIdCommand);
var
  Timeout: Integer;
  PortNumber: Integer;
  Session: TSession;
begin
  Logger.Debug(ASender.RawLine);
  try
    PortNumber := StrToInt(GetParam(ASender.Params, 0));
    Timeout := StrToInt(GetParam(ASender.Params, 1));

    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.Check(Session.ClaimDevice(PortNumber, Timeout));
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.chReleaseDeviceCommand(ASender: TIdCommand);
var
  Session: TSession;
begin
  Logger.Debug(ASender.RawLine);
  try
    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.ReleaseDevice;
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.TCPServerchCloseReceiptCommand(ASender: TIdCommand);
var
  Session: TSession;
begin
  Logger.Debug(ASender. RawLine);
  try
    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.CloseReceipt;
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.TCPServerchConnectCommand(ASender: TIdCommand);
var
  AppPID: Integer;
  AppName: string;
  CompName: string;
  Session: TSession;
begin
  Logger.Debug(ASender.RawLine);
  try
    AppPID := StrToInt(GetParam(ASender.Params, 0));
    AppName := GetParam(ASender.Params, 1);
    CompName := GetParam(ASender.Params, 2);

    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.Check(Session.Connect(AppPID, AppName, CompName));
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.TCPServerchOpenReceiptCommand(ASender: TIdCommand);
var
  Password: Integer;
  Session: TSession;
begin
  Logger.Debug(ASender.RawLine);
  try
    Password := StrToInt(GetParam(ASender.Params, 0));

    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.Check(Session.OpenReceipt(Password));
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

procedure TdmServer.TCPServerConnect(AContext: TIdContext);
begin
  Logger.Debug('TdmServer.TCPServerConnect');
  try
    Sessions.Lock;
    try
      Sessions.Add(AContext.Connection);
    finally
      Sessions.Unlock;
    end;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TdmServer.TCPServerDisconnect(AContext: TIdContext);
begin
  Logger.Debug('TdmServer.TCPServerDisconnect');
  try
    Sessions.Lock;
    try
      Sessions.FindByConnection(AContext.Connection).Free;
    finally
      Sessions.Unlock;
    end;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TdmServer.TCPServerCommandHandlers8Command(ASender: TIdCommand);
var
  Session: TSession;
begin
  Logger.Debug(ASender.RawLine);
  try
    Sessions.Lock;
    try
      Session := Sessions.ItemByConnection(ASender.Context.Connection);
      Session.Check(Session.Disconnect);
    finally
      Sessions.Unlock;
    end;
    SendSuccessReply(ASender);
  except
    on E: Exception do
    begin
      HandleException(E, ASender);
    end;
  end;
end;

end.



