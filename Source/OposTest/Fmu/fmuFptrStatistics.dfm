object fmFptrStatistics: TfmFptrStatistics
  Left = 336
  Top = 172
  AutoScroll = False
  Caption = 'Statistics'
  ClientHeight = 294
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    544
    294)
  PixelsPerInch = 96
  TextHeight = 13
  object btnResetStatistics: TButton
    Left = 232
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Reset statistics'
    TabOrder = 2
    OnClick = btnResetStatisticsClick
  end
  object btnRetrieveStatistics: TButton
    Left = 336
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Retrieve statistics'
    TabOrder = 3
    OnClick = btnRetrieveStatisticsClick
  end
  object btnUpdateStatistics: TButton
    Left = 440
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Update statistics'
    TabOrder = 4
    OnClick = btnUpdateStatisticsClick
  end
  object btnClear: TButton
    Left = 144
    Top = 264
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 1
    OnClick = btnClearClick
  end
  object mmData: TSynEdit
    Left = 8
    Top = 8
    Width = 529
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    TabOrder = 0
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = SynXMLSyn1
    TabWidth = 4
  end
  object SynXMLSyn1: TSynXMLSyn
    WantBracesParsed = False
    Left = 8
    Top = 120
  end
end
