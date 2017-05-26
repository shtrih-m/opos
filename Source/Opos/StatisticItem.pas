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
    procedure Assign(Source: TStatisticItems);
    function ItemByName(const AName: string): TStatisticItem;
    function AddItem(Item: TStatisticItem): TStatisticItem;
    function Add(const AName: string; AItemType: TStatisticType): TStatisticItem;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TStatisticItem read GetItem; default;
  end;

  { TStatisticItem }

  TStatisticItem = class
  private
    FName: string;
    FCounter: Int64;
    FIsEmpty: Boolean;
    FItemType: TStatisticType;
    FOwner: TStatisticItems;
    procedure SetOwner(AOwner: TStatisticItems);
    function GetText: string;
  public
    constructor Create(AOwner: TStatisticItems; const AName: string;
      AItemType: TStatisticType);
    destructor Destroy; override;

    procedure Reset;
    function IsOpos: Boolean;
    function IsManufacturer: Boolean;
    procedure IncCounter(Count: Integer);
    procedure SetValue(const Value: string);
    procedure Assign(Source: TStatisticItem);

    property Name: string read FName;
    property Text: string read GetText;
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

function TStatisticItems.ItemByName(const AName: string): TStatisticItem;
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

function TStatisticItems.Add(const AName: string;
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
const AName: string; AItemType: TStatisticType);
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

function TStatisticItem.GetText: string;
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

procedure TStatisticItem.SetValue(const Value: string);
begin
  FCounter := StrToInt64(Value);
end;

end.
