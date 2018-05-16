unit AsBarcode;

interface

uses
  // VCL
  Classes, Types, SysUtils,
  // This
  LogFile, WException;


const
  // Error messages
  SBarcodeType          = 'Invalid BarcodeType value';
  SBarcodeNotNumeric    = 'Barcode is not numeric';
  SInvalidTextLength    = 'Invalid text length';
  SInvalidData          = 'Invalid barcode data';
  SInternalError        = 'Internal error';
  SInvalidSymbol        = 'Invalid barcode symbol "%s" at position %d';

type
  TAsBarcodeAlignment = (baCenter, baLeft, baRight);

  TAsBarcodeType =
  (
  btCode_2_5_interleaved,
  btCode_2_5_industrial,
  btCode_2_5_matrix,
  btCode39,
  btCode39Extended,
  btCode128A,
  btCode128B,
  btCode128C,
  btCode93,
  btCode93Extended,
  btCodeMSI,
  btCodePostNet,
  btCodeCodabar,
  btCodeEAN8,
  btCodeEAN13,
  btCodeUPC_A,
  btCodeUPC_E0,
  btCodeUPC_E1,
  btCodeUPC_Supp2,    { UPC 2 digit supplemental }
  btCodeUPC_Supp5,    { UPC 5 digit supplemental }
  btCodeEAN128A,
  btCodeEAN128B,
  btCodeEAN128C
  );


  TBarLineType = (white, black, black_half);  {for internal use only}
  { black_half means a black line with 2/5 height (used for PostNet) }


  TBarcodeOption = (bcoNone, bcoCode, bcoTyp, bcoBoth); { Type of text to show }

  { Additions from Roberto Parola to improve the text output }

  TShowTextPosition =
  (
    stpTopLeft,
    stpTopRight,
    stpTopCenter,
    stpBottomLeft,
    stpBottomRight,
    stpBottomCenter
  );

  TCheckSumMethod =
  (
  csmNone,
  csmModulo10
  );

  { TAsBarcode }

  TAsBarcode = class
  private
    FText: string;
    FRatio: Double;
    FModule: Integer;
    FLineData: string;
    FCheckSum: Boolean;
    FBarcodeType: TAsBarcodeType;
    FBarcodeWidthInDots: Integer;
    FCheckSumMethod: TCheckSumMethod;
    FModules: array[0..3] of ShortInt;

    function Failed(Code: Integer): Boolean;
    procedure CalcCRC(MinLength: Integer);
    procedure GetBarProps(Code: Char; var Width: Integer; var lt: TBarLineType);
    procedure CheckTextLength(MinLength: Integer);
    function Code_2_5_interleaved: string;
    function Code_2_5_industrial: string;
    function Code_2_5_matrix: string;
    function Code_39: string;
    function Code_39Extended: string;
    function Code_128: string;
    function Code_93: string;
    function Code_93Extended: string;
    function Code_MSI: string;
    function Code_PostNet: string;
    function Code_Codabar: string;
    function Code_EAN8: string;
    function Code_EAN13: string;
    function Code_UPC_A: string;
    function Code_UPC_E0: string;
    function Code_UPC_E1: string;
    function Code_Supp5: string;
    function Code_Supp2: string;
    function GetTypText: string;
    procedure MakeModules;
    procedure AlignLeft;
    procedure AlignRight;
    procedure AlignCenter;
    procedure MakeAlignment;
    function DoCheckSumming(const data: string): string;
    function MakeData: string;
    function CreateBarcodeDots: string;
    procedure SetModuleWidth(Value: Integer);
  protected
    function GetWidth: Integer;
    procedure SetWidth(Value: Integer);
    procedure SetRatio(const Value: Double);
    procedure SetCheckSum(const Value: Boolean);
  public
    PrintWidthInDots: Integer; // Printer print width in dots
    Alignment: TAsBarcodeAlignment;

    constructor Create;
    procedure CreateBarcode;

    property LineData: string read FLineData;
    property Text: string read FText write FText;
    property BarcodeWidthInDots: Integer read FBarcodeWidthInDots;
    property ModuleWidth: Integer read FModule write SetModuleWidth;
    property BarcodeType: TAsBarcodeType read FBarcodeType write FBarcodeType;
  end;

function GetBarcodeName(BarcodeType: TAsBarcodeType): string;

implementation

function SetBit(Value: Byte; Bit: Integer): Byte;
begin
  SetBit := Value or (1 shl Bit);
end;

type
  TBCdata = record
   Name: string;        { Name of Barcode }
   IsNumeric: Boolean;  { Numeric data only }
  end;

const
  BCdata: array[btCode_2_5_interleaved..btCodeEAN128C] of TBCdata =
  (
    (Name:'2_5_interleaved'; IsNumeric: True),
    (Name:'2_5_industrial';  IsNumeric: True),
    (Name:'2_5_matrix';      IsNumeric: True),
    (Name:'Code39';          IsNumeric: False),
    (Name:'Code39 Extended'; IsNumeric: False),
    (Name:'Code128A';        IsNumeric: False),
    (Name:'Code128B';        IsNumeric: False),
    (Name:'Code128C';        IsNumeric: True),
    (Name:'Code93';          IsNumeric: False),
    (Name:'Code93 Extended'; IsNumeric: False),
    (Name:'MSI';             IsNumeric: True),
    (Name:'PostNet';         IsNumeric: True),
    (Name:'Codebar';         IsNumeric: False),
    (Name:'EAN8';            IsNumeric: True),
    (Name:'EAN13';           IsNumeric: True),
    (Name:'UPC_A';           IsNumeric: True),
    (Name:'UPC_E0';          IsNumeric: True),
    (Name:'UPC_E1';          IsNumeric: True),
    (Name:'UPC Supp2';       IsNumeric: True),
    (Name:'UPC Supp5';       IsNumeric: True),
    (Name:'EAN128A';         IsNumeric: False),
    (Name:'EAN128B';         IsNumeric: False),
    (Name:'EAN128C';         IsNumeric: True)
  );

function GetBarcodeName(BarcodeType: TAsBarcodeType): string;
begin
  GetBarcodeName := BCdata[BarcodeType].Name;
end;

function StringOfChar(C: Char; Len: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Len do
    Result := Result + C;
end;

function IntToStr(I: Longint): string;
var
  S: string[11];
begin
  Str(I, S);
  IntToStr := S;
end;

function StrToInt(const S: string): Integer;
var
  Code: Integer;
begin
  Val(S, Result, Code);
end;

function CheckSumModulo10(const data: string): string;
var
  i: Integer;
  fak: Integer;
  sum: Integer;
begin
	sum := 0;
	fak := Length(data);
	for i:=1 to Length(data) do
	begin
		if (fak mod 2) = 0 then
			sum := sum + (StrToInt(data[i])*1)
		else
			sum := sum + (StrToInt(data[i])*3);
		dec(fak);
	end;
	if (sum mod 10) = 0 then
		Result := data+'0'
	else
		Result := data+IntToStr(10-(sum mod 10));
end;

{
  converts a string from '321' to the internal representation '715'
  i need this function because some pattern tables have a different
  format :

  '00111'
  converts to '05161'
}
function Convert(const s: string): string;
var
  i, v: Integer;
begin
  Result := s;  { same Length as Input - string }
  for i:=1 to Length(s) do
  begin
    v := ord(s[i]) - 1;

    if odd(i) then
      Inc(v, 5);
    Result[i] := Chr(v);
  end;
end;

(*
 * Berechne die Quersumme aus einer Zahl x
 * z.B.: Quersumme von 1234 ist 10
 *)
function quersumme(x: Integer): Integer;
var
  sum: Integer;
begin
  sum := 0;

  while x > 0 do
  begin
    sum := sum + (x mod 10);
    x := x div 10;
  end;
  quersumme := sum;
end;


{
  Rotate a Point by Angle 'alpha'
}

procedure Rotate2D(p: TPoint; alpha:Double; var Result: TPoint);
var
  sinus, cosinus : Extended;
begin
  sinus   := sin(alpha);
  cosinus := cos(alpha);
(*
  { twice as fast than calc sin() and cos() }
  SinCos(alpha, sinus, cosinus);
*)

  Result.x := Round(p.x*cosinus + p.y*sinus);
  Result.y := Round(-p.x*sinus + p.y*cosinus);
end;

{
  Move Point "a" by Vector "b"
}
procedure Translate2D(a, b:TPoint; var Result: TPoint);
begin
  Result.x := a.x + b.x;
  Result.y := a.y + b.y;
end;

(*
  not used, but left in place for future use
procedure Rotate2Darray(p:array of TPoint; alpha:Double);
var
   i: Integer;
begin
   for i:=Low(p) to High(p) do
      p[i] := Rotate2D(p[i], alpha);
end;

procedure Translate2Darray(p:array of TPoint; shift:TPoint);
var
   i: Integer;
begin
   for i:=Low(p) to High(p) do
      p[i] := Translate2D(p[i], shift);
end;
*)

{
  Move the orgin so that when point is rotated by alpha, the rect
  between point and orgin stays in the visible quadrant.
}
procedure TranslateQuad2D(
  const alpha: Double;
  const orgin, point: TPoint; var Result: TPoint);
var
   alphacos: Extended;
   alphasin: Extended;
   moveby:   TPoint;
begin
   alphasin := sin(alpha);
   alphacos := cos(alpha);
(*
   { SinCos is twice as fast as: }
   SinCos(alpha, alphasin, alphacos);
*)

   if alphasin >= 0 then
   begin
      if alphacos >= 0 then
      begin
         { 1. Quadrant }
         moveby.x := 0;
         moveby.y := Round(alphasin*point.x);
      end
      else
      begin
         { 2. Quadrant }
         moveby.x := -Round(alphacos*point.x);
         moveby.y := Round(alphasin*point.x - alphacos*point.y);
      end;
   end
   else
   begin
      if alphacos >= 0 then
      begin
         { 4. quadrant }
         moveby.x := -Round(alphasin*point.y);
         moveby.y := 0;
      end
      else
      begin
         { 3. quadrant }
         moveby.x := -Round(alphacos*point.x) - Round(alphasin*point.y);
         moveby.y := -Round(alphacos*point.y);
      end;
   end;
   Translate2D(orgin, moveby, Result);
end;

{ TAsBarcode }

constructor TAsBarcode.Create;
begin
  inherited Create;
  FRatio := 2.0;
  FModule := 1;
  FCheckSum := True;
  FBarcodeType := btCodeEAN13;
  FCheckSumMethod := csmModulo10;
end;

{ Checking barcode length }

procedure TAsBarcode.CheckTextLength(MinLength: Integer);
begin
  if Length(FText) > MinLength+1 then
    raise EXception.Create(SInvalidTextLength);
  FText := StringOfChar('0', MinLength-Length(FText)) + FText;
end;

{ Check result code }
function TAsBarcode.Failed(Code: Integer): Boolean;
begin
  Failed := Code <> 0;
end;

{ Calculate CRC }
procedure TAsBarcode.CalcCRC(MinLength: Integer);
begin
  CheckTextLength(MinLength);
  if FCheckSum then
  begin
    FText := DoCheckSumming(Copy(FText, 1, MinLength));
  end else
  begin
    FText := Copy(FText, 1, MinLength+1);
  end;
end;

function TAsBarcode.GetTypText: string;
begin
  GetTypText := BCdata[FBarcodeType].Name;
end;

{ Set module width }
procedure TAsBarcode.SetModuleWidth(Value: Integer);
begin
  if (Value >= 1) and (Value < 50) then
  begin
    FModule := Value;
  end;
end;


{
calculate the width and the linetype of a sigle bar


  Code   Line-Color      Width               Height
------------------------------------------------------------------
  '0'   white           100%                full
  '1'   white           100%*Ratio          full
  '2'   white           150%*Ratio          full
  '3'   white           200%*Ratio          full
  '5'   black           100%                full
  '6'   black           100%*Ratio          full
  '7'   black           150%*Ratio          full
  '8'   black           200%*Ratio          full
  'A'   black           100%                2/5  (used for PostNet)
  'B'   black           100%*Ratio          2/5  (used for PostNet)
  'C'   black           150%*Ratio          2/5  (used for PostNet)
  'D'   black           200%*Ratio          2/5  (used for PostNet)
}

procedure TAsBarcode.GetBarProps(
  Code: Char; var Width: Integer; var lt: TBarLineType);
begin
  case Code of
    '0': begin width := FModules[0]; lt := white; end;
    '1': begin width := FModules[1]; lt := white; end;
    '2': begin width := FModules[2]; lt := white; end;
    '3': begin width := FModules[3]; lt := white; end;

    '5': begin width := FModules[0]; lt := black; end;
    '6': begin width := FModules[1]; lt := black; end;
    '7': begin width := FModules[2]; lt := black; end;
    '8': begin width := FModules[3]; lt := black; end;

    'A': begin width := FModules[0]; lt := black_half; end;
    'B': begin width := FModules[1]; lt := black_half; end;
    'C': begin width := FModules[2]; lt := black_half; end;
    'D': begin width := FModules[3]; lt := black_half; end;
  else
    raiseException(SInternalError);
  end;
end;

function TAsBarcode.MakeData: string;
var
  i: Integer;
begin
  { calculate the width of the different lines (FModules) }
  MakeModules;
  { Is numeric barcode type ? }
  if BCdata[FBarcodeType].IsNumeric then
  begin
    FText := Trim(FText); {remove blanks}
        for i := 1 to Length(Ftext) do
    if (FText[i] > '9') or (FText[i] < '0') then
    begin
      raiseException(SBarcodeNotNumeric);
    end;
  end;
  { get the pattern of the barcode }
  case FBarcodeType of
    btCode_2_5_interleaved: Result := Code_2_5_interleaved;
    btCode_2_5_industrial:  Result := Code_2_5_industrial;
    btCode_2_5_matrix:      Result := Code_2_5_matrix;
    btCode39:               Result := Code_39;
    btCode39Extended:       Result := Code_39Extended;
    btCode128A,
    btCode128B,
    btCode128C,
    btCodeEAN128A,
    btCodeEAN128B,
    btCodeEAN128C:          Result := Code_128;
    btCode93:               Result := Code_93;
    btCode93Extended:       Result := Code_93Extended;
    btCodeMSI:              Result := Code_MSI;
    btCodePostNet:          Result := Code_PostNet;
    btCodeCodabar:          Result := Code_Codabar;
    btCodeEAN8:             Result := Code_EAN8;
    btCodeEAN13:            Result := Code_EAN13;
    btCodeUPC_A:            Result := Code_UPC_A;
    btCodeUPC_E0:           Result := Code_UPC_E0;
    btCodeUPC_E1:           Result := Code_UPC_E1;
    btCodeUPC_Supp2:        Result := Code_Supp2;
    btCodeUPC_Supp5:        Result := Code_Supp5;
  else
    raiseException(SBarcodeType);
  end;
end;

function TAsBarcode.GetWidth: Integer;
var
  i: Integer;
  w: Integer;
  lt : TBarLineType;
  Data: string;
begin
  Result := 0;
  { get barcode pattern }
  Data := MakeData;
  { examine the pattern string }
  for i := 1 to Length(Data) do
  begin
    GetBarProps(Data[i], w, lt);
    Inc(Result, w);
  end;
end;

procedure TAsBarcode.SetWidth(Value: Integer);
var
  data: string;
  i: Integer;
  w, wtotal: Integer;
  lt : TBarLineType;
begin
  wtotal := 0;
  { get barcode pattern }
  { !!! }
  { data := MakeData; }

  for i:=1 to Length(data) do  {examine the pattern string}
  begin
    GetBarProps(data[i], w, lt);
    Inc(wtotal, w);
  end;


  {
  wtotal:  current width of barcode
  Value :  new width of barcode



  }

  if wtotal > 0 then  { don't divide by 0 ! }
    SetModuleWidth((FModule * Value) div wtotal);
end;



function TAsBarcode.DoCheckSumming(const data: string): string;
begin
  case FCheckSumMethod of
    csmNone: DoCheckSumming := data;
    csmModulo10: DoCheckSumming := CheckSumModulo10(data);
  else
    { !!! }
  end;
end;

{
////////////////////////////// EAN /////////////////////////////////////////
}


{
////////////////////////////// EAN8 /////////////////////////////////////////
}

{Pattern for Barcode EAN Charset A}
     {L1   S1   L2   S2}
const Table_EAN_A:array['0'..'9'] of string =
  (
  ('2605'),    { 0 }
  ('1615'),    { 1 }
  ('1516'),    { 2 }
  ('0805'),    { 3 }
  ('0526'),    { 4 }
  ('0625'),    { 5 }
  ('0508'),    { 6 }
  ('0706'),    { 7 }
  ('0607'),    { 8 }
  ('2506')     { 9 }
  );

{ Pattern for Barcode EAN Charset C }
     {S1   L1   S2   L2}
const Table_EAN_C:array['0'..'9'] of string =
  (
  ('7150' ),    { 0 }
  ('6160' ),    { 1 }
  ('6061' ),    { 2 }
  ('5350' ),    { 3 }
  ('5071' ),    { 4 }
  ('5170' ),    { 5 }
  ('5053' ),    { 6 }
  ('5251' ),    { 7 }
  ('5152' ),    { 8 }
  ('7051' )     { 9 }
  );

function TAsBarcode.Code_EAN8: string;
var
  i: Integer;
begin
  CalcCRC(7);
  Result := '505';   {Startcode}
  for i:=1 to 4 do
    Result := Result + Table_EAN_A[FText[i]];
  Result := Result + '05050';   {Center Guard Pattern}
  for i:=5 to 8 do
    Result := Result + Table_EAN_C[FText[i]] ;
  Result := Result + '505';   {Stopcode}
end;

{////////////////////////////// EAN13 ///////////////////////////////////////}

{Pattern for Barcode EAN Zeichensatz B}
     {L1   S1   L2   S2}
const Table_EAN_B:array['0'..'9'] of string =
  (
  ('0517'),    { 0 }
  ('0616'),    { 1 }
  ('1606'),    { 2 }
  ('0535'),    { 3 }
  ('1705'),    { 4 }
  ('0715'),    { 5 }
  ('3505'),    { 6 }
  ('1525'),    { 7 }
  ('2515'),    { 8 }
  ('1507')     { 9 }
  );

{Zuordung der Paraitaetsfolgen f№r EAN13}
const Table_ParityEAN13:array[0..9, 1..6] of char =
  (
  ('A', 'A', 'A', 'A', 'A', 'A'),    { 0 }
  ('A', 'A', 'B', 'A', 'B', 'B'),    { 1 }
  ('A', 'A', 'B', 'B', 'A', 'B'),    { 2 }
  ('A', 'A', 'B', 'B', 'B', 'A'),    { 3 }
  ('A', 'B', 'A', 'A', 'B', 'B'),    { 4 }
  ('A', 'B', 'B', 'A', 'A', 'B'),    { 5 }
  ('A', 'B', 'B', 'B', 'A', 'A'),    { 6 }
  ('A', 'B', 'A', 'B', 'A', 'B'),    { 7 }
  ('A', 'B', 'A', 'B', 'B', 'A'),    { 8 }
  ('A', 'B', 'B', 'A', 'B', 'A')     { 9 }
  );

function TAsBarcode.Code_EAN13: string;
var
  i: Integer;
  LK: Integer;
begin
  CalcCRC(12);
  LK := StrToInt(FText[1]);
  FText := Copy(FText, 2, 12);

  Result := '505';   {Startcode}
  for i:=1 to 6 do
  begin
    case Table_ParityEAN13[LK,i] of
      'A' : Result := Result + Table_EAN_A[FText[i]];
      'B' : Result := Result + Table_EAN_B[FText[i]] ;
      'C' : Result := Result + Table_EAN_C[FText[i]] ;
    end;
  end;

  Result := Result + '05050';   {Center Guard Pattern}

  for i:=7 to 12 do
    Result := Result + Table_EAN_C[FText[i]] ;

  Result := Result + '505';   {Stopcode}
end;

{Pattern for Barcode 2 of 5}
const Table_2_5:array['0'..'9', 1..5] of char =
  (
  ('0', '0', '1', '1', '0'),    {'0'}
  ('1', '0', '0', '0', '1'),    {'1'}
  ('0', '1', '0', '0', '1'),    {'2'}
  ('1', '1', '0', '0', '0'),    {'3'}
  ('0', '0', '1', '0', '1'),    {'4'}
  ('1', '0', '1', '0', '0'),    {'5'}
  ('0', '1', '1', '0', '0'),    {'6'}
  ('0', '0', '0', '1', '1'),    {'7'}
  ('1', '0', '0', '1', '0'),    {'8'}
  ('0', '1', '0', '1', '0')     {'9'}
  );

function TAsBarcode.Code_2_5_interleaved: string;
var
  c: char;
  i, j: Integer;
begin
  Result := '5050';   {Startcode}
  for i:=1 to Length(FText) div 2 do
  begin
    for j:= 1 to 5 do
    begin
      if Table_2_5[FText[i*2-1], j] = '1' then
        c := '6'
      else
        c := '5';
      Result := Result + c;
      if Table_2_5[FText[i*2], j] = '1' then
        c := '1'
      else
        c := '0';
      Result := Result + c;
    end;
  end;
  Result := Result + '605';    {Stopcode}
end;


function TAsBarcode.Code_2_5_industrial: string;
var
  i, j: Integer;
begin
  Result := '606050';   {Startcode}
  for i:=1 to Length(FText) do
  begin
    for j:= 1 to 5 do
    begin
    if Table_2_5[FText[i], j] = '1' then
      Result := Result + '60'
    else
      Result := Result + '50';
    end;
  end;
  Result := Result + '605060';   {Stopcode}
end;

function TAsBarcode.Code_2_5_matrix: string;
var
  i, j: Integer;
  c :char;
begin
  Result := '705050';   {Startcode}
  for i:=1 to Length(FText) do
  begin
    for j:= 1 to 5 do
    begin
      if Table_2_5[FText[i], j] = '1' then
        c := '1'
      else
        c := '0';

    {Falls i ungerade ist dann mache L№cke zu Strich}
      if odd(j) then
        c := chr(ord(c)+5);
      Result := Result + c;
    end;
   Result := Result + '0';   {L№cke zwischen den Zeichen}
  end;
  Result := Result + '70505';   {Stopcode}
end;

function TAsBarcode.Code_39: string;
type
  TCode39 = record
    c : char;
    data : array[0..8] of char;
    chk: ShortInt;
  end;

const
  Table_39: array[0..43] of TCode39 = (
  ( c:'0'; data:'505160605'; chk:0 ),
  ( c:'1'; data:'605150506'; chk:1 ),
  ( c:'2'; data:'506150506'; chk:2 ),
  ( c:'3'; data:'606150505'; chk:3 ),
  ( c:'4'; data:'505160506'; chk:4 ),
  ( c:'5'; data:'605160505'; chk:5 ),
  ( c:'6'; data:'506160505'; chk:6 ),
  ( c:'7'; data:'505150606'; chk:7 ),
  ( c:'8'; data:'605150605'; chk:8 ),
  ( c:'9'; data:'506150605'; chk:9 ),
  ( c:'A'; data:'605051506'; chk:10),
  ( c:'B'; data:'506051506'; chk:11),
  ( c:'C'; data:'606051505'; chk:12),
  ( c:'D'; data:'505061506'; chk:13),
  ( c:'E'; data:'605061505'; chk:14),
  ( c:'F'; data:'506061505'; chk:15),
  ( c:'G'; data:'505051606'; chk:16),
  ( c:'H'; data:'605051605'; chk:17),
  ( c:'I'; data:'506051605'; chk:18),
  ( c:'J'; data:'505061605'; chk:19),
  ( c:'K'; data:'605050516'; chk:20),
  ( c:'L'; data:'506050516'; chk:21),
  ( c:'M'; data:'606050515'; chk:22),
  ( c:'N'; data:'505060516'; chk:23),
  ( c:'O'; data:'605060515'; chk:24),
  ( c:'P'; data:'506060515'; chk:25),
  ( c:'Q'; data:'505050616'; chk:26),
  ( c:'R'; data:'605050615'; chk:27),
  ( c:'S'; data:'506050615'; chk:28),
  ( c:'T'; data:'505060615'; chk:29),
  ( c:'U'; data:'615050506'; chk:30),
  ( c:'V'; data:'516050506'; chk:31),
  ( c:'W'; data:'616050505'; chk:32),
  ( c:'X'; data:'515060506'; chk:33),
  ( c:'Y'; data:'615060505'; chk:34),
  ( c:'Z'; data:'516060505'; chk:35),
  ( c:'-'; data:'515050606'; chk:36),
  ( c:'.'; data:'615050605'; chk:37),
  ( c:' '; data:'516050605'; chk:38),
  ( c:'*'; data:'515060605'; chk:0 ),
  ( c:'$'; data:'515151505'; chk:39),
  ( c:'/'; data:'515150515'; chk:40),
  ( c:'+'; data:'515051515'; chk:41),
  ( c:'%'; data:'505151515'; chk:42)
  );


function FindIdx(z:char): Integer;
var
  i: Integer;
begin
  for i:=0 to High(Table_39) do
  begin
    if z = Table_39[i].c then
    begin
      FindIdx := i;
      Exit;
    end;
  end;
  FindIdx := -1;
end;

var
  i, idx: Integer;
  checksum: Integer;
begin
  checksum := 0;
  {Startcode}
  Result := Table_39[FindIdx('*')].data + '0';

  for i:=1 to Length(FText) do
  begin
    idx := FindIdx(FText[i]);
    if idx < 0 then
      raise Exception.CreateFmt(SInvalidSymbol, [FText[i], i]);

    Result := Result + Table_39[idx].data + '0';
    Inc(checksum, Table_39[idx].chk);
  end;

  {Calculate Checksum Result}
  if FCheckSum then
  begin
    checksum := checksum mod 43;
    for i:=0 to High(Table_39) do
    begin
      if checksum = Table_39[i].chk then
      begin
        Result := Result + Table_39[i].data + '0';
        break;
      end;
    end;
  end;
  {Stopcode}
  Result := Result + Table_39[FindIdx('*')].data;
end;

function TAsBarcode.Code_39Extended: string;
const
  code39x : array[0..127] of string[2] =
  (
  ('%U'), ('$A'), ('$B'), ('$C'), ('$D'), ('$E'), ('$F'), ('$G'),
  ('$H'), ('$I'), ('$J'), ('$K'), ('$L'), ('$M'), ('$N'), ('$O'),
  ('$P'), ('$Q'), ('$R'), ('$S'), ('$T'), ('$U'), ('$V'), ('$W'),
  ('$X'), ('$Y'), ('$Z'), ('%A'), ('%B'), ('%C'), ('%D'), ('%E'),
   (' '), ('/A'), ('/B'), ('/C'), ('/D'), ('/E'), ('/F'), ('/G'),
  ('/H'), ('/I'), ('/J'), ('/K'), ('/L'), ('/M'), ('/N'), ('/O'),
  ( '0'),  ('1'),  ('2'),  ('3'),  ('4'),  ('5'),  ('6'),  ('7'),
   ('8'),  ('9'), ('/Z'), ('%F'), ('%G'), ('%H'), ('%I'), ('%J'),
  ('%V'),  ('A'),  ('B'),  ('C'),  ('D'),  ('E'),  ('F'),  ('G'),
   ('H'),  ('I'),  ('J'),  ('K'),  ('L'),  ('M'),  ('N'),  ('O'),
   ('P'),  ('Q'),  ('R'),  ('S'),  ('T'),  ('U'),  ('V'),  ('W'),
   ('X'),  ('Y'),  ('Z'), ('%K'), ('%L'), ('%M'), ('%N'), ('%O'),
  ('%W'), ('+A'), ('+B'), ('+C'), ('+D'), ('+E'), ('+F'), ('+G'),
  ('+H'), ('+I'), ('+J'), ('+K'), ('+L'), ('+M'), ('+N'), ('+O'),
  ('+P'), ('+Q'), ('+R'), ('+S'), ('+T'), ('+U'), ('+V'), ('+W'),
  ('+X'), ('+Y'), ('+Z'), ('%P'), ('%Q'), ('%R'), ('%S'), ('%T')
  );
var
  save: string;
  i: Integer;
begin
  save := FText;
  FText := '';
  for i:=1 to Length(save) do
  begin
    if ord(save[i]) <= 127 then
      FText := FText + code39x[ord(save[i])];
  end;
  Result := Code_39;
  FText := save;
end;

{ Code 128 }

function TAsBarcode.Code_128: string;

type
  TCode128 = record
    a, b : char;
    c: string[2];
    data: string[6];
  end;

const
  Table_128: array[0..102] of TCode128 = (
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
  ( a:','; b:','; c:'12'; data:'112232' ), {23.10.2001 Stefano Torricella}
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
  ( a:' '; b:' '; c:'  '; data:'411131' )      { FNC1 }
  );

  StartA = '211412';
  StartB = '211214';
  StartC = '211232';
  Stop   = '2331112';

{ Find Code 128 Codeset A or B }
function Find_Code128AB(c: Char): Integer;
var
  v: char;
  i: Integer;
begin
  Result := -1;
  for i := 0 to High(Table_128) do
  begin
    if FBarcodeType = btCode128A then
      v := Table_128[i].a
    else
      v := Table_128[i].b;

    if c = v then
    begin
      Result := i;
      Break;
    end;
  end;
end;

{ find Code 128 Codeset C }
function Find_Code128C(c: string): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to High(Table_128) do
  begin
    if Table_128[i].c = c then
    begin
      Result := i;
      Break;
    end;
  end;
end;

var
  i, j, idx: Integer;
  startcode: string;
  checksum: Integer;
  codeword_pos: Integer;
begin
  case FBarcodeType of
    btCode128A,
    btCodeEAN128A:
    begin
      checksum := 103;
      startcode:= StartA;
    end;

    btCode128B,
    btCodeEAN128B:
    begin
      checksum := 104;
      startcode:= StartB;
    end;

    btCode128C,
    btCodeEAN128C:
    begin
      checksum := 105;
      startcode:= StartC;
    end;
  else
    raiseException(SBarcodeType);
  end;

  Result := startcode;    {Startcode}
  codeword_pos := 1;

  case FBarcodeType of
    btCodeEAN128A,
    btCodeEAN128B,
    btCodeEAN128C:
    begin
      {
      special identifier
      FNC1 = function code 1
      for EAN 128 barcodes
      }
      Result := Result + Table_128[102].data;
      Inc(checksum, 102*codeword_pos);
      Inc(codeword_pos);
      {
      if there is no checksum at the end of the string
      the EAN128 needs one (modulo 10)
      }
      if FCheckSum then FText:=DoCheckSumming(FTEXT);
    end;
  end;

  if (FBarcodeType = btCode128C) or (FBarcodeType = btcodeEAN128C) then
  begin
    if (Length(FText) mod 2<>0) then FText:='0'+FText;
    for i:=1 to (Length(FText) div 2) do
    begin
      j:=(i-1)*2+1;
      idx:=Find_Code128C(copy(Ftext,j,2));
      if idx < 0 then idx := Find_Code128C('00');
      Result := Result + Table_128[idx].data;
      Inc(checksum, idx*codeword_pos);
      Inc(codeword_pos);
    end;
  end
  else
    for i:=1 to Length(FText) do
    begin
      idx := Find_Code128AB(FText[i]);
      if idx < 0 then
        idx := Find_Code128AB(' ');
      Result := Result + Table_128[idx].data;
      Inc(checksum, idx*codeword_pos);
      Inc(codeword_pos);
    end;

  checksum := checksum mod 103;
  Result := Result + Table_128[checksum].data;

  Result := Result + Stop;      {Stopcode}
  Result := Convert(Result);
end;


function TAsBarcode.Code_93: string;
type
  TCode93 = record
    c : char;
    data : array[0..5] of char;
  end;

const
  Table_93: array[0..46] of TCode93 = (
  ( c:'0'; data:'131112'  ),
  ( c:'1'; data:'111213'  ),
  ( c:'2'; data:'111312'  ),
  ( c:'3'; data:'111411'  ),
  ( c:'4'; data:'121113'  ),
  ( c:'5'; data:'121212'  ),
  ( c:'6'; data:'121311'  ),
  ( c:'7'; data:'111114'  ),
  ( c:'8'; data:'131211'  ),
  ( c:'9'; data:'141111'  ),
  ( c:'A'; data:'211113'  ),
  ( c:'B'; data:'211212'  ),
  ( c:'C'; data:'211311'  ),
  ( c:'D'; data:'221112'  ),
  ( c:'E'; data:'221211'  ),
  ( c:'F'; data:'231111'  ),
  ( c:'G'; data:'112113'  ),
  ( c:'H'; data:'112212'  ),
  ( c:'I'; data:'112311'  ),
  ( c:'J'; data:'122112'  ),
  ( c:'K'; data:'132111'  ),
  ( c:'L'; data:'111123'  ),
  ( c:'M'; data:'111222'  ),
  ( c:'N'; data:'111321'  ),
  ( c:'O'; data:'121122'  ),
  ( c:'P'; data:'131121'  ),
  ( c:'Q'; data:'212112'  ),
  ( c:'R'; data:'212211'  ),
  ( c:'S'; data:'211122'  ),
  ( c:'T'; data:'211221'  ),
  ( c:'U'; data:'221121'  ),
  ( c:'V'; data:'222111'  ),
  ( c:'W'; data:'112122'  ),
  ( c:'X'; data:'112221'  ),
  ( c:'Y'; data:'122121'  ),
  ( c:'Z'; data:'123111'  ),
  ( c:'-'; data:'121131'  ),
  ( c:'.'; data:'311112'  ),
  ( c:' '; data:'311211'  ),
  ( c:'$'; data:'321111'  ),
  ( c:'/'; data:'112131'  ),
  ( c:'+'; data:'113121'  ),
  ( c:'%'; data:'211131'  ),
  ( c:'['; data:'121221'  ),   {only used for Extended Code 93}
  ( c:']'; data:'312111'  ),   {only used for Extended Code 93}
  ( c:'{'; data:'311121'  ),   {only used for Extended Code 93}
  ( c:'}'; data:'122211'  )    {only used for Extended Code 93}
  );


  { find Code 93 }
  function Find_Code93(c: char): Integer;
  var
    i: Integer;
  begin
    for i:=0 to High(Table_93) do
    begin
      if c = Table_93[i].c then
      begin
        Find_Code93 := i;
        Exit;
      end;
    end;
    Find_Code93 := -1;
  end;

var
  i, idx: Integer;
  checkC, checkK,   {Checksums}
  weightC, weightK: Integer;
begin
  Result := '111141';   {Startcode}
  for i:=1 to Length(FText) do
  begin
    idx := Find_Code93(FText[i]);
    if idx < 0 then
    begin
      raiseException('Invalid result');
    end;
    Result := Result + Table_93[idx].data;
  end;

  checkC := 0;
  checkK := 0;

  weightC := 1;
  weightK := 2;

  for i:=Length(FText) downto 1 do
  begin
    idx := Find_Code93(FText[i]);

    Inc(checkC, idx*weightC);
    Inc(checkK, idx*weightK);

    Inc(weightC);
    if weightC > 20 then weightC := 1;
    Inc(weightK);
    {  if weightK > 15 then weightC := 1; }
    if weightK > 15 then weightK:= 1;
  end;

  Inc(checkK, checkC);

  checkC := checkC mod 47;
  checkK := checkK mod 47;

  Result := Result + Table_93[checkC].data +
    Table_93[checkK].data;

  Result := Result + '1111411';   { Stopcode }
  Result := Convert(Result);
end;

{ Code_93Extended }
function TAsBarcode.Code_93Extended: string;

const
  code93x : array[0..127] of string[2] =
  (
  (']U'), ('[A'), ('[B'), ('[C'), ('[D'), ('[E'), ('[F'), ('[G'),
  ('[H'), ('[I'), ('[J'), ('[K'), ('[L'), ('[M'), ('[N'), ('[O'),
  ('[P'), ('[Q'), ('[R'), ('[S'), ('[T'), ('[U'), ('[V'), ('[W'),
  ('[X'), ('[Y'), ('[Z'), (']A'), (']B'), (']C'), (']D'), (']E'),
   (' '), ('{A'), ('{B'), ('{C'), ('{D'), ('{E'), ('{F'), ('{G'),
  ('{H'), ('{I'), ('{J'), ('{K'), ('{L'), ('{M'), ('{N'), ('{O'),
  ( '0'),  ('1'),  ('2'),  ('3'),  ('4'),  ('5'),  ('6'),  ('7'),
   ('8'),  ('9'), ('{Z'), (']F'), (']G'), (']H'), (']I'), (']J'),
  (']V'),  ('A'),  ('B'),  ('C'),  ('D'),  ('E'),  ('F'),  ('G'),
   ('H'),  ('I'),  ('J'),  ('K'),  ('L'),  ('M'),  ('N'),  ('O'),
   ('P'),  ('Q'),  ('R'),  ('S'),  ('T'),  ('U'),  ('V'),  ('W'),
   ('X'),  ('Y'),  ('Z'), (']K'), (']L'), (']M'), (']N'), (']O'),
  (']W'), ('}A'), ('}B'), ('}C'), ('}D'), ('}E'), ('}F'), ('}G'),
  ('}H'), ('}I'), ('}J'), ('}K'), ('}L'), ('}M'), ('}N'), ('}O'),
  ('}P'), ('}Q'), ('}R'), ('}S'), ('}T'), ('}U'), ('}V'), ('}W'),
  ('}X'), ('}Y'), ('}Z'), (']P'), (']Q'), (']R'), (']S'), (']T')
  );

var
  save: string;
  i: Integer;
begin
  save := FText;
  FText := '';

  for i:=1 to Length(save) do
  begin
    if ord(save[i]) <= 127 then
      FText := FText + code93x[ord(save[i])];
  end;
  Code_93Extended := Code_93;
  FText := save;
end;

function TAsBarcode.Code_MSI: string;

const
  Table_MSI:array['0'..'9'] of string[8] =
  (
  ( '51515151' ),    {'0'}
  ( '51515160' ),    {'1'}
  ( '51516051' ),    {'2'}
  ( '51516060' ),    {'3'}
  ( '51605151' ),    {'4'}
  ( '51605160' ),    {'5'}
  ( '51606051' ),    {'6'}
  ( '51606060' ),    {'7'}
  ( '60515151' ),    {'8'}
  ( '60515160' )     {'9'}
  );

var
  i: Integer;
  check_even, check_odd, checksum: Integer;
begin
  Result := '60';    {Startcode}
  check_even := 0;
  check_odd  := 0;

  for i:=1 to Length(FText) do
  begin
    if odd(i-1) then
      check_odd := check_odd*10+ord(FText[i])
    else
      check_even := check_even+ord(FText[i]);

    Result := Result + Table_MSI[FText[i]];
  end;

  checksum := quersumme(check_odd*2) + check_even;

  checksum := checksum mod 10;
  if checksum > 0 then
    checksum := 10-checksum;

  Result := Result + Table_MSI[chr(ord('0')+checksum)];

  Result := Result + '515'; {Stopcode}
end;

function TAsBarcode.Code_PostNet: string;
const
  Table_PostNet:array['0'..'9'] of string[10] =
  (
  ( '5151A1A1A1' ),    {'0'}
  ( 'A1A1A15151' ),    {'1'}
  ( 'A1A151A151' ),    {'2'}
  ( 'A1A15151A1' ),    {'3'}
  ( 'A151A1A151' ),    {'4'}
  ( 'A151A151A1' ),    {'5'}
  ( 'A15151A1A1' ),    {'6'}
  ( '51A1A1A151' ),    {'7'}
  ( '51A1A151A1' ),    {'8'}
  ( '51A151A1A1' )     {'9'}
  );
var
  i: Integer;
begin
  Result := '51';
  for i:=1 to Length(FText) do
  begin
    Result := Result + Table_PostNet[FText[i]];
  end;
  Result := Result + '5';
end;


function TAsBarcode.Code_Codabar: string;
type
  TCodabar = record
    c : char;
    data : array[0..6] of char;
  end;

const
  Table_cb: array[0..19] of TCodabar = (
  ( c:'1'; data:'5050615'  ),
  ( c:'2'; data:'5051506'  ),
  ( c:'3'; data:'6150505'  ),
  ( c:'4'; data:'5060515'  ),
  ( c:'5'; data:'6050515'  ),
  ( c:'6'; data:'5150506'  ),
  ( c:'7'; data:'5150605'  ),
  ( c:'8'; data:'5160505'  ),
  ( c:'9'; data:'6051505'  ),
  ( c:'0'; data:'5050516'  ),
  ( c:'-'; data:'5051605'  ),
  ( c:'$'; data:'5061505'  ),
  ( c:':'; data:'6050606'  ),
  ( c:'/'; data:'6060506'  ),
  ( c:'.'; data:'6060605'  ),
  ( c:'+'; data:'5060606'  ),
  ( c:'A'; data:'5061515'  ),
  ( c:'B'; data:'5151506'  ),
  ( c:'C'; data:'5051516'  ),
  ( c:'D'; data:'5051615'  )
  );

  { find Codabar }
  function Find_Codabar(c:char): Integer;
  var
    i: Integer;
  begin
    for i:=0 to High(Table_cb) do
    begin
      if c = Table_cb[i].c then
      begin
        Find_Codabar := i;
        exit;
      end;
    end;
    Find_Codabar := -1;
  end;

var
  i, idx: Integer;
begin
  Result := Table_cb[Find_Codabar('A')].data + '0';
  for i:=1 to Length(FText) do
  begin
    idx := Find_Codabar(FText[i]);
    Result := Result + Table_cb[idx].data + '0';
  end;
  Result := Result + Table_cb[Find_Codabar('B')].data;
end;

{ UPC-A }
function TAsBarcode.Code_UPC_A: string;
var
  i: Integer;
begin
  CheckTextLength(11);

  if FCheckSum then
  begin
    FText := DoCheckSumming(Copy(FText,1,11));
  end;

  Result := '505';   {Startcode}
  for i:=1 to 6 do
    Result := Result + Table_EAN_A[FText[i]];
  Result := Result + '05050';   { MiddleCode }
  for i:=7 to 12 do
    Result := Result + Table_EAN_C[FText[i]];
  Result := Result + '505';   {Stopcode}
end;


{UPC E Parity Pattern Table , Number System 0}
const
  Table_UPC_E0:array['0'..'9', 1..6] of char =
  (
  ('E', 'E', 'E', 'o', 'o', 'o' ),    { 0 }
  ('E', 'E', 'o', 'E', 'o', 'o' ),    { 1 }
  ('E', 'E', 'o', 'o', 'E', 'o' ),    { 2 }
  ('E', 'E', 'o', 'o', 'o', 'E' ),    { 3 }
  ('E', 'o', 'E', 'E', 'o', 'o' ),    { 4 }
  ('E', 'o', 'o', 'E', 'E', 'o' ),    { 5 }
  ('E', 'o', 'o', 'o', 'E', 'E' ),    { 6 }
  ('E', 'o', 'E', 'o', 'E', 'o' ),    { 7 }
  ('E', 'o', 'E', 'o', 'o', 'E' ),    { 8 }
  ('E', 'o', 'o', 'E', 'o', 'E' )     { 9 }
  );

function TAsBarcode.Code_UPC_E0: string;
var
  c: char;
  i,j: Integer;
begin
  CheckTextLength(6);

  if FCheckSum then
  begin
    FText := DoCheckSumming(Copy(FText, 1, 6));
  end;
  c := FText[7];
  Result := '505';   {Startcode}
  for i:=1 to 6 do
  begin
    if Table_UPC_E0[c,i]='E' then
    begin
      for j:= 1 to 4 do
        Result := Result + Table_EAN_C[FText[i],5-j];
    end else
    begin
      Result := Result + Table_EAN_A[FText[i]];
    end;
  end;
  Result := Result + '050505';   {Stopcode}
end;

function TAsBarcode.Code_UPC_E1: string;
var
  c: char;
  i, j: Integer;
begin
  c := #0;
  { Calculate CRC }
  CalcCRC(6);
  Result := '505';   {Startcode}
  for i := 1 to 6 do
  begin
    if Table_UPC_E0[c,i]='E' then
    begin
      Result := Result + Table_EAN_A[FText[i]];
    end
    else
    begin
      for j:= 1 to 4 do
        Result := Result + Table_EAN_C[FText[i],5-j];
    end;
  end;
  Result := Result + '050505';   {Stopcode}
end;

{ assist function }
function getSupp(Nr: string): String;
var
  i,fak,sum: Integer;
  tmp: string;
begin
  sum := 0;
  tmp := copy(nr,1,Length(Nr)-1);
  fak := Length(tmp);
  for i:=1 to length(tmp) do
  begin
    if (fak mod 2) = 0 then
      sum := sum + (StrToInt(tmp[i])*9)
    else
      sum := sum + (StrToInt(tmp[i])*3);
    dec(fak);
  end;
  sum:=((sum mod 10) mod 10) mod 10;
  getSupp := tmp+IntToStr(sum);
end;

function TAsBarcode.Code_Supp5: string;
var
  c: char;
  i,j: Integer;
begin
  c := #0;
(*
  FText := SetLen(5);
  tmp:=getSupp(copy(FText,1,5)+'0');
  c:=tmp[6];
  if FCheckSum then FText:=tmp else tmp := FText;
*)
  Result := '506';   {Startcode}
  for i:=1 to 5 do
  begin
    if Table_UPC_E0[c,(6-5)+i]='E' then
    begin
      for j:= 1 to 4 do Result := Result + Table_EAN_C[FText[i],5-j];
    end
    else
    begin
      Result := Result + Table_EAN_A[FText[i]];
    end;
    if i<5 then
      Result := Result + '05'; { character delineator }
  end;
end;

function TAsBarcode.Code_Supp2: string;
var
  i,j: Integer;
  tmp, mS: string;
begin
  { FText := SetLen(2); }
  i := StrToInt(Ftext);
  case i mod 4 of
    3: mS := 'EE';
    2: mS := 'Eo';
    1: mS := 'oE';
    0: mS := 'oo';
  end;
  tmp:=getSupp(copy(FText,1,5)+'0');

  if FCheckSum then FText:=tmp else tmp := FText;
  Result := '506';   {Startcode}
  for i := 1 to 2 do
  begin
    if mS[i]='E' then
    begin
      for j:= 1 to 4 do
        Result := Result + Table_EAN_C[tmp[i],5-j];
    end else
    begin
      Result := Result + Table_EAN_A[tmp[i]];
    end;
    if i < 2 then
      Result := Result + '05'; { character delineator }
  end;
end;

{---------------}

procedure TAsBarcode.MakeModules;
begin
  case FBarcodeType of
    btCode_2_5_interleaved,
    btCode_2_5_industrial,
    btCode39,
    btCodeEAN8,
    btCodeEAN13,
    btCode39Extended,
    btCodeCodabar,
    btCodeUPC_A,
    btCodeUPC_E0,
    btCodeUPC_E1,
    btCodeUPC_Supp2,
    btCodeUPC_Supp5:

    begin
      if FRatio < 2.0 then FRatio := 2.0;
      if FRatio > 3.0 then FRatio := 3.0;
    end;

    btCode_2_5_matrix:
    begin
      if FRatio < 2.25 then FRatio := 2.25;
      if FRatio > 3.0 then FRatio := 3.0;
    end;
    btCode128A,
    btCode128B,
    btCode128C,
    btCode93,
    btCode93Extended,
    btCodeMSI,
    btCodePostNet:    ;
  end;
(*
  FModules[0] := FModule;
  FModules[1] := Round(FModule*FRatio);
  FModules[2] := FModules[1] * 3 div 2;
  FModules[3] := FModules[1] * 2;
*)
  FModules[0] := FModule;
  FModules[1] := FModule * 2;
  FModules[2] := FModule * 3;
  FModules[3] := FModule * 4;
end;

procedure TAsBarcode.SetRatio(const Value: Double);
begin
  if Value <> FRatio then
  begin
    FRatio := Value;
  end;
end;

procedure TAsBarcode.SetCheckSum(const Value: Boolean);
begin
  if Value <> FCheckSum then
  begin
    FCheckSum := Value;
  end;
end;

{ Перевод штрихов в точки }

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

(*
  Перевод точек из текстового в двоичное представление
  '00011001' -> #$19
*)

function DotsToBin(const Data: string): string;
var
  C: Char;
  L: Integer;
  i: Integer;
  DataSize: Integer;
  BitIndex: Integer;
  CharIndex: Integer;
begin
  Result := '';

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
      C := Result[CharIndex];
      C := Chr(SetBit(Ord(C), BitIndex));
      Result[CharIndex] := C;
    end;
  end;
end;

{ Converting Barcode to bits }

function TAsBarcode.CreateBarcodeDots: string;
var
  i: Integer;
  Pattern: string;
  BarWidth: Integer;
  LineType: TBarLineType;
begin
  Result := '';
  Pattern := MakeData;
  for i := 1 to Length(Pattern) do
  begin
    GetBarProps(Pattern[i], BarWidth, LineType);
    if LineType = white then
    begin
      Result := Result + StringOfChar(#0, BarWidth);
    end else
    begin
      Result := Result + StringOfChar(#1, BarWidth);
    end;
  end;
end;

// Left alignment
// Nothing to do

procedure TAsBarcode.AlignLeft;
begin
  FLineData := FLineData + StringOfChar(#0, PrintWidthInDots - BarcodeWidthInDots);
end;

// Right alignment

procedure TAsBarcode.AlignRight;
begin
  FLineData := StringOfChar(#0, PrintWidthInDots - BarcodeWidthInDots) + FLineData;
end;

// Center alignment

procedure TAsBarcode.AlignCenter;
var
  DotCount: Integer;
  LeftDotCount: Integer;
begin
  DotCount := PrintWidthInDots - BarcodeWidthInDots;
  LeftDotCount := DotCount div 2;
  FLineData := StringOfChar(#0, LeftDotCount) + FLineData +
    StringOfChar(#0, DotCount - LeftDotCount)
end;

// Barcode alignment

procedure TAsBarcode.MakeAlignment;
begin
  case Alignment of
    baLeft   : AlignLeft;
    baRight  : AlignRight;
    baCenter : AlignCenter;
  else
    raiseException('Unknown alignment type');
  end;
end;

procedure TAsBarcode.CreateBarcode;
begin
  FLineData := CreateBarcodeDots;
  FBarcodeWidthInDots := Length(FLineData);
  if FBarcodeWidthInDots > PrintWidthInDots then
    raiseException('Barcode width is larger than printing width');
  MakeAlignment;
  FLineData := DotsToBin(LineData);
end;

end.
