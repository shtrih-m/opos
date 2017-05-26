object fmTextBlock: TfmTextBlock
  Left = 391
  Top = 329
  AutoScroll = False
  Caption = 'Text block'
  ClientHeight = 368
  ClientWidth = 343
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    343
    368)
  PixelsPerInch = 96
  TextHeight = 13
  object lblHeader: TLabel
    Left = 8
    Top = 8
    Width = 38
    Height = 13
    Caption = 'Header:'
  end
  object lblTrailer: TLabel
    Left = 8
    Top = 112
    Width = 32
    Height = 13
    Caption = 'Trailer:'
  end
  object lblResult: TLabel
    Left = 8
    Top = 216
    Width = 33
    Height = 13
    Caption = 'Result:'
  end
  object btnSaveBlock: TButton
    Left = 120
    Top = 336
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save block'
    TabOrder = 4
    OnClick = btnSaveBlockClick
  end
  object memHeader: TMemo
    Left = 8
    Top = 24
    Width = 329
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'ChequeBlock1, Line1'
      'ChequeBlock1, Line2'
      'ChequeBlock1, Line3')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnSalesReceipt: TButton
    Left = 232
    Top = 304
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Sales receipt'
    TabOrder = 5
    OnClick = btnSalesReceiptClick
  end
  object btnLoadBlock: TButton
    Left = 120
    Top = 304
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Load block'
    TabOrder = 3
    OnClick = btnLoadBlockClick
  end
  object btnRefundReceipt: TButton
    Left = 232
    Top = 336
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Refund receipt'
    TabOrder = 6
    OnClick = btnRefundReceiptClick
  end
  object memTrailer: TMemo
    Left = 8
    Top = 128
    Width = 329
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'ChequeBlock2, Line1'
      'ChequeBlock2, Line2'
      'ChequeBlock2, Line3')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object chbInvalidTime: TCheckBox
    Left = 8
    Top = 304
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Invalid time'
    TabOrder = 2
  end
  object Memo: TMemo
    Left = 6
    Top = 232
    Width = 329
    Height = 57
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object btnDefaultBlocks: TButton
    Left = 8
    Top = 336
    Width = 105
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Set defaults'
    TabOrder = 8
    OnClick = btnDefaultBlocksClick
  end
end
