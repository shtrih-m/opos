object fmFptrSetHeaderTrailer: TfmFptrSetHeaderTrailer
  Left = 415
  Top = 252
  AutoScroll = False
  Caption = 'Header & Trailer'
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
  object lblHeader: TTntLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Header:'
  end
  object lblTrailer: TTntLabel
    Left = 8
    Top = 120
    Width = 32
    Height = 13
    Caption = 'Trailer:'
  end
  object btnSetHeader: TTntButton
    Left = 184
    Top = 208
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Set Header'
    TabOrder = 0
    OnClick = btnSetHeaderClick
  end
  object btnSetTrailer: TTntButton
    Left = 288
    Top = 208
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Set Trailer'
    TabOrder = 1
    OnClick = btnSetTrailerClick
  end
  object mmHeader: TTntMemo
    Left = 8
    Top = 24
    Width = 379
    Height = 89
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object btnClear: TTntButton
    Left = 184
    Top = 240
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 3
    OnClick = btnClearClick
  end
  object mmTrailer: TTntMemo
    Left = 8
    Top = 136
    Width = 379
    Height = 65
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
  end
  object btnDefault: TTntButton
    Left = 288
    Top = 240
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Default'
    TabOrder = 5
    OnClick = btnDefaultClick
  end
  object chbDoubleWidth: TTntCheckBox
    Left = 8
    Top = 208
    Width = 89
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'DoubleWidth'
    TabOrder = 6
  end
end
