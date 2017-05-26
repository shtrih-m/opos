unit OPOSDate;

interface

uses
  // VCL
  SysUtils;

type
  { TOPOSDate }

  TOPOSDate = class
  private
    FAsString: string;
    function GetAsDate: TDateTime;
    procedure SetAsDate(const Value: TDateTime);
    procedure SetAsString(const Value: string);
  public
    property AsDate: TDateTime read GetAsDate write SetAsDate;
    property AsString: string read FAsString write SetAsString;
  end;

implementation

{ TOPOSDate }

// ddmmyyyyhhnn

function TOPOSDate.GetAsDate: TDateTime;
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  Day := StrToInt(Copy(AsString, 1, 2));
  Month := StrToInt(Copy(AsString, 3, 2));
  Year := StrToInt(Copy(AsString, 5, 4));
  Hour := StrToInt(Copy(AsString, 9, 2));
  Min := StrToInt(Copy(AsString, 11, 2));
  Sec := 0;
  MSec := 0;
  Result := EncodeDate(Year, Month, Day) + EncodeTime(Hour, Min, Sec, MSec);
end;

procedure TOPOSDate.SetAsDate(const Value: TDateTime);
begin
  FAsString := FormatDateTime('ddmmyyyyhhnn', Value);
end;

procedure TOPOSDate.SetAsString(const Value: string);
begin
  FAsString := Value;
end;

end.
