unit MockScaleParameters;

interface

uses
  // VCL
  SysUtils,
  // This
  ScaleParameters;

type
  { TMockScaleParameters }

  TMockScaleParameters = class(TScaleParameters)
  public
    ExceptionOnLoad: Boolean;
    procedure SetDefaults; override;
    procedure Load(const DeviceName: string); override;
    procedure Save(const DeviceName: string); override;
  end;


implementation

{ TMockScaleParameters }

procedure TMockScaleParameters.Load(const DeviceName: string);
begin
  if ExceptionOnLoad then
    raise Exception.Create('Load failed');
end;

procedure TMockScaleParameters.Save(const DeviceName: string);
begin
end;

procedure TMockScaleParameters.SetDefaults;
begin
end;

end.
