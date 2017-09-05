unit TableParameter;

interface

Uses
  // VCL
  Classes, SysUtils, 
  // This
  ParameterValue, DriverTypes;

type
  TTableParameter = class;

  { TTableParameters }

  TTableParameters = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TTableParameter;
    procedure InsertItem(AItem: TTableParameter);
    procedure RemoveItem(AItem: TTableParameter);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure CheckID(ID: Integer);
    function ItemByID(ParamID: Integer): TTableParameter;
    function Add(const AData: TTableParameterRec): TTableParameter;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTableParameter read GetItem; default;
  end;

  { TTableParameter }

  TTableParameter = class
  private
    FData: TTableParameterRec;
    FOwner: TTableParameters;
    FValues: TParameterValues;
    procedure SetOwner(AOwner: TTableParameters);
  public
    constructor Create(AOwner: TTableParameters; const AData: TTableParameterRec);
    destructor Destroy; override;
    function GetValue(ValueID: Integer): Integer;
    function AddValue(ID, Value: Integer): TParameterValue;

    property ID: Integer read FData.ID;
    property Name: string read FData.Name;
    property Table: Integer read FData.Table;
    property Row: Integer read FData.Row;
    property Field: Integer read FData.Field;
    property Values: TParameterValues read FValues;
    property Data: TTableParameterRec read FData;
  end;

implementation

{ TTableParameters }

constructor TTableParameters.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTableParameters.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTableParameters.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TTableParameters.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTableParameters.GetItem(Index: Integer): TTableParameter;
begin
  Result := FList[Index];
end;

procedure TTableParameters.InsertItem(AItem: TTableParameter);
begin
  //CheckID(AItem.ID);
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TTableParameters.RemoveItem(AItem: TTableParameter);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TTableParameters.ItemByID(ParamID: Integer): TTableParameter;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.ID = ParamID then Exit;
  end;
  Result := nil;
end;

function TTableParameters.Add(
  const AData: TTableParameterRec): TTableParameter;
begin
  Result := TTableParameter.Create(Self, AData);
end;

procedure TTableParameters.CheckID(ID: Integer);
resourcestring
  MsgNotUniqueItemID = 'Not unique item ID';
begin
  if ItemByID(ID) <> nil then
    raise Exception.Create(MsgNotUniqueItemID);
end;

{ TTableParameter }

constructor TTableParameter.Create(AOwner: TTableParameters;
  const AData: TTableParameterRec);
begin
  inherited Create;
  FValues := TParameterValues.Create;
  FData := AData;

  SetOwner(AOwner);
end;

destructor TTableParameter.Destroy;
begin
  FValues.Free;
  SetOwner(nil);
  inherited Destroy;
end;

procedure TTableParameter.SetOwner(AOwner: TTableParameters);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;  
end;

function TTableParameter.GetValue(ValueID: Integer): Integer;
var
  ParameterValue: TParameterValue;
resourcestring
  ParameterValueNotFound = 'Parameter value not found';
begin
  ParameterValue := Values.ItemByID(ValueID);
  if ParameterValue = nil then
    Raise Exception.Create(ParameterValueNotFound);
  Result := ParameterValue.Value;
end;

function TTableParameter.AddValue(ID, Value: Integer): TParameterValue;
begin
  Result := Values.AddValue(ID, Value);
end;

end.
