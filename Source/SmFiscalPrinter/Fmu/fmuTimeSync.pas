unit fmuTimeSync;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngBitBtn, ExtCtrls, DateUtils,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  BaseForm;

type
  TfmTimeSync = class(TBaseForm)
    lblTimeSync: TTntLabel;
    Label1: TTntLabel;
    btnCancel: TPngBitBtn;
    lblTimeLeft: TTntLabel;
    Timer: TTimer;
    Label2: TTntLabel;
    procedure TimerTimer(Sender: TObject);
  private
    FSTime: TDateTime;
    CancelEnabled: Boolean;
    procedure UpdatePage;
  end;

var
  fmTimeSync: TfmTimeSync;

function ShowTimeDialog(FSTime: TDateTime; CancelEnabled: Boolean): Boolean;

implementation

{$R *.dfm}

function ShowTimeDialog(FSTime: TDateTime; CancelEnabled: Boolean): Boolean;
var
  fmTimeSync: TfmTimeSync;
begin
  fmTimeSync := TfmTimeSync.Create(nil);
  try
    fmTimeSync.Left := Screen.Width - fmTimeSync.Width;
    fmTimeSync.Top := (Screen.Height - fmTimeSync.Height) div 2;
    fmTimeSync.FSTime := Frac(FSTime);
    fmTimeSync.CancelEnabled := CancelEnabled;
    fmTimeSync.UpdatePage;
    Result := fmTimeSync.ShowModal = mrOK;
  finally
    fmTimeSync.Free;
  end;
end;

{ TfmTimeSync }

procedure TfmTimeSync.UpdatePage;
var
  PCTime: TDateTime;
  Hour, Min, Sec, MSec: Word;
begin
  PCTime := Frac(Time);
  if PCTime >= FSTime then
  begin
    ModalResult := mrOK;
    Exit;
  end;
  DecodeTime(FSTime - PCTime, Hour, Min, Sec, MSec);
  lblTimeLeft.Caption := Tnt_WideFormat('%.2d:%.2d', [Min, Sec]);
end;

procedure TfmTimeSync.TimerTimer(Sender: TObject);
begin
  UpdatePage;
end;

end.
