unit Session;

interface

Uses
  // VCL
  Windows, SysUtils, Classes, SyncObjs, ComObj, ActiveX,
  // This
  oleMain, FptrServerLib_TLB, DriverError;


type
  TSession = class;
  TSessions = class;

  { TSessions }

  TSessions = class
  private
    FList: TList;
    FCS: TCriticalSection;

    function GetCount: Integer;
    procedure InsertItem(AItem: TSession);
    procedure RemoveItem(AItem: TSession);
    function GetItem(Index: Integer): TSession;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;
    procedure Clear;
    procedure Unlock;

    function Find(AID: Integer): TSession;
    function ItemByID(AID: Integer): TSession;
    function Add(AConnection: TObject): TSession;
    function ItemByConnection(AConnection: TObject): TSession;
    function FindByConnection(AConnection: TObject): TSession;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSession read GetItem; default;
  end;

  { TSession }

  TSession = class
  private
    FID: Integer;
    FOwner: TSessions;
    FDriver: TFptrServer;
    FConnection: TObject;

    function GetIndex: Integer;
    procedure SetOwner(AOwner: TSessions);
  public
    constructor Create(AOwner: TSessions; AConnection: TObject);
    destructor Destroy; override;

    procedure Check(ResultCode: Integer);

    function ClaimDevice(PortNumber: Integer; Timeout: Integer): Integer;
    function ClosePort: Integer;
    function CloseReceipt: Integer;
    function Connect(AAppPID: Integer; const AAppName: WideString; const ACompName: WideString): Integer;
    function Disconnect: Integer;
    function OpenPort(BaudRate: Integer; Timeout: Integer): Integer;
    function OpenReceipt(Password: Integer): Integer;
    function ReleaseDevice: Integer;
    function SendData(Timeout: Integer; const TxDataHex: WideString; out ResultCode: Integer): WideString;
    function Get_ClientAppName: WideString;
    function Get_ClientCompName: WideString;
    function Get_ClientPID: Integer;
    function Get_Connected: WordBool;
    function Get_FileVersion: WideString;
    function Get_IsClaimed: WordBool;
    function Get_IsPortOpened: WordBool;
    function Get_IsReceiptOpened: WordBool;
    function Get_ResultCode: Integer;
    function Get_ResultDescription: WideString;

    property ID: Integer read FID;
    property Index: Integer read GetIndex;
    property Driver: TFptrServer read FDriver;
    property Connection: TObject read FConnection;

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

function Sessions: TSessions;

implementation

var
  FSessions: TSessions = nil;

function Sessions: TSessions;
begin
  if FSessions = nil then
    FSessions := TSessions.Create;
  Result := FSessions;
end;

{ TSessions }

constructor TSessions.Create;
begin
  inherited Create;
  FList := TList.Create;
  FCS := TCriticalSection.Create;
end;

destructor TSessions.Destroy;
begin
  Clear;
  FList.Free;
  FCS.Free;
  inherited Destroy;
end;

procedure TSessions.Clear;
begin
  Lock;
  try
    while Count > 0 do Items[0].Free;
  finally
    Unlock;
  end;
end;

function TSessions.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSessions.GetItem(Index: Integer): TSession;
begin
  Result := FList[Index];
end;

procedure TSessions.InsertItem(AItem: TSession);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TSessions.RemoveItem(AItem: TSession);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

procedure TSessions.Lock;
begin
  FCS.Enter;
end;

procedure TSessions.Unlock;
begin
  FCS.Leave;
end;

function TSessions.Add(AConnection: TObject): TSession;
begin
  Result := TSession.Create(Self, AConnection);
end;

function CreateClassID: string;
var
  ClassID: TCLSID;
  P: PWideChar;
begin
  CoCreateGuid(ClassID);
  StringFromCLSID(ClassID, P);
  Result := P;
  CoTaskMemFree(P);
end;

function TSessions.Find(AID: Integer): TSession;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ID = AID then Exit;
  end;
  Result := nil;
end;

function TSessions.ItemByID(AID: Integer): TSession;
begin
  Result := Find(AID);
  if Result = nil then
    raise Exception.Create('Сессия не найдена');
end;

function TSessions.FindByConnection(AConnection: TObject): TSession;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Connection = AConnection then Exit;
  end;
  Result := nil;
end;

function TSessions.ItemByConnection(AConnection: TObject): TSession;
begin
  Result := FindByConnection(AConnection);
  if Result = nil then
    raise Exception.Create('Сессия не найдена');
end;

{ TSession }

constructor TSession.Create(AOwner: TSessions; AConnection: TObject);
const
  LastID: Integer = 0;
begin
  inherited Create;
  Inc(LastID); FID := LastID;
  FConnection := AConnection;
  SetOwner(AOwner);
  FDriver := TFptrServer.Create;
  FDriver.Initialize;
end;

destructor TSession.Destroy;
begin
  FDriver.Free;
  SetOwner(nil);
  inherited Destroy;
end;

procedure TSession.SetOwner(AOwner: TSessions);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TSession.Check(ResultCode: Integer);
begin
  if ResultCode <> 0 then
    raiseError(ResultCode, ResultDescription);
end;

function TSession.GetIndex: Integer;
begin
  Result := FOwner.FList.IndexOf(Self);
end;

function TSession.ClaimDevice(PortNumber: Integer; Timeout: Integer): Integer;
begin
  Result := Driver.ClaimDevice(PortNumber, Timeout);
end;

function TSession.ClosePort: Integer;
begin
  Result := Driver.ClosePort;
end;

function TSession.CloseReceipt: Integer;
begin
  Result := Driver.CloseReceipt;
end;

function TSession.Connect(AAppPID: Integer; const AAppName,
  ACompName: WideString): Integer;
begin
  Result := Driver.Connect(AAppPID, AAppName, ACompName);
end;

function TSession.Disconnect: Integer;
begin
  Result := Driver.Disconnect;
end;

function TSession.Get_ClientAppName: WideString;
begin
  Result := Driver.ClientAppName;
end;

function TSession.Get_ClientCompName: WideString;
begin
  Result := Driver.ClientAppName;
end;

function TSession.Get_ClientPID: Integer;
begin
  Result := Driver.ClientPID;
end;

function TSession.Get_Connected: WordBool;
begin
  Result := Driver.Connected;
end;

function TSession.Get_FileVersion: WideString;
begin
  Result := Driver.FileVersion;
end;

function TSession.Get_IsClaimed: WordBool;
begin
  Result := Driver.IsClaimed;
end;

function TSession.Get_IsPortOpened: WordBool;
begin
  Result := Driver.IsPortOpened;
end;

function TSession.Get_IsReceiptOpened: WordBool;
begin
  Result := Driver.IsReceiptOpened;
end;

function TSession.Get_ResultCode: Integer;
begin
  Result := Driver.ResultCode;
end;

function TSession.Get_ResultDescription: WideString;
begin
  Result := Driver.ResultDescription;
end;

function TSession.OpenPort(BaudRate, Timeout: Integer): Integer;
begin
  Result := Driver.OpenPort(BaudRate, Timeout);
end;

function TSession.OpenReceipt(Password: Integer): Integer;
begin
  Result := Driver.OpenReceipt(Password);
end;

function TSession.ReleaseDevice: Integer;
begin
  Result := Driver.ReleaseDevice;
end;

function TSession.SendData(Timeout: Integer; const TxDataHex: WideString;
  out ResultCode: Integer): WideString;
begin
  Result := Driver.SendData(Timeout, TxDataHex, ResultCode);
end;

initialization

finalization
  FSessions.Free;
  FSessions := nil;

end.
