unit duElectronicJournal;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  ElectronicJournal;

type
  { ElectronicJournal }

  TElectronicJournalTest = class(TTestCase)
  published
    procedure CheckDecodeDateLine;
  end;

implementation

{ TElectronicJournalTest }

procedure TElectronicJournalTest.CheckDecodeDateLine;
var
  Data: string;
  Result1: string;
  Result2: string;
begin
  Data := '«¿ –.—Ã. 0162 13/08/08  11:22 Œœ≈–¿“Œ–30 ';
  Result1 := TElectronicJournal.DecodeDateLine(Data);
  Result2 := '130820081122';
  Check(Result1 = Result2, Format('"%s" <> "%s"', [Result1, Result2]));
end;

initialization
  RegisterTest('', TElectronicJournalTest.Suite);

end.
