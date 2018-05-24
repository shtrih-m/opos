object fmDevice: TfmDevice
  Left = 412
  Top = 199
  BorderStyle = bsDialog
  Caption = 'Device'
  ClientHeight = 87
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblDeviceName: TTntLabel
    Left = 8
    Top = 20
    Width = 66
    Height = 13
    Caption = 'Device name:'
  end
  object btnOK: TTntButton
    Left = 136
    Top = 56
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TTntButton
    Left = 216
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object edtDeviceName: TTntEdit
    Left = 88
    Top = 16
    Width = 201
    Height = 21
    TabOrder = 0
    Text = 'edtDeviceName'
  end
end
