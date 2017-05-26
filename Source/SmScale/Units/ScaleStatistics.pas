unit ScaleStatistics;

interface

uses
  // This
  OposStat, OposStatistics, LogFile;

type
  { TScaleStatistics }

  TScaleStatistics = class(TOposStatistics)
  public
    constructor Create(ALogger: TLogFile); override;
    procedure WeightReaded;
  end;

implementation

{ TScaleStatistics }

constructor TScaleStatistics.Create(ALogger: TLogFile);
begin
  inherited Create(ALogger);
  // Statistics for the Scale device category.
  Add(OPOS_STAT_GoodWeightReadCount);
end;

procedure TScaleStatistics.WeightReaded;
begin
  IncItem(OPOS_STAT_GoodWeightReadCount);
end;


end.
