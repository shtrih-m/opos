object fmTankReport: TfmTankReport
  Left = 304
  Top = 167
  AutoScroll = False
  Caption = 'Tank report'
  ClientHeight = 344
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    408
    344)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTankReport: TTntLabel
    Left = 4
    Top = 7
    Width = 58
    Height = 13
    Caption = 'Tank report:'
  end
  object memTankReport: TTntMemo
    Left = 3
    Top = 24
    Width = 403
    Height = 281
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnSetDefaults: TTntButton
    Left = 248
    Top = 312
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Defaults'
    TabOrder = 1
    OnClick = btnSetDefaultsClick
  end
  object btnPrint: TTntButton
    Left = 328
    Top = 312
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Print'
    TabOrder = 2
    OnClick = btnPrintClick
  end
end
