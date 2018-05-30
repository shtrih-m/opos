unit fmuFptrSetHeaderTrailer;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  untPages, OposFiscalPrinter;

type
  TfmFptrSetHeaderTrailer = class(TPage)
    btnSetHeader: TTntButton;
    btnSetTrailer: TTntButton;
    lblHeader: TTntLabel;
    mmHeader: TTntMemo;
    btnClear: TTntButton;
    lblTrailer: TTntLabel;
    mmTrailer: TTntMemo;
    btnDefault: TTntButton;
    chbDoubleWidth: TTntCheckBox;
    procedure btnSetHeaderClick(Sender: TObject);
    procedure btnSetTrailerClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

{ TfmSetDate }

procedure TfmFptrSetHeaderTrailer.btnSetHeaderClick(Sender: TObject);
var
  i: Integer;
  Data: WideString;
  Result: Integer;
  DoubleWidth: Boolean;
begin
  DoubleWidth := chbDoubleWidth.Checked;
  EnableButtons(False);
  try
    with mmHeader do
    begin
      for i := 0 to Lines.Count-1 do
      begin
        Data := Lines[i];
        Result := FiscalPrinter.SetHeaderLine(i+1, Data, DoubleWidth);
        if Result <> 0 then Break;
      end;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSetHeaderTrailer.btnSetTrailerClick(Sender: TObject);
var
  i: Integer;
  Data: WideString;
  Result: Integer;
  DoubleWidth: Boolean;
begin
  DoubleWidth := chbDoubleWidth.Checked;
  EnableButtons(False);
  try
    with mmTrailer do
    begin
      for i := 0 to Lines.Count-1 do
      begin
        Data := Lines[i];
        Result := FiscalPrinter.SetTrailerLine(i+1, Data, DoubleWidth);
        if Result <> 0 then Break;
      end;
    end;
  finally
    EnableButtons(True);
  end;
end;

procedure TfmFptrSetHeaderTrailer.btnClearClick(Sender: TObject);
begin
  mmHeader.Clear;
  mmTrailer.Clear;
end;

procedure TfmFptrSetHeaderTrailer.btnDefaultClick(Sender: TObject);
var
  i: Integer;
  Data: WideString;
  Count: Integer;
begin
  mmHeader.Clear;
  Count := FiscalPrinter.NumHeaderLines;
  for i := 0 to Count-1 do
  begin
    Data := Tnt_WideFormat('Header line ¹%d', [i+1]);
    mmHeader.Lines.Add(Data);
  end;
  mmTrailer.Clear;
  Count := FiscalPrinter.NumTrailerLines;
  for i := 0 to Count-1 do
  begin
    Data := Tnt_WideFormat('Trailer line ¹%d', [i+1]);
    mmTrailer.Lines.Add(Data);
  end;
end;

end.
