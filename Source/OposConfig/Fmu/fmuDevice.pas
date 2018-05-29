unit fmuDevice;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // Tnt
  TntStdCtrls,
  // This
  BaseForm;

type
  TfmDevice = class(TBaseForm)
    btnOK: TTntButton;
    btnCancel: TTntButton;
    lblDeviceName: TTntLabel;
    edtDeviceName: TTntEdit;
  end;

function EditDeviceName(var DeviceName: WideString): Boolean;

implementation

{$R *.DFM}

function EditDeviceName(var DeviceName: WideString): Boolean;
var
  fm: TfmDevice;
begin
  fm := TfmDevice.Create(nil);
  try
    with fm do
    begin
      edtDeviceName.Text := DeviceName;
      Result := ShowModal = mrOK;
      if Result then
        DeviceName := edtDeviceName.Text;
    end;
  finally
    fm.Free;
  end;
end;

end.

