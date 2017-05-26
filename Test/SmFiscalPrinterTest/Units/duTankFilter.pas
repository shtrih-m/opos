unit duTankFilter;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  TankFilter, TankReader, UniposTank, NonfiscalDoc, MockSharedPrinter,
  FiscalPrinterTypes, PrinterParameters, MockFiscalPrinterDevice,
  FptrFilter, MalinaParams, LogFile, DriverContext;

type
  { TTankFilterTest }

  TTankFilterTest = class(TTestCase)
  private
    Context: TDriverContext;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckEndNonFiscal;
  end;

implementation

{ TTankFilterTest }

procedure TTankFilterTest.Setup;
begin
  Context := TDriverContext.Create;
end;

procedure TTankFilterTest.TearDown;
begin
  Context.Free;
end;

procedure TTankFilterTest.CheckEndNonFiscal;
begin
  Context.Parameters.SetDefaults;
  CheckEquals(DefTankReportKey, Context.MalinaParams.TankReportKey,
    'Parameters.TankReportKey');
  CheckEquals(DefTankReportHeader, Context.MalinaParams.TankReportHeader,
    'Parameters.TankReportHeader');
  CheckEquals(DefTankReportTrailer, Context.MalinaParams.TankReportTrailer,
    'Parameters.TankReportTrailer');
  CheckEquals(DefTankReportItem, Context.MalinaParams.TankReportItem,
    'Parameters.TankReportItem');
end;

initialization
  RegisterTest('', TTankFilterTest.Suite);

end.
