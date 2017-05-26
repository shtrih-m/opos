object fmScaleLog: TfmScaleLog
  Left = 579
  Top = 224
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Log'
  ClientHeight = 173
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    384
    173)
  PixelsPerInch = 96
  TextHeight = 13
  object gbLogParameters: TGroupBox
    Left = 8
    Top = 8
    Width = 369
    Height = 161
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Log parameters'
    TabOrder = 0
    object lblMaxLogFileCount: TLabel
      Left = 32
      Top = 56
      Width = 110
      Height = 13
      Caption = 'Maximum log file count:'
    end
    object chbLogEnabled: TCheckBox
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
      Top = 56
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
  end
end
