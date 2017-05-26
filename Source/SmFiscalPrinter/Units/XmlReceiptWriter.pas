unit XmlReceiptWriter;

interface

uses
  // VCL
  SysUtils, XMLDoc, XMLIntf,
  // This
  XmlUtils, LogFile, FileUtils, PrinterTypes;

const
  /////////////////////////////////////////////////////////////////////////////
  // Receipt type

  XML_RT_CASH_IN                  =  1;
  XML_RT_CASH_OUT                 =  2;
  XML_RT_SALE                     =  3;
  XML_RT_BUY                      =  4;
  XML_RT_RETSALE                  =  5;
  XML_RT_RETBUY                   =  6;
  XML_RT_NONFISCAL                =  7;

type
  { TReceiptRec }

  TReceiptRec = record
    ID: Integer;
    DocID: Integer;
    RecType: Integer;
    State: Integer;
    Amount: Int64;
    Payments: array [0..3] of Int64;
    Date: TPrinterDate;
    Time: TPrinterTime;
  end;

  { TXmlReceiptWriter }

  TXmlReceiptWriter = class
  public
    class procedure AddReceipt(const R: TReceiptRec; const FileName: string); overload;
    class procedure AddReceipt(const R: TReceiptRec; Document: IXMLDocument); overload;
  end;

///////////////////////////////////////////////////////////////////////////////
(*

<root>
  <receipts>
    <receipt>
      <id>0123</id>
      <docid>0123</docid>
      <type>0</type>
      <state>0</state>
      <amount>2345</amount>
      <payments>
        <payment>
          <type>0</type>
          <amount>10</amount>
          <type>1</type>
          <amount>11</amount>
        </payment>
      </payments>
    </receipt>
  </receipts>
</root>

*)
///////////////////////////////////////////////////////////////////////////////

implementation

class procedure TXmlReceiptWriter.AddReceipt(const R: TReceiptRec;
  Document: IXMLDocument);
var
  i: Integer;
  Node: IXMLNode;
  Root: IXMLNode;
  Payments: Int64;
  PaymentNode: IXMLNode;
begin
  Root := Document.ChildNodes.FindNode('root');
  if Root = nil then
    Root := Document.AddChild('root');
  Node := Root.ChildNodes.FindNode('receipts');
  if Node = nil then
    Node := Root.AddChild('receipts');

  Node := Node.AddChild('receipt');
  SetNodeInt(Node, 'id', R.ID);
  SetNodeInt(Node, 'docid', R.DocID);
  SetNodeInt(Node, 'type', R.RecType);
  SetNodeInt(Node, 'state', R.State);
  SetNodeInt(Node, 'amount', R.Amount);
  SetNodeStr(Node, 'date', Format('%.2d.%.2d.%.4d %.2d:%.2d:%.2d', [
    R.Date.Day, R.Date.Month, R.Date.Year + 2000,
    R.Time.Hour, R.Time.Min, R.Time.Sec]));

  Payments := R.Payments[0] + R.Payments[1] + R.Payments[2] + R.Payments[3];
  if Payments <> 0 then
  begin
    Node := Node.AddChild('payments');
    for i := 0 to 3 do
    begin
      if R.Payments[i] <> 0 then
      begin
        PaymentNode := Node.AddChild('payment');
        SetNodeInt(PaymentNode, 'type', i);
        SetNodeInt(PaymentNode, 'amount', R.Payments[i]);
      end;
    end;
  end;
end;

class procedure TXmlReceiptWriter.AddReceipt(const R: TReceiptRec;
  const FileName: string);
var
  Document: IXMLDocument;
begin
  try
    Document := TXMLDocument.Create(nil);
    Document.Active := True;
    Document.Version := '1.0';
    Document.Encoding := 'Windows-1251';
    if FileExists(FileName) then
    begin
      Document.LoadFromFile(FileName);
    end;
    AddReceipt(R, Document);
    Document.SaveToFile(FileName);
    //WriteFileData(FileName, FormatXMLData(Document.XML.Text));
  except
    on E:Exception do
    begin
      //Logger.Error(E.Message);
    end;
  end;
end;

end.
