unit TextReport;

interface

uses
  // VCL
  Classes, SysUtils, Variants,
  // Tnt
  TntClasses;


type
  { TTextReport }

  TTextReport = class
  private
    FLines: TTntStrings;
    FCaptionLen: Integer;
    function GetText: WideString;
  public
    constructor Create(CaptionLen: Integer);
    destructor Destroy; override;

    procedure Clear;
    procedure Add(const Caption: WideString; Value: Variant);

    property Text: WideString read GetText;
    property Lines: TTntStrings read FLines;
  end;

implementation

{ TTextReport }

constructor TTextReport.Create(CaptionLen: Integer);
begin
  inherited Create;
  FCaptionLen := CaptionLen;
  FLines := TTntStringList.Create;
end;

destructor TTextReport.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TTextReport.Clear;
begin
  FLines.Clear;
end;

function TTextReport.GetText: WideString;
begin
  Result := FLines.Text;
end;

procedure TTextReport.Add(const Caption: WideString; Value: Variant);
begin
  Lines.Add(Format('%-*s : %s', [FCaptionLen, Caption, VarToStr(Value)]));
end;


end.
