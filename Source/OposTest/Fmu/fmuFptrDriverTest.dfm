object fmFptrDriverTest: TfmFptrDriverTest
  Left = 339
  Top = 172
  AutoScroll = False
  Caption = 'Driver tests'
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
  object btnDayOpenedTest: TTntButton
    Left = 304
    Top = 240
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 1
    OnClick = btnDayOpenedTestClick
  end
  object Memo: TTntMemo
    Left = 168
    Top = 8
    Width = 221
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object ListBox: TTntListBox
    Left = 8
    Top = 8
    Width = 153
    Height = 225
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    TabOrder = 2
  end
end
