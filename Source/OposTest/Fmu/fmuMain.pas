unit fmuMain;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  BaseForm, fmuAbout, VersionInfo, fmuFiscalPrinter, fmuCashDrawer,
  fmuPosPrinter, fmuScale;

type
  { TfmMain }

  TfmMain = class(TBaseForm)
    btnAbout: TTntButton;
    btnClose: TTntButton;
    PageControl1: TPageControl;
    tsFiscalPrinter: TTabSheet;
    tsCashDrawer: TTabSheet;
    tsPosPrinter: TTabSheet;
    tsScale: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    procedure AddTabForm(FormParent: TWinControl; FormClass: TFormClass);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Tnt_WideFormat('%s %s (OPOS v.%s)',
    [Caption, GetFileVersionInfoStr, GetOPOSVersion]);
  AddTabForm(tsFiscalPrinter, TfmFiscalPrinter);
  AddTabForm(tsCashDrawer, TfmCashDrawer);
  AddTabForm(tsPosPrinter, TfmPosPrinter);
  AddTabForm(tsScale, TfmScale);

  Caption := Caption + '  ' + GetFileVersionInfoStr;
end;

procedure TfmMain.AddTabForm(FormParent: TWinControl; FormClass: TFormClass);
var
  Form: TForm;
begin
  Form := FormClass.Create(Self);
  Form.BorderStyle := bsNone;
  Form.Parent := FormParent;
  Form.Width := FormParent.ClientHeight;
  Form.Height := FormParent.ClientHeight;
  Form.Align := alClient;
  Form.Visible := True;
end;

procedure TfmMain.btnAboutClick(Sender: TObject);
begin
  ShowAboutBox(Handle, Application.Title,
    ['Program version: ' + GetModuleVersion]);
end;

procedure TfmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
