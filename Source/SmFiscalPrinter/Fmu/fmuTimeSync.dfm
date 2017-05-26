object fmTimeSync: TfmTimeSync
  Left = 678
  Top = 285
  Width = 270
  Height = 326
  BorderIcons = []
  Caption = #1057#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1103' '#1074#1088#1077#1084#1077#1085#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lblTimeSync: TLabel
    Left = 16
    Top = 16
    Width = 227
    Height = 29
    Caption = #1057#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1103' '#1074#1088#1077#1084#1077#1085#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -24
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 88
    Width = 160
    Height = 29
    Caption = #1042#1088#1077#1084#1103' '#1086#1078#1080#1076#1072#1085#1080#1103':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object lblTimeLeft: TLabel
    Left = 192
    Top = 88
    Width = 49
    Height = 29
    Caption = '00:01'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -24
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 96
    Top = 48
    Width = 74
    Height = 29
    Caption = #1060#1056' '#1080' '#1055#1050
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clNavy
    Font.Height = -24
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
  end
  object btnCancel: TPngBitBtn
    Left = 32
    Top = 216
    Width = 193
    Height = 65
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 0
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 24
    Top = 112
  end
end
