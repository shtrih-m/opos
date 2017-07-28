unit PortConnection;

interface

Uses
  // VCL
  Forms, Windows, Classes, Registry, SysUtils, SyncObjs, ExtCtrls,
  // This
  PrinterConnection, PrinterProtocol1, SerialPort, SrvParams, FiscalPrinterTypes,
  FiscalPrinterDevice, OposSemaphore, PrinterTypes, LogFile, PrinterPort;

type
  TPort = class;
  TPortsLink = class;

  { TClientInfo }

  TClientInfo = record
    ID: Integer;        // owner ID
    PID: DWORD;         // client process ID
    AppName: string;    // client application name
    CompName: string;   // client application computer name
  end;

  TPorts = class;

  { TPorts }

  TPorts = class
  private
    FList: TList;
    FLinks: TList;
    FLogger: ILogFile;
    FCS: TCriticalSection;

    function GetCount: Integer;
    procedure InsertItem(AItem: TPort);
    procedure RemoveItem(AItem: TPort);
    procedure InsertLink(AItem: TPortsLink);
    procedure RemoveLink(AItem: TPortsLink);
    function GetItem(Index: Integer): TPort;
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;
    procedure Lock;
    procedure Unlock;
    procedure UpdateTimers;
    function ItemByID(ID: Integer): TPort;
    function Add(PortNumber: Integer): TPort;
    function ItemByPortNumber(Value: Integer): TPort;

    property Count: Integer read GetCount;
    property Logger: ILogFile read FLogger;
    property Items[Index: Integer]: TPort read GetItem; default;
  end;

  { TPortsLink }

  TPortsLink = class
  private
    FOwner: TPorts;
    procedure SetOwner(AOwner: TPorts);
  public
    constructor Create(Logger: ILogFile);
    destructor Destroy; override;
    property Ports: TPorts read FOwner;
  end;

  TPortLink = class;

  { TPort }

  TPort = class
  private
    FID: Integer;
    FLinks: TList;
    FTimer: TTimer;
    FOwner: TPorts;
    FClaimed: Boolean;
    FPassword: Integer;
    FPortNumber: Integer;
    FPortOpened: Boolean;
    FCS: TCriticalSection;
    FReceiptOpened: Boolean;
    FClientInfo: TClientInfo;
    FConnection: IPrinterConnection;

    procedure ResetTimer;
    procedure UpdateTimer;
    function GetTimer: TTimer;
    procedure SetOwner(AOwner: TPorts);
    procedure TimerProc(Sender: TObject);
    procedure InsertLink(AItem: TPortLink);
    procedure RemoveLink(AItem: TPortLink);

    property Timer: TTimer read GetTimer;
    procedure CancelReceipt;
    function IsReceiptOpened(Device: IFiscalPrinterDevice): Boolean;
    procedure WaitForPrinting(Device: IFiscalPrinterDevice; Timeout: Integer);
    function GetStatus(Device: IFiscalPrinterDevice): TPrinterStatus;
  public
    constructor CreatePort(AOwner: TPorts; APortNumber: Integer; ALogger: ILogFile);
    destructor Destroy; override;

    procedure Lock;
    procedure Unlock;
    procedure ClosePort;
    procedure CloseReceipt;
    procedure ReleaseDevice;
    procedure OpenPort(BaudRate, Timeout: Integer);
    procedure OpenReceipt(APassword: Integer);
    procedure ClaimDevice(const AClientInfo: TClientInfo);
    function SendData(Timeout: DWORD; const Data: string): string;

    property ID: Integer read FID;
    property Claimed: Boolean read FClaimed;
    property PortOpened: Boolean read FPortOpened;
    property PortNumber: Integer read FPortNumber;
    property ClientInfo: TClientInfo read FClientInfo;
    property ReceiptOpened: Boolean read FReceiptOpened;
  end;

  { TPortLink }

  TPortLink = class
  private
    FOwner: TPort;
    FPortsLink: TPortsLink;
    procedure SetOwner(AOwner: TPort);
  public
    constructor Create(PortNumber: Integer; Logger: ILogFile);
    destructor Destroy; override;
    property Port: TPort read FOwner;
  end;

implementation

uses
  oleMain;

var
  PortsVar: TPorts = nil;

function GetPorts(Logger: ILogFile): TPorts;
begin
  if PortsVar = nil then
    PortsVar := TPorts.Create(Logger);
  Result := PortsVar;
end;

function Min(V1, V2: Integer): Integer;
begin
  if V1 < V2 then Result := V1
  else Result := V2;
end;

function DWToStr(Value: DWord): string;
begin
  SetLength(Result, 4);
  Move(Value, Result[1], 4);
end;

{ TPorts }

constructor TPorts.Create(ALogger: ILogFile);
begin
  inherited Create;
  FCS := TCriticalSection.Create;
end;

destructor TPorts.Destroy;
begin
  FCS.Free;
  if (PortsVar = Self) then PortsVar := nil;
  inherited Destroy;
end;

procedure TPorts.Lock;
begin
  FCS.Enter;
end;

procedure TPorts.Unlock;
begin
  FCS.Leave;
end;

procedure TPorts.UpdateTimers;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].UpdateTimer;
end;

function TPorts.GetCount: Integer;
begin
  if FList = nil then
    Result := 0
  else
    Result := FList.Count;
end;

function TPorts.GetItem(Index: Integer): TPort;
begin
  Result := FList[Index];
end;

procedure TPorts.InsertItem(AItem: TPort);
begin
  if FList = nil then FList := TList.Create;
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPorts.RemoveItem(AItem: TPort);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
  if FList.Count = 0 then
  begin
    FList.Free;
    FList := nil;
  end;
end;

procedure TPorts.InsertLink(AItem: TPortsLink);
begin
  if FLinks = nil then FLinks := TList.Create;
  FLinks.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPorts.RemoveLink(AItem: TPortsLink);
begin
  AItem.FOwner := nil;
  FLinks.Remove(AItem);
  if FLinks.Count = 0 then
  begin
    FLinks.Free;
    FLinks := nil;
    if Count = 0 then Free;
  end;
end;

function TPorts.ItemByID(ID: Integer): TPort;
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

function TPorts.ItemByPortNumber(Value: Integer): TPort;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.PortNumber = Value then Exit;
  end;
  Result := nil;
end;

function TPorts.Add(PortNumber: Integer): TPort;
begin
  Result := TPort.CreatePort(Self, PortNumber, Logger);
end;

{ TPortsLink }

constructor TPortsLink.Create(Logger: ILogFile);
begin
  inherited Create;
  SetOwner(GetPorts(Logger));
end;

destructor TPortsLink.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TPortsLink.SetOwner(AOwner: TPorts);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveLink(Self);
    if AOwner <> nil then AOwner.InsertLink(Self);
  end;
end;

{ TPort }

constructor TPort.CreatePort(AOwner: TPorts; APortNumber: Integer; ALogger: ILogFile);
const
  LastID: Integer = 0;
var
  APort: IPrinterPort;
begin
  inherited Create;
  FCS := TCriticalSection.Create;
  APort := GetSerialPort(APortNumber, ALogger);
  FConnection := TPrinterProtocol1.Create(ALogger, APort);

  Inc(LastID); FID := LastID;
  FPortNumber := APortNumber;
  SetOwner(AOwner);
  UpdateTimer;
end;

destructor TPort.Destroy;
begin
  SetOwner(nil);

  ClosePort;
  FCS.Free;
  FTimer.Free;
  FConnection := nil;
  inherited Destroy;
end;

procedure TPort.ResetTimer;
begin
  Timer.Enabled := False;
  UpdateTimer;
end;

function TPort.GetTimer: TTimer;
begin
  if FTimer = nil then
  begin
    FTimer := TTimer.Create(nil);
    FTimer.OnTimer := TimerProc;
  end;
  Result := FTimer;
end;

procedure TPort.OpenPort(BaudRate, Timeout: Integer);
begin
  FConnection.OpenPort(PortNumber, BaudRate, Timeout);

  ResetTimer;
  Timer.Enabled := Params.AutoPortClose;
  FPortOpened := True;
end;

procedure TPort.ClosePort;
begin
  FConnection.ClosePort;
  Timer.Enabled := False;
  FPortOpened := False;
end;

procedure TPort.UpdateTimer;
begin
  Timer.Enabled := Params.AutoPortClose;
  Timer.Interval := Params.PortCloseTimeout*1000;
end;

procedure TPort.CloseReceipt;
begin
  FReceiptOpened := False;
end;

procedure TPort.OpenReceipt(APassword: Integer);
begin
  FReceiptOpened := True;
  FPassword := APassword;
end;

procedure TPort.Lock;
begin
  FCS.Enter;
end;

procedure TPort.Unlock;
begin
  FCS.Leave;
end;

function TPort.GetStatus(Device: IFiscalPrinterDevice): TPrinterStatus;
var
  Status: TLongPrinterStatus;
begin
  Status := Device.GetLongStatus;
  Result.Mode := Status.Mode;
  Result.AdvancedMode := Status.AdvancedMode;
  Result.OperatorNumber := Status.OperatorNumber;
  Result.Flags := DecodePrinterFlags(Status.Flags);
end;

procedure TPort.WaitForPrinting(Device: IFiscalPrinterDevice; Timeout: Integer);
var
  Mode: Byte;
  Status: TPrinterStatus;
begin
  repeat
    Status := GetStatus(Device);
    Mode := Status.Mode and $0F;
    case Status.AdvancedMode of
      AMODE_IDLE:
      begin
        case Mode of
          MODE_FULLREPORT,
          MODE_EKLZREPORT,
          MODE_SLPPRINT:
            Sleep(Timeout);
        else
          Exit;
        end;
      end;

      AMODE_PASSIVE,
      AMODE_ACTIVE:
      begin
        // No receipt paper
        if Device.GetModel.CapRecPresent and Status.Flags.RecEmpty then
          raise Exception.Create('Receipt station is empty');
        // No control paper
        if Device.GetModel.CapJrnPresent and Status.Flags.JrnEmpty then
          raise Exception.Create('Journal station is empty');
      end;

      AMODE_AFTER:
          Device.ContinuePrint;

      AMODE_REPORT,
      AMODE_PRINT:
        Sleep(Timeout);

    else
      Sleep(Timeout);
    end;
  until False;
end;

function TPort.IsReceiptOpened(Device: IFiscalPrinterDevice): Boolean;
begin
  Result := (Device.GetLongStatus.Mode and $0F) = MODE_REC;
end;

procedure TPort.CancelReceipt;
var
  Device: IFiscalPrinterDevice;
begin
  Device := TFiscalPrinterDevice.Create;
  try
    Device.Open(FConnection);
    if IsReceiptOpened(Device) then
    begin
      Device.ReceiptCancel;
      WaitForPrinting(Device, 100);
    end;
  finally
    Device := nil;
  end;
end;

procedure TPort.TimerProc(Sender: TObject);
begin
  if Params.AutoRecCancel and FReceiptOpened then
  begin
    CancelReceipt;
  end;
  if Params.AutoPortClose then
    ReleasePortByNumber(PortNumber);
  Timer.Enabled := False;
end;

procedure TPort.SetOwner(AOwner: TPorts);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TPort.InsertLink(AItem: TPortLink);
begin
  if FLinks = nil then FLinks := TList.Create;
  FLinks.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPort.RemoveLink(AItem: TPortLink);
begin
  AItem.FOwner := nil;
  FLinks.Remove(AItem);
  if FLinks.Count = 0 then
  begin
    FLinks.Free;
    FLinks := nil;
    Free;
  end;
end;

function TPort.SendData(Timeout: DWORD; const Data: string): string;
begin
  Timer.Enabled := False;
  Timer.Enabled := Params.AutoPortClose;
  Timer.Interval := Params.PortCloseTimeout*1000;

  Result := FConnection.Send(Timeout, Data)
end;

procedure TPort.ReleaseDevice;
begin
  FClaimed := False;
end;

procedure TPort.ClaimDevice(const AClientInfo: TClientInfo);
begin
  FClientInfo := AClientInfo;
  FClaimed := True;
  Timer.Enabled := Params.AutoPortClose;
end;

{ TPortLink }

constructor TPortLink.Create(PortNumber: Integer; Logger: ILogFile);
var
  Port: TPort;
  Ports: TPorts;
begin
  inherited Create;
  FPortsLink := TPortsLink.Create(Logger);
  Ports := FPortsLink.Ports;

  Port := FPortsLink.Ports.ItemByPortNumber(PortNumber);
  if Port = nil then Port := Ports.Add(PortNumber);
  SetOwner(Port);
end;

destructor TPortLink.Destroy;
begin
  SetOwner(nil);
  FPortsLink.Free;
  inherited Destroy;
end;

procedure TPortLink.SetOwner(AOwner: TPort);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveLink(Self);
    if AOwner <> nil then AOwner.InsertLink(Self);
  end;
end;

end.




