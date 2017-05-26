unit DcomFactory;

interface

uses
  // VCL
  Windows, SysUtils, ComObj,
  // This
  DcomUtils;

type
  { TDcomFactory }

  TDcomFactory = class(TAutoObjectFactory)
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

implementation

{ TDcomFactory }

procedure TDcomFactory.UpdateRegistry(Register: Boolean);
begin
  inherited UpdateRegistry(Register);
  // AppID
  if Register then
  begin
    CreateRegKey('AppID\' + GuidToString(ClassID), '', Description);
  end else
  begin
    DeleteRegKey('AppID\' + GuidToString(ClassID));
  end;
  // Allow launch and access
  if Register and (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    try
      AllowLaunch(ClassID);
      AllowAccess(ClassID);
    except
      // ignore
    end;
  end;
end;

end.
