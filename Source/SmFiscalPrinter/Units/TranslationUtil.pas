unit TranslationUtil;

interface
uses
  // VCL
  SysUtils,
  // gnugettext
  gnugettext,
  // This
  VersionInfo, LangUtils;

procedure SetTranslationLanguage;
procedure SetCustomTranslationLanguage(const Language: WideString);

implementation

procedure SetTranslationLanguage;
begin
  bindtextdomain('SharpDrv', IncludeTrailingBackslash(ExtractFilePath(GetDllFileName)) + 'locale');
  textdomain('SharpDrv');
  UseLanguage(GetLanguage);
end;

procedure SetCustomTranslationLanguage(const Language: WideString);
begin
  bindtextdomain('SharpDrv', IncludeTrailingBackslash(ExtractFilePath(GetDllFileName)) + 'locale');
  textdomain('SharpDrv');
  UseLanguage(Language);
end;

end.
