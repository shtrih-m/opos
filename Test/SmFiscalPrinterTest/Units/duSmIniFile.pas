unit duSmIniFile;

interface

uses
  // VCL
  Windows, SysUtils, Classes, IniFiles,
  // DUnit
  TestFramework,
  // This
  FileUtils, StringUtils, SmIniFile;

type
  { TIniFileTest }

  TIniFileTest = class(TTestCase)
  private
    IniFile: TSmIniFile;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckReadString;
  end;

implementation


{ TIniFileTest }

procedure TIniFileTest.Setup;
var
  FileName: WideString;
begin
  FileName := ChangeFileExt(GetModuleFileName, '.ini');
  DeleteFile(FileName);
  IniFile := TSmIniFile.Create(FileName);
end;

procedure TIniFileTest.TearDown;
begin
  IniFile.Free;
end;

procedure TIniFileTest.CheckReadString;
var
  Line1: WideString;
  Line2: WideString;
begin
  Line2 := IniFile.ReadText('Section1', 'Ident1', '');
  CheckEquals('', Line2, 'Line2 <> ""');

  Line1 := 'sdkfhksfhl'#13#10'kshfksjhdfkjh';
  IniFile.WriteText('Section1', 'Ident1', Line1);
  Line2 := IniFile.ReadText('Section1', 'Ident1', '');
  CheckEquals(Line1, Line2, 'Line2');
end;

initialization
  RegisterTest('', TIniFileTest.Suite);


end.
