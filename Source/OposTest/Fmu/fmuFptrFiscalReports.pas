unit fmuFptrFiscalReports;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrFiscalReports = class(TPage)
    lblReportType: TLabel;
    btnPrintReport: TButton;
    edtReportType: TEdit;
    cbReportType: TComboBox;
    lblStartNum: TLabel;
    edtStartNum: TEdit;
    lblEndNum: TLabel;
    edtEndNum: TEdit;
    Bevel1: TBevel;
    btnPrintXReport: TButton;
    btnPrintZReport: TButton;
    dtpStart: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    btnStartDate: TButton;
    btnEndDate: TButton;
    Bevel2: TBevel;
    btnPrintPeriodicTotalsReport: TButton;
    lblDate1: TLabel;
    edtDate1: TEdit;
    lblDate2: TLabel;
    edtDate2: TEdit;
    dtpDate1: TDateTimePicker;
    dtpDate2: TDateTimePicker;
    btnDate1: TButton;
    btnDate2: TButton;
    procedure btnPrintReportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbReportTypeChange(Sender: TObject);
    procedure btnPrintXReportClick(Sender: TObject);
    procedure btnPrintZReportClick(Sender: TObject);
    procedure dtpStartChange(Sender: TObject);
    procedure dtpEndChange(Sender: TObject);
    procedure btnStartDateClick(Sender: TObject);
    procedure btnEndDateClick(Sender: TObject);
    procedure btnDate1Click(Sender: TObject);
    procedure btnDate2Click(Sender: TObject);
    procedure btnPrintPeriodicTotalsReportClick(Sender: TObject);
    procedure dtpDate1Change(Sender: TObject);
    procedure dtpDate2Change(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TfmFptrFiscalReports.FormCreate(Sender: TObject);
begin
  dtpEnd.DateTime := Date;
  dtpStart.DateTime := Date;
  dtpDate1.DateTime := Date;
  dtpDate2.DateTime := Date;
  if cbReportType.Items.Count > 0 then
    cbReportType.ItemIndex := 0;
  edtDate1.Text := Date2Str(dtpDate1.Date);
  edtDate2.Text := Date2Str(dtpDate2.Date);
  edtStartNum.Text := Date2Str(dtpStart.Date);
  edtEndNum.Text := Date2Str(dtpEnd.Date);
end;

procedure TfmFptrFiscalReports.cbReportTypeChange(Sender: TObject);
begin
  edtReportType.Text := IntToStr(cbReportType.ItemIndex + 1);
end;

procedure TfmFptrFiscalReports.btnPrintReportClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintReport(
      StrToInt(edtReportType.Text),
      edtStartNum.Text,
      edtEndNum.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFiscalReports.btnPrintXReportClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintXReport;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFiscalReports.btnPrintZReportClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintZReport;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFiscalReports.dtpStartChange(Sender: TObject);
begin
  edtStartNum.Text := Date2Str(dtpStart.Date);
end;

procedure TfmFptrFiscalReports.dtpEndChange(Sender: TObject);
begin
  edtEndNum.Text := Date2Str(dtpEnd.Date);
end;

procedure TfmFptrFiscalReports.btnStartDateClick(Sender: TObject);
begin
  dtpStart.Date := Date;
  edtStartNum.Text := Date2Str(Date);
end;

procedure TfmFptrFiscalReports.btnEndDateClick(Sender: TObject);
begin
  dtpEnd.Date := Date;
  edtEndNum.Text := Date2Str(Date);
end;

procedure TfmFptrFiscalReports.btnDate1Click(Sender: TObject);
begin
  dtpDate1.Date := Date;
  edtDate1.Text := Date2Str(Date);
end;

procedure TfmFptrFiscalReports.btnDate2Click(Sender: TObject);
begin
  dtpDate2.Date := Date;
  edtDate2.Text := Date2Str(Date);
end;

procedure TfmFptrFiscalReports.btnPrintPeriodicTotalsReportClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    FiscalPrinter.PrintPeriodicTotalsReport(edtDate1.Text, edtDate2.Text);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrFiscalReports.dtpDate1Change(Sender: TObject);
begin
  edtDate1.Text := Date2Str(dtpDate1.Date);
end;

procedure TfmFptrFiscalReports.dtpDate2Change(Sender: TObject);
begin
  edtDate2.Text := Date2Str(dtpDate2.Date);
end;

end.
