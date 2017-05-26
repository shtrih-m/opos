unit fmuFptrLog;

interface

uses
  // VCL
  ComCtrls, StdCtrls, Controls, Classes,
  // This
  FiscalPrinterDevice, FptrTypes, Spin;

type
  { TfmFptrLog }

  TfmFptrLog = class(TFptrPage)
    gbLogParameters: TGroupBox;
    chbLogEnabled: TCheckBox;
    lblMaxLogFileCount: TLabel;
    seMaxLogFileCount: TSpinEdit;
    edtLogFilePath: TEdit;
    lblLogFilePath: TLabel;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrLog }

procedure TfmFptrLog.UpdatePage;
begin
  chbLogEnabled.Checked := Parameters.LogFileEnabled;
  seMaxLogFileCount.Value := Parameters.LogMaxCount;
  edtLogFilePath.Text := Parameters.LogFilePath;
end;

procedure TfmFptrLog.UpdateObject;
begin
  Parameters.LogFileEnabled := chbLogEnabled.Checked;
  Parameters.LogMaxCount := seMaxLogFileCount.Value;
  Parameters.LogFilePath := edtLogFilePath.Text;
end;

procedure TfmFptrLog.PageChange(Sender: TObject);
begin
  Modified;
end;

end.
