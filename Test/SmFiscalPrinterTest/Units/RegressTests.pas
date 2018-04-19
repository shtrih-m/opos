unit RegressTests;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
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
  MalinaParams, DriverError, MockFiscalPrinterDevice, PascalMock;

type
  { TRegressTests }

  TRegressTests = class(TTestCase)
  private
    FDriver: ToleFiscalPrinter;
    FPrinter: TFiscalPrinterImpl;
    FDevice: TMockFiscalPrinterDevice;
    FConnection: TMockPrinterConnection;

    procedure OpenClaimEnable;
    procedure printFiscalReceipt;
    procedure CheckResult(ResultCode: Integer);

    property Driver: ToleFiscalPrinter read FDriver;
    property Device: TMockFiscalPrinterDevice read FDevice;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckRefundReceipt;
    procedure Check_NQR5154;
    procedure Check_NQR6477;
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
  Method: TMockMethod;
  FSSale: TFSSale2Object;
begin
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
  CheckEquals($FFFFFFFFFF, FSSale.Data.Total, 'FSSale.Data.Total');
  CheckEquals($FFFFFFFFFF, FSSale.Data.TaxAmount, 'FSSale.Data.TaxAmount');
  CheckEquals(1, FSSale.Data.Department, 'FSSale.Data.Department');
  CheckEquals(4, FSSale.Data.Tax, 'FSSale.Data.Tax');
  CheckEquals('', FSSale.Data.UnitName, 'FSSale.Data.UnitName');
  CheckEquals(0, FSSale.Data.PaymentType, 'FSSale.Data.PaymentType');
  CheckEquals(0, FSSale.Data.PaymentItem, 'FSSale.Data.PaymentItem');
  CheckEquals('', FSSale.Data.ItemBarcode, 'FSSale.Data.ItemBarcode');

  FSSale.Free;
end;

///////////////////////////////////////////////////////////////////////////////
//
// "Должна быть возможность получать/задавать все необходимые теги по ФФД 1.05
//

procedure TRegressTests.Check_NQR5154;
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

procedure TRegressTests.Check_NQR6477;
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


  pData := 1;
  pString := '';
  CheckResult(Driver.DirectIO(42, pData, pString));
  CheckEquals('', pString);

(*
  DIO_FPTR_PARAMETER_OFD_ADDRESS:
  DIO_FPTR_PARAMETER_OFD_PORT:
  DIO_FPTR_PARAMETER_OFD_TIMEOUT:

3) DirectIO 42, 1 - адрес ОФД
4) DirectIO 42, 2 - порт ОФД
5) DirectIO 42, 3 - таймаут ОФД"	high	драйвер			280318 Обнаружена проблема
*)

end;



initialization
  RegisterTest('', TRegressTests.Suite);

end.
