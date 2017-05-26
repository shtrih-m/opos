unit OposPosPrinter;

interface

uses
  // VCL
  SysUtils, Variants, ComObj,
  // This
  Opos, OposUtils;

procedure FreePosPrinter;
function PosPrinter: OleVariant;

procedure Check(AResultCode: Integer);

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    raise Exception.CreateFmt('%d, %s, %d, %s', [
      AResultCode, GetResultCodeText(AResultCode),
      PosPrinter.ResultCodeExtended, PosPrinter.ErrorString]);
  end;
end;


var
  PosPrinterVar: OleVariant;

procedure FreePosPrinter;
begin
  VarClear(PosPrinterVar);
end;

function PosPrinter: OleVariant;
begin
  if VarIsEmpty(PosPrinterVar) then
  begin
    try
      PosPrinterVar := CreateOleObject('OPOS.PosPrinter');
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object PosPrinter:'#13#10 +
          E.Message;
        raise;
      end;
    end;
  end;
  Result := PosPrinterVar;
end;

end.
