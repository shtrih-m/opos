unit fmuCashInProcessing;

interface

uses
  // VCL
  Controls, StdCtrls, Classes, SysUtils, ComCtrls,
  // This
  FiscalPrinterDevice, MalinaParams;

type
  { TfmFptrUnipos }

  TfmCashInProcessing = class(TFptrPage)
    chbCashInProcessingEnabled: TCheckBox;
    lblCashInTextPattern: TLabel;
    edtCashInTextPattern: TEdit;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmFptrUnipos }

procedure TfmCashInProcessing.UpdatePage;
begin
  chbCashInProcessingEnabled.Checked := GetMalinaParams.CashInProcessingEnabled;
  edtCashInTextPattern.Text := GetMalinaParams.CashInTextPattern;
end;

procedure TfmCashInProcessing.UpdateObject;
begin
  GetMalinaParams.CashInProcessingEnabled := chbCashInProcessingEnabled.Checked;
  GetMalinaParams.CashInTextPattern := edtCashInTextPattern.Text;
end;

procedure TfmCashInProcessing.PageChange(Sender: TObject);
begin
  Modified;
end;


end.
