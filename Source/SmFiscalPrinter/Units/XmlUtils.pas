unit XmlUtils;

interface

uses
  // VCL
  SysUtils,
  // This
  MSXML, XMLDOC, XMLIntf;

procedure SetNodeStr(Node: IXmlNode; const NodeName, NodeText: WideString);
procedure SetNodeInt(Node: IXmlNode; const NodeName: WideString; NodeValue: Integer);
procedure SetNodeBool(Node: IXmlNode; const NodeName: WideString; NodeValue: Boolean);
function GetNodeStr(Node: IXmlNode; const NodeName: WideString): WideString;
function GetNodeInt(Node: IXmlNode; const NodeName: WideString): Integer;
function GetNodeBool(Node: IXmlNode; const NodeName: WideString): Boolean;

implementation

const
  BoolToStr: array [Boolean] of WideString = ('0', '1');

procedure SetNodeStr(Node: IXmlNode; const NodeName, NodeText: WideString);
begin
  Node.AddChild(NodeName).Text := NodeText;
end;

procedure SetNodeInt(Node: IXmlNode; const NodeName: WideString; NodeValue: Integer);
begin
  Node.AddChild(NodeName).Text := IntToStr(NodeValue);
end;

procedure SetNodeBool(Node: IXmlNode; const NodeName: WideString; NodeValue: Boolean);
begin
  Node.AddChild(NodeName).Text := BoolToStr[NodeValue];
end;

function GetNodeStr(Node: IXmlNode; const NodeName: WideString): WideString;
begin
  Result := Node.ChildNodes.Nodes[NodeName].Text;
end;

function GetNodeInt(Node: IXmlNode; const NodeName: WideString): Integer;
begin
  Result := StrToIntDef(Node.ChildNodes.Nodes[NodeName].Text, 0);
end;

function GetNodeBool(Node: IXmlNode; const NodeName: WideString): Boolean;
begin
  Result := GetNodeStr(Node, NodeName) = '1';
end;

end.
