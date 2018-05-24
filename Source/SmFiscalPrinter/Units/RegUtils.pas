unit RegUtils;

interface

uses
  // VCL
  Windows, Classes, SysUtils,
  // Tnt
  TntRegistry, TntClasses;

procedure DeleteRegKey(const KeyName: string);

implementation

procedure DeleteRegKey(const KeyName: string);
var
  i: Integer;
  Reg: TTntRegistry;
  Strings: TTntStrings;
begin
  Reg := TTntRegistry.Create;
  Strings := TTntStringList.Create;
  try
    Reg.Access := KEY_ALL_ACCESS;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(KeyName, False) then
    begin
      Reg.GetKeyNames(Strings);
      for i := 0 to Strings.Count-1 do
      begin
        DeleteRegKey(KeyName + '\' + Strings[i]);
      end;
      Reg.CloseKey;
      Reg.DeleteKey(KeyName);
    end;
  finally
    Reg.Free;
    Strings.Free;
  end;
end;

end.
