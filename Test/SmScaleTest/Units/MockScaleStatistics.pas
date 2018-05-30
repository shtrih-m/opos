unit MockScaleStatistics;

interface

uses
  // This
  ScaleStatistics;

type
  { TMockscaleStatistics }

  TMockscaleStatistics = class(TScaleStatistics)
  public
    procedure IniLoad(const DeviceName: WideString); override;
    procedure IniSave(const DeviceName: WideString); override;
  end;

implementation

{ TMockscaleStatistics }

procedure TMockscaleStatistics.IniLoad(const DeviceName: WideString);
begin
end;

procedure TMockscaleStatistics.IniSave(const DeviceName: WideString);
begin
end;

end.
