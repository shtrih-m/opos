unit fmuZReport;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // This
  FiscalPrinterDevice, untUtil, FptrTypes, PrinterParameters;

type
  { TfmZReport }

  TfmZReport = class(TFptrPage)
    chbXmlZReportEnabled: TCheckBox;
    edtXmlZReportFileName: TEdit;
    chbCsvZReportEnabled: TCheckBox;
    edtCsvZReportFileName: TEdit;
    lblXmlZReportFileName: TLabel;
    llblCsvZReportFileName: TLabel;
    lblReceiptReportFileName: TLabel;
    chbReceiptReportEnabled: TCheckBox;
    edtReceiptReportFileName: TEdit;
    chbReportDateStamp: TCheckBox;
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

var
  fmZReport: TfmZReport;

implementation

{$R *.dfm}

{ TfmZReport }

procedure TfmZReport.UpdateObject;
begin
  Parameters.XmlZReportEnabled := chbXmlZReportEnabled.Checked;
  Parameters.CsvZReportEnabled := chbCsvZReportEnabled.Checked;
  Parameters.XmlZReportFileName := edtXmlZReportFileName.Text;
  Parameters.CsvZReportFileName := edtCsvZReportFileName.Text;
  Parameters.ReceiptReportFileName := edtReceiptReportFileName.Text;
  Parameters.ReceiptReportEnabled := chbReceiptReportEnabled.Checked;
  Parameters.ReportDateStamp := chbReportDateStamp.Checked;
end;

procedure TfmZReport.UpdatePage;
begin
  chbXmlZReportEnabled.Checked := Parameters.XmlZReportEnabled;
  chbCsvZReportEnabled.Checked := Parameters.CsvZReportEnabled;
  edtXmlZReportFileName.Text := Parameters.XmlZReportFileName;
  edtCsvZReportFileName.Text := Parameters.CsvZReportFileName;
  edtReceiptReportFileName.Text := Parameters.ReceiptReportFileName;
  chbReceiptReportEnabled.Checked := Parameters.ReceiptReportEnabled;
  chbReportDateStamp.Checked := Parameters.ReportDateStamp;
end;

end.
