object fmMiscParams: TfmMiscParams
  Left = 411
  Top = 129
  Width = 391
  Height = 547
  Caption = 'Misc parameters'
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
  object lblMaxReceiptItems: TTntLabel
    Left = 40
    Top = 48
    Width = 85
    Height = 13
    Caption = 'Max receipt items:'
  end
  object lblMonitoringPort: TTntLabel
    Left = 40
    Top = 192
    Width = 105
    Height = 13
    Caption = 'Monitoring server port:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 224
    Width = 361
    Height = 25
    Shape = bsTopLine
  end
  object lblAmountDecimalPlaces: TTntLabel
    Left = 8
    Top = 240
    Width = 166
    Height = 13
    Caption = 'Application amount decimal places:'
  end
  object Bevel2: TBevel
    Left = 7
    Top = 272
    Width = 361
    Height = 25
    Shape = bsTopLine
  end
  object lblCapRecNearEndSensorMode: TTntLabel
    Left = 8
    Top = 288
    Width = 146
    Height = 13
    Caption = 'CapRecNearEndSensor mode:'
  end
  object Bevel3: TBevel
    Left = 6
    Top = 344
    Width = 361
    Height = 25
    Shape = bsTopLine
  end
  object lblTimeUpdateMode: TTntLabel
    Left = 8
    Top = 360
    Width = 91
    Height = 13
    Caption = 'Time update mode:'
  end
  object lblDocumentBlockSize: TTntLabel
    Left = 32
    Top = 424
    Width = 102
    Height = 13
    Caption = 'Document block size:'
  end
  object chbVoidReceiptOnMaxItems: TTntCheckBox
    Left = 16
    Top = 16
    Width = 273
    Height = 17
    Caption = 'Cancel receipt after maximum receipt items'
    TabOrder = 0
  end
  object seMaxReceiptItems: TSpinEdit
    Left = 144
    Top = 48
    Width = 169
    Height = 22
    MaxValue = 1000
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
  object chbPrintRecSubtotal: TTntCheckBox
    Left = 16
    Top = 96
    Width = 273
    Height = 17
    Caption = 'PrintRecSubtotal method enabled'
    TabOrder = 2
  end
  object seMonitoringPort: TSpinEdit
    Left = 160
    Top = 192
    Width = 153
    Height = 22
    MaxValue = 65535
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object chbDepartmentInText: TTntCheckBox
    Left = 16
    Top = 128
    Width = 297
    Height = 17
    Caption = 'Department number is 2 first chars of text'
    TabOrder = 3
  end
  object chbMonitoringEnabled: TTntCheckBox
    Left = 16
    Top = 160
    Width = 297
    Height = 17
    Caption = 'Monitoring enabled'
    TabOrder = 4
  end
  object cbAmountDecimalPlaces: TTntComboBox
    Left = 192
    Top = 240
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      '0'
      '2'
      'As in fiscal printer')
  end
  object cbCapRecNearEndSensorMode: TTntComboBox
    Left = 192
    Top = 288
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Items.Strings = (
      'AUTO'
      'TRUE'
      'FALSE')
  end
  object chbWrapText: TTntCheckBox
    Left = 8
    Top = 320
    Width = 97
    Height = 17
    Caption = 'Wrap text'
    TabOrder = 8
  end
  object cbTimeUpdateMode: TTntComboBox
    Left = 112
    Top = 360
    Width = 255
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      'Normal'
      'When fiscal day is opened'
      'When fiscal day is opened without cancel')
  end
  object chbFSServiceEnabled: TTntCheckBox
    Left = 8
    Top = 400
    Width = 321
    Height = 17
    Caption = 'Fiscal storage service enabled'
    TabOrder = 10
  end
  object chbPingEnabled: TTntCheckBox
    Left = 8
    Top = 456
    Width = 209
    Height = 17
    Caption = 'PING device enabled'
    TabOrder = 12
  end
  object seDocumentBlockSize: TSpinEdit
    Left = 152
    Top = 424
    Width = 105
    Height = 22
    MaxLength = 10
    MaxValue = 151
    MinValue = 0
    TabOrder = 11
    Value = 0
  end
  object btnSetMaxDocumentBlockSize: TTntButton
    Left = 264
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Max value'
    TabOrder = 13
    OnClick = btnSetMaxDocumentBlockSizeClick
  end
end
