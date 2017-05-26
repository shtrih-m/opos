unit OposFiscalPrinter_1_12_Lib_TLB;

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
// File generated on 09.03.2010 17:01:27 from Type Library described below.

// ************************************************************************  //
// Type Lib: D:\Projects\Work\OposShtrih\Source\Opos\OPOSFiscalPrinter.tlb (1)
// LIBID: {CCB90070-B81E-11D2-AB74-0040054C3719}
// LCID: 0
// Helpfile: 
// HelpString: OPOS FiscalPrinter Control 1.12.000 [Public, by CRM/RCS-Dayton]
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
  OposFiscalPrinter_CCOMajorVersion = 1;
  OposFiscalPrinter_CCOMinorVersion = 0;

  LIBID_OposFiscalPrinter_CCO: TGUID = '{CCB90070-B81E-11D2-AB74-0040054C3719}';

  DIID__IOPOSFiscalPrinterEvents: TGUID = '{CCB90073-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter_1_6: TGUID = '{CCB92071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter_1_8: TGUID = '{CCB93071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter_1_9: TGUID = '{CCB94071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter_1_11: TGUID = '{CCB95071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter_1_12: TGUID = '{CCB96071-B81E-11D2-AB74-0040054C3719}';
  IID_IOPOSFiscalPrinter: TGUID = '{CCB97071-B81E-11D2-AB74-0040054C3719}';
  CLASS_OPOSFiscalPrinter: TGUID = '{CCB90072-B81E-11D2-AB74-0040054C3719}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  _IOPOSFiscalPrinterEvents = dispinterface;
  IOPOSFiscalPrinter_1_6 = interface;
  IOPOSFiscalPrinter_1_8 = interface;
  IOPOSFiscalPrinter_1_9 = interface;
  IOPOSFiscalPrinter_1_11 = interface;
  IOPOSFiscalPrinter_1_12 = interface;
  IOPOSFiscalPrinter_1_12Disp = dispinterface;
  IOPOSFiscalPrinter = interface;
  IOPOSFiscalPrinterDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OPOSFiscalPrinter = IOPOSFiscalPrinter;


// *********************************************************************//
// DispIntf:  _IOPOSFiscalPrinterEvents
// Flags:     (4096) Dispatchable
// GUID:      {CCB90073-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  _IOPOSFiscalPrinterEvents = dispinterface
    ['{CCB90073-B81E-11D2-AB74-0040054C3719}']
    procedure DirectIOEvent(EventNumber: Integer; var pData: Integer; var pString: WideString); dispid 2;
    procedure ErrorEvent(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                         var pErrorResponse: Integer); dispid 3;
    procedure OutputCompleteEvent(OutputID: Integer); dispid 4;
    procedure StatusUpdateEvent(Data: Integer); dispid 5;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter_1_6
// Flags:     (4096) Dispatchable
// GUID:      {CCB92071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter_1_6 = interface(IDispatch)
    ['{CCB92071-B81E-11D2-AB74-0040054C3719}']
    function SODataDummy(Status: Integer): HResult; stdcall;
    function SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString): HResult; stdcall;
    function SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                     var pErrorResponse: Integer): HResult; stdcall;
    function SOOutputComplete(OutputID: Integer): HResult; stdcall;
    function SOStatusUpdate(Data: Integer): HResult; stdcall;
    function SOProcessID(out pProcessID: Integer): HResult; stdcall;
    function Get_OpenResult(out pOpenResult: Integer): HResult; stdcall;
    function Get_BinaryConversion(out pBinaryConversion: Integer): HResult; stdcall;
    function Set_BinaryConversion(pBinaryConversion: Integer): HResult; stdcall;
    function Get_CapPowerReporting(out pCapPowerReporting: Integer): HResult; stdcall;
    function Get_CheckHealthText(out pCheckHealthText: WideString): HResult; stdcall;
    function Get_Claimed(out pClaimed: WordBool): HResult; stdcall;
    function Get_DeviceEnabled(out pDeviceEnabled: WordBool): HResult; stdcall;
    function Set_DeviceEnabled(pDeviceEnabled: WordBool): HResult; stdcall;
    function Get_FreezeEvents(out pFreezeEvents: WordBool): HResult; stdcall;
    function Set_FreezeEvents(pFreezeEvents: WordBool): HResult; stdcall;
    function Get_OutputID(out pOutputID: Integer): HResult; stdcall;
    function Get_PowerNotify(out pPowerNotify: Integer): HResult; stdcall;
    function Set_PowerNotify(pPowerNotify: Integer): HResult; stdcall;
    function Get_PowerState(out pPowerState: Integer): HResult; stdcall;
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
    function ClearOutput(out pRC: Integer): HResult; stdcall;
    function Close(out pRC: Integer): HResult; stdcall;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString; 
                      out pRC: Integer): HResult; stdcall;
    function Open(const DeviceName: WideString; out pRC: Integer): HResult; stdcall;
    function ReleaseDevice(out pRC: Integer): HResult; stdcall;
    function Get_AmountDecimalPlaces(out pAmountDecimalPlaces: Integer): HResult; stdcall;
    function Get_AsyncMode(out pAsyncMode: WordBool): HResult; stdcall;
    function Set_AsyncMode(pAsyncMode: WordBool): HResult; stdcall;
    function Get_CapAdditionalLines(out pCapAdditionalLines: WordBool): HResult; stdcall;
    function Get_CapAmountAdjustment(out pCapAmountAdjustment: WordBool): HResult; stdcall;
    function Get_CapAmountNotPaid(out pCapAmountNotPaid: WordBool): HResult; stdcall;
    function Get_CapCheckTotal(out pCapCheckTotal: WordBool): HResult; stdcall;
    function Get_CapCoverSensor(out pCapCoverSensor: WordBool): HResult; stdcall;
    function Get_CapDoubleWidth(out pCapDoubleWidth: WordBool): HResult; stdcall;
    function Get_CapDuplicateReceipt(out pCapDuplicateReceipt: WordBool): HResult; stdcall;
    function Get_CapFixedOutput(out pCapFixedOutput: WordBool): HResult; stdcall;
    function Get_CapHasVatTable(out pCapHasVatTable: WordBool): HResult; stdcall;
    function Get_CapIndependentHeader(out pCapIndependentHeader: WordBool): HResult; stdcall;
    function Get_CapItemList(out pCapItemList: WordBool): HResult; stdcall;
    function Get_CapJrnEmptySensor(out pCapJrnEmptySensor: WordBool): HResult; stdcall;
    function Get_CapJrnNearEndSensor(out pCapJrnNearEndSensor: WordBool): HResult; stdcall;
    function Get_CapJrnPresent(out pCapJrnPresent: WordBool): HResult; stdcall;
    function Get_CapNonFiscalMode(out pCapNonFiscalMode: WordBool): HResult; stdcall;
    function Get_CapOrderAdjustmentFirst(out pCapOrderAdjustmentFirst: WordBool): HResult; stdcall;
    function Get_CapPercentAdjustment(out pCapPercentAdjustment: WordBool): HResult; stdcall;
    function Get_CapPositiveAdjustment(out pCapPositiveAdjustment: WordBool): HResult; stdcall;
    function Get_CapPowerLossReport(out pCapPowerLossReport: WordBool): HResult; stdcall;
    function Get_CapPredefinedPaymentLines(out pCapPredefinedPaymentLines: WordBool): HResult; stdcall;
    function Get_CapReceiptNotPaid(out pCapReceiptNotPaid: WordBool): HResult; stdcall;
    function Get_CapRecEmptySensor(out pCapRecEmptySensor: WordBool): HResult; stdcall;
    function Get_CapRecNearEndSensor(out pCapRecNearEndSensor: WordBool): HResult; stdcall;
    function Get_CapRecPresent(out pCapRecPresent: WordBool): HResult; stdcall;
    function Get_CapRemainingFiscalMemory(out pCapRemainingFiscalMemory: WordBool): HResult; stdcall;
    function Get_CapReservedWord(out pCapReservedWord: WordBool): HResult; stdcall;
    function Get_CapSetHeader(out pCapSetHeader: WordBool): HResult; stdcall;
    function Get_CapSetPOSID(out pCapSetPOSID: WordBool): HResult; stdcall;
    function Get_CapSetStoreFiscalID(out pCapSetStoreFiscalID: WordBool): HResult; stdcall;
    function Get_CapSetTrailer(out pCapSetTrailer: WordBool): HResult; stdcall;
    function Get_CapSetVatTable(out pCapSetVatTable: WordBool): HResult; stdcall;
    function Get_CapSlpEmptySensor(out pCapSlpEmptySensor: WordBool): HResult; stdcall;
    function Get_CapSlpFiscalDocument(out pCapSlpFiscalDocument: WordBool): HResult; stdcall;
    function Get_CapSlpFullSlip(out pCapSlpFullSlip: WordBool): HResult; stdcall;
    function Get_CapSlpNearEndSensor(out pCapSlpNearEndSensor: WordBool): HResult; stdcall;
    function Get_CapSlpPresent(out pCapSlpPresent: WordBool): HResult; stdcall;
    function Get_CapSlpValidation(out pCapSlpValidation: WordBool): HResult; stdcall;
    function Get_CapSubAmountAdjustment(out pCapSubAmountAdjustment: WordBool): HResult; stdcall;
    function Get_CapSubPercentAdjustment(out pCapSubPercentAdjustment: WordBool): HResult; stdcall;
    function Get_CapSubtotal(out pCapSubtotal: WordBool): HResult; stdcall;
    function Get_CapTrainingMode(out pCapTrainingMode: WordBool): HResult; stdcall;
    function Get_CapValidateJournal(out pCapValidateJournal: WordBool): HResult; stdcall;
    function Get_CapXReport(out pCapXReport: WordBool): HResult; stdcall;
    function Get_CheckTotal(out pCheckTotal: WordBool): HResult; stdcall;
    function Set_CheckTotal(pCheckTotal: WordBool): HResult; stdcall;
    function Get_CountryCode(out pCountryCode: Integer): HResult; stdcall;
    function Get_CoverOpen(out pCoverOpen: WordBool): HResult; stdcall;
    function Get_DayOpened(out pDayOpened: WordBool): HResult; stdcall;
    function Get_DescriptionLength(out pDescriptionLength: Integer): HResult; stdcall;
    function Get_DuplicateReceipt(out pDuplicateReceipt: WordBool): HResult; stdcall;
    function Set_DuplicateReceipt(pDuplicateReceipt: WordBool): HResult; stdcall;
    function Get_ErrorLevel(out pErrorLevel: Integer): HResult; stdcall;
    function Get_ErrorOutID(out pErrorOutID: Integer): HResult; stdcall;
    function Get_ErrorState(out pErrorState: Integer): HResult; stdcall;
    function Get_ErrorStation(out pErrorStation: Integer): HResult; stdcall;
    function Get_ErrorString(out pErrorString: WideString): HResult; stdcall;
    function Get_FlagWhenIdle(out pFlagWhenIdle: WordBool): HResult; stdcall;
    function Set_FlagWhenIdle(pFlagWhenIdle: WordBool): HResult; stdcall;
    function Get_JrnEmpty(out pJrnEmpty: WordBool): HResult; stdcall;
    function Get_JrnNearEnd(out pJrnNearEnd: WordBool): HResult; stdcall;
    function Get_MessageLength(out pMessageLength: Integer): HResult; stdcall;
    function Get_NumHeaderLines(out pNumHeaderLines: Integer): HResult; stdcall;
    function Get_NumTrailerLines(out pNumTrailerLines: Integer): HResult; stdcall;
    function Get_NumVatRates(out pNumVatRates: Integer): HResult; stdcall;
    function Get_PredefinedPaymentLines(out pPredefinedPaymentLines: WideString): HResult; stdcall;
    function Get_PrinterState(out pPrinterState: Integer): HResult; stdcall;
    function Get_QuantityDecimalPlaces(out pQuantityDecimalPlaces: Integer): HResult; stdcall;
    function Get_QuantityLength(out pQuantityLength: Integer): HResult; stdcall;
    function Get_RecEmpty(out pRecEmpty: WordBool): HResult; stdcall;
    function Get_RecNearEnd(out pRecNearEnd: WordBool): HResult; stdcall;
    function Get_RemainingFiscalMemory(out pRemainingFiscalMemory: Integer): HResult; stdcall;
    function Get_ReservedWord(out pReservedWord: WideString): HResult; stdcall;
    function Get_SlipSelection(out pSlipSelection: Integer): HResult; stdcall;
    function Set_SlipSelection(pSlipSelection: Integer): HResult; stdcall;
    function Get_SlpEmpty(out pSlpEmpty: WordBool): HResult; stdcall;
    function Get_SlpNearEnd(out pSlpNearEnd: WordBool): HResult; stdcall;
    function Get_TrainingModeActive(out pTrainingModeActive: WordBool): HResult; stdcall;
    function BeginFiscalDocument(DocumentAmount: Integer; out pRC: Integer): HResult; stdcall;
    function BeginFiscalReceipt(PrintHeader: WordBool; out pRC: Integer): HResult; stdcall;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer; out pRC: Integer): HResult; stdcall;
    function BeginInsertion(Timeout: Integer; out pRC: Integer): HResult; stdcall;
    function BeginItemList(VatID: Integer; out pRC: Integer): HResult; stdcall;
    function BeginNonFiscal(out pRC: Integer): HResult; stdcall;
    function BeginRemoval(Timeout: Integer; out pRC: Integer): HResult; stdcall;
    function BeginTraining(out pRC: Integer): HResult; stdcall;
    function ClearError(out pRC: Integer): HResult; stdcall;
    function EndFiscalDocument(out pRC: Integer): HResult; stdcall;
    function EndFiscalReceipt(PrintHeader: WordBool; out pRC: Integer): HResult; stdcall;
    function EndFixedOutput(out pRC: Integer): HResult; stdcall;
    function EndInsertion(out pRC: Integer): HResult; stdcall;
    function EndItemList(out pRC: Integer): HResult; stdcall;
    function EndNonFiscal(out pRC: Integer): HResult; stdcall;
    function EndRemoval(out pRC: Integer): HResult; stdcall;
    function EndTraining(out pRC: Integer): HResult; stdcall;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString; out pRC: Integer): HResult; stdcall;
    function GetDate(out Date: WideString; out pRC: Integer): HResult; stdcall;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString; out pRC: Integer): HResult; stdcall;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer; out pRC: Integer): HResult; stdcall;
    function PrintDuplicateReceipt(out pRC: Integer): HResult; stdcall;
    function PrintFiscalDocumentLine(const DocumentLine: WideString; out pRC: Integer): HResult; stdcall;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString; 
                              out pRC: Integer): HResult; stdcall;
    function PrintNormal(Station: Integer; const Data: WideString; out pRC: Integer): HResult; stdcall;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString; 
                                       out pRC: Integer): HResult; stdcall;
    function PrintPowerLossReport(out pRC: Integer): HResult; stdcall;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                          out pRC: Integer): HResult; stdcall;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer; out pRC: Integer): HResult; stdcall;
    function PrintRecMessage(const Message: WideString; out pRC: Integer): HResult; stdcall;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency; out pRC: Integer): HResult; stdcall;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer; 
                            out pRC: Integer): HResult; stdcall;
    function PrintRecSubtotal(Amount: Currency; out pRC: Integer): HResult; stdcall;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; out pRC: Integer): HResult; stdcall;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString; 
                           out pRC: Integer): HResult; stdcall;
    function PrintRecVoid(const Description: WideString; out pRC: Integer): HResult; stdcall;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer; 
                              out pRC: Integer): HResult; stdcall;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString; 
                         out pRC: Integer): HResult; stdcall;
    function PrintXReport(out pRC: Integer): HResult; stdcall;
    function PrintZReport(out pRC: Integer): HResult; stdcall;
    function ResetPrinter(out pRC: Integer): HResult; stdcall;
    function SetDate(const Date: WideString; out pRC: Integer): HResult; stdcall;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool; 
                           out pRC: Integer): HResult; stdcall;
    function SetPOSID(const POSID: WideString; const CashierID: WideString; out pRC: Integer): HResult; stdcall;
    function SetStoreFiscalID(const ID: WideString; out pRC: Integer): HResult; stdcall;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool; 
                            out pRC: Integer): HResult; stdcall;
    function SetVatTable(out pRC: Integer): HResult; stdcall;
    function SetVatValue(VatID: Integer; const VatValue: WideString; out pRC: Integer): HResult; stdcall;
    function VerifyItem(const ItemName: WideString; VatID: Integer; out pRC: Integer): HResult; stdcall;
    function Get_ActualCurrency(out pActualCurrency: Integer): HResult; stdcall;
    function Get_AdditionalHeader(out pAdditionalHeader: WideString): HResult; stdcall;
    function Set_AdditionalHeader(const pAdditionalHeader: WideString): HResult; stdcall;
    function Get_AdditionalTrailer(out pAdditionalTrailer: WideString): HResult; stdcall;
    function Set_AdditionalTrailer(const pAdditionalTrailer: WideString): HResult; stdcall;
    function Get_CapAdditionalHeader(out pCapAdditionalHeader: WordBool): HResult; stdcall;
    function Get_CapAdditionalTrailer(out pCapAdditionalTrailer: WordBool): HResult; stdcall;
    function Get_CapChangeDue(out pCapChangeDue: WordBool): HResult; stdcall;
    function Get_CapEmptyReceiptIsVoidable(out pCapEmptyReceiptIsVoidable: WordBool): HResult; stdcall;
    function Get_CapFiscalReceiptStation(out pCapFiscalReceiptStation: WordBool): HResult; stdcall;
    function Get_CapFiscalReceiptType(out pCapFiscalReceiptType: WordBool): HResult; stdcall;
    function Get_CapMultiContractor(out pCapMultiContractor: WordBool): HResult; stdcall;
    function Get_CapOnlyVoidLastItem(out pCapOnlyVoidLastItem: WordBool): HResult; stdcall;
    function Get_CapPackageAdjustment(out pCapPackageAdjustment: WordBool): HResult; stdcall;
    function Get_CapPostPreLine(out pCapPostPreLine: WordBool): HResult; stdcall;
    function Get_CapSetCurrency(out pCapSetCurrency: WordBool): HResult; stdcall;
    function Get_CapTotalizerType(out pCapTotalizerType: WordBool): HResult; stdcall;
    function Get_ChangeDue(out pChangeDue: WideString): HResult; stdcall;
    function Set_ChangeDue(const pChangeDue: WideString): HResult; stdcall;
    function Get_ContractorId(out pContractorId: Integer): HResult; stdcall;
    function Set_ContractorId(pContractorId: Integer): HResult; stdcall;
    function Get_DateType(out pDateType: Integer): HResult; stdcall;
    function Set_DateType(pDateType: Integer): HResult; stdcall;
    function Get_FiscalReceiptStation(out pFiscalReceiptStation: Integer): HResult; stdcall;
    function Set_FiscalReceiptStation(pFiscalReceiptStation: Integer): HResult; stdcall;
    function Get_FiscalReceiptType(out pFiscalReceiptType: Integer): HResult; stdcall;
    function Set_FiscalReceiptType(pFiscalReceiptType: Integer): HResult; stdcall;
    function Get_MessageType(out pMessageType: Integer): HResult; stdcall;
    function Set_MessageType(pMessageType: Integer): HResult; stdcall;
    function Get_PostLine(out pPostLine: WideString): HResult; stdcall;
    function Set_PostLine(const pPostLine: WideString): HResult; stdcall;
    function Get_PreLine(out pPreLine: WideString): HResult; stdcall;
    function Set_PreLine(const pPreLine: WideString): HResult; stdcall;
    function Get_TotalizerType(out pTotalizerType: Integer): HResult; stdcall;
    function Set_TotalizerType(pTotalizerType: Integer): HResult; stdcall;
    function PrintRecCash(Amount: Currency; out pRC: Integer): HResult; stdcall;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString; 
                              out pRC: Integer): HResult; stdcall;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency; out pRC: Integer): HResult; stdcall;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString; out pRC: Integer): HResult; stdcall;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString; 
                                       out pRC: Integer): HResult; stdcall;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer; 
                                out pRC: Integer): HResult; stdcall;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency; out pRC: Integer): HResult; stdcall;
    function PrintRecTaxID(const TaxID: WideString; out pRC: Integer): HResult; stdcall;
    function SetCurrency(NewCurrency: Integer; out pRC: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter_1_8
// Flags:     (4096) Dispatchable
// GUID:      {CCB93071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter_1_8 = interface(IOPOSFiscalPrinter_1_6)
    ['{CCB93071-B81E-11D2-AB74-0040054C3719}']
    function Get_CapStatisticsReporting(out pCapStatisticsReporting: WordBool): HResult; stdcall;
    function Get_CapUpdateStatistics(out pCapUpdateStatistics: WordBool): HResult; stdcall;
    function ResetStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult; stdcall;
    function RetrieveStatistics(var pStatisticsBuffer: WideString; out pRC: Integer): HResult; stdcall;
    function UpdateStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter_1_9
// Flags:     (4096) Dispatchable
// GUID:      {CCB94071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter_1_9 = interface(IOPOSFiscalPrinter_1_8)
    ['{CCB94071-B81E-11D2-AB74-0040054C3719}']
    function Get_CapCompareFirmwareVersion(out pCapCompareFirmwareVersion: WordBool): HResult; stdcall;
    function Get_CapUpdateFirmware(out pCapUpdateFirmware: WordBool): HResult; stdcall;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer; 
                                    out pRC: Integer): HResult; stdcall;
    function UpdateFirmware(const FirmwareFileName: WideString; out pRC: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter_1_11
// Flags:     (4096) Dispatchable
// GUID:      {CCB95071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter_1_11 = interface(IOPOSFiscalPrinter_1_9)
    ['{CCB95071-B81E-11D2-AB74-0040054C3719}']
    function Get_CapPositiveSubtotalAdjustment(out pCapPositiveSubtotalAdjustment: WordBool): HResult; stdcall;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer; out pRC: Integer): HResult; stdcall;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              out pRC: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter_1_12
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB96071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter_1_12 = interface(IOPOSFiscalPrinter_1_11)
    ['{CCB96071-B81E-11D2-AB74-0040054C3719}']
    function PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity: Integer; 
                                VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; safecall;
    function PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; 
                                    Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; 
                                    const UnitName: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinter_1_12Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB96071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter_1_12Disp = dispinterface
    ['{CCB96071-B81E-11D2-AB74-0040054C3719}']
    function PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity: Integer; 
                                VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; dispid 200;
    function PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; 
                                    Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; 
                                    const UnitName: WideString): Integer; dispid 201;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
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
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    function BinaryConversion: Integer; dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    function DeviceEnabled: WordBool; dispid 17;
    function FreezeEvents: WordBool; dispid 18;
    property OutputID: Integer readonly dispid 19;
    function PowerNotify: Integer; dispid 20;
    property PowerState: Integer readonly dispid 21;
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
    property AmountDecimalPlaces: Integer readonly dispid 50;
    function AsyncMode: WordBool; dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    function CheckTotal: WordBool; dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    function DuplicateReceipt: WordBool; dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    function FlagWhenIdle: WordBool; dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    function SlipSelection: Integer; dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    function AdditionalHeader: WideString; dispid 211;
    function AdditionalTrailer: WideString; dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    function ChangeDue: WideString; dispid 225;
    function ContractorId: Integer; dispid 226;
    function DateType: Integer; dispid 227;
    function FiscalReceiptStation: Integer; dispid 228;
    function FiscalReceiptType: Integer; dispid 229;
    function MessageType: Integer; dispid 230;
    function PostLine: WideString; dispid 231;
    function PreLine: WideString; dispid 232;
    function TotalizerType: Integer; dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
  end;

// *********************************************************************//
// Interface: IOPOSFiscalPrinter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB97071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinter = interface(IOPOSFiscalPrinter_1_12)
    ['{CCB97071-B81E-11D2-AB74-0040054C3719}']
  end;

// *********************************************************************//
// DispIntf:  IOPOSFiscalPrinterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CCB97071-B81E-11D2-AB74-0040054C3719}
// *********************************************************************//
  IOPOSFiscalPrinterDisp = dispinterface
    ['{CCB97071-B81E-11D2-AB74-0040054C3719}']
    function PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity: Integer; 
                                VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer; dispid 200;
    function PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; 
                                    Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; 
                                    const UnitName: WideString): Integer; dispid 201;
    property CapPositiveSubtotalAdjustment: WordBool readonly dispid 234;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer): Integer; dispid 199;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 198;
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
    procedure SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                      var pErrorResponse: Integer); dispid 3;
    procedure SOOutputComplete(OutputID: Integer); dispid 4;
    procedure SOStatusUpdate(Data: Integer); dispid 5;
    function SOProcessID: Integer; dispid 9;
    property OpenResult: Integer readonly dispid 49;
    function BinaryConversion: Integer; dispid 11;
    property CapPowerReporting: Integer readonly dispid 12;
    property CheckHealthText: WideString readonly dispid 13;
    property Claimed: WordBool readonly dispid 14;
    function DeviceEnabled: WordBool; dispid 17;
    function FreezeEvents: WordBool; dispid 18;
    property OutputID: Integer readonly dispid 19;
    function PowerNotify: Integer; dispid 20;
    property PowerState: Integer readonly dispid 21;
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
    property AmountDecimalPlaces: Integer readonly dispid 50;
    function AsyncMode: WordBool; dispid 51;
    property CapAdditionalLines: WordBool readonly dispid 52;
    property CapAmountAdjustment: WordBool readonly dispid 53;
    property CapAmountNotPaid: WordBool readonly dispid 54;
    property CapCheckTotal: WordBool readonly dispid 55;
    property CapCoverSensor: WordBool readonly dispid 56;
    property CapDoubleWidth: WordBool readonly dispid 57;
    property CapDuplicateReceipt: WordBool readonly dispid 58;
    property CapFixedOutput: WordBool readonly dispid 59;
    property CapHasVatTable: WordBool readonly dispid 60;
    property CapIndependentHeader: WordBool readonly dispid 61;
    property CapItemList: WordBool readonly dispid 62;
    property CapJrnEmptySensor: WordBool readonly dispid 63;
    property CapJrnNearEndSensor: WordBool readonly dispid 64;
    property CapJrnPresent: WordBool readonly dispid 65;
    property CapNonFiscalMode: WordBool readonly dispid 66;
    property CapOrderAdjustmentFirst: WordBool readonly dispid 67;
    property CapPercentAdjustment: WordBool readonly dispid 68;
    property CapPositiveAdjustment: WordBool readonly dispid 69;
    property CapPowerLossReport: WordBool readonly dispid 70;
    property CapPredefinedPaymentLines: WordBool readonly dispid 71;
    property CapReceiptNotPaid: WordBool readonly dispid 72;
    property CapRecEmptySensor: WordBool readonly dispid 73;
    property CapRecNearEndSensor: WordBool readonly dispid 74;
    property CapRecPresent: WordBool readonly dispid 75;
    property CapRemainingFiscalMemory: WordBool readonly dispid 76;
    property CapReservedWord: WordBool readonly dispid 77;
    property CapSetHeader: WordBool readonly dispid 78;
    property CapSetPOSID: WordBool readonly dispid 79;
    property CapSetStoreFiscalID: WordBool readonly dispid 80;
    property CapSetTrailer: WordBool readonly dispid 81;
    property CapSetVatTable: WordBool readonly dispid 82;
    property CapSlpEmptySensor: WordBool readonly dispid 83;
    property CapSlpFiscalDocument: WordBool readonly dispid 84;
    property CapSlpFullSlip: WordBool readonly dispid 85;
    property CapSlpNearEndSensor: WordBool readonly dispid 86;
    property CapSlpPresent: WordBool readonly dispid 87;
    property CapSlpValidation: WordBool readonly dispid 88;
    property CapSubAmountAdjustment: WordBool readonly dispid 89;
    property CapSubPercentAdjustment: WordBool readonly dispid 90;
    property CapSubtotal: WordBool readonly dispid 91;
    property CapTrainingMode: WordBool readonly dispid 92;
    property CapValidateJournal: WordBool readonly dispid 93;
    property CapXReport: WordBool readonly dispid 94;
    function CheckTotal: WordBool; dispid 95;
    property CountryCode: Integer readonly dispid 96;
    property CoverOpen: WordBool readonly dispid 97;
    property DayOpened: WordBool readonly dispid 98;
    property DescriptionLength: Integer readonly dispid 99;
    function DuplicateReceipt: WordBool; dispid 100;
    property ErrorLevel: Integer readonly dispid 101;
    property ErrorOutID: Integer readonly dispid 102;
    property ErrorState: Integer readonly dispid 103;
    property ErrorStation: Integer readonly dispid 104;
    property ErrorString: WideString readonly dispid 105;
    function FlagWhenIdle: WordBool; dispid 106;
    property JrnEmpty: WordBool readonly dispid 107;
    property JrnNearEnd: WordBool readonly dispid 108;
    property MessageLength: Integer readonly dispid 109;
    property NumHeaderLines: Integer readonly dispid 110;
    property NumTrailerLines: Integer readonly dispid 111;
    property NumVatRates: Integer readonly dispid 112;
    property PredefinedPaymentLines: WideString readonly dispid 113;
    property PrinterState: Integer readonly dispid 114;
    property QuantityDecimalPlaces: Integer readonly dispid 115;
    property QuantityLength: Integer readonly dispid 116;
    property RecEmpty: WordBool readonly dispid 117;
    property RecNearEnd: WordBool readonly dispid 118;
    property RemainingFiscalMemory: Integer readonly dispid 119;
    property ReservedWord: WideString readonly dispid 120;
    function SlipSelection: Integer; dispid 121;
    property SlpEmpty: WordBool readonly dispid 122;
    property SlpNearEnd: WordBool readonly dispid 123;
    property TrainingModeActive: WordBool readonly dispid 124;
    function BeginFiscalDocument(DocumentAmount: Integer): Integer; dispid 140;
    function BeginFiscalReceipt(PrintHeader: WordBool): Integer; dispid 141;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer): Integer; dispid 142;
    function BeginInsertion(Timeout: Integer): Integer; dispid 143;
    function BeginItemList(VatID: Integer): Integer; dispid 144;
    function BeginNonFiscal: Integer; dispid 145;
    function BeginRemoval(Timeout: Integer): Integer; dispid 146;
    function BeginTraining: Integer; dispid 147;
    function ClearError: Integer; dispid 148;
    function EndFiscalDocument: Integer; dispid 149;
    function EndFiscalReceipt(PrintHeader: WordBool): Integer; dispid 150;
    function EndFixedOutput: Integer; dispid 151;
    function EndInsertion: Integer; dispid 152;
    function EndItemList: Integer; dispid 153;
    function EndNonFiscal: Integer; dispid 154;
    function EndRemoval: Integer; dispid 155;
    function EndTraining: Integer; dispid 156;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString): Integer; dispid 157;
    function GetDate(out Date: WideString): Integer; dispid 158;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString): Integer; dispid 159;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer): Integer; dispid 160;
    function PrintDuplicateReceipt: Integer; dispid 161;
    function PrintFiscalDocumentLine(const DocumentLine: WideString): Integer; dispid 162;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString): Integer; dispid 163;
    function PrintNormal(Station: Integer; const Data: WideString): Integer; dispid 164;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString): Integer; dispid 165;
    function PrintPowerLossReport: Integer; dispid 166;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString): Integer; dispid 167;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer): Integer; dispid 168;
    function PrintRecMessage(const Message: WideString): Integer; dispid 169;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency): Integer; dispid 170;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 171;
    function PrintRecSubtotal(Amount: Currency): Integer; dispid 172;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency): Integer; dispid 173;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString): Integer; dispid 174;
    function PrintRecVoid(const Description: WideString): Integer; dispid 175;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer): Integer; dispid 176;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString): Integer; dispid 177;
    function PrintXReport: Integer; dispid 178;
    function PrintZReport: Integer; dispid 179;
    function ResetPrinter: Integer; dispid 180;
    function SetDate(const Date: WideString): Integer; dispid 181;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 182;
    function SetPOSID(const POSID: WideString; const CashierID: WideString): Integer; dispid 183;
    function SetStoreFiscalID(const ID: WideString): Integer; dispid 184;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool): Integer; dispid 185;
    function SetVatTable: Integer; dispid 186;
    function SetVatValue(VatID: Integer; const VatValue: WideString): Integer; dispid 187;
    function VerifyItem(const ItemName: WideString; VatID: Integer): Integer; dispid 188;
    property ActualCurrency: Integer readonly dispid 210;
    function AdditionalHeader: WideString; dispid 211;
    function AdditionalTrailer: WideString; dispid 212;
    property CapAdditionalHeader: WordBool readonly dispid 213;
    property CapAdditionalTrailer: WordBool readonly dispid 214;
    property CapChangeDue: WordBool readonly dispid 215;
    property CapEmptyReceiptIsVoidable: WordBool readonly dispid 216;
    property CapFiscalReceiptStation: WordBool readonly dispid 217;
    property CapFiscalReceiptType: WordBool readonly dispid 218;
    property CapMultiContractor: WordBool readonly dispid 219;
    property CapOnlyVoidLastItem: WordBool readonly dispid 220;
    property CapPackageAdjustment: WordBool readonly dispid 221;
    property CapPostPreLine: WordBool readonly dispid 222;
    property CapSetCurrency: WordBool readonly dispid 223;
    property CapTotalizerType: WordBool readonly dispid 224;
    function ChangeDue: WideString; dispid 225;
    function ContractorId: Integer; dispid 226;
    function DateType: Integer; dispid 227;
    function FiscalReceiptStation: Integer; dispid 228;
    function FiscalReceiptType: Integer; dispid 229;
    function MessageType: Integer; dispid 230;
    function PostLine: WideString; dispid 231;
    function PreLine: WideString; dispid 232;
    function TotalizerType: Integer; dispid 233;
    function PrintRecCash(Amount: Currency): Integer; dispid 189;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString): Integer; dispid 190;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency): Integer; dispid 191;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString): Integer; dispid 192;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString): Integer; dispid 193;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer): Integer; dispid 194;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency): Integer; dispid 195;
    function PrintRecTaxID(const TaxID: WideString): Integer; dispid 196;
    function SetCurrency(NewCurrency: Integer): Integer; dispid 197;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TOPOSFiscalPrinter
// Help String      : OPOS FiscalPrinter Control 1.12.000 [Public, by CRM/RCS-Dayton]
// Default Interface: IOPOSFiscalPrinter
// Def. Intf. DISP? : No
// Event   Interface: _IOPOSFiscalPrinterEvents
// TypeFlags        : (2) CanCreate
// *********************************************************************//
  TOPOSFiscalPrinterDirectIOEvent = procedure(ASender: TObject; EventNumber: Integer; 
                                                                var pData: Integer; 
                                                                var pString: WideString) of object;
  TOPOSFiscalPrinterErrorEvent = procedure(ASender: TObject; ResultCode: Integer; 
                                                             ResultCodeExtended: Integer; 
                                                             ErrorLocus: Integer; 
                                                             var pErrorResponse: Integer) of object;
  TOPOSFiscalPrinterOutputCompleteEvent = procedure(ASender: TObject; OutputID: Integer) of object;
  TOPOSFiscalPrinterStatusUpdateEvent = procedure(ASender: TObject; Data: Integer) of object;

  TOPOSFiscalPrinter = class(TOleControl)
  private
    FOnDirectIOEvent: TOPOSFiscalPrinterDirectIOEvent;
    FOnErrorEvent: TOPOSFiscalPrinterErrorEvent;
    FOnOutputCompleteEvent: TOPOSFiscalPrinterOutputCompleteEvent;
    FOnStatusUpdateEvent: TOPOSFiscalPrinterStatusUpdateEvent;
    FIntf: IOPOSFiscalPrinter;
    function  GetControlInterface: IOPOSFiscalPrinter;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_OpenResult(out pOpenResult: Integer): HResult;
    function Get_BinaryConversion(out pBinaryConversion: Integer): HResult;
    function Get_CapPowerReporting(out pCapPowerReporting: Integer): HResult;
    function Get_CheckHealthText(out pCheckHealthText: WideString): HResult;
    function Get_Claimed(out pClaimed: WordBool): HResult;
    function Get_DeviceEnabled(out pDeviceEnabled: WordBool): HResult;
    function Get_FreezeEvents(out pFreezeEvents: WordBool): HResult;
    function Get_OutputID(out pOutputID: Integer): HResult;
    function Get_PowerNotify(out pPowerNotify: Integer): HResult;
    function Get_PowerState(out pPowerState: Integer): HResult;
    function Get_ResultCode(out pResultCode: Integer): HResult;
    function Get_ResultCodeExtended(out pResultCodeExtended: Integer): HResult;
    function Get_State(out pState: Integer): HResult;
    function Get_ControlObjectDescription(out pControlObjectDescription: WideString): HResult;
    function Get_ControlObjectVersion(out pControlObjectVersion: Integer): HResult;
    function Get_ServiceObjectDescription(out pServiceObjectDescription: WideString): HResult;
    function Get_ServiceObjectVersion(out pServiceObjectVersion: Integer): HResult;
    function Get_DeviceDescription(out pDeviceDescription: WideString): HResult;
    function Get_DeviceName(out pDeviceName: WideString): HResult;
    function Get_AmountDecimalPlaces(out pAmountDecimalPlaces: Integer): HResult;
    function Get_AsyncMode(out pAsyncMode: WordBool): HResult;
    function Get_CapAdditionalLines(out pCapAdditionalLines: WordBool): HResult;
    function Get_CapAmountAdjustment(out pCapAmountAdjustment: WordBool): HResult;
    function Get_CapAmountNotPaid(out pCapAmountNotPaid: WordBool): HResult;
    function Get_CapCheckTotal(out pCapCheckTotal: WordBool): HResult;
    function Get_CapCoverSensor(out pCapCoverSensor: WordBool): HResult;
    function Get_CapDoubleWidth(out pCapDoubleWidth: WordBool): HResult;
    function Get_CapDuplicateReceipt(out pCapDuplicateReceipt: WordBool): HResult;
    function Get_CapFixedOutput(out pCapFixedOutput: WordBool): HResult;
    function Get_CapHasVatTable(out pCapHasVatTable: WordBool): HResult;
    function Get_CapIndependentHeader(out pCapIndependentHeader: WordBool): HResult;
    function Get_CapItemList(out pCapItemList: WordBool): HResult;
    function Get_CapJrnEmptySensor(out pCapJrnEmptySensor: WordBool): HResult;
    function Get_CapJrnNearEndSensor(out pCapJrnNearEndSensor: WordBool): HResult;
    function Get_CapJrnPresent(out pCapJrnPresent: WordBool): HResult;
    function Get_CapNonFiscalMode(out pCapNonFiscalMode: WordBool): HResult;
    function Get_CapOrderAdjustmentFirst(out pCapOrderAdjustmentFirst: WordBool): HResult;
    function Get_CapPercentAdjustment(out pCapPercentAdjustment: WordBool): HResult;
    function Get_CapPositiveAdjustment(out pCapPositiveAdjustment: WordBool): HResult;
    function Get_CapPowerLossReport(out pCapPowerLossReport: WordBool): HResult;
    function Get_CapPredefinedPaymentLines(out pCapPredefinedPaymentLines: WordBool): HResult;
    function Get_CapReceiptNotPaid(out pCapReceiptNotPaid: WordBool): HResult;
    function Get_CapRecEmptySensor(out pCapRecEmptySensor: WordBool): HResult;
    function Get_CapRecNearEndSensor(out pCapRecNearEndSensor: WordBool): HResult;
    function Get_CapRecPresent(out pCapRecPresent: WordBool): HResult;
    function Get_CapRemainingFiscalMemory(out pCapRemainingFiscalMemory: WordBool): HResult;
    function Get_CapReservedWord(out pCapReservedWord: WordBool): HResult;
    function Get_CapSetHeader(out pCapSetHeader: WordBool): HResult;
    function Get_CapSetPOSID(out pCapSetPOSID: WordBool): HResult;
    function Get_CapSetStoreFiscalID(out pCapSetStoreFiscalID: WordBool): HResult;
    function Get_CapSetTrailer(out pCapSetTrailer: WordBool): HResult;
    function Get_CapSetVatTable(out pCapSetVatTable: WordBool): HResult;
    function Get_CapSlpEmptySensor(out pCapSlpEmptySensor: WordBool): HResult;
    function Get_CapSlpFiscalDocument(out pCapSlpFiscalDocument: WordBool): HResult;
    function Get_CapSlpFullSlip(out pCapSlpFullSlip: WordBool): HResult;
    function Get_CapSlpNearEndSensor(out pCapSlpNearEndSensor: WordBool): HResult;
    function Get_CapSlpPresent(out pCapSlpPresent: WordBool): HResult;
    function Get_CapSlpValidation(out pCapSlpValidation: WordBool): HResult;
    function Get_CapSubAmountAdjustment(out pCapSubAmountAdjustment: WordBool): HResult;
    function Get_CapSubPercentAdjustment(out pCapSubPercentAdjustment: WordBool): HResult;
    function Get_CapSubtotal(out pCapSubtotal: WordBool): HResult;
    function Get_CapTrainingMode(out pCapTrainingMode: WordBool): HResult;
    function Get_CapValidateJournal(out pCapValidateJournal: WordBool): HResult;
    function Get_CapXReport(out pCapXReport: WordBool): HResult;
    function Get_CheckTotal(out pCheckTotal: WordBool): HResult;
    function Get_CountryCode(out pCountryCode: Integer): HResult;
    function Get_CoverOpen(out pCoverOpen: WordBool): HResult;
    function Get_DayOpened(out pDayOpened: WordBool): HResult;
    function Get_DescriptionLength(out pDescriptionLength: Integer): HResult;
    function Get_DuplicateReceipt(out pDuplicateReceipt: WordBool): HResult;
    function Get_ErrorLevel(out pErrorLevel: Integer): HResult;
    function Get_ErrorOutID(out pErrorOutID: Integer): HResult;
    function Get_ErrorState(out pErrorState: Integer): HResult;
    function Get_ErrorStation(out pErrorStation: Integer): HResult;
    function Get_ErrorString(out pErrorString: WideString): HResult;
    function Get_FlagWhenIdle(out pFlagWhenIdle: WordBool): HResult;
    function Get_JrnEmpty(out pJrnEmpty: WordBool): HResult;
    function Get_JrnNearEnd(out pJrnNearEnd: WordBool): HResult;
    function Get_MessageLength(out pMessageLength: Integer): HResult;
    function Get_NumHeaderLines(out pNumHeaderLines: Integer): HResult;
    function Get_NumTrailerLines(out pNumTrailerLines: Integer): HResult;
    function Get_NumVatRates(out pNumVatRates: Integer): HResult;
    function Get_PredefinedPaymentLines(out pPredefinedPaymentLines: WideString): HResult;
    function Get_PrinterState(out pPrinterState: Integer): HResult;
    function Get_QuantityDecimalPlaces(out pQuantityDecimalPlaces: Integer): HResult;
    function Get_QuantityLength(out pQuantityLength: Integer): HResult;
    function Get_RecEmpty(out pRecEmpty: WordBool): HResult;
    function Get_RecNearEnd(out pRecNearEnd: WordBool): HResult;
    function Get_RemainingFiscalMemory(out pRemainingFiscalMemory: Integer): HResult;
    function Get_ReservedWord(out pReservedWord: WideString): HResult;
    function Get_SlipSelection(out pSlipSelection: Integer): HResult;
    function Get_SlpEmpty(out pSlpEmpty: WordBool): HResult;
    function Get_SlpNearEnd(out pSlpNearEnd: WordBool): HResult;
    function Get_TrainingModeActive(out pTrainingModeActive: WordBool): HResult;
    function Get_ActualCurrency(out pActualCurrency: Integer): HResult;
    function Get_AdditionalHeader(out pAdditionalHeader: WideString): HResult;
    function Get_AdditionalTrailer(out pAdditionalTrailer: WideString): HResult;
    function Get_CapAdditionalHeader(out pCapAdditionalHeader: WordBool): HResult;
    function Get_CapAdditionalTrailer(out pCapAdditionalTrailer: WordBool): HResult;
    function Get_CapChangeDue(out pCapChangeDue: WordBool): HResult;
    function Get_CapEmptyReceiptIsVoidable(out pCapEmptyReceiptIsVoidable: WordBool): HResult;
    function Get_CapFiscalReceiptStation(out pCapFiscalReceiptStation: WordBool): HResult;
    function Get_CapFiscalReceiptType(out pCapFiscalReceiptType: WordBool): HResult;
    function Get_CapMultiContractor(out pCapMultiContractor: WordBool): HResult;
    function Get_CapOnlyVoidLastItem(out pCapOnlyVoidLastItem: WordBool): HResult;
    function Get_CapPackageAdjustment(out pCapPackageAdjustment: WordBool): HResult;
    function Get_CapPostPreLine(out pCapPostPreLine: WordBool): HResult;
    function Get_CapSetCurrency(out pCapSetCurrency: WordBool): HResult;
    function Get_CapTotalizerType(out pCapTotalizerType: WordBool): HResult;
    function Get_ChangeDue(out pChangeDue: WideString): HResult;
    function Get_ContractorId(out pContractorId: Integer): HResult;
    function Get_DateType(out pDateType: Integer): HResult;
    function Get_FiscalReceiptStation(out pFiscalReceiptStation: Integer): HResult;
    function Get_FiscalReceiptType(out pFiscalReceiptType: Integer): HResult;
    function Get_MessageType(out pMessageType: Integer): HResult;
    function Get_PostLine(out pPostLine: WideString): HResult;
    function Get_PreLine(out pPreLine: WideString): HResult;
    function Get_TotalizerType(out pTotalizerType: Integer): HResult;
    function Get_CapStatisticsReporting(out pCapStatisticsReporting: WordBool): HResult;
    function Get_CapUpdateStatistics(out pCapUpdateStatistics: WordBool): HResult;
    function Get_CapCompareFirmwareVersion(out pCapCompareFirmwareVersion: WordBool): HResult;
    function Get_CapUpdateFirmware(out pCapUpdateFirmware: WordBool): HResult;
    function Get_CapPositiveSubtotalAdjustment(out pCapPositiveSubtotalAdjustment: WordBool): HResult;
  public
    function SODataDummy(Status: Integer): HResult;
    function SODirectIO(EventNumber: Integer; var pData: Integer; var pString: WideString): HResult;
    function SOError(ResultCode: Integer; ResultCodeExtended: Integer; ErrorLocus: Integer; 
                     var pErrorResponse: Integer): HResult;
    function SOOutputComplete(OutputID: Integer): HResult;
    function SOStatusUpdate(Data: Integer): HResult;
    function SOProcessID(out pProcessID: Integer): HResult;
    function CheckHealth(Level: Integer; out pRC: Integer): HResult;
    function ClaimDevice(Timeout: Integer; out pRC: Integer): HResult;
    function ClearOutput(out pRC: Integer): HResult;
    function Close(out pRC: Integer): HResult;
    function DirectIO(Command: Integer; var pData: Integer; var pString: WideString; 
                      out pRC: Integer): HResult;
    function Open(const DeviceName: WideString; out pRC: Integer): HResult;
    function ReleaseDevice(out pRC: Integer): HResult;
    function BeginFiscalDocument(DocumentAmount: Integer; out pRC: Integer): HResult;
    function BeginFiscalReceipt(PrintHeader: WordBool; out pRC: Integer): HResult;
    function BeginFixedOutput(Station: Integer; DocumentType: Integer; out pRC: Integer): HResult;
    function BeginInsertion(Timeout: Integer; out pRC: Integer): HResult;
    function BeginItemList(VatID: Integer; out pRC: Integer): HResult;
    function BeginNonFiscal(out pRC: Integer): HResult;
    function BeginRemoval(Timeout: Integer; out pRC: Integer): HResult;
    function BeginTraining(out pRC: Integer): HResult;
    function ClearError(out pRC: Integer): HResult;
    function EndFiscalDocument(out pRC: Integer): HResult;
    function EndFiscalReceipt(PrintHeader: WordBool; out pRC: Integer): HResult;
    function EndFixedOutput(out pRC: Integer): HResult;
    function EndInsertion(out pRC: Integer): HResult;
    function EndItemList(out pRC: Integer): HResult;
    function EndNonFiscal(out pRC: Integer): HResult;
    function EndRemoval(out pRC: Integer): HResult;
    function EndTraining(out pRC: Integer): HResult;
    function GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString; out pRC: Integer): HResult;
    function GetDate(out Date: WideString; out pRC: Integer): HResult;
    function GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString; out pRC: Integer): HResult;
    function GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer; out pRC: Integer): HResult;
    function PrintDuplicateReceipt(out pRC: Integer): HResult;
    function PrintFiscalDocumentLine(const DocumentLine: WideString; out pRC: Integer): HResult;
    function PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; const Data: WideString; 
                              out pRC: Integer): HResult;
    function PrintNormal(Station: Integer; const Data: WideString; out pRC: Integer): HResult;
    function PrintPeriodicTotalsReport(const Date1: WideString; const Date2: WideString; 
                                       out pRC: Integer): HResult;
    function PrintPowerLossReport(out pRC: Integer): HResult;
    function PrintRecItem(const Description: WideString; Price: Currency; Quantity: Integer; 
                          VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                          out pRC: Integer): HResult;
    function PrintRecItemAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                    Amount: Currency; VatInfo: Integer; out pRC: Integer): HResult;
    function PrintRecMessage(const Message: WideString; out pRC: Integer): HResult;
    function PrintRecNotPaid(const Description: WideString; Amount: Currency; out pRC: Integer): HResult;
    function PrintRecRefund(const Description: WideString; Amount: Currency; VatInfo: Integer; 
                            out pRC: Integer): HResult;
    function PrintRecSubtotal(Amount: Currency; out pRC: Integer): HResult;
    function PrintRecSubtotalAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; out pRC: Integer): HResult;
    function PrintRecTotal(Total: Currency; Payment: Currency; const Description: WideString; 
                           out pRC: Integer): HResult;
    function PrintRecVoid(const Description: WideString; out pRC: Integer): HResult;
    function PrintRecVoidItem(const Description: WideString; Amount: Currency; Quantity: Integer; 
                              AdjustmentType: Integer; Adjustment: Currency; VatInfo: Integer; 
                              out pRC: Integer): HResult;
    function PrintReport(ReportType: Integer; const StartNum: WideString; const EndNum: WideString; 
                         out pRC: Integer): HResult;
    function PrintXReport(out pRC: Integer): HResult;
    function PrintZReport(out pRC: Integer): HResult;
    function ResetPrinter(out pRC: Integer): HResult;
    function SetDate(const Date: WideString; out pRC: Integer): HResult;
    function SetHeaderLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool; 
                           out pRC: Integer): HResult;
    function SetPOSID(const POSID: WideString; const CashierID: WideString; out pRC: Integer): HResult;
    function SetStoreFiscalID(const ID: WideString; out pRC: Integer): HResult;
    function SetTrailerLine(LineNumber: Integer; const Text: WideString; DoubleWidth: WordBool; 
                            out pRC: Integer): HResult;
    function SetVatTable(out pRC: Integer): HResult;
    function SetVatValue(VatID: Integer; const VatValue: WideString; out pRC: Integer): HResult;
    function VerifyItem(const ItemName: WideString; VatID: Integer; out pRC: Integer): HResult;
    function PrintRecCash(Amount: Currency; out pRC: Integer): HResult;
    function PrintRecItemFuel(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              SpecialTax: Currency; const SpecialTaxName: WideString; 
                              out pRC: Integer): HResult;
    function PrintRecItemFuelVoid(const Description: WideString; Price: Currency; VatInfo: Integer; 
                                  SpecialTax: Currency; out pRC: Integer): HResult;
    function PrintRecPackageAdjustment(AdjustmentType: Integer; const Description: WideString; 
                                       const VatAdjustment: WideString; out pRC: Integer): HResult;
    function PrintRecPackageAdjustVoid(AdjustmentType: Integer; const VatAdjustment: WideString; 
                                       out pRC: Integer): HResult;
    function PrintRecRefundVoid(const Description: WideString; Amount: Currency; VatInfo: Integer; 
                                out pRC: Integer): HResult;
    function PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency; out pRC: Integer): HResult;
    function PrintRecTaxID(const TaxID: WideString; out pRC: Integer): HResult;
    function SetCurrency(NewCurrency: Integer; out pRC: Integer): HResult;
    function ResetStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
    function RetrieveStatistics(var pStatisticsBuffer: WideString; out pRC: Integer): HResult;
    function UpdateStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
    function CompareFirmwareVersion(const FirmwareFileName: WideString; out pResult: Integer; 
                                    out pRC: Integer): HResult;
    function UpdateFirmware(const FirmwareFileName: WideString; out pRC: Integer): HResult;
    function PrintRecItemAdjustmentVoid(AdjustmentType: Integer; const Description: WideString; 
                                        Amount: Currency; VatInfo: Integer; out pRC: Integer): HResult;
    function PrintRecItemVoid(const Description: WideString; Price: Currency; Quantity: Integer; 
                              VatInfo: Integer; UnitPrice: Currency; const UnitName: WideString; 
                              out pRC: Integer): HResult;
    function PrintRecItemRefund(const Description: WideString; Amount: Currency; Quantity: Integer; 
                                VatInfo: Integer; UnitAmount: Currency; const UnitName: WideString): Integer;
    function PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; 
                                    Quantity: Integer; VatInfo: Integer; UnitAmount: Currency; 
                                    const UnitName: WideString): Integer;
    property  ControlInterface: IOPOSFiscalPrinter read GetControlInterface;
    property  DefaultInterface: IOPOSFiscalPrinter read GetControlInterface;
  published
    property Anchors;
    property OnDirectIOEvent: TOPOSFiscalPrinterDirectIOEvent read FOnDirectIOEvent write FOnDirectIOEvent;
    property OnErrorEvent: TOPOSFiscalPrinterErrorEvent read FOnErrorEvent write FOnErrorEvent;
    property OnOutputCompleteEvent: TOPOSFiscalPrinterOutputCompleteEvent read FOnOutputCompleteEvent write FOnOutputCompleteEvent;
    property OnStatusUpdateEvent: TOPOSFiscalPrinterStatusUpdateEvent read FOnStatusUpdateEvent write FOnStatusUpdateEvent;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'Servers';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

procedure TOPOSFiscalPrinter.InitControlData;
const
  CEventDispIDs: array [0..3] of DWORD = (
    $00000002, $00000003, $00000004, $00000005);
  CControlData: TControlData2 = (
    ClassID: '{CCB90072-B81E-11D2-AB74-0040054C3719}';
    EventIID: '{CCB90073-B81E-11D2-AB74-0040054C3719}';
    EventCount: 4;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$80004002*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnDirectIOEvent) - Cardinal(Self);
end;

procedure TOPOSFiscalPrinter.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IOPOSFiscalPrinter;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TOPOSFiscalPrinter.GetControlInterface: IOPOSFiscalPrinter;
begin
  CreateControl;
  Result := FIntf;
end;

function TOPOSFiscalPrinter.Get_OpenResult(out pOpenResult: Integer): HResult;
begin
    Result := DefaultInterface.Get_OpenResult(pOpenResult);
end;

function TOPOSFiscalPrinter.Get_BinaryConversion(out pBinaryConversion: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.BinaryConversion;
end;

function TOPOSFiscalPrinter.Get_CapPowerReporting(out pCapPowerReporting: Integer): HResult;
begin
    Result := DefaultInterface.Get_CapPowerReporting(pCapPowerReporting);
end;

function TOPOSFiscalPrinter.Get_CheckHealthText(out pCheckHealthText: WideString): HResult;
begin
    Result := DefaultInterface.Get_CheckHealthText(pCheckHealthText);
end;

function TOPOSFiscalPrinter.Get_Claimed(out pClaimed: WordBool): HResult;
begin
    Result := DefaultInterface.Get_Claimed(pClaimed);
end;

function TOPOSFiscalPrinter.Get_DeviceEnabled(out pDeviceEnabled: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.DeviceEnabled;
end;

function TOPOSFiscalPrinter.Get_FreezeEvents(out pFreezeEvents: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FreezeEvents;
end;

function TOPOSFiscalPrinter.Get_OutputID(out pOutputID: Integer): HResult;
begin
    Result := DefaultInterface.Get_OutputID(pOutputID);
end;

function TOPOSFiscalPrinter.Get_PowerNotify(out pPowerNotify: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PowerNotify;
end;

function TOPOSFiscalPrinter.Get_PowerState(out pPowerState: Integer): HResult;
begin
    Result := DefaultInterface.Get_PowerState(pPowerState);
end;

function TOPOSFiscalPrinter.Get_ResultCode(out pResultCode: Integer): HResult;
begin
    Result := DefaultInterface.Get_ResultCode(pResultCode);
end;

function TOPOSFiscalPrinter.Get_ResultCodeExtended(out pResultCodeExtended: Integer): HResult;
begin
    Result := DefaultInterface.Get_ResultCodeExtended(pResultCodeExtended);
end;

function TOPOSFiscalPrinter.Get_State(out pState: Integer): HResult;
begin
    Result := DefaultInterface.Get_State(pState);
end;

function TOPOSFiscalPrinter.Get_ControlObjectDescription(out pControlObjectDescription: WideString): HResult;
begin
    Result := DefaultInterface.Get_ControlObjectDescription(pControlObjectDescription);
end;

function TOPOSFiscalPrinter.Get_ControlObjectVersion(out pControlObjectVersion: Integer): HResult;
begin
    Result := DefaultInterface.Get_ControlObjectVersion(pControlObjectVersion);
end;

function TOPOSFiscalPrinter.Get_ServiceObjectDescription(out pServiceObjectDescription: WideString): HResult;
begin
    Result := DefaultInterface.Get_ServiceObjectDescription(pServiceObjectDescription);
end;

function TOPOSFiscalPrinter.Get_ServiceObjectVersion(out pServiceObjectVersion: Integer): HResult;
begin
    Result := DefaultInterface.Get_ServiceObjectVersion(pServiceObjectVersion);
end;

function TOPOSFiscalPrinter.Get_DeviceDescription(out pDeviceDescription: WideString): HResult;
begin
    Result := DefaultInterface.Get_DeviceDescription(pDeviceDescription);
end;

function TOPOSFiscalPrinter.Get_DeviceName(out pDeviceName: WideString): HResult;
begin
    Result := DefaultInterface.Get_DeviceName(pDeviceName);
end;

function TOPOSFiscalPrinter.Get_AmountDecimalPlaces(out pAmountDecimalPlaces: Integer): HResult;
begin
    Result := DefaultInterface.Get_AmountDecimalPlaces(pAmountDecimalPlaces);
end;

function TOPOSFiscalPrinter.Get_AsyncMode(out pAsyncMode: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.AsyncMode;
end;

function TOPOSFiscalPrinter.Get_CapAdditionalLines(out pCapAdditionalLines: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapAdditionalLines(pCapAdditionalLines);
end;

function TOPOSFiscalPrinter.Get_CapAmountAdjustment(out pCapAmountAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapAmountAdjustment(pCapAmountAdjustment);
end;

function TOPOSFiscalPrinter.Get_CapAmountNotPaid(out pCapAmountNotPaid: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapAmountNotPaid(pCapAmountNotPaid);
end;

function TOPOSFiscalPrinter.Get_CapCheckTotal(out pCapCheckTotal: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapCheckTotal(pCapCheckTotal);
end;

function TOPOSFiscalPrinter.Get_CapCoverSensor(out pCapCoverSensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapCoverSensor(pCapCoverSensor);
end;

function TOPOSFiscalPrinter.Get_CapDoubleWidth(out pCapDoubleWidth: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapDoubleWidth(pCapDoubleWidth);
end;

function TOPOSFiscalPrinter.Get_CapDuplicateReceipt(out pCapDuplicateReceipt: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapDuplicateReceipt(pCapDuplicateReceipt);
end;

function TOPOSFiscalPrinter.Get_CapFixedOutput(out pCapFixedOutput: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapFixedOutput(pCapFixedOutput);
end;

function TOPOSFiscalPrinter.Get_CapHasVatTable(out pCapHasVatTable: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapHasVatTable(pCapHasVatTable);
end;

function TOPOSFiscalPrinter.Get_CapIndependentHeader(out pCapIndependentHeader: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapIndependentHeader(pCapIndependentHeader);
end;

function TOPOSFiscalPrinter.Get_CapItemList(out pCapItemList: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapItemList(pCapItemList);
end;

function TOPOSFiscalPrinter.Get_CapJrnEmptySensor(out pCapJrnEmptySensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapJrnEmptySensor(pCapJrnEmptySensor);
end;

function TOPOSFiscalPrinter.Get_CapJrnNearEndSensor(out pCapJrnNearEndSensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapJrnNearEndSensor(pCapJrnNearEndSensor);
end;

function TOPOSFiscalPrinter.Get_CapJrnPresent(out pCapJrnPresent: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapJrnPresent(pCapJrnPresent);
end;

function TOPOSFiscalPrinter.Get_CapNonFiscalMode(out pCapNonFiscalMode: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapNonFiscalMode(pCapNonFiscalMode);
end;

function TOPOSFiscalPrinter.Get_CapOrderAdjustmentFirst(out pCapOrderAdjustmentFirst: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapOrderAdjustmentFirst(pCapOrderAdjustmentFirst);
end;

function TOPOSFiscalPrinter.Get_CapPercentAdjustment(out pCapPercentAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPercentAdjustment(pCapPercentAdjustment);
end;

function TOPOSFiscalPrinter.Get_CapPositiveAdjustment(out pCapPositiveAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPositiveAdjustment(pCapPositiveAdjustment);
end;

function TOPOSFiscalPrinter.Get_CapPowerLossReport(out pCapPowerLossReport: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPowerLossReport(pCapPowerLossReport);
end;

function TOPOSFiscalPrinter.Get_CapPredefinedPaymentLines(out pCapPredefinedPaymentLines: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPredefinedPaymentLines(pCapPredefinedPaymentLines);
end;

function TOPOSFiscalPrinter.Get_CapReceiptNotPaid(out pCapReceiptNotPaid: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapReceiptNotPaid(pCapReceiptNotPaid);
end;

function TOPOSFiscalPrinter.Get_CapRecEmptySensor(out pCapRecEmptySensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapRecEmptySensor(pCapRecEmptySensor);
end;

function TOPOSFiscalPrinter.Get_CapRecNearEndSensor(out pCapRecNearEndSensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapRecNearEndSensor(pCapRecNearEndSensor);
end;

function TOPOSFiscalPrinter.Get_CapRecPresent(out pCapRecPresent: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapRecPresent(pCapRecPresent);
end;

function TOPOSFiscalPrinter.Get_CapRemainingFiscalMemory(out pCapRemainingFiscalMemory: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapRemainingFiscalMemory(pCapRemainingFiscalMemory);
end;

function TOPOSFiscalPrinter.Get_CapReservedWord(out pCapReservedWord: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapReservedWord(pCapReservedWord);
end;

function TOPOSFiscalPrinter.Get_CapSetHeader(out pCapSetHeader: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSetHeader(pCapSetHeader);
end;

function TOPOSFiscalPrinter.Get_CapSetPOSID(out pCapSetPOSID: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSetPOSID(pCapSetPOSID);
end;

function TOPOSFiscalPrinter.Get_CapSetStoreFiscalID(out pCapSetStoreFiscalID: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSetStoreFiscalID(pCapSetStoreFiscalID);
end;

function TOPOSFiscalPrinter.Get_CapSetTrailer(out pCapSetTrailer: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSetTrailer(pCapSetTrailer);
end;

function TOPOSFiscalPrinter.Get_CapSetVatTable(out pCapSetVatTable: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSetVatTable(pCapSetVatTable);
end;

function TOPOSFiscalPrinter.Get_CapSlpEmptySensor(out pCapSlpEmptySensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSlpEmptySensor(pCapSlpEmptySensor);
end;

function TOPOSFiscalPrinter.Get_CapSlpFiscalDocument(out pCapSlpFiscalDocument: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSlpFiscalDocument(pCapSlpFiscalDocument);
end;

function TOPOSFiscalPrinter.Get_CapSlpFullSlip(out pCapSlpFullSlip: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSlpFullSlip(pCapSlpFullSlip);
end;

function TOPOSFiscalPrinter.Get_CapSlpNearEndSensor(out pCapSlpNearEndSensor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSlpNearEndSensor(pCapSlpNearEndSensor);
end;

function TOPOSFiscalPrinter.Get_CapSlpPresent(out pCapSlpPresent: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSlpPresent(pCapSlpPresent);
end;

function TOPOSFiscalPrinter.Get_CapSlpValidation(out pCapSlpValidation: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSlpValidation(pCapSlpValidation);
end;

function TOPOSFiscalPrinter.Get_CapSubAmountAdjustment(out pCapSubAmountAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSubAmountAdjustment(pCapSubAmountAdjustment);
end;

function TOPOSFiscalPrinter.Get_CapSubPercentAdjustment(out pCapSubPercentAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSubPercentAdjustment(pCapSubPercentAdjustment);
end;

function TOPOSFiscalPrinter.Get_CapSubtotal(out pCapSubtotal: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSubtotal(pCapSubtotal);
end;

function TOPOSFiscalPrinter.Get_CapTrainingMode(out pCapTrainingMode: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapTrainingMode(pCapTrainingMode);
end;

function TOPOSFiscalPrinter.Get_CapValidateJournal(out pCapValidateJournal: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapValidateJournal(pCapValidateJournal);
end;

function TOPOSFiscalPrinter.Get_CapXReport(out pCapXReport: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapXReport(pCapXReport);
end;

function TOPOSFiscalPrinter.Get_CheckTotal(out pCheckTotal: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.CheckTotal;
end;

function TOPOSFiscalPrinter.Get_CountryCode(out pCountryCode: Integer): HResult;
begin
    Result := DefaultInterface.Get_CountryCode(pCountryCode);
end;

function TOPOSFiscalPrinter.Get_CoverOpen(out pCoverOpen: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CoverOpen(pCoverOpen);
end;

function TOPOSFiscalPrinter.Get_DayOpened(out pDayOpened: WordBool): HResult;
begin
    Result := DefaultInterface.Get_DayOpened(pDayOpened);
end;

function TOPOSFiscalPrinter.Get_DescriptionLength(out pDescriptionLength: Integer): HResult;
begin
    Result := DefaultInterface.Get_DescriptionLength(pDescriptionLength);
end;

function TOPOSFiscalPrinter.Get_DuplicateReceipt(out pDuplicateReceipt: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.DuplicateReceipt;
end;

function TOPOSFiscalPrinter.Get_ErrorLevel(out pErrorLevel: Integer): HResult;
begin
    Result := DefaultInterface.Get_ErrorLevel(pErrorLevel);
end;

function TOPOSFiscalPrinter.Get_ErrorOutID(out pErrorOutID: Integer): HResult;
begin
    Result := DefaultInterface.Get_ErrorOutID(pErrorOutID);
end;

function TOPOSFiscalPrinter.Get_ErrorState(out pErrorState: Integer): HResult;
begin
    Result := DefaultInterface.Get_ErrorState(pErrorState);
end;

function TOPOSFiscalPrinter.Get_ErrorStation(out pErrorStation: Integer): HResult;
begin
    Result := DefaultInterface.Get_ErrorStation(pErrorStation);
end;

function TOPOSFiscalPrinter.Get_ErrorString(out pErrorString: WideString): HResult;
begin
    Result := DefaultInterface.Get_ErrorString(pErrorString);
end;

function TOPOSFiscalPrinter.Get_FlagWhenIdle(out pFlagWhenIdle: WordBool): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FlagWhenIdle;
end;

function TOPOSFiscalPrinter.Get_JrnEmpty(out pJrnEmpty: WordBool): HResult;
begin
    Result := DefaultInterface.Get_JrnEmpty(pJrnEmpty);
end;

function TOPOSFiscalPrinter.Get_JrnNearEnd(out pJrnNearEnd: WordBool): HResult;
begin
    Result := DefaultInterface.Get_JrnNearEnd(pJrnNearEnd);
end;

function TOPOSFiscalPrinter.Get_MessageLength(out pMessageLength: Integer): HResult;
begin
    Result := DefaultInterface.Get_MessageLength(pMessageLength);
end;

function TOPOSFiscalPrinter.Get_NumHeaderLines(out pNumHeaderLines: Integer): HResult;
begin
    Result := DefaultInterface.Get_NumHeaderLines(pNumHeaderLines);
end;

function TOPOSFiscalPrinter.Get_NumTrailerLines(out pNumTrailerLines: Integer): HResult;
begin
    Result := DefaultInterface.Get_NumTrailerLines(pNumTrailerLines);
end;

function TOPOSFiscalPrinter.Get_NumVatRates(out pNumVatRates: Integer): HResult;
begin
    Result := DefaultInterface.Get_NumVatRates(pNumVatRates);
end;

function TOPOSFiscalPrinter.Get_PredefinedPaymentLines(out pPredefinedPaymentLines: WideString): HResult;
begin
    Result := DefaultInterface.Get_PredefinedPaymentLines(pPredefinedPaymentLines);
end;

function TOPOSFiscalPrinter.Get_PrinterState(out pPrinterState: Integer): HResult;
begin
    Result := DefaultInterface.Get_PrinterState(pPrinterState);
end;

function TOPOSFiscalPrinter.Get_QuantityDecimalPlaces(out pQuantityDecimalPlaces: Integer): HResult;
begin
    Result := DefaultInterface.Get_QuantityDecimalPlaces(pQuantityDecimalPlaces);
end;

function TOPOSFiscalPrinter.Get_QuantityLength(out pQuantityLength: Integer): HResult;
begin
    Result := DefaultInterface.Get_QuantityLength(pQuantityLength);
end;

function TOPOSFiscalPrinter.Get_RecEmpty(out pRecEmpty: WordBool): HResult;
begin
    Result := DefaultInterface.Get_RecEmpty(pRecEmpty);
end;

function TOPOSFiscalPrinter.Get_RecNearEnd(out pRecNearEnd: WordBool): HResult;
begin
    Result := DefaultInterface.Get_RecNearEnd(pRecNearEnd);
end;

function TOPOSFiscalPrinter.Get_RemainingFiscalMemory(out pRemainingFiscalMemory: Integer): HResult;
begin
    Result := DefaultInterface.Get_RemainingFiscalMemory(pRemainingFiscalMemory);
end;

function TOPOSFiscalPrinter.Get_ReservedWord(out pReservedWord: WideString): HResult;
begin
    Result := DefaultInterface.Get_ReservedWord(pReservedWord);
end;

function TOPOSFiscalPrinter.Get_SlipSelection(out pSlipSelection: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.SlipSelection;
end;

function TOPOSFiscalPrinter.Get_SlpEmpty(out pSlpEmpty: WordBool): HResult;
begin
    Result := DefaultInterface.Get_SlpEmpty(pSlpEmpty);
end;

function TOPOSFiscalPrinter.Get_SlpNearEnd(out pSlpNearEnd: WordBool): HResult;
begin
    Result := DefaultInterface.Get_SlpNearEnd(pSlpNearEnd);
end;

function TOPOSFiscalPrinter.Get_TrainingModeActive(out pTrainingModeActive: WordBool): HResult;
begin
    Result := DefaultInterface.Get_TrainingModeActive(pTrainingModeActive);
end;

function TOPOSFiscalPrinter.Get_ActualCurrency(out pActualCurrency: Integer): HResult;
begin
    Result := DefaultInterface.Get_ActualCurrency(pActualCurrency);
end;

function TOPOSFiscalPrinter.Get_AdditionalHeader(out pAdditionalHeader: WideString): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.AdditionalHeader;
end;

function TOPOSFiscalPrinter.Get_AdditionalTrailer(out pAdditionalTrailer: WideString): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.AdditionalTrailer;
end;

function TOPOSFiscalPrinter.Get_CapAdditionalHeader(out pCapAdditionalHeader: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapAdditionalHeader(pCapAdditionalHeader);
end;

function TOPOSFiscalPrinter.Get_CapAdditionalTrailer(out pCapAdditionalTrailer: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapAdditionalTrailer(pCapAdditionalTrailer);
end;

function TOPOSFiscalPrinter.Get_CapChangeDue(out pCapChangeDue: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapChangeDue(pCapChangeDue);
end;

function TOPOSFiscalPrinter.Get_CapEmptyReceiptIsVoidable(out pCapEmptyReceiptIsVoidable: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapEmptyReceiptIsVoidable(pCapEmptyReceiptIsVoidable);
end;

function TOPOSFiscalPrinter.Get_CapFiscalReceiptStation(out pCapFiscalReceiptStation: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapFiscalReceiptStation(pCapFiscalReceiptStation);
end;

function TOPOSFiscalPrinter.Get_CapFiscalReceiptType(out pCapFiscalReceiptType: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapFiscalReceiptType(pCapFiscalReceiptType);
end;

function TOPOSFiscalPrinter.Get_CapMultiContractor(out pCapMultiContractor: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapMultiContractor(pCapMultiContractor);
end;

function TOPOSFiscalPrinter.Get_CapOnlyVoidLastItem(out pCapOnlyVoidLastItem: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapOnlyVoidLastItem(pCapOnlyVoidLastItem);
end;

function TOPOSFiscalPrinter.Get_CapPackageAdjustment(out pCapPackageAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPackageAdjustment(pCapPackageAdjustment);
end;

function TOPOSFiscalPrinter.Get_CapPostPreLine(out pCapPostPreLine: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPostPreLine(pCapPostPreLine);
end;

function TOPOSFiscalPrinter.Get_CapSetCurrency(out pCapSetCurrency: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapSetCurrency(pCapSetCurrency);
end;

function TOPOSFiscalPrinter.Get_CapTotalizerType(out pCapTotalizerType: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapTotalizerType(pCapTotalizerType);
end;

function TOPOSFiscalPrinter.Get_ChangeDue(out pChangeDue: WideString): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.ChangeDue;
end;

function TOPOSFiscalPrinter.Get_ContractorId(out pContractorId: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.ContractorId;
end;

function TOPOSFiscalPrinter.Get_DateType(out pDateType: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.DateType;
end;

function TOPOSFiscalPrinter.Get_FiscalReceiptStation(out pFiscalReceiptStation: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FiscalReceiptStation;
end;

function TOPOSFiscalPrinter.Get_FiscalReceiptType(out pFiscalReceiptType: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.FiscalReceiptType;
end;

function TOPOSFiscalPrinter.Get_MessageType(out pMessageType: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.MessageType;
end;

function TOPOSFiscalPrinter.Get_PostLine(out pPostLine: WideString): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PostLine;
end;

function TOPOSFiscalPrinter.Get_PreLine(out pPreLine: WideString): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.PreLine;
end;

function TOPOSFiscalPrinter.Get_TotalizerType(out pTotalizerType: Integer): HResult;
var
  InterfaceVariant : OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  Result := InterfaceVariant.TotalizerType;
end;

function TOPOSFiscalPrinter.Get_CapStatisticsReporting(out pCapStatisticsReporting: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapStatisticsReporting(pCapStatisticsReporting);
end;

function TOPOSFiscalPrinter.Get_CapUpdateStatistics(out pCapUpdateStatistics: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapUpdateStatistics(pCapUpdateStatistics);
end;

function TOPOSFiscalPrinter.Get_CapCompareFirmwareVersion(out pCapCompareFirmwareVersion: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapCompareFirmwareVersion(pCapCompareFirmwareVersion);
end;

function TOPOSFiscalPrinter.Get_CapUpdateFirmware(out pCapUpdateFirmware: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapUpdateFirmware(pCapUpdateFirmware);
end;

function TOPOSFiscalPrinter.Get_CapPositiveSubtotalAdjustment(out pCapPositiveSubtotalAdjustment: WordBool): HResult;
begin
    Result := DefaultInterface.Get_CapPositiveSubtotalAdjustment(pCapPositiveSubtotalAdjustment);
end;

function TOPOSFiscalPrinter.SODataDummy(Status: Integer): HResult;
begin
  Result := DefaultInterface.SODataDummy(Status);
end;

function TOPOSFiscalPrinter.SODirectIO(EventNumber: Integer; var pData: Integer; 
                                       var pString: WideString): HResult;
begin
  Result := DefaultInterface.SODirectIO(EventNumber, pData, pString);
end;

function TOPOSFiscalPrinter.SOError(ResultCode: Integer; ResultCodeExtended: Integer; 
                                    ErrorLocus: Integer; var pErrorResponse: Integer): HResult;
begin
  Result := DefaultInterface.SOError(ResultCode, ResultCodeExtended, ErrorLocus, pErrorResponse);
end;

function TOPOSFiscalPrinter.SOOutputComplete(OutputID: Integer): HResult;
begin
  Result := DefaultInterface.SOOutputComplete(OutputID);
end;

function TOPOSFiscalPrinter.SOStatusUpdate(Data: Integer): HResult;
begin
  Result := DefaultInterface.SOStatusUpdate(Data);
end;

function TOPOSFiscalPrinter.SOProcessID(out pProcessID: Integer): HResult;
begin
  Result := DefaultInterface.SOProcessID(pProcessID);
end;

function TOPOSFiscalPrinter.CheckHealth(Level: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.CheckHealth(Level, pRC);
end;

function TOPOSFiscalPrinter.ClaimDevice(Timeout: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ClaimDevice(Timeout, pRC);
end;

function TOPOSFiscalPrinter.ClearOutput(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ClearOutput(pRC);
end;

function TOPOSFiscalPrinter.Close(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.Close(pRC);
end;

function TOPOSFiscalPrinter.DirectIO(Command: Integer; var pData: Integer; var pString: WideString; 
                                     out pRC: Integer): HResult;
begin
  Result := DefaultInterface.DirectIO(Command, pData, pString, pRC);
end;

function TOPOSFiscalPrinter.Open(const DeviceName: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.Open(DeviceName, pRC);
end;

function TOPOSFiscalPrinter.ReleaseDevice(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ReleaseDevice(pRC);
end;

function TOPOSFiscalPrinter.BeginFiscalDocument(DocumentAmount: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginFiscalDocument(DocumentAmount, pRC);
end;

function TOPOSFiscalPrinter.BeginFiscalReceipt(PrintHeader: WordBool; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginFiscalReceipt(PrintHeader, pRC);
end;

function TOPOSFiscalPrinter.BeginFixedOutput(Station: Integer; DocumentType: Integer; 
                                             out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginFixedOutput(Station, DocumentType, pRC);
end;

function TOPOSFiscalPrinter.BeginInsertion(Timeout: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginInsertion(Timeout, pRC);
end;

function TOPOSFiscalPrinter.BeginItemList(VatID: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginItemList(VatID, pRC);
end;

function TOPOSFiscalPrinter.BeginNonFiscal(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginNonFiscal(pRC);
end;

function TOPOSFiscalPrinter.BeginRemoval(Timeout: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginRemoval(Timeout, pRC);
end;

function TOPOSFiscalPrinter.BeginTraining(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.BeginTraining(pRC);
end;

function TOPOSFiscalPrinter.ClearError(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ClearError(pRC);
end;

function TOPOSFiscalPrinter.EndFiscalDocument(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndFiscalDocument(pRC);
end;

function TOPOSFiscalPrinter.EndFiscalReceipt(PrintHeader: WordBool; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndFiscalReceipt(PrintHeader, pRC);
end;

function TOPOSFiscalPrinter.EndFixedOutput(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndFixedOutput(pRC);
end;

function TOPOSFiscalPrinter.EndInsertion(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndInsertion(pRC);
end;

function TOPOSFiscalPrinter.EndItemList(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndItemList(pRC);
end;

function TOPOSFiscalPrinter.EndNonFiscal(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndNonFiscal(pRC);
end;

function TOPOSFiscalPrinter.EndRemoval(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndRemoval(pRC);
end;

function TOPOSFiscalPrinter.EndTraining(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.EndTraining(pRC);
end;

function TOPOSFiscalPrinter.GetData(DataItem: Integer; out OptArgs: Integer; out Data: WideString; 
                                    out pRC: Integer): HResult;
begin
  Result := DefaultInterface.GetData(DataItem, OptArgs, Data, pRC);
end;

function TOPOSFiscalPrinter.GetDate(out Date: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.GetDate(Date, pRC);
end;

function TOPOSFiscalPrinter.GetTotalizer(VatID: Integer; OptArgs: Integer; out Data: WideString; 
                                         out pRC: Integer): HResult;
begin
  Result := DefaultInterface.GetTotalizer(VatID, OptArgs, Data, pRC);
end;

function TOPOSFiscalPrinter.GetVatEntry(VatID: Integer; OptArgs: Integer; out VatRate: Integer; 
                                        out pRC: Integer): HResult;
begin
  Result := DefaultInterface.GetVatEntry(VatID, OptArgs, VatRate, pRC);
end;

function TOPOSFiscalPrinter.PrintDuplicateReceipt(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintDuplicateReceipt(pRC);
end;

function TOPOSFiscalPrinter.PrintFiscalDocumentLine(const DocumentLine: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintFiscalDocumentLine(DocumentLine, pRC);
end;

function TOPOSFiscalPrinter.PrintFixedOutput(DocumentType: Integer; LineNumber: Integer; 
                                             const Data: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintFixedOutput(DocumentType, LineNumber, Data, pRC);
end;

function TOPOSFiscalPrinter.PrintNormal(Station: Integer; const Data: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintNormal(Station, Data, pRC);
end;

function TOPOSFiscalPrinter.PrintPeriodicTotalsReport(const Date1: WideString; 
                                                      const Date2: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintPeriodicTotalsReport(Date1, Date2, pRC);
end;

function TOPOSFiscalPrinter.PrintPowerLossReport(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintPowerLossReport(pRC);
end;

function TOPOSFiscalPrinter.PrintRecItem(const Description: WideString; Price: Currency; 
                                         Quantity: Integer; VatInfo: Integer; UnitPrice: Currency; 
                                         const UnitName: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecItem(Description, Price, Quantity, VatInfo, UnitPrice, 
                                          UnitName, pRC);
end;

function TOPOSFiscalPrinter.PrintRecItemAdjustment(AdjustmentType: Integer; 
                                                   const Description: WideString; Amount: Currency; 
                                                   VatInfo: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecItemAdjustment(AdjustmentType, Description, Amount, VatInfo, 
                                                    pRC);
end;

function TOPOSFiscalPrinter.PrintRecMessage(const Message: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecMessage(Message, pRC);
end;

function TOPOSFiscalPrinter.PrintRecNotPaid(const Description: WideString; Amount: Currency; 
                                            out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecNotPaid(Description, Amount, pRC);
end;

function TOPOSFiscalPrinter.PrintRecRefund(const Description: WideString; Amount: Currency; 
                                           VatInfo: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecRefund(Description, Amount, VatInfo, pRC);
end;

function TOPOSFiscalPrinter.PrintRecSubtotal(Amount: Currency; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecSubtotal(Amount, pRC);
end;

function TOPOSFiscalPrinter.PrintRecSubtotalAdjustment(AdjustmentType: Integer; 
                                                       const Description: WideString; 
                                                       Amount: Currency; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecSubtotalAdjustment(AdjustmentType, Description, Amount, pRC);
end;

function TOPOSFiscalPrinter.PrintRecTotal(Total: Currency; Payment: Currency; 
                                          const Description: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecTotal(Total, Payment, Description, pRC);
end;

function TOPOSFiscalPrinter.PrintRecVoid(const Description: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecVoid(Description, pRC);
end;

function TOPOSFiscalPrinter.PrintRecVoidItem(const Description: WideString; Amount: Currency; 
                                             Quantity: Integer; AdjustmentType: Integer; 
                                             Adjustment: Currency; VatInfo: Integer; 
                                             out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecVoidItem(Description, Amount, Quantity, AdjustmentType, 
                                              Adjustment, VatInfo, pRC);
end;

function TOPOSFiscalPrinter.PrintReport(ReportType: Integer; const StartNum: WideString; 
                                        const EndNum: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintReport(ReportType, StartNum, EndNum, pRC);
end;

function TOPOSFiscalPrinter.PrintXReport(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintXReport(pRC);
end;

function TOPOSFiscalPrinter.PrintZReport(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintZReport(pRC);
end;

function TOPOSFiscalPrinter.ResetPrinter(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ResetPrinter(pRC);
end;

function TOPOSFiscalPrinter.SetDate(const Date: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetDate(Date, pRC);
end;

function TOPOSFiscalPrinter.SetHeaderLine(LineNumber: Integer; const Text: WideString; 
                                          DoubleWidth: WordBool; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetHeaderLine(LineNumber, Text, DoubleWidth, pRC);
end;

function TOPOSFiscalPrinter.SetPOSID(const POSID: WideString; const CashierID: WideString; 
                                     out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetPOSID(POSID, CashierID, pRC);
end;

function TOPOSFiscalPrinter.SetStoreFiscalID(const ID: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetStoreFiscalID(ID, pRC);
end;

function TOPOSFiscalPrinter.SetTrailerLine(LineNumber: Integer; const Text: WideString; 
                                           DoubleWidth: WordBool; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetTrailerLine(LineNumber, Text, DoubleWidth, pRC);
end;

function TOPOSFiscalPrinter.SetVatTable(out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetVatTable(pRC);
end;

function TOPOSFiscalPrinter.SetVatValue(VatID: Integer; const VatValue: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetVatValue(VatID, VatValue, pRC);
end;

function TOPOSFiscalPrinter.VerifyItem(const ItemName: WideString; VatID: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.VerifyItem(ItemName, VatID, pRC);
end;

function TOPOSFiscalPrinter.PrintRecCash(Amount: Currency; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecCash(Amount, pRC);
end;

function TOPOSFiscalPrinter.PrintRecItemFuel(const Description: WideString; Price: Currency; 
                                             Quantity: Integer; VatInfo: Integer; 
                                             UnitPrice: Currency; const UnitName: WideString; 
                                             SpecialTax: Currency; 
                                             const SpecialTaxName: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecItemFuel(Description, Price, Quantity, VatInfo, UnitPrice, 
                                              UnitName, SpecialTax, SpecialTaxName, pRC);
end;

function TOPOSFiscalPrinter.PrintRecItemFuelVoid(const Description: WideString; Price: Currency; 
                                                 VatInfo: Integer; SpecialTax: Currency; 
                                                 out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecItemFuelVoid(Description, Price, VatInfo, SpecialTax, pRC);
end;

function TOPOSFiscalPrinter.PrintRecPackageAdjustment(AdjustmentType: Integer; 
                                                      const Description: WideString; 
                                                      const VatAdjustment: WideString; 
                                                      out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecPackageAdjustment(AdjustmentType, Description, VatAdjustment, 
                                                       pRC);
end;

function TOPOSFiscalPrinter.PrintRecPackageAdjustVoid(AdjustmentType: Integer; 
                                                      const VatAdjustment: WideString; 
                                                      out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecPackageAdjustVoid(AdjustmentType, VatAdjustment, pRC);
end;

function TOPOSFiscalPrinter.PrintRecRefundVoid(const Description: WideString; Amount: Currency; 
                                               VatInfo: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecRefundVoid(Description, Amount, VatInfo, pRC);
end;

function TOPOSFiscalPrinter.PrintRecSubtotalAdjustVoid(AdjustmentType: Integer; Amount: Currency; 
                                                       out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecSubtotalAdjustVoid(AdjustmentType, Amount, pRC);
end;

function TOPOSFiscalPrinter.PrintRecTaxID(const TaxID: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecTaxID(TaxID, pRC);
end;

function TOPOSFiscalPrinter.SetCurrency(NewCurrency: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.SetCurrency(NewCurrency, pRC);
end;

function TOPOSFiscalPrinter.ResetStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.ResetStatistics(StatisticsBuffer, pRC);
end;

function TOPOSFiscalPrinter.RetrieveStatistics(var pStatisticsBuffer: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.RetrieveStatistics(pStatisticsBuffer, pRC);
end;

function TOPOSFiscalPrinter.UpdateStatistics(const StatisticsBuffer: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.UpdateStatistics(StatisticsBuffer, pRC);
end;

function TOPOSFiscalPrinter.CompareFirmwareVersion(const FirmwareFileName: WideString; 
                                                   out pResult: Integer; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.CompareFirmwareVersion(FirmwareFileName, pResult, pRC);
end;

function TOPOSFiscalPrinter.UpdateFirmware(const FirmwareFileName: WideString; out pRC: Integer): HResult;
begin
  Result := DefaultInterface.UpdateFirmware(FirmwareFileName, pRC);
end;

function TOPOSFiscalPrinter.PrintRecItemAdjustmentVoid(AdjustmentType: Integer; 
                                                       const Description: WideString; 
                                                       Amount: Currency; VatInfo: Integer; 
                                                       out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecItemAdjustmentVoid(AdjustmentType, Description, Amount, 
                                                        VatInfo, pRC);
end;

function TOPOSFiscalPrinter.PrintRecItemVoid(const Description: WideString; Price: Currency; 
                                             Quantity: Integer; VatInfo: Integer; 
                                             UnitPrice: Currency; const UnitName: WideString; 
                                             out pRC: Integer): HResult;
begin
  Result := DefaultInterface.PrintRecItemVoid(Description, Price, Quantity, VatInfo, UnitPrice, 
                                              UnitName, pRC);
end;

function TOPOSFiscalPrinter.PrintRecItemRefund(const Description: WideString; Amount: Currency; 
                                               Quantity: Integer; VatInfo: Integer; 
                                               UnitAmount: Currency; const UnitName: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecItemRefund(Description, Amount, Quantity, VatInfo, UnitAmount, 
                                                UnitName);
end;

function TOPOSFiscalPrinter.PrintRecItemRefundVoid(const Description: WideString; Amount: Currency; 
                                                   Quantity: Integer; VatInfo: Integer; 
                                                   UnitAmount: Currency; const UnitName: WideString): Integer;
begin
  Result := DefaultInterface.PrintRecItemRefundVoid(Description, Amount, Quantity, VatInfo, 
                                                    UnitAmount, UnitName);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TOPOSFiscalPrinter]);
end;

end.
