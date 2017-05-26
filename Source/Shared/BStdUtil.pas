unit BStdUtil;

interface

uses
  Classes, StdCtrls, ExtCtrls, ComCtrls;

// Процедура устанавливает переключатель у TCheckBox
// На время установки блокируется обработчик события OnClick
procedure SafeSetChecked(CheckBox: TCheckBox; Value: Boolean);
procedure SafeSetRadioButton(RadioButton: TRadioButton; Value: Boolean);
// Процедура устанавливает переключатель у TRadioGroup
procedure SafeSetRadioGroup(RadioGroup: TRadioGroup; Value: Integer);
// Процедура устанавливает свойство Text у TEdit
procedure SafeSetEdit(Edit: TCustomEdit; const Value: String);
// Процедура устанавливает свойство ItemIndex у TComboBox
procedure SafeSetComboBox(ComboBox: TComboBox; Value: Integer);
// Устанавливает свойство Lines у Memo
procedure SafeSetMemo(Memo: TMemo; Strings: TStrings);
procedure SafeSetUpDown(UpDown: TUpDown; const Value: Integer);
procedure SafeSetListBox(ListBox: TListBox; Value: Integer);
procedure StatusBarClear(StatusBar: TStatusBar);
procedure EditorsClear(Editors: Array of TCustomEdit);

implementation

{ SafeSetChecked }

procedure SafeSetChecked(CheckBox: TCheckBox; Value: Boolean);
var
  SaveOnClick: TNotifyEvent;
begin
  SaveOnClick := CheckBox.OnClick;
  CheckBox.OnClick := nil;
  try
    CheckBox.Checked := Value;
  finally
    CheckBox.OnClick := SaveOnClick;
  end;
end;

{ SafeSetRadioButton }

procedure SafeSetRadioButton(RadioButton: TRadioButton; Value: Boolean);
var
  SaveOnClick: TNotifyEvent;
begin
  SaveOnClick := RadioButton.OnClick;
  RadioButton.OnClick := nil;
  try
    RadioButton.Checked := Value;
  finally
    RadioButton.OnClick := SaveOnClick;
  end;
end;

{ SafeSetRadioGroup }

procedure SafeSetRadioGroup(RadioGroup: TRadioGroup; Value: Integer);
var
  SaveOnClick: TNotifyEvent;
begin
  SaveOnClick := RadioGroup.OnClick;
  RadioGroup.OnClick := nil;
  try
    RadioGroup.ItemIndex := Value;
  finally
    RadioGroup.OnClick := SaveOnClick;
  end;
end;

procedure SafeSetComboBox(ComboBox: TComboBox; Value: Integer);
var
  SaveOnChange: TNotifyEvent;
begin
  SaveOnChange := ComboBox.OnChange;
  ComboBox.OnChange := nil;
  try
    ComboBox.ItemIndex := Value;
  finally
    ComboBox.OnChange := SaveOnChange;
  end;
end;

procedure SafeSetListBox(ListBox: TListBox; Value: Integer);
var
  SaveOnChange: TNotifyEvent;
begin
  SaveOnChange := ListBox.OnClick;
  ListBox.OnClick := nil;
  try
    ListBox.ItemIndex := Value;
  finally
    ListBox.OnClick := SaveOnChange;
  end;
end;

procedure SafeSetMemo(Memo: TMemo; Strings: TStrings);
var
  SaveOnChange: TNotifyEvent;
begin
  SaveOnChange := Memo.OnChange;
  Memo.OnChange := nil;
  try
    Memo.Lines := Strings;
  finally
    Memo.OnChange := SaveOnChange;
  end;
end;

type
  TExposeCustomEdit = class(TCustomEdit)
  public
    property OnChange;
  end;

procedure SafeSetEdit(Edit: TCustomEdit; const Value: String);
var
  SaveOnChange: TNotifyEvent;
  TmpEdit: TExposeCustomEdit;
begin
  TmpEdit := TExposeCustomEdit(Edit);
  SaveOnChange := TmpEdit.OnChange;
  TmpEdit.OnChange := nil;
  try
    TmpEdit.Text := Value;
  finally
    TmpEdit.OnChange := SaveOnChange;
  end;
end;

{ SafeSetUpDown }

procedure SafeSetUpDown(UpDown: TUpDown; const Value: Integer);
var
  SaveOnClick: TUDClickEvent;
begin
  SaveOnClick := UpDown.OnClick;
  UpDown.OnClick := nil;
  try
    UpDown.Position := Value;
  finally
    UpDown.OnClick := SaveOnClick;
  end;
end;

procedure StatusBarClear(StatusBar: TStatusBar);
var
  I: Integer;
begin
  for I := 0 to StatusBar.Panels.Count - 1 do
  begin
    StatusBar.Panels[I].Text := '';
  end;
end;

procedure EditorsClear(Editors: Array of TCustomEdit);
var
  I: Integer;
begin
  for I := Low(Editors) to High(Editors) do Editors[I].Clear;
end;

end.
