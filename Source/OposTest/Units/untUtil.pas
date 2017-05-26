unit untUtil;

interface

uses
  // This
  Classes, ComCtrls, ExtCtrls, StdCtrls, Controls, Forms, Registry;

procedure SaveFormParams(Form: TForm; const RegKey: string);
procedure LoadFormParams(Form: TForm; const RegKey: string);
procedure EnableControlButtons(WinControl: TWinControl; Value: Boolean; var AButton: TButton);

implementation

procedure EnableControlButtons(WinControl: TWinControl; Value: Boolean; var AButton: TButton);
var
  i: Integer;
  Button: TButton;
  Control: TControl;
begin
  for i := 0 to WinControl.ControlCount-1 do
  begin
    Control := WinControl.Controls[i];
    if Control is TWinControl then
      EnableControlButtons(Control as TWinControl, Value, AButton);
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

procedure LoadControlParams(const Path: string; Control: TWinControl; Reg: TRegistry);
var
  i: Integer;
  Item: TControl;
  ValueName: string;
begin
  for i := 0 to Control.ControlCount-1 do
  begin
    Item := Control.Controls[i];
    if Item is TWinControl then
    begin
      ValueName := Path + '.' + Item.Name;
      LoadControlParams(ValueName, Item as TWinControl, Reg);
      if Reg.ValueExists(ValueName) then
      begin
        if Item is TEdit and (not TEdit(Item).ReadOnly) then
          TEdit(Item).Text := Reg.ReadString(ValueName);
        if Item is TComboBox then
          TComboBox(Item).ItemIndex := Reg.ReadInteger(ValueName);
        if Item is TCheckBox then
          TCheckBox(Item).Checked := Reg.ReadBool(ValueName);
        if Item is TRadioGroup then
          TRadioGroup(Item).ItemIndex := Reg.ReadInteger(ValueName);
        if Item is TDateTimePicker then
          TDateTimePicker(Item).DateTime := Reg.ReadDateTime(ValueName);
      end;
    end;
  end;
end;

procedure SetDefaults(Control: TWinControl);
var
  i: Integer;
  Item: TControl;
begin
  for i := 0 to Control.ControlCount-1 do
  begin
    Item := Control.Controls[i];
    if Item is TWinControl then
    begin
      SetDefaults(Item as TWinControl);
      if Item.ClassNameIs('TComboBox') then
        TComboBox(Item).ItemIndex := 0;
    end;
  end;
end;

procedure SaveControlParams(const Path: string; Control: TWinControl; Reg: TRegistry);
var
  i: Integer;
  EditItem: TEdit;
  Item: TComponent;
  ValueName: string;
begin
  for i := 0 to Control.ControlCount-1 do
  begin
    Item := Control.Controls[i];
    if Item is TWinControl then
    begin
      ValueName := Path + '.' + Item.Name;
      SaveControlParams(ValueName, Item as TWinControl, Reg);
      if Item is TEdit then
      begin
        EditItem := Item as TEdit;
        if not EditItem.ReadOnly then
        Reg.WriteString(ValueName, EditItem.Text);
      end;

      if Item is TComboBox then
        Reg.WriteInteger(ValueName, TComboBox(Item).ItemIndex);

      if Item is TCheckBox then
        Reg.WriteBool(ValueName, TCheckBox(Item).Checked);

      if Item is TRadioGroup then
        Reg.WriteInteger(ValueName, TRadioGroup(Item).ItemIndex);

      if Item is TDateTimePicker then
        Reg.WriteDateTime(ValueName, TDateTimePicker(Item).DateTime);
    end;
  end;
end;


procedure LoadFormParams(Form: TForm; const RegKey: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey(RegKey, False) then
    begin
      LoadControlParams(Form.Name, Form, Reg);
    end else
    begin
      SetDefaults(Form);
    end;
  finally
    Reg.Free;
  end;
end;

procedure SaveFormParams(Form: TForm; const RegKey: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey(RegKey, True) then
    begin
      SaveControlParams(Form.Name, Form, Reg);
    end;
  finally
    Reg.Free;
  end;
end;



end.
