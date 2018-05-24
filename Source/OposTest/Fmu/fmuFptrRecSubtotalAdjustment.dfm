object fmFptrRecSubtotalAdjustment: TfmFptrRecSubtotalAdjustment
  Left = 379
  Top = 335
  AutoScroll = False
  Caption = 'PrintRecSubtotalAdjustment'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
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
  object lblAmount: TTntLabel
    Left = 8
    Top = 80
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object Label1: TTntLabel
    Left = 8
    Top = 56
    Width = 79
    Height = 13
    Caption = 'AdjustmentType:'
  end
  object lblPreLine: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object btnExecute: TTntButton
    Left = 224
    Top = 112
    Width = 161
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecSubtotalAdjustment'
    TabOrder = 4
    OnClick = btnExecuteClick
  end
  object edtDescription: TTntEdit
    Left = 96
    Top = 32
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'printRecSubtotalAdjustment'
  end
  object edtAmount: TTntEdit
    Left = 96
    Top = 80
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '0'
  end
  object cbAdjustmentType: TTntComboBox
    Left = 96
    Top = 56
    Width = 289
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'FPTR_AT_AMOUNT_DISCOUNT'
      'FPTR_AT_AMOUNT_SURCHARGE'
      'FPTR_AT_PERCENTAGE_DISCOUNT'
      'FPTR_AT_PERCENTAGE_SURCHARGE')
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
end
