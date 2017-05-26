unit oleMain;

interface

uses
  // VCL
  Windows, ComObj, Classes, ComServ, ActiveX, SysUtils, StdVcl, SyncObjs,
  // Opos
  Opos, OposException,
  // This
  FptrServerLib_TLB, VersionInfo, PortConnection, DcomUtils,
  OposSemaphore, DriverError, StringUtils, DcomFactory, LogFile;

const
  E_NOERROR           =  0;   // no errors
  E_NOHARDWARE        = -1;   // no hardware
  E_NOPORT            = -2;   // invalid serial port
  E_PORTBUSY          = -3;   // access denied to serial port
  E_ANSWERLENGTH      = -7;   // invalid answer length
  E_UNKNOWN           = -8;   // unknown error
  E_PORTLOCKED        = -18;  // port is locked

resourcestring
  S_NOERROR           = 'No errors';
  S_NOHARDWARE        = 'No hardware';
  S_NOPORT            = 'Serial port is unavailable';
  S_PORTBUSY          = 'Access denied to serial port';
  S_PORTLOCKED        = 'Port is locked';

type
  TClients = class;
  TClientsLink = class;

  { TFptrServer }

  TFptrServer = class(TAutoObject, IFptrServer)
  private
    FLogger: TLogFile;
    FClientInfo: TClientInfo;
    FResultCode: Integer;
    FPortLink: TPortLink;
    FPortsLink: TPortsLink;
    FClientsLink: TClientsLink;
    FResultDescription: string;
    FSemaphore: TOposSemaphore;
    FPortNumber: Integer;
    FConnected: Boolean;

    function GetPort: TPort;
    function GetClients: TClients;
    function ClearResult: Integer;
    function HandleException(E: Exception): Integer;

    property Port: TPort read GetPort;
    property Logger: TLogFile read FLogger;
  public
    function OpenPort(BaudRate, Timeout: Integer): Integer; safecall;
    function ClosePort: Integer; safecall;
    function SendData(Timeout: Integer; const TxDataHex: WideString;
      out ResultCode: Integer): WideString; safecall;
    function  Get_FileVersion: WideString; safecall;
    function Get_ResultDescription: WideString; safecall;
    function CloseReceipt: Integer; safecall;
    function OpenReceipt(Password: Integer): Integer; safecall;
    function Connect(AAppPID: Integer; const AAppName,
      ACompName: WideString): Integer; safecall;
    function Get_ResultCode: Integer; safecall;
    function ClaimDevice(APortNumber, ATimeout: Integer): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function Get_ClientAppName: WideString; safecall;
    function Get_ClientCompName: WideString; safecall;
    function Get_ClientPID: Integer; safecall;
    function Get_Connected: WordBool; safecall;
    function Disconnect: Integer; safecall;
    function Get_IsReceiptOpened: WordBool; safecall;
    function Get_IsClaimed: WordBool; safecall;
    function Get_IsPortOpened: WordBool; safecall;

    property Clients: TClients read GetClients;
  public
    destructor Destroy; override;
    function Index: Integer;

    procedure Initialize; override;

    property ID: Integer read FClientInfo.ID;
    property PID: DWORD read FClientInfo.PID;
    property PortNumber: Integer read FPortNumber;
    property AppName: string read FClientInfo.AppName;
    property CompName: string read FClientInfo.CompName;
    property ClientAppName: WideString read Get_ClientAppName;
    property ClientCompName: WideString read Get_ClientCompName;
    property ClientPID: Integer read Get_ClientPID;
    property Connected: WordBool read Get_Connected;
    property FileVersion: WideString read Get_FileVersion;
    property IsClaimed: WordBool read Get_IsClaimed;
    property IsPortOpened: WordBool read Get_IsPortOpened;
    property IsReceiptOpened: WordBool read Get_IsReceiptOpened;
    property ResultCode: Integer read Get_ResultCode;
    property ResultDescription: WideString read Get_ResultDescription;
  end;

  { TClients }

  TClients = class
  private
    FList: TList;
    FLinks: TList;
    FCS: TCriticalSection;
    function GetCount: Integer;
    function GetItem(Index: Integer): TFptrServer;
    procedure Insert(AItem: TFptrServer);
    procedure Remove(AItem: TFptrServer);
    procedure InsertLink(AItem: TClientsLink);
    procedure RemoveLink(AItem: TClientsLink);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
    function ItemByID(ID: Integer): TFptrServer;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TFptrServer read GetItem; default;
  end;

  { TClientsLink }

  TClientsLink = class
  private
    FOwner: TClients;
    procedure SetOwner(AOwner: TClients);
  public
    constructor Create;
    destructor Destroy; override;
    property Clients: TClients read FOwner;
  end;

procedure ReleasePortByNumber(PortNumber: Integer);

implementation

var
  ClientsVar: TClients = nil;

function GetClients: TClients;
begin
  if ClientsVar = nil then
    ClientsVar := TClients.Create;
  Result := ClientsVar;
end;

procedure ReleasePortByNumber(PortNumber: Integer);
var
  i: Integer;
  Clients: TClients;
  Client: TFptrServer;
begin
  Clients := GetClients;
  for i := 0 to Clients.count-1 do
  begin
    Client := Clients[i];
    if Client.PortNumber = PortNumber then
    begin
      Client.ReleaseDevice;
    end;
  end;
end;

{ TClients }

constructor TClients.Create;
begin
  inherited Create;
  FList := TList.Create;
  FLinks := TList.Create;
  FCS := TCriticalSection.Create;
end;

destructor TClients.Destroy;
begin
  if (ClientsVar = Self) then ClientsVar := nil;

  FCS.Free;
  FList.Free;
  FLinks.Free;
  inherited Destroy;
end;

procedure TClients.Lock;
begin
  FCS.Enter;
end;

procedure TClients.Unlock;
begin
  FCS.Leave;
end;

function TClients.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TClients.GetItem(Index: Integer): TFptrServer;
begin
  Result := FList[Index];
end;

procedure TClients.Insert(AItem: TFptrServer);
begin
  Lock;
  try
    if FList.IndexOf(AItem) = -1 then
    begin
      FList.Add(AItem);
    end;
  finally
    Unlock;
  end;
end;

procedure TClients.Remove(AItem: TFptrServer);
begin
  Lock;
  try
    FList.Remove(AItem);
  finally
    Unlock;
  end;
end;

procedure TClients.InsertLink(AItem: TClientsLink);
begin
  FLinks.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TClients.RemoveLink(AItem: TClientsLink);
begin
  AItem.FOwner := nil;
  FLinks.Remove(AItem);
  if FLinks.Count = 0 then
  begin
    Free;
  end;
end;

function TClients.ItemByID(ID: Integer): TFptrServer;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ID = ID then Exit;
  end;
  Result := nil;
end;

{ TClientsLink }

constructor TClientsLink.Create;
begin
  inherited Create;
  SetOwner(GetClients);
end;

destructor TClientsLink.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TClientsLink.SetOwner(AOwner: TClients);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveLink(Self);
    if AOwner <> nil then AOwner.InsertLink(Self);
  end;
end;

{ TFptrServer }

procedure TFptrServer.Initialize;
const
  LastID: Integer = 0;
begin
  inherited Initialize;
  Inc(LastID);
  FClientInfo.ID := LastID;
  FPortsLink := TPortsLink.Create(Logger);
  FSemaphore := TOposSemaphore.Create;
  FClientsLink := TClientsLink.Create;
end;

destructor TFptrServer.Destroy;
begin
  ClosePort;
  Clients.Remove(Self);
  FSemaphore.Free;

  FPortLink.Free;
  FPortsLink.Free;
  FClientsLink.Free;
  inherited Destroy;
end;

function TFptrServer.GetPort: TPort;
begin
  if FPortLink = nil then
    raise Exception.Create('PortLink = nil');

  Result := FPortLink.Port;
end;

function TFptrServer.Index: Integer;
begin
  Result := Clients.FList.IndexOf(Self);
end;

function TFptrServer.GetClients: TClients;
begin
  Result := FClientsLink.Clients;
end;

function TFptrServer.ClearResult: Integer;
begin
  Result := E_NOERROR;
  FResultCode := E_NOERROR;
  FResultDescription := S_NOERROR;
end;

function TFptrServer.HandleException(E: Exception): Integer;
var
  DriverError: EDriverError;
  OPOSException: EOPOSException;
begin
  FResultDescription := E.Message;

  // EOPOSException
  if E is EOPOSException then
  begin
    Logger.Error('', E);
    OPOSException := E as EOPOSException;
    FResultDescription := E.Message;
    FResultCode := OPOSException.ResultCode;
    Result := FResultCode;
    Exit;
  end;
  // EDriverError
  if E is EDriverError then
  begin
    DriverError := E as EDriverError;
    Result := DriverError.ErrorCode;
    FResultCode := Result;
    Exit;
  end;

  // Unknown
  Result := E_UNKNOWN;
  FResultCode := E_UNKNOWN;
end;

// IFptrServer

function TFptrServer.OpenPort(BaudRate, Timeout: Integer): Integer;
begin
  try
    Port.OpenPort(BaudRate, Timeout);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.ClosePort: Integer;
begin
  try
    if FPortLink <> nil then
    begin
      Port.ClosePort;
    end;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.Get_FileVersion: WideString;
begin
  Result := GetFileVersionInfoStr;
end;

function TFptrServer.SendData(Timeout: Integer; const TxDataHex: WideString;
  out ResultCode: Integer): WideString;
var
  TxData: string;
  RxData: string;
begin
  Result := '';
  ResultCode := ClearResult;
  try
    TxData := HexToStr(TxDataHex);
    RxData := Port.SendData(Timeout, TxData);
    Result := StrToHexText(RxData);
    ResultCode := ClearResult;
  except
    on E: Exception do
      ResultCode := HandleException(E);
  end;
end;

function TFptrServer.Get_ResultDescription: WideString;
begin
  Result := FResultDescription;
end;

function TFptrServer.CloseReceipt: Integer;
begin
  try
    Port.CloseReceipt;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.OpenReceipt(Password: Integer): Integer;
begin
  try
    Port.OpenReceipt(Password);
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.Connect(AAppPID: Integer; const AAppName,
  ACompName: WideString): Integer;
begin
  try
    FClientInfo.PID := AAppPID;
    FClientInfo.AppName := AAppName;
    FClientInfo.CompName := ACompName;
    Clients.Insert(Self);
    FConnected := True;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.Get_ResultCode: Integer;
begin
  Result := FResultCode;
end;

function TFptrServer.ClaimDevice(APortNumber, ATimeout: Integer): Integer;
begin
  try
    FSemaphore.Claim('FptrServer' + IntToStr(APortNumber), ATimeout);
    FPortLink := TPortLink.Create(APortNumber, Logger);
    Port.ClaimDevice(FClientInfo);

    FPortNumber := APortNumber;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.ReleaseDevice: Integer;
begin
  try
    FSemaphore.Release;
    Port.ReleaseDevice;
    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.Get_ClientAppName: WideString;
begin
  Result := FClientInfo.AppName;
end;

function TFptrServer.Get_ClientCompName: WideString;
begin
  Result := FClientInfo.CompName;
end;

function TFptrServer.Get_ClientPID: Integer;
begin
  Result := FClientInfo.PID;
end;

function TFptrServer.Get_Connected: WordBool;
begin
  Result := FConnected;
end;

function TFptrServer.Disconnect: Integer;
begin
  try
    FClientInfo.PID := 0;
    FClientInfo.AppName := '';
    FClientInfo.CompName := '';
    FConnected := False;

    Result := ClearResult;
  except
    on E: Exception do
      Result := HandleException(E);
  end;
end;

function TFptrServer.Get_IsReceiptOpened: WordBool;
begin
  try
    Result := False;
    if FPortLink <> nil then
      Result := Port.ReceiptOpened;

    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

function TFptrServer.Get_IsClaimed: WordBool;
begin
  try
    Result := False;
    if FPortLink <> nil then
      Result := Port.Claimed;

    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

function TFptrServer.Get_IsPortOpened: WordBool;
begin
  try
    Result := False;
    if FPortLink <> nil then
      Result := Port.PortOpened;

    ClearResult;
  except
    on E: Exception do
      HandleException(E);
  end;
end;

initialization
  CoInitialize(nil);
  InitializeDefaultSecurity;
  TDcomFactory.Create(ComServer, TFptrServer, Class_FptrServer, ciMultiInstance, tmApartment);

end.
