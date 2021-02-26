unit SerialPort;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs, SysConst, Variants, ActiveX,
  // 3'd
  TntClasses, DBT,
  // This
  LogFile, DeviceNotification, PortUtil, TextReport, PrinterPort,
  WException, TntSysUtils, gnugettext;

type
  { TSerialPort }

  TSerialPort = class(TInterfacedObject, IPrinterPort)
  private
    FID: Integer;
    FHandle: THandle;
    FTimeout: DWORD;
    FBaudRate: DWORD;
    FPortNumber: Integer;
    FOpenCount: Integer;
    FCommProp: TCommProp;
    FLock: TCriticalSection;
    FReport: TTextReport;
    FReconnectPort: Boolean;
    FNotification: TDeviceNotification;
    FLogger: ILogFile;

    procedure CheckOpened;
    procedure CreateHandle;
    procedure ReadCommConfig;
    function GetHandle: THandle;
    procedure UpdateCommProperties;
    function GetOpened: Boolean;
    function GetDeviceName: AnsiString;
    procedure UpdateDCB(BaudRate: DWORD);
    procedure SetBaudRate(Value: DWORD);
    procedure SetPortNumber(Value: Integer);
    procedure DeviceChanged(Sender: TObject; dbt: Integer);
    procedure DoClose;

    property Logger: ILogFile read FLogger;
    function GetTimeout: DWORD;
    procedure SetTimeout(Value: DWORD);
    function GetPortNumber: Integer;
    function GetBaudRate: DWORD;
  public
    constructor Create(APortNumber: Integer; ALogger: ILogFile);
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    procedure Purge;
    procedure Flush;
    procedure Lock;
    procedure Unlock;
    procedure Write(const Data: AnsiString);
    function Read(Count: DWORD): AnsiString;
    procedure SetCmdTimeout(Value: DWORD);
    function ReadChar(var C: Char): Boolean;
    function GetPortName: AnsiString;

    property Opened: Boolean read GetOpened;
    property Timeout: DWORD read GetTimeout write SetTimeout;
    property BaudRate: DWORD read GetBaudRate write SetBaudRate;
    property PortNumber: Integer read GetPortNumber write SetPortNumber;
    property ReconnectPort: Boolean read FReconnectPort write FReconnectPort;
  end;

  ENoPortError = class(WideException);

  { ESerialPortError }

  ESerialPortError = class(WideException)
  public
    ErrorCode: Integer;
  end;

function GetSerialPort(PortNumber: Integer; Logger: ILogFile): IPrinterPort;

implementation

var
  Ports: TThreadList;

function GetSerialPort(PortNumber: Integer; Logger: ILogFile): IPrinterPort;
var
  i: Integer;
  List: TList;
  Port: TSerialPort;
begin
  List := Ports.LockList;
  try
    for i := 0 to List.Count-1 do
    begin
      Result := TSerialPort(List[i]);
      if Result.PortName = IntToStr(PortNumber) then
      begin
        Exit;
      end;
    end;
    Port := TSerialPort.Create(PortNumber, Logger);
    List.Add(Port);
    Result := Port;
  finally
    Ports.UnlockList;
  end;
end;

function GetProviderSubTypeText(Value: Integer): AnsiString;
begin
  case Value of
    PST_UNSPECIFIED     : Result := 'PST_UNSPECIFIED';
    PST_RS232           : Result := 'PST_RS232';
    PST_PARALLELPORT    : Result := 'PST_PARALLELPORT';
    PST_RS422           : Result := 'PST_RS422';
    PST_RS423           : Result := 'PST_RS423';
    PST_RS449           : Result := 'PST_RS449';
    PST_MODEM           : Result := 'PST_MODEM';
    PST_FAX             : Result := 'PST_FAX';
    PST_SCANNER         : Result := 'PST_SCANNER';
    PST_NETWORK_BRIDGE  : Result := 'PST_NETWORK_BRIDGE';
    PST_LAT             : Result := 'PST_LAT';
    PST_TCPIP_TELNET    : Result := 'PST_TCPIP_TELNET';
    PST_X25             : Result := 'PST_X25';
  else
    Result := 'Unknown provider ID';
  end;
end;

function TestMask(Value, Mask: Integer): Boolean;
begin
  Result := (Value and Mask) <> 0;
end;

function StringsToText(Strings: TTntStrings): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Strings.Count-1 do
  begin
    if Result <> '' then Result := Result + ', ';
    Result := Result + Strings[i];
  end;
end;

function GetProviderCapabilitiesText(Value: Integer): AnsiString;
var
  Strings: TTntStrings;
begin
  Result := '';
  Strings := TTntStringList.Create;
  try
    if TestMask(Value, PCF_DTRDSR) then Strings.Add('PCF_DTRDSR');
    if TestMask(Value, PCF_RTSCTS) then Strings.Add('PCF_RTSCTS');
    if TestMask(Value, PCF_RLSD) then Strings.Add('PCF_RLSD');
    if TestMask(Value, PCF_PARITY_CHECK) then Strings.Add('PCF_PARITY_CHECK');
    if TestMask(Value, PCF_XONXOFF) then Strings.Add('PCF_XONXOFF');
    if TestMask(Value, PCF_SETXCHAR) then Strings.Add('PCF_SETXCHAR');
    if TestMask(Value, PCF_TOTALTIMEOUTS) then Strings.Add('PCF_TOTALTIMEOUTS');
    if TestMask(Value, PCF_INTTIMEOUTS) then Strings.Add('PCF_INTTIMEOUTS');
    if TestMask(Value, PCF_SPECIALCHARS) then Strings.Add('PCF_SPECIALCHARS');
    if TestMask(Value, PCF_16BITMODE) then Strings.Add('PCF_16BITMODE');

    Result := StringsToText(Strings);
  finally
    Strings.Free;
  end;
end;

function GetSettableParamsText(const Value: Integer): AnsiString;
var
  Strings: TTntStrings;
begin
  Result := '';
  Strings := TTntStringList.Create;
  try
    if TestMask(Value, SP_PARITY) then Strings.Add('SP_PARITY');
    if TestMask(Value, SP_BAUD) then Strings.Add('SP_BAUD');
    if TestMask(Value, SP_DATABITS) then Strings.Add('SP_DATABITS');
    if TestMask(Value, SP_STOPBITS) then Strings.Add('SP_STOPBITS');
    if TestMask(Value, SP_HANDSHAKING) then Strings.Add('SP_HANDSHAKING');
    if TestMask(Value, SP_PARITY_CHECK) then Strings.Add('SP_PARITY_CHECK');
    if TestMask(Value, SP_RLSD) then Strings.Add('SP_RLSD');

    Result := StringsToText(Strings);
  finally
    Strings.Free;
  end;
end;

function GetBaudRatesText(const Value: Integer): AnsiString;
var
  Strings: TTntStrings;
begin
  Result := '';
  Strings := TTntStringList.Create;
  try
    if TestMask(Value, BAUD_075) then Strings.Add('BAUD_075');
    if TestMask(Value, BAUD_110) then Strings.Add('BAUD_110');
    if TestMask(Value, BAUD_134_5) then Strings.Add('BAUD_134_5');
    if TestMask(Value, BAUD_150) then Strings.Add('BAUD_150');
    if TestMask(Value, BAUD_300) then Strings.Add('BAUD_300');
    if TestMask(Value, BAUD_600) then Strings.Add('BAUD_600');
    if TestMask(Value, BAUD_1200) then Strings.Add('BAUD_1200');
    if TestMask(Value, BAUD_1800) then Strings.Add('BAUD_1800');
    if TestMask(Value, BAUD_2400) then Strings.Add('BAUD_2400');
    if TestMask(Value, BAUD_4800) then Strings.Add('BAUD_4800');
    if TestMask(Value, BAUD_7200) then Strings.Add('BAUD_7200');
    if TestMask(Value, BAUD_9600) then Strings.Add('BAUD_9600');
    if TestMask(Value, BAUD_14400) then Strings.Add('BAUD_14400');
    if TestMask(Value, BAUD_19200) then Strings.Add('BAUD_19200');
    if TestMask(Value, BAUD_38400) then Strings.Add('BAUD_38400');
    if TestMask(Value, BAUD_56K) then Strings.Add('BAUD_56K');
    if TestMask(Value, BAUD_128K) then Strings.Add('BAUD_128K');
    if TestMask(Value, BAUD_115200) then Strings.Add('BAUD_115200');
    if TestMask(Value, BAUD_57600) then Strings.Add('BAUD_57600');
    if TestMask(Value, BAUD_USER) then Strings.Add('BAUD_USER');

    Result := StringsToText(Strings);
  finally
    Strings.Free;
  end;
end;

function GetDataBitsText(const Value: Integer): AnsiString;
var
  Strings: TTntStrings;
begin
  Result := '';
  Strings := TTntStringList.Create;
  try
    if TestMask(Value, DATABITS_5) then Strings.Add('DATABITS_5');
    if TestMask(Value, DATABITS_6) then Strings.Add('DATABITS_6');
    if TestMask(Value, DATABITS_7) then Strings.Add('DATABITS_7');
    if TestMask(Value, DATABITS_8) then Strings.Add('DATABITS_8');
    if TestMask(Value, DATABITS_16) then Strings.Add('DATABITS_16');
    if TestMask(Value, DATABITS_16X) then Strings.Add('DATABITS_16X');

    Result := StringsToText(Strings);
  finally
    Strings.Free;
  end;
end;

function GetStopParityText(const Value: Integer): AnsiString;
var
  Strings: TTntStrings;
begin
  Result := '';
  Strings := TTntStringList.Create;
  try
    if TestMask(Value, STOPBITS_10) then Strings.Add('STOPBITS_10');
    if TestMask(Value, STOPBITS_15) then Strings.Add('STOPBITS_15');
    if TestMask(Value, STOPBITS_20) then Strings.Add('STOPBITS_20');
    if TestMask(Value, PARITY_NONE) then Strings.Add('PARITY_NONE');
    if TestMask(Value, PARITY_ODD) then Strings.Add('PARITY_ODD');
    if TestMask(Value, PARITY_EVEN) then Strings.Add('PARITY_EVEN');
    if TestMask(Value, PARITY_MARK) then Strings.Add('PARITY_MARK');
    if TestMask(Value, PARITY_SPACE) then Strings.Add('PARITY_SPACE');

    Result := StringsToText(Strings);
  finally
    Strings.Free;
  end;
end;

function GetLastErrorText: AnsiString;
begin
  Result := Tnt_WideFormat(SOSError, [GetLastError, SysErrorMessage(GetLastError)]);
end;

procedure RaiseSerialPortError;
var
  LastError: Integer;
  Error: ESerialPortError;
begin
  LastError := GetLastError;
  if LastError <> 0 then
    Error := ESerialPortError.CreateResFmt(@SOSError, [LastError,
      SysErrorMessage(LastError)])
  else
    Error := ESerialPortError.CreateRes(@SUnkOSError);
  Error.ErrorCode := LastError;
  raise Error;
end;

{ TSerialPort }

constructor TSerialPort.Create(APortNumber: Integer; ALogger: ILogFile);
const
  LastID: Integer = 0;
begin
  inherited Create;
  FLogger := ALogger;
  Inc(LastID); FID := LastID;
  Logger.Debug('TSerialPort.Create. ID: ' + IntToStr(FID));

  FHandle := INVALID_HANDLE_VALUE;
  FLock := TCriticalSection.Create;
  FReport := TTextReport.Create(20);
  FNotification := TDeviceNotification.Create(Logger);
  FNotification.OnDeviceChange := DeviceChanged;
  FReconnectPort := True;
  BaudRate := CBR_115200;
  PortNumber := APortNumber;
end;

destructor TSerialPort.Destroy;
begin
  Ports.Remove(Self);
  Close;
  FLock.Free;
  FReport.Free;
  FNotification.Free;
  FLogger := nil;
  inherited Destroy;
end;

procedure TSerialPort.DeviceChanged(Sender: TObject; dbt: Integer);
begin
  if dbt = DBT_DEVICEREMOVECOMPLETE then
  begin
    if Opened then
    begin
      Logger.Debug('Device closed by deviceremovecomplete');
    end;
    DoClose;
  end;
end;

function TSerialPort.GetHandle: THandle;
begin
  Open;
  Result := FHandle;
end;

procedure TSerialPort.UpdateDCB(BaudRate: DWORD);
const
  fBinary              = $00000001;
var
  DCB: TDCB;
begin
  FillChar(DCB, SizeOf(TDCB), #0);
  DCB.Bytesize := 8;
  DCB.Parity := NOPARITY;
  DCB.Stopbits := ONESTOPBIT;
  DCB.BaudRate := BaudRate;
  DCB.Flags := FBinary;

  if not SetCommState(GetHandle, DCB) then
  begin
    Logger.Error('SetCommState function failed.');
    Logger.Error(GetLastErrorText);
    RaiseSerialPortError;
  end;
end;

function TSerialPort.GetOpened: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

function TSerialPort.GetDeviceName: AnsiString;
begin
  Result := 'COM' + IntToStr(PortNumber);
end;

procedure TSerialPort.CreateHandle;
var
  i: Integer;
  DevName: AnsiString;
const
  MaxReconnectCount = 3;
begin
  DevName := '\\.\' + GetDeviceName;
  for i := 1 to MaxReconnectCount do
  begin
    FHandle := CreateFile(PCHAR(DevName), GENERIC_READ or GENERIC_WRITE, 0, nil,
      OPEN_EXISTING, 0, 0);

    if FHandle <> INVALID_HANDLE_VALUE then Break;

    if GetLastError = ERROR_ACCESS_DENIED then
      raise ENoPortError.Create(_('Port is opened by another application'));

    if ReconnectPort and (i <> MaxReconnectCount) then
    begin
      EnableComPort(PortNumber, False);
      Sleep(100);
      EnableComPort(PortNumber, True);
    end;
  end;

  if FHandle = INVALID_HANDLE_VALUE then
  begin
    Logger.Error(Format('CreateFile ERROR: 0x%.8x, %s', [
      GetLastError, SysErrorMessage(GetLastError)]));

    raise ENoPortError.Create(_('Cannot open port'));
  end;
end;

procedure TSerialPort.CheckOpened;
begin
  if not OPened then
    raise ESerialPortError.Create(_('Port not opened'));
end;

procedure TSerialPort.ReadCommConfig;
var
  dwSize: DWORD;
  CommConfig: TCommConfig;
begin
  Logger.Debug(Logger.Separator);
  dwSize := Sizeof(CommConfig);

  if not GetCommConfig(GetHandle, CommConfig, dwSize) then
  begin
    Logger.Error('GetCommConfig function failed');
    Logger.Error(GetLastErrorText);
    RaiseSerialPortError;
  end;

  Logger.Debug(Format('ProvSubType      : 0x%.8x, %s', [
    CommConfig.dwProviderSubType,
    GetProviderSubTypeText(CommConfig.dwProviderSubType)]));
end;

procedure TSerialPort.UpdateCommProperties;
var
  i: Integer;
begin
  CheckOpened;

  FReport.Clear;
  if not GetCommProperties(GetHandle, FCommProp) then
  begin
    Logger.Error('GetCommProperties function failed');
    Logger.Error(GetLastErrorText);
    RaiseSerialPortError;
  end;

  FReport.Add('PacketLength', FCommProp.wPacketLength);
  FReport.Add('PacketVersion', FCommProp.wPacketVersion);
  FReport.Add('ServiceMask', FCommProp.dwServiceMask);
  FReport.Add('MaxTxQueue', FCommProp.dwMaxTxQueue);
  FReport.Add('MaxRxQueue', FCommProp.dwMaxRxQueue);
  FReport.Add('MaxBaud', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.dwMaxBaud,
    GetBaudRatesText(FCommProp.dwMaxBaud)]));

  FReport.Add('ProvSubType', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.dwProvSubType,
    GetProviderSubTypeText(FCommProp.dwProvSubType)]));

  FReport.Add('ProvCapabilities', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.dwProvCapabilities,
    GetProviderCapabilitiesText(FCommProp.dwProvCapabilities)]));

  FReport.Add('SettableParams', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.dwSettableParams,
    GetSettableParamsText(FCommProp.dwSettableParams)]));

  FReport.Add('SettableBaud', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.dwSettableBaud,
    GetBaudRatesText(FCommProp.dwSettableBaud)]));

  FReport.Add('SettableData', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.wSettableData,
    GetDataBitsText(FCommProp.wSettableData)]));

  FReport.Add('SettableStopParity', Tnt_WideFormat('0x%.8x, %s', [
    FCommProp.wSettableStopParity,
    GetStopParityText(FCommProp.wSettableStopParity)]));

  FReport.Add('CurrentTxQueue', FCommProp.dwCurrentTxQueue);
  FReport.Add('CurrentRxQueue', FCommProp.dwCurrentRxQueue);
  FReport.Add('ProvSpec1', FCommProp.dwProvSpec1);
  FReport.Add('ProvSpec2', FCommProp.dwProvSpec2);
  FReport.Add('ProvChar', String(FCommProp.wcProvChar));

  for i := 0 to FReport.Lines.Count-1 do
  begin
    Logger.Debug(FReport.Lines[i]);
  end;
end;

procedure TSerialPort.Open;
begin
  Lock;
  try
    if not Opened then
    begin
      CreateHandle;
      Inc(FOpenCount);
      UpdateDCB(FBaudRate);
      SetupComm(GetHandle, 1024, 1024);

      ReadCommConfig;
      UpdateCommProperties;
      FNotification.Install(FHandle); 
    end;
  finally
    Unlock;
  end;
end;

procedure TSerialPort.Close;
begin
  Lock;
  try
    if Opened then
    begin
      Dec(FOpenCount);
      if FOpenCount <= 0 then
      begin
        FOpenCount := 0;
        DoClose;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TSerialPort.DoClose;
begin
  Lock;
  try
    if Opened then
    begin
      FNotification.Uninstall;
      CloseHandle(FHandle);
      Dec(FOpenCount);
      FHandle := INVALID_HANDLE_VALUE;
    end;
  finally
    Unlock;
  end;
end;

procedure TSerialPort.Write(const Data: AnsiString);
var
  Count: DWORD;
  WriteCount: DWORD;
begin
  Lock;
  try
    Count := Length(Data);
    if Count = 0 then Exit;

    if not WriteFile(GetHandle, Data[1], Count, WriteCount, nil) then
    begin
      Logger.Error('WriteFile function failed.');
      Logger.Error(GetLastErrorText);
      RaiseSerialPortError;
    end;

    if Count <> WriteCount then
    begin
      Logger.Error('Write failed. ' + _('Device not connected'));
      raise ESerialPortError.Create(_('Device not connected'));
    end;
  finally
    Unlock;
  end;
end;

function TSerialPort.ReadChar(var C: Char): Boolean;
var
  ReadCount: DWORD;
begin
  Lock;
  try
    if not ReadFile(GetHandle, C, 1, ReadCount, nil) then
    begin
      Logger.Error('ReadFile function failed.');
      Logger.Error(GetLastErrorText);
      RaiseSerialPortError;
    end;
    Result := ReadCount = 1;
  finally
    Unlock;
  end;
end;

function TSerialPort.Read(Count: DWORD): AnsiString;
var
  ReadCount: DWORD;
begin
  Lock;
  try
    Result := '';
    if Count = 0 then Exit;

    SetLength(Result, Count);
    if not ReadFile(GetHandle, Result[1], Count, ReadCount, nil) then
    begin
      Logger.Error('ReadFile function failed.');
      Logger.Error(GetLastErrorText);
      RaiseSerialPortError;
    end;

    SetLength(Result, ReadCount);
    if ReadCount <> Count then
    begin
      Logger.Error(Format('Read data: %d <> %d', [ReadCount, Count]));
      Logger.Error('Read error. ' + _('Device not connected'));
      raise ESerialPortError.Create(_('Device not connected'));
    end;
  finally
    Unlock;
  end;
end;

procedure TSerialPort.SetCmdTimeout(Value: DWORD);
var
  TimeOuts: TCommTimeOuts;
begin
  Lock;
  try
    // Default timeouts
    TimeOuts.ReadIntervalTimeout := Value;
    TimeOuts.ReadTotalTimeoutMultiplier := 0;
    TimeOuts.ReadTotalTimeoutConstant := Value;
    TimeOuts.WriteTotalTimeoutMultiplier := Timeout;
    TimeOuts.WriteTotalTimeoutConstant := 0;

    if not SetCommTimeOuts(GetHandle, TimeOuts) then
    begin
      Logger.Error('SetCommTimeOuts function failed');
      Logger.Error(GetLastErrorText);
      RaiseSerialPortError;
    end;
  finally
    Unlock;
  end;
end;

procedure TSerialPort.Purge;
begin
  Lock;
  try
    PurgeComm(GetHandle, PURGE_RXABORT + PURGE_RXCLEAR + PURGE_TXABORT +
      PURGE_TXCLEAR);
  finally
    Unlock;
  end;
end;

procedure TSerialPort.Lock;
begin
  FLock.Enter;
end;

procedure TSerialPort.Unlock;
begin
  FLock.Leave;
end;

procedure TSerialPort.SetPortNumber(Value: Integer);
begin
  if Value <> PortNumber then
  begin
    FPortNumber := Value;
    Close;
  end;
end;

procedure TSerialPort.SetBaudRate(Value: DWORD);
begin
  if Value <> BaudRate then
  begin
    FBaudRate := Value;
    if Opened then UpdateDCB(FBaudRate);
  end;
end;

procedure TSerialPort.Flush;
begin
  Lock;
  try
    FlushFileBuffers(GetHandle);
  finally
    Unlock;
  end;
end;

function TSerialPort.GetTimeout: DWORD;
begin
  Result := FTimeout;
end;

procedure TSerialPort.SetTimeout(Value: DWORD);
begin
  FTimeout := Value;
end;

function TSerialPort.GetPortNumber: Integer;
begin
  Result := FPortNumber;
end;

function TSerialPort.GetPortName: AnsiString;
begin
  Result := IntToStr(PortNumber);
end;

function TSerialPort.GetBaudRate: DWORD;
begin
  Result := FBaudRate;
end;

initialization
  Ports := TThreadList.Create;

finalization
  Ports.Free;

end.
