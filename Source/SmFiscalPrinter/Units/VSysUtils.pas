unit VSysUtils;

interface

uses
  // VCL
  Windows;

function GetCompName: WideString;

implementation

function GetCompName: WideString;
var
  Size: DWORD;
  LocalMachine: array [0..MAX_COMPUTERNAME_LENGTH] of WideChar;
begin
  Size := Sizeof(LocalMachine);
  if GetComputerNameW(LocalMachine, Size) then
    Result := LocalMachine else Result := '';
end;

end.
