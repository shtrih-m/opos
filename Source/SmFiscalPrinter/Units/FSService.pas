unit FSService;

interface

uses
  // VCL
  Windows, SysUtils,
  // Indy
  IdTCPClient, IdGlobal,
  // This
  LogFile, NotifyThread, FiscalPrinterTypes, PrinterParameters;

type
  { TOFDHeader }

  TOFDHeader = packed record
    Signature: DWORD;
    SVersion: WORD;
    AVersion: WORD;
    FSNumber: array [0..15] of char;
    Size: WORD;
    Flags: WORD;
    CRC: WORD;
  end;

  { TFSServiceParams }

  TFSServiceParams = record
    Host: string;
    Port: Integer;
    PollInterval: Integer; // in ms
  end;

  { TFSService }

  TFSService = class
  private
    function GetLogger: TLogFile;
  private
    FStopFlag: Boolean;
    FThread: TNotifyThread;
    FParams: TFSServiceParams;
    FDevice: IFiscalPrinterDevice;

    procedure Stop;
    procedure Start;
    procedure CheckFS;
    function SendData(const Command: string): string;
    procedure ThreadProc(Sender: TObject);
    procedure Sleep2(Timeout: Integer);

    property Logger: TLogFile read GetLogger;
    property Device: IFiscalPrinterDevice read FDevice;
  public
    constructor Create(ADevice: IFiscalPrinterDevice);
    destructor Destroy; override;
  end;

implementation

{ TFSService }

constructor TFSService.Create(ADevice: IFiscalPrinterDevice);
begin
  inherited Create;
  FDevice := ADevice;
  Start;
end;

destructor TFSService.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TFSService.Stop;
begin
  FStopFlag := True;
  FThread.Free;
  FThread := nil;
end;

procedure TFSService.Start;
begin
  FStopFlag := False;
  FThread := TNotifyThread.Create(True);
  FThread.OnExecute := ThreadProc;
  FThread.Resume;
end;

procedure TFSService.Sleep2(Timeout: Integer);
var
  TickCount: Integer;
begin
  TickCount := GetTickCount;
  while True do
  begin
    if FStopFlag then Break;
    if Integer(GetTickCount) > (TickCount + Timeout) then Break;
  end;
end;

procedure TFSService.ThreadProc(Sender: TObject);
begin
  try
    if Device.GetDeviceMetrics.DeviceName = 'ØÒÐÈÕ-ÌÎÁÀÉË-Ô' then
    begin
      FParams.Host := FDevice.ReadTableStr(15, 1, 1);
      FParams.Port := FDevice.ReadTableInt(15, 1, 2);
      FParams.PollInterval := FDevice.ReadTableInt(15, 1, 3)  * 1000;
    end else
    begin
      FParams.Host := FDevice.ReadTableStr(19, 1, 1);
      FParams.Port := FDevice.ReadTableInt(19, 1, 2);
      FParams.PollInterval := FDevice.ReadTableInt(19, 1, 3);
    end;

    while not FStopFlag do
    begin
      CheckFS;
      Sleep2(FParams.PollInterval);
    end;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TFSService.CheckFS;
var
  Answer: string;
  BlockData: string;
begin
  try
    FDevice.Lock;
    try
      BlockData := FDevice.FSReadBlockData;
      if Length(BlockData) = 0 then Exit;

      Answer := SendData(BlockData);
      if Length(Answer) = 0 then Exit;
      FDevice.FSWriteBlockData(Answer);
    finally
      FDevice.Unlock;
    end;
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

function StrToIdBytes(const Data: string): TIdBytes;
var
  i: Integer;
begin
  SetLength(Result, Length(Data));
  for i := 1 to Length(Data) do
    Result[i-1] := Ord(Data[i]);
end;

function TFSService.SendData(const Command: string): string;
const
  FSTimeout = 10000;
var
  i: Integer;
  IdBytes: TIdBytes;
  Header: TOFDHeader;
  Connection: TIdTCPClient;
begin
  Logger.Debug('TFSService.SendData');
  Logger.DebugData('-> ', Command);

  Connection := TIdTCPClient.Create(nil);
  try
    Connection.Host := FParams.Host;
    Connection.Port := FParams.Port;
    Connection.ReadTimeout := FSTimeout;
    Connection.Connect;
    Connection.UseNagle := False;
    IdBytes := StrToIdBytes(Command);
    Connection.IOHandler.Write(IdBytes, Length(IdBytes));

    Result := '';
    for i := 1 to Sizeof(Header) do
      Result := Result + Char(Connection.Socket.ReadByte);
    Move(Result[1], Header, Sizeof(Header));
    for i := 0 to Header.Size-1 do
      Result := Result + Char(Connection.Socket.ReadByte);
    Logger.DebugData('<- ', Result);
    Connection.Disconnect;
  finally
    Connection.Free;
  end;
end;

function TFSService.GetLogger: TLogFile;
begin
  Result := Device.Context.Logger;
end;

end.
