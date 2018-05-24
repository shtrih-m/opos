object fmFptrLogo: TfmFptrLogo
  Left = 451
  Top = 147
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Logo'
  ClientHeight = 362
  ClientWidth = 475
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
  object GroupBox1: TTntGroupBox
    Left = 0
    Top = 0
    Width = 475
    Height = 362
    Align = alClient
    TabOrder = 0
    DesignSize = (
      475
      362)
    object Bevel1: TBevel
      Left = 8
      Top = 16
      Width = 313
      Height = 273
      Anchors = [akLeft, akTop, akRight]
    end
    object Image: TImage
      Left = 16
      Top = 24
      Width = 297
      Height = 257
      Anchors = [akLeft, akTop, akRight]
    end
    object lblLogoPosition: TTntLabel
      Left = 144
      Top = 296
      Width = 66
      Height = 13
      Caption = 'Logo position:'
    end
    object lblLogoSize: TTntLabel
      Left = 144
      Top = 328
      Width = 48
      Height = 13
      Caption = 'Logo size:'
    end
    object lblProgress: TTntLabel
      Left = 328
      Top = 48
      Width = 51
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'lblProgress'
    end
    object cbLogoPosition: TTntComboBox
      Left = 216
      Top = 296
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'After header'
        'Before header'
        'Before trailer'
        'After trailer'
        'After TOTAL line')
    end
    object edtLogoSize: TTntEdit
      Left = 216
      Top = 328
      Width = 105
      Height = 21
      TabOrder = 2
    end
    object btnPrintLogo: TTntButton
      Left = 368
      Top = 168
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print'
      TabOrder = 3
      OnClick = btnPrintLogoClick
    end
    object btnLoad: TTntBitBtn
      Left = 368
      Top = 136
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Load'
      TabOrder = 4
      OnClick = btnLoadClick
    end
    object btnOpen: TTntBitBtn
      Left = 368
      Top = 104
      Width = 91
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Open'
      TabOrder = 5
      OnClick = btnOpenClick
    end
    object chbLogoCenter: TTntCheckBox
      Left = 328
      Top = 72
      Width = 129
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Center logo on page'
      TabOrder = 6
    end
    object ProgressBar: TProgressBar
      Left = 328
      Top = 24
      Width = 129
      Height = 16
      Anchors = [akTop, akRight]
      Step = 1
      TabOrder = 7
    end
    object chbLogoReloadEnabled: TTntCheckBox
      Left = 8
      Top = 296
      Width = 129
      Height = 17
      Caption = 'Logo reload enabled'
      TabOrder = 0
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 332
    Top = 104
  end
end
