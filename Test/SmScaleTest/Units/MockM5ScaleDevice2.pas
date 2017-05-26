unit MockM5ScaleDevice2;

interface

uses
  // VCL
  SysUtils,
  // This
  M5ScaleTypes, DriverError;

type
  { TMockM5ScaleDevice2 }

  TMockM5ScaleDevice2 = class(TInterfacedObject, IM5scaleDevice)
  private
    FPassword: Integer;
    FCommandTimeout: Integer;
  public
    Status: TM5Status;
    Status2: TM5Status2;
    ADCValue: Integer;
    ScaleMode: Integer;
    ResultCode: Integer;
    ResultText: WideString;
    ChannelCount: Integer;
    ChannelNumber: Integer;
    KeyboardStatus: Integer;
    ScaleParams: TM5Params;
    ScaleChannel: TScaleChannel;
    DeviceMetrics: TDeviceMetrics;
    GraduationPoint: TGraduationPoint;
    GraduationStatus: TGraduationStatus;
    WareItem: TM5WareItem;
    RxData: string;
    TxData: string;

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
    function GetCommandTimeout: Integer;
    function GetPassword: Integer;
    procedure Check(Code: Integer);
    procedure SetPassword(const Value: Integer);
    procedure SetCommandTimeout(const Value: Integer);
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

{ TMockM5ScaleDevice2 }

procedure TMockM5ScaleDevice2.Check(Code: Integer);
begin
  if Code <> 0 then
    RaiseError(Code, IntToStr(Code));
end;

function TMockM5ScaleDevice2.DisableChannel: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.EnableChannel: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.GetCommandText(Code: Integer): string;
begin
  Result := '';
end;

function TMockM5ScaleDevice2.GetCommandTimeout: Integer;
begin
  Result := FCommandTimeout;
end;

function TMockM5ScaleDevice2.GetErrorText(Code: Integer): string;
begin
  Result := '';
end;

function TMockM5ScaleDevice2.GetFullErrorText(Code: Integer): string;
begin
  Result := '';
end;

function TMockM5ScaleDevice2.GetPassword: Integer;
begin
  Result := FPassword;
end;

function TMockM5ScaleDevice2.GetPointStatusText(Code: Integer): string;
begin
  Result := '';
end;

function TMockM5ScaleDevice2.LockKeyboard: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadADC(var R: Integer): Integer;
begin
  R := ADCValue;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadChannel(var R: TScaleChannel): Integer;
begin
  R := ScaleChannel;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadChannelCount(var Count: Integer): Integer;
begin
  Count := ChannelCount;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadChannelNumber(
  var Number: Integer): Integer;
begin
  Number := ChannelNumber;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadDeviceMetrics(
  var R: TDeviceMetrics): Integer;
begin
  R := DeviceMetrics;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadGraduationPoint(
  var R: TGraduationPoint): Integer;
begin
  R := GraduationPoint;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadGraduationStatus(
  var R: TGraduationStatus): Integer;
begin
  R := GraduationStatus;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadKeyboardStatus(var R: Integer): Integer;
begin
  R := KeyboardStatus;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadMode(var Mode: Integer): Integer;
begin
  Mode := ScaleMode;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadParams(var P: TM5Params): Integer;
begin
  P := ScaleParams;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadStatus(var R: TM5Status): Integer;
begin
  R := Status;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.Reset: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ResetChannel: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.SelectChannel(const Number: Integer): Integer;
begin
  ChannelNumber := Number;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.SendKeyCode(Code: Integer): Integer;
begin
  Result := ResultCode;
end;

procedure TMockM5ScaleDevice2.SetCommandTimeout(const Value: Integer);
begin
  FCommandTimeout := Value;
end;

function TMockM5ScaleDevice2.WriteMode(Mode: Integer): Integer;
begin
  ScaleMode := Mode;
  Result := ResultCode;
end;

procedure TMockM5ScaleDevice2.SetPassword(const Value: Integer);
begin
  FPassword := Value;
end;

function TMockM5ScaleDevice2.StartGraduation: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.StopGraduation: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.Tare: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.WriteTareValue(Value: Integer): Integer;
begin
  Status2.Tare := Value;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.UnlockKeyboard: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.WriteChannel(const R: TScaleChannel): Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.WriteGraduationPoint(
  const P: TGraduationPoint): Integer;
begin
  GraduationPoint := P;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.WriteParams(const P: TM5Params): Integer;
begin
  ScaleParams := P;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.WritePassword(
  const NewPassword: Integer): Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.Zero: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.WriteWare(const P: TM5WareItem): Integer;
begin
  WareItem := P;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadFirmwareCRC(var R: Integer): Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadPowerReport(var R: TM5PowerReport): Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.TestGet(var R: string): Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.TestClr: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ReadStatus2(var R: TM5Status2): Integer;
begin
  R := Status2;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.SendCommand(
  const Command: string;
  var Answer: string): Integer;
begin
  TxData := Command;
  Answer := RxData;
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.ClearResult: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.GetModeText(Mode: Integer): WideString;
begin
  Result := '';
end;

function TMockM5ScaleDevice2.GetResultCode: Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.GetResultText: WideString;
begin
  Result := ResultText;
end;

function TMockM5ScaleDevice2.HandleException(E: Exception): Integer;
begin
  Result := ResultCode;
end;

function TMockM5ScaleDevice2.GetLanguageText(Code: Integer): WideString;
begin
  Result := '';
end;

function TMockM5ScaleDevice2.GetBaudRates: TBaudRates;
begin
  Result := M5BaudRates;
end;

end.
