object fmFptrTest2: TfmFptrTest2
  Left = 561
  Top = 219
  Width = 385
  Height = 340
  ActiveControl = btnStart
  Caption = 'Thread test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    369
    302)
  PixelsPerInch = 96
  TextHeight = 13
  object lblErrorCount_: TTntLabel
    Left = 8
    Top = 88
    Width = 55
    Height = 13
    Caption = 'Error count:'
  end
  object lblErrorCount: TTntLabel
    Left = 104
    Top = 88
    Width = 6
    Height = 13
    Caption = '0'
  end
  object lblDeviceName: TTntLabel
    Left = 8
    Top = 8
    Width = 97
    Height = 13
    Caption = 'Fiscal printer device:'
  end
  object lblPrinterTestCount_: TTntLabel
    Left = 8
    Top = 64
    Width = 83
    Height = 13
    Caption = 'Printer test count:'
  end
  object lblPrinterTestCount: TTntLabel
    Left = 104
    Top = 64
    Width = 6
    Height = 13
    Caption = '0'
  end
  object btnStart: TTntButton
    Left = 289
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start'
    TabOrder = 2
    OnClick = btnStartClick
  end
  object chbStopOnError: TTntCheckBox
    Left = 8
    Top = 40
    Width = 233
    Height = 17
    Caption = 'Stop on error'
    TabOrder = 0
  end
  object btnStop: TTntButton
    Left = 289
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 3
    OnClick = btnStopClick
  end
  object memMessages: TTntMemo
    Left = 8
    Top = 112
    Width = 274
    Height = 185
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object cbPrinterDeviceName: TTntComboBox
    Left = 112
    Top = 8
    Width = 170
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 4
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 248
    Top = 112
  end
end
