object fmFptrEvents: TfmFptrEvents
  Left = 527
  Top = 279
  Width = 375
  Height = 233
  Caption = 'Printer events'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    359
    195)
  PixelsPerInch = 96
  TextHeight = 13
  object memEvents: TTntMemo
    Left = 8
    Top = 8
    Width = 353
    Height = 161
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
  object btnClear: TTntButton
    Left = 288
    Top = 176
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 1
    OnClick = btnClearClick
  end
end
