unit duDateTime;

interface

uses
  // VCL
  Windows, SysUtils, Classes, DateUtils,
  // DUnit
  TestFramework;

type
  { TDateTimeTest }

  TDateTimeTest = class(TTestCase)
  published
    procedure CheckDateUtils;
  end;

implementation

{ TDateTimeTest }

procedure TDateTimeTest.CheckDateUtils;
var
  Time1: TDateTime;
  Time2: TDateTime;
begin
  Time1 := 0;
  Time2 := 0 + EncodeTime(0, 0, 5, 0);
  CheckEquals(5, SecondsBetween(Time1, Time2), 'SecondsBetween.1');

  Time1 := Now;
  Time2 := Time1 + EncodeTime(0, 0, 5, 0);
  CheckEquals(4, SecondsBetween(Time1, Time2), 'SecondsBetween.2');

  Time1 := 0;
  Time2 := 0 + EncodeTime(0, 5, 0, 0);
  CheckEquals(5, MinutesBetween(Time1, Time2), 'MinutesBetween.1');

  Time1 := Now;
  Time2 := Time1 + EncodeTime(0, 5, 0, 0);
  CheckEquals(4, MinutesBetween(Time1, Time2), 'MinutesBetween.2');
end;

initialization
  RegisterTest('', TDateTimeTest.Suite);

end.
