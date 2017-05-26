unit EscPrinter;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // This
  //AsBarcode,
  FiscalPrinterTypes, PrinterTypes, PrinterParameters, DirectIOAPI;

const
  /////////////////////////////////////////////////////////////////////////////
  // Barcode type 1 constants

  BARCODE_TYPE1_UPCA     = 0;
  BARCODE_TYPE1_UPCE     = 1;
  BARCODE_TYPE1_EAN13    = 2;
  BARCODE_TYPE1_EAN8     = 3;
  BARCODE_TYPE1_CODE39   = 4;
  BARCODE_TYPE1_ITF25    = 5;
  BARCODE_TYPE1_CODABAR  = 6;
  BARCODE_TYPE1_PDF417   = 10;

  /////////////////////////////////////////////////////////////////////////////
  // Barcode type 2 constants

  BARCODE_TYPE2_UPCA     = 65;
  BARCODE_TYPE2_UPCE     = 66;
  BARCODE_TYPE2_EAN13    = 67;
  BARCODE_TYPE2_EAN8     = 68;
  BARCODE_TYPE2_CODE39   = 69;
  BARCODE_TYPE2_ITF25    = 70;
  BARCODE_TYPE2_CODABAR  = 71;
  BARCODE_TYPE2_CODE93   = 72;
  BARCODE_TYPE2_CODE128  = 73;
  BARCODE_TYPE2_PDF417   = 75;

  /////////////////////////////////////////////////////////////////////////////
  // Barcode HRI position constants

  BARCODE_HRI_NONE      = 0;
  BARCODE_HRI_ABOVE     = 1;
  BARCODE_HRI_BELOW     = 2;
  BARCODE_HRI_BOTH      = 3;

type
  { TStringStream }

  TStringStream = class
  private
    FData: string;
    FPosition: Integer;
    procedure CheckEOF;
  public
    function EOF: Boolean;
    function ReadByte: Byte;
    function ReadChar: Char;
    procedure Write(const AData: string);
    function ReadData(EndFlag: Char): string;
    function ReadString(Len: Integer): string;

    property Data: string read FData;
    property Position: Integer read FPosition;
  end;

  { TEscBarcode }

  TEscBarcode = class
  private
    FData: string;
    FHeight: Integer;
    FFontType: Integer;
    FLineWidth: Integer;
    FBarcodeType: Integer;
    FHRIPosition: Integer;
    FPrinter: ISharedPrinter;

    procedure PrintTextAbove;
    procedure PrintTextBelow;
    procedure SetHeight(const Value: Integer);
    procedure SetFontType(const Value: Integer);
    procedure SetLineWidth(const Value: Integer);
    procedure SetHRIPosition(const Value: Integer);
  public
    constructor Create(APrinter: ISharedPrinter);
    procedure Print;

    property Data: string read FData write FData;
    property Printer: ISharedPrinter read FPrinter;
    property Height: Integer read FHeight write SetHeight;
    property FontType: Integer read FFontType write SetFontType;
    property LineWidth: Integer read FLineWidth write SetLineWidth;
    property BarcodeType: Integer read FBarcodeType write FBarcodeType;
    property HRIPosition: Integer read FHRIPosition write SetHRIPosition;
  end;

  { TEscPrinter }

  TEscPrinter = class
  private
    FBarcode: TEscBarcode;
    FIsHeaderLine: Boolean;
    FPrinter: ISharedPrinter;
    FStream: TStringStream;

    procedure Decode1B;
    procedure Decode1D;

    property Barcode: TEscBarcode read FBarcode;
  public
    constructor Create(APrinter: ISharedPrinter);
    destructor Destroy; override;

    procedure Execute(var Data: WideString);

    property IsHeaderLine: Boolean read FIsHeaderLine write FIsHeaderLine;
  end;

  { EscPrinterError }

  EscPrinterError = class(Exception);

implementation

resourcestring
  SCommandNotSupported = 'Команда не поддерживается';
  SInvalidCommandLength = 'Неверная длина команды';

procedure RaiseError(const Msg: string);
begin
  raise EscPrinterError.Create(Msg);
end;

procedure InvalidCommand;
begin
  raiseError(SCommandNotSupported);
end;

function ValidLength(const Data: string; MinLength: Integer): Boolean;
begin
	Result := Length(Data) >= MinLength;
end;

procedure CheckLength(const Data: string; MinLength: Integer);
begin
	if not ValidLength(Data, MinLength) then
    raiseError(SInvalidCommandLength);
end;

{ TEscPrinter }

constructor TEscPrinter.Create(APrinter: ISharedPrinter);
begin
  inherited Create;
  FPrinter := APrinter;
  FStream := TStringStream.Create;
  FBarcode := TEscBarcode.Create(APrinter);
end;

destructor TEscPrinter.Destroy;
begin
  FPrinter := nil;
  FStream.Free;
  FBarcode.Free;
  inherited Destroy;
end;

procedure TEscPrinter.Execute(var Data: WideString);
var
  Code1: Integer;
  Result: WideString;
begin
  Result := '';
  FStream.Write(Data);
  while not FStream.EOF do
  begin
    Code1 := FStream.ReadByte;
    case Code1 of
      $1B: Decode1B;
      $1D: Decode1D;
    else
      Result := Result + Chr(Code1);
    end;
  end;
  Data := Result;
end;

procedure TEscPrinter.Decode1B;
var
  Code2: Integer;
  FileName: string;
begin
  if FStream.EOF then Exit;
  Code2 := FStream.ReadByte;
  if Code2 = $62 then
  begin
    FileName := FStream.ReadData(#10);
    if not(FPrinter.Parameters.IsLogoLoaded and (FPrinter.Parameters.LogoFileName = FileName)) then
    begin
      FPrinter.LoadLogo(FileName);
      if not IsHeaderLine then
      begin
        FPrinter.PrintLogo;
      end;
    end;
  end;
end;

procedure TEscPrinter.Decode1D;
var
  L: Integer;
  Code2: Integer;
  Value: Integer;
begin
  if FStream.EOF then Exit;
  Code2 := FStream.ReadByte;
  if FStream.EOF then Exit;
  Value := FStream.ReadByte;

  case Code2 of
    $48: Barcode.HRIPosition := Value;
    $66: Barcode.FontType := Value;
    $68: Barcode.Height := Value;
    $77: Barcode.LineWidth := Value;
    $6B:
    begin
      Barcode.BarcodeType := Value;
      if (Value in [0..6, 10]) then
      begin
        Barcode.Data := FStream.ReadData(#0);
      end else
      begin
        if FStream.EOF then Exit;
        L := FStream.ReadByte;
        Barcode.Data := FStream.ReadString(L);
      end;
      Barcode.Print;
    end;
  end;
end;

{ TEscBarcode }

constructor TEscBarcode.Create(APrinter: ISharedPrinter);
begin
  inherited Create;
  FPrinter := APrinter;
end;

procedure TEscBarcode.SetHRIPosition(const Value: Integer);
begin
  if not (Value in [0..3]) then
    raise Exception.CreateFmt(
    'Неверное значение положения текста (%d). Должно быть 0..3', [Value]);

  FHRIPosition := Value;
end;

procedure TEscBarcode.SetFontType(const Value: Integer);
begin
  if not (Value in [0..1]) then
    raise Exception.CreateFmt(
    'Неверное значение типа шрифта (%d). Должно быть 0..1', [Value]);

  FFontType := Value;
end;

procedure TEscBarcode.SetLineWidth(const Value: Integer);
begin
  if not(Value in [1..6]) then
    raise Exception.CreateFmt(
    'Неверное значение ширины шрих-кода (%d). Должно быть 1..6', [Value]);

  FLineWidth := Value;
end;

procedure TEscBarcode.SetHeight(const Value: Integer);
begin
  if not(Value in [0..255]) then
    raise Exception.CreateFmt(
    'Неверное значение высоты шрих-кода (%d). Должно быть 1..255', [Value]);

  FHeight := Value;
end;

procedure TEscBarcode.PrintTextAbove;
begin
  if HRIPosition in [BARCODE_HRI_ABOVE, BARCODE_HRI_BOTH] then
    FPrinter.PrintText(Data, FPrinter.Station, 1, taCenter);
end;

procedure TEscBarcode.PrintTextBelow;
begin
  if HRIPosition in [BARCODE_HRI_BELOW, BARCODE_HRI_BOTH] then
    FPrinter.PrintText(Data, FPrinter.Station, 1, taCenter);
end;

function DecodeBarcodeType(Value: Integer): Integer;
begin
  case Value of
    BARCODE_TYPE1_UPCA: Result := DIO_BARCODE_UPCA_CC;
    BARCODE_TYPE1_UPCE: Result := DIO_BARCODE_UPCE_CC;
    BARCODE_TYPE1_EAN13: Result := DIO_BARCODE_EAN13_INT;
    BARCODE_TYPE1_EAN8: Result := DIO_BARCODE_EAN8;
    BARCODE_TYPE1_CODE39: Result := DIO_BARCODE_CODE39;
    BARCODE_TYPE1_ITF25: Result := DIO_BARCODE_CODE25INTERLEAVED;
    BARCODE_TYPE1_CODABAR: Result := DIO_BARCODE_CODABAR;
    BARCODE_TYPE1_PDF417: Result := DIO_BARCODE_PDF417;

    BARCODE_TYPE2_UPCA: Result := DIO_BARCODE_UPCA_CC;
    BARCODE_TYPE2_UPCE: Result := DIO_BARCODE_UPCE_CC;
    BARCODE_TYPE2_EAN13: Result := DIO_BARCODE_EAN13_INT;
    BARCODE_TYPE2_EAN8: Result := DIO_BARCODE_EAN8;
    BARCODE_TYPE2_CODE39: Result := DIO_BARCODE_CODE39;
    BARCODE_TYPE2_ITF25: Result := DIO_BARCODE_CODE25INTERLEAVED;
    BARCODE_TYPE2_CODABAR: Result := DIO_BARCODE_CODABAR;
    BARCODE_TYPE2_CODE93: Result := DIO_BARCODE_CODE93;
    BARCODE_TYPE2_CODE128: Result := DIO_BARCODE_HIBC_128;
    BARCODE_TYPE2_PDF417: Result := DIO_BARCODE_PDF417;
  else
    raise Exception.CreateFmt('Invalid barcode type, %d', [Value]);
  end;
end;

procedure TEscBarcode.Print;
var
  Barcode: TBarcodeRec;
begin
  if Height = 0 then
  begin
    PrintTextAbove;
    FPrinter.Device.PrintBarcode(Data);
	end else
  begin
    Barcode.Data := Data;
    Barcode.Text := Data;
    Barcode.Height := Height;
    Barcode.ModuleWidth := LineWidth;
    Barcode.Alignment := BARCODE_ALIGNMENT_CENTER;
    Barcode.BarcodeType := DecodeBarcodeType(BarcodeType);

    PrintTextAbove;
    FPrinter.Device.PrintBarcode2(Barcode);
    PrintTextBelow;
  end;
end;

{ TStringStream }

function TStringStream.EOF: Boolean;
begin
  Result := Position > Length(FData);
end;

procedure TStringStream.CheckEOF;
begin
  if EOF then
    raise Exception.Create('TStringStream.CheckEOF');
end;

function TStringStream.ReadData(EndFlag: Char): string;
var
  C: Char;
begin
  Result := '';
  while not EOF do
  begin
    C := ReadChar;
    if C = EndFlag then Break;
    Result := Result + C;
  end;
end;

function TStringStream.ReadByte: Byte;
begin
  CheckEOF;
  Result := Ord(FData[FPosition]);
  Inc(FPosition);
end;

function TStringStream.ReadChar: Char;
begin
  CheckEOF;
  Result := FData[FPosition];
  Inc(FPosition);
end;

procedure TStringStream.Write(const AData: string);
begin
  FData := AData;
  FPosition := 1;
end;

function TStringStream.ReadString(Len: Integer): string;
begin
  CheckEOF;
  Result := '';
  Result := Copy(FData, FPosition, Len);
  Inc(FPosition, Len);
end;

// #$1D#$2F#$00


end.
