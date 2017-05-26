unit VersionInfo;

interface

uses
  // VCL
  Windows, SysUtils;

type
  { TVersionInfo }

  TVersionInfo = record
    MajorVersion: WORD;
    MinorVersion: WORD;
    ProductRelease: WORD;
    ProductBuild: WORD;
  end;

function GetDllFileName: string;
function GetModuleDate: string;
function GetModuleVersion: string;
function GetFileVersionInfoStr: string;
function GetFileVersionInfoStr2: string;
function GetFileVersionInfo: TVersionInfo;
function GetOPOSVersion: string;

function VersionInfoToStr(const V: TVersionInfo): string;
function ReadFileVersion(const FileName: string): TVersionInfo;

implementation

function GetFileVersionInfo: TVersionInfo;
var
  hVerInfo: THandle;
  hGlobal: THandle;
  AddrRes: pointer;
  Buf: array[0..7]of byte;
begin
  Result.MajorVersion := 0;
  Result.MinorVersion := 0;
  Result.ProductRelease := 0;
  Result.ProductBuild := 0;

  hVerInfo:= FindResource(hInstance, '#1', RT_VERSION);
  if hVerInfo <> 0 then
  begin
    hGlobal := LoadResource(hInstance, hVerInfo);
    if hGlobal <> 0 then
    begin
      AddrRes:= LockResource(hGlobal);
      try
        CopyMemory(@Buf, Pointer(Integer(AddrRes)+48), 8);
        Result.MinorVersion := Buf[0] + Buf[1]*$100;
        Result.MajorVersion := Buf[2] + Buf[3]*$100;
        Result.ProductBuild := Buf[4] + Buf[5]*$100;
        Result.ProductRelease := Buf[6] + Buf[7]*$100;
      finally
        FreeResource(hGlobal);
      end;
    end;
  end;
end;

function GetFileVersionInfoStr: string;
var
  vi: TVersionInfo;
begin
  vi := GetFileVersionInfo;
  Result := Format('%d.%d.%d.%d', [vi.MajorVersion, vi.MinorVersion,
    vi.ProductRelease, vi.ProductBuild]);
end;

function GetFileVersionInfoStr2: string;
var
  vi: TVersionInfo;
begin
  vi := GetFileVersionInfo;
  Result := Format('%d.%d', [vi.MajorVersion, vi.MinorVersion]);
end;

function GetModuleFileName: string;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetModuleDate: string;
var
  FileTime: TFileTime;
  ModuleDate: TDateTime;
  SystemTime: TSystemTime;
  Data: TWin32FileAttributeData;
begin
  Result := 'unknown';
  if GetFileAttributesEx(PChar(GetModuleFileName), GetFileExInfoStandard, @Data) then
  begin
    if FileTimeToLocalFileTime(Data.ftLastWriteTime, FileTime) then
    begin
      if FileTimeToSystemTime(FileTime, SystemTime) then
      begin
        with SystemTime do
        ModuleDate := EncodeDate(wYear, wMonth, wDay) +
        EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
        Result := DateTimeToStr(ModuleDate);
      end;
    end;
  end;
end;

function GetModuleVersion: string;
begin
  Result := GetFileVersionInfoStr + ' from ' + GetModuleDate;
end;

function GetDllFileName: string;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetOPOSVersion: string;
begin
  Result := '1.12';
end;


function VersionInfoToStr(const V: TVersionInfo): string;
begin
  Result := Format('%d.%d.%d.%d', [V.MajorVersion, V.MinorVersion,
    V.ProductRelease, V.ProductBuild]);
end;

function ReadFileVersion(const FileName: string): TVersionInfo;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result.MajorVersion := 0;
  Result.MinorVersion := 0;
  Result.ProductRelease := 0;
  Result.ProductBuild := 0;

  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  if VerInfoSize = 0 then Exit;
  GetMem(VerInfo, VerInfoSize);
  if not assigned(VerInfo) then Exit;

  try
    if Windows.GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, VerInfo) then
    begin
      if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
      begin
        with VerValue^ do
        begin
          Result.MajorVersion := dwFileVersionMS shr 16;
          Result.MinorVersion := dwFileVersionMS and $FFFF;
          Result.ProductRelease := dwFileVersionLS shr 16;
          Result.ProductBuild := dwFileVersionLS and $FFFF;
        end;
      end;
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

end.
