object fmFptrTables: TfmFptrTables
  Left = 367
  Top = 258
  Width = 442
  Height = 289
  Caption = 'Tables'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    426
    251)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTableFilePath: TLabel
    Left = 24
    Top = 64
    Width = 70
    Height = 13
    Caption = 'Table file path:'
  end
  object chbTableEditEnabled: TCheckBox
    Left = 8
    Top = 8
    Width = 361
    Height = 17
    Caption = 'Table values changing enabled'
    TabOrder = 0
  end
  object chbWritePaymentNameEnabled: TCheckBox
    Left = 24
    Top = 32
    Width = 361
    Height = 17
    Caption = 'Write payment name enabled (via directIO)'
    TabOrder = 1
  end
  object edtTableFilePath: TEdit
    Left = 104
    Top = 64
    Width = 313
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
end
