unit duMalinaFilter;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  MalinaFilter, FiscalPrinterTypes, MockSharedPrinter, PrinterParameters,
  MockFiscalPrinterDevice;

type
  { TMalinaFilterTest }

  TMalinaFilterTest = class(TTestCase)
  published
    procedure CheckEndFiscalReceipt;
  end;

implementation

const
  REGSTR_UNIPOS_MALINA = 'SOFTWARE\Unipos\Malina';

{ TMalinaFilterTest }

procedure TMalinaFilterTest.CheckEndFiscalReceipt;
var
  //Filter: IFptrFilter;
  Device: TMockFiscalPrinterDevice;
  //Printer: TMockSharedPrinter;
  //Parameters: TPrinterParameters;
begin
  Device := TMockFiscalPrinterDevice.Create;
  Device.Free;
(*
  Device := TMockPrinterDevice.Create;
  Parameters := TPrinterParameters.Create;
  Printer := TMockSharedPrinter.Create(Parameters, Device);
  Filter := TMalinaFilter.Create(Printer);
  try
    Parameters.MalinaSaleText := 'MalinaSaleText';
    Parameters.MalinaCardPrefix := 'MalinaCardPrefix';
    Parameters.MalinaRegKey := REGSTR_UNIPOS_MALINA;
    Parameters.MalinaDiscountPercent := 10;
    Parameters.MalinaTotalThreshold := 20;
    Parameters.MalinaClearRegistry := True;
    //Filter.EndFiscalReceipt;

  finally
    Filter := nil;
    Device.Free;
    Printer.Free;
    Parameters.Free;
  end;
*)
end;

initialization
  RegisterTest('', TMalinaFilterTest.Suite);

end.
