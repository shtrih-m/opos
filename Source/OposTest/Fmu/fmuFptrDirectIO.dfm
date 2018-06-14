object fmFptrDirectIO: TfmFptrDirectIO
  Left = 404
  Top = 173
  AutoScroll = False
  Caption = 'DirectIO'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblData: TTntLabel
    Left = 8
    Top = 48
    Width = 26
    Height = 13
    Caption = 'Data:'
  end
  object lblString: TTntLabel
    Left = 8
    Top = 80
    Width = 30
    Height = 13
    Caption = 'String:'
  end
  object lblCommand: TTntLabel
    Left = 8
    Top = 16
    Width = 50
    Height = 13
    Caption = 'Command:'
  end
  object lblOutString: TTntLabel
    Left = 8
    Top = 112
    Width = 56
    Height = 13
    Caption = 'String (Out):'
  end
  object lblCustom: TTntLabel
    Left = 256
    Top = 16
    Width = 87
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Custom command:'
  end
  object lblDescription: TTntLabel
    Left = 8
    Top = 152
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object btnExecute: TTntButton
    Left = 288
    Top = 144
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 5
    OnClick = btnExecuteClick
  end
  object edtInString: TTntEdit
    Left = 72
    Top = 80
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object edtData: TTntEdit
    Left = 72
    Top = 48
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '0'
  end
  object edtOutString: TTntEdit
    Left = 72
    Top = 112
    Width = 315
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 4
  end
  object memInfo: TTntMemo
    Left = 8
    Top = 176
    Width = 379
    Height = 91
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 6
    WordWrap = False
  end
  object cbCommand: TTntComboBox
    Left = 72
    Top = 16
    Width = 179
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbCommandChange
  end
  object edtCustomCommand: TTntEdit
    Left = 352
    Top = 16
    Width = 33
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 1
    Text = '1'
  end
end
