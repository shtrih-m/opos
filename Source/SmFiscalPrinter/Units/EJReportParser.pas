unit EJReportParser;

interface

uses
  // VCL
  Classes,
  // Tnt
  TntClasses,
  // This
  PrinterTypes;

type
  { TEJReportParser }

  TEJReportParser = class
  public
    class function ParseActivation(const Text: WideString): TEJActivation;
  end;

implementation

function GetParam(const S: WideString; N: Integer): WideString;
var
  i: Integer;
  Tocken: WideString;
  WasSeparator: Boolean;
  TockenNumber: Integer;
begin
  Result := '';
  Tocken := '';
  TockenNumber := 1;
  WasSeparator := False;
  for i := 1 to Length(S) do
  begin
    if S[i] = ' ' then
    begin
      if TockenNumber = N then Break;
      WasSeparator := True;
    end else
    begin
      if WasSeparator then
      begin
        Tocken := '';
        Inc(TockenNumber);
        WasSeparator := False;
      end;
      Tocken := Tocken + S[i];
    end;
  end;
  Result := Tocken;
end;

function GetMaxLineLength(Lines: TTntStrings): Integer;
var
  i: Integer;
  L: Integer;
begin
  Result := 0;
  for i := 0 to Lines.Count-1 do
  begin
    L := Length(Lines[i]);
    if L > Result then
      Result := L;
  end;
end;

{ TEJReportParser }

(*
 ------------------------------------------
 40 ñèìâîëîâ
 ------------------------------------------
 ØÒÐÈÕ-Ì-ÔÐ-Ê
 ÊÊÌ 000012345678 ÈÍÍ 000000012345
 ÝÊËÇ 0000000018
 ÈÒÎÃ ÀÊÒÈÂÈÇÀÖÈÈ
 10/02/14 12:18 ÇÀÊÐÛÒÈÅ ÑÌÅÍÛ 0000
 ÐÅÃÈÑÒÐÀÖÈÎÍÍÛÉ ÍÎÌÅÐ       000000123456
 00000001 #037110
 ------------------------------------------
 16 ñèìâîëîâ
 ------------------------------------------
 ØÒÐÈÕ-LIGHT-ÔÐ-Ê
 ÊÊÌ 000000001012
 ÈÍÍ 000000012345
 ÝÊËÇ 0113154054
 ÈÒÎÃ ÀÊÒÈÂÈÇÀÖÈÈ
 10/02/14 13:57
 ÇÀÊÐ.ÑÌÅÍÛ  0000
 ÐÅÃ 000000123456
 00000001 #013047
 ------------------------------------------
*)

class function TEJReportParser.ParseActivation(
  const Text: WideString): TEJActivation;
var
  Lines: TTntStrings;
begin
  Result.EJSerial := '';
  Result.ActivationDate := '';
  Result.ActivationTime := '';

  Lines := TTntStringList.Create;
  try
    Lines.Text := Text;
    if GetMaxLineLength(Lines) > 16 then
    begin
      if Lines.Count >= 4 then
      begin
        Result.EJSerial := GetParam(Lines[2], 2);
        Result.ActivationDate := GetParam(Lines[4], 1);
        Result.ActivationTime := GetParam(Lines[4], 2);
      end;
    end else
    begin
      if Lines.Count >= 5 then
      begin
        Result.EJSerial := GetParam(Lines[3], 2);
        Result.ActivationDate := GetParam(Lines[5], 1);
        Result.ActivationTime := GetParam(Lines[5], 2);
      end;
    end;
  finally
    Lines.Free;
  end;
end;

end.
