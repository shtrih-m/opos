object fmFptrUnipos: TfmFptrUnipos
  Left = 448
  Top = 167
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Unipos'
  ClientHeight = 597
  ClientWidth = 479
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
  object gbUniposFilter: TTntGroupBox
    Left = 0
    Top = 0
    Width = 473
    Height = 129
    Caption = 'Unipos filter'
    TabOrder = 0
    object lblUniposTrailerFont: TTntLabel
      Left = 32
      Top = 80
      Width = 91
      Height = 13
      Caption = 'Trailer font number:'
    end
    object lblUniposHeaderFont: TTntLabel
      Left = 32
      Top = 52
      Width = 97
      Height = 13
      Caption = 'Header font number:'
    end
    object cbUniposTrailerFont: TTntComboBox
      Left = 144
      Top = 80
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = PageChange
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
    object cbUniposHeaderFont: TTntComboBox
      Left = 144
      Top = 48
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = PageChange
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
    object chbUniposFilterEnabled: TTntCheckBox
      Left = 16
      Top = 24
      Width = 121
      Height = 17
      Caption = 'Unipos filter enabled'
      TabOrder = 0
    end
  end
  object gbUniposPrinter: TTntGroupBox
    Left = 0
    Top = 136
    Width = 473
    Height = 145
    Caption = 'Unipos printer'
    TabOrder = 1
    object lblUniposTextFont: TTntLabel
      Left = 40
      Top = 52
      Width = 83
      Height = 13
      Caption = 'Text font number:'
    end
    object lblUniposPollPeriod: TTntLabel
      Left = 40
      Top = 80
      Width = 70
      Height = 13
      Caption = 'File poll period:'
    end
    object Label1: TTntLabel
      Left = 40
      Top = 112
      Width = 48
      Height = 13
      Caption = 'Files path:'
    end
    object cbUniposTextFont: TTntComboBox
      Left = 144
      Top = 48
      Width = 81
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = PageChange
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
    object edtUniposPollPeriod: TTntEdit
      Left = 144
      Top = 80
      Width = 65
      Height = 21
      TabOrder = 2
      Text = '0'
    end
    object udUniposPollPeriod: TUpDown
      Left = 209
      Top = 80
      Width = 16
      Height = 21
      Associate = edtUniposPollPeriod
      Max = 32767
      TabOrder = 3
    end
    object chbUniposPrinterEnabled: TTntCheckBox
      Left = 16
      Top = 24
      Width = 225
      Height = 17
      Caption = 'Unipos printer enabled'
      TabOrder = 0
    end
    object edtUniposFilesPath: TTntEdit
      Left = 144
      Top = 112
      Width = 313
      Height = 21
      TabOrder = 4
      Text = 'edtUniposFilesPath'
    end
  end
  object gbAntiFroudFilter: TTntGroupBox
    Left = 0
    Top = 288
    Width = 473
    Height = 241
    Caption = 'Anti froud filter'
    TabOrder = 2
    object lblUniposUniqueItemPrefix: TTntLabel
      Left = 16
      Top = 48
      Width = 87
      Height = 13
      Caption = 'Unique item prefix:'
    end
    object lblUniposSalesErrorText: TTntLabel
      Left = 16
      Top = 80
      Width = 108
      Height = 13
      Caption = 'Sales receipt error text:'
    end
    object lblUniposRefundErrorText: TTntLabel
      Left = 16
      Top = 160
      Width = 117
      Height = 13
      Caption = 'Refund receipt error text:'
    end
    object chbAntiFroudFilterEnabled: TTntCheckBox
      Left = 16
      Top = 24
      Width = 297
      Height = 17
      Caption = 'Unipos anti froud filter enabled'
      TabOrder = 0
    end
    object edtUniposUniqueItemPrefix: TTntEdit
      Left = 120
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '+++'
    end
    object memUniposSalesErrorText: TTntMemo
      Left = 16
      Top = 96
      Width = 441
      Height = 57
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object memUniposRefundErrorText: TTntMemo
      Left = 16
      Top = 176
      Width = 441
      Height = 57
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
end
