object fmFptrRecTotal: TfmFptrRecTotal
  Left = 408
  Top = 241
  AutoScroll = False
  Caption = 'PrintRecTotal'
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
  object lblTotal: TTntLabel
    Left = 8
    Top = 56
    Width = 27
    Height = 13
    Caption = 'Total:'
  end
  object lblPayment: TTntLabel
    Left = 8
    Top = 80
    Width = 44
    Height = 13
    Caption = 'Payment:'
  end
  object lblDescription: TTntLabel
    Left = 8
    Top = 104
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblPreLine: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object lblPostLine: TTntLabel
    Left = 8
    Top = 32
    Width = 44
    Height = 13
    Caption = 'PostLine:'
  end
  object btnExecute: TTntButton
    Left = 240
    Top = 136
    Width = 145
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecTotal'
    TabOrder = 6
    OnClick = btnExecuteClick
  end
  object edtTotal: TTntEdit
    Left = 80
    Top = 56
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '100'
  end
  object edtPayment: TTntEdit
    Left = 80
    Top = 80
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '100'
  end
  object edtDescription: TTntEdit
    Left = 80
    Top = 104
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '0'
  end
  object edtPreLine: TTntEdit
    Left = 80
    Top = 8
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'PreLine'
  end
  object edtPostLine: TTntEdit
    Left = 80
    Top = 32
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'PostLine'
  end
  object chbCheckTotal: TTntCheckBox
    Left = 80
    Top = 136
    Width = 97
    Height = 17
    Caption = 'CheckTotal'
    TabOrder = 5
  end
end
