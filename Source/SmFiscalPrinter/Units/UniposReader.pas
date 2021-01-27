unit UniposReader;

interface

uses
  // VCL
  Windows, SysUtils, Registry, ActiveX, ComObj,
  // 3'd
  TntRegistry,
  // This
  LogFile, PrinterTypes, WException;

type
  { TPrintReportRec }

  TPrintReportRec = record
    Successful: Boolean;
    PrintTime: TDateTime;
  end;

  { TTextReceiptRec }

  TTextReceiptRec = record
    NewChequeFlag: Boolean;
    NewChequeText: WideString;
    NewChequeText1: WideString;
  end;

  { TUniposTextReceipt }

  TUniposTextReceipt = class
  private
    FData: TTextReceiptRec;
  public
    constructor Create(const AData: TTextReceiptRec);
    property Data: TTextReceiptRec read FData;
  end;

  { TTextBlockRec }

  TTextBlockRec = record
    SecondsOfDay: Integer;
    Text: WideString;
  end;

  { TReceiptFlagsRec }

  TReceiptFlagsRec = record
    Enabled: Boolean;
    Seconds: Integer;
  end;

  { TUniposReader }

  TUniposReader = class
  private
    FLogger: ILogFile;
    property Logger: ILogFile read FLogger;
  public
    constructor Create(ALogger: ILogFile);

    function ReadHeaderBlock: TTextBlockRec;
    function ReadTrailerBlock: TTextBlockRec;
    function ReadPrintReport: TPrintReportRec;
    function ReadTextReceipt: TTextReceiptRec;
    function ReadReceiptFlags: TReceiptFlagsRec;
    function WriteTextReceipt(const Data: TTextReceiptRec): Boolean;

    procedure ClearPrintReport;
    procedure ClearReceiptFlags;
    procedure ReportSuccessfullPrint;
    procedure WriteHeaderBlock(const Data: TTextBlockRec);
    procedure WriteTrailerBlock(const Data: TTextBlockRec);
    procedure WritePrintReport(const Data: TPrintReportRec);
    procedure WriteReceiptFlags(const Data: TReceiptFlagsRec);
  end;

implementation

const
  BoolToStr: array [Boolean] of WideString = ('0', '1');

{ TUniposReader }

const
  REGSTR_KEY_UNIPOS_PRINT     = 'SOFTWARE\UniposPrint\';
  REGSTR_VAL_SUCCESS_FLAG     = 'ChequeSuccessfulPrint';
  REGSTR_VAL_SUCCESS_TIME     = 'ChequeSuccessfulTime';

  REGSTR_VAL_NEW_CHEQUE_FLAG  = 'NewChequeFlag';
  REGSTR_VAL_NEW_CHEQUE_TEXT  = 'NewChequeText';
  REGSTR_VAL_NEW_CHEQUE_TEXT1 = 'NewChequeText1';

  REGSTR_VAL_TIME_BLOCK1      = 'TimeBlock1';
  REGSTR_VAL_TIME_BLOCK2      = 'TimeBlock2';
  REGSTR_VAL_CHEQUE_BLOCK1    = 'ChequeBlock1';
  REGSTR_VAL_CHEQUE_BLOCK2    = 'ChequeBlock2';

  REGSTR_VAL_REC_ENABLED      = 'PrCheck';
  REGSTR_VAL_REC_SECONDS      = 'PrCheckTime';

(******************************************************************************

  Сразу после успешной печати фискальной части чека, драйвер фискального
  регистратора изменяет значения ключа реестра ChequeSuccessfulPrint
  (тип REG_SZ) на "1".

  Во второй ключ (ChequeSuccessfulTime) записывается системное время
  данной операции (формат - HH24:MI:SS, тип REG_SZ)
  При неуспешной печати  - никаких действий не требуется.

  Размещение в реестре
  HKEY_LOCAL_MACHINE\SOFTWARE\UniposPrint\
  Ключи ChequeSuccessfulPrint, ChequeSuccessfulTime

******************************************************************************)

constructor TUniposReader.Create(ALogger: ILogFile);
begin
  inherited Create;
  FLogger := ALogger;
end;

procedure TUniposReader.ClearPrintReport;
var
  Data: TPrintReportRec;
begin
  Logger.Debug('TUniposReader.ClearPrintReport');

  Data.PrintTime := 0;
  Data.Successful := False;
  WritePrintReport(Data);
end;

procedure TUniposReader.ReportSuccessfullPrint;
var
  Data: TPrintReportRec;
begin
  Logger.Debug('TUniposReader.ReportSuccessfullPrint');

  Data.Successful := True;
  Data.PrintTime := Now;
  WritePrintReport(Data);
end;

function TUniposReader.ReadPrintReport: TPrintReportRec;
var
  S: WideString;
  Reg: TTntRegistry;
begin
  Logger.Debug('TUniposReader.ReadPrintReport');

  Result.Successful := False;
  Result.PrintTime := 0;

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, False) then
    begin
      S := Reg.ReadString(REGSTR_VAL_SUCCESS_TIME);
      Result.PrintTime := Date + StrToTime(S);

      S := Reg.ReadString(REGSTR_VAL_SUCCESS_FLAG);
      Result.Successful := S <> '0';
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.ReportSuccessfullPrint: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

procedure TUniposReader.WritePrintReport(const Data: TPrintReportRec);
var
  S: WideString;
  Reg: TTntRegistry;
begin
  Logger.Debug('TUniposReader.WritePrintReport');

  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, True) then
    begin
      S := FormatDateTime('hh:nn:ss', Data.PrintTime);
      Reg.WriteString(REGSTR_VAL_SUCCESS_TIME, S);
      Reg.WriteString(REGSTR_VAL_SUCCESS_FLAG, BoolToStr[Data.Successful]);
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.ReportSuccessfullPrint: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

(******************************************************************************

  Размещение в реестре
  HKEY_LOCAL_MACHINE\SOFTWARE\UniposPrint\
  Ключ NewChequeFlag, тип REG_SZ, возможные значения ["0","1"] - признак печати,
  Ключ NewChequeText, тип REG_SZ - первая часть текста всего нового чека.
  люч NewChequeText1, тип REG_SZ - вторая часть текста всего нового чека.

******************************************************************************)

function TUniposReader.ReadTextReceipt: TTextReceiptRec;
var
  S: WideString;
  Reg: TTntRegistry;
begin
  Result.NewChequeFlag := False;
  Result.NewChequeText := '';
  Result.NewChequeText1 := '';

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, False) then
    begin
      S := Reg.ReadString(REGSTR_VAL_NEW_CHEQUE_FLAG);
      Result.NewChequeFlag := S = '1';
      Result.NewChequeText := Reg.ReadString(REGSTR_VAL_NEW_CHEQUE_TEXT);
      Result.NewChequeText1 := Reg.ReadString(REGSTR_VAL_NEW_CHEQUE_TEXT1);
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.ReadTextReceipt: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

function TUniposReader.WriteTextReceipt(const Data: TTextReceiptRec): Boolean;
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TUniposReader.WriteTextReceipt');

  Result := False;
  Reg := TTntRegistry.Create;
  try
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, True) then
      begin
        Reg.WriteString(REGSTR_VAL_NEW_CHEQUE_TEXT, Data.NewChequeText);
        Reg.WriteString(REGSTR_VAL_NEW_CHEQUE_TEXT1, Data.NewChequeText1);
        Reg.WriteString(REGSTR_VAL_NEW_CHEQUE_FLAG, BoolToStr[Data.NewChequeFlag]);
        Result := True;
      end;
    except
      on E: Exception do
      begin
        Logger.Error('TUniposReader.WriteTextReceipt: ' + GetExceptionMessage(E));
        Result := False;
      end;
    end;
  finally
    Reg.Free;
  end;
end;

(******************************************************************************

  Соответствие ключей реестра:
  HKEY_LOCAL_MACHINE\SOFTWARE\UniposPrint \
  Ключ ChequeBlock1, тип REG_SZ  - текст информационного блока №1
  (2048 символов, ASCII, разделитель строки - символ №13№10).
  Ключ ChequeBlock2, тип REG_SZ  - текст информационного блока №2
  (2048 символов, ASCII разделитель строки - символ №13,№10).
  Ключи TimeBlock1 и TimeBlock2, тип REG_SZ - содержат информацию о
  актуальности информации (время, формат - количество секунд от начала суток).
  Блоку информации №1 соответствует значение ключа ChequeBlock1, TimeBlock1,
  блоку информации №2 - ChequeBlock2, TimeBlock2.

******************************************************************************)

function TUniposReader.ReadHeaderBlock: TTextBlockRec;
var
  Text: WideString;
  Reg: TTntRegistry;
  Seconds: WideString;
begin
  Logger.Debug('TUniposReader.ReadHeaderBlock');

  Result.Text := '';
  Result.SecondsOfDay := 0;

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, False) then
    begin
      Text := Reg.ReadString(REGSTR_VAL_CHEQUE_BLOCK1);
      Seconds := Reg.ReadString(REGSTR_VAL_TIME_BLOCK1);

      Logger.Debug('TimeBlock1', Seconds);
      Logger.Debug('ChequeBlock1', Text);

      Result.Text := Text;
      Result.SecondsOfDay := StrToInt(Seconds);
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.ReadHeaderBlock: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

function TUniposReader.ReadTrailerBlock: TTextBlockRec;
var
  Text: WideString;
  Seconds: WideString;
  Reg: TTntRegistry;
begin
  Logger.Debug('TUniposReader.ReadTrailerBlock');

  Result.Text := '';
  Result.SecondsOfDay := 0;

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, False) then
    begin
      Text := Reg.ReadString(REGSTR_VAL_CHEQUE_BLOCK2);
      Seconds := Reg.ReadString(REGSTR_VAL_TIME_BLOCK2);
      Logger.Debug('TimeBlock2', Seconds);
      Logger.Debug('ChequeBlock2', Text);

      Result.Text := Text;
      Result.SecondsOfDay := StrToInt(Seconds);
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.ReadTrailerBlock: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

procedure TUniposReader.WriteHeaderBlock(const Data: TTextBlockRec);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TUniposReader.WriteHeaderBlock');

  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, True) then
    begin
      Reg.WriteString(REGSTR_VAL_TIME_BLOCK1, IntToStr(Data.SecondsOfDay));
      Reg.WriteString(REGSTR_VAL_CHEQUE_BLOCK1, Data.Text);
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.WriteTextBlock: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

procedure TUniposReader.WriteTrailerBlock(const Data: TTextBlockRec);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TUniposReader.WriteTrailerBlock');

  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, True) then
    begin
      Reg.WriteString(REGSTR_VAL_TIME_BLOCK2, IntToStr(Data.SecondsOfDay));
      Reg.WriteString(REGSTR_VAL_CHEQUE_BLOCK2, Data.Text);
    end;
  except
    on E: Exception do
      Logger.Error('TUniposReader.WriteTextBlock: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

function TUniposReader.ReadReceiptFlags: TReceiptFlagsRec;
var
  Enabled: WideString;
  Seconds: WideString;
  Reg: TTntRegistry;
begin
  Logger.Debug('TAntiFroudFilter.ReadReceiptFlags');

  Result.Enabled := False;
  Result.Seconds := 0;

  Reg := TTntRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, False) then
    begin
      Enabled := Reg.ReadString(REGSTR_VAL_REC_ENABLED);
      Seconds := Reg.ReadString(REGSTR_VAL_REC_SECONDS);
      Logger.Debug('Enabled', Enabled);
      Logger.Debug('Seconds', Seconds);

      Result.Enabled := Enabled <> '0';
      Result.Seconds := StrToInt(Seconds);
    end;
  except
    on E: Exception do
      Logger.Error('TAntiFroudFilter.ReadReceiptFlags: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;


procedure TUniposReader.WriteReceiptFlags(const Data: TReceiptFlagsRec);
var
  Reg: TTntRegistry;
begin
  Logger.Debug('TAntiFroudFilter.WriteReceiptFlags');

  Reg := TTntRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGSTR_KEY_UNIPOS_PRINT, True) then
    begin
      Reg.WriteString(REGSTR_VAL_REC_ENABLED, BoolToStr[Data.Enabled]);
      Reg.WriteString(REGSTR_VAL_REC_SECONDS, IntToStr(Data.Seconds));
    end;
  except
    on E: Exception do
      Logger.Error('TAntiFroudFilter.ClearReceiptFlags: ' + GetExceptionMessage(E));
  end;
  Reg.Free;
end;

procedure TUniposReader.ClearReceiptFlags;
var
  Data: TReceiptFlagsRec;
begin
  Logger.Debug('TUniposReader.ClearReceiptFlags');

  Data.Enabled := False;
  Data.Seconds := 0;
  WriteReceiptFlags(Data);
end;

{ TUniposTextReceipt }

constructor TUniposTextReceipt.Create(const AData: TTextReceiptRec);
begin
  inherited Create;
  FData := AData;
end;

end.
