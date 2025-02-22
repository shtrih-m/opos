unit FSService;

interface

uses
  // VCL
  Windows, SysUtils,
  // Indy
  IdTCPClient, IdGlobal,
  // This
  LogFile, NotifyThread, FiscalPrinterTypes, PrinterParameters,
  DriverError, WException;

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
    Host: AnsiString;
    Port: Integer;
    PollInterval: Integer; // in ms
  end;

  { TFSService }

  TFSService = class
  private
    FStopFlag: Boolean;
    FThread: TNotifyThread;
    FParams: TFSServiceParams;
    FDevice: IFiscalPrinterDevice;

    procedure Stop;
    procedure Start;
    procedure CheckFS;
    function GetLogger: ILogFile;
    function SendData(const Command: AnsiString): AnsiString;
    procedure ThreadProc(Sender: TObject);
    procedure Sleep2(Timeout: Integer);

    property Logger: ILogFile read GetLogger;
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
    Sleep(20);
    if FStopFlag then Break;
    if Integer(GetTickCount) > (TickCount + Timeout) then Break;
  end;
end;

procedure TFSService.ThreadProc(Sender: TObject);
begin
  try
    if Device.GetDeviceMetrics.DeviceName = '�����-������-�' then
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
      Logger.Error(GetExceptionMessage(E));
    end;
  end;
end;

procedure TFSService.CheckFS;
var
  Answer: AnsiString;
  BlockData: AnsiString;
begin
  try
    BlockData := FDevice.FSReadBlockData;
    if Length(BlockData) = 0 then Exit;

    Answer := SendData(BlockData);

    if Length(Answer) = 0 then Exit;
    FDevice.FSWriteBlockData(Answer);
  except
    on E: Exception do
    begin
      Logger.Error('FSService: ' + GetExceptionMessage(E));
      if E is EDriverError then raise;
    end;
  end;
end;

function StrToIdBytes(const Data: AnsiString): TIdBytes;
var
  i: Integer;
begin
  SetLength(Result, Length(Data));
  for i := 1 to Length(Data) do
    Result[i-1] := Ord(Data[i]);
end;

function IdBytesToStr(const Data: TIdBytes): AnsiString;
var
  i: Integer;
begin
  SetLength(Result, Length(Data));
  for i := 1 to Length(Data) do
    Result[i] := Chr(Data[i-1]);
end;

function TFSService.SendData(const Command: AnsiString): AnsiString;
const
  FSTimeout = 100000;
var
  i: Integer;
  IdBytes: TIdBytes;
  Header: TOFDHeader;
  Connection: TIdTCPClient;
begin
  Logger.Debug(Format('FSSErvice.Connect(%s:%d)', [FParams.Host, FParams.Port]));

  Connection := TIdTCPClient.Create(nil);
  try
    Connection.Host := FParams.Host;
    Connection.Port := FParams.Port;
    Connection.ReadTimeout := FSTimeout;
    Connection.Connect;
    Connection.UseNagle := False;
    IdBytes := StrToIdBytes(Command);

    Logger.Debug('TFSService.SendData');
    Logger.WriteTxData(Command);

    Connection.IOHandler.Write(IdBytes, Length(IdBytes));

    Result := '';
    for i := 1 to Sizeof(Header) do
      Result := Result + Char(Connection.Socket.ReadByte);
    Move(Result[1], Header, Sizeof(Header));
    for i := 0 to Header.Size-1 do
      Result := Result + Char(Connection.Socket.ReadByte);
    Logger.WriteRxData(Result);
    Connection.Disconnect;
  finally
    Connection.Free;
  end;
end;

function TFSService.GetLogger: ILogFile;
begin
  Result := Device.Context.Logger;
end;

end.
