unit MockUIController;

interface

uses
  // This
  M5ScaleTypes;

type
  { TMockUIController }

  TMockUIController = class(TInterfacedObject, IScaleUIController)
  public
    ShowScaleDlgCount: Integer;
    procedure ShowScaleDlg;
  end;


implementation

{ TMockUIController }

procedure TMockUIController.ShowScaleDlg;
begin
  Inc(ShowScaleDlgCount);
end;

end.
