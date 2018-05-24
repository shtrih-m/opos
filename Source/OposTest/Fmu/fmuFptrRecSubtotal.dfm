object fmFptrRecSubtotal: TfmFptrRecSubtotal
  Left = 427
  Top = 437
  AutoScroll = False
  Caption = 'PrintRecSubTotal'
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
  object lblAmount: TTntLabel
    Left = 8
    Top = 56
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object lblPreLine: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object lblPostLine: TTntLabel
    Left = 8
    Top = 32
    Width = 44
    Height = 13
    Caption = 'PostLine:'
  end
  object edtAmount: TTntEdit
    Left = 72
    Top = 56
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '100'
  end
  object btnPrintRecSubtotal: TTntButton
    Left = 264
    Top = 88
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecSubtotal'
    TabOrder = 3
    OnClick = btnPrintRecSubtotalClick
  end
  object edtPreLine: TTntEdit
    Left = 72
    Top = 8
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'PreLine'
  end
  object edtPostLine: TTntEdit
    Left = 72
    Top = 32
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'PostLine'
  end
end
