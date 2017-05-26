unit ScaleProtocol;

interface

uses
  // This
  ScaleTypes;

type
  { TScaleProtocol }

  TScaleProtocol = class(TInterfacedObject, IScaleProtocol)
  public
    function SendCommand(const P: string; var R: string): Integer;
  end;

implementation

{ TScaleProtocol }

function TScaleProtocol.SendCommand(const P: string;
  var R: string): Integer;
begin

end;

end.
