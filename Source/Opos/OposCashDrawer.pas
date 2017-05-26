unit OposCashDrawer;

interface

uses
  // VCL
  SysUtils, Variants, ComObj,
  // This
  Opos, OposUtils,
  OposCashDrawerIntf, SMCashDrawer, NCRCashDrawer;

const
  CashDrawerCCO_RCS = 0;
  CashDrawerCCO_NCR = 1;


procedure FreeCashDrawer;
procedure Check(AResultCode: Integer);
procedure CreateCashDrawer(CashDrawerCCOType: Integer);
function CashDrawer: IOPOSCashDrawer_1_9;

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    raise Exception.CreateFmt('%d, %s, %d', [
      AResultCode, GetResultCodeText(AResultCode),
      CashDrawer.ResultCodeExtended]);
  end;
end;

var
  FCashDrawer: IOPOSCashDrawer_1_9;

procedure FreeCashDrawer;
begin
  FCashDrawer := nil;
end;

procedure CreateCashDrawer(CashDrawerCCOType: Integer);
begin
  if FCashDrawer = nil then
  begin
    case CashDrawerCCOType of
      CashDrawerCCO_NCR: FCashDrawer := TNCRCashDrawer.Create
    else
      FCashDrawer := TSMCashDrawer.Create;
    end;
  end;
end;

function CashDrawer: IOPOSCashDrawer_1_9;
begin
  if FCashDrawer = nil then
    raise Exception.Create('CashDrawer not initialized');

  Result := FCashDrawer;
end;

end.
