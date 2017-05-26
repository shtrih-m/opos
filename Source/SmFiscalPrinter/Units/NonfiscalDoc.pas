unit NonfiscalDoc;

interface

uses
  // Tnt
  TntClasses, TntSysUtils,
  //
  ReceiptPrinter;

type
  { TLineRec }

  TLineRec = record
    Text: WideString;
    Station: Integer;
  end;

  { TNonfiscalDoc }

  TNonfiscalDoc = class
  private
    FLines: TTntStrings;
    FIsBuffered: Boolean;
    FPrinter: IReceiptPrinter;

    function GetText: WideString;
    function GetLineCount: Integer;
    procedure SetLine(Index: Integer; const Value: TLineRec);
  public
    Cancelled: Boolean;
    constructor Create(APrinter: IReceiptPrinter; IsBuffered: Boolean);
    destructor Destroy; override;

    procedure BeginNonFiscal;
    procedure EndNonFiscal;
    procedure Add(Station: Integer; const AText: WideString);
    procedure PrintNormal(Station: Integer; const AText: WideString);

    procedure Clear;
    function GetLine(Index: Integer): TLineRec;
    function HasLine(const Line: WideString): Boolean;

    property Text: WideString read GetText;
    property LineCount: Integer read GetLineCount;
    property Lines[Index: Integer]: TLineRec read GetLine write SetLine;
  end;

implementation

{ TNonfiscalDoc }

constructor TNonfiscalDoc.Create(APrinter: IReceiptPrinter; IsBuffered: Boolean);
begin
  inherited Create;
  FLines := TTntStringList.Create;
  FPrinter := APrinter;
  FIsBuffered := IsBuffered;
end;

destructor TNonfiscalDoc.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TNonfiscalDoc.Clear;
begin
  FLines.Clear;
end;

procedure TNonfiscalDoc.PrintNormal(Station: Integer; const AText: WideString);
begin
  if FIsBuffered then
  begin
    FLines.AddObject(AText, TObject(Station));
  end else
  begin
    FPrinter.PrintTextLine(AText);
  end;
end;

procedure TNonfiscalDoc.Add(Station: Integer; const AText: WideString);
begin
  FLines.AddObject(AText, TObject(Station));
end;

function TNonfiscalDoc.GetText: WideString;
begin
  Result := FLines.Text;
end;

function TNonfiscalDoc.GetLine(Index: Integer): TLineRec;
begin
  Result.Text := FLines[Index];
  Result.Station := Integer(FLines.Objects[Index]);
end;

function TNonfiscalDoc.GetLineCount: Integer;
begin
  Result := FLines.Count;
end;

procedure TNonfiscalDoc.SetLine(Index: Integer; const Value: TLineRec);
begin
  FLines[Index] := Value.Text;
  FLines.Objects[Index] := TObject(Value.Station);
end;

function TNonfiscalDoc.HasLine(const Line: WideString): Boolean;
begin
  Result := WideTextPos(Line, Text) <> 0;
end;

procedure TNonfiscalDoc.BeginNonFiscal;
begin
  Cancelled := False;
  FLines.Clear;
end;

procedure TNonfiscalDoc.EndNonFiscal;
var
  i: Integer;
  Text: WideString;
begin
  Cancelled := False;
  for i := 0 to FLines.Count-1 do
  begin
    Text := FLines[i];
    FPrinter.PrintTextLine(Text);
  end;
end;

end.
