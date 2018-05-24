unit fmuFptrTrailer;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, Classes, SysUtils, Registry, Dialogs, Forms,
  ComCtrls, Buttons, ExtDlgs, ExtCtrls, ComObj,
  // 3'd
  SynMemo, SynEdit,
  // This
  FiscalPrinterDevice, PrinterParameters, FptrTypes, DirectIOAPI,
  TntStdCtrls;

type
  { TfmFptrTrailer }

  TfmFptrTrailer = class(TFptrPage)
    symTrailer: TSynMemo;
    gbTrailer: TTntGroupBox;
    lblNumTrailerLines: TTntLabel;
    lblTrailerFont: TTntLabel;
    cbNumTrailerLines: TTntComboBox;
    cbTrailerFont: TTntComboBox;
    btnPrintTrailer: TTntButton;
    chbSetTrailerLineEnabled: TTntCheckBox;
    procedure PageChange(Sender: TObject);
    procedure btnPrintTrailerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

procedure TfmFptrTrailer.UpdatePage;
begin
  cbNumTrailerLines.ItemIndex := Parameters.NumTrailerLines;
  cbTrailerFont.ItemIndex := Parameters.TrailerFont-1;
  symTrailer.Text := Parameters.Trailer;
  chbSetTrailerLineEnabled.Checked := Parameters.SetTrailerLineEnabled;
end;

procedure TfmFptrTrailer.UpdateObject;
begin
  Parameters.Trailer := symTrailer.Text;
  Parameters.TrailerFont := cbTrailerFont.ItemIndex + 1;
  Parameters.NumTrailerLines := cbNumTrailerLines.ItemIndex;
  Parameters.SetTrailerLineEnabled := chbSetTrailerLineEnabled.Checked;
end;

procedure TfmFptrTrailer.PageChange(Sender: TObject);
begin
  Modified;
end;

procedure TfmFptrTrailer.btnPrintTrailerClick(Sender: TObject);
var
  pData: Integer;
  pWideString: WideString;
  Driver: OleVariant;
begin
  Owner.UpdateObject;
  Device.SaveParams;

  EnableButtons(False);
  try
    Driver := CreateOleObject('OPOS.FiscalPrinter');
    try
      Check(Driver, Driver.Open(Device.DeviceName));
      Check(Driver, Driver.ClaimDevice(0));
      Driver.DeviceEnabled := True;
      Check(Driver, Driver.ResultCode);

      pData := cbTrailerFont.ItemIndex + 1;
      pWideString := symTrailer.Text;
      Check(Driver, Driver.DirectIO(DIO_PRINT_TEXT2, pData, pWideString));
    finally
      Driver.Close;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrTrailer.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  cbNumTrailerLines.Items.BeginUpdate;
  try
    cbNumTrailerLines.Items.Clear;
    for i := MinTrailerLines to MaxTrailerLines do
      cbNumTrailerLines.Items.Add(IntToStr(i));
  finally
    cbNumTrailerLines.Items.EndUpdate;
  end;
end;

end.
