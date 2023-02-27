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
  Item: TCommandDefs;
begin
  Logger := TLogFile.Create;
  Item := TCommandDefs.Create(Logger);
  try
    Item.LoadFromFile(GetModulePath + 'commands.xml');
    DeleteFile(GetModulePath + 'commands2.xml');
    Item.SaveToFile(GetModulePath + 'commands2.xml');
    CheckEquals(190, Item.Count, 'Item.Count');
  finally
    Item.Free;
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
    Item.SaveToFile('CommandDefs.xml');
  finally
    Item.Free;
    Logger := nil;
  end;
end;

initialization
  RegisterTest('', TCommandDefsTest.Suite);

end.
