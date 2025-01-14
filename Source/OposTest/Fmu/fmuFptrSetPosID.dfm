object fmFptrSetPosId: TfmFptrSetPosId
  Left = 461
  Top = 452
  AutoScroll = False
  Caption = 'SetPosID'
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
  object lblPOSID: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'POS ID:'
  end
  object lblVatValue: TTntLabel
    Left = 8
    Top = 40
    Width = 52
    Height = 13
    Caption = 'Cashier ID:'
  end
  object btnSetPosID: TTntButton
    Left = 280
    Top = 8
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SetPosID'
    TabOrder = 2
    OnClick = btnSetPosIDClick
  end
  object edtPOSID: TTntEdit
    Left = 72
    Top = 8
    Width = 202
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '1'
  end
  object edtCashierID: TTntEdit
    Left = 72
    Top = 40
    Width = 202
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'Cashier 1'
  end
end
