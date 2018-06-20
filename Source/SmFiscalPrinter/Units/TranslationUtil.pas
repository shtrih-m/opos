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
  bindtextdomain('SmFiscalPrinter', IncludeTrailingBackslash(ExtractFilePath(GetDllFileName)) + 'locale');
  textdomain('SmFiscalPrinter');
  UseLanguage(GetLanguage);
end;

procedure SetCustomTranslationLanguage(const Language: WideString);
begin
  bindtextdomain('SmFiscalPrinter', IncludeTrailingBackslash(ExtractFilePath(GetDllFileName)) + 'locale');
  textdomain('SmFiscalPrinter');
  UseLanguage(Language);
end;

end.
