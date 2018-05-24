object fmFptrSlipInsertion: TfmFptrSlipInsertion
  Left = 467
  Top = 462
  AutoScroll = False
  Caption = 'Slip Insertion'
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
  object lblTimeout: TTntLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = 'Timeout, ms.:'
  end
  object edtTimeout: TTntEdit
    Left = 80
    Top = 8
    Width = 195
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '10000'
  end
  object btnBeginInsertion: TTntButton
    Left = 280
    Top = 8
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'BeginInsertion'
    TabOrder = 1
    OnClick = btnBeginInsertionClick
  end
  object btnEndInsertion: TTntButton
    Left = 280
    Top = 40
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'EndInsertion'
    TabOrder = 2
    OnClick = btnEndInsertionClick
  end
  object btnBeginRemoval: TTntButton
    Left = 280
    Top = 72
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'BeginRemoval'
    TabOrder = 3
    OnClick = btnBeginRemovalClick
  end
  object btnEndRemoval: TTntButton
    Left = 280
    Top = 104
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'EndRemoval'
    TabOrder = 4
    OnClick = btnEndRemovalClick
  end
end
