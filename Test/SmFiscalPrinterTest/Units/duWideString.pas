unit duWideString;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework, StringUtils;

type
  { TWideStringTest }

  TWideStringTest = class(TTestCase)
  published
    procedure CheckWideString1251;
    procedure CheckWideString866;
  end;

implementation

function CreateUCS4String(const P: array of UCS4Char): UCS4String;
var
  i: Integer;
begin
  SetLength(Result, High(P) - Low(P) + 1);
  for i := Low(P) to High(P) do
    Result[i] := P[i];
end;

function StringToCharArray(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + Format('#$%.2x', [Ord(S[i])]);
end;

function WideStringToCharArray(const S: WideString): string;
var
  i: Integer;
  UCS4Line: UCS4String;
begin
  UCS4Line := WideStringToUCS4String(S);
  for i := 1 to Length(S) do
    Result := Result + Format('#%d', [Ord(S[i])]);
end;

function UCS4StringToCharArray(const S: UCS4String): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(S) to High(S) do
    Result := Result + Format('#%d', [Ord(S[i])]);
end;

{ TWideStringTest }

procedure TWideStringTest.CheckWideString1251;
var
  ALine: string;
  ULine: WideString;
  AUCS4String: UCS4String;
const
  AString = #205#238#226#251#233;
  UString: array [0..5] of UCS4Char = (1053, 1086, 1074, 1099, 1081, 0);
begin
  ULine := UCS4StringToWideString(CreateUCS4String(UString));
  ALine := WideStringToAnsiString(1251, ULine);
  CheckEquals(StringToCharArray(AString), StringToCharArray(ALine), 'ALine');

  ULine := AnsiStringToWideString(1251, ALine);
  AUCS4String := WideStringToUCS4String(ULine);
  CheckEquals(UCS4StringToCharArray(CreateUCS4String(UString)),
    UCS4StringToCharArray(AUCS4String));
end;

procedure TWideStringTest.CheckWideString866;
var
  ALine: string;
  ULine: WideString;
  AUCS4String: UCS4String;
const
  AString = #$8D#$AE#$A2#$EB#$A9;
  UString: array [0..5] of UCS4Char = (1053, 1086, 1074, 1099, 1081, 0);
begin
  ULine := UCS4StringToWideString(CreateUCS4String(UString));
  ALine := WideStringToAnsiString(866, ULine);
  CheckEquals(StringToCharArray(AString), StringToCharArray(ALine), 'ALine');

  ULine := AnsiStringToWideString(866, ALine);
  AUCS4String := WideStringToUCS4String(ULine);
  CheckEquals(UCS4StringToCharArray(CreateUCS4String(UString)),
    UCS4StringToCharArray(AUCS4String));
end;

initialization
  RegisterTest('', TWideStringTest.Suite);

end.


