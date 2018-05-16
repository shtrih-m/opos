unit DriverError;

interface

uses
  // VCL
  SysUtils, WException;

type
  { EDriverError }

  EDriverError = class(WideException)
  private
   FErrorCode: Integer;
  public
    property ErrorCode: Integer read fErrorCode;
    constructor Create2(Code: Integer; const Msg: WideString);
  end;

procedure RaiseError(Code: Integer; const Message: WideString);

implementation

{ EDriverError }

constructor EDriverError.Create2(Code: Integer; const Msg: WideString);
begin
  inherited Create(Msg);
  FErrorCode := Code;
end;

procedure RaiseError(Code: Integer; const Message: WideString);
begin
  raise EDriverError.Create2(Code, Message);
end;

end.
