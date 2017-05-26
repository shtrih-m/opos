unit duOFD;

interface

uses
  // VCL
  Windows, SysUtils, Classes, DateUtils,
  // DUnit
  TestFramework,
  // This
  OFD, OFDProtocol, OFDOpenSessionReport, TLV, StringUtils, FileUtils,
  LogFile, formatTLV;

type
  { TOFDTest }

  TOFDTest = class(TTestCase)
  private
    Sender: TOFD;
    Container: TTLVList;
  protected
    procedure Setup; override;
    procedure TearDown; override;

    procedure testAddDate;
    procedure testServerOpenDay;
    procedure testFiscalization;
    procedure testServerOpenDay2;
  published
    procedure testSingleByte;
    procedure testSingleFixed32;
    procedure testSingleUint64Packed8;
    procedure testSingleUint64Packed7;
    procedure testSingleUint64Packed6;
    procedure testSingleUint64Packed5;
    procedure testSingleUint64Packed4;
    procedure testSingleUint64Packed3;
    procedure testSingleUint64Packed2;
    procedure testSingleUint64Packed1;
    procedure testSingleUint64Packed0;
    procedure testSingleString;
    procedure testSingleFixedString;
    procedure testSingleFixedStringNoPadding;
    procedure testSingleBytes;
    procedure testSingleFixedBytes;
    procedure testSingleFixedBytesNoPadding;
    procedure testSingleEmptyObject;
    procedure testSingleObjectWithString;
    procedure testNestedObject;
    procedure testComplexObject;
    procedure testSimpleDouble;
    procedure testAddIntFixed;
  end;

implementation

{ TOFDTest }

procedure TOFDTest.Setup;
begin
  inherited Setup;
  Sender := TOFD.Create;
  Container := TTLVList.Create;
end;

procedure TOFDTest.TearDown;
begin
  Sender.Free;
  Container.Free;
  inherited TearDown;
end;

procedure TOFDTest.testSingleByte;
const
  Data = #$21#$43#$01#$00#$fd;
begin
  Container.AddByte($4321, $fd);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleFixed32;
const
  Data = #$23#$78#$04#$00#$44#$33#$22#$11;
begin
  Container.AddInt($7823, $11223344);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed8;
const
  Data = #$e4#$e2#$08#$00#$11#$22#$33#$44#$55#$66#$77#$88;
var
  V: Int64;
begin
  V := $8877665544332211;
  Container.AddInt64($e2e4, V);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed7;
const
  Data = #$e4#$e2#$07#$00#$11#$22#$33#$44#$55#$66#$77;
var
  V: Int64;
begin
  V := $77665544332211;
  Container.AddInt64($e2e4, V);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed6;
const
  Data = #$e4#$e2#$06#$00#$11#$22#$33#$44#$55#$66;
var
  V: Int64;
begin
  V := $665544332211;
  Container.AddInt64($e2e4, V);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed5;
const
  Data = #$e4#$e2#$05#$00#$11#$22#$33#$44#$55;
var
  V: Int64;
begin
  V := $5544332211;
  Container.AddInt64($e2e4, V);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed4;
const
  Data = #$e4#$e2#$04#$00#$11#$22#$33#$44;
begin
  Container.AddInt64($e2e4, $44332211);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed3;
const
  Data = #$e4#$e2#$03#$00#$11#$22#$33;
begin
  Container.AddInt64($e2e4, $332211);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed2;
const
  Data = #$e4#$e2#$02#$00#$11#$22;
begin
  Container.AddInt64($e2e4, $2211);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed1;
const
  Data = #$e4#$e2#$01#$00#$11;
begin
  Container.AddInt64($e2e4, $11);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleUint64Packed0;
const
  Data = #$e4#$e2#$00#$00;
begin
  Container.AddInt64($e2e4, 0);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleString;
const
  Data = #$4a#$a5#$04#$00'test';
begin
  Container.AddStr($a54a, 'test', 0);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleFixedString;
const
  Data = #$4a#$a5#$08#$00'test    ';
begin
  Container.AddStr($a54a, 'test', 8);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleFixedStringNoPadding;
const
  Data = #$4a#$a5#$08#$00'testtest';
begin
  Container.AddStr($a54a, 'testtest', 8);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleBytes;
const
  Data = #$4a#$a5#$04#$00'test';
begin
  Container.AddBytes($a54a, 'test', 4);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleFixedBytes;
const
  Data = #$4a#$a5#$08#$00#$00#$00#$00#$00'test';
begin
  Container.AddBytes($a54a, 'test', 8);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleFixedBytesNoPadding;
const
  Data = #$4a#$a5#$08#$00'testtest';
begin
  Container.AddBytes($a54a, 'testtest', 8);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleEmptyObject;
const
  Data = #$34#$12#$00#$00;
begin
  Container.Add($1234);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSingleObjectWithString;
const
  Data = #$34#$12#$08#$00#$4a#$a5#$04#$00'test';
var
  V: TTLV;
begin
  V := Container.Add($1234);
  V.Items.AddStr($a54a, 'test', 0);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testNestedObject;
const
  Data = #$34#$12#$0c#$00#$78#$56#$08#$00#$4a#$a5#$04#$00'test';
var
  V: TTLV;
begin
  V := Container.Add($1234);
  V := V.Items.Add($5678);
  V.Items.AddStr($a54a, 'test', 0);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testComplexObject;
const
  Data = #$34#$12#$19#$00 +  //object header
    #$23#$78#$04#$00#$44#$33#$22#$11 + //fixed32
    #$78#$56#$08#$00#$4a#$a5#$04#$00'test' + // nested object w/string
    #$21#$43#$01#$00#$42; //byte
var
  V1, V2: TTLV;
begin
  V1 := Container.Add($1234);
  V1.Items.AddInt($7823, $11223344);
  V2 := V1.Items.Add($5678);
  V2.Items.AddStr($a54a, 'test', 0);
  V1.Items.AddByte($4321, $42);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testSimpleDouble;
const
  Data = #$76#$98#$03#$00#$02#$34#$12;
begin
  Container.AddCurrency($9876, $1234);
  //CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData)); { !!! }
end;

procedure TOFDTest.testServerOpenDay;
var
  P: TOFDOpenSessionReportParams;
begin
  P.UserINN := '12345678';
  P.Cashier := 'User1';
  P.DateTime := Now;
  P.SessionNumber := 100;
  P.IsOFDTimeout := False;
  P.IsFNNeedToReplace := False;
  P.IsFNOverload := False;
  P.IsFNFinished := False;
  P.KKTNumber := '12000005';
  P.FNSerial := '1517';
  P.FiscalDocumentNumber := 123;
  P.DocumentFiscalSign := 144112;

  Sender.Enabled := True;
  Sender.Host := 'k-server.test-naofd.ru';
  Sender.Port := 7777;
  Sender.KKMID := '12000005';
  Sender.OpenSession(P);
end;

procedure TOFDTest.testServerOpenDay2;
var
  Data: string;
  Sender: TOFDProtocol;
begin
  Data := ReadFileData(GetModulePath + 'openshift.bin');
  Sender := TOFDProtocol.Create;
  try
    Sender.Host := 'k-server.test-naofd.ru';
    Sender.Port := 7777;
    Sender.KKMID := '12000099';
    Sender.Send(Data);
  finally
    Sender.Free;
  end;
end;

procedure TOFDTest.testFiscalization;
var
  Data: string;
  Sender: TOFD;
begin
  Logger.Enabled := True;
  Logger.FilePath := GetModulePath;
  Logger.FileName := 'testFiscalization.txt';
  Logger.Debug('testFiscalization');

  Data := ReadFileData(GetModulePath + 'квитанция.ofd');
  Sender := TOFD.Create;
  try
    Sender.Enabled := True;
    Sender.Host := '109.73.43.4';
    Sender.Port := 19080;
    Sender.KKMID := 'KKT-772-233-445-566';
    Sender.SendData(Data);
    WriteFileData(GetModulePath + 'Answer.bin', Sender.Answer);
  finally
    Sender.Free;
    Logger.Enabled := False;
  end;
end;

procedure TOFDTest.testAddIntFixed;
const
  Data = #$34#$12#$06#$00#$00#$00#$00#$23#$45#$67;
begin
  Container.AddIntFixed($1234, $234567, 6);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

procedure TOFDTest.testAddDate;
var
  V: TDateTime;
const
  Data = #$34#$12#$04#$00#$55#$9E#$02#$8A;
begin
  V := EncodeDate(2015, 07, 09) + EncodeTime(5, 11, 38, 0);
  CheckEquals('559E028A', IntToHex(DateTimeToUnix(V), 8));
  Container.AddDateTime($1234, V);
  CheckEquals(StrToHex(Data), StrToHex(Container.GetRawData));
end;

initialization
  RegisterTest('', TOFDTest.Suite);

end.
