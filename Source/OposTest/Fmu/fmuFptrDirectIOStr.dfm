object fmFptrDirectIOStr: TfmFptrDirectIOStr
  Left = 475
  Top = 305
  AutoScroll = False
  Caption = 'DirectIO Str'
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
  object lblTxData: TLabel
    Left = 8
    Top = 48
    Width = 56
    Height = 13
    Caption = 'Parameters:'
  end
  object lblRxData: TLabel
    Left = 8
    Top = 80
    Width = 33
    Height = 13
    Caption = 'Result:'
  end
  object lblCommand: TLabel
    Left = 8
    Top = 16
    Width = 50
    Height = 13
    Caption = 'Command:'
  end
  object lblDescription: TLabel
    Left = 8
    Top = 112
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object Label1: TLabel
    Left = 8
    Top = 200
    Width = 38
    Height = 13
    Caption = 'Answer:'
  end
  object btnExecute: TButton
    Left = 288
    Top = 240
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Execute'
    TabOrder = 5
    OnClick = btnExecuteClick
  end
  object edtRxData: TEdit
    Left = 80
    Top = 80
    Width = 307
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object edtTxData: TEdit
    Left = 80
    Top = 48
    Width = 307
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '01'
  end
  object cbCommand: TComboBox
    Left = 80
    Top = 16
    Width = 307
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnChange = cbCommandChange
  end
  object memCommand: TMemo
    Left = 80
    Top = 112
    Width = 307
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object memAnswer: TMemo
    Left = 80
    Top = 200
    Width = 307
    Height = 33
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
