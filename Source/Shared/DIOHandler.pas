unit DIOHandler;

interface

Uses
  // VCL
  Classes, SysUtils,
  // THis
  DriverContext, LogFile;

type
  TDIOHandler = class;

  { TDIOHandlers }

  TDIOHandlers = class
  private
    FList: TList;
    FContext: TDriverContext;

    function GetCount: Integer;
    function GetItem(Index: Integer): TDIOHandler;
    procedure InsertItem(AItem: TDIOHandler);
    procedure RemoveItem(AItem: TDIOHandler);
  public
    constructor Create(AContext: TDriverContext);
    destructor Destroy; override;

    procedure Clear;
    function ItemByCommand(Command: Integer): TDIOHandler;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TDIOHandler read GetItem; default;
    property Context: TDriverContext read FContext;
  end;

  { TDIOHandler }

  TDIOHandler = class
  private
    FCommand: Integer;
    FOwner: TDIOHandlers;

    function GetLogger: ILogFile;
    procedure SetOwner(AOwner: TDIOHandlers);
    function GetContext: TDriverContext;
  public
    constructor Create(AOwner: TDIOHandlers; ACommand: Integer); virtual;
    destructor Destroy; override;
    function GetCommand: Integer; virtual;
    procedure DirectIO(var pData: Integer; var pString: WideString); virtual; abstract;

    property Logger: ILogFile read GetLogger;
    property Command: Integer read FCommand;
    property Context: TDriverContext read GetContext;
  end;

implementation

resourcestring
  MsgInvalidDirectIOCommandCode = 'Invalid DirectIO command code';

{ TDIOHandlers }

constructor TDIOHandlers.Create(AContext: TDriverContext);
begin
  inherited Create;
  FList := TList.Create;
  FContext := AContext;
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
  raise Exception.Create(MsgInvalidDirectIOCommandCode);
end;

{ TDIOHandler }

constructor TDIOHandler.Create(AOwner: TDIOHandlers; ACommand: Integer);
begin
  inherited Create;
  SetOwner(AOwner);
  FCommand := ACommand;
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

function TDIOHandler.GetCommand: Integer;
begin
  Result := 0;
end;

function TDIOHandler.GetContext: TDriverContext;
begin
  Result := FOwner.Context;
end;

function TDIOHandler.GetLogger: ILogFile;
begin
  Result := Context.Logger;
end;

end.
