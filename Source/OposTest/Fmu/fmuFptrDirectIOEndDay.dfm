object fmFptrDirectIOEndDay: TfmFptrDirectIOEndDay
  Left = 425
  Top = 292
  AutoScroll = False
  Caption = 'DirectIO End day'
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
  object lblResult: TTntLabel
    Left = 8
    Top = 16
    Width = 33
    Height = 13
    Caption = 'Result:'
  end
  object btnExecute: TTntButton
    Left = 290
    Top = 48
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 1
    OnClick = btnExecuteClick
  end
  object edtResult: TTntEdit
    Left = 64
    Top = 16
    Width = 323
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
end
