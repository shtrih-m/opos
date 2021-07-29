unit LogExcept;

interface

uses
  // VCL
  Classes, SysUtils, TypInfo,
  // 3'd
  JclDebug, JclHookExcept;

implementation

procedure LogException(ExceptObj: TObject; ExceptAddr: Pointer; IsOS: Boolean);
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

    Lines.SaveToFile('C:\SmFiscalPrinterException.txt');
  finally
    Lines.Free;
  end;
end;

initialization
  Include(JclStackTrackingOptions, stStaticModuleList);
  Include(JclStackTrackingOptions, stExceptFrame);
  JclStartExceptionTracking;
  JclAddExceptNotifier(LogException);


finalization
  JclStopExceptionTracking;

end.
