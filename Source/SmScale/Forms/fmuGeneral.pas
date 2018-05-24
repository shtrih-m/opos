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
    Edit53: TTntEdit;
    gbConnectionParams: TTntGroupBox;
    lblComPort: TTntLabel;
    lblBaudRate: TTntLabel;
    lblTimeout: TTntLabel;
    edtTimeout: TTntEdit;
    cbBaudRate: TTntComboBox;
    cbComPort: TTntComboBox;
    btnReadParameters: TTntButton;
    btnWriteParameters: TTntButton;
    gbScaleMode: TTntGroupBox;
    rbWeightMode: TTntRadioButton;
    rbGraduationMode: TTntRadioButton;
    rbDataMode: TTntRadioButton;
    btnReadMode: TTntButton;
    btnWriteMode: TTntButton;
    gbKeyboard: TTntGroupBox;
    btnKeyCode: TTntButton;
    Edit123: TTntEdit;
    lblKeyCode: TTntLabel;
    btnLockKeyboard: TTntButton;
    btnUnlockKeyboard: TTntButton;
    btnKeyboardReadStatus: TTntButton;
    GroupBox1: TTntGroupBox;
    lblNewPassword: TTntLabel;
    edtNewPassword: TTntEdit;
    btnWritePassword: TTntButton;
    gbStatus: TTntGroupBox;
    Memo1: TTntMemo;
    btnReadStatus: TTntButton;
  end;

var
  fmGeneral: TfmGeneral;

implementation

{$R *.DFM}


end.
