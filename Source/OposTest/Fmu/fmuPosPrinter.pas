unit fmuPosPrinter;

interface

uses
  // VCL
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Forms, SysUtils,
  Registry, ComCtrls,
  // Tnt
  TntStdCtrls, TntSysUtils,
  // This
  BaseForm, untPages, OposUtils, OposPosPrinter, VersionInfo, OposPtrUtils,
  fmuPtrGeneral;

type
  { TfmMain }

  TfmPosPrinter = class(TBaseForm)
    pnlData: TPanel;
    Panel1: TPanel;
    lblTime: TTntLabel;
    lblResult: TTntLabel;
    lblExtendedResult: TTntLabel;
    lblErrorString: TTntLabel;
    edtTime: TTntEdit;
    edtResult: TTntEdit;
    edtExtendedResult: TTntEdit;
    edtErrorString: TTntEdit;
    Panel2: TPanel;
    lbPages: TTntListBox;
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
    procedure UpdatePages(ListBox: TTntListBox; Pages: TPages);
  protected
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  fmPosPrinter: TfmPosPrinter;

implementation

{$R *.DFM}

{ TfmMain }

constructor TfmPosPrinter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TPages.Create;
end;

destructor TfmPosPrinter.Destroy;
begin
  FPages.Free;
  FreePosPrinter;
  inherited Destroy;
end;

procedure TfmPosPrinter.ReadState(Reader: TReader);
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

procedure TfmPosPrinter.AddPage(PageClass: TPageClass);
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

procedure TfmPosPrinter.CreatePages;
begin
  // General pages
  AddPage(TfmPtrGeneral);
end;

procedure TfmPosPrinter.UpdatePages(ListBox: TTntListBox; Pages: TPages);
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
        PageName := Tnt_WideFormat('%.2d. %s', [i+1, Pages[i].Caption]);
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

procedure TfmPosPrinter.StartCommand(Sender: TObject);
begin
  FStarted := True;
  FTickCount := GetTickCount;
end;

procedure TfmPosPrinter.UpdatePage(Sender: TObject);
var
  S: WideString;
begin
  S := PosPrinter.ErrorString;
  edtErrorString.Text := PosPrinter.ErrorString;
  if FStarted then
  begin
    edtTime.Text := IntToStr(GetTickCount - FTickCount) + ' ms.';
    FStarted := False;
  end else edtTime.Clear;

  edtResult.Text := GetResultCodeText(PosPrinter.ResultCode);
  edtExtendedResult.Text := GetResultCodeExtendedText(PosPrinter.ResultCodeExtended);
end;

procedure TfmPosPrinter.ShowPage(Page: TPage);
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

procedure TfmPosPrinter.lbPagesClick(Sender: TObject);
begin
  ShowPage(FPages[lbPages.ItemIndex]);
end;

procedure TfmPosPrinter.FormCreate(Sender: TObject);
begin
  CreatePages;
  UpdatePages(lbPages, FPages);
  ShowPage(FPages[0]);
end;

procedure TfmPosPrinter.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
