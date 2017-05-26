unit XmlPrinterParameters;

interface

uses
  // VCL
  Windows, SysUtils, Classes, IniFiles,
  // 3'd
  OmniXml, OmniXmlPersistent,
  // This
  Oposhi, PrinterTypes, PayType, LogFile, FileUtils;

const
  /////////////////////////////////////////////////////////////////////////////
  // ReceiptType constants

  ReceiptTypeNormal     = 0;
  ReceiptTypeSingleSale = 1;


  /////////////////////////////////////////////////////////////////////////////
  // CompatLevel constants

  CompatLevelNone   = 0;
  CompatLevel1      = 1;
  CompatLevel2      = 2;

  /////////////////////////////////////////////////////////////////////////////
  // Connection type constants

  ConnectionTypeLocal   = 0;
  ConnectionTypeDCOM    = 1;
  ConnectionTypeTCP     = 2;

  /////////////////////////////////////////////////////////////////////////////
  // Valid connecion types

  ConnectionTypes: array [0..2] of Integer =
  (
    ConnectionTypeLocal,
    ConnectionTypeDCOM,
    ConnectionTypeTCP
  );

  //////////////////////////////////////////////////////////////////////////////
  // Logo position constants

  LogoAfterHeader     = 0;    // Print logo after header
  LogoBeforeHeader    = 1;    // Print logo before header

  //////////////////////////////////////////////////////////////////////////////
  // Status command constants

  // Driver will select command to read printer status
  StatusCommandDriver = 0;

  // Short status command
  StatusCommandShort = 1;

  // Long status command
  StatusCommandLong = 2;


  /////////////////////////////////////////////////////////////////////////////
  // Header type constants

  HeaderTypePrinter = 0;
  HeaderTypeDriver  = 1;

  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';

  //////////////////////////////////////////////////////////////////////////////
  // ZeroReceiptType constants

  // Nornmal receipt
  ZERO_RECEIPT_NORMAL         = 0;

  // Document header is printed after all receipt items
  ZERO_RECEIPT_NONFISCAL      = 1;

  /////////////////////////////////////////////////////////////////////////////
  // "CCOType" constants

  CCOTYPE_RCS = 0;
  CCOTYPE_NCR = 1;

type
  { TPrinterParameters }

  TPrinterParameters = class(TPersistent)
  private
    FPayTypes: TPayTypes;
    FPortNumber: Integer;
    FBaudRate: Integer;
    FSysPassword: Integer;        // system administrator password
    FUsrPassword: Integer;        // operator password
    FSubtotalText: string;
    FCloseRecText: string;
    FVoidRecText: string;
    FFontNumber: Integer;
    FByteTimeout: Integer;              // driver byte timeout
    FDeviceByteTimeout: Integer;        // device byte timeout
    FMaxRetryCount: Integer;
    FPollInterval: Integer;             // printer polling interval
    FSearchByPortEnabled: Boolean;
    FSearchByBaudRateEnabled: Boolean;
    FStatusInterval: Integer;              // time to sleep when printer is busy
    FMonitoringEnabled: Boolean;
    FLogFileEnabled: Boolean;
    FCutType: Integer;                  // receipt cut type: full or partial
    FLogoPosition: Integer;             // Logo position
    FNumHeaderLines: Integer;           // number of header lines
    FNumTrailerLines: Integer;          // number of trailer lines
    FHeaderFont: Integer;
    FTrailerFont: Integer;
    FEncoding: Integer;

    //Training mode text strings
    FTrainModeText: string;
    FTrainCashInText: string;
    FTrainCashOutText: string;
    FTrainSaleText: string;
    FTrainVoidRecText: string;
    FTrainTotalText: string;
    FTrainCashPayText: string;
    FTrainPay2Text: string;
    FTrainPay3Text: string;
    FTrainPay4Text: string;
    FTrainChangeText: string;
    FTrainStornoText: string;
    FRemoteHost: string;
    FRemotePort: Integer;
    FConnectionType: Integer;
    FStatusCommand: Integer;
    FHeaderType: Integer;
    FBarcodePrintDelay: Integer;
    FCompatLevel: Integer;
    FCCOType: Integer;

    FHeader: string;
    FTrailer: string;
    FDepartment: Integer;
    FLogoCenter: Boolean;
    FHeaderPrinted: Boolean;
    FLogoSize: Integer;
    FLogoEnabled: Boolean;
    FReceiptType: Integer;
    FZeroReceiptType: Integer;
    FZeroReceiptNumber: Integer;
    FTableEditEnabled: Boolean;

    function GetIniFileName: string;
    function GetXmlFileName: string;
    procedure LogText(const Caption, Text: string);
    procedure SetLogoPosition(const Value: Integer);
    class function GetSysKeyName(const DeviceName: string): string;
    class function GetUsrKeyName(const DeviceName: string): string;
    procedure LoadFromXml(const DeviceName: string);
    procedure LoadUsrParameters(const DeviceName: string);
    procedure SaveUsrParameters(const DeviceName: string);
    procedure SaveToXml(const DeviceName: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetDefaults;
    procedure WriteLogParameters;
    procedure Load(const DeviceName: string);
    procedure Save(const DeviceName: string);
    class function DeviceExists(const DeviceName: string): Boolean;
  published
    property BaudRate: Integer read FBaudRate write FBaudRate;
    property PortNumber: Integer read FPortNumber write FPortNumber;
    property FontNumber: Integer read FFontNumber write FFontNumber;
    property SysPassword: Integer read FSysPassword write FSysPassword;
    property UsrPassword: Integer read FUsrPassword write FUsrPassword;
    property ByteTimeout: Integer read FByteTimeout write FByteTimeout;
    property StatusInterval: Integer read FStatusInterval write FStatusInterval;
    property SubtotalText: string read FSubtotalText write FSubtotalText;
    property CloseRecText: string read FCloseRecText write FCloseRecText;
    property VoidRecText: string read FVoidRecText write FVoidRecText;
    property PollInterval: Integer read FPollInterval write FPollInterval;
    property MaxRetryCount: Integer read FMaxRetryCount write FMaxRetryCount;
    property DeviceByteTimeout: Integer read FDeviceByteTimeout write FDeviceByteTimeout;
    property SearchByPortEnabled: Boolean read FSearchByPortEnabled write FSearchByPortEnabled;
    property SearchByBaudRateEnabled: Boolean read FSearchByBaudRateEnabled write FSearchByBaudRateEnabled;
    property MonitoringEnabled: Boolean read FMonitoringEnabled write FMonitoringEnabled;
    property CutType: Integer read FCutType write FCutType;

    property PayTypes: TPayTypes read FPayTypes;
    property Encoding: Integer read FEncoding write FEncoding;
    property RemoteHost: string read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property HeaderType: Integer read FHeaderType write FHeaderType;
    property HeaderFont: Integer read FHeaderFont write FHeaderFont;
    property TrailerFont: Integer read FTrailerFont write FTrailerFont;
    property TrainModeText: string read FTrainModeText write FTrainModeText;
    property LogoPosition: Integer read FLogoPosition write SetLogoPosition;
    property TrainSaleText: string read FTrainSaleText write FTrainSaleText;
    property TrainPay2Text: string read FTrainPay2Text write FTrainPay2Text;
    property TrainPay3Text: string read FTrainPay3Text write FTrainPay3Text;
    property TrainPay4Text: string read FTrainPay4Text write FTrainPay4Text;
    property StatusCommand: Integer read FStatusCommand write FStatusCommand;
    property TrainTotalText: string read FTrainTotalText write FTrainTotalText;
    property ConnectionType: Integer read FConnectionType write FConnectionType;
    property LogFileEnabled: Boolean read FLogFileEnabled write FLogFileEnabled;
    property NumHeaderLines: Integer read FNumHeaderLines write FNumHeaderLines;
    property TrainChangeText: string read FTrainChangeText write FTrainChangeText;
    property TrainStornoText: string read FTrainStornoText write FTrainStornoText;
    property TrainCashInText: string read FTrainCashInText write FTrainCashInText;
    property NumTrailerLines: Integer read FNumTrailerLines write FNumTrailerLines;
    property TrainCashOutText: string read FTrainCashOutText write FTrainCashOutText;
    property TrainVoidRecText: string read FTrainVoidRecText write FTrainVoidRecText;
    property TrainCashPayText: string read FTrainCashPayText write FTrainCashPayText;
    property BarcodePrintDelay: Integer read FBarcodePrintDelay write FBarcodePrintDelay;
    property CompatLevel: Integer read FCompatLevel write FCompatLevel;
    // User parameters
    property Header: string read FHeader write FHeader;
    property Trailer: string read FTrailer write FTrailer;
    property LogoSize: Integer read FLogoSize write FLogoSize;
    property LogoCenter: Boolean read FLogoCenter write FLogoCenter;
    property Department: Integer read FDepartment write FDepartment;
    property LogoEnabled: Boolean read FLogoEnabled write FLogoEnabled;
    property HeaderPrinted: Boolean read FHeaderPrinted write FHeaderPrinted;
    property ReceiptType: Integer read FReceiptType write FReceiptType;
    property ZeroReceiptType: Integer read FZeroReceiptType write FZeroReceiptType;
    property ZeroReceiptNumber: Integer read FZeroReceiptNumber write FZeroReceiptNumber;
    property CCOType: Integer read FCCOType write FCCOType;
    property TableEditEnabled: Boolean read FTableEditEnabled write FTableEditEnabled;
  end;

function ReadEncoding(const DeviceName: string): Integer;

implementation

resourcestring
  MsgKeyOpenError = 'Error opening registry key: %s';

const
  REG_KEY_PAYTYPES = 'PaymentTypes';
  DefRemoteHost = '';
  DefRemotePort = 0;
  DefConnectionType = ConnectionTypeLocal;


function ReadEncoding(const DeviceName: string): Integer;
var
  P: TPrinterParameters;
begin
  P := TPrinterParameters.Create;
  try
    P.Load(DeviceName);
    Result := P.Encoding;
  finally
    P.Free;
  end;
end;

{ TPrinterParameters }

constructor TPrinterParameters.Create;
begin
  inherited Create;
  FPayTypes := TPayTypes.Create;
  SetDefaults;
end;

destructor TPrinterParameters.Destroy;
begin
  FPayTypes.Free;
  inherited Destroy;
end;

procedure TPrinterParameters.SetDefaults;
var
  i: Integer;
  Lines: TStrings;
begin
  Logger.Debug('TPrinterParameters.SetDefaults');

  FPortNumber := 1;
  FBaudRate := CBR_4800;
  FSysPassword := 30;
  FUsrPassword := 1;
  FSubtotalText := 'SUBTOTAL';
  FCloseRecText := '';
  FVoidRecText := 'RECEIPT VOIDED';
  FFontNumber := 1;
  FByteTimeout := 1000;
  FDeviceByteTimeout := 1000;
  FMaxRetryCount := 5;
  FPollInterval := 100;
  FStatusInterval := 100;
  FSearchByPortEnabled := False;
  FSearchByBaudRateEnabled := True;
  FMonitoringEnabled := False;
  FLogFileEnabled := False;

  FCutType := PRINTER_CUTTYPE_PARTIAL;
  LogoPosition := LogoAfterHeader;
  FNumHeaderLines := 6;
  FNumTrailerLines := 4;
  FHeaderFont := 1;
  FTrailerFont := 1;
  FEncoding := EncodingWindows;
  FBarcodePrintDelay := 100;

  // Training mode text params
  FTrainModeText := ' TRAINING MODE ';
  FTrainCashInText := 'CASH IN';
  FTrainCashOutText := 'CASH OUT';
  FTrainSaleText := 'SALE';
  FTrainVoidRecText := 'RECEIPT VOIDED';
  FTrainTotalText := 'TOTAL';
  FTrainCashPayText := 'CASH' ;
  FTrainPay2Text := 'PAY TYPE 1' ;
  FTrainPay3Text := 'PAY TYPE 2';
  FTrainPay4Text := 'PAY TYPE 3' ;
  FTrainChangeText := 'CHANGE';
  FTrainStornoText := 'VOID';

  PayTypes.Clear;
  PayTypes.Add(0, '0');  // Cash
  PayTypes.Add(1, '1');  // Cashless 1
  PayTypes.Add(2, '2');  // Cashless 2
  PayTypes.Add(3, '3');  // Cashless 3
  FStatusCommand := StatusCommandDriver;

  HeaderType := HeaderTypePrinter;
  CompatLevel := CompatLevelNone;

  Lines := TStringList.Create;
  try
    Lines.Clear;
    for i := 1 to NumHeaderLines do
      Lines.Add(Format('Header line %d', [i]));
    FHeader := Lines.Text;

    Lines.Clear;
    for i := 1 to NumTrailerLines do
      Lines.Add(Format('Trailer line %d', [i]));
    FTrailer := Lines.Text;
  finally
    Lines.Free;
  end;

  FLogoSize := 0;
  FDepartment := 1;
  FLogoCenter := True;
  FLogoEnabled := False;
  FReceiptType := ReceiptTypeNormal;
  FZeroReceiptType := ZERO_RECEIPT_NONFISCAL;
  FZeroReceiptNumber := 1;
  FCCOType := CCOTYPE_RCS;
  TableEditEnabled := True;
end;

class function TPrinterParameters.GetSysKeyName(const DeviceName: string): string;
begin
  Result := Format('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

class function TPrinterParameters.DeviceExists(
  const DeviceName: string): Boolean;
var
  Key: HKEY;
  RegKeyName: string;
begin
  RegKeyName := GetSysKeyName(DeviceName);
  Result := RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(RegKeyName), 0,
    KEY_READ, Key) = ERROR_SUCCESS;
  if Result then
    RegCloseKey(Key);
end;

procedure TPrinterParameters.LogText(const Caption, Text: string);
var
  i: Integer;
  Lines: TStrings;
begin
  Lines := TStringList.Create;
  try
    Lines.Text := Text;
    if Lines.Count = 1 then
    begin
      Logger.Debug(Format('%s: ''%s''', [Caption, Lines[0]]));
    end else
    begin
      for i := 0 to Lines.Count-1 do
      begin
        Logger.Debug(Format('%s.%d: ''%s''', [Caption, i, Lines[i]]));
      end;
    end;
  finally
    Lines.Free;
  end;
end;

procedure TPrinterParameters.WriteLogParameters;
var
  i: Integer;
  PayType: TPayType;
begin
  Logger.Debug('TPrinterParameters.WriteLogParameters');

  LogText('Header', Header);
  LogText('Trailer', Trailer);
  Logger.Debug('RemoteHost: ' + RemoteHost);
  Logger.Debug('RemotePort: ' + IntToStr(RemotePort));
  Logger.Debug('ConnectionType: ' + IntToStr(ConnectionType));
  Logger.Debug('PortNumber: ' + IntToStr(PortNumber));
  Logger.Debug('BaudRate: ' + IntToStr(BaudRate));
  Logger.Debug('SysPassword: ' + IntToStr(SysPassword));
  Logger.Debug('UsrPassword: ' + IntToStr(UsrPassword));
  Logger.Debug('SubtotalText: ' + SubtotalText);
  Logger.Debug('CloseRecText: ' + CloseRecText);
  Logger.Debug('VoidRecText: ' + VoidRecText);
  Logger.Debug('FontNumber: ' + IntToStr(FontNumber));
  Logger.Debug('ByteTimeout: ' + IntToStr(ByteTimeout));
  Logger.Debug('MaxRetryCount: ' + IntToStr(MaxRetryCount));
  Logger.Debug('SearchByPortEnabled: ' + BoolToStr(SearchByPortEnabled));
  Logger.Debug('SearchByBaudRateEnabled: ' + BoolToStr(SearchByBaudRateEnabled));
  Logger.Debug('PollInterval: ' + IntToStr(PollInterval));
  Logger.Debug('StatusInterval: ' + IntToStr(StatusInterval));
  Logger.Debug('DeviceByteTimeout: ' + IntToStr(DeviceByteTimeout));
  Logger.Debug('MonitoringEnabled: ' + BoolToStr(MonitoringEnabled));
  Logger.Debug('LogFileEnabled: ' + BoolToStr(LogFileEnabled));
  Logger.Debug('CutType: ' + IntToStr(CutType));
  Logger.Debug('LogoPosition: ' + IntToStr(LogoPosition));
  Logger.Debug('NumHeaderLines: ' + IntToStr(NumHeaderLines));
  Logger.Debug('NumTrailerLines: ' + IntToStr(NumTrailerLines));
  Logger.Debug('Encoding: ' + IntToStr(Encoding));
  Logger.Debug('HeaderType: ' + IntToStr(HeaderType));
  Logger.Debug('HeaderFont: ' + IntToStr(HeaderFont));
  Logger.Debug('TrailerFont: ' + IntToStr(TrailerFont));
  Logger.Debug('StatusCommand: ' + IntToStr(StatusCommand));
  Logger.Debug('BarcodePrintDelay: ' + IntToStr(BarcodePrintDelay));

  Logger.Debug('TrainModeText: ' + TrainModeText);
  Logger.Debug('TrainCashInText: ' + TrainCashInText);
  Logger.Debug('TrainCashOutText: ' + TrainCashOutText);
  Logger.Debug('TrainSaleText: ' + TrainSaleText);
  Logger.Debug('TrainVoidRecText: ' + TrainVoidRecText);
  Logger.Debug('TrainTotalText: ' + TrainTotalText);
  Logger.Debug('TrainCashPayText: ' + TrainCashPayText);
  Logger.Debug('TrainPay2Text: ' + TrainPay2Text);
  Logger.Debug('TrainPay3Text: ' + TrainPay3Text);
  Logger.Debug('TrainPay4Text: ' + TrainPay4Text);
  Logger.Debug('TrainChangeText: ' + TrainChangeText);
  Logger.Debug('TrainStornoText: ' + TrainStornoText);
  Logger.Debug('CompatLevel: ' + IntToStr(CompatLevel));
  Logger.Debug('ReceiptType: ' + IntToStr(ReceiptType));
  Logger.Debug('ZeroReceiptType: ' + IntToStr(ZeroReceiptType));
  Logger.Debug('ZeroReceiptNumber: ' + IntToStr(ZeroReceiptNumber));
  Logger.Debug('LogoSize: ' + IntToStr(LogoSize));
  Logger.Debug('LogoCenter: ' + BoolToStr(LogoCenter));
  Logger.Debug('Department: ' + IntToStr(Department));
  Logger.Debug('LogoEnabled: ' + BoolToStr(LogoEnabled));
  Logger.Debug('HeaderPrinted: ' + BoolToStr(HeaderPrinted));
  Logger.Debug('CCOType: ' + IntToStr(CCOType));
  Logger.Debug('TableEditEnabled: ' + BoolToStr(TableEditEnabled));


  for i := 0 to PayTypes.Count-1 do
  begin
    PayType := PayTypes[i];
    Logger.Debug(Format('PayType %d: %s', [PayType.Code, PayType.Text]));
  end;

  Logger.Debug(Logger.Separator);
end;

function TPrinterParameters.GetXmlFileName: string;
begin
  Result := ChangeFileExt(GetModuleFileName, '.xml');
end;

function FindChildNode(Node: IXMLNode; const NodeName: string): IXMLNode;
var
  i: Integer;
begin
  for i := 0 to Node.ChildNodes.Length-1 do
  begin
    Result := Node.ChildNodes.Item[i];
    if Result.NodeName = NodeName then Exit;
  end;
  Result := nil;
end;

function FindChild(Node: IXMLNode; const NodeName: string): IXMLNode;
begin
  Result := FindChildNode(Node, NodeName);
  if Result = nil then
    raise Exception.CreateFmt('Node "%s" not found', [NodeName]);
end;

function GetChild(Document: IXMLDocument; Node: IXMLNode;
  const NodeName: string): IXMLNode;
var
  Node1: IXmlNode;
begin
  Result := FindChildNode(Node, NodeName);
  if Result = nil then
  begin
    Document.CreateElement()
    Node1 := Node.ChildNodes.AddNode();
    Result := Node.A
end;

procedure TPrinterParameters.Load(const DeviceName: string);
begin
  try
    SetDefaults;
    LoadFromXml(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TPrinterParameters.Load', E);
    end;
  end;
end;

procedure TPrinterParameters.LoadFromXml(const DeviceName: string);
var
  Root: IXMLNode;
  Node: IXMLNode;
  Reader: TOmniXmlReader;
  Document: IXMLDocument;
begin
  Document := TXMLDocument.Create;
  Reader := TOmniXmlReader.Create;
  try
    Document.Load(GetXmlFileName);
    Root := FindChild(Document.DocumentElement, 'FiscalPrinter');
    Node := FindChild(Root, DeviceName);
    Reader.Read(Self, Node as IXMLElement);
  finally
    Reader.Free;
  end;
end;

procedure TPrinterParameters.Save(const DeviceName: string);
begin
  try
    SaveToXml(DeviceName);
  except
    on E: Exception do
      Logger.Error('TPrinterParameters.Save', E);
  end;
end;

procedure TPrinterParameters.SaveToXml(const DeviceName: string);
var
  Root: IXMLNode;
  Node: IXMLNode;
  FileName: string;
  Writer: TOmniXmlWriter;
  Document: IXMLDocument;
begin
  Document := TXMLDocument.Create;
  Writer := TOmniXmlWriter.Create(Document);
  try
    FileName := GetXmlFileName;
    if FileExists(FileName) then
      Document.Load(FileName);

    Root := GetChild(Document.DocumentElement, 'FiscalPrinter');
    Node := GetChild(Root, DeviceName);

    Writer.Write(Node, Self, FileName);
  finally
    Writer.Free;
  end;
end;

function TPrinterParameters.GetIniFileName: string;
begin
  Result := ChangeFileExt(GetModuleFileName, '.ini');
end;

procedure TPrinterParameters.SetLogoPosition(const Value: Integer);
resourcestring
  SInvalidLogoPosition = 'Invalid LogoPosition value (%d).';
begin
  if Value <> LogoPosition then
  begin
    if not Value in [LogoAfterHeader, LogoBeforeHeader] then
      raise Exception.CreateFmt(SInvalidLogoPosition, [Value]);

    FLogoPosition := Value;
  end;
end;

class function TPrinterParameters.GetUsrKeyName(const DeviceName: string): string;
begin
  Result := Format('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

procedure TPrinterParameters.LoadUsrParameters(const DeviceName: string);
var
  Reg: TRegistry;
begin
  Logger.Debug('TPrinterParameters.LoadUsrParameters', [DeviceName]);
  Reg := TRegistry.Create;
  try
    IniFile.Access := KEY_READ;
    IniFile.RootKey := HKEY_CURRENT_USER;
    if IniFile.OpenKey(GetUsrKeyName(DeviceName), False) then
    begin
      if IniFile.ValueExists('Header') then
        FHeader := IniFile.ReadString('Header');

      if IniFile.ValueExists('Trailer') then
        FTrailer := IniFile.ReadString('Trailer');

      if IniFile.ValueExists('HeaderPrinted') then
        FHeaderPrinted := IniFile.ReadBool('HeaderPrinted');

      if IniFile.ValueExists('LogoSize') then
        FLogoSize := IniFile.ReadInteger('LogoSize');

      if IniFile.ValueExists('LogoEnabled') then
        FLogoEnabled := IniFile.ReadBool('LogoEnabled');

      if IniFile.ValueExists('LogoCenter') then
        FLogoCenter := IniFile.ReadBool('LogoCenter');

      if IniFile.ValueExists('Department') then
        FDepartment := IniFile.ReadInteger('Department');

      if IniFile.ValueExists('ZeroReceiptNumber') then
        ZeroReceiptNumber := IniFile.ReadInteger('ZeroReceiptNumber');
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TPrinterParameters.SaveUsrParameters(const DeviceName: string);
var
  Reg: TRegistry;
begin
  Logger.Debug('TPrinterParameters.SaveUsrParameters', [DeviceName]);
  Reg := TRegistry.Create;
  try
    IniFile.Access := KEY_ALL_ACCESS;
    IniFile.RootKey := HKEY_CURRENT_USER;
    if IniFile.OpenKey(GetUsrKeyName(DeviceName), True) then
    begin
      IniFile.WriteString('Header', Header);
      IniFile.WriteString('Trailer', Trailer);
      IniFile.WriteBool('HeaderPrinted', HeaderPrinted);
      IniFile.WriteInteger('LogoSize', LogoSize);
      IniFile.WriteBool('LogoEnabled', LogoEnabled);
      IniFile.WriteBool('LogoCenter', LogoCenter);
      IniFile.WriteInteger('Department', Department);
      IniFile.WriteInteger('ZeroReceiptNumber', ZeroReceiptNumber);
    end else
    begin
      raise Exception.Create('Registry key open error');
    end;
  finally
    IniFile.Free;
  end;
end;

end.
