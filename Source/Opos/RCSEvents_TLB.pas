unit RCSEvents_TLB;

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
// File generated on 18.12.2012 18:29:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: RCSEvents.tlb (1)
// LIBID: {934E72FE-30C2-4916-A83F-FEE60461AD5D}
// LCID: 0
// Helpfile: 
// HelpString: SmScale Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Errors:
//   Hint: TypeInfo 'RCSEvents' changed to 'RCSEvents_'
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
  RCSEventsMajorVersion = 1;
  RCSEventsMinorVersion = 0;

  LIBID_RCSEvents: TGUID = '{934E72FE-30C2-4916-A83F-FEE60461AD5D}';

  IID_IRCSEvents: TGUID = '{AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}';
  CLASS_RCSEvents_: TGUID = '{D612E5A4-16D3-40C8-B3F6-3D6A5789D06D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IRCSEvents = interface;
  IRCSEventsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  RCSEvents_ = IRCSEvents;


// *********************************************************************//
// Interface: IRCSEvents
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}
// *********************************************************************//
  IRCSEvents = interface(IDispatch)
    ['{AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}']
    procedure SOData(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); safecall;
    procedure SOOutputCompleteDummy(OutputID: Integer); safecall;
    procedure SOStatusUpdate(Data: Integer); safecall;
    function SOProcessID: Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IRCSEventsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}
// *********************************************************************//
  IRCSEventsDisp = dispinterface
    ['{AF342B5A-4476-47EB-B2B5-C01F6BBFEB4A}']
    procedure SOData(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputCompleteDummy(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
  end;

// *********************************************************************//
// The Class CoRCSEvents_ provides a Create and CreateRemote method to          
// create instances of the default interface IRCSEvents exposed by              
// the CoClass RCSEvents_. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoRCSEvents_ = class
    class function Create: IRCSEvents;
    class function CreateRemote(const MachineName: string): IRCSEvents;
  end;

implementation

uses ComObj;

class function CoRCSEvents_.Create: IRCSEvents;
begin
  Result := CreateComObject(CLASS_RCSEvents_) as IRCSEvents;
end;

class function CoRCSEvents_.CreateRemote(const MachineName: string): IRCSEvents;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_RCSEvents_) as IRCSEvents;
end;

end.
