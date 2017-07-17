unit NCRCashDrawer;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Variants, ComObj,
  // This
  PrinterEncoding, PrinterParametersX, OposCashDrawerIntf, NCRCashDrawer_TLB,
  Logfile;

type
  { TNCRCashDrawer }

  TNCRCashDrawer = class(TInterfacedObject, IOPOSCashDrawer_1_9)
  private
    FLogger: ILogFile;
    FEncoding: Integer;
    FDriver: TNCRCashDrawerService;

    function GetLogger: ILogFile;
    function GetDriver: TNCRCashDrawerService;

    property Logger: ILogFile read GetLogger;
    property Driver: TNCRCashDrawerService read GetDriver;
  public
    function EncodeString(const Text: WideString): WideString;
    function DecodeString(const Text: WideString): WideString;
  public
    destructor Destroy; override;
    // IOPOSCashDrawer_1_5
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

{ TNCRCashDrawer }

function TNCRCashDrawer.GetDriver: TNCRCashDrawerService;
begin
  if FDriver = nil then
  begin
    try
      FDriver := TNCRCashDrawerService.Create(nil);
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

destructor TNCRCashDrawer.Destroy;
begin
  FDriver.Free;
  FLogger := nil;
  inherited Destroy;
end;

function TNCRCashDrawer.GetLogger: ILogFile;
begin
  if FLogger = nil then
    FLogger := TLogFile.Create;
  Result := FLogger;
end;

function TNCRCashDrawer.DecodeString(const Text: WideString): WideString;
begin
  Result := DecodeText(FEncoding, Text);
end;

function TNCRCashDrawer.EncodeString(const Text: WideString): WideString;
begin
  Result := EncodeText(FEncoding, Text);
end;

// IOPOSCashDrawer_1_5

function TNCRCashDrawer.CheckHealth(Level: Integer): Integer;
begin
  Result := Driver.CheckHealth(Level);
end;

function TNCRCashDrawer.Claim(Timeout: Integer): Integer;
begin
  Result := Driver.Claim(Timeout);
end;

function TNCRCashDrawer.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := Driver.Claim(Timeout);
end;

function TNCRCashDrawer.Close: Integer;
begin
  Result := Driver.Close;
end;

function TNCRCashDrawer.CompareFirmwareVersion(
  const FirmwareFileName: WideString; out pResult: Integer): Integer;
begin
  Result := 0;
end;

function TNCRCashDrawer.DirectIO(Command: Integer; var pData: Integer;
  var pString: WideString): Integer;
begin
  Result := Driver.DirectIO(Command, pData, pString);
end;

function TNCRCashDrawer.Get_BinaryConversion: Integer;
begin
  Result := Driver.BinaryConversion;
end;

function TNCRCashDrawer.Get_CapCompareFirmwareVersion: WordBool;
begin
  Result := False;
end;

function TNCRCashDrawer.Get_CapPowerReporting: Integer;
begin
  Result := Driver.CapPowerReporting;
end;

function TNCRCashDrawer.Get_CapStatisticsReporting: WordBool;
begin
  Result := False;
end;

function TNCRCashDrawer.Get_CapStatus: WordBool;
begin
  Result := Driver.CapStatus;
end;

function TNCRCashDrawer.Get_CapStatusMultiDrawerDetect: WordBool;
begin
  Result := False;
end;

function TNCRCashDrawer.Get_CapUpdateFirmware: WordBool;
begin
  Result := False;
end;

function TNCRCashDrawer.Get_CapUpdateStatistics: WordBool;
begin
  Result := False;
end;

function TNCRCashDrawer.Get_CheckHealthText: WideString;
begin
  Result := DecodeString(Driver.CheckHealthText);
end;

function TNCRCashDrawer.Get_Claimed: WordBool;
begin
  Result := Driver.Claimed;
end;

function TNCRCashDrawer.Get_ControlObjectDescription: WideString;
begin
  Result := DecodeString(Driver.ControlObjectDescription);
end;

function TNCRCashDrawer.Get_ControlObjectVersion: Integer;
begin
  Result := Driver.ControlObjectVersion;
end;

function TNCRCashDrawer.Get_DeviceDescription: WideString;
begin
  Result := DecodeString(Driver.DeviceDescription);
end;

function TNCRCashDrawer.Get_DeviceEnabled: WordBool;
begin
  Result := Driver.DeviceEnabled;
end;

function TNCRCashDrawer.Get_DeviceName: WideString;
begin
  Result := DecodeString(Driver.DeviceName);
end;

function TNCRCashDrawer.Get_DrawerOpened: WordBool;
begin
  Result := Driver.DrawerOpened;
end;

function TNCRCashDrawer.Get_FreezeEvents: WordBool;
begin
  Result := Driver.FreezeEvents;
end;

function TNCRCashDrawer.Get_OpenResult: Integer;
begin
  Result := Driver.OpenResult;
end;

function TNCRCashDrawer.Get_PowerNotify: Integer;
begin
  Result := Driver.PowerNotify;
end;

function TNCRCashDrawer.Get_PowerState: Integer;
begin
  Result := Driver.PowerState;
end;

function TNCRCashDrawer.Get_ResultCode: Integer;
begin
  Result := Driver.ResultCode;
end;

function TNCRCashDrawer.Get_ResultCodeExtended: Integer;
begin
  Result := Driver.ResultCodeExtended;
end;

function TNCRCashDrawer.Get_ServiceObjectDescription: WideString;
begin
  Result := DecodeString(Driver.ServiceObjectDescription);
end;

function TNCRCashDrawer.Get_ServiceObjectVersion: Integer;
begin
  Result := Driver.ServiceObjectVersion;
end;

function TNCRCashDrawer.Get_State: Integer;
begin
  Result := Driver.State;
end;

function TNCRCashDrawer.Open(const DeviceName: WideString): Integer;
begin
  Result := Driver.Open(DeviceName);
  FEncoding := ReadEncoding(DeviceName, Logger);
end;

function TNCRCashDrawer.OpenDrawer: Integer;
begin
  Result := Driver.OpenDrawer;
end;

function TNCRCashDrawer.Release: Integer;
begin
  Result := Driver.Release;
end;

function TNCRCashDrawer.ReleaseDevice: Integer;
begin
  Result := Driver.Release;
end;

function TNCRCashDrawer.ResetStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  Result := 0;
end;

function TNCRCashDrawer.RetrieveStatistics(
  var pStatisticsBuffer: WideString): Integer;
begin
  Result := 0;
end;

procedure TNCRCashDrawer.Set_BinaryConversion(pBinaryConversion: Integer);
begin
  Driver.BinaryConversion := pBinaryConversion;
end;

procedure TNCRCashDrawer.Set_DeviceEnabled(pDeviceEnabled: WordBool);
begin
  Driver.DeviceEnabled := pDeviceEnabled;
end;

procedure TNCRCashDrawer.Set_FreezeEvents(pFreezeEvents: WordBool);
begin
  Driver.FreezeEvents := pFreezeEvents;
end;

procedure TNCRCashDrawer.Set_PowerNotify(pPowerNotify: Integer);
begin
  Driver.PowerNotify := pPowerNotify;
end;

function TNCRCashDrawer.UpdateFirmware(
  const FirmwareFileName: WideString): Integer;
begin
  Result := 0;
end;

function TNCRCashDrawer.UpdateStatistics(
  const StatisticsBuffer: WideString): Integer;
begin
  Result := 0;
end;

function TNCRCashDrawer.WaitForDrawerClose(BeepTimeout, BeepFrequency,
  BeepDuration, BeepDelay: Integer): Integer;
begin
  Result := 0;
end;

end.
