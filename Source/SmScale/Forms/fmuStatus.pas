unit fmuStatus;

interface

uses
  // VCL
  Windows, StdCtrls, ExtCtrls, Controls, Classes, SysUtils,
  // Tnt
  TntSysUtils, TntClasses, TntStdCtrls,
  // This
  ScalePage, M5ScaleTypes;

type
  { TfmStatus }

  TfmStatus = class(TScalePage)
    Memo: TTntMemo;
    btnReadStatus: TTntButton;
    btnReadStatus2: TTntButton;
    btnDeviceMetrics: TTntButton;
    procedure btnReadStatusClick(Sender: TObject);
    procedure btnReadStatus2Click(Sender: TObject);
    procedure btnDeviceMetricsClick(Sender: TObject);
  private
    procedure ReadStatus;
    procedure ReadStatus2;
    procedure AddLine(const line: string);
  end;

var
  fmStatus: TfmStatus;

implementation

{$R *.DFM}

const
  Separator = ' -----------------------------------------------------';
  BoolToStr: array [Boolean] of string = ('[ ]', '[X]');

{ TfmStatus }

procedure TfmStatus.AddLine(const Line: string);
begin
  Memo.Lines.Add('  ' + Line);
end;

procedure TfmStatus.btnReadStatusClick(Sender: TObject);
begin
  ReadStatus;
end;

procedure TfmStatus.btnReadStatus2Click(Sender: TObject);
begin
  ReadStatus2;
end;

procedure TfmStatus.ReadStatus;
var
  Status: TM5Status;
  Flags: TM5StatusFlags;
begin
  try
    Device.Check(Device.ReadStatus(Status));
    Flags := Status.Flags;

    Memo.Lines.Clear;
    Memo.Lines.Add(Separator);
    AddLine(' Scale status');
    Memo.Lines.Add(Separator);
    AddLine('Weight value  : ' + IntToStr(Status.Weight));
    AddLine('Tare weight   : ' + IntToStr(Status.Tare));
    Memo.Lines.Add(Separator);
    AddLine('Flags value   : ' + IntToStr(Status.Flags.Value));
    Memo.Lines.Add(Separator);

    AddLine('Bit 0, weight fixed       : ' + BoolToStr[Flags.isWeightFixed]);
    AddLine('Bit 1, auto zero flag     : ' + BoolToStr[Flags.isAutoZeroOn]);
    AddLine('Bit 2, channel enabled    : ' + BoolToStr[Flags.isChannelEnabled]);
    AddLine('Bit 3, tare flag          : ' + BoolToStr[Flags.isTareSet]);
    AddLine('Bit 4, weight stable      : ' + BoolToStr[Flags.isWeightStable]);
    AddLine('Bit 5, auto zero error    : ' + BoolToStr[Flags.isAutoZeroError]);
    AddLine('Bit 6, overweight         : ' + BoolToStr[Flags.isOverweight]);
    AddLine('Bit 7, read weight error  : ' + BoolToStr[Flags.isReadWeightError]);
    AddLine('Bit 8, weight is low      : ' + BoolToStr[Flags.isWeightTooLow]);
    AddLine('Bit 9, ADC not responding : ' + BoolToStr[Flags.isADCNotResponding]);
    Memo.Lines.Add(Separator);

    Device.ClearResult;
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  Modified;
end;

procedure TfmStatus.ReadStatus2;
var
  Status: TM5Status2;
begin
  try
    Device.Check(Device.ReadStatus2(Status));

    Memo.Lines.Clear;
    Memo.Lines.Add(Separator);
    AddLine(' Scale status 2');
    Memo.Lines.Add(Separator);
    AddLine(Format('Scale mode    : %d, %s', [
      Status.Mode, Device.GetModeText(Status.Mode)]));
    AddLine('Weight value  : ' + IntToStr(Status.Weight));
    AddLine('Tare weight   : ' + IntToStr(Status.Tare));
    AddLine('Item type     : ' + IntToStr(Status.ItemType));
    AddLine('Item quantity : ' + IntToStr(Status.Quantity));
    AddLine('Unit price    : ' + IntToStr(Status.Price));
    AddLine('Sales price   : ' + IntToStr(Status.Amount));
    AddLine('Last key code : ' + IntToStr(Status.LastKey));
    Memo.Lines.Add(Separator);

    Device.ClearResult;
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  Modified;
end;

procedure TfmStatus.btnDeviceMetricsClick(Sender: TObject);
var
  R: TDeviceMetrics;
begin
  try
    Device.Check(Device.ReadDeviceMetrics(R));

    Memo.Lines.Clear;
    Memo.Lines.Add(Separator);
    AddLine(' Device metrics');
    Memo.Lines.Add(Separator);
    AddLine(Format('Device type     : %d.%d', [R.MajorType, R.MinorType]));
    AddLine(Format('Device version  : %d.%d', [R.MajorVersion, R.MinorVersion]));
    AddLine(Format('Device model    : %d', [R.Model]));
    AddLine(Format('Device language : %d, %s', [
      R.Language, Device.GetLanguageText(R.Language)]));
    AddLine(Format('Device name     : %s', [R.Name]));
    Memo.Lines.Add(Separator);

    Device.ClearResult;
  except
    on E: Exception do
      Device.HandleException(E);
  end;
  Modified;
end;

end.
