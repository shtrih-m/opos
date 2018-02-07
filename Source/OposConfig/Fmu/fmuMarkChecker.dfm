object fmMarkChecker: TfmMarkChecker
  Left = 655
  Top = 219
  AutoScroll = False
  Caption = 'Marking'
  ClientHeight = 429
  ClientWidth = 612
  Color = clBtnFace
  Constraints.MinHeight = 265
  Constraints.MinWidth = 280
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblEkmServerHost: TTntLabel
    Left = 40
    Top = 56
    Width = 53
    Height = 13
    Caption = 'IP address:'
  end
  object lblEkmServerPort: TTntLabel
    Left = 40
    Top = 88
    Width = 73
    Height = 13
    Caption = 'Port (0..65535):'
  end
  object lblEkmServerTimeout: TTntLabel
    Left = 40
    Top = 120
    Width = 120
    Height = 13
    Caption = 'Timeout, seconds (1..30):'
  end
  object chkEkmServerEnabled: TTntCheckBox
    Left = 8
    Top = 32
    Width = 417
    Height = 17
    Caption = 'Check marking on EKM server (conection to EKM server is needed)'
    TabOrder = 1
  end
  object edtEkmServerHost: TTntEdit
    Left = 168
    Top = 56
    Width = 137
    Height = 21
    TabOrder = 2
  end
  object seEkmServerPort: TSpinEdit
    Left = 168
    Top = 88
    Width = 137
    Height = 22
    MaxValue = 65535
    MinValue = 0
    TabOrder = 3
    Value = 0
  end
  object seEkmServerTimeout: TSpinEdit
    Left = 168
    Top = 120
    Width = 137
    Height = 22
    MaxValue = 30
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object chkFSMarkCheckEnabled: TTntCheckBox
    Left = 8
    Top = 8
    Width = 417
    Height = 17
    Caption = 'Check marking in fiscal storage (version 1.1 or later)'
    TabOrder = 0
  end
end
