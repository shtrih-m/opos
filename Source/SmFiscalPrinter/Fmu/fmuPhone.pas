unit fmuPhone;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngBitBtn, ExtCtrls, Mask,
  // 3'd
  TntStdCtrls, TntSysUtils, TntComCtrls, TntExtCtrls,
  // This
  BaseForm, LogFile, PngSpeedButton, FormUtils;

type
  { TfmPhone }

  TfmPhone = class(TBaseForm)
    btnOK: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    Label1: TTntLabel;
    pnlKeyboard: TTntPanel;
    btn2: TPngSpeedButton;
    btn3: TPngSpeedButton;
    btn4: TPngSpeedButton;
    btn5: TPngSpeedButton;
    btn6: TPngSpeedButton;
    btn7: TPngSpeedButton;
    btn8: TPngSpeedButton;
    btn9: TPngSpeedButton;
    btn0: TPngSpeedButton;
    btnBack: TPngSpeedButton;
    edtAddress: TTntEdit;
    btnPlus: TPngSpeedButton;
    btn1: TPngSpeedButton;
    procedure btnOKClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn0Click(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
    procedure edtAddressKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
  private
    procedure SendVirtualKey(VK: Integer);
    procedure SendString(const S: WideString);
  public
    procedure UpdatePage(const Data: WideString);
    procedure UpdateObject(var Data: WideString);
  end;

var
  fmPhone: TfmPhone;

function ShowPhoneDlg(var AData: WideString): Boolean;

implementation

{$R *.dfm}

const
  	VK_OEM_PLUS = $BB;

function ShowPhoneDlg(var AData: WideString): Boolean;
begin
  fmPhone := TfmPhone.Create(Application);
  try
    DisableForms(fmPhone.Handle);
    SetForegroundWindow(fmPhone.Handle);
    BringWindowToTop(fmPhone.Handle);

    fmPhone.Left := Screen.Width - fmPhone.Width;
    fmPhone.Top := (Screen.Height - fmPhone.Height) div 2;
    fmPhone.UpdatePage(AData);
    Result := fmPhone.ShowModal = mrOK;
    if Result then
    begin
      fmPhone.UpdateObject(AData);
    end;
  finally
    EnableForms;
    fmPhone.Free;
  end;
end;

{ TfmPhone }

procedure TfmPhone.SendVirtualKey(VK: Integer);
begin
  PostMessage(edtAddress.Handle, WM_KEYDOWN, VK, 0);
end;

procedure TfmPhone.SendString(const S: WideString);
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    PostMessage(edtAddress.Handle, WM_CHAR, Ord(S[i]), 0);
end;

procedure TfmPhone.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmPhone.UpdatePage(const Data: WideString);
begin
  edtAddress.Text := Data;
  SendVirtualKey(VK_END);
end;

procedure TfmPhone.UpdateObject(var Data: WideString);
begin
  Data := edtAddress.Text;
end;

procedure TfmPhone.btn1Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD1);
end;

procedure TfmPhone.btn2Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD2);
end;

procedure TfmPhone.btn3Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD3);
end;

procedure TfmPhone.btn4Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD4);
end;

procedure TfmPhone.btn5Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD5);
end;

procedure TfmPhone.btn6Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD6);
end;

procedure TfmPhone.btn7Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD7);
end;

procedure TfmPhone.btn8Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD8);
end;

procedure TfmPhone.btn9Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD9);
end;

procedure TfmPhone.btn0Click(Sender: TObject);
begin
  SendVirtualKey(VK_NUMPAD0);
end;

procedure TfmPhone.btnBackClick(Sender: TObject);
begin
  SendVirtualKey(VK_BACK);
end;

procedure TfmPhone.btnPlusClick(Sender: TObject);
begin
  SendString('+');
end;

procedure TfmPhone.edtAddressKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '+')and (Pos('+', edtAddress.Text) <> 0) then
  begin
    Key := #0;
    Exit;
  end;

  if not(Ord(Key) in [Ord('0')..Ord('9'), Ord('+'), VK_DELETE, VK_INSERT, VK_HELP, VK_PRIOR, VK_NEXT,
    VK_END, VK_HOME, VK_LEFT, VK_RIGHT, VK_BACK]) then
  begin
    Key := #0;
    Exit;
  end;
end;

procedure TfmPhone.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
