unit untPages;

interface

Uses
  // VCL
  Windows, Classes, SysUtils, Forms, Grids, Controls, StdCtrls,
  // Tnt
  TntSysUtils,
  // This
  BaseForm, untUtil, OposUtils;

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

    procedure InsertItem(AItem: TPage);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TPage read GetItem; default;
  end;

  { TPage }

  TPage = class(TBaseForm)
  private
    FOwner: TPages;
    FOnStart: TNotifyEvent;
    FOnUpdate: TNotifyEvent;
  protected
    procedure UpdatePage; virtual;
    procedure ReadState(Reader: TReader); override;
  public
    procedure EnableButtons(Value: Boolean); override;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnUpdate: TNotifyEvent read FOnUpdate write FOnUpdate;
  end;

  TPageClass = class of TPage;

function Date2Str(Value: TDateTime): WideString;
function DateTime2Str(Value: TDateTime): WideString;

implementation

function Date2Str(Value: TDateTime): WideString;
var
  Year, Month, Day: Word;
begin
  DecodeDate(Value, Year, Month, Day);
  Result := Tnt_WideFormat('%.2d%.2d%.4d0000', [Day, Month, Year]);
end;

function DateTime2Str(Value: TDateTime): WideString;
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(Value, Year, Month, Day);
  DecodeTime(Value, Hour, Min, Sec, MSec);
  Result := Tnt_WideFormat('%.2d%.2d%.4d%.2d%.2d', [Day, Month, Year, Hour, Min]);
end;

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

{ TPage }

procedure TPage.ReadState(Reader: TReader);
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

procedure TPage.UpdatePage;
begin
  if Assigned(FOnUpdate) then
    FOnUpdate(Self);
end;

procedure TPage.EnableButtons(Value: Boolean);
begin
  inherited EnableButtons(Value);
  try
    if Value then UpdatePage else
    begin
      if Assigned(FOnStart) then
        FOnStart(Self);
    end;
  except
    { !!! }
  end;
end;

end.
