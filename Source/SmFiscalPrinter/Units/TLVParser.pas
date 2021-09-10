unit TLVParser;

interface

uses
  // VCL
  SysUtils,
  // This
  TLVTags, WException, gnugettext;

type
  { TTLVParser }

  TTLVParser = class
  private
    FList: TTLVTags;
    FIdent: Integer;
    FShowTagNumbers: Boolean;
    function GetIdent: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function ParseTLV(AData: AnsiString): AnsiString;
    function DoParseTLV(AData: AnsiString): AnsiString;
    property ShowTagNumbers: Boolean read FShowTagNumbers write FShowTagNumbers;
  end;

  { TTLVItem }

  TTLVItem = record
    ID: Integer;
    Data: AnsiString;
  end;

  { TTLVReader }

  TTLVReader = class
  public
    class function Read(var Data: AnsiString; var Item: TTLVItem): Boolean;
  end;

  { TTLVWriter }

  TTLVWriter = class
  public
    class function Write(const Item: TTLVItem): AnsiString;
  end;

implementation


constructor TTLVParser.Create;
begin
  FList := TTLVTags.Create;
  FShowTagNumbers := False;
end;

destructor TTLVParser.Destroy;
begin
  FList.Free;
  inherited;
end;

function TTLVParser.DoParseTLV(AData: AnsiString): AnsiString;
var
  S: AnsiString;
  t: Integer;
  i: Integer;
  l: Integer;
  Data: AnsiString;
  Item: TTLVTag;
begin
  Result := '';
  if Length(AData) < 4 then
    raiseException(_('TLV length error'));

  S := '';
  i := 1;
  while i <= Length(AData) do
  begin
    t := TTLVTag.ValueTLV2Int(Copy(AData, i, 2));
    Inc(i, 2);
    l := TTLVTag.ValueTLV2Int(Copy(AData, i, 2));
    Inc(i, 2);

    Item := FList.Find(t);
    if Item = nil then
    begin
      S := S + GetIdent;
      if ShowTagNumbers then
        S := S + IntToStr(t) + ',';
      S := S + _('НЕИЗВЕСТНЫЙ ТЕГ')+ #13#10;

      Inc(i, l);
      continue;
    end;
    if (Length(AData) - 4) < l then
    begin
      S := S + GetIdent;
      if ShowTagNumbers then
        S := S + GetIdent + IntToStr(t) + ','+Item.ShortDescription + ':' + _('Ошибка! Некорректная длина')
      else
        S := S + GetIdent + Item.ShortDescription + ':' + _('Ошибка! Некорректная длина') ;
      S := S + #13#10;
      Exit;
    end;
    Data := Copy(AData, i, l);

    if ShowTagNumbers then
      S := S + GetIdent + IntToStr(t) + ','+Item.ShortDescription
    else
      S := S + GetIdent + Item.ShortDescription;
    if  Item.TagType = ttSTLV then
    begin
      Inc(FIdent);
      S := S + #13#10 + DoParseTLV(Data);
      Dec(FIdent);
    end
    else
      S := S + ':' + Item.GetStrValue(Data) + #13#10;
    Inc(i, l);
  end;
  Result := S;
end;

function TTLVParser.GetIdent: AnsiString;
begin
  Result := '';
  if FIdent > 0 then
    Result := StringOfChar(' ', FIdent);
end;

function TTLVParser.ParseTLV(AData: AnsiString): AnsiString;
begin
  FIdent := 0;
  Result := DoParseTLV(AData);
end;

{ TTLVReader }

class function TTLVReader.Read(var Data: AnsiString; var Item: TTLVItem): Boolean;
var
  Len: Integer;
begin
  Result := False;
  if Length(Data) >= 4 then
  begin
    Item.ID := TTLVTag.ValueTLV2Int(Copy(Data, 1, 2));
    Len := TTLVTag.ValueTLV2Int(Copy(Data, 3, 2));
    Item.Data := Copy(Data, 5, Len);
    Data := Copy(Data, 5 + Len, Length(Data));
    Result := True;
  end;
end;

{ TTLVWriter }

class function TTLVWriter.Write(const Item: TTLVItem): AnsiString;
begin
  Result :=
    TTLVTag.Int2ValueTLV(Item.ID, 2) +
    TTLVTag.Int2ValueTLV(Length(Item.Data), 2) +
    Item.Data;
end;

end.
