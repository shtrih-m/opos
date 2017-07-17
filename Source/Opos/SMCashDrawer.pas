unit SMCashDrawer;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Variants, ComObj,
  // This
  PrinterEncoding, PrinterParametersX, OposCashDrawerIntf, LogFile;

type
  { TSMCashDrawer }

  TSMCashDrawer = class(TInterfacedObject, IOPOSCashDrawer_1_9)
  private
    FEncoding: Integer;
    FDriver: OleVariant;
    FLogger: ILogFile;

    function GetLogger: ILogFile;
    function GetDriver: OleVariant;
    function EncodeString(const Text: WideString): WideString;
    function DecodeString(const Text: WideString): WideString;
    property Logger: ILogFile read GetLogger;
  public
    property Driver: OleVariant read GetDriver;
  public
    destructor Destroy; override;
    // IOPOSCashDrawer_1_5
    procedure SODataDummy(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer;
                           var pErrorResponse: Integer); safecall;
    procedure SOOutputCompleteDummy(OutputID: Integer); safecall;
    procedure SOStatusUpdate(Data: Integer); safecall;
    function SOProcessID: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    function Get_CheckHealthText: WideString; safecall;
    function Get_Claimed: WordBool; safecall;
    function Get_DeviceEnabled: WordBool; safecall;
    procedure Set_DeviceEnabled(pDeviceEnabled: WordBool); safecall;
    function Get_FreezeEvents: WordBool; safecall;
    procedure Set_FreezeEvents(pFreezeEvents: WordBool); safecall;
    function Get_ResultCode: Integer; safecall;
    function Get_ResultCodeExtended: Integer; safecall;
    function Get_State: Integer; safecall;
    function Get_ControlObjectDescription: WideString; safecall;
    function Get_ControlObjectVersion: Integer; safecall;
    function Get_ServiceObjectDescription: WideString; safecall;
    function Get_ServiceObjectVersion: Integer; safecall;
    function Get_DeviceDescription: WideString; safecall;
    function Get_DeviceName: WideString; safecall;
    function CheckHealth(Level: Integer): Integer; safecall;
    function Claim(Timeout: Integer): Integer; safecall;
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function Close: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function Open(const DeviceName: WideString): Integer; safecall;
    function Release: Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function Get_CapStatus: WordBool; safecall;
    function Get_DrawerOpened: WordBool; safecall;
    function OpenDrawer: Integer; safecall;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer;
                                BeepDuration: Integer; BeepDelay: Integer): Integer; safecall;
    function Get_BinaryConversion: Integer; safecall;
    procedure Set_BinaryConversion(pBinaryConversion: Integer); safecall;
    function Get_CapPowerReporting: Integer; safecall;
    function Get_PowerNotify: Integer; safecall;
    procedure Set_PowerNotify(pPowerNotify: Integer); safecall;
    function Get_PowerState: Integer; safecall;
    function Get_CapStatusMultiDrawerDetect: WordBool; safecall;
    property OpenResult: Integer read Get_OpenResult;
    property CheckHealthText: WideString read Get_CheckHealthText;
    property Claimed: WordBool read Get_Claimed;
    property DeviceEnabled: WordBool read Get_DeviceEnabled write Set_DeviceEnabled;
    property FreezeEvents: WordBool read Get_FreezeEvents write Set_FreezeEvents;
    property ResultCode: Integer read Get_ResultCode;
    property ResultCodeExtended: Integer read Get_ResultCodeExtended;
    property State: Integer read Get_State;
    property ControlObjectDescription: WideString read Get_ControlObjectDescription;
    property ControlObjectVersion: Integer read Get_ControlObjectVersion;
    property ServiceObjectDescription: WideString read Get_ServiceObjectDescription;
    property ServiceObjectVersion: Integer read Get_ServiceObjectVersion;
    property DeviceDescription: WideString read Get_DeviceDescription;
    property DeviceName: WideString read Get_DeviceName;
    property CapStatus: WordBool read Get_CapStatus;
    property DrawerOpened: WordBool read Get_DrawerOpened;
    property BinaryConversion: Integer read Get_BinaryConversion write Set_BinaryConversion;
    property CapPowerReporting: Integer read Get_CapPowerReporting;
    property PowerNotify: Integer read Get_PowerNotify write Set_PowerNotify;
    property PowerState: Integer read Get_PowerState;
    property CapStatusMultiDrawerDetect: WordBool read Get_CapStatusMultiDrawerDetect;
  public
    // IOPOSCashDrawer_1_8
    function Get_CapStatisticsReporting: WordBool; safecall;
    function Get_CapUpdateStatistics: WordBool; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    property CapStatisticsReporting: WordBool read Get_CapStatisticsReporting;
    property CapUpdateStatistics: WordBool read Get_CapUpdateStatistics;
  public
    // IOPOSCashDrawer_1_9
    function Get_CapCompareFirmwareVersion: WordBool; safecall;
    function Get_CapUpdateFirmware: WordBool; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    property CapCompareFirmwareVersion: WordBool read Get_CapCompareFirmwareVersion;
    property CapUpdateFirmware: WordBool read Get_CapUpdateFirmware;
  end;

implementation

{ TSMCashDrawer }

destructor TSMCashDrawer.Destroy;
begin
  FLogger := nil;
  VarClear(FDriver);
  inherited Destroy;
end;

function TSMCashDrawer.GetLogger: ILogFile;
begin
  if FLogger = nil then
    FLogger := TLogFile.Create;
  Result := FLogger;
end;

function TSMCashDrawer.DecodeString(const Text: WideString): WideString;
begin
  Result := DecodeText(FEncoding, Text);
end;

function TSMCashDrawer.EncodeString(const Text: WideString): WideString;
begin
  Result := EncodeText(FEncoding, Text);
end;

function TSMCashDrawer.GetDriver: OleVariant;
begin
  if VarIsEmpty(FDriver) then
  begin
    try
      FDriver := CreateOleObject('OPOS.CashDrawer');
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object CashDrawer:'#13#10 +
          E.Message;
        raise;
      end;
    end;
  end;
  Result := FDriver;
end;

// IOPOSCashDrawer_1_5

function TSMCashDrawer.CheckHealth(Level: Integer): Integer;
begin
  Result := Driver.CheckHealth(Level);
end;

function TSMCashDrawer.Claim(Timeout: Integer): Integer;
begin
  Result := Driver.Claim(Timeout);
end;

function TSMCashDrawer.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := Driver.ClaimDevice(Timeout);
end;

function TSMCashDrawer.Close: Integer;
begin
  Result := Driver.Close;
end;

function TSMCashDrawer.CompareFirmwareVersion(
  const FirmwareFileName: WideString; out pResult: Integer): Integer;
begin
  Result := Driver.CompareFirmwareVersion(FirmwareFileName, pResult);
end;

function TSMCashDrawer.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  Result := Driver.DirectIO(Command, pData, pString);
end;

function TSMCashDrawer.Get_BinaryConversion: Integer;
begin
  Result := Driver.BinaryConversion;
end;

function TSMCashDrawer.Get_CapCompareFirmwareVersion: WordBool;
begin
  Result := Driver.CapCompareFirmwareVersion;
end;

function TSMCashDrawer.Get_CapPowerReporting: Integer;
begin
  Result := Driver.CapPowerReporting;
end;

function TSMCashDrawer.Get_CapStatisticsReporting: WordBool;
begin
  Result := Driver.CapStatisticsReporting;
end;

function TSMCashDrawer.Get_CapStatus: WordBool;
begin
  Result := Driver.CapStatus;
end;

function TSMCashDrawer.Get_CapStatusMultiDrawerDetect: WordBool;
begin
  Result := Driver.CapStatusMultiDrawerDetect;
end;

function TSMCashDrawer.Get_CapUpdateFirmware: WordBool;
begin
  Result := Driver.CapUpdateFirmware;
end;

function TSMCashDrawer.Get_CapUpdateStatistics: WordBool;
begin
  Result := Driver.CapUpdateStatistics;
end;

function TSMCashDrawer.Get_CheckHealthText: WideString;
begin
  Result := DecodeString(Driver.CheckHealthText);
end;

function TSMCashDrawer.Get_Claimed: WordBool;
begin
  Result := Driver.Claimed;
end;

function TSMCashDrawer.Get_ControlObjectDescription: WideString;
begin
  Result := DecodeString(Driver.ControlObjectDescription);
end;

function TSMCashDrawer.Get_ControlObjectVersion: Integer;
begin
  Result := Driver.ControlObjectVersion;
end;

function TSMCashDrawer.Get_DeviceDescription: WideString;
begin
  Result := DecodeString(Driver.DeviceDescription);
end;

function TSMCashDrawer.Get_DeviceEnabled: WordBool;
begin
  Result := Driver.DeviceEnabled;
end;

function TSMCashDrawer.Get_DeviceName: WideString;
begin
  Result := DecodeString(Driver.DeviceName);
end;

function TSMCashDrawer.Get_DrawerOpened: WordBool;
begin
  Result := Driver.DrawerOpened;
end;

function TSMCashDrawer.Get_FreezeEvents: WordBool;
begin
  Result := Driver.FreezeEvents;
end;

function TSMCashDrawer.Get_OpenResult: Integer;
begin
  Result := Driver.OpenResult;
end;

function TSMCashDrawer.Get_PowerNotify: Integer;
begin
  Result := Driver.PowerNotify;
end;

function TSMCashDrawer.Get_PowerState: Integer;
begin
  Result := Driver.PowerState;
end;

function TSMCashDrawer.Get_ResultCode: Integer;
begin
  Result := Driver.ResultCode;
end;

function TSMCashDrawer.Get_ResultCodeExtended: Integer;
begin
  Result := Driver.ResultCodeExtended;
end;

function TSMCashDrawer.Get_ServiceObjectDescription: WideString;
begin
  Result := DecodeString(Driver.ServiceObjectDescription);
end;

function TSMCashDrawer.Get_ServiceObjectVersion: Integer;
begin
  Result := Driver.ServiceObjectVersion;
end;

function TSMCashDrawer.Get_State: Integer;
begin
  Result := Driver.State;
end;

function TSMCashDrawer.Open(const DeviceName: WideString): Integer;
begin
  Result := Driver.Open(DeviceName);
  FEncoding := ReadEncoding(DeviceName, Logger);
end;

function TSMCashDrawer.OpenDrawer: Integer;
begin
  Result := Driver.OpenDrawer;
end;

function TSMCashDrawer.Release: Integer;
begin
  Result := Driver.Release;
end;

function TSMCashDrawer.ReleaseDevice: Integer;
begin
  Result := Driver.ReleaseDevice;
end;

function TSMCashDrawer.ResetStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  Result := Driver.ResetStatistics(EncodeString(StatisticsBuffer));
end;

function TSMCashDrawer.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  pStatisticsBuffer := EncodeString(pStatisticsBuffer);
  Result := Driver.RetrieveStatistics(pStatisticsBuffer);
  pStatisticsBuffer := DecodeString(pStatisticsBuffer);
end;

procedure TSMCashDrawer.Set_BinaryConversion(pBinaryConversion: Integer);
begin
  Driver.BinaryConversion := pBinaryConversion;
end;

procedure TSMCashDrawer.Set_DeviceEnabled(pDeviceEnabled: WordBool);
begin
  Driver.DeviceEnabled := pDeviceEnabled;
end;

procedure TSMCashDrawer.Set_FreezeEvents(pFreezeEvents: WordBool);
begin
  Driver.FreezeEvents := pFreezeEvents;
end;

procedure TSMCashDrawer.Set_PowerNotify(pPowerNotify: Integer);
begin
  Driver.PowerNotify := pPowerNotify;
end;

procedure TSMCashDrawer.SODataDummy(Status: Integer);
begin
  Driver.SODataDummy(Status);
end;

procedure TSMCashDrawer.SODirectIO(EventNumber: Integer;
  var pData: Integer; var pString: WideString);
begin
  pString := EncodeString(pString);
  Driver.SODirectIO(EventNumber, pData, pString);
  pString := DecodeString(pString);
end;

procedure TSMCashDrawer.SOErrorDummy(ResultCode, ResultCodeExtended,
  ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  Driver.SOErrorDummy(ResultCode, ResultCodeExtended, ErrorLocus,
    pErrorResponse);
end;

procedure TSMCashDrawer.SOOutputCompleteDummy(OutputID: Integer);
begin
  Driver.SOOutputCompleteDummy(OutputID);
end;

function TSMCashDrawer.SOProcessID: Integer;
begin
  Result := Driver.SOProcessID;
end;

procedure TSMCashDrawer.SOStatusUpdate(Data: Integer);
begin
  Driver.SOStatusUpdate(Data);
end;

function TSMCashDrawer.UpdateFirmware(
  const FirmwareFileName: WideString): Integer;
begin
  Result := Driver.UpdateFirmware(EncodeString(FirmwareFileName));
end;

function TSMCashDrawer.UpdateStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  Result := Driver.UpdateStatistics(EncodeString(StatisticsBuffer));
end;

function TSMCashDrawer.WaitForDrawerClose(BeepTimeout, BeepFrequency,
  BeepDuration, BeepDelay: Integer): Integer;
begin
  Result := Driver.WaitForDrawerClose(BeepTimeout, BeepFrequency,
    BeepDuration, BeepDelay);
end;

end.
