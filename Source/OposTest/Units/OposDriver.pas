unit OposDriver;

interface

uses
  // VCL
  SysUtils,
  // This
  OposFiscalPrinter_1_11_Lib_TLB, OposCashDrawer_1_11_Lib_TLB, Opos;

procedure FreeCashDrawer;
procedure FreePosPrinter;
procedure FreeFiscalPrinter;

function PosPrinter: TOPOSPOSPrinter;
function CashDrawer: TOPOSCashDrawer;
function FiscalPrinter: TOPOSFiscalPrinter;

procedure Check(AResultCode: Integer);

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then Abort;
end;


var
  PosPrinterVar: TOPOSPOSPrinter = nil;
  CashDrawerVar: TOPOSCashDrawer = nil;
  FiscalPrinterVar: TOPOSFiscalPrinter = nil;

procedure FreeFiscalPrinter;
begin
  FiscalPrinterVar.Free;
  FiscalPrinterVar := nil;
end;

procedure FreeCashDrawer;
begin
  CashDrawerVar.Free;
  CashDrawerVar := nil;
end;

function CashDrawer: TOPOSCashDrawer;
begin
  if CashDrawerVar = nil then
  begin
    try
      CashDrawerVar := TOPOSCashDrawer.Create(nil);
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object CashDrawer:'#13#10 + E.Message;
        raise;
      end;
    end;
  end;
  Result := CashDrawerVar;
end;

function FiscalPrinter: TOPOSFiscalPrinter;
begin
  if FiscalPrinterVar = nil then
  begin
    try
      FiscalPrinterVar := TOPOSFiscalPrinter.Create(nil);
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object FiscalPrinter:'#13#10 +
          E.Message;
        raise;
      end;
    end;
  end;
  Result := FiscalPrinterVar;
end;

end.
