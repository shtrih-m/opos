unit FormUtils;

interface

uses
  // VCL
  Windows,
  JwaWinUser;

procedure EnableForms;
procedure DisableForms(hWnd: HWND);

implementation

var
  Hook: HHOOK = 0;
  WndHandle: HWND;

function MsgHookProc(nCode, wParam, lParam: Integer): Integer; stdcall;
begin
  if nCode = HCBT_ACTIVATE then
  begin
    if Integer(wParam) <> Integer(WndHandle) then
    begin
      OutputDebugString('wParam <> WndHandle');
      Result := 1;
      Exit;
    end;
  end;
  Result := CallNextHookEx(Hook, nCode, wParam, lParam);
end;

procedure DisableForms(hWnd: HWND);
begin
  if Hook = 0 then
  begin
    WndHandle := hWnd;
    Hook := SetWindowsHookEx(WH_CBT, MsgHookProc, HInstance, GetCurrentThreadID);
  end;
end;

procedure EnableForms;
begin
  if Hook <> 0 then
  begin
    UnhookWindowsHookEx(Hook);
    Hook := 0;
  end;
end;


end.
