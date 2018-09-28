unit duGS1Barcode;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  GS1Barcode;

type
  { TGS1BarcodeTest }

  TGS1BarcodeTest = class(TTestCase)
  published
    procedure CheckDecode;
  end;

implementation


{ TGS1BarcodeTest }

procedure TGS1BarcodeTest.CheckDecode;
const
  Barcode2 = '010700000000000321Ai1iJul' + GS + '291ErTuY7uj';
  Barcode3 = '04606203084623+A13gPh-4Hi7uGl';
var
  Data: string;
  Barcode: TGS1Barcode;
begin
  Data := GS1DecodeBraces(Barcode2);
  CheckEquals('(01)07000000000003(21)Ai1iJul(291)ErTuY7uj', Data, 'Data');
  Barcode := DecodeGS1(GS1FilterTockens(GS1DecodeBraces(Barcode2)));
  CheckEquals('07000000000003', Barcode.GTIN, 'Barcode.GTIN');
  CheckEquals('Ai1iJul', Barcode.Serial, 'Barcode.Serial');

  Data := GS1DecodeBraces(Barcode3);
  CheckEquals('(01)04606203084623(21)+A13gPh(9099)-4Hi7uGl', Data, 'Data');
  Barcode := DecodeGS1(GS1FilterTockens(GS1DecodeBraces(Barcode3)));
  CheckEquals('04606203084623', Barcode.GTIN, 'Barcode.GTIN');
  CheckEquals('+A13gPh', Barcode.Serial, 'Barcode.Serial');
end;

initialization
  RegisterTest('', TGS1BarcodeTest.Suite);

end.
