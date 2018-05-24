object fmFptrRecTaxID: TfmFptrRecTaxID
  Left = 407
  Top = 400
  AutoScroll = False
  Caption = 'PrintRecTaxID'
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
  object lblTaxID: TTntLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'TaxID:'
  end
  object btnExecute: TTntButton
    Left = 240
    Top = 40
    Width = 145
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecTaxID'
    TabOrder = 1
    OnClick = btnExecuteClick
  end
  object edtTaxID: TTntEdit
    Left = 56
    Top = 8
    Width = 329
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'PrintRecTaxID'
  end
end
