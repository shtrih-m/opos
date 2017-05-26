unit RecDiscount;

interface

Uses
  // VCL
  Classes,
  // This
  PrinterTypes;

type
  TRecDiscount = class;

  { TRecDiscounts }

  TRecDiscounts = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TRecDiscount;
    procedure InsertItem(AItem: TRecDiscount);
    procedure RemoveItem(AItem: TRecDiscount);
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Clear;
    function ItemByTax1(Tax1: Integer): TRecDiscount;
    function Add(const Data: TAmountOperation): TRecDiscount;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TRecDiscount read GetItem; default;
  end;

  { TRecDiscount }

  TRecDiscount = class
  private
    FOwner: TRecDiscounts;
    FData: TAmountOperation;
    procedure SetOwner(AOwner: TRecDiscounts);
  public
    constructor Create(AOwner: TRecDiscounts; const AData: TAmountOperation);
    destructor Destroy; override;

    property Data: TAmountOperation read FData write FData;
    property Amount: Int64 read FData.Amount write FData.Amount;
  end;

implementation

{ TRecDiscounts }

constructor TRecDiscounts.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TRecDiscounts.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TRecDiscounts.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TRecDiscounts.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TRecDiscounts.GetItem(Index: Integer): TRecDiscount;
begin
  Result := FList[Index];
end;

procedure TRecDiscounts.InsertItem(AItem: TRecDiscount);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TRecDiscounts.RemoveItem(AItem: TRecDiscount);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TRecDiscounts.Add(const Data: TAmountOperation): TRecDiscount;
begin
  Result := TRecDiscount.Create(Self, Data);
end;

function TRecDiscounts.ItemByTax1(Tax1: Integer): TRecDiscount;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Data.Tax1 = Tax1 then Exit;
  end;
  Result := nil;
end;

{ TRecDiscount }

constructor TRecDiscount.Create(AOwner: TRecDiscounts;
  const AData: TAmountOperation);
begin
  inherited Create;
  SetOwner(AOwner);
  FData := AData;
end;

destructor TRecDiscount.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TRecDiscount.SetOwner(AOwner: TRecDiscounts);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
