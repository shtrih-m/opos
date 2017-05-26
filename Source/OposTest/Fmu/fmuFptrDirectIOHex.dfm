object fmFptrDirectIOHex: TfmFptrDirectIOHex
  Left = 425
  Top = 292
  AutoScroll = False
  Caption = 'DirectIO Hex'
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
  object lblTxData: TLabel
    Left = 8
    Top = 16
    Width = 38
    Height = 13
    Caption = 'TxData:'
  end
  object lblRxData: TLabel
    Left = 8
    Top = 48
    Width = 39
    Height = 13
    Caption = 'RxData:'
  end
  object btnExecute: TButton
    Left = 290
    Top = 80
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 2
    OnClick = btnExecuteClick
  end
  object edtRxData: TEdit
    Left = 64
    Top = 48
    Width = 323
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object edtTxData: TEdit
    Left = 64
    Top = 16
    Width = 323
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '11 01 00 00 00'
  end
end
