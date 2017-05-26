unit fmuScaleProperties;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ActiveX, ComObj,
  // This
  untPages, OposScale;

type
  { TfmScaleProperties }

  TfmScaleProperties = class(TPage)
    btnRefresh: TButton;
    Memo: TMemo;
    procedure btnRefreshClick(Sender: TObject);
  private
    procedure UpdateForm;
    function GetPropVal(const PropertyName: WideString): string;
  end;

implementation

{$R *.DFM}

function BoolToStr(Value: Boolean): string;
begin
  if Value then Result := '[X]'
  else Result := '[ ]';
end;

function TfmScaleProperties.GetPropVal(const PropertyName: WideString): string;
var
  Value: Variant;
  Intf: IDispatch;
  PName: PWideChar;
  PropID: Integer;
  DispParams: TDispParams;
begin
  Intf := Scale.ControlInterface;
  PName := PWideChar(PropertyName);
  try
    OleCheck(Intf.GetIDsOfNames(GUID_NULL, @PName, 1, GetThreadLocale, @PropID));
    VarClear(Value);
    FillChar(DispParams, SizeOf(DispParams), 0);
    OleCheck(Intf.Invoke(PropID, GUID_NULL, 0, DISPATCH_PROPERTYGET,
      DispParams, @Value, nil, nil));

    Result := Value;
  except
    on E: Exception do Result := E.Message;
  end;
end;

// Show all properties

procedure TfmScaleProperties.UpdateForm;
var
  S: string;
  i: Integer;
  TypeAttr: PTypeAttr;
  Dispatch: IDispatch;
  TypeInfo: ITypeInfo;
  FuncDesc: PFuncDesc;
  PropName: WideString;
begin
  Memo.Clear;
  Dispatch := Scale.ControlInterface;

  Dispatch.GetTypeInfo(0, 0, TypeInfo);
  if TypeInfo = nil then Exit;
  TypeInfo.GetTypeAttr(TypeAttr);
  try
    for i := 0 to TypeAttr.cFuncs-1 do
    begin
      TypeInfo.GetFuncDesc(i, FuncDesc);
      try
        TypeInfo.GetDocumentation(FuncDesc.memid, @PropName, nil, nil, nil);
        if FuncDesc.invkind = INVOKE_PROPERTYGET then
        begin
          S := GetPropVal(PropName);
          S := Format('%.3d %-26s: %s', [i+1, PropName, S]);
          Memo.Lines.Add(S);
        end;
      finally
        TypeInfo.ReleaseFuncDesc(FuncDesc);
      end;
    end;
  finally
    TypeInfo.ReleaseTypeAttr(TypeAttr);
  end;
end;

procedure TfmScaleProperties.btnRefreshClick(Sender: TObject);
begin
  EnableButtons(False);
  try
    UpdateForm;
  finally
    EnableButtons(True);
  end;
end;

end.
