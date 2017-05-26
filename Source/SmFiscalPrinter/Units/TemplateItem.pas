unit TemplateItem;

interface

Uses
  // VCL
  Classes,
  // This
  ReceiptItem;

///////////////////////////////////////////////////////////////////////////////
//
// %51lTITLE%;%8lPRICE% %6lDISCOUNT%  %8lSUM%       %3QUAN%    %=$10TOTAL_TAX%
//
///////////////////////////////////////////////////////////////////////////////

type
  TTemplateItem = class;

  { TTemplateItems }

  TTemplateItems = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TTemplateItem;
    procedure Clear;
    procedure InsertItem(AItem: TTemplateItem);
    procedure RemoveItem(AItem: TTemplateItem);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const S: string);
    function GetText(const Item: TFSSaleItem): string;
    function GetNextTag(var S, Tag: string): Boolean;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TTemplateItem read GetItem; default;
  end;

  { TTemplateItem }

  TTemplateItem = class
  private
    FOwner: TTemplateItems;
    procedure SetOwner(AOwner: TTemplateItems);
  public
    constructor Create(AOwner: TTemplateItems);
    destructor Destroy; override;

    function GetText(const Item: TFSSaleItem): string;
  end;

implementation

{ TTemplateItems }

constructor TTemplateItems.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TTemplateItems.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TTemplateItems.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TTemplateItems.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TTemplateItems.GetItem(Index: Integer): TTemplateItem;
begin
  Result := FList[Index];
end;

procedure TTemplateItems.InsertItem(AItem: TTemplateItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TTemplateItems.RemoveItem(AItem: TTemplateItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

// %51lTITLE%;%8lPRICE% %6lDISCOUNT%  %8lSUM%       %3QUAN%    %=$10TOTAL_TAX%
function TTemplateItems.GetNextTag(var S: string; var Tag: string): Boolean;
var
  P: Integer;
begin
  if Length(S) = 0 then
  begin
    Result := False;
    Exit;
  end;
  repeat
    P := Pos('%', S);
    if P = 1 then
    begin
      S := Copy(S, 2, Length(S));
    end;
  until P <> 1;

  if P = 0 then
  begin
    Tag := S;
    Result := True;
    Exit;
  end;

  Tag := Copy(S, 1, P-1);
  S := Copy(S, P+1, Length(S));
  Result := True;
end;

procedure TTemplateItems.Parse(const S: string);
(*
var
  Tag: string;
  Line: string;
  //TagData: TTagData;
*)  
begin
(*
  Clear;
  Line := S;
  while GetNextTag(Line, Tag) do
  begin
    if ParseTag(Tag, TagData) then
    begin
      Add(TagData);
    end;
  end;
*)  
end;

function TTemplateItems.GetText(const Item: TFSSaleItem): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count-1 do
  begin
    Result := Result + Items[i].GetText(Item);
  end;
end;

{ TTemplateItem }

constructor TTemplateItem.Create(AOwner: TTemplateItems);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TTemplateItem.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TTemplateItem.SetOwner(AOwner: TTemplateItems);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

function TTemplateItem.GetText(const Item: TFSSaleItem): string;
begin

end;


end.
