unit FixedStrings;

interface

uses
  // VCL
  Classes, SysUtils, Math;

type
  { TFixedStrings }
  { Class for fixed count string - need for header and trailer }

  TFixedStrings = class
  private
    FLines: TStrings;
    function GetText: string;
    function GetCount: Integer;
    procedure SetCount(Value: Integer);
    procedure SetText(const Text: string);
    function GetItem(Index: Integer): string;
    procedure SetItem(Index: Integer; const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Strings: TStrings);
    function ValidIndex(Index: Integer): Boolean;

    property Text: string read GetText write SetText;
    property Count: Integer read GetCount write SetCount;
    property Items[Index: Integer]: string read GetItem write SetItem; default;
  end;

implementation

{ TFixedStrings }

constructor TFixedStrings.Create;
begin
  inherited Create;
  FLines := TStringList.Create;
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

function TFixedStrings.GetItem(Index: Integer): string;
begin
  Result := '';
  if ValidIndex(Index) then
    Result := FLines[Index];

  if Result = '' then Result := ' ';
end;

procedure TFixedStrings.SetItem(Index: Integer; const Value: string);
begin
  FLines[Index] := Value;
end;

{ Add or delete string }

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

function TFixedStrings.GetText: string;
begin
  Result := FLines.Text;
end;

procedure TFixedStrings.SetText(const Text: string);
var
  Strings: TStrings;
begin
  Strings := TStringList.Create;
  try
    Strings.Text := Text;
    Assign(Strings);
  finally
    Strings.Free;
  end;
end;

procedure TFixedStrings.Assign(Strings: TStrings);
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
