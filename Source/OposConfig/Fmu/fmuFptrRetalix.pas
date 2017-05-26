unit fmuFptrRetalix;

interface

uses
  // VCL
  StdCtrls, pngimage, Controls, ExtCtrls, Classes, SysUtils,
  // This
  FiscalPrinterDevice, MalinaParams;

type
  { TfmFptrRetalix }

  TfmFptrRetalix = class(TFptrPage)
    edtRetalixDBPath: TEdit;
    lblRetalixDBPath: TLabel;
    chbRetalixDBEnabled: TCheckBox;
    chbRetalixSearchCI: TCheckBox;
    Label1: TLabel;
    chbRosneftDryReceiptEnabled: TCheckBox;
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
