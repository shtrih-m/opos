unit RecItem;

interface

Uses
  // VCL
  Classes,
  // This
  PrinterTypes;

type
  TRecItem = class;

  { TRecItems }

  TRecItems = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TRecItem;
    procedure InsertItem(AItem: TRecItem);
    procedure RemoveItem(AItem: TRecItem);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const Data: TPriceReg): TRecItem;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TRecItem read GetItem; default;
  end;

  { TRecItem }

  TRecItem = class
  private
    FOwner: TRecItems;
    FData: TPriceReg;
    procedure SetOwner(AOwner: TRecItems);
  public
    constructor Create(AOwner: TRecItems; const AData: TPriceReg);
    destructor Destroy; override;
    property Data: TPriceReg read FData;
  end;

implementation

{ TRecItems }

constructor TRecItems.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TRecItems.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TRecItems.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TRecItems.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TRecItems.GetItem(Index: Integer): TRecItem;
begin
  Result := FList[Index];
end;

procedure TRecItems.InsertItem(AItem: TRecItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TRecItems.RemoveItem(AItem: TRecItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TRecItems.Add(const Data: TPriceReg): TRecItem;
begin
  Result := TRecItem.Create(Self, Data);
end;

{ TRecItem }

constructor TRecItem.Create(AOwner: TRecItems; const AData: TPriceReg);
begin
  inherited Create;
  SetOwner(AOwner);
  FData := AData;
end;

destructor TRecItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TRecItem.SetOwner(AOwner: TRecItems);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
