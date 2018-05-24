object fmFptrMonitoring: TfmFptrMonitoring
  Left = 273
  Top = 169
  AutoScroll = False
  Caption = 'Monitoring'
  ClientHeight = 264
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    424
    264)
  PixelsPerInch = 96
  TextHeight = 13
  object lblHost: TTntLabel
    Left = 8
    Top = 200
    Width = 25
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Host:'
  end
  object lblPort: TTntLabel
    Left = 8
    Top = 232
    Width = 22
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Port:'
  end
  object btnReadStatus: TTntButton
    Left = 320
    Top = 200
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Read'
    TabOrder = 3
    OnClick = btnReadStatusClick
  end
  object btnClear: TTntButton
    Left = 320
    Top = 232
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 4
    OnClick = btnClearClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 8
    Width = 409
    Height = 185
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
  object edtHost: TTntEdit
    Left = 80
    Top = 200
    Width = 233
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    Text = '127.0.0.1'
  end
  object edtPort: TTntEdit
    Left = 80
    Top = 232
    Width = 233
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    Text = '50000'
  end
end
