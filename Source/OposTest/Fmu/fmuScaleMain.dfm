object fmScaleMain: TfmScaleMain
  Left = 325
  Top = 213
  Width = 383
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
    375
    285)
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel
    Left = 8
    Top = 72
    Width = 24
    Height = 13
    Caption = 'Text:'
  end
  object lblWeightData: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'WeightData:'
  end
  object lblTimeout: TLabel
    Left = 8
    Top = 40
    Width = 41
    Height = 13
    Caption = 'Timeout:'
  end
  object btnDisplayText: TButton
    Left = 296
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'DisplayText'
    TabOrder = 0
    OnClick = btnDisplayTextClick
  end
  object edtText: TEdit
    Left = 80
    Top = 72
    Width = 209
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'NCR 7874'
  end
  object btnReadWeight: TButton
    Left = 296
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'ReadWeight'
    TabOrder = 2
    OnClick = btnReadWeightClick
  end
  object edtWeightData: TEdit
    Left = 80
    Top = 8
    Width = 209
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object edtTimeout: TEdit
    Left = 80
    Top = 40
    Width = 209
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '4000'
  end
  object btnZeroScale: TButton
    Left = 296
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'ZeroScale'
    TabOrder = 5
    OnClick = btnZeroScaleClick
  end
end
