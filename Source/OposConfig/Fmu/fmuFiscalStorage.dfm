object fmFiscalStorage: TfmFiscalStorage
  Left = 461
  Top = 274
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Fiscal storage'
  ClientHeight = 394
  ClientWidth = 424
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
  object chbFSBarcodeEnabled: TCheckBox
    Left = 8
    Top = 56
    Width = 148
    Height = 17
    Caption = 'Print QR code '
    TabOrder = 2
  end
  object chbFSAddressEnabled: TCheckBox
    Left = 8
    Top = 32
    Width = 225
    Height = 17
    Caption = 'Customer EMail and phone query enabled'
    TabOrder = 1
  end
  object chbFSUpdatePrice: TCheckBox
    Left = 8
    Top = 8
    Width = 329
    Height = 17
    Caption = 'Update price on discounts'
    TabOrder = 0
  end
end
