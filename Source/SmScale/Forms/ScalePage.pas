unit ScalePage;

interface

uses
  // This
  untPages, M5ScaleTypes;

type
  { TScalePage }

  TScalePage = class(TPage)
  public
    Device: IM5ScaleDevice;
  end;
  TScalePageClass = class of TScalePage;

implementation

end.
