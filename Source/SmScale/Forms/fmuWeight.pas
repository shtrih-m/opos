unit fmuWeight;

interface

uses
  // VCL
  Windows, StdCtrls, ExtCtrls, Controls, Classes, SysUtils,
  // Tnt
  TntComCtrls, TntStdCtrls, TntClasses, TntSysUtils,
  // This
  ScalePage, M5ScaleTypes, JvExControls, JvSegmentedLEDDisplay, TntExtCtrls;

type
  { TfmWeight }

  TfmWeight = class(TScalePage)
    pnlWeight: TTntPanel;
    btnSetTare: TTntButton;
    btnZeroScale: TTntButton;
    btnSetTareValue: TTntButton;
    Edit1: TTntEdit;
    lblTareWeight: TTntLabel;
    chbAutoUpdate: TTntCheckBox;
    lblWeight: TTntLabel;
    lblWeightValue: TTntLabel;
    pnlPrice: TTntPanel;
    lblPriceValue: TTntLabel;
    pblAmount: TTntPanel;
    lblAmountValue: TTntLabel;
    lblPrice: TTntLabel;
    lblAmount: TTntLabel;
    Bevel1: TBevel;
    Timer: TTimer;
    btnUpdateWeight: TTntButton;
    procedure TimerTimer(Sender: TObject);
  public
    procedure UpdatePage; override;
  end;

var
  fmWeight: TfmWeight;

implementation

{$R *.DFM}


procedure TfmWeight.TimerTimer(Sender: TObject);
begin
  try
    UpdatePage;
  except
    on E: Exception do
    begin
      Timer.Enabled := False;
      Device.HandleException(E);
    end;
  end;
  Modified;
end;

procedure TfmWeight.UpdatePage;
var
  Status: TM5Status2;
begin
  Device.Check(Device.ReadStatus2(Status));
  lblWeightValue.Caption := Tnt_WideFormat('%.3f', [Status.Weight/1000]);
  lblPriceValue.Caption := Tnt_WideFormat('%.2f', [Status.Price/100]);
  lblAmountValue.Caption := Tnt_WideFormat('%.2f', [Status.Amount/100]);
end;

end.
