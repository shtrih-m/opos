unit SysUtilsTest;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework;

type
  { TSysUtilsTest }

  TSysUtilsTest = class(TTestCase)
  published
    procedure TestInt64;
  end;

implementation

{ TSysUtilsTest }

procedure TSysUtilsTest.TestInt64;
var
  Value: Int64;
begin
  Value := $ABCD;
  CheckEquals($ABCD, Value);
  Value := Value shl 16;
  CheckEquals($ABCD0000, Value);
  Value := Value + $ABCD;
  CheckEquals($ABCDABCD, Value);
end;

initialization
  RegisterTest('', TSysUtilsTest.Suite);

end.
