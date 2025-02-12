unit duFiscalPrinter2;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ActiveX,
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
  MalinaParams, MockFiscalPrinterDevice;

type
  { TFiscalPrinterTest2 }

  TFiscalPrinterTest2 = class(TTestCase)
  private
    FDriver: ToleFiscalPrinter;
    FPrinter: TFiscalPrinterImpl;
    FDevice: TMockFiscalPrinterDevice;
  protected
    procedure Setup; override;
    procedure TearDown; override;

    procedure OpenDevice;
    procedure ClaimDevice;
    procedure CheckClaimed;
    procedure EnableDevice;
    procedure OpenClaimEnable;
    procedure CheckResult(ResultCode: Integer);

    function GetParameters: TPrinterParameters;
    property Parameters: TPrinterParameters read GetParameters;
  published
    procedure CheckSetVatTable;
    procedure CheckSetVatValue;

    property Driver: ToleFiscalPrinter read FDriver;
    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: TMockFiscalPrinterDevice read FDevice;
  end;

implementation

const
  DeviceName = 'TestDeviceName';

{ TFiscalPrinterTest2 }

procedure TFiscalPrinterTest2.Setup;
var
  SPrinter: ISharedPrinter;
begin
  inherited Setup;
  CoInitialize(nil);

  LoadParametersEnabled := False;
  CommandDefsLoadEnabled := False;

  FDevice := TMockFiscalPrinterDevice.Create;
  SPrinter := SharedPrinter.GetPrinter(DeviceName);
  SPrinter.Device := FDevice;

  FPrinter := TFiscalPrinterImpl.Create(nil);
  FPrinter.SetPrinter(SPrinter);
  FDriver := ToleFiscalPrinter.Create(FPrinter);
  Parameters.SetDefaults;
end;

procedure TFiscalPrinterTest2.TearDown;
begin
  FDriver.Free;
  FDevice.Free;
  inherited TearDown;
end;

function TFiscalPrinterTest2.GetParameters: TPrinterParameters;
begin
  Result := FPrinter.Parameters;
end;

procedure TFiscalPrinterTest2.OpenDevice;
begin
  CheckResult(Driver.Open('FiscalPrinter', DeviceName, nil));
end;

procedure TFiscalPrinterTest2.ClaimDevice;
begin
  CheckResult(Driver.Claim(0));
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed), 'Claimed=0');
end;

procedure TFiscalPrinterTest2.EnableDevice;
begin
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

procedure TFiscalPrinterTest2.OpenClaimEnable;
begin
  OpenDevice;
  ClaimDevice;
  EnableDevice;
end;

procedure TFiscalPrinterTest2.CheckResult(ResultCode: Integer);
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

procedure TFiscalPrinterTest2.CheckClaimed;
begin
  OpenDevice;
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.Claim(0));
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.ReleaseDevice);
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.Claim(0));
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed));
  CheckResult(Driver.Release1);
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed));
end;


procedure TFiscalPrinterTest2.CheckSetVatTable;
begin
  FDevice.Expects('WriteTaxRate').WithParams([1, 1234]);
  FDevice.Expects('WriteTaxRate').WithParams([5, 6542]);
  FDevice.Expects('WriteTaxRate').WithParams([7, 6867]);

  OpenClaimEnable;
  CheckResult(Driver.SetVatValue(1, '1234'));
  CheckResult(Driver.SetVatValue(5, '6542'));
  CheckResult(Driver.SetVatValue(7, '6867'));
  CheckResult(Driver.SetVatTable);

  FDevice.Verify('Device.Verify');
end;

procedure TFiscalPrinterTest2.CheckSetVatValue;
begin
  OpenClaimEnable;
  CheckResult(Driver.SetVatValue(1, '1234'));
  CheckResult(Driver.SetVatValue(5, '6542'));
  CheckResult(Driver.SetVatValue(7, '6867'));
  FDevice.Verify('Device.Verify');
end;

initialization
  RegisterTest('', TFiscalPrinterTest2.Suite);

end.
