unit ElectronicJournal;

interface

uses
  // VCL
  Classes, SysUtils,
  // Opos
  OposUtils, OposFptrUtils,
  // This
  PrinterTypes, RegExpr, FiscalPrinterDevice, FiscalPrinterTypes, WException,
  gnugettext;

type
  { TElectronicJournal }

  TElectronicJournal = class
  private
    procedure CheckStatus(Printer: IFiscalPrinterDevice);
  public
    class function DecodeDateLine(Line: string): string;
    function ReadEJSesssionDate(Printer: IFiscalPrinterDevice; SesssionNumber: Word): string;
    function ReadEJSesssionResult(Printer: IFiscalPrinterDevice; SesssionNumber: Word): string;
  end;

implementation

{ TElectronicJournal }

procedure TElectronicJournal.CheckStatus(Printer: IFiscalPrinterDevice);
var
  Status: TEJStatus1;
begin
  Printer.Check(Printer.GetEJStatus1(Status));
  if Status.Flags.ReportMode then
    Printer.Check(Printer.EJReportStop);
end;

class function TElectronicJournal.DecodeDateLine(Line: string): string;
var
  R: TRegExpr;
  S: string;
  OposDate: TOposDate;
begin
  Result := '';
  R := TRegExpr.Create;
  try
    try
      // Date
      R.Expression := '[0-9]{2}/[0-9]{2}/[0-9]{2}';
      if not R.Exec(Line) then Exit;
      S := R.Match[0];
      OposDate.Day := StrToInt(Copy(S, 1, 2));
      OposDate.Month := StrToInt(Copy(S, 4, 2));
      OposDate.Year := 2000 + StrToInt(Copy(S, 7, 2));
      // Time
      R.Expression := '[0-9]{2}:[0-9]{2}';
      if not R.Exec(Line) then Exit;
      S := R.Match[0];
      OposDate.Hour := StrToInt(Copy(S, 1, 2));
      OposDate.Min := StrToInt(Copy(S, 4, 2));
      Result := EncodeOposDate(OposDate);
    except
      on E: Exception do
      begin
        raiseException(_('Failed parsing electronic journal report.') + GetExceptionMessage(E));
      end;
    end;
  finally
    R.Free;
  end;
end;

function TElectronicJournal.ReadEJSesssionDate(
  Printer: IFiscalPrinterDevice;
  SesssionNumber: Word): string;
var
  Line: string;
  AResult: Integer;
  LineCount: Integer;
const
  MaxLineCount = 10;
begin
  CheckStatus(Printer);

  Result := '';
  LineCount := 0;
  Printer.Check(Printer.GetEJSesssionResult(SesssionNumber, Line));
  repeat
    AResult := Printer.GetEJReportLine(Line);
    if Pos('«¿ –', Line) <> 0 then
    begin
      Result := Line;
      Break;
    end;
    if AResult = EJ_NO_MORE_DATA then Break;
    Printer.Check(AResult);

    Inc(LineCount);
    if LineCount > MaxLineCount then Break;
  until false;
  Printer.Check(Printer.EJReportStop);

  if LineCount > MaxLineCount then
    raiseException(_('Date line not found'));

  Result := DecodeDateLine(Result);
  if Result = '' then
    raiseException(_('Failed parsing electronic journal report. Date not found'));
end;

function TElectronicJournal.ReadEJSesssionResult(
  Printer: IFiscalPrinterDevice;
  SesssionNumber: Word): string;
var
  Line: string;
  AResult: Integer;
begin
  Result := '';
  Printer.Check(Printer.GetEJSesssionResult(SesssionNumber, Line));
  repeat
    AResult := Printer.GetEJReportLine(Line);
    Result := Result + #13#10 + Line;
    if AResult = EJ_NO_MORE_DATA then Break;
    Printer.Check(AResult);
  until false;
  Printer.Check(Printer.EJReportStop);
end;

end.
