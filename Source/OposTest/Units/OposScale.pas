unit OposScale;

interface

uses
  // VCL
  SysUtils, Variants, ComObj, Forms,
  // This
  Opos, OposUtils, DebugUtils;

procedure FreeScale;
procedure Check(AResultCode: Integer);
function Scale: OleVariant;

implementation

procedure Check(AResultCode: Integer);
begin
  if AResultCode <> OPOS_SUCCESS then
  begin
    raise Exception.CreateFmt('%d, %s, %d', [
      AResultCode, GetResultCodeText(AResultCode),
      Scale.ResultCodeExtended]);
  end;
end;

var
  ScaleVar: OleVariant;

procedure FreeScale;
begin
  if not VarIsEmpty(ScaleVar) then
  begin
    VarClear(ScaleVar);
  end;
end;

function Scale: OleVariant;
begin
  if VarIsEmpty(ScaleVar) then
  begin
    try
      ScaleVar := CreateOleObject('OPOS.Scale');
    except
      on E: Exception do
      begin
        E.Message := 'Error creating object Scale:'#13#10 +
          E.Message;
        raise;
      end;
    end;
  end;
  Result := ScaleVar;
end;

end.
