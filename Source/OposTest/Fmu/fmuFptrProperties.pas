unit fmuFptrProperties;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ActiveX, ComObj,
  // Tnt
  TntSysUtils, TntStdCtrls,
  // This
  untPages, OposFiscalPrinter, OposUtils, OposFptrUtils;

type
  TfmFptrProperties = class(TPage)
    btnRefresh: TTntButton;
    Memo: TTntMemo;
    procedure btnRefreshClick(Sender: TObject);
  private
    function GetPropVal(const PropertyName: WideString): WideString;
    procedure UpdateProps;
    procedure AddProp(const PropName: WideString; PropText: WideString = '');
  public
    procedure UpdateForm;
  end;

implementation

{$R *.DFM}

(*
// Sorted ByName

ActualCurrency
AdditionalHeader
AdditionalTrailer
AmountDecimalPlaces
AsyncMode
BinaryConversion
CapAdditionalHeader
CapAdditionalLines
CapAdditionalTrailer
CapAmountAdjustment
CapAmountNotPaid
CapChangeDue
CapCheckTotal
CapCompareFirmwareVersion
CapCoverSensor
CapDoubleWidth
CapDuplicateReceipt
CapEmptyReceiptIsVoidable
CapFiscalReceiptStation
CapFiscalReceiptType
CapFixedOutput
CapHasVatTable
CapIndependentHeader
CapItemList
CapJrnEmptySensor
CapJrnNearEndSensor
CapJrnPresent
CapMultiContractor
CapNonFiscalMode
CapOnlyVoidLastItem
CapOrderAdjustmentFirst
CapPackageAdjustment
CapPercentAdjustment
CapPositiveAdjustment
CapPositiveSubtotalAdjustment
CapPostPreLine
CapPowerLossReport
CapPowerReporting
CapPredefinedPaymentLines
CapRecEmptySensor
CapRecNearEndSensor
CapRecPresent
CapReceiptNotPaid
CapRemainingFiscalMemory
CapReservedWord
CapSetCurrency
CapSetHeader
CapSetPOSID
CapSetStoreFiscalID
CapSetTrailer
CapSetVatTable
CapSlpEmptySensor
CapSlpFiscalDocument
CapSlpFullSlip
CapSlpNearEndSensor
CapSlpPresent
CapSlpValidation
CapStatisticsReporting
CapSubAmountAdjustment
CapSubPercentAdjustment
CapSubtotal
CapTotalizerType
CapTrainingMode
CapUpdateFirmware
CapUpdateStatistics
CapValidateJournal
CapXReport
ChangeDue
CheckHealthText           
CheckTotal
Claimed
ContractorId
ControlObjectDescription
ControlObjectVersion
CountryCode
CoverOpen
DateType
DayOpened
DescriptionLength
DeviceDescription
DeviceEnabled
DeviceName
DuplicateReceipt
ErrorLevel
ErrorOutID
ErrorState
ErrorStation
ErrorString
FiscalReceiptStation
FiscalReceiptType
FlagWhenIdle
FreezeEvents
JrnEmpty
JrnNearEnd
MessageLength
MessageType
NumHeaderLines
NumTrailerLines
NumVatRates
OpenResult
OutputID
PostLine
PowerNotify
PowerState
PreLine
PredefinedPaymentLines
PrinterState
QuantityDecimalPlaces
QuantityLength
RecEmpty
RecNearEnd
RemainingFiscalMemory
ReservedWord
ResultCode
ResultCodeExtended
ServiceObjectDescription
ServiceObjectVersion
SlipSelection
SlpEmpty
SlpNearEnd
State
TotalizerType
TrainingModeActive

// Sorted by ID
OpenResult
BinaryConversion
CapPowerReporting
CheckHealthText           :
Claimed
DeviceEnabled
FreezeEvents
OutputID
PowerNotify
PowerState
ResultCode
ResultCodeExtended
State
ControlObjectDescription
ControlObjectVersion
ServiceObjectDescription
ServiceObjectVersion
DeviceDescription
DeviceName
AmountDecimalPlaces
AsyncMode
CapAdditionalLines
CapAmountAdjustment
CapAmountNotPaid
CapCheckTotal
CapCoverSensor
CapDoubleWidth
CapDuplicateReceipt
CapFixedOutput
CapHasVatTable
CapIndependentHeader
CapItemList
CapJrnEmptySensor
CapJrnNearEndSensor
CapJrnPresent
CapNonFiscalMode
CapOrderAdjustmentFirst
CapPercentAdjustment
CapPositiveAdjustment
CapPowerLossReport
CapPredefinedPaymentLines
CapReceiptNotPaid
CapRecEmptySensor
CapRecNearEndSensor
CapRecPresent
CapRemainingFiscalMemory
CapReservedWord
CapSetHeader
CapSetPOSID
CapSetStoreFiscalID
CapSetTrailer
CapSetVatTable
CapSlpEmptySensor
CapSlpFiscalDocument
CapSlpFullSlip
CapSlpNearEndSensor
CapSlpPresent
CapSlpValidation
CapSubAmountAdjustment
CapSubPercentAdjustment
CapSubtotal
CapTrainingMode
CapValidateJournal
CapXReport
CheckTotal
CountryCode
CoverOpen
DayOpened
DescriptionLength
DuplicateReceipt
ErrorLevel
ErrorOutID
ErrorState
ErrorStation
ErrorString
FlagWhenIdle
JrnEmpty
JrnNearEnd
MessageLength
NumHeaderLines
NumTrailerLines
NumVatRates
PredefinedPaymentLines
PrinterState
QuantityDecimalPlaces
QuantityLength
RecEmpty
RecNearEnd
RemainingFiscalMemory
ReservedWord
SlipSelection
SlpEmpty
SlpNearEnd
TrainingModeActive
ActualCurrency
AdditionalHeader
AdditionalTrailer
CapAdditionalHeader
CapAdditionalTrailer
CapChangeDue
CapEmptyReceiptIsVoidable
CapFiscalReceiptStation
CapFiscalReceiptType
CapMultiContractor
CapOnlyVoidLastItem
CapPackageAdjustment
CapPostPreLine
CapSetCurrency
CapTotalizerType
ChangeDue
ContractorId
DateType
FiscalReceiptStation
FiscalReceiptType
MessageType
PostLine
PreLine
TotalizerType
CapStatisticsReporting
CapUpdateStatistics
CapCompareFirmwareVersion
CapUpdateFirmware
CapPositiveSubtotalAdjustment

*)

function TfmFptrProperties.GetPropVal(const PropertyName: WideString): WideString;
var
  Value: Variant;
  Intf: IDispatch;
  PName: PWideChar;
  PropID: Integer;
  DispParams: TDispParams;
begin
  Intf := FiscalPrinter.Driver.ControlInterface;
  PName := PWideChar(PropertyName);
  try
    OleCheck(Intf.GetIDsOfNames(GUID_NULL, @PName, 1, GetThreadLocale, @PropID));
    VarClear(Value);
    FillChar(DispParams, SizeOf(DispParams), 0);
    OleCheck(Intf.Invoke(PropID, GUID_NULL, 0, DISPATCH_PROPERTYGET,
      DispParams, @Value, nil, nil));

    Result := Value;
  except
    on E: Exception do Result := E.Message;
  end;
end;

procedure TfmFptrProperties.UpdateForm;
var
  S: WideString;
  i: Integer;
  TypeAttr: PTypeAttr;
  Dispatch: IDispatch;
  TypeInfo: ITypeInfo;
  FuncDesc: PFuncDesc;
  PropName: WideString;
begin
  Memo.Clear;
  Dispatch := FiscalPrinter.Driver.ControlInterface;

  Dispatch.GetTypeInfo(0, 0, TypeInfo);
  if TypeInfo = nil then Exit;
  TypeInfo.GetTypeAttr(TypeAttr);
  try
    for i := 0 to TypeAttr.cFuncs-1 do
    begin
      TypeInfo.GetFuncDesc(i, FuncDesc);
      try
        TypeInfo.GetDocumentation(FuncDesc.memid, @PropName, nil, nil, nil);
        if FuncDesc.invkind = INVOKE_PROPERTYGET then
        begin
          S := GetPropVal(PropName);
          S := Tnt_WideFormat('%.3d %-26s: %s', [i+1, PropName, S]);
          Memo.Lines.Add(S);
        end;
      finally
        TypeInfo.ReleaseFuncDesc(FuncDesc);
      end;
    end;
  finally
    TypeInfo.ReleaseTypeAttr(TypeAttr);
  end;
end;

procedure TfmFptrProperties.AddProp(const PropName: WideString; PropText: WideString);
var
  Line: WideString;
begin
  Line := GetPropVal(PropName);
  Line := Tnt_WideFormat('%-30s: %s', [PropName, Line]);
  if PropText <> '' then
    Line := Line + ', ' + PropText;
  Memo.Lines.Add(Line);
end;

procedure TfmFptrProperties.UpdateProps;
begin
  Memo.Clear;
  AddProp('ActualCurrency', ActualCurrencyToStr(FiscalPrinter.ActualCurrency));
  AddProp('AdditionalHeader');
  AddProp('AdditionalTrailer');
  AddProp('AmountDecimalPlaces');
  AddProp('AsyncMode');
  AddProp('BinaryConversion', BinaryConversionToStr(FiscalPrinter.BinaryConversion));
  AddProp('CapAdditionalHeader');
  AddProp('CapAdditionalLines');
  AddProp('CapAdditionalTrailer');
  AddProp('CapAmountAdjustment');
  AddProp('CapAmountNotPaid');
  AddProp('CapChangeDue');
  AddProp('CapCheckTotal');
  AddProp('CapCompareFirmwareVersion');
  AddProp('CapCoverSensor');
  AddProp('CapDoubleWidth');
  AddProp('CapDuplicateReceipt');
  AddProp('CapEmptyReceiptIsVoidable');
  AddProp('CapFiscalReceiptStation');
  AddProp('CapFiscalReceiptType');
  AddProp('CapFixedOutput');
  AddProp('CapHasVatTable');
  AddProp('CapIndependentHeader');
  AddProp('CapItemList');
  AddProp('CapJrnEmptySensor');
  AddProp('CapJrnNearEndSensor');
  AddProp('CapJrnPresent');
  AddProp('CapMultiContractor');
  AddProp('CapNonFiscalMode');
  AddProp('CapOnlyVoidLastItem');
  AddProp('CapOrderAdjustmentFirst');
  AddProp('CapPackageAdjustment');
  AddProp('CapPercentAdjustment');
  AddProp('CapPositiveAdjustment');
  AddProp('CapPositiveSubtotalAdjustment');
  AddProp('CapPostPreLine');
  AddProp('CapPowerLossReport');
  AddProp('CapPowerReporting', PowerReportingToStr(FiscalPrinter.CapPowerReporting));
  AddProp('CapPredefinedPaymentLines');
  AddProp('CapRecEmptySensor');
  AddProp('CapRecNearEndSensor');
  AddProp('CapRecPresent');
  AddProp('CapReceiptNotPaid');
  AddProp('CapRemainingFiscalMemory');
  AddProp('CapReservedWord');
  AddProp('CapSetCurrency');
  AddProp('CapSetHeader');
  AddProp('CapSetPOSID');
  AddProp('CapSetStoreFiscalID');
  AddProp('CapSetTrailer');
  AddProp('CapSetVatTable');
  AddProp('CapSlpEmptySensor');
  AddProp('CapSlpFiscalDocument');
  AddProp('CapSlpFullSlip');
  AddProp('CapSlpNearEndSensor');
  AddProp('CapSlpPresent');
  AddProp('CapSlpValidation');
  AddProp('CapStatisticsReporting');
  AddProp('CapSubAmountAdjustment');
  AddProp('CapSubPercentAdjustment');
  AddProp('CapSubtotal');
  AddProp('CapTotalizerType');
  AddProp('CapTrainingMode');
  AddProp('CapUpdateFirmware');
  AddProp('CapUpdateStatistics');
  AddProp('CapValidateJournal');
  AddProp('CapXReport');
  AddProp('ChangeDue');
  AddProp('CheckHealthText');
  AddProp('CheckTotal');
  AddProp('Claimed');
  AddProp('ContractorId', ContractorIdToStr(FiscalPrinter.ContractorId));
  AddProp('ControlObjectDescription');
  AddProp('ControlObjectVersion');
  AddProp('CountryCode', CountryCodeToStr(FiscalPrinter.CountryCode));
  AddProp('CoverOpen');
  AddProp('DateType', DateTypeToStr(FiscalPrinter.DateType));
  AddProp('DayOpened');
  AddProp('DescriptionLength');
  AddProp('DeviceDescription');
  AddProp('DeviceEnabled');
  AddProp('DeviceName');
  AddProp('DuplicateReceipt');
  AddProp('ErrorLevel', ErrorLevelToStr(FiscalPrinter.ErrorLevel));
  AddProp('ErrorOutID');
  AddProp('ErrorState', PrinterStateToStr(FiscalPrinter.ErrorState));
  AddProp('ErrorStation', StationToStr(FiscalPrinter.ErrorStation));
  AddProp('ErrorString');
  AddProp('FiscalReceiptStation', StationToStr(FiscalPrinter.ErrorStation));
  AddProp('FiscalReceiptType', FiscalReceiptTypeToStr(FiscalPrinter.FiscalReceiptType));
  AddProp('FlagWhenIdle');
  AddProp('FreezeEvents');
  AddProp('JrnEmpty');
  AddProp('JrnNearEnd');
  AddProp('MessageLength');
  AddProp('MessageType', MessageTypeToStr(FiscalPrinter.MessageType));
  AddProp('NumHeaderLines');
  AddProp('NumTrailerLines');
  AddProp('NumVatRates');
  AddProp('OpenResult', GetResultCodeText(FiscalPrinter.OpenResult));
  AddProp('OutputID');
  AddProp('PostLine');
  AddProp('PowerNotify', PowerNotifyToStr(FiscalPrinter.PowerNotify));
  AddProp('PowerState', PowerStateToStr(FiscalPrinter.PowerState));
  AddProp('PreLine');
  AddProp('PredefinedPaymentLines');
  AddProp('PrinterState', PrinterStateToStr(FiscalPrinter.PrinterState));
  AddProp('QuantityDecimalPlaces');
  AddProp('QuantityLength');
  AddProp('RecEmpty');
  AddProp('RecNearEnd');
  AddProp('RemainingFiscalMemory');
  AddProp('ReservedWord');
  AddProp('ResultCode', GetResultCodeText(FiscalPrinter.ResultCode));
  AddProp('ResultCodeExtended', GetResultCodeExtendedText(FiscalPrinter.ResultCodeExtended));
  AddProp('ServiceObjectDescription');
  AddProp('ServiceObjectVersion');
  AddProp('SlipSelection');
  AddProp('SlpEmpty');
  AddProp('SlpNearEnd');
  AddProp('State', StateToStr(FiscalPrinter.State));
  AddProp('TotalizerType', TotalizerTypeToStr(FiscalPrinter.TotalizerType));
  AddProp('TrainingModeActive');
end;

procedure TfmFptrProperties.btnRefreshClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    UpdateProps;
  finally
    EnableButtons(True);
  end;
end;

end.
