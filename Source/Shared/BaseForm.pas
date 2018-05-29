unit BaseForm;

interface

uses
  // VCL
  Windows, Forms, Classes, Controls, StdCtrls,
  // Tnt
  TntForms, TntStdCtrls, TntComCtrls, TntExtCtrls, TntClasses,
  gnugettext;

type
  { TBaseForm }

  TBaseForm = class(TTntForm)
  private
    FActiveControl: TWinControl;
  public
    procedure EnableButtons; overload;
    procedure DisableButtons;
    procedure EnableButtons(Value: Boolean); overload; virtual; 
    constructor Create(AOwner: TComponent); override;
  end;

procedure EnableControls(WinControl: TWinControl; Value: Boolean);

implementation

procedure EnableWinControl(WinControl: TWinControl; Value: Boolean);
begin
  if WinControl is TTntButton then
  begin
    if (not Value)and WinControl.Enabled then
    begin
      WinControl.Tag := 1;
      WinControl.Enabled := False;
    end;
    if Value and (WinControl.Tag = 1) then
    begin
      WinControl.Tag := 0;
      WinControl.Enabled := True;
    end;
  end;
end;

// Запрещение оконных элементов управления

procedure EnableControls(WinControl: TWinControl; Value: Boolean);
var
  i: Integer;
  Control: TControl;
begin
  for i := 0 to WinControl.ControlCount - 1 do
  begin
    Control := WinControl.Controls[i];
    if Control is TWinControl then
      EnableControls(Control as TWinControl, Value);
  end;
  EnableWinControl(WinControl, Value);
end;

procedure EnableControlsFocused(WinControl: TWinControl; Value: Boolean;
  var FocusedControl: TWinControl);
var
  i: Integer;
  Control: TControl;
begin
  for i := 0 to WinControl.ControlCount - 1 do
  begin
    Control := WinControl.Controls[i];
    if Control is TWinControl then
      EnableControlsFocused(Control as TWinControl, Value, FocusedControl);
  end;
  if WinControl is TTntButton then
  begin
    // Запоминаем
    if WinControl.Focused and (not Value) then
      FocusedControl := WinControl;

    EnableWinControl(WinControl, Value);
    // Устанавливаем
    if Value and (FocusedControl = WinControl) and WinControl.CanFocus then
      WinControl.SetFocus;
  end;
end;

{ TBaseForm }

constructor TBaseForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TranslateComponent(Self);
end;

procedure TBaseForm.EnableButtons(Value: Boolean);
begin
  EnableControlsFocused(Self, Value, FActiveControl);
end;


procedure TBaseForm.EnableButtons;
begin
  EnableControlsFocused(Self, True, FActiveControl);
end;

procedure TBaseForm.DisableButtons;
begin
  EnableControlsFocused(Self, False, FActiveControl);
end;

end.
