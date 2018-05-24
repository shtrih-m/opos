object fmCashWait: TfmCashWait
  Left = 398
  Top = 292
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WaitForDrawerClose'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblBeepTimeout: TTntLabel
    Left = 8
    Top = 16
    Width = 65
    Height = 13
    Caption = 'Beep timeout:'
  end
  object lblbeepDelay: TTntLabel
    Left = 8
    Top = 88
    Width = 56
    Height = 13
    Caption = 'Beep delay:'
  end
  object lblbeepDuration: TTntLabel
    Left = 8
    Top = 64
    Width = 69
    Height = 13
    Caption = 'Beep duration:'
  end
  object lblbeepFrequency: TTntLabel
    Left = 8
    Top = 40
    Width = 78
    Height = 13
    Caption = 'Beep frequency:'
  end
  object edtbeepTimeout: TTntEdit
    Left = 96
    Top = 16
    Width = 89
    Height = 21
    TabOrder = 0
    Text = '1000'
  end
  object edtbeepFrequency: TTntEdit
    Left = 96
    Top = 40
    Width = 89
    Height = 21
    TabOrder = 1
    Text = '1000'
  end
  object edtbeepDuration: TTntEdit
    Left = 96
    Top = 64
    Width = 89
    Height = 21
    TabOrder = 2
    Text = '1000'
  end
  object edtbeepDelay: TTntEdit
    Left = 96
    Top = 88
    Width = 89
    Height = 21
    TabOrder = 3
    Text = '1000'
  end
  object btnWaitForDrawerClose: TTntButton
    Left = 192
    Top = 16
    Width = 137
    Height = 25
    Caption = 'WaitForDrawerClose'
    TabOrder = 4
    OnClick = btnWaitForDrawerCloseClick
  end
end
