object fmRosneftAddText: TfmRosneftAddText
  Left = 417
  Top = 168
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Rosneft additional text'
  ClientHeight = 272
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    432
    272)
  PixelsPerInch = 96
  TextHeight = 13
  object lblRosneftItemName: TTntLabel
    Left = 32
    Top = 40
    Width = 91
    Height = 13
    Caption = 'Receipt item name:'
  end
  object lblRosneftAddText: TTntLabel
    Left = 32
    Top = 104
    Width = 98
    Height = 13
    Caption = 'Additional text block:'
  end
  object lblDepartment: TTntLabel
    Left = 32
    Top = 72
    Width = 118
    Height = 13
    Caption = 'Receipt item department:'
  end
  object chbRosneftAddTextEnabled: TTntCheckBox
    Left = 8
    Top = 8
    Width = 313
    Height = 17
    Caption = 'Additional text block enabled'
    TabOrder = 0
  end
  object edtRosneftItemName: TTntEdit
    Left = 160
    Top = 40
    Width = 265
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'edtRosneftItemName'
  end
  object memRosneftAddText: TTntMemo
    Left = 32
    Top = 128
    Width = 393
    Height = 137
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object seRosneftItemDepartment: TSpinEdit
    Left = 160
    Top = 72
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
end
