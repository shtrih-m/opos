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
  MalinaParams;

type
  { TRegressTests }

  TRegressTests = class(TTestCase)
  private
    FDriver: ToleFiscalPrinter;
    FPrinter: TFiscalPrinterImpl;
    FDevice: TTextFiscalPrinterDevice;
    FConnection: TMockPrinterConnection;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckRefundReceipt;
  end;

implementation

{ TRegressTests }

procedure TRegressTests.Setup;
var
  Model: TPrinterModelRec;
  SPrinter: ISharedPrinter;
begin
  inherited Setup;
  LoadParametersEnabled := False;
  CommandDefsLoadEnabled := False;

  FDevice := TTextFiscalPrinterDevice.Create;
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
  inherited TearDown;
end;

procedure TRegressTests.CheckRefundReceipt;
begin
  Check(FiscalPrinter.ResetPrinter());
  FiscalPrinter.FiscalReceiptType := FPTR_RT_SALES;
  FiscalPrinter.BeginFiscalReceipt(True);
  FiscalPrinter.PrintRecItemRefund('¿»-95', 100, 2551, 4, 39.2, '');
  FiscalPrinter.PrintRecTotal(100, 100, '0');
  FiscalPrinter.EndFiscalReceipt(True);
end;

initialization
  RegisterTest('', TRegressTests.Suite);

end.
