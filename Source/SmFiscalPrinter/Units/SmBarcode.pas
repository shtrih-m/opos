unit SmBarcode;

interface

uses
  // VCL
  SysUtils;

(******************************************************************************

   Convert data to Code128 barcode

   Input data  : Barcode type and data
   Output data : data string where each byte corresponds to its dot

   Features:

   1. Barcode type must be selected before conversion.
      Not realized transition coding between Code128 barcode types

******************************************************************************)

type
  TSmBarcodeAlignment = (baCenter, baLeft, baRight);
  TSmBarcodeType = (smCode128A, smCode128B, smCode128C);

  { TSmBarcodeRec }

  TSmBarcodeRec = record
    Data: string;                 // Barcode data
    BarWidth: Integer;            // bar width in dots
    BarcodeType: TSmBarcodeType;    // Barcode type
    Alignment: TSmBarcodeAlignment; // Barcode alignment
  end;

  { TSmBarcode }

  TSmBarcode = class
  private
    FLineData: string;
    FBarcodeLine: string;
    FBarcodeWidth: Integer;
    procedure AlignLeft;
    procedure AlignRight;
    procedure AlignCenter;
    procedure MakeAlignment;
    procedure CreateCode128A;
    procedure CreateCode128B;
    procedure CreateCode128C;
    function FindCode128A(c: char): Integer;
    function FindCode128B(c: char): Integer;
    function FindCode128C(c: string): Integer;
    procedure MakeBarWidth;
  public
    PrintWidth: Integer; // Printer print width
    Barcode: TSmBarcodeRec;

    constructor Create;
    procedure CreateBarcode;
    function GetBarcode128Types: string;

    property LineData: string read FLineData;
    property BarcodeLine: string read FBarcodeLine;
    property BarcodeWidth: Integer read FBarcodeWidth;
  end;

implementation

type
  { TCode128 }

  TCode128 = record
    a, b : char;
    c: string[2];
    data: string[6];
  end;

const
  Table128: array[0..102] of TCode128 =
  (
  ( a:' '; b:' '; c:'00'; data:'212222' ),
  ( a:'!'; b:'!'; c:'01'; data:'222122' ),
  ( a:'"'; b:'"'; c:'02'; data:'222221' ),
  ( a:'#'; b:'#'; c:'03'; data:'121223' ),
  ( a:'$'; b:'$'; c:'04'; data:'121322' ),
  ( a:'%'; b:'%'; c:'05'; data:'131222' ),
  ( a:'&'; b:'&'; c:'06'; data:'122213' ),
  ( a:''''; b:''''; c:'07'; data:'122312' ),
  ( a:'('; b:'('; c:'08'; data:'132212' ),
  ( a:')'; b:')'; c:'09'; data:'221213' ),
  ( a:'*'; b:'*'; c:'10'; data:'221312' ),
  ( a:'+'; b:'+'; c:'11'; data:'231212' ),
  ( a:','; b:','; c:'12'; data:'112232' ),
  ( a:'-'; b:'-'; c:'13'; data:'122132' ),
  ( a:'.'; b:'.'; c:'14'; data:'122231' ),
  ( a:'/'; b:'/'; c:'15'; data:'113222' ),
  ( a:'0'; b:'0'; c:'16'; data:'123122' ),
  ( a:'1'; b:'1'; c:'17'; data:'123221' ),
  ( a:'2'; b:'2'; c:'18'; data:'223211' ),
  ( a:'3'; b:'3'; c:'19'; data:'221132' ),
  ( a:'4'; b:'4'; c:'20'; data:'221231' ),
  ( a:'5'; b:'5'; c:'21'; data:'213212' ),
  ( a:'6'; b:'6'; c:'22'; data:'223112' ),
  ( a:'7'; b:'7'; c:'23'; data:'312131' ),
  ( a:'8'; b:'8'; c:'24'; data:'311222' ),
  ( a:'9'; b:'9'; c:'25'; data:'321122' ),
  ( a:':'; b:':'; c:'26'; data:'321221' ),
  ( a:';'; b:';'; c:'27'; data:'312212' ),
  ( a:'<'; b:'<'; c:'28'; data:'322112' ),
  ( a:'='; b:'='; c:'29'; data:'322211' ),
  ( a:'>'; b:'>'; c:'30'; data:'212123' ),
  ( a:'?'; b:'?'; c:'31'; data:'212321' ),
  ( a:'@'; b:'@'; c:'32'; data:'232121' ),
  ( a:'A'; b:'A'; c:'33'; data:'111323' ),
  ( a:'B'; b:'B'; c:'34'; data:'131123' ),
  ( a:'C'; b:'C'; c:'35'; data:'131321' ),
  ( a:'D'; b:'D'; c:'36'; data:'112313' ),
  ( a:'E'; b:'E'; c:'37'; data:'132113' ),
  ( a:'F'; b:'F'; c:'38'; data:'132311' ),
  ( a:'G'; b:'G'; c:'39'; data:'211313' ),
  ( a:'H'; b:'H'; c:'40'; data:'231113' ),
  ( a:'I'; b:'I'; c:'41'; data:'231311' ),
  ( a:'J'; b:'J'; c:'42'; data:'112133' ),
  ( a:'K'; b:'K'; c:'43'; data:'112331' ),
  ( a:'L'; b:'L'; c:'44'; data:'132131' ),
  ( a:'M'; b:'M'; c:'45'; data:'113123' ),
  ( a:'N'; b:'N'; c:'46'; data:'113321' ),
  ( a:'O'; b:'O'; c:'47'; data:'133121' ),
  ( a:'P'; b:'P'; c:'48'; data:'313121' ),
  ( a:'Q'; b:'Q'; c:'49'; data:'211331' ),
  ( a:'R'; b:'R'; c:'50'; data:'231131' ),
  ( a:'S'; b:'S'; c:'51'; data:'213113' ),
  ( a:'T'; b:'T'; c:'52'; data:'213311' ),
  ( a:'U'; b:'U'; c:'53'; data:'213131' ),
  ( a:'V'; b:'V'; c:'54'; data:'311123' ),
  ( a:'W'; b:'W'; c:'55'; data:'311321' ),
  ( a:'X'; b:'X'; c:'56'; data:'331121' ),
  ( a:'Y'; b:'Y'; c:'57'; data:'312113' ),
  ( a:'Z'; b:'Z'; c:'58'; data:'312311' ),
  ( a:'['; b:'['; c:'59'; data:'332111' ),
  ( a:'\'; b:'\'; c:'60'; data:'314111' ),
  ( a:']'; b:']'; c:'61'; data:'221411' ),
  ( a:'^'; b:'^'; c:'62'; data:'431111' ),
  ( a:'_'; b:'_'; c:'63'; data:'111224' ),
  ( a:#0 ; b:'`'; c:'64'; data:'111422' ),
  ( a:#1 ; b:'a'; c:'65'; data:'121124' ),
  ( a:#2 ; b:'b'; c:'66'; data:'121421' ),
  ( a:#3 ; b:'c'; c:'67'; data:'141122' ),
  ( a:#4 ; b:'d'; c:'68'; data:'141221' ),
  ( a:#5 ; b:'e'; c:'69'; data:'112214' ),
  ( a:#6 ; b:'f'; c:'70'; data:'112412' ),
  ( a:#7 ; b:'g'; c:'71'; data:'122114' ),
  ( a:#8 ; b:'h'; c:'72'; data:'122411' ),
  ( a:#9 ; b:'i'; c:'73'; data:'142112' ),
  ( a:#10; b:'j'; c:'74'; data:'142211' ),
  ( a:#11; b:'k'; c:'75'; data:'241211' ),
  ( a:#12; b:'l'; c:'76'; data:'221114' ),
  ( a:#13; b:'m'; c:'77'; data:'413111' ),
  ( a:#14; b:'n'; c:'78'; data:'241112' ),
  ( a:#15; b:'o'; c:'79'; data:'134111' ),
  ( a:#16; b:'p'; c:'80'; data:'111242' ),
  ( a:#17; b:'q'; c:'81'; data:'121142' ),
  ( a:#18; b:'r'; c:'82'; data:'121241' ),
  ( a:#19; b:'s'; c:'83'; data:'114212' ),
  ( a:#20; b:'t'; c:'84'; data:'124112' ),
  ( a:#21; b:'u'; c:'85'; data:'124211' ),
  ( a:#22; b:'v'; c:'86'; data:'411212' ),
  ( a:#23; b:'w'; c:'87'; data:'421112' ),
  ( a:#24; b:'x'; c:'88'; data:'421211' ),
  ( a:#25; b:'y'; c:'89'; data:'212141' ),
  ( a:#26; b:'z'; c:'90'; data:'214121' ),
  ( a:#27; b:'{'; c:'91'; data:'412121' ),
  ( a:#28; b:'|'; c:'92'; data:'111143' ),
  ( a:#29; b:'}'; c:'93'; data:'111341' ),
  ( a:#30; b:'~'; c:'94'; data:'131141' ),
  ( a:#31; b:' '; c:'95'; data:'114113' ),
  ( a:' '; b:' '; c:'96'; data:'114311' ),
  ( a:' '; b:' '; c:'97'; data:'411113' ),
  ( a:' '; b:' '; c:'98'; data:'411311' ),
  ( a:' '; b:' '; c:'99'; data:'113141' ),
  ( a:' '; b:' '; c:'  '; data:'114131' ),
  ( a:' '; b:' '; c:'  '; data:'311141' ),
  ( a:' '; b:' '; c:'  '; data:'411131' )
  );

  StartA = '211412';
  StartB = '211214';
  StartC = '211232';
  Stop   = '2331112';

function SetBit(Value: Byte; Bit: Integer): Byte;
begin
  Result := Value or (1 shl Bit);
end;

// Bars to dots conversion

function BarsToDots(const Data: string): string;
var
  i: Integer;
  j: Integer;
  Color: Char;
  BarSize: Integer;
const
  Width = 1;
begin
  Color := #1;
  Result := '';
  for i := 1 to Length(Data) do
  begin
    BarSize := (StrToInt(Data[i]))*Width;
    for j := 1 to BarSize do
      Result := Result + Color;

    if Color = #1 then
      Color := #0 else Color := #1;
  end;
end;

// Convert dots from text to binary
// '00011001' -> #$19

function DotsToBin(const Data: string): string;
var
  L: Integer;
  i: Integer;
  DataSize: Integer;
  BitIndex: Integer;
  CharIndex: Integer;
begin
  L := Length(Data);
  DataSize := L div 8;
  if (L mod 8) <> 0 then Inc(DataSize);
  Result := StringOfChar(#0, DataSize);

  for i := 1 to Length(Data) do
  begin
    if Data[i] = #1 then
    begin
      BitIndex := (i-1) mod 8;
      CharIndex := ((i-1) div 8) + 1;
      Result[CharIndex] := Chr(SetBit(Ord(Result[CharIndex]), BitIndex));
    end;
  end;
end;

function GeTSmBarcodeName(BT: TSmBarcodeType): string;
begin
  case BT of
    smCode128A: Result := 'Code128A';
    smCode128B: Result := 'Code128B';
    smCode128C: Result := 'Code128C';
  else
    Result := 'Unknown barcode type';
  end;
end;

procedure RaiseInvalidCharError(BT: TSmBarcodeType; const S: string);
begin
  raise Exception.CreateFmt('''%s'' - incorrect character for barcode %s',
    [S, GeTSmBarcodeName(BT)]);
end;

{ TSmBarcode }

constructor TSmBarcode.Create;
begin
  inherited Create;
  Barcode.BarWidth := 2;
end;

// Get supported barcode types

function TSmBarcode.GetBarcode128Types: string;
var
  i: TSmBarcodeType;
begin
  Result := '';
  for i := smCode128A to smCode128C do
  begin
    if Result <> '' then Result := Result + #13#10;
    Result := Result + GeTSmBarcodeName(i);
  end;
end;

function TSmBarcode.FindCode128A(c: char): Integer;
var
  v: Char;
  i: Integer;
begin
  Result := 0;
  for i := 0 to High(Table128) do
  begin
    v := Table128[i].a;
    if c = v then
    begin
      Result := i;
      Exit;
    end;
  end;
  RaiseInvalidCharError(smCode128A, C);
end;

function TSmBarcode.FindCode128B(c: char): Integer;
var
  v: Char;
  i: Integer;
begin
  Result := 0;
  for i := 0 to High(Table128) do
  begin
    v := Table128[i].b;
    if c = v then
    begin
      Result := i;
      Exit;
    end;
  end;
  RaiseInvalidCharError(smCode128B, C);
end;

// find Code 128 Codeset C

function TSmBarcode.FindCode128C(c: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to High(Table128) do
  begin
    if Table128[i].c = c then
    begin
      Result := i;
      Exit;
    end;
  end;
  RaiseInvalidCharError(smCode128C, C);
end;

// Create Code128A code

procedure TSmBarcode.CreateCode128A;
var
  i: Integer;
  Index: Integer;
  startcode: string;
  checksum : Integer;
  codeword_pos : Integer;
begin
  checksum := 103;
  startcode := StartA;
  FLineData := startcode;
  codeword_pos := 1;
  for i := 1 to Length(Barcode.Data) do
  begin
    Index := FindCode128A(Barcode.Data[i]);
    FLineData := FLineData + Table128[Index].Data;
    Inc(checksum, Index*codeword_pos);
    Inc(codeword_pos);
  end;
  checksum := checksum mod 103;
  FLineData := FLineData + Table128[checksum].Data;
  FLineData := FLineData + Stop;
  FLineData := BarsToDots(LineData);
end;

procedure TSmBarcode.CreateCode128B;
var
  i: Integer;
  Index: Integer;
  startcode: string;
  checksum : Integer;
  codeword_pos : Integer;
begin
  checksum := 104;
  startcode := StartB;
  FLineData := startcode;
  codeword_pos := 1;
  for i := 1 to Length(Barcode.Data) do
  begin
    Index := FindCode128B(Barcode.Data[i]);
    FLineData := FLineData + Table128[Index].Data;
    Inc(checksum, Index*codeword_pos);
    Inc(codeword_pos);
  end;
  checksum := checksum mod 103;
  FLineData := FLineData + Table128[checksum].Data;
  FLineData := FLineData + Stop;
  FLineData := BarsToDots(FLineData);
end;

procedure TSmBarcode.CreateCode128C;
var
  S: string;
  i: Integer;
  j: Integer;
  Index: Integer;
  startcode: string;
  checksum : Integer;
  codeword_pos : Integer;
begin
  checksum := 105;
  startcode := StartC;

  FLineData := startcode;    {Startcode}
  codeword_pos := 1;
  S := Barcode.Data;
  if (Length(S) mod 2 <> 0) then
    S := '0' + S;
  for i := 1 to (Length(S) div 2) do
  begin
    j := (i-1)*2 + 1;
    Index := FindCode128C(Copy(S, j, 2));
    FLineData := FLineData + Table128[Index].Data;
    Inc(checksum, Index*codeword_pos);
    Inc(codeword_pos);
  end;
  checksum := checksum mod 103;
  FLineData := FLineData + Table128[checksum].Data;

  FLineData := FLineData + Stop;      {Stopcode}
  FLineData := BarsToDots(FLineData);
end;

// Left alignment
// Nothing to do

procedure TSmBarcode.AlignLeft;
begin
  FLineData := FLineData + StringOfChar('0', PrintWidth - BarcodeWidth);
end;

// Right alignment

procedure TSmBarcode.AlignRight;
begin
  FLineData := StringOfChar('0', PrintWidth - BarcodeWidth) + FLineData;
end;

// Center alignment

procedure TSmBarcode.AlignCenter;
var
  DotCount: Integer;
  LeftDotCount: Integer;
begin
  DotCount := PrintWidth - BarcodeWidth;
  LeftDotCount := DotCount div 2;
  FLineData := StringOfChar('0', LeftDotCount) + FLineData +
    StringOfChar('0', DotCount - LeftDotCount)
end;

// Barcode alignment

procedure TSmBarcode.MakeAlignment;
begin
  case Barcode.Alignment of
    baLeft   : AlignLeft;
    baRight  : AlignRight;
    baCenter : AlignCenter;
  else
    raise Exception.Create('Unknown alignment type');
  end;
end;

// Applying barcode width

procedure TSmBarcode.MakeBarWidth;
var
  S: string;
  i: Integer;
begin
  S := '';
  for i := 1 to Length(FLineData) do
    S := S + StringOfChar(FLineData[i], Barcode.BarWidth);
  FLineData := S;
end;

procedure TSmBarcode.CreateBarcode;
begin
  // Barcode creation
  case Barcode.BarcodeType of
    smCode128A: CreateCode128A;
    smCode128B: CreateCode128B;
    smCode128C: CreateCode128C;
  else
    raise Exception.Create('Invalid barcode type');
  end;
  // Bar widths applying
  MakeBarWidth;
  // Check print width
  FBarcodeWidth := Length(FLineData);
  if FBarcodeWidth > PrintWidth then
    raise Exception.Create('Barcode width is larger than printing width');
  // Alignment
  MakeAlignment;
  // Convert to binary format
  FBarcodeLine := DotsToBin(LineData);
end;

end.
