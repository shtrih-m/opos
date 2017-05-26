unit OposCashDrawer_CCO_TLB;

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
// File generated on 21.10.2011 11:31:44 from Type Library described below.

// ************************************************************************  //
// Type Lib: I:\Projects\OposShtrih\Source\Opos\OPOSCashDrawer.tlb (1)
// LIBID: {CCB90040-B81E-11D2-AB74-0040054C3719}
// LCID: 0
// Helpfile: 
// HelpString: OPOS CashDrawer Control 1.13.001 [Public, by CRM/RCS-Dayton]
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
  OposCashDrawer_CCOMajorVersion = 1;
  OposCashDrawer_CCOMinorVersion = 0;

  LIBID_OposCashDrawer_CCO: TGUID = '{CCB90040-B81E-11D2-AB74-0040054C3719}';

  DIID__IOPOSCashDrawerEvents: TGUID = '{CCB90043-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSCashDrawer_1_5: TGUID = '{CCB91041-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSCashDrawer_1_8: TGUID = '{CCB92041-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSCashDrawer_1_9: TGUID = '{CCB93041-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSCashDrawer: TGUID = '{CCB94041-B81E-11D2-AB74-0040054C3719}';
  CLASS_OPOSCashDrawer: TGUID = '{CCB90042-B81E-11D2-AB74-0040054C3719}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IOPOSCashDrawerEvents = dispinterface;
  IOPOSCashDrawer_1_5 = interface;
  IOPOSCashDrawer_1_5Disp = dispinterface;
  IOPOSCashDrawer_1_8 = interface;
  IOPOSCashDrawer_1_8Disp = dispinterface;
  IOPOSCashDrawer_1_9 = interface;
  IOPOSCashDrawer_1_9Disp = dispinterface;
  IOPOSCashDrawer = interface;
  IOPOSCashDrawerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OPOSCashDrawer = IOPOSCashDrawer;


// *********************************************************************//
// DispIntf:  _IOPOSCashDrawerEvents
// Flags:     (4096) Dispatchable
// GUID:      {CCB90043-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  _IOPOSCashDrawerEvents = dispinterface
    ['{CCB90043-B81E-11D2-AB74-0040054C3719}']
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure StatusUpdateEvent(Data: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: IOPOSCashDrawer_1_5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer_1_5 = interface(IDispatch)
    ['{CCB91041-B81E-11D2-AB74-0040054C3719}']
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
    function ClaimDevice(Timeout: Integer): Integer; safecall;
    function Close: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function Open(const DeviceName: WideString): Integer; safecall;
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
  end;

// *********************************************************************//
// DispIntf:  IOPOSCashDrawer_1_5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer_1_5Disp = dispinterface
    ['{CCB91041-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
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
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property CapStatus: WordBool readonly dispid 50;
    property DrawerOpened: WordBool readonly dispid 51;
    function OpenDrawer: Integer; dispid 60;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer; dispid 61;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapStatusMultiDrawerDetect: WordBool readonly dispid 52;
  end;

// *********************************************************************//
// Interface: IOPOSCashDrawer_1_8
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer_1_8 = interface(IOPOSCashDrawer_1_5)
    ['{CCB92041-B81E-11D2-AB74-0040054C3719}']
    function Get_CapStatisticsReporting: WordBool; safecall;
    function Get_CapUpdateStatistics: WordBool; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    property CapStatisticsReporting: WordBool read Get_CapStatisticsReporting;
    property CapUpdateStatistics: WordBool read Get_CapUpdateStatistics;
  end;

// *********************************************************************//
// DispIntf:  IOPOSCashDrawer_1_8Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer_1_8Disp = dispinterface
    ['{CCB92041-B81E-11D2-AB74-0040054C3719}']
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
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
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property CapStatus: WordBool readonly dispid 50;
    property DrawerOpened: WordBool readonly dispid 51;
    function OpenDrawer: Integer; dispid 60;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer; dispid 61;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapStatusMultiDrawerDetect: WordBool readonly dispid 52;
  end;

// *********************************************************************//
// Interface: IOPOSCashDrawer_1_9
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer_1_9 = interface(IOPOSCashDrawer_1_8)
    ['{CCB93041-B81E-11D2-AB74-0040054C3719}']
    function Get_CapCompareFirmwareVersion: WordBool; safecall;
    function Get_CapUpdateFirmware: WordBool; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    property CapCompareFirmwareVersion: WordBool read Get_CapCompareFirmwareVersion;
    property CapUpdateFirmware: WordBool read Get_CapUpdateFirmware;
  end;

// *********************************************************************//
// DispIntf:  IOPOSCashDrawer_1_9Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer_1_9Disp = dispinterface
    ['{CCB93041-B81E-11D2-AB74-0040054C3719}']
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
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
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property CapStatus: WordBool readonly dispid 50;
    property DrawerOpened: WordBool readonly dispid 51;
    function OpenDrawer: Integer; dispid 60;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer; dispid 61;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapStatusMultiDrawerDetect: WordBool readonly dispid 52;
  end;

// *********************************************************************//
// Interface: IOPOSCashDrawer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawer = interface(IOPOSCashDrawer_1_9)
    ['{CCB94041-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSCashDrawerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94041-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSCashDrawerDisp = dispinterface
    ['{CCB94041-B81E-11D2-AB74-0040054C3719}']
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
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
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property CapStatus: WordBool readonly dispid 50;
    property DrawerOpened: WordBool readonly dispid 51;
    function OpenDrawer: Integer; dispid 60;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer; dispid 61;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapStatusMultiDrawerDetect: WordBool readonly dispid 52;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TOPOSCashDrawer
// Help String      : OPOS CashDrawer Control 1.13.001 [Public, by CRM/RCS-Dayton]
// Default Interface: IOPOSCashDrawer
// Def. Intf. DISP? : No
// Event   Interface: _IOPOSCashDrawerEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TOPOSCashDrawerDirectIOEvent = procedure(ASender: TObject; EventNumber: Integer; 
                                                             var pData: Integer; 
                                                             var pString: WideString) of object;
  TOPOSCashDrawerStatusUpdateEvent = procedure(ASender: TObject; Data: Integer) of object;

  TOPOSCashDrawer = class(TOleControl)
  private
    FOnDirectIOEvent: TOPOSCashDrawerDirectIOEvent;
    FOnStatusUpdateEvent: TOPOSCashDrawerStatusUpdateEvent;
    FIntf: IOPOSCashDrawer;
    function  GetControlInterface: IOPOSCashDrawer;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure SODataDummy(Status: Integer);
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString);
    procedure SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                           var pErrorResponse: Integer);
    procedure SOOutputCompleteDummy(OutputID: Integer);
    procedure SOStatusUpdate(Data: Integer);
    function SOProcessID: Integer;
    function CheckHealth(Level: Integer): Integer;
    function ClaimDevice(Timeout: Integer): Integer;
    function Close: Integer;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
    function Open(const DeviceName: WideString): Integer;
    function ReleaseDevice: Integer;
    function OpenDrawer: Integer;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer;
    property  ControlInterface: IOPOSCashDrawer read GetControlInterface;
    property  DefaultInterface: IOPOSCashDrawer read GetControlInterface;
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
    property CapStatus: WordBool index 50 read GetWordBoolProp;
    property DrawerOpened: WordBool index 51 read GetWordBoolProp;
    property CapPowerReporting: Integer index 12 read GetIntegerProp;
    property PowerState: Integer index 21 read GetIntegerProp;
    property CapStatusMultiDrawerDetect: WordBool index 52 read GetWordBoolProp;
    property CapStatisticsReporting: WordBool index 39 read GetWordBoolProp;
    property CapUpdateStatistics: WordBool index 40 read GetWordBoolProp;
    property CapCompareFirmwareVersion: WordBool index 44 read GetWordBoolProp;
    property CapUpdateFirmware: WordBool index 45 read GetWordBoolProp;
  published
    property Anchors;
    property DeviceEnabled: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property FreezeEvents: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property BinaryConversion: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property PowerNotify: Integer index 20 read GetIntegerProp write SetIntegerProp stored False;
    property OnDirectIOEvent: TOPOSCashDrawerDirectIOEvent read FOnDirectIOEvent write FOnDirectIOEvent;
    property OnStatusUpdateEvent: TOPOSCashDrawerStatusUpdateEvent read FOnStatusUpdateEvent write FOnStatusUpdateEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TOPOSCashDrawer.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $00000002, $00000005);
  CControlData: TControlData2 = (
    ClassID: '{CCB90042-B81E-11D2-AB74-0040054C3719}';
    EventIID: '{CCB90043-B81E-11D2-AB74-0040054C3719}';
    EventCount: 2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnDirectIOEvent) - Cardinal(Self);
end;

procedure TOPOSCashDrawer.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IOPOSCashDrawer;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TOPOSCashDrawer.GetControlInterface: IOPOSCashDrawer;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TOPOSCashDrawer.SODataDummy(Status: Integer);
begin
  DefaultInterface.SODataDummy(Status);
end;

procedure TOPOSCashDrawer.SODirectIO(EventNumber: Integer; var pData: Integer; 
                                     var pString: WideString);
begin
  DefaultInterface.SODirectIO(EventNumber, pData, pString);
end;

procedure TOPOSCashDrawer.SOErrorDummy(ResultCode: Integer; ResultCodeExtended: Integer; 
                                       ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  DefaultInterface.SOErrorDummy(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

procedure TOPOSCashDrawer.SOOutputCompleteDummy(OutputID: Integer);
begin
  DefaultInterface.SOOutputCompleteDummy(OutputID);
end;

procedure TOPOSCashDrawer.SOStatusUpdate(Data: Integer);
begin
  DefaultInterface.SOStatusUpdate(Data);
end;

function TOPOSCashDrawer.SOProcessID: Integer;
begin
  Result := DefaultInterface.SOProcessID;
end;

function TOPOSCashDrawer.CheckHealth(Level: Integer): Integer;
begin
  Result := DefaultInterface.CheckHealth(Level);
end;

function TOPOSCashDrawer.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.ClaimDevice(Timeout);
end;

function TOPOSCashDrawer.Close: Integer;
begin
  Result := DefaultInterface.Close;
end;

function TOPOSCashDrawer.DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString);
end;

function TOPOSCashDrawer.Open(const DeviceName: WideString): Integer;
begin
  Result := DefaultInterface.Open(DeviceName);
end;

function TOPOSCashDrawer.ReleaseDevice: Integer;
begin
  Result := DefaultInterface.ReleaseDevice;
end;

function TOPOSCashDrawer.OpenDrawer: Integer;
begin
  Result := DefaultInterface.OpenDrawer;
end;

function TOPOSCashDrawer.WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                            BeepDuration: Integer; BeepDelay: Integer): Integer;
begin
  Result := DefaultInterface.WaitForDrawerClose(BeepTimeout, BeepFrequency, BeepDuration, BeepDelay);
end;

function TOPOSCashDrawer.ResetStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.ResetStatistics(StatisticsBuffer);
end;

function TOPOSCashDrawer.RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.RetrieveStatistics(pStatisticsBuffer);
end;

function TOPOSCashDrawer.UpdateStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.UpdateStatistics(StatisticsBuffer);
end;

function TOPOSCashDrawer.CompareFirmwareVersion(const FirmwareFileName: WideString; 
                                                out pResult: Integer): Integer;
begin
  Result := DefaultInterface.CompareFirmwareVersion(FirmwareFileName, pResult);
end;

function TOPOSCashDrawer.UpdateFirmware(const FirmwareFileName: WideString): Integer;
begin
  Result := DefaultInterface.UpdateFirmware(FirmwareFileName);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TOPOSCashDrawer]);
end;

end.
