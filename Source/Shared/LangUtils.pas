unit LangUtils;

interface

uses
  // VCL
  Windows, SysUtils, Classes, Registry, IniFiles, ShlObj,
  // Tnt
  TntIniFiles, TntSysUtils,
  // gnugettext
  gnugettext;

function GetLanguage: WideString;
procedure SetLanguage(const Language: WideString);
function GetRes(Value: PResStringRec): WideString;
function GetLanguageParamsFileName: WideString;
function GetUserShtrihPath: WideString;

implementation
var
  GLanguage: WideString = '';

const
  LangParamsFileName = 'locale.ini';

function GetUserShtrihPath: WideString;
begin
  SetLength(Result, MAX_PATH);
  ShlObj.SHGetSpecialFolderPath(0, @Result[1], CSIDL_APPDATA, false);
  SetLength(Result, Pos(#0, Result)-1);

  Result := WideIncludeTrailingPathDelimiter(Result) + 'SHTRIH-M';
  if not DirectoryExists(Result) then
    CreateDir(Result);
  Result := Result + '\SharpDrv';
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

function GetLanguageParamsFileName: WideString;
begin
  Result := WideIncludeTrailingPathDelimiter(GetUserShtrihPath) + LangParamsFileName;
end;

// Посколько resourceWideStrings в Delphi 7 не юникодные,
// получаем таким способом
function GetRes(Value: PResStringRec): WideString;
begin
  Result := LoadResStringW(Value);
end;

function GetModuleFileName: WideString;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetLanguage: WideString;
var
  F: TTntIniFile;
begin
  if GLanguage <> '' then
  begin
    Result := GLanguage;
    Exit;
  end;
  Result := 'EN';
  if FileExists(GetLanguageParamsFileName) then
  begin
    F := TTntIniFile.Create(GetLanguageParamsFileName);
    try
      Result := F.ReadString('Locale', 'Lang', 'RU');
    finally
      F.Free;
    end;
    if (Result <> 'RU') and (Result <> 'EN') then
      Result := 'EN';
  end;
  GLanguage := Result;
end;

procedure SetLanguage(const Language: WideString);
var
  F: TTntIniFile;
begin
  F := TTntIniFile.Create(GetLanguageParamsFileName);
  try
  finally
    F.WriteString('Locale', 'Lang', Language);
  end;
end;

end.
