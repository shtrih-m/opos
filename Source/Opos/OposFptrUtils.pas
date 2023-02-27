unit OposFptrUtils;

interface

uses
  // VCL
  SysUtils,
  // This
  Opos, OposUtils, Oposhi, OposFptr, OposFptrhi, OposException, TntSysUtils,
  gnugettext;

function PrinterStateToStr(Value: Integer): WideString;
function GetFptrPropertyName(const ID: Integer): WideString;
function GetResultCodeExtendedText(Value: Integer): WideString;
function GetStatusUpdateEventText(Value: Integer): WideString;
procedure OposFptrCheck(Driver: OleVariant; ResultCode: Integer);
function OposFptrGetErrorText(Driver: OleVariant): WideString;
function ActualCurrencyToStr(Value: Integer): WideString;
function ContractorIdToStr(Value: Integer): WideString;
function CountryCodeToStr(Value: Integer): WideString;
function ErrorLevelToStr(Value: Integer): WideString;
function DateTypeToStr(Value: Integer): WideString;
function FiscalReceiptTypeToStr(Value: Integer): WideString;
function MessageTypeToStr(Value: Integer): WideString;
function TotalizerTypeToStr(Value: Integer): WideString;
function StationToStr(Value: Integer): WideString;

procedure raiseOposFptrRecEmpty;
procedure raiseOposFptrJrnEmpty;
procedure raiseOposFptrCoverOpened;

implementation

procedure raiseOposFptrRecEmpty;
begin
  raiseExtendedError(OPOS_EFPTR_REC_EMPTY, _('Receipt station is empty'));
end;

procedure raiseOposFptrJrnEmpty;
begin
  raiseExtendedError(OPOS_EFPTR_JRN_EMPTY, _('Journal station is empty'));
end;

procedure raiseOposFptrCoverOpened;
begin
  raiseExtendedError(OPOS_EFPTR_COVER_OPEN, _('Cover is opened'));
end;

function OposFptrGetErrorText(Driver: OleVariant): WideString;
begin
  if Driver.ResultCode = OPOS_E_EXTENDED then
    Result := Tnt_WideFormat('%s %s', [
    GetResultCodeExtendedText(Driver.ResultCodeExtended), Driver.ErrorString])
  else
    Result := Tnt_WideFormat('%s %s', [
    GetResultCodeText(Driver.ResultCode), Driver.ErrorString])
end;

procedure OposFptrCheck(Driver: OleVariant; ResultCode: Integer);
begin
  if Driver.ResultCode <> OPOS_SUCCESS then
    raise Exception.Create(OposFptrGetErrorText(Driver));
end;

function GetFptrPropertyName(const ID: Integer): WideString;
begin
  case ID of
    // fiscal printer
    PIDXFptr_AmountDecimalPlaces: Result := 'PIDXFptr_AmountDecimalPlaces';
    PIDXFptr_AsyncMode: Result := 'PIDXFptr_AsyncMode';
    PIDXFptr_CheckTotal: Result := 'PIDXFptr_CheckTotal';
    PIDXFptr_CountryCode: Result := 'PIDXFptr_CountryCode';
    PIDXFptr_CoverOpen: Result := 'PIDXFptr_CoverOpen';
    PIDXFptr_DayOpened: Result := 'PIDXFptr_DayOpened';
    PIDXFptr_DescriptionLength: Result := 'PIDXFptr_DescriptionLength';
    PIDXFptr_DuplicateReceipt: Result := 'PIDXFptr_DuplicateReceipt';
    PIDXFptr_ErrorLevel: Result := 'PIDXFptr_ErrorLevel';
    PIDXFptr_ErrorOutID: Result := 'PIDXFptr_ErrorOutID';
    PIDXFptr_ErrorState: Result := 'PIDXFptr_ErrorState';
    PIDXFptr_ErrorStation: Result := 'PIDXFptr_ErrorStation';
    PIDXFptr_FlagWhenIdle: Result := 'PIDXFptr_FlagWhenIdle';
    PIDXFptr_JrnEmpty: Result := 'PIDXFptr_JrnEmpty';
    PIDXFptr_JrnNearEnd: Result := 'PIDXFptr_JrnNearEnd';
    PIDXFptr_MessageLength: Result := 'PIDXFptr_MessageLength';
    PIDXFptr_NumHeaderLines: Result := 'PIDXFptr_NumHeaderLines';
    PIDXFptr_NumTrailerLines: Result := 'PIDXFptr_NumTrailerLines';
    PIDXFptr_NumVatRates: Result := 'PIDXFptr_NumVatRates';
    PIDXFptr_PrinterState: Result := 'PIDXFptr_PrinterState';
    PIDXFptr_QuantityDecimalPlaces: Result := 'PIDXFptr_QuantityDecimalPlaces';
    PIDXFptr_QuantityLength: Result := 'PIDXFptr_QuantityLength';
    PIDXFptr_RecEmpty: Result := 'PIDXFptr_RecEmpty';
    PIDXFptr_RecNearEnd: Result := 'PIDXFptr_RecNearEnd';
    PIDXFptr_RemainingFiscalMemory: Result := 'PIDXFptr_RemainingFiscalMemory';
    PIDXFptr_SlpEmpty: Result := 'PIDXFptr_SlpEmpty';
    PIDXFptr_SlpNearEnd: Result := 'PIDXFptr_SlpNearEnd';
    PIDXFptr_SlipSelection: Result := 'PIDXFptr_SlipSelection';
    PIDXFptr_TrainingModeActive: Result := 'PIDXFptr_TrainingModeActive';
    PIDXFptr_ActualCurrency: Result := 'PIDXFptr_ActualCurrency';
    PIDXFptr_ContractorId: Result := 'PIDXFptr_ContractorId';
    PIDXFptr_DateType: Result := 'PIDXFptr_DateType';
    PIDXFptr_FiscalReceiptStation: Result := 'PIDXFptr_FiscalReceiptStation';
    PIDXFptr_FiscalReceiptType: Result := 'PIDXFptr_FiscalReceiptType';
    PIDXFptr_MessageType: Result := 'PIDXFptr_MessageType';
    PIDXFptr_TotalizerType: Result := 'PIDXFptr_TotalizerType';
    PIDXFptr_CapAdditionalLines: Result := 'PIDXFptr_CapAdditionalLines';
    PIDXFptr_CapAmountAdjustment: Result := 'PIDXFptr_CapAmountAdjustment';
    PIDXFptr_CapAmountNotPaid: Result := 'PIDXFptr_CapAmountNotPaid';
    PIDXFptr_CapCheckTotal: Result := 'PIDXFptr_CapCheckTotal';
    PIDXFptr_CapCoverSensor: Result := 'PIDXFptr_CapCoverSensor';
    PIDXFptr_CapDoubleWidth: Result := 'PIDXFptr_CapDoubleWidth';
    PIDXFptr_CapDuplicateReceipt: Result := 'PIDXFptr_CapDuplicateReceipt';
    PIDXFptr_CapFixedOutput: Result := 'PIDXFptr_CapFixedOutput';
    PIDXFptr_CapHasVatTable: Result := 'PIDXFptr_CapHasVatTable';
    PIDXFptr_CapIndependentHeader: Result := 'PIDXFptr_CapIndependentHeader';
    PIDXFptr_CapItemList: Result := 'PIDXFptr_CapItemList';
    PIDXFptr_CapJrnEmptySensor: Result := 'PIDXFptr_CapJrnEmptySensor';
    PIDXFptr_CapJrnNearEndSensor: Result := 'PIDXFptr_CapJrnNearEndSensor';
    PIDXFptr_CapJrnPresent: Result := 'PIDXFptr_CapJrnPresent';
    PIDXFptr_CapNonFiscalMode: Result := 'PIDXFptr_CapNonFiscalMode';
    PIDXFptr_CapOrderAdjustmentFirst: Result := 'PIDXFptr_CapOrderAdjustmentFirst';
    PIDXFptr_CapPercentAdjustment: Result := 'PIDXFptr_CapPercentAdjustment';
    PIDXFptr_CapPositiveAdjustment: Result := 'PIDXFptr_CapPositiveAdjustment';
    PIDXFptr_CapPowerLossReport: Result := 'PIDXFptr_CapPowerLossReport';
    PIDXFptr_CapPredefinedPaymentLines: Result := 'PIDXFptr_CapPredefinedPaymentLines';
    PIDXFptr_CapReceiptNotPaid: Result := 'PIDXFptr_CapReceiptNotPaid';
    PIDXFptr_CapRecEmptySensor: Result := 'PIDXFptr_CapRecEmptySensor';
    PIDXFptr_CapRecNearEndSensor: Result := 'PIDXFptr_CapRecNearEndSensor';
    PIDXFptr_CapRecPresent: Result := 'PIDXFptr_CapRecPresent';
    PIDXFptr_CapRemainingFiscalMemory: Result := 'PIDXFptr_CapRemainingFiscalMemory';
    PIDXFptr_CapReservedWord: Result := 'PIDXFptr_CapReservedWord';
    PIDXFptr_CapSetHeader: Result := 'PIDXFptr_CapSetHeader';
    PIDXFptr_CapSetPOSID: Result := 'PIDXFptr_CapSetPOSID';
    PIDXFptr_CapSetStoreFiscalID: Result := 'PIDXFptr_CapSetStoreFiscalID';
    PIDXFptr_CapSetTrailer: Result := 'PIDXFptr_CapSetTrailer';
    PIDXFptr_CapSetVatTable: Result := 'PIDXFptr_CapSetVatTable';
    PIDXFptr_CapSlpEmptySensor: Result := 'PIDXFptr_CapSlpEmptySensor';
    PIDXFptr_CapSlpFiscalDocument: Result := 'PIDXFptr_CapSlpFiscalDocument';
    PIDXFptr_CapSlpFullSlip: Result := 'PIDXFptr_CapSlpFullSlip';
    PIDXFptr_CapSlpNearEndSensor: Result := 'PIDXFptr_CapSlpNearEndSensor';
    PIDXFptr_CapSlpPresent: Result := 'PIDXFptr_CapSlpPresent';
    PIDXFptr_CapSlpValidation: Result := 'PIDXFptr_CapSlpValidation';
    PIDXFptr_CapSubAmountAdjustment: Result := 'PIDXFptr_CapSubAmountAdjustment';
    PIDXFptr_CapSubPercentAdjustment: Result := 'PIDXFptr_CapSubPercentAdjustment';
    PIDXFptr_CapSubtotal: Result := 'PIDXFptr_CapSubtotal';
    PIDXFptr_CapTrainingMode: Result := 'PIDXFptr_CapTrainingMode';
    PIDXFptr_CapValidateJournal: Result := 'PIDXFptr_CapValidateJournal';
    PIDXFptr_CapXReport: Result := 'PIDXFptr_CapXReport';
    PIDXFptr_CapAdditionalHeader: Result := 'PIDXFptr_CapAdditionalHeader';
    PIDXFptr_CapAdditionalTrailer: Result := 'PIDXFptr_CapAdditionalTrailer';
    PIDXFptr_CapChangeDue: Result := 'PIDXFptr_CapChangeDue';
    PIDXFptr_CapEmptyReceiptIsVoidable: Result := 'PIDXFptr_CapEmptyReceiptIsVoidable';
    PIDXFptr_CapFiscalReceiptStation: Result := 'PIDXFptr_CapFiscalReceiptStation';
    PIDXFptr_CapFiscalReceiptType: Result := 'PIDXFptr_CapFiscalReceiptType';
    PIDXFptr_CapMultiContractor: Result := 'PIDXFptr_CapMultiContractor';
    PIDXFptr_CapOnlyVoidLastItem: Result := 'PIDXFptr_CapOnlyVoidLastItem';
    PIDXFptr_CapPackageAdjustment: Result := 'PIDXFptr_CapPackageAdjustment';
    PIDXFptr_CapPostPreLine: Result := 'PIDXFptr_CapPostPreLine';
    PIDXFptr_CapSetCurrency: Result := 'PIDXFptr_CapSetCurrency';
    PIDXFptr_CapTotalizerType: Result := 'PIDXFptr_CapTotalizerType';
    PIDXFptr_CapPositiveSubtotalAdjustment: Result := 'PIDXFptr_CapPositiveSubtotalAdjustment';
    PIDXFptr_ErrorString: Result := 'PIDXFptr_ErrorString';
    PIDXFptr_PredefinedPaymentLines: Result := 'PIDXFptr_PredefinedPaymentLines';
    PIDXFptr_ReservedWord: Result := 'PIDXFptr_ReservedWord';
    PIDXFptr_AdditionalHeader: Result := 'PIDXFptr_AdditionalHeader';
    PIDXFptr_AdditionalTrailer: Result := 'PIDXFptr_AdditionalTrailer';
    PIDXFptr_ChangeDue: Result := 'PIDXFptr_ChangeDue';
    PIDXFptr_PostLine: Result := 'PIDXFptr_PostLine';
    PIDXFptr_PreLine: Result := 'PIDXFptr_PreLine';
  else
    Result := GetCommonPropertyName(ID);
  end;
end;

function GetResultCodeExtendedText(Value: Integer): WideString;
begin
  case Value of
    OPOS_EFPTR_COVER_OPEN                 : Result := 'OPOS_EFPTR_COVER_OPEN';
    OPOS_EFPTR_JRN_EMPTY                  : Result := 'OPOS_EFPTR_JRN_EMPTY';
    OPOS_EFPTR_REC_EMPTY                  : Result := 'OPOS_EFPTR_REC_EMPTY';
    OPOS_EFPTR_SLP_EMPTY                  : Result := 'OPOS_EFPTR_SLP_EMPTY';
    OPOS_EFPTR_SLP_FORM                   : Result := 'OPOS_EFPTR_SLP_FORM';
    OPOS_EFPTR_MISSING_DEVICES            : Result := 'OPOS_EFPTR_MISSING_DEVICES';
    OPOS_EFPTR_WRONG_STATE                : Result := 'OPOS_EFPTR_WRONG_STATE';
    OPOS_EFPTR_TECHNICAL_ASSISTANCE       : Result := 'OPOS_EFPTR_TECHNICAL_ASSISTANCE';
    OPOS_EFPTR_CLOCK_ERROR                : Result := 'OPOS_EFPTR_CLOCK_ERROR';
    OPOS_EFPTR_FISCAL_MEMORY_FULL         : Result := 'OPOS_EFPTR_FISCAL_MEMORY_FULL';
    OPOS_EFPTR_FISCAL_MEMORY_DISCONNECTED : Result := 'OPOS_EFPTR_FISCAL_MEMORY_DISCONNECTED';
    OPOS_EFPTR_FISCAL_TOTALS_ERROR        : Result := 'OPOS_EFPTR_FISCAL_TOTALS_ERROR';
    OPOS_EFPTR_BAD_ITEM_QUANTITY          : Result := 'OPOS_EFPTR_BAD_ITEM_QUANTITY';
    OPOS_EFPTR_BAD_ITEM_AMOUNT            : Result := 'OPOS_EFPTR_BAD_ITEM_AMOUNT';
    OPOS_EFPTR_BAD_ITEM_DESCRIPTION       : Result := 'OPOS_EFPTR_BAD_ITEM_DESCRIPTION';
    OPOS_EFPTR_RECEIPT_TOTAL_OVERFLOW     : Result := 'OPOS_EFPTR_RECEIPT_TOTAL_OVERFLOW';
    OPOS_EFPTR_BAD_VAT                    : Result := 'OPOS_EFPTR_BAD_VAT';
    OPOS_EFPTR_BAD_PRICE                  : Result := 'OPOS_EFPTR_BAD_PRICE';
    OPOS_EFPTR_BAD_DATE                   : Result := 'OPOS_EFPTR_BAD_DATE';
    OPOS_EFPTR_NEGATIVE_TOTAL             : Result := 'OPOS_EFPTR_NEGATIVE_TOTAL';
    OPOS_EFPTR_WORD_NOT_ALLOWED           : Result := 'OPOS_EFPTR_WORD_NOT_ALLOWED';
    OPOS_EFPTR_BAD_LENGTH                 : Result := 'OPOS_EFPTR_BAD_LENGTH';
    OPOS_EFPTR_MISSING_SET_CURRENCY       : Result := 'OPOS_EFPTR_MISSING_SET_CURRENCY';
    OPOS_EFPTR_DAY_END_REQUIRED           : Result := 'OPOS_EFPTR_DAY_END_REQUIRED';
  else
    Result := IntToStr(Value);
  end;
end;

function PrinterStateTostr(Value: Integer): WideString;
begin
  case Value of
    FPTR_PS_MONITOR               : Result := 'FPTR_PS_MONITOR';
    FPTR_PS_FISCAL_RECEIPT        : Result := 'FPTR_PS_FISCAL_RECEIPT';
    FPTR_PS_FISCAL_RECEIPT_TOTAL  : Result := 'FPTR_PS_FISCAL_RECEIPT_TOTAL';
    FPTR_PS_FISCAL_RECEIPT_ENDING : Result := 'FPTR_PS_FISCAL_RECEIPT_ENDING';
    FPTR_PS_FISCAL_DOCUMENT       : Result := 'FPTR_PS_FISCAL_DOCUMENT';
    FPTR_PS_FIXED_OUTPUT          : Result := 'FPTR_PS_FIXED_OUTPUT';
    FPTR_PS_ITEM_LIST             : Result := 'FPTR_PS_ITEM_LIST';
    FPTR_PS_LOCKED                : Result := 'FPTR_PS_LOCKED';
    FPTR_PS_NONFISCAL             : Result := 'FPTR_PS_NONFISCAL';
    FPTR_PS_REPORT                : Result := 'FPTR_PS_REPORT';
  else
    Result := IntToStr(Value);
  end;
end;

function GetStatusUpdateEventText(Value: Integer): WideString;
begin
  case Value of
    // fptr
     FPTR_SUE_COVER_OPEN                  : Result := 'FPTR_SUE_COVER_OPEN';
     FPTR_SUE_COVER_OK                    : Result := 'FPTR_SUE_COVER_OK';
     FPTR_SUE_JRN_COVER_OPEN              : Result := 'FPTR_SUE_JRN_COVER_OPEN';
     FPTR_SUE_JRN_COVER_OK                : Result := 'FPTR_SUE_JRN_COVER_OK';
     FPTR_SUE_REC_COVER_OPEN              : Result := 'FPTR_SUE_REC_COVER_OPEN';
     FPTR_SUE_REC_COVER_OK                : Result := 'FPTR_SUE_REC_COVER_OK';
     FPTR_SUE_SLP_COVER_OPEN              : Result := 'FPTR_SUE_SLP_COVER_OPEN';
     FPTR_SUE_SLP_COVER_OK                : Result := 'FPTR_SUE_SLP_COVER_OK';
     FPTR_SUE_JRN_EMPTY                   : Result := 'FPTR_SUE_JRN_EMPTY';
     FPTR_SUE_JRN_NEAREMPTY               : Result := 'FPTR_SUE_JRN_NEAREMPTY';
     FPTR_SUE_JRN_PAPEROK                 : Result := 'FPTR_SUE_JRN_PAPEROK';
     FPTR_SUE_REC_EMPTY                   : Result := 'FPTR_SUE_REC_EMPTY';
     FPTR_SUE_REC_NEAREMPTY               : Result := 'FPTR_SUE_REC_NEAREMPTY';
     FPTR_SUE_REC_PAPEROK                 : Result := 'FPTR_SUE_REC_PAPEROK';
     FPTR_SUE_SLP_EMPTY                   : Result := 'FPTR_SUE_SLP_EMPTY';
     FPTR_SUE_SLP_NEAREMPTY               : Result := 'FPTR_SUE_SLP_NEAREMPTY';
     FPTR_SUE_SLP_PAPEROK                 : Result := 'FPTR_SUE_SLP_PAPEROK';
     FPTR_SUE_IDLE                        : Result := 'FPTR_SUE_IDLE';
  else
    Result := GetCommonStatusUpdateEventText(Value);
  end;
end;

function ActualCurrencyToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_AC_BRC: Result := 'FPTR_AC_BRC';
    FPTR_AC_BGL: Result := 'FPTR_AC_BGL';
    FPTR_AC_EUR: Result := 'FPTR_AC_EUR';
    FPTR_AC_GRD: Result := 'FPTR_AC_GRD';
    FPTR_AC_HUF: Result := 'FPTR_AC_HUF';
    FPTR_AC_ITL: Result := 'FPTR_AC_ITL';
    FPTR_AC_PLZ: Result := 'FPTR_AC_PLZ';
    FPTR_AC_ROL: Result := 'FPTR_AC_ROL';
    FPTR_AC_RUR: Result := 'FPTR_AC_RUR';
    FPTR_AC_TRL: Result := 'FPTR_AC_TRL';
    FPTR_AC_CZK: Result := 'FPTR_AC_CZK';
    FPTR_AC_UAH: Result := 'FPTR_AC_UAH';
    FPTR_AC_OTHER: Result := 'FPTR_AC_OTHER';
  else
    Result := IntToStr(Value);
  end;
end;

function ContractorIdToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_CID_FIRST: Result := 'FPTR_CID_FIRST';
    FPTR_CID_SECOND: Result := 'FPTR_CID_SECOND';
    FPTR_CID_SINGLE: Result := 'FPTR_CID_SINGLE';
  else
    Result := IntToStr(Value);
  end;
end;

function CountryCodeToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_CC_BRAZIL: Result := 'FPTR_CC_BRAZIL';
    FPTR_CC_GREECE: Result := 'FPTR_CC_GREECE';
    FPTR_CC_HUNGARY: Result := 'FPTR_CC_HUNGARY';
    FPTR_CC_ITALY: Result := 'FPTR_CC_ITALY';
    FPTR_CC_POLAND: Result := 'FPTR_CC_POLAND';
    FPTR_CC_TURKEY: Result := 'FPTR_CC_TURKEY';
    FPTR_CC_RUSSIA: Result := 'FPTR_CC_RUSSIA';
    FPTR_CC_BULGARIA: Result := 'FPTR_CC_BULGARIA';
    FPTR_CC_ROMANIA: Result := 'FPTR_CC_ROMANIA';
    FPTR_CC_CZECH_REPUBLIC: Result := 'FPTR_CC_CZECH_REPUBLIC';
    FPTR_CC_UKRAINE: Result := 'FPTR_CC_UKRAINE';
    FPTR_CC_OTHER: Result := 'FPTR_CC_OTHER';
  else
    Result := IntToStr(Value);
  end;
end;

function DateTypeToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_DT_CONF: Result := 'FPTR_DT_CONF';
    FPTR_DT_EOD: Result := 'FPTR_DT_EOD';
    FPTR_DT_RESET: Result := 'FPTR_DT_RESET';
    FPTR_DT_RTC: Result := 'FPTR_DT_RTC';
    FPTR_DT_VAT: Result := 'FPTR_DT_VAT';
    FPTR_DT_START: Result := 'FPTR_DT_START';
  else
    Result := IntToStr(Value);
  end;
end;

function ErrorLevelToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_EL_NONE: Result := 'FPTR_EL_NONE';
    FPTR_EL_RECOVERABLE: Result := 'FPTR_EL_RECOVERABLE';
    FPTR_EL_FATAL: Result := 'FPTR_EL_FATAL';
    FPTR_EL_BLOCKED: Result := 'FPTR_EL_BLOCKED';
  else
    Result := IntToStr(Value);
  end;
end;

function FiscalReceiptTypeToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_RT_CASH_IN: Result := 'FPTR_RT_CASH_IN';
    FPTR_RT_CASH_OUT: Result := 'FPTR_RT_CASH_OUT';
    FPTR_RT_GENERIC: Result := 'FPTR_RT_GENERIC';
    FPTR_RT_SALES: Result := 'FPTR_RT_SALES';
    FPTR_RT_SERVICE: Result := 'FPTR_RT_SERVICE';
    FPTR_RT_SIMPLE_INVOICE: Result := 'FPTR_RT_SIMPLE_INVOICE';
    FPTR_RT_REFUND: Result := 'FPTR_RT_REFUND';
  else
    Result := IntToStr(Value);
  end;
end;

function MessageTypeToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_MT_ADVANCE: Result := 'FPTR_MT_ADVANCE';
    FPTR_MT_ADVANCE_PAID: Result := 'FPTR_MT_ADVANCE_PAID';
    FPTR_MT_AMOUNT_TO_BE_PAID: Result := 'FPTR_MT_AMOUNT_TO_BE_PAID';
    FPTR_MT_AMOUNT_TO_BE_PAID_BACK: Result := 'FPTR_MT_AMOUNT_TO_BE_PAID_BACK';
    FPTR_MT_CARD: Result := 'FPTR_MT_CARD';
    FPTR_MT_CARD_NUMBER: Result := 'FPTR_MT_CARD_NUMBER';
    FPTR_MT_CARD_TYPE: Result := 'FPTR_MT_CARD_TYPE';
    FPTR_MT_CASH: Result := 'FPTR_MT_CASH';
    FPTR_MT_CASHIER: Result := 'FPTR_MT_CASHIER';
    FPTR_MT_CASH_REGISTER_NUMBER: Result := 'FPTR_MT_CASH_REGISTER_NUMBER';
    FPTR_MT_CHANGE: Result := 'FPTR_MT_CHANGE';
    FPTR_MT_CHEQUE: Result := 'FPTR_MT_CHEQUE';
    FPTR_MT_CLIENT_NUMBER: Result := 'FPTR_MT_CLIENT_NUMBER';
    FPTR_MT_CLIENT_SIGNATURE: Result := 'FPTR_MT_CLIENT_SIGNATURE';
    FPTR_MT_COUNTER_STATE: Result := 'FPTR_MT_COUNTER_STATE';
    FPTR_MT_CREDIT_CARD: Result := 'FPTR_MT_CREDIT_CARD';
    FPTR_MT_CURRENCY: Result := 'FPTR_MT_CURRENCY';
    FPTR_MT_CURRENCY_VALUE: Result := 'FPTR_MT_CURRENCY_VALUE';
    FPTR_MT_DEPOSIT: Result := 'FPTR_MT_DEPOSIT';
    FPTR_MT_DEPOSIT_RETURNED: Result := 'FPTR_MT_DEPOSIT_RETURNED';
    FPTR_MT_DOT_LINE: Result := 'FPTR_MT_DOT_LINE';
    FPTR_MT_DRIVER_NUMB: Result := 'FPTR_MT_DRIVER_NUMB';
    FPTR_MT_EMPTY_LINE: Result := 'FPTR_MT_EMPTY_LINE';
    FPTR_MT_FREE_TEXT: Result := 'FPTR_MT_FREE_TEXT';
    FPTR_MT_FREE_TEXT_WITH_DAY_LIMIT: Result := 'FPTR_MT_FREE_TEXT_WITH_DAY_LIMIT';
    FPTR_MT_GIVEN_DISCOUNT: Result := 'FPTR_MT_GIVEN_DISCOUNT';
    FPTR_MT_LOCAL_CREDIT: Result := 'FPTR_MT_LOCAL_CREDIT';
    FPTR_MT_MILEAGE_KM: Result := 'FPTR_MT_MILEAGE_KM';
    FPTR_MT_NOTE: Result := 'FPTR_MT_NOTE';
    FPTR_MT_PAID: Result := 'FPTR_MT_PAID';
    FPTR_MT_PAY_IN: Result := 'FPTR_MT_PAY_IN';
    FPTR_MT_POINT_GRANTED: Result := 'FPTR_MT_POINT_GRANTED';
    FPTR_MT_POINTS_BONUS: Result := 'FPTR_MT_POINTS_BONUS';
    FPTR_MT_POINTS_RECEIPT: Result := 'FPTR_MT_POINTS_RECEIPT';
    FPTR_MT_POINTS_TOTAL: Result := 'FPTR_MT_POINTS_TOTAL';
    FPTR_MT_PROFITED: Result := 'FPTR_MT_PROFITED';
    FPTR_MT_RATE: Result := 'FPTR_MT_RATE';
    FPTR_MT_REGISTER_NUMB: Result := 'FPTR_MT_REGISTER_NUMB';
    FPTR_MT_SHIFT_NUMBER: Result := 'FPTR_MT_SHIFT_NUMBER';
    FPTR_MT_STATE_OF_AN_ACCOUNT: Result := 'FPTR_MT_STATE_OF_AN_ACCOUNT';
    FPTR_MT_SUBSCRIPTION: Result := 'FPTR_MT_SUBSCRIPTION';
    FPTR_MT_TABLE: Result := 'FPTR_MT_TABLE';
    FPTR_MT_THANK_YOU_FOR_LOYALTY: Result := 'FPTR_MT_THANK_YOU_FOR_LOYALTY';
    FPTR_MT_TRANSACTION_NUMB: Result := 'FPTR_MT_TRANSACTION_NUMB';
    FPTR_MT_VALID_TO: Result := 'FPTR_MT_VALID_TO';
    FPTR_MT_VOUCHER: Result := 'FPTR_MT_VOUCHER';
    FPTR_MT_VOUCHER_PAID: Result := 'FPTR_MT_VOUCHER_PAID';
    FPTR_MT_VOUCHER_VALUE: Result := 'FPTR_MT_VOUCHER_VALUE';
    FPTR_MT_WITH_DISCOUNT: Result := 'FPTR_MT_WITH_DISCOUNT';
    FPTR_MT_WITHOUT_UPLIFT: Result := 'FPTR_MT_WITHOUT_UPLIFT';
  else
    Result := IntToStr(Value);
  end;
end;

function TotalizerTypeToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_TT_DOCUMENT: Result := 'FPTR_TT_DOCUMENT';
    FPTR_TT_DAY: Result := 'FPTR_TT_DAY';
    FPTR_TT_RECEIPT: Result := 'FPTR_TT_RECEIPT';
    FPTR_TT_GRAND: Result := 'FPTR_TT_GRAND';
  else
    Result := IntToStr(Value);
  end;
end;

function StationToStr(Value: Integer): WideString;
begin
  case Value of
    FPTR_S_JOURNAL: Result := 'FPTR_S_JOURNAL';
    FPTR_S_RECEIPT: Result := 'FPTR_S_RECEIPT';
    FPTR_S_SLIP: Result := 'FPTR_S_SLIP';
    FPTR_S_JOURNAL_RECEIPT: Result := 'FPTR_S_JOURNAL_RECEIPT';
  else
    Result := IntToStr(Value);
  end;
end;

end.
