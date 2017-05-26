unit duOposStatistics;

interface

uses
  // VCL
  Windows, SysUtils, Classes,
  // DUnit
  TestFramework,
  // This
  OposStatistics, FileUtils, Logfile;

type
  { OposStatistics }

  TOposStatisticsTest = class(TTestCase)
  private
    Logger: TLogfile;
    Item: TOposStatistics;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure CheckReset;
    procedure CheckUpdate;
    procedure CheckRetrieve;
  end;

implementation

function GetPath: string;
begin
  Result := IncludeTrailingBackSlash(ExtractFilePath(FileUtils.GetModuleFileName));
end;

{ TOposStatisticsTest }

procedure TOposStatisticsTest.SetUp;
begin
  inherited SetUp;
  Logger := TLogfile.Create;
  Item := TOposStatistics.Create(Logger);
end;

procedure TOposStatisticsTest.TearDown;
begin
  Item.Free;
  Logger.Free;
  inherited TearDown;
end;

procedure TOposStatisticsTest.CheckReset;
var
  Buffer: WideString;
begin
  Buffer := 'HoursPoweredCount=10,CommunicationErrorCount=234';
  Item.Update(Buffer);

  Buffer := '';
  Item.Retrieve(Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsUpdateTest1.txt'));
  // reset
  Buffer := 'HoursPoweredCount';
  Item.Reset(Buffer);

  Buffer := '';
  Item.Retrieve(Buffer);
  WriteFileData(GetPath + 'OposStatisticsResetTest.txt', Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsResetTest1.txt'));
end;

procedure TOposStatisticsTest.CheckRetrieve;
var
  Buffer: WideString;
begin
  // All items
  Buffer := '';
  Item.Retrieve(Buffer);
  WriteFileData(GetPath + 'OposStatisticsRetrieveTest.txt', Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsRetrieveTest1.txt'));
  // Unknown item
  Buffer := 'HoursPoweredCount2';
  Item.Retrieve(Buffer);
  WriteFileData(GetPath + 'OposStatisticsRetrieveTest.txt', Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsRetrieveTest2.txt'));
  // Opos items
  Buffer := 'U_';
  Item.Retrieve(Buffer);
  WriteFileData(GetPath + 'OposStatisticsRetrieveTest.txt', Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsRetrieveTest1.txt'));
  // Manufacturer items
  Buffer := 'M_';
  Item.Retrieve(Buffer);
  WriteFileData(GetPath + 'OposStatisticsRetrieveTest.txt', Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsRetrieveTest3.txt'));
end;

procedure TOposStatisticsTest.CheckUpdate;
var
  Buffer: WideString;
begin
  Buffer := 'HoursPoweredCount=10,CommunicationErrorCount=234';
  Item.Update(Buffer);

  Buffer := '';
  Item.Retrieve(Buffer);
  WriteFileData(GetPath + 'OposStatisticsUpdateTest.txt', Buffer);
  Check(Buffer = ReadFileData(GetPath + 'OposStatisticsUpdateTest1.txt'));
end;

//initialization
//  RegisterTest('', TOposStatisticsTest.Suite);

end.
