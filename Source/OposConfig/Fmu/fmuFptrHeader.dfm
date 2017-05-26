object fmFptrHeader: TfmFptrHeader
  Left = 486
  Top = 159
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Header'
  ClientHeight = 468
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object symHeader: TSynMemo
    Left = 0
    Top = 0
    Width = 648
    Height = 368
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
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
    FontSmoothing = fsmNone
  end
  object gbHeader: TGroupBox
    Left = 0
    Top = 368
    Width = 648
    Height = 100
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      648
      100)
    object lblNumHeaderLines: TLabel
      Left = 354
      Top = 16
      Width = 100
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Number header lines:'
    end
    object lblHeaderFont: TLabel
      Left = 354
      Top = 48
      Width = 97
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Header font number:'
    end
    object cbNumHeaderLines: TComboBox
      Left = 466
      Top = 16
      Width = 81
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 2
      OnChange = PageChange
    end
    object cbHeaderFont: TComboBox
      Left = 466
      Top = 48
      Width = 81
      Height = 21
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemHeight = 13
      TabOrder = 3
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
    object btnPrintHeader: TButton
      Left = 554
      Top = 16
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print header'
      TabOrder = 4
      OnClick = btnPrintHeaderClick
    end
    object chbSetHeaderLineEnabled: TCheckBox
      Left = 8
      Top = 16
      Width = 169
      Height = 17
      Caption = 'SetHeaderLine method enabled'
      TabOrder = 0
    end
    object chbCenterHeader: TCheckBox
      Left = 8
      Top = 48
      Width = 185
      Height = 17
      Caption = 'Center header lines automatically'
      TabOrder = 1
    end
  end
end
