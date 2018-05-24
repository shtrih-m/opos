object fmFptrRecItemVoid: TfmFptrRecItemVoid
  Left = 370
  Top = 343
  AutoScroll = False
  Caption = 'PrintRecItemVoid'
  ClientHeight = 292
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    350
    292)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDescription: TTntLabel
    Left = 8
    Top = 60
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblPrice: TTntLabel
    Left = 8
    Top = 84
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object lblQuantity: TTntLabel
    Left = 8
    Top = 108
    Width = 42
    Height = 13
    Caption = 'Quantity:'
  end
  object lblVatInfo: TTntLabel
    Left = 8
    Top = 132
    Width = 37
    Height = 13
    Caption = 'VatInfo:'
  end
  object lblUnitPrice: TTntLabel
    Left = 8
    Top = 156
    Width = 46
    Height = 13
    Caption = 'UnitPrice:'
  end
  object lblUnitName: TTntLabel
    Left = 8
    Top = 180
    Width = 50
    Height = 13
    Caption = 'UnitName:'
  end
  object lblPreLine: TTntLabel
    Left = 8
    Top = 12
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object lblPostLine: TTntLabel
    Left = 8
    Top = 36
    Width = 44
    Height = 13
    Caption = 'PostLine:'
  end
  object btnExecute: TTntButton
    Left = 224
    Top = 208
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecItemVoid'
    TabOrder = 8
    OnClick = btnExecuteClick
  end
  object edtDescription: TTntEdit
    Left = 96
    Top = 56
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'printRecItemVoid'
  end
  object edtPrice: TTntEdit
    Left = 96
    Top = 80
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '100'
  end
  object edtQuantity: TTntEdit
    Left = 96
    Top = 104
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '1000'
  end
  object edtVatInfo: TTntEdit
    Left = 96
    Top = 128
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = '0'
  end
  object edtUnitPrice: TTntEdit
    Left = 96
    Top = 152
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = '100'
  end
  object edtUnitName: TTntEdit
    Left = 96
    Top = 176
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
    Text = 'kg.'
  end
  object edtPreLine: TTntEdit
    Left = 96
    Top = 8
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'PreLine'
  end
  object edtPostLine: TTntEdit
    Left = 96
    Top = 32
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'PostLine'
  end
end
