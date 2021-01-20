unit duLogFile;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // Tnt
  TntClasses,
  // This
  LogFile, FileUtils;

type
  { TLogFileTest }

  TLogFileTest = class(TTestCase)
  public
    procedure CheckMaxSize;
  published
    procedure CheckMaxCount;
    procedure CheckDeleteFile;
    procedure CheckException;
  end;

implementation

{ TLogFileTest }

procedure TLogFileTest.CheckMaxSize;
var
  Data: AnsiString;
  Logger: ILogFile;
  FilesPath: string;
  FileNames: TTntStringList;
begin
  FileNames := TTntStringList.Create;
  try
    Logger := TLogFile.Create;
    Logger.MaxCount := 1;
    Logger.Enabled := True;
    Logger.FilePath := GetModulePath + 'Logs';
    Logger.DeviceName := 'Device1';

    FilesPath := GetModulePath + 'Logs\';
    DeleteFiles(FilesPath + '*.log');
    Data := StringOfChar(#0, 4096);
    repeat
      Logger.Write(Data);
      if ((Logger.FileSize div 1024) > (MAX_FILE_SIZE_IN_KB * 2)) then Break;
    until False;
  finally
    FileNames.Free;
  end;
end;

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
    Logger.FilePath := GetModulePath + 'Logs\';
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
    Logger.CloseFile;

    DeleteFiles(Logger.FilePath  + '*.log');
  finally
    Lines.Free;
  end;
end;

procedure TLogFileTest.CheckMaxCount;
var
  Logger: ILogFile;
  FilesPath: string;
  FileNames: TTntStringList;
begin
  FileNames := TTntStringList.Create;
  try
    Logger := TLogFile.Create;
    Logger.MaxCount := 3;
    Logger.Enabled := True;
    Logger.FilePath := GetModulePath + 'Logs';
    Logger.DeviceName := 'Device1';

    FilesPath := GetModulePath + 'Logs\';
    DeleteFiles(FilesPath + '*.log');
    Logger.GetFileNames(FilesPath + '*.log', FileNames);
    CheckEquals(0, FileNames.Count, 'FileNames.Count');

    WriteFileData(FilesPath + 'Device1_2018.02.15.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.16.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.17.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.18.log', '');
    WriteFileData(FilesPath +'Device1_2018.02.19.log', '');

    WriteFileData(FilesPath +'Device2_2018.02.15.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.16.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.17.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.18.log', '');
    WriteFileData(FilesPath +'Device2_2018.02.19.log', '');

    Logger.GetFileNames(FilesPath + '*.log', FileNames);
    CheckEquals(10, FileNames.Count, 'FileNames.Count');
    Logger.CheckFilesMaxCount;

    Logger.GetFileNames(FilesPath + '*.log', FileNames);
    FileNames.Sort;

    CheckEquals(8, FileNames.Count, 'FileNames.Count');
    CheckEquals('Device1_2018.02.17.log', ExtractFileName(FileNames[0]), 'FileNames[0]');
    CheckEquals('Device1_2018.02.18.log', ExtractFileName(FileNames[1]), 'FileNames[1]');
    CheckEquals('Device1_2018.02.19.log', ExtractFileName(FileNames[2]), 'FileNames[2]');
    CheckEquals('Device2_2018.02.15.log', ExtractFileName(FileNames[3]), 'FileNames[3]');
    DeleteFiles(FilesPath + '*.log');
  finally
    FileNames.Free;
  end;
end;

procedure TLogFileTest.CheckException;
var
  I: Double;
  Logger: ILogFile;
begin
  Logger := TLogFile.Create;
  Logger.MaxCount := 3;
  Logger.Enabled := True;
  Logger.FilePath := GetModulePath + 'Logs';
  Logger.DeviceName := 'Device1';
  try
    I := 0;
    I := 10/I;
  except
  end;
end;

initialization
  RegisterTest('', TLogFileTest.Suite);

end.
