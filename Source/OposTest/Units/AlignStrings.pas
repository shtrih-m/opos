unit AlignStrings;

interface

uses
  // VCL
  SysUtils,
  // Tnt
  TntSysUtils;

type
  TAlignType = (atLeft, atRight, atCenter);

function AlignString(const S: WideString; Width: Integer; at: TAlignType): WideString;

implementation

function AlignString(const S: WideString; Width: Integer; at: TAlignType): WideString;
var
  LS: WideString;
  L: Integer;
  L1: Integer;
begin
  LS := Copy(S, 1, Width);
  case at of
    atLeft      : Result := Tnt_WideFormat('%-*s', [Width, LS]);
    atRight     : Result := Tnt_WideFormat('%*s', [Width, LS]);
    atCenter    :
    begin
      L := Width - Length(LS);
      L1 := L div 2;
      Result := StringOfChar(' ', L1) + LS + StringOfChar(' ', L-L1);
    end;
  else
    Result := S;
  end;
end;


end.
