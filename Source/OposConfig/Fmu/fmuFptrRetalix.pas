unit fmuFptrRetalix;

interface

uses
  // VCL
  StdCtrls, pngimage, Controls, ExtCtrls, Classes, SysUtils,
  // This
  FiscalPrinterDevice, MalinaParams, TntStdCtrls;

type
  { TfmFptrRetalix }

  TfmFptrRetalix = class(TFptrPage)
    edtRetalixDBPath: TTntEdit;
    lblRetalixDBPath: TTntLabel;
    chbRetalixDBEnabled: TTntCheckBox;
    chbRetalixSearchCI: TTntCheckBox;
    Label1: TTntLabel;
    chbRosneftDryReceiptEnabled: TTntCheckBox;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrRetalix }

procedure TfmFptrRetalix.UpdatePage;
begin
  edtRetalixDBPath.Text := GetMalinaParams.RetalixDBPath;
  chbRetalixDBEnabled.Checked := GetMalinaParams.RetalixDBEnabled;
  chbRetalixSearchCI.Checked := GetMalinaParams.RetalixSearchCI;
  chbRosneftDryReceiptEnabled.Checked := GetMalinaParams.RosneftDryReceiptEnabled;
end;

procedure TfmFptrRetalix.UpdateObject;
begin
  GetMalinaParams.RetalixDBPath := edtRetalixDBPath.Text;
  GetMalinaParams.RetalixDBEnabled := chbRetalixDBEnabled.Checked;
  GetMalinaParams.RetalixSearchCI := chbRetalixSearchCI.Checked;
  GetMalinaParams.RosneftDryReceiptEnabled := chbRosneftDryReceiptEnabled.Checked;
end;

end.
