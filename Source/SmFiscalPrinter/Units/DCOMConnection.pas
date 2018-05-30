unit DCOMConnection;

interface

uses
  // VCL
  Windows, Messages, MConnect, ComObj, SysUtils, Variants,
  SConnect,
  // This
  PrinterConnection, FptrServerLib_TLB, DriverError, StringUtils, VSysUtils;

type
  { TDCOMConnection }

  TDCOMConnection = class(TInterfacedObject, IPrinterConnection)
  private
    FRemoteHost: AnsiString;
    FRemotePort: Integer;
    FDriver: IFptrServer;
    FPortNumber: Integer;
    FBaudRate: Integer;
    FByteTimeout: Integer;

    procedure Check(Code: Integer);
    function GetDriver: IFptrServer;

    property Driver: IFptrServer read GetDriver;
  public
    constructor Create(const ARemoteHost: AnsiString; ARemotePort: Integer;
      APortNumber, ABaudRate, AByteTimeout: Integer);
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

{ TDCOMConnection }

constructor TDCOMConnection.Create(const ARemoteHost: AnsiString; ARemotePort: Integer;
  APortNumber, ABaudRate, AByteTimeout: Integer);
begin
  inherited Create;
  FRemoteHost := ARemoteHost;
  FRemotePort := ARemotePort;
  FPortNumber := APortNumber;
  FBaudRate := ABaudRate;
  FByteTimeout := AByteTimeout;
end;

destructor TDCOMConnection.Destroy;
begin
  FDriver := nil;
  inherited Destroy;
end;

procedure TDCOMConnection.Check(Code: Integer);
begin
  if Code <> 0 then
    RaiseError(Code, Driver.ResultDescription);
end;

function TDCOMConnection.GetDriver: IFptrServer;
begin
  if FDriver = nil then
  begin
    if FRemoteHost = '' then
      FDriver := CoFptrServer.Create
    else
      FDriver := CoFptrServer.CreateRemote(FRemoteHost);

    Check(FDriver.Connect(GetCurrentProcessID, 'OPOS fiscal printer', GetCompName));
  end;
  Result := FDriver;
end;

procedure TDCOMConnection.ClaimDevice(PortNumber, Timeout: Integer);
begin
  Check(Driver.ClaimDevice(PortNumber, Timeout));
end;

procedure TDCOMConnection.ReleaseDevice;
begin
  Check(Driver.ReleaseDevice);
end;

procedure TDCOMConnection.ClosePort;
begin
  Check(Driver.ClosePort);
end;

procedure TDCOMConnection.CloseReceipt;
begin
  Check(Driver.CloseReceipt);
end;

procedure TDCOMConnection.OpenPort(PortNumber, BaudRate, ByteTimeout: Integer);
begin
  Check(Driver.OpenPort(BaudRate, ByteTimeout));
end;

procedure TDCOMConnection.OpenReceipt(Password: Integer);
begin
  Check(Driver.OpenReceipt(Password));
end;

function TDCOMConnection.Send(Timeout: Integer;
  const Data: AnsiString): AnsiString;
var
  ResultCode: Integer;
begin
  Result := Driver.SendData(Timeout, StrToHexText(Data), ResultCode);
  Check(ResultCode);
  Result := HexToStr(Result);
end;

end.
