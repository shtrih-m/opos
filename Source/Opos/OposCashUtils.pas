unit OposCashUtils;

interface

uses
  // VCL
  SysUtils,
  // Opos
  OposUtils, OposCashhi;

function GetCashPropertyName(const ID: Integer): WideString;
function GetResultCodeExtendedText(Value: Integer): WideString;

implementation

function GetCashPropertyName(const ID: Integer): WideString;
begin
  case ID of
    PIDXCash_DrawerOpened  : Result := 'PIDXCash_DrawerOpened';
    PIDXCash_CapStatus     : Result := 'PIDXCash_CapStatus';
    PIDXCash_CapStatusMultiDrawerDetect: Result := 'PIDXCash_CapStatusMultiDrawerDetect';
  else
    Result := GetCommonPropertyName(ID);
  end;
end;

function GetResultCodeExtendedText(Value: Integer): WideString;
begin
  Result := IntToStr(Value);
end;

end.
