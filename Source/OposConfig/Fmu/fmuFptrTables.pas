unit fmuFptrTables;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // This
  FiscalPrinterDevice;

type
  TfmFptrTables = class(TFptrPage)
    chbTableEditEnabled: TCheckBox;
    chbWritePaymentNameEnabled: TCheckBox;
    lblTableFilePath: TLabel;
    edtTableFilePath: TEdit;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmFptrTables: TfmFptrTables;

implementation

{$R *.dfm}

{ TfmFptrTables }

procedure TfmFptrTables.UpdateObject;
begin
  Parameters.TableEditEnabled := chbTableEditEnabled.Checked;
  Parameters.WritePaymentNameEnabled := chbWritePaymentNameEnabled.Checked;
  Parameters.TableFilePath := edtTableFilePath.Text;
end;

procedure TfmFptrTables.UpdatePage;
begin
  chbTableEditEnabled.Checked := Parameters.TableEditEnabled;
  chbWritePaymentNameEnabled.Checked := Parameters.WritePaymentNameEnabled;
  edtTableFilePath.Text := Parameters.TableFilePath;
end;

end.
