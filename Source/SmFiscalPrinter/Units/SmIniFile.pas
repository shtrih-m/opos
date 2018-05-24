unit SmIniFile;

interface

uses
  // VCL
  Classes, SysUtils,
  // Tnt
  TntIniFiles,
  // This
  StringUtils;

type
  { TSmIniFile }

  TSmIniFile = class(TTntIniFile)
  public
    procedure WriteText(const Section, Ident, Value: String);
    function ReadText(const Section, Ident, Default: string): string;
  end;

implementation

{ TSmIniFile }

function TSmIniFile.ReadText(const Section, Ident,
  Default: string): string;
begin
  Result := HexToStr(ReadString(Section, Ident, Default));
end;

procedure TSmIniFile.WriteText(const Section, Ident, Value: String);
begin
  WriteString(Section, Ident, StrToHexText(Value));
end;

end.
