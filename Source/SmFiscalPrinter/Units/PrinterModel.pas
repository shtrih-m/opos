unit PrinterModel;

interface

Uses
  // VCL
  Classes, SysUtils,
  // This
  PrinterTypes, TableParameter, DriverTypes, PrinterTable, LogFile;

type
  TPrinterModel = class;

  { TPrinterModels }

  TPrinterModels = class
  private
    FList: TList;
    function GetCount: Integer;
    procedure InsertItem(AItem: TPrinterModel);
    function GetItem(Index: Integer): TPrinterModel;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure RemoveItem(AItem: TPrinterModel);
    procedure Insert(Index: Integer; AItem: TPrinterModel);
    function IndexById(AID: Integer): Integer;
    function ItemByID(AID: Integer): TPrinterModel;
    function Add(AData: TPrinterModelRec): TPrinterModel;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPrinterModel read GetItem; default;
  end;

  { TPrinterModel }

  TPrinterModel = class
  private
    FOwner: TPrinterModels;
    FData: TPrinterModelRec;
    FTables: TPrinterTables;
    FParameters: TTableParameters;

    procedure SetOwner(AOwner: TPrinterModels);
  public
    constructor Create(AOwner: TPrinterModels; AData: TPrinterModelRec);
    destructor Destroy; override;
    procedure Initialize; virtual;
    function AddParam(const P: TTableParameterRec): TTableParameter;
    function AddBoolParam(const P: TTableParameterRec): TTableParameter;

    property Data: TPrinterModelRec read FData;
    property Tables: TPrinterTables read FTables;
    property Parameters: TTableParameters read FParameters;
  end;

implementation

{ TPrinterModels }

constructor TPrinterModels.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPrinterModels.Destroy;
begin
  Clear;
  Flist.Free;
  inherited Destroy;
end;

procedure TPrinterModels.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TPrinterModels.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPrinterModels.GetItem(Index: Integer): TPrinterModel;
begin
  Result := FList[Index];
end;

procedure TPrinterModels.InsertItem(AItem: TPrinterModel);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPrinterModels.RemoveItem(AItem: TPrinterModel);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TPrinterModels.Add(AData: TPrinterModelRec): TPrinterModel;
begin
  Result := TPrinterModel.Create(Self, AData);
end;

function TPrinterModels.ItemByID(AID: Integer): TPrinterModel;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Data.ID = AID then Exit;
  end;
  Result := nil;
end;

function TPrinterModels.IndexById(AID: Integer): Integer;
var
  Model: TPrinterModel;
begin
  Result := -1;
  Model := ItemByID(AID);
  if Model <> nil then
    Result := FList.IndexOf(Model);
end;

procedure TPrinterModels.Insert(Index: Integer; AItem: TPrinterModel);
begin
  FList.Insert(Index, AItem);
  AItem.FOwner := Self;
end;

{ TPrinterModel }

constructor TPrinterModel.Create(AOwner: TPrinterModels; AData: TPrinterModelRec);
begin
  inherited Create;
  SetOwner(AOwner);
  FData := AData;
  FTables := TPrinterTables.Create;
  FParameters := TTableParameters.Create;
  Initialize;
end;

destructor TPrinterModel.Destroy;
begin
  SetOwner(nil);
  FTables.Free;
  FParameters.Free;
  inherited Destroy;
end;

procedure TPrinterModel.SetOwner(AOwner: TPrinterModels);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TPrinterModel.Initialize;
begin

end;

function TPrinterModel.AddBoolParam(
  const P: TTableParameterRec): TTableParameter;
begin
  Result := Parameters.Add(P);
end;

function TPrinterModel.AddParam(
  const P: TTableParameterRec): TTableParameter;
begin
  Result := Parameters.Add(P);
  Result.Values.AddValue(VALUEID_DISABLED, 0);
  Result.Values.AddValue(VALUEID_ENABLED, 1);
end;

end.

