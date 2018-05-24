unit fmuFptrText;

interface

uses
  // VCL
  StdCtrls, Controls, Classes, SysUtils, Spin, 
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  FiscalPrinterDevice, FptrTypes;

type
  { TfmFiscalPrinter }

  TfmFptrText = class(TFptrPage)
    gbTextParameters: TTntGroupBox;
    lblFontNumber: TTntLabel;
    lblCloseRecText: TTntLabel;
    lblSubtotalName: TTntLabel;
    lblVoidRecText: TTntLabel;
    edtSubtotalName: TTntEdit;
    edtCloseRecText: TTntEdit;
    edtVoidRecText: TTntEdit;
    seFontNumber: TSpinEdit;
    seRFQuantityLength: TSpinEdit;
    lblQuantityLength: TTntLabel;
    seRFAmountLength: TSpinEdit;
    lblRFAmountLength: TTntLabel;
    chbRFShowTaxLetters: TTntCheckBox;
    cbRFSeparatorLine: TTntComboBox;
    lblRFSeparatorLine: TTntLabel;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFiscalPrinter }

procedure TfmFptrText.UpdatePage;
begin
  seFontNumber.Value := Parameters.FontNumber;
  edtSubtotalName.Text := Parameters.SubtotalText;
  edtCloseRecText.Text := Parameters.CloseRecText;
  edtVoidRecText.Text := Parameters.VoidRecText;
  seRFQuantityLength.Value := Parameters.RFQuantityLength;
  seRFAmountLength.Value := Parameters.RFAmountLength;
  chbRFShowTaxLetters.Checked := Parameters.RFShowTaxLetters;
  cbRFSeparatorLine.ItemIndex := Parameters.RFSeparatorLine;
end;

procedure TfmFptrText.UpdateObject;
begin
  Parameters.SubtotalText := edtSubtotalName.Text;
  Parameters.CloseRecText := edtCloseRecText.Text;
  Parameters.VoidRecText := edtVoidRecText.Text;
  Parameters.FontNumber := seFontNumber.Value;
  Parameters.RFQuantityLength := seRFQuantityLength.Value;
  Parameters.RFAmountLength := seRFAmountLength.Value;
  Parameters.RFShowTaxLetters := chbRFShowTaxLetters.Checked;
  Parameters.RFSeparatorLine := cbRFSeparatorLine.ItemIndex;
end;

procedure TfmFptrText.PageChange(Sender: TObject);
begin
  Modified;
end;


end.
