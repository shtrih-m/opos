unit duM5OposDevice;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // 3'd
  TestFramework, PascalMock, Opos,
  // This
  M5OposDevice, M5ScaleTypes, M5ScaleDevice, MockScaleConnection,
  StringUtils, LogFile, CommandDef, ScaleParameters, ScaleStatistics,
  UIController, Oposhi;

type
  { TM5OposDeviceTest }

  TM5OposDeviceTest = class(TTestCase)
  private
    FLogger: ILogFile;
    Device:  TM5OposDevice;
    ScaleDevice: IM5ScaleDevice;
    Connection: TMockScaleConnection;
    FCommands: TCommandDefs;
    FParameters: TScaleParameters;
    FStatistics: TScaleStatistics;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    procedure TestReadWeight;
  end;

implementation

const
  Timeout = 567;
  Password = 1;

{ TM5OposDeviceTest }

procedure TM5OposDeviceTest.Setup;
var
  UIController: TUIController;
begin
  FLogger := TLogFile.Create;
  Connection := TMockScaleConnection.Create;
  ScaleDevice := TM5ScaleDevice.Create(FLogger, Connection);
  ScaleDevice.CommandTimeout := Timeout;
  ScaleDevice.Password := Password;
  FCommands := TCommandDefs.Create(FLogger);
  FParameters := TScaleParameters.Create(FLogger);
  FStatistics := TScaleStatistics.Create(FLogger);
  UIController := TUIController.Create(ScaleDevice);
  Device := TM5OposDevice.Create(FLogger, ScaleDevice, Connection,
    FCommands, FParameters, FStatistics, UIController);
  Device.PollEnabled := False;
end;

procedure TM5OposDeviceTest.TearDown;
begin
  FLogger := nil;
  ScaleDevice := nil;
  Device.Free;
  FCommands.Free;
  FParameters.Free;
  FStatistics.Free;
  Connection.Free;
end;

procedure TM5OposDeviceTest.TestReadWeight;
var
  WeightData: Integer;
const
  DeviceName = 'ScaleDevice';
begin
  FParameters.Save(DeviceName);

  //Connection.Expects('ClaimDevice').WithParams([FParameters.PortNumber, 0]);
  Connection.Expects('OpenPort').WithParams([FParameters.PortNumber,
    FParameters.BaudRate, FParameters.ByteTimeout]);

  // Decimal point 3, weight factor 1
  Connection.Expects('Send').WithParams([Timeout, #$FC]).Returns(
    #$FC#$00#$01#$02#$03#$04#$05#$06'Device name');
  Connection.Expects('Send').WithParams([Timeout, #$EA]).Returns(#$EA#$00#$67);
  Connection.Expects('Send').WithParams([Timeout, #$E8#$67]).Returns(
    HexToStr('E800010003000400050006000700080009000A0B0C0D0E0F'));

  Connection.Expects('Send').WithParams([Timeout, HexToStr('3A01000000')]).
    Returns(HexToStr('3A000123010000000123'));

  Connection.Expects('Send').WithParams([Timeout, #$11#$01#$00#$00#$00]).
    Returns(#$11#$00#$12#$34#$12#$34#$56#$78#$57#$24#$00#$76#$89#$77#$68#$87#$64#$73#$18#$17);

  CheckEquals(0, Device.Open(OPOS_CLASSKEY_SCAL, DeviceName, nil), 'Device.Open');
  CheckEquals(0, Device.ClaimDevice(0), 'Device.ClaimDevice');
  Device.SetDeviceEnabled(True);
  CheckEquals(0, Device.ReadWeight(WeightData, 0), 'Device.ReadWeight');
  CheckEquals(1000, WeightData, 'WeightData');
  Connection.Verify('Verify');
end;

initialization
  RegisterTest('', TM5OposDeviceTest.Suite);

end.
