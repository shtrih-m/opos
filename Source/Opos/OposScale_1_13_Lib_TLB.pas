unit OposScale_1_13_Lib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 27.11.2012 17:42:14 from Type Library described below.

// ************************************************************************  //
// Type Lib: I:\Projects\OposShtrih\Source\Opos\OPOSScale.tlb (1)
// LIBID: {CCB90170-B81E-11D2-AB74-0040054C3719}
// LCID: 0
// Helpfile: 
// HelpString: OPOS Scale Control 1.13.001 [Public, by CRM/RCS-Dayton]
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  OposScale_CCOMajorVersion = 1;
  OposScale_CCOMinorVersion = 0;

  LIBID_OposScale_CCO: TGUID = '{CCB90170-B81E-11D2-AB74-0040054C3719}';

  DIID__IOPOSScaleEvents: TGUID = '{CCB90173-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSScale_1_5: TGUID = '{CCB91171-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSScale_1_8: TGUID = '{CCB92171-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSScale_1_9: TGUID = '{CCB93171-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSScale_1_13: TGUID = '{CCB95171-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSScale: TGUID = '{CCB96171-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSScale_1_9_zz: TGUID = '{CCB94171-B81E-11D2-AB74-0040054C3719}';
  CLASS_OPOSScale: TGUID = '{CCB90172-B81E-11D2-AB74-0040054C3719}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IOPOSScaleEvents = dispinterface;
  IOPOSScale_1_5 = interface;
  IOPOSScale_1_5Disp = dispinterface;
  IOPOSScale_1_8 = interface;
  IOPOSScale_1_8Disp = dispinterface;
  IOPOSScale_1_9 = interface;
  IOPOSScale_1_9Disp = dispinterface;
  IOPOSScale_1_13 = interface;
  IOPOSScale_1_13Disp = dispinterface;
  IOPOSScale = interface;
  IOPOSScaleDisp = dispinterface;
  IOPOSScale_1_9_zz = interface;
  IOPOSScale_1_9_zzDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OPOSScale = IOPOSScale;


// *********************************************************************//
// DispIntf:  _IOPOSScaleEvents
// Flags:     (4096) Dispatchable
// GUID:      {CCB90173-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  _IOPOSScaleEvents = dispinterface
    ['{CCB90173-B81E-11D2-AB74-0040054C3719}']
    procedure DataEvent(Status: Integer); dispid 1;
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure ErrorEvent(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                         var pErrorResponse: Integer); dispid 3;
    procedure StatusUpdateEvent(Data: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_5 = interface(IDispatch)
    ['{CCB91171-B81E-11D2-AB74-0040054C3719}']
    procedure SOData(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
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
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function ClearInput: Integer; safecall;
    function Close: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function Open(const DeviceName: WideString): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function Get_MaximumWeight: Integer; safecall;
    function Get_WeightUnit: Integer; safecall;
    function Get_WeightUnits: Integer; safecall;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; safecall;
    function Get_BinaryConversion: Integer; safecall;
    procedure Set_BinaryConversion(pBinaryConversion: Integer); safecall;
    function Get_CapDisplay: WordBool; safecall;
    function Get_AutoDisable: WordBool; safecall;
    procedure Set_AutoDisable(pAutoDisable: WordBool); safecall;
    function Get_CapPowerReporting: Integer; safecall;
    function Get_DataCount: Integer; safecall;
    function Get_DataEventEnabled: WordBool; safecall;
    procedure Set_DataEventEnabled(pDataEventEnabled: WordBool); safecall;
    function Get_PowerNotify: Integer; safecall;
    procedure Set_PowerNotify(pPowerNotify: Integer); safecall;
    function Get_PowerState: Integer; safecall;
    function Get_AsyncMode: WordBool; safecall;
    procedure Set_AsyncMode(pAsyncMode: WordBool); safecall;
    function Get_CapDisplayText: WordBool; safecall;
    function Get_CapPriceCalculating: WordBool; safecall;
    function Get_CapTareWeight: WordBool; safecall;
    function Get_CapZeroScale: WordBool; safecall;
    function Get_MaxDisplayTextChars: Integer; safecall;
    function Get_SalesPrice: Currency; safecall;
    function Get_TareWeight: Integer; safecall;
    procedure Set_TareWeight(pTareWeight: Integer); safecall;
    function Get_UnitPrice: Currency; safecall;
    procedure Set_UnitPrice(pUnitPrice: Currency); safecall;
    function DisplayText(const Data: WideString): Integer; safecall;
    function ZeroScale: Integer; safecall;
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
    property MaximumWeight: Integer read Get_MaximumWeight;
    property WeightUnit: Integer read Get_WeightUnit;
    property WeightUnits: Integer read Get_WeightUnits;
    property BinaryConversion: Integer read Get_BinaryConversion write Set_BinaryConversion;
    property CapDisplay: WordBool read Get_CapDisplay;
    property AutoDisable: WordBool read Get_AutoDisable write Set_AutoDisable;
    property CapPowerReporting: Integer read Get_CapPowerReporting;
    property DataCount: Integer read Get_DataCount;
    property DataEventEnabled: WordBool read Get_DataEventEnabled write Set_DataEventEnabled;
    property PowerNotify: Integer read Get_PowerNotify write Set_PowerNotify;
    property PowerState: Integer read Get_PowerState;
    property AsyncMode: WordBool read Get_AsyncMode write Set_AsyncMode;
    property CapDisplayText: WordBool read Get_CapDisplayText;
    property CapPriceCalculating: WordBool read Get_CapPriceCalculating;
    property CapTareWeight: WordBool read Get_CapTareWeight;
    property CapZeroScale: WordBool read Get_CapZeroScale;
    property MaxDisplayTextChars: Integer read Get_MaxDisplayTextChars;
    property SalesPrice: Currency read Get_SalesPrice;
    property TareWeight: Integer read Get_TareWeight write Set_TareWeight;
    property UnitPrice: Currency read Get_UnitPrice write Set_UnitPrice;
  end;

// *********************************************************************//
// DispIntf:  IOPOSScale_1_5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_5Disp = dispinterface
    ['{CCB91171-B81E-11D2-AB74-0040054C3719}']
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearInput: Integer; dispid 33;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property MaximumWeight: Integer readonly dispid 57;
    property WeightUnit: Integer readonly dispid 61;
    property WeightUnits: Integer readonly dispid 62;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 71;
    property BinaryConversion: Integer dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    property AutoDisable: WordBool dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    property DataEventEnabled: WordBool dispid 16;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property AsyncMode: WordBool dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    property TareWeight: Integer dispid 59;
    property UnitPrice: Currency dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_8
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_8 = interface(IOPOSScale_1_5)
    ['{CCB92171-B81E-11D2-AB74-0040054C3719}']
    function Get_CapStatisticsReporting: WordBool; safecall;
    function Get_CapUpdateStatistics: WordBool; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    property CapStatisticsReporting: WordBool read Get_CapStatisticsReporting;
    property CapUpdateStatistics: WordBool read Get_CapUpdateStatistics;
  end;

// *********************************************************************//
// DispIntf:  IOPOSScale_1_8Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_8Disp = dispinterface
    ['{CCB92171-B81E-11D2-AB74-0040054C3719}']
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearInput: Integer; dispid 33;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property MaximumWeight: Integer readonly dispid 57;
    property WeightUnit: Integer readonly dispid 61;
    property WeightUnits: Integer readonly dispid 62;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 71;
    property BinaryConversion: Integer dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    property AutoDisable: WordBool dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    property DataEventEnabled: WordBool dispid 16;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property AsyncMode: WordBool dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    property TareWeight: Integer dispid 59;
    property UnitPrice: Currency dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_9
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_9 = interface(IOPOSScale_1_8)
    ['{CCB93171-B81E-11D2-AB74-0040054C3719}']
    function Get_CapCompareFirmwareVersion: WordBool; safecall;
    function Get_CapUpdateFirmware: WordBool; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    function Get_CapStatusUpdate: WordBool; safecall;
    function Get_ScaleLiveWeight: Integer; safecall;
    function Get_StatusNotify: Integer; safecall;
    procedure Set_StatusNotify(pStatusNotify: Integer); safecall;
    property CapCompareFirmwareVersion: WordBool read Get_CapCompareFirmwareVersion;
    property CapUpdateFirmware: WordBool read Get_CapUpdateFirmware;
    property CapStatusUpdate: WordBool read Get_CapStatusUpdate;
    property ScaleLiveWeight: Integer read Get_ScaleLiveWeight;
    property StatusNotify: Integer read Get_StatusNotify write Set_StatusNotify;
  end;

// *********************************************************************//
// DispIntf:  IOPOSScale_1_9Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_9Disp = dispinterface
    ['{CCB93171-B81E-11D2-AB74-0040054C3719}']
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatusUpdate: WordBool readonly dispid 63;
    property ScaleLiveWeight: Integer readonly dispid 64;
    property StatusNotify: Integer dispid 65;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearInput: Integer; dispid 33;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property MaximumWeight: Integer readonly dispid 57;
    property WeightUnit: Integer readonly dispid 61;
    property WeightUnits: Integer readonly dispid 62;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 71;
    property BinaryConversion: Integer dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    property AutoDisable: WordBool dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    property DataEventEnabled: WordBool dispid 16;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property AsyncMode: WordBool dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    property TareWeight: Integer dispid 59;
    property UnitPrice: Currency dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_13
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB95171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_13 = interface(IOPOSScale_1_9)
    ['{CCB95171-B81E-11D2-AB74-0040054C3719}']
    function Get_ZeroValid: WordBool; safecall;
    procedure Set_ZeroValid(pZeroValid: WordBool); safecall;
    property ZeroValid: WordBool read Get_ZeroValid write Set_ZeroValid;
  end;

// *********************************************************************//
// DispIntf:  IOPOSScale_1_13Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB95171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_13Disp = dispinterface
    ['{CCB95171-B81E-11D2-AB74-0040054C3719}']
    property ZeroValid: WordBool dispid 66;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatusUpdate: WordBool readonly dispid 63;
    property ScaleLiveWeight: Integer readonly dispid 64;
    property StatusNotify: Integer dispid 65;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearInput: Integer; dispid 33;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property MaximumWeight: Integer readonly dispid 57;
    property WeightUnit: Integer readonly dispid 61;
    property WeightUnits: Integer readonly dispid 62;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 71;
    property BinaryConversion: Integer dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    property AutoDisable: WordBool dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    property DataEventEnabled: WordBool dispid 16;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property AsyncMode: WordBool dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    property TareWeight: Integer dispid 59;
    property UnitPrice: Currency dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;

// *********************************************************************//
// Interface: IOPOSScale
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB96171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale = interface(IOPOSScale_1_13)
    ['{CCB96171-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSScaleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB96171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScaleDisp = dispinterface
    ['{CCB96171-B81E-11D2-AB74-0040054C3719}']
    property ZeroValid: WordBool dispid 66;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatusUpdate: WordBool readonly dispid 63;
    property ScaleLiveWeight: Integer readonly dispid 64;
    property StatusNotify: Integer dispid 65;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearInput: Integer; dispid 33;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property MaximumWeight: Integer readonly dispid 57;
    property WeightUnit: Integer readonly dispid 61;
    property WeightUnits: Integer readonly dispid 62;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 71;
    property BinaryConversion: Integer dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    property AutoDisable: WordBool dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    property DataEventEnabled: WordBool dispid 16;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property AsyncMode: WordBool dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    property TareWeight: Integer dispid 59;
    property UnitPrice: Currency dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_9_zz
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CCB94171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_9_zz = interface(IOPOSScale_1_9)
    ['{CCB94171-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSScale_1_9_zzDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CCB94171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_9_zzDisp = dispinterface
    ['{CCB94171-B81E-11D2-AB74-0040054C3719}']
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatusUpdate: WordBool readonly dispid 63;
    property ScaleLiveWeight: Integer readonly dispid 64;
    property StatusNotify: Integer dispid 65;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property ResultCode: Integer readonly dispid 22;
    property ResultCodeExtended: Integer readonly dispid 23;
    property State: Integer readonly dispid 24;
    property ControlObjectDescription: WideString readonly dispid 25;
    property ControlObjectVersion: Integer readonly dispid 26;
    property ServiceObjectDescription: WideString readonly dispid 27;
    property ServiceObjectVersion: Integer readonly dispid 28;
    property DeviceDescription: WideString readonly dispid 29;
    property DeviceName: WideString readonly dispid 30;
    function CheckHealth(Level: Integer): Integer; dispid 31;
    function ClaimDevice(Timeout: Integer): Integer; dispid 32;
    function ClearInput: Integer; dispid 33;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property MaximumWeight: Integer readonly dispid 57;
    property WeightUnit: Integer readonly dispid 61;
    property WeightUnits: Integer readonly dispid 62;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 71;
    property BinaryConversion: Integer dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    property AutoDisable: WordBool dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    property DataEventEnabled: WordBool dispid 16;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property AsyncMode: WordBool dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    property TareWeight: Integer dispid 59;
    property UnitPrice: Currency dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TOPOSScale
// Help String      : OPOS Scale Control 1.13.001 [Public, by CRM/RCS-Dayton]
// Default Interface: IOPOSScale
// Def. Intf. DISP? : No
// Event   Interface: _IOPOSScaleEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TOPOSScaleDataEvent = procedure(ASender: TObject; Status: Integer) of object;
  TOPOSScaleDirectIOEvent = procedure(ASender: TObject; EventNumber: Integer; var pData: Integer; 
                                                        var pString: WideString) of object;
  TOPOSScaleErrorEvent = procedure(ASender: TObject; ResultCode: Integer; 
                                                     ResultCodeExtended: Integer; 
                                                     ErrorLocus: Integer; 
                                                     var pErrorResponse: Integer) of object;
  TOPOSScaleStatusUpdateEvent = procedure(ASender: TObject; Data: Integer) of object;

  TOPOSScale = class(TOleControl)
  private
    FOnDataEvent: TOPOSScaleDataEvent;
    FOnDirectIOEvent: TOPOSScaleDirectIOEvent;
    FOnErrorEvent: TOPOSScaleErrorEvent;
    FOnStatusUpdateEvent: TOPOSScaleStatusUpdateEvent;
    FIntf: IOPOSScale;
    function  GetControlInterface: IOPOSScale;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure SOData(Status: Integer);
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString);
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer);
    procedure SOOutputCompleteDummy(OutputID: Integer);
    procedure SOStatusUpdate(Data: Integer);
    function SOProcessID: Integer;
    function CheckHealth(Level: Integer): Integer;
    function ClaimDevice(Timeout: Integer): Integer;
    function ClearInput: Integer;
    function Close: Integer;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
    function Open(const DeviceName: WideString): Integer;
    function ReleaseDevice: Integer;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer;
    function DisplayText(const Data: WideString): Integer;
    function ZeroScale: Integer;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer;
    property  ControlInterface: IOPOSScale read GetControlInterface;
    property  DefaultInterface: IOPOSScale read GetControlInterface;
    property OpenResult: Integer index 49 read GetIntegerProp;
    property CheckHealthText: WideString index 13 read GetWideStringProp;
    property Claimed: WordBool index 14 read GetWordBoolProp;
    property ResultCode: Integer index 22 read GetIntegerProp;
    property ResultCodeExtended: Integer index 23 read GetIntegerProp;
    property State: Integer index 24 read GetIntegerProp;
    property ControlObjectDescription: WideString index 25 read GetWideStringProp;
    property ControlObjectVersion: Integer index 26 read GetIntegerProp;
    property ServiceObjectDescription: WideString index 27 read GetWideStringProp;
    property ServiceObjectVersion: Integer index 28 read GetIntegerProp;
    property DeviceDescription: WideString index 29 read GetWideStringProp;
    property DeviceName: WideString index 30 read GetWideStringProp;
    property MaximumWeight: Integer index 57 read GetIntegerProp;
    property WeightUnit: Integer index 61 read GetIntegerProp;
    property WeightUnits: Integer index 62 read GetIntegerProp;
    property CapDisplay: WordBool index 51 read GetWordBoolProp;
    property CapPowerReporting: Integer index 12 read GetIntegerProp;
    property DataCount: Integer index 15 read GetIntegerProp;
    property PowerState: Integer index 21 read GetIntegerProp;
    property CapDisplayText: WordBool index 52 read GetWordBoolProp;
    property CapPriceCalculating: WordBool index 53 read GetWordBoolProp;
    property CapTareWeight: WordBool index 54 read GetWordBoolProp;
    property CapZeroScale: WordBool index 55 read GetWordBoolProp;
    property MaxDisplayTextChars: Integer index 56 read GetIntegerProp;
    property SalesPrice: Currency index 58 read GetCurrencyProp;
    property CapStatisticsReporting: WordBool index 39 read GetWordBoolProp;
    property CapUpdateStatistics: WordBool index 40 read GetWordBoolProp;
    property CapCompareFirmwareVersion: WordBool index 44 read GetWordBoolProp;
    property CapUpdateFirmware: WordBool index 45 read GetWordBoolProp;
    property CapStatusUpdate: WordBool index 63 read GetWordBoolProp;
    property ScaleLiveWeight: Integer index 64 read GetIntegerProp;
  published
    property Anchors;
    property DeviceEnabled: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property FreezeEvents: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property BinaryConversion: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property AutoDisable: WordBool index 10 read GetWordBoolProp write SetWordBoolProp stored False;
    property DataEventEnabled: WordBool index 16 read GetWordBoolProp write SetWordBoolProp stored False;
    property PowerNotify: Integer index 20 read GetIntegerProp write SetIntegerProp stored False;
    property AsyncMode: WordBool index 50 read GetWordBoolProp write SetWordBoolProp stored False;
    property TareWeight: Integer index 59 read GetIntegerProp write SetIntegerProp stored False;
    property UnitPrice: Currency index 60 read GetCurrencyProp write SetCurrencyProp stored False;
    property StatusNotify: Integer index 65 read GetIntegerProp write SetIntegerProp stored False;
    property ZeroValid: WordBool index 66 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnDataEvent: TOPOSScaleDataEvent read FOnDataEvent write FOnDataEvent;
    property OnDirectIOEvent: TOPOSScaleDirectIOEvent read FOnDirectIOEvent write FOnDirectIOEvent;
    property OnErrorEvent: TOPOSScaleErrorEvent read FOnErrorEvent write FOnErrorEvent;
    property OnStatusUpdateEvent: TOPOSScaleStatusUpdateEvent read FOnStatusUpdateEvent write FOnStatusUpdateEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TOPOSScale.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $00000001, $00000002, $00000003, $00000005);
  CControlData: TControlData2 = (
    ClassID: '{CCB90172-B81E-11D2-AB74-0040054C3719}';
    EventIID: '{CCB90173-B81E-11D2-AB74-0040054C3719}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnDataEvent) - Cardinal(Self);
end;

procedure TOPOSScale.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IOPOSScale;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TOPOSScale.GetControlInterface: IOPOSScale;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TOPOSScale.SOData(Status: Integer);
begin
  DefaultInterface.SOData(Status);
end;

procedure TOPOSScale.SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString);
begin
  DefaultInterface.SODirectIO(EventNumber, pData, pString);
end;

procedure TOPOSScale.SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                             var pErrorResponse: Integer);
begin
  DefaultInterface.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

procedure TOPOSScale.SOOutputCompleteDummy(OutputID: Integer);
begin
  DefaultInterface.SOOutputCompleteDummy(OutputID);
end;

procedure TOPOSScale.SOStatusUpdate(Data: Integer);
begin
  DefaultInterface.SOStatusUpdate(Data);
end;

function TOPOSScale.SOProcessID: Integer;
begin
  Result := DefaultInterface.SOProcessID;
end;

function TOPOSScale.CheckHealth(Level: Integer): Integer;
begin
  Result := DefaultInterface.CheckHealth(Level);
end;

function TOPOSScale.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.ClaimDevice(Timeout);
end;

function TOPOSScale.ClearInput: Integer;
begin
  Result := DefaultInterface.ClearInput;
end;

function TOPOSScale.Close: Integer;
begin
  Result := DefaultInterface.Close;
end;

function TOPOSScale.DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString);
end;

function TOPOSScale.Open(const DeviceName: WideString): Integer;
begin
  Result := DefaultInterface.Open(DeviceName);
end;

function TOPOSScale.ReleaseDevice: Integer;
begin
  Result := DefaultInterface.ReleaseDevice;
end;

function TOPOSScale.ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer;
begin
  Result := DefaultInterface.ReadWeight(pWeightData, Timeout);
end;

function TOPOSScale.DisplayText(const Data: WideString): Integer;
begin
  Result := DefaultInterface.DisplayText(Data);
end;

function TOPOSScale.ZeroScale: Integer;
begin
  Result := DefaultInterface.ZeroScale;
end;

function TOPOSScale.ResetStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.ResetStatistics(StatisticsBuffer);
end;

function TOPOSScale.RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.RetrieveStatistics(pStatisticsBuffer);
end;

function TOPOSScale.UpdateStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.UpdateStatistics(StatisticsBuffer);
end;

function TOPOSScale.CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
begin
  Result := DefaultInterface.CompareFirmwareVersion(FirmwareFileName, pResult);
end;

function TOPOSScale.UpdateFirmware(const FirmwareFileName: WideString): Integer;
begin
  Result := DefaultInterface.UpdateFirmware(FirmwareFileName);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TOPOSScale]);
end;

end.
