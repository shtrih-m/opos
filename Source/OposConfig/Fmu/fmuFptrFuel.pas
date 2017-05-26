unit fmuFptrFuel;

interface

uses
  // VCL
  StdCtrls, Controls, Classes, ComObj, SysUtils,
  // This
  FiscalPrinterDevice, FptrTypes, MalinaParams;

type
  { TfmFptrFuel }

  TfmFptrFuel = class(TFptrPage)
    gbFuelFilter: TGroupBox;
    Label3: TLabel;
    lblFuelItemText: TLabel;
    lblFuelAmountStep: TLabel;
    lblFuelAmountPrecision: TLabel;
    chbFuelRoundEnabled: TCheckBox;
    memFuelItemText: TMemo;
    edtFuelAmountStep: TEdit;
    edtFuelAmountPrecision: TEdit;
    chbCashRoundEnabled: TCheckBox;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFiscalPrinter }

procedure TfmFptrFuel.UpdatePage;
begin
  chbFuelRoundEnabled.Checked := GetMalinaParams.FuelRoundEnabled;
  chbCashRoundEnabled.Checked := GetMalinaParams.CashRoundEnabled;
  memFuelItemText.Text := GetMalinaParams.FuelItemText;
  edtFuelAmountStep.Text := FloatToStr(GetMalinaParams.FuelAmountStep);
  edtFuelAmountPrecision.Text := FloatToStr(GetMalinaParams.FuelAmountPrecision);
end;

procedure TfmFptrFuel.UpdateObject;
begin
  GetMalinaParams.FuelRoundEnabled := chbFuelRoundEnabled.Checked;
  GetMalinaParams.CashRoundEnabled := chbCashRoundEnabled.Checked;
  GetMalinaParams.FuelItemText := memFuelItemText.Text;
  GetMalinaParams.FuelAmountStep := StrToFloat(edtFuelAmountStep.Text);
  GetMalinaParams.FuelAmountPrecision := StrToFloat(edtFuelAmountPrecision.Text);
end;

procedure TfmFptrFuel.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
