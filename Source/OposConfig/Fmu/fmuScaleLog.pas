unit fmuScaleLog;

interface

uses
  // VCL
  ComCtrls, StdCtrls, Controls, Classes,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  ScaleDevice, FptrTypes, Spin;

type
  { TfmScaleLog }

  TfmScaleLog = class(TScalePage)
    gbLogParameters: TTntGroupBox;
    chbLogEnabled: TTntCheckBox;
    lblMaxLogFileCount: TTntLabel;
    seMaxLogFileCount: TSpinEdit;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmScaleLog }

procedure TfmScaleLog.UpdatePage;
begin
  chbLogEnabled.Checked := Parameters.LogFileEnabled;
  seMaxLogFileCount.Value := Parameters.LogMaxCount;
end;

procedure TfmScaleLog.UpdateObject;
begin
  Parameters.LogFileEnabled := chbLogEnabled.Checked;
  Parameters.LogMaxCount := seMaxLogFileCount.Value;
end;

procedure TfmScaleLog.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
