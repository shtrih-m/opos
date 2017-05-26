unit CsvPrinterTableFormat;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // Tnt
  TntClasses, TntSysUtils, TntSystem,
  // This
  PrinterTable, PrinterTypes, PrinterTableFormat, VersionInfo;

type
  { TCsvPrinterTableFormat }

  TCsvPrinterTableFormat = class(TPrinterTableFormat)
  private
    function AddComments(Lines: TTntStringList): WideString;
    procedure CreateField(Tables: TPrinterTables; const Text: WideString);
  public
    function Extension: WideString; override;
    function FilterString: WideString; override;
    procedure SaveToFile(const FileName: WideString; Tables: TPrinterTables); override;
    procedure LoadFromFile(const FileName: WideString; Tables: TPrinterTables); override;
  end;

implementation

resourcestring
  STable = 'Таблица';
  CsvFilterString = 'Файлы таблиц (*.csv)|*.csv|';
  STableFormat = 'Номер таблицы,Ряд,Поле,Размер поля,Тип поля,Мин. значение, Макс.значение, Название,Значение';

{ TCsvPrinterTableFormat }

function TCsvPrinterTableFormat.FilterString: WideString;
begin
  Result := CsvFilterString;
end;

function IsComma(C: WideChar): Boolean;
begin
  Result := (C  = '"') or (C = '''');
end;

function GetCsvString(const Text: WideString; Number: Integer): WideString;
var
  i: Integer;
  Count: Integer;
  InText: Boolean;
  EndPos: Integer;
  StartPos: Integer;
begin
  Result := '';

  Count := 1;
  StartPos := 1;
  InText := False;
  EndPos := Length(Text);
  for i := 1 to Length(Text) do
  begin
    if Text[i] = ',' then
    begin
      if not InText then
      begin
        Inc(Count);
        if Count = Number then StartPos := i+1;
        if Count = (Number + 1) then EndPos := i-1;
      end;
    end;

    if IsComma(Text[i]) then
    begin
      InText := not InText;
    end;
  end;
  Result := Copy(Text, StartPos, EndPos - StartPos + 1);
  if Result <> '' then
  begin
    if IsComma(Result[1]) and IsComma(Result[Length(Result)]) then
      Result := Copy(Result, 2, Length(Result)-2);
  end;
end;

procedure TCsvPrinterTableFormat.CreateField(Tables: TPrinterTables;
  const Text: WideString);
var
  Field: TPrinterField;
  Table: TPrinterTable;
  TableRec: TPrinterTableRec;
  FieldRec: TPrinterFieldRec;
  FieldValue: WideString;
begin
  FieldRec.Table := StrToInt(GetCsvString(Text, 1));
  FieldRec.Row := StrToInt(GetCsvString(Text, 2));
  FieldRec.Field := StrToInt(GetCsvString(Text, 3));
  FieldRec.Size := StrToInt(GetCsvString(Text, 4));
  FieldRec.FieldType := StrToInt(GetCsvString(Text, 5));
  FieldRec.MinValue := StrToInt(GetCsvString(Text, 6));
  FieldRec.MaxValue := StrToInt(GetCsvString(Text, 7));
  FieldRec.Name := GetCsvString(Text, 8);
  FieldValue := GetCsvString(Text, 9);
  // поиск таблицы
  Table := Tables.ItemByNumber(FieldRec.Table);
  if Table = nil then
  begin
    TableRec.Number := FieldRec.Table;
    TableRec.Name := '';
    TableRec.RowCount := 0;
    TableRec.FieldCount := 0;
    Table := Tables.Add(TableRec);
  end;

  Field := TPrinterField.Create(Table.Fields, FieldRec);
  Field.Value := FieldValue;
end;

procedure TCsvPrinterTableFormat.LoadFromFile(const FileName: WideString;
  Tables: TPrinterTables);
var
  i: Integer;
  P: Integer;
  S: WideString;
  Line: WideString;
  Stream: TTntFileStream;
  Strings: TTntStringList;
begin
  if not FileExists(FileName) then Exit;
  // Удаляем поля
  for i := 0 to Tables.Count-1 do
  begin
    Tables[i].Fields.Clear;
  end;

  Tables.Header.Clear;
  Strings := TTntStringList.Create;
  Stream := TTntFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Stream.Position := 0;
    Strings.LastFileCharSet := csUtf8;
    Strings.LoadFromStream(Stream);
    for i := 0 to Strings.Count-1 do
    begin
      Line := Trim(UTF8ToWideString(Strings[i]));
      // skip comment lines
      if Pos('//', Line) <> 1 then
      begin
        CreateField(Tables, Line);
      end;
      if Pos('///', Line) = 1 then
      begin
        P := WideTextPos('Модель:', Line);
        if P <> 0 then
        begin
          S := Copy(Line, P + 8, Length(Line));
          P := WideTextPos(';', S);
          Tables.DeviceName := Trim(Copy(S, 1, P-1));
        end;
        Tables.Header.Add(Copy(Line, 5, Length(Line)))
      end;
    end;
  finally
    Stream.Free;
    Strings.Free;
  end;
end;

function TCsvPrinterTableFormat.AddComments(Lines: TTntStringList): WideString;
var
  i: Integer;
  Strings: TTntStringList;
begin
  Result := '';
  Strings := TTntStringList.Create;
  try
    for i := 0 to Lines.Count-1 do
    begin
      Strings.Add('/// ' + Lines[i]);
    end;
    Result := Strings.Text;
  finally
    Strings.Free;
  end;
end;

procedure TCsvPrinterTableFormat.SaveToFile(const FileName: WideString;
  Tables: TPrinterTables);
var
  i, j: Integer;
  Field: TPrinterField;
  Table: TPrinterTable;
  Strings: TTntStringList;
begin
  if FileExists(FileName) then DeleteFile(FileName);

  Strings := TTntStringList.Create;
  try
    // Header
    Strings.Text := AddComments(Tables.Header);
    // Даные таблиц
    for i := 0 to Tables.Count-1 do
    begin
      Table := Tables[i];
      Strings.Add(Tnt_WideFormat('// %s %d, %s', [STable, Table.Number, Table.Name]));
      Strings.Add('// ' + STableFormat);

      for j := 0 to Table.Fields.Count-1 do
      begin
        Field := Table.Fields[j];
        Strings.Add(Tnt_WideFormat('%d,%d,%d,%d,%d,%d,%d,''%s'',''%s''', [

          Field.Table,
          Field.Row,
          Field.Field,
          Field.Size,
          Field.FieldType,
          Field.MinValue,
          Field.MaxValue,
          Trim(Field.Name),
          Field.Value

        ]));
      end;
    end;
    Strings.SaveToFile(FileName);
  finally
    Strings.Free;
  end;
end;

function TCsvPrinterTableFormat.Extension: WideString;
begin
  Result := '.csv';
end;

end.
