unit duTankReader;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  TankReader, UniposTank;

type
  { TTankReaderTest }

  TTankReaderTest = class(TTestCase)
  private
    Item: TTankReader;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckClear;
  end;

implementation

{ TTankReaderTest }

procedure TTankReaderTest.Setup;
begin
  Item := TTankReader.Create;
end;

procedure TTankReaderTest.TearDown;
begin
  Item.Free;
end;

procedure TTankReaderTest.CheckClear;
begin
  CheckEquals(0, Item.Tanks.Count, 'Item.Tanks.Count');
  CheckEquals(0, Item.Values.Count, 'Item.Values.Count');
  Item.Tanks.Add('Tank1');
  Item.Tanks.Add('Tank2');
  Item.Values.Add('Value1');
  Item.Values.Add('Value2');
  CheckEquals(2, Item.Tanks.Count, 'Item.Tanks.Count');
  CheckEquals(2, Item.Values.Count, 'Item.Values.Count');

  Item.Clear;
  CheckEquals(0, Item.Tanks.Count, 'Item.Tanks.Count');
  CheckEquals(0, Item.Values.Count, 'Item.Values.Count');
end;

initialization
  RegisterTest('', TTankReaderTest.Suite);

end.
