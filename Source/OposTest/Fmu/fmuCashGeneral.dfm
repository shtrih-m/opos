object fmCashGeneral: TfmCashGeneral
  Left = 858
  Top = 305
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'General'
  ClientHeight = 302
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    392
    302)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCashDeviceName: TTntLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'DeviceName:'
  end
  object lblEvents: TTntLabel
    Left = 8
    Top = 200
    Width = 36
    Height = 13
    Caption = 'Events:'
  end
  object lblStatus: TTntLabel
    Left = 8
    Top = 168
    Width = 33
    Height = 13
    Caption = 'Status:'
  end
  object lblCashOpenResult: TTntLabel
    Left = 8
    Top = 136
    Width = 59
    Height = 13
    Caption = 'OpenResult:'
  end
  object lblTimeout: TTntLabel
    Left = 8
    Top = 104
    Width = 41
    Height = 13
    Caption = 'Timeout:'
  end
  object cbCashDeviceName: TTntComboBox
    Left = 80
    Top = 8
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnUpdateCashDevice: TTntButton
    Left = 232
    Top = 8
    Width = 153
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Update device names'
    TabOrder = 2
    OnClick = btnUpdateCashDeviceClick
  end
  object btnOpen: TTntButton
    Left = 232
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Open'
    TabOrder = 3
    OnClick = btnOpenClick
  end
  object btnClose: TTntButton
    Left = 312
    Top = 72
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnRelease: TTntButton
    Left = 312
    Top = 104
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Release'
    TabOrder = 5
    OnClick = btnReleaseClick
  end
  object btnClaim: TTntButton
    Left = 232
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Claim'
    TabOrder = 6
    OnClick = btnClaimClick
  end
  object btnOpenDrawer: TTntButton
    Left = 232
    Top = 136
    Width = 153
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OpenDrawer'
    TabOrder = 7
    OnClick = btnOpenDrawerClick
  end
  object btnGetStatus: TTntButton
    Left = 232
    Top = 168
    Width = 153
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Get drawer status'
    TabOrder = 8
    OnClick = btnGetStatusClick
  end
  object btnClearEvents: TTntButton
    Left = 296
    Top = 272
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear events'
    TabOrder = 9
    OnClick = btnClearEventsClick
  end
  object memEvents: TTntMemo
    Left = 80
    Top = 200
    Width = 306
    Height = 65
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 10
  end
  object edtStatus: TTntEdit
    Left = 80
    Top = 168
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 11
  end
  object edtCashOpenResult: TTntEdit
    Left = 80
    Top = 136
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 12
  end
  object edtTimeout: TTntEdit
    Left = 80
    Top = 104
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 13
    Text = '0'
  end
  object chbDeviceEnabled: TTntCheckBox
    Left = 80
    Top = 72
    Width = 137
    Height = 17
    Caption = 'Device enabled'
    TabOrder = 14
    OnClick = chbDeviceEnabledClick
  end
  object cbDeviceType: TTntComboBox
    Left = 80
    Top = 40
    Width = 146
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'CCO RCS'
      'CCO NCR')
  end
end
