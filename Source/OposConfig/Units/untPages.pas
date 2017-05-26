unit untPages;

interface

Uses
  // VCL
  Windows, Classes, SysUtils, Forms, Grids, Controls, StdCtrls,
  // This
  BaseForm;

type
  TPage = class;

  { TPages }

  TPages = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TPage;
  public
    constructor Create;
    destructor Destroy; override;
    procedure UpdatePage; virtual;
    procedure UpdateObject; virtual;

    procedure InsertItem(AItem: TPage);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPage read GetItem; default;
  end;

  { TPage }

  TPage = class(TBaseForm)
  private
    FOwner: TPages;
    FOnModified: TNotifyEvent;
  public
    procedure Modified;
    procedure UpdatePage; virtual;
    procedure UpdateObject; virtual;

    property Owner: TPages read FOwner;
    property OnModified: TNotifyEvent read FOnModified write FOnModified;
  end;
  TPageClass = class of TPage;

implementation

{ TPages }

constructor TPages.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TPages.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TPages.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPages.GetItem(Index: Integer): TPage;
begin
  Result := FList[Index];
end;

procedure TPages.InsertItem(AItem: TPage);
begin
  FList.Add(AItem);
  AItem.FOwner := Self;
end;

procedure TPages.UpdateObject;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].UpdateObject;
end;

procedure TPages.UpdatePage;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].UpdatePage;
end;

{ TPage }

procedure TPage.UpdateObject;
begin

end;

procedure TPage.UpdatePage;
begin

end;

procedure TPage.Modified;
begin
  if Assigned(FOnModified) then
    FOnModified(Self);
end;


end.
