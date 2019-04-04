object fmFptrBarcode: TfmFptrBarcode
  Left = 607
  Top = 124
  Width = 312
  Height = 445
  Caption = 'Barcode'
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
  object lblBarLinePrintDelay: TTntLabel
    Left = 8
    Top = 16
    Width = 108
    Height = 13
    Caption = 'Bar line print delay, ms:'
  end
  object lblBarLineByteMode: TTntLabel
    Left = 8
    Top = 48
    Width = 67
    Height = 13
    Caption = 'Bar line mode:'
  end
  object Label1: TTntLabel
    Left = 8
    Top = 80
    Width = 226
    Height = 13
    Caption = 'Bar line is used to print barcodes and separators'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 104
    Width = 273
    Height = 17
    Shape = bsTopLine
  end
  object lblBarcodePrefix: TTntLabel
    Left = 8
    Top = 120
    Width = 71
    Height = 13
    Caption = 'Barcode prefix:'
  end
  object lblBarcodeHeight: TTntLabel
    Left = 8
    Top = 152
    Width = 75
    Height = 13
    Caption = 'Barcode height:'
  end
  object lblBarcodeType: TTntLabel
    Left = 8
    Top = 184
    Width = 66
    Height = 13
    Caption = 'Barcode type:'
  end
  object lblBarcodeModuleWidth: TTntLabel
    Left = 8
    Top = 216
    Width = 108
    Height = 13
    Caption = 'Barcode module width:'
  end
  object lblBarcodeAlignment: TTntLabel
    Left = 8
    Top = 248
    Width = 91
    Height = 13
    Caption = 'Barcode alignment:'
  end
  object lblBarcodeParameter1: TTntLabel
    Left = 8
    Top = 280
    Width = 102
    Height = 13
    Caption = 'Barcode parameter 1:'
  end
  object lblBarcodeParameter2: TTntLabel
    Left = 8
    Top = 312
    Width = 102
    Height = 13
    Caption = 'Barcode parameter 2:'
  end
  object lblBarcodeParameter3: TTntLabel
    Left = 8
    Top = 344
    Width = 102
    Height = 13
    Caption = 'Barcode parameter 3:'
  end
  object Bevel2: TBevel
    Left = 8
    Top = 376
    Width = 273
    Height = 17
    Shape = bsTopLine
  end
  object cbBarLineByteMode: TTntComboBox
    Left = 152
    Top = 48
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Autoselect'
      'Straight'
      'Reverse')
  end
  object seBarLinePrintDelay: TSpinEdit
    Left = 152
    Top = 16
    Width = 129
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object edtBarcodePrefix: TTntEdit
    Left = 104
    Top = 120
    Width = 177
    Height = 21
    TabOrder = 2
    Text = 'edtBarcodePrefix'
  end
  object seBarcodeHeight: TSpinEdit
    Left = 104
    Top = 152
    Width = 177
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object cbBarcodeType: TTntComboBox
    Left = 104
    Top = 184
    Width = 177
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'Autoselect'
      'Straight'
      'Reverse')
  end
  object seBarcodeModuleWidth: TSpinEdit
    Left = 128
    Top = 216
    Width = 153
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object cbBarcodeAlignment: TTntComboBox
    Left = 128
    Top = 248
    Width = 153
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'CENTER'
      'LEFT'
      'RIGHT')
  end
  object seBarcodeParameter1: TSpinEdit
    Left = 128
    Top = 280
    Width = 153
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 0
  end
  object seBarcodeParameter2: TSpinEdit
    Left = 128
    Top = 312
    Width = 153
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 8
    Value = 0
  end
  object seBarcodeParameter3: TSpinEdit
    Left = 128
    Top = 344
    Width = 153
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 9
    Value = 0
  end
end
