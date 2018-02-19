unit duLogFile;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  LogFile, FileUtils;

type
  { TLogFileTest }

  TLogFileTest = class(TTestCase)
  published
    procedure CheckDeleteFile;
  end;

implementation

{ TLogFileTest }

procedure TLogFileTest.CheckDeleteFile;
var
  Logger: ILogFile;
  Lines: TStrings;
begin
  Logger := TLogFile.Create;
  Lines := TStringList.Create;
  try
    Logger.MaxCount := 10;
    Logger.Enabled := True;
    Logger.FilePath := GetModulePath;
    Logger.DeviceName := 'DeviceName1';
    Logger.TimeStampEnabled := False;

    DeleteFile(Logger.GetFileName);
    CheckEquals(False, FileExists(Logger.GetFileName), 'FileExists!');

    Logger.Debug('Line1');
    Logger.Error('Line2');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(2, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');

    Logger.Debug('Line3');
    Logger.Error('Line4');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(4, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');
    CheckEquals('[DEBUG] Line3', Lines[2], 'Lines[2]');
    CheckEquals('[ERROR] Line4', Lines[3], 'Lines[3]');

    Logger.DeviceName := 'DeviceName2';
    DeleteFile(Logger.GetFileName);
    CheckEquals(False, FileExists(Logger.GetFileName), 'FileExists!');

    Logger.Debug('Line1');
    Logger.Error('Line2');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(2, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');

    Logger.Debug('Line3');
    Logger.Error('Line4');
    Logger.CloseFile;

    Lines.LoadFromFile(Logger.GetFileName);
    CheckEquals(4, Lines.Count, 'Lines.Count');
    CheckEquals('[DEBUG] Line1', Lines[0], 'Lines[0]');
    CheckEquals('[ERROR] Line2', Lines[1], 'Lines[1]');
    CheckEquals('[DEBUG] Line3', Lines[2], 'Lines[2]');
    CheckEquals('[ERROR] Line4', Lines[3], 'Lines[3]');
  finally
    Lines.Free;
  end;
end;

initialization
  RegisterTest('', TLogFileTest.Suite);

end.
