unit StatisticItem;

interface

Uses
  // VCL
  Classes, SysUtils;

const
  OposStatisticsPrefix = 'U_';  // UnifiedPOS defined statistics
  ManfStatisticsPrefix = 'M_';  // manufacturer defined statistics

type
  TStatisticItem = class;
  TStatisticType = (stOpos, stManufacturer);

  { TStatisticItems }

  TStatisticItems = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TStatisticItem;
    procedure InsertItem(AItem: TStatisticItem);
    procedure RemoveItem(AItem: TStatisticItem);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Reset(const AName: WideString);
    procedure Assign(Source: TStatisticItems);
    function ItemByName(const AName: WideString): TStatisticItem;
    function AddItem(Item: TStatisticItem): TStatisticItem;
    function Add(const AName: WideString; AItemType: TStatisticType): TStatisticItem;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStatisticItem read GetItem; default;
  end;

  { TStatisticItem }

  TStatisticItem = class
  private
    FName: WideString;
    FCounter: Int64;
    FIsEmpty: Boolean;
    FItemType: TStatisticType;
    FOwner: TStatisticItems;
    procedure SetOwner(AOwner: TStatisticItems);
    function GetText: WideString;
  public
    constructor Create(AOwner: TStatisticItems; const AName: WideString;
      AItemType: TStatisticType);
    destructor Destroy; override;

    procedure Reset;
    function IsOpos: Boolean;
    function IsManufacturer: Boolean;
    procedure IncCounter(Count: Integer);
    procedure SetValue(const Value: WideString);
    procedure Assign(Source: TStatisticItem);
    function Select(const AName: WideString): Boolean;

    property Name: WideString read FName;
    property Text: WideString read GetText;
    property ItemType: TStatisticType read FItemType;
    property Counter: Int64 read FCounter write FCounter;
    property IsEmpty: Boolean read FIsEmpty write FIsEmpty;
  end;

implementation

{ TStatisticItems }

constructor TStatisticItems.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TStatisticItems.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TStatisticItems.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TStatisticItems.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TStatisticItems.GetItem(Index: Integer): TStatisticItem;
begin
  Result := FList[Index];
end;

procedure TStatisticItems.InsertItem(AItem: TStatisticItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TStatisticItems.RemoveItem(AItem: TStatisticItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

procedure TStatisticItems.Reset(const AName: WideString);
var
  i: Integer;
  Item: TStatisticItem;
begin
  for i := 0 to Count-1 do
  begin
    Item := Items[i];
    if Item.Select(AName) then Item.Reset;
  end;
end;

function TStatisticItems.ItemByName(const AName: WideString): TStatisticItem;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.Name, AName) = 0 then Exit;
  end;
  Result := nil;
end;

procedure TStatisticItems.Assign(Source: TStatisticItems);
var
  i: Integer;
  SrcItem: TStatisticItem;
  DstItem: TStatisticItem;
begin
  Clear;
  for i := 0 to Source.Count-1 do
  begin
    SrcItem := Source[i];
    DstItem := Add(SrcItem.Name, SrcItem.ItemType);
    DstItem.Assign(SrcItem);
  end;
end;

function TStatisticItems.Add(const AName: WideString;
  AItemType: TStatisticType): TStatisticItem;
begin
  Result := TStatisticItem.Create(Self, AName, AItemType);
end;

function TStatisticItems.AddItem(Item: TStatisticItem): TStatisticItem;
begin
  Result := Add(Item.Name, Item.ItemType);
  Result.Assign(Item);
end;

{ TStatisticItem }

constructor TStatisticItem.Create(AOwner: TStatisticItems;
const AName: WideString; AItemType: TStatisticType);
begin
  inherited Create;
  FName := AName;
  FItemType := AItemType;
  SetOwner(AOwner);
end;

destructor TStatisticItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TStatisticItem.SetOwner(AOwner: TStatisticItems);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TStatisticItem.Reset;
begin
  FCounter := 0;
end;

procedure TStatisticItem.IncCounter(Count: Integer);
begin
  FCounter := FCounter + Count;
end;

procedure TStatisticItem.Assign(Source: TStatisticItem);
begin
  FCounter := Source.Counter;
end;

function TStatisticItem.GetText: WideString;
begin
  if IsEmpty then Result := ''
  else Result := IntToStr(Counter);
end;

function TStatisticItem.IsManufacturer: Boolean;
begin
  Result := ItemType = stManufacturer;
end;

function TStatisticItem.IsOpos: Boolean;
begin
  Result := ItemType = stOpos;
end;

procedure TStatisticItem.SetValue(const Value: WideString);
begin
  FCounter := StrToInt64(Value);
end;

function TStatisticItem.Select(const AName: WideString): Boolean;
begin
  Result := AName = '';
  if Result then Exit;

  Result := AnsiCompareText(Name, AName) = 0;
  if Result then Exit;

  Result := (AName = OposStatisticsPrefix)and(ItemType = stOpos);
  if Result then Exit;

  Result := (AName = ManfStatisticsPrefix)and(ItemType = stManufacturer);
end;

end.
