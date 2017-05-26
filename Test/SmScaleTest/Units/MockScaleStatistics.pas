unit MockScaleStatistics;

interface

uses
  // This
  ScaleStatistics;

type
  { TMockscaleStatistics }

  TMockscaleStatistics = class(TScaleStatistics)
  public
    procedure IniLoad(const DeviceName: string); override;
    procedure IniSave(const DeviceName: string); override;
  end;

implementation

{ TMockscaleStatistics }

procedure TMockscaleStatistics.IniLoad(const DeviceName: string);
begin
end;

procedure TMockscaleStatistics.IniSave(const DeviceName: string);
begin
end;

end.
