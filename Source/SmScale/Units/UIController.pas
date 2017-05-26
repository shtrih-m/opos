unit UIController;

interface

uses
  // VCL
  ComObj,
  // This
  M5ScaleTypes, fmuPages, untPages, fmuStatus, fmuWeight,
  fmuMode, ScalePage;

type
  { TUIController }

  TUIController = class(TInterfacedObject, IScaleUIController)
  private
    FDevice: IM5ScaleDevice;
    procedure AddPage(Pages: TfmPages; PageClass: TScalePageClass);
  public
    constructor Create(ADevice: IM5ScaleDevice);
    procedure ShowScaleDlg;
  end;

implementation

{ TUIController }

constructor TUIController.Create(ADevice: IM5ScaleDevice);
begin
  inherited Create;
  FDevice := ADevice;
end;

procedure TUIController.AddPage(Pages: TfmPages; PageClass: TScalePageClass);
var
  Page: TScalePage;
begin
  Page := PageClass.Create(Pages);
  Page.Device := FDevice;
  Pages.Add(Page);
end;

procedure TUIController.ShowScaleDlg;
var
  Dlg: TfmPages;
begin
  Dlg := TfmPages.Create(nil);
  try
    AddPage(Dlg, TfmStatus);
    AddPage(Dlg, TfmWeight);
    AddPage(Dlg, TfmMode);

    Dlg.Init;
    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

end.
