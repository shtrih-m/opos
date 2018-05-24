unit AlignStrings;

interface

uses
  // VCL
  SysUtils,
  // Tnt
  TntSysUtils;

type
  TAlignType = (atLeft, atRight, atCenter);

function AlignString(const S: string; Width: Integer; at: TAlignType): string;

implementation

function AlignString(const S: string; Width: Integer; at: TAlignType): string;
var
  LS: string;
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
