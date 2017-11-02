unit duResourceString;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Consts, IdResourceStrings,
  // Indy
  IdStack,
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
  RSStackErrorEng = 'Socket Error # %d' + #13#10 + '%s';
var
  S: string;
  AIdStack: TIdStack;
const
  SocketError10013 = 'Socket Error # 10013'#$D#$A'Access denied.';
begin
  CheckEquals(SClassMismatch, SClassMismatchRus, 'SClassMismatch');
  CheckEquals(RSInvalidSourceArray, RSInvalidSourceArrayEng, 'RSInvalidSourceArray');
  CheckEquals(RSStackError, RSStackErrorEng, 'RSStackError');

  AIdStack := TIdStack.Create;
  try
    S := AIdStack.WSTranslateSocketErrorMsg(10013);
    CheckEquals(S, SocketError10013);
  finally
    AIdStack.Free;
  end;
end;

//initialization
//  RegisterTest('', TResourceStringTest.Suite);

end.
