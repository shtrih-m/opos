unit BaseForm;

interface

uses
  // VCL
  Windows, Forms, Classes, Controls, StdCtrls;

type
  { TBaseForm }

  TBaseForm = class(TForm)
  private
    FActiveControl: TWinControl;
  protected
    procedure ReadState(Reader: TReader); override;
  public
    procedure EnableButtons(Value: Boolean); virtual;
  end;

procedure EnableControls(WinControl: TWinControl; Value: Boolean);

implementation

procedure EnableWinControl(WinControl: TWinControl; Value: Boolean);
begin
  if WinControl is TButton then
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
  if WinControl is TButton then
  begin
    if WinControl.Focused and (not Value) then
      FocusedControl := WinControl;

    EnableWinControl(WinControl, Value);
    if Value and (FocusedControl = WinControl) and WinControl.CanFocus then
      WinControl.SetFocus;
  end;
end;

{ TBaseForm }

procedure TBaseForm.ReadState(Reader: TReader);
begin
  DisableAlign;
  try
    inherited ReadState(Reader);
    if BorderStyle = bsSizeable then
    begin
      Height := Height + GetSystemMetrics(SM_CYCAPTION) - 19 +
        (GetSystemMetrics(SM_CYSIZEFRAME)-GetSystemMetrics(SM_CYEDGE)-1)*2;

      Width := Width +
        (GetSystemMetrics(SM_CXSIZEFRAME)-GetSystemMetrics(SM_CXEDGE)-1)*2;
    end;
  finally
    EnableAlign;
  end;
end;

procedure TBaseForm.EnableButtons(Value: Boolean);
begin
  EnableControlsFocused(Self, Value, FActiveControl);
end;

end.







