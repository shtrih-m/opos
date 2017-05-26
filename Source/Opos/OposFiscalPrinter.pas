unit OposFiscalPrinter;

interface

uses
  // VCL
  SysUtils, Variants, ComObj, Forms,
  // This
  Opos, OposUtils, SMFiscalPrinter;

const
  FiscalPrinterProgID = 'OposShtrih.FiscalPrinter';

procedure FreeFiscalPrinter;
procedure Check(AResultCode: Integer);
function FiscalPrinter: TSMFiscalPrinter;

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    raise Exception.CreateFmt('%d, %s, %d, %s', [
      AResultCode, GetResultCodeText(AResultCode),
      FiscalPrinter.ResultCodeExtended, FiscalPrinter.ErrorString]);
  end;
end;

var
  FFiscalPrinter: TSMFiscalPrinter;

procedure FreeFiscalPrinter;
begin
  if FFiscalPrinter <> nil then
  begin
    FFiscalPrinter.Free;
    FFiscalPrinter := nil;
  end;
end;

function FiscalPrinter: TSMFiscalPrinter;
begin
  if  FFiscalPrinter = nil then
  begin
    try
      FFiscalPrinter := TSMFiscalPrinter.Create;
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
