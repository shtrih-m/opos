unit fmuXReport;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // This
  FiscalPrinterDevice, untUtil, FptrTypes, PrinterParameters;

type
  { TfmZReport }

  TfmXReport = class(TFptrPage)
    lblXReport: TLabel;
    cbXReport: TComboBox;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmXReport: TfmXReport;

implementation

{$R *.dfm}

{ TfmXReport }

procedure TfmXReport.UpdateObject;
begin
  Parameters.XReport := cbXReport.ItemIndex;
end;

procedure TfmXReport.UpdatePage;
begin
  cbXReport.ItemIndex := Parameters.XReport;
end;

end.
