unit fmuPages;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Controls, ExtCtrls, StdCtrls, Forms,
  // Tnt
  TntStdCtrls, TntComCtrls, TntSysUtils,
  // Opos
  OposDevice,
  // This
  BaseForm, untPages, TntExtCtrls;

type
  { TfmFiscalPrinter }

  TfmPages = class(TBaseForm)
    btnDefaults: TTntButton;
    btnOK: TTntButton;
    btnCancel: TTntButton;
    btnApply: TTntButton;
    lbPages: TTntListBox;
    pnlPage: TTntPanel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    procedure lbPagesClick(Sender: TObject);
  private
    FPage: TPage;
    FPages: TPages;
    FDevice: TOposDevice;

    procedure ShowPage(Page: TPage);
    procedure Modified(Sender: TObject);
    procedure UpdatePages(ListBox: TTntListBox; Pages: TPages);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init;
    procedure UpdatePage;
    procedure UpdateObject;
    procedure Add(Page: TPage);
    procedure AddPage(PageClass: TPageClass);

    property Pages: TPages read FPages;
    property Device: TOposDevice read FDevice write FDevice;
  end;

implementation

{$R *.DFM}

{ TfmFiscalPrinter }

constructor TfmPages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TPages.Create;
end;

destructor TfmPages.Destroy;
begin
  FPages.Free;
  inherited Destroy;
end;

procedure TfmPages.AddPage(PageClass: TPageClass);
begin
  Add(PageClass.Create(Self));
end;

procedure TfmPages.Add(Page: TPage);
begin
  Page.OnModified := Modified;
  Page.BorderStyle := bsNone;
  Page.Parent := pnlPage;
  Page.Width := pnlPage.ClientHeight;
  Page.Height := pnlPage.ClientHeight;
  FPages.InsertItem(Page);
end;

procedure TfmPages.UpdatePages(ListBox: TTntListBox; Pages: TPages);
var
  i: Integer;
  PageName: WideString;
begin
  lbPages.Items.BeginUpdate;
  try
    lbPages.Items.Clear;
    for i := 0 to Pages.Count-1 do
    begin
      PageName := Tnt_WideFormat('%.2d. %s', [i+1, Pages[i].Caption]);
      lbPages.Items.Add(PageName);
    end;
  finally
    lbPages.Items.EndUpdate;
  end;
  if Pages.Count > 0 then
  begin
    ListBox.ItemIndex := 0;
    ShowPage(Pages[0]);
  end;
end;

procedure TfmPages.ShowPage(Page: TPage);
begin
  if Page <> FPage then
  begin
    if Page <> nil then
    begin
      Page.Align := alClient;
      Page.Visible := True;
      Page.Width := pnlPage.ClientWidth;
    end;
    if FPage <> nil then
      FPage.Visible := False;
    FPage := Page;
  end;
end;

procedure TfmPages.Modified(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

procedure TfmPages.UpdatePage;
begin
  FPages.UpdatePage;
end;

procedure TfmPages.UpdateObject;
begin
  FPages.UpdateObject;
  FDevice.SaveParams;
end;

procedure TfmPages.btnDefaultsClick(Sender: TObject);
begin
  FDevice.SetDefaults;
  UpdatePage;
end;

procedure TfmPages.btnOKClick(Sender: TObject);
begin
  UpdateObject;
  ModalResult := mrOK;
end;

procedure TfmPages.Init;
begin
  UpdatePages(lbPages, FPages);
  ShowPage(FPages[0]);
end;

procedure TfmPages.FormCreate(Sender: TObject);
begin
  pnlPage.Caption := '';
  pnlPage.BevelOuter := bvNone;
end;

procedure TfmPages.btnApplyClick(Sender: TObject);
begin
  UpdateObject;
  btnApply.Enabled := False;
end;

procedure TfmPages.lbPagesClick(Sender: TObject);
begin
  ShowPage(FPages[lbPages.ItemIndex]);
end;

end.
