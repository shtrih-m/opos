unit TankFilter;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // Tnt
  TntClasses, TntSysUtils,
  // This
  FiscalPrinterTypes, NonfiscalDoc, TankReader, PrinterTypes,
  PrinterParameters, FptrFilter, CustomReceipt, MalinaParams;

type
  { TTankFilter }

  TTankFilter = class(TFptrFilter)
  private
    FReader: TTankReader;
    FPrinter: ISharedPrinter;

    function CreateReport: WideString;
    function GetTag(const Line: WideString; var Tag: WideString): Boolean;
    function ReplaceTags(const S: WideString;
      Values: TTntStrings): WideString;
    function ReplaceTagsText(const Template: WideString;
      Values: TTntStrings): WideString;
    function GetMalinaParams: TMalinaParams;

  public
    constructor Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);
    destructor Destroy; override;

    procedure EndNonFiscal(Doc: TNonfiscalDoc); override;
    property Reader: TTankReader read FReader;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

const
  TankReportNoData =
    '           Нет данных            ' + CRLF +
    ' Пожалуйста повторите вывод отчета';

implementation

{ TTankFilter }

constructor TTankFilter.Create(AOwner: TFptrFilters; APrinter: ISharedPrinter);
begin
  inherited Create(AOwner);
  FPrinter := APrinter;
  FReader := TTankReader.Create;
end;

destructor TTankFilter.Destroy;
begin
  FReader.Free;
  FPrinter := nil;
  inherited Destroy;
end;

function TTankFilter.GetTag(const Line: WideString;
  var Tag: WideString): Boolean;
var
  i: Integer;
  HasStartTag: Boolean;
  StartIndex: Integer;
const
  TagStart = '[';
  TagStop = ']';
begin
  Tag := '';
  Result := False;
  StartIndex := 1;
  HasStartTag := False;
  for i := 1 to Length(Line) do
  begin
    if Line[i] = TagStart then
    begin
      StartIndex := i;
      HasStartTag := True;
    end;
    if Line[i] = TagStop then
    begin
      if HasStartTag then
      begin
        Tag := Copy(Line, StartIndex+1, i-StartIndex-1);
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function IsManualTag(const TagName: WideString): Boolean;
begin
  Result := Pos('MANUAL_', TagName) <> 0;
end;


function TTankFilter.ReplaceTags(const S: WideString;
  Values: TTntStrings): WideString;
var
  Line: WideString;
  TagName: WideString;
  TagValue: WideString;
begin
  Line := S;
  while GetTag(Line, TagName) do
  begin
    if IsManualTag(TagName) then
      Line := GetMalinaParams.TankManualLine + CRLF + Line;

    TagValue := Values.Values[TagName];
    TagName := '[' + TagName + ']';
    Line := Tnt_WideStringReplace(Line, TagName, TagValue, [
      rfReplaceAll, rfIgnoreCase]);
  end;
  Result := Line;
end;

function TTankFilter.ReplaceTagsText(const Template: WideString;
  Values: TTntStrings): WideString;
var
  i: Integer;
  Lines: TTntStrings;
begin
  Result := '';
  Lines := TTntStringList.Create;
  try
    Lines.Text := Template;
    for i := 0 to Lines.Count-1 do
    begin
      Lines[i] := ReplaceTags(Lines[i], Values);
    end;
    Result := Lines.Text;
  finally
    Lines.Free;
  end;
end;

function TTankFilter.CreateReport: WideString;
var
  i: Integer;
begin
  if FReader.DataReady then
  begin
    Result := ReplaceTagsText(GetMalinaParams.TankReportHeader, FReader.Values) + CRLF;
    for i := 0 to FReader.Tanks.Count-1 do
    begin
      Result := Result + ReplaceTagsText(GetMalinaParams.TankReportItem,
        FReader.Tanks[i].Values) + CRLF;
    end;
    Result := Result + ReplaceTagsText(GetMalinaParams.TankReportTrailer, FReader.Values);
  end else
  begin
    Result := ReplaceTagsText(GetMalinaParams.TankReportHeader, FReader.Values) + CRLF;
    Result := Result + TankReportNoData + CRLF;
    Result := Result + ReplaceTagsText(GetMalinaParams.TankReportTrailer, FReader.Values);
  end;
end;

procedure TTankFilter.EndNonFiscal(Doc: TNonfiscalDoc);
var
  Text: WideString;
begin
  if Doc.HasLine(GetMalinaParams.TankReportKey) then
  begin
    FReader.Load;
    Doc.Clear;
    Text := CreateReport;
    Doc.Add(PRINTER_STATION_REC, Text);
  end;
end;

function TTankFilter.GetMalinaParams: TMalinaParams;
begin
  Result := FPrinter.Device.Context.MalinaParams;
end;

end.
