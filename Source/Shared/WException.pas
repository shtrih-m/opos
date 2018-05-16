unit WException;

interface

uses
  // VCL
  SysUtils,
  // Tnt
  TntSysUtils;

type
  { WideException }

  WideException = class(Exception)
  private
    FMessage: WideString;
  public
    constructor Create(const AMessage: WideString);
    property Message: WideString read FMessage;
  end;

procedure raiseException(const AMessage: WideString);
procedure raiseExceptionFmt(const AFormat: WideString; const Args: array of const);

function GetExceptionMessage(E: Exception): WideString;

implementation

procedure raiseException(const AMessage: WideString);
begin
  raise WideException.Create(AMessage);
end;

procedure raiseExceptionFmt(const AFormat: WideString; const Args: array of const);
begin
  raise WideException.Create(Tnt_WideFormat(AFormat, Args));
end;

function GetExceptionMessage(E: Exception): WideString;
begin
  Result := E.Message;
  if E is WideException then
    Result := (E as WideException).Message;
end;

{ WideException }

constructor WideException.Create(const AMessage: WideString);
begin
  inherited Create(AMessage);
  FMessage := AMessage;
end;

end.
