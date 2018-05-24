unit fmuFptrAddHeaderTrailer;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposFiscalPrinter;

type
  { TfmFptrAddHeaderTrailer }

  TfmFptrAddHeaderTrailer = class(TPage)
    lblAdditionalHeader: TTntLabel;
    AdditionalHeader: TTntMemo;
    lblAdditionalTrailer: TTntLabel;
    AdditionalTrailer: TTntMemo;
    btnRead: TTntButton;
    btnWrite: TTntButton;
    btnDefaults: TTntButton;
    btnClear: TTntButton;
    procedure btnReadClick(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmFptrAddHeaderTrailer }

procedure TfmFptrAddHeaderTrailer.btnReadClick(Sender: TObject);
begin
  AdditionalHeader.Text := FiscalPrinter.AdditionalHeader;
  AdditionalTrailer.Text := FiscalPrinter.AdditionalTrailer;
end;

procedure TfmFptrAddHeaderTrailer.btnWriteClick(Sender: TObject);
begin
  FiscalPrinter.AdditionalHeader := AdditionalHeader.Text;
  FiscalPrinter.AdditionalTrailer := AdditionalTrailer.Text;
end;

procedure TfmFptrAddHeaderTrailer.btnDefaultsClick(Sender: TObject);
begin
  AdditionalHeader.Text :=
    '  AdditionalHeader, line 1 ' + #13#10 +
    '  AdditionalHeader, line 2 ' + #13#10 +
    '  AdditionalHeader, line 3 ' + #13#10 +
    '  AdditionalHeader, line 4 ' + #13#10 +
    '  AdditionalHeader, line 5 ';

  AdditionalTrailer.Text :=
    '  AdditionalTrailer, line 1 ' + #13#10 +
    '  AdditionalTrailer, line 2 ' + #13#10 +
    '  AdditionalTrailer, line 3 ' + #13#10 +
    '  AdditionalTrailer, line 4 ' + #13#10 +
    '  AdditionalTrailer, line 5 ';
end;

procedure TfmFptrAddHeaderTrailer.FormCreate(Sender: TObject);
begin
  btnDefaultsClick(Self);
end;

procedure TfmFptrAddHeaderTrailer.btnClearClick(Sender: TObject);
begin
  AdditionalHeader.Clear;
  AdditionalTrailer.Clear;
end;

end.
