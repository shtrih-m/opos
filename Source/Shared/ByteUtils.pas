unit ByteUtils;

interface

uses
  Math;

function SwapByte(Value: Byte): Byte;
function SwapBytes(const S: AnsiString): AnsiString;
procedure SetBit(var Value: Byte; Bit: Byte);
function TestBit(Value: Int64; Bit: Integer): Boolean;

type
  { TBits }

  TBits = class
  private
    FBits: array of Byte;
    FBytes: array of Byte;
  public
    procedure Clear;
    procedure UpdateBytes;
    function SizeInBits: Integer;
    function SizeInBytes: Integer;
    function Bytes(Index: Integer): Integer;
    procedure Add(Value: Int64; Count: Integer);
  end;

implementation

function TestBit(Value: Int64; Bit: Integer): Boolean;
begin
  Result := ((Value shr Bit) and 1) <> 0;
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

function SwapBytes(const S: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + Chr(SwapByte(Ord(S[i])));
end;

{ TBits }

procedure TBits.add(Value: Int64; Count: Integer);
var
  i: Integer;
  Index: Integer;
begin
  Index := SizeInBits;
  SetLength(FBits, SizeInBits + Count);
  for i := 0 to Count-1 do
  begin
    FBits[Index + i] := (Value shr (count-1-i)) and 1;
  end;
end;

procedure TBits.UpdateBytes;
var
  B: Byte;
  Bit: Integer;
  Count: Integer;
  Index: Integer;
begin
  SetLength(FBytes, SizeInBytes);
  B := 0;
  Count := 0;
  Index := 0;
  while Index < Length(FBits) do
  begin
    Bit := Index mod 8;
    B := B + (FBits[Index] shl (7-Bit));
    Inc(Count);
    if Count = 8 then
    begin
      FBytes[Index div 8] := B;
      Count := 0;
      B := 0;
    end;
    Inc(Index);
  end;
  if Count <> 0 then
  begin
    FBytes[SizeInBytes-1] := B;
  end;
end;

function TBits.Bytes(Index: Integer): Integer;
begin
  Result := FBytes[Index];
end;

function TBits.SizeInBits: Integer;
begin
  Result := Length(FBits);
end;

function TBits.SizeInBytes: Integer;
begin
  Result := (SizeInBits + 7) div 8;
end;

procedure TBits.Clear;
begin
  SetLength(FBits, 0);
  SetLength(FBytes, 0);
end;

end.
