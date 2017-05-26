unit fmuFptrMalina;

interface

uses
  // VCL
  StdCtrls, pngimage, Controls, ExtCtrls, Classes, SysUtils,
  // This
  FiscalPrinterDevice, MalinaReceipt, FptrTypes, MalinaParams, Spin;

type
  { TfmFptrMalina }

  TfmFptrMalina = class(TFptrPage)
    memReceipt: TMemo;
    Image1: TImage;
    chbMalinaFilterEnabled: TCheckBox;
    edtMalinaCardPrefix: TEdit;
    edtMalinaPromoText: TEdit;
    edtMalinaRegistryKey: TEdit;
    chbMalinaClearRegistry: TCheckBox;
    lblMalinaRegistryKey: TLabel;
    lblMalinaPromoText: TLabel;
    lblMalinaCardPrefix: TLabel;
    lblMalinaCoefficient: TLabel;
    lblMalinaPoints: TLabel;
    seMalinaCoefficient: TSpinEdit;
    seMalinaPoints: TSpinEdit;
    lblMalinaPointText: TLabel;
    edtMalinaPointsText: TEdit;
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
