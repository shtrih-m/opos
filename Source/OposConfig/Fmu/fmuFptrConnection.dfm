object fmFptrConnection: TfmFptrConnection
  Left = 375
  Top = 200
  Width = 512
  Height = 498
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
  object lblStorage: TLabel
    Left = 16
    Top = 384
    Width = 94
    Height = 13
    Caption = 'Parameters storage:'
  end
  object gbConenctionParams: TGroupBox
    Left = 8
    Top = 8
    Width = 249
    Height = 369
    TabOrder = 0
    DesignSize = (
      249
      369)
    object lblComPort: TLabel
      Left = 8
      Top = 112
      Width = 48
      Height = 13
      Caption = 'COM port:'
    end
    object lblBaudRate: TLabel
      Left = 8
      Top = 136
      Width = 46
      Height = 13
      Caption = 'Baudrate:'
    end
    object lblByteTimeout: TLabel
      Left = 8
      Top = 160
      Width = 80
      Height = 13
      Caption = 'Byte timeout, ms:'
    end
    object lblMaxRetryCount: TLabel
      Left = 8
      Top = 184
      Width = 120
      Height = 13
      Caption = 'Maximum connect retries:'
    end
    object lblConnectionType: TLabel
      Left = 8
      Top = 16
      Width = 80
      Height = 13
      Caption = 'Connection type:'
    end
    object lblRemoteHost: TLabel
      Left = 8
      Top = 64
      Width = 25
      Height = 13
      Caption = 'Host:'
    end
    object lblRemotePort: TLabel
      Left = 8
      Top = 88
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object lblPollInterval: TLabel
      Left = 8
      Top = 288
      Width = 117
      Height = 13
      Caption = 'Polling interval, seconds:'
    end
    object lblStatusInterval: TLabel
      Left = 8
      Top = 312
      Width = 118
      Height = 13
      Caption = 'Status query interval, ms:'
    end
    object lblStatusTimeout: TLabel
      Left = 8
      Top = 336
      Width = 113
      Height = 13
      Caption = 'Status timeout, seconds'
    end
    object lblPropertyUpdateMode: TLabel
      Left = 8
      Top = 264
      Width = 115
      Height = 13
      Caption = 'Properties update mode:'
    end
    object lblPrinterProtocol: TLabel
      Left = 8
      Top = 40
      Width = 65
      Height = 13
      Caption = 'Protocol type:'
    end
    object cbComPort: TComboBox
      Left = 112
      Top = 112
      Width = 129
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 4
    end
    object cbBaudRate: TComboBox
      Left = 112
      Top = 136
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
    object chbSearchByPort: TCheckBox
      Left = 8
      Top = 240
      Width = 233
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Find device on all available COM ports'
      TabOrder = 9
    end
    object chbSearchByBaudRate: TCheckBox
      Left = 8
      Top = 216
      Width = 233
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Find device on all available baud rates'
      TabOrder = 8
    end
    object cbConnectionType: TComboBox
      Left = 112
      Top = 16
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
    object edtRemoteHost: TEdit
      Left = 112
      Top = 64
      Width = 129
      Height = 21
      TabOrder = 2
      Text = 'edtRemoteHost'
    end
    object seRemotePort: TSpinEdit
      Left = 112
      Top = 88
      Width = 129
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 0
    end
    object seByteTimeout: TSpinEdit
      Left = 112
      Top = 160
      Width = 129
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 6
      Value = 0
    end
    object seMaxRetryCount: TSpinEdit
      Left = 136
      Top = 185
      Width = 105
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 7
      Value = 0
    end
    object sePollInterval: TSpinEdit
      Left = 136
      Top = 288
      Width = 105
      Height = 22
      MaxValue = 60
      MinValue = 1
      TabOrder = 11
      Value = 1
    end
    object seStatusInterval: TSpinEdit
      Left = 136
      Top = 312
      Width = 105
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 12
      Value = 0
    end
    object seStatusTimeout: TSpinEdit
      Left = 136
      Top = 336
      Width = 105
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 13
      Value = 0
    end
    object cbPropertyUpdateMode: TComboBox
      Left = 136
      Top = 264
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 10
      Items.Strings = (
        'None'
        'Polling'
        'Query')
    end
    object cbPrinterProtocol: TComboBox
      Left = 112
      Top = 40
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
  end
  object gbParams: TGroupBox
    Left = 264
    Top = 8
    Width = 225
    Height = 329
    TabOrder = 1
    DesignSize = (
      225
      329)
    object lblDefaultDepartment: TLabel
      Left = 8
      Top = 16
      Width = 79
      Height = 13
      Caption = 'Def. department:'
    end
    object lblCutType: TLabel
      Left = 8
      Top = 40
      Width = 42
      Height = 13
      Caption = 'Cut type:'
    end
    object lblEncoding: TLabel
      Left = 8
      Top = 64
      Width = 48
      Height = 13
      Caption = 'Encoding:'
    end
    object lblStatusCommand: TLabel
      Left = 8
      Top = 88
      Width = 82
      Height = 13
      Caption = 'Status command:'
    end
    object lblHeaderType: TLabel
      Left = 8
      Top = 112
      Width = 61
      Height = 13
      Caption = 'Header type:'
    end
    object lblZeroReceipt: TLabel
      Left = 8
      Top = 184
      Width = 60
      Height = 13
      Caption = 'Zero receipt:'
    end
    object lblCompatLevel: TLabel
      Left = 8
      Top = 136
      Width = 61
      Height = 13
      Caption = 'Compatibility:'
    end
    object lblReceiptType: TLabel
      Left = 8
      Top = 160
      Width = 63
      Height = 13
      Caption = 'Receipt type:'
    end
    object lblZeroReceiptNumber: TLabel
      Left = 8
      Top = 208
      Width = 98
      Height = 13
      Caption = 'Zero receipt number:'
    end
    object lblEventsType: TLabel
      Left = 8
      Top = 232
      Width = 59
      Height = 13
      Caption = 'Events type:'
    end
    object cbCutType: TComboBox
      Left = 96
      Top = 40
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Full cut'
        'Partial cut'
        'No cut')
    end
    object cbEncoding: TComboBox
      Left = 96
      Top = 64
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Windows'
        'CP866')
    end
    object cbStatusCommand: TComboBox
      Left = 96
      Top = 88
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'Driver selection'
        'Short status, 10h'
        'Long status, 11h')
    end
    object cbHeaderType: TComboBox
      Left = 96
      Top = 112
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        'Printer header'
        'Driver header'
        'None')
    end
    object cbZeroReceipt: TComboBox
      Left = 96
      Top = 184
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 7
      Items.Strings = (
        'Normal'
        'Nonfiscal')
    end
    object cbCompatLevel: TComboBox
      Left = 96
      Top = 136
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 5
      Items.Strings = (
        'None'
        'Level 1'
        'Level 2')
    end
    object cbReceiptType: TComboBox
      Left = 96
      Top = 160
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 6
      Items.Strings = (
        'Normal receipt'
        'Single position'
        'GLOBUS receipt'
        'GLOBUS text receipt')
    end
    object cbCCOType: TComboBox
      Left = 96
      Top = 232
      Width = 121
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 9
      Items.Strings = (
        'RCS CCO (default)'
        'NCR CCO'
        'NONE')
    end
    object chbCacheReceiptNumber: TCheckBox
      Left = 8
      Top = 256
      Width = 201
      Height = 17
      Caption = 'Cache receipt number'
      TabOrder = 10
    end
    object seDepartment: TSpinEdit
      Left = 96
      Top = 16
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object seZeroReceiptNumber: TSpinEdit
      Left = 120
      Top = 208
      Width = 97
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 8
      Value = 0
    end
    object chbZReceiptBeforeZReport: TCheckBox
      Left = 8
      Top = 280
      Width = 214
      Height = 17
      Caption = 'Zero receipt before Z report (day closed)'
      TabOrder = 11
    end
    object chbOpenReceiptEnabled: TCheckBox
      Left = 8
      Top = 304
      Width = 214
      Height = 17
      Caption = 'Open receipt in beginFiscalReceipt'
      TabOrder = 12
    end
  end
  object gbPassword: TGroupBox
    Left = 264
    Top = 344
    Width = 225
    Height = 73
    Caption = 'Passwords'
    TabOrder = 2
    object lblUsrPassword: TLabel
      Left = 8
      Top = 20
      Width = 92
      Height = 13
      Caption = 'Operator password:'
    end
    object lblSysPassword: TLabel
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
  object cbStorage: TComboBox
    Left = 128
    Top = 384
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'Registry'
      'Ini file'
      'Registry IBT')
  end
end
