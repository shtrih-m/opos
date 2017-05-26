unit ScaleFrame;

interface

type
  { TScaleFrame }

  TScaleFrame = class
  public
    class function GetCRC(const Data: string): Byte;
    class function Encode(const Data: string): string;
  end;

implementation

{ TScaleFrame }

class function TScaleFrame.Encode(const Data: string): string;
const
  STX = #2;
var
  DataLen: Integer;
begin
  DataLen := Length(Data);
  Result := Chr(DataLen) + Data;
  Result := STX + Result + Chr(GetCRC(Result));
end;

class function TScaleFrame.GetCRC(const Data: string): Byte;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Data) do
    Result := Result xor Ord(Data[i]);
end;

end.
