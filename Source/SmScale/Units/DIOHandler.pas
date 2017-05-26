unit DIOHandler;

interface

Uses
  // VCL
  Classes, SysUtils;

type
  TDIOHandler = class;

  { TDIOHandlers }

  TDIOHandlers = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TDIOHandler;
    procedure InsertItem(AItem: TDIOHandler);
    procedure RemoveItem(AItem: TDIOHandler);
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Clear;
    function ItemByCommand(Command: Integer): TDIOHandler;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDIOHandler read GetItem; default;
  end;

  { TDIOHandler }

  TDIOHandler = class
  private
    FOwner: TDIOHandlers;
    procedure SetOwner(AOwner: TDIOHandlers);
  public
    constructor Create(AOwner: TDIOHandlers); virtual;
    destructor Destroy; override;
    function GetCommand: Integer; virtual; abstract;
    procedure DirectIO(var pData: Integer; var pString: WideString); virtual; abstract;

    property Command: Integer read GetCommand;
  end;

implementation

{ TDIOHandlers }

constructor TDIOHandlers.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TDIOHandlers.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TDIOHandlers.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TDIOHandlers.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDIOHandlers.GetItem(Index: Integer): TDIOHandler;
begin
  Result := FList[Index];
end;

procedure TDIOHandlers.InsertItem(AItem: TDIOHandler);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TDIOHandlers.RemoveItem(AItem: TDIOHandler);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TDIOHandlers.ItemByCommand(Command: Integer): TDIOHandler;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Command = Command then Exit;
  end;
  raise Exception.Create('Invalid DirectIO command code');
end;

{ TDIOHandler }

constructor TDIOHandler.Create(AOwner: TDIOHandlers);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TDIOHandler.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TDIOHandler.SetOwner(AOwner: TDIOHandlers);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

end.
