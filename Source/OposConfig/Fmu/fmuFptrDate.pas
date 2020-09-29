unit fmuFptrDate;

interface

uses
  // VCL
  StdCtrls, Controls, Classes, ComObj, SysUtils, Spin, ExtCtrls,
  // 3'd
  SynMemo, SynEdit,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // This
  PrinterParameters, FiscalPrinterDevice, FptrTypes, DirectIOAPI;


type
  { TfmFptrDate }

  TfmFptrDate = class(TFptrPage)
    seValidTimeDiff: TSpinEdit;
    lblValidTimeDiff: TTntLabel;
    Label1: TLabel;
    procedure PageChange(Sender: TObject);
  public
    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

procedure TfmFptrDate.PageChange(Sender: TObject);
begin
  Modified;
end;

procedure TfmFptrDate.UpdatePage;
begin
  seValidTimeDiff.Value := Parameters.ValidTimeDiffInSecs;
end;

procedure TfmFptrDate.UpdateObject;
begin
  Parameters.ValidTimeDiffInSecs := seValidTimeDiff.Value;
end;

end.

