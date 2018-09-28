object fmFptrReceipt: TfmFptrReceipt
  Left = 689
  Top = 154
  Width = 512
  Height = 498
  Caption = 'Receipt'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object gbParams: TTntGroupBox
    Left = 8
    Top = 8
    Width = 481
    Height = 417
    TabOrder = 0
    DesignSize = (
      481
      417)
    object lblDefaultDepartment: TTntLabel
      Left = 8
      Top = 16
      Width = 79
      Height = 13
      Caption = 'Def. department:'
    end
    object lblCutType: TTntLabel
      Left = 8
      Top = 40
      Width = 42
      Height = 13
      Caption = 'Cut type:'
    end
    object lblEncoding: TTntLabel
      Left = 8
      Top = 64
      Width = 48
      Height = 13
      Caption = 'Encoding:'
    end
    object lblStatusCommand: TTntLabel
      Left = 8
      Top = 88
      Width = 82
      Height = 13
      Caption = 'Status command:'
    end
    object lblHeaderType: TTntLabel
      Left = 8
      Top = 112
      Width = 61
      Height = 13
      Caption = 'Header type:'
    end
    object lblZeroReceipt: TTntLabel
      Left = 8
      Top = 184
      Width = 60
      Height = 13
      Caption = 'Zero receipt:'
    end
    object lblCompatLevel: TTntLabel
      Left = 8
      Top = 136
      Width = 61
      Height = 13
      Caption = 'Compatibility:'
    end
    object lblReceiptType: TTntLabel
      Left = 8
      Top = 160
      Width = 63
      Height = 13
      Caption = 'Receipt type:'
    end
    object lblZeroReceiptNumber: TTntLabel
      Left = 8
      Top = 208
      Width = 98
      Height = 13
      Caption = 'Zero receipt number:'
    end
    object lblQuantityLength: TTntLabel
      Left = 8
      Top = 232
      Width = 74
      Height = 13
      Caption = 'Quantity length:'
    end
    object lblPrintRecMessageMode: TTntLabel
      Left = 8
      Top = 256
      Width = 116
      Height = 13
      Caption = 'PrintRecMessage mode:'
    end
    object lblDiscountMode: TTntLabel
      Left = 8
      Top = 280
      Width = 74
      Height = 13
      Caption = 'Discount mode:'
    end
    object cbCutType: TTntComboBox
      Left = 136
      Top = 40
      Width = 337
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
    object cbEncoding: TTntComboBox
      Left = 136
      Top = 64
      Width = 337
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'Windows'
        'CP866')
    end
    object cbStatusCommand: TTntComboBox
      Left = 136
      Top = 88
      Width = 337
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
    object cbHeaderType: TTntComboBox
      Left = 136
      Top = 112
      Width = 337
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
    object cbZeroReceipt: TTntComboBox
      Left = 136
      Top = 184
      Width = 337
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 7
      Items.Strings = (
        'Normal'
        'Nonfiscal')
    end
    object cbCompatLevel: TTntComboBox
      Left = 136
      Top = 136
      Width = 337
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
    object cbReceiptType: TTntComboBox
      Left = 136
      Top = 160
      Width = 337
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
    object chbCacheReceiptNumber: TTntCheckBox
      Left = 8
      Top = 320
      Width = 201
      Height = 17
      Caption = 'Cache receipt number'
      TabOrder = 10
    end
    object seDepartment: TSpinEdit
      Left = 136
      Top = 16
      Width = 337
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object seZeroReceiptNumber: TSpinEdit
      Left = 136
      Top = 208
      Width = 97
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 8
      Value = 0
    end
    object chbZReceiptBeforeZReport: TTntCheckBox
      Left = 8
      Top = 344
      Width = 214
      Height = 17
      Caption = 'Zero receipt before Z report (day closed)'
      TabOrder = 11
    end
    object chbOpenReceiptEnabled: TTntCheckBox
      Left = 8
      Top = 368
      Width = 214
      Height = 17
      Caption = 'Open receipt in beginFiscalReceipt'
      TabOrder = 12
    end
    object cbQuantityDecimalPlaces: TTntComboBox
      Left = 136
      Top = 232
      Width = 337
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 9
      Items.Strings = (
        '3 digits'
        '6 digits')
    end
    object cbPrintRecMessageMode: TTntComboBox
      Left = 136
      Top = 256
      Width = 337
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 13
      Items.Strings = (
        '1. Normal - after receipt ending'
        '2. Before receipt ending')
    end
    object cbDiscountMode: TTntComboBox
      Left = 136
      Top = 280
      Width = 337
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 14
      Items.Strings = (
        '0 - Discount has effect on price and amount'
        '1 - Discount has no effect ')
    end
  end
end
