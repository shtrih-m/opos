object fmFptrRecItemAdjust: TfmFptrRecItemAdjust
  Left = 361
  Top = 420
  AutoScroll = False
  Caption = 'PrintRecItemAdjustment'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDescription: TTntLabel
    Left = 8
    Top = 32
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblAdjustmentType: TTntLabel
    Left = 8
    Top = 56
    Width = 79
    Height = 13
    Caption = 'AdjustmentType:'
  end
  object lblAmount: TTntLabel
    Left = 8
    Top = 104
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object lblVatInfo: TTntLabel
    Left = 8
    Top = 128
    Width = 37
    Height = 13
    Caption = 'VatInfo:'
  end
  object lblPreLine: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object Label1: TTntLabel
    Left = 8
    Top = 80
    Width = 79
    Height = 13
    Caption = 'AdjustmentType:'
  end
  object btnExecute: TTntButton
    Left = 240
    Top = 160
    Width = 145
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecItemAdjustment'
    TabOrder = 6
    OnClick = btnExecuteClick
  end
  object edtDescription: TTntEdit
    Left = 96
    Top = 32
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'printRecItemAdjustment'
  end
  object edtAdjustmentType: TTntEdit
    Left = 96
    Top = 56
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '1'
  end
  object edtAmount: TTntEdit
    Left = 96
    Top = 104
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '100'
  end
  object edtVatInfo: TTntEdit
    Left = 96
    Top = 128
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = '0'
  end
  object edtPreLine: TTntEdit
    Left = 96
    Top = 8
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'PreLine'
  end
  object cbAdjustmentType: TTntComboBox
    Left = 96
    Top = 80
    Width = 289
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbAdjustmentTypeChange
    Items.Strings = (
      'FPTR_AT_AMOUNT_DISCOUNT'
      'FPTR_AT_AMOUNT_SURCHARGE'
      'FPTR_AT_PERCENTAGE_DISCOUNT'
      'FPTR_AT_PERCENTAGE_SURCHARGE')
  end
end
