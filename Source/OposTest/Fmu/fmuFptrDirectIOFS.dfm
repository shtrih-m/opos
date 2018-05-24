object fmFptrDirectIOFS: TfmFptrDirectIOFS
  Left = 483
  Top = 201
  AutoScroll = False
  Caption = 'DirectIO FS document'
  ClientHeight = 320
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    472
    320)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDocNumber: TTntLabel
    Left = 10
    Top = 294
    Width = 90
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Document number:'
  end
  object btnPrintFSDocument: TTntButton
    Left = 345
    Top = 288
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Print FS document'
    TabOrder = 2
    OnClick = btnPrintFSDocumentClick
  end
  object Memo: TTntMemo
    Left = 8
    Top = 8
    Width = 458
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
  end
  object btnReadFSDocument: TTntButton
    Left = 217
    Top = 288
    Width = 121
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Read FS document'
    TabOrder = 3
    OnClick = btnReadFSDocumentClick
  end
  object seDocumentNumber: TSpinEdit
    Left = 114
    Top = 288
    Width = 92
    Height = 22
    Anchors = [akRight, akBottom]
    MaxValue = 99999999
    MinValue = 1
    TabOrder = 1
    Value = 1
  end
end
