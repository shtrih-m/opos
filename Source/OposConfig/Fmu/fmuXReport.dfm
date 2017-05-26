object fmXReport: TfmXReport
  Left = 512
  Top = 214
  Width = 384
  Height = 373
  Caption = 'X report'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblXReport: TLabel
    Left = 8
    Top = 24
    Width = 40
    Height = 13
    Caption = 'X report:'
  end
  object cbXReport: TComboBox
    Left = 64
    Top = 24
    Width = 209
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'X report'
      'Fiscal storage calculations report')
  end
end
