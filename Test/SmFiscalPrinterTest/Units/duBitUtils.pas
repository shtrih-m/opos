unit duBitUtils;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  ByteUtils;

type
  { TBitTest }

  TBitTest = class(TTestCase)
  published
    procedure CheckBits;
    procedure CheckTestBit;
  end;

implementation

{ TBitTest }

procedure TBitTest.CheckBits;
var
  Bits: TBits;
begin
  Bits := TBits.Create;
  try
    Bits.Add($0, 1);
    Bits.Add($0, 1);
    Bits.Add($01, 2);
    Bits.Add($02, 4);
    Bits.Add($56, 8);
    Bits.Add($FF, 8);
    Bits.Add($90, 8);
    Bits.Add($07, 3);
    Bits.UpdateBytes;
    CheckEquals(35, Bits.SizeInBits, 'Bits.SizeInBits');
    CheckEquals(5, Bits.SizeInBytes, 'Bits.SizeInBytes');
    CheckEquals($12, Bits.Bytes(0), 'Bits.Bytes(0)');
    CheckEquals($56, Bits.Bytes(1), 'Bits.Bytes(1)');
    CheckEquals($FF, Bits.Bytes(2), 'Bits.Bytes(2)');
    CheckEquals($90, Bits.Bytes(3), 'Bits.Bytes(3)');
    CheckEquals($E0, Bits.Bytes(4), 'Bits.Bytes(4)');
  finally
    Bits.Free;
  end;
end;

procedure TBitTest.CheckTestBit;
begin
  Check(TestBit($0100, 8), 'TestBit($0100, 8)');
  Check(not TestBit($0, 8), 'not TestBit($0, 8)');
  Check(TestBit($100000000, 32), 'TestBit($100000000, 32)');
end;

initialization
  RegisterTest('', TBitTest.Suite);

end.
