unit FileUtils;

interface

uses
  // VCL
  Windows, Classes, SysUtils, ShlObj, ShFolder, Registry,
  // 3'd
  TntClasses, TntStdCtrls, TntRegistry, TntSysUtils;

function GetModulePath: WideString;
function GetModuleFileName: WideString;
function ReadFileData(const FileName: AnsiString): AnsiString;
procedure WriteFileData(const FileName, Data: AnsiString);
function GetLongFileName(const FileName: WideString): WideString;
function GetSystemPath: WideString;
function CLSIDToFileName(const CLSID: TGUID): WideString;
procedure DeleteFiles(const FileMask: WideString);
procedure GetFileNames(const Mask: WideString; FileNames: TTntStrings);
procedure GetDirNames(const Mask: WideString; DirNames: TTntStrings);

implementation

function GetModulePath: WideString;
begin
  Result := WideIncludeTrailingPathDelimiter(ExtractFilePath(
    GetLongFileName(GetModuleFileName)));
end;

function GetModFileName: WideString;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetModuleFileName: WideString;
begin
  Result := GetLongFileName(GetModFileName);
end;

function ReadFileData(const FileName: AnsiString): AnsiString;
var
  Stream: TFileStream;
begin
  Result := '';
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    if Stream.Size > 0 then
    begin
      SetLength(Result, Stream.Size);
      Stream.Read(Result[1], Stream.Size);
    end;
  finally
    Stream.Free;
  end;
end;

procedure WriteFileData(const FileName, Data: AnsiString);
var
  Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if Length(Data) > 0 then
      Stream.Write(Data[1], Length(Data));
  finally
    Stream.Free;
  end;
end;

function GetLongFileName(const FileName: WideString): WideString;
var
  L: Integer;
  Handle: Integer;
  Buffer: array[0..MAX_PATH] of WideChar;
  GetLongPathName: function (ShortPathName: PWideChar; LongPathName: PWideChar;
    cchBuffer: Integer): Integer stdcall;
const
  kernel = 'kernel32.dll';
begin
  Result := FileName;
  Handle := GetModuleHandle(kernel);
  if Handle <> 0 then
  begin
    @GetLongPathName := GetProcAddress(Handle, 'GetLongPathNameW');
    if Assigned(GetLongPathName) then
    begin
      L := GetLongPathName(PWideChar(FileName), Buffer, SizeOf(Buffer));
      SetString(Result, Buffer, L);
    end;
  end;
end;

function GetSystemPath: WideString;
var
  Buffer: array[0..MAX_PATH] of WideChar;
begin
  Result := '';
  SHGetSpecialFolderPathW(0, Buffer, CSIDL_SYSTEM, False);
  Result := WideIncludeTrailingPathDelimiter(Buffer);
end;

function ExtractQuotedStr(const Src: WideString): WideString;
begin
  Result := Src;
  if Src[1] = '"' then Delete(Result, 1, 1);;
  if Result[Length(Result)] = '"' then SetLength(Result, Length(Result) - 1);
end;

function CLSIDToFileName(const CLSID: TGUID): WideString;
var
  Reg: TTntRegistry;
  strCLSID: WideString;
begin
  Result := '';
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey:= HKEY_CLASSES_ROOT;
    Reg.Access := KEY_READ;
    strCLSID := GUIDToString(CLSID);
    if Reg.OpenKey(Format('CLSID\%s\InProcServer32', [strCLSID]), False)
       or Reg.OpenKey(Format('CLSID\%s\LocalServer32', [strCLSID]), False) then
    begin
      try
        Result := ExtractQuotedStr(Reg.ReadString(''));
        Result := GetLongFileName(Result);
      finally
        Reg.CloseKey;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

procedure GetFileNames(const Mask: WideString; FileNames: TTntStrings);
var
  F: TSearchRec;
  Result: Integer;
  FileName: WideString;
begin
  Result := FindFirst(Mask, faAnyFile, F);
  while Result = 0 do
  begin
    FileName := ExtractFilePath(Mask) + F.FindData.cFileName;
    FileNames.Add(FileName);
    Result := FindNext(F);
  end;
  FindClose(F);
end;

procedure GetDirNames(const Mask: WideString; DirNames: TTntStrings);
var
  F: TSearchRec;
  Result: Integer;
  FileName: WideString;
  DirName: WideString;
begin
  Result := FindFirst(Mask, faDirectory, F);
  while Result = 0 do
  begin
    DirName := F.FindData.cFileName;
    if (DirName <> '.') and (DirName <> '..')and((F.Attr and FILE_ATTRIBUTE_DIRECTORY) <> 0) then
    begin
      FileName := ExtractFilePath(Mask) + DirName;
      DirNames.Add(FileName);
    end;
    Result := FindNext(F);
  end;
  FindClose(F);
end;

procedure DeleteFiles(const FileMask: WideString);
var
  FileNames: TTntStringList;
begin
  FileNames := TTntStringList.Create;
  try
    GetFileNames(FileMask, FileNames);
    while FileNames.Count > 0 do
    begin
      DeleteFile(FileNames[0]);
      FileNames.Delete(0);
    end;
  finally
    FileNames.Free;
  end;
end;

end.
