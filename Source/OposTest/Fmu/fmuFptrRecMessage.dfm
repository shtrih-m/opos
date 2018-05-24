object fmFptrRecMessage: TfmFptrRecMessage
  Left = 408
  Top = 231
  AutoScroll = False
  Caption = 'PrintRecMessage'
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
  object lblMessage: TTntLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 13
    Caption = 'Message:'
  end
  object btnExecute: TTntButton
    Left = 240
    Top = 40
    Width = 145
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecMessage'
    TabOrder = 1
    OnClick = btnExecuteClick
  end
  object edtMessage: TTntEdit
    Left = 72
    Top = 8
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'printRecMessage'
  end
end
