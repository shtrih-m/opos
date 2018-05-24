unit untUtil;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Registry, Controls, StdCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils, TntClasses, TntRegistry;


procedure CreatePorts(Strings: TTntStrings);
procedure DeleteRegKey(const KeyName: string);
procedure EnableButtons(WinControl: TWinControl; Value: Boolean; var AButton: TTntButton);

implementation

procedure EnableButtons(WinControl: TWinControl; Value: Boolean; var AButton: TTntButton);
var
  i: Integer;
  Button: TTntButton;
  Control: TControl;
begin
  for i := 0 to WinControl.ControlCount-1 do
  begin
    Control := WinControl.Controls[i];
    if Control is TWinControl then
      EnableButtons(Control as TWinControl, Value, AButton);
  end;

  if (WinControl is TTntButton) then
  begin
    Button := WinControl as TTntButton;
    if Value then
    begin
      Button.Enabled := True;
      if Button = AButton then Button.SetFocus;
    end else
    begin
      if Button.Focused then AButton := Button;
      Button.Enabled := False;
    end;
  end;
end;

procedure CreatePorts(Strings: TTntStrings);
var
  i: Integer;
begin
  for i := 1 to 256 do
    Strings.Add('COM' + IntToStr(i));
end;

procedure DeleteRegKey(const KeyName: string);
var
  i: Integer;
  Reg: TTntRegistry;
  Strings: TTntStrings;
begin
  Reg := TTntRegistry.Create;
  Strings := TTntStringList.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyName, False) then
    begin
      Reg.GetKeyNames(Strings);
      for i := 0 to Strings.Count-1 do
      begin
        DeleteRegKey(KeyName + '\' + Strings[i]);
      end;
      Reg.CloseKey;
      Reg.DeleteKey(KeyName);
    end;
  finally
    Reg.Free;
    Strings.Free;
  end;
end;

end.
