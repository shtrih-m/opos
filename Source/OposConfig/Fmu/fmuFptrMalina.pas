unit fmuFptrMalina;

interface

uses
  // VCL
  StdCtrls, pngimage, Controls, ExtCtrls, Classes, SysUtils,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, MalinaReceipt, FptrTypes, MalinaParams, Spin;

type
  { TfmFptrMalina }

  TfmFptrMalina = class(TFptrPage)
    memReceipt: TTntMemo;
    Image1: TImage;
    chbMalinaFilterEnabled: TTntCheckBox;
    edtMalinaCardPrefix: TTntEdit;
    edtMalinaPromoText: TTntEdit;
    edtMalinaRegistryKey: TTntEdit;
    chbMalinaClearRegistry: TTntCheckBox;
    lblMalinaRegistryKey: TTntLabel;
    lblMalinaPromoText: TTntLabel;
    lblMalinaCardPrefix: TTntLabel;
    lblMalinaCoefficient: TTntLabel;
    lblMalinaPoints: TTntLabel;
    seMalinaCoefficient: TSpinEdit;
    seMalinaPoints: TSpinEdit;
    lblMalinaPointText: TTntLabel;
    edtMalinaPointsText: TTntEdit;
    procedure MalinaParametersChanged(Sender: TObject);
  private
    procedure UpdateMalinaReceipt;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrMalina }

procedure TfmFptrMalina.UpdatePage;
begin
  chbMalinaFilterEnabled.Checked := GetMalinaParams.MalinaFilterEnabled;
  edtMalinaPromoText.Text := GetMalinaParams.MalinaPromoText;
  edtMalinaCardPrefix.Text := GetMalinaParams.MalinaCardPrefix;
  edtMalinaPointsText.Text := GetMalinaParams.MalinaPointsText;
  seMalinaCoefficient.Value := GetMalinaParams.MalinaCoefficient;
  seMalinaPoints.Value := GetMalinaParams.MalinaPoints;
  edtMalinaRegistryKey.Text := GetMalinaParams.MalinaRegistryKey;
  chbMalinaClearRegistry.Checked := GetMalinaParams.MalinaClearRegistry;
  UpdateMalinaReceipt;
end;

procedure TfmFptrMalina.UpdateObject;
begin
  GetMalinaParams.MalinaFilterEnabled := chbMalinaFilterEnabled.Checked;
  GetMalinaParams.MalinaPromoText := edtMalinaPromoText.Text;
  GetMalinaParams.MalinaCardPrefix := edtMalinaCardPrefix.Text;
  GetMalinaParams.MalinaPointsText := edtMalinaPointsText.Text;
  GetMalinaParams.MalinaCoefficient := seMalinaCoefficient.Value;
  GetMalinaParams.MalinaPoints := seMalinaPoints.Value;
  GetMalinaParams.MalinaRegistryKey := edtMalinaRegistryKey.Text;
  GetMalinaParams.MalinaClearRegistry := chbMalinaClearRegistry.Checked;
end;

procedure TfmFptrMalina.MalinaParametersChanged(Sender: TObject);
begin
  UpdateMalinaReceipt;
end;

procedure TfmFptrMalina.UpdateMalinaReceipt;
var
  Params: TMalinaParamsRec;
begin
  Params.SaleText := edtMalinaPromoText.Text;
  Params.CardPrefix := edtMalinaCardPrefix.Text;
  Params.MalinaCoeff := seMalinaCoefficient.Value;
  Params.MalinaPoints := seMalinaPoints.Value;
  memReceipt.Text := TMalinaReceipt.CreateReceipt(Params);
end;

end.
