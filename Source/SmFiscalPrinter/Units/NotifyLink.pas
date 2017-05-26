unit NotifyLink;

interface

Uses
  // VCL
  Classes;

type
  TNotifyLink = class;

  { TNotifyLinks }

  TNotifyLinks = class
  private
    FList: TThreadList;
    procedure Clear;
    procedure InsertItem(AItem: TNotifyLink);
    procedure RemoveItem(AItem: TNotifyLink);
  public
    constructor Create;
    destructor Destroy; override;

    procedure DoNotify;
    procedure Add(Item: TNotifyLink);
    procedure Remove(Item: TNotifyLink);
  end;

  { TNotifyLink }

  TNotifyLink = class
  private
    FOwner: TNotifyLinks;
    FOnChange: TNotifyEvent;
    procedure SetOwner(AOwner: TNotifyLinks);
  public
    destructor Destroy; override;
    procedure DoNotify;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TNotifyLinks }

constructor TNotifyLinks.Create;
begin
  inherited Create;
  FList := TThreadList.Create;
end;

destructor TNotifyLinks.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TNotifyLinks.Clear;
var
  i: Integer;
  List: TList;
begin
  List := FList.LockList;
  try
    for i := List.Count-1 downto 0 do
      TNotifyLink(List[i]).SetOwner(nil);
  finally
    FList.UnlockList;
  end;
end;

procedure TNotifyLinks.InsertItem(AItem: TNotifyLink);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TNotifyLinks.RemoveItem(AItem: TNotifyLink);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

procedure TNotifyLinks.Add(Item: TNotifyLink);
begin
  Item.SetOwner(Self);
end;

procedure TNotifyLinks.Remove(Item: TNotifyLink);
begin
  Item.SetOwner(nil);
end;

procedure TNotifyLinks.DoNotify;
var
  i: Integer;
  List: TList;
begin
  List := FList.LockList;
  try
    for i := 0 to List.Count-1 do
      TNotifyLink(List[i]).DoNotify;
  finally
    FList.UnlockList;
  end;
end;

{ TNotifyLink }

destructor TNotifyLink.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TNotifyLink.SetOwner(AOwner: TNotifyLinks);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TNotifyLink.DoNotify;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;


end.
