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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 473
    Height = 361
    TabOrder = 0
    object Image: TImage
      Left = 16
      Top = 24
      Width = 297
      Height = 257
    end
    object Bevel1: TBevel
      Left = 8
      Top = 16
      Width = 313
      Height = 273
    end
    object lblLogoPosition: TLabel
      Left = 144
      Top = 296
      Width = 66
      Height = 13
      Caption = 'Logo position:'
    end
    object lblLogoSize: TLabel
      Left = 144
      Top = 328
      Width = 48
      Height = 13
      Caption = 'Logo size:'
    end
    object lblProgress: TLabel
      Left = 328
      Top = 48
      Width = 51
      Height = 13
      Caption = 'lblProgress'
    end
    object chbLogoEnabled: TCheckBox
      Left = 8
      Top = 296
      Width = 113
      Height = 17
      Caption = 'Logo enabled'
      TabOrder = 0
    end
    object cbLogoPosition: TComboBox
      Left = 216
      Top = 296
      Width = 105
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        'After header'
        'Before header'
        'Before trailer'
        'After trailer'
        'After TOTAL line')
    end
    object edtLogoSize: TEdit
      Left = 216
      Top = 328
      Width = 105
      Height = 21
      TabOrder = 3
    end
    object btnPrintLogo: TButton
      Left = 368
      Top = 168
      Width = 91
      Height = 25
      Caption = 'Print'
      TabOrder = 4
      OnClick = btnPrintLogoClick
    end
    object btnLoad: TBitBtn
      Left = 368
      Top = 136
      Width = 91
      Height = 25
      Caption = 'Load'
      TabOrder = 5
      OnClick = btnLoadClick
    end
    object btnOpen: TBitBtn
      Left = 368
      Top = 104
      Width = 91
      Height = 25
      Caption = 'Open'
      TabOrder = 6
      OnClick = btnOpenClick
    end
    object chbLogoCenter: TCheckBox
      Left = 328
      Top = 72
      Width = 129
      Height = 17
      Caption = 'Center logo on page'
      TabOrder = 7
    end
    object ProgressBar: TProgressBar
      Left = 328
      Top = 24
      Width = 129
      Height = 16
      Step = 1
      TabOrder = 8
    end
    object chbLogoReloadEnabled: TCheckBox
      Left = 8
      Top = 328
      Width = 129
      Height = 17
      Caption = 'Logo reload enabled'
      TabOrder = 1
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 332
    Top = 104
  end
end
