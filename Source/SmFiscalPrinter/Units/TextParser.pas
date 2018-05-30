unit TextParser;

interface

uses
  // VCL
  Classes, SysUtils;

type
  TParserField = class;

  { TParserFields }

  TParserFields = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TParserField;
    procedure Clear;
    procedure InsertItem(AItem: TParserField);
    procedure RemoveItem(AItem: TParserField);
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TParserField read GetItem; default;
  end;

  { TParserField }

  TParserField = class
  private
    FOwner: TParserFields;
    procedure SetOwner(AOwner: TParserFields);
  public
    constructor Create(AOwner: TParserFields);
    destructor Destroy; override;
    function Parse(const C: Char): Boolean; virtual; abstract;
  end;

  { TIntegerParserField }

  TIntegerParserField = class(TParserField)
  private
    FValue: Integer;
    FText: AnsiString;
  public
    function Parse(const C: Char): Boolean; override;

    property Text: AnsiString read FText;
    property Value: Integer read FValue;
  end;

  TTextParserField = class(TParserField)
  private
    FText: AnsiString;
  public
    function Parse(const C: Char): Boolean; override;
    property Text: AnsiString read FText;
  end;

  { TChars }

  TChars = set of char;

  { TCharParserField }

  TCharParserField = class(TParserField)
  private
    FValue: Char;
    FValues: TChars;
  public
    constructor Create(AOwner: TParserFields; AValues: TChars);
    function Parse(const C: Char): Boolean; override;

    property Value: Char read FValue;
    property Values: TChars read FValues write FValues;
  end;

  { TTextParser }

  TTextParser = class
  private
    FFields: TParserFields;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(const Text: AnsiString);
    procedure AddField(Field: TParserField);
    property Fields: TParserFields read FFields;
  end;

implementation

{ TParserFields }

constructor TParserFields.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TParserFields.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TParserFields.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TParserFields.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TParserFields.GetItem(Index: Integer): TParserField;
begin
  Result := FList[Index];
end;

procedure TParserFields.InsertItem(AItem: TParserField);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TParserFields.RemoveItem(AItem: TParserField);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

{ TParserField }

constructor TParserField.Create(AOwner: TParserFields);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TParserField.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TParserField.SetOwner(AOwner: TParserFields);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

{ TIntegerParserField }

function TIntegerParserField.Parse(const C: Char): Boolean;
begin
  Result := Char(C) in ['0'..'9'];
  if Result then
  begin
    FText := FText + C;
    FValue := StrToInt(FText);
  end;
end;

{ TTextParserField }

function TTextParserField.Parse(const C: Char): Boolean;
begin
  Result := True;
  FText := FText + C;
end;

{ TCharParserField }

constructor TCharParserField.Create(AOwner: TParserFields; AValues: TChars);
begin
  inherited Create(AOwner);
  FValues := AValues;
end;

function TCharParserField.Parse(const C: Char): Boolean;
begin
  Result := Char(C) in FValues;
  if Result then
    FValue := C;
end;

{ TTextParser }

constructor TTextParser.Create;
begin
  inherited Create;
  FFields := TParserFields.Create;
end;

destructor TTextParser.Destroy;
begin
  FFields.Free;
  inherited Destroy;
end;

procedure TTextParser.AddField(Field: TParserField);
begin
  FFields.InsertItem(Field);
end;

procedure TTextParser.Parse(const Text: AnsiString);
var
  i, Index: Integer;
begin
  Index := 0;
  for i := 1 to Length(Text) do
  begin
    while Index < Fields.Count do
    begin
      if Fields[Index].Parse(Text[i]) then Break;
      Inc(Index);
    end;
  end;
end;

end.
