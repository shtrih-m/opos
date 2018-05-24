object fmFptrTest: TfmFptrTest
  Left = 408
  Top = 259
  Width = 384
  Height = 340
  ActiveControl = btnStart
  Caption = 'Printer test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    368
    302)
  PixelsPerInch = 96
  TextHeight = 13
  object lblReceiptPeriod: TTntLabel
    Left = 8
    Top = 8
    Width = 118
    Height = 13
    Caption = 'Receipt period, seconds:'
  end
  object lblReceiptsPrinted_: TTntLabel
    Left = 8
    Top = 104
    Width = 80
    Height = 13
    Caption = 'Receipts printed:'
  end
  object lblReceiptsPrinted: TTntLabel
    Left = 104
    Top = 104
    Width = 6
    Height = 13
    Caption = '0'
  end
  object lblErrorCount_: TTntLabel
    Left = 8
    Top = 128
    Width = 55
    Height = 13
    Caption = 'Error count:'
  end
  object lblErrorCount: TTntLabel
    Left = 104
    Top = 128
    Width = 6
    Height = 13
    Caption = '0'
  end
  object lblReceiptItemsCount: TTntLabel
    Left = 8
    Top = 40
    Width = 97
    Height = 13
    Caption = 'Receipt items count:'
  end
  object btnStart: TTntButton
    Left = 288
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start'
    TabOrder = 4
    OnClick = btnStartClick
  end
  object spereceiptPeriod: TSpinEdit
    Left = 144
    Top = 8
    Width = 129
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 5
  end
  object chbStopOnError: TTntCheckBox
    Left = 8
    Top = 72
    Width = 233
    Height = 17
    Caption = 'Stop on error'
    TabOrder = 2
  end
  object btnStop: TTntButton
    Left = 288
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Stop'
    Enabled = False
    TabOrder = 5
    OnClick = btnStopClick
  end
  object memMessages: TTntMemo
    Left = 8
    Top = 152
    Width = 265
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object speReceiptItemsCount: TSpinEdit
    Left = 144
    Top = 40
    Width = 129
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    MaxValue = 100
    MinValue = 1
    TabOrder = 1
    Value = 5
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 232
    Top = 72
  end
end
