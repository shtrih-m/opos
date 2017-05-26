unit duIniFile;

interface

uses
  // VCL
  Windows, SysUtils, Classes, IniFiles,
  // DUnit
  TestFramework,
  // This
  FileUtils, StringUtils;

type
  { TIniFileTest }

  TIniFileTest = class(TTestCase)
  private
    IniFile: TIniFile;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckReadString;
    procedure CheckReadBinary;
  end;

implementation


{ TIniFileTest }

procedure TIniFileTest.Setup;
var
  FileName: string;
begin
  FileName := ChangeFileExt(GetModuleFileName, '.ini');
  DeleteFile(FileName);
  IniFile := TIniFile.Create(FileName);
end;

procedure TIniFileTest.TearDown;
begin
  IniFile.Free;
end;

procedure TIniFileTest.CheckReadString;
var
  Line1: string;
  Line2: string;
begin
  Line1 := 'sdkfhksfhl';
  Line2 := IniFile.ReadString('Section1', 'Ident1', '');
  CheckEquals('', Line2, 'Line2 <> ""');

  IniFile.WriteString('Section1', 'Ident1', Line1);
  Line2 := IniFile.ReadString('Section1', 'Ident1', '');
  CheckEquals(Line1, Line2, 'Line1 <> Line2');

  Line1 := 'sdkfhksfhl'#13#10'kshfksjhdfkjh';
  IniFile.WriteString('Section1', 'Ident1', Line1);
  Line2 := IniFile.ReadString('Section1', 'Ident1', '');
  CheckEquals('sdkfhksfhl', Line2, 'Line2');
end;

procedure TIniFileTest.CheckReadBinary;
var
  Data2: string;
  Stream: TMemoryStream;
const
  Data1 = #$02#$03#$04#$05#$06;
begin
  Data2 := '';

  Stream := TMemoryStream.Create;
  try
    IniFile.ReadBinaryStream('Section1', 'Ident1', Stream);
    CheckEquals(0, Stream.Size, 'Stream.Size');

    Stream.WriteBuffer(Data1[1], Length(Data1));
    Stream.Position := 0;
    IniFile.WriteBinaryStream('Section1', 'Ident1', Stream);

    Stream.Clear;
    IniFile.ReadBinaryStream('Section1', 'Ident1', Stream);
    Check(Stream.Size > 0, 'Stream.Size');
    CheckEquals(Length(Data1), Stream.Size, 'Stream.Size');
    SetLength(Data2, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(Data2[1], Stream.Size);
    CheckEquals(StrToHex(Data1), StrToHex(Data2), 'Data1 <> Data2');
  finally
    Stream.Free;
  end;
end;

initialization
  RegisterTest('', TIniFileTest.Suite);


end.
