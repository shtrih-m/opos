unit BStrUtil;

interface

uses
  Windows, SysUtils, Classes,
  // 3'd
  TntSysUtils, TntClasses;

type
  TSetOfChar = set of Char;
  TSetOfByte = set of Byte;
  TEntryCodeToName = record
    Code: Integer;
    Name: AnsiString;
  end;
  
  { TAnsiStringParser }

  TAnsiStringParser = class
  private
    fLen: Integer;
    fLine: AnsiString;
    fDelimiters: TSetOfChar;
    procedure SetLine(const Value: AnsiString);
  protected
    fLastPos: Integer;
  public
    function NextToken: AnsiString;
    property Line: AnsiString read fLine write SetLine;
    property Delimiters: TSetOfChar read fDelimiters write fDelimiters;
    property Len: Integer read fLen;
    property LastPos: Integer read fLastPos;
  end;

function TrimStr(const S: AnsiString; Valid: TSetOfChar): AnsiString;
function HasSymbols(const S: AnsiString; const Symbols: TSetOfChar): Boolean;
// Get k-index parameter of AnsiString type
function GetStringK(const S: AnsiString; K: Integer; Delimiters: TSetOfChar): AnsiString;
procedure StringsSetText(const Text: AnsiString; Delimiters: TSetOfChar;
  Strings: TTntStrings);
{ StringsToAnsiString }
// AppendStr(Result, Strings[I]);
function StringsToAnsiString(Strings: TTntStrings): AnsiString;

function RemoveFirstBkSlash(const Name: AnsiString): AnsiString;
function RemoveLastBkSlash(const Name: AnsiString): AnsiString;
function AddLastBkSlash(const Name: AnsiString): AnsiString;
function AddFirstBkSlash(const Name: AnsiString): AnsiString;
// Replace AnsiString by another AnsiString
function PutValue(
  // Source AnsiString
  const Src,
  // What to replace
  VarName,
  // Replace AnsiString
  VarValue: AnsiString;
  // Output AnsiString
  var Dst: AnsiString;
  // Ignore case
  IgnoreCase: Boolean):
  // True if something changed
  Boolean;

// Removes first 'T' from class name
function RemoveFirstT(const ClassName: AnsiString): AnsiString;

function ControlToChar(const Value: AnsiString): AnsiString;
function CharToControl(const Value: AnsiString): AnsiString;

procedure StringsAssignItems(Strings: TTntStrings;
  const Items: array of AnsiString);

procedure StringsAssignEntries(Strings: TTntStrings;
  Entries: array of TEntryCodeToName; EnabledCodes: TSetOfByte);

procedure SkipBlanks(const S: AnsiString; var P: Integer);

implementation

function TrimStr(const S: AnsiString; Valid: TSetOfChar): AnsiString;
var
  I, L, P: Integer;
begin
  Result := '';
  L := Length(S);
  I := 1;
  while (I <= L) do
  begin
    while (I <= L) and not (S[I] in Valid) do
     Inc(I);
    P := I;
    while (I <= L) and (S[I] in Valid) do
      Inc(I);
    Result := Result + Copy(S, P, I - P);
  end;
end;

function HasSymbols(const S: AnsiString; const Symbols: TSetOfChar): Boolean;
var
  I: Integer;
begin
  for I := 1 to Length(S) do
  begin
    if (S[I] in Symbols) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function GetStringK(const S: AnsiString; K: Integer; Delimiters: TSetOfChar): AnsiString;
var
  LastPos: Integer;
  CurPos: Integer;
  CurParam: Integer;
  Len: Integer;
begin
  Result := '';
  Len := Length(S);
  CurParam := 1;
  CurPos := 1;
  while (CurPos <= Len) and (CurParam <= K) do
  begin
    LastPos := CurPos;
    while (CurPos <= Len) and not (S[CurPos] in Delimiters) do Inc(CurPos);
    if CurParam = K then
    begin
      Result := Copy(S, LastPos, CurPos - LastPos);
      Exit;
    end;
    Inc(CurPos);
    Inc(CurParam);
  end;
  Result := '';
end;

procedure StringsSetText(const Text: AnsiString; Delimiters: TSetOfChar;
  Strings: TTntStrings);
var
  P, Start: PChar;
  S: AnsiString;
begin
  Include(Delimiters, #0);
  Strings.BeginUpdate;
  try
    Strings.Clear;
    P := Pointer(Text);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not (P^ in Delimiters) do Inc(P);
        SetString(S, Start, P - Start);
        Strings.Add(S);
        if (P^ <> #0) and (P^ in Delimiters) then Inc(P);
      end;
  finally
    Strings.EndUpdate;
  end;
end;

function StringsToAnsiString(Strings: TTntStrings): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Strings.Count - 1 do
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + Strings[I];
  end;
end;

function RemoveFirstBkSlash(const Name: AnsiString): AnsiString;
begin
  Result := Name;
  if (Result <> '')
     and (Result[1] = '\') then Result := Copy(Result, 2, MaxInt);
end;

function RemoveLastBkSlash(const Name: AnsiString): AnsiString;
begin
  Result := Name;
  if (Result <> '')
     and (Result[Length(Result)] = '\') then
    SetLength(Result, Length(Result) - 1);
end;

function AddFirstBkSlash(const Name: AnsiString): AnsiString;
begin
  Result := Name;
  if (Result <> '') and (Result[1] <> '\') then
    Result := '\' + Result;
end;

function AddLastBkSlash(const Name: AnsiString): AnsiString;
begin
  Result := Name;
  if (Result <> '')
     and (Result[Length(Result)] <> '\') then
       Result := Result + '\';
end;

function PutValue(const Src, VarName, VarValue: AnsiString; var Dst: AnsiString;
  IgnoreCase: Boolean): Boolean;
var
  P: Integer;
  strTemp: AnsiString;
begin
  Result := False;
  Dst := '';
  strTemp := Src;
  repeat
    if IgnoreCase then
      P := Pos(AnsiUpperCase(VarName), AnsiUpperCase(strTemp))
    else
      P := Pos(VarName, strTemp);
    if P = 0 then
    begin
      Dst := Dst + strTemp;
    end
    else
    begin
      Result := True;
      Dst :=  Dst + Copy(strTemp, 1, P - 1) + VarValue;
      strTemp := Copy(strTemp, P + Length(VarName), MaxInt);
    end;
  until (P = 0);
end;

function RemoveFirstT(const ClassName: AnsiString): AnsiString;
begin
  if ClassName[1] = 'T' then
    Result := Copy(ClassName, 2, MaxInt)
  else
    Result := ClassName;
end;

{ TAnsiStringParser }

function TAnsiStringParser.NextToken: AnsiString;
var
  I: Integer;
begin
  Result := '';
  I := fLastPos;
  if (I <= fLen) then
  begin
    // Skip delimeter symbols
    while (I <= fLen) and (Line[I] in Delimiters) do Inc(I);
    fLastPos := I;
    // Go to first delimeter
    while (I <= fLen) and not (Line[I] in Delimiters) do Inc(I);
    Result := Copy(Line, fLastPos, I - fLastPos);
    fLastPos := I + 1;
  end;
end;

procedure TAnsiStringParser.SetLine(const Value: AnsiString);
begin
  fLastPos := 1;
  fLine := Value;
  fLen := Length(fLine);
end;

function ControlToChar(const Value: AnsiString): AnsiString;
const
  chrZero = ' ';
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if Value[I] < chrZero then
    begin
      if (I > 1) and (Value[I-1] >= chrZero) then Result := Result + '''';
      Result := Result + Tnt_WideFormat('#%.2d', [Ord(Value[I])])
    end
    else
    begin
      if ((I > 1) and (Value[I-1] < chrZero)) or (I = 1) then Result := Result + '''';
      Result := Result + Value[I];
    end;
  end;
  if (Value <> '') and (Value[Length(Value)] >= chrZero) then
    Result := Result + '''';
end;

procedure SkipBlanks(const S: AnsiString; var P: Integer);
begin
  while (P <= Length(S)) and (S[P] = ' ') do Inc(P);
end;

function CharToControl(const Value: AnsiString): AnsiString;
type
  TState = (Unknown, FoundGrid, FoundApostrophe, WaitApostropheEnd);
const
  strUnknown = 'Unknown symbol [%s] in position [%d]';
  strNoAnsiStringEnd = 'No AnsiString end';
var
  State: TState;
  strControl: AnsiString;
  I: Integer;
begin
  Result := '';
  I := 1;
  SkipBlanks(Value, I);
  State := Unknown;
  while True do
  begin
    case State of
    Unknown:
      begin
        if (I > Length(Value)) then Break;
        case Value[I] of
        '''':
          begin
            State := FoundApostrophe;
            Inc(I);
            Continue;
          end;
        '#':
          begin
            State := FoundGrid;
            Inc(I);
            Continue;
          end;
        else
          raise Exception.CreateFmt(strUnknown, [Value[I], I])
        end;
      end;
    FoundGrid:
      begin
        if (I > Length(Value)) then // ??? #
          raise Exception.CreateFmt(strUnknown, [Value[I-1], I-1]);
        if not (Value[I] in ['0'..'9']) then  // ??? #.
          raise Exception.CreateFmt(strUnknown, [Value[I], I]);
        // Current state #X
        strControl := Value[I];
        Inc(I);
        if (I > Length(Value)) then
        begin
          Result := Result + Chr(StrToInt(strControl));
          Exit; // End of AnsiString
        end;
        if not (Value[I] in ['0'..'9']) then
        begin
          // Current state is #X.
          Result := Result + Chr(StrToInt(strControl));
          State := Unknown;
          Continue;
        end;
        // Current state is #XX
        strControl := strControl + Value[I];
        Inc(I);
        if (I > Length(Value)) then
        begin
          Result := Result + Chr(StrToInt(strControl));
          Exit;
        end;
        if not (Value[I] in ['0'..'9']) then
        begin
          // Current state is #XX.
          Result := Result + Chr(StrToInt(strControl));
          State := Unknown;
          Continue;
        end;
        // Current state is #XXX
        strControl := strControl + Value[I];
        if strControl > '255' then
          raise Exception.CreateFmt(strUnknown, [Value[I], I]);
        Result := Result + Chr(StrToInt(strControl));
        State := Unknown;
        Inc(I);
        Continue;
      end;
    FoundApostrophe:
      begin
        if (I > Length(Value)) then
          raise Exception.CreateFmt(strUnknown, [Value[I-1], I-1]);
        // Current state is '
        if Value[I] <> '''' then
        begin
          // Current state is '.
          State := WaitApostropheEnd; // Wait for AnsiString end
          Result := Result + Value[I];
          Inc(I);
          Continue;
        end;
        // Current state is ''
        Inc(I);
        if (I > Length(Value)) then Exit; //  Empty AnsiString
        if (Value[I] <> '''') then
        begin
          // Current state is ''.
          State := Unknown; // Empty AnsiString, skip
          Continue;
        end;
        // Current state is '''
        Inc(I);
        if (I > Length(Value)) then   // Incomprehensible when ''' and than all
          raise Exception.CreateFmt(strUnknown, [Value[I-1], I-1]);
        if (Value[I] <> '''') then
        begin
          // Current state is '''.
          State := WaitApostropheEnd; // Wait for AnsiString end
          Result := Result + Value[I];
          Continue;
        end;
        // Current state ''''
        Result := Result + '''';   // Found  ''''
        Inc(I);
        State := Unknown;
        Continue;
      end;
    WaitApostropheEnd:
      begin
        if (I > Length(Value)) then
          raise Exception.Create(strNoAnsiStringEnd);
        if Value[I] <> '''' then
        begin
          // Current state is '...
          Result := Result + Value[I];
          Inc(I);
          Continue;
        end;
        // Current state is '...'
        Inc(I);
        if (I > Length(Value)) then Exit; // AnsiString end detected
        if (Value[I] <> '''') then // AnsiString end detected
        begin
          // Current state is '...'.
          State := Unknown;
          Continue;
        end;
        // Current state is '...''
        Inc(I);
        if (I > Length(Value)) then
          raise Exception.CreateFmt(strUnknown, [Value[I-1], I-1]);
        if (Value[I] = '#') then  // Incomprehensible '...''#
          raise Exception.CreateFmt(strUnknown, [Value[I], I]);
        if (Value[I] <> '''') then
        begin
          // Current state is '...''.
          Result := Result + Value[I];
          Inc(I);
          Continue; // Wait for AnsiString end
        end;
        // Current state is '...'''
        Result := Result + '''';
        State := Unknown;
        Inc(I);
        Continue;
      end;
    end;
  end;
end;

procedure StringsAssignEntries(Strings: TTntStrings;
  Entries: array of TEntryCodeToName; EnabledCodes: TSetOfByte);
var
  I: Integer;
  Entry: TEntryCodeToName;
begin
  with Strings do
  begin
    BeginUpdate;
    try
      Clear;
      for I := Low(Entries) to High(Entries) do
      begin
        Entry := Entries[I];
        if Entry.Code in EnabledCodes then
          AddObject(Entry.Name, TObject(Entry.Code));
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure StringsAssignItems(Strings: TTntStrings;
  const Items: array of AnsiString);
var
  I: Integer;
begin
  with Strings do
  begin
    BeginUpdate;
    try
      Clear;
      for I := Low(Items) to High(Items) do
      begin
        AddObject(Items[I], TObject(I));
      end;
    finally
      EndUpdate;
    end;
  end;
end;

end.
