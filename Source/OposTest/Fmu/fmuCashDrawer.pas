unit fmuCashDrawer;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Forms, SysUtils,
  Registry, ComCtrls,
  // Opos
  OposCashDrawer, OposUtils,
  // This
  BaseForm, untPages, fmuCashGeneral, fmuCashWait;

type
  { TfmMain }

  TfmCashDrawer = class(TBaseForm)
    pnlData: TPanel;
    Panel1: TPanel;
    lblTime: TLabel;
    lblResult: TLabel;
    lblExtendedResult: TLabel;
    edtTime: TEdit;
    edtResult: TEdit;
    edtExtendedResult: TEdit;
    Panel2: TPanel;
    lbPages: TListBox;
    procedure lbPagesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FPages: TPages;
    FLastPage: TForm;
    FStarted: Boolean;
    FTickCount: DWORD;
    procedure CreatePages;
    procedure ShowPage(Page: TPage);
    procedure UpdatePage(Sender: TObject);
    procedure StartCommand(Sender: TObject);
    procedure AddPage(PageClass: TPageClass);
    procedure UpdatePages(ListBox: TListBox; Pages: TPages);
  protected
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmCashDrawer: TfmCashDrawer;

implementation

{$R *.DFM}

{ TfmMain }

constructor TfmCashDrawer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TPages.Create;
end;

destructor TfmCashDrawer.Destroy;
begin
  FPages.Free;
  inherited Destroy;
end;

procedure TfmCashDrawer.ReadState(Reader: TReader);
var
  Value: Integer;
begin
  DisableAlign;
  try
    inherited ReadState(Reader);
    Value := GetSystemMetrics(SM_CYCAPTION);
    Height := Height + (Value-19);
  finally
    EnableAlign;
  end;
end;

procedure TfmCashDrawer.AddPage(PageClass: TPageClass);
var
  Page: TPage;
begin
  Page := PageClass.Create(Self);
  Page.OnUpdate := UpdatePage;
  Page.OnStart := StartCommand;
  Page.BorderStyle := bsNone;
  Page.Parent := pnlData;
  Page.Width := pnlData.ClientHeight;
  Page.Height := pnlData.ClientHeight;
  FPages.InsertItem(Page);
end;

procedure TfmCashDrawer.CreatePages;
begin
  AddPage(TfmCashGeneral);
  AddPage(TfmCashWait);
end;

procedure TfmCashDrawer.UpdatePages(ListBox: TListBox; Pages: TPages);
var
  i: Integer;
  PageName: string;
begin
  with ListBox do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      for i := 0 to Pages.Count-1 do
      begin
        PageName := Format('%.2d. %s', [i+1, Pages[i].Caption]);
        Items.Add(PageName);
      end;
    finally
      Items.EndUpdate;
    end;
  end;
  if Pages.Count > 0 then
  begin
    ListBox.ItemIndex := 0;
    ShowPage(Pages[0]);
  end;
end;

procedure TfmCashDrawer.StartCommand(Sender: TObject);
begin
  FStarted := True;
  FTickCount := GetTickCount;
end;

procedure TfmCashDrawer.UpdatePage(Sender: TObject);
begin
  if FStarted then
  begin
    edtTime.Text := IntToStr(GetTickCount - FTickCount) + ' ms.';
    FStarted := False;
  end else edtTime.Clear;
  edtResult.Text := GetResultCodeText(CashDrawer.ResultCode);
  //edtExtendedResult.Text := GetResultCodeExtendedText(CashDrawer.ResultCodeExtended);
end;

procedure TfmCashDrawer.ShowPage(Page: TPage);
begin
  if Page <> FLastPage then
  begin
    if Page <> nil then
    begin
      Page.Align := alClient;
      Page.Visible := True;
      Page.Width := pnlData.ClientWidth;
    end;
    if FLastPage <> nil then
      FLastPage.Visible := False;
    FLastPage := Page;
  end;
end;

// Events

procedure TfmCashDrawer.lbPagesClick(Sender: TObject);
begin
  ShowPage(FPages[lbPages.ItemIndex]);
end;

procedure TfmCashDrawer.FormCreate(Sender: TObject);
begin
  CreatePages;
  UpdatePages(lbPages, FPages);
  ShowPage(FPages[0]);
end;

procedure TfmCashDrawer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
