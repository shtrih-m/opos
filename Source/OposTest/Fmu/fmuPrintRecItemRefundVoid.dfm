object fmPrintRecItemRefundVoid: TfmPrintRecItemRefundVoid
  Left = 469
  Top = 258
  AutoScroll = False
  Caption = 'PrintRecItemRefundVoid'
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
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblAmount: TTntLabel
    Left = 8
    Top = 32
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object lblQuantity: TTntLabel
    Left = 8
    Top = 56
    Width = 42
    Height = 13
    Caption = 'Quantity:'
  end
  object lblVatInfo: TTntLabel
    Left = 8
    Top = 80
    Width = 37
    Height = 13
    Caption = 'VatInfo:'
  end
  object lblUnitAmount: TTntLabel
    Left = 8
    Top = 104
    Width = 58
    Height = 13
    Caption = 'UnitAmount:'
  end
  object lblUnitName: TTntLabel
    Left = 8
    Top = 128
    Width = 50
    Height = 13
    Caption = 'UnitName:'
  end
  object btnExecute: TTntButton
    Left = 248
    Top = 160
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecItemRefundVoid'
    TabOrder = 6
    OnClick = btnExecuteClick
  end
  object edtDescription: TTntEdit
    Left = 96
    Top = 8
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'Method printRecItemRefundVoid'
  end
  object edtAmount: TTntEdit
    Left = 96
    Top = 32
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '100'
  end
  object edtQuantity: TTntEdit
    Left = 96
    Top = 56
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '1000'
  end
  object edtVatInfo: TTntEdit
    Left = 96
    Top = 80
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '0'
  end
  object edtUnitAmount: TTntEdit
    Left = 96
    Top = 104
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '0'
  end
  object edtUnitName: TTntEdit
    Left = 96
    Top = 128
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = 'kg'
  end
end
