unit fmuFptrUnipos;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, ComCtrls,
  // This
  FiscalPrinterDevice, FptrTypes, MalinaParams;

type
  { TfmFptrUnipos }

  TfmFptrUnipos = class(TFptrPage)
    gbUniposFilter: TGroupBox;
    lblUniposTrailerFont: TLabel;
    lblUniposHeaderFont: TLabel;
    cbUniposTrailerFont: TComboBox;
    cbUniposHeaderFont: TComboBox;
    chbUniposFilterEnabled: TCheckBox;
    gbUniposPrinter: TGroupBox;
    lblUniposTextFont: TLabel;
    lblUniposPollPeriod: TLabel;
    cbUniposTextFont: TComboBox;
    edtUniposPollPeriod: TEdit;
    udUniposPollPeriod: TUpDown;
    chbUniposPrinterEnabled: TCheckBox;
    gbAntiFroudFilter: TGroupBox;
    lblUniposUniqueItemPrefix: TLabel;
    lblUniposSalesErrorText: TLabel;
    lblUniposRefundErrorText: TLabel;
    chbAntiFroudFilterEnabled: TCheckBox;
    edtUniposUniqueItemPrefix: TEdit;
    memUniposSalesErrorText: TMemo;
    memUniposRefundErrorText: TMemo;
    Label1: TLabel;
    edtUniposFilesPath: TEdit;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrUnipos }

procedure TfmFptrUnipos.UpdatePage;
begin
  chbAntiFroudFilterEnabled.Checked := GetMalinaParams.AntiFroudFilterEnabled;
  chbUniposPrinterEnabled.Checked := GetMalinaParams.UniposPrinterEnabled;
  chbUniposFilterEnabled.Checked := GetMalinaParams.UniposFilterEnabled;
  cbUniposTextFont.ItemIndex := GetMalinaParams.UniposTextFont-1;
  cbUniposHeaderFont.ItemIndex := GetMalinaParams.UniposHeaderFont-1;
  cbUniposTrailerFont.ItemIndex := GetMalinaParams.UniposTrailerFont-1;
  udUniposPollPeriod.Position := GetMalinaParams.UniposPollPeriod;
  edtUniposFilesPath.Text := GetMalinaParams.UniposFilesPath;
  memUniposSalesErrorText.Text := GetMalinaParams.UniposSalesErrorText;
  memUniposRefundErrorText.Text := GetMalinaParams.UniposRefundErrorText;
  edtUniposUniqueItemPrefix.Text := GetMalinaParams.UniposUniqueItemPrefix;
end;

procedure TfmFptrUnipos.UpdateObject;
begin
  GetMalinaParams.AntiFroudFilterEnabled := chbAntiFroudFilterEnabled.Checked;
  GetMalinaParams.UniposPrinterEnabled := chbUniposPrinterEnabled.Checked;
  GetMalinaParams.UniposFilterEnabled := chbUniposFilterEnabled.Checked;
  GetMalinaParams.UniposHeaderFont := cbUniposHeaderFont.ItemIndex + 1;
  GetMalinaParams.UniposTrailerFont := cbUniposTrailerFont.ItemIndex + 1;
  GetMalinaParams.UniposTextFont := cbUniposTextFont.ItemIndex + 1;
  GetMalinaParams.UniposPollPeriod := udUniposPollPeriod.Position;
  GetMalinaParams.UniposFilesPath := edtUniposFilesPath.Text;
  GetMalinaParams.UniposSalesErrorText := memUniposSalesErrorText.Text;
  GetMalinaParams.UniposRefundErrorText := memUniposRefundErrorText.Text;
  GetMalinaParams.UniposUniqueItemPrefix := edtUniposUniqueItemPrefix.Text;
end;

procedure TfmFptrUnipos.PageChange(Sender: TObject);
begin
  Modified;
end;


end.
