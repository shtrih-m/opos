unit TextEncoding;

interface

uses
  // This
  StringUtils;

const
  EncodingWindows       = 0;
  Encoding866           = 1;

function DecodeText(Encoding: Integer; const Text: WideString): WideString;
function EncodeText(Encoding: Integer; const Text: WideString): WideString;

implementation

function DecodeText(Encoding: Integer; const Text: WideString): WideString;
begin
  Result := Text;
  case Encoding of
    Encoding866: Result := Str866To1251(Text);
  else
    Result := WideStringToAnsiString(1251, Text);
  end;
end;

function EncodeText(Encoding: Integer; const Text: WideString): WideString;
begin
  case Encoding of
    Encoding866: Result := Str1251To866(Text);
  else
    Result := AnsiStringToWideString(1251, Text);
  end;
end;

end.
