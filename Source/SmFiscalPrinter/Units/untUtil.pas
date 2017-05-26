unit untUtil;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Registry, Controls, StdCtrls;

procedure CreatePorts(Strings: TStrings);
procedure DeleteRegKey(const KeyName: string);
procedure EnableButtons(WinControl: TWinControl; Value: Boolean; var AButton: TButton);

implementation

procedure EnableButtons(WinControl: TWinControl; Value: Boolean; var AButton: TButton);
var
  i: Integer;
  Button: TButton;
  Control: TControl;
begin
  for i := 0 to WinControl.ControlCount-1 do
  begin
    Control := WinControl.Controls[i];
    if Control is TWinControl then
      EnableButtons(Control as TWinControl, Value, AButton);
  end;

  if (WinControl is TButton) then
  begin
    Button := WinControl as TButton;
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

procedure CreatePorts(Strings: TStrings);
var
  i: Integer;
begin
  for i := 1 to 256 do
    Strings.Add('COM' + IntToStr(i));
end;

procedure DeleteRegKey(const KeyName: string);
var
  i: Integer;
  Reg: TRegistry;
  Strings: TStrings;
begin
  Reg := TRegistry.Create;
  Strings := TStringList.Create;
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
