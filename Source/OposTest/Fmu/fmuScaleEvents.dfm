object fmScaleEvents: TfmScaleEvents
  Left = 321
  Top = 327
  Width = 375
  Height = 233
  Caption = 'Scale events'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    367
    206)
  PixelsPerInch = 96
  TextHeight = 13
  object memEvents: TTntMemo
    Left = 8
    Top = 8
    Width = 353
    Height = 161
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
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
