unit MalinaCard;

interface

uses
  // VCL
  Windows, SysUtils, Registry,
  // 3'd
  TntRegistry,
  // This
  LogFile, WException;

type
  { TMalinaCard }

  TMalinaCard = class
  private
    FLogger: ILogFile;
    FAmount: Integer;
    FDateTime: WideString;
    FCardNumber: WideString;
    FOperationType: Integer;
  public
    constructor Create(ALogger: ILogFile);

    procedure Clear;
    procedure Load(const Key: WideString);
    procedure Save(const Key: WideString);

    property Logger: ILogFile read FLogger;
    property Amount: Integer read FAmount write FAmount;
    property DateTime: WideString read FDateTime write FDateTime;
    property CardNumber: WideString read FCardNumber write FCardNumber;
    property OperationType: Integer read FOperationType write FOperationType;
  end;

implementation

const
  REGSTR_VAL_CARD           = 'Card';
  REGSTR_VAL_AMOUNT         = 'Amount';
  REGSTR_VAL_DATETIME       = 'DateTime';
  REGSTR_VAL_TYPE_OPERATION = 'TypeOperation';

{ TMalinaCard }

constructor TMalinaCard.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
end;

procedure TMalinaCard.Clear;
begin
  FAmount := 0;
  FDateTime := '';
  FCardNumber := '';
  FOperationType := 0;
end;

procedure TMalinaCard.Save(const Key: WideString);
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(Key, True) then
    begin
      Reg.WriteInteger(REGSTR_VAL_AMOUNT, Amount);
      Reg.WriteInteger(REGSTR_VAL_TYPE_OPERATION, operationType);
      Reg.WriteString(REGSTR_VAL_CARD, CardNumber);
      Reg.WriteString(REGSTR_VAL_DATETIME, DateTime);
    end;
  except
    on E: Exception do
      Logger.Error(GetExceptionMessage(E));
  end;
  Reg.Free;
end;

procedure TMalinaCard.Load(const Key: WideString);
var
  Reg: TTntRegistry;
begin
  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(Key, False) then
    begin
      if Reg.ValueExists(REGSTR_VAL_AMOUNT) then
        FAmount := Reg.ReadInteger(REGSTR_VAL_AMOUNT);

      if Reg.ValueExists(REGSTR_VAL_TYPE_OPERATION) then
        FOperationType := Reg.ReadInteger(REGSTR_VAL_TYPE_OPERATION);

      if Reg.ValueExists(REGSTR_VAL_CARD) then
        FCardNumber := Reg.ReadString(REGSTR_VAL_CARD);

      if Reg.ValueExists(REGSTR_VAL_DATETIME) then
        FDateTime := Reg.ReadString(REGSTR_VAL_DATETIME);
    end;
  except
    on E: Exception do
      Logger.Error(GetExceptionMessage(E));
  end;
  Reg.Free;
end;

end.
