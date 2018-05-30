unit UniposTank;

interface

Uses
  // VCL
  Classes,
  // Tnt
  TntClasses;

type
  TUniposTank = class;

  { TUniposTanks }

  TUniposTanks = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TUniposTank;
    procedure InsertItem(AItem: TUniposTank);
    procedure RemoveItem(AItem: TUniposTank);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function Add(const AName: WideString): TUniposTank;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TUniposTank read GetItem; default;
  end;

  { TUniposTank }

  TUniposTank = class
  private
    FName: WideString;
    FValues: TTntStrings;
    FOwner: TUniposTanks;
    procedure SetOwner(AOwner: TUniposTanks);
  public
    constructor Create(AOwner: TUniposTanks; const AName: WideString);
    destructor Destroy; override;

    property Name: WideString read FName;
    property Values: TTntStrings read FValues;
  end;

implementation

{ TUniposTanks }

constructor TUniposTanks.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TUniposTanks.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TUniposTanks.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TUniposTanks.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TUniposTanks.GetItem(Index: Integer): TUniposTank;
begin
  Result := FList[Index];
end;

procedure TUniposTanks.InsertItem(AItem: TUniposTank);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TUniposTanks.RemoveItem(AItem: TUniposTank);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TUniposTanks.Add(const AName: WideString): TUniposTank;
begin
  Result := TUniposTank.Create(Self, AName);
end;

{ TUniposTank }

constructor TUniposTank.Create(AOwner: TUniposTanks; const AName: WideString);
begin
  inherited Create;
  SetOwner(AOwner);
  FValues := TTntStringList.Create;
  FName := AName;
end;

destructor TUniposTank.Destroy;
begin
  FValues.Free;
  SetOwner(nil);
  inherited Destroy;
end;

procedure TUniposTank.SetOwner(AOwner: TUniposTanks);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
