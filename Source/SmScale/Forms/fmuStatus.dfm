object fmStatus: TfmStatus
  Left = 371
  Top = 177
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Status'
  ClientHeight = 373
  ClientWidth = 376
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    376
    373)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo: TTntMemo
    Left = 0
    Top = 0
    Width = 376
    Height = 337
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
  object btnReadStatus: TTntButton
    Left = 64
    Top = 344
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Read status'
    TabOrder = 1
    OnClick = btnReadStatusClick
  end
  object btnReadStatus2: TTntButton
    Left = 168
    Top = 344
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Read status 2'
    TabOrder = 2
    OnClick = btnReadStatus2Click
  end
  object btnDeviceMetrics: TTntButton
    Left = 272
    Top = 344
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Device metrics'
    TabOrder = 3
    OnClick = btnDeviceMetricsClick
  end
end
