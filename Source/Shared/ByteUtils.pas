unit ByteUtils;

interface

function SwapByte(Value: Byte): Byte;
function SwapBytes(const S: string): string;
procedure SetBit(var Value: Byte; Bit: Byte);
function TestBit(Value: Int64; Bit: Integer): Boolean;

implementation

function TestBit(Value: Int64; Bit: Integer): Boolean;
begin
  Result := (Value and (1 shl Bit)) <> 0;
end;

procedure SetBit(var Value: Byte; Bit: Byte);
begin
  Value := Value or (1 shl Bit);
end;

function SwapByte(Value: Byte): Byte;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to 7 do
  begin
    if TestBit(Value, i) then SetBit(Result, 7-i);
  end;
end;

function SwapBytes(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + Chr(SwapByte(Ord(S[i])));
end;

end.
