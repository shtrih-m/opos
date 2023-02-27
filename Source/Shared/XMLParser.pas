unit xmlParser;

interface

uses
  // VCL
  Classes, SysUtils, ActiveX, ComObj,
  // This
  XMLDoc, XMLIntf, MSXML, WException, gnugettext;

type
  TXmlItem = class;

  { TXmlParser }

  TXmlParser = class
  private
    FRoot: TXmlItem;
    FxmlDoc: IXMLDOMDocument;

    procedure UpdateItems;
    procedure CreateProcessingInstruction;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function GetXml: WideString;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure SetRootName(const Name: WideString);
    procedure SaveToFile(const FileName: WideString);
    procedure LoadFromFile(const FileName: WideString);
    procedure LoadFromString(const Data: WideString);
    procedure ConvertFile(const FileName: WideString);

    property Xml: WideString read GetXml;
    property Root: TXmlItem read FRoot;
    property xmlDoc: IXMLDOMDocument read FxmlDoc;
  end;

  { TXmlItemParams }

  TXmlItemParams = class
  private
    FxmlNode: IXMLDOMNode;
    function GetValue(const Name: WideString): WideString;
    procedure SetValue(const Name, Value: WideString);
    function GetCount: Integer;
  public
    constructor Create(AxmlNode: IXMLDOMNode);

    property Count: Integer read GetCount;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
  end;

  { TXmlItem }

  TXmlItem = class
  private
    FList: TList;
    FOwner: TXmlItem;
    FxmlNode: IXMLDOMNode;
    FParams: TXmlItemParams;

    procedure Clear;
    function GetName: WideString;
    function Get_Text: WideString;
    procedure CreateChildItems;
    function GetCount: Integer;
    function GetParams: TXmlItemParams;
    procedure SetOwner(AOwner: TXmlItem);
    procedure InsertItem(AItem: TXmlItem);
    procedure RemoveItem(AItem: TXmlItem);
    procedure SetText(const Value: WideString);
    function Get_Item(const Index: Integer): TXmlItem;
  public
    constructor Create(AOwner: TXmlItem; AxmlNode: IXMLDOMNode);
    destructor Destroy; override;

    function Add(const Name: WideString): TXmlItem;
    function New(const Name: WideString): TXmlItem;
    procedure AddText(const Name, Text: WideString);
    procedure AddParam(const Name, Text: WideString);
    function GetText(const Name: WideString): WideString;
    function GetInt(const Name: WideString): Integer;
    function GetBool(const Name: WideString): Boolean;
    function GetItem(const Name: WideString): TXmlItem;
    function FindItem(const Name: WideString): TXmlItem;
    function NameIsEqual(const AName: WideString): Boolean;
    procedure AddInt(const Name: WideString; Value: Integer);
    procedure AddBool(const Name: WideString; Value: Boolean);
    function GetIntDef(const Name: WideString; DefValue: Integer): Integer;

    property Name: WideString read GetName;
    property Count: Integer read GetCount;
    property Params: TXmlItemParams read GetParams;
    property Text: WideString read Get_Text write SetText;
    property Items[const Index: Integer]: TXmlItem read Get_Item; default;
  end;

procedure TextToFile(const Text, FileName: WideString);
procedure TextToXmlFile(const Text, FileName: WideString);

implementation

procedure TextToXmlFile(const Text, FileName: WideString);
var
  xml: TXmlParser;
begin
  xml := TXmlParser.Create;
  try
    xml.xmlDoc.LoadXml(Text);
    xml.SaveToFile(FileName);
  finally
    xml.Free;
  end;
end;

// Get readable XML

function GetXml(const Data: WideString): WideString;
begin
  Result := StringReplace(Data, '><', '>'#13#10'<', [rfReplaceAll, rfIgnoreCase]);
end;

// Save text to file

procedure TextToFile(const Text, FileName: WideString);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    if Length(Text) > 0 then
      Stream.Write(Text[1], Length(Text));
  finally
    Stream.Free;
  end;
end;

{ TXmlParser }

constructor TXmlParser.Create;
begin
  inherited Create;
  CoInitialize(nil);
  FxmlDoc := CoDOMDocument.Create;
  FxmlDoc.async := False;
  CreateProcessingInstruction;
  FxmlDoc.documentElement := FxmlDoc.createElement('root');
  FRoot := TXmlItem.Create(nil, xmlDoc.documentElement);
end;

destructor TXmlParser.Destroy;
begin
  FRoot.Free;
  FxmlDoc := nil;
  CoUninitialize();
  inherited Destroy;
end;

procedure TXmlParser.CreateProcessingInstruction;
var
  ProcessingInstruction: IXMLDOMProcessingInstruction;
begin
  ProcessingInstruction := xmlDoc.createProcessingInstruction('xml',
    'version=''1.0'' encoding=''UTF-8''');
  xmlDoc.appendChild(ProcessingInstruction);
end;

procedure TXmlParser.SetRootName(const Name: WideString);
begin
  FRoot.Free;
  FxmlDoc.documentElement := FxmlDoc.createElement(Name);
  FRoot := TXmlItem.Create(nil, xmlDoc.documentElement);
end;

procedure TXmlParser.UpdateItems;
begin
  FRoot.Free;
  FRoot := TXmlItem.Create(nil, xmlDoc.documentElement);
  FRoot.CreateChildItems;
end;

function TXmlParser.GetXml: WideString;
var
  Stream: TMemoryStream;
begin
  Result := '';
  Stream := TMemoryStream.Create;
  try
    SaveToStream(Stream);
    Stream.Position := 0;
    if Stream.Size > 0 then
    begin
      SetLength(Result, Stream.Size);
      Stream.Read(Result[1], Stream.Size);
    end;
  finally
    Stream.Free;
  end;
end;

procedure TXmlParser.SaveToStream(Stream: TStream);
var
  OleStream: IStream;
begin
  OleStream := TStreamAdapter.Create(stream);
  xmlDoc.Save(OleStream);
end;

procedure TXmlParser.ConvertFile(const FileName: WideString);
var
  Data: WideString;
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenReadWrite);
  try
    if Stream.Size = 0 then Exit;
    SetLength(Data, Stream.Size);
    Stream.Read(Data[1], Stream.Size);
    Data := StringReplace(Data, '><', '>'#13#10'<', [rfReplaceAll, rfIgnoreCase]);
    if Length(Data) > 0 then
    begin
      Stream.Position := 0;
      Stream.Write(Data[1], Length(Data));
    end;
  finally
    Stream.Free;
  end;
end;

procedure TXmlParser.SaveToFile(const FileName: WideString);
begin
  xmlDoc.save(FileName);
(*
  ConvertFile(FileName);
  xmlDoc.load(FileName);
  xmlDoc.save(FileName);
*)
end;

procedure TXmlParser.LoadFromFile(const FileName: WideString);
begin
  if not xmlDoc.Load(FileName) then
  begin
    raiseExceptionFmt('%s %s.', [_('File reading error'), FileName]);
  end;
  UpdateItems;
end;

procedure TXmlParser.Clear;
begin
  Root.Clear;
end;

procedure TXmlParser.LoadFromStream(Stream: TStream);
var
  OleStream: IStream;
begin
  OleStream := TStreamAdapter.Create(stream);
  if not xmlDoc.load(OleStream) then
  begin
    raise Exception.Create(_('Xml document reading error'));
  end;
  UpdateItems;
end;

procedure TXmlParser.LoadFromString(const Data: WideString);
var
  Stream: TMemoryStream;
begin
  if Length(Data) > 0 then
  begin
    Stream := TMemoryStream.Create;
    try
      Stream.Write(Data[1], Length(Data));
      Stream.Position := 0;
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
end;

{ TXmlItem }

procedure TXmlItem.Clear;
begin
  while Count > 0 do
    Items[0].Free;
end;

constructor TXmlItem.Create(AOwner: TXmlItem; AxmlNode: IXMLDOMNode);
begin
  inherited Create;
  FxmlNode := AxmlNode;
  FList := TList.Create;
  SetOwner(AOwner);

  if AxmlNode = nil then
    raise Exception.Create('AxmlNode = nil');
end;

destructor TXmlItem.Destroy;
begin
  SetOwner(nil);
  Clear;
  FList.Free;
  FxmlNode := nil;
  FParams.Free;
  inherited Destroy;
end;

procedure TXmlItem.SetOwner(AOwner: TXmlItem);
begin
  if AOwner <> FOwner then
  begin
    if FOwner <> nil then FOwner.RemoveItem(Self);
    if AOwner <> nil then AOwner.InsertItem(Self);
  end;
end;

procedure TXmlItem.InsertItem(AItem: TXmlItem);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TXmlItem.RemoveItem(AItem: TXmlItem);
begin
  AItem.FOwner := nil;
  FList.Remove(AItem);
end;

function TXmlItem.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TXmlItem.Get_Item(const Index: Integer): TXmlItem;
begin
  Result := TXmlItem(FList[Index]);
end;

procedure TXmlItem.CreateChildItems;
var
  i: Integer;
  Item: TXmlItem;
  childNodes: IXMLDOMNodeList;
begin
  Clear;
  childNodes := FxmlNode.childNodes;
  for i := 0 to childNodes.length-1 do
  begin
    Item := TXmlItem.Create(Self, childNodes.item[i]);
    Item.CreateChildItems;
  end;
end;

function TXmlItem.GetParams: TXmlItemParams;
begin
  if FParams = nil then
    FParams := TXmlItemParams.Create(FxmlNode);
  Result := FParams;
end;

function TXmlItem.New(const Name: WideString): TXmlItem;
var
  node: IXMLDOMElement;
begin
  node := FxmlNode.ownerDocument.createElement(Name);
  Result := TXmlItem.Create(Self, FxmlNode.appendChild(node));
end;

function TXmlItem.Add(const Name: WideString): TXmlItem;
var
  node: IXMLDOMElement;
begin
  node := FxmlNode.ownerDocument.createElement(Name);
  Result := TXmlItem.Create(Self, FxmlNode.appendChild(node));
end;

function TXmlItem.Get_Text: WideString;
begin
  Result := FxmlNode.text;
end;

procedure TXmlItem.SetText(const Value: WideString);
begin
  FxmlNode.text := Value;
end;

function TXmlItem.NameIsEqual(const AName: WideString): Boolean;
begin
  Result := AnsiCompareText(GetName, AName) = 0;
end;

function TXmlItem.FindItem(const Name: WideString): TXmlItem;
var
  i: Integer;
begin
  if NameIsEqual(Name) then
  begin
    Result := Self;
    Exit;
  end;

  for i := 0 to Count-1 do
  begin
    Result := Items[i];
    if Result.NameIsEqual(Name) then Exit;
  end;
  Result := nil;
end;

function TXmlItem.GetName: WideString;
begin
  Result := FxmlNode.nodeName;
end;

procedure TXmlItem.AddParam(const Name, Text: WideString);
begin
  Params.Values[Name] := Text;
end;

procedure TXmlItem.AddText(const Name, Text: WideString);
begin
  Add(Name).Text := Text;
end;

procedure TXmlItem.AddInt(const Name: WideString; Value: Integer);
begin
  AddText(Name, IntToStr(Value));
end;

procedure TXmlItem.AddBool(const Name: WideString; Value: Boolean);
const
  BoolToStr: array [Boolean] of WideString = ('0', '1');
begin
  AddText(Name, BoolToStr[Value]);
end;

function TXmlItem.GetItem(const Name: WideString): TXmlItem;
begin
  Result := FindItem(Name);
  if Result = nil then
    raiseExceptionFmt('%s, %s', [_('Element not found'), Name]);
end;

function TXmlItem.GetText(const Name: WideString): WideString;
begin
  Result := GetItem(Name).Text;
end;

function TXmlItem.GetInt(const Name: WideString): Integer;
var
  Text: WideString;
begin
  Text := GetText(Name);
  Text := StringReplace(Text, '0x', '$', []);
  Result := StrToInt(Text);
end;

function TXmlItem.GetIntDef(const Name: WideString; DefValue: Integer): Integer;
var
  Node: TXmlItem;
begin
  Result := DefValue;
  Node := FindItem(Name);
  if Node <> nil then
    Result := StrToIntDef(Node.Text, DefValue);
end;

function TXmlItem.GetBool(const Name: WideString): Boolean;
begin
  Result := GetText(Name) = '1';
end;

{ TXmlItemParams }

constructor TXmlItemParams.Create(AxmlNode: IXMLDOMNode);
begin
  inherited Create;
  FxmlNode := AxmlNode;
  if AxmlNode = nil then
    raise Exception.Create('AxmlNode = nil');
end;

function TXmlItemParams.GetCount: Integer;
begin
  Result := FxmlNode.attributes.length;
end;

function TXmlItemParams.GetValue(const Name: WideString): WideString;
var
  node: IXMLDOMNode;
begin
  Result := '';
  node := FxmlNode.attributes.getNamedItem(Name);
  if node <> nil then Result := node.text;
end;

(*

<Picture

BackgroundColor='00FFFFFF'
Text='Exit'
TextOrientation='0'
FontFixels='96'
FontCharset='204'
FontColor='80000008'
FontHeight='-12'
FontName='Times New Roman'
FontSize='9'
FontStyle='1'

/>


*)

procedure TXmlItemParams.SetValue(const Name, Value: WideString);
var
  node: IXMLDOMNode;
  newAtt: IXMLDOMAttribute;
begin
  node := FxmlNode.attributes.getNamedItem(Name);
  if node <> nil then
  begin
    node.text := Value
  end else
  begin
    newAtt := FxmlNode.ownerDocument.createAttribute(Name);
    FxmlNode.attributes.setNamedItem(newAtt);
    newAtt.text := Value;
  end;
end;

end.
