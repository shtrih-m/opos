unit duXmlReceiptWriter;

interface

uses
  // VCL
  Windows, SysUtils, Classes, XMLDoc, XMLIntf,
  // DUnit
  TestFramework,
  // This
  XmlReceiptWriter, FileUtils;

type
  { TXmlReceiptWriterTest }

  TXmlReceiptWriterTest = class(TTestCase)
  public
    procedure CheckAddTime; { !!! }
    procedure CreateReceiptFile;
  published
    procedure CheckWrite;
  end;

implementation

{ TXmlReceiptWriterTest }

procedure TXmlReceiptWriterTest.CreateReceiptFile;
var
  i: Integer;
  R: TReceiptRec;
  FileName: WideString;
  Document: IXMLDocument;
begin
  FileName := GetModulePath + 'XmlReceipt3.xml';
  DeleteFile(FileName);

  R.ID := 123;
  R.DocID := 234;
  R.RecType := 345;
  R.State := 456;
  R.Amount := 567;
  R.Payments[0] := 789;
  R.Payments[1] := 890;
  R.Payments[2] := 901;
  R.Payments[3] := 012;

  Document := TXMLDocument.Create(nil);
  Document.Active := True;
  Document.Version := '1.0';
  Document.Encoding := 'Windows-1251';
  for i := 1 to 3000 do
  begin
    TXmlReceiptWriter.AddReceipt(R, Document);
  end;
  Document.SaveToFile(FileName);
end;

procedure TXmlReceiptWriterTest.CheckAddTime;
var
  R: TReceiptRec;
  FileName: WideString;
  TickCount: Integer;
begin
  TickCount := GetTickCount;
  R.DocID := 234;
  R.RecType := 345;
  R.State := 456;
  R.Amount := 567;
  R.Payments[0] := 789;
  R.Payments[1] := 890;
  R.Payments[2] := 901;
  R.Payments[3] := 012;
  R.Date.Day := 3;
  R.Date.Month := 6;
  R.Date.Year := 14;
  R.Time.Hour := 15;
  R.Time.Min := 06;
  R.Time.Sec := 23;

  FileName := GetModulePath + 'XmlReceipt3.xml';
  TXmlReceiptWriter.AddReceipt(R, FileName);
  TickCount := Integer(GetTickCount) - TickCount;
  Check(TickCount < 1000, 'TickCount < 1000 мс.');
end;

procedure TXmlReceiptWriterTest.CheckWrite;
var
  R: TReceiptRec;
  FileName1: WideString;
  FileName2: WideString;
begin
  FileName1 := GetModulePath + 'XmlReceipt.xml';
  FileName2 := GetModulePath + 'XmlReceipt1.xml';
  DeleteFile(FileName1);

  R.ID := 123;
  R.DocID := 234;
  R.RecType := 345;
  R.State := 456;
  R.Amount := 567;
  R.Payments[0] := 789;
  R.Payments[1] := 890;
  R.Payments[2] := 901;
  R.Payments[3] := 012;
  R.Date.Day := 3;
  R.Date.Month := 6;
  R.Date.Year := 14;
  R.Time.Hour := 15;
  R.Time.Min := 06;
  R.Time.Sec := 23;

  TXmlReceiptWriter.AddReceipt(R, FileName1);
  CheckEquals(ReadFileData(FileName1), ReadFileData(FileName2), 'FileName1');
  TXmlReceiptWriter.AddReceipt(R, FileName1);
  FileName2 := GetModulePath + 'XmlReceipt2.xml';
  CheckEquals(ReadFileData(FileName1), ReadFileData(FileName2), 'FileName2');
  DeleteFile(FileName1);
end;

initialization
  RegisterTest('', TXmlReceiptWriterTest.Suite);

end.
