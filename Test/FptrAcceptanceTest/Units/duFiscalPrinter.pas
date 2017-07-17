unit duFiscalPrinter;

interface

uses
  // VCL
  Windows, SysUtils, Classes, ActiveX, ComObj,
  // DUnit
  TestFramework,
  // This
  Opos, OposFptrUtils, OposFiscalPrinter_1_11_Lib_TLB, DirectIOAPI;

type
  { TFiscalPrinterTest }

  TFiscalPrinterTest = class(TTestCase)
  published
    procedure CheckOpenMulti;
  end;

implementation

{ TFiscalPrinterTest }

procedure TFiscalPrinterTest.CheckOpenMulti;
const
  IPAddressList: array
   [1..3] of string = (
    '192.168.137.110', '192.168.137.111', '192.168.137.112'
  );

  procedure DirectIO(Printer: TOPOSFiscalPrinter; Command, pData: Integer;
    const pString: WideString);
  var
    pStringOut: WideString;
  begin
    pStringOut := pString;
    CheckEquals(0, printer.DirectIO(Command, pData, pStringOut));
  end;

var
  i: Integer;
  Printer: TOPOSFiscalPrinter;
begin
  for i := Low(IPAddressList) to High(IPAddressList) do
  begin
    Printer := TOPOSFiscalPrinter.Create(nil);
    try
      CheckEquals(0, Printer.Open('SHTRIH-M-OPOS-1'),
        'Printer.Open(''SHTRIH-M-OPOS-1'')');

		  DirectIO(Printer, DIO_SET_DRIVER_PARAMETER,
        DriverParameterPropertyUpdateMode, '0');

  		DirectIO(Printer, DIO_SET_DRIVER_PARAMETER,
        DriverParameterConnectionType, '3');

		  DirectIO(Printer, DIO_SET_DRIVER_PARAMETER,
        DriverParameterRemoteHost, IPAddressList[i]);

		  DirectIO(Printer, DIO_SET_DRIVER_PARAMETER,
        DriverParameterRemotePort, '7778');

      CheckEquals(0, Printer.ClaimDevice(0),
        'Printer.ClaimDevice(0)');

      CheckEquals(0, Printer.Close, 'Printer.Close');
    finally
      Printer.Free;
    end;
  end;
end;

initialization
  RegisterTest('', TFiscalPrinterTest.Suite);


end.
