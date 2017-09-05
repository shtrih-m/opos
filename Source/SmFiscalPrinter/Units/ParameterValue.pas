unit ParameterValue;

interface

Uses
  // VCL
  Classes, SysUtils,
  // This
  DriverTypes;

type
  TParameterValue = class;

  { TParameterValues }

  TParameterValues = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TParameterValue;
    procedure InsertItem(AItem: TParameterValue);
    procedure RemoveItem(AItem: TParameterValue);
    procedure CheckID(ID: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function ItemByID(ID: Integer): TParameterValue;
    function AddValue(ID, Value: Integer): TParameterValue;
    function Add(const AData: TParameterValueRec): TParameterValue;


    property Count: Integer read GetCount;
    property Items[Index: Integer]: TParameterValue read GetItem; default;
  end;

  { TParameterValue }

  TParameterValue = class
  private
    FData: TParameterValueRec;
    FOwner: TParameterValues;
    procedure SetOwner(AOwner: TParameterValues);
  public
    constructor Create(AOwner: TParameterValues; const AData: TParameterValueRec);
    destructor Destroy; override;

    property ID: Integer read FData.ID;
    property Value: Integer read FData.Value;
  end;

implementation

{ TParameterValues }

constructor TParameterValues.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TParameterValues.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TParameterValues.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TParameterValues.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TParameterValues.GetItem(Index: Integer): TParameterValue;
begin
  Result := FList[Index];
end;

procedure TParameterValues.InsertItem(AItem: TParameterValue);
begin
  CheckID(AItem.ID);
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TParameterValues.RemoveItem(AItem: TParameterValue);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TParameterValues.AddValue(ID, Value: Integer): TParameterValue;
var
  Data: TParameterValueRec;
begin
  Data.ID := ID;
  Data.Value := Value;
  Result := TParameterValue.Create(Self, Data);
end;

function TParameterValues.Add(
  const AData: TParameterValueRec): TParameterValue;
begin
  Result := TParameterValue.Create(Self, AData);
end;

function TParameterValues.ItemByID(ID: Integer): TParameterValue;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ID = ID then Exit;
  end;
  Result := nil;
end;

procedure TParameterValues.CheckID(ID: Integer);
resourcestring
  MsgNotUniqueItemID = 'Not unique item ID';
begin
  if ItemByID(ID) <> nil then
    raise Exception.Create(MsgNotUniqueItemID);
end;

{ TParameterValue }

constructor TParameterValue.Create(AOwner: TParameterValues;
  const AData: TParameterValueRec);
begin
  inherited Create;
  FData := AData;
  SetOwner(AOwner);
end;

destructor TParameterValue.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TParameterValue.SetOwner(AOwner: TParameterValues);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

end.
