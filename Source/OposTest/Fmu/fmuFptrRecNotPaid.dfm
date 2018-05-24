object fmFptrRecNotPaid: TfmFptrRecNotPaid
  Left = 340
  Top = 261
  AutoScroll = False
  Caption = 'PrintRecNotPaid'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDescription: TTntLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblAmount: TTntLabel
    Left = 8
    Top = 32
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object btnExecute: TTntButton
    Left = 264
    Top = 64
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecNotPaid'
    TabOrder = 2
    OnClick = btnExecuteClick
  end
  object edtDescription: TTntEdit
    Left = 80
    Top = 8
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'printRecNotPaid'
  end
  object edtAmount: TTntEdit
    Left = 80
    Top = 32
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '100'
  end
end
