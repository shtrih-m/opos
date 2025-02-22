unit ReceiptTemplate;

interface

uses
  // This
  Windows, Classes, SysUtils,
  // Tnt
  TntClasses, TntSysUtils,
  // This
  ReceiptItem, PrinterParameters, TextParser, StringUtils, GS1Barcode,
  PrinterTypes, FiscalPrinterTypes, MathUtils;

type
  { TFieldAlignment }

  TFieldAlignment = (faLeft, faCenter, faRight);

  { TTemplateFieldRec }

  TTemplateFieldRec = record
    Name: WideString;
    Prefix: WideString;
    Length: Integer;
    Alignment: TFieldAlignment;
  end;

  TReceiptTemplateRec = record
    PrintWidth: Integer;
    TaxInfo: TTaxInfoList;
  end;

  { TReceiptTemplate }

  TReceiptTemplate = class
  private
    FTemplate: WideString;
    FData: TReceiptTemplateRec;

    function GetFieldValue(const Field, Prefix: WideString;
      const Item: TFSSaleItem): WideString;
    function GetTaxRate(Tax: Integer): Double;
    function GetTaxName(Tax: Integer): WideString;
  public
    constructor Create(AData: TReceiptTemplateRec);

    function getItemText(const Item: TFSSaleItem): WideString;
    function ParseField(const Field: WideString): TTemplateFieldRec;
    function ParseField2(const Field: WideString): TTemplateFieldRec;
    function GetText(const FormatLine: WideString; const Item: TFSSaleItem): WideString;

    property Template: WideString read FTemplate write FTemplate;
  end;

implementation

{ TReceiptTemplate }

constructor TReceiptTemplate.Create(AData: TReceiptTemplateRec);
begin
  inherited Create;
  FData := AData;
end;


// %51lTITLE%;%8lPRICE% %6lDISCOUNT%  %8lSUM%       %3QUAN%    %=$10TOTAL_TAX%
function TReceiptTemplate.GetText(const FormatLine: WideString;
  const Item: TFSSaleItem): WideString;
type
  TParserState = (stNone, stChar, stESC, stField);
var
  C: WideChar;
  i: Integer;
  Field: WideString;
  Prefix: WideString;
  State: TParserState;
  FieldValue: WideString;
begin
  Field := '';
  Prefix := '';
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
            FieldValue := GetFieldValue(Field, Prefix, Item);
            Result := Result + FieldValue;
            State := stChar;
          end;
          stESC:
          begin
            Result := Result + '%';
            State := stChar;
          end;
        else
          Field := '';
          Prefix := '';
          State := stField;
        end;
      end;
    else
      if State = stField then
      begin
        if (Field = '')and(not IsWideCharAlphaNumeric(C)) then
        begin
          Prefix := Prefix + C;
        end else
        begin
          Field := Field + C;
        end;
      end else
      begin
        State := stChar;
        Result := Result + FormatLine[i];
      end;
    end;
  end;
end;

function GetTaxLetter(Tax: Integer): WideString;
const
  taxLetters = '������';
begin
  Result := '';
  if (Tax > 0)and(Tax <= Length(TaxLetters)) then
  begin
    Result := TaxLetters[Tax];
  end;
end;

function TReceiptTemplate.GetTaxRate(Tax: Integer): Double;
begin
  Result := 0;
  if Tax in [1..6] then
    Result := FData.TaxInfo[Tax].Rate/10000;
end;

function TReceiptTemplate.GetTaxName(Tax: Integer): WideString;
begin
  Result := '';
  if Tax in [1..6] then
    Result := FData.TaxInfo[Tax].Name;
end;

function TReceiptTemplate.GetFieldValue(const Field, Prefix: WideString;
  const Item: TFSSaleItem): WideString;
var
  L: Integer;
  TaxRate: Double;
  FieldNumber: Integer;
  TaxLetter: WideString;
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
    Result := QuantityToStr(Item.Data.Quantity);
  end;
  if AnsiCompareText(FieldData.Name, 'UnitName') = 0 then
  begin
    Result := Item.Data.UnitName;
  end;
  if AnsiCompareText(FieldData.Name, 'SUM') = 0 then
  begin
    Result := AmountToStr(Item.PriceWithDiscount/100);
  end;
  if AnsiCompareText(FieldData.Name, 'DISCOUNT') = 0 then
  begin
    Result := AmountToStr(Item.PriceDiscount/100);
  end;
  if AnsiCompareText(FieldData.Name, 'DISCOUNTSUM') = 0 then
  begin
    Result := AmountToStr(Item.Discounts.GetTotal/100);
  end;
  if AnsiCompareText(FieldData.Name, 'TOTAL') = 0 then
  begin
    Result := AmountToStr(Item.Total/100);
  end;
  if AnsiCompareText(FieldData.Name, 'TOTAL_TAX') = 0 then
  begin
    Result := AmountToStr(Item.Total/100);
    TaxLetter := GetTaxLetter(Item.Tax);
    if TaxLetter <> '' then
    begin
      Result := Result + '_' + TaxLetter;
    end;
  end;
  if AnsiCompareText(FieldData.Name, 'TAX_AMOUNT') = 0 then
  begin
    TaxRate := GetTaxRate(Item.Tax);
    Result := AmountToStr(Round2(Item.Total * TaxRate/(1 + TaxRate))/100);
  end;
  if AnsiCompareText(FieldData.Name, 'TAX_LETTER') = 0 then
  begin
    Result := GetTaxLetter(Item.Tax);
  end;
  if AnsiCompareText(FieldData.Name, 'TAX_NAME') = 0 then
  begin
    Result := GetTaxName(Item.Tax);
  end;
  if AnsiCompareText(FieldData.Name, 'MULT_NE_ONE') = 0 then
  begin
    if Item.Data.Quantity = 1 then Result := ' '
    else Result := '*';
  end;
  // KTN
  if AnsiCompareText(FieldData.Name, 'KTN') = 0 then
  begin
    if Item.Data.Tag1162IsSet then
    begin
      Result := '[M]';
    end;
  end;
  // FIELD
  if AnsiCompareText(Copy(FieldData.Name, 1, 5), 'FIELD') = 0 then
  begin
    FieldNumber := StrToIntDef(Copy(FieldData.Name, 6, 2), 0);
    if FieldNumber in [MinReceiptField..MaxReceiptField] then
      Result := Item.Data.ReceiptField[FieldNumber];
  end;

  Result := Prefix + Result;
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

function TReceiptTemplate.ParseField(const Field: WideString): TTemplateFieldRec;
type
  TFieldParserState = (stNone, stLength, stText);
var
  C: WideChar;
  i: Integer;
  Text: WideString;
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

function TReceiptTemplate.getItemText(const Item: TFSSaleItem): WideString;
var
  i: Integer;
  Lines: TTntStrings;
  TemplateLines: TTntStrings;
begin
  Lines := TTntStringList.Create;
  TemplateLines := TTntStringList.Create;
  try
    if Item.Quantity < 0 then
    begin
      Lines.Add('������');
      Item.Quantity := Abs(Item.Quantity);
    end;
    TemplateLines.Text := FTemplate;
    for i := 0 to TemplateLines.Count-1 do
    begin
      Lines.Add(GetText(TemplateLines[i], Item));
    end;

    Result := Lines.Text;
  finally
    Lines.Free;
    TemplateLines.Free;
  end;
end;

function TReceiptTemplate.ParseField2(
  const Field: WideString): TTemplateFieldRec;
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

////////////////////////////////////////////////////////////////////////////////
// %3cPOS% %20lTITLE% %6lSUM% * %6QUAN% %6lDISCOUNTSUM% =%10TOTAL_TAX%

end.
