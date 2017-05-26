unit FptrTypes;


interface

uses
  // VCL
  SysUtils,
  // This
  Opos, OposUtils, OposFptr, OposFptrUtils, PrinterParameters;

function BaudRateToInt(Value: Integer): Integer;
function IntToBaudRate(Value: Integer): Integer;
procedure Check(Driver: OleVariant; ResultCode: Integer);

implementation

procedure Check(Driver: OleVariant; ResultCode: Integer);
begin
  if Driver.ResultCode <> OPOS_SUCCESS then
  begin
    if Driver.ResultCode = OPOS_E_EXTENDED then
      raise Exception.CreateFmt('%s %s',
      [GetResultCodeExtendedText(Driver.ResultCodeExtended), Driver.ErrorString])
    else
      raise Exception.CreateFmt('%s %s',
      [GetResultCodeText(Driver.ResultCode), Driver.ErrorString])
  end;
end;

function BaudRateToInt(Value: Integer): Integer;
begin
  case Value of
    2400   : Result := 0;
    4800   : Result := 1;
    9600   : Result := 2;
    19200  : Result := 3;
    38400  : Result := 4;
    57600  : Result := 5;
    115200 : Result := 6;
  else
    Result := 1;
  end;
end;

function IntToBaudRate(Value: Integer): Integer;
begin
  case Value of
    0: Result := 2400;
    1: Result := 4800;
    2: Result := 9600;
    3: Result := 19200;
    4: Result := 38400;
    5: Result := 57600;
    6: Result := 115200;
  else
    Result := 1;
  end;
end;

end.
