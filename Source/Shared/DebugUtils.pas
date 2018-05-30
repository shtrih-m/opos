unit DebugUtils;

interface

uses
  // VCL
  Windows;

procedure ODS(const S: WideString);

implementation

procedure ODS(const S: WideString);
begin
{$IFDEF DEBUG}
  OutputDebugStringW(PWideChar(S));
{$ENDIF}
end;

end.



