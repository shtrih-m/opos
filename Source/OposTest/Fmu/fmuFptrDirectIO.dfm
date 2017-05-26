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
  object lblData: TLabel
    Left = 8
    Top = 48
    Width = 26
    Height = 13
    Caption = 'Data:'
  end
  object lblString: TLabel
    Left = 8
    Top = 80
    Width = 30
    Height = 13
    Caption = 'String:'
  end
  object lblCommand: TLabel
    Left = 8
    Top = 16
    Width = 50
    Height = 13
    Caption = 'Command:'
  end
  object lblOutString: TLabel
    Left = 8
    Top = 112
    Width = 56
    Height = 13
    Caption = 'String (Out):'
  end
  object lblCustom: TLabel
    Left = 256
    Top = 16
    Width = 87
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Custom command:'
  end
  object lblDescription: TLabel
    Left = 8
    Top = 184
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object btnExecute: TButton
    Left = 288
    Top = 144
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 5
    OnClick = btnExecuteClick
  end
  object edtInString: TEdit
    Left = 72
    Top = 80
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object edtData: TEdit
    Left = 72
    Top = 48
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '0'
  end
  object edtOutString: TEdit
    Left = 72
    Top = 112
    Width = 315
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 4
  end
  object memInfo: TMemo
    Left = 8
    Top = 208
    Width = 379
    Height = 59
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Color = clBtnFace
    TabOrder = 6
  end
  object cbCommand: TComboBox
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
  object edtCustomCommand: TEdit
    Left = 352
    Top = 16
    Width = 33
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 1
    Text = '1'
  end
end
