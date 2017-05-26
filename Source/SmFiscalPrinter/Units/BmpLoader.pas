unit BmpLoader;

interface

uses
  // VCL
  Windows, Classes, SysUtils, Graphics,
  // This
  SharedPrinterInterface, FiscalPrinterTypes, OposMessages, ByteUtils,
  DriverTypes;

type
  { TBmpLoader }

  TBmpLoader = class
  private
    FLogoSize: Integer;
    FStartLine: Integer;
    FCenterLogo: Boolean;
    FPrinter: ISharedPrinter;
    FOnProgress: TProgressEvent;

    procedure ProgressEvent(Progress: Integer);
    function IsInversedPalette(Bitmap: TBitmap): Boolean;
    function GetLineData(Bitmap: TBitmap; Index: Integer): string;

    property Printer: ISharedPrinter read FPrinter;
  public
    constructor Create(APrinter: ISharedPrinter);
    destructor Destroy; override;

    function GetBitmapData(Bitmap: TBitmap): string;
    procedure Load(const FileName: string);
    procedure LoadBitmap(Bitmap: TBitmap);

    property LogoSize: Integer read FLogoSize;
    property StartLine: Integer read FStartLine write FStartLine;
    property CenterLogo: Boolean read FCenterLogo write FCenterLogo;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
  end;

function GetBitmapData(APrinter: ISharedPrinter; Bitmap: TBitmap;
  CenterLogo: Boolean): string;

implementation

procedure AlignBitmapWidth(Bitmap: TBitmap; const NewWidth: Integer);
var
  NewHeight: Integer;
begin
  NewHeight := Trunc(Bitmap.Height*(NewWidth/Bitmap.Width));
  Bitmap.Canvas.StretchDraw(
    Rect(0, 0, NewWidth, NewHeight),
    Bitmap);
  Bitmap.Width := NewWidth;
  Bitmap.Height := NewHeight;
end;

function GetBitmapData(APrinter: ISharedPrinter; Bitmap: TBitmap;
  CenterLogo: Boolean): string;
var
  Loader: TBmpLoader;
begin
  Loader := TBmpLoader.Create(APrinter);
  try
    Loader.CenterLogo := CenterLogo;
    Result := Loader.GetBitmapData(Bitmap);
  finally
    Loader.Free;
  end;
end;

function Inverse(const S: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
    Result := Result + Chr(Ord(S[i]) xor $FF);
end;

function GetLine(const Text: string; MinLength, MaxLength: Integer): string;
begin
  Result := Copy(Text, 1, MaxLength);
  Result := Result + StringOfChar(#0, MinLength - Length(Result));
end;

{ TBmpLoader }

constructor TBmpLoader.Create(APrinter: ISharedPrinter);
begin
  inherited Create;
  FPrinter := APrinter;
  FStartLine := 1;
end;

destructor TBmpLoader.Destroy;
begin
  FPrinter := nil;
  inherited Destroy;
end;


procedure TBmpLoader.Load(const FileName: string);
var
  Bitmap: TBitmap;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.LoadFromFile(FileName);
    LoadBitmap(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TBmpLoader.LoadBitmap(Bitmap: TBitmap);
var
  i: Integer;
  Count: Integer;
  Progress: Integer;
  NewProgress: Integer;
  ProgressStep: Double;
  Model: TPrinterModelRec;
begin
  Model := Printer.Device.GetModel;
  Bitmap.Monochrome := True;
  Bitmap.PixelFormat := pf1Bit;

  if Bitmap.Height = 0 then
    raise Exception.Create(MsgImageHeightIsZero);

  if Bitmap.Width > Model.MaxGraphicsWidth then
  begin
    AlignBitmapWidth(Bitmap, Model.MaxGraphicsWidth);
  end;
  Device.CheckGraphicsSize(FLogoSize);

  Progress := 0;
  Count := Bitmap.Height;
  FLogoSize := Bitmap.Height;
  ProgressStep := Bitmap.Height/100;
  for i := 0 to Count-1 do
  begin
    Device.Check(Device.LoadGraphics(i+ StartLine, GetLineData(Bitmap, i)));
    NewProgress := Round(i/ProgressStep);
    if (NewProgress <> Progress)and(NewProgress <= 100) then
    begin
      Progress := NewProgress;
      ProgressEvent(NewProgress);
    end;
  end;
  ProgressEvent(100);
end;

procedure TBmpLoader.ProgressEvent(Progress: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Progress);
end;

function TBmpLoader.IsInversedPalette(Bitmap: TBitmap): Boolean;
var
  PaletteSize: Integer;
  PalEntry: TPaletteEntry;
begin
  Result := False;
  if Bitmap.Palette <> 0 then
  begin
    PaletteSize := 0;
    if GetObject(Bitmap.Palette, SizeOf(PaletteSize), @PaletteSize) = 0 then Exit;
    if PaletteSize = 0 then Exit;
    GetPaletteEntries(Bitmap.Palette, 0, 1, PalEntry);
    Result := (PalEntry.peRed = $FF)and(PalEntry.peGreen = $FF)and(PalEntry.peBlue = $FF);
  end;
end;

function TBmpLoader.GetLineData(Bitmap: TBitmap; Index: Integer): string;
var
  i: Integer;
  Len: Integer;
begin
  Result := '';
  Len := Bitmap.Width div 8;
  for i := 0 to Len-1 do
    Result := Result + Chr(SwapByte($FF - PByteArray(Bitmap.ScanLine[Index])[i]));

  // If palette is inverse
  if IsInversedPalette(Bitmap) then
    Result := Inverse(Result);

  if CenterLogo then
    Result := StringOfChar(#0, (320 - Bitmap.Width) div 16) + Result;

  Result := GetLine(Result, 40, 40);
end;

function TBmpLoader.GetBitmapData(Bitmap: TBitmap): string;
var
  i: Integer;
begin
  if Bitmap.Height > Device.GetModel.MaxGraphicsHeight then
    raise Exception.Create(MsgImageHeightMoreThanMaximum);

  if Bitmap.Width > Device.GetModel.MaxGraphicsWidth then
    raise Exception.Create(MsgImageWidthMoreThanMaximum);

  Bitmap.Monochrome := True;
  Bitmap.PixelFormat := pf1Bit;

  Result := '';
  for i := 0 to Bitmap.Height-1 do
    Result := Result + GetLineData(Bitmap, i);
end;

end.
