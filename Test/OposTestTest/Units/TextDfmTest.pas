unit TextDfmTest;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  TestFramework, FileUtils;

type
  { TTextDfmTest }

  TTextDfmTest = class(TTestCase)
  private
    procedure CheckDfmFilePath(const Dir: string);
    function IsTextDfm(const FileName: string): Boolean;
    procedure GetDfmFileNames(const Path: string; FileNames: TStrings);
  published
    procedure CheckDfmFiles;
  end;

implementation

function IsDirectory(const F: TSearchRec): Boolean;
begin
  Result := (F.FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0;
end;

{ TTextDfmTest }

procedure ODS(const Data: string);
begin
  OutputDebugString(PChar(Data));
end;

procedure TTextDfmTest.GetDfmFileNames(const Path: string;
  FileNames: TStrings);
var
  Dir: string;
  SubDir: string;
  F: TSearchRec;
  Result: Integer;
begin
  Dir := IncludeTrailingBackslash(Path);
  // Поиск файлов
  Result := FindFirst(Dir + '*.dfm', faAnyFile, F);
  while Result = 0 do
  begin
    ODS(Dir + F.FindData.cFileName);
    FileNames.Add(Dir + F.FindData.cFileName);
    Result := FindNext(F);
  end;
  FindClose(F);
  // Поиск директорий
  Result := FindFirst(Dir + '*.*', faDirectory, F);
  while Result = 0 do
  begin
    if IsDirectory(F) then
    begin
      SubDir := F.FindData.cFileName;
      if (SubDir <> '.')and(SubDir <> '..') then
      begin
        SubDir := IncludeTrailingBackslash(Dir + SubDir);
        ODS(SubDir);
        GetDfmFileNames(SubDir, FileNames);
      end;
    end;
    Result := FindNext(F);
  end;
  FindClose(F);
end;

function TTextDfmTest.IsTextDfm(const FileName: string): Boolean;
var
  S: string;
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(S, 3);
    Stream.ReadBuffer(S[1], 3);
    Result := S <> #$FF#$0A#$00;
  finally
    Stream.Free;
  end;
end;

procedure TTextDfmTest.CheckDfmFilePath(const Dir: string);
var
  i: Integer;
  FileName: string;
  FileNames: TStrings;
begin
  FileNames := TStringList.Create;
  try
    GetDfmFileNames(Dir, FileNames);
    Check(FileNames.Count > 0, 'FileNames.Count <= 0');
    for i := 0 to FileNames.Count-1 do
    begin
      FileName := FileNames[i];
      CheckEquals(True, IsTextDfm(FileName), 'IsTextDfm(' + FileName + ')');
    end;
  finally
    FileNames.Free;
  end;
end;

procedure TTextDfmTest.CheckDfmFiles;
var
  FilePath: string;
begin
  FilePath := IncludeTrailingPathDelimiter(ExtractFilePath(
    FileUtils.GetModuleFileName)) + '..\..\..\Source\OposTest';
  CheckDfmFilePath(FilePath);
end;

initialization
  RegisterTest('', TTextDfmTest.Suite);

end.
