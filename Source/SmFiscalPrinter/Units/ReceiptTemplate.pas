unit ReceiptTemplate;

interface

uses
  // This
  Classes, SysUtils,
  // This
  ReceiptItem, PrinterParameters, TextParser, StringUtils;

type
  { TFieldAlignment }

  TFieldAlignment = (faLeft, faCenter, faRight);

  { TTemplateFieldRec }

  TTemplateFieldRec = record
    Name: string;
    Length: Integer;
    Alignment: TFieldAlignment;
  end;

  { TReceiptTemplate }

  TReceiptTemplate = class
  private
    FTemplate: string;
    function GetFieldValue(const Field: string; const Item: TFSSaleItem): string;
  public
    function getItemText(const Item: TFSSaleItem): string;
    function ParseField(const Field: string): TTemplateFieldRec;
    function ParseField2(const Field: string): TTemplateFieldRec;
    function GetText(const FormatLine: string; const Item: TFSSaleItem): string;

    property Template: string read FTemplate write FTemplate;
  end;

implementation

{ TReceiptTemplate }

// %51lTITLE%;%8lPRICE% %6lDISCOUNT%  %8lSUM%       %3QUAN%    %=$10TOTAL_TAX%
function TReceiptTemplate.GetText(const FormatLine: string;
  const Item: TFSSaleItem): string;
type
  TParserState = (stNone, stChar, stESC, stField);
var
  C: Char;
  i: Integer;
  Field: string;
  State: TParserState;
begin
  Field := '';
  Result := '';
  State := stNone;
  for i := 1 to Length(FormatLine) do
  begin
    C := FormatLine[i];
    case C of
      '\': State := stESC;
      '%':
      begin
        case State of
          stField:
          begin
            Result := Result + GetFieldValue(Field, Item);
            State := stChar;
          end;
          stESC:
          begin
            Result := Result + '%';
            State := stChar;
          end;
        else
          Field := '';
          State := stField;
        end;
      end;
    else
      if State = stField then
      begin
        Field := Field + C;
      end else
      begin
        State := stChar;
        Result := Result + FormatLine[i];
      end;
    end;
  end;
end;

function GetTaxLetter(Tax: Integer): string;
const
  taxLetters = 'ÀÁÂÃÄÅ';
begin
  Result := '';
  if (Tax > 0)and(Tax <= Length(TaxLetters)) then
  begin
    Result := TaxLetters[Tax];
  end;
end;


function TReceiptTemplate.GetFieldValue(const Field: string;
  const Item: TFSSaleItem): string;
var
  L: Integer;
  TaxLetter: string;
  FieldData: TTemplateFieldRec;
begin
  Result := '';
  FieldData := ParseField(Field);
  if AnsiCompareText(FieldData.Name, 'TITLE') = 0 then
  begin
    Result := Item.Text;
  end;
  if AnsiCompareText(FieldData.Name, 'POS') = 0 then
  begin
    Result := IntToStr(Item.Pos);
  end;
  if AnsiCompareText(FieldData.Name, 'UNITPRICE') = 0 then
  begin
    Result := AmountToStr(Item.UnitPrice/100);
  end;
  if AnsiCompareText(FieldData.Name, 'PRICE') = 0 then
  begin
    Result := AmountToStr(Item.UnitPrice/100);
  end;
  if AnsiCompareText(FieldData.Name, 'QUAN') = 0 then
  begin
    Result := QuantityToStr(Item.Data.Quantity/1000);
  end;
  if AnsiCompareText(FieldData.Name, 'SUM') = 0 then
  begin
    Result := AmountToStr(Item.PriceWithDiscount/100);
  end;
  if AnsiCompareText(FieldData.Name, 'DISCOUNT') = 0 then
  begin
    Result := AmountToStr(Item.PriceDiscount/100);
  end;
  if AnsiCompareText(FieldData.Name, 'TOTAL') = 0 then
  begin
    Result := AmountToStr(Item.Total/100);
  end;
  if AnsiCompareText(FieldData.Name, 'TOTAL_TAX') = 0 then
  begin
    Result := AmountToStr(Item.Total2/100);
    TaxLetter := GetTaxLetter(Item.Tax);
    if TaxLetter <> '' then
    begin
      Result := Result + '_' + TaxLetter;
    end;
  end;
  if AnsiCompareText(FieldData.Name, 'TAX_LETTER') = 0 then
  begin
    Result := GetTaxLetter(Item.Tax);
  end;
  if AnsiCompareText(FieldData.Name, 'MULT_NE_ONE') = 0 then
  begin
    if Item.Data.Quantity = 1000 then Result := ' '
    else Result := '*';
  end;

  if FieldData.Length <> 0 then
  begin
    Result := Copy(Result, 1, FieldData.Length);
    L := FieldData.Length - Length(Result);
    if L < 0 then L := 0;
    case FieldData.Alignment of
      faLeft: Result := Result + StringOfChar(' ', L);
      faCenter:
      begin
        Result := StringOfChar(' ', L div 2) + Result + StringOfChar(' ', L - (L div 2));
      end;
    else
      Result := StringOfChar(' ', L) + Result;
    end;
  end;
end;

function TReceiptTemplate.ParseField(const Field: string): TTemplateFieldRec;
type
  TFieldParserState = (stNone, stLength, stText);
var
  C: Char;
  i: Integer;
  Text: string;
  State: TFieldParserState;
begin
  Result.Name := '';
  Result.Length := 0;
  Result.Alignment := faRight;

  Text := '';
  State := stNone;
  for i := 1 to Length(Field) do
  begin
    C := Field[i];
    case C of
      '0'..'9':
      begin
        if State = stNone then
        begin
          State := stLength;
        end;
        Text := Text + C;
      end;
      'c', 'l':
      begin
        case State of
          stNone:
          begin
            if C = 'c' then
              Result.Alignment := faCenter
            else
              Result.Alignment := faLeft;
            State := stText;
            Text := '';
          end;
          stLength:
          begin
            Result.Length := StrToInt(Text);
            if C = 'c' then
              Result.Alignment := faCenter
            else
              Result.Alignment := faLeft;
            State := stText;
            Text := '';
          end;
        else
          Text := Text + C;
        end;
      end;
    else
      if State = stLength then
      begin
        Result.Length := StrToInt(Text);
        Text := '';
      end;
      State := stText;
      Text := Text + C;
    end;
  end;
  Result.Name := Text;
end;

function TReceiptTemplate.getItemText(const Item: TFSSaleItem): string;
var
  i: Integer;
  Lines: TStrings;
  TemplateLines: TStrings;
begin
  Lines := TStringList.Create;
  TemplateLines := TStringList.Create;
  try
    if Item.PreLine <> '' then
      Lines.Add(Item.PreLine);

    if Item.Quantity < 0 then
    begin
      Lines.Add('ÑÒÎÐÍÎ');
      Item.Quantity := Abs(Item.Quantity);
    end;
    TemplateLines.Text := FTemplate;
    for i := 0 to TemplateLines.Count-1 do
    begin
      Lines.Add(GetText(TemplateLines[i], Item));
    end;

    if Item.PostLine <> '' then
      Lines.Add(Item.PostLine);

    Result := Lines.Text;
  finally
    Lines.Free;
    TemplateLines.Free;
  end;
end;

function TReceiptTemplate.ParseField2(
  const Field: string): TTemplateFieldRec;
var
  Parser: TTextParser;
  TextField: TTextParserField;
  AlignField: TCharParserField;
  LengthField: TIntegerParserField;
begin
  Parser := TTextParser.Create;
  try
    LengthField := TIntegerParserField.Create(Parser.Fields);
    AlignField := TCharParserField.Create(Parser.Fields, ['c', 'l']);
    TextField := TTextParserField.Create(Parser.Fields);
    Parser.Parse(Field);

    Result.Name := TextField.Text;
    Result.Length := LengthField.Value;
    case AlignField.Value of
      'c': Result.Alignment := faCenter;
      'l': Result.Alignment := faLeft;
    else
      Result.Alignment := faRight;
    end;
  finally
    Parser.Free;
  end;
end;

end.
