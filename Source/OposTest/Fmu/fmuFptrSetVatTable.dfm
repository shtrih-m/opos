object fmFptrSetVatTable: TfmFptrSetVatTable
  Left = 461
  Top = 452
  AutoScroll = False
  Caption = 'SetVat'
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
  object lblVatID: TTntLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = 'VatID:'
  end
  object lblVatValue: TTntLabel
    Left = 8
    Top = 32
    Width = 46
    Height = 13
    Caption = 'VatValue:'
  end
  object btnSetVatTable: TTntButton
    Left = 280
    Top = 40
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SetVatTable'
    TabOrder = 0
    OnClick = btnSetVatTableClick
  end
  object btnSetVatValue: TTntButton
    Left = 280
    Top = 8
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SetVatValue'
    TabOrder = 1
    OnClick = btnSetVatValueClick
  end
  object edtVatID: TTntEdit
    Left = 64
    Top = 8
    Width = 210
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '0'
  end
  object edtVatValue: TTntEdit
    Left = 64
    Top = 32
    Width = 210
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '0'
  end
end
