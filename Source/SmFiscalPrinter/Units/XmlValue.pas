unit XmlValue;

interface

Uses
  // VCL
  Classes, SysUtils,
  // This
  XmlParser;

type
  TXmlValue = class;

  { TXmlValues }

  TXmlValues = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TXmlValue;
    procedure InsertItem(AItem: TXmlValue);
    procedure RemoveItem(AItem: TXmlValue);
    function GetAsXml: string;
    procedure SetAsXml(const Xml: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure ClearValue;
    function Add: TXmlValue;
    function FindItem(const Name: string): TXmlValue;
    function ItemByName(const Name: string): TXmlValue;

    property Count: Integer read GetCount;
    property AsXml: string read GetAsXml write SetAsXml;
    property Items[Index: Integer]: TXmlValue read GetItem; default;
  end;

  { TXmlValue }

  TXmlValue = class
  private
    FName: string;
    FValue: string;
    FOwner: TXmlValues;
    procedure SetOwner(AOwner: TXmlValues);
  public
    constructor Create(AOwner: TXmlValues);
    destructor Destroy; override;

    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
  end;

implementation

{ TXmlValues }

constructor TXmlValues.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TXmlValues.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TXmlValues.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TXmlValues.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TXmlValues.GetItem(Index: Integer): TXmlValue;
begin
  Result := FList[Index];
end;

procedure TXmlValues.InsertItem(AItem: TXmlValue);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TXmlValues.RemoveItem(AItem: TXmlValue);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TXmlValues.Add: TXmlValue;
begin
  Result := TXmlValue.Create(Self);
end;

function TXmlValues.FindItem(const Name: string): TXmlValue;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if AnsiCompareText(Result.Name, Name) = 0 then Exit;
  end;
  Result := nil;
end;

function TXmlValues.ItemByName(const Name: string): TXmlValue;
begin
  Result := FindItem(Name);
  if Result = nil then
    raise Exception.Create('Parameter not found');
end;

function TXmlValues.GetAsXml: string;
var
  i: Integer;
  Node: TXmlItem;
  Parser: TXmlParser;
  Param: TXmlValue;
begin
  Parser := TXmlParser.Create;
  try
    Parser.SetRootName('Params');
    for i := 0 to Count-1 do
    begin
      Param := Items[i];
      Node := Parser.Root.Add('Param');
      Node.AddText('Name', Param.Name);
      Node.AddText('Value', Param.Value);
    end;
    Result := Parser.Xml;
  finally
    Parser.Free;
  end;
end;

procedure TXmlValues.SetAsXml(const Xml: string);
var
  i: Integer;
  Node: TXmlItem;
  Root: TXmlItem;
  Parser: TXmlParser;
  ParamName: string;
  ParamValue: string;
  Param: TXmlValue;
begin
  Parser := TXmlParser.Create;
  try
    Parser.LoadFromString(Xml);
    Root := Parser.Root.GetItem('Params');
    for i := 0 to Root.Count-1 do
    begin
      Node := Root[i];
      if Node.NameIsEqual('Param') then
      begin
        ParamName := Node.GetText('Name');
        ParamValue := Node.GetText('Value');

        Param := FindItem(ParamName);
        if Param = nil then
        begin
          Param := Add;
          Param.Name := ParamName;
        end;
        Param.Value := ParamValue;
      end;
    end;
  finally
    Parser.Free;
  end;
end;

procedure TXmlValues.ClearValue;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].Value := '';
end;

{ TXmlValue }

constructor TXmlValue.Create(AOwner: TXmlValues);
begin
  inherited Create;
  SetOwner(AOwner);
end;

destructor TXmlValue.Destroy;
begin
  SetOwner(nil);
  inherited Destroy;
end;

procedure TXmlValue.SetOwner(AOwner: TXmlValues);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

end.
