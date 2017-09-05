unit formatTLV;

interface

type
  TypeTLV = (tlvUnknown, tlvByte, tlvInt32, tlvInt16, tlvSTLV, tlvUnixTime, tlvVLN, tlvFVLN, tlvASCII);
type
  TFormatTLV = class

  public
    class function Format(t: TypeTLV; v: Variant): string;
    class function GetTypeTLV(MsgId: Integer): TypeTLV;
    class function Int2ValueTLV(aValue: UInt64; aSizeInBytes: Integer): string;
    class function Int2Bytes(Value: UInt64; SizeInBytes: Integer): string;
    class function VLN2ValueTLV(aValue: UInt64): string;
    class function FVLN2ValueTLV(aValue: Currency): string;
    class function UnixTime2ValueTLV(Value: TDateTime): string;
    class function ASCII2ValueTLV(aValue: WideString): string;

    class function ValueTLV2UnixTime(s: string): TDateTime;
    class function ValueTLV2Int(s: string): UInt64;
    class function ValueTLV2VLN(s: string): UInt64;
    class function ValueTLV2FVLN(s: string): Currency;
    class function ValueTLV2ASCII(s: string): WideString;


  end;

  TMsg = class

  end;


implementation
uses
  SysUtils, DateUtils, Windows;

class function TFormatTLV.Format(t: TypeTLV; v: Variant): string;
begin
  case t of
    tlvByte:
      Result := Int2ValueTLV(v, 1);

    tlvInt32:
      Result := Int2ValueTLV(v, 4);

    tlvInt16:
      Result := Int2ValueTLV(v, 2);

    tlvSTLV:
      Result := '';

    tlvUnixTime: 
      Result := UnixTime2ValueTLV(v);

    tlvVLN:
      Result := VLN2ValueTLV(v);

    tlvFVLN:
      Result := FVLN2ValueTLV(v);

    tlvASCII:
      Result := ASCII2ValueTLV(v);
  end;

end;

class function TFormatTLV.Int2Bytes(Value: UInt64; SizeInBytes: Integer): string;
var
  V: Int64;
  i: Integer;
begin
  Result := '';
  if not (SizeInBytes in [1..8]) then Exit;

  for i := 0 to SizeInBytes-1 do
  begin
    V := Value shr (i*8);
    if V = 0 then Break;
    Result := Chr(V and $FF) + Result;
  end;
  Result := StringOfChar(#0, SizeInBytes-Length(Result)) + Result;
end;

class function TFormatTLV.Int2ValueTLV(aValue: UInt64; aSizeInBytes: Integer): string;
var
  d: UInt64;
  i, c: Integer;
resourcestring
  MsgTooLargeData = 'too large data';
begin
  if (aSizeInBytes > 8) or (aSizeInBytes < 1) then
    raise Exception.Create(MsgTooLargeData);

  SetLength(Result, aSizeInBytes);

  c := 0;
  d := $FF;

  for i := 1 to aSizeInBytes do
  begin
    Result[i] := Char((aValue and d) shr c);
    c := c + 8;
    d := d shl 8;
  end;
end;

class function TFormatTLV.VLN2ValueTLV(aValue: UInt64): string;
var
  d: UInt64;
  i, c: Integer;
begin
  Result := '';
  if aValue = 0 then Exit;

  c := 0;
  d := $FF;

  for i := 1 to 8 do
  begin
    Result := Result + Char((aValue and d) shr c);
    c := c + 8;
    d := d shl 8;
    if (aValue shr c) = 0 then
      Break;
  end;
end;

class function TFormatTLV.FVLN2ValueTLV(aValue: Currency): string;
var
  i: UInt64;
  k: Byte;
  c: Currency;
begin
  i := Round(aValue);
  c := aValue;

  for k := 0 to 4 do
  begin
    if i = c then
      Break;

    c := c * 10;
    i := Round(c)
  end;

  Result := Char(k) + VLN2ValueTLV(i);
end;

(*
class function TFormatTLV.UnixTime2ValueTLV(Value: TDateTime): string;
begin
  Result := Int2Bytes(DateTimeToUnix(Value), 4);
end;
*)
class function TFormatTLV.UnixTime2ValueTLV(Value: TDateTime): string;
var
  V: Int64;
begin
  V := DateTimeToUnix(Value);
  Result := Chr(V and $FF);
  Result := Result + Chr((V shr 8) and $FF);
  Result := Result + Chr((V shr 16) and $FF);
  Result := Result + Chr((V shr 24) and $FF);
end;

class function TFormatTLV.ValueTLV2UnixTime(s: string): TDateTime;
begin
  Result := 0;
  if Length(s) <> 4 then
    Exit;

  Result := (((Byte(s[4]) shl 24) or (Byte(s[3]) shl 16) or (Byte(s[2]) shl 8) or Byte(s[1])) / 86400) + EncodeDateTime(1970, 1, 1, 3, 0, 0, 0);
  //Result := (((Byte(s[4]) shl 24) or (Byte(s[3]) shl 16) or (Byte(s[2]) shl 8) or Byte(s[1])) / 86400) + EncodeDateTime(1970, 1, 1, 0, 0, 0, 0);
end;

class function TFormatTLV.ASCII2ValueTLV(aValue: WideString): string;
var
  l: Integer;
  P: PChar;
begin
  Result := '';
  if aValue = '' Then
    Exit;

  l := WideCharToMultiByte(CP_OEMCP, WC_COMPOSITECHECK Or WC_DISCARDNS Or WC_SEPCHARS Or WC_DEFAULTCHAR, @aValue[1], -1, Nil, 0, Nil, Nil);
  if l > 1 then
  begin
    GetMem(P, l);
    SetLength(Result, l);
    WideCharToMultiByte(CP_OEMCP, WC_COMPOSITECHECK Or WC_DISCARDNS Or WC_SEPCHARS Or WC_DEFAULTCHAR, @aValue[1], -1, P, l - 1, Nil, Nil);
    P[l - 1] := #0;
    Result := Copy(P, 1, l - 1);
    FreeMem(P, l);
  end;
end;

class function TFormatTLV.ValueTLV2ASCII(s: string): WideString;
var
  l: Integer;
begin
  l := MultiByteToWideChar(CP_OEMCP, MB_PRECOMPOSED, PChar(@s[1]), -1, nil, 0);
  SetLength(Result, l - 1);
  if l > 1 then
    MultiByteToWideChar(CP_OEMCP, MB_PRECOMPOSED, PChar(@s[1]), -1, PWideChar(@Result[1]), l - 1);
end;

class function TFormatTLV.ValueTLV2Int(s: string): UInt64;
var
  i: Integer;
begin
  Result := 0;
  for i := Length(s) downto 1 do
  begin
    Result := Result * $100 + Byte(s[i]);
  end;
end;

class function TFormatTLV.ValueTLV2VLN(s: string): UInt64;
begin
  Result := ValueTLV2Int(s);
end;

class function TFormatTLV.ValueTLV2FVLN(s: string): Currency;
var
  i: Byte;
begin
  if Byte(s[1]) > 4 then
    raise Exception.Create('Неверная длина FVLN');

  if Length(s) < 2 then
    raise Exception.Create('Неверная длина FVLN');

  Result := ValueTLV2Int(Copy(s, 2, Length(s) - 1));
  for i := 1 to Byte(s[1]) do
    Result := Result / 10;
end;

class function TFormatTLV.GetTypeTLV(MsgId: Integer): TypeTLV;
begin
  case MsgId of
    7: //Ответ
      Result := tlvSTLV;

    1039:	//Номер средства формирования фискльного прихнака оператора
      Result := tlvASCII;

    1078:	//Фискальный признак оператора
      Result := tlvInt32;

    1068:	//Сообщение оператора для ФН
      Result := tlvSTLV;

    1067:	//Сообщение оператора для ККТ
      Result := tlvSTLV;

    1022:	//Код ответа ОФД
      Result := tlvByte;

    1017:	//ИНН ОФД
      Result := tlvASCII;

    1047:	//Параметр настройки
      Result := tlvSTLV;

    1019:	//Информационное сообщение
      Result := tlvASCII;

    1029:	//Наименование реквизита
      Result := tlvSTLV;

    1014:	//Значение типа строка
      Result := tlvASCII;

    1015:	//Значение типа целое
      Result := tlvInt32;

    else
      Result := tlvUnknown;

  end;

  if Result = tlvUnknown then
    //raise Exception.Create('Неизвестный пакет');
end;

end.
