object fmFptrFiscalDocument: TfmFptrFiscalDocument
  Left = 365
  Top = 217
  AutoScroll = False
  Caption = 'Fiscal Document'
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
  object lblAmount: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object lblLine: TTntLabel
    Left = 8
    Top = 72
    Width = 23
    Height = 13
    Caption = 'Line:'
  end
  object btnBeginFiscalDocument: TTntButton
    Left = 248
    Top = 8
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'BeginFiscalDocument'
    TabOrder = 0
    OnClick = btnBeginFiscalDocumentClick
  end
  object edtAmount: TTntEdit
    Left = 80
    Top = 8
    Width = 161
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '0'
  end
  object btnEndFiscalDocument: TTntButton
    Left = 248
    Top = 40
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'EndFiscalDocument'
    TabOrder = 2
    OnClick = btnEndFiscalDocumentClick
  end
  object btnPrintFiscalDocumentLine: TTntButton
    Left = 248
    Top = 104
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintFiscalDocumentLine'
    TabOrder = 3
    OnClick = btnPrintFiscalDocumentLineClick
  end
  object edtLine: TTntEdit
    Left = 40
    Top = 72
    Width = 345
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = 'String for printing'
  end
end
