object fmFptrText: TfmFptrText
  Left = 532
  Top = 260
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Text'
  ClientHeight = 367
  ClientWidth = 494
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
  object lblQuantityLength: TTntLabel
    Left = 16
    Top = 168
    Width = 186
    Height = 13
    Caption = '"QUANTITY X PRICE" field size, 0..56:'
  end
  object lblRFAmountLength: TTntLabel
    Left = 16
    Top = 200
    Width = 133
    Height = 13
    Caption = '"AMOUNT" field size, 0..56:'
  end
  object lblRFSeparatorLine: TTntLabel
    Left = 16
    Top = 232
    Width = 68
    Height = 13
    Caption = 'Separator line:'
  end
  object gbTextParameters: TTntGroupBox
    Left = 8
    Top = 8
    Width = 473
    Height = 137
    Caption = 'Text parameters'
    TabOrder = 0
    DesignSize = (
      473
      137)
    object lblFontNumber: TTntLabel
      Left = 8
      Top = 28
      Width = 62
      Height = 13
      Caption = 'Font number:'
    end
    object lblCloseRecText: TTntLabel
      Left = 8
      Top = 76
      Width = 84
      Height = 13
      Caption = 'Close receipt text:'
    end
    object lblSubtotalName: TTntLabel
      Left = 8
      Top = 52
      Width = 62
      Height = 13
      Caption = 'Subtotal text:'
    end
    object lblVoidRecText: TTntLabel
      Left = 8
      Top = 100
      Width = 79
      Height = 13
      Caption = 'Void receipt text:'
    end
    object edtSubtotalName: TTntEdit
      Left = 104
      Top = 48
      Width = 361
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 40
      TabOrder = 1
      OnChange = PageChange
    end
    object edtCloseRecText: TTntEdit
      Left = 104
      Top = 72
      Width = 361
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      MaxLength = 40
      TabOrder = 2
      OnChange = PageChange
    end
    object edtVoidRecText: TTntEdit
      Left = 104
      Top = 96
      Width = 361
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnChange = PageChange
    end
    object seFontNumber: TSpinEdit
      Left = 104
      Top = 24
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
  end
  object seRFQuantityLength: TSpinEdit
    Left = 216
    Top = 168
    Width = 121
    Height = 22
    MaxValue = 56
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object seRFAmountLength: TSpinEdit
    Left = 216
    Top = 200
    Width = 121
    Height = 22
    MaxValue = 56
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object chbRFShowTaxLetters: TTntCheckBox
    Left = 16
    Top = 256
    Width = 185
    Height = 17
    Caption = 'Show tax letters'
    TabOrder = 4
  end
  object cbRFSeparatorLine: TTntComboBox
    Left = 216
    Top = 232
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'None'
      'Dashed line'
      'Solid line')
  end
end
