unit MonitoringServer;

interface

uses
  // VCL
  Windows, SysUtils, WinSock, DateUtils,
  // This
  LogFile, NotifyThread, DebugUtils, SimpleSocket, FiscalPrinterTypes,
  PrinterTypes, BStrUtil, OposFptrUtils, TntSysUtils, WException;

type
  { TMonitoringServer }

  TMonitoringServer = class
  private
    function GetDevice: IFiscalPrinterDevice;
    function CommandFN_UNIXTIME: AnsiString;
    function CommandCNT_QUEUE: AnsiString;
    function CommandDateLast: AnsiString;
    function CommandCashReg(Command: AnsiString): AnsiString;
    function CommandOperReg(Command: AnsiString): AnsiString;
    function CommandOfdSEttings(Command: AnsiString): AnsiString;
    function GetLogger: ILogFile;
  private
    FPort: Integer;
    FThread: TNotifyThread;
    FPrinter: ISharedPrinter;

    procedure ThreadProc(Sender: TObject);
    function RunCommand(const Command: AnsiString): AnsiString;
    function CommandStatus: AnsiString;
    function IsCommand(const Text, Command: AnsiString): Boolean;
    function CommandECTP: AnsiString;
    function CommandInfo: AnsiString;
    function CommandFN: AnsiString;
    function CommandFWVersion: AnsiString;


    property Device: IFiscalPrinterDevice read GetDevice;
  public
    destructor Destroy; override;

    procedure Close;
    procedure Open(APort: Integer; APrinter: ISharedPrinter);
    property Logger: ILogFile read GetLogger;
  end;

implementation

{ TMonitoringServer }

destructor TMonitoringServer.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TMonitoringServer.Open(APort: Integer; APrinter: ISharedPrinter);
begin
  try
    FPort := APort;
    FPrinter := APrinter;
    FThread := TNotifyThread.Create(True);
    FThread.OnExecute := ThreadProc;
    FThread.Resume;
  except
    on E: Exception do
    begin
      Logger.Error('Failed to start server thread, ' + GetExceptionMessage(E));
    end;
  end;
end;

procedure TMonitoringServer.ThreadProc(Sender: TObject);
var
  Data: AnsiString;
  WSAData: TWSAData;
  ErrorCode: Integer;
  ServerSocket: TSimpleSocket;
  ClientSocket: TSimpleSocket;
const
  CRLF = #13#10;
  ReadTimeOut = 3000;
  WriteTimeOut = 3000;
begin
  ServerSocket := TSimpleSocket.Create;
  ClientSocket := TSimpleSocket.Create;
  try
    ErrorCode := WSAStartup($0101, WSAData);
    if ErrorCode <> 0 then
      raiseExceptionFmt('WSAStartup error, %d', [WSAGetLastError()]);

    ServerSocket.Socket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if ServerSocket.Socket = INVALID_SOCKET then
      raiseExceptionFmt('Socket failed with error: %d', [WSAGetLastError()]);

    if not ServerSocket.Bind(AF_INET, '127.0.0.1', FPort) then
      raiseExceptionFmt('Failed bind with error: %d', [WSAGetLastError()]);

    if not ServerSocket.Listen(SOMAXCONN) then
      raiseExceptionFmt('Failed listen with error: %d', [WSAGetLastError()]);

    while not FThread.Terminated do
    begin
      if ServerSocket.WaitRead(ReadTimeOut) = 1 then
      begin
        ClientSocket.Socket := ServerSocket.accept;
        if ClientSocket.Socket <> INVALID_SOCKET then
        begin
          if ClientSocket.WaitRead(ReadTimeOut) = 1 then
          begin
            Data := ClientSocket.ReadLn(CRLF);
            Data := RunCommand(TrimRight(Data));
            if Length(Data) > 0 then
            begin
              ClientSocket.Send(Data + CRLF);
              ClientSocket.WaitWrite(WriteTimeOut);
            end;
          end;
          ClientSocket.Disconnect;
          ClientSocket.Close;
        end;
      end;
    end;
    ServerSocket.Close;
  except
    on E: Exception do
    begin
      Logger.Error('Monitoring server = ' + GetExceptionMessage(E))
    end;
  end;
  ServerSocket.Free;
  ClientSocket.Free;
end;

procedure TMonitoringServer.Close;
begin
  try
    FThread.Free;
    FThread := nil;
    FPrinter := nil;
  except
    on E: Exception do
    begin
      Logger.Error(Format('Failed to close server, %s', [GetExceptionMessage(E)]));
    end;
  end;
end;

function TMonitoringServer.IsCommand(const Text, Command: AnsiString): Boolean;
begin
  Result := Pos(Command, Text) = 1;
end;

function TMonitoringServer.CommandStatus: AnsiString;
begin
  Result := 'OK';
  if FPrinter.Device.ResultCode <> 0 then
    Result := Tnt_WideFormat('Error (%d, %s)', [
      FPrinter.Device.ResultCode, FPrinter.Device.ResultText]);
end;

function TMonitoringServer.CommandInfo: AnsiString;
begin
  Result := Tnt_WideFormat('%s,%s,%.10d', [
    FPrinter.DeviceMetrics.DeviceName,
    FPrinter.LongPrinterStatus.SerialNumber,
    FPrinter.EJStatus1.EJNumber]);
end;

function TMonitoringServer.CommandECTP: AnsiString;
begin
  Result := Tnt_WideFormat('%s,%s,%s', [
    FPrinter.EJActivation.EJSerial,
    FPrinter.EJActivation.ActivationDate,
    FPrinter.EJActivation.ActivationTime]);
end;

function TMonitoringServer.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

(*

�������	���������
STATUS	    ��	Error (�������)
INFO	      ������ ���, ���. � ���, ����� �� (����������� ����� � �������)
FN	        ����� ��, ���� ����������� ��, ����� ����������� �� (����������� ����� � �������)
FN_UNIXTIME	���� ����������� �� � UNIXTIME
CNT_QUEUE	  ���-�� ����������, ��������� �������� � ��� (�������)
DATE_LAST	  ���� ���������� ������������� ��������� � ���

*)

function PrinterDateTimeToStr(Date: TPrinterDateTime): AnsiString;
begin
  Result := Tnt_WideFormat('%.2d.%.2d.%.4d,%.2d:%.2d', [
    Date.Day, Date.Month, Date.Year + 2000, Date.Hour, Date.Min]);
end;

function TMonitoringServer.CommandFN: AnsiString;
var
  FSState: TFSState;
  FSFiscalResult: TFSFiscalResult;
begin
  Device.Check(Device.FSReadState(FSState));
  Device.Check(Device.FSReadFiscalResult(FSFiscalResult));
  Result := Tnt_WideFormat('%s,%s', [
    FSState.FSNumber, PrinterDateTimeToStr(FSFiscalResult.Date)])
end;

function TMonitoringServer.CommandFWVersion: AnsiString;
var
  MainVersion1: WideString;
  MainVersion2: WideString;
  LoaderVersion: WideString;
  Status: TLongPrinterStatus;
begin
  Status := Device.ReadLongStatus; { !!! }

  MainVersion1 := Tnt_WideFormat('%s.%s %d %s', [
    Status.FirmwareVersionHi, Status.FirmwareVersionLo, Status.FirmwareBuild,
    EncodeOposDate(Status.FirmwareDate)]);

  MainVersion2 := Tnt_WideFormat('%s.%s %d %s', [
    Status.FMVersionHi, Status.FMVersionLo, Status.FMBuild,
    EncodeOposDate(Status.FMFirmwareDate)]);

  Device.Check(Device.ReadLoaderVersion(LoaderVersion));
  Result := Tnt_WideFormat('%s;%s;%s', [LoaderVersion, MainVersion1, MainVersion2]);
end;

// FN_UNIXTIME ���� ����������� �� � UNIXTIME
function TMonitoringServer.CommandFN_UNIXTIME: AnsiString;
var
  Date: TDateTime;
  D: TPrinterDateTime;
  FSFiscalResult: TFSFiscalResult;
begin
  Device.Check(Device.FSReadFiscalResult(FSFiscalResult));
  D := FSFiscalResult.Date;
  Date := EncodeDateTime(D.Year + 2000, D.Month, D.Day, D.Hour, D.Min, D.Sec, 0);
  Result := IntToStr(DateTimeToUnix(Date));
end;

// CNT_QUEUE ���-�� ����������, ��������� �������� � ��� (�������)
function TMonitoringServer.CommandCNT_QUEUE: AnsiString;
var
  FSCommStatus: TFSCommStatus;
begin
  Device.Check(Device.FSReadCommStatus(FSCommStatus));
  Result := IntToStr(FSCommStatus.DocumentCount);
end;

// DATE_LAST ���� ���������� ������������� ��������� � ���
function TMonitoringServer.CommandDateLast: AnsiString;
var
  FSCommStatus: TFSCommStatus;
begin
  Device.Check(Device.FSReadCommStatus(FSCommStatus));
  Result := PrinterDateTimeToStr(FSCommStatus.DocumentDate);
end;


// CASH_REG ����� ��������
// ���������� ��������� ��������
function TMonitoringServer.CommandCashReg(Command: AnsiString): AnsiString;
var
  V, Code: Integer;
begin
  Val(GetStringK(Command, 2, [' ']), V, Code);
  if Code <> 0 then
  begin
    Result := 'WRONG_PARAM';
    Exit;
  end;
  Result := IntToStr(Device.ReadCashReg2(V));
end;

(*
// ������� 19, ��������� ���
// ����� �������,���,����,������ ����,��� ����,���. ��������, ����.��������, ��������,��������
19,1,1,64,1,0,255,'������','connect.ofd-ya.ru'
19,1,2,2,0,0,65535,'����','7779'
19,1,3,2,0,0,65535,'������� ������ ������','1000'

������� ��������� ��� �� ������� 19, "��������� ���".
������: connect.ofd-ya.ru:7779 (������: ������:����)
*)

function TMonitoringServer.CommandOfdSEttings(Command: AnsiString): AnsiString;
var
  Port: AnsiString;
  Server: AnsiString;
begin
  Result := '';
  if Device.CapFiscalStorage then
  begin
    Server := Device.ReadTableStr(19, 1, 1);
    Port := Device.ReadTableStr(19, 1, 2);
    Result := Tnt_WideFormat('%s:%s', [Server, Port]);
  end;
end;

// OPER_REG ����� ��������
// ���������� ������������� ��������
function TMonitoringServer.CommandOperReg(Command: AnsiString): AnsiString;
var
  V, Code: Integer;
begin
  Val(GetStringK(Command, 2, [' ']), V, Code);
  if Code <> 0 then
  begin
    Result := 'WRONG_PARAM';
    Exit;
  end;
  Result := IntToStr(Device.ReadOperatingRegister(V));
end;

function TMonitoringServer.RunCommand(const Command: AnsiString): AnsiString;
begin
  Result := '';
  try
    if IsCommand(Command, 'STATUS') then
    begin
      Result := CommandStatus;
      Exit;
    end;
    if IsCommand(Command, 'INFO') then
    begin
      Result := CommandInfo;
      Exit;
    end;
    if IsCommand(Command, 'ECTP') then
    begin
      Result := CommandECTP;
      Exit;
    end;
    if IsCommand(Command, 'FN') then
    begin
      Result := CommandFN;
      Exit;
    end;
    if IsCommand(Command, 'FN_UNIXTIME') then
    begin
      Result := CommandFN_UNIXTIME;
      Exit;
    end;
    if IsCommand(Command, 'CNT_QUEUE') then
    begin
      Result := CommandCNT_QUEUE;
      Exit;
    end;
    if IsCommand(Command, 'DATE_LAST') then
    begin
      Result := CommandDateLast;
      Exit;
    end;
    if IsCommand(Command, 'CASH_REG') then
    begin
      Result := CommandCashReg(Command);
      Exit;
    end;
    if IsCommand(Command, 'OPER_REG') then
    begin
      Result := CommandOperReg(Command);
      Exit;
    end;
    if IsCommand(Command, 'OFD_SETTING') then
    begin
      Result := CommandOfdSEttings(Command);
      Exit;
    end;
    if IsCommand(Command, 'FWVERSION') then
    begin
      Result := CommandFWVersion;
      Exit;
    end;



  except
    on E: Exception do
    begin
      Result := 'ERROR ' + GetExceptionMessage(E);
    end;
  end;
end;

function TMonitoringServer.GetLogger: ILogFile;
begin
  Result := FPrinter.Parameters.Logger;
end;

end.
