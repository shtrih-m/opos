unit duFiscalPrinterDevice;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework, FiscalPrinterDevice, Opos, OPOSException, OposFptr, DriverError;

type
  { TFiscalPrinterDeviceTest }

  TFiscalPrinterDeviceTest = class(TTestCase)
  private
    Device: TFiscalPrinterDevice;
    procedure CheckErrorCode(Code: Integer);
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestCheck;
  end;

implementation

{ TFiscalPrinterDeviceTest }

procedure TFiscalPrinterDeviceTest.Setup;
begin
  Device := TFiscalPrinterDevice.Create;
end;

procedure TFiscalPrinterDeviceTest.TearDown;
begin
  Device.Free;
end;

procedure TFiscalPrinterDeviceTest.CheckErrorCode(Code: Integer);
begin
  try
    Device.Check(Code);
    Check(False, 'No Exception');
  except
    on E: EDriverError do
    begin
      CheckEquals(E.ErrorCode, Code, 'E.ErrorCode');
    end;
  end;
end;

procedure TFiscalPrinterDeviceTest.TestCheck;
begin
  CheckErrorCode($01); // FM1, Code); FM2 or RTC error
  CheckErrorCode($02); // FM1 missing
end;

initialization
  RegisterTest('', TFiscalPrinterDeviceTest.Suite);

end.


