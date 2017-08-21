unit duResourceString;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Consts, IdResourceStrings,
  // DUnit
  TestFramework;

type
  { TTankFilterTest }

  TResourceStringTest = class(TTestCase)
  published
    procedure CheckStrings;
  end;

implementation

{ TResourceStringTest }

procedure TResourceStringTest.CheckStrings;
const
  SClassMismatchRus = 'Неверный класс ресурса %s';
  RSInvalidSourceArrayEng = 'Invalid source array';
begin
  CheckEquals(SClassMismatch, SClassMismatchRus, 'SClassMismatch');
  CheckEquals(RSInvalidSourceArray, RSInvalidSourceArrayEng, 'RSInvalidSourceArray');
end;

initialization
  RegisterTest('', TResourceStringTest.Suite);

end.
