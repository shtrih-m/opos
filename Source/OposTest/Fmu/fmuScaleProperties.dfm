object fmScaleProperties: TfmScaleProperties
  Left = 389
  Top = 247
  Width = 383
  Height = 304
  Caption = 'Properties'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    367
    266)
  PixelsPerInch = 96
  TextHeight = 13
  object btnRefresh: TTntButton
    Left = 288
    Top = 232
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Refresh'
    TabOrder = 0
    OnClick = btnRefreshClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 8
    Width = 353
    Height = 217
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
