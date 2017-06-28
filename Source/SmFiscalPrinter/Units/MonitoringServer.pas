unit MonitoringServer;

interface

uses
  // VCL
  Windows, SysUtils, WinSock, DateUtils,
  // This
  LogFile, NotifyThread, DebugUtils, SimpleSocket, FiscalPrinterTypes,
  PrinterTypes, BStrUtil;

type
  { TMonitoringServer }

  TMonitoringServer = class
  private
    function GetDevice: IFiscalPrinterDevice;
    function CommandFN_UNIXTIME: string;
    function CommandCNT_QUEUE: string;
    function CommandDateLast: string;
    function CommandCashReg(Command: string): string;
    function CommandOperReg(Command: string): string;
    function CommandOfdSEttings(Command: string): string;
    function GetLogger: TLogFile;
  private
    FPort: Integer;
    FThread: TNotifyThread;
    FPrinter: ISharedPrinter;

    procedure ThreadProc(Sender: TObject);
    function RunCommand(const Command: string): string;
    function CommandStatus: string;
    function IsCommand(const Text, Command: string): Boolean;
    function CommandECTP: string;
    function CommandInfo: string;
    function CommandFN: string;

    property Device: IFiscalPrinterDevice read GetDevice;
  public
    destructor Destroy; override;

    procedure Close;
    procedure Open(APort: Integer; APrinter: ISharedPrinter);
    property Logger: TLogFile read GetLogger;
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
      Logger.Error('Failed to start server thread, ' + E.Message);
    end;
  end;
end;

procedure TMonitoringServer.ThreadProc(Sender: TObject);
var
  Data: string;
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
      raise Exception.CreateFmt('WSAStartup error, %d', [WSAGetLastError()]);

    ServerSocket.Socket := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if ServerSocket.Socket = INVALID_SOCKET then
      raise Exception.CreateFmt('Socket failed with error: %d', [WSAGetLastError()]);

    if not ServerSocket.Bind(AF_INET, '127.0.0.1', FPort) then
      raise Exception.CreateFmt('Failed bind with error: %d', [WSAGetLastError()]);

    if not ServerSocket.Listen(SOMAXCONN) then
      raise Exception.CreateFmt('Failed listen with error: %d', [WSAGetLastError()]);

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
      Logger.Error('Monitoring server = ' + E.Message)
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
      Logger.Error(Format('Failed to close server, %s', [E.Message]));
    end;
  end;
end;

function TMonitoringServer.IsCommand(const Text, Command: string): Boolean;
begin
  Result := Pos(Command, Text) = 1;
end;

function TMonitoringServer.CommandStatus: string;
begin
  Result := 'OK';
  if FPrinter.Device.ResultCode <> 0 then
    Result := Format('Error (%d, %s)', [
      FPrinter.Device.ResultCode, FPrinter.Device.ResultText]);
end;

function TMonitoringServer.CommandInfo: string;
begin
  Result := Format('%s,%s,%.10d', [
    FPrinter.DeviceMetrics.DeviceName,
    FPrinter.LongPrinterStatus.SerialNumber,
    FPrinter.EJStatus1.EJNumber]);
end;

function TMonitoringServer.CommandECTP: string;
begin
  Result := Format('%s,%s,%s', [
    FPrinter.EJActivation.EJSerial,
    FPrinter.EJActivation.ActivationDate,
    FPrinter.EJActivation.ActivationTime]);
end;

function TMonitoringServer.GetDevice: IFiscalPrinterDevice;
begin
  Result := FPrinter.Device;
end;

(*

Команда	Результат
STATUS	    ОК	Error (причина)
INFO	      Модель ККМ, Зав. № ККМ, Номер ФН (разделитель точка с запятой)
FN	        Номер ФН, Дата активизации ФН, Время Активизации ФН (разделитель точка с запятой)
FN_UNIXTIME	Дата активизации ФН в UNIXTIME
CNT_QUEUE	  Кол-во документов, ожидающих отправки в ОФД (очередь)
DATE_LAST	  Дата последнего отправленного документа в ОФД

*)

function PrinterDateTimeToStr(Date: TPrinterDateTime): string;
begin
  Result := Format('%.2d.%.2d.%.4d,%.2d:%.2d', [
    Date.Day, Date.Month, Date.Year + 2000, Date.Hour, Date.Min]);
end;

function TMonitoringServer.CommandFN: string;
var
  FSState: TFSState;
  FSFiscalResult: TFSFiscalResult;
begin
  Device.Check(Device.FSReadState(FSState));
  Device.Check(Device.FSReadFiscalResult(FSFiscalResult));
  Result := Format('%s,%s', [
    FSState.FSNumber, PrinterDateTimeToStr(FSFiscalResult.Date)])
end;

// FN_UNIXTIME Дата активизации ФН в UNIXTIME
function TMonitoringServer.CommandFN_UNIXTIME: string;
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

// CNT_QUEUE Кол-во документов, ожидающих отправки в ОФД (очередь)
function TMonitoringServer.CommandCNT_QUEUE: string;
var
  FSCommStatus: TFSCommStatus;
begin
  Device.Check(Device.FSReadCommStatus(FSCommStatus));
  Result := IntToStr(FSCommStatus.DocumentCount);
end;

// DATE_LAST Дата последнего отправленного документа в ОФД
function TMonitoringServer.CommandDateLast: string;
var
  FSCommStatus: TFSCommStatus;
begin
  Device.Check(Device.FSReadCommStatus(FSCommStatus));
  Result := PrinterDateTimeToStr(FSCommStatus.DocumentDate);
end;


// CASH_REG Номер регистра
// Содержимое денежного регистра
function TMonitoringServer.CommandCashReg(Command: string): string;
var
  V, Code: Integer;
begin
  Val(GetStringK(Command, 2, [' ']), V, Code);
  if Code <> 0 then
  begin
    Result := 'WRONG_PARAM';
    Exit;
  end;
  Result := IntToStr(Device.ReadCashRegister(V));
end;

(*
// Таблица 19, Параметры офд
// Номер таблицы,Ряд,Поле,Размер поля,Тип поля,Мин. значение, Макс.значение, Название,Значение
19,1,1,64,1,0,255,'Сервер','connect.ofd-ya.ru'
19,1,2,2,0,0,65535,'Порт','7779'
19,1,3,2,0,0,65535,'Таймаут чтения ответа','1000'

Выводит настройки ОФД из таблицы 19, "Параметры ОФД".
Пример: connect.ofd-ya.ru:7779 (Формат: сервер:порт)
*)

function TMonitoringServer.CommandOfdSEttings(Command: string): string;
var
  Port: string;
  Server: string;
begin
  Result := '';
  if Device.CapFiscalStorage then
  begin
    Server := Device.ReadTableStr(19, 1, 1);
    Port := Device.ReadTableStr(19, 1, 2);
    Result := Format('%s:%s', [Server, Port]);
  end;
end;

// OPER_REG Номер регистра
// Содержимое операционного регистра
function TMonitoringServer.CommandOperReg(Command: string): string;
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

function TMonitoringServer.RunCommand(const Command: string): string;
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



  except
    on E: Exception do
    begin
      Result := 'ERROR ' + E.Message;
    end;
  end;
end;

function TMonitoringServer.GetLogger: TLogFile;
begin
  Result := FPrinter.Parameters.Logger;
end;

end.
