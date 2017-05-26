unit fmuWeight;

interface

uses
  // VCL
  Windows, StdCtrls, ExtCtrls, Controls, Classes, SysUtils,
  // This
  ScalePage, M5ScaleTypes, JvExControls, JvSegmentedLEDDisplay;

type
  { TfmWeight }

  TfmWeight = class(TScalePage)
    pnlWeight: TPanel;
    btnSetTare: TButton;
    btnZeroScale: TButton;
    btnSetTareValue: TButton;
    Edit1: TEdit;
    lblTareWeight: TLabel;
    chbAutoUpdate: TCheckBox;
    lblWeight: TLabel;
    lblWeightValue: TLabel;
    pnlPrice: TPanel;
    lblPriceValue: TLabel;
    pblAmount: TPanel;
    lblAmountValue: TLabel;
    lblPrice: TLabel;
    lblAmount: TLabel;
    Bevel1: TBevel;
    Timer: TTimer;
    btnUpdateWeight: TButton;
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
  lblWeightValue.Caption := Format('%.3f', [Status.Weight/1000]);
  lblPriceValue.Caption := Format('%.2f', [Status.Price/100]);
  lblAmountValue.Caption := Format('%.2f', [Status.Amount/100]);
end;

end.
