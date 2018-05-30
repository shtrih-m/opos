unit PrinterFrame;

interface

type
  { TPrinterFrame }

  TPrinterFrame = class
  public
    class function GetCRC(const Data: AnsiString): Byte;
    class function Encode(const Data: AnsiString): AnsiString;
  end;

implementation

{ TPrinterFrame }

class function TPrinterFrame.Encode(const Data: AnsiString): AnsiString;
const
  STX = #2;
var
  DataLen: Integer;
begin
  DataLen := Length(Data);
  Result := Chr(DataLen) + Data;
  Result := STX + Result + Chr(GetCRC(Result));
end;

class function TPrinterFrame.GetCRC(const Data: AnsiString): Byte;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Data) do
    Result := Result xor Ord(Data[i]);
end;

end.
