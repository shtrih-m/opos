unit duTLV;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  TLV, StringUtils;

type
  { TTLVTest }

  TTLVTest = class(TTestCase)
  published
    procedure Check1;
  end;

implementation


{ TTLVTest }

procedure TTLVTest.Check1;
var
  Item: TTLV;
const
  DataHex =
  'C8042600C9040F008E8E8E2022928F8C20A3E0E3AFAF2293040F00382D3932362D3132332D34352D3637';
begin
  Item := TTLV.Create(nil);
  try
    Item.Tag := 1224;
    Item.Items.Clear;
    Item.Items.Add(1225).Data := TagToStr(1225, 'ÎÎÎ "ÒÏÌ ãðóïï"');
    Item.Items.Add(1171).Data := TagToStr(1171, '8-926-123-45-67');
    CheckEquals(DataHex, StrToHexText(Item.RawData), 'Item.RawData');
  finally
    Item.Free;
  end;
end;

initialization
  RegisterTest('', TTLVTest.Suite);

end.
