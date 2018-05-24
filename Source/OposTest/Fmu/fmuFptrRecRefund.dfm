object fmFptrRecRefund: TfmFptrRecRefund
  Left = 412
  Top = 395
  AutoScroll = False
  Caption = 'PrintRecRefund'
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
  object lblAmount: TTntLabel
    Left = 8
    Top = 56
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object lblVatInfo: TTntLabel
    Left = 8
    Top = 80
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
  object btnExecute: TTntButton
    Left = 240
    Top = 112
    Width = 145
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecRefund'
    TabOrder = 4
    OnClick = btnExecuteClick
  end
  object edtDescription: TTntEdit
    Left = 72
    Top = 32
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'printRecRefund'
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
  object edtVatInfo: TTntEdit
    Left = 72
    Top = 80
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '0'
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
end
