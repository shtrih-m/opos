object fmFptrNonFiscal: TfmFptrNonFiscal
  Left = 581
  Top = 327
  AutoScroll = False
  Caption = 'NonFiscal'
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
  object lblStation: TTntLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Station:'
  end
  object lblData: TTntLabel
    Left = 8
    Top = 64
    Width = 26
    Height = 13
    Caption = 'Data:'
  end
  object btnEndNonFiscal: TTntButton
    Left = 272
    Top = 240
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'EndNonFiscal'
    TabOrder = 7
    OnClick = btnEndNonFiscalClick
  end
  object edtStation: TTntEdit
    Left = 80
    Top = 8
    Width = 81
    Height = 21
    TabOrder = 0
    Text = '2'
  end
  object btnBeginNonFiscal: TTntButton
    Left = 272
    Top = 176
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'BeginNonFiscal'
    TabOrder = 5
    OnClick = btnBeginNonFiscalClick
  end
  object btnPrintNormal: TTntButton
    Left = 272
    Top = 208
    Width = 113
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'PrintNormal'
    TabOrder = 6
    OnClick = btnPrintNormalClick
  end
  object chbReceipt: TTntCheckBox
    Left = 168
    Top = 8
    Width = 129
    Height = 17
    Caption = 'FPTR_S_RECEIPT'
    TabOrder = 1
    OnClick = chbReceiptClick
  end
  object chbJournal: TTntCheckBox
    Left = 168
    Top = 32
    Width = 129
    Height = 17
    Caption = 'FPTR_S_JOURNAL'
    TabOrder = 2
    OnClick = chbReceiptClick
  end
  object chbSlip: TTntCheckBox
    Left = 168
    Top = 56
    Width = 137
    Height = 17
    Caption = 'FPTR_S_SLIP'
    TabOrder = 3
    OnClick = chbReceiptClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 80
    Width = 379
    Height = 89
    Anchors = [akLeft, akTop, akRight, akBottom]
    BiDiMode = bdLeftToRight
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      '****************************************'
      ''
      '        Nonfiscal line 1'
      '        Nonfiscal line 2'
      '        Nonfiscal line 3'
      ''
      '****************************************')
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 4
  end
end
