unit ZReport;

interface

uses
  // VCL
  Windows, Classes, SysUtils, XMLDoc, XMLIntf,
  // Tnt
  TntClasses,
  // This
  PrinterTypes, FiscalPrinterTypes, FileUtils;

type
  TOperRegisters = array [0..255] of Word;
  TCashRegisters = array [0..265] of Int64;

  { TZReport }

  TZReport = class
  private
    FDevice: IFiscalPrinterDevice;

    FOperRegCount: Integer;
    FCashRegCount: Integer;
    FOperRegisters: TOperRegisters;
    FCashRegisters: TCashRegisters;
  public
    constructor Create(ADevice: IFiscalPrinterDevice);

    procedure Read;
    procedure Clear;
    procedure SaveToXml(const FileName: string);
    procedure SaveToCsv(const FileName: string);

    property OperRegCount: Integer read FOperRegCount;
    property CashRegCount: Integer read FCashRegCount;
    property OperRegisters: TOperRegisters read FOperRegisters;
    property CashRegisters: TCashRegisters read FCashRegisters;
    property Device: IFiscalPrinterDevice read FDevice;
  end;

implementation

{ TZReport }

constructor TZReport.Create(ADevice: IFiscalPrinterDevice);
begin
  inherited Create;
  FDevice := ADevice;
end;

procedure TZReport.Clear;
var
  i: Integer;
begin
  FOperRegCount := 0;
  FCashRegCount := 0;
  for i := 0 to 255 do
  begin
    FOperRegisters[i] := 0;
    FCashRegisters[i] := 0;
  end;
end;

function GetTotalsAmount(Totals: TFMTotals): Int64;
begin
  Result := Totals.SaleTotal - Totals.RetSale + Totals.RetBuy - Totals.BuyTotal;
end;

procedure TZReport.Read;
var
  i: Integer;
  CashReg: TCashRegisterRec;
  OperReg: TOperRegisterRec;
  Totals1: TFMTotals;
  Totals2: TFMTotals;
begin
  Clear;
  for i := 0 to 255 do
  begin
    if FDevice.ReadCashReg(i, CashReg) <> 0 then Break;
    FCashRegCount := i+1;
    FCashRegisters[i] := CashReg.Value;
  end;
  for i := 0 to 255 do
  begin
    if FDevice.ReadOperatingReg(i, OperReg) <> 0 then Break;
    FOperRegCount := i+1;
    FOperRegisters[i] := OperReg.Value;
  end;

  Totals1 := Device.ReadFPTotals(0);
  Totals2 := Device.ReadDayTotals;
  FCashRegisters[256] := GetTotalsAmount(Totals1);
  FCashRegisters[257] := FCashRegisters[256] + GetTotalsAmount(Totals2);
  FCashRegisters[258] := Totals1.SaleTotal;
  FCashRegisters[259] := Totals1.BuyTotal;
  FCashRegisters[260] := Totals1.RetSale;
  FCashRegisters[261] := Totals1.RetBuy;
  FCashRegisters[262] := Totals1.SaleTotal + Totals2.SaleTotal;
  FCashRegisters[263] := Totals1.BuyTotal + Totals2.BuyTotal;
  FCashRegisters[264] := Totals1.RetSale + Totals2.RetSale;
  FCashRegisters[265] := Totals1.RetBuy + Totals2.RetBuy;
  FCashRegCount := 266;
end;

procedure TZReport.SaveToCsv(const FileName: string);
var
  i: Integer;
  Line: string;
  Lines: TStrings;
begin
  if FileExists(FileName) then
    DeleteFile(FileName);

  Lines := TStringList.Create;
  try
    for i := 0 to CashRegCount-1 do
    begin
      Line := Format('0;%d;%d;%s', [
        i, FCashRegisters[i], GetCashRegisterName(i)]);
      Lines.Add(Line);
    end;

    for i := 0 to OperRegCount-1 do
    begin
      Line := Format('1;%d;%d;%s', [
        i, FOperRegisters[i], GetOperRegisterName(i)]);
      Lines.Add(Line);
    end;
    Lines.SaveToFile(FileName);
  finally
    Lines.Free;
  end;
end;

procedure TZReport.SaveToXml(const FileName: string);
var
  i: Integer;
  Node: IXMLNode;
  RootNode: IXMLNode;
  Document: IXMLDocument;
  RegistersNode: IXMLNode;
begin
  if FileExists(FileName) then
    DeleteFile(FileName);

  Document := TXMLDocument.Create(nil);
  Document.Options := [doNodeAutoCreate, doAttrNull, doAutoPrefix, doNamespaceDecl];
  Document.Active := True;
  Document.Version := '1.0';
  Document.Encoding := 'Windows-1251';
  RootNode := Document.AddChild('ZReport');
  RegistersNode := RootNode.AddChild('CashRegisters');
  for i := 0 to CashRegCount-1 do
  begin
    Node := RegistersNode.AddChild('CashRegister');
    Node.Attributes['Number'] := i;
    Node.Attributes['Value'] := CashRegisters[i];
    //Node.Attributes['Name'] := GetCashRegisterName(i);
  end;
  RegistersNode := RootNode.AddChild('OperationRegisters');
  for i := 0 to OperRegCount-1 do
  begin
    Node := RegistersNode.AddChild('OperationRegister');
    Node.Attributes['Number'] := i;
    Node.Attributes['Value'] := OperRegisters[i];
    //Node.Attributes['Name'] := GetCashRegisterName(i);
  end;
  WriteFileData(FileName, FormatXMLData(Document.XML.Text));
end;

end.
