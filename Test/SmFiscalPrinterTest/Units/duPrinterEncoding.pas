unit duPrinterEncoding;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  PrinterEncoding, PrinterTypes, PrinterParameters;

type
  { OposStatistics }

  TPrinterEncodingTest = class(TTestCase)
  published
    procedure CheckEncoding;
  end;

implementation

//function DecodeText(Encoding: Integer; const Text: WideString): WideString;
//function EncodeText(Encoding: Integer; const Text: WideString): WideString;

{ TPrinterEncodingTest }

procedure TPrinterEncodingTest.CheckEncoding;
var
  Text: WideString;
  Encoding: Integer;
begin
  Text := 'Штрих-М';
  Encoding := EncodingWindows;
  CheckEquals(Text, DecodeText(Encoding, EncodeText(Encoding, Text)), 'EncodingWindows');

  Text := 'Штрих-М';
  Encoding := Encoding866;
  CheckEquals(Text, DecodeText(Encoding, EncodeText(Encoding, Text)), 'Encoding866');
end;

initialization
  RegisterTest('', TPrinterEncodingTest.Suite);

end.
