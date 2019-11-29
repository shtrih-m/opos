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
    procedure CheckDecode2;
  end;

implementation


{ TGS1BarcodeTest }

procedure TGS1BarcodeTest.CheckDecode;
const
  Barcode2 = '010700000000000321Ai1iJul[GS]291ErTuY7uj';
  Barcode3 = '04606203084623+A13gPh-4Hi7uGl';
  Barcode4 = '010405104227920221TB6qQHbmOTZBf'#$1D'2406402'#$1D'91ffd0'#$1D'92DbZgaQm2x0uA5+8/AzMM9hVq6apGvtM3bJzejjpHan2pvK4O+XbYcVgFRR5I4HmCLQvZ74KgKkIhVADd==';
var
  Barcode: TGS1Barcode;
begin
  Check(IsValidGS1(Barcode2), 'IsValidGS1(Barcode2)');

  Barcode := DecodeGS1(Barcode2);
  CheckEquals('07000000000003', Barcode.GTIN, 'Barcode.GTIN');
  CheckEquals('Ai1iJul', Barcode.Serial, 'Barcode.Serial');

  Barcode := DecodeGS1(Barcode3);
  CheckEquals('04606203084623', Barcode.GTIN, 'Barcode.GTIN');
  CheckEquals('+A13gPh', Barcode.Serial, 'Barcode.Serial');

  Barcode := DecodeGS1(Barcode4);
  CheckEquals('04051042279202', Barcode.GTIN, 'Barcode4.GTIN');
  CheckEquals('TB6qQHbmOTZBf', Barcode.Serial, 'Barcode4.Serial');

  Barcode := DecodeGS1('00000046173881F7918379LAS23XXX123');
  CheckEquals('00000046173881', Barcode.GTIN, '5.GTIN');
  CheckEquals('F791837', Barcode.Serial, '5.Serial');
end;

procedure TGS1BarcodeTest.CheckDecode2;
const
  Barcode = '010463003546359221Jty945YpbLtBA'#$1D'2406402'#$1D'91ffd0'#$1D +
    '92lhADfVvvYK1hulPfYg42Yv5fNlSTxqLtP7JEvbMnyTkT7ljcNK6d/Z1qGzMEIdb2qqDFYiAGUE2ssqXiNICCcg==';
var
  Tokens: TGS1Tokens;
begin
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeAI(Barcode);
    CheckEquals(5, Tokens.Count, 'Tokens.Count');

    CheckEquals('01', Tokens[0].id, 'Tokens[0].id');
    CheckEquals('04630035463592', Tokens[0].Data, 'Tokens[0].Data');

    CheckEquals('21', Tokens[1].id, 'Tokens[1].id');
    CheckEquals('Jty945YpbLtBA', Tokens[1].Data, 'Tokens[1].Data');

    CheckEquals('240', Tokens[2].id, 'Tokens[2].id');
    CheckEquals('6402', Tokens[2].Data, 'Tokens[2].Data');

    CheckEquals('91', Tokens[3].id, 'Tokens[3].id');
    CheckEquals('ffd0', Tokens[3].Data, 'Tokens[3].Data');

    CheckEquals('92', Tokens[4].id, 'Tokens[4].id');
    CheckEquals('lhADfVvvYK1hulPfYg42Yv5fNlSTxqLtP7JEvbMnyTkT7ljcNK6d/Z1qGzMEIdb2qqDFYiAGUE2ssqXiNICCcg==', Tokens[4].Data, 'Tokens[4].Data');
  finally
    Tokens.Free;
  end;
end;


initialization
  RegisterTest('', TGS1BarcodeTest.Suite);

end.
