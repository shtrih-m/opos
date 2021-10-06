unit PrinterParametersRegIBT;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Registry,
  // 3'd
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  PrinterParameters, FileUtils, LogFile, SmIniFile, Oposhi, WException,
  TntSysUtils, DriverError, gnugettext;

type
  { TPrinterParametersRegIBT }

  TPrinterParametersRegIBT = class
  private
    FLogger: ILogFile;
    FParameters: TPrinterParameters;
    procedure LoadIBTParameters;
    procedure SaveIBTParameters;
    procedure LoadSysParameters(const DeviceName: WideString);
    procedure LoadUsrParameters(const DeviceName: WideString);
    procedure SaveSysParameters(const DeviceName: WideString);
    procedure SaveUsrParameters(const DeviceName: WideString);
    class function GetUsrKeyName(const DeviceName: WideString): WideString;
    property Parameters: TPrinterParameters read FParameters;
    class function GetSysKeyName(const DeviceName: WideString): WideString;
  public
    constructor Create(AParameters: TPrinterParameters; ALogger: ILogFile);
    procedure Load(const DeviceName: WideString);
    procedure Save(const DeviceName: WideString);
    property Logger: ILogFile read FLogger;
  end;

function ReadEncodingRegIBT(const DeviceName: WideString; Logger: ILogFile): Integer;

procedure DeleteParametersRegIBT(const DeviceName: WideString; Logger: ILogFile);

procedure LoadParametersRegIBT(Item: TPrinterParameters; const DeviceName: WideString; Logger: ILogFile);

procedure SaveParametersRegIBT(Item: TPrinterParameters; const DeviceName: WideString; Logger: ILogFile);

procedure SaveUsrParametersRegIBT(Item: TPrinterParameters; const DeviceName: WideString; Logger: ILogFile);

implementation

const
  REG_KEY_VATCODES = 'VatCodes';
  REG_KEY_PAYTYPES = 'PaymentTypes';
  REGSTR_KEY_IBT = 'SOFTWARE\POSITIVE\POSITIVE32\Terminal';

function ReadEncodingRegIBT(const DeviceName: WideString; Logger: ILogFile): Integer;
var
  P: TPrinterParameters;
begin
  P := TPrinterParameters.Create(Logger);
  try
    LoadParametersRegIBT(P, DeviceName, Logger);
    Result := P.Encoding;
  finally
    P.Free;
  end;
end;

procedure DeleteParametersRegIBT(const DeviceName: WideString; Logger: ILogFile);
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.DeleteKey(TPrinterParametersRegIBT.GetUsrKeyName(DeviceName));
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.DeleteKey(TPrinterParametersRegIBT.GetSysKeyName(DeviceName));
  except
    on E: Exception do
      Logger.Error('TPrinterParametersReg.Save', E);
  end;
  Reg.Free;
end;

procedure LoadParametersRegIBT(Item: TPrinterParameters; const DeviceName: WideString; Logger: ILogFile);
var
  Reader: TPrinterParametersRegIBT;
begin
  Reader := TPrinterParametersRegIBT.Create(Item, Logger);
  try
    Reader.Load(DeviceName);
  finally
    Reader.Free;
  end;
end;

procedure SaveParametersRegIBT(Item: TPrinterParameters; const DeviceName: WideString; Logger: ILogFile);
var
  Writer: TPrinterParametersRegIBT;
begin
  Writer := TPrinterParametersRegIBT.Create(Item, Logger);
  try
    Writer.Save(DeviceName);
  finally
    Writer.Free;
  end;
end;

procedure SaveUsrParametersRegIBT(Item: TPrinterParameters; const DeviceName: WideString; Logger: ILogFile);
var
  Writer: TPrinterParametersRegIBT;
begin
  Writer := TPrinterParametersRegIBT.Create(Item, Logger);
  try
    Writer.SaveUsrParameters(DeviceName);
  finally
    Writer.Free;
  end;
end;

{ TPrinterParametersRegIBT }

constructor TPrinterParametersRegIBT.Create(AParameters: TPrinterParameters; ALogger: ILogFile);
begin
  inherited Create;
  FParameters := AParameters;
  FLogger := ALogger;
end;

class function TPrinterParametersRegIBT.GetSysKeyName(const DeviceName: WideString): WideString;
begin
  Result := Tnt_WideFormat('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

procedure TPrinterParametersRegIBT.Load(const DeviceName: WideString);
begin
  try
    LoadIBTParameters;
    LoadSysParameters(DeviceName);
    LoadUsrParameters(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TPrinterParametersRegIBT.Load', E);
    end;
  end;
end;

procedure TPrinterParametersRegIBT.Save(const DeviceName: WideString);
begin
  try
    SaveIBTParameters;
    SaveUsrParameters(DeviceName);
    SaveSysParameters(DeviceName);
  except
    on E: Exception do
      Logger.Error('TPrinterParametersRegIBT.Save', E);
  end;
end;

procedure TPrinterParametersRegIBT.LoadIBTParameters;
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TPrinterParametersRegIBT.LoadIBTParameters');

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_IBT, False) then
    begin
      if Reg.ValueExists('IBTHeader') then
        Parameters.Header := Reg.ReadString('IBTHeader');

      if Reg.ValueExists('IBTTrailer') then
        Parameters.Trailer := Reg.ReadString('IBTTrailer');
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParametersRegIBT.SaveIBTParameters;
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TPrinterParametersRegIBT.SaveIBTParameters');

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_IBT, True) then
    begin
      if Parameters.SetHeaderLineEnabled then
        Reg.WriteString('IBTHeader', Parameters.Header);

      if Parameters.SetTrailerLineEnabled then
        Reg.WriteString('IBTTrailer', Parameters.Trailer);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParametersRegIBT.LoadSysParameters(const DeviceName: WideString);
var
  i: Integer;
  Reg: TTntRegistry;
  Names: TTntStrings;
  KeyName: WideString;
  PayTypeText: WideString;
  PayTypeCode: Integer;
  AppVatCode: Integer;
  FptrVatCode: Integer;
begin
  Logger.Debug('TPrinterParametersRegIBT.Load', [DeviceName]);

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetSysKeyName(DeviceName);
    if Reg.OpenKey(KeyName, False) then
    begin
      if Reg.ValueExists('RemoteHost') then
        Parameters.RemoteHost := Reg.ReadString('RemoteHost');

      if Reg.ValueExists('RemotePort') then
        Parameters.RemotePort := Reg.ReadInteger('RemotePort');

      if Reg.ValueExists('ConnectionType') then
        Parameters.ConnectionType := Reg.ReadInteger('ConnectionType');

      if Reg.ValueExists('ComNumber') then
        Parameters.PortNumber := Reg.ReadInteger('ComNumber');

      if Reg.ValueExists('BaudRate') then
        Parameters.BaudRate := Reg.ReadInteger('BaudRate');

      if Reg.ValueExists('SysPassword') then
        Parameters.SysPassword := Reg.ReadInteger('SysPassword');

      if Reg.ValueExists('UsrPassword') then
        Parameters.UsrPassword := Reg.ReadInteger('UsrPassword');

      if Reg.ValueExists('SubtotalText') then
        Parameters.SubtotalText := Reg.ReadString('SubtotalText');

      if Reg.ValueExists('CloseRecText') then
        Parameters.CloseRecText := Reg.ReadString('CloseRecText');

      if Reg.ValueExists('VoidRecText') then
        Parameters.VoidRecText := Reg.ReadString('VoidRecText');

      if Reg.ValueExists('FontNumber') then
        Parameters.FontNumber := Reg.ReadInteger('FontNumber');

      if Reg.ValueExists('ByteTimeout') then
        Parameters.ByteTimeout := Reg.ReadInteger('ByteTimeout');

      if Reg.ValueExists('MaxRetryCount') then
        Parameters.MaxRetryCount := Reg.ReadInteger('MaxRetryCount');

      if Reg.ValueExists('SearchByPortEnabled') then
        Parameters.SearchByPortEnabled := Reg.ReadBool('SearchByPortEnabled');

      if Reg.ValueExists('SearchByBaudRateEnabled') then
        Parameters.SearchByBaudRateEnabled := Reg.ReadBool('SearchByBaudRateEnabled');

      if Reg.ValueExists('PollIntervalInSeconds') then
        Parameters.PollIntervalInSeconds := Reg.ReadInteger('PollIntervalInSeconds');

      if Reg.ValueExists('DeviceByteTimeout') then
        Parameters.DeviceByteTimeout := Reg.ReadInteger('DeviceByteTimeout');

      if Reg.ValueExists('StatusInterval') then
        Parameters.StatusInterval := Reg.ReadInteger('StatusInterval');

      if Reg.ValueExists('LogFileEnabled') then
        Parameters.LogFileEnabled := Reg.ReadBool('LogFileEnabled');

      if Reg.ValueExists('CutType') then
        Parameters.CutType := Reg.ReadInteger('CutType');

      if Reg.ValueExists('LogoPosition') then
        Parameters.LogoPosition := Reg.ReadInteger('LogoPosition');

      if Reg.ValueExists('NumHeaderLines') then
        Parameters.NumHeaderLines := Reg.ReadInteger('NumHeaderLines');

      if Reg.ValueExists('NumTrailerLines') then
        Parameters.NumTrailerLines := Reg.ReadInteger('NumTrailerLines');

      if Reg.ValueExists('HeaderFont') then
        Parameters.HeaderFont := Reg.ReadInteger('HeaderFont');

      if Reg.ValueExists('TrailerFont') then
        Parameters.TrailerFont := Reg.ReadInteger('TrailerFont');

      if Reg.ValueExists('Encoding') then
        Parameters.Encoding := Reg.ReadInteger('Encoding');

      if Reg.ValueExists('StatusCommand') then
        Parameters.StatusCommand := Reg.ReadInteger('StatusCommand');

      if Reg.ValueExists('HeaderType') then
        Parameters.HeaderType := Reg.ReadInteger('HeaderType');

      if Reg.ValueExists('BarLinePrintDelay') then
        Parameters.BarLinePrintDelay := Reg.ReadInteger('BarLinePrintDelay');

      if Reg.ValueExists('CompatLevel') then
        Parameters.CompatLevel := Reg.ReadInteger('CompatLevel');

      if Reg.ValueExists('ReceiptType') then
        Parameters.ReceiptType := Reg.ReadInteger('ReceiptType');

      if Reg.ValueExists('ZeroReceiptType') then
        Parameters.ZeroReceiptType := Reg.ReadInteger('ZeroReceiptType');

      if Reg.ValueExists('CCOType') then
        Parameters.CCOType := Reg.ReadInteger('CCOType');

      if Reg.ValueExists('TableEditEnabled') then
        Parameters.TableEditEnabled := Reg.ReadBool('TableEditEnabled');

      if Reg.ValueExists('XmlZReportEnabled') then
        Parameters.XmlZReportEnabled := Reg.ReadBool('XmlZReportEnabled');

      if Reg.ValueExists('CsvZReportEnabled') then
        Parameters.CsvZReportEnabled := Reg.ReadBool('CsvZReportEnabled');

      if Reg.ValueExists('XmlZReportFileName') then
        Parameters.XmlZReportFileName := Reg.ReadString('XmlZReportFileName');

      if Reg.ValueExists('CsvZReportFileName') then
        Parameters.CsvZReportFileName := Reg.ReadString('CsvZReportFileName');

      if Reg.ValueExists('LogMaxCount') then
        Parameters.LogMaxCount := Reg.ReadInteger('LogMaxCount');

      if Reg.ValueExists('VoidReceiptOnMaxItems') then
        Parameters.VoidReceiptOnMaxItems := Reg.ReadBool('VoidReceiptOnMaxItems');

      if Reg.ValueExists('MaxReceiptItems') then
        Parameters.MaxReceiptItems := Reg.ReadInteger('MaxReceiptItems');

      if Reg.ValueExists('JournalPrintHeader') then
        Parameters.JournalPrintHeader := Reg.ReadBool('JournalPrintHeader');

      if Reg.ValueExists('JournalPrintTrailer') then
        Parameters.JournalPrintTrailer := Reg.ReadBool('JournalPrintTrailer');

      if Reg.ValueExists('CacheReceiptNumber') then
        Parameters.CacheReceiptNumber := Reg.ReadBool('CacheReceiptNumber');

      if Reg.ValueExists('BarLineByteMode') then
        Parameters.BarLineByteMode := Reg.ReadInteger('BarLineByteMode');

      if Reg.ValueExists('PrintRecSubtotal') then
        Parameters.PrintRecSubtotal := Reg.ReadBool('PrintRecSubtotal');

      if Reg.ValueExists('StatusTimeout') then
        Parameters.StatusTimeout := Reg.ReadInteger('StatusTimeout');

      if Reg.ValueExists('SetHeaderLineEnabled') then
        Parameters.SetHeaderLineEnabled := Reg.ReadBool('SetHeaderLineEnabled');

      if Reg.ValueExists('SetTrailerLineEnabled') then
        Parameters.SetTrailerLineEnabled := Reg.ReadBool('SetTrailerLineEnabled');

      if Reg.ValueExists('RFAmountLength') then
        Parameters.RFAmountLength := Reg.ReadInteger('RFAmountLength');

      if Reg.ValueExists('RFSeparatorLine') then
        Parameters.RFSeparatorLine := Reg.ReadInteger('RFSeparatorLine');

      if Reg.ValueExists('RFQuantityLength') then
        Parameters.RFQuantityLength := Reg.ReadInteger('RFQuantityLength');

      if Reg.ValueExists('RFShowTaxLetters') then
        Parameters.RFShowTaxLetters := Reg.ReadBool('RFShowTaxLetters');

      if Reg.ValueExists('MonitoringPort') then
        Parameters.MonitoringPort := Reg.ReadInteger('MonitoringPort');

      if Reg.ValueExists('MonitoringEnabled') then
        Parameters.MonitoringEnabled := Reg.ReadBool('MonitoringEnabled');

      if Reg.ValueExists('PropertyUpdateMode') then
        Parameters.PropertyUpdateMode := Reg.ReadInteger('PropertyUpdateMode');

      if Reg.ValueExists('ReceiptReportFileName') then
        Parameters.ReceiptReportFileName := Reg.ReadString('ReceiptReportFileName');

      if Reg.ValueExists('ReceiptReportEnabled') then
        Parameters.ReceiptReportEnabled := Reg.ReadBool('ReceiptReportEnabled');

      if Reg.ValueExists('ZReceiptBeforeZReport') then
        Parameters.ZReceiptBeforeZReport := Reg.ReadBool('ZReceiptBeforeZReport');

      if Reg.ValueExists('DepartmentInText') then
        Parameters.DepartmentInText := Reg.ReadBool('DepartmentInText');

      if Reg.ValueExists('CenterHeader') then
        Parameters.CenterHeader := Reg.ReadBool('CenterHeader');

      if Reg.ValueExists('AmountDecimalPlaces') then
        Parameters.AmountDecimalPlaces := Reg.ReadInteger('AmountDecimalPlaces');

      if Reg.ValueExists('CapRecNearEndSensorMode') then
        Parameters.CapRecNearEndSensorMode := Reg.ReadInteger('CapRecNearEndSensorMode');

      if Reg.ValueExists('FPSerial') then
        Parameters.FPSerial := Reg.ReadString('FPSerial');

      if Reg.ValueExists('LogFilePath') then
        Parameters.LogFilePath := Reg.ReadString('LogFilePath');

      if Reg.ValueExists('ReportDateStamp') then
        Parameters.ReportDateStamp := Reg.ReadBool('ReportDateStamp');

      if Reg.ValueExists('FSBarcodeEnabled') then
        Parameters.FSBarcodeEnabled := Reg.ReadBool('FSBarcodeEnabled');

      if Reg.ValueExists('FSAddressEnabled') then
        Parameters.FSAddressEnabled := Reg.ReadBool('FSAddressEnabled');

      if Reg.ValueExists('FSUpdatePrice') then
        Parameters.FSUpdatePrice := Reg.ReadBool('FSUpdatePrice');

      if Reg.ValueExists('BarcodePrefix') then
        Parameters.BarcodePrefix := Reg.ReadString('BarcodePrefix');

      if Reg.ValueExists('BarcodeHeight') then
        Parameters.BarcodeHeight := Reg.ReadInteger('BarcodeHeight');

      if Reg.ValueExists('BarcodeType') then
        Parameters.BarcodeType := Reg.ReadInteger('BarcodeType');

      if Reg.ValueExists('BarcodeModuleWidth') then
        Parameters.BarcodeModuleWidth := Reg.ReadInteger('BarcodeModuleWidth');

      if Reg.ValueExists('BarcodeAlignment') then
        Parameters.BarcodeAlignment := Reg.ReadInteger('BarcodeAlignment');

      if Reg.ValueExists('BarcodeParameter1') then
        Parameters.BarcodeParameter1 := Reg.ReadInteger('BarcodeParameter1');

      if Reg.ValueExists('BarcodeParameter2') then
        Parameters.BarcodeParameter2 := Reg.ReadInteger('BarcodeParameter2');

      if Reg.ValueExists('BarcodeParameter3') then
        Parameters.BarcodeParameter3 := Reg.ReadInteger('BarcodeParameter3');

      if Reg.ValueExists('BarcodeParameter4') then
        Parameters.BarcodeParameter4 := Reg.ReadInteger('BarcodeParameter4');

      if Reg.ValueExists('BarcodeParameter5') then
        Parameters.BarcodeParameter5 := Reg.ReadInteger('BarcodeParameter5');

      if Reg.ValueExists('XReport') then
        Parameters.XReport := Reg.ReadInteger('XReport');

      if Reg.ValueExists('WrapText') then
        Parameters.WrapText := Reg.ReadBool('WrapText');

      if Reg.ValueExists('WritePaymentNameEnabled') then
        Parameters.WritePaymentNameEnabled := Reg.ReadBool('WritePaymentNameEnabled');

      if Reg.ValueExists('TimeUpdateMode') then
        Parameters.TimeUpdateMode := Reg.ReadInteger('TimeUpdateMode');

      if Reg.ValueExists('ReceiptItemsHeader') then
        Parameters.ReceiptItemsHeader := Reg.ReadString('ReceiptItemsHeader');

      if Reg.ValueExists('ReceiptItemsTrailer') then
        Parameters.ReceiptItemsTrailer := Reg.ReadString('ReceiptItemsTrailer');

      if Reg.ValueExists('ReceiptItemFormat') then
        Parameters.ReceiptItemFormat := Reg.ReadString('ReceiptItemFormat');

      if Reg.ValueExists('RecPrintType') then
        Parameters.RecPrintType := Reg.ReadInteger('RecPrintType');

      if Reg.ValueExists('PrintSingleQuantity') then
        Parameters.PrintSingleQuantity := Reg.ReadBool('PrintSingleQuantity');

      if Reg.ValueExists('TableFilePath') then
        Parameters.TableFilePath := Reg.ReadString('TableFilePath');

      if Reg.ValueExists('VatCodeEnabled') then
        Parameters.VatCodeEnabled := Reg.ReadBool('VatCodeEnabled');

      if Reg.ValueExists('HandleErrorCode') then
        Parameters.HandleErrorCode := Reg.ReadBool('HandleErrorCode');

      if Reg.ValueExists('FSServiceEnabled') then
        Parameters.FSServiceEnabled := Reg.ReadBool('FSServiceEnabled');

      if Reg.ValueExists('PrinterProtocol') then
        Parameters.PrinterProtocol := Reg.ReadInteger('PrinterProtocol');

      if Reg.ValueExists('PrintUnitName') then
        Parameters.PrintUnitName := Reg.ReadBool('PrintUnitName');

      if Reg.ValueExists('OpenReceiptEnabled') then
        Parameters.OpenReceiptEnabled := Reg.ReadBool('OpenReceiptEnabled');

      if Reg.ValueExists('QuantityDecimalPlaces') then
        Parameters.QuantityDecimalPlaces := Reg.ReadInteger('QuantityDecimalPlaces');

      if Reg.ValueExists('PingEnabled') then
        Parameters.PingEnabled := Reg.ReadBool('PingEnabled');

      if Reg.ValueExists('DocumentBlockSize') then
        Parameters.DocumentBlockSize := Reg.ReadInteger('DocumentBlockSize');

      if Reg.ValueExists('PrintRecMessageMode') then
        Parameters.PrintRecMessageMode := Reg.ReadInteger('PrintRecMessageMode');

      if Reg.ValueExists('EkmServerHost') then
        FParameters.EkmServerHost := Reg.ReadString('EkmServerHost');
      if Reg.ValueExists('EkmServerPort') then
        FParameters.EkmServerPort := Reg.ReadInteger('EkmServerPort');
      if Reg.ValueExists('EkmServerTimeout') then
        FParameters.EkmServerTimeout := Reg.ReadInteger('EkmServerTimeout');
      if Reg.ValueExists('EkmServerEnabled') then
        FParameters.EkmServerEnabled := Reg.ReadBool('EkmServerEnabled');
      if Reg.ValueExists('CheckItemCodeEnabled') then
        FParameters.CheckItemCodeEnabled := Reg.ReadBool('CheckItemCodeEnabled');

      if Reg.ValueExists('NewItemStatus') then
        FParameters.NewItemStatus := Reg.ReadInteger('NewItemStatus');

      if Reg.ValueExists('ItemCheckMode') then
        FParameters.ItemCheckMode := Reg.ReadInteger('ItemCheckMode');

      if Reg.ValueExists('IgnoreDirectIOErrors') then
        FParameters.IgnoreDirectIOErrors := Reg.ReadBool('IgnoreDirectIOErrors');

      if Reg.ValueExists('ModelId') then
        FParameters.ModelId := Reg.ReadInteger('ModelId');

      if Reg.ValueExists('ItemTextMode') then
        FParameters.ItemTextMode := Reg.ReadInteger('ItemTextMode');

      if Reg.ValueExists('CorrectCashlessAmount') then
        FParameters.CorrectCashlessAmount := Reg.ReadBool('CorrectCashlessAmount');

      if Reg.ValueExists('SingleQuantityOnZeroUnitPrice') then
        FParameters.SingleQuantityOnZeroUnitPrice := Reg.ReadBool('SingleQuantityOnZeroUnitPrice');

      if Reg.ValueExists('SendMarkType') then
        FParameters.SendMarkType := Reg.ReadInteger('SendMarkType');

      if Reg.ValueExists('ValidTimeDiffInSecs') then
        FParameters.ValidTimeDiffInSecs := Reg.ReadInteger('ValidTimeDiffInSecs');

      Reg.CloseKey;
    end;
    // VatCodes
    if Reg.OpenKey(KeyName + '\' + REG_KEY_VATCODES, False) then
    begin
      Parameters.VatCodes.Clear;
      Names := TTntStringList.Create;
      try
        Reg.GetValueNames(Names);
        for i := 0 to Names.Count - 1 do
        begin
          AppVatCode := StrToInt(Names[i]);
          FptrVatCode := Reg.ReadInteger(Names[i]);
          Parameters.VatCodes.Add(AppVatCode, FptrVatCode);
        end;
      finally
        Names.Free;
      end;
      Reg.CloseKey;
    end;
    // Payment types
    if Reg.OpenKey(KeyName + '\' + REG_KEY_PAYTYPES, False) then
    begin
      Parameters.PayTypes.Clear;
      Names := TTntStringList.Create;
      try
        Reg.GetValueNames(Names);
        for i := 0 to Names.Count - 1 do
        begin
          PayTypeText := Names[i];
          PayTypeCode := Reg.ReadInteger(PayTypeText);
          Parameters.PayTypes.Add(PayTypeCode, PayTypeText);
        end;
      finally
        Names.Free;
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParametersRegIBT.SaveSysParameters(const DeviceName: WideString);
var
  i: Integer;
  Reg: TTntRegistry;
  KeyName: WideString;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    KeyName := GetSysKeyName(DeviceName);
    if not Reg.OpenKey(KeyName, True) then
      raiseOpenKeyError(KeyName);

    Reg.WriteString('', FiscalPrinterProgID);
    Reg.WriteInteger('ComNumber', Parameters.PortNumber);
    Reg.WriteInteger('BaudRate', Parameters.BaudRate);
    Reg.WriteInteger('DeviceByteTimeout', Parameters.DeviceByteTimeout);
    Reg.WriteBool('SearchByBaudRateEnabled', Parameters.SearchByBaudRateEnabled);
    Reg.WriteBool('SearchByPortEnabled', Parameters.SearchByPortEnabled);
    Reg.WriteInteger('UsrPassword', Parameters.UsrPassword);
    Reg.WriteInteger('SysPassword', Parameters.SysPassword);
    Reg.WriteInteger('CutType', Parameters.CutType);
    Reg.WriteInteger('LogoPosition', Parameters.LogoPosition);

    Reg.WriteInteger('ConnectionType', Parameters.ConnectionType);
    Reg.WriteInteger('RemotePort', Parameters.RemotePort);
    Reg.WriteString('RemoteHost', Parameters.RemoteHost);
    Reg.WriteString('SubtotalText', Parameters.SubtotalText);
    Reg.WriteString('CloseRecText', Parameters.CloseRecText);
    Reg.WriteString('VoidRecText', Parameters.VoidRecText);
    Reg.WriteInteger('FontNumber', Parameters.FontNumber);
    Reg.WriteInteger('ByteTimeout', Parameters.ByteTimeout);
    Reg.WriteInteger('MaxRetryCount', Parameters.MaxRetryCount);
    Reg.WriteInteger('PollIntervalInSeconds', Parameters.PollIntervalInSeconds);

    Reg.WriteInteger('StatusInterval', Parameters.StatusInterval);

    Reg.WriteBool('LogFileEnabled', Parameters.LogFileEnabled);
    Reg.WriteInteger('NumHeaderLines', Parameters.NumHeaderLines);
    Reg.WriteInteger('NumTrailerLines', Parameters.NumTrailerLines);
    Reg.WriteInteger('HeaderFont', Parameters.HeaderFont);
    Reg.WriteInteger('TrailerFont', Parameters.TrailerFont);
    Reg.WriteInteger('Encoding', Parameters.Encoding);
    Reg.WriteInteger('BarLinePrintDelay', Parameters.BarLinePrintDelay);
    Reg.WriteBool('TableEditEnabled', Parameters.TableEditEnabled);
    Reg.WriteInteger('CCOType', Parameters.CCOType);
    // Training mode text params
    Reg.WriteInteger('StatusCommand', Parameters.StatusCommand);
    Reg.WriteInteger('HeaderType', Parameters.HeaderType);
    Reg.WriteInteger('CompatLevel', Parameters.CompatLevel);
    Reg.WriteInteger('ReceiptType', Parameters.ReceiptType);
    Reg.WriteInteger('ZeroReceiptType', Parameters.ZeroReceiptType);
    Reg.WriteBool('XmlZReportEnabled', Parameters.XmlZReportEnabled);
    Reg.WriteBool('CsvZReportEnabled', Parameters.CsvZReportEnabled);
    Reg.WriteString('XmlZReportFileName', Parameters.XmlZReportFileName);
    Reg.WriteString('CsvZReportFileName', Parameters.CsvZReportFileName);
    Reg.WriteInteger('LogMaxCount', Parameters.LogMaxCount);
    Reg.WriteBool('VoidReceiptOnMaxItems', Parameters.VoidReceiptOnMaxItems);
    Reg.WriteInteger('MaxReceiptItems', Parameters.MaxReceiptItems);
    Reg.WriteBool('JournalPrintHeader', Parameters.JournalPrintHeader);
    Reg.WriteBool('JournalPrintTrailer', Parameters.JournalPrintTrailer);
    Reg.WriteBool('CacheReceiptNumber', Parameters.CacheReceiptNumber);
    Reg.WriteInteger('BarLineByteMode', Parameters.BarLineByteMode);
    Reg.WriteBool('PrintRecSubtotal', Parameters.PrintRecSubtotal);
    Reg.WriteInteger('StatusTimeout', Parameters.StatusTimeout);
    Reg.WriteBool('SetHeaderLineEnabled', Parameters.SetHeaderLineEnabled);
    Reg.WriteBool('SetTrailerLineEnabled', Parameters.SetTrailerLineEnabled);
    Reg.WriteInteger('RFAmountLength', Parameters.RFAmountLength);
    Reg.WriteInteger('RFSeparatorLine', Parameters.RFSeparatorLine);
    Reg.WriteInteger('RFQuantityLength', Parameters.RFQuantityLength);
    Reg.WriteBool('RFShowTaxLetters', Parameters.RFShowTaxLetters);
    Reg.WriteInteger('MonitoringPort', Parameters.MonitoringPort);
    Reg.WriteBool('MonitoringEnabled', Parameters.MonitoringEnabled);
    Reg.WriteInteger('PropertyUpdateMode', Parameters.PropertyUpdateMode);
    Reg.WriteString('ReceiptReportFileName', Parameters.ReceiptReportFileName);
    Reg.WriteBool('ReceiptReportEnabled', Parameters.ReceiptReportEnabled);
    Reg.WriteBool('ZReceiptBeforeZReport', Parameters.ZReceiptBeforeZReport);
    Reg.WriteBool('DepartmentInText', Parameters.DepartmentInText);
    Reg.WriteBool('CenterHeader', Parameters.CenterHeader);
    Reg.WriteInteger('AmountDecimalPlaces', Parameters.AmountDecimalPlaces);
    Reg.WriteInteger('CapRecNearEndSensorMode', Parameters.CapRecNearEndSensorMode);
    Reg.WriteString('FPSerial', FParameters.FPSerial);
    Reg.WriteString('LogFilePath', FParameters.LogFilePath);
    Reg.WriteBool('ReportDateStamp', FParameters.ReportDateStamp);
    Reg.WriteBool('FSBarcodeEnabled', FParameters.FSBarcodeEnabled);
    Reg.WriteBool('FSAddressEnabled', FParameters.FSAddressEnabled);
    Reg.WriteBool('FSUpdatePrice', FParameters.FSUpdatePrice);
    Reg.WriteString('BarcodePrefix', FParameters.BarcodePrefix);
    Reg.WriteInteger('BarcodeHeight', FParameters.BarcodeHeight);
    Reg.WriteInteger('BarcodeType', FParameters.BarcodeType);
    Reg.WriteInteger('BarcodeModuleWidth', FParameters.BarcodeModuleWidth);
    Reg.WriteInteger('BarcodeAlignment', FParameters.BarcodeAlignment);
    Reg.WriteInteger('BarcodeParameter1', FParameters.BarcodeParameter1);
    Reg.WriteInteger('BarcodeParameter2', FParameters.BarcodeParameter2);
    Reg.WriteInteger('BarcodeParameter3', FParameters.BarcodeParameter3);
    Reg.WriteInteger('BarcodeParameter4', FParameters.BarcodeParameter4);
    Reg.WriteInteger('BarcodeParameter5', FParameters.BarcodeParameter5);
    Reg.WriteInteger('XReport', FParameters.XReport);
    Reg.WriteBool('WrapText', FParameters.WrapText);
    Reg.WriteBool('WritePaymentNameEnabled', FParameters.WritePaymentNameEnabled);
    Reg.WriteInteger('TimeUpdateMode', FParameters.TimeUpdateMode);
    Reg.WriteString('ReceiptItemsHeader', FParameters.ReceiptItemsHeader);
    Reg.WriteString('ReceiptItemsTrailer', FParameters.ReceiptItemsTrailer);
    Reg.WriteString('ReceiptItemFormat', FParameters.ReceiptItemFormat);
    Reg.WriteInteger('RecPrintType', FParameters.RecPrintType);
    Reg.WriteBool('PrintSingleQuantity', FParameters.PrintSingleQuantity);
    Reg.WriteString('TableFilePath', FParameters.TableFilePath);
    Reg.WriteBool('VatCodeEnabled', FParameters.VatCodeEnabled);
    Reg.WriteBool('HandleErrorCode', FParameters.HandleErrorCode);
    Reg.WriteBool('FSServiceEnabled', FParameters.FSServiceEnabled);
    Reg.WriteInteger('PrinterProtocol', FParameters.PrinterProtocol);
    Reg.WriteBool('PrintUnitName', FParameters.PrintUnitName);
    Reg.WriteBool('OpenReceiptEnabled', FParameters.OpenReceiptEnabled);
    Reg.WriteInteger('QuantityDecimalPlaces', FParameters.QuantityDecimalPlaces);
    Reg.WriteBool('PingEnabled', FParameters.PingEnabled);
    Reg.WriteInteger('DocumentBlockSize', FParameters.DocumentBlockSize);
    Reg.WriteInteger('PrintRecMessageMode', FParameters.PrintRecMessageMode);
    Reg.WriteString('EkmServerHost', FParameters.EkmServerHost);
    Reg.WriteInteger('EkmServerPort', FParameters.EkmServerPort);
    Reg.WriteInteger('EkmServerTimeout', FParameters.EkmServerTimeout);
    Reg.WriteBool('EkmServerEnabled', FParameters.EkmServerEnabled);
    Reg.WriteBool('CheckItemCodeEnabled', FParameters.CheckItemCodeEnabled);
    Reg.WriteInteger('NewItemStatus', FParameters.NewItemStatus);
    Reg.WriteInteger('ItemCheckMode', FParameters.ItemCheckMode);
    Reg.WriteBool('IgnoreDirectIOErrors', FParameters.IgnoreDirectIOErrors);
    Reg.WriteInteger('ModelId', FParameters.ModelId);
    Reg.WriteInteger('ItemTextMode', FParameters.ItemTextMode);
    Reg.WriteBool('CorrectCashlessAmount', FParameters.CorrectCashlessAmount);
    Reg.WriteBool('SingleQuantityOnZeroUnitPrice', FParameters.SingleQuantityOnZeroUnitPrice);
    Reg.WriteInteger('SendMarkType', FParameters.SendMarkType);
    Reg.WriteInteger('ValidTimeDiffInSecs', FParameters.ValidTimeDiffInSecs);
    Reg.CloseKey;

    // VatCodes
    Reg.DeleteKey(KeyName + '\' + REG_KEY_VATCODES);
    if Reg.OpenKey(KeyName + '\' + REG_KEY_VATCODES, True) then
    begin
      for i := 0 to Parameters.VatCodes.Count - 1 do
      begin
        Reg.WriteInteger(IntToStr(Parameters.VatCodes[i].AppVatCode), Parameters.VatCodes[i].FptrVatCode);
      end;
      Reg.CloseKey;
    end;
    // PayTypes
    Reg.DeleteKey(KeyName + '\' + REG_KEY_PAYTYPES);
    if Reg.OpenKey(KeyName + '\' + REG_KEY_PAYTYPES, True) then
    begin
      for i := 0 to Parameters.PayTypes.Count - 1 do
      begin
        Reg.WriteInteger(Parameters.PayTypes[i].Text, Parameters.PayTypes[i].Code);
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

class function TPrinterParametersRegIBT.GetUsrKeyName(const DeviceName: WideString): WideString;
begin
  Result := Tnt_WideFormat('%s\%s\%s', [OPOS_ROOTKEY, OPOS_CLASSKEY_FPTR, DeviceName]);
end;

procedure TPrinterParametersRegIBT.LoadUsrParameters(const DeviceName: WideString);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TPrinterParametersRegIBT.LoadUsrParameters', [DeviceName]);
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(GetUsrKeyName(DeviceName), False) then
    begin
      if Reg.ValueExists('HeaderPrinted') then
        Parameters.HeaderPrinted := Reg.ReadBool('HeaderPrinted');

      if Reg.ValueExists('LogoSize') then
        Parameters.LogoSize := Reg.ReadInteger('LogoSize');

      if Reg.ValueExists('LogoReloadEnabled') then
        Parameters.LogoReloadEnabled := Reg.ReadBool('LogoReloadEnabled');

      if Reg.ValueExists('LogoCenter') then
        Parameters.LogoCenter := Reg.ReadBool('LogoCenter');

      if Reg.ValueExists('IsLogoLoaded') then
        Parameters.IsLogoLoaded := Reg.ReadBool('IsLogoLoaded');

      if Reg.ValueExists('LogoFileName') then
        Parameters.LogoFileName := Reg.ReadString('LogoFileName');

      if Reg.ValueExists('Department') then
        Parameters.Department := Reg.ReadInteger('Department');

      if Reg.ValueExists('ZeroReceiptNumber') then
        Parameters.ZeroReceiptNumber := Reg.ReadInteger('ZeroReceiptNumber');
    end;
  finally
    Reg.Free;
  end;
end;

procedure TPrinterParametersRegIBT.SaveUsrParameters(const DeviceName: WideString);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TPrinterParametersRegIBT.SaveUsrParameters', [DeviceName]);
  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey(GetUsrKeyName(DeviceName), True) then
    begin
      Reg.WriteBool('HeaderPrinted', Parameters.HeaderPrinted);
      Reg.WriteInteger('LogoSize', Parameters.LogoSize);
      Reg.WriteBool('LogoReloadEnabled', Parameters.LogoReloadEnabled);
      Reg.WriteBool('LogoCenter', Parameters.LogoCenter);
      Reg.WriteBool('IsLogoLoaded', Parameters.IsLogoLoaded);
      Reg.WriteString('LogoFileName', Parameters.LogoFileName);
      Reg.WriteInteger('Department', Parameters.Department);
      Reg.WriteInteger('ZeroReceiptNumber', Parameters.ZeroReceiptNumber);
    end
    else
    begin
      raiseException(_('Registry key open error'));
    end;
  finally
    Reg.Free;
  end;
end;

end.

