unit fmuFptrTables;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice;

type
  TfmFptrTables = class(TFptrPage)
    chbTableEditEnabled: TTntCheckBox;
    chbWritePaymentNameEnabled: TTntCheckBox;
    lblTableFilePath: TTntLabel;
    edtTableFilePath: TTntEdit;
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
