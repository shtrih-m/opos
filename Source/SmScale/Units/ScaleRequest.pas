unit ScaleRequest;

interface

Uses
  // VCL
  Classes;

type
  { TScaleRequests }

  TScaleRequests = class
  private
    FList: TThreadList;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function GetItem: TObject;
    procedure Add(Item: TObject);
  end;

implementation

{ TScaleRequests }

constructor TScaleRequests.Create;
begin
  inherited Create;
  FList := TThreadList.Create;
end;

destructor TScaleRequests.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TScaleRequests.Clear;
var
  Item: TObject;
begin
  repeat
    Item := GetItem;
    Item.Free;
  until Item = nil;
end;

function TScaleRequests.GetItem: TObject;
var
  List: TList;
begin
  Result := nil;
  List := FList.LockList;
  try
    if List.Count > 0 then
    begin
      Result := List[0];
      List.Delete(0);
    end;
  finally
    FList.UnlockList;
  end;
end;

procedure TScaleRequests.Add(Item: TObject);
begin
  FList.Add(Item);
end;

end.
