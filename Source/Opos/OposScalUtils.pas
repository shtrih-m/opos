unit OposScalUtils;

interface

uses
  // VCL
  SysUtils,
  // Opos
  OposScal, OposScalhi, OposUtils;

function GetScalePropertyName(const ID: Integer): WideString;
function GetResultCodeExtendedText(Value: Integer): WideString;
function GetScaleStatusUpdateEventText(Value: Integer): WideString;

implementation

function GetScalePropertyName(const ID: Integer): WideString;
begin
  case ID of
    PIDXScal_MaximumWeight        : Result := 'PIDXScal_MaximumWeight';
    PIDXScal_WeightUnit           : Result := 'PIDXScal_WeightUnit';
    PIDXScal_AsyncMode            : Result := 'PIDXScal_AsyncMode';
    PIDXScal_MaxDisplayTextChars  : Result := 'PIDXScal_MaxDisplayTextChars';
    PIDXScal_TareWeight           : Result := 'PIDXScal_TareWeight';
    PIDXScal_ScaleLiveWeight      : Result := 'PIDXScal_ScaleLiveWeight';
    PIDXScal_StatusNotify         : Result := 'PIDXScal_StatusNotify';
    PIDXScal_CapDisplay           : Result := 'PIDXScal_CapDisplay';
    PIDXScal_CapDisplayText       : Result := 'PIDXScal_CapDisplayText';
    PIDXScal_CapPriceCalculating  : Result := 'PIDXScal_CapPriceCalculating';
    PIDXScal_CapTareWeight        : Result := 'PIDXScal_CapTareWeight';
    PIDXScal_CapZeroScale         : Result := 'PIDXScal_CapZeroScale';
    PIDXScal_CapStatusUpdate      : Result := 'PIDXScal_CapStatusUpdate';
  else
    Result := GetCommonPropertyName(ID);
  end;
end;

function GetResultCodeExtendedText(Value: Integer): WideString;
begin
  case Value of
    OPOS_ESCAL_OVERWEIGHT  : Result := 'OPOS_ESCAL_OVERWEIGHT';
    OPOS_ESCAL_UNDER_ZERO  : Result := 'OPOS_ESCAL_UNDER_ZERO';
    OPOS_ESCAL_SAME_WEIGHT : Result := 'OPOS_ESCAL_SAME_WEIGHT';
  else
    Result := IntToStr(Value);
  end;
end;

function GetScaleStatusUpdateEventText(Value: Integer): WideString;
begin
  case Value of
    // OPOS SCALE
    SCAL_SUE_STABLE_WEIGHT     : Result := 'SCAL_SUE_STABLE_WEIGHT';
    SCAL_SUE_WEIGHT_UNSTABLE   : Result := 'SCAL_SUE_WEIGHT_UNSTABLE';
    SCAL_SUE_WEIGHT_ZERO       : Result := 'SCAL_SUE_WEIGHT_ZERO';
    SCAL_SUE_WEIGHT_OVERWEIGHT : Result := 'SCAL_SUE_WEIGHT_OVERWEIGHT';
    SCAL_SUE_NOT_READY         : Result := 'SCAL_SUE_NOT_READY';
    SCAL_SUE_WEIGHT_UNDER_ZERO : Result := 'SCAL_SUE_WEIGHT_UNDER_ZERO';
    // NCR Scale
  else
    Result := GetCommonStatusUpdateEventText(Value);
  end;
end;

end.
