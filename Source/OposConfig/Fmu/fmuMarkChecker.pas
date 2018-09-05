unit fmuMarkChecker;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,  TntDialogs, TntStdCtrls, Spin,
  // This
  untUtil, FptrTypes, PrinterParameters, FiscalPrinterDevice;

type
  { TfmMarkChecker }

  TfmMarkChecker = class(TFptrPage)
    chkEkmServerEnabled: TTntCheckBox;
    lblEkmServerHost: TTntLabel;
    edtEkmServerHost: TTntEdit;
    seEkmServerPort: TSpinEdit;
    lblEkmServerPort: TTntLabel;
    seEkmServerTimeout: TSpinEdit;
    lblEkmServerTimeout: TTntLabel;
    chkCheckItemCodeEnabled: TTntCheckBox;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmMarkChecker: TfmMarkChecker;

implementation

{$R *.DFM}

{ TfmMarkChecker }

procedure TfmMarkChecker.UpdatePage;
begin
  edtEkmServerHost.Text := Parameters.EkmServerHost;
  seEkmServerPort.Value := Parameters.EkmServerPort;
  seEkmServerTimeout.Value := Parameters.EkmServerTimeout;
  chkEkmServerEnabled.Checked := Parameters.EkmServerEnabled;
  chkCheckItemCodeEnabled.Checked := Parameters.CheckItemCodeEnabled;
end;

procedure TfmMarkChecker.UpdateObject;
begin
  Parameters.EkmServerHost := edtEkmServerHost.Text;
  Parameters.EkmServerPort := seEkmServerPort.Value;
  Parameters.EkmServerTimeout := seEkmServerTimeout.Value;
  Parameters.EkmServerEnabled := chkEkmServerEnabled.Checked;
  Parameters.CheckItemCodeEnabled := chkCheckItemCodeEnabled.Checked;
end;

end.
