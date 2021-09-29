object fmFptrTrailer: TfmFptrTrailer
  Left = 322
  Top = 118
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Trailer'
  ClientHeight = 316
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    476
    316)
  PixelsPerInch = 96
  TextHeight = 13
  object gbTrailer: TTntGroupBox
    Left = 0
    Top = 216
    Width = 473
    Height = 97
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
    DesignSize = (
      473
      97)
    object lblNumTrailerLines: TTntLabel
      Left = 184
      Top = 20
      Width = 92
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Number trailer lines:'
    end
    object lblTrailerFont: TTntLabel
      Left = 184
      Top = 52
      Width = 91
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Trailer font number:'
    end
    object cbNumTrailerLines: TTntComboBox
      Left = 288
      Top = 16
      Width = 81
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = PageChange
    end
    object cbTrailerFont: TTntComboBox
      Left = 288
      Top = 48
      Width = 81
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      OnChange = PageChange
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
    object btnPrintTrailer: TTntButton
      Left = 376
      Top = 16
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print trailer'
      TabOrder = 2
      OnClick = btnPrintTrailerClick
    end
    object chbSetTrailerLineEnabled: TTntCheckBox
      Left = 8
      Top = 72
      Width = 193
      Height = 17
      Caption = 'SetTrailerLine method enabled'
      TabOrder = 3
    end
  end
  object symTrailer: TSynMemo
    Left = 0
    Top = 0
    Width = 473
    Height = 209
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 1
    Gutter.DigitCount = 2
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Gutter.LeftOffset = 6
    Gutter.RightOffset = 4
    Gutter.ShowLineNumbers = True
    ScrollBars = ssVertical
    OnChange = PageChange
  end
end
