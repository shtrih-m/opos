object fmFptrRetalix: TfmFptrRetalix
  Left = 376
  Top = 269
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Retalix'
  ClientHeight = 321
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    368
    321)
  PixelsPerInch = 96
  TextHeight = 13
  object lblRetalixDBPath: TTntLabel
    Left = 24
    Top = 48
    Width = 73
    Height = 13
    Caption = 'Database path:'
  end
  object Label1: TTntLabel
    Left = 24
    Top = 104
    Width = 309
    Height = 26
    Caption = 
      'Driver will user lcase SQL function that will slow down search t' +
      'ime'#13#10'for 1 second or more. '
  end
  object edtRetalixDBPath: TTntEdit
    Left = 112
    Top = 48
    Width = 249
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '30'
  end
  object chbRetalixDBEnabled: TTntCheckBox
    Left = 8
    Top = 16
    Width = 257
    Height = 17
    Caption = 'Retalix database query enabled'
    TabOrder = 0
  end
  object chbRetalixSearchCI: TTntCheckBox
    Left = 8
    Top = 80
    Width = 313
    Height = 17
    Caption = 'Search items case insensitively'
    TabOrder = 2
  end
  object chbRosneftDryReceiptEnabled: TTntCheckBox
    Left = 8
    Top = 144
    Width = 313
    Height = 17
    Caption = 'Rosneft "dry" receipts enabled'
    TabOrder = 3
  end
end
