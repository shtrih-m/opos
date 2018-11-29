object fmFptrConnection: TfmFptrConnection
  Left = 533
  Top = 150
  Width = 512
  Height = 381
  Caption = 'Connection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblStorage: TTntLabel
    Left = 8
    Top = 304
    Width = 94
    Height = 13
    Caption = 'Parameters storage:'
  end
  object lblModel: TTntLabel
    Left = 264
    Top = 267
    Width = 32
    Height = 13
    Caption = 'Model:'
  end
  object gbConenctionParams: TTntGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 289
    Caption = 'Connection'
    TabOrder = 0
    DesignSize = (
      249
      289)
    object lblComPort: TTntLabel
      Left = 8
      Top = 120
      Width = 48
      Height = 13
      Caption = 'COM port:'
    end
    object lblBaudRate: TTntLabel
      Left = 8
      Top = 144
      Width = 46
      Height = 13
      Caption = 'Baudrate:'
    end
    object lblByteTimeout: TTntLabel
      Left = 8
      Top = 168
      Width = 80
      Height = 13
      Caption = 'Byte timeout, ms:'
    end
    object lblMaxRetryCount: TTntLabel
      Left = 8
      Top = 192
      Width = 74
      Height = 13
      Caption = 'Connect retries:'
    end
    object lblConnectionType: TTntLabel
      Left = 8
      Top = 24
      Width = 80
      Height = 13
      Caption = 'Connection type:'
    end
    object lblRemoteHost: TTntLabel
      Left = 8
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Host:'
    end
    object lblRemotePort: TTntLabel
      Left = 8
      Top = 96
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object lblPrinterProtocol: TTntLabel
      Left = 8
      Top = 48
      Width = 65
      Height = 13
      Caption = 'Protocol type:'
    end
    object cbComPort: TTntComboBox
      Left = 112
      Top = 120
      Width = 129
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 4
    end
    object cbBaudRate: TTntComboBox
      Left = 112
      Top = 144
      Width = 129
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 5
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
      Top = 248
      Width = 233
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Find device on all available COM ports'
      TabOrder = 8
    end
    object chbSearchByBaudRate: TTntCheckBox
      Left = 8
      Top = 224
      Width = 233
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Find device on all available baud rates'
      TabOrder = 7
    end
    object cbConnectionType: TTntComboBox
      Left = 112
      Top = 24
      Width = 129
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Local'
        'DCOM'
        'TCP'
        'SOCKET')
    end
    object edtRemoteHost: TTntEdit
      Left = 112
      Top = 72
      Width = 129
      Height = 21
      TabOrder = 2
      Text = 'edtRemoteHost'
    end
    object seRemotePort: TSpinEdit
      Left = 112
      Top = 96
      Width = 129
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object seByteTimeout: TSpinEdit
      Left = 112
      Top = 168
      Width = 129
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 6
      Value = 0
    end
    object cbPrinterProtocol: TTntComboBox
      Left = 112
      Top = 48
      Width = 129
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Standard'
        'Protocol 2.0')
    end
    object cbMaxRetryCount: TTntComboBox
      Left = 112
      Top = 192
      Width = 129
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 9
      Items.Strings = (
        'INFINITE'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10')
    end
  end
  object gbPassword: TTntGroupBox
    Left = 264
    Top = 184
    Width = 225
    Height = 73
    Caption = 'Passwords'
    TabOrder = 1
    object lblUsrPassword: TTntLabel
      Left = 8
      Top = 20
      Width = 92
      Height = 13
      Caption = 'Operator password:'
    end
    object lblSysPassword: TTntLabel
      Left = 8
      Top = 44
      Width = 111
      Height = 13
      Caption = 'Administrator password:'
    end
    object seUsrPassword: TSpinEdit
      Left = 136
      Top = 19
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object seSysPassword: TSpinEdit
      Left = 136
      Top = 43
      Width = 81
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
  object cbStorage: TTntComboBox
    Left = 120
    Top = 304
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'Registry'
      'Ini file'
      'Registry IBT')
  end
  object GroupBox1: TTntGroupBox
    Left = 264
    Top = 8
    Width = 225
    Height = 169
    Caption = 'Polling'
    TabOrder = 3
    DesignSize = (
      225
      169)
    object lblPropertyUpdateMode: TTntLabel
      Left = 8
      Top = 32
      Width = 79
      Height = 13
      Caption = 'Properties mode:'
    end
    object lblPollInterval: TTntLabel
      Left = 8
      Top = 56
      Width = 80
      Height = 13
      Caption = 'Poll interval, sec:'
    end
    object lblStatusInterval: TTntLabel
      Left = 8
      Top = 80
      Width = 89
      Height = 13
      Caption = 'Status interval, ms:'
    end
    object lblStatusTimeout: TTntLabel
      Left = 8
      Top = 104
      Width = 90
      Height = 13
      Caption = 'Status timeout, sec'
    end
    object lblEventsType: TTntLabel
      Left = 8
      Top = 128
      Width = 59
      Height = 13
      Caption = 'Events type:'
    end
    object cbPropertyUpdateMode: TTntComboBox
      Left = 104
      Top = 32
      Width = 113
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'None'
        'Polling'
        'Query')
    end
    object sePollInterval: TSpinEdit
      Left = 104
      Top = 56
      Width = 113
      Height = 22
      MaxValue = 60
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object seStatusInterval: TSpinEdit
      Left = 104
      Top = 80
      Width = 113
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object seStatusTimeout: TSpinEdit
      Left = 104
      Top = 104
      Width = 113
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object cbCCOType: TTntComboBox
      Left = 104
      Top = 128
      Width = 113
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        'RCS CCO (default)'
        'NCR CCO'
        'NONE')
    end
  end
  object cbModel: TTntComboBox
    Left = 320
    Top = 264
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
end
