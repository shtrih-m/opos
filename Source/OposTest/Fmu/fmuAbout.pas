unit fmuAbout;

interface

uses
  // VCL
  Windows, Forms, ExtCtrls, StdCtrls, Controls, Classes, ShellAPI, Graphics,
  // Tnt
  TntStdCtrls, TntRegistry,
  // This
  BaseForm;

type
  { TfmAbout }

  TfmAbout = class(TBaseForm)
    lblAddress: TTntLabel;
    btnOK: TTntButton;
    lblURL: TTntLabel;
    lblWebSite: TTntLabel;
    lblSupport: TTntLabel;
    lblSupportMail: TTntLabel;
    NameLabel: TTntLabel;
    lbVersion: TTntListBox;
    bvlInfo: TBevel;
    lblFirmName: TTntLabel;
    Image: TImage;
    Shape1: TShape;
    Bevel2: TBevel;
    procedure lblURLClick(Sender: TObject);
    procedure lblSupportMailClick(Sender: TObject);
  end;

procedure ShowAboutBox(ParentWnd: HWND; const ACaption: WideString;
  Info: array of WideString);

implementation

{$R *.DFM}

procedure ShowAboutBox(ParentWnd: HWND; const ACaption: WideString;
  Info: array of WideString);
var
  i: Integer;
  fm: TFmAbout;
begin
  fm := TfmAbout.Create(nil);
  try
    with fm do
    begin
      SetWindowLong(Handle, GWL_HWNDPARENT, ParentWnd);
      NameLabel.Caption := ACaption;
      for i:= Low(Info) to High(Info) do lbVersion.Items.Add(Info[i]);
      ShowModal;
    end;
  finally
    fm.Free;
  end;
end;

{ TfmAbout }

procedure TfmAbout.lblURLClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(), 'open', 'http://www.shtrih-m.ru',
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfmAbout.lblSupportMailClick(Sender: TObject);
begin
  ShellExecute(GetDesktopWindow(), 'open', 'mailto:support@shtrih-m.ru',
    nil, nil, SW_SHOWNORMAL);
end;

end.
