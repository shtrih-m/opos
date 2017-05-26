unit fmuSelect;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,
  // Png
  PngBitBtn,
  // This
  LogFile, FormUtils;

type
  TfmSelect = class(TForm)
    btnPhone: TPngBitBtn;
    btnEMail: TPngBitBtn;
    btnCancel: TPngBitBtn;
    procedure btnPhoneClick(Sender: TObject);
    procedure btnEMailClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FSelection: Integer;
  end;

const
  SelectNone  = 0;
  SelectPhone = 1;
  SelectEMail = 2;

function ShowSelectDlg: Integer;

implementation

{$R *.dfm}

function ShowSelectDlg: Integer;
var
  fmSelect: TfmSelect;
begin
  fmSelect := TfmSelect.Create(Application);
  try
    DisableForms(fmSelect.Handle);
    SetForegroundWindow(fmSelect.Handle);
    BringWindowToTop(fmSelect.Handle);

    fmSelect.Left := Screen.Width - fmSelect.Width;
    fmSelect.Top := (Screen.Height - fmSelect.Height) div 2;
    Result := SelectNone;
    if fmSelect.ShowModal = mrOK then
      Result := fmSelect.FSelection;
  finally
    EnableForms;
    fmSelect.Free;
  end;
end;

{ TfmSelect }

procedure TfmSelect.btnPhoneClick(Sender: TObject);
begin
  FSelection := SelectPhone;
  ModalResult := mrOK;
end;

procedure TfmSelect.btnEMailClick(Sender: TObject);
begin
  FSelection := SelectEMail;
  ModalResult := mrOK;
end;

procedure TfmSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
