unit duScaleDriver2;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs,
  // DUnit
  TestFramework,
  // Opos
  Opos, Oposhi, OposScalhi, OposEvents, OposScal,
  // This
  ScaleDriver;

type
  { TScaleDriverTest2 }

  TScaleDriverTest2 = class(TTestCase)
  private
    Driver: TScaleDriver;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  public
    procedure ClaimDevice;
    procedure DisableDevice;
    procedure EnableDevice;
    procedure OpenService;
    procedure ReleaseDevice;
    procedure OpenClaimEnable;
  published
    procedure CheckCheckHealth;
  end;

implementation

const
  DeviceName = 'SHTRIH-M-OPOS-1';

{ TScaleDriverTest2 }

procedure TScaleDriverTest2.Setup;
begin
  Driver := TScaleDriver.Create;
end;

procedure TScaleDriverTest2.TearDown;
begin
  Driver.Free;
end;

procedure TScaleDriverTest2.OpenService;
begin
  Driver.Parameters.CreateKey(DeviceName);
  CheckEquals(OPOS_SUCCESS, Driver.OpenService('Scale', DeviceName, nil));
end;

procedure TScaleDriverTest2.ClaimDevice;
begin
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
  CheckEquals(OPOS_SUCCESS, Driver.ClaimDevice(0), 'Driver.ClaimDevice(0)');
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
end;

procedure TScaleDriverTest2.ReleaseDevice;
begin
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
  CheckEquals(OPOS_SUCCESS, Driver.ReleaseDevice, 'Driver.ReleaseDevice');
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_Claimed),
    'Driver.GetPropertyNumber(PIDX_Claimed)');
end;

procedure TScaleDriverTest2.EnableDevice;
var
  ResultCode: Integer;
begin
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 1);
  ResultCode := Driver.GetPropertyNumber(PIDX_ResultCode);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'OPOS_SUCCESS');
  CheckEquals(1, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;

procedure TScaleDriverTest2.DisableDevice;
var
  ResultCode: Integer;
begin
  Driver.SetPropertyNumber(PIDX_DeviceEnabled, 0);
  ResultCode := Driver.GetPropertyNumber(PIDX_ResultCode);
  CheckEquals(OPOS_SUCCESS, ResultCode, 'OPOS_SUCCESS');
  CheckEquals(0, Driver.GetPropertyNumber(PIDX_DeviceEnabled), 'DeviceEnabled');
end;


procedure TScaleDriverTest2.OpenClaimEnable;
begin
  OpenService;
  ClaimDevice;
  EnableDevice;
end;

procedure TScaleDriverTest2.CheckCheckHealth;
begin
  OpenClaimEnable;
  CheckEquals(OPOS_SUCCESS, Driver.CheckHealth(OPOS_CH_INTERACTIVE),
    'Driver.CheckHealth(OPOS_CH_INTERACTIVE)');
end;

//initialization
//  RegisterTest('', TScaleDriverTest2.Suite);

end.
