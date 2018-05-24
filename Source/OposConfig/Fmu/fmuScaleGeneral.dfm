object fmScaleGeneral: TfmScaleGeneral
  Left = 379
  Top = 113
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Scale'
  ClientHeight = 375
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    432
    375)
  PixelsPerInch = 96
  TextHeight = 13
  object gbParams: TTntGroupBox
    Left = 8
    Top = 8
    Width = 417
    Height = 361
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object lblComPort: TTntLabel
      Left = 8
      Top = 24
      Width = 48
      Height = 13
      Caption = 'COM port:'
    end
    object lblBaudRate: TTntLabel
      Left = 8
      Top = 48
      Width = 46
      Height = 13
      Caption = 'Baudrate:'
    end
    object lblByteTimeout: TTntLabel
      Left = 8
      Top = 72
      Width = 80
      Height = 13
      Caption = 'Byte timeout, ms:'
    end
    object lblMaxRetryCount: TTntLabel
      Left = 8
      Top = 120
      Width = 120
      Height = 13
      Caption = 'Maximum connect retries:'
    end
    object lblCommandTimeout: TTntLabel
      Left = 8
      Top = 96
      Width = 106
      Height = 13
      Caption = 'Command timeout, ms:'
    end
    object lblPassword: TTntLabel
      Left = 8
      Top = 208
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object lblEncoding: TTntLabel
      Left = 8
      Top = 232
      Width = 48
      Height = 13
      Caption = 'Encoding:'
    end
    object lblCCOType: TTntLabel
      Left = 8
      Top = 264
      Width = 48
      Height = 13
      Caption = 'CCO type:'
    end
    object lblPollPeriod: TTntLabel
      Left = 8
      Top = 312
      Width = 52
      Height = 13
      Caption = 'Poll period:'
    end
    object cbComPort: TTntComboBox
      Left = 216
      Top = 24
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object cbBaudRate: TTntComboBox
      Left = 216
      Top = 48
      Width = 193
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
    object chbSearchByPort: TTntCheckBox
      Left = 8
      Top = 176
      Width = 401
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Find device on all available COM ports'
      TabOrder = 6
    end
    object chbSearchByBaudRate: TTntCheckBox
      Left = 8
      Top = 152
      Width = 401
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Find device on all available baud rates'
      TabOrder = 5
    end
    object seByteTimeout: TSpinEdit
      Left = 216
      Top = 72
      Width = 193
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object seMaxRetryCount: TSpinEdit
      Left = 216
      Top = 121
      Width = 193
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object seCommandTimeout: TSpinEdit
      Left = 216
      Top = 96
      Width = 193
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object sePassword: TSpinEdit
      Left = 216
      Top = 209
      Width = 193
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 7
      Value = 0
    end
    object cbEncoding: TTntComboBox
      Left = 216
      Top = 232
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 8
      Items.Strings = (
        'Windows'
        'CP866')
    end
    object cbCCOType: TTntComboBox
      Left = 216
      Top = 256
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 9
      Items.Strings = (
        'RCS CCO (default)'
        'NCR CCO'
        'None')
    end
    object chbCapPrice: TTntCheckBox
      Left = 8
      Top = 288
      Width = 401
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use scale price calculating (additional commands will be sent)'
      TabOrder = 10
    end
    object spPollPeriod: TSpinEdit
      Left = 216
      Top = 313
      Width = 193
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 11
      Value = 0
    end
  end
  object OpenDialog: TTntOpenDialog
    Filter = 
      'Log files (*.log)|*.log|Text files (*.txt)|*.txt|All files (*.*)' +
      '|*.*'
    Left = 112
    Top = 240
  end
end
