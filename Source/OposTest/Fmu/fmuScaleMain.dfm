object fmScaleMain: TfmScaleMain
  Left = 325
  Top = 213
  Width = 388
  Height = 312
  Caption = 'Operations'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    372
    274)
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TTntLabel
    Left = 8
    Top = 72
    Width = 24
    Height = 13
    Caption = 'Text:'
  end
  object lblWeightData: TTntLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'WeightData:'
  end
  object lblTimeout: TTntLabel
    Left = 8
    Top = 40
    Width = 41
    Height = 13
    Caption = 'Timeout:'
  end
  object btnDisplayText: TTntButton
    Left = 288
    Top = 72
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'DisplayText'
    TabOrder = 0
    OnClick = btnDisplayTextClick
  end
  object edtText: TTntEdit
    Left = 80
    Top = 72
    Width = 201
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'NCR 7874'
  end
  object btnReadWeight: TTntButton
    Left = 288
    Top = 8
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'ReadWeight'
    TabOrder = 2
    OnClick = btnReadWeightClick
  end
  object edtWeightData: TTntEdit
    Left = 80
    Top = 8
    Width = 201
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object edtTimeout: TTntEdit
    Left = 80
    Top = 40
    Width = 201
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '4000'
  end
  object btnZeroScale: TTntButton
    Left = 288
    Top = 40
    Width = 81
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'ZeroScale'
    TabOrder = 5
    OnClick = btnZeroScaleClick
  end
end
