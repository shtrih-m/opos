unit CASHDRAWERLib_TLB;

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
// File generated on 21.10.2011 12:55:54 from Type Library described below.

// ************************************************************************  //
// Type Lib: I:\Projects\OposShtrih\Source\Opos\NCRCashDrawer.tlb (1)
// LIBID: {A0BB5DC0-34C1-11CF-88F3-02608CA3BE43}
// LCID: 0
// Helpfile: 
// HelpString: OPOS CashDrawer Control 1.3 (NCR)
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
  CASHDRAWERLibMajorVersion = 1;
  CASHDRAWERLibMinorVersion = 0;

  LIBID_CASHDRAWERLib: TGUID = '{A0BB5DC0-34C1-11CF-88F3-02608CA3BE43}';

  DIID__DCashDrawer: TGUID = '{A0BB5DC1-34C1-11CF-88F3-02608CA3BE43}';
  DIID__DCashDrawerEvents: TGUID = '{A0BB5DC2-34C1-11CF-88F3-02608CA3BE43}';
  CLASS_CashDrawer: TGUID = '{A0BB5DC3-34C1-11CF-88F3-02608CA3BE43}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _DCashDrawer = dispinterface;
  _DCashDrawerEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CashDrawer = _DCashDrawer;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PInteger1 = ^Integer; {*}
  PWideString1 = ^WideString; {*}


// *********************************************************************//
// DispIntf:  _DCashDrawer
// Flags:     (4112) Hidden Dispatchable
// GUID:      {A0BB5DC1-34C1-11CF-88F3-02608CA3BE43}
// *********************************************************************//
  _DCashDrawer = dispinterface
    ['{A0BB5DC1-34C1-11CF-88F3-02608CA3BE43}']
    property CheckHealthText: WideString dispid 1;
    property Claimed: WordBool dispid 2;
    property DeviceEnabled: WordBool dispid 3;
    property FreezeEvents: WordBool dispid 4;
    property ResultCode: Integer dispid 5;
    property ResultCodeExtended: Integer dispid 6;
    property State: Integer dispid 7;
    property ControlObjectDescription: WideString dispid 8;
    property ControlObjectVersion: Integer dispid 9;
    property ServiceObjectDescription: WideString dispid 10;
    property ServiceObjectVersion: Integer dispid 11;
    property DeviceDescription: WideString dispid 12;
    property DeviceName: WideString dispid 13;
    property CapStatus: WordBool dispid 14;
    property DrawerOpened: WordBool dispid 15;
    property BinaryConversion: Integer dispid 24;
    property CapPowerReporting: Integer dispid 26;
    property PowerNotify: Integer dispid 27;
    property PowerState: Integer dispid 28;
    function Open(const DeviceName: WideString): Integer; dispid 16;
    function Close: Integer; dispid 17;
    function Claim(Timeout: Integer): Integer; dispid 18;
    function Release: Integer; dispid 19;
    function CheckHealth(Level: Integer): Integer; dispid 20;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 21;
    function OpenDrawer: Integer; dispid 22;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer; dispid 23;
    function SOProcessID: Integer; dispid 25;
  end;

// *********************************************************************//
// DispIntf:  _DCashDrawerEvents
// Flags:     (4096) Dispatchable
// GUID:      {A0BB5DC2-34C1-11CF-88F3-02608CA3BE43}
// *********************************************************************//
  _DCashDrawerEvents = dispinterface
    ['{A0BB5DC2-34C1-11CF-88F3-02608CA3BE43}']
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 1;
    procedure StatusUpdateEvent(Data: Integer); dispid 2;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TCashDrawer
// Help String      : CashDrawer Control 1.3
// Default Interface: _DCashDrawer
// Def. Intf. DISP? : Yes
// Event   Interface: _DCashDrawerEvents
// TypeFlags        : (34) CanCreate Control
// *********************************************************************//
  TCashDrawerDirectIOEvent = procedure(ASender: TObject; EventNumber: Integer; var pData: Integer; 
                                                         var pString: WideString) of object;
  TCashDrawerStatusUpdateEvent = procedure(ASender: TObject; Data: Integer) of object;

  TCashDrawer = class(TOleControl)
  private
    FOnDirectIOEvent: TCashDrawerDirectIOEvent;
    FOnStatusUpdateEvent: TCashDrawerStatusUpdateEvent;
    FIntf: _DCashDrawer;
    function  GetControlInterface: _DCashDrawer;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    function Open(const DeviceName: WideString): Integer;
    function Close: Integer;
    function Claim(Timeout: Integer): Integer;
    function Release: Integer;
    function CheckHealth(Level: Integer): Integer;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
    function OpenDrawer: Integer;
    function WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                BeepDuration: Integer; BeepDelay: Integer): Integer;
    function SOProcessID: Integer;
    property  ControlInterface: _DCashDrawer read GetControlInterface;
    property  DefaultInterface: _DCashDrawer read GetControlInterface;
  published
    property Anchors;
    property CheckHealthText: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property Claimed: WordBool index 2 read GetWordBoolProp write SetWordBoolProp stored False;
    property DeviceEnabled: WordBool index 3 read GetWordBoolProp write SetWordBoolProp stored False;
    property FreezeEvents: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property ResultCode: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property ResultCodeExtended: Integer index 6 read GetIntegerProp write SetIntegerProp stored False;
    property State: Integer index 7 read GetIntegerProp write SetIntegerProp stored False;
    property ControlObjectDescription: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property ControlObjectVersion: Integer index 9 read GetIntegerProp write SetIntegerProp stored False;
    property ServiceObjectDescription: WideString index 10 read GetWideStringProp write SetWideStringProp stored False;
    property ServiceObjectVersion: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property DeviceDescription: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property DeviceName: WideString index 13 read GetWideStringProp write SetWideStringProp stored False;
    property CapStatus: WordBool index 14 read GetWordBoolProp write SetWordBoolProp stored False;
    property DrawerOpened: WordBool index 15 read GetWordBoolProp write SetWordBoolProp stored False;
    property BinaryConversion: Integer index 24 read GetIntegerProp write SetIntegerProp stored False;
    property CapPowerReporting: Integer index 26 read GetIntegerProp write SetIntegerProp stored False;
    property PowerNotify: Integer index 27 read GetIntegerProp write SetIntegerProp stored False;
    property PowerState: Integer index 28 read GetIntegerProp write SetIntegerProp stored False;
    property OnDirectIOEvent: TCashDrawerDirectIOEvent read FOnDirectIOEvent write FOnDirectIOEvent;
    property OnStatusUpdateEvent: TCashDrawerStatusUpdateEvent read FOnStatusUpdateEvent write FOnStatusUpdateEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TCashDrawer.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $00000001, $00000002);
  CControlData: TControlData2 = (
    ClassID: '{A0BB5DC3-34C1-11CF-88F3-02608CA3BE43}';
    EventIID: '{A0BB5DC2-34C1-11CF-88F3-02608CA3BE43}';
    EventCount: 2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004005*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnDirectIOEvent) - Cardinal(Self);
end;

procedure TCashDrawer.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as _DCashDrawer;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TCashDrawer.GetControlInterface: _DCashDrawer;
begin
  CreateControl;
  Result := FIntf;
end;

function TCashDrawer.Open(const DeviceName: WideString): Integer;
begin
  Result := DefaultInterface.Open(DeviceName);
end;

function TCashDrawer.Close: Integer;
begin
  Result := DefaultInterface.Close;
end;

function TCashDrawer.Claim(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.Claim(Timeout);
end;

function TCashDrawer.Release: Integer;
begin
  Result := DefaultInterface.Release;
end;

function TCashDrawer.CheckHealth(Level: Integer): Integer;
begin
  Result := DefaultInterface.CheckHealth(Level);
end;

function TCashDrawer.DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString);
end;

function TCashDrawer.OpenDrawer: Integer;
begin
  Result := DefaultInterface.OpenDrawer;
end;

function TCashDrawer.WaitForDrawerClose(BeepTimeout: Integer; BeepFrequency: Integer; 
                                        BeepDuration: Integer; BeepDelay: Integer): Integer;
begin
  Result := DefaultInterface.WaitForDrawerClose(BeepTimeout, BeepFrequency, BeepDuration, BeepDelay);
end;

function TCashDrawer.SOProcessID: Integer;
begin
  Result := DefaultInterface.SOProcessID;
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TCashDrawer]);
end;

end.
