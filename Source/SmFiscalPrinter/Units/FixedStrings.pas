unit FixedStrings;

interface

uses
  // VCL
  Classes, SysUtils, Math,
  // Tnt
  TntClasses;


type
  { TFixedStrings }
  { Class for fixed count WideString - need for header and trailer }

  TFixedStrings = class
  private
    FLines: TTntStrings;
    function GetText: WideString;
    function GetCount: Integer;
    procedure SetCount(Value: Integer);
    procedure SetText(const Text: WideString);
    function GetItem(Index: Integer): WideString;
    procedure SetItem(Index: Integer; const Value: WideString);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Strings: TTntStrings);
    function ValidIndex(Index: Integer): Boolean;

    property Text: WideString read GetText write SetText;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: WideString read GetItem write SetItem; default;
  end;

implementation

{ TFixedStrings }

constructor TFixedStrings.Create;
begin
  inherited Create;
  FLines := TTntStringList.Create;
end;

destructor TFixedStrings.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

function TFixedStrings.GetCount: Integer;
begin
  Result := FLines.Count;
end;

function TFixedStrings.GetItem(Index: Integer): WideString;
begin
  Result := '';
  if ValidIndex(Index) then
    Result := FLines[Index];

  if Result = '' then Result := ' ';
end;

procedure TFixedStrings.SetItem(Index: Integer; const Value: WideString);
begin
  FLines[Index] := Value;
end;

{ Add or delete WideString }

procedure TFixedStrings.SetCount(Value: Integer);
begin
  if Value <> Count then
  begin
    while Count < Value do
      FLines.Add('');
    while Count > Value do
      FLines.Delete(FLines.Count-1);
  end;
end;

function TFixedStrings.GetText: WideString;
begin
  Result := FLines.Text;
end;

procedure TFixedStrings.SetText(const Text: WideString);
var
  Strings: TTntStrings;
begin
  Strings := TTntStringList.Create;
  try
    Strings.Text := Text;
    Assign(Strings);
  finally
    Strings.Free;
  end;
end;

procedure TFixedStrings.Assign(Strings: TTntStrings);
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    FLines[i] := '';
    if i < Strings.Count then
      FLines[i] := Strings[i];
  end;
end;

function TFixedStrings.ValidIndex(Index: Integer): Boolean;
begin
  Result := (Index >= 0)and(Index < Count);
end;

end.
