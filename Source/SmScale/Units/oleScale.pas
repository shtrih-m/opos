unit oleScale;

interface

uses
  // VCL
  Windows, ComObj, ActiveX, StdVcl, ComServ, SysUtils, Classes, Graphics,
  SyncObjs,
  // Opos
  Opos, Oposhi, OposScal, OposScalhi, OposScalUtils,
  // This
  SmScale_TLB, ScaleDriver, LogFile, TextEncoding;

type
  { ToleScale }

  ToleScale = class(TAutoObject, IScale)
  private
    FDriver: TScaleDriver;
    FLock: TCriticalSection;

    procedure Lock;
    procedure Unlock;
    function GetLogger: TLogFile;
    function GetDriver: TScaleDriver;
    function GetLock: TCriticalSection;
    function EncodeString(const Text: string): WideString;
    function DecodeString(const Text: WideString): string;

    property Logger: TLogFile read GetLogger; 
    property Driver: TScaleDriver read GetDriver;
  public
    function CheckHealth(Level: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearInput: Integer; safecall;
    function ClearOutput: Integer; safecall;
    function CloseService: Integer; safecall;
    function COFreezeEvents(Freeze: WordBool): Integer; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function DisplayText(const Data: WideString): Integer; safecall;
    function GetPropertyNumber(PropIndex: Integer): Integer; safecall;
    function GetPropertyString(PropIndex: Integer): WideString; safecall;
    function GetSalesPrice: Currency; safecall;
    function GetUnitPrice: Currency; safecall;
    function OpenService(const DeviceClass: WideString; const DeviceName: WideString;
                         const pDispatch: IDispatch): Integer; safecall;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); safecall;
    procedure SetPropertyString(PropIndex: Integer; const Text: WideString); safecall;
    procedure SetUnitPrice(Value: Currency); safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function ZeroScale: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    property OpenResult: Integer read Get_OpenResult;
  public
    destructor Destroy; override;
    procedure Initialize; override;
  end;

implementation

{ ToleScale }

procedure ToleScale.Initialize;
begin
  inherited Initialize;
  FDriver := TScaleDriver.Create;
end;

destructor ToleScale.Destroy;
begin
  CloseService;
  FDriver.Free;
  inherited Destroy;
end;

function ToleScale.GetLogger: TLogFile;
begin
  Result := Driver.Logger;
end;

function ToleScale.DecodeString(const Text: WideString): string;
begin
  Result := DecodeText(Driver.Parameters.Encoding, Text);
end;

function ToleScale.EncodeString(const Text: string): WideString;
begin
  Result := EncodeText(Driver.Parameters.Encoding, Text);
end;

function ToleScale.GetDriver: TScaleDriver;
begin
  if FDriver = nil then
    FDriver := TScaleDriver.Create;
  Result := FDriver;
end;

function ToleScale.GetLock: TCriticalSection;
begin
  if FLock = nil then
    FLock := TCriticalSection.Create;
  Result := FLock;
end;

procedure ToleScale.Lock;
begin
  GetLock.Enter;
end;

procedure ToleScale.Unlock;
begin
  GetLock.Leave;
end;

// Common

function ToleScale.CheckHealth(Level: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.CheckHealth', [Level]);
  Result := Driver.CheckHealth(Level);
  Logger.Debug('ToleScale.CheckHealth', [Level], Result);
  Unlock;
end;

function ToleScale.ClaimDevice(Timeout: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.ClaimDevice', [Timeout]);
  Result := Driver.ClaimDevice(Timeout);
  Logger.Debug('ToleScale.ClaimDevice', [Timeout], Result);
  Unlock;
end;

function ToleScale.ClearInput: Integer;
begin
  Lock;
  Logger.Debug('ToleScale.ClearInput');
  Result := Driver.ClearInput;
  Logger.Debug('ToleScale.ClearInput', [], Result);
  Unlock;
end;

function ToleScale.ClearOutput: Integer;
begin
  Lock;
  Logger.Debug('ToleScale.ClearOutput');
  Result := Driver.ClearOutput;
  Logger.Debug('ToleScale.ClearOutput', Result);
  Unlock;
end;

function ToleScale.CloseService: Integer;
begin
  Lock;
  Logger.Debug('ToleScale.CloseService');
  Result := Driver.CloseService;
  Logger.Debug('ToleScale.CloseService', Result);
  Unlock;
end;

function ToleScale.COFreezeEvents(Freeze: WordBool): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.COFreezeEvents', [Freeze]);
  Result := Driver.COFreezeEvents(Freeze);
  Logger.Debug('ToleScale.COFreezeEvents', [Freeze], Result);
  Unlock;
end;

function ToleScale.CompareFirmwareVersion(
  const FirmwareFileName: WideString;
  out pResult: Integer): Integer;
var
  AFirmwareFileName: string;
begin
  Lock;
  AFirmwareFileName := DecodeString(FirmwareFileName);
  Logger.Debug('ToleScale.CompareFirmwareVersion', [AFirmwareFileName, pResult]);
  Result := Driver.CompareFirmwareVersion(AFirmwareFileName, pResult);
  Logger.Debug('ToleScale.CompareFirmwareVersion', [AFirmwareFileName, pResult], Result);
  Unlock;
end;

function ToleScale.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.DirectIO', [Command, pData, pString]);
  Result := Driver.DirectIO(Command, pData, pString);
  Logger.Debug('ToleScale.DirectIO', [Command, pData, pString], Result);
  Unlock;
end;

function ToleScale.Get_OpenResult: Integer;
begin
  Lock;
  Logger.Debug('ToleScale.Get_OpenResult');
  Result := Driver.Get_OpenResult;
  Logger.Debug('ToleScale.Get_OpenResult', [], Result);
  Unlock;
end;

function ToleScale.GetPropertyNumber(PropIndex: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.GetPropertyNumber', [
    GetScalePropertyName(PropIndex)]);
  Result := Driver.GetPropertyNumber(PropIndex);
  Logger.Debug('ToleScale.GetPropertyNumber', [
    GetScalePropertyName(PropIndex)], Result);
  Unlock;
end;

function ToleScale.GetPropertyString(PropIndex: Integer): WideString;
begin
  Lock;
  Logger.Debug('ToleScale.GetPropertyString', [
    GetScalePropertyName(PropIndex)]);
  Result := Driver.GetPropertyString(PropIndex);
  Result := EncodeString(Result);
  Logger.Debug('ToleScale.GetPropertyString', [
    GetScalePropertyName(PropIndex)], Result);
  Unlock;
end;

function ToleScale.OpenService(const DeviceClass, DeviceName: WideString;
  const pDispatch: IDispatch): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.OpenService', [DeviceClass, DeviceName]);
  Result := Driver.OpenService(DeviceClass, DeviceName, pDispatch);
  Logger.Debug('ToleScale.OpenService', [DeviceClass, DeviceName], Result);
  Unlock;
end;

function ToleScale.ReleaseDevice: Integer;
begin
  Lock;
  Logger.Debug('ToleScale.ReleaseDevice');
  Result := Driver.ReleaseDevice;
  Logger.Debug('ToleScale.ReleaseDevice', Result);
  Unlock;
end;

function ToleScale.ResetStatistics(
  const StatisticsBuffer: WideString): Integer;
var
  AStatisticsBuffer: string;
begin
  Lock;
  AStatisticsBuffer := DecodeString(StatisticsBuffer);
  Logger.Debug('ToleScale.ResetStatistics', [AStatisticsBuffer]);
  Result := Driver.ResetStatistics(AStatisticsBuffer);
  Logger.Debug('ToleScale.ResetStatistics', [AStatisticsBuffer], Result);
  Unlock;
end;

function ToleScale.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.RetrieveStatistics', [pStatisticsBuffer]);
  Result := Driver.RetrieveStatistics(pStatisticsBuffer);
  pStatisticsBuffer := EncodeString(pStatisticsBuffer);
  Logger.Debug('ToleScale.RetrieveStatistics', [pStatisticsBuffer], Result);
  Unlock;
end;

procedure ToleScale.SetPropertyNumber(PropIndex, Number: Integer);
begin
  Lock;
  Logger.Debug('ToleScale.SetPropertyNumber', [
    GetScalePropertyName(PropIndex), Number]);
  Driver.SetPropertyNumber(PropIndex, Number);
  Logger.Debug('ToleScale.SetPropertyNumber', [], 'OK');
  Unlock;
end;

procedure ToleScale.SetPropertyString(PropIndex: Integer;
  const Text: WideString);
var
  AText: WideString;
begin
  Lock;
  AText := DecodeString(Text);
  Logger.Debug('ToleScale.SetPropertyString', [
    GetScalePropertyName(PropIndex), AText]);
  Driver.SetPropertyString(PropIndex, AText);
  Logger.Debug('ToleScale.SetPropertyString', [], 'OK');
  Unlock;
end;

function ToleScale.UpdateFirmware(
  const FirmwareFileName: WideString): Integer;
var
  AFirmwareFileName: string;
begin
  Lock;
  AFirmwareFileName := DecodeString(FirmwareFileName);
  Logger.Debug('ToleScale.UpdateFirmware', [AFirmwareFileName]);
  Result := Driver.UpdateFirmware(AFirmwareFileName);
  Logger.Debug('ToleScale.UpdateFirmware', [AFirmwareFileName], Result);
  Unlock;
end;

function ToleScale.UpdateStatistics(
  const StatisticsBuffer: WideString): Integer;
var
  AStatisticsBuffer: string;
begin
  Lock;
  AStatisticsBuffer := DecodeString(StatisticsBuffer);
  Logger.Debug('ToleScale.UpdateStatistics', [AStatisticsBuffer]);
  Result := Driver.UpdateStatistics(AStatisticsBuffer);
  Logger.Debug('ToleScale.UpdateStatistics', [AStatisticsBuffer], Result);
  Unlock;
end;

// Specific

function ToleScale.DisplayText(const Data: WideString): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.DisplayText', [Data]);
  Result := Driver.DisplayText(Data);
  Logger.Debug('ToleScale.DisplayText', [Data], Result);
  Unlock;
end;


function ToleScale.ZeroScale: Integer;
begin
  Lock;
  Logger.Debug('ToleScale.ZeroScale');
  Result := Driver.ZeroScale;
  Logger.Debug('ToleScale.ZeroScale', [], Result);
  Unlock;
end;

function ToleScale.ReadWeight(out pWeightData: Integer;
  Timeout: Integer): Integer;
begin
  Lock;
  Logger.Debug('ToleScale.ReadWeight', [Timeout]);
  Result := Driver.ReadWeight(pWeightData, Timeout);
  Logger.Debug('ToleScale.ReadWeight', [Timeout, pWeightData], Result);
  Unlock;
end;

function ToleScale.GetSalesPrice: Currency;
begin
  Lock;
  Logger.Debug('ToleScale.GetSalesPrice');
  Result := Driver.GetSalesPrice;
  Logger.Debug('ToleScale.GetSalesPrice', [], Result);
  Unlock;
end;

function ToleScale.GetUnitPrice: Currency;
begin
  Lock;
  Logger.Debug('ToleScale.GetUnitPrice');
  Result := Driver.GetUnitPrice;
  Logger.Debug('ToleScale.GetUnitPrice', [], Result);
  Unlock;
end;

procedure ToleScale.SetUnitPrice(Value: Currency);
begin
  Lock;
  Logger.Debug('ToleScale.SetUnitPrice', [Value]);
  Driver.SetUnitPrice(Value);
  Logger.Debug('ToleScale.SetUnitPrice', [Value], 'OK');
  Unlock;
end;

initialization
  ComServer.SetServerName('OposShtrih');
  TAutoObjectFactory.Create(ComServer, ToleScale, Class_Scale,
    ciMultiInstance, tmApartment);
end.
