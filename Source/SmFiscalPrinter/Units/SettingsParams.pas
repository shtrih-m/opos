unit SettingsParams;

interface

Uses
  // VCL
  Classes;

type

  TSettingsParam = class;

  { TSettingsParams }

  TSettingsParams = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TSettingsParam;
    procedure InsertItem(AItem: TSettingsParam);
    procedure RemoveItem(AItem: TSettingsParam);
  public
    constructor Create;
    destructor Destroy; override;
    function Add: TSettingsParam;

    procedure Clear;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TSettingsParam read GetItem; default;
  end;

  { TSettingsParam }

  TSettingsParam = class
  private
    FOwner: TSettingsParams;
    procedure SetOwner(AOwner: TSettingsParams);
  public
    constructor Create(AOwner: TSettingsParams);
    destructor Destroy; override;
  end;

implementation

{ TSettingsParams }

constructor TSettingsParams.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TSettingsParams.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TSettingsParams.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TSettingsParams.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TSettingsParams.GetItem(Index: Integer): TSettingsParam;
begin
  Result := FList[Index];
end;

procedure TSettingsParams.InsertItem(AItem: TSettingsParam);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TSettingsParams.RemoveItem(AItem: TSettingsParam);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TSettingsParams.Add: TSettingsParam;
begin
  Result := TSettingsParam.Create(Self);
end;

{ TSettingsParam }

constructor TSettingsParam.Create(AOwner: TSettingsParams);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TSettingsParam.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TSettingsParam.SetOwner(AOwner: TSettingsParams);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

end.

