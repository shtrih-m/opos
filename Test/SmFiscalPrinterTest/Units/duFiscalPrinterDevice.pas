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
    procedure TestSTLV;
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

procedure TFiscalPrinterDeviceTest.TestSTLV;
const
  DataHex =
  'C8042600C9040F008E8E8E2022928F8C20A3E0E3AFAF2293040F00382D3932362D3132332D34352D3637';
begin
  Device.STLVBegin(1224);
  Device.STLVAddTag(1225, 'ÎÎÎ "ÒÏÌ ãðóïï"');
  Device.STLVAddTag(1171, '8-926-123-45-67');
  CheckEquals(DataHex, Device.STLVGetHex, 'Device.STLVGetHex');
end;

initialization
  RegisterTest('', TFiscalPrinterDeviceTest.Suite);

end.


