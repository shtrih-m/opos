unit GS1Barcode;

interface

uses
  // VCL
  Classes, SysUtils,
  // This
  EkmClient, DriverError, TntSysUtils;


const
  GS = #$1D;

type
  { TGS1Barcode }

  TGS1Barcode = record
    GTIN: AnsiString;
    Serial: AnsiString;
  end;

  { TGS1Token }

  TGS1Token = class(TCollectionItem)
  public
    id: AnsiString;
    Data: AnsiString;
  end;

  { TGS1Tokens }

  TGS1Tokens = class(TCollection)
  private
    function GetItem(Index: Integer): TGS1Token;
  public
    procedure DecodeAI(Barcode: AnsiString);
    procedure DecodeBraces(const Data: AnsiString);
    function ItemByID(const ID: AnsiString): TGS1Token;
    property Items[Index: Integer]: TGS1Token read GetItem; default;
  end;

function IsValidGS1(const Barcode: AnsiString): Boolean;
function DecodeGS1(const Barcode: AnsiString): TGS1Barcode;

implementation


function IsValidGS1(const Barcode: AnsiString): Boolean;
var
  Tokens: TGS1Tokens;
begin
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeAI(Barcode);
    Result := (Tokens.ItemByID('01') <> nil)and(Tokens.ItemByID('21') <> nil);
  finally
    Tokens.Free;
  end;
end;

function DecodeGS1(const Barcode: AnsiString): TGS1Barcode;
var
  Token: TGS1Token;
  Tokens: TGS1Tokens;
const
  STagNotFound = '“ег %s не найден';
begin
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeAI(Barcode);
    if (Tokens.ItemByID('01') = nil) or (Tokens.ItemByID('21') = nil) then
    begin
      Result.GTIN := Copy(Barcode, 1, 14);
      Result.Serial := Copy(Barcode, 15, 7);
    end else
    begin

      Token := Tokens.ItemByID('01');
      if Token = nil then
        raiseError(E_TAG_NOT_FOUND, Tnt_WideFormat(STagNotFound, ['GTIN(01)']));
      Result.GTIN := Token.Data;

      Token := Tokens.ItemByID('21');
      if Token = nil then
        raiseError(E_TAG_NOT_FOUND, Tnt_WideFormat(STagNotFound, ['SerialNumber(21)']));
      Result.Serial := Token.Data;
    end;
  finally
    Tokens.Free;
  end;
end;

type
  { TAIREc }

  TAIREc = record
    id: AnsiString;
    min: Integer;
    max: Integer;
  end;

const
  AIItems: array [0..157] of TAIREc = (
    (id: '00'; min: 18; max: 18), // Serial Shipping Container Code (SSCC)
    (id: '01'; min: 14; max: 14), // Global Trade Item Number (GTIN)
    (id: '02'; min: 14; max: 14), // GTIN of contained trade items
    (id: '03'; min: 14; max: 14), // ?
    (id: '04'; min: 16; max: 16), // ?
    (id: '10'; min: 1; max: 20), // Batch or lot number
    (id: '11'; min: 6; max: 6), // Production date (YYMMDD)
    (id: '12'; min: 6; max: 6), // Due date (YYMMDD)
    (id: '13'; min: 6; max: 6), // Packaging date (YYMMDD)
    (id: '14'; min: 6; max: 6), // ?
    (id: '15'; min: 6; max: 6), // Best before date (YYMMDD)
    (id: '16'; min: 6; max: 6), // Sell by date (YYMMDD)
    (id: '17'; min: 6; max: 6), // Expiration date (YYMMDD)
    (id: '18'; min: 6; max: 6), // ?
    (id: '19'; min: 6; max: 6), // ?
    (id: '20'; min: 2; max: 2), // Internal product variant
    (id: '21'; min: 1; max: 20), // Serial number (FNC1)
    (id: '22'; min: 1; max: 20), // Consumer product variant (FNC1)
    (id: '240'; min: 1; max: 30), // Additional item identification (FNC1)
    (id: '241'; min: 1; max: 30), // Customer part number
    (id: '242'; min: 1; max: 6), // Made-to-Order variation number
    (id: '243'; min: 1; max: 20), // Packaging component number
    (id: '250'; min: 1; max: 30), // Secondary serial number
    (id: '251'; min: 1; max: 30), // Reference to source entity
    (id: '253'; min: 1; max: 17), // Global Document Type Identifier (GDTI)
    (id: '254'; min: 1; max: 20), // GLN extension component
    (id: '255'; min: 1; max: 12), // Global Coupon Number (GCN)
    (id: '291'; min: 1; max: 30), // CRC
    (id: '30'; min: 8; max: 8), // Variable count of items (variable measure trade item)
    (id: '310'; min: 6; max: 6), // Net weight, kilograms (variable measure trade item)
    (id: '311'; min: 6; max: 6), // Length or first dimension, metres (variable measure trade item)
    (id: '312'; min: 6; max: 6), // Width, diameter, or second dimension, metres (variable measure trade item)
    (id: '313'; min: 6; max: 6), // Depth, thickness, height, or third dimension, metres (variable measure trade item)
    (id: '314'; min: 6; max: 6), // Area, square metres (variable measure trade item)
    (id: '315'; min: 6; max: 6), // Net volume, litres (variable measure trade item)
    (id: '316'; min: 6; max: 6), // Net volume, cubic metres (variable measure trade item)
    (id: '320'; min: 6; max: 6), // Net weight, pounds (variable measure trade item)
    (id: '321'; min: 6; max: 6), // Length or first dimension, inches (variable measure trade item)
    (id: '322'; min: 6; max: 6), // Length or first dimension, feet (variable measure trade item)
    (id: '323'; min: 6; max: 6), // Length or first dimension, yards (variable measure trade item)
    (id: '324'; min: 6; max: 6), // Width, diameter, or second dimension, inches (variable measure trade item)
    (id: '325'; min: 6; max: 6), // Width, diameter, or second dimension, feet (variable measure trade item)
    (id: '326'; min: 6; max: 6), // Width, diameter, or second dimension, yards (variable measure trade item)
    (id: '327'; min: 6; max: 6), // Depth, thickness, height, or third dimension, inches (variable measure trade item)
    (id: '328'; min: 6; max: 6), // Depth, thickness, height, or third dimension, feet (variable measure trade item)
    (id: '329'; min: 6; max: 6), // Depth, thickness, height, or third dimension, yards (variable measure trade item)
    (id: '330'; min: 6; max: 6), // Logistic weight, kilograms
    (id: '331'; min: 6; max: 6), // Length or first dimension, metres
    (id: '332'; min: 6; max: 6), // Width, diameter, or second dimension, metres
    (id: '333'; min: 6; max: 6), // Depth, thickness, height, or third dimension, metres
    (id: '334'; min: 6; max: 6), // Area, square metres
    (id: '335'; min: 6; max: 6), // Logistic volume, litres
    (id: '336'; min: 6; max: 6), // Logistic volume, cubic metres
    (id: '337'; min: 6; max: 6), // Kilograms per square metre
    (id: '340'; min: 6; max: 6), // Logistic weight, pounds
    (id: '341'; min: 6; max: 6), // Length or first dimension, inches
    (id: '342'; min: 6; max: 6), // Length or first dimension, feet
    (id: '343'; min: 6; max: 6), // Length or first dimension, yards
    (id: '344'; min: 6; max: 6), // Width, diameter, or second dimension, inches
    (id: '345'; min: 6; max: 6), // Width, diameter, or second dimension, feet
    (id: '346'; min: 6; max: 6), // Width, diameter, or second dimension, yard
    (id: '347'; min: 6; max: 6), // Depth, thickness, height, or third dimension, inches
    (id: '348'; min: 6; max: 6), // Depth, thickness, height, or third dimension, feet
    (id: '349'; min: 6; max: 6), // Depth, thickness, height, or third dimension, yards
    (id: '350'; min: 6; max: 6), // Area, square inches (variable measure trade item)
    (id: '351'; min: 6; max: 6), // Area, square feet (variable measure trade item)
    (id: '352'; min: 6; max: 6), // Area, square yards (variable measure trade item)
    (id: '353'; min: 6; max: 6), // Area, square inches
    (id: '354'; min: 6; max: 6), // Area, square feet
    (id: '355'; min: 6; max: 6), // Area, square yards
    (id: '356'; min: 6; max: 6), // Net weight, troy ounces (variable measure trade item)
    (id: '357'; min: 6; max: 6), // Net weight (or volume), ounces (variable measure trade item)
    (id: '360'; min: 6; max: 6), // Net volume, quarts (variable measure trade item)
    (id: '361'; min: 6; max: 6), // Net volume, gallons U.S. (variable measure trade item)
    (id: '362'; min: 6; max: 6), // Logistic volume, quarts
    (id: '363'; min: 6; max: 6), // Logistic volume, gallons U.S.
    (id: '364'; min: 6; max: 6), // Net volume, cubic inches (variable measure trade item)
    (id: '365'; min: 6; max: 6), // Net volume, cubic feet (variable measure trade item)
    (id: '366'; min: 6; max: 6), // Net volume, cubic yards (variable measure trade item)
    (id: '367'; min: 6; max: 6), // Logistic volume, cubic inches
    (id: '368'; min: 6; max: 6), // Logistic volume, cubic feet
    (id: '369'; min: 6; max: 6), // Logistic volume, cubic yards
    (id: '369'; min: 6; max: 6), // Logistic volume, cubic yards
    (id: '37'; min: 1; max: 8), // Count of trade items
    (id: '390'; min: 1; max: 15), // Applicable amount payable or Coupon value, local currency
    (id: '391'; min: 4; max: 18), // Applicable amount payable with ISO currency code
    (id: '392'; min: 1; max: 15), // Applicable amount payable, single monetary area (variable measure trade item)
    (id: '393'; min: 4; max: 18), // Applicable amount payable with ISO currency code (variable measure trade item)
    (id: '394'; min: 4; max: 4), // Percentage discount of a coupon
    (id: '400'; min: 1; max: 30), // Customer's purchase order number
    (id: '401'; min: 1; max: 30), // Global Identification Number for Consignment (GINC)
    (id: '402'; min: 17; max: 17), // Global Shipment Identification Number (GSIN)
    (id: '403'; min: 1; max: 30), // Routing code
    (id: '410'; min: 13; max: 13), // Ship to - Deliver to Global Location Number
    (id: '411'; min: 13; max: 13), // Bill to - Invoice to Global Location Number
    (id: '412'; min: 13; max: 13), // Purchased from Global Location Number
    (id: '413'; min: 13; max: 13), // Ship for - Deliver for - Forward to Global Location Number
    (id: '414'; min: 13; max: 13), // Identification of a physical location - Global Location Number
    (id: '415'; min: 13; max: 13), // Global Location Number of the invoicing party
    (id: '416'; min: 13; max: 13), // GLN of the production or service location
    (id: '420'; min: 1; max: 20), // Deliver to postal code within a single postal authority
    (id: '421'; min: 4; max: 12), // Ship to - Deliver to postal code with ISO country code
    (id: '422'; min: 3; max: 3), // Country of origin of a trade item
    (id: '423'; min: 4; max: 15), // Country of initial processing
    (id: '424'; min: 3; max: 3), // Country of processing
    (id: '425'; min: 3; max: 15), // Country of disassembly
    (id: '426'; min: 3; max: 3), // Country covering full process chain
    (id: '427'; min: 1; max: 3), // Country subdivision Of origin
    (id: '7001'; min: 13; max: 13), // NATO Stock Number (NSN)
    (id: '7002'; min: 1; max: 30), // UN/ECE meat carcasses and cuts classification
    (id: '7003'; min: 10; max: 10), // Expiration date and time
    (id: '7004'; min: 1; max: 4), // Active potency
    (id: '7005'; min: 1; max: 12), // Catch area
    (id: '7006'; min: 6; max: 6), // First freeze date
    (id: '7007'; min: 6; max: 12), // Harvest date
    (id: '7008'; min: 1; max: 3), // Species for fishery purposes
    (id: '7009'; min: 1; max: 10), // Fishing gear type
    (id: '7010'; min: 1; max: 2), // Production method
    (id: '7020'; min: 1; max: 20), // Refurbishment lot ID
    (id: '7021'; min: 1; max: 20), // Functional status
    (id: '7022'; min: 1; max: 20), // Revision status
    (id: '7023'; min: 1; max: 30), // Global Individual Asset Identifier (GIAI) of an assembly
    (id: '7023'; min: 1; max: 30), // Global Individual Asset Identifier (GIAI) of an assembly
    (id: '703'; min: 4; max: 30), // Number of processor with ISO Country Code
    (id: '710'; min: 1; max: 20), // National Healthcare Reimbursement Number (NHRN) Ц Germany PZN
    (id: '711'; min: 1; max: 20), // National Healthcare Reimbursement Number (NHRN) Ц France CIP
    (id: '712'; min: 1; max: 20), // National Healthcare Reimbursement Number (NHRN) Ц Spain CN
    (id: '713'; min: 1; max: 20), // National Healthcare Reimbursement Number (NHRN) Ц Brasil DRN
    (id: '8001'; min: 14; max: 14), // Roll products (width, length, core diameter, direction, splices)
    (id: '8002'; min: 1; max: 20), // Cellular mobile telephone identifier
    (id: '8003'; min: 15; max: 30), // Global Returnable Asset Identifier (GRAI)
    (id: '8004'; min: 1; max: 30), // Global Individual Asset Identifier (GIAI)
    (id: '8005'; min: 6; max: 6), // Price per unit of measure
    (id: '8006'; min: 18; max: 18), // Identification of an individual trade item piece
    (id: '8007'; min: 1; max: 34), // International Bank Account Number (IBAN)
    (id: '8008'; min: 9; max: 12), // Date and time of production
    (id: '8010'; min: 1; max: 30), // Component / Part Identifier (CPID)
    (id: '8011'; min: 1; max: 12), // Component / Part Identifier serial number (CPID SERIAL)
    (id: '8012'; min: 1; max: 20), // Software version
    (id: '8017'; min: 18; max: 18), // Global Service Relation Number to identify the relationship between an organisation offering services and the provider of services
    (id: '8018'; min: 18; max: 18), // Global Service Relation Number to identify the relationship between an organisation offering services and the recipient of services
    (id: '8019'; min: 1; max: 10), // Service Relation Instance Number (SRIN)
    (id: '8020'; min: 1; max: 25), // Payment slip reference number
    (id: '8110'; min: 1; max: 70), // Coupon code identification for use in North America
    (id: '8111'; min: 4; max: 4), // Loyalty points of a coupon
    (id: '8112'; min: 1; max: 70), // Paperless coupon code identification for use in North America (AI 8112)
    (id: '8200'; min: 1; max: 70), // Extended Packaging URL
    (id: '90'; min: 1; max: 30), // Information mutually agreed between trading partners
    (id: '9099'; min: 8; max: 8), // Information mutually agreed between trading partners
    (id: '91'; min: 1; max: 90), // Company internal information
      (id: '92'; min: 1; max: 90), // Company internal information
    (id: '93'; min: 1; max: 90), // Company internal information
    (id: '94'; min: 1; max: 90), // Company internal information
    (id: '95'; min: 1; max: 90), // Company internal information
    (id: '96'; min: 1; max: 90), // Company internal information
    (id: '97'; min: 1; max: 90), // Company internal information
    (id: '98'; min: 1; max: 90), // Company internal information
    (id: '99'; min: 1; max: 90) // Company internal information
  );

function GetAI(const id: AnsiString; var Item: TAIREc): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Length(AIItems)-1 do
  begin
    Item := AIItems[i];
    if Item.id = id then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function GS1EncodeBraces(const Barcode: AnsiString): AnsiString;
var
  i: Integer;
  Item: TAIRec;
  Token: TGS1Token;
  Tokens: TGS1Tokens;
begin
  Result := '';
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeBraces(Barcode);
    for i := 0 to Tokens.Count-1 do
    begin
      Token := Tokens[i];
      if GetAI(Token.id, Item) then
      begin
        if i = Tokens.Count-1 then
        begin
          Result := Result + Token.id + Token.Data
        end else
        begin
          if Item.min = Item.max then
            Result := Result + Token.id + Token.Data
          else
            Result := Result + Token.id + Token.Data + GS;
        end;
      end;
    end;
  finally
    Tokens.Free;
  end;
end;

//(01)18901148006024(21)09ICXT3D9BZ8L(10)111(17)190117(240)3004(91)0001(92)2dKkY5iBAmuKEAU2eqIElw/0OYK0P2/+j2O2Y/K8mQDxI51I1L+X2BHCdZdShioTaKqaCvbhfnBD/ZmQJh8RQw==

function ValidGS1TagId(const TagId: AnsiString): Boolean;
begin
  Result := (TagId <> '10')and(TagId <> '17');
end;

function GS1FilterTokens(const Barcode: AnsiString): AnsiString;
var
  i: Integer;
  Token: TGS1Token;
  Tokens: TGS1Tokens;
begin
  Result := Barcode;
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeBraces(Barcode);
    if Tokens.Count > 0 then
    begin
      Result := '';
    end;

    for i := 0 to Tokens.Count-1 do
    begin
      Token := Tokens[i];
      if ValidGS1TagId(Token.id) then
      begin
        Result := Result + Tnt_WideFormat('(%s)%s', [Token.id, Token.Data]);
      end;
    end;
  finally
    Tokens.Free;
  end;
end;

(*
04606203084623
+A13gPh
-4Hi7uGl
*)

(*
1. Ќа пачку нанос€т об€зательные пол€ из 35 символов:

  GTIN товара (глобальный номер) из 14 цифр, содержащих информацию о товаре и
  историю его перемещений. Ќаноситс€ на нижнюю или боковую сторону пачки;
  индивидуальный код упаковки из 13 символов;
  проверочный код из 8 цифр.

2. Ќа блок нанос€т 29 об€зательных символов:

  SSCI (серийный код транспортной упаковки) Ц 18 цифр;
  код идентификации Ц 7 символов;
  проверочный код из 8 цифр.

*)

function GS1DecodeBraces(const Barcode: AnsiString): AnsiString;
var
  i: Integer;
  Token: TGS1Token;
  Tokens: TGS1Tokens;
begin
  Result := Barcode;
  if Barcode = '' then Exit;
  if Barcode[1] = '(' then Exit;

  Result := '';
  Tokens := TGS1Tokens.Create(TGS1Token);
  try
    Tokens.DecodeAI(Barcode);
    for i := 0 to Tokens.Count-1 do
    begin
      Token := Tokens[i];
      Result := Result + Tnt_WideFormat('(%s)%s', [Token.ID, Token.Data]);
    end;
  finally
    Tokens.Free;
  end;
end;

{ TGS1Tokens }

type
  TDecodeState = (dsCode, dsData);

procedure TGS1Tokens.DecodeBraces(const Data: AnsiString);
var
  i: Integer;
  Token: TGS1Token;
  State: TDecodeState;
  TokenID: AnsiString;
  TokenData: AnsiString;
begin
  Clear;
  State := dsCode;
  TokenData := '';
  TokenID := '';
  for i := 1 to Length(Data) do
  begin
    case State of
      dsCode:
      begin
        case Data[i] of
        '(':
        begin
          TokenID := '';
          TokenData := '';
          State := dsCode;
        end;
        ')': State := dsData;
        else
          TokenID := TokenID + Data[i];
        end;
      end;

      dsData:
      if (Data[i] = '(')or(i = Length(Data)) then
      begin
        if i = Length(Data) then
          TokenData := TokenData + Data[i];

        State := dsCode;
        Token := TGS1Token.Create(Self);
        Token.ID := TokenID;
        Token.Data := TokenData;
        TokenID := '';
        TokenData := '';
      end else
      begin
        TokenData := TokenData + Data[i];
      end;
    end;
  end;
end;

procedure TGS1Tokens.DecodeAI(Barcode: AnsiString);
var
  Item: TAIREc;
  i, j: Integer;
  Token: TGS1Token;
  TokenID: AnsiString;
  TokenData: AnsiString;
begin
  Clear;
  Barcode := StringReplace(Barcode, '[GS]', GS, [rfReplaceAll, rfIgnoreCase]);

  i := 1;
  TokenID := '';
  while i <= Length(Barcode) do
  begin
    if Barcode[i] = GS then
    begin
      TokenID := '';
    end else
    begin
      TokenID := TokenID + Barcode[i];
      if GetAI(TokenID, Item) then
      begin
        if Item.min = Item.max then
        begin
          TokenData := Copy(Barcode, i+1, Item.Max);
          Inc(i, Item.max);
        end else
        begin
          TokenData := Copy(Barcode, i+1, Item.Max);
          j := Item.Min;
          while j <= Item.Max+1 do
          begin
            if Barcode[i+j] = GS then
            begin
              TokenData := Copy(Barcode, i+1, j-1);
              Break;
            end;
            Inc(j);
          end;
          Inc(i, j);
        end;
        Token := TGS1Token.Create(Self);
        Token.ID := TokenID;
        Token.Data := TokenData;
        TokenID := '';
      end;
    end;
    Inc(i);
  end;
end;

function TGS1Tokens.GetItem(Index: Integer): TGS1Token;
begin
  Result := inherited Items[Index] as TGS1Token;
end;

function TGS1Tokens.ItemByID(const ID: AnsiString): TGS1Token;
var
  i: Integer;
begin
  for i := 0 to Count-1 do
  begin
    Result := Items[i] as TGS1Token;
    if Result.ID = ID then Exit;
  end;
  Result := nil;
end;


end.
