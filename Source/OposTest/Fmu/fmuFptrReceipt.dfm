object fmFptrReceipt: TfmFptrReceipt
  Left = 940
  Top = 196
  AutoScroll = False
  Caption = 'Fiscal Receipt'
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
  object lblFiscalReceiptStation: TTntLabel
    Left = 8
    Top = 8
    Width = 100
    Height = 13
    Caption = 'FiscalReceiptStation:'
  end
  object lblFiscalReceiptType: TTntLabel
    Left = 8
    Top = 32
    Width = 91
    Height = 13
    Caption = 'FiscalReceiptType:'
  end
  object lblDescription: TTntLabel
    Left = 8
    Top = 160
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object btnBeginFisclReceipt: TTntButton
    Left = 264
    Top = 64
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'BeginFisclReceipt'
    TabOrder = 3
    OnClick = btnBeginFisclReceiptClick
  end
  object btnEndFiscalReceipt: TTntButton
    Left = 264
    Top = 96
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'EndFiscalReceipt'
    TabOrder = 4
    OnClick = btnEndFiscalReceiptClick
  end
  object chbPrintHeader: TTntCheckBox
    Left = 120
    Top = 64
    Width = 81
    Height = 17
    Caption = 'PrintHeader'
    TabOrder = 2
  end
  object btnPrintDuplicateReceipt: TTntButton
    Left = 264
    Top = 128
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintDuplicateReceipt'
    TabOrder = 5
    OnClick = btnPrintDuplicateReceiptClick
  end
  object cbFiscalReceiptStation: TTntComboBox
    Left = 120
    Top = 8
    Width = 267
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'FPTR_RS_RECEIPT'
      'FPTR_RS_SLIP')
  end
  object cbFiscalReceiptType: TTntComboBox
    Left = 120
    Top = 32
    Width = 267
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'FPTR_RT_CASH_IN'
      'FPTR_RT_CASH_OUT'
      'FPTR_RT_GENERIC'
      'FPTR_RT_SALES'
      'FPTR_RT_SERVICE'
      'FPTR_RT_SIMPLE_INVOICE'
      'FPTR_RT_REFUND')
  end
  object btnPrintRecVoid: TTntButton
    Left = 264
    Top = 160
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecVoid'
    TabOrder = 7
    OnClick = btnPrintRecVoidClick
  end
  object edtDescription: TTntEdit
    Left = 72
    Top = 160
    Width = 187
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = 'printRecVoid'
  end
end
