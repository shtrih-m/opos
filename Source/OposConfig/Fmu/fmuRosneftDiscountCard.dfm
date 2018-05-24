object fmRosneftDiscountCard: TfmRosneftDiscountCard
  Left = 453
  Top = 179
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Rosneft, discount card'
  ClientHeight = 455
  ClientWidth = 445
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
  object lblRosneftCardMask: TTntLabel
    Left = 32
    Top = 48
    Width = 147
    Height = 13
    Caption = 'Card mask (regular expression):'
  end
  object lblRosneftCardName: TTntLabel
    Left = 32
    Top = 80
    Width = 149
    Height = 13
    Caption = 'Card name (replacement string):'
  end
  object Bevel1: TBevel
    Left = 32
    Top = 112
    Width = 393
    Height = 25
    Shape = bsTopLine
  end
  object Label1: TTntLabel
    Left = 96
    Top = 128
    Width = 54
    Height = 13
    Caption = 'Card name:'
  end
  object Label2: TTntLabel
    Left = 96
    Top = 160
    Width = 86
    Height = 13
    Caption = 'Result card name:'
  end
  object chbDiscountCards: TTntCheckBox
    Left = 8
    Top = 8
    Width = 313
    Height = 17
    Caption = 'Process discount cards'
    TabOrder = 0
  end
  object edtRosneftCardMask: TTntEdit
    Left = 192
    Top = 48
    Width = 233
    Height = 21
    TabOrder = 1
    Text = 'edtRosneftCardMask'
  end
  object edtRosneftCardName: TTntEdit
    Left = 192
    Top = 80
    Width = 233
    Height = 21
    TabOrder = 2
    Text = 'edtRosneftCardName'
  end
  object btnTest: TTntButton
    Left = 336
    Top = 192
    Width = 91
    Height = 25
    Caption = 'Test'
    TabOrder = 5
    OnClick = btnTestClick
  end
  object edtCardName: TTntEdit
    Left = 192
    Top = 128
    Width = 233
    Height = 21
    TabOrder = 3
    Text = '3% Loyalty 000302992000000040'
  end
  object edtResultCardName: TTntEdit
    Left = 192
    Top = 160
    Width = 233
    Height = 21
    TabOrder = 4
  end
end
