object fmFptrLog: TfmFptrLog
  Left = 536
  Top = 304
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Log'
  ClientHeight = 191
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    482
    191)
  PixelsPerInch = 96
  TextHeight = 13
  object gbLogParameters: TTntGroupBox
    Left = 8
    Top = 8
    Width = 467
    Height = 161
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Log parameters'
    TabOrder = 0
    DesignSize = (
      467
      161)
    object lblMaxLogFileCount: TTntLabel
      Left = 32
      Top = 96
      Width = 110
      Height = 13
      Caption = 'Maximum log file count:'
    end
    object lblLogFilePath: TTntLabel
      Left = 32
      Top = 56
      Width = 61
      Height = 13
      Caption = 'Log file path:'
    end
    object Label1: TLabel
      Left = 280
      Top = 104
      Width = 124
      Height = 13
      Caption = '0 - unlimited log files count'
    end
    object chbLogEnabled: TTntCheckBox
      Left = 8
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Log file enabled'
      TabOrder = 0
      OnClick = PageChange
    end
    object seMaxLogFileCount: TSpinEdit
      Left = 152
      Top = 96
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
    object edtLogFilePath: TTntEdit
      Left = 152
      Top = 56
      Width = 307
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Text = 'edtLogFilePath'
    end
  end
end
