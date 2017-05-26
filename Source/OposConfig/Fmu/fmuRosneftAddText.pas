unit fmuRosneftAddText;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, ComCtrls, ExtCtrls,
  // This
  FiscalPrinterDevice, FptrTypes, MalinaParams, RegExpr, Spin;

type
  { TfmRosneftAddText }

  TfmRosneftAddText = class(TFptrPage)
    chbRosneftAddTextEnabled: TCheckBox;
    edtRosneftItemName: TEdit;
    lblRosneftItemName: TLabel;
    lblRosneftAddText: TLabel;
    memRosneftAddText: TMemo;
    lblDepartment: TLabel;
    seRosneftItemDepartment: TSpinEdit;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmDiscountCard }

procedure TfmRosneftAddText.UpdatePage;
begin
  chbRosneftAddTextEnabled.Checked := GetMalinaParams.RosneftAddTextEnabled;
  edtRosneftItemName.Text := GetMalinaParams.RosneftItemName;
  seRosneftItemDepartment.Value := GetMalinaParams.RosneftItemDepartment;
  memRosneftAddText.Text := GetMalinaParams.RosneftAddText;
end;

procedure TfmRosneftAddText.UpdateObject;
begin
  GetMalinaParams.RosneftAddTextEnabled := chbRosneftAddTextEnabled.Checked;
  GetMalinaParams.RosneftItemName := edtRosneftItemName.Text;
  GetMalinaParams.RosneftItemDepartment := seRosneftItemDepartment.Value;
  GetMalinaParams.RosneftAddText := memRosneftAddText.Text;
end;

procedure TfmRosneftAddText.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
