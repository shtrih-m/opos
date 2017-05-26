unit OposFiscalPrinterVar;

interface

uses
  // VCL
  SysUtils, Variants, ComObj, Forms,
  // This
  Opos;

const
  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';

procedure FreeFiscalPrinter;
procedure Check(AResultCode: Integer);
function FiscalPrinter: OleVariant;

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then Abort;
end;

var
  FiscalPrinterVar: OleVariant;

procedure FreeFiscalPrinter;
begin
  if not VarIsEmpty(FiscalPrinterVar) then
  begin
    FiscalPrinterVar.Close;
    VarClear(FiscalPrinterVar);
  end;
end;

function FiscalPrinter: OleVariant;
begin
  if  VarIsEmpty(FiscalPrinterVar) then
  begin
    try
      FiscalPrinterVar := CreateOleObject('OPOS.FiscalPrinter');
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
