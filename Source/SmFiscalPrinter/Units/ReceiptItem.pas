unit ReceiptItem;

interface

Uses
  // VCL
  Classes,
  // This
  PrinterTypes, TextItem, MathUtils;

type
  TReceiptItem = class;
  TFSSaleItem = class;

  { TReceiptItems }

  TReceiptItems = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TReceiptItem;
    procedure InsertItem(AItem: TReceiptItem);
    procedure RemoveItem(AItem: TReceiptItem);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(Items: TReceiptItems);
    function GetTotal: Int64;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TReceiptItem read GetItem; default;
  end;

  { TReceiptItem }

  TReceiptItem = class
  private
    FOwner: TReceiptItems;
    procedure SetOwner(AOwner: TReceiptItems);
  public
    constructor Create(AOwner: TReceiptItems);
    procedure Assign(Items: TReceiptItem); virtual;
    destructor Destroy; override;
    function GetTotal: Int64; virtual;
  end;

  { TSaleReceiptItem }

  TSaleReceiptItem = class(TReceiptItem)
  public
    Data: TPriceReg;
    PreLine: string;
    PostLine: string;
  end;

  { TStornoReceiptItem }

  TStornoReceiptItem = class(TReceiptItem)
  public
    Data: TPriceReg;
    PreLine: string;
    PostLine: string;
  end;

  { TDiscountReceiptItem }

  TDiscountReceiptItem = class(TReceiptItem)
  public
    Data: TAmountOperation;
    PreLine: string;
    PostLine: string;
    function GetTotal: Int64; override;
    procedure Assign(Item: TReceiptItem); override;
  end;

  { TChargeReceiptItem }

  TChargeReceiptItem = class(TReceiptItem)
  public
    Data: TAmountOperation;
    PreLine: string;
    PostLine: string;
    function GetTotal: Int64; override;
  end;

  { TTextReceiptItem }

  TTextReceiptItem = class(TReceiptItem)
  public
    Data: TTextRec;
    procedure Assign(Item: TReceiptItem); override;
  end;

  { TFSSaleItem }

  TFSSaleItem = class(TReceiptItem)
  private
    FDiscounts: TReceiptItems;
    FPriceWithDiscount: Int64;
    function GetPriceDiscount: Int64;
  public
    destructor Destroy; override;
  public
    Pos: Integer;
    Data: TFSSale;
    PreLine: string;
    PostLine: string;
    FUnitPrice: Int64;

    function GetAmount: int64;
    function GetTotal: Int64; override;
    function GetDiscounts: TReceiptItems;
    procedure Assign(Item: TReceiptItem); override;

    property Total: Int64 read GetTotal;
    property PriceWithDiscount: Int64 read FPriceWithDiscount;
    property PriceDiscount: Int64 read GetPriceDiscount;
    property Discounts: TReceiptItems read GetDiscounts;
    property RecType: Integer read Data.RecType write Data.RecType;
    property Quantity: Int64 read Data.Quantity write Data.Quantity;
    property Price: Int64 read Data.Price write Data.Price;
    property Department: Byte read Data.Department write Data.Department;
    property Tax: Byte read Data.Tax write Data.Tax;
    property Text: string read Data.Text write Data.Text;
    property Charge: Int64 read Data.Charge write Data.Charge;
    property Discount: Int64 read Data.Discount write Data.Discount;
    property Barcode: Int64 read Data.Barcode write Data.Barcode;
    property AdjText: string read Data.AdjText write Data.AdjText;
    property UnitPrice: Int64 read FUnitPrice write FUnitPrice;
  end;

  { TBarcodeReceiptItem }

  TBarcodeReceiptItem = class(TReceiptItem)
  public
    Data: TBarcodeRec;
    procedure Assign(Item: TReceiptItem); override;
  end;

  { TTLVReceiptItem }

  TTLVReceiptItem = class(TReceiptItem)
  public
    Data: string;
    procedure Assign(Item: TReceiptItem); override;
  end;

implementation

{ TReceiptItems }

constructor TReceiptItems.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TReceiptItems.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TReceiptItems.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TReceiptItems.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TReceiptItems.GetItem(Index: Integer): TReceiptItem;
begin
  Result := FList[Index];
end;

procedure TReceiptItems.InsertItem(AItem: TReceiptItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TReceiptItems.RemoveItem(AItem: TReceiptItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TReceiptItems.GetTotal: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count-1 do
    Result := Result + Items[i].GetTotal;
end;

procedure TReceiptItems.Assign(Items: TReceiptItems);
var
  i: Integer;
  Item: TReceiptItem;
begin
  Clear;
  for i := 0 to Items.Count-1 do
  begin
    Item := Items[i].ClassType.Create as TReceiptItem;
    InsertItem(Item);
    Item.Assign(Items[i]);
  end;
end;

{ TReceiptItem }

procedure TReceiptItem.Assign(Items: TReceiptItem);
begin

end;

constructor TReceiptItem.Create(AOwner: TReceiptItems);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TReceiptItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

function TReceiptItem.GetTotal: Int64;
begin
  Result := 0;
end;

procedure TReceiptItem.SetOwner(AOwner: TReceiptItems);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

{ TFSSaleItem }

destructor TFSSaleItem.Destroy;
begin
  FDiscounts.Free;
  inherited Destroy;
end;

function TFSSaleItem.GetAmount: int64;
begin
  Result := Abs(Round2(Price * Quantity/1000));
end;

function TFSSaleItem.GetTotal: Int64;
begin
  Result := GetAmount - Discount + Charge;
end;

function TFSSaleItem.GetDiscounts: TReceiptItems;
begin
  if FDiscounts = nil then
    FDiscounts := TReceiptItems.Create;
  Result := FDiscounts;
end;

procedure TFSSaleItem.Assign(Item: TReceiptItem);
var
  Src: TFSSaleItem;
begin
  if Item is TFSSaleItem then
  begin
    Src := Item as TFSSaleItem;

    Data := Src.Data;
    PreLine := Src.PreLine;
    PostLine := Src.PostLine;
    Discounts.Assign(Src.Discounts);
  end;
end;

function TFSSaleItem.GetPriceDiscount: Int64;
begin
  Result := Price - PriceWithDiscount;
end;

{ TDiscountReceiptItem }

procedure TDiscountReceiptItem.Assign(Item: TReceiptItem);
var
  Src: TDiscountReceiptItem;
begin
  if Item is TDiscountReceiptItem then
  begin
    Src := Item as TDiscountReceiptItem;

    Data := Src.Data;
    PreLine := Src.PreLine;
    PostLine := Src.PostLine;
  end;
end;

function TDiscountReceiptItem.GetTotal: Int64;
begin
  Result := -Data.Amount;
end;

{ TChargeReceiptItem }

function TChargeReceiptItem.GetTotal: Int64;
begin
  Result := Data.Amount;
end;

{ TTextReceiptItem }

procedure TTextReceiptItem.Assign(Item: TReceiptItem);
var
  Src: TTextReceiptItem;
begin
  if Item is TTextReceiptItem then
  begin
    Src := Item as TTextReceiptItem;
    Data := Src.Data;
  end;
end;

{ TBarcodeReceiptItem }

procedure TBarcodeReceiptItem.Assign(Item: TReceiptItem);
var
  Src: TBarcodeReceiptItem;
begin
  if Item is TBarcodeReceiptItem then
  begin
    Src := Item as TBarcodeReceiptItem;
    Data := Src.Data;
  end;
end;

{ TTLVReceiptItem }

procedure TTLVReceiptItem.Assign(Item: TReceiptItem);
var
  Src: TTLVReceiptItem;
begin
  if Item is TTLVReceiptItem then
  begin
    Src := Item as TTLVReceiptItem;
    Data := Src.Data;
  end;
end;

end.
