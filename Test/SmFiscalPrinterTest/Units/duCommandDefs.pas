unit duCommandDefs;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  CommandDef, LogFile, FileUtils;

type
  { TCommandDefsTest }

  TCommandDefsTest = class(TTestCase)
  published
    procedure CheckSaveToXml;
    procedure CheckLoadFromXml;
  end;

implementation


{ TCommandDefsTest }

procedure TCommandDefsTest.CheckLoadFromXml;
var
  Logger: ILogFile;
  Item: TCommandDef;
  Items: TCommandDefs;
begin
  CommandDefsLoadEnabled := True;
  Logger := TLogFile.Create;
  Items := TCommandDefs.Create(Logger);
  try
    Items.LoadFromFile(GetModulePath + 'commands.xml');
    CheckEquals(192, Items.Count, 'Items.Count');
    Item := Items.ItemByCode(37);
    Check(Item <> nil, 'Item <> nil');
    CheckEquals('Cut paper', Item.Name, 'Item.Name');
  finally
    Items.Free;
    Logger := nil;
  end;
end;

procedure TCommandDefsTest.CheckSaveToXml;
var
  Logger: ILogFile;
  Item: TCommandDefs;
begin
  Logger := TLogFile.Create;
  Item := TCommandDefs.Create(Logger);
  try
    Item.SaveToFile('commands2.xml');
  finally
    Item.Free;
    Logger := nil;
  end;
end;

initialization
  RegisterTest('', TCommandDefsTest.Suite);

end.
