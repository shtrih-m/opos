unit Retalix;

interface

uses
  // VCL
  Windows, Classes, SysUtils, ActiveX, ComObj, ADOInt, ADOConst,
  // Tnt
  TntSysUtils,
  // This
  StringUtils, RegExpr, LogFile, MalinaParams, PrinterParameters,
  DriverContext, SmresourceStrings;

type
  { TRetalix }

  TRetalix = class
  private
    function GetLogger: ILogFile;
    function GetMalinaParams: TMalinaParams;
  private
    FDBPath: string;
    FIsOpened: Boolean;
    FContext: TDriverContext;
    FConnection: ADOInt._Connection;
    
    property Logger: ILogFile read GetLogger;
  public
    constructor Create(const DBPath: string; AContext: TDriverContext);
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    function IsOpened: Boolean;
    function ReadTaxGroup(ItemName: WideString): Integer;
    function ReadCashierName(var CashierName: string): Boolean;
    class function ParseItemName(const ItemName: string): string;
    class function ReplaceOperator(const Line, Cashier: string): string;
    function ParseOperator(const Line: string; var Cashier: string): Boolean;
    class function ParseCashierName(const Line: string; var Cashier: string): Boolean;
    property MalinaParams: TMalinaParams read GetMalinaParams;
  end;

function RetalixReadCashierName(const DBPath: string;
  var CashierName: string; Context: TDriverContext): Boolean;

function RetalixReadTaxGroup(const DBPath: string;
  const ItemName: string; Context: TDriverContext): Integer;

implementation

function RetalixReadCashierName(const DBPath: string;
  var CashierName: string; Context: TDriverContext): Boolean;
var
  RetalixDB: TRetalix;
begin
  RetalixDB := TRetalix.Create(DBPath, Context);
  try
    RetalixDB.Open;
    Result := RetalixDB.ReadCashierName(CashierName);
  finally
    RetalixDB.Free;
  end;
end;

function RetalixReadTaxGroup(const DBPath: string;
  const ItemName: string; Context: TDriverContext): Integer;
var
  RetalixDB: TRetalix;
begin
  RetalixDB := TRetalix.Create(DBPath, Context);
  try
    RetalixDB.Open;
    Result := RetalixDB.ReadTaxGroup(ItemName);
  finally
    RetalixDB.Free;
  end;
end;

function CreateADOObject(const ClassID: TGUID): IUnknown;
var
  Status: HResult;
  FPUControlWord: Word;
begin
  asm
    FNSTCW  FPUControlWord
  end;
  Status := CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER, IUnknown, Result);
  asm
    FNCLEX
    FLDCW FPUControlWord
  end;
  if (Status = REGDB_E_CLASSNOTREG) then
    raise Exception.CreateRes(@SADOCreateError) else
    OleCheck(Status);
end;


{ TRetalix }

constructor TRetalix.Create(const DBPath: string; AContext: TDriverContext);
begin
  inherited Create;
  FDBPath := DBPath;
  FContext := AContext;
end;

destructor TRetalix.Destroy;
begin
  Close;
  inherited Destroy;
end;

function TRetalix.GetMalinaParams: TMalinaParams;
begin
  Result := FContext.MalinaParams;
end;

function TRetalix.GetLogger: ILogFile;
begin
  Result := FContext.Logger;
end;

function TRetalix.IsOpened: Boolean;
begin
  Result := FIsOpened;
end;

procedure TRetalix.Open;
var
  ConnectionString: WideString;
begin
  if IsOpened then Exit;

  try
    FConnection := CreateADOObject(CLASS_Connection) as _Connection;
    ConnectionString :=
      'Provider=Microsoft.Jet.OLEDB.4.0;Extended Properties=Paradox 5.x;Data Source=%s';
    ConnectionString := Format(ConnectionString, [FDBPath]);
    FConnection.Open(ConnectionString, '', '', Integer(adConnectUnspecified));
    FIsOpened := True;
  except
    on E: Exception do
    begin
      Logger.Error('TRetalix.Open: ' + E.Message);
    end;
  end;
end;

procedure TRetalix.Close;
begin
  try
    if FIsOpened then
    begin
      if FConnection <> nil then
      begin
        FConnection.Close;
      end;
    end;
    FConnection := nil;
    FIsOpened := False;
  except
    on E: Exception do
    begin
      Logger.Error('TRetalix.Close: ' + E.Message);
    end;
  end;
end;

function TRetalix.ReadCashierName(var CashierName: string): Boolean;
var
  S: WideString;
  SQL: WideString;
  Records: _Recordset;
  RecordsAffected: OleVariant;
begin
  Result := False;
  if not IsOpened then Exit;

  SQL := 'select accessname + '' '' + fullname from ' +
    'employee e inner join access a on e.posaccess=a.accessid ' +
    'where fullname like ''%%%s%%'' and empno=(' +
    'select max(empno) from employee where fullname ' +
    'like ''%%%s%%'' and status=''W'')';

  if GetMalinaParams.RetalixSearchCI then
  begin
    SQL := 'select accessname + '' '' + fullname from ' +
      'employee e inner join access a on e.posaccess=a.accessid ' +
      'where lcase(fullname) like lcase(''%%%s%%'') and empno=(' +
      'select max(empno) from employee where fullname ' +
      'like lcase(''%%%s%%'') and status=''W'')';
  end;

  SQL := Tnt_WideFormat(SQL, [CashierName, CashierName]);
  SQL := AnsiStringToWideString(1252, SQL);
  Records := FConnection.Execute(SQL, RecordsAffected, 0);

  if Records.RecordCount = 0 then Exit;
  if Records.EOF then Exit;

  Records.MoveFirst;
  S := Records.Fields[0].Value;
  CashierName := WideStringToAnsiString(1252, S);
  Result := True;
end;

// ТРК 4:АИ-95-К5               Трз1449

class function TRetalix.ParseItemName(const ItemName: string): string;
begin
  Result := ItemName;
  if ExecRegExpr('ТРК.+:', ItemName) then
  begin
    Result := Trim(ReplaceRegExpr('ТРК.+:', Result, ''));
    Result := Trim(ReplaceRegExpr(' .+', Result, ''));
  end;
end;


function TRetalix.ReadTaxGroup(ItemName: WideString): Integer;

  procedure CheckItemName(const ItemName: WideString);
  begin
    if ItemName = '' then
      raise Exception.Create(MsgItemNameEmpty);
  end;

var
  SQL: WideString;
  Records: _Recordset;
  RecordsAffected: OleVariant;
begin
  Result := -1;
  try
    if not IsOpened then Exit;

    CheckItemName(ItemName);
    ItemName := ParseItemName(ItemName);
    ItemName := Tnt_WideStringReplace(ItemName, '''', '%', [rfReplaceAll, rfIgnoreCase]);
    CheckItemName(ItemName);


    SQL := 'select taxgrp1 from item where ((itemname like ''%s%%'')or(fulldescription like ''%s%%''))';
    if GetMalinaParams.RetalixSearchCI then
      SQL := 'select taxgrp1 from item where ((lcase(itemname) like lcase(''%s%%'')) or (lcase(fulldescription) like lcase(''%s%%'')))';

    SQL := Tnt_WideFormat(SQL, [ItemName, ItemName]);
    SQL := AnsiStringToWideString(1252, SQL);
    Records := FConnection.Execute(SQL, RecordsAffected, 0);

    if Records.RecordCount = 0 then Exit;
    if Records.EOF then Exit;

    Records.MoveFirst;
    Result := Records.Fields[0].Value;
  except
    on E: Exception do
    begin
      Logger.Error('TRetalix.ReadTaxGroup: ' + E.Message);
    end;
  end;
end;

//  Оператор: Щукина Оль  ID: 154826».

function TRetalix.ParseOperator(const Line: string;
  var Cashier: string): Boolean;
begin
  Result := False;
  try
    Result := ParseCashierName(Line, Cashier);
    if Result then
      Result := ReadCashierName(Cashier)
  except
    on E: Exception do
    begin
      Logger.Error('TRetalix.ParseOperator: ' + E.Message);
    end;
  end;
end;

//Cashier
class function TRetalix.ParseCashierName(const Line: string;
  var Cashier: string): Boolean;
const
  CashierPrefix = 'оператор:';
var
  P: Integer;
  Line1: string;
begin
  Line1 := Copy(Trim(Line), 1, Length(CashierPrefix));
  Result := AnsiCompareText(Line1, CashierPrefix) = 0;
  if not Result then Exit;

  Cashier := Trim(Copy(Line, Length(CashierPrefix) + 1, Length(Line)));
  Result := Length(Cashier) > 0;
  if not Result then Exit;

  P := Pos(' ID', Cashier);
  if P <> 0 then
  begin
    Cashier := Trim(Copy(Cashier, 1, P-1));
  end;
end;

class function TRetalix.ReplaceOperator(const Line, Cashier: string): string;
var
  P: Integer;
begin
  P := Pos('ID:', UpperCase(Line));
  if P = 0 then
  begin
    Result := Cashier;
  end else
  begin
    Result := Cashier + ' ' + Copy(Line, P, Length(Line));
  end;
end;

(*

Поправьте, пожалуйста, немного запрос для вывода данных об операторе
(СУ Retalix StorePoint) при сборке более новых версий драйвера ККТ.

Запрос, который используется в настоящий момент.

SELECT AccessName + ' ' + FirstName
  FROM
    Employee E INNER JOIN Access A
      ON E.POSAccess=A.ACCESSID
  WHERE
    FullName LIKE ? + '%' and
    Status='W' and
    EMPNO=(
      SELECT MAX(EMPNO)
        FROM Employee
        WHERE FullName LIKE ? + '%'
    )


Обновлённый запрос.

SELECT AccessName + ' ' + FullName
  FROM
    Employee E INNER JOIN Access A
      ON E.POSAccess=A.ACCESSID
  WHERE
    FullName LIKE :? + '%' and
    EMPNO=(
      SELECT MAX(EMPNO)
        FROM Employee
        WHERE FullName LIKE :? + '%' and Status='W'
    )

*)

end.
