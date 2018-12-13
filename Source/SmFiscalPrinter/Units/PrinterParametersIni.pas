unit PrinterParametersIni;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry, TntIniFiles, TntSysUtils, 
  // This
  PrinterParameters, FileUtils, LogFile, SmIniFile, SmFiscalPrinterLib_TLB,
  DirectIOAPI, VatCode;

type
  { IParamsReader }

  IParamsReader = interface
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);
    procedure WriteText(const Section, Ident, Value: WideString);
    procedure WriteString(const Section, Ident, Value: WideString);
    procedure WriteBool(const Section, Ident: WideString; Value: Boolean);
    procedure WriteInteger(const Section, Ident: WideString; Value: Longint);
    function ReadText(const Section, Ident, Default: WideString): WideString;
    function ReadString(const Section, Ident, Default: WideString): WideString;
    function ReadInteger(const Section, Ident: WideString; Default: Longint): Longint;
    function ReadBool(const Section, Ident: WideString; Default: Boolean): Boolean;
  end;

  (*
  { TTntIniFileReader }

  TTntIniFileReader = class(TInterfacedObject, IParamsReader)
  public
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);
    procedure WriteText(const Section, Ident, Value: WideString);
    procedure WriteString(const Section, Ident, Value: WideString);
    procedure WriteBool(const Section, Ident: WideString; Value: Boolean);
    procedure WriteInteger(const Section, Ident: WideString; Value: Longint);
    function ReadText(const Section, Ident, Default: WideString): WideString;
    function ReadString(const Section, Ident, Default: WideString): WideString;
    function ReadInteger(const Section, Ident: WideString; Default: Longint): Longint;
    function ReadBool(const Section, Ident: WideString; Default: Boolean): Boolean;
  end;

  *)

  { TPrinterParametersIni }

  TPrinterParametersIni = class
  private
    FLogger: ILogFile;
    FParameters: TPrinterParameters;
    procedure LoadIni(const DeviceName: WideString);
    property Parameters: TPrinterParameters read FParameters;

    class function GetIniFileName: WideString;
    class function GetSectionName(const DeviceName: WideString): WideString;
    class function DoReadStorage(const DeviceName: WideString): Integer;
    class procedure DoSaveStorage(const DeviceName: WideString;
      Storage: Integer);
    procedure SaveSysParameters(const DeviceName: WideString);
    procedure SaveUsrParameters(const DeviceName: WideString);

    property Logger: ILogFile read FLogger;
  public
    constructor Create(AParameters: TPrinterParameters; ALogger: ILogFile);
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);
    class function ReadStorage(const DeviceName: WideString): Integer;
    class procedure SaveStorage(const DeviceName: WideString; Storage: Integer);
  end;

function ReadEncodingIni(const DeviceName: WideString; Logger: ILogFile): Integer;

procedure DeleteParametersIni(const DeviceName: WideString);

procedure LoadParametersIni(Item: TPrinterParameters;
  const DeviceName: WideString; Logger: ILogFile);

procedure SaveParametersIni(Item: TPrinterParameters;
  const DeviceName: WideString; Logger: ILogFile);

procedure SaveUsrParametersIni(Item: TPrinterParameters;
  const DeviceName: WideString; Logger: ILogFile);

implementation

function ReadEncodingIni(const DeviceName: WideString; Logger: ILogFile): Integer;
var
  P: TPrinterParameters;
begin
  P := TPrinterParameters.Create(Logger);
  try
    LoadParametersIni(P, DeviceName, Logger);
    Result := P.Encoding;
  finally
    P.Free;
  end;
end;

procedure DeleteParametersIni(const DeviceName: WideString);
begin
  try
    DeleteFile(TPrinterParametersIni.GetIniFileName);
  except
    on E: Exception do
      //Logger.Error('DeleteParametersIni', E);
  end;
end;

procedure LoadParametersIni(Item: TPrinterParameters;
  const DeviceName: WideString; Logger: ILogFile);
var
  Reader: TPrinterParametersIni;
begin
  Reader := TPrinterParametersIni.Create(Item, Logger);
  try
    Reader.Load(DeviceName);
  finally
    Reader.Free;
  end;
end;

procedure SaveParametersIni(Item: TPrinterParameters; const DeviceName: WideString;
  Logger: ILogFile);
var
  Writer: TPrinterParametersIni;
begin
  Writer := TPrinterParametersIni.Create(Item, Logger);
  try
    Writer.Save(DeviceName);
  finally
    Writer.Free;
  end;
end;

procedure SaveUsrParametersIni(Item: TPrinterParameters;
  const DeviceName: WideString; Logger: ILogFile);
var
  Writer: TPrinterParametersIni;
begin
  Writer := TPrinterParametersIni.Create(Item, Logger);
  try
    Writer.SaveUsrParameters(DeviceName);
  finally
    Writer.Free;
  end;
end;

{ TPrinterParametersIni }

constructor TPrinterParametersIni.Create(AParameters: TPrinterParameters;
  ALogger: ILogFile);
begin
  inherited Create;
  FParameters := AParameters;
  FLogger := ALogger;
end;

procedure TPrinterParametersIni.Load(const DeviceName: WideString);
begin
  try
    LoadIni(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TPrinterParametersIni.Load', E);
    end;
  end;
end;

procedure TPrinterParametersIni.Save(const DeviceName: WideString);
begin
  try
    SaveUsrParameters(DeviceName);
    SaveSysParameters(DeviceName);
  except
    on E: Exception do
      Logger.Error('TPrinterParametersIni.Save', E);
  end;
end;

class function TPrinterParametersIni.GetIniFileName: WideString;
begin
  Result := WideIncludeTrailingPathDelimiter(ExtractFilePath(
    CLSIDToFileName(Class_FiscalPrinter))) + 'FiscalPrinter.ini';
end;

class function TPrinterParametersIni.GetSectionName(const DeviceName: WideString): WideString;
begin
  Result := 'FiscalPrinter_' + DeviceName;
end;

procedure TPrinterParametersIni.LoadIni(const DeviceName: WideString);
var
  i: Integer;
  Section: WideString;
  Names: TTntStrings;
  AppVatCode: Integer;
  FptrVatCode: Integer;
  IniFile: TSmIniFile;
  PayTypeText: WideString;
  PayTypeCode: Integer;
begin
  Logger.Debug('TPrinterParametersIni.Load', [DeviceName]);

  IniFile := TSmIniFile.Create(GetIniFileName);
  try
    Section := GetSectionName(DeviceName);
    if IniFile.SectionExists(Section) then
    begin
      FParameters.RemoteHost := IniFile.ReadText(Section, 'RemoteHost', DefRemoteHost);
      FParameters.RemotePort := IniFile.ReadInteger(Section, 'RemotePort', DefRemotePort);
      FParameters.ConnectionType := IniFile.ReadInteger(Section, 'ConnectionType', DefConnectionType);
      FParameters.PortNumber := IniFile.ReadInteger(Section, 'PortNumber', DefPortNumber);
      FParameters.BaudRate :=  IniFile.ReadInteger(Section, 'BaudRate', DefBaudRate);
      FParameters.SysPassword := IniFile.ReadInteger(Section, 'SysPassword', DefSysPassword);
      FParameters.UsrPassword := IniFile.ReadInteger(Section, 'UsrPassword', DefUsrPassword);
      FParameters.SubtotalText := IniFile.ReadText(Section, 'SubtotalText', DefSubtotalText);
      FParameters.CloseRecText := IniFile.ReadText(Section, 'CloseRecText', DefCloseRecText);
      FParameters.VoidRecText := IniFile.ReadText(Section, 'VoidRecText', DefVoidRecText);
      FParameters.FontNumber := IniFile.ReadInteger(Section, 'FontNumber', DefFontNumber);
      FParameters.ByteTimeout := IniFile.ReadInteger(Section, 'ByteTimeout', DefByteTimeout);
      FParameters.MaxRetryCount := IniFile.ReadInteger(Section, 'MaxRetryCount', DefMaxRetryCount);
      FParameters.SearchByPortEnabled := IniFile.ReadBool(Section, 'SearchByPortEnabled', DefSearchByPortEnabled);
      FParameters.SearchByBaudRateEnabled := IniFile.ReadBool(Section, 'SearchByBaudRateEnabled', DefSearchByBaudRateEnabled);
      FParameters.PollIntervalInSeconds := IniFile.ReadInteger(Section, 'PollIntervalInSeconds', DefPollIntervalInSeconds);
      FParameters.DeviceByteTimeout := IniFile.ReadInteger(Section, 'DeviceByteTimeout', DefDeviceByteTimeout);
      FParameters.StatusInterval := IniFile.ReadInteger(Section, 'StatusInterval', DefStatusInterval);
      FParameters.LogFileEnabled := IniFile.ReadBool(Section, 'LogFileEnabled', DefLogFileEnabled);
      FParameters.CutType := IniFile.ReadInteger(Section, 'CutType', DefCutType);
      FParameters.LogoPosition := IniFile.ReadInteger(Section, 'LogoPosition', DefLogoPosition);
      FParameters.NumHeaderLines := IniFile.ReadInteger(Section, 'NumHeaderLines', DefNumHeaderLines);
      FParameters.NumTrailerLines := IniFile.ReadInteger(Section, 'NumTrailerLines', DefNumTrailerLines);
      FParameters.HeaderFont := IniFile.ReadInteger(Section, 'HeaderFont', DefHeaderFont);
      FParameters.TrailerFont := IniFile.ReadInteger(Section, 'TrailerFont', DefTrailerFont);
      FParameters.Encoding := IniFile.ReadInteger(Section, 'Encoding', DefEncoding);
      FParameters.StatusCommand := IniFile.ReadInteger(Section, 'StatusCommand', DefStatusCommand);
      FParameters.HeaderType := IniFile.ReadInteger(Section, 'HeaderType', DefHeaderType);
      FParameters.BarLinePrintDelay := IniFile.ReadInteger(Section, 'BarLinePrintDelay', DefBarLinePrintDelay);
      FParameters.CompatLevel := IniFile.ReadInteger(Section, 'CompatLevel', DefCompatLevel);
      FParameters.ReceiptType := IniFile.ReadInteger(Section, 'ReceiptType', DefReceiptType);
      FParameters.ZeroReceiptType := IniFile.ReadInteger(Section, 'ZeroReceiptType', DefZeroReceiptType);
      FParameters.CCOType := IniFile.ReadInteger(Section, 'CCOType', DefCCOType);
      FParameters.TableEditEnabled := IniFile.ReadBool(Section, 'TableEditEnabled', DefTableEditEnabled);

      FParameters.Header := IniFile.ReadText(Section, 'Header', DefHeader);
      FParameters.Trailer := IniFile.ReadText(Section, 'Trailer', DefTrailer);
      FParameters.HeaderPrinted := IniFile.ReadBool(Section, 'HeaderPrinted', DefHeaderPrinted);
      FParameters.LogoSize := IniFile.ReadInteger(Section, 'LogoSize', DefLogoSize);
      FParameters.LogoReloadEnabled := IniFile.ReadBool(Section, 'LogoReloadEnabled', DefLogoReloadEnabled);
      FParameters.LogoFileName := IniFile.ReadString(Section, 'LogoFileName', '');
      FParameters.IsLogoLoaded := IniFile.ReadBool(Section, 'IsLogoLoaded', False);

      FParameters.LogoCenter := IniFile.ReadBool(Section, 'LogoCenter', DefLogoCenter);
      FParameters.LogoFileName := IniFile.ReadString(Section, 'LogoFileName', '');
      FParameters.IsLogoLoaded := IniFile.ReadBool(Section, 'IsLogoLoaded', False);

      FParameters.Department := IniFile.ReadInteger(Section, 'Department', DefDepartment);
      FParameters.ZeroReceiptNumber := IniFile.ReadInteger(Section, 'ZeroReceiptNumber', DefZeroReceiptNumber);
      FParameters.XmlZReportEnabled := IniFile.ReadBool(Section, 'XmlZReportEnabled', DefXmlZReportEnabled);
      FParameters.CsvZReportEnabled := IniFile.ReadBool(Section, 'CsvZReportEnabled', DefCsvZReportEnabled);
      FParameters.XmlZReportFileName := IniFile.ReadString(Section, 'XmlZReportFileName', FParameters.DefXmlZReportFileName);
      FParameters.CsvZReportFileName := IniFile.ReadString(Section, 'CsvZReportFileName', FParameters.DefCsvZReportFileName);
      FParameters.LogMaxCount := IniFile.ReadInteger(Section, 'LogMaxCount', DefLogMaxCount);
      FParameters.VoidReceiptOnMaxItems := IniFile.ReadBool(Section, 'VoidReceiptOnMaxItems', DefVoidReceiptOnMaxItems);
      FParameters.MaxReceiptItems := IniFile.ReadInteger(Section, 'MaxReceiptItems', DefMaxReceiptItems);
      FParameters.JournalPrintHeader := IniFile.ReadBool(Section, 'JournalPrintHeader', DefJournalPrintHeader);
      FParameters.JournalPrintTrailer := IniFile.ReadBool(Section, 'JournalPrintTrailer', DefJournalPrintTrailer);
      FParameters.CacheReceiptNumber := IniFile.ReadBool(Section, 'CacheReceiptNumber', DefCacheReceiptNumber);
      FParameters.BarLineByteMode := IniFile.ReadInteger(Section, 'BarLineByteMode', DefBarLineByteMode);
      FParameters.PrintRecSubtotal := IniFile.ReadBool(Section, 'PrintRecSubtotal', DefPrintRecSubtotal);
      FParameters.StatusTimeout := IniFile.ReadInteger(Section, 'StatusTimeout', DefStatusTimeout);
      FParameters.SetHeaderLineEnabled := IniFile.ReadBool(Section,
        'SetHeaderLineEnabled', DefSetHeaderLineEnabled);
      FParameters.SetTrailerLineEnabled := IniFile.ReadBool(Section,
        'SetTrailerLineEnabled', DefSetTrailerLineEnabled);

      FParameters.RFAmountLength := IniFile.ReadInteger(Section, 'RFAmountLength', DefRFAmountLength);
      FParameters.RFQuantityLength := IniFile.ReadInteger(Section, 'RFQuantityLength', DefRFQuantityLength);
      FParameters.RFShowTaxLetters := IniFile.ReadBool(Section, 'RFShowTaxLetters', DefRFShowTaxLetters);
      FParameters.RFSeparatorLine := IniFile.ReadInteger(Section, 'RFSeparatorLine', DefRFSeparatorLine);
      FParameters.MonitoringPort := IniFile.ReadInteger(Section, 'MonitoringPort', DefMonitoringPort);
      FParameters.MonitoringEnabled := IniFile.ReadBool(Section, 'MonitoringEnabled', DefMonitoringEnabled);
      FParameters.PropertyUpdateMode := IniFile.ReadInteger(Section, 'PropertyUpdateMode', DefPropertyUpdateMode);
      FParameters.ReceiptReportFileName := IniFile.ReadString(Section, 'ReceiptReportFileName', FParameters.DefReceiptReportFileName);
      FParameters.ReceiptReportEnabled := IniFile.ReadBool(Section, 'ReceiptReportEnabled', DefReceiptReportEnabled);
      FParameters.ZReceiptBeforeZReport := IniFile.ReadBool(Section, 'ZReceiptBeforeZReport', DefZReceiptBeforeZReport);
      FParameters.DepartmentInText := IniFile.ReadBool(Section, 'DepartmentInText', DefDepartmentInText);
      FParameters.CenterHeader := IniFile.ReadBool(Section, 'CenterHeader', DefCenterHeader);
      FParameters.AmountDecimalPlaces := IniFile.ReadInteger(Section, 'AmountDecimalPlaces', DefAmountDecimalPlaces);
      FParameters.CapRecNearEndSensorMode := IniFile.ReadInteger(Section, 'CapRecNearEndSensorMode', DefCapRecNearEndSensorMode);
      FParameters.FSBarcodeEnabled := IniFile.ReadBool(Section, 'FSBarcodeEnabled', False);
      FParameters.FPSerial := IniFile.ReadString(Section, 'FPSerial', '');
      FParameters.LogFilePath := IniFile.ReadString(Section, 'LogFilePath', '');
      FParameters.ReportDateStamp := IniFile.ReadBool(Section, 'ReportDateStamp', False);
      FParameters.FSAddressEnabled := IniFile.ReadBool(Section, 'FSAddressEnabled', False);
      FParameters.FSUpdatePrice := IniFile.ReadBool(Section, 'FSUpdatePrice', DefFSUpdatePrice);

      FParameters.BarcodePrefix := IniFile.ReadString(Section, 'BarcodePrefix', 'BARCODE:');
      FParameters.BarcodeHeight := IniFile.ReadInteger(Section, 'BarcodeHeight', 100);
      FParameters.BarcodeType := IniFile.ReadInteger(Section, 'BarcodeType', DIO_BARCODE_EAN13_INT);
      FParameters.BarcodeModuleWidth := IniFile.ReadInteger(Section, 'BarcodeModuleWidth', 2);
      FParameters.BarcodeAlignment := IniFile.ReadInteger(Section, 'BarcodeAlignment', BARCODE_ALIGNMENT_CENTER);
      FParameters.BarcodeParameter1 := IniFile.ReadInteger(Section, 'BarcodeParameter1', 0);
      FParameters.BarcodeParameter2 := IniFile.ReadInteger(Section, 'BarcodeParameter2', 0);
      FParameters.BarcodeParameter3 := IniFile.ReadInteger(Section, 'BarcodeParameter3', 0);

      FParameters.XReport := IniFile.ReadInteger(Section, 'XReport', FptrXReport);
      FParameters.WrapText := IniFile.ReadBool(Section, 'WrapText', DefWrapText);
      FParameters.WritePaymentNameEnabled := IniFile.ReadBool(Section, 'WritePaymentNameEnabled', True);
      FParameters.TimeUpdateMode := IniFile.ReadInteger(Section, 'TimeUpdateMode', DefTimeUpdateMode);
      FParameters.ReceiptItemsHeader := IniFile.ReadText(Section, 'ReceiptItemsHeader', DefReceiptItemsHeader);
      FParameters.ReceiptItemsTrailer := IniFile.ReadText(Section, 'ReceiptItemsTrailer', DefReceiptItemsTrailer);
      FParameters.ReceiptItemFormat := IniFile.ReadText(Section, 'ReceiptItemFormat', DefReceiptItemFormat);
      FParameters.RecPrintType := IniFile.ReadInteger(Section, 'RecPrintType', DefRecPrintType);
      FParameters.PrintSingleQuantity := IniFile.ReadBool(Section, 'PrintSingleQuantity', DefPrintSingleQuantity);
      FParameters.TableFilePath := IniFile.ReadString(Section, 'TableFilePath', FParameters.DefTableFilePath);
      FParameters.VatCodeEnabled := IniFile.ReadBool(Section, 'VatCodeEnabled', DefVatCodeEnabled);
      FParameters.HandleErrorCode := IniFile.ReadBool(Section, 'HandleErrorCode', DefHandleErrorCode);
      FParameters.FSServiceEnabled := IniFile.ReadBool(Section, 'FSServiceEnabled', False);
      FParameters.PrinterProtocol := IniFile.ReadInteger(Section, 'PrinterProtocol', DefPrinterProtocol);
      FParameters.PrintUnitName := IniFile.ReadBool(Section, 'PrintUnitName', DefPrintUnitName);
      FParameters.OpenReceiptEnabled := IniFile.ReadBool(Section, 'OpenReceiptEnabled', DefOpenReceiptEnabled);
      FParameters.QuantityDecimalPlaces := IniFile.ReadInteger(Section, 'QuantityDecimalPlaces', DefQuantityDecimalPlaces);
      FParameters.PingEnabled := IniFile.ReadBool(Section, 'PingEnabled', DefPingEnabled);
      FParameters.DocumentBlockSize := IniFile.ReadInteger(Section, 'DocumentBlockSize', DefDocumentBlockSize);
      FParameters.PrintRecMessageMode := IniFile.ReadInteger(Section, 'PrintRecMessageMode', DefPrintRecMessageMode);

      FParameters.EkmServerHost := IniFile.ReadString(Section, 'EkmServerHost', DefEkmServerHost);
      FParameters.EkmServerPort := IniFile.ReadInteger(Section, 'EkmServerPort', DefEkmServerPort);
      FParameters.EkmServerTimeout := IniFile.ReadInteger(Section, 'EkmServerTimeout', DefEkmServerTimeout);
      FParameters.EkmServerEnabled := IniFile.ReadBool(Section, 'EkmServerEnabled', DefEkmServerEnabled);
      FParameters.CheckItemCodeEnabled := IniFile.ReadBool(Section, 'CheckItemCodeEnabled', DefCheckItemCodeEnabled);
      FParameters.NewItemStatus := IniFile.ReadInteger(Section, 'NewItemStatus', DefNewItemStatus);
      FParameters.ItemCheckMode := IniFile.ReadInteger(Section, 'ItemCheckMode', DefItemCheckMode);
      FParameters.DiscountMode := IniFile.ReadInteger(Section, 'DiscountMode', DefDiscountMode);
      FParameters.IgnoreDirectIOErrors := IniFile.ReadBool(Section, 'IgnoreDirectIOErrors', DefIgnoreDirectIOErrors);
      FParameters.ModelId := IniFile.ReadInteger(Section, 'ModelId', DefModelId);
      FParameters.ItemTextMode := IniFile.ReadInteger(Section, 'ItemTextMode', DefItemTextMode);
      FParameters.CorrectCashlessAmount := IniFile.ReadBool(Section, 'CorrectCashlessAmount', DefCorrectCashlessAmount);
    end;
    // VatCodes
    Section := GetSectionName(DeviceName) + '_VatCodes';
    if IniFile.SectionExists(Section) then
    begin
      FParameters.VatCodes.Clear;
      Names := TTntStringList.Create;
      try
        IniFile.ReadSection(Section, Names);
        for i := 0 to Names.Count-1 do
        begin
          AppVatCode := StrToInt(Names[i]);
          FptrVatCode := IniFile.ReadInteger(Section, Names[i], 0);
          FParameters.VatCodes.Add(AppVatCode, FptrVatCode);
        end;
      finally
        Names.Free;
     end;
    end;
    // Payment types
    Section := GetSectionName(DeviceName) + '_PaymentTypes';
    if IniFile.SectionExists(Section) then
    begin
      FParameters.PayTypes.Clear;
      Names := TTntStringList.Create;
      try
        IniFile.ReadSection(Section, Names);
        for i := 0 to Names.Count-1 do
        begin
          PayTypeText := Names[i];
          PayTypeCode := IniFile.ReadInteger(Section, PayTypeText, 0);
          FParameters.PayTypes.Add(PayTypeCode, PayTypeText);
        end;
      finally
        Names.Free;
      end;
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TPrinterParametersIni.SaveSysParameters(const DeviceName: WideString);
var
  i: Integer;
  Section: WideString;
  IniFile: TSmIniFile;
  VatCode: TVatCode;
begin
  IniFile := TSmIniFile.Create(GetIniFileName);
  try
    Section := GetSectionName(DeviceName);
    IniFile.WriteInteger(Section, 'ConnectionType', Parameters.ConnectionType);
    IniFile.WriteInteger(Section, 'RemotePort', Parameters.RemotePort);
    IniFile.WriteText(Section, 'RemoteHost', Parameters.RemoteHost);
    IniFile.WriteInteger(Section, 'PortNumber', Parameters.PortNumber);
    IniFile.WriteInteger(Section, 'BaudRate', Parameters.BaudRate);
    IniFile.WriteInteger(Section, 'SysPassword', Parameters.SysPassword);
    IniFile.WriteInteger(Section, 'UsrPassword', Parameters.UsrPassword);
    IniFile.WriteText(Section, 'SubtotalText', Parameters.SubtotalText);
    IniFile.WriteText(Section, 'CloseRecText', Parameters.CloseRecText);
    IniFile.WriteText(Section, 'VoidRecText', Parameters.VoidRecText);
    IniFile.WriteInteger(Section, 'FontNumber', Parameters.FontNumber);
    IniFile.WriteInteger(Section, 'ByteTimeout', Parameters.ByteTimeout);
    IniFile.WriteInteger(Section, 'MaxRetryCount', Parameters.MaxRetryCount);
    IniFile.WriteBool(Section, 'SearchByPortEnabled', Parameters.SearchByPortEnabled);
    IniFile.WriteBool(Section, 'SearchByBaudRateEnabled', Parameters.SearchByBaudRateEnabled);
    IniFile.WriteInteger(Section, 'PollIntervalInSeconds', Parameters.PollIntervalInSeconds);
    IniFile.WriteInteger(Section, 'DeviceByteTimeout', Parameters.DeviceByteTimeout);
    IniFile.WriteInteger(Section, 'StatusInterval', Parameters.StatusInterval);
    IniFile.WriteBool(Section, 'LogFileEnabled', Parameters.LogFileEnabled);
    IniFile.WriteInteger(Section, 'CutType', Parameters.CutType);
    IniFile.WriteInteger(Section, 'LogoPosition', Parameters.LogoPosition);
    IniFile.WriteInteger(Section, 'NumHeaderLines', Parameters.NumHeaderLines);
    IniFile.WriteInteger(Section, 'NumTrailerLines', Parameters.NumTrailerLines);
    IniFile.WriteInteger(Section, 'HeaderFont', Parameters.HeaderFont);
    IniFile.WriteInteger(Section, 'TrailerFont', Parameters.TrailerFont);
    IniFile.WriteInteger(Section, 'Encoding', Parameters.Encoding);
    IniFile.WriteInteger(Section, 'BarLinePrintDelay', Parameters.BarLinePrintDelay);
    // Training mode text params
    IniFile.WriteInteger(Section, 'StatusCommand', Parameters.StatusCommand);
    IniFile.WriteInteger(Section, 'HeaderType', Parameters.HeaderType);
    IniFile.WriteInteger(Section, 'CompatLevel', Parameters.CompatLevel);
    IniFile.WriteInteger(Section, 'ReceiptType', Parameters.ReceiptType);
    IniFile.WriteInteger(Section, 'ZeroReceiptType', Parameters.ZeroReceiptType);
    IniFile.WriteInteger(Section, 'CCOType', Parameters.CCOType);
    IniFile.WriteBool(Section, 'TableEditEnabled', Parameters.TableEditEnabled);
    IniFile.WriteBool(Section, 'XmlZReportEnabled', Parameters.XmlZReportEnabled);
    IniFile.WriteBool(Section, 'CsvZReportEnabled', Parameters.CsvZReportEnabled);
    IniFile.WriteString(Section, 'XmlZReportFileName', Parameters.XmlZReportFileName);
    IniFile.WriteString(Section, 'CsvZReportFileName', Parameters.CsvZReportFileName);
    IniFile.WriteInteger(Section, 'LogMaxCount', Parameters.LogMaxCount);
    IniFile.WriteBool(Section, 'VoidReceiptOnMaxItems', Parameters.VoidReceiptOnMaxItems);
    IniFile.WriteInteger(Section, 'MaxReceiptItems', Parameters.MaxReceiptItems);
    IniFile.WriteBool(Section, 'JournalPrintHeader', FParameters.JournalPrintHeader);
    IniFile.WriteBool(Section, 'JournalPrintTrailer', FParameters.JournalPrintTrailer);
    IniFile.WriteBool(Section, 'CacheReceiptNumber', FParameters.CacheReceiptNumber);
    IniFile.WriteInteger(Section, 'BarLineByteMode', FParameters.BarLineByteMode);
    IniFile.WriteBool(Section, 'PrintRecSubtotal', FParameters.PrintRecSubtotal);
    IniFile.WriteInteger(Section, 'StatusTimeout', FParameters.StatusTimeout);
    IniFile.WriteBool(Section, 'SetHeaderLineEnabled', FParameters.SetHeaderLineEnabled);
    IniFile.WriteBool(Section, 'SetTrailerLineEnabled', FParameters.SetTrailerLineEnabled);

    IniFile.WriteInteger(Section, 'RFAmountLength', FParameters.RFAmountLength);
    IniFile.WriteInteger(Section, 'RFQuantityLength', FParameters.RFQuantityLength);
    IniFile.WriteInteger(Section, 'RFSeparatorLine', FParameters.RFSeparatorLine);
    IniFile.WriteBool(Section, 'RFShowTaxLetters', FParameters.RFShowTaxLetters);
    IniFile.WriteInteger(Section, 'MonitoringPort', FParameters.MonitoringPort);
    IniFile.WriteBool(Section, 'MonitoringEnabled', FParameters.MonitoringEnabled);
    IniFile.WriteInteger(Section, 'PropertyUpdateMode', FParameters.PropertyUpdateMode);
    IniFile.WriteString(Section, 'ReceiptReportFileName', FParameters.ReceiptReportFileName);
    IniFile.WriteBool(Section, 'ReceiptReportEnabled', FParameters.ReceiptReportEnabled);
    IniFile.WriteBool(Section, 'ZReceiptBeforeZReport', FParameters.ZReceiptBeforeZReport);
    IniFile.WriteBool(Section, 'DepartmentInText', FParameters.DepartmentInText);
    IniFile.WriteBool(Section, 'CenterHeader', FParameters.CenterHeader);
    IniFile.WriteInteger(Section, 'AmountDecimalPlaces', FParameters.AmountDecimalPlaces);
    IniFile.WriteInteger(Section, 'CapRecNearEndSensorMode', FParameters.CapRecNearEndSensorMode);
    IniFile.WriteString(Section, 'FPSerial', FParameters.FPSerial);
    IniFile.WriteString(Section, 'LogFilePath', FParameters.LogFilePath);
    IniFile.WriteBool(Section, 'ReportDateStamp', FParameters.ReportDateStamp);
    IniFile.WriteBool(Section, 'FSBarcodeEnabled', FParameters.FSBarcodeEnabled);
    IniFile.WriteBool(Section, 'FSAddressEnabled', FParameters.FSAddressEnabled);
    IniFile.WriteBool(Section, 'FSUpdatePrice', FParameters.FSUpdatePrice);

    IniFile.WriteString(Section, 'BarcodePrefix', FParameters.BarcodePrefix);
    IniFile.WriteInteger(Section, 'BarcodeHeight', FParameters.BarcodeHeight);
    IniFile.WriteInteger(Section, 'BarcodeType', FParameters.BarcodeType);
    IniFile.WriteInteger(Section, 'BarcodeModuleWidth', FParameters.BarcodeModuleWidth);
    IniFile.WriteInteger(Section, 'BarcodeAlignment', FParameters.BarcodeAlignment);
    IniFile.WriteInteger(Section, 'BarcodeParameter1', FParameters.BarcodeParameter1);
    IniFile.WriteInteger(Section, 'BarcodeParameter2', FParameters.BarcodeParameter2);
    IniFile.WriteInteger(Section, 'BarcodeParameter3', FParameters.BarcodeParameter3);
    IniFile.WriteInteger(Section, 'XReport', FParameters.XReport);
    IniFile.WriteBool(Section, 'WrapText', FParameters.WrapText);
    IniFile.WriteBool(Section, 'WritePaymentNameEnabled', FParameters.WritePaymentNameEnabled);
    IniFile.WriteInteger(Section, 'TimeUpdateMode', FParameters.TimeUpdateMode);
    IniFile.WriteText(Section, 'ReceiptItemsHeader', FParameters.ReceiptItemsHeader);
    IniFile.WriteText(Section, 'ReceiptItemsTrailer', FParameters.ReceiptItemsTrailer);
    IniFile.WriteText(Section, 'ReceiptItemFormat', FParameters.ReceiptItemFormat);
    IniFile.WriteInteger(Section, 'RecPrintType', FParameters.RecPrintType);
    IniFile.WriteBool(Section, 'PrintSingleQuantity', FParameters.PrintSingleQuantity);
    IniFile.WriteString(Section, 'TableFilePath', FParameters.TableFilePath);
    IniFile.WriteBool(Section, 'VatCodeEnabled', FParameters.VatCodeEnabled);
    IniFile.WriteBool(Section, 'HandleErrorCode', FParameters.HandleErrorCode);
    IniFile.WriteBool(Section, 'FSServiceEnabled', FParameters.FSServiceEnabled);
    IniFile.WriteInteger(Section, 'PrinterProtocol', FParameters.PrinterProtocol);
    IniFile.WriteBool(Section, 'PrintUnitName', FParameters.PrintUnitName);
    IniFile.WriteBool(Section, 'OpenReceiptEnabled', FParameters.OpenReceiptEnabled);
    IniFile.WriteInteger(Section, 'QuantityDecimalPlaces', FParameters.QuantityDecimalPlaces);
    IniFile.WriteBool(Section, 'PingEnabled', FParameters.PingEnabled);
    IniFile.WriteInteger(Section, 'DocumentBlockSize', FParameters.DocumentBlockSize);
    IniFile.WriteInteger(Section, 'PrintRecMessageMode', FParameters.PrintRecMessageMode);

    IniFile.WriteString(Section, 'EkmServerHost', FParameters.EkmServerHost);
    IniFile.WriteInteger(Section, 'EkmServerPort', FParameters.EkmServerPort);
    IniFile.WriteInteger(Section, 'EkmServerTimeout', FParameters.EkmServerTimeout);
    IniFile.WriteBool(Section, 'EkmServerEnabled', FParameters.EkmServerEnabled);
    IniFile.WriteBool(Section, 'CheckItemCodeEnabled', FParameters.CheckItemCodeEnabled);
    IniFile.WriteInteger(Section, 'NewItemStatus', FParameters.NewItemStatus);
    IniFile.WriteInteger(Section, 'ItemCheckMode', FParameters.ItemCheckMode);
    IniFile.WriteInteger(Section, 'DiscountMode', FParameters.DiscountMode);
    IniFile.WriteBool(Section, 'IgnoreDirectIOErrors', FParameters.IgnoreDirectIOErrors);
    IniFile.WriteInteger(Section, 'ModelId', FParameters.ModelId);
    IniFile.WriteInteger(Section, 'ItemTextMode', FParameters.ItemTextMode);
    IniFile.WriteBool(Section, 'CorrectCashlessAmount', FParameters.CorrectCashlessAmount);

    // PayTypes
    Section := GetSectionName(DeviceName) + '_PaymentTypes';
    IniFile.EraseSection(Section);
    for i := 0 to Parameters.PayTypes.Count-1 do
    begin
      IniFile.WriteInteger(Section, Parameters.PayTypes[i].Text,
        Parameters.PayTypes[i].Code);
    end;
    // VatCodes
    Section := GetSectionName(DeviceName) + '_VatCodes';
    IniFile.EraseSection(Section);
    for i := 0 to Parameters.VatCodes.Count-1 do
    begin
      VatCode := Parameters.VatCodes[i];
      IniFile.WriteInteger(Section, IntToStr(VatCode.AppVatCode),
        VatCode.FptrVatCode);
    end;
  finally
    IniFile.Free;
  end;
end;

procedure TPrinterParametersIni.SaveUsrParameters(const DeviceName: WideString);
var
  Section: WideString;
  IniFile: TSmIniFile;
begin
  IniFile := TSmIniFile.Create(GetIniFileName);
  try
    Section := GetSectionName(DeviceName);

    IniFile.WriteText(Section, 'Header', Parameters.Header);
    IniFile.WriteText(Section, 'Trailer', Parameters.Trailer);
    IniFile.WriteBool(Section, 'HeaderPrinted', Parameters.HeaderPrinted);
    IniFile.WriteInteger(Section, 'LogoSize', Parameters.LogoSize);
    IniFile.WriteBool(Section, 'LogoReloadEnabled', Parameters.LogoReloadEnabled);
    IniFile.WriteBool(Section, 'LogoCenter', Parameters.LogoCenter);
    IniFile.WriteBool(Section, 'IsLogoLoaded', Parameters.IsLogoLoaded);
    IniFile.WriteString(Section, 'LogoFileName', Parameters.LogoFileName);
    IniFile.WriteInteger(Section, 'Department', Parameters.Department);
    IniFile.WriteInteger(Section, 'ZeroReceiptNumber', Parameters.ZeroReceiptNumber);
  finally
    IniFile.Free;
  end;
end;

class function TPrinterParametersIni.DoReadStorage(
  const DeviceName: WideString): Integer;
var
  Section: WideString;
  IniFile: TSmIniFile;
begin
  Result := StorageIni;
  IniFile := TSmIniFile.Create(GetIniFileName);
  try
    Section := GetSectionName(DeviceName);
    if IniFile.SectionExists(Section) then
    begin
      Result := IniFile.ReadInteger(Section, 'Storage', StorageIni);
    end;
  finally
    IniFile.Free;
  end;
end;

class function TPrinterParametersIni.ReadStorage(
  const DeviceName: WideString): Integer;
begin
  Result := StorageIni;
  try
    Result := DoReadStorage(DeviceName);
  except

  end;
end;

class procedure TPrinterParametersIni.DoSaveStorage(
  const DeviceName: WideString;
  Storage: Integer);
var
  Section: WideString;
  IniFile: TSmIniFile;
begin
  IniFile := TSmIniFile.Create(GetIniFileName);
  try
    Section := GetSectionName(DeviceName);
    IniFile.WriteInteger(Section, 'Storage', Storage);
  finally
    IniFile.Free;
  end;
end;

class procedure TPrinterParametersIni.SaveStorage(const DeviceName: WideString;
  Storage: Integer);
begin
  try
    DoSaveStorage(DeviceName, Storage);
  except
  end;
end;

end.
