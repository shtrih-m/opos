unit PrinterCommand;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // 3'd
  TntSysUtils,
  // This
  PrinterTypes, BinStream, OposException, Opos, StringUtils, gnugettext;

type
  { TPrinterCommand }

  TPrinterCommand = class
  private
    FResultCode: Integer;
  public
    function GetCode: Byte; virtual; abstract;
    procedure Encode(Data: TBinStream); virtual; abstract;
    procedure Decode(Data: TBinStream); virtual; abstract;

    property ResultCode: Integer read FResultCode write FResultCode;
  end;

  { TGetDumpBlockCommand }

  TGetDumpBlockCommand = class(TPrinterCommand)
  public
    Password: DWORD;            // in, Operator password (4 bytes)
    DumpBlock: TDumpBlock;      // out

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TStopDumpCommand }

  TStopDumpCommand = class(TPrinterCommand)
  public
    Password: DWORD;            // in, Operator password (4 bytes)

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TLongFiscalizationCommand }

  TLongFiscalizationCommand = class(TPrinterCommand)
  public
    TaxPassword: DWORD;         // in, Tax Officer password (4 bytes)
    NewPassword: DWORD;         // in, New Tax Officer password (4 bytes)
    PrinterID: Int64;           // in, Printer ID, (7 bytes) 00000000000000…99999999999999
    FiscalID: Int64;            // in, FiscalID, (6 bytes) 000000000000…999999999999

    FiscResult: TLongFiscResult; // out

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TSetLongSerialCommand }

  TSetLongSerialCommand = class(TPrinterCommand)
  public
    Password: DWORD;    // in, (default password value '0')
    Serial: Int64;      // in, Long Serial Number (7 bytes) 00000000000000…99999999999999

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TLongStatusCommand }

  TLongStatusCommand = class(TPrinterCommand)
  public
    Password: DWORD;            // in, Operator password (4 bytes)
    Status: TLongPrinterStatus;     // out

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TCashInCommand }

  TCashInCommand = class(TPrinterCommand)
  public
    Password: DWORD;            // in, Operator password (4 bytes)
    Amount: Int64;              // in, Sum (5 bytes)
    OperatorNumber: Byte;       // out, Operator number (1 bytes) 1…30
    DocumentNumber: WORD;       // out, Transparent document number (2 bytes)

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TCashOutCommand }

  TCashOutCommand = class(TPrinterCommand)
  public
    Password: DWORD;            // in, Operator password (4 bytes)
    Amount: Int64;              // in, Sum (5 bytes)
    OperatorNumber: Byte;       // out, Operator number (1 bytes) 1…30
    DocumentNumber: WORD;       // out, Transparent document number (2 bytes)

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TWriteLicenseCommand }

  TWriteLicenseCommand = class(TPrinterCommand)
  public
    SysPassword: DWORD; // in, System administrator password (4 bytes)
    License: Int64;     // in, License (5 bytes) 0000000000…9999999999

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TReadLicenseCommand }

  TReadLicenseCommand = class(TPrinterCommand)
  public
    SysPassword: DWORD; // in, System administrator password (4 bytes)
    License: Int64;     // out, License (5 bytes) 0000000000…9999999999

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TWriteTableCommand }

  TWriteTableCommand = class(TPrinterCommand)
  public
    SysPassword: DWORD; // in, System administrator password (4 bytes)
    Table: Byte;        // in, Table (1 bytes)
    Row: WORD;          // in, Row (2 bytes)
    Field: Byte;        // in, Field (1 bytes)
    FieldValue: WideString; // in, Value (X bytes) up to 40 bytes

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

  { TReadTableCommand }

  TReadTableCommand = class(TPrinterCommand)
  public
    SysPassword: DWORD; // in, System administrator password (4 bytes)
    Table: Byte;        // in, Table (1 bytes)
    Row: WORD;          // in, Row (2 bytes)
    Field: Byte;        // in, Field (1 bytes)
    FieldValue: WideString; // out, Value (X bytes) up to 40 bytes

    function GetCode: Byte; override;
    procedure Encode(Data: TBinStream); override;
    procedure Decode(Data: TBinStream); override;
  end;

implementation

procedure CheckParam(Value, Min, Max: Int64; const ParamName: WideString);
begin
  if (Value < Min)or(Value > Max) then
    RaiseOPOSException(OPOS_E_ILLEGAL,
      Tnt_WideFormat('%s, %s', [_('Invalid parameter value'), ParamName]));
end;

(*******************************************************************************

  Get Data Block From Dump
  Command:	02H. Length: 5 bytes.
  ·	Service Support Center specialist password, or System Administrator
        password in case Service Support Center specialist password is
        not defined (4 bytes)

  Answer:		02H. Length: 37 bytes.
  ·	Result Code (1 byte)
  ·	Fiscal Printer unit code (1 byte)
  §	01 - Fiscal Memory 1
  §	02 - Fiscal Memory 1
  §	03 - Clock
  §	04 - Nonvolatile memory
  §	05 - Fiscal Memory processor
  §	06 - Fiscal Printer ROM
  §	07 - Fiscal Printer RAM
  ·	Data block number (2 bytes)
  ·	Data block contents (32 bytes)

*******************************************************************************)

{ TGetDumpBlockCommand }

function TGetDumpBlockCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_GETDUMPBLOCK;
end;

procedure TGetDumpBlockCommand.Encode(Data: TBinStream);
begin
  Data.WriteDWORD(Password);
end;

procedure TGetDumpBlockCommand.Decode(Data: TBinStream);
begin
  Data.Read(DumpBlock, Sizeof(DumpBlock));
end;

(*******************************************************************************

  Get FP Status
  Command:	11H. Length: 5 bytes.
  ·	Operator password (4 bytes)
  Answer:		11H. Length: 48 bytes.
  ·	Result Code (1 byte)
  ·	Operator index number (1 byte) 1…30
  ·	FP firmware version (2 bytes)
  ·	FP firmware build (2 bytes)
  ·	FP firmware date (3 bytes) DD-MM-YY
  ·	Number of FP in checkout line (1 byte)
  ·	Current receipt number (2 bytes)
  ·	FP flags (2 bytes)
  ·	FP mode (1 byte)
  ·	FP submode (1 byte)
  ·	FP port (1 byte)
  ·	FM firmware version (2 bytes)
  ·	FM firmware build (2 bytes)
  ·	FM firmware date (3 bytes) DD-MM-YY
  ·	Current date (3 bytes) DD-MM-YY
  ·	Current time (3 bytes) HH-MM-SS
  ·	FM flags (1 byte)
  ·	Serial number (4 bytes)
  ·	Number of last daily totals record in FM (2 bytes) 0000…2100
  ·	Quantity of free daily totals records left in FM (2 bytes)
  ·	Last fiscalization/refiscalization record number in FM (1 byte) 1…16
  ·	Quantity of free fiscalization/refiscalization records left in FM (1 byte) 0…15
  ·	Taxpayer ID (6 bytes)

*******************************************************************************)

{ TLongStatusCommand }

function TLongStatusCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_GET_STATUS;
end;

procedure TLongStatusCommand.Encode(Data: TBinStream);
begin
  Data.WriteInt(Password, 4);
end;

procedure TLongStatusCommand.Decode(Data: TBinStream);
var
  FiscalID: WideString;
begin
  Status.OperatorNumber := Data.ReadByte;
  Status.FirmwareVersionHi := Data.ReadChar;
  Status.FirmwareVersionLo := Data.ReadChar;
  Status.FirmwareBuild := Data.ReadWord;
  Data.Read(Status.FirmwareDate, Sizeof(Status.FirmwareDate));
  Status.LogicalNumber := Data.ReadByte;
  Status.DocumentNumber := Data.ReadWord;
  Status.Flags := Data.ReadWord;
  Status.Mode := Data.ReadByte;
  Status.AdvancedMode := Data.ReadByte;
  Status.PortNumber := Data.ReadByte;
  Status.FMVersionHi := Data.ReadChar;
  Status.FMVersionLo := Data.ReadChar;
  Status.FMBuild := Data.ReadWord;
  Data.Read(Status.FMFirmwareDate, sizeof(Status.FMFirmwareDate));
  Data.Read(Status.Date, sizeof(Status.Date));
  Data.Read(Status.Time, sizeof(Status.Time));
  Status.FMFlags := Data.ReadByte;

  Status.SerialNumber := Data.ReadString(4);
  if Status.SerialNumber = #$FF#$FF#$FF#$FF then
    Status.SerialNumber := '????????'
  else
    Status.SerialNumber := Tnt_WideFormat('%.8d', [BinToInt(Status.SerialNumber, 1, 4)]);

  Status.DayNumber := Data.ReadWord;
  Status.RemainingFiscalMemory := Data.ReadWord;
  Status.RegistrationNumber := Data.ReadByte;
  Status.FreeRegistration := Data.ReadByte;

  FiscalID := Data.ReadString(6);
  if FiscalID = #$FF#$FF#$FF#$FF#$FF#$FF then
    Status.FiscalID := '????????????'
  else
    Status.FiscalID := Tnt_WideFormat('%.12d', [BinToInt(FiscalID, 1, 6)]);
end;


(******************************************************************************

  Cash in
  
  Command:	50H. Length: 10 bytes.
  '	Operator password (4 bytes)
  '	Sum to be cashed in (5 bytes)
  Answer:		50H. Length: 5 bytes.
  '	Result Code (1 byte)
  '	Operator index number (1 byte) 1…30
  '	Current receipt number (2 bytes)

******************************************************************************)

{ TCashInCommand }

function TCashInCommand.GetCode: Byte;
begin
  Result := $50;
end;

procedure TCashInCommand.Encode(Data: TBinStream);
begin
  Data.Write(Password, 4);
  Data.Write(Amount, 5);
end;

procedure TCashInCommand.Decode(Data: TBinStream);
begin
  OperatorNumber := Data.ReadInt(1);
  DocumentNumber := Data.ReadInt(2);
end;

(******************************************************************************

  Cash-Out

  Command:	51H. Length: 10 bytes.
  '	Operator password (4 bytes)
  '	Sum to be cashed out (5 bytes)
  Answer:		51H. Length: 5 bytes.
  '	Result Code (1 byte)
  '	Operator index number (1 byte) 1…30
  '	Current receipt number (2 bytes)


******************************************************************************)

{ TCashOutCommand }

function TCashOutCommand.GetCode: Byte;
begin
  Result := $51;
end;

procedure TCashOutCommand.Decode(Data: TBinStream);
begin
  OperatorNumber := Data.ReadInt(1);
  DocumentNumber := Data.ReadInt(2);
end;

procedure TCashOutCommand.Encode(Data: TBinStream);
begin
  Data.Write(Password, 4);
  Data.Write(Amount, 5);
end;

(******************************************************************************

  Stop Getting Data From Dump
  Command:	03H. Length: 5 bytes.
  ·	System Administrator password (4 bytes) 30
  Answer:		03H. Length: 2 bytes.
  ·	Result Code (1 byte)

******************************************************************************)

{ TStopDumpCommand }

function TStopDumpCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_STOP_DUMP;
end;

procedure TStopDumpCommand.Encode(Data: TBinStream);
begin
  Data.WriteDWORD(Password);
end;

procedure TStopDumpCommand.Decode(Data: TBinStream);
begin

end;

(******************************************************************************

  Fiscalize/Refiscalize Printer With Long ECRRN

  Command:	0DH. Length: 22 bytes.
  ·	Old Tax Officer password (4 bytes)
  ·	New Tax Officer password (4 bytes)
  ·	Long ECRRN (7 bytes) 00000000000000…99999999999999
  ·	Taxpayer ID (6 bytes) 000000000000…999999999999

  Answer:		0DH. Length: 9 bytes.
  ·	Result Code (1 byte)
  ·	Fiscalization/Refiscalization number(1 byte) 1…16
  ·	Quantity of refiscalizations left in FM (1 byte) 0…15
  ·	Last daily totals record number in FM (2 bytes) 0000…2100
  ·	Fiscalization/Refiscalization date (3 bytes) DD-MM-YY

******************************************************************************)

{ TLongFiscalizationCommand }

function TLongFiscalizationCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_LONG_FISCALIZATION;
end;

procedure TLongFiscalizationCommand.Encode(Data: TBinStream);
begin
  Data.WriteInt(TaxPassword, 4);
  Data.WriteInt(NewPassword, 4);
  Data.WriteInt(PrinterID, 7);
  Data.WriteInt(FiscalID, 6);
end;

procedure TLongFiscalizationCommand.Decode(Data: TBinStream);
begin
  Data.Read(FiscResult, sizeof(FiscResult));
end;

(******************************************************************************

  Set Long Serial Number
  Command:	0EH. Length: 12 bytes.
  ·	Password (4 bytes) (default password value '0')
  ·	Long Serial Number (7 bytes) 00000000000000…99999999999999
  Answer:		0EH. Length: 2 bytes.
  ·	Result Code (1 byte)
  NOTE: The command is introduced into this protocol to conform to the
  Byelorussian legislation that requires Electronic Cash Registers
  to have serial number to be 14 digits long, where as in Russia
  it must be 10 digits long.

******************************************************************************)

{ TSetLongSerialCommand }

function TSetLongSerialCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_SET_LONG_SERIAL;
end;

procedure TSetLongSerialCommand.Encode(Data: TBinStream);
begin
  CheckParam(Serial, 0, 99999999999999, 'Serial');

  Data.WriteDWORD(Password);
  Data.WriteInt(Serial, 7);
end;

procedure TSetLongSerialCommand.Decode(Data: TBinStream);
begin

end;

(******************************************************************************

  Set License

  Command:	1CH. Length: 10 bytes.
  '	System Administrator password (4 bytes) 30
  '	License (5 bytes) 0000000000…9999999999
  Answer:		1CH. Length: 2 bytes.
  '	Result Code (1 byte)


******************************************************************************)

{ TWriteLicenseCommand }

function TWriteLicenseCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_WRITE_LICENSE;
end;

procedure TWriteLicenseCommand.Encode(Data: TBinStream);
begin
  Data.WriteDWORD(SysPassword);
  Data.WriteInt(License, 5);
end;

procedure TWriteLicenseCommand.Decode(Data: TBinStream);
begin
  { !!! }
end;

(******************************************************************************

  Get License

  Command:	1DH. Length: 5 bytes.
  '	System Administrator password (4 bytes) 30
  Answer:		1DH. Length: 7 bytes.
  '	Result Code (1 byte)
  '	License (5 bytes) 0000000000…9999999999

******************************************************************************)

{ TReadLicenseCommand }

function TReadLicenseCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_READ_LICENSE;
end;

procedure TReadLicenseCommand.Encode(Data: TBinStream);
begin
  Data.WriteDWORD(SysPassword);
end;

procedure TReadLicenseCommand.Decode(Data: TBinStream);
begin
  License := Data.ReadInt(5);
end;

(******************************************************************************

  Set Table Field Value

  Command:	1EH. Length: (9+X) bytes.
  '	System Administrator password (4 bytes) 30
  '	Table (1 byte)
  '	Row (2 bytes)
  '	Field (1 byte)
  '	Value (X bytes) up to 40 bytes
  Answer:		1EH. Length: 2 bytes.
  '	Result Code (1 byte)

******************************************************************************)

{ TWriteTableCommand }

function TWriteTableCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_WRITE_TABLE;
end;

procedure TWriteTableCommand.Encode(Data: TBinStream);
begin
  Data.WriteDWORD(SysPassword);
  Data.WriteByte(Table);
  Data.WriteInt(Row, 2);
  Data.WriteByte(Field);
  Data.WriteString(FieldValue);
end;

procedure TWriteTableCommand.Decode(Data: TBinStream);
begin

end;

(******************************************************************************

  Get Table Field Value

  Command:	1FH. Length: 9 bytes.
  '	System Administrator password (4 bytes) 30
  '	Table (1 byte)
  '	Row (2 bytes)
  '	Field (1 byte)
  Answer:		1FH. Length: (2+X) bytes.
  '	Result Code (1 byte)
  '	Value (X bytes) up to 40 bytes

******************************************************************************)

{ TReadTableCommand }

function TReadTableCommand.GetCode: Byte;
begin
  Result := SMFP_COMMAND_READ_TABLE;
end;

procedure TReadTableCommand.Encode(Data: TBinStream);
begin
  Data.WriteDWORD(SysPassword);
  Data.WriteByte(Table);
  Data.WriteInt(Row, 2);
  Data.WriteByte(Field);
end;

procedure TReadTableCommand.Decode(Data: TBinStream);
begin
  FieldValue := Data.ReadString;
end;


end.
