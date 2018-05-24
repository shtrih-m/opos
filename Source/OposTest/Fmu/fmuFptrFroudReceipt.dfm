object fmFptrFroudReceipt: TfmFptrFroudReceipt
  Left = 595
  Top = 227
  AutoScroll = False
  Caption = 'Froud receipt'
  ClientHeight = 232
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    424
    232)
  PixelsPerInch = 96
  TextHeight = 13
  object btnInvalidSalesReceipt: TTntButton
    Left = 168
    Top = 168
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Invalid sales receipt'
    TabOrder = 3
    OnClick = btnInvalidSalesReceiptClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 8
    Width = 409
    Height = 153
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnInvalidRefundReceipt: TTntButton
    Left = 296
    Top = 168
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Invalid refund receipt'
    TabOrder = 5
    OnClick = btnInvalidRefundReceiptClick
  end
  object btnValidSalesReceipt: TTntButton
    Left = 55
    Top = 168
    Width = 106
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Valid sales receipt'
    TabOrder = 1
    OnClick = btnValidSalesReceiptClick
  end
  object btnInvalidRefundReceipt2: TTntButton
    Left = 296
    Top = 200
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Invalid refund receipt 2'
    TabOrder = 6
    OnClick = btnInvalidRefundReceipt2Click
  end
  object btnValidRefundReceipt: TTntButton
    Left = 55
    Top = 200
    Width = 106
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Valid refund receipt'
    TabOrder = 2
    OnClick = btnValidRefundReceiptClick
  end
  object btnInvalidSalesReceipt2: TTntButton
    Left = 168
    Top = 200
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Invalid sales receipt 2'
    TabOrder = 4
    OnClick = btnInvalidSalesReceipt2Click
  end
end
