object fmScaleHealth: TfmScaleHealth
  Left = 351
  Top = 300
  Width = 344
  Height = 201
  Caption = 'Check health'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    336
    174)
  PixelsPerInch = 96
  TextHeight = 13
  object lblLevel: TLabel
    Left = 8
    Top = 149
    Width = 29
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Level:'
  end
  object lblCheckHealthText: TLabel
    Left = 8
    Top = 8
    Width = 86
    Height = 13
    Caption = 'CheckHealthText:'
  end
  object cbLevel: TComboBox
    Left = 64
    Top = 144
    Width = 153
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'CH_INTERNAL'
      'CH_EXTERNAL'
      'CH_INTERACTIVE')
  end
  object btnCheckHealth: TButton
    Left = 224
    Top = 144
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'CheckHealth'
    TabOrder = 2
    OnClick = btnCheckHealthClick
  end
  object memCheckHealthText: TMemo
    Left = 8
    Top = 24
    Width = 321
    Height = 108
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
end
