unit duScaleParameters;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs,
  // DUnit
  TestFramework,
  // This
  ScaleParameters, LogFile;

type
  { TScaleParametersTest }

  TScaleParametersTest = class(TTestCase)
  private
    Logger: ILogFile;
    Parameters: TScaleParameters;

    procedure SetValues;
    procedure CheckParameters;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure CheckSave;
    procedure CheckSetDefault;
  end;

implementation

const
  DeviceName = 'Device1';

{ TScaleParametersTest }

procedure TScaleParametersTest.Setup;
begin
  Logger := TLogFile.Create;
  Parameters := TScaleParameters.Create(Logger);
end;

procedure TScaleParametersTest.TearDown;
begin
  Logger := nil;
  Parameters.DeleteKey(DeviceName);
  Parameters.Free;
end;

procedure TScaleParametersTest.SetValues;
begin
  Parameters.CCOType := 123;
  Parameters.Password := 123;
  Parameters.Encoding := 123;
  Parameters.PortNumber := 123;
  Parameters.BaudRate := 123;
  Parameters.ByteTimeout := 123;
  Parameters.CommandTimeout := 123;
  Parameters.MaxRetryCount := 123;
  Parameters.SearchByPortEnabled := True;
  Parameters.SearchByBaudRateEnabled := True;
  Parameters.LogFileEnabled := True;
  Parameters.LogMaxCount := 123;
  Parameters.CapPrice := True;
  Parameters.PollPeriod := 123;
end;

procedure TScaleParametersTest.CheckParameters;
begin
  CheckEquals(DefCCOType, Parameters.CCOType, 'Parameters.CCOType');
  CheckEquals(DefPassword, Parameters.Password, 'Parameters.Password');
  CheckEquals(DefEncoding, Parameters.Encoding, 'Parameters.Encoding');
  CheckEquals(DefPortNumber, Parameters.PortNumber, 'Parameters.PortNumber');
  CheckEquals(DefBaudRate, Parameters.BaudRate, 'Parameters.BaudRate');
  CheckEquals(DefByteTimeout, Parameters.ByteTimeout, 'Parameters.ByteTimeout');
  CheckEquals(DefCommandTimeout, Parameters.CommandTimeout,
    'Parameters.CommandTimeout');
  CheckEquals(DefMaxRetryCount, Parameters.MaxRetryCount,
    'Parameters.MaxRetryCount');
  CheckEquals(DefSearchByPortEnabled, Parameters.SearchByPortEnabled,
    'Parameters.SearchByPortEnabled');
  CheckEquals(DefSearchByBaudRateEnabled, Parameters.SearchByBaudRateEnabled,
    'Parameters.SearchByBaudRateEnabled');
  CheckEquals(DefLogFileEnabled, Parameters.LogFileEnabled,
    'Parameters.LogFileEnabled');
  CheckEquals(DefLogMaxCount, Parameters.LogMaxCount, 'Parameters.LogMaxCount');
  CheckEquals(DefCapPrice, Parameters.CapPrice, 'Parameters.CapPrice');
  CheckEquals(DefPollPeriod, Parameters.PollPeriod, 'Parameters.PollPeriod');
end;

procedure TScaleParametersTest.CheckSetDefault;
begin
  SetValues;
  Parameters.SetDefaults;
  CheckParameters;
end;

procedure TScaleParametersTest.CheckSave;
begin
  SetValues;
  Parameters.SetDefaults;
  Parameters.Save(DeviceName);
  SetValues;
  Parameters.Load(DeviceName);
  CheckParameters;
end;


initialization
  RegisterTest('', TScaleParametersTest.Suite);

end.
