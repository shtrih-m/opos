unit OposScale_1_12_Lib_TLB_Var;

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
// File generated on 30.06.2009 16:09:43 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Projects\Work\OposShtrihTrunk\Source\Opos\OposScale_1_12_Lib_TLB.tlb (1)
// LIBID: {CCB90170-B81E-11D2-AB74-0040054C3719}
// LCID: 0
// Helpfile: 
// HelpString: OPOS Scale Control 1.12.000 [Public, by CRM/RCS-Dayton]
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
  IID_IOPOSScale: TGUID = '{CCB94171-B81E-11D2-AB74-0040054C3719}';
  CLASS_OPOSScale: TGUID = '{CCB90172-B81E-11D2-AB74-0040054C3719}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IOPOSScaleEvents = dispinterface;
  IOPOSScale_1_5 = interface;
  IOPOSScale_1_8 = interface;
  IOPOSScale_1_9 = interface;
  IOPOSScale_1_9Disp = dispinterface;
  IOPOSScale = interface;
  IOPOSScaleDisp = dispinterface;

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
// Flags:     (4096) Dispatchable
// GUID:      {CCB91171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_5 = interface(IDispatch)
    ['{CCB91171-B81E-11D2-AB74-0040054C3719}']
    function SOData(Status: Integer): HResult; stdcall;
    function SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString): HResult; stdcall;
    function SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                     var pErrorResponse: Integer): HResult; stdcall;
    function SOOutputCompleteDummy(OutputID: Integer): HResult; stdcall;
    function SOStatusUpdate(Data: Integer): HResult; stdcall;
    function SOProcessID(out pProcessID: Integer): HResult; stdcall;
    function Get_OpenResult(out pOpenResult: Integer): HResult; stdcall;
    function Get_CheckHealthText(out pCheckHealthText: WideString): HResult; stdcall;
    function Get_Claimed(out pClaimed: WordBool): HResult; stdcall;
    function Get_DeviceEnabled(out pDeviceEnabled: WordBool): HResult; stdcall;
    function Set_DeviceEnabled(pDeviceEnabled: WordBool): HResult; stdcall;
    function Get_FreezeEvents(out pFreezeEvents: WordBool): HResult; stdcall;
    function Set_FreezeEvents(pFreezeEvents: WordBool): HResult; stdcall;
    function Get_ResultCode(out pResultCode: Integer): HResult; stdcall;
    function Get_ResultCodeExtended(out pResultCodeExtended: Integer): HResult; stdcall;
    function Get_State(out pState: Integer): HResult; stdcall;
    function Get_ControlObjectDescription(out pControlObjectDescription: WideString): HResult; stdcall;
    function Get_ControlObjectVersion(out pControlObjectVersion: Integer): HResult; stdcall;
    function Get_ServiceObjectDescription(out pServiceObjectDescription: WideString): HResult; stdcall;
    function Get_ServiceObjectVersion(out pServiceObjectVersion: Integer): HResult; stdcall;
    function Get_DeviceDescription(out pDeviceDescription: WideString): HResult; stdcall;
    function Get_DeviceName(out pDeviceName: WideString): HResult; stdcall;
    function CheckHealth(Level: Integer; out pRC: Integer): HResult; stdcall;
    function ClaimDevice(Timeout: Integer; out pRC: Integer): HResult; stdcall;
    function ClearInput(out pRC: Integer): HResult; stdcall;
    function Close(out pRC: Integer): HResult; stdcall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString; 
                      out pRC: Integer): HResult; stdcall;
    function Open(const DeviceName: WideString; out pRC: Integer): HResult; stdcall;
    function ReleaseDevice(out pRC: Integer): HResult; stdcall;
    function Get_MaximumWeight(out pMaximumWeight: Integer): HResult; stdcall;
    function Get_WeightUnit(out pWeightUnit: Integer): HResult; stdcall;
    function Get_WeightUnits(out pWeightUnits: Integer): HResult; stdcall;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer; out pRC: Integer): HResult; stdcall;
    function Get_BinaryConversion(out pBinaryConversion: Integer): HResult; stdcall;
    function Set_BinaryConversion(pBinaryConversion: Integer): HResult; stdcall;
    function Get_CapDisplay(out pCapDisplay: WordBool): HResult; stdcall;
    function Get_AutoDisable(out pAutoDisable: WordBool): HResult; stdcall;
    function Set_AutoDisable(pAutoDisable: WordBool): HResult; stdcall;
    function Get_CapPowerReporting(out pCapPowerReporting: Integer): HResult; stdcall;
    function Get_DataCount(out pDataCount: Integer): HResult; stdcall;
    function Get_DataEventEnabled(out pDataEventEnabled: WordBool): HResult; stdcall;
    function Set_DataEventEnabled(pDataEventEnabled: WordBool): HResult; stdcall;
    function Get_PowerNotify(out pPowerNotify: Integer): HResult; stdcall;
    function Set_PowerNotify(pPowerNotify: Integer): HResult; stdcall;
    function Get_PowerState(out pPowerState: Integer): HResult; stdcall;
    function Get_AsyncMode(out pAsyncMode: WordBool): HResult; stdcall;
    function Set_AsyncMode(pAsyncMode: WordBool): HResult; stdcall;
    function Get_CapDisplayText(out pCapDisplayText: WordBool): HResult; stdcall;
    function Get_CapPriceCalculating(out pCapPriceCalculating: WordBool): HResult; stdcall;
    function Get_CapTareWeight(out pCapTareWeight: WordBool): HResult; stdcall;
    function Get_CapZeroScale(out pCapZeroScale: WordBool): HResult; stdcall;
    function Get_MaxDisplayTextChars(out pMaxDisplayTextChars: Integer): HResult; stdcall;
    function Get_SalesPrice(out pSalesPrice: Currency): HResult; stdcall;
    function Get_TareWeight(out pTareWeight: Integer): HResult; stdcall;
    function Set_TareWeight(pTareWeight: Integer): HResult; stdcall;
    function Get_UnitPrice(out pUnitPrice: Currency): HResult; stdcall;
    function Set_UnitPrice(pUnitPrice: Currency): HResult; stdcall;
    function DisplayText(const Data: WideString; out pRC: Integer): HResult; stdcall;
    function ZeroScale(out pRC: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_8
// Flags:     (4096) Dispatchable
// GUID:      {CCB92171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_8 = interface(IOPOSScale_1_5)
    ['{CCB92171-B81E-11D2-AB74-0040054C3719}']
    function GhostMethod_IOPOSScale_1_8_0_1: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_4_2: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_8_3: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_12_4: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_16_5: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_20_6: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_24_7: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_28_8: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_32_9: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_36_10: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_40_11: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_44_12: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_48_13: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_52_14: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_56_15: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_60_16: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_64_17: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_68_18: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_72_19: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_76_20: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_80_21: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_84_22: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_88_23: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_92_24: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_96_25: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_100_26: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_104_27: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_108_28: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_112_29: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_116_30: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_120_31: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_124_32: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_128_33: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_132_34: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_136_35: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_140_36: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_144_37: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_148_38: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_152_39: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_156_40: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_160_41: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_164_42: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_168_43: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_172_44: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_176_45: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_180_46: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_184_47: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_188_48: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_192_49: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_196_50: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_200_51: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_204_52: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_208_53: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_212_54: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_216_55: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_220_56: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_224_57: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_228_58: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_232_59: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_236_60: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_240_61: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_244_62: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_248_63: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_252_64: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_256_65: HResult; stdcall;
    function GhostMethod_IOPOSScale_1_8_260_66: HResult; stdcall;
    function Get_CapStatisticsReporting(out pCapStatisticsReporting: WordBool): HResult; stdcall;
    function Get_CapUpdateStatistics(out pCapUpdateStatistics: WordBool): HResult; stdcall;
    function ResetStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult; stdcall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString; out pRC: Integer): HResult; stdcall;
    function UpdateStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPOSScale_1_9
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale_1_9 = interface(IOPOSScale_1_8)
    ['{CCB93171-B81E-11D2-AB74-0040054C3719}']
    procedure GhostMethod_IOPOSScale_1_9_0_1; safecall;
    procedure GhostMethod_IOPOSScale_1_9_4_2; safecall;
    procedure GhostMethod_IOPOSScale_1_9_8_3; safecall;
    procedure GhostMethod_IOPOSScale_1_9_12_4; safecall;
    procedure GhostMethod_IOPOSScale_1_9_16_5; safecall;
    procedure GhostMethod_IOPOSScale_1_9_20_6; safecall;
    procedure GhostMethod_IOPOSScale_1_9_24_7; safecall;
    procedure GhostMethod_IOPOSScale_1_9_28_8; safecall;
    procedure GhostMethod_IOPOSScale_1_9_32_9; safecall;
    procedure GhostMethod_IOPOSScale_1_9_36_10; safecall;
    procedure GhostMethod_IOPOSScale_1_9_40_11; safecall;
    procedure GhostMethod_IOPOSScale_1_9_44_12; safecall;
    procedure GhostMethod_IOPOSScale_1_9_48_13; safecall;
    procedure GhostMethod_IOPOSScale_1_9_52_14; safecall;
    procedure GhostMethod_IOPOSScale_1_9_56_15; safecall;
    procedure GhostMethod_IOPOSScale_1_9_60_16; safecall;
    procedure GhostMethod_IOPOSScale_1_9_64_17; safecall;
    procedure GhostMethod_IOPOSScale_1_9_68_18; safecall;
    procedure GhostMethod_IOPOSScale_1_9_72_19; safecall;
    procedure GhostMethod_IOPOSScale_1_9_76_20; safecall;
    procedure GhostMethod_IOPOSScale_1_9_80_21; safecall;
    procedure GhostMethod_IOPOSScale_1_9_84_22; safecall;
    procedure GhostMethod_IOPOSScale_1_9_88_23; safecall;
    procedure GhostMethod_IOPOSScale_1_9_92_24; safecall;
    procedure GhostMethod_IOPOSScale_1_9_96_25; safecall;
    procedure GhostMethod_IOPOSScale_1_9_100_26; safecall;
    procedure GhostMethod_IOPOSScale_1_9_104_27; safecall;
    procedure GhostMethod_IOPOSScale_1_9_108_28; safecall;
    procedure GhostMethod_IOPOSScale_1_9_112_29; safecall;
    procedure GhostMethod_IOPOSScale_1_9_116_30; safecall;
    procedure GhostMethod_IOPOSScale_1_9_120_31; safecall;
    procedure GhostMethod_IOPOSScale_1_9_124_32; safecall;
    procedure GhostMethod_IOPOSScale_1_9_128_33; safecall;
    procedure GhostMethod_IOPOSScale_1_9_132_34; safecall;
    procedure GhostMethod_IOPOSScale_1_9_136_35; safecall;
    procedure GhostMethod_IOPOSScale_1_9_140_36; safecall;
    procedure GhostMethod_IOPOSScale_1_9_144_37; safecall;
    procedure GhostMethod_IOPOSScale_1_9_148_38; safecall;
    procedure GhostMethod_IOPOSScale_1_9_152_39; safecall;
    procedure GhostMethod_IOPOSScale_1_9_156_40; safecall;
    procedure GhostMethod_IOPOSScale_1_9_160_41; safecall;
    procedure GhostMethod_IOPOSScale_1_9_164_42; safecall;
    procedure GhostMethod_IOPOSScale_1_9_168_43; safecall;
    procedure GhostMethod_IOPOSScale_1_9_172_44; safecall;
    procedure GhostMethod_IOPOSScale_1_9_176_45; safecall;
    procedure GhostMethod_IOPOSScale_1_9_180_46; safecall;
    procedure GhostMethod_IOPOSScale_1_9_184_47; safecall;
    procedure GhostMethod_IOPOSScale_1_9_188_48; safecall;
    procedure GhostMethod_IOPOSScale_1_9_192_49; safecall;
    procedure GhostMethod_IOPOSScale_1_9_196_50; safecall;
    procedure GhostMethod_IOPOSScale_1_9_200_51; safecall;
    procedure GhostMethod_IOPOSScale_1_9_204_52; safecall;
    procedure GhostMethod_IOPOSScale_1_9_208_53; safecall;
    procedure GhostMethod_IOPOSScale_1_9_212_54; safecall;
    procedure GhostMethod_IOPOSScale_1_9_216_55; safecall;
    procedure GhostMethod_IOPOSScale_1_9_220_56; safecall;
    procedure GhostMethod_IOPOSScale_1_9_224_57; safecall;
    procedure GhostMethod_IOPOSScale_1_9_228_58; safecall;
    procedure GhostMethod_IOPOSScale_1_9_232_59; safecall;
    procedure GhostMethod_IOPOSScale_1_9_236_60; safecall;
    procedure GhostMethod_IOPOSScale_1_9_240_61; safecall;
    procedure GhostMethod_IOPOSScale_1_9_244_62; safecall;
    procedure GhostMethod_IOPOSScale_1_9_248_63; safecall;
    procedure GhostMethod_IOPOSScale_1_9_252_64; safecall;
    procedure GhostMethod_IOPOSScale_1_9_256_65; safecall;
    procedure GhostMethod_IOPOSScale_1_9_260_66; safecall;
    procedure GhostMethod_IOPOSScale_1_9_264_67; safecall;
    procedure GhostMethod_IOPOSScale_1_9_268_68; safecall;
    procedure GhostMethod_IOPOSScale_1_9_272_69; safecall;
    procedure GhostMethod_IOPOSScale_1_9_276_70; safecall;
    procedure GhostMethod_IOPOSScale_1_9_280_71; safecall;
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
    procedure GhostMethod_IOPOSScale_1_9_0_1; dispid 1610678272;
    procedure GhostMethod_IOPOSScale_1_9_4_2; dispid 1610678273;
    procedure GhostMethod_IOPOSScale_1_9_8_3; dispid 1610678274;
    procedure GhostMethod_IOPOSScale_1_9_12_4; dispid 1610678275;
    procedure GhostMethod_IOPOSScale_1_9_16_5; dispid 1610678276;
    procedure GhostMethod_IOPOSScale_1_9_20_6; dispid 1610678277;
    procedure GhostMethod_IOPOSScale_1_9_24_7; dispid 1610678278;
    procedure GhostMethod_IOPOSScale_1_9_28_8; dispid 1610678279;
    procedure GhostMethod_IOPOSScale_1_9_32_9; dispid 1610678280;
    procedure GhostMethod_IOPOSScale_1_9_36_10; dispid 1610678281;
    procedure GhostMethod_IOPOSScale_1_9_40_11; dispid 1610678282;
    procedure GhostMethod_IOPOSScale_1_9_44_12; dispid 1610678283;
    procedure GhostMethod_IOPOSScale_1_9_48_13; dispid 1610678284;
    procedure GhostMethod_IOPOSScale_1_9_52_14; dispid 1610678285;
    procedure GhostMethod_IOPOSScale_1_9_56_15; dispid 1610678286;
    procedure GhostMethod_IOPOSScale_1_9_60_16; dispid 1610678287;
    procedure GhostMethod_IOPOSScale_1_9_64_17; dispid 1610678288;
    procedure GhostMethod_IOPOSScale_1_9_68_18; dispid 1610678289;
    procedure GhostMethod_IOPOSScale_1_9_72_19; dispid 1610678290;
    procedure GhostMethod_IOPOSScale_1_9_76_20; dispid 1610678291;
    procedure GhostMethod_IOPOSScale_1_9_80_21; dispid 1610678292;
    procedure GhostMethod_IOPOSScale_1_9_84_22; dispid 1610678293;
    procedure GhostMethod_IOPOSScale_1_9_88_23; dispid 1610678294;
    procedure GhostMethod_IOPOSScale_1_9_92_24; dispid 1610678295;
    procedure GhostMethod_IOPOSScale_1_9_96_25; dispid 1610678296;
    procedure GhostMethod_IOPOSScale_1_9_100_26; dispid 1610678297;
    procedure GhostMethod_IOPOSScale_1_9_104_27; dispid 1610678298;
    procedure GhostMethod_IOPOSScale_1_9_108_28; dispid 1610678299;
    procedure GhostMethod_IOPOSScale_1_9_112_29; dispid 1610678300;
    procedure GhostMethod_IOPOSScale_1_9_116_30; dispid 1610678301;
    procedure GhostMethod_IOPOSScale_1_9_120_31; dispid 1610678302;
    procedure GhostMethod_IOPOSScale_1_9_124_32; dispid 1610678303;
    procedure GhostMethod_IOPOSScale_1_9_128_33; dispid 1610678304;
    procedure GhostMethod_IOPOSScale_1_9_132_34; dispid 1610678305;
    procedure GhostMethod_IOPOSScale_1_9_136_35; dispid 1610678306;
    procedure GhostMethod_IOPOSScale_1_9_140_36; dispid 1610678307;
    procedure GhostMethod_IOPOSScale_1_9_144_37; dispid 1610678308;
    procedure GhostMethod_IOPOSScale_1_9_148_38; dispid 1610678309;
    procedure GhostMethod_IOPOSScale_1_9_152_39; dispid 1610678310;
    procedure GhostMethod_IOPOSScale_1_9_156_40; dispid 1610678311;
    procedure GhostMethod_IOPOSScale_1_9_160_41; dispid 1610678312;
    procedure GhostMethod_IOPOSScale_1_9_164_42; dispid 1610678313;
    procedure GhostMethod_IOPOSScale_1_9_168_43; dispid 1610678314;
    procedure GhostMethod_IOPOSScale_1_9_172_44; dispid 1610678315;
    procedure GhostMethod_IOPOSScale_1_9_176_45; dispid 1610678316;
    procedure GhostMethod_IOPOSScale_1_9_180_46; dispid 1610678317;
    procedure GhostMethod_IOPOSScale_1_9_184_47; dispid 1610678318;
    procedure GhostMethod_IOPOSScale_1_9_188_48; dispid 1610678319;
    procedure GhostMethod_IOPOSScale_1_9_192_49; dispid 1610678320;
    procedure GhostMethod_IOPOSScale_1_9_196_50; dispid 1610678321;
    procedure GhostMethod_IOPOSScale_1_9_200_51; dispid 1610678322;
    procedure GhostMethod_IOPOSScale_1_9_204_52; dispid 1610678323;
    procedure GhostMethod_IOPOSScale_1_9_208_53; dispid 1610678324;
    procedure GhostMethod_IOPOSScale_1_9_212_54; dispid 1610678325;
    procedure GhostMethod_IOPOSScale_1_9_216_55; dispid 1610678326;
    procedure GhostMethod_IOPOSScale_1_9_220_56; dispid 1610678327;
    procedure GhostMethod_IOPOSScale_1_9_224_57; dispid 1610678328;
    procedure GhostMethod_IOPOSScale_1_9_228_58; dispid 1610678329;
    procedure GhostMethod_IOPOSScale_1_9_232_59; dispid 1610678330;
    procedure GhostMethod_IOPOSScale_1_9_236_60; dispid 1610678331;
    procedure GhostMethod_IOPOSScale_1_9_240_61; dispid 1610678332;
    procedure GhostMethod_IOPOSScale_1_9_244_62; dispid 1610678333;
    procedure GhostMethod_IOPOSScale_1_9_248_63; dispid 1610678334;
    procedure GhostMethod_IOPOSScale_1_9_252_64; dispid 1610678335;
    procedure GhostMethod_IOPOSScale_1_9_256_65; dispid 1610678336;
    procedure GhostMethod_IOPOSScale_1_9_260_66; dispid 1610678337;
    procedure GhostMethod_IOPOSScale_1_9_264_67; dispid 1610678338;
    procedure GhostMethod_IOPOSScale_1_9_268_68; dispid 1610678339;
    procedure GhostMethod_IOPOSScale_1_9_272_69; dispid 1610678340;
    procedure GhostMethod_IOPOSScale_1_9_276_70; dispid 1610678341;
    procedure GhostMethod_IOPOSScale_1_9_280_71; dispid 1610678342;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatusUpdate: WordBool readonly dispid 63;
    property ScaleLiveWeight: Integer readonly dispid 64;
    property StatusNotify: Integer dispid 65;
    procedure GhostMethod_IOPOSScale_1_8_0_1; dispid 1610678272;
    procedure GhostMethod_IOPOSScale_1_8_4_2; dispid 1610678273;
    procedure GhostMethod_IOPOSScale_1_8_8_3; dispid 1610678274;
    procedure GhostMethod_IOPOSScale_1_8_12_4; dispid 1610678275;
    procedure GhostMethod_IOPOSScale_1_8_16_5; dispid 1610678276;
    procedure GhostMethod_IOPOSScale_1_8_20_6; dispid 1610678277;
    procedure GhostMethod_IOPOSScale_1_8_24_7; dispid 1610678278;
    procedure GhostMethod_IOPOSScale_1_8_28_8; dispid 1610678279;
    procedure GhostMethod_IOPOSScale_1_8_32_9; dispid 1610678280;
    procedure GhostMethod_IOPOSScale_1_8_36_10; dispid 1610678281;
    procedure GhostMethod_IOPOSScale_1_8_40_11; dispid 1610678282;
    procedure GhostMethod_IOPOSScale_1_8_44_12; dispid 1610678283;
    procedure GhostMethod_IOPOSScale_1_8_48_13; dispid 1610678284;
    procedure GhostMethod_IOPOSScale_1_8_52_14; dispid 1610678285;
    procedure GhostMethod_IOPOSScale_1_8_56_15; dispid 1610678286;
    procedure GhostMethod_IOPOSScale_1_8_60_16; dispid 1610678287;
    procedure GhostMethod_IOPOSScale_1_8_64_17; dispid 1610678288;
    procedure GhostMethod_IOPOSScale_1_8_68_18; dispid 1610678289;
    procedure GhostMethod_IOPOSScale_1_8_72_19; dispid 1610678290;
    procedure GhostMethod_IOPOSScale_1_8_76_20; dispid 1610678291;
    procedure GhostMethod_IOPOSScale_1_8_80_21; dispid 1610678292;
    procedure GhostMethod_IOPOSScale_1_8_84_22; dispid 1610678293;
    procedure GhostMethod_IOPOSScale_1_8_88_23; dispid 1610678294;
    procedure GhostMethod_IOPOSScale_1_8_92_24; dispid 1610678295;
    procedure GhostMethod_IOPOSScale_1_8_96_25; dispid 1610678296;
    procedure GhostMethod_IOPOSScale_1_8_100_26; dispid 1610678297;
    procedure GhostMethod_IOPOSScale_1_8_104_27; dispid 1610678298;
    procedure GhostMethod_IOPOSScale_1_8_108_28; dispid 1610678299;
    procedure GhostMethod_IOPOSScale_1_8_112_29; dispid 1610678300;
    procedure GhostMethod_IOPOSScale_1_8_116_30; dispid 1610678301;
    procedure GhostMethod_IOPOSScale_1_8_120_31; dispid 1610678302;
    procedure GhostMethod_IOPOSScale_1_8_124_32; dispid 1610678303;
    procedure GhostMethod_IOPOSScale_1_8_128_33; dispid 1610678304;
    procedure GhostMethod_IOPOSScale_1_8_132_34; dispid 1610678305;
    procedure GhostMethod_IOPOSScale_1_8_136_35; dispid 1610678306;
    procedure GhostMethod_IOPOSScale_1_8_140_36; dispid 1610678307;
    procedure GhostMethod_IOPOSScale_1_8_144_37; dispid 1610678308;
    procedure GhostMethod_IOPOSScale_1_8_148_38; dispid 1610678309;
    procedure GhostMethod_IOPOSScale_1_8_152_39; dispid 1610678310;
    procedure GhostMethod_IOPOSScale_1_8_156_40; dispid 1610678311;
    procedure GhostMethod_IOPOSScale_1_8_160_41; dispid 1610678312;
    procedure GhostMethod_IOPOSScale_1_8_164_42; dispid 1610678313;
    procedure GhostMethod_IOPOSScale_1_8_168_43; dispid 1610678314;
    procedure GhostMethod_IOPOSScale_1_8_172_44; dispid 1610678315;
    procedure GhostMethod_IOPOSScale_1_8_176_45; dispid 1610678316;
    procedure GhostMethod_IOPOSScale_1_8_180_46; dispid 1610678317;
    procedure GhostMethod_IOPOSScale_1_8_184_47; dispid 1610678318;
    procedure GhostMethod_IOPOSScale_1_8_188_48; dispid 1610678319;
    procedure GhostMethod_IOPOSScale_1_8_192_49; dispid 1610678320;
    procedure GhostMethod_IOPOSScale_1_8_196_50; dispid 1610678321;
    procedure GhostMethod_IOPOSScale_1_8_200_51; dispid 1610678322;
    procedure GhostMethod_IOPOSScale_1_8_204_52; dispid 1610678323;
    procedure GhostMethod_IOPOSScale_1_8_208_53; dispid 1610678324;
    procedure GhostMethod_IOPOSScale_1_8_212_54; dispid 1610678325;
    procedure GhostMethod_IOPOSScale_1_8_216_55; dispid 1610678326;
    procedure GhostMethod_IOPOSScale_1_8_220_56; dispid 1610678327;
    procedure GhostMethod_IOPOSScale_1_8_224_57; dispid 1610678328;
    procedure GhostMethod_IOPOSScale_1_8_228_58; dispid 1610678329;
    procedure GhostMethod_IOPOSScale_1_8_232_59; dispid 1610678330;
    procedure GhostMethod_IOPOSScale_1_8_236_60; dispid 1610678331;
    procedure GhostMethod_IOPOSScale_1_8_240_61; dispid 1610678332;
    procedure GhostMethod_IOPOSScale_1_8_244_62; dispid 1610678333;
    procedure GhostMethod_IOPOSScale_1_8_248_63; dispid 1610678334;
    procedure GhostMethod_IOPOSScale_1_8_252_64; dispid 1610678335;
    procedure GhostMethod_IOPOSScale_1_8_256_65; dispid 1610678336;
    procedure GhostMethod_IOPOSScale_1_8_260_66; dispid 1610678337;
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
    function DeviceEnabled: WordBool; dispid 17;
    function FreezeEvents: WordBool; dispid 18;
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
    function BinaryConversion: Integer; dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    function AutoDisable: WordBool; dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    function DataEventEnabled: WordBool; dispid 16;
    function PowerNotify: Integer; dispid 20;
    property PowerState: Integer readonly dispid 21;
    function AsyncMode: WordBool; dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    function TareWeight: Integer; dispid 59;
    function UnitPrice: Currency; dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;

// *********************************************************************//
// Interface: IOPOSScale
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScale = interface(IOPOSScale_1_9)
    ['{CCB94171-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSScaleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94171-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSScaleDisp = dispinterface
    ['{CCB94171-B81E-11D2-AB74-0040054C3719}']
    procedure GhostMethod_IOPOSScale_1_9_0_1; dispid 1610678272;
    procedure GhostMethod_IOPOSScale_1_9_4_2; dispid 1610678273;
    procedure GhostMethod_IOPOSScale_1_9_8_3; dispid 1610678274;
    procedure GhostMethod_IOPOSScale_1_9_12_4; dispid 1610678275;
    procedure GhostMethod_IOPOSScale_1_9_16_5; dispid 1610678276;
    procedure GhostMethod_IOPOSScale_1_9_20_6; dispid 1610678277;
    procedure GhostMethod_IOPOSScale_1_9_24_7; dispid 1610678278;
    procedure GhostMethod_IOPOSScale_1_9_28_8; dispid 1610678279;
    procedure GhostMethod_IOPOSScale_1_9_32_9; dispid 1610678280;
    procedure GhostMethod_IOPOSScale_1_9_36_10; dispid 1610678281;
    procedure GhostMethod_IOPOSScale_1_9_40_11; dispid 1610678282;
    procedure GhostMethod_IOPOSScale_1_9_44_12; dispid 1610678283;
    procedure GhostMethod_IOPOSScale_1_9_48_13; dispid 1610678284;
    procedure GhostMethod_IOPOSScale_1_9_52_14; dispid 1610678285;
    procedure GhostMethod_IOPOSScale_1_9_56_15; dispid 1610678286;
    procedure GhostMethod_IOPOSScale_1_9_60_16; dispid 1610678287;
    procedure GhostMethod_IOPOSScale_1_9_64_17; dispid 1610678288;
    procedure GhostMethod_IOPOSScale_1_9_68_18; dispid 1610678289;
    procedure GhostMethod_IOPOSScale_1_9_72_19; dispid 1610678290;
    procedure GhostMethod_IOPOSScale_1_9_76_20; dispid 1610678291;
    procedure GhostMethod_IOPOSScale_1_9_80_21; dispid 1610678292;
    procedure GhostMethod_IOPOSScale_1_9_84_22; dispid 1610678293;
    procedure GhostMethod_IOPOSScale_1_9_88_23; dispid 1610678294;
    procedure GhostMethod_IOPOSScale_1_9_92_24; dispid 1610678295;
    procedure GhostMethod_IOPOSScale_1_9_96_25; dispid 1610678296;
    procedure GhostMethod_IOPOSScale_1_9_100_26; dispid 1610678297;
    procedure GhostMethod_IOPOSScale_1_9_104_27; dispid 1610678298;
    procedure GhostMethod_IOPOSScale_1_9_108_28; dispid 1610678299;
    procedure GhostMethod_IOPOSScale_1_9_112_29; dispid 1610678300;
    procedure GhostMethod_IOPOSScale_1_9_116_30; dispid 1610678301;
    procedure GhostMethod_IOPOSScale_1_9_120_31; dispid 1610678302;
    procedure GhostMethod_IOPOSScale_1_9_124_32; dispid 1610678303;
    procedure GhostMethod_IOPOSScale_1_9_128_33; dispid 1610678304;
    procedure GhostMethod_IOPOSScale_1_9_132_34; dispid 1610678305;
    procedure GhostMethod_IOPOSScale_1_9_136_35; dispid 1610678306;
    procedure GhostMethod_IOPOSScale_1_9_140_36; dispid 1610678307;
    procedure GhostMethod_IOPOSScale_1_9_144_37; dispid 1610678308;
    procedure GhostMethod_IOPOSScale_1_9_148_38; dispid 1610678309;
    procedure GhostMethod_IOPOSScale_1_9_152_39; dispid 1610678310;
    procedure GhostMethod_IOPOSScale_1_9_156_40; dispid 1610678311;
    procedure GhostMethod_IOPOSScale_1_9_160_41; dispid 1610678312;
    procedure GhostMethod_IOPOSScale_1_9_164_42; dispid 1610678313;
    procedure GhostMethod_IOPOSScale_1_9_168_43; dispid 1610678314;
    procedure GhostMethod_IOPOSScale_1_9_172_44; dispid 1610678315;
    procedure GhostMethod_IOPOSScale_1_9_176_45; dispid 1610678316;
    procedure GhostMethod_IOPOSScale_1_9_180_46; dispid 1610678317;
    procedure GhostMethod_IOPOSScale_1_9_184_47; dispid 1610678318;
    procedure GhostMethod_IOPOSScale_1_9_188_48; dispid 1610678319;
    procedure GhostMethod_IOPOSScale_1_9_192_49; dispid 1610678320;
    procedure GhostMethod_IOPOSScale_1_9_196_50; dispid 1610678321;
    procedure GhostMethod_IOPOSScale_1_9_200_51; dispid 1610678322;
    procedure GhostMethod_IOPOSScale_1_9_204_52; dispid 1610678323;
    procedure GhostMethod_IOPOSScale_1_9_208_53; dispid 1610678324;
    procedure GhostMethod_IOPOSScale_1_9_212_54; dispid 1610678325;
    procedure GhostMethod_IOPOSScale_1_9_216_55; dispid 1610678326;
    procedure GhostMethod_IOPOSScale_1_9_220_56; dispid 1610678327;
    procedure GhostMethod_IOPOSScale_1_9_224_57; dispid 1610678328;
    procedure GhostMethod_IOPOSScale_1_9_228_58; dispid 1610678329;
    procedure GhostMethod_IOPOSScale_1_9_232_59; dispid 1610678330;
    procedure GhostMethod_IOPOSScale_1_9_236_60; dispid 1610678331;
    procedure GhostMethod_IOPOSScale_1_9_240_61; dispid 1610678332;
    procedure GhostMethod_IOPOSScale_1_9_244_62; dispid 1610678333;
    procedure GhostMethod_IOPOSScale_1_9_248_63; dispid 1610678334;
    procedure GhostMethod_IOPOSScale_1_9_252_64; dispid 1610678335;
    procedure GhostMethod_IOPOSScale_1_9_256_65; dispid 1610678336;
    procedure GhostMethod_IOPOSScale_1_9_260_66; dispid 1610678337;
    procedure GhostMethod_IOPOSScale_1_9_264_67; dispid 1610678338;
    procedure GhostMethod_IOPOSScale_1_9_268_68; dispid 1610678339;
    procedure GhostMethod_IOPOSScale_1_9_272_69; dispid 1610678340;
    procedure GhostMethod_IOPOSScale_1_9_276_70; dispid 1610678341;
    procedure GhostMethod_IOPOSScale_1_9_280_71; dispid 1610678342;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapStatusUpdate: WordBool readonly dispid 63;
    property ScaleLiveWeight: Integer readonly dispid 64;
    property StatusNotify: Integer dispid 65;
    procedure GhostMethod_IOPOSScale_1_8_0_1; dispid 1610678272;
    procedure GhostMethod_IOPOSScale_1_8_4_2; dispid 1610678273;
    procedure GhostMethod_IOPOSScale_1_8_8_3; dispid 1610678274;
    procedure GhostMethod_IOPOSScale_1_8_12_4; dispid 1610678275;
    procedure GhostMethod_IOPOSScale_1_8_16_5; dispid 1610678276;
    procedure GhostMethod_IOPOSScale_1_8_20_6; dispid 1610678277;
    procedure GhostMethod_IOPOSScale_1_8_24_7; dispid 1610678278;
    procedure GhostMethod_IOPOSScale_1_8_28_8; dispid 1610678279;
    procedure GhostMethod_IOPOSScale_1_8_32_9; dispid 1610678280;
    procedure GhostMethod_IOPOSScale_1_8_36_10; dispid 1610678281;
    procedure GhostMethod_IOPOSScale_1_8_40_11; dispid 1610678282;
    procedure GhostMethod_IOPOSScale_1_8_44_12; dispid 1610678283;
    procedure GhostMethod_IOPOSScale_1_8_48_13; dispid 1610678284;
    procedure GhostMethod_IOPOSScale_1_8_52_14; dispid 1610678285;
    procedure GhostMethod_IOPOSScale_1_8_56_15; dispid 1610678286;
    procedure GhostMethod_IOPOSScale_1_8_60_16; dispid 1610678287;
    procedure GhostMethod_IOPOSScale_1_8_64_17; dispid 1610678288;
    procedure GhostMethod_IOPOSScale_1_8_68_18; dispid 1610678289;
    procedure GhostMethod_IOPOSScale_1_8_72_19; dispid 1610678290;
    procedure GhostMethod_IOPOSScale_1_8_76_20; dispid 1610678291;
    procedure GhostMethod_IOPOSScale_1_8_80_21; dispid 1610678292;
    procedure GhostMethod_IOPOSScale_1_8_84_22; dispid 1610678293;
    procedure GhostMethod_IOPOSScale_1_8_88_23; dispid 1610678294;
    procedure GhostMethod_IOPOSScale_1_8_92_24; dispid 1610678295;
    procedure GhostMethod_IOPOSScale_1_8_96_25; dispid 1610678296;
    procedure GhostMethod_IOPOSScale_1_8_100_26; dispid 1610678297;
    procedure GhostMethod_IOPOSScale_1_8_104_27; dispid 1610678298;
    procedure GhostMethod_IOPOSScale_1_8_108_28; dispid 1610678299;
    procedure GhostMethod_IOPOSScale_1_8_112_29; dispid 1610678300;
    procedure GhostMethod_IOPOSScale_1_8_116_30; dispid 1610678301;
    procedure GhostMethod_IOPOSScale_1_8_120_31; dispid 1610678302;
    procedure GhostMethod_IOPOSScale_1_8_124_32; dispid 1610678303;
    procedure GhostMethod_IOPOSScale_1_8_128_33; dispid 1610678304;
    procedure GhostMethod_IOPOSScale_1_8_132_34; dispid 1610678305;
    procedure GhostMethod_IOPOSScale_1_8_136_35; dispid 1610678306;
    procedure GhostMethod_IOPOSScale_1_8_140_36; dispid 1610678307;
    procedure GhostMethod_IOPOSScale_1_8_144_37; dispid 1610678308;
    procedure GhostMethod_IOPOSScale_1_8_148_38; dispid 1610678309;
    procedure GhostMethod_IOPOSScale_1_8_152_39; dispid 1610678310;
    procedure GhostMethod_IOPOSScale_1_8_156_40; dispid 1610678311;
    procedure GhostMethod_IOPOSScale_1_8_160_41; dispid 1610678312;
    procedure GhostMethod_IOPOSScale_1_8_164_42; dispid 1610678313;
    procedure GhostMethod_IOPOSScale_1_8_168_43; dispid 1610678314;
    procedure GhostMethod_IOPOSScale_1_8_172_44; dispid 1610678315;
    procedure GhostMethod_IOPOSScale_1_8_176_45; dispid 1610678316;
    procedure GhostMethod_IOPOSScale_1_8_180_46; dispid 1610678317;
    procedure GhostMethod_IOPOSScale_1_8_184_47; dispid 1610678318;
    procedure GhostMethod_IOPOSScale_1_8_188_48; dispid 1610678319;
    procedure GhostMethod_IOPOSScale_1_8_192_49; dispid 1610678320;
    procedure GhostMethod_IOPOSScale_1_8_196_50; dispid 1610678321;
    procedure GhostMethod_IOPOSScale_1_8_200_51; dispid 1610678322;
    procedure GhostMethod_IOPOSScale_1_8_204_52; dispid 1610678323;
    procedure GhostMethod_IOPOSScale_1_8_208_53; dispid 1610678324;
    procedure GhostMethod_IOPOSScale_1_8_212_54; dispid 1610678325;
    procedure GhostMethod_IOPOSScale_1_8_216_55; dispid 1610678326;
    procedure GhostMethod_IOPOSScale_1_8_220_56; dispid 1610678327;
    procedure GhostMethod_IOPOSScale_1_8_224_57; dispid 1610678328;
    procedure GhostMethod_IOPOSScale_1_8_228_58; dispid 1610678329;
    procedure GhostMethod_IOPOSScale_1_8_232_59; dispid 1610678330;
    procedure GhostMethod_IOPOSScale_1_8_236_60; dispid 1610678331;
    procedure GhostMethod_IOPOSScale_1_8_240_61; dispid 1610678332;
    procedure GhostMethod_IOPOSScale_1_8_244_62; dispid 1610678333;
    procedure GhostMethod_IOPOSScale_1_8_248_63; dispid 1610678334;
    procedure GhostMethod_IOPOSScale_1_8_252_64; dispid 1610678335;
    procedure GhostMethod_IOPOSScale_1_8_256_65; dispid 1610678336;
    procedure GhostMethod_IOPOSScale_1_8_260_66; dispid 1610678337;
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
    function DeviceEnabled: WordBool; dispid 17;
    function FreezeEvents: WordBool; dispid 18;
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
    function BinaryConversion: Integer; dispid 11;
    property CapDisplay: WordBool readonly dispid 51;
    function AutoDisable: WordBool; dispid 10;
    property CapPowerReporting: Integer readonly dispid 12;
    property DataCount: Integer readonly dispid 15;
    function DataEventEnabled: WordBool; dispid 16;
    function PowerNotify: Integer; dispid 20;
    property PowerState: Integer readonly dispid 21;
    function AsyncMode: WordBool; dispid 50;
    property CapDisplayText: WordBool readonly dispid 52;
    property CapPriceCalculating: WordBool readonly dispid 53;
    property CapTareWeight: WordBool readonly dispid 54;
    property CapZeroScale: WordBool readonly dispid 55;
    property MaxDisplayTextChars: Integer readonly dispid 56;
    property SalesPrice: Currency readonly dispid 58;
    function TareWeight: Integer; dispid 59;
    function UnitPrice: Currency; dispid 60;
    function DisplayText(const Data: WideString): Integer; dispid 70;
    function ZeroScale: Integer; dispid 72;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TOPOSScale
// Help String      : OPOS Scale Control 1.12.000 [Public, by CRM/RCS-Dayton]
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
    FIntf: OleVariant;
    function  GetControlInterface: OleVariant;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_OpenResult(out pOpenResult: Integer): HResult;
    function Get_CheckHealthText(out pCheckHealthText: WideString): HResult;
    function Get_Claimed(out pClaimed: WordBool): HResult;
    function Get_DeviceEnabled(out pDeviceEnabled: WordBool): HResult;
    function Get_FreezeEvents(out pFreezeEvents: WordBool): HResult;
    function Get_ResultCode(out pResultCode: Integer): HResult;
    function Get_ResultCodeExtended(out pResultCodeExtended: Integer): HResult;
    function Get_State(out pState: Integer): HResult;
    function Get_ControlObjectDescription(out pControlObjectDescription: WideString): HResult;
    function Get_ControlObjectVersion(out pControlObjectVersion: Integer): HResult;
    function Get_ServiceObjectDescription(out pServiceObjectDescription: WideString): HResult;
    function Get_ServiceObjectVersion(out pServiceObjectVersion: Integer): HResult;
    function Get_DeviceDescription(out pDeviceDescription: WideString): HResult;
    function Get_DeviceName(out pDeviceName: WideString): HResult;
    function Get_MaximumWeight(out pMaximumWeight: Integer): HResult;
    function Get_WeightUnit(out pWeightUnit: Integer): HResult;
    function Get_WeightUnits(out pWeightUnits: Integer): HResult;
    function Get_BinaryConversion(out pBinaryConversion: Integer): HResult;
    function Get_CapDisplay(out pCapDisplay: WordBool): HResult;
    function Get_AutoDisable(out pAutoDisable: WordBool): HResult;
    function Get_CapPowerReporting(out pCapPowerReporting: Integer): HResult;
    function Get_DataCount(out pDataCount: Integer): HResult;
    function Get_DataEventEnabled(out pDataEventEnabled: WordBool): HResult;
    function Get_PowerNotify(out pPowerNotify: Integer): HResult;
    function Get_PowerState(out pPowerState: Integer): HResult;
    function Get_AsyncMode(out pAsyncMode: WordBool): HResult;
    function Get_CapDisplayText(out pCapDisplayText: WordBool): HResult;
    function Get_CapPriceCalculating(out pCapPriceCalculating: WordBool): HResult;
    function Get_CapTareWeight(out pCapTareWeight: WordBool): HResult;
    function Get_CapZeroScale(out pCapZeroScale: WordBool): HResult;
    function Get_MaxDisplayTextChars(out pMaxDisplayTextChars: Integer): HResult;
    function Get_SalesPrice(out pSalesPrice: Currency): HResult;
    function Get_TareWeight(out pTareWeight: Integer): HResult;
    function Get_UnitPrice(out pUnitPrice: Currency): HResult;
    function Get_CapStatisticsReporting(out pCapStatisticsReporting: WordBool): HResult;
    function Get_CapUpdateStatistics(out pCapUpdateStatistics: WordBool): HResult;
  public
    function SOData(Status: Integer): HResult;
    function SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString): HResult;
    function SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                     var pErrorResponse: Integer): HResult;
    function SOOutputCompleteDummy(OutputID: Integer): HResult;
    function SOStatusUpdate(Data: Integer): HResult;
    function SOProcessID(out pProcessID: Integer): HResult;
    function CheckHealth(Level: Integer; out pRC: Integer): HResult;
    function ClaimDevice(Timeout: Integer; out pRC: Integer): HResult;
    function ClearInput(out pRC: Integer): HResult;
    function Close(out pRC: Integer): HResult;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString; 
                      out pRC: Integer): HResult;
    function Open(const DeviceName: WideString; out pRC: Integer): HResult;
    function ReleaseDevice(out pRC: Integer): HResult;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer; out pRC: Integer): HResult;
    function DisplayText(const Data: WideString; out pRC: Integer): HResult;
    function ZeroScale(out pRC: Integer): HResult;
    function ResetStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
    function RetrieveStatistics(var pStatisticsBuffer: WideString; out pRC: Integer): HResult;
    function UpdateStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer;
    property  ControlInterface: OleVariant read GetControlInterface;
    property  DefaultInterface: OleVariant read GetControlInterface;
    property CapCompareFirmwareVersion: WordBool index 44 read GetWordBoolProp;
    property CapUpdateFirmware: WordBool index 45 read GetWordBoolProp;
    property CapStatusUpdate: WordBool index 63 read GetWordBoolProp;
    property ScaleLiveWeight: Integer index 64 read GetIntegerProp;
  published
    property Anchors;
    property StatusNotify: Integer index 65 read GetIntegerProp write SetIntegerProp stored False;
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
  if VarIsEmpty(FIntf) then DoCreate;
end;

function TOPOSScale.GetControlInterface: OleVariant;
begin
  CreateControl;
  Result := FIntf;
end;

function TOPOSScale.Get_OpenResult(out pOpenResult: Integer): HResult;
begin
    Result := DefaultInterface.Get_OpenResult(pOpenResult);
end;

function TOPOSScale.Get_CheckHealthText(out pCheckHealthText: WideString): HResult;
begin
    Result := DefaultInterface.Get_CheckHealthText(pCheckHealthText);
end;

function TOPOSScale.Get_Claimed(out pClaimed: WordBool): HResult;
begin
    Result := DefaultInterface.Get_Claimed(pClaimed);
end;

function TOPOSScale.Get_DeviceEnabled(out pDeviceEnabled: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.DeviceEnabled;
end;

function TOPOSScale.Get_FreezeEvents(out pFreezeEvents: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FreezeEvents;
end;

function TOPOSScale.Get_ResultCode(out pResultCode: Integer): HResult;
begin
    Result := DefaultInterface.Get_ResultCode(pResultCode);
end;

function TOPOSScale.Get_ResultCodeExtended(out pResultCodeExtended: Integer): HResult;
begin
    Result := DefaultInterface.Get_ResultCodeExtended(pResultCodeExtended);
end;

function TOPOSScale.Get_State(out pState: Integer): HResult;
begin
    Result := DefaultInterface.Get_State(pState);
end;

function TOPOSScale.Get_ControlObjectDescription(out pControlObjectDescription: WideString): HResult;
begin
    Result := DefaultInterface.Get_ControlObjectDescription(pControlObjectDescription);
end;

function TOPOSScale.Get_ControlObjectVersion(out pControlObjectVersion: Integer): HResult;
begin
    Result := DefaultInterface.Get_ControlObjectVersion(pControlObjectVersion);
end;

function TOPOSScale.Get_ServiceObjectDescription(out pServiceObjectDescription: WideString): HResult;
begin
    Result := DefaultInterface.Get_ServiceObjectDescription(pServiceObjectDescription);
end;

function TOPOSScale.Get_ServiceObjectVersion(out pServiceObjectVersion: Integer): HResult;
begin
    Result := DefaultInterface.Get_ServiceObjectVersion(pServiceObjectVersion);
end;

function TOPOSScale.Get_DeviceDescription(out pDeviceDescription: WideString): HResult;
begin
    Result := DefaultInterface.Get_DeviceDescription(pDeviceDescription);
end;

function TOPOSScale.Get_DeviceName(out pDeviceName: WideString): HResult;
begin
    Result := DefaultInterface.Get_DeviceName(pDeviceName);
end;

function TOPOSScale.Get_MaximumWeight(out pMaximumWeight: Integer): HResult;
begin
    Result := DefaultInterface.Get_MaximumWeight(pMaximumWeight);
end;

function TOPOSScale.Get_WeightUnit(out pWeightUnit: Integer): HResult;
begin
    Result := DefaultInterface.Get_WeightUnit(pWeightUnit);
end;

function TOPOSScale.Get_WeightUnits(out pWeightUnits: Integer): HResult;
begin
    Result := DefaultInterface.Get_WeightUnits(pWeightUnits);
end;

function TOPOSScale.Get_BinaryConversion(out pBinaryConversion: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.BinaryConversion;
end;

function TOPOSScale.Get_CapDisplay(out pCapDisplay: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapDisplay(pCapDisplay);
end;

function TOPOSScale.Get_AutoDisable(out pAutoDisable: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.AutoDisable;
end;

function TOPOSScale.Get_CapPowerReporting(out pCapPowerReporting: Integer): HResult;
begin
    Result := DefaultInterface.Get_CapPowerReporting(pCapPowerReporting);
end;

function TOPOSScale.Get_DataCount(out pDataCount: Integer): HResult;
begin
    Result := DefaultInterface.Get_DataCount(pDataCount);
end;

function TOPOSScale.Get_DataEventEnabled(out pDataEventEnabled: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.DataEventEnabled;
end;

function TOPOSScale.Get_PowerNotify(out pPowerNotify: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PowerNotify;
end;

function TOPOSScale.Get_PowerState(out pPowerState: Integer): HResult;
begin
    Result := DefaultInterface.Get_PowerState(pPowerState);
end;

function TOPOSScale.Get_AsyncMode(out pAsyncMode: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.AsyncMode;
end;

function TOPOSScale.Get_CapDisplayText(out pCapDisplayText: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapDisplayText(pCapDisplayText);
end;

function TOPOSScale.Get_CapPriceCalculating(out pCapPriceCalculating: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPriceCalculating(pCapPriceCalculating);
end;

function TOPOSScale.Get_CapTareWeight(out pCapTareWeight: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapTareWeight(pCapTareWeight);
end;

function TOPOSScale.Get_CapZeroScale(out pCapZeroScale: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapZeroScale(pCapZeroScale);
end;

function TOPOSScale.Get_MaxDisplayTextChars(out pMaxDisplayTextChars: Integer): HResult;
begin
    Result := DefaultInterface.Get_MaxDisplayTextChars(pMaxDisplayTextChars);
end;

function TOPOSScale.Get_SalesPrice(out pSalesPrice: Currency): HResult;
begin
    Result := DefaultInterface.Get_SalesPrice(pSalesPrice);
end;

function TOPOSScale.Get_TareWeight(out pTareWeight: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TareWeight;
end;

function TOPOSScale.Get_UnitPrice(out pUnitPrice: Currency): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.UnitPrice;
end;

function TOPOSScale.Get_CapStatisticsReporting(out pCapStatisticsReporting: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapStatisticsReporting(pCapStatisticsReporting);
end;

function TOPOSScale.Get_CapUpdateStatistics(out pCapUpdateStatistics: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapUpdateStatistics(pCapUpdateStatistics);
end;

function TOPOSScale.SOData(Status: Integer): HResult;
begin
  Result := DefaultInterface.SOData(Status);
end;

function TOPOSScale.SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString): HResult;
begin
  Result := DefaultInterface.SODirectIO(EventNumber, pData, pString);
end;

function TOPOSScale.SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                            var pErrorResponse: Integer): HResult;
begin
  Result := DefaultInterface.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

function TOPOSScale.SOOutputCompleteDummy(OutputID: Integer): HResult;
begin
  Result := DefaultInterface.SOOutputCompleteDummy(OutputID);
end;

function TOPOSScale.SOStatusUpdate(Data: Integer): HResult;
begin
  Result := DefaultInterface.SOStatusUpdate(Data);
end;

function TOPOSScale.SOProcessID(out pProcessID: Integer): HResult;
begin
  Result := DefaultInterface.SOProcessID(pProcessID);
end;

function TOPOSScale.CheckHealth(Level: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.CheckHealth(Level, pRC);
end;

function TOPOSScale.ClaimDevice(Timeout: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ClaimDevice(Timeout, pRC);
end;

function TOPOSScale.ClearInput(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ClearInput(pRC);
end;

function TOPOSScale.Close(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.Close(pRC);
end;

function TOPOSScale.DirectIO(Command: Integer; var pData: Integer; var pString: WideString; 
                             out pRC: Integer): HResult;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString, pRC);
end;

function TOPOSScale.Open(const DeviceName: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.Open(DeviceName, pRC);
end;

function TOPOSScale.ReleaseDevice(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ReleaseDevice(pRC);
end;

function TOPOSScale.ReadWeight(out pWeightData: Integer; Timeout: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ReadWeight(pWeightData, Timeout, pRC);
end;

function TOPOSScale.DisplayText(const Data: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.DisplayText(Data, pRC);
end;

function TOPOSScale.ZeroScale(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ZeroScale(pRC);
end;

function TOPOSScale.ResetStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ResetStatistics(StatisticsBuffer, pRC);
end;

function TOPOSScale.RetrieveStatistics(var pStatisticsBuffer: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.RetrieveStatistics(pStatisticsBuffer, pRC);
end;

function TOPOSScale.UpdateStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.UpdateStatistics(StatisticsBuffer, pRC);
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
