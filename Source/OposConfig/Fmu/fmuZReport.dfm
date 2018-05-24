object fmZReport: TfmZReport
  Left = 512
  Top = 214
  Width = 384
  Height = 373
  Caption = 'Z report'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    368
    335)
  PixelsPerInch = 96
  TextHeight = 13
  object lblXmlZReportFileName: TTntLabel
    Left = 40
    Top = 40
    Width = 107
    Height = 13
    Caption = 'XML Z report filename:'
  end
  object llblCsvZReportFileName: TTntLabel
    Left = 40
    Top = 112
    Width = 106
    Height = 13
    Caption = 'CSV Z report filename:'
  end
  object lblReceiptReportFileName: TTntLabel
    Left = 40
    Top = 184
    Width = 112
    Height = 13
    Caption = 'Receipt report filename:'
  end
  object chbXmlZReportEnabled: TTntCheckBox
    Left = 16
    Top = 16
    Width = 193
    Height = 17
    Caption = 'XML Z report enabled'
    TabOrder = 0
  end
  object edtXmlZReportFileName: TTntEdit
    Left = 40
    Top = 56
    Width = 329
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'edtXmlZReportFileName'
  end
  object chbCsvZReportEnabled: TTntCheckBox
    Left = 16
    Top = 88
    Width = 153
    Height = 17
    Caption = 'CSV Z report enabled'
    TabOrder = 2
  end
  object edtCsvZReportFileName: TTntEdit
    Left = 40
    Top = 128
    Width = 329
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'edtCsvZReportFileName'
  end
  object chbReceiptReportEnabled: TTntCheckBox
    Left = 16
    Top = 160
    Width = 153
    Height = 17
    Caption = 'Receipt report enabled'
    TabOrder = 4
  end
  object edtReceiptReportFileName: TTntEdit
    Left = 39
    Top = 200
    Width = 329
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = 'edtReceiptReportFileName'
  end
  object chbReportDateStamp: TTntCheckBox
    Left = 16
    Top = 240
    Width = 345
    Height = 17
    Caption = 'Add report date to file name (HHmmDDMMYY)'
    TabOrder = 6
  end
end
