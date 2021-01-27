unit SmIniFile;

interface

uses
  // VCL
  Classes, SysUtils,
  // 3'd
  TntIniFiles,
  // This
  StringUtils;

type
  { TSmIniFile }

  TSmIniFile = class(TTntIniFile)
  public
    procedure WriteText(const Section, Ident, Value: WideString);
    function ReadText(const Section, Ident, Default: WideString): WideString;
  end;

implementation

{ TSmIniFile }

function TSmIniFile.ReadText(const Section, Ident,
  Default: WideString): WideString;
begin
  Result := HexToStr(ReadString(Section, Ident, Default));
end;

procedure TSmIniFile.WriteText(const Section, Ident, Value: WideString);
begin
  WriteString(Section, Ident, StrToHexText(Value));
end;

end.
