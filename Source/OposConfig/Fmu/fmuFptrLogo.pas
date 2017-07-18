unit fmuFptrLogo;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, Classes, SysUtils, Registry, Dialogs, Forms,
  ComCtrls, Buttons, ExtDlgs, ExtCtrls, ComObj,
  // This
  FiscalPrinterDevice, PrinterParameters, PrinterParametersX, FptrTypes,
  DirectIOAPI, DriverContext;

type
  { TfmFptrLogo }

  TfmFptrLogo = class(TFptrPage)
    OpenPictureDialog: TOpenPictureDialog;
    GroupBox1: TGroupBox;
    Image: TImage;
    Bevel1: TBevel;
    lblLogoPosition: TLabel;
    lblLogoSize: TLabel;
    lblProgress: TLabel;
    cbLogoPosition: TComboBox;
    edtLogoSize: TEdit;
    btnPrintLogo: TButton;
    btnLoad: TBitBtn;
    btnOpen: TBitBtn;
    chbLogoCenter: TCheckBox;
    ProgressBar: TProgressBar;
    chbLogoReloadEnabled: TCheckBox;
    procedure PageChange(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintLogoClick(Sender: TObject);
  private
    procedure UpdateLogoSize;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;

    procedure DirectIOEvent(Sender: TObject; EventNumber: Integer;
      var pData: Integer; var pWideString: WideString);
  end;

implementation

{$R *.DFM}

{ TfmFptrLogo }

procedure TfmFptrLogo.UpdatePage;
begin
  chbLogoCenter.Checked := Parameters.LogoCenter;
  chbLogoReloadEnabled.Checked := Parameters.LogoReloadEnabled;
  edtLogoSize.Text := IntToStr(Parameters.LogoSize);
  cbLogoPosition.ItemIndex := Parameters.LogoPosition;
end;

procedure TfmFptrLogo.UpdateObject;
begin
  Parameters.LogoCenter := chbLogoCenter.Checked;
  Parameters.LogoReloadEnabled := chbLogoReloadEnabled.Checked;
  Parameters.LogoSize := StrToInt(edtLogoSize.Text);
  Parameters.LogoPosition := cbLogoPosition.ItemIndex;
end;

procedure TfmFptrLogo.btnOpenClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
    Image.Picture.LoadFromFile(OpenPictureDialog.FileName);
end;

procedure TfmFptrLogo.DirectIOEvent(Sender: TObject; EventNumber: Integer;
  var pData: Integer; var pWideString: WideString);
begin
  case EventNumber of
    DIRECTIO_EVENT_PROGRESS:
    begin
      ProgressBar.Position := pData;
      lblProgress.Caption := Format('Load status: %d%%', [pData]);
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfmFptrLogo.btnLoadClick(Sender: TObject);
var
  pData: Integer;
  pWideString: WideString;
  Driver: OleVariant;
begin
  ProgressBar.Position := 0;
  lblProgress.Caption := '';

  EnableButtons(False);
  try
    UpdateObject;

    Driver := CreateOleObject('OPOS.FiscalPrinter');
    try
      Check(Driver, Driver.Open(Device.DeviceName));
      Check(Driver, Driver.ClaimDevice(0));
      Driver.DeviceEnabled := True;
      Check(Driver, Driver.ResultCode);
      //Driver.OnDirectIOEvent := DirectIOEvent; { !!! }
      // Start loading
      pData := 0;
      pWideString := OpenPictureDialog.FileName;
      Check(Driver, Driver.DirectIO(DIO_LOAD_LOGO, pData, pWideString));
      // update progress
      LoadParameters(Parameters, Device.DeviceName, Logger  );
      UpdateLogoSize;
    finally
      Driver.Close;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrLogo.UpdateLogoSize;
var
  Context: TDriverContext;
begin
  Context := TDriverContext.Create;
  try
    LoadParameters(Context.Parameters, Device.DeviceName, Context.Logger);
    Parameters.LogoSize := Context.Parameters.LogoSize;
    edtLogoSize.Text := IntToStr(Parameters.LogoSize);
  finally
    Context.Free;
  end;
end;

procedure TfmFptrLogo.FormCreate(Sender: TObject);
begin
  lblProgress.Caption := '';
  OpenPictureDialog.InitialDir := ExtractFilePath(ParamStr(0));
end;

procedure TfmFptrLogo.btnPrintLogoClick(Sender: TObject);
var
  pData: Integer;
  pWideString: WideString;
  Driver: OleVariant;
begin
  EnableButtons(False);
  try
    Driver := CreateOleObject('OPOS.FiscalPrinter');
    try
      Check(Driver, Driver.Open(DeviceName));
      Check(Driver, Driver.ClaimDevice(0));
      Driver.DeviceEnabled := True;
      Check(Driver, Driver.ResultCode);

      pData := 0;
      pWideString := '';
      Check(Driver, Driver.DirectIO(DIO_PRINT_LOGO, pData, pWideString));
    finally
      Driver.Close;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrLogo.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
