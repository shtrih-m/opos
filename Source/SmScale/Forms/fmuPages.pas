unit fmuPages;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Controls, ExtCtrls, StdCtrls, Forms,
  // Tnt
  TntComCtrls, TntStdCtrls, TntSysUtils,
  // This
  BaseForm, untPages, TntExtCtrls;

type
  { TfmFiscalPrinter }

  TfmPages = class(TBaseForm)
    btnOK: TTntButton;
    lbPages: TTntListBox;
    pnlPage: TTntPanel;
    edtRecieve: TTntEdit;
    edtTxData: TTntEdit;
    edtResult: TTntEdit;
    lblResult: TTntLabel;
    lblTxData: TTntLabel;
    lblRxData: TTntLabel;
    stxPassword: TStaticText;
    edtPassword: TTntEdit;
    stxTime: TStaticText;
    edtTime: TTntEdit;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbPagesClick(Sender: TObject);
  private
    FPage: TPage;
    FPages: TPages;

    procedure ShowPage(Page: TPage);
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
  Page.BorderStyle := bsNone;
  Page.Parent := pnlPage;
  Page.Width := pnlPage.ClientHeight;
  Page.Height := pnlPage.ClientHeight;
  FPages.InsertItem(Page);
end;

procedure TfmPages.UpdatePages(ListBox: TTntListBox; Pages: TPages);
var
  i: Integer;
  PageName: string;
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

procedure TfmPages.UpdatePage;
begin
  FPages.UpdatePage;

end;

procedure TfmPages.UpdateObject;
begin
  FPages.UpdateObject;
end;

procedure TfmPages.btnOKClick(Sender: TObject);
begin
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

procedure TfmPages.lbPagesClick(Sender: TObject);
begin
  ShowPage(FPages[lbPages.ItemIndex]);
end;


end.
