unit fmuFptrHeader;

interface

uses
  // VCL
  StdCtrls, Controls, Classes, ComObj, SysUtils,
  // 3'd
  SynMemo, SynEdit,
  // This
  PrinterParameters, FiscalPrinterDevice, FptrTypes, DirectIOAPI,
  TntStdCtrls;

type
  { TfmFiscalPrinter }

  TfmFptrHeader = class(TFptrPage)
    gbHeader: TTntGroupBox;
    lblNumHeaderLines: TTntLabel;
    lblHeaderFont: TTntLabel;
    cbNumHeaderLines: TTntComboBox;
    cbHeaderFont: TTntComboBox;
    btnPrintHeader: TTntButton;
    chbSetHeaderLineEnabled: TTntCheckBox;
    chbCenterHeader: TTntCheckBox;
    symHeader: TSynMemo;
    procedure PageChange(Sender: TObject);
    procedure btnPrintHeaderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrHeader }

procedure TfmFptrHeader.PageChange(Sender: TObject);
begin
  Modified;
end;

procedure TfmFptrHeader.btnPrintHeaderClick(Sender: TObject);
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

      pData := cbHeaderFont.ItemIndex + 1;
      pWideString := symHeader.Text;
      Check(Driver, Driver.DirectIO(DIO_PRINT_TEXT2, pData, pWideString));
    finally
      Driver.Close;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrHeader.UpdatePage;
begin
  chbSetHeaderLineEnabled.Checked := Parameters.SetHeaderLineEnabled;
  chbCenterHeader.Checked := Parameters.CenterHeader;
  cbNumHeaderLines.ItemIndex := Parameters.NumHeaderLines-MinHeaderLines;
  cbHeaderFont.ItemIndex := Parameters.HeaderFont-1;
  symHeader.Text := Parameters.Header;
end;

procedure TfmFptrHeader.UpdateObject;
begin
  Parameters.Header := symHeader.Text;
  Parameters.CenterHeader := chbCenterHeader.Checked;
  Parameters.HeaderFont := cbHeaderFont.ItemIndex + 1;
  Parameters.NumHeaderLines := cbNumHeaderLines.ItemIndex + MinHeaderLines;
  Parameters.SetHeaderLineEnabled := chbSetHeaderLineEnabled.Checked;
end;

procedure TfmFptrHeader.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  cbNumHeaderLines.Items.BeginUpdate;
  try
    cbNumHeaderLines.Items.Clear;
    for i := MinHeaderLines to MaxHeaderLines do
      cbNumHeaderLines.Items.Add(IntToStr(i));
  finally
    cbNumHeaderLines.Items.EndUpdate;
  end;
end;

end.
