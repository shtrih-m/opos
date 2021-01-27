unit IntfObj;

interface

uses
  // VCL
  SysUtils, Windows;

type
  TInterfacedObject2 = class(TObject, IInterface)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    property RefCount: Integer read FRefCount;
  end;

implementation

procedure ODS(const S: WideString);
begin
  OutputDebugStringW(PWideChar(S));
end;

function InterlockedIncrement(var I: Integer): Integer;
asm
      MOV   EDX,1
      XCHG  EAX,EDX
 LOCK XADD  [EDX],EAX
      INC   EAX
end;

function InterlockedDecrement(var I: Integer): Integer;
asm
      MOV   EDX,-1
      XCHG  EAX,EDX
 LOCK XADD  [EDX],EAX
      DEC   EAX
end;

procedure TInterfacedObject2.AfterConstruction;
begin
// Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);
end;

procedure TInterfacedObject2.BeforeDestruction;
begin
  if RefCount <> 0 then
    ODS('reInvalidPtr !');
end;

// Set an implicit refcount so that refcounting
// during construction won't destroy the object.
class function TInterfacedObject2.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TInterfacedObject2(Result).FRefCount := 1;
end;

function TInterfacedObject2.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TInterfacedObject2._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
  ODS('_AddRef: ' + IntToStr(FRefCount));
end;

function TInterfacedObject2._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  ODS('_Release: ' + IntToStr(FRefCount));
  if Result = 0 then
    Destroy;
end;

end.
