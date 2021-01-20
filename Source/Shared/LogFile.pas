unit LogFile;

interface

uses
  // VCL
  Windows, Classes, SysUtils, SyncObjs, SysConst, Variants, DateUtils, TypInfo,
  // Tnt
  TntClasses, TntStdCtrls, TntRegistry,
  // JCL
  JclDebug, JclHookExcept,
  // This
  WException, TntSysUtils;

const
  MAX_FILES_COUNT     = 10;
  MAX_FILE_SIZE_IN_KB = 4194240;

type
  TVariantArray = array of Variant;

  { ILogFile }

  ILogFile = interface
    procedure Lock;
    procedure Unlock;
    procedure Write(const Data: AnsiString);
    procedure Info(const Data: AnsiString); overload;
    procedure Debug(const Data: AnsiString); overload;
    procedure Trace(const Data: AnsiString); overload;
    procedure Error(const Data: AnsiString); overload;
    procedure Error(const Data: AnsiString; E: Exception); overload;
    procedure Info(const Data: AnsiString; Params: array of const); overload;
    procedure Trace(const Data: AnsiString; Params: array of const); overload;
    procedure Error(const Data: AnsiString; Params: array of const); overload;
    procedure Debug(const Data: AnsiString; Result: Variant); overload;
    procedure Debug(const Data: AnsiString; Params: array of const); overload;
    procedure Debug(const Data: AnsiString; Params: array of const; Result: Variant); overload;
    function GetFileDate(const FileName: AnsiString; var FileDate: TDateTime): Boolean;
    procedure WriteRxData(Data: AnsiString);
    procedure WriteTxData(Data: AnsiString);
    procedure LogParam(const ParamName: AnsiString; const ParamValue: Variant);
    procedure GetFileNames(const Mask: AnsiString; FileNames: TTntStrings);

    function GetFileSize: Int64;
    function GetEnabled: Boolean;
    function GetMaxCount: Integer;
    function GetFilePath: AnsiString;
    function GetFileName: AnsiString;
    function GetSeparator: AnsiString;
    function GetDeviceName: AnsiString;
    function GetTimeStampEnabled: Boolean;

    procedure CloseFile;
    procedure CheckFilesMaxCount;
    procedure SetEnabled(Value: Boolean);
    procedure SetMaxCount(const Value: Integer);
    procedure SetFileName(const Value: AnsiString);
    procedure SetFilePath(const Value: AnsiString);
    procedure SetSeparator(const Value: AnsiString);
    procedure SetDeviceName(const Value: AnsiString);
    procedure SetTimeStampEnabled(const Value: Boolean);

    property FileSize: Int64 read GetFileSize;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property FilePath: AnsiString read GetFilePath write SetFilePath;
    property FileName: AnsiString read GetFileName write SetFileName;
    property MaxCount: Integer read GetMaxCount write SetMaxCount;
    property Separator: AnsiString read GetSeparator write SetSeparator;
    property DeviceName: AnsiString read GetDeviceName write SetDeviceName;
    property TimeStampEnabled: Boolean read GetTimeStampEnabled write SetTimeStampEnabled;
  end;


  { TLogFile }

  TLogFile = class(TInterfacedObject, ILogFile)
  private
    FHandle: THandle;
    FFileName: AnsiString;
    FFilePath: AnsiString;
    FEnabled: Boolean;
    FSeparator: AnsiString;
    FMaxCount: Integer;
    FLock: TCriticalSection;
    FDeviceName: AnsiString;
    FTimeStampEnabled: Boolean;

    function GetOpened: Boolean;
    function GetEnabled: Boolean;
    function GetMaxCount: Integer;
    function GetFilePath: AnsiString;
    function GetFileName: AnsiString;
    function GetSeparator: AnsiString;
    function GetDeviceName: AnsiString;
    function GetTimeStampEnabled: Boolean;
    function GetDefaultFileName: AnsiString;

    procedure OpenFile;
    procedure CloseFile;
    procedure SetDefaults;
    procedure CheckFilesMaxCount;
    procedure SetEnabled(Value: Boolean);
    procedure Write(const Data: AnsiString);
    procedure AddLine(const Data: AnsiString);
    procedure SetMaxCount(const Value: Integer);
    procedure SetFilePath(const Value: AnsiString);
    procedure SetFileName(const Value: AnsiString);
    procedure SetSeparator(const Value: AnsiString);
    procedure SetDeviceName(const Value: AnsiString);
    procedure SetTimeStampEnabled(const Value: Boolean);
    procedure GetFileNames(const Mask: AnsiString; FileNames: TTntStrings);

    class function VariantToStr(V: Variant): AnsiString;
    class function ParamsToStr(const Params: array of const): AnsiString;
    class function VarArrayToStr(const AVarArray: TVariantArray): AnsiString;

    property Opened: Boolean read GetOpened;
    function GetFileSize: Int64;
    procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer;
      IsOS: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Lock;

    procedure Unlock;
    procedure Info(const Data: AnsiString); overload;
    procedure Debug(const Data: AnsiString); overload;
    procedure Trace(const Data: AnsiString); overload;
    procedure Error(const Data: AnsiString); overload;
    procedure Error(const Data: AnsiString; E: Exception); overload;
    procedure Info(const Data: AnsiString; Params: array of const); overload;
    procedure Trace(const Data: AnsiString; Params: array of const); overload;
    procedure Error(const Data: AnsiString; Params: array of const); overload;
    procedure Debug(const Data: AnsiString; Result: Variant); overload;
    procedure Debug(const Data: AnsiString; Params: array of const); overload;
    procedure Debug(const Data: AnsiString; Params: array of const; Result: Variant); overload;
    class function StrToText(const Text: AnsiString): AnsiString;
    function GetFileDate(const FileName: AnsiString;
      var FileDate: TDateTime): Boolean;
    procedure DebugData(const Prefix, Data: AnsiString);
    procedure LogParam(const ParamName: AnsiString; const ParamValue: Variant);
    procedure WriteRxData(Data: AnsiString);
    procedure WriteTxData(Data: AnsiString);

    property FileSize: Int64 read GetFileSize;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property FilePath: AnsiString read GetFilePath write SetFilePath;
    property FileName: AnsiString read GetFileName write SetFileName;
    property MaxCount: Integer read GetMaxCount write SetMaxCount;
    property Separator: AnsiString read GetSeparator write SetSeparator;
    property DeviceName: AnsiString read GetDeviceName write SetDeviceName;
    property TimeStampEnabled: Boolean read GetTimeStampEnabled write SetTimeStampEnabled;
  end;

implementation

const
  SDefaultSeparator   = '------------------------------------------------------------';
  SDefaultSeparator2  = '************************************************************';

function ConstArrayToVarArray(const AValues : array of const): TVariantArray;
var
  i : Integer;
begin
  SetLength(Result, Length(AValues));
  for i := Low(AValues) to High(AValues) do
  begin
    with AValues[i] do
    begin
      case VType of
        vtInteger: Result[i] := VInteger;
        vtInt64: Result[i] := VInt64^;
        vtBoolean: Result[i] := VBoolean;
        vtChar: Result[i] := VChar;
        vtExtended: Result[i] := VExtended^;
        vtString: Result[i] := VString^;
        vtPointer: Result[i] := Integer(VPointer);
        vtPChar: Result[i] := StrPas(VPChar);
        vtObject: Result[i]:= Integer(VObject);
        vtAnsiString: Result[i] := String(VAnsiString);
        vtCurrency: Result[i] := VCurrency^;
        vtVariant: Result[i] := VVariant^;
        vtInterface: Result[i]:= Integer(VPointer);
        vtWideString: Result[i]:= WideString(VWideString);
      else
        Result[i] := NULL;
      end;
    end;
  end;
end;

function StrToHex(const S: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(S) do
  begin
    if i <> 1 then Result := Result + ' ';
    Result := Result + IntToHex(Ord(S[i]), 2);
  end;
end;

const
  TagInfo         = '[ INFO] ';
  TagTrace        = '[TRACE] ';
  TagDebug        = '[DEBUG] ';
  TagError        = '[ERROR] ';

function GetTimeStamp: AnsiString;
var
  Year, Month, Day: Word;
  Hour, Min, Sec, MSec: Word;
begin
  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  Result := Tnt_WideFormat('%.2d.%.2d.%.4d %.2d:%.2d:%.2d.%.3d ',[
    Day, Month, Year, Hour, Min, Sec, MSec]);
end;

function GetLongFileName(const FileName: AnsiString): AnsiString;
var
  L: Integer;
  Handle: Integer;
  Buffer: array[0..MAX_PATH] of Char;
  GetLongPathName: function (ShortPathName: PChar; LongPathName: PChar;
    cchBuffer: Integer): Integer stdcall;
const
  kernel = 'kernel32.dll';
begin
  Result := FileName;
  Handle := GetModuleHandle(kernel);
  if Handle <> 0 then
  begin
    @GetLongPathName := GetProcAddress(Handle, 'GetLongPathNameA');
    if Assigned(GetLongPathName) then
    begin
      L := GetLongPathName(PChar(FileName), Buffer, SizeOf(Buffer));
      SetString(Result, Buffer, L);
    end;
  end;
end;

function GetModFileName: AnsiString;
var
  Buffer: array[0..261] of Char;
begin
  SetString(Result, Buffer, Windows.GetModuleFileName(HInstance,
    Buffer, SizeOf(Buffer)));
end;

function GetModuleFileName: AnsiString;
begin
  Result := GetLongFileName(GetModFileName);
end;

function GetLastErrorText: AnsiString;
begin
  Result := Tnt_WideFormat(SOSError, [GetLastError,  SysErrorMessage(GetLastError)]);
end;

procedure ODS(const S: AnsiString);
begin
{$IFDEF DEBUG}
  OutputDebugString(PChar(S));
{$ENDIF}
end;

{ TLogFile }

constructor TLogFile.Create;
begin
  ODS('TLogFile.Create');
  inherited Create;
  FLock := TCriticalSection.Create;
  FHandle := INVALID_HANDLE_VALUE;
  FDeviceName := 'Device1';
  FSeparator := SDefaultSeparator;
  SetDefaults;


  //JclAddExceptNotifier(LogException);
end;

destructor TLogFile.Destroy;
begin
  ODS('TLogFile.Destroy');
  //JclRemoveExceptNotifier(LogException);

  CloseFile;
  FLock.Free;
  inherited Destroy;
end;

procedure TLogFile.LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
var
  TmpS: string;
  Lines: TStringList;
  ModInfo: TJclLocationInfo;
  I: Integer;
  ExceptionHandled: Boolean;
  HandlerLocation: Pointer;
  ExceptFrame: TJclExceptFrame;
begin
  if not IsOS then Exit;

  Lines := TStringList.Create;
  try
    TmpS := 'Exception ' + ExceptObj.ClassName;
    if ExceptObj is Exception then
      TmpS := TmpS + ': ' + Exception(ExceptObj).Message;
    if IsOS then
      TmpS := TmpS + ' (OS Exception)';
    Lines.Add(TmpS);
    ModInfo := GetLocationInfo(ExceptAddr);
    Lines.Add(Format(
      '  Exception occured at $%p (Module "%s", Procedure "%s", Unit "%s", Line %d)',
      [ModInfo.Address,
       ModInfo.UnitName,
       ModInfo.ProcedureName,
       ModInfo.SourceName,
       ModInfo.LineNumber]));
    if stExceptFrame in JclStackTrackingOptions then
    begin
      Lines.Add('  Except frame-dump:');
      I := 0;
      ExceptionHandled := False;
      while (not ExceptionHandled) and
        (I < JclLastExceptFrameList.Count) do
      begin
        ExceptFrame := JclLastExceptFrameList.Items[I];
        ExceptionHandled := ExceptFrame.HandlerInfo(ExceptObj, HandlerLocation);
        if (ExceptFrame.FrameKind = efkFinally) or
            (ExceptFrame.FrameKind = efkUnknown) or
            not ExceptionHandled then
          HandlerLocation := ExceptFrame.CodeLocation;
        ModInfo := GetLocationInfo(HandlerLocation);
        TmpS := Format(
          '    Frame at $%p (type: %s',
          [ExceptFrame.FrameLocation,
           GetEnumName(TypeInfo(TExceptFrameKind), Ord(ExceptFrame.FrameKind))]);
        if ExceptionHandled then
          TmpS := TmpS + ', handles exception)'
        else
          TmpS := TmpS + ')';
        Lines.Add(TmpS);
        if ExceptionHandled then
          Lines.Add(Format(
            '      Handler at $%p',
            [HandlerLocation]))
        else
          Lines.Add(Format(
            '      Code at $%p',
            [HandlerLocation]));
        Lines.Add(Format(
          '      Module "%s", Procedure "%s", Unit "%s", Line %d',
          [ModInfo.UnitName,
           ModInfo.ProcedureName,
           ModInfo.SourceName,
           ModInfo.LineNumber]));
        Inc(I);
      end;
    end;
    Lines.Add('');

    JclLastExceptStackList.AddToStrings(Lines, True, True, True, True);
    Lines.Add('');

    Write(Lines.Text);
  finally
    Lines.Free;
  end;
end;


procedure TLogFile.Lock;
begin
  //FLock.Enter;
end;

procedure TLogFile.Unlock;
begin
  //FLock.Leave;
end;

function TLogFile.GetDefaultFileName: AnsiString;
begin
  Result := IncludeTrailingBackSlash(FilePath) + DeviceName + '_' +
    FormatDateTime('yyyy.mm.dd', Date) + '.log';
end;

function TLogFile.GetFileName: AnsiString;
begin
  Result := FFileName;
end;

procedure TLogFile.SetDefaults;
begin
  MaxCount := 0;
  Enabled := False;
  FilePath := IncludeTrailingBackSlash(ExtractFilePath(GetModuleFileName)) + 'Logs';
  FileName := GetDefaultFileName;
  FTimeStampEnabled := True;
end;

procedure TLogFile.OpenFile;
var
  FileName: AnsiString;
begin
  Lock;
  try
    if not Opened then
    begin
      CheckFilesMaxCount;
      if not DirectoryExists(FilePath) then
      begin
        ODS(Format('Log directory is not exists, ''%s''', [FilePath]));
        if not CreateDir(FilePath) then
        begin
          ODS('Failed to create log directory');
          ODS(GetLastErrorText);
        end;
      end;

      FileName := GetDefaultFileName;
      FHandle := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
        FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);

      if Opened then
      begin
        FileSeek(FHandle, 0, 2); // 0 from end
        FFileName := FileName;
      end else
      begin
        ODS(Format('Failed to create log file ''%s''', [FileName]));
        ODS(GetLastErrorText);
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TLogFile.CloseFile;
begin
  Lock;
  try
    if Opened then
      CloseHandle(FHandle);
    FHandle := INVALID_HANDLE_VALUE;
  finally
    Unlock;
  end;
end;

function TLogFile.GetOpened: Boolean;
begin
  Result := FHandle <> INVALID_HANDLE_VALUE;
end;

procedure TLogFile.SetEnabled(Value: Boolean);
begin
  if Value <> Enabled then
  begin
    FEnabled := Value;
    CloseFile;
  end;
end;

procedure TLogFile.SetFileName(const Value: AnsiString);
begin
  if Value <> FileName then
  begin
    CloseFile;
    FFileName := Value;
  end;
end;

procedure TLogFile.CheckFilesMaxCount;
var
  FileMask: AnsiString;
  FileNames: TTntStringList;
begin
  if MaxCount = 0 then Exit;
  FileNames := TTntStringList.Create;
  try
    FileMask := IncludeTrailingBackSlash(FilePath) + Tnt_WideFormat('*%s*.log', [DeviceName]);
    GetFileNames(FileMask, FileNames);
    FileNames.Sort;
    while FileNames.Count > MaxCount do
    begin
      DeleteFile(FileNames[0]);
      FileNames.Delete(0);
    end;
  finally
    FileNames.Free;
  end;
end;

procedure TLogFile.GetFileNames(const Mask: AnsiString; FileNames: TTntStrings);
var
  F: TSearchRec;
  Result: Integer;
  FileName: AnsiString;
begin
  FileNames.Clear;
  Result := FindFirst(Mask, faAnyFile, F);
  while Result = 0 do
  begin
    FileName := ExtractFilePath(Mask) + F.FindData.cFileName;
    FileNames.Add(FileName);
    Result := FindNext(F);
  end;
  FindClose(F);
end;

function TLogFile.GetFileDate(const FileName: AnsiString;
  var FileDate: TDateTime): Boolean;
var
  Line: AnsiString;
  Year, Month, Day: Word;
begin
  try
    Line := ChangeFileExt(ExtractFileName(FileName), '');
    Line := Copy(Line, Length(Line)-9, 10);
    Day := StrToInt(Copy(Line, 1, 2));
    Month := StrToInt(Copy(Line, 4, 2));
    Year := StrToInt(Copy(Line, 7, 4));
    FileDate := EncodeDate(Year, Month, Day);
    Result := True;
  except
    Result := False;
  end;
end;

procedure TLogFile.Write(const Data: AnsiString);
var
  i: Integer;
  S: AnsiString;
  Count: DWORD;
  NewFileName: AnsiString;
begin
  ODS(Data);
  Lock;
  try
    if not Enabled then Exit;
    S := Data;

    if GetDefaultFileName <> FFileName then
    begin
      CloseFile;
    end;
    OpenFile;
    if Opened then
    begin
      if (GetFileSize() div 1024) > MAX_FILE_SIZE_IN_KB then
      begin
        CloseFile;
        for i := 0 to MAX_FILES_COUNT-1 do
        begin
          NewFileName := ChangeFileExt(FFileName, Format('_%d.log', [i]));
          if not FileExists(NewFileName) then
          begin
            RenameFile(FFileName, NewFileName);
            Break;
          end;
        end;
        OpenFile;
      end;

      if not WriteFile(FHandle, S[1], Length(S), Count, nil) then
      begin
        CloseFile;
      end;
    end;
  finally
    Unlock;
  end;
end;

procedure TLogFile.AddLine(const Data: AnsiString);
const
  CRLF = #13#10;
var
  Line: AnsiString;
begin
  Line := Data;
  if FTimeStampEnabled then
    Line := Tnt_WideFormat('[%s] [%.8d] %s', [GetTimeStamp, GetCurrentThreadID, Line]);
  Line := Line + CRLF;
  Write(Line);
end;

procedure TLogFile.Trace(const Data: AnsiString);
begin
  AddLine(TagTrace + Data);
end;

procedure TLogFile.Info(const Data: AnsiString);
begin
  AddLine(TagInfo + Data);
end;

procedure TLogFile.Error(const Data: AnsiString);
begin
  AddLine(TagError + Data);
end;

procedure TLogFile.Error(const Data: AnsiString; E: Exception);
begin
  AddLine(TagError + Data + ' ' + GetExceptionMessage(E));
end;

procedure TLogFile.Debug(const Data: AnsiString);
begin
  AddLine(TagDebug + Data);
end;

class function TLogFile.ParamsToStr(const Params: array of const): AnsiString;
begin
  Result := VarArrayToStr(ConstArrayToVarArray(Params));
end;

procedure TLogFile.Debug(const Data: AnsiString; Params: array of const);
begin
  Debug(Data + ParamsToStr(Params));
end;

procedure TLogFile.Debug(const Data: AnsiString; Params: array of const;
  Result: Variant);
begin
  Debug(Data + ParamsToStr(Params) + '=' + VariantToStr(Result));
end;

procedure TLogFile.Debug(const Data: AnsiString; Result: Variant);
begin
  Debug(Data + '=' + VariantToStr(Result));
end;

procedure TLogFile.Error(const Data: AnsiString; Params: array of const);
begin
  Error(Data + ParamsToStr(Params));
end;

procedure TLogFile.Info(const Data: AnsiString; Params: array of const);
begin
  Info(Data + ParamsToStr(Params));
end;

procedure TLogFile.Trace(const Data: AnsiString; Params: array of const);
begin
  Trace(Data + ParamsToStr(Params));
end;

{ Преобразование строки в текст, чтобы увидеть все символы }

class function TLogFile.StrToText(const Text: AnsiString): AnsiString;
var
  Code: Byte;
  i: Integer;
  IsPrevCharNormal: Boolean;
begin
  Result := '';
  IsPrevCharNormal := False;
  if Length(Text) > 0 then
  begin
    for i := 1 to Length(Text) do
    begin
      Code := Ord(Text[i]);
      if Code < $20 then
      begin
        if IsPrevCharNormal then
        begin
          IsPrevCharNormal := False;
          Result := Result + '''';
        end;
        Result := Result + Tnt_WideFormat('#$%.2x', [Code])
      end else
      begin
        if not IsPrevCharNormal then
        begin
          IsPrevCharNormal := True;
          Result := Result + '''';
        end;
        Result := Result + Text[i];
      end;
    end;
    if IsPrevCharNormal then
      Result := Result + '''';
  end else
  begin
    Result := '''''';
  end;
end;

class function TLogFile.VariantToStr(V: Variant): AnsiString;
begin
  if VarIsNull(V) then
  begin
    Result := 'NULL';
  end else
  begin
    case VarType(V) of
      varOleStr,
      varStrArg,
      varString:
        Result := StrToText(VarToStr(V));
    else
      Result := VarToStr(V);
    end;
  end;
end;

class function TLogFile.VarArrayToStr(const AVarArray: TVariantArray): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for i := Low(AVarArray) to High(AVarArray) do
  begin
    if Length(Result) > 0 then
      Result := Result + ', ';
    Result := Result + VariantToStr(AVarArray[I]);
  end;
  Result := '(' + Result + ')';
end;

procedure TLogFile.SetMaxCount(const Value: Integer);
begin
  if Value <> MaxCount then
  begin
    FMaxCount := Value;
    CheckFilesMaxCount;
  end;
end;

procedure TLogFile.DebugData(const Prefix, Data: AnsiString);
var
  Line: AnsiString;
const
  DataLen = 20; // Max data string length
begin
  Line := Data;
  repeat
    Debug(Prefix + StrToHex(Copy(Line, 1, DataLen)));
    Line := Copy(Line, DataLen + 1, Length(Line));
  until Line = '';
end;

procedure TLogFile.WriteRxData(Data: AnsiString);
begin
  DebugData('<- ', Data);
end;

procedure TLogFile.WriteTxData(Data: AnsiString);
begin
  DebugData('-> ', Data);
end;

procedure TLogFile.LogParam(const ParamName: AnsiString; const ParamValue: Variant);
begin
  Debug(ParamName + ': ' + VarToStr(ParamValue));
end;


function TLogFile.GetSeparator: AnsiString;
begin
  Result := FSeparator;
end;

procedure TLogFile.SetSeparator(const Value: AnsiString);
begin
  FSeparator := Value;
end;

function TLogFile.GetMaxCount: Integer;
begin
  Result := FMaxCount;
end;

function TLogFile.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TLogFile.GetFilePath: AnsiString;
begin
  Result := FFilePath;
end;

procedure TLogFile.SetFilePath(const Value: AnsiString);
begin
  FFilePath := Value;
end;

function TLogFile.GetDeviceName: AnsiString;
begin
  Result := FDeviceName;
end;

procedure TLogFile.SetDeviceName(const Value: AnsiString);
begin
  FDeviceName := Value;
end;

function TLogFile.GetTimeStampEnabled: Boolean;
begin
  Result := FTimeStampEnabled;
end;

procedure TLogFile.SetTimeStampEnabled(const Value: Boolean);
begin
  FTimeStampEnabled := Value;
end;

function TLogFile.GetFileSize: Int64;
var
  FileSizeHigh: DWORD;
begin
  Result := 0;
  if Opened then
  begin
    Result := Windows.GetFileSize(FHandle, @FileSizeHigh);
    Result := Result + (FileSizeHigh * $100000000);
  end;
end;

(*
initialization
  Include(JclStackTrackingOptions, stStaticModuleList);
  Include(JclStackTrackingOptions, stExceptFrame);
  JclStartExceptionTracking;


finalization
  JclStopExceptionTracking;
*)

end.
