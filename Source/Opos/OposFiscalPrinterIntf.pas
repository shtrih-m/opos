unit OposFiscalPrinterIntf;

interface

uses
  // VCL
  SysUtils, Variants, ComObj, Forms,
  // This
  Opos, OposFiscalPrinter_1_13_Lib_TLB;

const
  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';

procedure FreeFiscalPrinter;
procedure Check(AResultCode: Integer);
function FiscalPrinter: IOPOSFiscalPrinter;

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then Abort;
end;

var
  FFiscalPrinter: IOPOSFiscalPrinter;

procedure FreeFiscalPrinter;
begin
  if not VarIsEmpty(FFiscalPrinter) then
  begin
    FFiscalPrinter.Close;
    FFiscalPrinter := nil;
  end;
end;

function FiscalPrinter: IOPOSFiscalPrinter;
begin
  if  VarIsEmpty(FFiscalPrinter) then
  begin
    try
      FFiscalPrinter := IUnknown(CreateOleObject('OPOS.FiscalPrinter')) as IOPOSFiscalPrinter;
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object FiscalPrinter:'#13#10 +
          E.Message;
        raise;
      end;
    end;
  end;
  Result := FFiscalPrinter;
end;

end.
