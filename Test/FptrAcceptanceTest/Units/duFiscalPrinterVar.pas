unit duFiscalPrinterVar;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ActiveX, ComObj, Variants,
  // DUnit
  TestFramework, OposFptrUtils;

type
  { TFiscalPrinterVarTest }

  TFiscalPrinterVarTest = class(TTestCase)
  private
    Printer: OleVariant;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckOpen;
    procedure CheckOpenMulti;
  end;

implementation

{ TFiscalPrinterVarTest }

procedure TFiscalPrinterVarTest.Setup;
begin
  inherited Setup;
  Printer := CreateOleObject('OPOS.FiscalPrinter');
end;

procedure TFiscalPrinterVarTest.TearDown;
begin
  inherited TearDown;
  VarClear(Printer);
end;

procedure TFiscalPrinterVarTest.CheckOpen;
begin
  CheckEquals(0, Printer.Open('SHTRIH-M-OPOS-1'),
    'Printer.Open(''SHTRIH-M-OPOS-1'')');
  CheckEquals(0, Printer.ClaimDevice(0), 'Printer.ClaimDevice(0)');
  Printer.DeviceEnabled := True;
  CheckEquals(True, Printer.DeviceEnabled, 'Printer.DeviceEnabled = False');
  Printer.DeviceEnabled := False;
  CheckEquals(False, Printer.DeviceEnabled, 'Printer.DeviceEnabled = True');
  CheckEquals(0, Printer.ReleaseDevice, 'Printer.ReleaseDevice');
  CheckEquals(0, Printer.Close, 'Printer.Close');
end;

procedure TFiscalPrinterVarTest.CheckOpenMulti;
var
  i: Integer;
begin
  for i := 1 to 3 do
  begin
    CheckOpen;
  end;
end;

initialization
  RegisterTest('', TFiscalPrinterVarTest.Suite);


end.
