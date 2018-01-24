unit duPrinterParameters;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  PrinterParameters, PrinterParametersIni, PrinterParametersReg,
  PrinterParametersX, DriverContext, LogFile;

type
  { TPrinterParametersTest }

  TPrinterParametersTest = class(TTestCase)
  private
    FContext: TDriverContext;

    procedure SetNonDefaultParams;
    procedure CheckNonDefaultParams;

    function GetLogger: ILogFile;
    function GetParams: TPrinterParameters;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckLoadIni;
    procedure CheckLoadReg;
    procedure CheckSetDefaults;
    procedure CheckDefaultParams;

    property Logger: ILogFile read GetLogger; 
    property Params: TPrinterParameters read GetParams;
  end;

implementation

const
  NonDefRemoteHost = 'sjhfgjsghdf';
  NonDefRemotePort = 234;
  NonDefConnectionType = 2;
  NonDefPortNumber = 23;
  NonDefBaudRate = 7687;
  NonDefSysPassword = 767;
  NonDefUsrPassword = 65;
  NonDefSubtotalText = 'sldfjlskdfj';
  NonDefCloseRecText = 'sadfljhsldfkj';
  NonDefVoidRecText = 'skdfjhksjdfh';
  NonDefFontNumber = 9;
  NonDefByteTimeout = 101;
  NonDefDeviceByteTimeout = 657;
  NonDefMaxRetryCount = 7;
  NonDefPollIntervalInSeconds = 18;
  NonDefStatusInterval = 76;
  NonDefSearchByPortEnabled = True;
  NonDefSearchByBaudRateEnabled = True;
  NonDefPropertyUpdateMode = PropertyUpdateModePolling;
  NonDefLogFileEnabled = True;
  NonDefCutType = 1;
  NonDefLogoPosition = 3;
  NonDefNumHeaderLines = 34;
  NonDefNumTrailerLines = 56;
  NonDefHeaderFont = 4;
  NonDefTrailerFont = 14;
  NonDefEncoding = 1;
  NonDefBarLinePrintDelay = 657;
  NonDefStatusCommand = 1;
  NonDefHeaderType = 1;
  NonDefCompatLevel = 1;
  NonDefLogoSize = 76;
  NonDefDepartment = 8;
  NonDefLogoCenter = True;
  NonDefLogoEnabled = True;
  NonDefReceiptType = 1;
  NonDefZeroReceiptType = 889;
  NonDefZeroReceiptNumber = 233;
  NonDefCCOType = 1;
  NonDefTableEditEnabled = True;
  NonDefHeaderPrinted = True;
  NonDefHeader = 'woeury9348r'#13#10'wueyfgwudyeg';
  NonDefTrailer = 'wmlerjlkjwh4ur983'#13#10'wueyfgwudyeg';
  NonDefXmlZReportEnabled = True;
  NonDefCsvZReportEnabled = True;
  NonDefXmlZReportFileName = 'skdfhksjdfh';
  NonDefCsvZReportFileName = 'sldfjlskdjf';
  NonDefLogMaxCount = 14;
  NonDefDocumentBlockSize = 10;

{ TPrinterParametersTest }

procedure TPrinterParametersTest.Setup;
begin
  inherited Setup;
  FContext := TDriverContext.Create;
end;

procedure TPrinterParametersTest.TearDown;
begin
  FContext.Free;
  inherited TearDown;
end;

function TPrinterParametersTest.GetParams: TPrinterParameters;
begin
  Result := FContext.Parameters;
end;

procedure TPrinterParametersTest.CheckDefaultParams;
begin
  CheckEquals(DefBaudRate, Params.BaudRate, 'Params.BaudRate');
  CheckEquals(DefPortNumber, Params.PortNumber, 'Params.PortNumber');
  CheckEquals(DefFontNumber, Params.FontNumber, 'Params.FontNumber');
  CheckEquals(DefSysPassword, Params.SysPassword, 'Params.SysPassword');
  CheckEquals(DefUsrPassword, Params.UsrPassword, 'Params.UsrPassword');
  CheckEquals(DefByteTimeout, Params.ByteTimeout, 'Params.ByteTimeout');
  CheckEquals(DefStatusInterval, Params.StatusInterval, 'Params.StatusInterval');
  CheckEquals(DefSubtotalText, Params.SubtotalText, 'Params.SubtotalText');
  CheckEquals(DefCloseRecText, Params.CloseRecText, 'Params.CloseRecText');
  CheckEquals(DefVoidRecText, Params.VoidRecText, 'Params.VoidRecText');
  CheckEquals(DefPollIntervalInSeconds, Params.PollIntervalInSeconds, 'Params.PollIntervalInSeconds');
  CheckEquals(DefMaxRetryCount, Params.MaxRetryCount, 'Params.MaxRetryCount');
  CheckEquals(DefDeviceByteTimeout, Params.DeviceByteTimeout, 'Params.DeviceByteTimeout');
  CheckEquals(DefSearchByPortEnabled, Params.SearchByPortEnabled, 'Params.SearchByPortEnabled');
  CheckEquals(DefSearchByBaudRateEnabled, Params.SearchByBaudRateEnabled, 'Params.SearchByBaudRateEnabled');
  CheckEquals(DefPropertyUpdateMode, Params.PropertyUpdateMode, 'Params.PropertyUpdateMode');
  CheckEquals(DefCutType, Params.CutType, 'Params.CutType');
  CheckEquals(DefEncoding, Params.Encoding, 'Params.Encoding');
  CheckEquals(DefRemoteHost, Params.RemoteHost, 'Params.RemoteHost');
  CheckEquals(DefRemotePort, Params.RemotePort, 'Params.RemotePort');
  CheckEquals(DefHeaderType, Params.HeaderType, 'Params.HeaderType');
  CheckEquals(DefHeaderFont, Params.HeaderFont, 'Params.HeaderFont');
  CheckEquals(DefTrailerFont, Params.TrailerFont, 'Params.TrailerFont');
  CheckEquals(DefLogoPosition, Params.LogoPosition, 'Params.SetLogoPosition');
  CheckEquals(DefStatusCommand, Params.StatusCommand, 'Params.StatusCommand');
  CheckEquals(DefConnectionType, Params.ConnectionType, 'Params.ConnectionType');
  CheckEquals(DefLogFileEnabled, Params.LogFileEnabled, 'Params.LogFileEnabled');
  CheckEquals(DefNumHeaderLines, Params.NumHeaderLines, 'Params.NumHeaderLines');
  CheckEquals(DefNumTrailerLines, Params.NumTrailerLines, 'Params.NumTrailerLines');
  CheckEquals(DefBarLinePrintDelay, Params.BarLinePrintDelay, 'Params.BarLinePrintDelay');
  CheckEquals(DefCompatLevel, Params.CompatLevel, 'Params.CompatLevel');
  CheckEquals(DefHeader, Params.Header, 'Params.Header');
  CheckEquals(DefTrailer, Params.Trailer, 'Params.Trailer');
  CheckEquals(DefLogoSize, Params.LogoSize, 'Params.LogoSize');
  CheckEquals(DefLogoCenter, Params.LogoCenter, 'Params.LogoCenter');
  CheckEquals(DefDepartment, Params.Department, 'Params.Department');
  CheckEquals(DefHeaderPrinted, Params.HeaderPrinted, 'Params.HeaderPrinted');
  CheckEquals(DefReceiptType, Params.ReceiptType, 'Params.ReceiptType');
  CheckEquals(DefZeroReceiptType, Params.ZeroReceiptType, 'Params.ZeroReceiptType');
  CheckEquals(DefZeroReceiptNumber, Params.ZeroReceiptNumber, 'Params.ZeroReceiptNumber');
  CheckEquals(DefCCOType, Params.CCOType, 'Params.CCOType');
  CheckEquals(DefTableEditEnabled, Params.TableEditEnabled, 'Params.TableEditEnabled');
  CheckEquals(DefXmlZReportEnabled, Params.XmlZReportEnabled, 'Params.XmlZReportEnabled');
  CheckEquals(DefCsvZReportEnabled, Params.CsvZReportEnabled, 'Params.CsvZReportEnabled');
  CheckEquals(Params.DefXmlZReportFileName, Params.XmlZReportFileName, 'Params.XmlZReportFileName');
  CheckEquals(Params.DefCsvZReportFileName, Params.CsvZReportFileName, 'Params.CsvZReportFileName');
  CheckEquals(DefLogMaxCount, Params.LogMaxCount, 'Params.LogMaxCount');
  CheckEquals(DefDocumentBlockSize, Params.DocumentBlockSize, 'Params.DocumentBlockSize');

  CheckEquals(16, Params.PayTypes.Count, 'Params.PayTypes.Count');
  CheckEquals(0, Params.PayTypes[0].Code, 'Params.PayTypes[0].Code');
  CheckEquals(1, Params.PayTypes[1].Code, 'Params.PayTypes[1].Code');
  CheckEquals(2, Params.PayTypes[2].Code, 'Params.PayTypes[2].Code');
  CheckEquals(3, Params.PayTypes[3].Code, 'Params.PayTypes[3].Code');
  CheckEquals('0', Params.PayTypes[0].Text, 'Params.PayTypes[0].Text');
  CheckEquals('1', Params.PayTypes[1].Text, 'Params.PayTypes[1].Text');
  CheckEquals('2', Params.PayTypes[2].Text, 'Params.PayTypes[2].Text');
  CheckEquals('3', Params.PayTypes[3].Text, 'Params.PayTypes[3].Text');

end;

procedure TPrinterParametersTest.CheckSetDefaults;
begin
  SetNonDefaultParams;
  Params.SetDefaults;
  CheckDefaultParams;
end;

procedure TPrinterParametersTest.SetNonDefaultParams;
begin
  Params.RemoteHost := NonDefRemoteHost;
  Params.RemotePort := NonDefRemotePort;
  Params.PortNumber := NonDefPortNumber;
  Params.BaudRate := NonDefBaudRate;
  Params.SysPassword := NonDefSysPassword;
  Params.UsrPassword := NonDefUsrPassword;
  Params.SubtotalText := NonDefSubtotalText;
  Params.CloseRecText := NonDefCloseRecText;
  Params.VoidRecText := NonDefVoidRecText;
  Params.FontNumber := NonDefFontNumber;
  Params.ByteTimeout := NonDefByteTimeout;
  Params.DeviceByteTimeout := NonDefDeviceByteTimeout;
  Params.MaxRetryCount := NonDefMaxRetryCount;
  Params.PollIntervalInSeconds := NonDefPollIntervalInSeconds;
  Params.StatusInterval := NonDefStatusInterval;
  Params.SearchByPortEnabled := NonDefSearchByPortEnabled;
  Params.SearchByBaudRateEnabled := NonDefSearchByBaudRateEnabled;
  Params.PropertyUpdateMode := NonDefPropertyUpdateMode;
  Params.LogFileEnabled := NonDefLogFileEnabled;
  Params.CutType := NonDefCutType;
  Params.LogoPosition := NonDefLogoPosition;
  Params.NumHeaderLines := NonDefNumHeaderLines;
  Params.NumTrailerLines := NonDefNumTrailerLines;
  Params.HeaderFont := NonDefHeaderFont;
  Params.TrailerFont := NonDefTrailerFont;
  Params.Encoding := NonDefEncoding;
  Params.BarLinePrintDelay := NonDefBarLinePrintDelay;
  Params.HeaderType := NonDefHeaderType;
  Params.CompatLevel := NonDefCompatLevel;
  Params.StatusCommand := NonDefStatusCommand;
  Params.LogoSize := NonDefLogoSize;
  Params.Department := NonDefDepartment;
  Params.LogoCenter := NonDefLogoCenter;
  Params.ReceiptType := NonDefReceiptType;
  Params.ZeroReceiptType := NonDefZeroReceiptType;
  Params.ZeroReceiptNumber := NonDefZeroReceiptNumber;
  Params.CCOType := NonDefCCOType;
  Params.TableEditEnabled := NonDefTableEditEnabled;
  Params.Header := NonDefHeader;
  Params.Trailer := NonDefTrailer;
  Params.ConnectionType := NonDefConnectionType;
  Params.HeaderPrinted := NonDefHeaderPrinted;
  Params.PayTypes.Clear;
  Params.PayTypes.Add(12, 'Pay type 12');
  Params.PayTypes.Add(45, 'Pay type 45');
  Params.PayTypes.Add(78, 'Pay type 78');
  Params.XmlZReportEnabled := NonDefXmlZReportEnabled;
  Params.CsvZReportEnabled := NonDefCsvZReportEnabled;
  Params.XmlZReportFileName := NonDefXmlZReportFileName;
  Params.CsvZReportFileName := NonDefCsvZReportFileName;
  Params.LogMaxCount := NonDefLogMaxCount;
  Params.DocumentBlockSize := NonDefDocumentBlockSize;
end;

procedure TPrinterParametersTest.CheckNonDefaultParams;
begin
  CheckEquals(NonDefBaudRate, Params.BaudRate, 'Params.BaudRate');
  CheckEquals(NonDefPortNumber, Params.PortNumber, 'Params.PortNumber');
  CheckEquals(NonDefFontNumber, Params.FontNumber, 'Params.FontNumber');
  CheckEquals(NonDefSysPassword, Params.SysPassword, 'Params.SysPassword');
  CheckEquals(NonDefUsrPassword, Params.UsrPassword, 'Params.UsrPassword');
  CheckEquals(NonDefByteTimeout, Params.ByteTimeout, 'Params.ByteTimeout');
  CheckEquals(NonDefStatusInterval, Params.StatusInterval, 'Params.StatusInterval');
  CheckEquals(NonDefSubtotalText, Params.SubtotalText, 'Params.SubtotalText');
  CheckEquals(NonDefCloseRecText, Params.CloseRecText, 'Params.CloseRecText');
  CheckEquals(NonDefVoidRecText, Params.VoidRecText, 'Params.VoidRecText');
  CheckEquals(NonDefPollIntervalInSeconds, Params.PollIntervalInSeconds, 'Params.PollIntervalInSeconds');
  CheckEquals(NonDefMaxRetryCount, Params.MaxRetryCount, 'Params.MaxRetryCount');
  CheckEquals(NonDefDeviceByteTimeout, Params.DeviceByteTimeout, 'Params.DeviceByteTimeout');
  CheckEquals(NonDefSearchByPortEnabled, Params.SearchByPortEnabled, 'Params.SearchByPortEnabled');
  CheckEquals(NonDefSearchByBaudRateEnabled, Params.SearchByBaudRateEnabled, 'Params.SearchByBaudRateEnabled');
  CheckEquals(NonDefPropertyUpdateMode, Params.PropertyUpdateMode, 'Params.PropertyUpdateMode');
  CheckEquals(NonDefCutType, Params.CutType, 'Params.CutType');
  CheckEquals(NonDefEncoding, Params.Encoding, 'Params.Encoding');
  CheckEquals(NonDefRemoteHost, Params.RemoteHost, 'Params.RemoteHost');
  CheckEquals(NonDefRemotePort, Params.RemotePort, 'Params.RemotePort');
  CheckEquals(NonDefHeaderType, Params.HeaderType, 'Params.HeaderType');
  CheckEquals(NonDefHeaderFont, Params.HeaderFont, 'Params.HeaderFont');
  CheckEquals(NonDefTrailerFont, Params.TrailerFont, 'Params.TrailerFont');
  CheckEquals(NonDefLogoPosition, Params.LogoPosition, 'Params.SetLogoPosition');
  CheckEquals(NonDefStatusCommand, Params.StatusCommand, 'Params.StatusCommand');
  CheckEquals(NonDefConnectionType, Params.ConnectionType, 'Params.ConnectionType');
  CheckEquals(NonDefLogFileEnabled, Params.LogFileEnabled, 'Params.LogFileEnabled');
  CheckEquals(NonDefNumHeaderLines, Params.NumHeaderLines, 'Params.NumHeaderLines');
  CheckEquals(NonDefNumTrailerLines, Params.NumTrailerLines, 'Params.NumTrailerLines');
  CheckEquals(NonDefBarLinePrintDelay, Params.BarLinePrintDelay, 'Params.BarLinePrintDelay');
  CheckEquals(NonDefCompatLevel, Params.CompatLevel, 'Params.CompatLevel');
  CheckEquals(NonDefHeader, Params.Header, 'Params.Header');
  CheckEquals(NonDefTrailer, Params.Trailer, 'Params.Trailer');
  CheckEquals(NonDefLogoSize, Params.LogoSize, 'Params.LogoSize');
  CheckEquals(NonDefLogoCenter, Params.LogoCenter, 'Params.LogoCenter');
  CheckEquals(NonDefDepartment, Params.Department, 'Params.Department');
  CheckEquals(NonDefHeaderPrinted, Params.HeaderPrinted, 'Params.HeaderPrinted');
  CheckEquals(NonDefReceiptType, Params.ReceiptType, 'Params.ReceiptType');
  CheckEquals(NonDefZeroReceiptType, Params.ZeroReceiptType, 'Params.ZeroReceiptType');
  CheckEquals(NonDefZeroReceiptNumber, Params.ZeroReceiptNumber, 'Params.ZeroReceiptNumber');
  CheckEquals(NonDefCCOType, Params.CCOType, 'Params.CCOType');
  CheckEquals(NonDefTableEditEnabled, Params.TableEditEnabled, 'Params.TableEditEnabled');
  CheckEquals(NonDefXmlZReportEnabled, Params.XmlZReportEnabled, 'Params.XmlZReportEnabled');
  CheckEquals(NonDefCsvZReportEnabled, Params.CsvZReportEnabled, 'Params.CsvZReportEnabled');
  CheckEquals(NonDefXmlZReportFileName, Params.XmlZReportFileName, 'Params.XmlZReportFileName');
  CheckEquals(NonDefCsvZReportFileName, Params.CsvZReportFileName, 'Params.CsvZReportFileName');
  CheckEquals(NonDefLogMaxCount, Params.LogMaxCount, 'Params.LogMaxCount');
  CheckEquals(NonDefDocumentBlockSize, Params.DocumentBlockSize, 'Params.DocumentBlockSize');

  CheckEquals(3, Params.PayTypes.Count, 'Params.PayTypes.Count');
  CheckEquals(12, Params.PayTypes[0].Code, 'Params.PayTypes[0].Code');
  CheckEquals(45, Params.PayTypes[1].Code, 'Params.PayTypes[1].Code');
  CheckEquals(78, Params.PayTypes[2].Code, 'Params.PayTypes[2].Code');
  CheckEquals('Pay type 12', Params.PayTypes[0].Text, 'Params.PayTypes[0].Text');
  CheckEquals('Pay type 45', Params.PayTypes[1].Text, 'Params.PayTypes[1].Text');
  CheckEquals('Pay type 78', Params.PayTypes[2].Text, 'Params.PayTypes[2].Text');
end;

procedure TPrinterParametersTest.CheckLoadIni;
begin
  SetNonDefaultParams;
  SaveParametersIni(Params, 'DeviceName', Logger);
  Params.SetDefaults;
  LoadParametersIni(Params, 'DeviceName', Logger);
  CheckNonDefaultParams;
  DeleteParametersIni('DeviceName');
end;

procedure TPrinterParametersTest.CheckLoadReg;
begin
  SetNonDefaultParams;
  SaveParametersReg(Params, 'DeviceName', Logger);
  Params.SetDefaults;
  LoadParametersReg(Params, 'DeviceName', Logger);
  CheckNonDefaultParams;
  DeleteParametersReg('DeviceName', Logger);
end;

function TPrinterParametersTest.GetLogger: ILogFile;
begin
  Result := FContext.Logger;
end;

initialization
  RegisterTest('', TPrinterParametersTest.Suite);


end.
