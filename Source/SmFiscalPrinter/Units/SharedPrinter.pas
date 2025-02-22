unit SharedPrinter;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs, Graphics, ActiveX,
  // 3'd
  TntClasses, IdGlobal, IdIcmpClient,
  // Opos
  Opos, OposFptr, OposFptrUtils, OposException, OposSemaphore,
  // This
  FiscalPrinterDevice, PrinterTypes, PrinterConnection,
  LogFile, SerialPorts, StringUtils, FiscalPrinterStatistics,
  FiscalPrinterTypes, FixedStrings, FileUtils, DeviceTables, CommunicationError,
  PrinterProtocol1, PrinterProtocol2, TCPConnection, DCOMConnection, VSysUtils,
  PayType, DebugUtils, ByteUtils, DriverTypes, NotifyThread, NotifyLink,
  PrinterParameters, PrinterParametersX, DriverError, DirectIOAPI,
  ReceiptReportFilter, EscFilter, SerialPort, SocketPort, PrinterPort,
  WException, TntSysUtils, gnugettext;

type
  { TSharedPrinter }

  TSharedPrinter = class(TInterfacedObject, IInterface, ISharedPrinter)
  private
    FOpened: Boolean;
    FConnectCount: Integer;
    FDeviceName: WideString;
    FConnected: Boolean;
    FCheckTotal: Boolean;
    FHeader: TFixedStrings;
    FLock: TCriticalSection;
    FTrailer: TFixedStrings;
    FDeviceMetrics: TDeviceMetrics;
    FLongPrinterStatus: TLongPrinterStatus;
    FOnProgress: TProgressEvent;
    FPollEnabled: Boolean;
    FPollEnabledCount: Integer;
    FPingThread: TNotifyThread;
    FDeviceThread: TNotifyThread;
    FStatusLinks: TNotifyLinks;
    FConnectLinks: TNotifyLinks;
    FStation: Integer;
    FPreLine: WideString;
    FPostLine: WideString;
    FNumHeaderLines: Integer;
    FNumTrailerLines: Integer;
    FEJStatus1: TEJStatus1;
    FEJActivation: TEJActivation;
    FEscFilter: TEscFilter;
    FSemaphore: TOposSemaphore;

    FFilter: IFiscalPrinterFilter;
    FDevice: IFiscalPrinterDevice;
    FConnection: IPrinterConnection;

    procedure Lock;
    procedure Unlock;
    procedure SearchDevice;
    function GetPrintWidth: Integer;
    function GetPrintWidthInDots: Integer;
    function SearchBaudRate(PortNumber: Integer): Boolean;
    function ConnectDevice(PortNumber, BaudRate: Integer): Boolean;

    procedure ReadTables;
    function ReadRecFormatItem(Row: Integer): TRecFormatItem;
    function ReadRecFormatTable: TRecFormatTable;
    function CreateConnection: IPrinterConnection;
    function GetDeviceName: WideString;
    function GetCheckTotal: Boolean;
    procedure SetCheckTotal(const Value: Boolean);
    function GetHeader: TFixedStrings;
    function GetTrailer: TFixedStrings;
    function GetOnProgress: TProgressEvent;
    procedure SetOnProgress(const Value: TProgressEvent);
    function GetPollEnabled: Boolean;
    procedure SetPollEnabled(const Value: Boolean);
    procedure DeviceProc(Sender: TObject);
    function GetStatusLinks: TNotifyLinks;
    function GetPostLine: WideString;
    function GetPreLine: WideString;
    procedure SetPostLine(const Value: WideString);
    procedure SetPreLine(const Value: WideString);
    function GetSeparatorData(SeparatorType, PrintWidth: Integer): WideString;
    procedure LoadParams(const DeviceName: WideString);
    function GetNumHeaderLines: Integer;
    function GetNumTrailerLines: Integer;
    function GetDeviceMetrics: TDeviceMetrics;
    function GetLongPrinterStatus: TLongPrinterStatus;
    function GetEJStatus1: TEJStatus1;
    procedure DeviceConnect(Sender: TObject);
    procedure DeviceDisconnect(Sender: TObject);
    function GetAppAmountDecimalPlaces: Integer;
    function GetDevice: IFiscalPrinterDevice;
    procedure SetDeviceName(const Value: WideString);
    procedure SleepEx(TimeinMilliseconds: Integer);
    function GetLogger: ILogFile;
    function CreateProtocol(Port: IPrinterPort): IPrinterConnection;
    procedure DevicePrinterStatus(Sender: TObject);
    procedure PingProc(Sender: TObject);
  public
    constructor Create(const ADeviceName: WideString);
    destructor Destroy; override;

    function FormatText(const Value: WideString;
      RecFormatSize: Integer): WideString;

    procedure ProgressEvent(Progress: Integer);
    procedure Open(const DeviceName: WideString);
    procedure Close;
    procedure ReleaseDevice;
    procedure ClaimDevice(Timeout: Integer);
    procedure OpenReceipt(ReceiptType: Integer);

    procedure Connect;
    procedure CutPaper;
    procedure Disconnect;
    procedure PrintZReport;
    procedure ReceiptCancel;
    procedure SaveParameters;
    procedure PrintFakeReceipt;
    procedure PrintCancelReceipt;
    procedure Check(Value: Integer);
    procedure CashIn(Amount: Int64);
    procedure CashOut(Amount: Int64);
    procedure Sale(Operation: TPriceReg);
    procedure Buy(Operation: TPriceReg);
    procedure PrintSubtotal(Value: Int64);
    procedure RetBuy(Operation: TPriceReg);
    procedure Storno(Operation: TPriceReg);
    procedure RetSale(Operation: TPriceReg);
    procedure PrintRecText(const Text: WideString);
    procedure LoadLogo(const FileName: WideString);
    procedure PrintLines(const Line1, Line2: WideString);
    procedure ReceiptClose(Params: TCloseReceiptParams);
    procedure ReceiptCharge(Operation: TAmountOperation);
    procedure ReceiptDiscount(Operation: TAmountOperation);
    procedure PrintLine(Stations: Integer; const Line: WideString);

    procedure PrintText(const Text: WideString); overload;
    procedure PrintText(Station: Integer; const Text: WideString); overload;
    procedure PrintText(const Text: WideString; Station, Font: Integer;
      Alignment: TTextAlignment = taLeft); overload;


    procedure PrintBoldString(Flags: Byte; const Text: WideString);
    procedure ReceiptStornoDiscount(Operation: TAmountOperation);
    procedure ReceiptStornoCharge(Operation: TAmountOperation);
    procedure PrintCurrency(const Line: WideString; Value: Currency);
    procedure PrintDocHeader(const DocName: WideString; DocNumber: Word);
    procedure PrintImage(const FileName: WideString);
    procedure PrintImageScale(const FileName: WideString; Scale: Integer);

    function FormatBoldLines(const Line1, Line2: WideString): WideString;
    procedure AddStatusLink(Link: TNotifyLink);
    procedure AddConnectLink(Link: TNotifyLink);
    procedure RemoveStatusLink(Link: TNotifyLink);
    function GetStation: Integer;
    function GetFont: Integer;
    procedure SetStation(Value: Integer);
    procedure PrintLogo;
    procedure ClearLogo;
    procedure PrintSeparator(SeparatorType, SeparatorHeight: Integer);
    procedure UpdateParams;
    function GetEJActivation: TEJActivation;
    function CurrencyToInt(Value: Currency): Int64;
    function IntToCurrency(Value: Int64): Currency;
    function IsDecimalPoint: Boolean;
    function CurrencyToStr(Value: Currency): WideString;
    function GetFilter: TEscFilter;

    procedure ReleasePrinter;
    procedure ClaimPrinter(Timeout: Integer);
    function GetPrinterSemaphoreName: WideString;
    procedure SetDevice(Value: IFiscalPrinterDevice);
    function GetConnection: IPrinterConnection;
    procedure SetConnection(const Value: IPrinterConnection);
    function GetParameters: TPrinterParameters;
    procedure StartPing;
    procedure StopPing;

    property Opened: Boolean read FOpened;
    property Header: TFixedStrings read GetHeader;
    property Trailer: TFixedStrings read GetTrailer;
    property PrintWidth: Integer read GetPrintWidth;
    property Station: Integer read FStation write FStation;
    property StatusLinks: TNotifyLinks read GetStatusLinks;
    property PrintWidthInDots: Integer read GetPrintWidthInDots;
    property Device: IFiscalPrinterDevice read FDevice write FDevice;
    property CheckTotal: Boolean read GetCheckTotal write SetCheckTotal;
    property OnProgress: TProgressEvent read GetOnProgress write SetOnProgress;
    property PollEnabled: Boolean read GetPollEnabled write SetPollEnabled;
    property PreLine: WideString read GetPreLine write SetPreLine;
    property PostLine: WideString read GetPostLine write SetPostLine;
    property NumHeaderLines: Integer read GetNumHeaderLines;
    property NumTrailerLines: Integer read GetNumTrailerLines;
    property DeviceMetrics: TDeviceMetrics read GetDeviceMetrics;
    property LongPrinterStatus: TLongPrinterStatus read GetLongPrinterStatus;
    property EJStatus1: TEJStatus1 read GetEJStatus1;
    property EJActivation: TEJActivation read GetEJActivation;
    property ConnectLinks: TNotifyLinks read FConnectLinks;
    property DeviceName: WideString read GetDeviceName write SetDeviceName;
    property Parameters: TPrinterParameters read GetParameters;
    property Logger: ILogFile read GetLogger;
  end;

function GetPrinter(const DeviceName: WideString): ISharedPrinter;

implementation

function GetStringsCount(const Text: WideString): Integer;
var
  Strings: TTntStrings;
begin
  Strings := TTntStringList.Create;
  try
    Strings.Text := Text;
    Result := Strings.Count;
  finally
    Strings.Free;
  end;
end;

var
  Printers: TThreadList;

function GetPrintersCount: Integer;
var
  List: TList;
begin
  List := Printers.LockList;
  try
    Result := List.Count;
  finally
    Printers.UnlockList;
  end;
end;

function GetPrinter(const DeviceName: WideString): ISharedPrinter;
var
  i: Integer;
  List: TList;
  Port: TSharedPrinter;
begin
  List := Printers.LockList;
  try
    for i := 0 to List.Count-1 do
    begin
      Result := TSharedPrinter(List[i]);
      if Result.DeviceName = DeviceName then
      begin
        Exit;
      end;
    end;
    Port := TSharedPrinter.Create(DeviceName);
    Printers.Add(Port);
    Result := Port;
  finally
    Printers.UnlockList;
  end;
end;

{ TSharedPrinter }

constructor TSharedPrinter.Create(const ADeviceName: WideString);
begin
  inherited Create;
  FDeviceName := ADeviceName;
  FSemaphore := TOposSemaphore.Create;
  FStatusLinks := TNotifyLinks.Create;
  FConnectLinks := TNotifyLinks.Create;
  FLock := TCriticalSection.Create;
  FHeader := TFixedStrings.Create;
  FTrailer := TFixedStrings.Create;
  FStation := PRINTER_STATION_REC;
  FNumHeaderLines := 4;
  FNumTrailerLines := 4;

  FDevice := TFiscalPrinterDevice.Create;
  FDevice.OnConnect := DeviceConnect;
  FDevice.OnDisconnect := DeviceDisconnect;
  FDevice.OnPrinterStatus := DevicePrinterStatus;
end;

destructor TSharedPrinter.Destroy;
begin
  ODS('TSharedPrinter.Destroy.0');
  Printers.Remove(Self);
  StopPing;
  SetPollEnabled(False);
  FPingThread.Free;
  FDeviceThread.Free;

  if FFilter <> nil then
  begin
    FDevice.RemoveFilter(FFilter);
    FFilter := nil;
  end;
  FPollEnabled := False;
  FLock.Free;
  FHeader.Free;
  FTrailer.Free;
  FEscFilter.Free;
  FSemaphore.Free;
  FConnection := nil;
  FDevice := nil;
  FStatusLinks.Free;
  FConnectLinks.Free;
  inherited Destroy;
  ODS('TSharedPrinter.Destroy.1');
end;

procedure TSharedPrinter.SetDevice(Value: IFiscalPrinterDevice);
begin
  FDevice := Value;
end;

function TSharedPrinter.GetFilter: TEscFilter;
begin
  if FEscFilter = nil then
    FEscFilter := TEscFilter.Create(Self);
  Result := FEscFilter;
end;


procedure TSharedPrinter.DeviceConnect(Sender: TObject);
begin
  FConnectLinks.DoNotify;
end;

procedure TSharedPrinter.DevicePrinterStatus(Sender: TObject);
begin
  FStatusLinks.DoNotify;
end;

procedure TSharedPrinter.DeviceDisconnect(Sender: TObject);
begin
  FConnectLinks.DoNotify;
end;

function TSharedPrinter.GetEJActivation: TEJActivation;
begin
  Result := FEJActivation;
end;

function TSharedPrinter.GetEJStatus1: TEJStatus1;
begin
  Result := FEJStatus1;
end;

function TSharedPrinter.GetLongPrinterStatus: TLongPrinterStatus;
begin
  Result := FLongPrinterStatus;
end;

function TSharedPrinter.GetDeviceMetrics: TDeviceMetrics;
begin
  Result := FDeviceMetrics;
end;

function TSharedPrinter.GetNumHeaderLines: Integer;
begin
  Result := FNumHeaderLines;
end;

function TSharedPrinter.GetNumTrailerLines: Integer;
begin
  Result := FNumTrailerLines;
end;

function TSharedPrinter.GetCheckTotal: Boolean;
begin
  Result := FCheckTotal;
end;

procedure TSharedPrinter.SetCheckTotal(const Value: Boolean);
begin
  FCheckTotal := Value;
end;

function TSharedPrinter.GetDeviceName: WideString;
begin
  Result := FDeviceName;
end;

procedure TSharedPrinter.SetDeviceName(const Value: WideString);
begin
  FDeviceName := Value;
end;

function TSharedPrinter.CreateProtocol(Port: IPrinterPort): IPrinterConnection;
begin
  case Parameters.PrinterProtocol of
    PrinterProtocol10: Result := TPrinterProtocol1.Create(Logger, Port);
    PrinterProtocol20: Result := TPrinterProtocol2.Create(Logger, Port, Parameters);
  else
    raiseException(_('Invalid printer protocol'));
  end;
end;

function TSharedPrinter.CreateConnection: IPrinterConnection;
var
  Port: IPrinterPort;
begin
  case Parameters.ConnectionType of
    ConnectionTypeLocal:
    begin
      Port := GetSerialPort(Parameters.PortNumber, Logger);
      Result := CreateProtocol(Port);
    end;
    ConnectionTypeDCOM:
      Result := TDCOMConnection.Create(
        Parameters.RemoteHost,
        Parameters.RemotePort,
        Parameters.PortNumber,
        Parameters.BaudRate,
        Parameters.ByteTimeout);

    ConnectionTypeTCP:
      Result := TTCPConnection.Create(
        Parameters.RemoteHost,
        Parameters.RemotePort,
        Parameters.PortNumber,
        Parameters.BaudRate,
        Parameters.ByteTimeout,
        Logger);

    ConnectionTypeSocket:
    begin
      Port := TSocketPort.Create(Parameters, Logger);
      Result := CreateProtocol(Port);
    end;
  else
    raiseException(_('Invalid connection type'));
  end;
end;

procedure TSharedPrinter.Close;
begin
  try
    FOpened := False;
    FConnection := nil;
    Device.Close;
  except
    on E: Exception do
    begin
      Logger.Error('TSharedPrinter.Close: ', E);
    end;
  end;
end;

procedure TSharedPrinter.Open(const DeviceName: WideString);
begin
  if Opened then Exit;

  try
    FConnected := False;
    LoadParams(DeviceName);
    if Parameters.ReceiptReportEnabled then
    begin
      FFilter := TReceiptReportFilter.Create(FDevice, Parameters);
      Device.AddFilter(FFilter);
    end;

    FOpened := True;
  except
    on E: Exception do
    begin
      Logger.Error('TFiscalPrinterParameters.Load: ', E);
      RaiseOposException(OPOS_ORS_CONFIG, GetExceptionMessage(E));
    end;
  end;
end;

procedure TSharedPrinter.UpdateParams;
begin
  LoadParams(DeviceName);
end;

procedure TSharedPrinter.LoadParams(const DeviceName: WideString);
begin
  LoadParameters(Parameters, DeviceName, Logger);
  Logger.MaxCount := Parameters.LogMaxCount;
  Logger.Enabled := Parameters.LogFileEnabled;
  Logger.FilePath := Parameters.LogFilePath;
  Logger.DeviceName := DeviceName;

  Device.SetSysPassword(Parameters.SysPassword);
  Device.SetUsrPassword(Parameters.UsrPassword);
  case Parameters.HeaderType of
    HeaderTypePrinter:
    begin
      FNumHeaderLines := Device.Model.NumHeaderLines;
      FNumTrailerLines := Device.Model.NumTrailerLines;
      Header.Count := FNumHeaderLines;
      Trailer.Count := FNumTrailerLines;
      Header.Text := Parameters.Header;
      Trailer.Text := Parameters.Trailer;
    end;
    HeaderTypeDriver:
    begin
      if Parameters.SetHeaderLineEnabled then
        FNumHeaderLines := Parameters.NumHeaderLines
      else
        FNumHeaderLines := GetStringsCount(Parameters.Header);

      if Parameters.SetTrailerLineEnabled then
        FNumTrailerLines := Parameters.NumTrailerLines
      else
        FNumTrailerLines := GetStringsCount(Parameters.Trailer);

      Header.Count := FNumHeaderLines;
      Trailer.Count := FNumTrailerLines;
      Header.Text := Parameters.Header;
      Trailer.Text := Parameters.Trailer;
    end;
  else
    FNumHeaderLines := 0;
    FNumTrailerLines := 0;
    Header.Count := 0;
    Trailer.Count := 0;
    Header.Text := '';
    Trailer.Text := '';
  end;
end;

procedure TSharedPrinter.CutPaper;
begin
  case Parameters.CutType of
    DRIVER_CUTTYPE_FULL,
    DRIVER_CUTTYPE_PARTIAL:
    begin
      try
        Device.CutPaper(Parameters.CutType);
        //Statistics.PaperCutted;
      except
        on E: EFiscalPrinterException do
        begin
          //Statistics.PaperCutFailed;
          raise;
        end;
      end;
    end;
    DRIVER_CUTTYPE_NONE:
    begin
      (*
      if Device.Model.CombLineNumber > 0 then
      begin
        Device.FeedPaper(GetStation, Device.Model.CombLineNumber);
      end;
      *)
    end;
  end;
end;

procedure TSharedPrinter.Lock;
begin
  FLock.Enter;
end;

procedure TSharedPrinter.Unlock;
begin
  FLock.Leave;
end;

function TSharedPrinter.SearchBaudRate(PortNumber: Integer): Boolean;
var
  i: Integer;
  ByteTimeout: Integer;
  MaxRetryCount: Integer;
begin
  Logger.Debug('TSharedPrinter.SearchBaudRate');

  Result := False;
  MaxRetryCount := Parameters.MaxRetryCount;
  ByteTimeout := Parameters.ByteTimeout;
  Parameters.MaxRetryCount := 1;
  Parameters.ByteTimeout := 200;
  try
    for i := Low(PrinterBaudRates) to High(PrinterBaudRates) do
    begin
      if PrinterBaudRates[i] <> Parameters.BaudRate then
      begin
        Result := ConnectDevice(PortNumber, PrinterBaudRates[i]);
        if Result then Break;
      end;
    end;
  finally
    Parameters.ByteTimeout := ByteTimeout;
    Parameters.MaxRetryCount := MaxRetryCount;
  end;
end;

function TSharedPrinter.ConnectDevice(
  PortNumber, BaudRate: Integer): Boolean;
var
  PortParams: TPortParams;
  PrinterBaudRate: Integer;
begin
  Logger.Debug('TSharedPrinter.ConnectDevice');

  PrinterBaudRate := BaudRate;
  try
    Device.OpenPort(PortNumber, BaudRate, Parameters.ByteTimeout);
    FLongPrinterStatus := Device.ReadLongStatus;
    // check if port supports baudrate
    if BaudRate <> Parameters.BaudRate then
    begin
      try
        Device.OpenPort(PortNumber, Parameters.BaudRate, Parameters.ByteTimeout);
        // Baudrate supported - use it
        PrinterBaudRate := Parameters.BaudRate;
      except
        // Selected baudrate is not supported in the system/hardware
        // Use baudrate on wich printer was found
        PrinterBaudRate := BaudRate;
      end;
      Device.OpenPort(PortNumber, BaudRate, Parameters.ByteTimeout);
    end;
    // always set port parameters
    if FLongPrinterStatus.PortNumber = 0 then
    begin
      PortParams.BaudRate := PrinterBaudRate;
      PortParams.Timeout := Parameters.DeviceByteTimeout;
      if Device.SetPortParams(FLongPrinterStatus.PortNumber, PortParams) = 0 then
      begin
        if BaudRate <> PrinterBaudRate then
        begin
          // To ensure that last ACK is delivered
          Sleep(100);
          Device.OpenPort(PortNumber, PrinterBaudRate, Parameters.ByteTimeout);
          Device.ReadPrinterStatus;
        end;
      end;
    end;
    Result := True;
  except
    on E: ECommunicationError do
    begin
      Logger.Error('ConnectDevice', E);
      Result := False;
    end;
  end;
end;

procedure TSharedPrinter.SearchDevice;
var
  i: Integer;
  Ports: TTntStringList;
  PortNumber: Integer;
begin
  if ConnectDevice(Parameters.PortNumber, Parameters.BaudRate) then Exit;

  if Parameters.IsLocalConnection then
  begin
    if Parameters.SearchByPortEnabled then
    begin
      Ports := TTntStringList.Create;
      try
        TSerialPorts.GetSystemPorts(Ports);
        for i := 0 to Ports.Count-1 do
        begin
          PortNumber := Integer(Ports.Objects[i]);
          if Parameters.SearchByBaudRateEnabled then
          begin
            if SearchBaudRate(PortNumber) then Exit;
          end else
          begin
            if ConnectDevice(PortNumber, Parameters.BaudRate) then Exit;
          end;
        end;
      finally
        Ports.Free;
      end;
    end else
    begin
      if Parameters.SearchByBaudRateEnabled then
      begin
        if SearchBaudRate(Parameters.PortNumber) then Exit;
      end;
    end;
  end;
  RaiseOposException(OPOS_E_NOHARDWARE, _('No connection'));
end;

function TSharedPrinter.ReadRecFormatItem(Row: Integer): TRecFormatItem;
begin
  Result.Line := Device.ReadTableInt(PRINTER_TABLE_RECFORMAT, Row, 1);
  Result.Offset := Device.ReadTableInt(PRINTER_TABLE_RECFORMAT, Row, 2);
  Result.Size := Device.ReadTableInt(PRINTER_TABLE_RECFORMAT, Row, 3);
  Result.Align := Device.ReadTableInt(PRINTER_TABLE_RECFORMAT, Row, 4);
  Result.Name := Device.ReadTableStr(PRINTER_TABLE_RECFORMAT, Row, 5);
end;

function TSharedPrinter.ReadRecFormatTable: TRecFormatTable;
begin
  Result.ItemText := ReadRecFormatItem(1);
  Result.Quantity := ReadRecFormatItem(2);
  Result.Department := ReadRecFormatItem(3);
  Result.SaleAmount := ReadRecFormatItem(4);
  Result.StornoText := ReadRecFormatItem(5);
  Result.DiscountText := ReadRecFormatItem(6);
  Result.DiscountName := ReadRecFormatItem(7);
  Result.DiscountAmount := ReadRecFormatItem(8);
  Result.ChargeText := ReadRecFormatItem(9);
  Result.ChargeName := ReadRecFormatItem(10);
  Result.ChargeAmount := ReadRecFormatItem(11);
  Result.DscStornoText := ReadRecFormatItem(12);
  Result.DscStornoName := ReadRecFormatItem(13);
  Result.DscStornoAmount := ReadRecFormatItem(14);
  Result.ChrStornoText := ReadRecFormatItem(15);
  Result.ChrStornoName := ReadRecFormatItem(16);
  Result.ChrStornoAmount := ReadRecFormatItem(17);
end;

procedure TSharedPrinter.ReadTables;
var
  Tables: TDeviceTables;
begin
  Tables := Device.Tables;
  if Device.ReadParameter(PARAMID_RECFORMAT_ENABLED) = 1 then
  begin
    if Tables.Params.RecFormatEnabled then
    begin
      Tables.RecFormat := ReadRecFormatTable;
    end;
  end;
  Tables.TaxInfo := Device.TaxInfoList;
  Device.Tables := Tables;
end;

procedure TSharedPrinter.Connect;
begin
  Lock;
  try
    Inc(FConnectCount);
    if FConnected then Exit;

    SearchDevice;
    FDeviceMetrics := Device.GetDeviceMetrics;
    if Device.ReadPrinterStatus.Flags.EJPresent then
    begin
      Device.GetEJStatus1(FEJStatus1);
      if FEJStatus1.Flags.Activated then
      begin
        FEJActivation := Device.QueryEJActivation;
      end;
    end;
    Device.Connect;
    FConnected := True;
  finally
    Unlock;
  end;
end;

procedure TSharedPrinter.Disconnect;
begin
  Lock;
  try
    Device.Disconnect;
    Dec(FConnectCount);
    if FConnected and (FConnectCount = 0) then
    begin
      FConnected := False;
    end;
  finally
    Unlock;
  end;
end;

procedure TSharedPrinter.PrintLines(const Line1, Line2: WideString);
begin
  PrintRecText(Device.FormatLines(Line1, Line2));
end;

procedure TSharedPrinter.PrintLine(Stations: Integer; const Line: WideString);
begin
  Device.PrintStringFont(Stations, Parameters.FontNumber, Line);
end;

procedure TSharedPrinter.PrintText(const Text: WideString);
var
  Data: TTextREc;
begin
  Data.Text := Text;
  Data.Station := GetStation;
  Data.Font := GetFont;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

procedure TSharedPrinter.PrintText(Station: Integer; const Text: WideString);
var
  Data: TTextREc;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := GetFont;
  Data.Alignment := taLeft;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

procedure TSharedPrinter.PrintText(const Text: WideString;
  Station, Font: Integer; Alignment: TTextAlignment = taLeft);
var
  Data: TTextREc;
begin
  Data.Text := Text;
  Data.Station := Station;
  Data.Font := Font;
  Data.Alignment := Alignment;
  Data.Wrap := Parameters.WrapText;
  Device.PrintText(Data);
end;

procedure TSharedPrinter.PrintRecText(const Text: WideString);
begin
  PrintText(Text);
end;

procedure TSharedPrinter.PrintCurrency(const Line: WideString; Value: Currency);
begin
  PrintRecText(Device.FormatLines(Line, '=' + CurrencyToStr(Value)));
end;

procedure TSharedPrinter.PrintCancelReceipt;
begin
  PrintLine(GetStation, Parameters.VoidRecText);
end;

procedure TSharedPrinter.PrintDocHeader(const DocName: WideString;
  DocNumber: Word);
begin
  Device.PrintDocHeader(DocName, DocNumber);
end;

procedure TSharedPrinter.OpenReceipt(ReceiptType: Integer);
begin
  Device.OpenReceipt(ReceiptType);
end;

procedure TSharedPrinter.PrintFakeReceipt;
begin
  Device.OpenReceipt(0);
  Device.CancelReceipt;
  Device.CutPaper(Parameters.CutType);
end;

function TSharedPrinter.GetPrintWidth: Integer;
begin
  Result := Device.GetPrintWidth;
end;

procedure TSharedPrinter.Check(Value: Integer);
begin
  Device.Check(Value);
end;

function TSharedPrinter.FormatBoldLines(const Line1, Line2: WideString): WideString;
begin
  Result := Device.FormatBoldLines(Line1, Line2);
end;

procedure TSharedPrinter.PrintBoldString(Flags: Byte; const Text: WideString);
begin
  Device.PrintBoldString(Flags, Text);
end;

procedure TSharedPrinter.CashIn(Amount: Int64);
begin
  Device.CashIn(Amount);
end;

procedure TSharedPrinter.CashOut(Amount: Int64);
begin
  Device.CashOut(Amount);
end;

procedure TSharedPrinter.PrintZReport;
begin
  Device.PrintZReport;
end;

procedure TSharedPrinter.ReceiptCancel;
begin
  Device.Check(Device.ReceiptCancel);
end;

function TSharedPrinter.FormatText(const Value: WideString;
  RecFormatSize: Integer): WideString;
begin
  if Device.Tables.Params.RecFormatEnabled then
  begin
    Result := Copy(Value, 1, RecFormatSize);
  end else
  begin
    Result := Copy(Value, 1, Device.GetPrintWidth);
  end;
end;

procedure TSharedPrinter.ReceiptCharge(Operation: TAmountOperation);
begin
  Device.Check(Device.ReceiptCharge(Operation));
end;

procedure TSharedPrinter.ReceiptClose(Params: TCloseReceiptParams);
var
  R: TCloseReceiptResult;
begin
  Device.Check(Device.ReceiptClose(Params, R));
end;

procedure TSharedPrinter.ReceiptDiscount(Operation: TAmountOperation);
begin
  Device.Check(Device.ReceiptDiscount(Operation));
end;

procedure TSharedPrinter.ReceiptStornoCharge(Operation: TAmountOperation);
begin
  Device.Check(Device.ReceiptStornoCharge(Operation));
end;

procedure TSharedPrinter.ReceiptStornoDiscount(Operation: TAmountOperation);
begin
  Device.ReceiptStornoDiscount(Operation);
end;

procedure TSharedPrinter.RetSale(Operation: TPriceReg);
begin
  Device.Check(Device.RetSale(Operation));
end;

procedure TSharedPrinter.Sale(Operation: TPriceReg);
begin
  Device.Check(Device.Sale(Operation));
end;

procedure TSharedPrinter.Buy(Operation: TPriceReg);
begin
  Device.Check(Device.Buy(Operation));
end;

procedure TSharedPrinter.RetBuy(Operation: TPriceReg);
begin
  Device.Check(Device.RetBuy(Operation));
end;

procedure TSharedPrinter.Storno(Operation: TPriceReg);
begin
  Device.Check(Device.Storno(Operation));
end;

procedure TSharedPrinter.PrintSubtotal(Value: Int64);
begin
  PrintCurrency(Parameters.SubtotalText, IntToCurrency(Value));
end;

procedure TSharedPrinter.ClaimDevice(Timeout: Integer);
begin
  Device.Open(GetConnection);
  Device.ClaimDevice(Parameters.PortNumber, Timeout);
end;

procedure TSharedPrinter.ReleaseDevice;
begin
  Device.ReleaseDevice;
end;

// Mode: 0x04, amode: 0x01, Flags: 0x04B2
// Mode: 0x04, amode: 0x01, Flags: 0x04B2
// 0000 0100 1011 0010

function TSharedPrinter.GetHeader: TFixedStrings;
begin
  Result := FHeader;
end;

function TSharedPrinter.GetTrailer: TFixedStrings;
begin
  Result := FTrailer;
end;

procedure TSharedPrinter.SaveParameters;
begin
  try
    PrinterParametersX.SaveUsrParameters(Parameters, DeviceName, Logger);
  except
    on E: Exception do
    begin
      Logger.Error('SaveParameters', E);
    end;
  end;
end;

procedure TSharedPrinter.ProgressEvent(Progress: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Progress);
end;

procedure TSharedPrinter.LoadLogo(const FileName: WideString);
var
  ImageHeight: Integer;
begin
  ImageHeight := Device.LoadImage(FileName, 1);
  Parameters.IsLogoLoaded := True;
  Parameters.LogoFileName := FileName;
  Parameters.LogoSize := ImageHeight;
  SaveParameters;
end;

procedure TSharedPrinter.PrintImage(const FileName: WideString);
var
  StartLine: Integer;
begin
  StartLine := 1;
  if Parameters.IsLogoLoaded and (Parameters.LogoSize > 0) then
  begin
    StartLine := Parameters.LogoSize + 1;
  end;
  Device.PrintImage(FileName, StartLine);
end;

procedure TSharedPrinter.PrintImageScale(const FileName: WideString; Scale: Integer);
var
  StartLine: Integer;
begin
  StartLine := 1;
  if Parameters.IsLogoLoaded and (Parameters.LogoSize > 0) then
  begin
    StartLine := Parameters.LogoSize + 1;
  end;
  Device.PrintImageScale(FileName, StartLine, Scale);
end;

function TSharedPrinter.GetOnProgress: TProgressEvent;
begin
  Result := FOnProgress;
end;

procedure TSharedPrinter.SetOnProgress(const Value: TProgressEvent);
begin
  FOnProgress := Value;
end;

function TSharedPrinter.GetPollEnabled: Boolean;
begin
  Result := FPollEnabled;
end;

procedure TSharedPrinter.SetPollEnabled(const Value: Boolean);
begin
  if Value then
  begin
    Inc(FPollEnabledCount)
  end else
  begin
    Dec(FPollEnabledCount);
  end;

  if Value <> PollEnabled then
  begin
    if Value then
    begin
      FDeviceThread.Free;
      FDeviceThread := TNotifyThread.Create(True);
      FDeviceThread.OnExecute := DeviceProc;
      FDeviceThread.Resume;
      FPollEnabled := Value;
    end else
    begin
      if FPollEnabledCount = 0 then
      begin
        FPollEnabled := False;
        FDeviceThread.Free;
        FDeviceThread := nil;
      end;
    end;
  end;
end;

procedure TSharedPrinter.SleepEx(TimeinMilliseconds: Integer);
var
  TickCount: Integer;
begin
  TickCount := Integer(GetTickCount);
  repeat
    Sleep(20);
    if not FPollEnabled then Exit;
  until Integer(GetTickCount) > (TickCount + TimeinMilliseconds);
end;

procedure TSharedPrinter.DeviceProc(Sender: TObject);
begin
  Logger.Debug('TSharedPrinter.DeviceProc.Start');
  try
    while FPollEnabled do
    begin
      try
        Device.Lock;
        try
          Device.ReadPrinterStatus;
        finally
          Device.Unlock;
        end;
      except
        on E: Exception do
        begin
          Logger.Error('TSharedPrinter.DeviceProc', E);
        end;
      end;
      SleepEx(Parameters.PollIntervalInSeconds * 1000);
    end;
  except
    on E: Exception do
      Logger.Error('TSharedPrinter.DeviceProc: ', E);
  end;
  Logger.Debug('TSharedPrinter.DeviceProc.End');
end;

function TSharedPrinter.GetStatusLinks: TNotifyLinks;
begin
  Result := FStatusLinks;
end;

procedure TSharedPrinter.AddStatusLink(Link: TNotifyLink);
begin
  FStatusLinks.Add(Link);
end;

procedure TSharedPrinter.AddConnectLink(Link: TNotifyLink);
begin
  FConnectLinks.Add(Link);
end;

procedure TSharedPrinter.RemoveStatusLink(Link: TNotifyLink);
begin
  FStatusLinks.Remove(Link);
end;

function TSharedPrinter.GetPrintWidthInDots: Integer;
begin
  Result := Device.ReadFontInfo(GetFont).PrintWidth;
end;

function TSharedPrinter.GetStation: Integer;
begin
  Result := FStation;
end;

function TSharedPrinter.GetFont: Integer;
begin
  Result := Parameters.FontNumber;
end;

procedure TSharedPrinter.SetStation(Value: Integer);
begin
  FStation := Value;
end;

function TSharedPrinter.GetPostLine: WideString;
begin
  Result := FPostLine;
end;

function TSharedPrinter.GetPreLine: WideString;
begin
  Result := FPreLine;
end;

procedure TSharedPrinter.SetPostLine(const Value: WideString);
begin
  FPostLine := Value;
end;

procedure TSharedPrinter.SetPreLine(const Value: WideString);
begin
  FPreLine := Value;
end;

procedure TSharedPrinter.ClearLogo;
begin
  Parameters.LogoSize := 0;
  Parameters.IsLogoLoaded := False;
  SaveParameters;
end;

procedure TSharedPrinter.PrintLogo;
begin
  if (Parameters.LogoSize > 0) then
  begin
    Device.PrintGraphics(1, Parameters.LogoSize);
  end;
end;

function TSharedPrinter.GetSeparatorData(
  SeparatorType, PrintWidth: Integer): WideString;
const
  SEPARATOR_PATTERN_BLACK    = #$FF;
  SEPARATOR_PATTERN_WHITE    = #$00;
  SEPARATOR_PATTERN_DOTTED_1 = #$FF#$FF#$FF#$00#$00#$00;
  SEPARATOR_PATTERN_DOTTED_2 = #$FF#$FF#$FF#$FF#$00#$00#$00#$00;
var
  Pattern: WideString;
begin
  case SeparatorType of
    DIO_SEPARATOR_BLACK    : Pattern := SEPARATOR_PATTERN_BLACK;
    DIO_SEPARATOR_WHITE    : Pattern := SEPARATOR_PATTERN_WHITE;
    DIO_SEPARATOR_DOTTED_1 : Pattern := SEPARATOR_PATTERN_DOTTED_1;
    DIO_SEPARATOR_DOTTED_2 : Pattern := SEPARATOR_PATTERN_DOTTED_2;
  else
    Pattern := SEPARATOR_PATTERN_BLACK;
  end;
  Result := '';
  while Length(Result) < PrintWidth do
    Result := Result + Pattern;
  Result := Copy(Result, 1, PrintWidth);
end;

procedure TSharedPrinter.PrintSeparator(
  SeparatorType, SeparatorHeight: Integer);
var
  Data: WideString;
begin
  Data := GetSeparatorData(SeparatorType, GetPrintWidthInDots div 8);
  Check(Device.PrintBarLine(SeparatorHeight, Data));
  Device.WaitForPrinting;
end;

function TSharedPrinter.IsDecimalPoint: Boolean;
begin
  Result := Device.AmountDecimalPlaces = 2;
end;

function TSharedPrinter.CurrencyToInt(Value: Currency): Int64;
begin
  Result := Trunc(Value);
  if IsDecimalPoint then
    Result := Trunc(Value*100);
end;

function TSharedPrinter.IntToCurrency(Value: Int64): Currency;
begin
  Result := Value;
  if IsDecimalPoint then
    Result := Value/100;
end;

function TSharedPrinter.GetAppAmountDecimalPlaces: Integer;
begin
  case Parameters.AmountDecimalPlaces of
    AmountDecimalPlaces_0: Result := 0;
    AmountDecimalPlaces_2: Result := 2;
  else
    Result := Device.AmountDecimalPlaces;
  end;
end;

function TSharedPrinter.CurrencyToStr(Value: Currency): WideString;
var
  SaveDecimalSeparator: Char;
begin
  if GetAppAmountDecimalPlaces = 2 then
  begin
    SaveDecimalSeparator := DecimalSeparator;
    try
      DecimalSeparator := '.';
      Result := Tnt_WideFormat('%.2f', [Value]);
    finally
      DecimalSeparator := SaveDecimalSeparator;
    end;
  end else
  begin
    Result := IntToStr(CurrencyToInt(Value));
  end;
end;

function TSharedPrinter.GetPrinterSemaphoreName: WideString;
begin
  Result := 'PrinterSemaphore_' + FDeviceName;
end;

procedure TSharedPrinter.ClaimPrinter(Timeout: Integer);
begin
  FSemaphore.Claim(GetPrinterSemaphoreName, Timeout);
end;

procedure TSharedPrinter.ReleasePrinter;
begin
  FSemaphore.Release;
end;

function TSharedPrinter.GetConnection: IPrinterConnection;
begin
  if FConnection = nil then
    FConnection := CreateConnection;
  Result := FConnection;
end;

function TSharedPrinter.GetDevice: IFiscalPrinterDevice;
begin
  Result := FDevice;
end;


procedure TSharedPrinter.SetConnection(const Value: IPrinterConnection);
begin
  FConnection := Value;
end;

function TSharedPrinter.GetParameters: TPrinterParameters;
begin
  Result := FDevice.Parameters;
end;

function TSharedPrinter.GetLogger: ILogFile;
begin
  Result := Parameters.Logger;
end;

procedure TSharedPrinter.PingProc(Sender: TObject);

  procedure Sleep2(TimeinMilliseconds: Integer);
  var
    TickCount: Integer;
  begin
    TickCount := Integer(GetTickCount);
    repeat
      Sleep(20);
      if FPingThread.Terminated then Exit;
    until Integer(GetTickCount) > (TickCount + TimeinMilliseconds);
  end;

  function DoPing: Integer;
  var
    IcmpClient: TIdIcmpClient;
  begin
    IcmpClient := TIdIcmpClient.Create;
    try
      IcmpClient.Protocol := 1;
      IcmpClient.PacketSize := 24;
      IcmpClient.IPVersion := Id_IPv4;
      IcmpClient.Host := Parameters.RemoteHost;
      IcmpClient.Ping('32');
      Result := IcmpClient.ReplyStatus.MsRoundTripTime;
    finally
      IcmpClient.Free;
    end;
  end;

var
  TimeInMs: Integer;
begin
  Logger.Debug('TSharedPrinter.PingProc.Start');
  try
    while not FPingThread.Terminated do
    begin
      try
        TimeInMs := DoPing;
        Logger.Debug(Format('PING time: %d ms', [TimeInMs]));
      except
        on E: Exception do
        begin
          Logger.Error('PING failed: ' + GetExceptionMessage(E));
        end;
      end;
      Sleep2(3000);
    end;
  except
    on E: Exception do
      Logger.Error('TSharedPrinter.PingProc: ', E);
  end;
  Logger.Debug('TSharedPrinter.PingProc.End');
end;

procedure TSharedPrinter.StartPing;
begin
  FPingThread := TNotifyThread.Create(True);
  FPingThread.OnExecute := PingProc;
  FPingThread.Resume;
end;

procedure TSharedPrinter.StopPing;
begin
  FPingThread.Free;
  FPingThread := nil;
end;

initialization
  Printers := TThreadList.Create;

finalization
  Printers.Free;

end.
