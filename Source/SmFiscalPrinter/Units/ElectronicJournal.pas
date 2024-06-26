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
    class function DecodeDateLine(Line: WideString): WideString;
    function ReadEJSesssionDate(Printer: IFiscalPrinterDevice; SesssionNumber: Word): WideString;
    function ReadEJSesssionResult(Printer: IFiscalPrinterDevice; SesssionNumber: Word): WideString;
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

class function TElectronicJournal.DecodeDateLine(Line: WideString): WideString;
var
  R: TRegExpr;
  S: WideString;
  Date: TPrinterDateTime;
begin
  Result := '';
  R := TRegExpr.Create;
  try
    try
      // Date
      R.Expression := '[0-9]{2}/[0-9]{2}/[0-9]{2}';
      if not R.Exec(Line) then Exit;
      S := R.Match[0];
      Date.Day := StrToInt(Copy(S, 1, 2));
      Date.Month := StrToInt(Copy(S, 4, 2));
      Date.Year := StrToInt(Copy(S, 7, 2));
      // Time
      R.Expression := '[0-9]{2}:[0-9]{2}';
      if not R.Exec(Line) then Exit;
      S := R.Match[0];
      Date.Hour := StrToInt(Copy(S, 1, 2));
      Date.Min := StrToInt(Copy(S, 4, 2));
      Result := EncodeOposDate(Date);
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
  SesssionNumber: Word): WideString;
var
  Line: WideString;
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
    if Pos('����', Line) <> 0 then
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
  SesssionNumber: Word): WideString;
var
  Line: WideString;
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
