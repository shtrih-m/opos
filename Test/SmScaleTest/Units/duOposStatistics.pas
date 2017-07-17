unit duOposStatistics;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs,
  // DUnit
  TestFramework,
  // Opos
  Opos, Oposhi, OposScalhi, OposEvents, OposScal, OposStatistics, OposStat,
  // This
  FileUtils, LogFile;

type
  { TOposStatisticsTest }

  TOposStatisticsTest = class(TTestCase)
  private
    Logger: ILogFile;
    Statistics: TOposStatistics;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  public
    procedure CheckRetrieveStatistics;
    procedure CheckUpdateStatistics;
  published
    procedure CheckLoad;
    procedure CheckResetStatistics;
  end;

implementation

const
  DeviceName = 'DeviceName1';

{ TOposStatisticsTest }

procedure TOposStatisticsTest.Setup;
begin
  Logger := TLogFile.Create;
  Statistics := TOposStatistics.Create(Logger);
end;

procedure TOposStatisticsTest.TearDown;
begin
  Statistics.Free;
  Logger := nil;
end;

procedure TOposStatisticsTest.CheckLoad;
begin
  // CommunicationErrorCount
  CheckEquals(0, Statistics.GetCounter(OPOS_STAT_CommunicationErrorCount),
    'CommunicationErrorCount');
  Statistics.CommunicationError;
  CheckEquals(1, Statistics.GetCounter(OPOS_STAT_CommunicationErrorCount),
    'CommunicationErrorCount');
  // HoursPoweredCount
  CheckEquals(0, Statistics.GetCounter(OPOS_STAT_HoursPoweredCount),
    'HoursPoweredCount');
  Statistics.ReportHoursPowered(123);
  Statistics.ReportHoursPowered(1);
  CheckEquals(124, Statistics.GetCounter(OPOS_STAT_HoursPoweredCount),
    'HoursPoweredCount');
  Statistics.IniSave(DeviceName);
  Statistics.Reset('');
  CheckEquals(0, Statistics.GetCounter(OPOS_STAT_CommunicationErrorCount),
    'CommunicationErrorCount');
  CheckEquals(0, Statistics.GetCounter(OPOS_STAT_HoursPoweredCount),
    'HoursPoweredCount');
  Statistics.IniLoad(DeviceName);
  CheckEquals(1, Statistics.GetCounter(OPOS_STAT_CommunicationErrorCount),
    'CommunicationErrorCount');
  CheckEquals(124, Statistics.GetCounter(OPOS_STAT_HoursPoweredCount),
    'HoursPoweredCount');
end;

procedure TOposStatisticsTest.CheckResetStatistics;
var
  Buffer: WideString;
const
  SrcFileName1 = 'SrcOposStatistics1.txt';
  SrcFileName2 = 'SrcOposStatistics2.txt';
  DstFileName1 = 'DstOposStatistics1.txt';
  DstFileName2 = 'DstOposStatistics2.txt';
begin
  Statistics.DeviceCategory := OPOS_CLASSKEY_SCAL;
  Statistics.UnifiedPOSVersion := '1.13.0';
  Statistics.ManufacturerName := 'SHTRIH-M';
  Statistics.ModelName := 'Scale1';
  Statistics.SerialNumber := '82634827346';
  Statistics.FirmwareRevision := '1.2.345';
  Statistics.InterfaceName := 'RS232';
  Statistics.InstallationDate := '25.12.2012';

  Buffer := '';
  Statistics.Reset(Buffer);
  Statistics.Retrieve(Buffer);
  DeleteFile(DstFileName1);
  WriteFileData(DstFileName1, Buffer);
  CheckEquals(ReadFileData(SrcFileName1), Buffer, 'Buffer');
  DeleteFile(DstFileName1);

  Buffer := '';
  Statistics.ReportHoursPowered(1);
  Statistics.CommunicationError;
  Statistics.CommunicationError;
  Statistics.Retrieve(Buffer);
  DeleteFile(DstFileName2);
  WriteFileData(DstFileName2, Buffer);
  CheckEquals(ReadFileData(SrcFileName2), Buffer, 'Buffer');
end;

procedure TOposStatisticsTest.CheckRetrieveStatistics;
begin

end;

procedure TOposStatisticsTest.CheckUpdateStatistics;
begin

end;

initialization
  RegisterTest('', TOposStatisticsTest.Suite);

end.
