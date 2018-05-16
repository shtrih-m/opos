unit VatCode;

interface

Uses
  // VCL
  Classes, SysUtils, WException, gnugettext;

type
  TVatCode = class;

  { TVatCodes }

  TVatCodes = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TVatCode;
    procedure InsertItem(AItem: TVatCode);
    procedure RemoveItem(AItem: TVatCode);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Add(AppVatCode, FptrVatCode: Integer): TVatCode;
    function ItemByAppVatCode(AppVatCode: Integer): TVatCode;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TVatCode read GetItem; default;
  end;

  { TVatCode }

  TVatCode = class
  private
    FOwner: TVatCodes;
    FAppVatCode: Integer;
    FFptrVatCode: Integer;
    procedure SetOwner(AOwner: TVatCodes);
  public
    constructor Create(AOwner: TVatCodes; AAppVatCode, AFptrVatCode: Integer);
    destructor Destroy; override;

    property AppVatCode: Integer read FAppVatCode;
    property FptrVatCode: Integer read FFptrVatCode;
  end;

implementation

{ TVatCodes }

constructor TVatCodes.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TVatCodes.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TVatCodes.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TVatCodes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TVatCodes.GetItem(Index: Integer): TVatCode;
begin
  Result := FList[Index];
end;

procedure TVatCodes.InsertItem(AItem: TVatCode);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TVatCodes.RemoveItem(AItem: TVatCode);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TVatCodes.Add(AppVatCode, FptrVatCode: Integer): TVatCode;
begin
  if ItemByAppVatCode(AppVatCode) <> nil then
    raiseExceptionFmt(_('Item with app VAT code %d already exists.'),
    [AppVatCode]);

  Result := TVatCode.Create(Self, AppVatCode, FptrVatCode);
end;

function TVatCodes.ItemByAppVatCode(AppVatCode: Integer): TVatCode;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.AppVatCode = AppVatCode then Exit;
  end;
  Result := nil;
end;

{ TVatCode }

constructor TVatCode.Create(AOwner: TVatCodes; AAppVatCode, AFptrVatCode: Integer);
begin
  inherited Create;
  SetOwner(AOwner);
  FAppVatCode := AAppVatCode;
  FFptrVatCode := AFptrVatCode;
end;

destructor TVatCode.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TVatCode.SetOwner(AOwner: TVatCodes);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
