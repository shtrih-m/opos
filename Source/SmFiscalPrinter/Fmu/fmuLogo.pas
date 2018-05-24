unit fmuLogo;

interface

uses
  // VCL
  Windows, Messages, StdCtrls, Controls, Classes, SysUtils, Registry, Dialogs,
  Forms, ComCtrls, Buttons, ExtDlgs, ExtCtrls, Graphics,
  // Tnt
  TntStdCtrls, TntSysUtils, TntButtons, 
  // This
  FiscalPrinterImpl, Opos, Oposhi, OposUtils, untUtil, FiscalPrinterDevice,
  FiscalPrinterTypes, PrinterParameters;

const
  WM_NOTIFY = WM_USER + 1;

type
  { TfmLogo }

  TfmLogo = class(TForm)
    btnClose: TTntButton;
    OpenPictureDialog: TOpenPictureDialog;
    btnOpen: TTntBitBtn;
    btnLoad: TTntBitBtn;
    btnPrint: TTntBitBtn;
    Panel1: TPanel;
    lblMaxImageSize: TTntLabel;
    lblInfo1: TTntLabel;
    lblImageSize: TTntLabel;
    edtImageSize: TTntEdit;
    edtMaxImageSize: TTntEdit;
    lblWarn: TTntLabel;
    imgWarn: TImage;
    Panel2: TPanel;
    Image: TImage;
    lblProgress: TTntLabel;
    chbLogoCenter: TTntCheckBox;
    procedure btnLoadClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    FButton: TTntButton;
    FPrinter: TFiscalPrinterImpl;
    FApplicationTitle: string;
    FApplicationHandle: THandle;

    procedure UpdatePage;
    function GetDevice: IFiscalPrinterDevice;

    property Printer: TFiscalPrinterImpl read FPrinter;
    property Device: IFiscalPrinterDevice read GetDevice;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure ShowLogoDialog(APrinter: TFiscalPrinterImpl);

implementation

{$R *.DFM}

procedure ShowLogoDialog(APrinter: TFiscalPrinterImpl);
var
  fm: TfmLogo;
begin
  fm := TfmLogo.Create(nil);
  try
    SetWindowLong(fm.Handle, GWL_HWNDPARENT, GetActiveWindow);
    fm.FPrinter := APrinter;
    fm.UpdatePage;
    fm.ShowModal;
  finally
    fm.Free;
  end;
end;

{ TfmLogo }

constructor TfmLogo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FApplicationHandle := Application.Handle;
  FApplicationTitle := Application.Title;

  Application.Handle := Handle;
  Application.Title := 'Logo loading';
end;

destructor TfmLogo.Destroy;
begin
  Application.Title := FApplicationTitle;
  Application.Handle := FApplicationHandle;
  inherited Destroy;
end;

function TfmLogo.GetDevice: IFiscalPrinterDevice;
begin
  Result := Printer.Printer.Device;
end;

procedure TfmLogo.UpdatePage;
begin
  chbLogoCenter.Checked := Device.Parameters.LogoCenter;
  edtMaxImageSize.Text := Tnt_WideFormat('%d x %d', [Device.GetModel.MaxGraphicsWidth,
    Device.GetModel.MaxGraphicsHeight]);

  lblProgress.Caption := '';
  OpenPictureDialog.InitialDir := ExtractFilePath(ParamStr(0));
end;

procedure TfmLogo.btnLoadClick(Sender: TObject);
begin
  btnLoad.Enabled := False;
  try
    Device.Parameters.LogoCenter := chbLogoCenter.Checked;
    Printer.LoadLogo(OpenPictureDialog.FileName);
  except
    on E: Exception do
    begin
      Application.HandleException(E);
    end;
  end;
  btnLoad.Enabled := True;
  btnLoad.setFocus;
end;

procedure TfmLogo.btnOpenClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
  begin
    Image.Picture.LoadFromFile(OpenPictureDialog.FileName);
    edtImageSize.Text := Tnt_WideFormat('%d x %d', [Image.Picture.Width,
      Image.Picture.Height]);
    lblWarn.Caption := 'Image size more than maximum';
  end;
end;

procedure TfmLogo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmLogo.btnPrintClick(Sender: TObject);
begin
  EnableButtons(Self, False, FButton);
  try
    Printer.PrintLogo;
  finally
    EnableButtons(Self, True, FButton);
  end;
end;

end.
