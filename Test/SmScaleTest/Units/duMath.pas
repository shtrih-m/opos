unit duMath;

interface

uses
  // VCL
  Math,
  // 3'd
  TestFramework;

type
  { TMathTest }

  TMathTest = class(TTestCase)
  published
    procedure TestPower;
    procedure TestShortInt;
  end;

implementation

{ TMathTest }

procedure TMathTest.TestPower;
begin
  CheckEquals(1, Power(10, 0), 'Power(10, 0) <> 1');
  CheckEquals(10, Power(10, 1), 'Power(10, 1) <> 10');
  CheckEquals(0.1, Power(10, -1), 0.00001, 'Power(10, -1) <> 0.1');
  CheckEquals(0.01, Power(10, -2), 0.00001, 'Power(10, -2) <> 0.01');
end;

procedure TMathTest.TestShortInt;
begin
  CheckEquals(1, Byte(ShortInt(1)));
  CheckEquals(0, Byte(ShortInt(0)));
  CheckEquals($7F, Byte(ShortInt(127)));
  CheckEquals($FF, Byte(ShortInt(-1)));
  CheckEquals($80, Byte(ShortInt(-128)));
end;

initialization
  RegisterTest('', TMathTest.Suite);

end.
