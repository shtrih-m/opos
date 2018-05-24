unit fmuDevice;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  // This
  BaseForm, TntStdCtrls;

type
  TfmDevice = class(TBaseForm)
    btnOK: TTntButton;
    btnCancel: TTntButton;
    lblDeviceName: TTntLabel;
    edtDeviceName: TTntEdit;
  end;

function EditDeviceName(var DeviceName: string): Boolean;

implementation

{$R *.DFM}

function EditDeviceName(var DeviceName: string): Boolean;
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

