unit fmuEMail;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngBitBtn, ExtCtrls, Mask,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  LogFile, PngImageList, ImgList, JvExButtons, JvBitBtn, JvImageList,
  ActnList, PngSpeedButton, FormUtils;

const
  /////////////////////////////////////////////////////////////////////////////
  // Language constants

  LanguageRussian   = 0;
  LanguageEnglish   = 1;

type
  TVButton = class;
  TTextButton = class;
  TTntButtonType = (btText, btBackspace, btShift, btRu, btEn);
  TSpeedButtons = array [0..27] of TSpeedButton;

  { TfmEMail }

  TfmEMail = class(TForm)
    btnOK: TPngSpeedButton;
    btnCancel: TPngSpeedButton;
    Label1: TTntLabel;
    edtAddress: TTntEdit;
    ImageList: TImageList;
    pnlEn1: TPanel;
    pnlEn2: TPanel;
    pnlRu1: TPanel;
    pnlRu2: TPanel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FLanguage: Integer;
    FButtons: TComponent;
    FPageIndex: Integer;
    FButtonIndex: Integer;
    FShiftPressed: Boolean;
    FSpeedButtons: array [0..3] of TSpeedButtons;
    FPages: array [0..3] of TPanel;

    procedure AddButton(const S1, S2: WideString);
    function CreateButton(AOwner: TPanel): TSpeedButton;
    procedure ButtonClick(Sender: TObject);
    procedure AddButton3(const S: WideString);
    procedure UpdatePage2;
    procedure AddButton2(ImageIndex: Integer; ButtonType: TTntButtonType);
    function CreateTextButton(const Text: WideString): TTextButton;
    function CreateVButton(ButtonType: TTntButtonType): TVButton;
    procedure SendString(const S: WideString);
    procedure SendVirtualKey(VK: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdatePage(const Data: WideString);
    procedure UpdateObject(var Data: WideString);
  end;

  { TVButton }

  TVButton = class(TComponent)
  public
    ButtonType: TTntButtonType;
  end;

  { TTextButton }

  TTextButton = class(TVButton)
  public
    Text: WideString;
  end;

var
  fmEMail: TfmEMail;

function ShowEMailDlg(var AData: WideString): Boolean;

implementation

{$R *.dfm}

const
  	VK_OEM_PLUS = $BB;

function ShowEMailDlg(var AData: WideString): Boolean;
begin
  fmEMail := TfmEMail.Create(Application);
  try
    DisableForms(fmEMail.Handle);
    SetForegroundWindow(fmEMail.Handle);
    BringWindowToTop(fmEMail.Handle);

    fmEMail.Left := Screen.Width - fmEMail.Width;
    fmEMail.Top := (Screen.Height - fmEMail.Height) div 2;
    fmEMail.UpdatePage(AData);
    Result := fmEMail.ShowModal = mrOK;
    if Result then
    begin
      fmEMail.UpdateObject(AData);
    end;
  finally
    EnableForms;
    fmEMail.Free;
  end;
end;

{ TfmEMail }

constructor TfmEMail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtons := TComponent.Create(Self);
  FPages[0] := pnlEn1;
  FPages[1] := pnlEn2;
  FPages[2] := pnlRu1;
  FPages[3] := pnlRu2;
end;

destructor TfmEMail.Destroy;
begin
  FButtons.Free;
  inherited Destroy;
end;

procedure TfmEMail.SendVirtualKey(VK: Integer);
begin
  PostMessage(edtAddress.Handle, WM_KEYDOWN, VK, 0);
end;

procedure TfmEMail.SendString(const S: WideString);
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    PostMessage(edtAddress.Handle, WM_CHAR, Ord(S[i]), 0);
end;

procedure TfmEMail.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TfmEMail.UpdatePage(const Data: WideString);
begin
  edtAddress.Text := Data;
end;

procedure TfmEMail.UpdateObject(var Data: WideString);
begin
  Data := edtAddress.Text;
end;

const
  ButtonWidth = 54;


function TfmEMail.CreateButton(AOwner: TPanel): TSpeedButton;
var
  Button: TSpeedButton;
begin
  Button := TSpeedButton.Create(AOwner);
  Button.Parent := AOwner;
  Button.Width := ButtonWidth;
  Button.Height := ButtonWidth;
  Button.Left := 8 + (FButtonIndex mod 4)*ButtonWidth;
  Button.Top := 8 + (FButtonIndex div 4)*ButtonWidth;
  Button.OnClick := ButtonClick;
  Result := Button;
end;

function TfmEMail.CreateTextButton(const Text: WideString): TTextButton;
begin
  Result := TTextButton.Create(FButtons);
  Result.Text := Text;
  Result.ButtonType := btText;
end;

function TfmEMail.CreateVButton(ButtonType: TTntButtonType): TVButton;
begin
  Result := TVButton.Create(FButtons);
  Result.ButtonType := ButtonType;
end;

procedure TfmEMail.AddButton(const S1, S2: WideString);

  procedure CreateButtonImage(Bitmap: TBitmap; const S1, S2: WideString;
    Color1, Color2: TColor);
  begin
    Bitmap.Width := ButtonWidth-4;
    Bitmap.Height := ButtonWidth-4;
    Bitmap.PixelFormat := pf24bit;
    Bitmap.Transparent := True;
    Bitmap.Canvas.Font.Name := 'Arial';
    Bitmap.Canvas.Font.Size := 18;
    Bitmap.Canvas.Font.Color := Color1;
    Bitmap.Canvas.Font.Style := [fsBold];
    Bitmap.Canvas.TextOut(3, 1, S1);
    Bitmap.Canvas.Font.Color := Color2;
    Bitmap.Canvas.TextOut(25, 18, S2);
  end;

var
  Button: TSpeedButton;
begin
  Button := CreateButton(FPages[FPageIndex]);
  Button.Tag := Integer(CreateTextButton(S1));
  CreateButtonImage(Button.Glyph, S1, S2, clBlack, RGB(245, 110, 101));
  FSpeedButtons[FPageIndex][FButtonIndex] := Button;

  Button := CreateButton(FPages[FPageIndex+1]);
  Button.Tag := Integer(CreateTextButton(S2));
  CreateButtonImage(Button.Glyph, S1, S2, RGB(128, 128, 128), clRed);
  FSpeedButtons[FPageIndex+1][FButtonIndex] := Button;

  Inc(FButtonIndex);
end;

procedure TfmEMail.AddButton2(ImageIndex: Integer; ButtonType: TTntButtonType);
var
  Button: TSpeedButton;
  GroupIndex: Integer;
const
  LastGroupIndex: Integer = 0;
begin
  GroupIndex := 0;
  if ButtonType in [btShift, btRu, btEn] then
  begin
    Inc(LastGroupIndex);
    GroupIndex := LastGroupIndex;
  end;

  Button := CreateButton(FPages[FPageIndex]);
  Button.Tag := Integer(CreateVButton(ButtonType));
  Button.AllowAllUp := True;
  ImageList.GetBitmap(ImageIndex, Button.Glyph);
  FSpeedButtons[FPageIndex][FButtonIndex] := Button;

  Button := CreateButton(FPages[FPageIndex+1]);
  Button.Tag := Integer(CreateVButton(ButtonType));
  Button.GroupIndex := GroupIndex;
  Button.AllowAllUp := True;
  ImageList.GetBitmap(ImageIndex, Button.Glyph);
  FSpeedButtons[FPageIndex+1][FButtonIndex] := Button;

  Inc(FButtonIndex);
end;


procedure TfmEMail.AddButton3(const S: WideString);

  procedure CreateButtonImage(Bitmap: TBitmap; const S: WideString);
  begin
    Bitmap.Width := ButtonWidth-4;
    Bitmap.Height := ButtonWidth-4;
    Bitmap.PixelFormat := pf24bit;
    Bitmap.Transparent := True;
    Bitmap.Canvas.Font.Name := 'Arial';
    Bitmap.Canvas.Font.Size := 12;
    Bitmap.Canvas.Font.Color := clBlack;
    Bitmap.Canvas.Font.Style := [fsBold];
    Bitmap.Canvas.TextOut(3, 15, S);
  end;

var
  Button: TSpeedButton;
begin
  Button := CreateButton(FPages[FPageIndex]);
  Button.Tag := Integer(CreateTextButton(S));
  CreateButtonImage(Button.Glyph, S);
  FSpeedButtons[FPageIndex][FButtonIndex] := Button;

  Button := CreateButton(FPages[FPageIndex+1]);
  Button.Tag := Integer(CreateTextButton(S));
  CreateButtonImage(Button.Glyph, S);
  FSpeedButtons[FPageIndex+1][FButtonIndex] := Button;

  Inc(FButtonIndex);
end;

procedure TfmEMail.FormCreate(Sender: TObject);

  procedure CreatePageEn;
  begin
    FPageIndex := 0;
    FButtonIndex := 0;

    AddButton('1', '2');
    AddButton('3', '4');
    AddButton('5', '6');
    AddButton2(0, btBackspace);
    AddButton('7', '8');
    AddButton('9', '0');
    AddButton('.', '-');
    AddButton('@', '_');
    AddButton('A', 'B');
    AddButton('C', 'D');
    AddButton('E', 'F');
    AddButton('G', 'H');
    AddButton('I', 'J');
    AddButton('K', 'L');
    AddButton('M', 'N');
    AddButton('O', 'P');
    AddButton('Q', 'R');
    AddButton('S', 'T');
    AddButton('U', 'V');
    AddButton('W', 'X');
    AddButton('Y', 'Z');
    AddButton3('.RU');
    AddButton3('.COM');
    AddButton3('.NET');
    AddButton2(1, btShift);
    AddButton3('.ORG');
    AddButton3('.INFO');
    AddButton2(3, btRu);
  end;

  procedure CreatePageRu;
  begin
    FPageIndex := 2;
    FButtonIndex := 0;

    AddButton('1', '2');
    AddButton('3', '4');
    AddButton('5', '6');
    AddButton2(0, btBackspace);
    AddButton('7', '8');
    AddButton('9', '0');
    AddButton('.', '-');
    AddButton('@', '_');
    AddButton('Р', 'С');
    AddButton('Т', 'У');
    AddButton('Ф', 'Х');
    AddButton('Ј', 'Ц');
    AddButton('Ч', 'Ш');
    AddButton('Щ', 'Ъ');
    AddButton('Ы', 'Ь');
    AddButton('Э', 'Ю');
    AddButton('Я', 'а');
    AddButton('б', 'в');
    AddButton('г', 'д');
    AddButton('е', 'ж');
    AddButton('з', 'и');
    AddButton('й', 'к');
    AddButton('л', 'м');
    AddButton('н', 'о');
    AddButton2(1, btShift);
    AddButton('п', '');
    AddButton3('.ад');
    AddButton2(2, btEn);
  end;

begin
  FShiftPressed := False;
  FLanguage := LanguageEnglish;

  CreatePageEn;
  CreatePageRu;
  UpdatePage2;
end;

procedure TfmEMail.ButtonClick(Sender: TObject);
var
  Button: TSpeedButton;
  VButton: TVButton;
begin
  Button := Sender as TSpeedButton;
  VButton := TVButton(Button.Tag);
  case VButton.ButtonType of
    btText:
    begin
      SendString((VButton as TTextButton).Text);
    end;
    btShift:
    begin
      FShiftPressed := not FShiftPressed;
    end;
    btBackspace: SendVirtualKey(VK_BACK);
    btRu: FLanguage := LanguageRussian;
    btEn: FLanguage := LanguageEnglish;
  end;
  UpdatePage2;
end;

procedure TfmEMail.UpdatePage2;
begin
  FPages[0].Visible := (FLanguage = LanguageEnglish) and (not FShiftPressed);
  FPages[1].Visible := (FLanguage = LanguageEnglish) and FShiftPressed;
  FPages[2].Visible := (FLanguage = LanguageRussian) and (not FShiftPressed);
  FPages[3].Visible := (FLanguage = LanguageRussian) and FShiftPressed;
  FSpeedButtons[1][24].Down := True;
  FSpeedButtons[2][24].Down := True;
  FSpeedButtons[3][24].Down := True;
end;

procedure TfmEMail.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
