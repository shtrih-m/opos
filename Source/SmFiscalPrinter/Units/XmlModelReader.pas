unit XmlModelReader;

interface

uses
  // VCL
  Windows, Classes, SysUtils, PrinterModel, XMLDoc, XMLIntf, Variants,
  // This
  DriverTypes, LogFile, XmlUtils, DefaultModel, FileUtils, TableParameter,
  ParameterValue;

type
  { TXmlModelReader }

  TXmlModelReader = class
  private
    FLogger: TLogFile;
    FModels: TPrinterModels;

    procedure LoadModel(Node: IXMLNode);
    procedure SaveModel(Root: IXMLNode; Model: TPrinterModel);
    procedure LoadParameters(Root: IXmlNode; Parameters: TTableParameters);
    procedure LoadValues(Root: IXmlNode; Items: TParameterValues);
    procedure SaveParameters(Root: IXmlNode; Items: TTableParameters);
    procedure SaveValues(Root: IXmlNode; Items: TParameterValues);

    property Logger: TLogFile read FLogger;
    property Models: TPrinterModels read FModels;
  public
    constructor Create(AModels: TPrinterModels);

    procedure SetDefaults;
    procedure Save(const FileName: WideString);
    procedure Load(const FileName: WideString);
  end;

procedure LoadModels(AModels: TPrinterModels; const FileName: string; Logger: TLogFile);
procedure SaveModels(AModels: TPrinterModels; const FileName: string; Logger: TLogFile);

implementation

const
  NODENAME_ROOT = 'Root';
  NODENAME_MODEL = 'Model';
  NODENAME_MODELS = 'Models';
  NODENAME_PARAMETER_VALUE = 'ParameterValue';
  NODENAME_PARAMETER_VALUES = 'ParameterValues';
  NODENAME_TABLE_PARAMETER = 'TableParameter';
  NODENAME_TABLE_PARAMETERS = 'TableParameters';

function IsNameEqual(const S1, S2: WideString): Boolean;
begin
  Result := AnsiCompareText(S1, S2) = 0;
end;

procedure LoadModels(AModels: TPrinterModels; const FileName: string; Logger: TLogFile);
var
  Reader: TXmlModelReader;
begin
  Reader := TXmlModelReader.Create(AModels);
  try
    Reader.Load(FileName);
  except
    on E: Exception do
      Logger.Error('LoadModels', E);
  end;
  Reader.Free;
end;

procedure SaveModels(AModels: TPrinterModels; const FileName: string; Logger: TLogFile);
var
  Writer: TXmlModelReader;
begin
  Writer := TXmlModelReader.Create(AModels);
  try
    Writer.Save(FileName);
  except
    on E: Exception do
      Logger.Error('SaveModels', E);
  end;
  Writer.Free;
end;

{ TXmlModelReader }

constructor TXmlModelReader.Create(AModels: TPrinterModels);
begin
  inherited Create;
  FModels := AModels;
end;

procedure TXmlModelReader.Save(const FileName: WideString);
var
  i: Integer;
  Node: IXMLNode;
  ModelNode: IXMLNode;
  Document: IXMLDocument;
begin
  try
    if FileExists(FileName) then
      DeleteFile(FileName);

    Document := TXMLDocument.Create(nil);
    Document.Options := [doNodeAutoCreate, doAttrNull, doAutoPrefix, doNamespaceDecl];
    Document.Active := True;
    Document.Version := '1.0';
    Document.Encoding := 'Windows-1251';

    Node := Document.AddChild(NODENAME_ROOT);
    Node := Node.AddChild(NODENAME_MODELS);
    for i := 0 to Models.Count-1 do
    begin
      ModelNode := Node.AddChild(NODENAME_MODEL);
      SaveModel(ModelNode, Models[i]);
    end;
    WriteFileData(FileName, FormatXMLData(Document.XML.Text));
  except
    on E:Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TXmlModelReader.Load(const FileName: WideString);
var
  i: Integer;
  Node: IXMLNode;
  Xml: IXMLDocument;
  ModelNode: IXMLNode;
begin
  Models.Clear;
  try
    Xml := TXMLDocument.Create(nil);
    Xml.Active := True;
    Xml.LoadFromFile(FileName);
    Node := Xml.ChildNodes['Root'];
    Node := Node.ChildNodes[NODENAME_MODELS];
    for i := 0 to Node.ChildNodes.Count-1 do
    begin
      ModelNode := Node.ChildNodes.Nodes[i];
      if IsNameEqual(ModelNode.NodeName, NODENAME_MODEL) then
        LoadModel(ModelNode);
    end;
    if Models.Count = 0 then
      SetDefaults;
  except
    on E:Exception do
    begin
      Logger.Error(E.Message);
      SetDefaults;
    end;
  end;
end;

procedure TXmlModelReader.SetDefaults;
begin
  Models.Clear;
  AddDefaultModels(Models);
end;

procedure TXmlModelReader.LoadModel(Node: IXMLNode);
var
  Model: TPrinterModelRec;
  ParametersNode: IXmlNode;
  PrinterModel: TPrinterModel;
begin
  try
    Model.ID := GetNodeInt(Node, 'ID');
    Model.Name := GetNodeStr(Node, 'Name');
    Model.CapShortEcrStatus := GetNodeBool(Node, 'CapShortEcrStatus');
    Model.CapCoverSensor := GetNodeBool(Node, 'CapCoverSensor');
    Model.CapJrnPresent := GetNodeBool(Node, 'CapJrnPresent');
    Model.CapJrnEmptySensor := GetNodeBool(Node, 'CapJrnEmptySensor');
    Model.CapJrnNearEndSensor := GetNodeBool(Node, 'CapJrnNearEndSensor');
    Model.CapRecPresent := GetNodeBool(Node, 'CapRecPresent');
    Model.CapRecEmptySensor := GetNodeBool(Node, 'CapRecEmptySensor');
    Model.CapRecNearEndSensor := GetNodeBool(Node, 'CapRecNearEndSensor');
    Model.CapSlpFullSlip := GetNodeBool(Node, 'CapSlpFullSlip');
    Model.CapSlpEmptySensor := GetNodeBool(Node, 'CapSlpEmptySensor');
    Model.CapSlpFiscalDocument := GetNodeBool(Node, 'CapSlpFiscalDocument');
    Model.CapSlpNearEndSensor := GetNodeBool(Node, 'CapSlpNearEndSensor');
    Model.CapSlpPresent := GetNodeBool(Node, 'CapSlpPresent');
    Model.CapSetHeader := GetNodeBool(Node, 'CapSetHeader');
    Model.CapSetTrailer := GetNodeBool(Node, 'CapSetTrailer');
    Model.CapRecLever := GetNodeBool(Node, 'CapRecLever');
    Model.CapJrnLever := GetNodeBool(Node, 'CapJrnLever');
    Model.CapFixedTrailer := GetNodeBool(Node, 'CapFixedTrailer');
    Model.CapDisableTrailer := GetNodeBool(Node, 'CapDisableTrailer');
    Model.NumHeaderLines := GetNodeInt(Node, 'NumHeaderLines');
    Model.NumTrailerLines := GetNodeInt(Node, 'NumTrailerLines');
    Model.StartHeaderLine := GetNodeInt(Node, 'StartHeaderLine');
    Model.StartTrailerLine := GetNodeInt(Node, 'StartTrailerLine');
    Model.BaudRates := GetNodeStr(Node, 'BaudRates');
    Model.PrintWidth := GetNodeInt(Node, 'PrintWidth');
    Model.MaxGraphicsWidth := GetNodeInt(Node, 'MaxGraphicsWidth');
    Model.MaxGraphicsHeight := GetNodeInt(Node, 'MaxGraphicsHeight');
    Model.CapFullCut := GetNodeBool(Node, 'CapFullCut');
    Model.CapPartialCut := GetNodeBool(Node, 'CapPartialCut');
    Model.CombLineNumber := GetNodeInt(Node, 'CombLineNumber');
    Model.BarcodeSwapBytes := GetNodeBool(Node, 'BarcodeSwapBytes');
    Model.HeaderTableNumber := GetNodeInt(Node, 'HeaderTableNumber');
    Model.TrailerTableNumber := GetNodeInt(Node, 'TrailerTableNumber');
    Model.CapAttributes := GetNodeBool(Node, 'CapAttributes');
    Model.CapJournalReport := GetNodeBool(Node, 'CapJournalReport');
    Model.CapNonfiscalDocument := GetNodeBool(Node, 'CapNonfiscalDocument');

    PrinterModel := Models.Add(Model);
    ParametersNode := Node.ChildNodes.FindNode(NODENAME_TABLE_PARAMETERS);
    if ParametersNode <> nil then
      LoadParameters(ParametersNode, PrinterModel.Parameters);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TXmlModelReader.LoadParameters(Root: IXmlNode;
  Parameters: TTableParameters);
var
  i: Integer;
  Node: IXmlNode;
  ValuesNode: IXmlNode;
  Data: TTableParameterRec;
  Parameter: TTableParameter;
begin
  Parameters.Clear;
  for i := 0 to Root.ChildNodes.Count-1 do
  begin
    Node := Root.ChildNodes[i];
    if IsNameEqual(NODENAME_TABLE_PARAMETER, Node.NodeName) then
    begin
      Data.ID := GetNodeInt(Node, 'ID');
      Data.Name := GetNodeStr(Node, 'Name');
      Data.Table := GetNodeInt(Node, 'Table');
      Data.Row := GetNodeInt(Node, 'Row');
      Data.Field := GetNodeInt(Node, 'Field');
      Data.Size := GetNodeInt(Node, 'Size');
      Data.FieldType := GetNodeInt(Node, 'FieldType');
      Data.MinValue := GetNodeInt(Node, 'MinValue');
      Data.MaxValue := GetNodeInt(Node, 'MaxValue');
      Data.DefValue := GetNodeStr(Node, 'DefValue');
      Parameter := Parameters.Add(Data);
      ValuesNode := Node.ChildNodes.FindNode('ParameterValues');
      if ValuesNode <> nil then
        LoadValues(ValuesNode, Parameter.Values);
    end;
  end;
end;

procedure TXmlModelReader.LoadValues(Root: IXmlNode; Items: TParameterValues);
var
  i: Integer;
  Node: IXmlNode;
  Data: TParameterValueRec;
begin
  Items.Clear;
  for i := 0 to Root.ChildNodes.Count-1 do
  begin
    Node := Root.ChildNodes[i];
    if IsNameEqual(Node.NodeName, NODENAME_PARAMETER_VALUE) then
    begin
      Data.ID := GetNodeInt(Node, 'ID');
      Data.Value := GetNodeInt(Node, 'Value');
      Items.Add(Data);
    end;
  end;
end;

procedure TXmlModelReader.SaveModel(Root: IXMLNode; Model: TPrinterModel);
var
  Node: IXMLNode;
  Data: TPrinterModelRec;
begin
  Data := Model.Data;
  try
    SetNodeInt(Root, 'ID', Data.ID);
    SetNodeStr(Root, 'Name', Data.Name);
    SetNodeBool(Root, 'CapShortEcrStatus', Data.CapShortEcrStatus);
    SetNodeBool(Root, 'CapCoverSensor', Data.CapCoverSensor);
    SetNodeBool(Root, 'CapJrnPresent', Data.CapJrnPresent);
    SetNodeBool(Root, 'CapJrnEmptySensor', Data.CapJrnEmptySensor);
    SetNodeBool(Root, 'CapJrnNearEndSensor', Data.CapJrnNearEndSensor);
    SetNodeBool(Root, 'CapRecPresent', Data.CapRecPresent);
    SetNodeBool(Root, 'CapRecEmptySensor', Data.CapRecEmptySensor);
    SetNodeBool(Root, 'CapRecNearEndSensor', Data.CapRecNearEndSensor);
    SetNodeBool(Root, 'CapSlpFullSlip', Data.CapSlpFullSlip);
    SetNodeBool(Root, 'CapSlpEmptySensor', Data.CapSlpEmptySensor);
    SetNodeBool(Root, 'CapSlpFiscalDocument', Data.CapSlpFiscalDocument);
    SetNodeBool(Root, 'CapSlpNearEndSensor', Data.CapSlpNearEndSensor);
    SetNodeBool(Root, 'CapSlpPresent', Data.CapSlpPresent);
    SetNodeBool(Root, 'CapSetHeader', Data.CapSetHeader);
    SetNodeBool(Root, 'CapSetTrailer', Data.CapSetTrailer);
    SetNodeBool(Root, 'CapRecLever', Data.CapRecLever);
    SetNodeBool(Root, 'CapJrnLever', Data.CapJrnLever);
    SetNodeBool(Root, 'CapFixedTrailer', Data.CapFixedTrailer);
    SetNodeBool(Root, 'CapDisableTrailer', Data.CapDisableTrailer);
    SetNodeInt(Root, 'NumHeaderLines', Data.NumHeaderLines);
    SetNodeInt(Root, 'NumTrailerLines', Data.NumTrailerLines);
    SetNodeInt(Root, 'StartHeaderLine', Data.StartHeaderLine);
    SetNodeInt(Root, 'StartTrailerLine', Data.StartTrailerLine);
    SetNodeStr(Root, 'BaudRates', Data.BaudRates);
    SetNodeInt(Root, 'PrintWidth', Data.PrintWidth);
    SetNodeInt(Root, 'MaxGraphicsWidth', Data.MaxGraphicsWidth);
    SetNodeInt(Root, 'MaxGraphicsHeight', Data.MaxGraphicsHeight);
    SetNodeBool(Root, 'CapFullCut', Data.CapFullCut);
    SetNodeBool(Root, 'CapPartialCut', Data.CapPartialCut);
    SetNodeInt(Root, 'CombLineNumber', Data.CombLineNumber);
    SetNodeBool(Root, 'BarcodeSwapBytes', Data.BarcodeSwapBytes);
    SetNodeInt(Root, 'HeaderTableNumber', Data.HeaderTableNumber);
    SetNodeInt(Root, 'TrailerTableNumber', Data.TrailerTableNumber);
    SetNodeBool(Root, 'CapNonfiscalDocument', Data.CapNonfiscalDocument);
    SetNodeBool(Root, 'CapAttributes', Data.CapAttributes);
    SetNodeBool(Root, 'CapJournalReport', Data.CapJournalReport);

    Node := Root.AddChild(NODENAME_TABLE_PARAMETERS);
    SaveParameters(Node, Model.Parameters);
  except
    on E: Exception do
    begin
      Logger.Error(E.Message);
    end;
  end;
end;

procedure TXmlModelReader.SaveParameters(Root: IXmlNode; Items: TTableParameters);
var
  i: Integer;
  Node: IXmlNode;
  Item: TTableParameterRec;
begin
  for i := 0 to Items.Count-1 do
  begin
    Item := Items[i].Data;
    Node := Root.AddChild(NODENAME_TABLE_PARAMETER);

    SetNodeInt(Node, 'ID', Item.ID);
    SetNodeStr(Node, 'Name', Item.Name);
    SetNodeInt(Node, 'Table', Item.Table);
    SetNodeInt(Node, 'Row', Item.Row);
    SetNodeInt(Node, 'Field', Item.Field);
    SetNodeInt(Node, 'Size', Item.Size);
    SetNodeInt(Node, 'FieldType', Item.FieldType);
    SetNodeInt(Node, 'MinValue', Item.MinValue);
    SetNodeInt(Node, 'MaxValue', Item.MaxValue);
    SetNodeStr(Node, 'DefValue', Item.DefValue);

    SaveValues(Node.AddChild(NODENAME_PARAMETER_VALUES), Items[i].Values);
  end;
end;

procedure TXmlModelReader.SaveValues(Root: IXmlNode; Items: TParameterValues);
var
  i: Integer;
  Node: IXmlNode;
  Item: TParameterValue;
begin
  for i := 0 to Items.Count-1 do
  begin
    Item := Items[i];
    Node := Root.AddChild(NODENAME_PARAMETER_VALUE);

    SetNodeInt(Node, 'ID', Item.ID);
    SetNodeInt(Node, 'Value', Item.Value);
  end;
end;

end.

