unit PrinterParametersXml;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // 3'd
  OmniXml, OmniXmlPersistent,
  // This
  PrinterParameters, FileUtils, LogFile;

type
  { TPrinterParametersXml }

  TPrinterParametersXml = class(TPersistent)
  private
    FItem: TPrinterParameters;
    function GetXmlFileName: string;
    procedure SaveToXml(const DeviceName: string);
    procedure LoadFromXml(const DeviceName: string);
  public
    constructor Create(AItem: TPrinterParameters);
    procedure Load(const DeviceName: string);
    procedure Save(const DeviceName: string);
  end;

function ReadEncoding(const DeviceName: string): Integer;
procedure LoadParameters(Item: TPrinterParameters; const DeviceName: string);
procedure SaveParameters(Item: TPrinterParameters; const DeviceName: string);

implementation

function ReadEncoding(const DeviceName: string): Integer;
var
  P: TPrinterParameters;
begin
  P := TPrinterParameters.Create;
  try
    LoadParameters(P, DeviceName);
    Result := P.Encoding;
  finally
    P.Free;
  end;
end;

procedure LoadParameters(Item: TPrinterParameters; const DeviceName: string);
var
  Reader: TPrinterParametersXml;
begin
  Reader := TPrinterParametersXml.Create(Item);
  try
    Reader.Load(DeviceName);
  finally
    Reader.Free;
  end;
end;

procedure SaveParameters(Item: TPrinterParameters; const DeviceName: string);
var
  Writer: TPrinterParametersXml;
begin
  Writer := TPrinterParametersXml.Create(Item);
  try
    Writer.Save(DeviceName);
  finally
    Writer.Free;
  end;
end;

function FindChildNode(Node: IXMLNode; const NodeName: string): IXMLNode;
var
  i: Integer;
begin
  if Node.HasChildNodes then
  begin
    for i := 0 to Node.ChildNodes.Length-1 do
    begin
      Result := Node.ChildNodes.Item[i];
      if Result.NodeName = NodeName then Exit;
    end;
  end;
  Result := nil;
end;

function FindChild(Node: IXMLNode; const NodeName: string): IXMLNode;
begin
  Result := FindChildNode(Node, NodeName);
  if Result = nil then
    raise Exception.CreateFmt('Node "%s" not found', [NodeName]);
end;

function GetChild(Document: IXMLDocument; Node: IXMLNode;
  const NodeName: string): IXMLNode;
begin
  Result := FindChildNode(Node, NodeName);
  if Result = nil then
  begin
    Result := Document.CreateElement(NodeName);
    Node.ChildNodes.AddNode(Result);
  end;
end;

{ TPrinterParametersXml }

constructor TPrinterParametersXml.Create(AItem: TPrinterParameters);
begin
  inherited Create;
  FItem := AItem;
end;

function TPrinterParametersXml.GetXmlFileName: string;
begin
  Result := ChangeFileExt(GetModuleFileName, '.xml');
end;

procedure TPrinterParametersXml.Load(const DeviceName: string);
begin
  try
    FItem.SetDefaults;
    LoadFromXml(DeviceName);
  except
    on E: Exception do
    begin
      Logger.Error('TPrinterParametersXml.Load', E);
    end;
  end;
end;

procedure TPrinterParametersXml.LoadFromXml(const DeviceName: string);
var
  Root: IXMLNode;
  Node: IXMLNode;
  Reader: TOmniXmlReader;
  Document: IXMLDocument;
begin
  Document := TXMLDocument.Create;
  Reader := TOmniXmlReader.Create(pfNodes);
  try
    Document.Load(GetXmlFileName);
    Root := FindChild(Document.DocumentElement, 'FiscalPrinter');
    Node := FindChild(Root, DeviceName);
    Reader.Read(Self, Node as IXMLElement);
  finally
    Reader.Free;
  end;
end;

procedure TPrinterParametersXml.Save(const DeviceName: string);
begin
  try
    SaveToXml(DeviceName);
  except
    on E: Exception do
      Logger.Error('TPrinterParametersXml.Save', E);
  end;
end;

procedure TPrinterParametersXml.SaveToXml(const DeviceName: string);
var
  Root: IXMLNode;
  Node: IXMLNode;
  FileName: string;
  Writer: TOmniXmlWriter;
  Document: IXMLDocument;
begin
  Document := TXMLDocument.Create;
  Writer := TOmniXmlWriter.Create(Document);
  try
    FileName := GetXmlFileName;
    if FileExists(FileName) then
      Document.Load(FileName);

    if Document.DocumentElement = nil
    Document.CreateElement('')
    Root := GetChild(Document, Document.DocumentElement, 'FiscalPrinter');
    Node := GetChild(Document, Root, DeviceName);

    Writer.Write(Self, Node as IXmlElement);
    Document.Save(FileName);
  finally
    Writer.Free;
  end;
end;

end.
