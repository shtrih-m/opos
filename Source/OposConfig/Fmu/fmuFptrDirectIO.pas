unit fmuFptrDirectIO;

interface

uses
  // VCL
  ComCtrls, StdCtrls, Controls, Classes,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, FptrTypes, Spin;

type
  { TfmFptrDirectIO }

  TfmFptrDirectIO = class(TFptrPage)
    chbIgnoreDirectIOErrors: TTntCheckBox;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrLog }

procedure TfmFptrDirectIO.UpdatePage;
begin
  chbIgnoreDirectIOErrors.Checked := Parameters.IgnoreDirectIOErrors;
end;

procedure TfmFptrDirectIO.UpdateObject;
begin
  Parameters.IgnoreDirectIOErrors := chbIgnoreDirectIOErrors.Checked;
end;

procedure TfmFptrDirectIO.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
