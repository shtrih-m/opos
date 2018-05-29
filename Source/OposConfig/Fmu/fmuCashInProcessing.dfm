object fmCashInProcessing: TfmCashInProcessing
  Left = 349
  Top = 218
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'CashIn'
  ClientHeight = 102
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    338
    102)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCashInTextPattern: TTntLabel
    Left = 16
    Top = 48
    Width = 92
    Height = 13
    Caption = 'CashIn text pattern:'
  end
  object chbCashInProcessingEnabled: TTntCheckBox
    Left = 8
    Top = 8
    Width = 289
    Height = 25
    Caption = 'CashIn processing enabled'
    TabOrder = 0
  end
  object edtCashInTextPattern: TTntEdit
    Left = 128
    Top = 48
    Width = 204
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
end
