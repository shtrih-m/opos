unit fmuFptrInfo;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls, ComObj,
  // Tnt
  TntStdCtrls, TntSysUtils, TntClasses, 
  // This
  untPages, Opos, Oposhi, OposUtils, OposFiscalPrinter, OposDevice,
  VersionInfo;

type
  TfmFptrInfo = class(TPage)
    btnRefresh: TTntButton;
    memDevices: TTntMemo;
    lblServiceFileVersion_: TTntLabel;
    lblServiceFileVersion: TTntLabel;
    procedure btnRefreshClick(Sender: TObject);
  public
    procedure UpdateDevices;
    procedure UpdatePage; override;
  end;

implementation

{$R *.DFM}

function ReadControlVersion(const ProgID: WideString): WideString;
var
  V: OleVariant;
begin
  Result := '';
  try
    V := CreateOleObject(ProgID);
    Result := V.ControlObjectVersion;
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

{ TfmFptrGeneral }

procedure TfmFptrInfo.UpdateDevices;
var
  i: Integer;
  DeviceName: WideString;
  Device: TOposDevice;
  ServiceProgID: WideString;
  DeviceNames: TTntStrings;
  ServiceFileVersion: WideString;
  ServiceObjectVersion: WideString;
  ControlObjectVersion: WideString;
  ControlObjectFileVersion: WideString;
begin
  try
    lblServiceFileVersion.Caption :=
      TOposDevice.ProgIDToFileVersion(FiscalPrinterProgID);

    memDevices.Clear;
    // Control object info
    ControlObjectVersion := ReadControlVersion('Opos.FiscalPrinter');
    ControlObjectFileVersion := VersionInfoToStr(ReadFileVersion(
      ProgIDToFileName('Opos.FiscalPrinter')));


    memDevices.Lines.Add('-----------------------------------------');
    memDevices.Lines.Add(Format('Control object version : %s', [
      ControlObjectVersion]));

    memDevices.Lines.Add(Format('Control file version   : %s', [
      ControlObjectFileVersion]));
    // Service object info

    // Devices info
    DeviceNames := TTntStringList.Create;
    Device := TOposDevice.Create(nil, OPOS_CLASSKEY_FPTR, OPOS_CLASSKEY_FPTR,
      FiscalPrinterProgID);
    try
      Device.GetDeviceNames(DeviceNames);
      for i := 0 to DeviceNames.Count-1 do
      begin
        DeviceName := DeviceNames[i];
        ServiceProgID := Device.ReadServiceName(DeviceName);
        ServiceObjectVersion := Device.ReadServiceVersion(ServiceProgID);
        ServiceFileVersion := Device.ProgIDToFileVersion(ServiceProgID);

        memDevices.Lines.Add('-----------------------------------------');
        memDevices.Lines.Add(Format('Device name      : "%s"', [DeviceName]));
        memDevices.Lines.Add(Format('Service ProgID   : %s', [ServiceProgID]));
        memDevices.Lines.Add(Format('Service version  : %s', [ServiceObjectVersion]));
        memDevices.Lines.Add(Format('Service file ver.: %s', [ServiceFileVersion]));

        memDevices.Lines.Add('-----------------------------------------');

      end;
    finally
      Device.Free;
      DeviceNames.Free;
    end;
  except
    on E: Exception do
    begin
      memDevices.Lines.Add('Device update failed: ' + E.Message);
    end;
  end;
end;

procedure TfmFptrInfo.btnRefreshClick(Sender: TObject);
begin
  UpdateDevices;
end;

procedure TfmFptrInfo.UpdatePage;
begin
  UpdateDevices;
end;

end.
