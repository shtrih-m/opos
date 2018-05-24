unit fmuTankReport;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // 3's
  PngImage,
  // This
  untPages, Opos, OposUtils, OposFiscalPrinter, OposFptr, OposFptrUtils,
  TankReader, UniposTank;

type
  TfmTankReport = class(TPage)
    memTankReport: TTntMemo;
    lblTankReport: TTntLabel;
    btnSetDefaults: TTntButton;
    btnPrint: TTntButton;
    procedure btnSetDefaultsClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SaveTanks;
  end;

var
  fmTankReport: TfmTankReport;

implementation

{$R *.dfm}

const
  CRLF = #13#10;

  DefTankReport: WideString =
    '******************************************' + CRLF +
    ' Отчет о состоянии резервуаров            ' + CRLF +
    ' Дата печати:            2010-04-10 18:00 ' + CRLF +
    ' Дата измерений:         2010-04-10 15:00 ' + CRLF +
    '                                          ' + CRLF +
    ' Резервуар 1 : [AИ-95]                    ' + CRLF +
    ' Объем:  100000 л       Уровень: 1.500 мм ' + CRLF +
    ' Вода:   0 л                Уровень: 0 мм ' + CRLF +
    ' Вместимость:  500000 л                   ' + CRLF +
    ' Температура:  18 с                       ' + CRLF +
    ' Плотность:  0.69                         ' + CRLF +
    ' Свободный объем : 400000л                ' + CRLF +
    '                                          ' + CRLF +
    ' Резервуар 2:  [AИ-92]                    ' + CRLF +
    ' Объем:  100000 л       Уровень: 1.500 мм ' + CRLF +
    ' Вода:   0 л                Уровень: 0 мм ' + CRLF +
    ' Вместимость:                    500000 л ' + CRLF +
    '******************************************';


{ TfmTankReport }

procedure TfmTankReport.btnSetDefaultsClick(Sender: TObject);
begin
  memTankReport.Text := DefTankReport;
end;

procedure TfmTankReport.btnPrintClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    SaveTanks;
    Check(FiscalPrinter.BeginNonFiscal);
    FiscalPrinter.PrintNormal(FPTR_S_RECEIPT, memTankReport.Text);
    Check(FiscalPrinter.EndNonFiscal);
  finally
    EnableButtons(True);
  end;
end;

procedure TfmTankReport.SaveTanks;
var
  i: Integer;
  Tank: TUniposTank;
  Reader: TTankReader;
const
  MaxTanks = 2;
  GradeNames: array [0..2] of string =
    ('AИ-76', 'AИ-92', 'AИ-95');
begin
  Reader := TTankReader.Create;
  try
    Reader.Clear;
    Reader.DataReady := True;
    Reader.TransactionDate := DateToStr(Now);

    for i := 1 to MaxTanks do
    begin
      Tank := Reader.Tanks.Add('Tank' + IntToStr(i));
      Tank.Values.Values[REGSTR_VAL_TIME_MANUAL] := TimeToStr(Time);
      Tank.Values.Values[REGSTR_VAL_TANK_NAME] := WideFormat('Резервуар №%d', [i]);
      Tank.Values.Values[REGSTR_VAL_GRADENAME] := GradeNames[i];
      Tank.Values.Values[REGSTR_VAL_CLOSE_QTY] := '1500000';
      Tank.Values.Values[REGSTR_VAL_DENSITY] := '0.69';
      Tank.Values.Values[REGSTR_VAL_TANK_TEMP] := '18';
      Tank.Values.Values[REGSTR_VAL_NET_STICK] := '123';
      Tank.Values.Values[REGSTR_VAL_MANUAL_NET] := '234';
      Tank.Values.Values[REGSTR_VAL_WATER_VOLUME] := '345';
      Tank.Values.Values[REGSTR_VAL_WATER_STICK] := '45';
      Tank.Values.Values[REGSTR_VAL_MANUAL_WATER] := '879';
      Tank.Values.Values[REGSTR_VAL_VOLUME_QTY] := '6378';
      Tank.Values.Values[REGSTR_VAL_EMPTY_VOLUME] := '877';
    end;
    Reader.Save;
  finally
    Reader.Free;
  end;
end;

procedure TfmTankReport.FormCreate(Sender: TObject);
begin
  memTankReport.Text := DefTankReport;
end;

end.
