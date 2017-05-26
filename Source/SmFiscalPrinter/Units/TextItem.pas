unit TextItem;

interface

Uses
  // VCL
  Classes,
  // This
  PrinterTypes, FiscalPrinterTypes;

type
  TTextItem = class;

  { TTextItems }

  TTextItems = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TTextItem;
    procedure InsertItem(AItem: TTextItem);
    procedure RemoveItem(AItem: TTextItem);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(const AData: TTextRec): TTextItem;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTextItem read GetItem; default;
  end;

  { TTextItem }

  TTextItem = class
  private
    FData: TTextRec;
    FOwner: TTextItems;
    procedure SetOwner(AOwner: TTextItems);
  public
    constructor Create(AOwner: TTextItems; const AData: TTextRec);
    destructor Destroy; override;
    property Data: TTextRec read FData;
  end;

implementation

{ TTextItems }

constructor TTextItems.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTextItems.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTextItems.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TTextItems.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTextItems.GetItem(Index: Integer): TTextItem;
begin
  Result := FList[Index];
end;

procedure TTextItems.InsertItem(AItem: TTextItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TTextItems.RemoveItem(AItem: TTextItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TTextItems.Add(const AData: TTextRec): TTextItem;
begin
  Result := TTextItem.Create(Self, AData);
end;

{ TTextItem }

constructor TTextItem.Create(AOwner: TTextItems; const AData: TTextRec);
begin
  inherited Create;
  SetOwner(AOwner);
  FData := AData;
end;

destructor TTextItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TTextItem.SetOwner(AOwner: TTextItems);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
