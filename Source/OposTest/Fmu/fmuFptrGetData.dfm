object fmFptrGetData: TfmFptrGetData
  Left = 389
  Top = 247
  AutoScroll = False
  Caption = 'GetData'
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
  object lblDataItem: TTntLabel
    Left = 8
    Top = 8
    Width = 46
    Height = 13
    Caption = 'DataItem:'
  end
  object lblOptArgs: TTntLabel
    Left = 8
    Top = 32
    Width = 41
    Height = 13
    Caption = 'OptArgs:'
  end
  object lblData: TTntLabel
    Left = 128
    Top = 32
    Width = 26
    Height = 13
    Caption = 'Data:'
  end
  object lblVatID: TTntLabel
    Left = 8
    Top = 144
    Width = 30
    Height = 13
    Caption = 'VatID:'
  end
  object Label1: TTntLabel
    Left = 8
    Top = 168
    Width = 41
    Height = 13
    Caption = 'OptArgs:'
  end
  object lblTotalizerType: TTntLabel
    Left = 8
    Top = 120
    Width = 67
    Height = 13
    Caption = 'TotalizerType:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 104
    Width = 377
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object btnGetData: TTntButton
    Left = 288
    Top = 64
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'GetData'
    TabOrder = 4
    OnClick = btnGetDataClick
  end
  object edtDataItem: TTntEdit
    Left = 64
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object cbDataItem: TTntComboBox
    Left = 128
    Top = 8
    Width = 257
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbDataItemChange
    Items.Strings = (
      'FPTR_GD_CURRENT_TOTAL'
      'FPTR_GD_DAILY_TOTAL'
      'FPTR_GD_RECEIPT_NUMBER'
      'FPTR_GD_REFUND'
      'FPTR_GD_NOT_PAID'
      'FPTR_GD_MID_VOID'
      'FPTR_GD_Z_REPORT'
      'FPTR_GD_GRAND_TOTAL'
      'FPTR_GD_PRINTER_ID'
      'FPTR_GD_FIRMWARE'
      'FPTR_GD_RESTART'
      'FPTR_GD_REFUND_VOID'
      'FPTR_GD_NUMB_CONFIG_BLOCK'
      'FPTR_GD_NUMB_CURRENCY_BLOCK'
      'FPTR_GD_NUMB_HDR_BLOCK'
      'FPTR_GD_NUMB_RESET_BLOCK'
      'FPTR_GD_NUMB_VAT_BLOCK'
      'FPTR_GD_FISCAL_DOC'
      'FPTR_GD_FISCAL_DOC_VOID'
      'FPTR_GD_FISCAL_REC'
      'FPTR_GD_FISCAL_REC_VOID'
      'FPTR_GD_NONFISCAL_DOC'
      'FPTR_GD_NONFISCAL_DOC_VOID'
      'FPTR_GD_NONFISCAL_REC'
      'FPTR_GD_SIMP_INVOICE'
      'FPTR_GD_TENDER'
      'FPTR_GD_LINECOUNT'
      'FPTR_GD_DESCRIPTION_LENGTH')
  end
  object edtOptArgs: TTntEdit
    Left = 64
    Top = 32
    Width = 57
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object edtData: TTntEdit
    Left = 168
    Top = 32
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object btnGetTotalizer: TTntButton
    Left = 288
    Top = 224
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'GetTotalizer'
    TabOrder = 5
    OnClick = btnGetTotalizerClick
  end
  object edtVatID: TTntEdit
    Left = 80
    Top = 144
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = '0'
  end
  object Edit1: TTntEdit
    Left = 80
    Top = 168
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
    Text = '0'
  end
  object Edit2: TTntEdit
    Left = 80
    Top = 192
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
  end
  object cbTotalizerType: TTntComboBox
    Left = 80
    Top = 120
    Width = 305
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      'FPTR_TT_DOCUMENT'
      'FPTR_TT_DAY'
      'FPTR_TT_RECEIPT'
      'FPTR_TT_GRAND')
  end
end
