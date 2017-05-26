unit duM5ScaleDevice;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // 3'd
  TestFramework, PascalMock, Opos,
  // This
  M5ScaleTypes, M5ScaleDevice, MockScaleConnection, StringUtils;

type
  { TM5ScaleDeviceTest }

  TM5ScaleDeviceTest = class(TTestCase)
  private
    Device: IM5ScaleDevice;
    Connection: TMockScaleConnection;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  public
    procedure CheckDecodeFlags;
  published
    procedure CheckLockKeyboard;
    procedure CheckUnlockKeyboard;
    procedure CheckWriteMode;
    procedure CheckSendKeyCode;
    procedure CheckReadMode;
    procedure CheckReadParams;
    procedure CheckWriteParams;
    procedure CheckWritePassword;
    procedure CheckZero;
    procedure CheckTare;
    procedure CheckWriteTareValue;
    procedure CheckReadStatus;
    procedure CheckWriteGraduationPoint;
    procedure CheckReadGraduationPoint;
    procedure CheckStartGraduation;
    procedure CheckStopGraduation;
    procedure CheckReadGraduationStatus;
    procedure CheckReadADC;
    procedure CheckReadKeyboardStatus;
    procedure CheckReadChannelCount;
    procedure CheckSelectChannel;
    procedure CheckEnableChannel;
    procedure CheckDisableChannel;
    procedure CheckReadChannel;
    procedure CheckWriteChannel;
    procedure CheckReadChannelNumber;
    procedure CheckResetChannel;
    procedure CheckReset;
    procedure CheckReadDeviceMetrics;
    procedure CheckGetErrorText;
    procedure CheckGetCommandText;
    procedure CheckGetFullErrorText;
    procedure CheckGetPointStatusText;
    procedure CheckTestGet;
    procedure CheckTestClr;
    procedure CheckWriteWare;
    procedure CheckReadFirmwareCRC;
    procedure CheckReadPowerReport;
  end;

implementation

const
  Timeout = 567;
  Password = 1;

{ TM5ScaleDeviceTest }

procedure TM5ScaleDeviceTest.Setup;
begin
  Connection := TMockScaleConnection.Create;
  Device := TM5ScaleDevice.Create(Connection);
  Device.CommandTimeout := Timeout;
  Device.Password := Password;
end;

procedure TM5ScaleDeviceTest.TearDown;
begin
  Device := nil;
  Connection.Free;
end;

procedure TM5ScaleDeviceTest.CheckDisableChannel;
begin
  Connection.Expects('Send').WithParams([Timeout, #$E7#01#00#00#00#00]).Returns(#$E7#00);
  CheckEquals(0, Device.DisableChannel, 'Device.DisableChannel');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$E7#01#00#00#00#00]).Returns(#$E7#$45);
  CheckEquals($45, Device.DisableChannel, 'Device.DisableChannel');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckEnableChannel;
begin
  Connection.Expects('Send').WithParams([Timeout, #$E7#01#00#00#00#01]).Returns(#$E7#00);
  CheckEquals(0, Device.EnableChannel, 'Device.EnableChannel');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$E7#01#00#00#00#01]).Returns(#$E7#$45);
  CheckEquals($45, Device.EnableChannel, 'Device.EnableChannel');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckGetCommandText;
begin
  CheckEquals(S_COMMAND_07h, Device.GetCommandText($07),
    'Device.GetCommandText($07)');
  CheckEquals(S_COMMAND_FCh, Device.GetCommandText($FC),
    'Device.GetCommandText($FC)');
  CheckEquals(S_COMMAND_UNKNOWN, Device.GetCommandText(0),
    'Device.GetCommandText(0)');
end;

procedure TM5ScaleDeviceTest.CheckGetErrorText;
begin
  CheckEquals(S_ERROR_00, Device.GetErrorText(0),
    'Device.GetErrorText(0)');
  CheckEquals(S_ERROR_17, Device.GetErrorText(17),
    'Device.GetErrorText(17)');
  CheckEquals(S_ERROR_UNKNOWN, Device.GetErrorText(190),
    'Device.GetErrorText(190)');
end;

procedure TM5ScaleDeviceTest.CheckGetFullErrorText;
begin
  CheckEquals('(0), ' + S_ERROR_00, Device.GetFullErrorText(0),
    'Device.GetFullErrorText(0)');
  CheckEquals('(17), ' + S_ERROR_17, Device.GetFullErrorText(17),
    'Device.GetFullErrorText(17)');
  CheckEquals('(190), ' + S_ERROR_UNKNOWN, Device.GetFullErrorText(190),
    'Device.GetFullErrorText(190)');
end;

procedure TM5ScaleDeviceTest.CheckGetPointStatusText;
begin
  CheckEquals(S_POINT_STATUS_0, Device.GetPointStatusText(0),
    'Device.GetPointStatusText(0)');
  CheckEquals(S_POINT_STATUS_1, Device.GetPointStatusText(1),
    'Device.GetPointStatusText(1)');
  CheckEquals(S_POINT_STATUS_UNKNOWN, Device.GetPointStatusText(10),
    'Device.GetPointStatusText(10)');
end;

procedure TM5ScaleDeviceTest.CheckLockKeyboard;
begin
  Connection.Expects('Send').WithParams([Timeout, #$09#01#00#00#00#01]).Returns(#$09#$00);
  CheckEquals(0, Device.LockKeyboard, 'Device.LockKeyboard');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$09#01#00#00#00#01]).Returns(#$09#$45);
  CheckEquals($45, Device.LockKeyboard, 'Device.LockKeyboard');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadADC;
var
  Value: Integer;
  Method: TMockMethod;
begin
  Method := Connection.Expects('Send');
  Method.WithParams([Timeout, #$75#01#00#00#00]);
  Method.Returns(#$75#$00#$01#$23#$45#$67);
  Method.ReturnsOutParams([$67452301]);
  CheckEquals(0, Device.ReadADC(Value), 'Device.ReadADC');
  CheckEquals($67452301, Value, 'ADC value');
  Connection.Verify('Verify');

  Method := Connection.Expects('Send');
  Method.WithParams([Timeout, #$75#01#00#00#00]);
  Method.Returns(#$75#$45);
  CheckEquals($45, Device.ReadADC(Value), 'Device.ReadADC');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadChannelCount;
var
  Count: Integer;
begin
  Connection.Expects('Send').WithParams([Timeout, #$E5#01#00#00#00]).Returns(#$E5#$00#$67);
  CheckEquals(0, Device.ReadChannelCount(Count), 'Device.ReadChannelCount');
  CheckEquals($67, Count, 'Count');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$E5#01#00#00#00]).Returns(#$E5#$67);
  CheckEquals($67, Device.ReadChannelCount(Count), 'Device.ReadChannelCount');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadChannelNumber;
var
  Count: Integer;
begin
  Connection.Expects('Send').WithParams([Timeout, #$EA]).Returns(#$EA#$00#$67);
  CheckEquals(0, Device.ReadChannelNumber(Count), 'Device.ReadChannelNumber');
  CheckEquals($67, Count, 'Count');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$EA]).Returns(#$EA#$67);
  CheckEquals($67, Device.ReadChannelNumber(Count), 'Device.ReadChannelNumber');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadDeviceMetrics;
var
  Data: TDeviceMetrics;
begin
  Connection.Expects('Send').WithParams([Timeout, #$FC]).Returns(
    #$FC#$00#$01#$02#$03#$04#$05#$06'Device name');
  CheckEquals(0, Device.ReadDeviceMetrics(Data), 'Device.ReadDeviceMetrics');
  CheckEquals(1, Data.MajorType, 'Data.MajorType');
  CheckEquals(2, Data.MinorType, 'Data.MinorType');
  CheckEquals(3, Data.MajorVersion, 'Data.MajorVersion');
  CheckEquals(4, Data.MinorVersion, 'Data.MinorVersion');
  CheckEquals(5, Data.Model, 'Data.Model');
  CheckEquals(6, Data.Language, 'Data.Language');
  CheckEquals('Device name', Data.Name, 'Data.Name');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$FC]).Returns(#$FC#$12);
  CheckEquals($12, Device.ReadDeviceMetrics(Data), 'Device.ReadDeviceMetrics');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadGraduationPoint;
var
  Data: TGraduationPoint;
begin
  Data.Number := 3;
  Connection.Expects('Send').WithParams([Timeout, #$71#$01#$00#$00#$00#$03]).
    Returns(#$71#$00#$05#$00#$00#$00);
  CheckEquals(0, Device.ReadGraduationPoint(Data), 'Device.ReadGraduationPoint');
  CheckEquals(5, Data.Weight, 'Data.Weight');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$71#$01#$00#$00#$00#$03]).
    Returns(#$71#$56);
  CheckEquals($56, Device.ReadGraduationPoint(Data), 'Device.ReadGraduationPoint');
  Connection.Verify('Verify');
end;

//     function ReadGraduationStatus(var R: TGraduationStatus): Integer;

procedure TM5ScaleDeviceTest.CheckReadGraduationStatus;
var
  Data: TGraduationStatus;
begin
  Connection.Expects('Send').WithParams([Timeout, #$73#$01#$00#$00#$00]).
    Returns(#$73#$00#$01#$02#$00#$03);
  CheckEquals(0, Device.ReadGraduationStatus(Data), 'ReadGraduationStatus');
  CheckEquals(1, Data.ChannelNumber, 'Data.ChannelNumber');
  CheckEquals(2, Data.PointNumber, 'Data.PointNumber');
  CheckEquals(3, Data.PointStatus, 'Data.PointStatus');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$73#$01#$00#$00#$00]).
    Returns(#$73#$56);
  CheckEquals($56, Device.ReadGraduationStatus(Data), 'ReadGraduationStatus');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadKeyboardStatus;
var
  Value: Integer;
begin
  Connection.Expects('Send').WithParams([Timeout, #$90#$01#$00#$00#$00]).
    Returns(#$90#$00#$56);
  CheckEquals(0, Device.ReadKeyboardStatus(Value), 'ReadKeyboardStatus');
  CheckEquals($56, Value, 'Value');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$90#$01#$00#$00#$00]).
    Returns(#$90#$56);
  CheckEquals($56, Device.ReadKeyboardStatus(Value), 'ReadKeyboardStatus');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadMode;
var
  Value: Integer;
begin
  Connection.Expects('Send').WithParams([Timeout, #$12#$01#$00#$00#$00]).
    Returns(#$12#$00#$56);
  CheckEquals(0, Device.ReadMode(Value), 'ReadMode');
  CheckEquals($56, Value, 'Value');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$12#$01#$00#$00#$00]).
    Returns(#$12#$56);
  CheckEquals($56, Device.ReadMode(Value), 'ReadMode');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadParams;
var
  Data: TM5Params;
begin
  Data.Port := 9;
  Connection.Expects('Send').WithParams([Timeout, #$15#$01#$00#$00#$00#$09]).
    Returns(#$15#$00#$56#$67);
  CheckEquals(0, Device.ReadParams(Data), 'ReadParams');
  CheckEquals($56, Data.BaudRate, 'Data.BaudRate');
  CheckEquals($67, Data.Timeout, 'Data.Timeout');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$15#$01#$00#$00#$00#$09]).
    Returns(#$15#$56);
  CheckEquals($56, Device.ReadParams(Data), 'ReadParams');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadStatus;
var
  Data: TM5Status;
begin
  Connection.Expects('Send').WithParams([Timeout, #$3A#$01#$00#$00#$00]).
    Returns(#$3A#$00#$01#$23#$01#$23#$45#$67#$01#$23);
  CheckEquals(0, Device.ReadStatus(Data), 'ReadStatus');
  CheckEquals($2301, Data.Flags.Value, 'Data.Flags.Value');
  CheckEquals($67452301, Data.Weight, 'Data.Weight');
  CheckEquals($2301, Data.Tare, 'Data.Tare');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$3A#$01#$00#$00#$00]).
    Returns(#$3A#$56);
  CheckEquals($56, Device.ReadStatus(Data), 'ReadStatus');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReset;
begin
  Connection.Expects('Send').WithParams([Timeout, #$F0#$01#$00#$00#$00]).
    Returns(#$F0#$00);
  CheckEquals(0, Device.Reset, 'Reset');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$F0#$01#$00#$00#$00]).
    Returns(#$F0#$56);
  CheckEquals($56, Device.Reset, 'Reset');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckResetChannel;
begin
  Connection.Expects('Send').WithParams([Timeout, #$EF#$01#$00#$00#$00]).
    Returns(#$EF#$00);
  CheckEquals(0, Device.ResetChannel, 'ResetChannel');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$EF#$01#$00#$00#$00]).
    Returns(#$EF#$56);
  CheckEquals($56, Device.ResetChannel, 'ResetChannel');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckSelectChannel;
begin
  Connection.Expects('Send').WithParams([Timeout, #$E6#$01#$00#$00#$00#$67]).
    Returns(#$E6#$00);
  CheckEquals(0, Device.SelectChannel($67), 'SelectChannel');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$E6#$01#$00#$00#$00#$67]).
    Returns(#$E6#$56);
  CheckEquals($56, Device.SelectChannel($67), 'SelectChannel');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckSendKeyCode;
begin
  Connection.Expects('Send').WithParams([Timeout, #$08#$01#$00#$00#$00#$67]).
    Returns(#$08#$00);
  CheckEquals(0, Device.SendKeyCode($67), 'SendKeyCode');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$08#$01#$00#$00#$00#$67]).
    Returns(#$08#$56);
  CheckEquals($56, Device.SendKeyCode($67), 'SendKeyCode');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWriteMode;
begin
  Connection.Expects('Send').WithParams([Timeout, #$07#$01#$00#$00#$00#$67]).
    Returns(#$07#$00);
  CheckEquals(0, Device.WriteMode($67), 'WriteMode');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$07#$01#$00#$00#$00#$67]).
    Returns(#$07#$56);
  CheckEquals($56, Device.WriteMode($67), 'WriteMode');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckStartGraduation;
begin
  Connection.Expects('Send').WithParams([Timeout, #$72#$01#$00#$00#$00]).
    Returns(#$72#$00);
  CheckEquals(0, Device.StartGraduation, 'StartGraduation');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$72#$01#$00#$00#$00]).
    Returns(#$72#$56);
  CheckEquals($56, Device.StartGraduation, 'StartGraduation');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckStopGraduation;
begin
  Connection.Expects('Send').WithParams([Timeout, #$74#$01#$00#$00#$00]).
    Returns(#$74#$00);
  CheckEquals(0, Device.StopGraduation, 'StopGraduation');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$74#$01#$00#$00#$00]).
    Returns(#$74#$56);
  CheckEquals($56, Device.StopGraduation, 'StopGraduation');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckTare;
begin
  Connection.Expects('Send').WithParams([Timeout, #$31#$01#$00#$00#$00]).
    Returns(#$31#$00);
  CheckEquals(0, Device.Tare, 'Tare');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$31#$01#$00#$00#$00]).
    Returns(#$31#$56);
  CheckEquals($56, Device.Tare, 'Tare');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWriteTareValue;
begin
  Connection.Expects('Send').WithParams([Timeout, #$32#$01#$00#$00#$00#$34#$12]).
    Returns(#$32#$00);
  CheckEquals(0, Device.WriteTareValue($1234), 'WriteTareValue');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$32#$01#$00#$00#$00#$34#$12]).
    Returns(#$32#$67);
  CheckEquals($67, Device.WriteTareValue($1234), 'WriteTareValue');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckUnlockKeyboard;
begin
  Connection.Expects('Send').WithParams([Timeout, #$09#$01#$00#$00#$00#$00]).
    Returns(#$09#$00);
  CheckEquals(0, Device.UnlockKeyboard, 'UnlockKeyboard');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$09#$01#$00#$00#$00#$00]).
    Returns(#$09#$56);
  CheckEquals($56, Device.UnlockKeyboard, 'UnlockKeyboard');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWriteChannel;
var
  TxData: string;
  Data: TScaleChannel;
begin
  Data.Number := 1;
  Data.Flags := 2;
  Data.DecimalPoint := 3;
  Data.Power := 4;
  Data.MaxWeight := 5;
  Data.MinWeight := 6;
  Data.MaxTare := 7;
  Data.Range1 := 8;
  Data.Range2 := 9;
  Data.Range3 := 10;
  Data.Discreteness1 := 11;
  Data.Discreteness2 := 12;
  Data.Discreteness3 := 13;
  Data.Discreteness4 := 14;
  Data.PointCount := 15;
  Data.CalibrationsCount := 16;

  TxData := HexToStr(
    'E9 01 00 00 00 01 02 00 03 04 05 00 06 00 07 00 08 00 09 00 0A 00 0B 0C 0D 0E 0F 10');
  Connection.Expects('Send').WithParams([Timeout, TxData]).Returns(#$E9#$00);
  CheckEquals(0, Device.WriteChannel(Data), 'WriteChannel');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, TxData]).Returns(#$E9#$56);
  CheckEquals($56, Device.WriteChannel(Data), 'WriteChannel');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWriteGraduationPoint;
var
  P: TGraduationPoint;
begin
  P.Number := $12;
  P.Weight := $3456;
  Connection.Expects('Send').WithParams([Timeout, #$70#$01#$00#$00#$00#$12#$56#$34]).
    Returns(#$70#$00);
  CheckEquals(0, Device.WriteGraduationPoint(P), 'WriteGraduationPoint');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$70#$01#$00#$00#$00#$12#$56#$34]).
    Returns(#$70#$67);
  CheckEquals($67, Device.WriteGraduationPoint(P), 'WriteGraduationPoint');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWriteParams;
var
  P: TM5Params;
begin
  P.Port := $12;
  P.BaudRate := $34;
  P.Timeout := $56;
  Connection.Expects('Send').WithParams([Timeout, #$14#$01#$00#$00#$00#$12#$34#$56]).
    Returns(#$14#$00);
  CheckEquals(0, Device.WriteParams(P), 'WriteParams');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout, #$14#$01#$00#$00#$00#$12#$34#$56]).
    Returns(#$14#$56);
  CheckEquals($56, Device.WriteParams(P), 'WriteParams');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWritePassword;
begin
  Connection.Expects('Send').WithParams([Timeout,
    #$16#$01#$00#$00#$00#$12#$34#$56#$78]).Returns(#$16#$00);
  CheckEquals(0, Device.WritePassword($78563412), 'WritePassword');
  // Password must be changed
  CheckEquals($78563412, Device.Password, 'Device.Password');
  Connection.Verify('Verify');

  Device.Password := 1;
  Connection.Expects('Send').WithParams([Timeout,
    #$16#$01#$00#$00#$00#$12#$34#$56#$78]).Returns(#$16#$56);
  CheckEquals($56, Device.WritePassword($78563412), 'WritePassword');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckZero;
begin
  Connection.Expects('Send').WithParams([Timeout,
    #$30#$01#$00#$00#$00]).Returns(#$30#$00);
  CheckEquals(0, Device.Zero, 'Zero');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout,
    #$30#$01#$00#$00#$00]).Returns(#$30#$56);
  CheckEquals($56, Device.Zero, 'Zero');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadChannel;
var
  RxData: string;
  Data: TScaleChannel;
begin
  Data.Number := $67;
  RxData :=
    'E8 00 01 00 02 03 04 00 05 00 06 00 07 00 08 00 09 00 0A 0B 0C 0D 0E 0F';
  RxData := HexToStr(RxData);

  Connection.Expects('Send').WithParams([Timeout, #$E8#$67]).Returns(RxData);
  CheckEquals(0, Device.ReadChannel(Data), 'ReadChannel');
  Connection.Verify('Verify');

  CheckEquals(1, Data.Flags, 'Data.Flags');
  CheckEquals(2, Data.DecimalPoint, 'Data.DecimalPoint');
  CheckEquals(3, Data.Power, 'Data.Power');
  CheckEquals(4, Data.MaxWeight, 'Data.MaxWeight');
  CheckEquals(5, Data.MinWeight, 'Data.MinWeight');
  CheckEquals(6, Data.MaxTare, 'Data.Tare');
  CheckEquals(7, Data.Range1, 'Data.Range1');
  CheckEquals(8, Data.Range2, 'Data.Range2');
  CheckEquals(9, Data.Range3, 'Data.Range3');
  CheckEquals(10, Data.Discreteness1, 'Data.Discreteness1');
  CheckEquals(11, Data.Discreteness2, 'Data.Discreteness2');
  CheckEquals(12, Data.Discreteness3, 'Data.Discreteness3');
  CheckEquals(13, Data.Discreteness4, 'Data.Discreteness4');
  CheckEquals(14, Data.PointCount, 'Data.PointCount');
  CheckEquals(15, Data.CalibrationsCount, 'Data.CalibrationsCount');
end;

procedure TM5ScaleDeviceTest.CheckTestGet;
var
  R: string;
const
  Data = '83746587346';
begin
  Connection.Expects('Send').WithParams([Timeout,
    #$F1]).Returns(#$F1#$00 + Data);
  CheckEquals(0, Device.TestGet(R), 'TestGet');
  CheckEquals(R, Data, 'TestGet result');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckTestClr;
begin
  Connection.Expects('Send').WithParams([Timeout,
    #$F8]).Returns(#$F8#$00);
  CheckEquals(0, Device.TestClr, 'TestClr');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout,
    #$F8]).Returns(#$F8#$56);
  CheckEquals($56, Device.TestClr, 'TestClr');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckWriteWare;
var
  P: TM5WareItem;
begin
  P.ItemType := 1;
  P.Quantity := 2;
  P.Price := 3;
  Connection.Expects('Send').WithParams([Timeout,
    #$33#$01#$00#$00#$00#$01#$02#$03#$00#$00]).Returns(#$33#$00);
  CheckEquals(0, Device.WriteWare(P), 'WriteWare');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout,
    #$33#$01#$00#$00#$00#$01#$02#$03#$00#$00]).Returns(#$33#$67);
  CheckEquals($67, Device.WriteWare(P), 'WriteWare');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadFirmwareCRC;
var
  R: Integer;
begin
  Connection.Expects('Send').WithParams([Timeout,
    #$F2]).Returns(#$F2#$00#$34#$12);
  CheckEquals(0, Device.ReadFirmwareCRC(R), 'ReadFirmwareCRC');
  CheckEquals($1234, R, 'ReadFirmwareCRC');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout,
    #$F2]).Returns(#$F2#$12);
  CheckEquals($12, Device.ReadFirmwareCRC(R), 'ReadFirmwareCRC');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckReadPowerReport;
var
  R: TM5PowerReport;
begin
  Connection.Expects('Send').WithParams([Timeout,
    #$F3#$01#$00#$00#$00]).Returns(#$F3#$00#$34#$12#$78#$56#$57#$16#$12#$34);
  CheckEquals(0, Device.ReadPowerReport(R), 'ReadPowerReport');
  CheckEquals($1234, R.Voltage5, 'R.Voltage5');
  CheckEquals($5678, R.Voltage12, 'R.Voltage12');
  CheckEquals($1657, R.VoltageX, 'R.VoltageX');
  CheckEquals($12, R.VoltageFlags, 'R.VoltageFlags');
  CheckEquals($34, R.VoltageX1, 'R.VoltageX1');
  Connection.Verify('Verify');

  Connection.Expects('Send').WithParams([Timeout,
    #$F3#$01#$00#$00#$00]).Returns(#$F3#$34);
  CheckEquals($34, Device.ReadPowerReport(R), 'ReadPowerReport');
  Connection.Verify('Verify');
end;

procedure TM5ScaleDeviceTest.CheckDecodeFlags;
begin
  { !!! }
end;

initialization
  RegisterTest('', TM5ScaleDeviceTest.Suite);

end.
