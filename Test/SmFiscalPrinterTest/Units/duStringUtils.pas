unit duStringUtils;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  StringUtils;

type
  { TStringUtilsTest }

  TStringUtilsTest = class(TTestCase)
  published
    procedure TestTrimText;
  end;

implementation

{ TStringUtilsTest }

procedure TStringUtilsTest.TestTrimText;
begin
  CheckEquals('1 2', TrimText('1  2', 3));
  CheckEquals('Наличные         Рубль               19.90',
     TrimText('Наличные            Рубль               19.90', 42));

  CheckEquals('1 Автомобильный бензин Пульсар АИ-92-5 0.0',
     TrimText('1 Автомобильный бензин Пульсар АИ-92-5       0.000    Отмена', 42));
end;

initialization
  RegisterTest('', TStringUtilsTest.Suite);

end.
