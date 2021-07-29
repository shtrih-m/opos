unit RegressTests;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // Tnt
  TntClasses, 
  // DUnit
  TestFramework,
  // Opos
  Opos, Oposhi, OposFptr, OposFptrHi,
  // This
  FiscalPrinterImpl, oleFiscalPrinter, CommandDef,
  OposFptrUtils, OPOSException, PrinterTypes, DirectIOAPI,
  TextFiscalPrinterDevice, MockSharedPrinter, SharedPrinterInterface,
  FiscalPrinterTypes, DriverTypes, PrinterParameters, PrinterParametersX,
  SharedPrinter, LogFile, StringUtils, MockPrinterConnection, DefaultModel,
  MalinaParams, DriverError, MockFiscalPrinterDevice, PascalMock, FileUtils;

type
  { TRegressTests }

  TRegressTests = class(TTestCase)
  private
    FDriver: ToleFiscalPrinter;
    FPrinter: TFiscalPrinterImpl;
    FDevice: TMockFiscalPrinterDevice;
    FConnection: TMockPrinterConnection;

    property Driver: ToleFiscalPrinter read FDriver;
    property Device: TMockFiscalPrinterDevice read FDevice;
  protected
    procedure Setup; override;
    procedure TearDown; override;

    procedure OpenClaimEnable;
    procedure printFiscalReceipt;
    procedure CheckResult(ResultCode: Integer);
  published
    procedure CheckRefundReceipt;
    procedure Check_NQR_5154;
    procedure Check_NQR_6477;
    procedure Check_NQR_6836;
    procedure Check_NQR_6836_1;
    procedure Check_NQR_2791;
    procedure Check_NQR_5615;
    procedure Check_NQR_5160;
    procedure Check_NQR_6838;
  end;

implementation

const
  DeviceName = 'TestDeviceName';

{ TRegressTests }

procedure TRegressTests.CheckResult(ResultCode: Integer);
var
  Text: string;
  ResultCodeExtended: Integer;
begin
  if ResultCode = OPOS_E_EXTENDED then
  begin
    ResultCodeExtended := Driver.GetPropertyNumber(PIDX_ResultCodeExtended);
    Text := 'OPOS_E_EXTENDED, ' + GetResultCodeExtendedText(ResultCodeExtended);
   Check(False, Text);
  end else
  begin
    CheckEquals(0, ResultCode, EOPOSException.GetResultCodeText(ResultCode));
  end;
end;

procedure TRegressTests.Setup;
var
  Model: TPrinterModelRec;
  SPrinter: ISharedPrinter;
begin
  inherited Setup;
  LoadParametersEnabled := False;
  CommandDefsLoadEnabled := False;

  FDevice := TMockFiscalPrinterDevice.Create;
  FDevice.FCapFiscalStorage := True;
  Model := PrinterModelDefault;
  Model.NumHeaderLines := 0;
  Model.NumTrailerLines := 0;
  FDevice.Model := Model;

  FConnection := TMockPrinterConnection.Create;
  SPrinter := SharedPrinter.GetPrinter(DeviceName);
  SPrinter.Device := FDevice;
  SPrinter.Connection := FConnection;

  FPrinter := TFiscalPrinterImpl.Create(nil);
  FPrinter.SetPrinter(SPrinter);
  FDriver := ToleFiscalPrinter.Create(FPrinter);
end;

procedure TRegressTests.TearDown;
begin
  FDriver.Free;
  FDevice.Free;
  inherited TearDown;
end;

procedure TRegressTests.OpenClaimEnable;
begin
  CheckResult(Driver.Open('FiscalPrinter', DeviceName, nil));
  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DeviceEnabled));
end;

procedure TRegressTests.printFiscalReceipt;
begin
  Driver.SetPropertyNumber(PIDXFptr_FiscalReceiptType, FPTR_RT_SALES);
  CheckResult(Driver.BeginFiscalReceipt(True));
  CheckResult(Driver.PrintRecItem('АИ-95', 100, 2551, 4, 39.2, ''));
  CheckResult(Driver.PrintRecTotal(100, 100, '0'));
  CheckResult(Driver.EndFiscalReceipt(True));
  CheckResult(Driver.Close);
end;

procedure TRegressTests.CheckRefundReceipt;
var
  pData: Integer;
  pString: WideString;
  Method: TMockMethod;
  FSSale: TFSSale2Object;
begin
  pData := DriverParameterParam3;
  pString := '1';
  Driver.DirectIO(DIO_SET_DRIVER_PARAMETER, pData, pString);

  CheckResult(Driver.Open('FiscalPrinter', DeviceName, nil));
  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);

  Driver.SetPropertyNumber(PIDXFptr_FiscalReceiptType, FPTR_RT_SALES);
  CheckResult(Driver.BeginFiscalReceipt(True));
  CheckResult(Driver.PrintRecItemRefund('АИ-95', 100, 2551, 4, 39.2, ''));
  CheckResult(Driver.PrintRecTotal(100, 100, '0'));
  CheckResult(Driver.EndFiscalReceipt(True));
  CheckResult(Driver.Close);

  Method := Device.CalledMethodByName('FSSale2');
  CheckEquals(1, Length(Method.Params), 'Length(Method.Params)');
  FSSale := TFSSale2Object(Integer(Method.Params[0]));
  CheckEquals('АИ-95', FSSale.Data.Text, 'FSSale.Data.Text');
  CheckEquals(3920, FSSale.Data.Price, 'FSSale.Data.Price');
  CheckEquals(2.551, FSSale.Data.Quantity, 0.001, 'FSSale.Data.Quantity');
  CheckEquals(2, FSSale.Data.RecType, 'FSSale.Data.RecType');
  CheckEquals(10000, FSSale.Data.Total, 'FSSale.Data.Total');
  CheckEquals($FFFFFFFFFF, FSSale.Data.TaxAmount, 'FSSale.Data.TaxAmount');
  CheckEquals(1, FSSale.Data.Department, 'FSSale.Data.Department');
  CheckEquals(4, FSSale.Data.Tax, 'FSSale.Data.Tax');
  CheckEquals('', FSSale.Data.UnitName, 'FSSale.Data.UnitName');
  CheckEquals(4, FSSale.Data.PaymentType, 'FSSale.Data.PaymentType');
  CheckEquals(1, FSSale.Data.PaymentItem, 'FSSale.Data.PaymentItem');

  FSSale.Free;
end;

///////////////////////////////////////////////////////////////////////////////
//
// "Должна быть возможность получать/задавать все необходимые теги по ФФД 1.05
//

procedure TRegressTests.Check_NQR_5154;
begin
  CheckResult(Driver.Open('FiscalPrinter', DeviceName, nil));
  CheckResult(Driver.Claim(0));
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
end;

(*
62	ШТРИХ-Mobile-ПТК	"NQR-6477
NQR-6463"	"Не вычитываются поля:
1) DirectIO 41, 1 - номер фискального документа
2) DirectIO 41, 2 - фискальная подпись документа
3) DirectIO 42, 1 - адрес ОФД
4) DirectIO 42, 2 - порт ОФД
5) DirectIO 42, 3 - таймаут ОФД"	high	драйвер			280318 Обнаружена проблема

*)

procedure TRegressTests.Check_NQR_6477;
var
  pData: Integer;
  pString: WideString;
begin
  OpenClaimEnable;

  pData := 1;
  pString := '';
  CheckResult(Driver.DirectIO(41, pData, pString));
  CheckEquals('0', pString);

  pData := 2;
  pString := '';
  CheckResult(Driver.DirectIO(41, pData, pString));
  CheckEquals('0', pString);

  Device.FSCloseReceiptResult2.Change := 0;
  Device.FSCloseReceiptResult2.DocNumber := 1237865;
  Device.FSCloseReceiptResult2.MacValue := 723645725;

  pData := 1;
  pString := '';
  CheckResult(Driver.DirectIO(41, pData, pString));
  CheckEquals('1237865', pString);

  pData := 2;
  pString := '';
  CheckResult(Driver.DirectIO(41, pData, pString));
  CheckEquals('723645725', pString);
end;

///////////////////////////////////////////////////////////////////////////////
//
// NQR-6836, Слишком короткое время хранения логов

procedure TRegressTests.Check_NQR_6836;
var
  Logger: ILogFile;
  Lines: TStrings;
begin
  Logger := TLogFile.Create;
  Lines := TStringList.Create;
  try
    Logger.MaxCount := 10;
    Logger.Enabled := True;
    Logger.FilePath := GetModulePath + 'Logs\';
    Logger.DeviceName := 'DeviceName1';
    Logger.TimeStampEnabled := False;

    DeleteFile(Logger.GetFileName);
    CheckEquals(False, FileExists(Logger.GetFileName), 'FileExists!');

    Logger.Debug('Line1');
    Logger.Error('Line2');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(2, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');

    Logger.Debug('Line3');
    Logger.Error('Line4');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(4, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');
    CheckEquals('[DEBUG] Line3', Lines[2], 'Lines[2]');
    CheckEquals('[ERROR] Line4', Lines[3], 'Lines[3]');

    Logger.DeviceName := 'DeviceName2';
   DeleteFile(Logger.GetFileName);
    CheckEquals(False, FileExists(Logger.GetFileName), 'FileExists!');

    Logger.Debug('Line1');
    Logger.Error('Line2');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(2, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');

    Logger.Debug('Line3');
    Logger.Error('Line4');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(4, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');
    CheckEquals('[DEBUG] Line3', Lines[2], 'Lines[2]');
    CheckEquals('[ERROR] Line4', Lines[3], 'Lines[3]');
    Logger.CloseFile;

    DeleteFiles(Logger.FilePath  + '*.log');
  finally
    Lines.Free;
  end;
end;

procedure TRegressTests.Check_NQR_6836_1;
var
  Logger: ILogFile;
  FilesPath: string;
  FileNames: TTntStringList;
begin
  FileNames := TTntStringList.Create;
  try
    Logger := TLogFile.Create;
    Logger.MaxCount := 3;
    Logger.Enabled := True;
    Logger.FilePath := GetModulePath + 'Logs';
    Logger.DeviceName := 'Device1';

    FilesPath := GetModulePath + 'Logs\';
    DeleteFiles(FilesPath + '*.log');
    Logger.GetFileNames(FilesPath + '*.log', FileNames);
    CheckEquals(0, FileNames.Count, 'FileNames.Count');

    WriteFileData(FilesPath + 'Device1_2018.02.15.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.16.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.17.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.18.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.19.log', '');

    WriteFileData(FilesPath +'Device2_2018.02.15.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.16.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.17.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.18.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.19.log', '');

    Logger.GetFileNames(FilesPath + '*.log', FileNames);
    CheckEquals(10, FileNames.Count, 'FileNames.Count');
    Logger.CheckFilesMaxCount;

    Logger.GetFileNames(FilesPath + '*.log', FileNames);
    FileNames.Sort;

    CheckEquals(8, FileNames.Count, 'FileNames.Count');
    CheckEquals('Device1_2018.02.17.log', ExtractFileName(FileNames[0]), 'FileNames[0]');
    CheckEquals('Device1_2018.02.18.log', ExtractFileName(FileNames[1]), 'FileNames[1]');
    CheckEquals('Device1_2018.02.19.log', ExtractFileName(FileNames[2]), 'FileNames[2]');
    CheckEquals('Device2_2018.02.15.log', ExtractFileName(FileNames[3]), 'FileNames[3]');
    DeleteFiles(FilesPath + '*.log');
  finally
    FileNames.Free;
  end;
end;

///////////////////////////////////////////////////////////////////////////////
//
// NQR-2791	Обрезается длинное наименование товара
// Обрезается текст
//
///////////////////////////////////////////////////////////////////////////////

procedure TRegressTests.Check_NQR_2791;
var
  Text: WideString;
  Method: TMockMethod;
  FSSale: TFSSale2Object;
begin
  OpenClaimEnable;

  Text := 'Превышение номинальной стоимости подарочного сертификата над продажной ценой товара';
  Driver.SetPropertyNumber(PIDXFptr_FiscalReceiptType, FPTR_RT_SALES);
  CheckResult(Driver.BeginFiscalReceipt(True));
  CheckResult(Driver.PrintRecItem(Text, 100, 2551, 4, 39.2, ''));
  CheckResult(Driver.PrintRecTotal(100, 100, '0'));
  CheckResult(Driver.EndFiscalReceipt(True));
  CheckResult(Driver.Close);

  Method := Device.CalledMethodByName('FSSale2');
  CheckEquals(1, Length(Method.Params), 'Length(Method.Params)');
  FSSale := TFSSale2Object(Integer(Method.Params[0]));
  CheckEquals(Text, FSSale.Data.Text, 'FSSale.Data.Text');
end;

///////////////////////////////////////////////////////////////////////////////
//
// NQR-5615	Некорректный текст ошибки в случае, когда смена превысила 24 часа
//
///////////////////////////////////////////////////////////////////////////////

procedure TRegressTests.Check_NQR_5615;
var
  ResultCode: Integer;
  Status: TPrinterStatus;
begin
  OpenClaimEnable;
  Status.Mode := ECRMODE_24OVER;
  Status.Flags.Value := 0;
  Status.AdvancedMode := 0;
  Device.Status := Status;
  Driver.SetPropertyNumber(PIDXFptr_FiscalReceiptType, FPTR_RT_SALES);
  ResultCode := Driver.BeginFiscalReceipt(True);
  CheckEquals(OPOS_E_EXTENDED, ResultCode,
    'BeginFiscalReceipt <> OPOS_E_EXTENDED');

  CheckEquals(OPOS_E_EXTENDED,
    Driver.GetPropertyNumber(PIDX_ResultCode),
    'Driver.GetPropertyNumber(PIDX_ResultCode)');

  CheckEquals(OPOS_EFPTR_DAY_END_REQUIRED,
    Driver.GetPropertyNumber(PIDX_ResultCodeExtended),
    'GetPropertyNumber(PIDX_ResultCodeExtended)');

  CheckEquals('Истекли 24 часа. Распечатайте Z отчет и попробуйте снова',
    Driver.GetPropertyString(PIDXFptr_ErrorString),
    'GetPropertyString(PIDXFptr_ErrorString)');

end;

///////////////////////////////////////////////////////////////////////////////
//
// NQR-5160	Открытие смены командой OPOS
//
///////////////////////////////////////////////////////////////////////////////

procedure TRegressTests.Check_NQR_5160;
var
  pData: Integer;
  Method: TMockMethod;
  pString: WideString;
  Status: TPrinterStatus;
begin
  Status.Mode := ECRMODE_CLOSED;
  Status.Flags.Value := 0;
  Status.AdvancedMode := 0;
  Device.Status := Status;

  OpenClaimEnable;

  pData := 0;
  pString := '';
  CheckResult(Driver.DirectIO(DIO_OPEN_DAY, pData, pString));
  Method := Device.CalledMethodByName('OpenFiscalDay');
  CheckEquals(True, Method.ReturnValue, 'Method.ReturnValue');
end;

///////////////////////////////////////////////////////////////////////////////
//
// NQR-6838 	Сумма всех типов оплаты меньше итога чека
//
///////////////////////////////////////////////////////////////////////////////

procedure TRegressTests.Check_NQR_6838;
begin
  // ???
end;

initialization
  RegisterTest('', TRegressTests.Suite);

end.
