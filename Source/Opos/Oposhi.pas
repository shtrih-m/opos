unit Oposhi;

//////////////////////////////////////////////////////////////////////
//
// Opos.hi
//
//   General header file for OPOS Control Objects and Service Objects.
//
// Modification history
// -------------------------------------------------------------------
// 1995-12-08 OPOS Release 1.0                                   CRM
// 1996-03-18 OPOS Release 1.01                                  CRM
//   Remove HKEY_LOCAL_MACHINE from the root keys, so that they
//     may be directly used by RegOpenKey.
// 1996-04-22 OPOS Release 1.1                                   CRM
//   Add POS Keyboard values.
// 1997-06-04 OPOS Release 1.2                                   CRM
//   Add Cash Changer and Tone Indicator.
//   Add the following properties:
//     AutoDisable, BinaryConversion, DataCount
// 1998-03-06 OPOS Release 1.3                                   CRM
//   Add Bump Bar, Fiscal Printer, PIN Pad, Remote Order Display.
//   Add the following properties:
//     CapPowerReporting, PowerNotify, PowerState
// 1998-09-29 OPOS Release 1.4                                OPOS-J
//   Add CAT.
// 2000-09-24 OPOS Release 1.5                                   BKS
//   Add Point Card Reader Writer and POS Power.
// 2002-08-17 OPOS Release 1.7                                   CRM
//   Add Check Scanner and Motion Sensor.
// 2004-03-22 OPOS Release 1.8                                   CRM
//   Add Smart Card Reader Writer.
// 2005-04-29 OPOS Release 1.9                                   CRM
//   Add the following properties:
//     CapCompareFirmwareVersion, CapUpdateFirmware
//   Remove validation functions.
// 2006-03-15 OPOS Release 1.10                                  CRM
//   Add Biometrics and Electronic Journal
// 2007-01-30 OPOS Release 1.11                                  CRM
//   Add BillAcceptor, BillDispensor, CoinAcceptor, ImageScanner
//
//////////////////////////////////////////////////////////////////////

interface

const

//////////////////////////////////////////////////////////////////////
// Registry Keys
//////////////////////////////////////////////////////////////////////

// OPOS_ROOTKEY is the key under which all OPOS Service Object keys
//   and values are placed.  This key will contain device class keys.
//   (The base key is HKEY_LOCAL_MACHINE.)
  OPOS_ROOTKEY = 'SOFTWARE\OLEforRetail\ServiceOPOS';

// Device Class Keys
//   Release 1.0
  OPOS_CLASSKEY_CASH    = 'CashDrawer';
  OPOS_CLASSKEY_COIN    = 'CoinDispenser';
  OPOS_CLASSKEY_TOT     = 'HardTotals';
  OPOS_CLASSKEY_LOCK    = 'Keylock';
  OPOS_CLASSKEY_DISP    = 'LineDisplay';
  OPOS_CLASSKEY_MICR    = 'MICR';
  OPOS_CLASSKEY_MSR     = 'MSR';
  OPOS_CLASSKEY_PTR     = 'POSPrinter';
  OPOS_CLASSKEY_SCAL    = 'Scale';
  OPOS_CLASSKEY_SCAN    = 'Scanner';
  OPOS_CLASSKEY_SIG     = 'SignatureCapture';
//   Release 1.1
  OPOS_CLASSKEY_KBD     = 'POSKeyboard';
//   Release 1.2
  OPOS_CLASSKEY_CHAN    = 'CashChanger';
  OPOS_CLASSKEY_TONE    = 'ToneIndicator';
//   Release 1.3
  OPOS_CLASSKEY_BB      = 'BumpBar';
  OPOS_CLASSKEY_FPTR    = 'FiscalPrinter';
  OPOS_CLASSKEY_PPAD    = 'PINPad';
  OPOS_CLASSKEY_ROD     = 'RemoteOrderDisplay';
//   Release 1.4
  OPOS_CLASSKEY_CAT     = 'CAT';
//   Release 1.5
  OPOS_CLASSKEY_PCRW    = 'PointCardRW';
  OPOS_CLASSKEY_PWR     = 'POSPower';
//   Release 1.7
  OPOS_CLASSKEY_CHK     = 'CheckScanner';
  OPOS_CLASSKEY_MOTION  = 'MotionSensor';
//   Release 1.8
  OPOS_CLASSKEY_SCRW    = 'SmartCardRW';
//   Release 1.10
  OPOS_CLASSKEY_BIO     = 'Biometrics';
  OPOS_CLASSKEY_EJ      = 'ElectronicJournal';
//   Release 1.10
  OPOS_CLASSKEY_BACC    = 'BillAcceptor';
  OPOS_CLASSKEY_BDSP    = 'BillDispenser';
  OPOS_CLASSKEY_CACC    = 'CoinAcceptor';
  OPOS_CLASSKEY_IMG     = 'ImageScanner';

// OPOS_ROOTKEY_PROVIDER is the key under which a Service Object
//   provider may place provider-specific information.
//   (The base key is HKEY_LOCAL_MACHINE.)

  OPOS_ROOTKEY_PROVIDER = 'SOFTWARE\OLEforRetail\ServiceInfo';


//////////////////////////////////////////////////////////////////////
// Common Property Base Index Values.
//////////////////////////////////////////////////////////////////////

// * Base Indices *

  PIDX_NUMBER                  =        0;
  PIDX_STRING                  =  1000000; // 1,000,000

// **Warning**
//   OPOS property indices may not be changed by future releases.
//   New indices must be added sequentially at the end of the
//     numeric, capability, and string sections.
//     Also, the validation functions must be updated.


// Note: The ControlObjectDescription and ControlObjectVersion
//   properties are processed entirely by the CO. Therefore, no
//   property index values are required below.


//////////////////////////////////////////////////////////////////////
// Common Numeric Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDX_Claimed                 =   1 + PIDX_NUMBER;
  PIDX_DataEventEnabled        =   2 + PIDX_NUMBER;
  PIDX_DeviceEnabled           =   3 + PIDX_NUMBER;
  PIDX_FreezeEvents            =   4 + PIDX_NUMBER;
  PIDX_OutputID                =   5 + PIDX_NUMBER;
  PIDX_ResultCode              =   6 + PIDX_NUMBER;
  PIDX_ResultCodeExtended      =   7 + PIDX_NUMBER;
  PIDX_ServiceObjectVersion    =   8 + PIDX_NUMBER;
  PIDX_State                   =   9 + PIDX_NUMBER;

//      Added for Release 1.2:
  PIDX_AutoDisable             =  10 + PIDX_NUMBER;
  PIDX_BinaryConversion        =  11 + PIDX_NUMBER;
  PIDX_DataCount               =  12 + PIDX_NUMBER;

//      Added for Release 1.3:
  PIDX_PowerNotify             =  13 + PIDX_NUMBER;
  PIDX_PowerState              =  14 + PIDX_NUMBER;


// * Capabilities *

//      Added for Release 1.3:
  PIDX_CapPowerReporting       = 501 + PIDX_NUMBER;

//      Added for Release 1.8:
  PIDX_CapStatisticsReporting  = 502 + PIDX_NUMBER;
  PIDX_CapUpdateStatistics     = 503 + PIDX_NUMBER;

//      Added for Release 1.9:
  PIDX_CapCompareFirmwareVersion = 504 + PIDX_NUMBER;
  PIDX_CapUpdateFirmware       = 505 + PIDX_NUMBER;


//////////////////////////////////////////////////////////////////////
// Common String Property Index Values.
//////////////////////////////////////////////////////////////////////

// * Properties *

  PIDX_CheckHealthText         =   1 + PIDX_STRING;
  PIDX_DeviceDescription       =   2 + PIDX_STRING;
  PIDX_DeviceName              =   3 + PIDX_STRING;
  PIDX_ServiceObjectDescription=   4 + PIDX_STRING;


//////////////////////////////////////////////////////////////////////
// Class Property Base Index Values.
//////////////////////////////////////////////////////////////////////

//   Release 1.0
  PIDX_CASH    =  1000;  // Cash Drawer.
  PIDX_COIN    =  2000;  // Coin Dispenser.
  PIDX_TOT     =  3000;  // Hard Totals.
  PIDX_LOCK    =  4000;  // Keylock.
  PIDX_DISP    =  5000;  // Line Display.
  PIDX_MICR    =  6000;  // Magnetic Ink Character Recognition.
  PIDX_MSR     =  7000;  // Magnetic Stripe Reader.
  PIDX_PTR     =  8000;  // POS Printer.
  PIDX_SCAL    =  9000;  // Scale.
  PIDX_SCAN    = 10000;  // Scanner - Bar Code Reader.
  PIDX_SIG     = 11000;  // Signature Capture.
//   Release 1.1
  PIDX_KBD     = 12000;  // POS Keyboard.
//   Release 1.2
  PIDX_CHAN    = 13000;  // Cash Changer.
  PIDX_TONE    = 14000;  // Tone Indicator.
//   Release 1.3
  PIDX_BB      = 15000;  // Bump Bar.
  PIDX_FPTR    = 16000;  // Fiscal Printer.
  PIDX_PPAD    = 17000;  // PIN Pad.
  PIDX_ROD     = 18000;  // Remote Order Display.
//   Release 1.4
  PIDX_CAT     = 19000;  // CAT.
//   Release 1.5
  PIDX_PCRW    = 20000;  // Point Card Reader Writer.
  PIDX_PWR     = 21000;  // POS Power.
//   Release 1.7
  PIDX_CHK     = 22000;  // Check Scanner.
  PIDX_MOTION  = 23000;  // Motion Sensor.
//   Release 1.8
  PIDX_SCRW    = 24000;  // Smart Card Reader Writer.
//   Release 1.10
  PIDX_BIO     = 25000;  // Biometrics.
  PIDX_EJ      = 26000;  // Electronic Journal.
//   Release 1.11
  PIDX_BACC    = 27000;  // BillAcceptor
  PIDX_BDSP    = 28000;  // BillDispenser
  PIDX_CACC    = 29000;  // CoinAcceptor
  PIDX_IMG     = 30000;  // ImageScanner


function IsNumericPidx(Pidx: Integer): Boolean;
function IsStringPidx(Pidx: Integer): Boolean;

implementation

// * Range Test Functions *

function IsNumericPidx(Pidx: Integer): Boolean;
begin
  Result := Pidx < PIDX_STRING;
end;

function IsStringPidx(Pidx: Integer): Boolean;
begin
  Result := Pidx >= PIDX_STRING;
end;

end.
