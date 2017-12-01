unit FptrServerLib_TLB;

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
// File generated on 01.12.2017 16:26:10 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\projects\OPOSShtrih\Source\SmFptrSrv\SmFptrSrv.tlb (1)
// LIBID: {B082E684-3F10-4B82-8D81-79F0B2D4F0AF}
// LCID: 0
// Helpfile: 
// HelpString: OPOS print server
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
  FptrServerLibMajorVersion = 1;
  FptrServerLibMinorVersion = 3;

  LIBID_FptrServerLib: TGUID = '{B082E684-3F10-4B82-8D81-79F0B2D4F0AF}';

  IID_IFptrServer: TGUID = '{F1005939-85FF-49AE-A535-3D024E5047E0}';
  CLASS_FptrServer: TGUID = '{1064A946-8207-4DCF-97D1-8DD86D83ED9C}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IFptrServer = interface;
  IFptrServerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  FptrServer = IFptrServer;


// *********************************************************************//
// Interface: IFptrServer
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F1005939-85FF-49AE-A535-3D024E5047E0}
// *********************************************************************//
  IFptrServer = interface(IDispatch)
    ['{F1005939-85FF-49AE-A535-3D024E5047E0}']
    function ClaimDevice(PortNumber: Integer; Timeout: Integer): Integer; safecall;
    function ClosePort: Integer; safecall;
    function CloseReceipt: Integer; safecall;
    function Connect(AAppPID: Integer; const AAppName: WideString; const ACompName: WideString): Integer; safecall;
    function Disconnect: Integer; safecall;
    function OpenPort(BaudRate: Integer; Timeout: Integer): Integer; safecall;
    function OpenReceipt(Password: Integer): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function SendData(Timeout: Integer; const TxData: WideString; out ResultCode: Integer): WideString; safecall;
    function Get_ClientAppName: WideString; safecall;
    function Get_ClientCompName: WideString; safecall;
    function Get_ClientPID: Integer; safecall;
    function Get_Connected: WordBool; safecall;
    function Get_FileVersion: WideString; safecall;
    function Get_IsClaimed: WordBool; safecall;
    function Get_IsPortOpened: WordBool; safecall;
    function Get_IsReceiptOpened: WordBool; safecall;
    function Get_ResultCode: Integer; safecall;
    function Get_ResultDescription: WideString; safecall;
    property ClientAppName: WideString read Get_ClientAppName;
    property ClientCompName: WideString read Get_ClientCompName;
    property ClientPID: Integer read Get_ClientPID;
    property Connected: WordBool read Get_Connected;
    property FileVersion: WideString read Get_FileVersion;
    property IsClaimed: WordBool read Get_IsClaimed;
    property IsPortOpened: WordBool read Get_IsPortOpened;
    property IsReceiptOpened: WordBool read Get_IsReceiptOpened;
    property ResultCode: Integer read Get_ResultCode;
    property ResultDescription: WideString read Get_ResultDescription;
  end;

// *********************************************************************//
// DispIntf:  IFptrServerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F1005939-85FF-49AE-A535-3D024E5047E0}
// *********************************************************************//
  IFptrServerDisp = dispinterface
    ['{F1005939-85FF-49AE-A535-3D024E5047E0}']
    function ClaimDevice(PortNumber: Integer; Timeout: Integer): Integer; dispid 1;
    function ClosePort: Integer; dispid 2;
    function CloseReceipt: Integer; dispid 3;
    function Connect(AAppPID: Integer; const AAppName: WideString; const ACompName: WideString): Integer; dispid 4;
    function Disconnect: Integer; dispid 5;
    function OpenPort(BaudRate: Integer; Timeout: Integer): Integer; dispid 6;
    function OpenReceipt(Password: Integer): Integer; dispid 7;
    function ReleaseDevice: Integer; dispid 8;
    function SendData(Timeout: Integer; const TxData: WideString; out ResultCode: Integer): WideString; dispid 9;
    property ClientAppName: WideString readonly dispid 10;
    property ClientCompName: WideString readonly dispid 11;
    property ClientPID: Integer readonly dispid 12;
    property Connected: WordBool readonly dispid 13;
    property FileVersion: WideString readonly dispid 14;
    property IsClaimed: WordBool readonly dispid 15;
    property IsPortOpened: WordBool readonly dispid 16;
    property IsReceiptOpened: WordBool readonly dispid 17;
    property ResultCode: Integer readonly dispid 18;
    property ResultDescription: WideString readonly dispid 19;
  end;

// *********************************************************************//
// The Class CoFptrServer provides a Create and CreateRemote method to          
// create instances of the default interface IFptrServer exposed by              
// the CoClass FptrServer. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoFptrServer = class
    class function Create: IFptrServer;
    class function CreateRemote(const MachineName: string): IFptrServer;
  end;

implementation

uses ComObj;

class function CoFptrServer.Create: IFptrServer;
begin
  Result := CreateComObject(CLASS_FptrServer) as IFptrServer;
end;

class function CoFptrServer.CreateRemote(const MachineName: string): IFptrServer;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_FptrServer) as IFptrServer;
end;

end.
