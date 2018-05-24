object fmFptrTraining: TfmFptrTraining
  Left = 425
  Top = 292
  AutoScroll = False
  Caption = 'Training'
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
  object lblTrainingModeActive: TTntLabel
    Left = 8
    Top = 8
    Width = 98
    Height = 13
    Caption = 'TrainingModeActive:'
  end
  object btnEndTraining: TTntButton
    Left = 288
    Top = 72
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'EndTraining'
    TabOrder = 2
    OnClick = btnEndTrainingClick
  end
  object edtTrainingModeActive: TTntEdit
    Left = 120
    Top = 8
    Width = 265
    Height = 21
    TabStop = False
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
  object btnBeginTraining: TTntButton
    Left = 288
    Top = 40
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'BeginTraining'
    TabOrder = 1
    OnClick = btnBeginTrainingClick
  end
end
