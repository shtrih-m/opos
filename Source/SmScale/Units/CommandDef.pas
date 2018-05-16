unit CommandDef;

interface

Uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  XmlParser, CommandParam, LogFile, WException, gnugettext;

type
  TCommandDef = class;

  { TCommandDefs }

  TCommandDefs = class
  private
    FList: TList;
    FLogger: ILogFile;

    function GetCount: Integer;
    function GetItem(Index: Integer): TCommandDef;
    procedure InsertItem(AItem: TCommandDef);
    procedure RemoveItem(AItem: TCommandDef);
    procedure DoSaveToFile(const FileName: string);
    procedure DoLoadFromFile(const FileName: string);
  public
    constructor Create(ALogger: ILogFile);
    destructor Destroy; override;

    procedure Clear;
    function Add: TCommandDef; overload;
    procedure SaveToFile(const FileName: string); virtual;
    procedure LoadFromFile(const FileName: string); virtual;
    function ItemByCode(Code: Integer): TCommandDef;
    function Add(Code: Integer; const Name: string): TCommandDef; overload;
    function AddParam(Params: TCommandParams; const ParamName: string;
      ParamSize: Integer; ParamType: Integer): TCommandParam;

    property Logger: ILogFile read FLogger;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TCommandDef read GetItem; default;
  end;

  { TCommandDef }

  TCommandDef = class
  private
    FCode: Integer;
    FText: string;
    FName: string;
    FOwner: TCommandDefs;
    FInParams: TCommandParams;
    FOutParams: TCommandParams;

    procedure SetOwner(AOwner: TCommandDefs);
    procedure LoadParam(Param: TCommandParam; Root: TXmlItem);
    procedure LoadParams(Params: TCommandParams; Root: TXmlItem);
    procedure SaveParams(Params: TCommandParams; Root: TXmlItem);
    procedure SaveParam(Param: TCommandParam; Root: TXmlItem);
  public
    constructor Create(AOwner: TCommandDefs);
    destructor Destroy; override;

    procedure SaveToXml(Root: TXmlItem);
    procedure LoadFromXml(Root: TXmlItem);
    property InParams: TCommandParams read FInParams;
    property OutParams: TCommandParams read FOutParams;

    property Text: string read FText write FText;
    property Name: string read FName write FName;
    property Code: Integer read FCode write FCode;
  end;

implementation

{ TCommandDefs }

constructor TCommandDefs.Create(ALogger: ILogFile);
begin
  inherited Create;
  FList := TList.Create;
  FLogger := ALogger;
end;

destructor TCommandDefs.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TCommandDefs.Clear;
begin
  while Count > 0 do Items[0].Free;
end;

function TCommandDefs.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TCommandDefs.GetItem(Index: Integer): TCommandDef;
begin
  Result := FList[Index];
end;

procedure TCommandDefs.InsertItem(AItem: TCommandDef);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TCommandDefs.RemoveItem(AItem: TCommandDef);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TCommandDefs.Add: TCommandDef;
begin
  Result := TCommandDef.Create(Self);
end;

function TCommandDefs.Add(Code: Integer; const Name: string): TCommandDef;
begin
  Result := Add;
  Result.Code := Code;
  Result.Name := Name;
end;

function TCommandDefs.AddParam(Params: TCommandParams; const ParamName: string;
  ParamSize: Integer; ParamType: Integer): TCommandParam;
begin
  Result := Params.Add;
  Result.Name := ParamName;
  Result.Size := ParamSize;
  Result.ParamType := ParamType;
end;

function TCommandDefs.ItemByCode(Code: Integer): TCommandDef;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.Code = Code then Exit;
  end;
  raiseException(_('Неверный код команды'));
end;

procedure TCommandDefs.DoLoadFromFile(const FileName: string);
var
  i: Integer;
  Parser: TXmlParser;
  Item: TXmlItem;
  CommandsItem: TXmlItem;
begin
  if not FileExists(FileName) then Exit;
  Parser := TXmlParser.Create;
  try
    Parser.LoadFromFile(FileName);
    CommandsItem := Parser.Root.FindItem('Commands');
    if CommandsItem <> nil then
    begin
      Clear;
      for i := 0 to CommandsItem.Count-1 do
      begin
        Item := CommandsItem[i];
        if Item.NameIsEqual('Command')  then
        begin
          Add.LoadFromXml(Item);
        end;
      end;
    end;
  finally
    Parser.Free;
  end;
end;

procedure TCommandDefs.DoSaveToFile(const FileName: string);
var
  i: Integer;
  Item: TXmlItem;
  Parser: TXmlParser;
  CommandsItem: TXmlItem;
begin
  Parser := TXmlParser.Create;
  try
    CommandsItem := Parser.Root.Add('Commands');
    for i := 0 to Count-1 do
    begin
      Item := CommandsItem.Add('Command');
      Items[i].SaveToXml(Item);
    end;
    Parser.SaveToFile(FileName);
  finally
    Parser.Free;
  end;
end;

procedure TCommandDefs.SaveToFile(const FileName: string);
begin
  try
    DoSaveToFile(FileName);
  except
    on E: Exception do
      Logger.Error('TCommandDefs.SaveToFile: ', E);
  end;
end;

procedure TCommandDefs.LoadFromFile(const FileName: string);
begin
  try
    DoLoadFromFile(FileName);
  except
    on E: Exception do
    begin
      Logger.Error('TCommandDefs.LoadFromFile: ', E);
    end;
  end;
end;

{ TCommandDef }

constructor TCommandDef.Create(AOwner: TCommandDefs);
begin
  inherited Create;
  SetOwner(AOwner);
  FInParams := TCommandParams.Create;
  FOutParams := TCommandParams.Create;
end;

destructor TCommandDef.Destroy;
begin
  FInParams.Free;
  FOutParams.Free;
  SetOwner(nil);
  inherited Destroy;
end;

procedure TCommandDef.SetOwner(AOwner: TCommandDefs);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TCommandDef.LoadParam(Param: TCommandParam; Root: TXmlItem);
begin
  Param.Text := Root.GetText('Text');
  Param.Name := Root.GetText('Name');
  Param.Size := Root.GetInt('Size');
  Param.ParamType := Root.GetInt('Type');
  Param.MinValue := Root.GetIntDef('MinValue', 0);
  Param.MaxValue := Root.GetIntDef('MaxValue', 0);
end;

procedure TCommandDef.SaveParam(Param: TCommandParam; Root: TXmlItem);
begin
  Root.AddText('Text', Param.Text);
  Root.AddText('Name', Param.Name);
  Root.AddInt('Size', Param.Size);
  Root.AddInt('Type', Param.ParamType);
  Root.AddInt('MinValue', Param.MinValue);
  Root.AddInt('MaxValue', Param.MaxValue);
end;

procedure TCommandDef.LoadParams(Params: TCommandParams; Root: TXmlItem);
var
  i: Integer;
  Node: TXmlItem;
begin
  Params.Clear;
  if Root = nil then Exit;

  for i := 0 to Root.Count-1 do
  begin
    Node := Root[i];
    if Node.NameIsEqual('Param')  then
    begin
      LoadParam(Params.Add, Node);
    end;
  end;
end;

procedure TCommandDef.SaveParams(Params: TCommandParams; Root: TXmlItem);
var
  i: Integer;
begin
  if Root = nil then Exit;
  for i := 0 to Params.Count-1 do
    SaveParam(Params[i], Root.Add('Param'));
end;

procedure TCommandDef.LoadFromXml(Root: TXmlItem);
begin
  FCode := Root.GetInt('Code');
  FText := Root.GetText('Text');
  FName := Root.GetText('Name');

  LoadParams(InParams, Root.FindItem('InParams'));
  LoadParams(OutParams, Root.FindItem('OutParams'));
end;

procedure TCommandDef.SaveToXml(Root: TXmlItem);
begin
  Root.AddInt('Code', Code);
  Root.AddText('Text', Text);
  Root.AddText('Name', Name);

  SaveParams(InParams, Root.Add('InParams'));
  SaveParams(OutParams, Root.Add('OutParams'));
end;

end.
