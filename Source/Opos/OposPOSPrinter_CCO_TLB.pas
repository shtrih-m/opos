unit OposPOSPrinter_CCO_TLB;

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
// File generated on 27.07.2016 21:59:59 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\projects\OPOSShtrih\Source\Opos\OPOSPOSPrinter.tlb (1)
// LIBID: {CCB90150-B81E-11D2-AB74-0040054C3719}
// LCID: 0
// Helpfile: 
// HelpString: OPOS POSPrinter Control 1.13.003 [Public, by CRM/MCS]
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
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
  OposPOSPrinter_CCOMajorVersion = 1;
  OposPOSPrinter_CCOMinorVersion = 0;

  LIBID_OposPOSPrinter_CCO: TGUID = '{CCB90150-B81E-11D2-AB74-0040054C3719}';

  DIID__IOPOSPOSPrinterEvents: TGUID = '{CCB90153-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_5: TGUID = '{CCB91151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_7: TGUID = '{CCB92151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_8: TGUID = '{CCB93151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_9: TGUID = '{CCB94151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_10: TGUID = '{CCB95151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_13: TGUID = '{CCB97151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter: TGUID = '{CCB98151-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSPOSPrinter_1_10_zz: TGUID = '{CCB96151-B81E-11D2-AB74-0040054C3719}';
  CLASS_OPOSPOSPrinter: TGUID = '{CCB90152-B81E-11D2-AB74-0040054C3719}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IOPOSPOSPrinterEvents = dispinterface;
  IOPOSPOSPrinter_1_5 = interface;
  IOPOSPOSPrinter_1_5Disp = dispinterface;
  IOPOSPOSPrinter_1_7 = interface;
  IOPOSPOSPrinter_1_7Disp = dispinterface;
  IOPOSPOSPrinter_1_8 = interface;
  IOPOSPOSPrinter_1_8Disp = dispinterface;
  IOPOSPOSPrinter_1_9 = interface;
  IOPOSPOSPrinter_1_9Disp = dispinterface;
  IOPOSPOSPrinter_1_10 = interface;
  IOPOSPOSPrinter_1_10Disp = dispinterface;
  IOPOSPOSPrinter_1_13 = interface;
  IOPOSPOSPrinter_1_13Disp = dispinterface;
  IOPOSPOSPrinter = interface;
  IOPOSPOSPrinterDisp = dispinterface;
  IOPOSPOSPrinter_1_10_zz = interface;
  IOPOSPOSPrinter_1_10_zzDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OPOSPOSPrinter = IOPOSPOSPrinter;


// *********************************************************************//
// DispIntf:  _IOPOSPOSPrinterEvents
// Flags:     (4096) Dispatchable
// GUID:      {CCB90153-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  _IOPOSPOSPrinterEvents = dispinterface
    ['{CCB90153-B81E-11D2-AB74-0040054C3719}']
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure ErrorEvent(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                         var pErrorResponse: Integer); dispid 3;
    procedure OutputCompleteEvent(OutputID: Integer); dispid 4;
    procedure StatusUpdateEvent(Data: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_5
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_5 = interface(IDispatch)
    ['{CCB91151-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); safecall;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); safecall;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); safecall;
    procedure SOOutputComplete(OutputID: Integer); safecall;
    procedure SOStatusUpdate(Data: Integer); safecall;
    function SOProcessID: Integer; safecall;
    function Get_OpenResult: Integer; safecall;
    function Get_CheckHealthText: WideString; safecall;
    function Get_Claimed: WordBool; safecall;
    function Get_DeviceEnabled: WordBool; safecall;
    procedure Set_DeviceEnabled(pDeviceEnabled: WordBool); safecall;
    function Get_FreezeEvents: WordBool; safecall;
    procedure Set_FreezeEvents(pFreezeEvents: WordBool); safecall;
    function Get_OutputID: Integer; safecall;
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
    function ClearOutput: Integer; safecall;
    function Close: Integer; safecall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; safecall;
    function Open(const DeviceName: WideString): Integer; safecall;
    function ReleaseDevice: Integer; safecall;
    function Get_AsyncMode: WordBool; safecall;
    procedure Set_AsyncMode(pAsyncMode: WordBool); safecall;
    function Get_CapConcurrentJrnRec: WordBool; safecall;
    function Get_CapConcurrentJrnSlp: WordBool; safecall;
    function Get_CapConcurrentRecSlp: WordBool; safecall;
    function Get_CapCoverSensor: WordBool; safecall;
    function Get_CapJrn2Color: WordBool; safecall;
    function Get_CapJrnBold: WordBool; safecall;
    function Get_CapJrnDhigh: WordBool; safecall;
    function Get_CapJrnDwide: WordBool; safecall;
    function Get_CapJrnDwideDhigh: WordBool; safecall;
    function Get_CapJrnEmptySensor: WordBool; safecall;
    function Get_CapJrnItalic: WordBool; safecall;
    function Get_CapJrnNearEndSensor: WordBool; safecall;
    function Get_CapJrnPresent: WordBool; safecall;
    function Get_CapJrnUnderline: WordBool; safecall;
    function Get_CapRec2Color: WordBool; safecall;
    function Get_CapRecBarCode: WordBool; safecall;
    function Get_CapRecBitmap: WordBool; safecall;
    function Get_CapRecBold: WordBool; safecall;
    function Get_CapRecDhigh: WordBool; safecall;
    function Get_CapRecDwide: WordBool; safecall;
    function Get_CapRecDwideDhigh: WordBool; safecall;
    function Get_CapRecEmptySensor: WordBool; safecall;
    function Get_CapRecItalic: WordBool; safecall;
    function Get_CapRecLeft90: WordBool; safecall;
    function Get_CapRecNearEndSensor: WordBool; safecall;
    function Get_CapRecPapercut: WordBool; safecall;
    function Get_CapRecPresent: WordBool; safecall;
    function Get_CapRecRight90: WordBool; safecall;
    function Get_CapRecRotate180: WordBool; safecall;
    function Get_CapRecStamp: WordBool; safecall;
    function Get_CapRecUnderline: WordBool; safecall;
    function Get_CapSlp2Color: WordBool; safecall;
    function Get_CapSlpBarCode: WordBool; safecall;
    function Get_CapSlpBitmap: WordBool; safecall;
    function Get_CapSlpBold: WordBool; safecall;
    function Get_CapSlpDhigh: WordBool; safecall;
    function Get_CapSlpDwide: WordBool; safecall;
    function Get_CapSlpDwideDhigh: WordBool; safecall;
    function Get_CapSlpEmptySensor: WordBool; safecall;
    function Get_CapSlpFullslip: WordBool; safecall;
    function Get_CapSlpItalic: WordBool; safecall;
    function Get_CapSlpLeft90: WordBool; safecall;
    function Get_CapSlpNearEndSensor: WordBool; safecall;
    function Get_CapSlpPresent: WordBool; safecall;
    function Get_CapSlpRight90: WordBool; safecall;
    function Get_CapSlpRotate180: WordBool; safecall;
    function Get_CapSlpUnderline: WordBool; safecall;
    function Get_CharacterSet: Integer; safecall;
    procedure Set_CharacterSet(pCharacterSet: Integer); safecall;
    function Get_CharacterSetList: WideString; safecall;
    function Get_CoverOpen: WordBool; safecall;
    function Get_ErrorStation: Integer; safecall;
    function Get_FlagWhenIdle: WordBool; safecall;
    procedure Set_FlagWhenIdle(pFlagWhenIdle: WordBool); safecall;
    function Get_JrnEmpty: WordBool; safecall;
    function Get_JrnLetterQuality: WordBool; safecall;
    procedure Set_JrnLetterQuality(pJrnLetterQuality: WordBool); safecall;
    function Get_JrnLineChars: Integer; safecall;
    procedure Set_JrnLineChars(pJrnLineChars: Integer); safecall;
    function Get_JrnLineCharsList: WideString; safecall;
    function Get_JrnLineHeight: Integer; safecall;
    procedure Set_JrnLineHeight(pJrnLineHeight: Integer); safecall;
    function Get_JrnLineSpacing: Integer; safecall;
    procedure Set_JrnLineSpacing(pJrnLineSpacing: Integer); safecall;
    function Get_JrnLineWidth: Integer; safecall;
    function Get_JrnNearEnd: WordBool; safecall;
    function Get_MapMode: Integer; safecall;
    procedure Set_MapMode(pMapMode: Integer); safecall;
    function Get_RecEmpty: WordBool; safecall;
    function Get_RecLetterQuality: WordBool; safecall;
    procedure Set_RecLetterQuality(pRecLetterQuality: WordBool); safecall;
    function Get_RecLineChars: Integer; safecall;
    procedure Set_RecLineChars(pRecLineChars: Integer); safecall;
    function Get_RecLineCharsList: WideString; safecall;
    function Get_RecLineHeight: Integer; safecall;
    procedure Set_RecLineHeight(pRecLineHeight: Integer); safecall;
    function Get_RecLineSpacing: Integer; safecall;
    procedure Set_RecLineSpacing(pRecLineSpacing: Integer); safecall;
    function Get_RecLinesToPaperCut: Integer; safecall;
    function Get_RecLineWidth: Integer; safecall;
    function Get_RecNearEnd: WordBool; safecall;
    function Get_RecSidewaysMaxChars: Integer; safecall;
    function Get_RecSidewaysMaxLines: Integer; safecall;
    function Get_SlpEmpty: WordBool; safecall;
    function Get_SlpLetterQuality: WordBool; safecall;
    procedure Set_SlpLetterQuality(pSlpLetterQuality: WordBool); safecall;
    function Get_SlpLineChars: Integer; safecall;
    procedure Set_SlpLineChars(pSlpLineChars: Integer); safecall;
    function Get_SlpLineCharsList: WideString; safecall;
    function Get_SlpLineHeight: Integer; safecall;
    procedure Set_SlpLineHeight(pSlpLineHeight: Integer); safecall;
    function Get_SlpLinesNearEndToEnd: Integer; safecall;
    function Get_SlpLineSpacing: Integer; safecall;
    procedure Set_SlpLineSpacing(pSlpLineSpacing: Integer); safecall;
    function Get_SlpLineWidth: Integer; safecall;
    function Get_SlpMaxLines: Integer; safecall;
    function Get_SlpNearEnd: WordBool; safecall;
    function Get_SlpSidewaysMaxChars: Integer; safecall;
    function Get_SlpSidewaysMaxLines: Integer; safecall;
    function BeginInsertion(Timeout: Integer): Integer; safecall;
    function BeginRemoval(Timeout: Integer): Integer; safecall;
    function CutPaper(Percentage: Integer): Integer; safecall;
    function EndInsertion: Integer; safecall;
    function EndRemoval: Integer; safecall;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; safecall;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; safecall;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; safecall;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; safecall;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; safecall;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; safecall;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; safecall;
    function SetLogo(Location: Integer; const Data: WideString): Integer; safecall;
    function Get_CapCharacterSet: Integer; safecall;
    function Get_CapTransaction: WordBool; safecall;
    function Get_ErrorLevel: Integer; safecall;
    function Get_ErrorString: WideString; safecall;
    function Get_FontTypefaceList: WideString; safecall;
    function Get_RecBarCodeRotationList: WideString; safecall;
    function Get_RotateSpecial: Integer; safecall;
    procedure Set_RotateSpecial(pRotateSpecial: Integer); safecall;
    function Get_SlpBarCodeRotationList: WideString; safecall;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; safecall;
    function ValidateData(Station: Integer; const Data: WideString): Integer; safecall;
    function Get_BinaryConversion: Integer; safecall;
    procedure Set_BinaryConversion(pBinaryConversion: Integer); safecall;
    function Get_CapPowerReporting: Integer; safecall;
    function Get_PowerNotify: Integer; safecall;
    procedure Set_PowerNotify(pPowerNotify: Integer); safecall;
    function Get_PowerState: Integer; safecall;
    function Get_CapJrnCartridgeSensor: Integer; safecall;
    function Get_CapJrnColor: Integer; safecall;
    function Get_CapRecCartridgeSensor: Integer; safecall;
    function Get_CapRecColor: Integer; safecall;
    function Get_CapRecMarkFeed: Integer; safecall;
    function Get_CapSlpBothSidesPrint: WordBool; safecall;
    function Get_CapSlpCartridgeSensor: Integer; safecall;
    function Get_CapSlpColor: Integer; safecall;
    function Get_CartridgeNotify: Integer; safecall;
    procedure Set_CartridgeNotify(pCartridgeNotify: Integer); safecall;
    function Get_JrnCartridgeState: Integer; safecall;
    function Get_JrnCurrentCartridge: Integer; safecall;
    procedure Set_JrnCurrentCartridge(pJrnCurrentCartridge: Integer); safecall;
    function Get_RecCartridgeState: Integer; safecall;
    function Get_RecCurrentCartridge: Integer; safecall;
    procedure Set_RecCurrentCartridge(pRecCurrentCartridge: Integer); safecall;
    function Get_SlpCartridgeState: Integer; safecall;
    function Get_SlpCurrentCartridge: Integer; safecall;
    procedure Set_SlpCurrentCartridge(pSlpCurrentCartridge: Integer); safecall;
    function Get_SlpPrintSide: Integer; safecall;
    function ChangePrintSide(Side: Integer): Integer; safecall;
    function MarkFeed(Type_: Integer): Integer; safecall;
    property OpenResult: Integer read Get_OpenResult;
    property CheckHealthText: WideString read Get_CheckHealthText;
    property Claimed: WordBool read Get_Claimed;
    property DeviceEnabled: WordBool read Get_DeviceEnabled write Set_DeviceEnabled;
    property FreezeEvents: WordBool read Get_FreezeEvents write Set_FreezeEvents;
    property OutputID: Integer read Get_OutputID;
    property ResultCode: Integer read Get_ResultCode;
    property ResultCodeExtended: Integer read Get_ResultCodeExtended;
    property State: Integer read Get_State;
    property ControlObjectDescription: WideString read Get_ControlObjectDescription;
    property ControlObjectVersion: Integer read Get_ControlObjectVersion;
    property ServiceObjectDescription: WideString read Get_ServiceObjectDescription;
    property ServiceObjectVersion: Integer read Get_ServiceObjectVersion;
    property DeviceDescription: WideString read Get_DeviceDescription;
    property DeviceName: WideString read Get_DeviceName;
    property AsyncMode: WordBool read Get_AsyncMode write Set_AsyncMode;
    property CapConcurrentJrnRec: WordBool read Get_CapConcurrentJrnRec;
    property CapConcurrentJrnSlp: WordBool read Get_CapConcurrentJrnSlp;
    property CapConcurrentRecSlp: WordBool read Get_CapConcurrentRecSlp;
    property CapCoverSensor: WordBool read Get_CapCoverSensor;
    property CapJrn2Color: WordBool read Get_CapJrn2Color;
    property CapJrnBold: WordBool read Get_CapJrnBold;
    property CapJrnDhigh: WordBool read Get_CapJrnDhigh;
    property CapJrnDwide: WordBool read Get_CapJrnDwide;
    property CapJrnDwideDhigh: WordBool read Get_CapJrnDwideDhigh;
    property CapJrnEmptySensor: WordBool read Get_CapJrnEmptySensor;
    property CapJrnItalic: WordBool read Get_CapJrnItalic;
    property CapJrnNearEndSensor: WordBool read Get_CapJrnNearEndSensor;
    property CapJrnPresent: WordBool read Get_CapJrnPresent;
    property CapJrnUnderline: WordBool read Get_CapJrnUnderline;
    property CapRec2Color: WordBool read Get_CapRec2Color;
    property CapRecBarCode: WordBool read Get_CapRecBarCode;
    property CapRecBitmap: WordBool read Get_CapRecBitmap;
    property CapRecBold: WordBool read Get_CapRecBold;
    property CapRecDhigh: WordBool read Get_CapRecDhigh;
    property CapRecDwide: WordBool read Get_CapRecDwide;
    property CapRecDwideDhigh: WordBool read Get_CapRecDwideDhigh;
    property CapRecEmptySensor: WordBool read Get_CapRecEmptySensor;
    property CapRecItalic: WordBool read Get_CapRecItalic;
    property CapRecLeft90: WordBool read Get_CapRecLeft90;
    property CapRecNearEndSensor: WordBool read Get_CapRecNearEndSensor;
    property CapRecPapercut: WordBool read Get_CapRecPapercut;
    property CapRecPresent: WordBool read Get_CapRecPresent;
    property CapRecRight90: WordBool read Get_CapRecRight90;
    property CapRecRotate180: WordBool read Get_CapRecRotate180;
    property CapRecStamp: WordBool read Get_CapRecStamp;
    property CapRecUnderline: WordBool read Get_CapRecUnderline;
    property CapSlp2Color: WordBool read Get_CapSlp2Color;
    property CapSlpBarCode: WordBool read Get_CapSlpBarCode;
    property CapSlpBitmap: WordBool read Get_CapSlpBitmap;
    property CapSlpBold: WordBool read Get_CapSlpBold;
    property CapSlpDhigh: WordBool read Get_CapSlpDhigh;
    property CapSlpDwide: WordBool read Get_CapSlpDwide;
    property CapSlpDwideDhigh: WordBool read Get_CapSlpDwideDhigh;
    property CapSlpEmptySensor: WordBool read Get_CapSlpEmptySensor;
    property CapSlpFullslip: WordBool read Get_CapSlpFullslip;
    property CapSlpItalic: WordBool read Get_CapSlpItalic;
    property CapSlpLeft90: WordBool read Get_CapSlpLeft90;
    property CapSlpNearEndSensor: WordBool read Get_CapSlpNearEndSensor;
    property CapSlpPresent: WordBool read Get_CapSlpPresent;
    property CapSlpRight90: WordBool read Get_CapSlpRight90;
    property CapSlpRotate180: WordBool read Get_CapSlpRotate180;
    property CapSlpUnderline: WordBool read Get_CapSlpUnderline;
    property CharacterSet: Integer read Get_CharacterSet write Set_CharacterSet;
    property CharacterSetList: WideString read Get_CharacterSetList;
    property CoverOpen: WordBool read Get_CoverOpen;
    property ErrorStation: Integer read Get_ErrorStation;
    property FlagWhenIdle: WordBool read Get_FlagWhenIdle write Set_FlagWhenIdle;
    property JrnEmpty: WordBool read Get_JrnEmpty;
    property JrnLetterQuality: WordBool read Get_JrnLetterQuality write Set_JrnLetterQuality;
    property JrnLineChars: Integer read Get_JrnLineChars write Set_JrnLineChars;
    property JrnLineCharsList: WideString read Get_JrnLineCharsList;
    property JrnLineHeight: Integer read Get_JrnLineHeight write Set_JrnLineHeight;
    property JrnLineSpacing: Integer read Get_JrnLineSpacing write Set_JrnLineSpacing;
    property JrnLineWidth: Integer read Get_JrnLineWidth;
    property JrnNearEnd: WordBool read Get_JrnNearEnd;
    property MapMode: Integer read Get_MapMode write Set_MapMode;
    property RecEmpty: WordBool read Get_RecEmpty;
    property RecLetterQuality: WordBool read Get_RecLetterQuality write Set_RecLetterQuality;
    property RecLineChars: Integer read Get_RecLineChars write Set_RecLineChars;
    property RecLineCharsList: WideString read Get_RecLineCharsList;
    property RecLineHeight: Integer read Get_RecLineHeight write Set_RecLineHeight;
    property RecLineSpacing: Integer read Get_RecLineSpacing write Set_RecLineSpacing;
    property RecLinesToPaperCut: Integer read Get_RecLinesToPaperCut;
    property RecLineWidth: Integer read Get_RecLineWidth;
    property RecNearEnd: WordBool read Get_RecNearEnd;
    property RecSidewaysMaxChars: Integer read Get_RecSidewaysMaxChars;
    property RecSidewaysMaxLines: Integer read Get_RecSidewaysMaxLines;
    property SlpEmpty: WordBool read Get_SlpEmpty;
    property SlpLetterQuality: WordBool read Get_SlpLetterQuality write Set_SlpLetterQuality;
    property SlpLineChars: Integer read Get_SlpLineChars write Set_SlpLineChars;
    property SlpLineCharsList: WideString read Get_SlpLineCharsList;
    property SlpLineHeight: Integer read Get_SlpLineHeight write Set_SlpLineHeight;
    property SlpLinesNearEndToEnd: Integer read Get_SlpLinesNearEndToEnd;
    property SlpLineSpacing: Integer read Get_SlpLineSpacing write Set_SlpLineSpacing;
    property SlpLineWidth: Integer read Get_SlpLineWidth;
    property SlpMaxLines: Integer read Get_SlpMaxLines;
    property SlpNearEnd: WordBool read Get_SlpNearEnd;
    property SlpSidewaysMaxChars: Integer read Get_SlpSidewaysMaxChars;
    property SlpSidewaysMaxLines: Integer read Get_SlpSidewaysMaxLines;
    property CapCharacterSet: Integer read Get_CapCharacterSet;
    property CapTransaction: WordBool read Get_CapTransaction;
    property ErrorLevel: Integer read Get_ErrorLevel;
    property ErrorString: WideString read Get_ErrorString;
    property FontTypefaceList: WideString read Get_FontTypefaceList;
    property RecBarCodeRotationList: WideString read Get_RecBarCodeRotationList;
    property RotateSpecial: Integer read Get_RotateSpecial write Set_RotateSpecial;
    property SlpBarCodeRotationList: WideString read Get_SlpBarCodeRotationList;
    property BinaryConversion: Integer read Get_BinaryConversion write Set_BinaryConversion;
    property CapPowerReporting: Integer read Get_CapPowerReporting;
    property PowerNotify: Integer read Get_PowerNotify write Set_PowerNotify;
    property PowerState: Integer read Get_PowerState;
    property CapJrnCartridgeSensor: Integer read Get_CapJrnCartridgeSensor;
    property CapJrnColor: Integer read Get_CapJrnColor;
    property CapRecCartridgeSensor: Integer read Get_CapRecCartridgeSensor;
    property CapRecColor: Integer read Get_CapRecColor;
    property CapRecMarkFeed: Integer read Get_CapRecMarkFeed;
    property CapSlpBothSidesPrint: WordBool read Get_CapSlpBothSidesPrint;
    property CapSlpCartridgeSensor: Integer read Get_CapSlpCartridgeSensor;
    property CapSlpColor: Integer read Get_CapSlpColor;
    property CartridgeNotify: Integer read Get_CartridgeNotify write Set_CartridgeNotify;
    property JrnCartridgeState: Integer read Get_JrnCartridgeState;
    property JrnCurrentCartridge: Integer read Get_JrnCurrentCartridge write Set_JrnCurrentCartridge;
    property RecCartridgeState: Integer read Get_RecCartridgeState;
    property RecCurrentCartridge: Integer read Get_RecCurrentCartridge write Set_RecCurrentCartridge;
    property SlpCartridgeState: Integer read Get_SlpCartridgeState;
    property SlpCurrentCartridge: Integer read Get_SlpCurrentCartridge write Set_SlpCurrentCartridge;
    property SlpPrintSide: Integer read Get_SlpPrintSide;
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_5Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB91151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_5Disp = dispinterface
    ['{CCB91151-B81E-11D2-AB74-0040054C3719}']
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_7
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_7 = interface(IOPOSPOSPrinter_1_5)
    ['{CCB92151-B81E-11D2-AB74-0040054C3719}']
    function Get_CapMapCharacterSet: WordBool; safecall;
    function Get_MapCharacterSet: WordBool; safecall;
    procedure Set_MapCharacterSet(pMapCharacterSet: WordBool); safecall;
    function Get_RecBitmapRotationList: WideString; safecall;
    function Get_SlpBitmapRotationList: WideString; safecall;
    property CapMapCharacterSet: WordBool read Get_CapMapCharacterSet;
    property MapCharacterSet: WordBool read Get_MapCharacterSet write Set_MapCharacterSet;
    property RecBitmapRotationList: WideString read Get_RecBitmapRotationList;
    property SlpBitmapRotationList: WideString read Get_SlpBitmapRotationList;
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_7Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB92151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_7Disp = dispinterface
    ['{CCB92151-B81E-11D2-AB74-0040054C3719}']
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_8
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_8 = interface(IOPOSPOSPrinter_1_7)
    ['{CCB93151-B81E-11D2-AB74-0040054C3719}']
    function Get_CapStatisticsReporting: WordBool; safecall;
    function Get_CapUpdateStatistics: WordBool; safecall;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; safecall;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; safecall;
    property CapStatisticsReporting: WordBool read Get_CapStatisticsReporting;
    property CapUpdateStatistics: WordBool read Get_CapUpdateStatistics;
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_8Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB93151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_8Disp = dispinterface
    ['{CCB93151-B81E-11D2-AB74-0040054C3719}']
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_9
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_9 = interface(IOPOSPOSPrinter_1_8)
    ['{CCB94151-B81E-11D2-AB74-0040054C3719}']
    function Get_CapCompareFirmwareVersion: WordBool; safecall;
    function Get_CapUpdateFirmware: WordBool; safecall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; safecall;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; safecall;
    function Get_CapConcurrentPageMode: WordBool; safecall;
    function Get_CapRecPageMode: WordBool; safecall;
    function Get_CapSlpPageMode: WordBool; safecall;
    function Get_PageModeArea: WideString; safecall;
    function Get_PageModeDescriptor: Integer; safecall;
    function Get_PageModeHorizontalPosition: Integer; safecall;
    procedure Set_PageModeHorizontalPosition(pPageModeHorizontalPosition: Integer); safecall;
    function Get_PageModePrintArea: WideString; safecall;
    procedure Set_PageModePrintArea(const pPageModePrintArea: WideString); safecall;
    function Get_PageModePrintDirection: Integer; safecall;
    procedure Set_PageModePrintDirection(pPageModePrintDirection: Integer); safecall;
    function Get_PageModeStation: Integer; safecall;
    procedure Set_PageModeStation(pPageModeStation: Integer); safecall;
    function Get_PageModeVerticalPosition: Integer; safecall;
    procedure Set_PageModeVerticalPosition(pPageModeVerticalPosition: Integer); safecall;
    function ClearPrintArea: Integer; safecall;
    function PageModePrint(Control: Integer): Integer; safecall;
    property CapCompareFirmwareVersion: WordBool read Get_CapCompareFirmwareVersion;
    property CapUpdateFirmware: WordBool read Get_CapUpdateFirmware;
    property CapConcurrentPageMode: WordBool read Get_CapConcurrentPageMode;
    property CapRecPageMode: WordBool read Get_CapRecPageMode;
    property CapSlpPageMode: WordBool read Get_CapSlpPageMode;
    property PageModeArea: WideString read Get_PageModeArea;
    property PageModeDescriptor: Integer read Get_PageModeDescriptor;
    property PageModeHorizontalPosition: Integer read Get_PageModeHorizontalPosition write Set_PageModeHorizontalPosition;
    property PageModePrintArea: WideString read Get_PageModePrintArea write Set_PageModePrintArea;
    property PageModePrintDirection: Integer read Get_PageModePrintDirection write Set_PageModePrintDirection;
    property PageModeStation: Integer read Get_PageModeStation write Set_PageModeStation;
    property PageModeVerticalPosition: Integer read Get_PageModeVerticalPosition write Set_PageModeVerticalPosition;
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_9Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB94151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_9Disp = dispinterface
    ['{CCB94151-B81E-11D2-AB74-0040054C3719}']
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapConcurrentPageMode: WordBool readonly dispid 194;
    property CapRecPageMode: WordBool readonly dispid 195;
    property CapSlpPageMode: WordBool readonly dispid 196;
    property PageModeArea: WideString readonly dispid 197;
    property PageModeDescriptor: Integer readonly dispid 198;
    property PageModeHorizontalPosition: Integer dispid 199;
    property PageModePrintArea: WideString dispid 200;
    property PageModePrintDirection: Integer dispid 201;
    property PageModeStation: Integer dispid 202;
    property PageModeVerticalPosition: Integer dispid 203;
    function ClearPrintArea: Integer; dispid 177;
    function PageModePrint(Control: Integer): Integer; dispid 178;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_10
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB95151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_10 = interface(IOPOSPOSPrinter_1_9)
    ['{CCB95151-B81E-11D2-AB74-0040054C3719}']
    function PrintMemoryBitmap(Station: Integer; const Data: WideString; Type_: Integer; 
                               Width: Integer; Alignment: Integer): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_10Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB95151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_10Disp = dispinterface
    ['{CCB95151-B81E-11D2-AB74-0040054C3719}']
    function PrintMemoryBitmap(Station: Integer; const Data: WideString; Type_: Integer; 
                               Width: Integer; Alignment: Integer): Integer; dispid 179;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapConcurrentPageMode: WordBool readonly dispid 194;
    property CapRecPageMode: WordBool readonly dispid 195;
    property CapSlpPageMode: WordBool readonly dispid 196;
    property PageModeArea: WideString readonly dispid 197;
    property PageModeDescriptor: Integer readonly dispid 198;
    property PageModeHorizontalPosition: Integer dispid 199;
    property PageModePrintArea: WideString dispid 200;
    property PageModePrintDirection: Integer dispid 201;
    property PageModeStation: Integer dispid 202;
    property PageModeVerticalPosition: Integer dispid 203;
    function ClearPrintArea: Integer; dispid 177;
    function PageModePrint(Control: Integer): Integer; dispid 178;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_13
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB97151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_13 = interface(IOPOSPOSPrinter_1_10)
    ['{CCB97151-B81E-11D2-AB74-0040054C3719}']
    function Get_CapRecRuledLine: Integer; safecall;
    function Get_CapSlpRuledLine: Integer; safecall;
    function DrawRuledLine(Station: Integer; const PositionList: WideString; 
                           LineDirection: Integer; LineWidth: Integer; LineStyle: Integer; 
                           LineColor: Integer): Integer; safecall;
    property CapRecRuledLine: Integer read Get_CapRecRuledLine;
    property CapSlpRuledLine: Integer read Get_CapSlpRuledLine;
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_13Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB97151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_13Disp = dispinterface
    ['{CCB97151-B81E-11D2-AB74-0040054C3719}']
    property CapRecRuledLine: Integer readonly dispid 204;
    property CapSlpRuledLine: Integer readonly dispid 205;
    function DrawRuledLine(Station: Integer; const PositionList: WideString; 
                           LineDirection: Integer; LineWidth: Integer; LineStyle: Integer; 
                           LineColor: Integer): Integer; dispid 180;
    function PrintMemoryBitmap(Station: Integer; const Data: WideString; Type_: Integer; 
                               Width: Integer; Alignment: Integer): Integer; dispid 179;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapConcurrentPageMode: WordBool readonly dispid 194;
    property CapRecPageMode: WordBool readonly dispid 195;
    property CapSlpPageMode: WordBool readonly dispid 196;
    property PageModeArea: WideString readonly dispid 197;
    property PageModeDescriptor: Integer readonly dispid 198;
    property PageModeHorizontalPosition: Integer dispid 199;
    property PageModePrintArea: WideString dispid 200;
    property PageModePrintDirection: Integer dispid 201;
    property PageModeStation: Integer dispid 202;
    property PageModeVerticalPosition: Integer dispid 203;
    function ClearPrintArea: Integer; dispid 177;
    function PageModePrint(Control: Integer): Integer; dispid 178;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB98151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter = interface(IOPOSPOSPrinter_1_13)
    ['{CCB98151-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB98151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinterDisp = dispinterface
    ['{CCB98151-B81E-11D2-AB74-0040054C3719}']
    property CapRecRuledLine: Integer readonly dispid 204;
    property CapSlpRuledLine: Integer readonly dispid 205;
    function DrawRuledLine(Station: Integer; const PositionList: WideString; 
                           LineDirection: Integer; LineWidth: Integer; LineStyle: Integer; 
                           LineColor: Integer): Integer; dispid 180;
    function PrintMemoryBitmap(Station: Integer; const Data: WideString; Type_: Integer; 
                               Width: Integer; Alignment: Integer): Integer; dispid 179;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapConcurrentPageMode: WordBool readonly dispid 194;
    property CapRecPageMode: WordBool readonly dispid 195;
    property CapSlpPageMode: WordBool readonly dispid 196;
    property PageModeArea: WideString readonly dispid 197;
    property PageModeDescriptor: Integer readonly dispid 198;
    property PageModeHorizontalPosition: Integer dispid 199;
    property PageModePrintArea: WideString dispid 200;
    property PageModePrintDirection: Integer dispid 201;
    property PageModeStation: Integer dispid 202;
    property PageModeVerticalPosition: Integer dispid 203;
    function ClearPrintArea: Integer; dispid 177;
    function PageModePrint(Control: Integer): Integer; dispid 178;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;

// *********************************************************************//
// Interface: IOPOSPOSPrinter_1_10_zz
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CCB96151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_10_zz = interface(IOPOSPOSPrinter_1_10)
    ['{CCB96151-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSPOSPrinter_1_10_zzDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {CCB96151-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSPOSPrinter_1_10_zzDisp = dispinterface
    ['{CCB96151-B81E-11D2-AB74-0040054C3719}']
    function PrintMemoryBitmap(Station: Integer; const Data: WideString; Type_: Integer; 
                               Width: Integer; Alignment: Integer): Integer; dispid 179;
    property CapCompareFirmwareVersion: WordBool readonly dispid 44;
    property CapUpdateFirmware: WordBool readonly dispid 45;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer; dispid 46;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer; dispid 47;
    property CapConcurrentPageMode: WordBool readonly dispid 194;
    property CapRecPageMode: WordBool readonly dispid 195;
    property CapSlpPageMode: WordBool readonly dispid 196;
    property PageModeArea: WideString readonly dispid 197;
    property PageModeDescriptor: Integer readonly dispid 198;
    property PageModeHorizontalPosition: Integer dispid 199;
    property PageModePrintArea: WideString dispid 200;
    property PageModePrintDirection: Integer dispid 201;
    property PageModeStation: Integer dispid 202;
    property PageModeVerticalPosition: Integer dispid 203;
    function ClearPrintArea: Integer; dispid 177;
    function PageModePrint(Control: Integer): Integer; dispid 178;
    property CapStatisticsReporting: WordBool readonly dispid 39;
    property CapUpdateStatistics: WordBool readonly dispid 40;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer; dispid 41;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer; dispid 42;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer; dispid 43;
    property CapMapCharacterSet: WordBool readonly dispid 190;
    property MapCharacterSet: WordBool dispid 191;
    property RecBitmapRotationList: WideString readonly dispid 192;
    property SlpBitmapRotationList: WideString readonly dispid 193;
    procedure SODataDummy(Status: Integer); dispid 1;
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    property DeviceEnabled: WordBool dispid 17;
    property FreezeEvents: WordBool dispid 18;
    property OutputID: Integer readonly dispid 19;
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
    function ClearOutput: Integer; dispid 34;
    function Close: Integer; dispid 35;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer; dispid 36;
    function Open(const DeviceName: WideString): Integer; dispid 37;
    function ReleaseDevice: Integer; dispid 38;
    property AsyncMode: WordBool dispid 50;
    property CapConcurrentJrnRec: WordBool readonly dispid 52;
    property CapConcurrentJrnSlp: WordBool readonly dispid 53;
    property CapConcurrentRecSlp: WordBool readonly dispid 54;
    property CapCoverSensor: WordBool readonly dispid 55;
    property CapJrn2Color: WordBool readonly dispid 56;
    property CapJrnBold: WordBool readonly dispid 57;
    property CapJrnDhigh: WordBool readonly dispid 58;
    property CapJrnDwide: WordBool readonly dispid 59;
    property CapJrnDwideDhigh: WordBool readonly dispid 60;
    property CapJrnEmptySensor: WordBool readonly dispid 61;
    property CapJrnItalic: WordBool readonly dispid 62;
    property CapJrnNearEndSensor: WordBool readonly dispid 63;
    property CapJrnPresent: WordBool readonly dispid 64;
    property CapJrnUnderline: WordBool readonly dispid 65;
    property CapRec2Color: WordBool readonly dispid 66;
    property CapRecBarCode: WordBool readonly dispid 67;
    property CapRecBitmap: WordBool readonly dispid 68;
    property CapRecBold: WordBool readonly dispid 69;
    property CapRecDhigh: WordBool readonly dispid 70;
    property CapRecDwide: WordBool readonly dispid 71;
    property CapRecDwideDhigh: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecItalic: WordBool readonly dispid 74;
    property CapRecLeft90: WordBool readonly dispid 75;
    property CapRecNearEndSensor: WordBool readonly dispid 76;
    property CapRecPapercut: WordBool readonly dispid 77;
    property CapRecPresent: WordBool readonly dispid 78;
    property CapRecRight90: WordBool readonly dispid 79;
    property CapRecRotate180: WordBool readonly dispid 80;
    property CapRecStamp: WordBool readonly dispid 81;
    property CapRecUnderline: WordBool readonly dispid 82;
    property CapSlp2Color: WordBool readonly dispid 83;
    property CapSlpBarCode: WordBool readonly dispid 84;
    property CapSlpBitmap: WordBool readonly dispid 85;
    property CapSlpBold: WordBool readonly dispid 86;
    property CapSlpDhigh: WordBool readonly dispid 87;
    property CapSlpDwide: WordBool readonly dispid 88;
    property CapSlpDwideDhigh: WordBool readonly dispid 89;
    property CapSlpEmptySensor: WordBool readonly dispid 90;
    property CapSlpFullslip: WordBool readonly dispid 91;
    property CapSlpItalic: WordBool readonly dispid 92;
    property CapSlpLeft90: WordBool readonly dispid 93;
    property CapSlpNearEndSensor: WordBool readonly dispid 94;
    property CapSlpPresent: WordBool readonly dispid 95;
    property CapSlpRight90: WordBool readonly dispid 96;
    property CapSlpRotate180: WordBool readonly dispid 97;
    property CapSlpUnderline: WordBool readonly dispid 98;
    property CharacterSet: Integer dispid 100;
    property CharacterSetList: WideString readonly dispid 101;
    property CoverOpen: WordBool readonly dispid 102;
    property ErrorStation: Integer readonly dispid 104;
    property FlagWhenIdle: WordBool dispid 106;
    property JrnEmpty: WordBool readonly dispid 108;
    property JrnLetterQuality: WordBool dispid 109;
    property JrnLineChars: Integer dispid 110;
    property JrnLineCharsList: WideString readonly dispid 111;
    property JrnLineHeight: Integer dispid 112;
    property JrnLineSpacing: Integer dispid 113;
    property JrnLineWidth: Integer readonly dispid 114;
    property JrnNearEnd: WordBool readonly dispid 115;
    property MapMode: Integer dispid 116;
    property RecEmpty: WordBool readonly dispid 118;
    property RecLetterQuality: WordBool dispid 119;
    property RecLineChars: Integer dispid 120;
    property RecLineCharsList: WideString readonly dispid 121;
    property RecLineHeight: Integer dispid 122;
    property RecLineSpacing: Integer dispid 123;
    property RecLinesToPaperCut: Integer readonly dispid 124;
    property RecLineWidth: Integer readonly dispid 125;
    property RecNearEnd: WordBool readonly dispid 126;
    property RecSidewaysMaxChars: Integer readonly dispid 127;
    property RecSidewaysMaxLines: Integer readonly dispid 128;
    property SlpEmpty: WordBool readonly dispid 131;
    property SlpLetterQuality: WordBool dispid 132;
    property SlpLineChars: Integer dispid 133;
    property SlpLineCharsList: WideString readonly dispid 134;
    property SlpLineHeight: Integer dispid 135;
    property SlpLinesNearEndToEnd: Integer readonly dispid 136;
    property SlpLineSpacing: Integer dispid 137;
    property SlpLineWidth: Integer readonly dispid 138;
    property SlpMaxLines: Integer readonly dispid 139;
    property SlpNearEnd: WordBool readonly dispid 140;
    property SlpSidewaysMaxChars: Integer readonly dispid 141;
    property SlpSidewaysMaxLines: Integer readonly dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 160;
    function BeginRemoval(Timeout: Integer): Integer; dispid 161;
    function CutPaper(Percentage: Integer): Integer; dispid 162;
    function EndInsertion: Integer; dispid 163;
    function EndRemoval: Integer; dispid 164;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer; dispid 165;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer; dispid 166;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer; dispid 167;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 168;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer; dispid 169;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer; dispid 170;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer; dispid 171;
    function SetLogo(Location: Integer; const Data: WideString): Integer; dispid 172;
    property CapCharacterSet: Integer readonly dispid 51;
    property CapTransaction: WordBool readonly dispid 99;
    property ErrorLevel: Integer readonly dispid 103;
    property ErrorString: WideString readonly dispid 105;
    property FontTypefaceList: WideString readonly dispid 107;
    property RecBarCodeRotationList: WideString readonly dispid 117;
    property RotateSpecial: Integer dispid 129;
    property SlpBarCodeRotationList: WideString readonly dispid 130;
    function TransactionPrint(Station: Integer; Control: Integer): Integer; dispid 173;
    function ValidateData(Station: Integer; const Data: WideString): Integer; dispid 174;
    property BinaryConversion: Integer dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property PowerNotify: Integer dispid 20;
    property PowerState: Integer readonly dispid 21;
    property CapJrnCartridgeSensor: Integer readonly dispid 143;
    property CapJrnColor: Integer readonly dispid 144;
    property CapRecCartridgeSensor: Integer readonly dispid 145;
    property CapRecColor: Integer readonly dispid 146;
    property CapRecMarkFeed: Integer readonly dispid 147;
    property CapSlpBothSidesPrint: WordBool readonly dispid 148;
    property CapSlpCartridgeSensor: Integer readonly dispid 149;
    property CapSlpColor: Integer readonly dispid 150;
    property CartridgeNotify: Integer dispid 151;
    property JrnCartridgeState: Integer readonly dispid 152;
    property JrnCurrentCartridge: Integer dispid 153;
    property RecCartridgeState: Integer readonly dispid 154;
    property RecCurrentCartridge: Integer dispid 155;
    property SlpCartridgeState: Integer readonly dispid 156;
    property SlpCurrentCartridge: Integer dispid 157;
    property SlpPrintSide: Integer readonly dispid 158;
    function ChangePrintSide(Side: Integer): Integer; dispid 175;
    function MarkFeed(Type_: Integer): Integer; dispid 176;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TOPOSPOSPrinter
// Help String      : OPOS POSPrinter Control 1.13.003 [Public, by CRM/MCS]
// Default Interface: IOPOSPOSPrinter
// Def. Intf. DISP? : No
// Event   Interface: _IOPOSPOSPrinterEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TOPOSPOSPrinterDirectIOEvent = procedure(ASender: TObject; EventNumber: Integer; 
                                                             var pData: Integer; 
                                                             var pString: WideString) of object;
  TOPOSPOSPrinterErrorEvent = procedure(ASender: TObject; ResultCode: Integer; 
                                                          ResultCodeExtended: Integer; 
                                                          ErrorLocus: Integer; 
                                                          var pErrorResponse: Integer) of object;
  TOPOSPOSPrinterOutputCompleteEvent = procedure(ASender: TObject; OutputID: Integer) of object;
  TOPOSPOSPrinterStatusUpdateEvent = procedure(ASender: TObject; Data: Integer) of object;

  TOPOSPOSPrinter = class(TOleControl)
  private
    FOnDirectIOEvent: TOPOSPOSPrinterDirectIOEvent;
    FOnErrorEvent: TOPOSPOSPrinterErrorEvent;
    FOnOutputCompleteEvent: TOPOSPOSPrinterOutputCompleteEvent;
    FOnStatusUpdateEvent: TOPOSPOSPrinterStatusUpdateEvent;
    FIntf: IOPOSPOSPrinter;
    function  GetControlInterface: IOPOSPOSPrinter;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure SODataDummy(Status: Integer);
    procedure SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString);
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer);
    procedure SOOutputComplete(OutputID: Integer);
    procedure SOStatusUpdate(Data: Integer);
    function SOProcessID: Integer;
    function CheckHealth(Level: Integer): Integer;
    function ClaimDevice(Timeout: Integer): Integer;
    function ClearOutput: Integer;
    function Close: Integer;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
    function Open(const DeviceName: WideString): Integer;
    function ReleaseDevice: Integer;
    function BeginInsertion(Timeout: Integer): Integer;
    function BeginRemoval(Timeout: Integer): Integer;
    function CutPaper(Percentage: Integer): Integer;
    function EndInsertion: Integer;
    function EndRemoval: Integer;
    function PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                          Height: Integer; Width: Integer; Alignment: Integer; TextPosition: Integer): Integer;
    function PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                         Alignment: Integer): Integer;
    function PrintImmediate(Station: Integer; const Data: WideString): Integer;
    function PrintNormal(Station: Integer; const Data: WideString): Integer;
    function PrintTwoNormal(Stations: Integer; const Data1: WideString; const Data2: WideString): Integer;
    function RotatePrint(Station: Integer; Rotation: Integer): Integer;
    function SetBitmap(BitmapNumber: Integer; Station: Integer; const FileName: WideString; 
                       Width: Integer; Alignment: Integer): Integer;
    function SetLogo(Location: Integer; const Data: WideString): Integer;
    function TransactionPrint(Station: Integer; Control: Integer): Integer;
    function ValidateData(Station: Integer; const Data: WideString): Integer;
    function ChangePrintSide(Side: Integer): Integer;
    function MarkFeed(Type_: Integer): Integer;
    function ResetStatistics(const StatisticsBuffer: WideString): Integer;
    function RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
    function UpdateStatistics(const StatisticsBuffer: WideString): Integer;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer): Integer;
    function UpdateFirmware(const FirmwareFileName: WideString): Integer;
    function ClearPrintArea: Integer;
    function PageModePrint(Control: Integer): Integer;
    function PrintMemoryBitmap(Station: Integer; const Data: WideString; Type_: Integer; 
                               Width: Integer; Alignment: Integer): Integer;
    function DrawRuledLine(Station: Integer; const PositionList: WideString; 
                           LineDirection: Integer; LineWidth: Integer; LineStyle: Integer; 
                           LineColor: Integer): Integer;
    property  ControlInterface: IOPOSPOSPrinter read GetControlInterface;
    property  DefaultInterface: IOPOSPOSPrinter read GetControlInterface;
    property OpenResult: Integer index 49 read GetIntegerProp;
    property CheckHealthText: WideString index 13 read GetWideStringProp;
    property Claimed: WordBool index 14 read GetWordBoolProp;
    property OutputID: Integer index 19 read GetIntegerProp;
    property ResultCode: Integer index 22 read GetIntegerProp;
    property ResultCodeExtended: Integer index 23 read GetIntegerProp;
    property State: Integer index 24 read GetIntegerProp;
    property ControlObjectDescription: WideString index 25 read GetWideStringProp;
    property ControlObjectVersion: Integer index 26 read GetIntegerProp;
    property ServiceObjectDescription: WideString index 27 read GetWideStringProp;
    property ServiceObjectVersion: Integer index 28 read GetIntegerProp;
    property DeviceDescription: WideString index 29 read GetWideStringProp;
    property DeviceName: WideString index 30 read GetWideStringProp;
    property CapConcurrentJrnRec: WordBool index 52 read GetWordBoolProp;
    property CapConcurrentJrnSlp: WordBool index 53 read GetWordBoolProp;
    property CapConcurrentRecSlp: WordBool index 54 read GetWordBoolProp;
    property CapCoverSensor: WordBool index 55 read GetWordBoolProp;
    property CapJrn2Color: WordBool index 56 read GetWordBoolProp;
    property CapJrnBold: WordBool index 57 read GetWordBoolProp;
    property CapJrnDhigh: WordBool index 58 read GetWordBoolProp;
    property CapJrnDwide: WordBool index 59 read GetWordBoolProp;
    property CapJrnDwideDhigh: WordBool index 60 read GetWordBoolProp;
    property CapJrnEmptySensor: WordBool index 61 read GetWordBoolProp;
    property CapJrnItalic: WordBool index 62 read GetWordBoolProp;
    property CapJrnNearEndSensor: WordBool index 63 read GetWordBoolProp;
    property CapJrnPresent: WordBool index 64 read GetWordBoolProp;
    property CapJrnUnderline: WordBool index 65 read GetWordBoolProp;
    property CapRec2Color: WordBool index 66 read GetWordBoolProp;
    property CapRecBarCode: WordBool index 67 read GetWordBoolProp;
    property CapRecBitmap: WordBool index 68 read GetWordBoolProp;
    property CapRecBold: WordBool index 69 read GetWordBoolProp;
    property CapRecDhigh: WordBool index 70 read GetWordBoolProp;
    property CapRecDwide: WordBool index 71 read GetWordBoolProp;
    property CapRecDwideDhigh: WordBool index 72 read GetWordBoolProp;
    property CapRecEmptySensor: WordBool index 73 read GetWordBoolProp;
    property CapRecItalic: WordBool index 74 read GetWordBoolProp;
    property CapRecLeft90: WordBool index 75 read GetWordBoolProp;
    property CapRecNearEndSensor: WordBool index 76 read GetWordBoolProp;
    property CapRecPapercut: WordBool index 77 read GetWordBoolProp;
    property CapRecPresent: WordBool index 78 read GetWordBoolProp;
    property CapRecRight90: WordBool index 79 read GetWordBoolProp;
    property CapRecRotate180: WordBool index 80 read GetWordBoolProp;
    property CapRecStamp: WordBool index 81 read GetWordBoolProp;
    property CapRecUnderline: WordBool index 82 read GetWordBoolProp;
    property CapSlp2Color: WordBool index 83 read GetWordBoolProp;
    property CapSlpBarCode: WordBool index 84 read GetWordBoolProp;
    property CapSlpBitmap: WordBool index 85 read GetWordBoolProp;
    property CapSlpBold: WordBool index 86 read GetWordBoolProp;
    property CapSlpDhigh: WordBool index 87 read GetWordBoolProp;
    property CapSlpDwide: WordBool index 88 read GetWordBoolProp;
    property CapSlpDwideDhigh: WordBool index 89 read GetWordBoolProp;
    property CapSlpEmptySensor: WordBool index 90 read GetWordBoolProp;
    property CapSlpFullslip: WordBool index 91 read GetWordBoolProp;
    property CapSlpItalic: WordBool index 92 read GetWordBoolProp;
    property CapSlpLeft90: WordBool index 93 read GetWordBoolProp;
    property CapSlpNearEndSensor: WordBool index 94 read GetWordBoolProp;
    property CapSlpPresent: WordBool index 95 read GetWordBoolProp;
    property CapSlpRight90: WordBool index 96 read GetWordBoolProp;
    property CapSlpRotate180: WordBool index 97 read GetWordBoolProp;
    property CapSlpUnderline: WordBool index 98 read GetWordBoolProp;
    property CharacterSetList: WideString index 101 read GetWideStringProp;
    property CoverOpen: WordBool index 102 read GetWordBoolProp;
    property ErrorStation: Integer index 104 read GetIntegerProp;
    property JrnEmpty: WordBool index 108 read GetWordBoolProp;
    property JrnLineCharsList: WideString index 111 read GetWideStringProp;
    property JrnLineWidth: Integer index 114 read GetIntegerProp;
    property JrnNearEnd: WordBool index 115 read GetWordBoolProp;
    property RecEmpty: WordBool index 118 read GetWordBoolProp;
    property RecLineCharsList: WideString index 121 read GetWideStringProp;
    property RecLinesToPaperCut: Integer index 124 read GetIntegerProp;
    property RecLineWidth: Integer index 125 read GetIntegerProp;
    property RecNearEnd: WordBool index 126 read GetWordBoolProp;
    property RecSidewaysMaxChars: Integer index 127 read GetIntegerProp;
    property RecSidewaysMaxLines: Integer index 128 read GetIntegerProp;
    property SlpEmpty: WordBool index 131 read GetWordBoolProp;
    property SlpLineCharsList: WideString index 134 read GetWideStringProp;
    property SlpLinesNearEndToEnd: Integer index 136 read GetIntegerProp;
    property SlpLineWidth: Integer index 138 read GetIntegerProp;
    property SlpMaxLines: Integer index 139 read GetIntegerProp;
    property SlpNearEnd: WordBool index 140 read GetWordBoolProp;
    property SlpSidewaysMaxChars: Integer index 141 read GetIntegerProp;
    property SlpSidewaysMaxLines: Integer index 142 read GetIntegerProp;
    property CapCharacterSet: Integer index 51 read GetIntegerProp;
    property CapTransaction: WordBool index 99 read GetWordBoolProp;
    property ErrorLevel: Integer index 103 read GetIntegerProp;
    property ErrorString: WideString index 105 read GetWideStringProp;
    property FontTypefaceList: WideString index 107 read GetWideStringProp;
    property RecBarCodeRotationList: WideString index 117 read GetWideStringProp;
    property SlpBarCodeRotationList: WideString index 130 read GetWideStringProp;
    property CapPowerReporting: Integer index 12 read GetIntegerProp;
    property PowerState: Integer index 21 read GetIntegerProp;
    property CapJrnCartridgeSensor: Integer index 143 read GetIntegerProp;
    property CapJrnColor: Integer index 144 read GetIntegerProp;
    property CapRecCartridgeSensor: Integer index 145 read GetIntegerProp;
    property CapRecColor: Integer index 146 read GetIntegerProp;
    property CapRecMarkFeed: Integer index 147 read GetIntegerProp;
    property CapSlpBothSidesPrint: WordBool index 148 read GetWordBoolProp;
    property CapSlpCartridgeSensor: Integer index 149 read GetIntegerProp;
    property CapSlpColor: Integer index 150 read GetIntegerProp;
    property JrnCartridgeState: Integer index 152 read GetIntegerProp;
    property RecCartridgeState: Integer index 154 read GetIntegerProp;
    property SlpCartridgeState: Integer index 156 read GetIntegerProp;
    property SlpPrintSide: Integer index 158 read GetIntegerProp;
    property CapMapCharacterSet: WordBool index 190 read GetWordBoolProp;
    property RecBitmapRotationList: WideString index 192 read GetWideStringProp;
    property SlpBitmapRotationList: WideString index 193 read GetWideStringProp;
    property CapStatisticsReporting: WordBool index 39 read GetWordBoolProp;
    property CapUpdateStatistics: WordBool index 40 read GetWordBoolProp;
    property CapCompareFirmwareVersion: WordBool index 44 read GetWordBoolProp;
    property CapUpdateFirmware: WordBool index 45 read GetWordBoolProp;
    property CapConcurrentPageMode: WordBool index 194 read GetWordBoolProp;
    property CapRecPageMode: WordBool index 195 read GetWordBoolProp;
    property CapSlpPageMode: WordBool index 196 read GetWordBoolProp;
    property PageModeArea: WideString index 197 read GetWideStringProp;
    property PageModeDescriptor: Integer index 198 read GetIntegerProp;
    property CapRecRuledLine: Integer index 204 read GetIntegerProp;
    property CapSlpRuledLine: Integer index 205 read GetIntegerProp;
  published
    property Anchors;
    property DeviceEnabled: WordBool index 17 read GetWordBoolProp write SetWordBoolProp stored False;
    property FreezeEvents: WordBool index 18 read GetWordBoolProp write SetWordBoolProp stored False;
    property AsyncMode: WordBool index 50 read GetWordBoolProp write SetWordBoolProp stored False;
    property CharacterSet: Integer index 100 read GetIntegerProp write SetIntegerProp stored False;
    property FlagWhenIdle: WordBool index 106 read GetWordBoolProp write SetWordBoolProp stored False;
    property JrnLetterQuality: WordBool index 109 read GetWordBoolProp write SetWordBoolProp stored False;
    property JrnLineChars: Integer index 110 read GetIntegerProp write SetIntegerProp stored False;
    property JrnLineHeight: Integer index 112 read GetIntegerProp write SetIntegerProp stored False;
    property JrnLineSpacing: Integer index 113 read GetIntegerProp write SetIntegerProp stored False;
    property MapMode: Integer index 116 read GetIntegerProp write SetIntegerProp stored False;
    property RecLetterQuality: WordBool index 119 read GetWordBoolProp write SetWordBoolProp stored False;
    property RecLineChars: Integer index 120 read GetIntegerProp write SetIntegerProp stored False;
    property RecLineHeight: Integer index 122 read GetIntegerProp write SetIntegerProp stored False;
    property RecLineSpacing: Integer index 123 read GetIntegerProp write SetIntegerProp stored False;
    property SlpLetterQuality: WordBool index 132 read GetWordBoolProp write SetWordBoolProp stored False;
    property SlpLineChars: Integer index 133 read GetIntegerProp write SetIntegerProp stored False;
    property SlpLineHeight: Integer index 135 read GetIntegerProp write SetIntegerProp stored False;
    property SlpLineSpacing: Integer index 137 read GetIntegerProp write SetIntegerProp stored False;
    property RotateSpecial: Integer index 129 read GetIntegerProp write SetIntegerProp stored False;
    property BinaryConversion: Integer index 11 read GetIntegerProp write SetIntegerProp stored False;
    property PowerNotify: Integer index 20 read GetIntegerProp write SetIntegerProp stored False;
    property CartridgeNotify: Integer index 151 read GetIntegerProp write SetIntegerProp stored False;
    property JrnCurrentCartridge: Integer index 153 read GetIntegerProp write SetIntegerProp stored False;
    property RecCurrentCartridge: Integer index 155 read GetIntegerProp write SetIntegerProp stored False;
    property SlpCurrentCartridge: Integer index 157 read GetIntegerProp write SetIntegerProp stored False;
    property MapCharacterSet: WordBool index 191 read GetWordBoolProp write SetWordBoolProp stored False;
    property PageModeHorizontalPosition: Integer index 199 read GetIntegerProp write SetIntegerProp stored False;
    property PageModePrintArea: WideString index 200 read GetWideStringProp write SetWideStringProp stored False;
    property PageModePrintDirection: Integer index 201 read GetIntegerProp write SetIntegerProp stored False;
    property PageModeStation: Integer index 202 read GetIntegerProp write SetIntegerProp stored False;
    property PageModeVerticalPosition: Integer index 203 read GetIntegerProp write SetIntegerProp stored False;
    property OnDirectIOEvent: TOPOSPOSPrinterDirectIOEvent read FOnDirectIOEvent write FOnDirectIOEvent;
    property OnErrorEvent: TOPOSPOSPrinterErrorEvent read FOnErrorEvent write FOnErrorEvent;
    property OnOutputCompleteEvent: TOPOSPOSPrinterOutputCompleteEvent read FOnOutputCompleteEvent write FOnOutputCompleteEvent;
    property OnStatusUpdateEvent: TOPOSPOSPrinterStatusUpdateEvent read FOnStatusUpdateEvent write FOnStatusUpdateEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TOPOSPOSPrinter.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $00000002, $00000003, $00000004, $00000005);
  CControlData: TControlData2 = (
    ClassID: '{CCB90152-B81E-11D2-AB74-0040054C3719}';
    EventIID: '{CCB90153-B81E-11D2-AB74-0040054C3719}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnDirectIOEvent) - Cardinal(Self);
end;

procedure TOPOSPOSPrinter.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IOPOSPOSPrinter;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TOPOSPOSPrinter.GetControlInterface: IOPOSPOSPrinter;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TOPOSPOSPrinter.SODataDummy(Status: Integer);
begin
  DefaultInterface.SODataDummy(Status);
end;

procedure TOPOSPOSPrinter.SODirectIO(EventNumber: Integer; var pData: Integer; 
                                     var pString: WideString);
begin
  DefaultInterface.SODirectIO(EventNumber, pData, pString);
end;

procedure TOPOSPOSPrinter.SOError(ResultCode: Integer; ResultCodeExtended: Integer; 
                                  ErrorLocus: Integer; var pErrorResponse: Integer);
begin
  DefaultInterface.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

procedure TOPOSPOSPrinter.SOOutputComplete(OutputID: Integer);
begin
  DefaultInterface.SOOutputComplete(OutputID);
end;

procedure TOPOSPOSPrinter.SOStatusUpdate(Data: Integer);
begin
  DefaultInterface.SOStatusUpdate(Data);
end;

function TOPOSPOSPrinter.SOProcessID: Integer;
begin
  Result := DefaultInterface.SOProcessID;
end;

function TOPOSPOSPrinter.CheckHealth(Level: Integer): Integer;
begin
  Result := DefaultInterface.CheckHealth(Level);
end;

function TOPOSPOSPrinter.ClaimDevice(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.ClaimDevice(Timeout);
end;

function TOPOSPOSPrinter.ClearOutput: Integer;
begin
  Result := DefaultInterface.ClearOutput;
end;

function TOPOSPOSPrinter.Close: Integer;
begin
  Result := DefaultInterface.Close;
end;

function TOPOSPOSPrinter.DirectIO(Command: Integer; var pData: Integer; var pString: WideString): Integer;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString);
end;

function TOPOSPOSPrinter.Open(const DeviceName: WideString): Integer;
begin
  Result := DefaultInterface.Open(DeviceName);
end;

function TOPOSPOSPrinter.ReleaseDevice: Integer;
begin
  Result := DefaultInterface.ReleaseDevice;
end;

function TOPOSPOSPrinter.BeginInsertion(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.BeginInsertion(Timeout);
end;

function TOPOSPOSPrinter.BeginRemoval(Timeout: Integer): Integer;
begin
  Result := DefaultInterface.BeginRemoval(Timeout);
end;

function TOPOSPOSPrinter.CutPaper(Percentage: Integer): Integer;
begin
  Result := DefaultInterface.CutPaper(Percentage);
end;

function TOPOSPOSPrinter.EndInsertion: Integer;
begin
  Result := DefaultInterface.EndInsertion;
end;

function TOPOSPOSPrinter.EndRemoval: Integer;
begin
  Result := DefaultInterface.EndRemoval;
end;

function TOPOSPOSPrinter.PrintBarCode(Station: Integer; const Data: WideString; Symbology: Integer; 
                                      Height: Integer; Width: Integer; Alignment: Integer; 
                                      TextPosition: Integer): Integer;
begin
  Result := DefaultInterface.PrintBarCode(Station, Data, Symbology, Height, Width, Alignment, 
                                          TextPosition);
end;

function TOPOSPOSPrinter.PrintBitmap(Station: Integer; const FileName: WideString; Width: Integer; 
                                     Alignment: Integer): Integer;
begin
  Result := DefaultInterface.PrintBitmap(Station, FileName, Width, Alignment);
end;

function TOPOSPOSPrinter.PrintImmediate(Station: Integer; const Data: WideString): Integer;
begin
  Result := DefaultInterface.PrintImmediate(Station, Data);
end;

function TOPOSPOSPrinter.PrintNormal(Station: Integer; const Data: WideString): Integer;
begin
  Result := DefaultInterface.PrintNormal(Station, Data);
end;

function TOPOSPOSPrinter.PrintTwoNormal(Stations: Integer; const Data1: WideString; 
                                        const Data2: WideString): Integer;
begin
  Result := DefaultInterface.PrintTwoNormal(Stations, Data1, Data2);
end;

function TOPOSPOSPrinter.RotatePrint(Station: Integer; Rotation: Integer): Integer;
begin
  Result := DefaultInterface.RotatePrint(Station, Rotation);
end;

function TOPOSPOSPrinter.SetBitmap(BitmapNumber: Integer; Station: Integer; 
                                   const FileName: WideString; Width: Integer; Alignment: Integer): Integer;
begin
  Result := DefaultInterface.SetBitmap(BitmapNumber, Station, FileName, Width, Alignment);
end;

function TOPOSPOSPrinter.SetLogo(Location: Integer; const Data: WideString): Integer;
begin
  Result := DefaultInterface.SetLogo(Location, Data);
end;

function TOPOSPOSPrinter.TransactionPrint(Station: Integer; Control: Integer): Integer;
begin
  Result := DefaultInterface.TransactionPrint(Station, Control);
end;

function TOPOSPOSPrinter.ValidateData(Station: Integer; const Data: WideString): Integer;
begin
  Result := DefaultInterface.ValidateData(Station, Data);
end;

function TOPOSPOSPrinter.ChangePrintSide(Side: Integer): Integer;
begin
  Result := DefaultInterface.ChangePrintSide(Side);
end;

function TOPOSPOSPrinter.MarkFeed(Type_: Integer): Integer;
begin
  Result := DefaultInterface.MarkFeed(Type_);
end;

function TOPOSPOSPrinter.ResetStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.ResetStatistics(StatisticsBuffer);
end;

function TOPOSPOSPrinter.RetrieveStatistics(var pStatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.RetrieveStatistics(pStatisticsBuffer);
end;

function TOPOSPOSPrinter.UpdateStatistics(const StatisticsBuffer: WideString): Integer;
begin
  Result := DefaultInterface.UpdateStatistics(StatisticsBuffer);
end;

function TOPOSPOSPrinter.CompareFirmwareVersion(const FirmwareFileName: WideString; 
                                                out pResult: Integer): Integer;
begin
  Result := DefaultInterface.CompareFirmwareVersion(FirmwareFileName, pResult);
end;

function TOPOSPOSPrinter.UpdateFirmware(const FirmwareFileName: WideString): Integer;
begin
  Result := DefaultInterface.UpdateFirmware(FirmwareFileName);
end;

function TOPOSPOSPrinter.ClearPrintArea: Integer;
begin
  Result := DefaultInterface.ClearPrintArea;
end;

function TOPOSPOSPrinter.PageModePrint(Control: Integer): Integer;
begin
  Result := DefaultInterface.PageModePrint(Control);
end;

function TOPOSPOSPrinter.PrintMemoryBitmap(Station: Integer; const Data: WideString; 
                                           Type_: Integer; Width: Integer; Alignment: Integer): Integer;
begin
  Result := DefaultInterface.PrintMemoryBitmap(Station, Data, Type_, Width, Alignment);
end;

function TOPOSPOSPrinter.DrawRuledLine(Station: Integer; const PositionList: WideString; 
                                       LineDirection: Integer; LineWidth: Integer; 
                                       LineStyle: Integer; LineColor: Integer): Integer;
begin
  Result := DefaultInterface.DrawRuledLine(Station, PositionList, LineDirection, LineWidth, 
                                           LineStyle, LineColor);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TOPOSPOSPrinter]);
end;

end.
