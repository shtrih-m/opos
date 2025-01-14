unit duFiscalPrinterDevice;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework, FiscalPrinterDevice, Opos, OPOSException, OposFptr,
  DriverError, StringUtils, PrinterTypes, MockPrinterConnection2;

type
  { TFiscalPrinterDeviceTest }

  TFiscalPrinterDeviceTest = class(TTestCase)
  private
    Device: TFiscalPrinterDevice;
    Connection: TMockPrinterConnection2;
    procedure CheckErrorCode(Code: Integer);
  protected
    procedure Setup; override;
    procedure TearDown; override;

    procedure TestUpdateInfo; // !!!
  published
    procedure TestCheck;
    procedure TestSTLV;
    procedure TestIsMatch;
    procedure TestBarcodeTo1162Value;
    procedure TestReadFontInfoList;
    procedure TestReadFontInfo;
    procedure TestReadTaxInfoList;
  end;

implementation

{ TFiscalPrinterDeviceTest }

procedure TFiscalPrinterDeviceTest.Setup;
begin
  Device := TFiscalPrinterDevice.Create;
  Connection := TMockPrinterConnection2.Create;
  Device.Connection := Connection;
end;

procedure TFiscalPrinterDeviceTest.TearDown;
begin
  Device.Free;
  Connection.Free;
end;

procedure TFiscalPrinterDeviceTest.CheckErrorCode(Code: Integer);
begin
  try
    Device.Check(Code);
    Check(False, 'No Exception');
  except
    on E: EDriverError do
    begin
      CheckEquals(E.ErrorCode, Code, 'E.ErrorCode');
    end;
  end;
end;

procedure TFiscalPrinterDeviceTest.TestCheck;
begin
  CheckErrorCode($01); // FM1, Code); FM2 or RTC error
  CheckErrorCode($02); // FM1 missing
end;

procedure TFiscalPrinterDeviceTest.TestSTLV;
const
  DataHex =
  'C8042600C9040F008E8E8E2022928F8C20A3E0E3AFAF2293040F00382D3932362D3132332D34352D3637';
begin
  Device.STLVBegin(1224);
  Device.STLVAddTag(1225, 'ÎÎÎ "ÒÏÌ ãðóïï"');
  Device.STLVAddTag(1171, '8-926-123-45-67');
  CheckEquals(DataHex, Device.STLVGetHex, 'Device.STLVGetHex');
end;

procedure TFiscalPrinterDeviceTest.TestBarcodeTo1162Value;
var
  data: AnsiString;
  validData: AnsiString;
  barcode: AnsiString;
begin
  // EAN-8
  validData := '45 08 00 00 02 C0 EE D8';
  data := StrToHex(device.barcodeTo1162Value('46198488'));
  CheckEquals(validData, data);
  // EAN-8 - unknown
  validData := '00 00 41 34 36 31 39 38 34 38 38';
  data := StrToHex(device.barcodeTo1162Value('A46198488'));
  CheckEquals(validData, data);
  // EAN-13
  validData := '45 0D 04 30 77 19 57 61';
  data := StrToHex(device.barcodeTo1162Value('4606203090785'));
  CheckEquals(validData, data);
  // ITF-14
  validData := '49 0E 0D 47 9D 66 52 D2';
  data := StrToHex(device.barcodeTo1162Value('14601234567890'));
  CheckEquals(validData, data);

  validData := '44 4D 04 2F 1F 96 81 78 4A 67 58 4A 35 2E 54 31 31 32 30 30 30';
  barcode := '010460043993125621JgXJ5.T'#$1D'8005112000'#$1D'930001'#$1D'923zbrLA=='#$1D'24014276281';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(validData, data);

  barcode := '010460406000600021N4N57RSCBUZTQ'#$1D'2403004002910161218'#$1D'1724010191ffd0' +
      #$1D'92tIAF/YVoU4roQS3M/m4z78yFq0fc/WsSmLeX5QkF/YVWwy8IMYAeiQ91Xa2z/fFSJcOkb' +
      '2N+uUUmfr4n0mOX0Q==';
  validData := '44 4D 04 2F F7 5C 76 70 4E 34 4E 35 37 52 53 43 42 55 5A 54 51';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(validData, data);

  barcode := '00000046198488X?io+qCABm8wAYa';
  validData := '44 4D 00 00 02 C0 EE D8 58 3F 69 6F 2B 71 43 41 42 6D 38 20 20';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(validData, data);

  barcode := 'RU-401301-AAA02770301';
  validData := '52 46 52 55 2D 34 30 31 33 30 31 2D 41 41 41 30 32 37 37 30 33 30 31';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(validData, data);

  barcode := '22N00002NU5DBKYDOT17ID980726019019608CW1A4XR5EJ7JKFX50FHHGV92ZR2GZRZ';
  validData := 'C5 14 4E 55 35 44 42 4B 59 44 4F 54 31 37 49 44 39 38 30 37 32 36 30 31 39';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(UpperCase(validData), data);

  barcode := '136222000058810918QWERDFEWT5123456YGHFDSWERT56YUIJHGFDSAERTYUIOKJ8H' +
      'GFVCXZSDLKJHGFDSAOIPLMNBGHJYTRDFGHJKIREWSDFGHJIOIUTDWQASDFRETY' +
      'UIUYGTREDFGHUYTREWQWE';
  validData := 'C5 1E 31 33 36 32 32 32 30 30 30 30 35 38 38 31';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(UpperCase(validData), data);

  barcode := '2710124190';
  validData := '45 41 00 00 A1 89 36 9E';
  data := StrToHex(device.barcodeTo1162Value(barcode));
  CheckEquals(UpperCase(validData), data);
end;

procedure TFiscalPrinterDeviceTest.TestIsMatch;
begin
  CheckEquals(True, IsMatch('72354726', '\d+'));
  CheckEquals(True, IsMatch('72354726', '\d{8}'));
  CheckEquals(True, IsMatch('72354726', '[0-9]{8}'));
end;

procedure TFiscalPrinterDeviceTest.TestReadFontInfoList;
var
  FontInfo: TFontInfo;
  FontInfoList: TFontInfoList;
begin
  Connection.Expects('Send').WithParams([3000, '26 00 00 00 00 01']).Returns('26 00 00 02 0C 18 02');
  Connection.Expects('Send').WithParams([3000, '26 00 00 00 00 02']).Returns('26 00 58 02 09 12 02');
  FontInfoList := Device.ReadFontInfoList;
  Connection.Verify('Connection.Verify');

  CheckEquals(2, Length(FontInfoList), 'Length(FontInfoList)');
  // 0
  FontInfo := FontInfoList[0];
  CheckEquals(512, FontInfo.PrintWidth, 'FontInfo.PrintWidth.0');
  CheckEquals(12, FontInfo.CharWidth, 'FontInfo.CharWidth.0');
  CheckEquals(24, FontInfo.CharHeight, 'FontInfo.CharHeight.0');
  CheckEquals(2, FontInfo.FontCount, 'FontInfo.FontCount.0');
  // 1
  FontInfo := FontInfoList[1];
  CheckEquals(600, FontInfo.PrintWidth, 'FontInfo.PrintWidth.1');
  CheckEquals(9, FontInfo.CharWidth, 'FontInfo.CharWidth.1');
  CheckEquals(18, FontInfo.CharHeight, 'FontInfo.CharHeight.1');
  CheckEquals(2, FontInfo.FontCount, 'FontInfo.FontCount.1');
end;

procedure TFiscalPrinterDeviceTest.TestReadFontInfo;
var
  FontInfo: TFontInfo;
begin
  Connection.Expects('Send').WithParams([3000, '26 00 00 00 00 01']).Returns('26 00 00 02 0C 18 01');
  FontInfo := Device.ReadFontInfo(1);
  Connection.Verify('Connection.Verify');
  CheckEquals(512, FontInfo.PrintWidth, 'FontInfo.PrintWidth');
  CheckEquals(12, FontInfo.CharWidth, 'FontInfo.CharWidth');
  CheckEquals(24, FontInfo.CharHeight, 'FontInfo.CharHeight');
  CheckEquals(1, FontInfo.FontCount, 'FontInfo.FontCount');
end;

procedure TFiscalPrinterDeviceTest.TestReadTaxInfoList;
var
  RxData: AnsiString;
  TaxInfoList: TTaxInfoList;
begin
  // Read table info
  RxData := #$2D#$00 + StringOfChar(#0, 40) + IntToBin(2, 2) + Chr(3);
  Connection.Expects('Send').WithParams([3000, '2D 00 00 00 00 06']).Returns(StrToHex(RxData));
  // Read field info 1
  RxData := #$2E#$00 + StringOfChar(#0, 40) + #$00#$02;
  Connection.Expects('Send').WithParams([3000, '2E 00 00 00 00 06 01']).Returns(StrToHex(RxData));
  // Read table value
  RxData := #$1F#$00 + #$E8#$03;
  Connection.Expects('Send').WithParams([3000, '1F 00 00 00 00 06 01 00 01']).Returns(StrToHex(RxData));
  // Read field info 2
  RxData := #$2E#$00 + StringOfChar(#0, 40) + #$01#$02;
  Connection.Expects('Send').WithParams([3000, '2E 00 00 00 00 06 02']).Returns(StrToHex(RxData));
  // Read table value
  RxData := #$1F#$00 + '10 %';
  Connection.Expects('Send').WithParams([3000, '1F 00 00 00 00 06 01 00 02']).Returns(StrToHex(RxData));
  // Read table value
  RxData := #$1F#$00 + #$F4#$01;
  Connection.Expects('Send').WithParams([3000, '1F 00 00 00 00 06 02 00 01']).Returns(StrToHex(RxData));
  // Read table value
  RxData := #$1F#$00 + '5 %';
  Connection.Expects('Send').WithParams([3000, '1F 00 00 00 00 06 02 00 02']).Returns(StrToHex(RxData));

  TaxInfoList := Device.ReadTaxInfoList;
  Connection.Verify('Connection.Verify');
  CheckEquals(2, Length(TaxInfoList), 'Length(TaxInfoList)');
  // 0
  CheckEquals(1000, TaxInfoList[0].Rate, 'TaxInfoList[0].Rate');
  CheckEquals('10 %', TaxInfoList[0].Name, 'TaxInfoList[0].Name');
  // 1
  CheckEquals(500, TaxInfoList[1].Rate, 'TaxInfoList[1].Rate');
  CheckEquals('5 %', TaxInfoList[1].Name, 'TaxInfoList[1].Name');
end;

procedure TFiscalPrinterDeviceTest.TestUpdateInfo;
begin

end;

initialization
  RegisterTest('', TFiscalPrinterDeviceTest.Suite);

end.


