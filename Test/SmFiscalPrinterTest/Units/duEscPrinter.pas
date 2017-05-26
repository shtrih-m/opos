unit duEscPrinter;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  EscPrinter, MockSharedPrinter, MockFiscalPrinterDevice;

type
  { TEscPrinterTest }

  TEscPrinterTest = class(TTestCase)
  private
    EscPrinter: TEscPrinter;
    Printer: TMockSharedPrinter;
    Device: TMockFiscalPrinterDevice;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckExecute;
  end;

implementation

{ TEscPrinterTest }

procedure TEscPrinterTest.Setup;
begin
  inherited Setup;
  Device := TMockFiscalPrinterDevice.Create;
  Printer := TMockSharedPrinter.Create(Device);
  EscPrinter := TEscPrinter.Create(Printer);
end;

procedure TEscPrinterTest.TearDown;
begin
  inherited TearDown;
  EscPrinter.Free;
end;

procedure TEscPrinterTest.CheckExecute;
var
  Data: WideString;
begin
  Data := #$1B;
  EscPrinter.Execute(Data);
  CheckEquals('', Data, 'Data <> ''''');

  Data := #$1B#$1D#$00;
  EscPrinter.Execute(Data);
  CheckEquals(#0, Data, 'Data <> ''''');

  Data :=
    #$1D#$68#$01 +
    #$30 +
    #$1D#$77#$01 +
    #$31#$32 +
    #$1D#$48#$01 +
    #$33#$34#$35 +
    #$1D#$66#$01 +
    #$1D#$6B#$43#12'012345678901';

  Data := 'StringForPrinting1_' + Data + '_StringForPrinting2';

  EscPrinter.Execute(Data);
  CheckEquals('StringForPrinting1_012345_StringForPrinting2', Data);
end;

initialization
  RegisterTest('', TEscPrinterTest.Suite);


end.
