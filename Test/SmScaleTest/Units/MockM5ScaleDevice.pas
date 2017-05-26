unit MockM5ScaleDevice;

interface

uses
  // VCL
  SysUtils,
  // Mock
  PascalMock,
  // This
  M5ScaleTypes;

type
  { TMockM5scaleDevice }

  TMockM5scaleDevice = class(TMock, IM5scaleDevice)
  private
    FPassword: Integer;
    FCommandTimeout: Integer;
  public
    function LockKeyboard: Integer;
    function UnlockKeyboard: Integer;
    function WriteMode(Mode: Integer): Integer;
    function SendKeyCode(Code: Integer): Integer;
    function ReadMode(var Mode: Integer): Integer;
    function ReadParams(var P: TM5Params): Integer;
    function WriteParams(const P: TM5Params): Integer;
    function WritePassword(const NewPassword: Integer): Integer;
    function Zero: Integer;
    function Tare: Integer;
    function WriteTareValue(Value: Integer): Integer;
    function ReadStatus(var R: TM5Status): Integer;
    function WriteGraduationPoint(const P: TGraduationPoint): Integer;
    function ReadGraduationPoint(var R: TGraduationPoint): Integer;
    function StartGraduation: Integer;
    function StopGraduation: Integer;
    function ReadGraduationStatus(var R: TGraduationStatus): Integer;
    function ReadADC(var R: Integer): Integer;
    function ReadKeyboardStatus(var R: Integer): Integer;
    function ReadChannelCount(var Count: Integer): Integer;
    function SelectChannel(const Number: Integer): Integer;
    function EnableChannel: Integer;
    function DisableChannel: Integer;
    function ReadChannel(var R: TScaleChannel): Integer;
    function WriteChannel(const R: TScaleChannel): Integer;
    function ReadChannelNumber(var Number: Integer): Integer;
    function ResetChannel: Integer;
    function Reset: Integer;
    function ReadDeviceMetrics(var R: TDeviceMetrics): Integer;

    function GetErrorText(Code: Integer): string;
    function GetCommandText(Code: Integer): string;
    function GetFullErrorText(Code: Integer): string;
    function GetPointStatusText(Code: Integer): string;
    procedure Check(Code: Integer);
    function GetCommandTimeout: Integer;
    procedure SetCommandTimeout(const Value: Integer);
    function GetPassword: Integer;
    procedure SetPassword(const Value: Integer);
    function WriteWare(const P: TM5WareItem): Integer;
    function ReadFirmwareCRC(var R: Integer): Integer;
    function ReadPowerReport(var R: TM5PowerReport): Integer;
    function TestGet(var R: string): Integer;
    function TestClr: Integer;
    function ReadStatus2(var R: TM5Status2): Integer;
    function SendCommand(const Command: string; var Answer: string): Integer;
    function HandleException(E: Exception): Integer;
    function GetResultCode: Integer;
    function GetResultText: WideString;
    function ClearResult: Integer;
    function GetModeText(Mode: Integer): WideString;
    function GetLanguageText(Code: Integer): WideString;
    function GetBaudRates: TBaudRates;

    property Password: Integer read GetPassword write SetPassword;
    property CommandTimeout: Integer read GetCommandTimeout write SetCommandTimeout;
  end;

implementation

{ TMockM5scaleDevice }

procedure TMockM5scaleDevice.Check(Code: Integer);
begin
  AddCall('Check').WithParams([Code]);
end;

function TMockM5scaleDevice.DisableChannel: Integer;
begin
  Result := AddCall('DisableChannel').ReturnValue;
end;

function TMockM5scaleDevice.EnableChannel: Integer;
begin
  Result := AddCall('EnableChannel').ReturnValue;
end;

function TMockM5scaleDevice.GetCommandText(Code: Integer): string;
begin
  Result := AddCall('GetCommandText').WithParams([Code]).ReturnValue;
end;

function TMockM5scaleDevice.GetErrorText(Code: Integer): string;
begin
  Result := AddCall('GetErrorText').WithParams([Code]).ReturnValue;
end;

function TMockM5scaleDevice.GetFullErrorText(Code: Integer): string;
begin
  Result := AddCall('GetFullErrorText').WithParams([Code]).ReturnValue;
end;

function TMockM5scaleDevice.GetPointStatusText(Code: Integer): string;
begin
  Result := AddCall('GetPointStatusText').WithParams([Code]).ReturnValue;
end;

function TMockM5scaleDevice.LockKeyboard: Integer;
begin
  Result := AddCall('LockKeyboard').ReturnValue;
end;

function TMockM5scaleDevice.ReadADC(var R: Integer): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadADC');
  Result := Method.ReturnValue;
  R := Method.OutParams[0];
end;

function TMockM5scaleDevice.ReadChannel(var R: TScaleChannel): Integer;
begin
  Result := AddCall('ReadChannel').WithParams([R.Number]).ReturnValue;
end;

function TMockM5scaleDevice.ReadChannelCount(var Count: Integer): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadChannelCount');
  Result := Method.ReturnValue;
  Count := Method.OutParams[0];
end;

function TMockM5scaleDevice.ReadChannelNumber(
  var Number: Integer): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadChannelNumber');
  Result := Method.ReturnValue;
  Number := Method.OutParams[0];
end;

function TMockM5scaleDevice.ReadDeviceMetrics(
  var R: TDeviceMetrics): Integer;
begin
  Result := AddCall('ReadDeviceMetrics').ReturnValue;
end;

function TMockM5scaleDevice.ReadGraduationPoint(
  var R: TGraduationPoint): Integer;
begin
  Result := AddCall('ReadGraduationPoint').ReturnValue;
end;

function TMockM5scaleDevice.ReadGraduationStatus(
  var R: TGraduationStatus): Integer;
begin
  Result := AddCall('ReadGraduationStatus').ReturnValue;
end;

function TMockM5scaleDevice.ReadKeyboardStatus(var R: Integer): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadKeyboardStatus');
  Result := Method.ReturnValue;
  R := Method.OutParams[0];
end;

function TMockM5scaleDevice.ReadMode(var Mode: Integer): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadMode');
  Result := Method.ReturnValue;
  Mode := Method.OutParams[0];
end;

function TMockM5scaleDevice.ReadParams(var P: TM5Params): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadParams');
  Result := Method.ReturnValue;
  P.Port := Method.OutParams[0];
  P.BaudRate := Method.OutParams[1];
  P.Timeout := Method.OutParams[2];
end;

function TMockM5scaleDevice.ReadStatus(var R: TM5Status): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadStatus');
  Result := Method.ReturnValue;
  //R.Flags := Method.OutParams[0]; { !!! }
  R.Weight := Method.OutParams[1];
  R.Tare := Method.OutParams[2];
end;

function TMockM5scaleDevice.Reset: Integer;
begin
  Result := AddCall('Reset').ReturnValue;
end;

function TMockM5scaleDevice.ResetChannel: Integer;
begin
  Result := AddCall('ResetChannel').ReturnValue;
end;

function TMockM5scaleDevice.SelectChannel(const Number: Integer): Integer;
begin
  Result := AddCall('SelectChannel').WithParams([Number]).ReturnValue;
end;

function TMockM5scaleDevice.SendKeyCode(Code: Integer): Integer;
begin
  Result := AddCall('SendKeyCode').WithParams([Code]).ReturnValue;
end;

function TMockM5scaleDevice.WriteMode(Mode: Integer): Integer;
begin
  Result := AddCall('WriteMode').WithParams([Mode]).ReturnValue;
end;

function TMockM5scaleDevice.StartGraduation: Integer;
begin
  Result := AddCall('StartGraduation').ReturnValue;
end;

function TMockM5scaleDevice.StopGraduation: Integer;
begin
  Result := AddCall('StopGraduation').ReturnValue;
end;

function TMockM5scaleDevice.Tare: Integer;
begin
  Result := AddCall('Tare').ReturnValue;
end;

function TMockM5scaleDevice.WriteTareValue(Value: Integer): Integer;
begin
  Result := AddCall('WriteTareValue').WithParams([Value]).ReturnValue;
end;

function TMockM5scaleDevice.UnlockKeyboard: Integer;
begin
  Result := AddCall('UnlockKeyboard').ReturnValue;
end;

function TMockM5scaleDevice.WriteChannel(const R: TScaleChannel): Integer;
begin
  Result := AddCall('WriteChannel').WithParams([@R]).ReturnValue;
end;

function TMockM5scaleDevice.WriteGraduationPoint(
  const P: TGraduationPoint): Integer;
begin
  Result := AddCall('WriteGraduationPoint').WithParams([@P]).ReturnValue;
end;

function TMockM5scaleDevice.WriteParams(const P: TM5Params): Integer;
begin
  Result := AddCall('WriteParams').WithParams([@P]).ReturnValue;
end;

function TMockM5scaleDevice.WritePassword(
  const NewPassword: Integer): Integer;
begin
  Result := AddCall('WritePassword').WithParams([NewPassword]).ReturnValue;
end;

function TMockM5scaleDevice.Zero: Integer;
begin
  Result := AddCall('Zero').ReturnValue;
end;

function TMockM5scaleDevice.GetCommandTimeout: Integer;
begin
  Result := FCommandTimeout;
end;

procedure TMockM5scaleDevice.SetCommandTimeout(const Value: Integer);
begin
  FCommandTimeout := Value;
end;

function TMockM5scaleDevice.GetPassword: Integer;
begin
  Result := FPassword;
end;

procedure TMockM5scaleDevice.SetPassword(const Value: Integer);
begin
  FPassword := Value;
end;

function TMockM5scaleDevice.WriteWare(const P: TM5WareItem): Integer;
begin
  Result := AddCall('WriteWare').WithParams([P.ItemType, P.Quantity, P.Price]).ReturnValue;
end;

function TMockM5scaleDevice.ReadFirmwareCRC(var R: Integer): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadFirmwareCRC');
  R := Method.OutParams[0];
  Result := Method.ReturnValue;
end;

function TMockM5scaleDevice.ReadPowerReport(var R: TM5PowerReport): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('ReadFirmwareCRC');
  R.Voltage5 := Method.OutParams[0];
  R.Voltage12 := Method.OutParams[1];
  R.VoltageX := Method.OutParams[2];
  R.VoltageFlags := Method.OutParams[3];
  R.VoltageX1 := Method.OutParams[4];
  Result := Method.ReturnValue;
end;

function TMockM5scaleDevice.TestGet(var R: string): Integer;
var
  Method: TMockMethod;
begin
  Method := AddCall('TestGet');
  R := Method.OutParams[0];
  Result := Method.ReturnValue;
end;

function TMockM5scaleDevice.TestClr: Integer;
begin
  Result := AddCall('TestClr').ReturnValue;
end;

function TMockM5scaleDevice.ReadStatus2(var R: TM5Status2): Integer;
begin
  Result := AddCall('ReadStatus2').WithParams([@R]).ReturnValue;
end;

function TMockM5scaleDevice.SendCommand(const Command: string;
  var Answer: string): Integer;
begin
  Result := 0;
end;

function TMockM5scaleDevice.ClearResult: Integer;
begin
  Result := 0;
end;

function TMockM5scaleDevice.GetModeText(Mode: Integer): WideString;
begin
  Result := '';
end;

function TMockM5scaleDevice.GetResultCode: Integer;
begin
  Result := 0;
end;

function TMockM5scaleDevice.GetResultText: WideString;
begin
  Result := '';
end;

function TMockM5scaleDevice.HandleException(E: Exception): Integer;
begin
  Result := 0;
end;

function TMockM5scaleDevice.GetLanguageText(Code: Integer): WideString;
begin
  Result := '';
end;

function TMockM5scaleDevice.GetBaudRates: TBaudRates;
begin
  Result := M5BaudRates;
end;

end.
