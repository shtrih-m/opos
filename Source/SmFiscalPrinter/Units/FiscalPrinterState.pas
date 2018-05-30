unit FiscalPrinterState;

interface

uses
  // VCL
  Classes, SysUtils,
  // This
  OPOSException, OposFptr, WException, gnugettext;

type
  { TFiscalPrinterState }

  TFiscalPrinterState = class
  private
    FState: Integer;
  public
    class procedure CheckValidState(AState: Integer);
    class function GetStateText(AState: Integer): WideString;
    class function ValidState(const Value: Integer): Boolean;

    function IsReceiptEnding: Boolean;
    procedure SetState(AState: Integer);
    procedure CheckState(AState: Integer);

    property State: Integer read FState;
  end;

implementation

{ TFiscalPrinterState }

class function TFiscalPrinterState.ValidState(const Value: Integer): Boolean;
begin
  Result :=
   (Value = FPTR_PS_MONITOR) or
   (Value = FPTR_PS_FISCAL_RECEIPT) or
   (Value = FPTR_PS_FISCAL_RECEIPT_TOTAL) or
   (Value = FPTR_PS_FISCAL_RECEIPT_ENDING) or
   (Value = FPTR_PS_FISCAL_DOCUMENT) or
   (Value = FPTR_PS_FIXED_OUTPUT) or
   (Value = FPTR_PS_ITEM_LIST) or
   (Value = FPTR_PS_LOCKED) or
   (Value = FPTR_PS_NONFISCAL) or
   (Value = FPTR_PS_REPORT);
end;

class procedure TFiscalPrinterState.CheckValidState(AState: Integer);
begin
  if not ValidState(AState) then
    raiseException(_('Invalid printer state'));
end;

class function TFiscalPrinterState.GetStateText(AState: Integer): WideString;
begin
  case AState of
    FPTR_PS_MONITOR                     : Result := 'FPTR_PS_MONITOR';
    FPTR_PS_FISCAL_RECEIPT              : Result := 'FPTR_PS_FISCAL_RECEIPT';
    FPTR_PS_FISCAL_RECEIPT_TOTAL        : Result := 'FPTR_PS_FISCAL_RECEIPT_TOTAL';
    FPTR_PS_FISCAL_RECEIPT_ENDING       : Result := 'FPTR_PS_FISCAL_RECEIPT_ENDING';
    FPTR_PS_FISCAL_DOCUMENT             : Result := 'FPTR_PS_FISCAL_DOCUMENT';
    FPTR_PS_FIXED_OUTPUT                : Result := 'FPTR_PS_FIXED_OUTPUT';
    FPTR_PS_ITEM_LIST                   : Result := 'FPTR_PS_ITEM_LIST';
    FPTR_PS_LOCKED                      : Result := 'FPTR_PS_LOCKED';
    FPTR_PS_NONFISCAL                   : Result := 'FPTR_PS_NONFISCAL';
    FPTR_PS_REPORT                      : Result := 'FPTR_PS_REPORT';
  else
    Result := IntToStr(AState);
  end;
end;

procedure TFiscalPrinterState.CheckState(AState: Integer);
begin
  if AState <> FState then
    raiseExtendedError(OPOS_EFPTR_WRONG_STATE, _('Wrong printer state'));
end;

procedure TFiscalPrinterState.SetState(AState: Integer);
begin
  CheckValidState(AState);
  FState := AState;
end;

function TFiscalPrinterState.IsReceiptEnding: Boolean;
begin
  Result := FState = FPTR_PS_FISCAL_RECEIPT_ENDING;
end;

end.
