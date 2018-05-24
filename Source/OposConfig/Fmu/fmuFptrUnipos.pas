unit fmuFptrUnipos;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, ComCtrls,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, FptrTypes, MalinaParams;

type
  { TfmFptrUnipos }

  TfmFptrUnipos = class(TFptrPage)
    gbUniposFilter: TTntGroupBox;
    lblUniposTrailerFont: TTntLabel;
    lblUniposHeaderFont: TTntLabel;
    cbUniposTrailerFont: TTntComboBox;
    cbUniposHeaderFont: TTntComboBox;
    chbUniposFilterEnabled: TTntCheckBox;
    gbUniposPrinter: TTntGroupBox;
    lblUniposTextFont: TTntLabel;
    lblUniposPollPeriod: TTntLabel;
    cbUniposTextFont: TTntComboBox;
    edtUniposPollPeriod: TTntEdit;
    udUniposPollPeriod: TUpDown;
    chbUniposPrinterEnabled: TTntCheckBox;
    gbAntiFroudFilter: TTntGroupBox;
    lblUniposUniqueItemPrefix: TTntLabel;
    lblUniposSalesErrorText: TTntLabel;
    lblUniposRefundErrorText: TTntLabel;
    chbAntiFroudFilterEnabled: TTntCheckBox;
    edtUniposUniqueItemPrefix: TTntEdit;
    memUniposSalesErrorText: TTntMemo;
    memUniposRefundErrorText: TTntMemo;
    Label1: TTntLabel;
    edtUniposFilesPath: TTntEdit;
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
