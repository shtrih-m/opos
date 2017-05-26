unit PayType;

interface

Uses
  // VCL
  Windows, Classes, SysUtils;

type
  TPayType = class;

  { TPayTypes }

  TPayTypes = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TPayType;
    procedure InsertItem(AItem: TPayType);
    procedure RemoveItem(AItem: TPayType);
  public
    constructor Create;
    destructor Destroy; override;
    function ItemByText(const Text: string): TPayType;
    function Add(ACode: Byte; const AText: string): TPayType;
    procedure Clear;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPayType read GetItem; default;
  end;

  { TPayType }

  TPayType = class
  private
    FCode: Byte;
    FText: string;
    FOwner: TPayTypes;
    procedure SetOwner(AOwner: TPayTypes);
  public
    constructor Create(AOwner: TPayTypes; ACode: Byte; const AText: string);
    destructor Destroy; override;

    property Code: Byte read FCode;
    property Text: string read FText;
  end;

implementation

{ TPayTypes }

constructor TPayTypes.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPayTypes.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TPayTypes.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TPayTypes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPayTypes.GetItem(Index: Integer): TPayType;
begin
  Result := FList[Index];
end;

procedure TPayTypes.InsertItem(AItem: TPayType);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPayTypes.RemoveItem(AItem: TPayType);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TPayTypes.ItemByText(const Text: string): TPayType;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.Text, Text) = 0 then Exit;
  end;
  Result := nil;
end;

function TPayTypes.Add(ACode: Byte; const AText: string): TPayType;
begin
  Result := TPayType.Create(Self, ACode, AText);
end;

{ TPayType }

constructor TPayType.Create(AOwner: TPayTypes; ACode: Byte; const AText: string);
begin
  inherited Create;
  SetOwner(AOwner);
  FCode := ACode;
  FText := AText;
end;

destructor TPayType.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TPayType.SetOwner(AOwner: TPayTypes);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
