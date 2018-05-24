unit SerialPorts;

interface

uses
  // VCL
  Windows, Classes, Registry, SysUtils,
  // Tnt
  TntSysUtils, TntClasses, TntRegistry;

type
  { TSerialPorts }

  TSerialPorts = class
  private
    class procedure GetDefaultPorts(Ports: TTntStrings; Count: Integer);
  public
    class procedure GetPorts(Ports: TTntStrings);
    class procedure GetSystemPorts(Ports: TTntStringList);

    class function GetPortNames: string;
    class function GetSystemPortNames: string;
  end;

implementation

{ TSerialPorts }

class procedure TSerialPorts.GetPorts(Ports: TTntStrings);
begin
  GetDefaultPorts(Ports, 256);
end;

class procedure TSerialPorts.GetDefaultPorts(Ports: TTntStrings; Count: Integer);
var
  i: Integer;
begin
  Ports.Clear;
  for i := 1 to Count do
    Ports.AddObject('COM '+ IntToStr(i), TObject(i));
end;

{ Compare by port numbers  }

function ComparePorts(List: TTntStringList; Index1, Index2: Integer): Integer;
begin
  Result := Integer(List.Objects[Index1]) - Integer(List.Objects[Index2]);
end;

{ Ports must be named as COMx }
{ We don't add another ports }

class procedure TSerialPorts.GetSystemPorts(Ports: TTntStringList);
var
  S: string;
  S1: string;
  i: Integer;
  Code: Integer;
  Reg: TTntRegistry;
  PortNumber: Integer;
  Strings: TTntStringList;
begin
  Ports.Clear;
  Reg := TTntRegistry.Create;
  Strings := TTntStringList.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\HARDWARE\DEVICEMAP\SERIALCOMM', False) then
    begin
      Reg.GetValueNames(Strings);
      for i := 0 to Strings.Count-1 do
      begin
        S := Reg.ReadString(Strings[i]);
        S1 := Copy(S, 4, Length(S));
        Val(S1, PortNumber, Code);
        if Code = 0 then
        begin
          if Ports.IndexOf(S) = -1 then
            Ports.AddObject(S, TObject(PortNumber));
        end;
      end;
      Ports.CustomSort(ComparePorts);
    end;
  finally
    Reg.Free;
    Strings.Free;
  end;
end;

class function TSerialPorts.GetSystemPortNames: string;
var
  PortNames: TTntStringList;
begin
  PortNames := TTntStringList.Create;
  try
    GetSystemPorts(PortNames);
    Result := PortNames.Text;
  finally
    PortNames.Free;
  end;
end;

class function TSerialPorts.GetPortNames: string;
var
  PortNames: TTntStringList;
begin
  PortNames := TTntStringList.Create;
  try
    GetPorts(PortNames);
    Result := PortNames.Text;
  finally
    PortNames.Free;
  end;
end;

end.
