unit TCPDriver;

interface

uses
  // VCL
  Windows, Messages, MConnect, ComObj, SysUtils, {$IFDEF VER150} Variants, {$ENDIF}
  SConnect,
  // This
  PrinterDriver, SrvFRLib_TLB, untUtil, DriverError, DriverTypes, untLogger,
  License;

type
  TTCPConnection = TSocketConnection;

  { TRemoteDriver }

  TRemoteDriver = class(TPrinterDriver)
  private
    FComputerName: string;
    FPortOpened: Boolean;
    FLogger: TLogger;
    function GetLogger: TLogger;
    procedure DoAfterConnect;
    procedure CheckLicenses;
    procedure Check(Code: Integer);
    function GetMachineName: string;
    function EncodeData(const AStr: string): string;
    function DecodeData(const AStr: string): string;
    procedure AfterDisconnect(Sender: TObject);
    procedure CheckLicense(var LicInfo: TLicInfoRec);
    property Logger: TLogger read GetLogger;
  protected
    function Connected: Boolean; virtual; abstract;
    function GetDriver: OleVariant; virtual; abstract;
    property Driver: OleVariant read GetDriver;
    function GetPortOpened: Boolean; override;
  public
    procedure LockPort; override;
    procedure OpenPort; override;
    procedure ClosePort; override;
    procedure UnlockPort; override;
    procedure AdminUnlockPorts; override;
    procedure AdminUnlockPort(ComNumber: Integer); override;

    function ServerVersion: string; override;
    function GetComputerName: string; override;
    function HasCashControlLicense: Boolean; override;
    procedure CloseCheck(ComNumber: Integer); override;
    procedure OpenCheck(ComNumber, Password: Integer); override;
    procedure SendData(CmdTimeout: DWORD; const ATxData: string); override;
    property ComputerName: string read FComputerName write FComputerName;
  end;

  { TTCPDriver }

  TTCPDriver = class(TRemoteDriver)
  private
    FTCPPort: Integer;
    FIPAddress: string;
    FUseIPAddress: Boolean;

    FConnection: TTCPConnection;
    function GetConnection: TTCPConnection;
    property Connection: TTCPConnection read GetConnection;
  protected
    function Connected: Boolean; override;
    function GetDriver: OleVariant; override;
  public
    destructor Destroy; override;
    procedure Connect; override;
    procedure Disconnect; override;
    function GetPortName: string; override;

    property TCPPort: Integer read FTCPPort write FTCPPort;
    property IPAddress: string read FIPAddress write FIPAddress;
    property UseIPAddress: Boolean read FUseIPAddress write FUseIPAddress;
  end;

  { TDCOMDriver }

  TDCOMDriver = class(TRemoteDriver)
  private
    FDriver: OleVariant;
  protected
    function Connected: Boolean; override;
    function GetDriver: OleVariant; override;
  public
    destructor Destroy; override;
    procedure Connect; override;
    procedure Disconnect; override;
    function GetPortName: string; override;
  end;

implementation

{ TTCPDriver }

function TRemoteDriver.ServerVersion: string;
begin
  if Connected then Result := Driver.ServerVersion
  else Result := 'недоступна';
end;

procedure TRemoteDriver.AfterDisconnect(Sender: TObject);
begin
  FPortOpened := False;
end;

procedure TRemoteDriver.Check(Code: Integer);
begin
  if Code <> 0 then
    RaiseError(Code, Driver.ResultDescription);
end;

function TRemoteDriver.EncodeData(const AStr: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(AStr) do
    Result := Result + Tnt_WideFormat('%.2x', [Ord(AStr[i])]);
end;

function TRemoteDriver.DecodeData(const AStr: string): string;

  function HexCharToByte(AChar: char): byte;
  begin
    case AChar of
    '0'..'9': Result := ord(AChar) - ord('0');
    'A'..'F': Result := ord(AChar) - ord('A') + 10;
    'a'..'f': Result := ord(AChar) - ord('a') + 10;
    else
      raiseException('Неверный формат данных');
    end;
  end;

var
  i: Integer;
begin
  SetLength(Result, Length(AStr) div 2);
  for i := 1 to Length(Result) do
    Result[i] := char(HexCharToByte(AStr[(i shl 1) - 1]) shl 4 or HexCharToByte(AStr[i shl 1]));
end;

procedure TRemoteDriver.SendData(CmdTimeout: DWORD; const ATxData: string);
var
  ResultCode: Integer;
  TxData: string;
  RxData: string;
begin
  Logger.WriteTxData(ATxData);
  TxData := EncodeData(ATxData);
  Logger.Debug('-> (' + TxData + ')');
  RxData := Driver.SendData(CmdTimeout, TxData, ResultCode);
  Logger.Debug('<- (' + RxData + ')');
  Output := DecodeData(RxData);
  Logger.WriteRxData(Output);
  Check(ResultCode);
end;

procedure TRemoteDriver.OpenPort;
begin
  CheckLicenses; //!!!
  Check(Driver.OpenPort(PortNumber, BaudRate, Timeout));
  FPortOpened := True;
end;

procedure TRemoteDriver.ClosePort;
begin
  if Connected then Driver.ClosePort;
end;

procedure TRemoteDriver.OpenCheck(ComNumber, Password: Integer);
begin
  Driver.OpenCheck(ComNumber, Password);
end;

procedure TRemoteDriver.CloseCheck(ComNumber: Integer);
begin
  Driver.CloseCheck(ComNumber);
end;

function TRemoteDriver.GetMachineName: string;
begin
  Result := ComputerName;
  if Result = '' then Result := GetCompName;
end;

function TRemoteDriver.GetComputerName: string;
begin
  Result := Driver.GetComputerName;
end;

function TRemoteDriver.HasCashControlLicense: Boolean;
begin
  if not Driver.LicensesChecked then
  begin
    Check(Driver.CheckLicenses);
  end;
  Result := Driver.CashControl;
end;

{****************************************************************************}
{
{       Проверка лицензий выполняется:
{       1. Если выполняется удаленное подключение
{       2. Если включена система CashControl
{
{       Лицензии не проверяются в том случае, если
{       1. Драйвер их уже проверял
{       2. Другие клиенты сервера их уже проверили

{       Если ключ включили на ходу то нужно либо явно обновить
{       лицензии на сервере, либо отключить всех клиентов и снова
{       начать работу с сервером.
{
{       Это нужно для оптимизации, так как поиск ключа длительная операция,
{       и как правило ключ не вынимают часто, то достаточно проверить его
{       один раз
{
{****************************************************************************}

procedure TRemoteDriver.CheckLicense(var LicInfo: TLicInfoRec);
begin
  LicInfo.ResultCode := 0;
  LicInfo.ResultDesc := 'Ошибок нет';
  if not Driver.LicensesChecked then
  begin
    LicInfo.ResultCode := Driver.CheckLicenses;
    LicInfo.ResultDesc := Driver.ResultDescription;
  end;
  LicInfo.CashControl := Driver.CashControl;
  LicInfo.KeyCount := Driver.KeyCount;
  LicInfo.LicCount := Driver.LicCount;
  LicInfo.RemoteLaunch := Driver.RemoteLaunch;
  Check(Driver.Connect(GetCurrentProcessID, GetAppName, GetCompName));
end;

{*****************************************************************************}
{
{       Проверка лицензий на сервере
{
{*****************************************************************************}

procedure TRemoteDriver.CheckLicenses;

  function GetIsRemote: Boolean;
  var
    ClientComputerName: string;
    ServerComputerName: string;
  begin
    ClientComputerName := GetCompName;
    ServerComputerName := Driver.GetComputerName;
    Result := (ServerComputerName <> '') and (ClientComputerName <> ServerComputerName);
    {$IFDEF LOCALREMOTE}
    Result := True;
    {$ENDIF}
  end;

var
  S: string;
  IsRemote: Boolean;
  LicInfo: TLicInfoRec;
begin
  {$IFNDEF DEBUG_NOCHECK }
  IsRemote := GetIsRemote;

  CheckLicense(LicInfo);
  if IsRemote and (not LicInfo.RemoteLaunch) then
  begin
    // Если на сервере не нашли лицензии, проверяем лицензии на клиенте
    if not LicenseParams.Updated then
      LicenseParams.Update;
    if LicenseParams.RemoteLaunch then Exit;
    
    // 1. Не смогли проверить лицензии
    if LicInfo.ResultCode <> 0 then
    begin
      S := Tnt_WideFormat('%s. %s', [S_REMOTECONNECTION, LicInfo.ResultDesc]);
      RaiseError(E_REMOTECONNECTION, S);
    end;
    // 2. Ключ защиты не найден
    if LicInfo.KeyCount = 0 then
    begin
      S := 'Ключ защиты не найден.';
      RaiseError(E_REMOTECONNECTION, S);
    end;
    // 3. Не введены лицензии
    if LicInfo.LicCount = 0 then
    begin
      S := 'Не введена лицензия.';
      RaiseError(E_REMOTECONNECTION, S);
    end;
    // Лицензии и ключи есть, но все они не те
    S := 'Лицензия недействительна';
    RaiseError(E_REMOTECONNECTION, S);
  end;
  {$ENDIF}
end;

procedure TRemoteDriver.DoAfterConnect;
begin
  if Assigned(AfterConnect) then AfterConnect(Self);
end;

{ TTCPDriver }

destructor TTCPDriver.Destroy;
begin
  FConnection.Free;
  FLogger.Free;
  inherited Destroy;
end;

function TTCPDriver.GetConnection: TTCPConnection;
begin
  if FConnection = nil then
  begin
    FConnection := TTCPConnection.Create(nil);
    FConnection.AfterDisconnect := AfterDisconnect;
    if UseIPAddress then FConnection.Address := IPAddress
    else FConnection.Host := GetMachineName;
    FConnection.Port := TCPPort;
    FConnection.ServerGUID := GuidToString(CLASS_SrvFR);
  end;
  Result := FConnection;
end;

function TTCPDriver.GetDriver: OleVariant;
begin
  if not Connected then Connect;
  Result := Connection.AppServer;
end;

function TTCPDriver.Connected: Boolean;
begin
  Result := (FConnection <> nil)and(FConnection.Connected);
end;

procedure TTCPDriver.Connect;
begin
  Connection.Open;
  CheckLicenses;
  DoAfterConnect;
end;

procedure TTCPDriver.Disconnect;
begin
  FConnection.Free;
  FConnection := nil;
end;

function TTCPDriver.GetPortName: string;
begin
  Result := Tnt_WideFormat('TCP:%s:%d ', [IPAddress, TCPPort]) + inherited GetPortName;
end;

{ TDCOMDriver }

destructor TDCOMDriver.Destroy;
begin
  Disconnect;
  inherited Destroy;
end;

function TDCOMDriver.Connected: Boolean;
begin
  Result := not VarIsEmpty(FDriver);
end;

procedure TDCOMDriver.Connect;
begin
  if ComputerName = '' then FDriver := CoSrvFR.Create
  else FDriver := CoSrvFR.CreateRemote(ComputerName);

  CheckLicenses;
  DoAfterConnect;
end;

procedure TDCOMDriver.Disconnect;
begin
  VarClear(FDriver);
end;

function TDCOMDriver.GetDriver: OleVariant;
begin
  if not Connected then Connect;
  Result := FDriver;
end;

procedure TRemoteDriver.LockPort;
begin
  Check(Driver.LockPort(PortNumber));
  PortLocked := True;
end;

procedure TRemoteDriver.UnlockPort;
begin
  Check(Driver.UnlockPort);
  PortLocked := False;
end;

procedure TRemoteDriver.AdminUnlockPort(ComNumber: Integer);
begin
  Check(Driver.AdminUnlockPort(ComNumber));
  PortLocked := False;
end;

procedure TRemoteDriver.AdminUnlockPorts;
begin
  Check(Driver.AdminUnlockPorts);
  PortLocked := False;
end;

function TDCOMDriver.GetPortName: string;
begin
  Result := Tnt_WideFormat('DCOM:%s ', [ComputerName]) + inherited GetPortName;
end;

function TRemoteDriver.GetLogger: TLogger;
begin
  if FLogger = nil then
    FLogger := TLogger.Create(Self.ClassName);
  Result := FLogger;
end;

function TRemoteDriver.GetPortOpened: Boolean;
begin
  Result := FPortOpened;
end;

end.
