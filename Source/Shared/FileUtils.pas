unit FileUtils;

interface

uses
  // VCL
  Windows, Classes, SysUtils, ShlObj, ShFolder, Registry;

function GetModulePath: string;
function GetModuleFileName: string;
function ReadFileData(const FileName: string): string;
procedure WriteFileData(const FileName, Data: string);
function GetLongFileName(const FileName: string): string;
function GetSystemPath: string;
function CLSIDToFileName(const CLSID: TGUID): String;

implementation

function GetModulePath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(
    GetLongFileName(GetModuleFileName)));
end;

function GetModFileName: string;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetModuleFileName: string;
begin
  Result := GetLongFileName(GetModFileName);
end;

function ReadFileData(const FileName: string): string;
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

procedure WriteFileData(const FileName, Data: string);
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

function GetLongFileName(const FileName: string): string;
var
  L: Integer;
  Handle: Integer;
  Buffer: array[0..MAX_PATH] of Char;
  GetLongPathName: function (ShortPathName: PChar; LongPathName: PChar;
    cchBuffer: Integer): Integer stdcall;
const
  kernel = 'kernel32.dll';
begin
  Result := FileName;
  Handle := GetModuleHandle(kernel);
  if Handle <> 0 then
  begin
    @GetLongPathName := GetProcAddress(Handle, 'GetLongPathNameA');
    if Assigned(GetLongPathName) then
    begin
      L := GetLongPathName(PChar(FileName), Buffer, SizeOf(Buffer));
      SetString(Result, Buffer, L);
    end;
  end;
end;

function GetSystemPath: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  Result := '';
  SHGetSpecialFolderPath(0, Buffer, CSIDL_SYSTEM, False);
  Result := IncludeTrailingPathDelimiter(Buffer);
end;

function ExtractQuotedStr(const Src: String): String;
begin
  Result := Src;
  if Src[1] = '"' then Delete(Result, 1, 1);;
  if Result[Length(Result)] = '"' then SetLength(Result, Length(Result) - 1);
end;

function CLSIDToFileName(const CLSID: TGUID): String;
var
  Reg: TRegistry;
  strCLSID: String;
begin
  Result := '';
  Reg := TRegistry.Create;
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




end.
