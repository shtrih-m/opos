unit fmuGeneral;

interface

uses
  // VCL
  Windows, StdCtrls, ExtCtrls, Controls, Classes,
  // This
  untPages;

type
  TfmGeneral = class(TPage)
    StaticText1: TStaticText;
    Edit53: TEdit;
    gbConnectionParams: TGroupBox;
    lblComPort: TLabel;
    lblBaudRate: TLabel;
    lblTimeout: TLabel;
    edtTimeout: TEdit;
    cbBaudRate: TComboBox;
    cbComPort: TComboBox;
    btnReadParameters: TButton;
    btnWriteParameters: TButton;
    gbScaleMode: TGroupBox;
    rbWeightMode: TRadioButton;
    rbGraduationMode: TRadioButton;
    rbDataMode: TRadioButton;
    btnReadMode: TButton;
    btnWriteMode: TButton;
    gbKeyboard: TGroupBox;
    btnKeyCode: TButton;
    Edit123: TEdit;
    lblKeyCode: TLabel;
    btnLockKeyboard: TButton;
    btnUnlockKeyboard: TButton;
    btnKeyboardReadStatus: TButton;
    GroupBox1: TGroupBox;
    lblNewPassword: TLabel;
    edtNewPassword: TEdit;
    btnWritePassword: TButton;
    gbStatus: TGroupBox;
    Memo1: TMemo;
    btnReadStatus: TButton;
  end;

var
  fmGeneral: TfmGeneral;

implementation

{$R *.DFM}


end.
