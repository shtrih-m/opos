object fmFptrReceiptTest: TfmFptrReceiptTest
  Left = 358
  Top = 219
  AutoScroll = False
  Caption = 'Receipt test'
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
  object btnExecute: TTntButton
    Left = 304
    Top = 8
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 0
    OnClick = btnExecuteClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 40
    Width = 377
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object cbTest: TTntComboBox
    Left = 8
    Top = 8
    Width = 289
    Height = 26
    Style = csOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 20
    ParentFont = False
    TabOrder = 2
  end
end
