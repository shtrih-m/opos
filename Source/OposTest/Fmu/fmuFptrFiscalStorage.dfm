object fmFptrFiscalStorage: TfmFptrFiscalStorage
  Left = 591
  Top = 181
  AutoScroll = False
  Caption = 'Fiscal storage'
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
  object lblAdditionalHeader: TTntLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Parameters:'
  end
  object memParameters: TTntMemo
    Left = 8
    Top = 24
    Width = 377
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object btnReadParams: TTntButton
    Left = 256
    Top = 240
    Width = 131
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Read parameters'
    TabOrder = 1
    OnClick = btnReadParamsClick
  end
end
