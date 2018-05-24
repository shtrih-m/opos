unit fmuScaleHealth;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposScale, OposUtils, OposScalUtils;

type
  TfmScaleHealth = class(TPage)
    lblLevel: TTntLabel;
    lblCheckHealthText: TTntLabel;
    cbLevel: TTntComboBox;
    btnCheckHealth: TTntButton;
    memCheckHealthText: TTntMemo;
    procedure btnCheckHealthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmScaleHealth.btnCheckHealthClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    Scale.CheckHealth(cbLevel.ItemIndex + 1);
    memCheckHealthText.Text := Scale.CheckHealthText;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmScaleHealth.FormCreate(Sender: TObject);
begin
  cbLevel.ItemIndex := 0;
end;

end.
