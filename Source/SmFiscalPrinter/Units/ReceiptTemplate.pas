unit ReceiptTemplate;

interface

uses
  // This
  Classes,
  // This
  ReceiptItem, PrinterParameters;

type
  { TReceiptTemplate }

  TReceiptTemplate = class
  private
    FTemplate: string;
    function GetText(const FormatLine: string; const Item: TFSSaleItem): string;
  public
    constructor Create(const ATemplate: string);
    function getItemText(const Item: TFSSaleItem): string;
  end;

implementation

{ TReceiptTemplate }

constructor TReceiptTemplate.Create(const ATemplate: string);
begin
  inherited Create;
  FTemplate := ATemplate;
end;

// \% %51lTITLE%;%8lPRICE% %6lDISCOUNT%  %8lSUM%       %3QUAN%    %=$10TOTAL_TAX%
function TReceiptTemplate.GetText(const FormatLine: string;
  const Item: TFSSaleItem): string;
type
  TParserState = (stChar, stESC, stField);
var
  C: Char;
  i: Integer;
  Field: string;
  State: TParserState;
begin
(*
  Field := '';
  Result := '';
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
          end;
          stESC:
          begin

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
*)
end;

function TReceiptTemplate.getItemText(const Item: TFSSaleItem): string;
var
  i: Integer;
  Lines: TStrings;
  TemplateLines: TStrings;
begin
(*
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
      Lines.Add(GetText(TemplateLines[i], Item);
    end;

    if Item.PostLine <> '' then
      Lines.Add(Item.PostLine);

    Result := Lines.Text;
  finally
    Lines.Free;
    TemplateLines.Free;
  end;
*)  
end;

end.
