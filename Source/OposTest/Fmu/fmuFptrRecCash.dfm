object fmFptrRecCash: TfmFptrRecCash
  Left = 445
  Top = 218
  AutoScroll = False
  Caption = 'PrintRecCash'
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
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object btnPrintRecCash: TTntButton
    Left = 264
    Top = 40
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecCash'
    TabOrder = 1
    OnClick = btnPrintRecCashClick
  end
  object edtAmount: TTntEdit
    Left = 72
    Top = 8
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '100'
  end
end
