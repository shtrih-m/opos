unit fmuCashDrawer;

interface

uses
  // VCL
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Registry, ExtCtrls, ComCtrls, Spin,
  // Opos
  OposDevice,
  // This
  untPages, BaseForm, untUtil, CashDrawerParameters,
  PrinterParameters, CashDrawerDevice;

type
  { TfmCashDrawer }

  TfmCashDrawer = class(TCashPage)
    OpenDialog: TOpenDialog;
    lblDrawerNumber: TLabel;
    lblFiscalPrinterDeviceName: TLabel;
    cbFiscalPrinterDeviceName: TComboBox;
    lblCCOType: TLabel;
    cbCCOType: TComboBox;
    seDrawerNumber: TSpinEdit;
    procedure btnDefaultsClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure SetDefaults;
    procedure SaveParams(const DeviceName: WideString);
    procedure LoadParams(const DeviceName: WideString);

    procedure UpdatePage; override;
    procedure UpdateObject; override;
  end;

implementation

{$R *.DFM}

{ TfmCashDrawer }

procedure TfmCashDrawer.UpdatePage;
begin
  cbFiscalPrinterDeviceName.Text := Parameters.FptrDeviceName;
  seDrawerNumber.Value := Parameters.DrawerNumber;
  cbCCOType.ItemIndex := Parameters.CCOType;
end;

procedure TfmCashDrawer.UpdateObject;
begin
  Parameters.FptrDeviceName := cbFiscalPrinterDeviceName.Text;
  Parameters.DrawerNumber := seDrawerNumber.Value;
  Parameters.CCOType := cbCCOType.ItemIndex;
end;

procedure TfmCashDrawer.SetDefaults;
begin
  Parameters.SetDefaults;
end;

procedure TfmCashDrawer.LoadParams(const DeviceName: WideString);
begin
  Parameters.Load(DeviceName);
end;

procedure TfmCashDrawer.SaveParams(const DeviceName: WideString);
begin
  Parameters.Save(DeviceName);
end;

procedure TfmCashDrawer.btnDefaultsClick(Sender: TObject);
begin
  Parameters.SetDefaults;
  UpdatePage;
end;

procedure TfmCashDrawer.btnOKClick(Sender: TObject);
begin
  UpdateObject;
  ModalResult := mrOK;
end;

procedure TfmCashDrawer.FormCreate(Sender: TObject);
var
  D: TOposDevice;
begin
  D := TOposDevice.Create(nil, 'FiscalPrinter', 'FiscalPrinter',
    FiscalPrinterProgID);
  try
    D.GetDeviceNames(cbFiscalPrinterDeviceName.Items);
  finally
    D.Free;
  end;
end;

end.
