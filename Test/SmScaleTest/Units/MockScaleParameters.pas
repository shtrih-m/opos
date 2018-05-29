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
    procedure Load(const DeviceName: WideString); override;
    procedure Save(const DeviceName: WideString); override;
  end;


implementation

{ TMockScaleParameters }

procedure TMockScaleParameters.Load(const DeviceName: WideString);
begin
  if ExceptionOnLoad then
    raise Exception.Create('Load failed');
end;

procedure TMockScaleParameters.Save(const DeviceName: WideString);
begin
end;

procedure TMockScaleParameters.SetDefaults;
begin
end;

end.
