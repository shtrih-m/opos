object fmFptrAddHeaderTrailer: TfmFptrAddHeaderTrailer
  Left = 432
  Top = 308
  AutoScroll = False
  Caption = 'Additional Header & Trailer'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblAdditionalHeader: TTntLabel
    Left = 8
    Top = 8
    Width = 84
    Height = 13
    Caption = 'AdditionalHeader:'
  end
  object lblAdditionalTrailer: TTntLabel
    Left = 8
    Top = 144
    Width = 78
    Height = 13
    Caption = 'AdditionalTrailer:'
  end
  object AdditionalHeader: TTntMemo
    Left = 8
    Top = 24
    Width = 377
    Height = 113
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object AdditionalTrailer: TTntMemo
    Left = 8
    Top = 160
    Width = 377
    Height = 73
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object btnRead: TTntButton
    Left = 232
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Read'
    TabOrder = 4
    OnClick = btnReadClick
  end
  object btnWrite: TTntButton
    Left = 312
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Write'
    TabOrder = 5
    OnClick = btnWriteClick
  end
  object btnDefaults: TTntButton
    Left = 8
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Defaults'
    TabOrder = 2
    OnClick = btnDefaultsClick
  end
  object btnClear: TTntButton
    Left = 88
    Top = 240
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Clear'
    TabOrder = 3
    OnClick = btnClearClick
  end
end
