object fmFptrProperties: TfmFptrProperties
  Left = 389
  Top = 247
  AutoScroll = False
  Caption = 'Properties'
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
  object btnRefresh: TTntButton
    Left = 304
    Top = 240
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Refresh'
    TabOrder = 0
    OnClick = btnRefreshClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 8
    Width = 377
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
end
