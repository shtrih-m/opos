object fmTextReceipt: TfmTextReceipt
  Left = 252
  Top = 196
  AutoScroll = False
  Caption = 'Text receipt'
  ClientHeight = 344
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    408
    344)
  PixelsPerInch = 96
  TextHeight = 13
  object lblBlock1: TLabel
    Left = 8
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Block1:'
  end
  object lblBlock2: TLabel
    Left = 8
    Top = 176
    Width = 36
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Block2:'
  end
  object memBlock1: TMemo
    Left = 8
    Top = 24
    Width = 394
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '-------------------------------------------'
      #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1050#1072#1088#1090#1077
      #1050#1072#1088#1090#1072':                               123456'
      #1058#1077#1088#1084#1080#1085#1072#1083':                            123456'
      #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103':                         12:34'
      #1054#1089#1090#1072#1090#1086#1082' '#1073#1086#1085#1091#1089#1086#1074' '#1085#1072' '#1089#1095#1105#1090#1077':           10 '#1088#1091#1073'.'
      #1042' '#1090#1086#1084' '#1095#1080#1089#1083#1077' '#1076#1086#1089#1090#1091#1087#1085#1099#1093' '#1076#1083#1103' '#1089#1087#1080#1089#1072#1085#1080#1103': 10 '#1088#1091#1073'.'
      #1054#1089#1090#1072#1090#1086#1082' '#1073#1086#1085#1091#1089#1086#1074' '#1085#1072' '#1089#1095#1105#1090#1077' '#1074' '#1088#1091#1073#1083#1103#1093':  10 '#1088#1091#1073'.'
      ''
      '-------------------------------------------')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnSave: TButton
    Left = 328
    Top = 312
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Save'
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object memBlock2: TMemo
    Left = 8
    Top = 192
    Width = 394
    Height = 81
    Anchors = [akLeft, akRight, akBottom]
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
  object btnLoad: TButton
    Left = 328
    Top = 280
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Load'
    TabOrder = 4
    OnClick = btnLoadClick
  end
  object chbNewCheck: TCheckBox
    Left = 8
    Top = 280
    Width = 89
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = #1053#1086#1074#1099#1081' '#1095#1077#1082
    TabOrder = 2
  end
  object btnSetDefaults: TButton
    Left = 248
    Top = 280
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Defaults'
    TabOrder = 3
    OnClick = btnSetDefaultsClick
  end
  object btnPrint: TButton
    Left = 248
    Top = 312
    Width = 74
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Print'
    TabOrder = 6
    OnClick = btnPrintClick
  end
end
