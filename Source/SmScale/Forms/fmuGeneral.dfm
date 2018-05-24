object fmGeneral: TfmGeneral
  Left = 351
  Top = 134
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1054#1089#1085#1086#1074#1085#1099#1077
  ClientHeight = 762
  ClientWidth = 375
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000F000000000000000000000000000000F0F000000000000
    0000000000000000FF0FF0000000000000000000000000000FF00F0000000000
    0000000000000000F0FF0FF0000000000000000000000000FF0F0FF000000000
    00000000000000FF0F0000FF0000000000000000000000F00FF000FF00000000
    00000000000000F000FF000FF000000000000000000000F0000FF00FFF00000F
    0F000000000000FF000FF000FF0000F0F00FF0000000000F0000FF000F0000F0
    00F00FF0F00FF00FF0000FF00FFF000FFFF0FFF0F0F0F00FFF0000FF00FF0000
    000FFF0FF0F0FF00FFFF00FFF0FF000000FF0FFF0FF0FF00F00FF00FFF000000
    000F0FFF0FFF0FF0FF0FFF00FF0000000000F0F0FFFF0FF00FF0FFF00FFF0000
    0000000FFF00FFFF0FFF0FFF00F00000000000F00FF0F0FFF0FF00FF00000000
    00000F00FFF0FF00FF0FF00FF00000000000000F00FF0FF0FF0FFF00F0000000
    000000000FFFF0FF0FF0FF00000000000000000000F0F0FF0F000FF000000000
    00000000FFFFFF0FF0F0000000000000000000FFFFF00FF0F000000000000000
    000000FFF00000000000000000000000000000000F000000000000000000FFFF
    FFFFFFFFFDFFFFFFFDFFFFFFF8FFFFFFF07FFFFFF03FFFFFE03FFFFFE01FFFFF
    C00FFFFFC00FC1FF800781FF800300FF0003007F0001001E0001000000010000
    000080000000C0000000E0000000F0000000F8000000FC000000FE000000FF00
    0001FF000001FF800007FFC00007FFC0003FFF8001FFFF0003FFFF0003FF}
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object StaticText1: TStaticText
    Left = 8
    Top = 704
    Width = 42
    Height = 17
    Caption = #1055#1072#1088#1086#1083#1100
    TabOrder = 1
  end
  object Edit53: TTntEdit
    Left = 68
    Top = 704
    Width = 65
    Height = 21
    MaxLength = 4
    TabOrder = 0
    Text = '30'
  end
  object gbConnectionParams: TTntGroupBox
    Left = 8
    Top = 8
    Width = 361
    Height = 137
    Caption = 'Connection parameters'
    TabOrder = 2
    object lblComPort: TTntLabel
      Left = 16
      Top = 24
      Width = 48
      Height = 13
      Caption = 'COM port:'
    end
    object lblBaudRate: TTntLabel
      Left = 16
      Top = 56
      Width = 51
      Height = 13
      Caption = 'BaudRate:'
    end
    object lblTimeout: TTntLabel
      Left = 16
      Top = 88
      Width = 41
      Height = 13
      Caption = 'Timeout:'
    end
    object edtTimeout: TTntEdit
      Left = 96
      Top = 88
      Width = 129
      Height = 21
      MaxLength = 3
      TabOrder = 2
      Text = '150'
    end
    object cbBaudRate: TTntComboBox
      Left = 96
      Top = 56
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        '2400'
        '4800'
        '9600'
        '19200'
        '38400'
        '57600'
        '115200')
    end
    object cbComPort: TTntComboBox
      Left = 96
      Top = 24
      Width = 129
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Com1'
        'Com2'
        'Com3'
        'Com4'
        'Com5'
        'Com6'
        'Com7'
        'Com8'
        'Com9'
        'Com10'
        'Com11'
        'Com12'
        'Com13'
        'Com14'
        'Com15'
        'Com16'
        'Com17'
        'Com18'
        'Com19'
        'Com20'
        'Com21'
        'Com22'
        'Com23'
        'Com24'
        'Com25'
        'Com26'
        'Com27'
        'Com28'
        'Com29'
        'Com30'
        'Com31'
        'Com32')
    end
    object btnReadParameters: TTntButton
      Left = 232
      Top = 24
      Width = 121
      Height = 25
      Caption = 'Read parameters'
      TabOrder = 3
    end
    object btnWriteParameters: TTntButton
      Left = 232
      Top = 56
      Width = 121
      Height = 25
      Caption = 'Write parameters'
      TabOrder = 4
    end
  end
  object gbScaleMode: TTntGroupBox
    Left = 8
    Top = 152
    Width = 361
    Height = 137
    Caption = 'Scale mode'
    TabOrder = 3
    object rbWeightMode: TTntRadioButton
      Left = 16
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Weight mode'
      TabOrder = 0
    end
    object rbGraduationMode: TTntRadioButton
      Left = 16
      Top = 64
      Width = 113
      Height = 17
      Caption = 'Graduation mode'
      TabOrder = 1
    end
    object rbDataMode: TTntRadioButton
      Left = 16
      Top = 96
      Width = 113
      Height = 17
      Caption = 'Data mode'
      TabOrder = 2
    end
    object btnReadMode: TTntButton
      Left = 232
      Top = 32
      Width = 121
      Height = 25
      Caption = 'Read mode'
      TabOrder = 3
    end
    object btnWriteMode: TTntButton
      Left = 232
      Top = 64
      Width = 121
      Height = 25
      Caption = 'Write mode'
      TabOrder = 4
    end
  end
  object gbKeyboard: TTntGroupBox
    Left = 8
    Top = 504
    Width = 361
    Height = 105
    Caption = 'Keyboard'
    TabOrder = 4
    object lblKeyCode: TTntLabel
      Left = 16
      Top = 24
      Width = 48
      Height = 13
      Caption = 'Key code:'
    end
    object btnKeyCode: TTntButton
      Left = 152
      Top = 24
      Width = 97
      Height = 25
      Caption = 'Send key code'
      TabOrder = 0
    end
    object Edit123: TTntEdit
      Left = 80
      Top = 24
      Width = 65
      Height = 21
      MaxLength = 3
      TabOrder = 1
      Text = '0'
    end
    object btnLockKeyboard: TTntButton
      Left = 152
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Lock keyboard'
      TabOrder = 2
    end
    object btnUnlockKeyboard: TTntButton
      Left = 256
      Top = 56
      Width = 97
      Height = 25
      Caption = 'Unlock keyboard'
      TabOrder = 3
    end
    object btnKeyboardReadStatus: TTntButton
      Left = 256
      Top = 24
      Width = 97
      Height = 25
      Caption = 'Read status'
      TabOrder = 4
    end
  end
  object GroupBox1: TTntGroupBox
    Left = 8
    Top = 616
    Width = 361
    Height = 73
    Caption = 'Password'
    TabOrder = 5
    object lblNewPassword: TTntLabel
      Left = 12
      Top = 35
      Width = 73
      Height = 13
      Caption = 'New password:'
      WordWrap = True
    end
    object edtNewPassword: TTntEdit
      Left = 96
      Top = 32
      Width = 145
      Height = 21
      MaxLength = 4
      TabOrder = 0
      Text = '0'
    end
    object btnWritePassword: TTntButton
      Left = 248
      Top = 32
      Width = 105
      Height = 25
      Caption = 'Write password'
      TabOrder = 1
    end
  end
  object gbStatus: TTntGroupBox
    Left = 8
    Top = 296
    Width = 361
    Height = 201
    Caption = 'Status'
    TabOrder = 6
    object Memo1: TTntMemo
      Left = 8
      Top = 24
      Width = 345
      Height = 129
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
    object btnReadStatus: TTntButton
      Left = 256
      Top = 168
      Width = 97
      Height = 25
      Caption = 'Read status'
      TabOrder = 1
    end
  end
end
