unit untUtil;

interface

uses
  // This
  Classes, ComCtrls, ExtCtrls, StdCtrls, Controls, Forms, Registry,
  // Tnt
  TntStdCtrls, TntRegistry;

procedure SaveFormParams(Form: TForm; const RegKey: WideString);
procedure LoadFormParams(Form: TForm; const RegKey: WideString);
procedure EnableControlButtons(WinControl: TWinControl; Value: Boolean; var AButton: TTntButton);

implementation

procedure EnableControlButtons(WinControl: TWinControl; Value: Boolean; var AButton: TTntButton);
var
  i: Integer;
  Button: TTntButton;
  Control: TControl;
begin
  for i := 0 to WinControl.ControlCount-1 do
  begin
    Control := WinControl.Controls[i];
    if Control is TWinControl then
      EnableControlButtons(Control as TWinControl, Value, AButton);
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

procedure LoadControlParams(const Path: WideString; Control: TWinControl; Reg: TTntRegistry);
var
  i: Integer;
  Item: TControl;
  ValueName: WideString;
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
        if Item is TTntEdit and (not TTntEdit(Item).ReadOnly) then
          TTntEdit(Item).Text := Reg.ReadString(ValueName);
        if Item is TTntComboBox then
          TTntComboBox(Item).ItemIndex := Reg.ReadInteger(ValueName);
        if Item is TTntCheckBox then
          TTntCheckBox(Item).Checked := Reg.ReadBool(ValueName);
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
      if Item.ClassNameIs('TTntComboBox') then
        TTntComboBox(Item).ItemIndex := 0;
    end;
  end;
end;

procedure SaveControlParams(const Path: WideString; Control: TWinControl; Reg: TTntRegistry);
var
  i: Integer;
  EditItem: TTntEdit;
  Item: TComponent;
  ValueName: WideString;
begin
  for i := 0 to Control.ControlCount-1 do
  begin
    Item := Control.Controls[i];
    if Item is TWinControl then
    begin
      ValueName := Path + '.' + Item.Name;
      SaveControlParams(ValueName, Item as TWinControl, Reg);
      if Item is TTntEdit then
      begin
        EditItem := Item as TTntEdit;
        if not EditItem.ReadOnly then
        Reg.WriteString(ValueName, EditItem.Text);
      end;

      if Item is TTntComboBox then
        Reg.WriteInteger(ValueName, TTntComboBox(Item).ItemIndex);

      if Item is TTntCheckBox then
        Reg.WriteBool(ValueName, TTntCheckBox(Item).Checked);

      if Item is TRadioGroup then
        Reg.WriteInteger(ValueName, TRadioGroup(Item).ItemIndex);

      if Item is TDateTimePicker then
        Reg.WriteDateTime(ValueName, TDateTimePicker(Item).DateTime);
    end;
  end;
end;


procedure LoadFormParams(Form: TForm; const RegKey: WideString);
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
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

procedure SaveFormParams(Form: TForm; const RegKey: WideString);
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
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
