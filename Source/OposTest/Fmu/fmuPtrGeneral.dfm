object fmPtrGeneral: TfmPtrGeneral
  Left = 409
  Top = 447
  AutoScroll = False
  Caption = 'General'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDeviceName: TTntLabel
    Left = 8
    Top = 8
    Width = 65
    Height = 13
    Caption = 'DeviceName:'
  end
  object lblTimeout: TTntLabel
    Left = 8
    Top = 72
    Width = 41
    Height = 13
    Caption = 'Timeout:'
  end
  object lblOpenResult: TTntLabel
    Left = 8
    Top = 40
    Width = 59
    Height = 13
    Caption = 'OpenResult:'
  end
  object lblLevel: TTntLabel
    Left = 8
    Top = 152
    Width = 29
    Height = 13
    Caption = 'Level:'
  end
  object lblCheckHealthText: TTntLabel
    Left = 8
    Top = 184
    Width = 86
    Height = 13
    Caption = 'CheckHealthText:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 136
    Width = 378
    Height = 9
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object btnOpen: TTntButton
    Left = 232
    Top = 40
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Open'
    TabOrder = 2
    OnClick = btnOpenClick
  end
  object btnClose: TTntButton
    Left = 312
    Top = 40
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Close'
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnRelease: TTntButton
    Left = 312
    Top = 72
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Release'
    TabOrder = 7
    OnClick = btnReleaseClick
  end
  object btnClaim: TTntButton
    Left = 232
    Top = 72
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Claim'
    TabOrder = 6
    OnClick = btnClaimClick
  end
  object edtTimeout: TTntEdit
    Left = 80
    Top = 72
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '0'
  end
  object edtOpenResult: TTntEdit
    Left = 80
    Top = 40
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 8
  end
  object btnUpdatePrinterDevice: TTntButton
    Left = 312
    Top = 8
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 1
    OnClick = btnUpdatePrinterDeviceClick
  end
  object cbPrinterDeviceName: TTntComboBox
    Left = 80
    Top = 8
    Width = 226
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object cbLevel: TTntComboBox
    Left = 80
    Top = 152
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      'CH_INTERNAL'
      'CH_EXTERNAL'
      'CH_INTERACTIVE')
  end
  object btnCheckHealth: TTntButton
    Left = 232
    Top = 152
    Width = 153
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'CheckHealth'
    TabOrder = 10
    OnClick = btnCheckHealthClick
  end
  object CheckHealthText: TTntMemo
    Left = 8
    Top = 200
    Width = 377
    Height = 65
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 11
  end
  object chbDeviceEnabled: TTntCheckBox
    Left = 80
    Top = 104
    Width = 113
    Height = 17
    Caption = 'Device enabled'
    TabOrder = 5
    OnClick = chbDeviceEnabledClick
  end
end
