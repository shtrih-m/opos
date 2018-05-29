unit SmScale_TLB;

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
// File generated on 28.05.2018 14:19:52 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\projects\OPOSShtrih\Source\SmScale\SmScale.tlb (1)
// LIBID: {934E72FE-30C2-4916-A83F-FEE60461AD5D}
// LCID: 0
// Helpfile: 
// HelpString: SmScale Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  SmScaleMajorVersion = 1;
  SmScaleMinorVersion = 0;

  LIBID_SmScale: TGUID = '{934E72FE-30C2-4916-A83F-FEE60461AD5D}';

  IID_IScale: TGUID = '{AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}';
  CLASS_Scale: TGUID = '{D612E5A4-16D3-40C8-B3F6-3D6A5789D06D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IScale = interface;
  IScaleDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Scale = IScale;


// *********************************************************************//
// Interface: IScale
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}
// *********************************************************************//
  IScale = interface(IDispatch)
    ['{AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}']
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
  end;

// *********************************************************************//
// DispIntf:  IScaleDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}
// *********************************************************************//
  IScaleDisp = dispinterface
    ['{AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}']
    function CheckHealth(Level: Integer): Integer; dispid 1;
    function ClaimDevice(Timeout: Integer): Integer; dispid 2;
    function ClearInput: Integer; dispid 3;
    function ClearOutput: Integer; dispid 4;
    function CloseService: Integer; dispid 5;
    function COFreezeEvents(Freeze: WordBool): Integer; dispid 6;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 7;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 8;
    function DisplayText(const Data: WideString): Integer; dispid 9;
    function GetPropertyNumber(PropIndex: Integer): Integer; dispid 10;
    function GetPropertyString(PropIndex: Integer): WideString; dispid 11;
    function GetSalesPrice: Currency; dispid 12;
    function GetUnitPrice: Currency; dispid 13;
    function OpenService(const DeviceClass: WideString; const DeviceName: WideString; 
                         const pDispatch: IDispatch): Integer; dispid 14;
    function ReadWeight(out pWeightData: Integer; Timeout: Integer): Integer; dispid 15;
    function ReleaseDevice: Integer; dispid 16;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 17;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 18;
    procedure SetPropertyNumber(PropIndex: Integer; Number: Integer); dispid 19;
    procedure SetPropertyString(PropIndex: Integer; const Text: WideString); dispid 20;
    procedure SetUnitPrice(Value: Currency); dispid 21;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 22;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 23;
    function ZeroScale: Integer; dispid 24;
    property OpenResult: Integer readonly dispid 25;
  end;

// *********************************************************************//
// The Class CoScale provides a Create and CreateRemote method to          
// create instances of the default interface IScale exposed by              
// the CoClass Scale. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoScale = class
    class function Create: IScale;
    class function CreateRemote(const MachineName: string): IScale;
  end;

implementation

uses ComObj;

class function CoScale.Create: IScale;
begin
  Result := CreateComObject(CLASS_Scale) as IScale;
end;

class function CoScale.CreateRemote(const MachineName: string): IScale;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Scale) as IScale;
end;

end.
