object fmScaleGeneral: TfmScaleGeneral
  Left = 432
  Top = 143
  Width = 399
  Height = 474
  Caption = 'General'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    391
    447)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDeviceName: TLabel
    Left = 8
    Top = 12
    Width = 65
    Height = 13
    Caption = 'DeviceName:'
  end
  object lblTimeout: TLabel
    Left = 8
    Top = 76
    Width = 41
    Height = 13
    Caption = 'Timeout:'
  end
  object lblOpenResult: TLabel
    Left = 8
    Top = 46
    Width = 59
    Height = 13
    Caption = 'OpenResult:'
  end
  object Bevel2: TBevel
    Left = 6
    Top = 104
    Width = 377
    Height = 9
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object lblPowerNotify: TLabel
    Left = 152
    Top = 116
    Width = 60
    Height = 13
    Caption = 'PowerNotify:'
  end
  object lblStatusNotify: TLabel
    Left = 152
    Top = 140
    Width = 60
    Height = 13
    Caption = 'StatusNotify:'
  end
  object lblTareWeight: TLabel
    Left = 152
    Top = 164
    Width = 59
    Height = 13
    Caption = 'TareWeight:'
  end
  object lblUnitPrice: TLabel
    Left = 152
    Top = 188
    Width = 46
    Height = 13
    Caption = 'UnitPrice:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 256
    Width = 377
    Height = 9
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object lblText: TLabel
    Left = 8
    Top = 312
    Width = 24
    Height = 13
    Caption = 'Text:'
  end
  object lblWeightData: TLabel
    Left = 8
    Top = 264
    Width = 60
    Height = 13
    Caption = 'WeightData:'
  end
  object Label1: TLabel
    Left = 8
    Top = 288
    Width = 41
    Height = 13
    Caption = 'Timeout:'
  end
  object Label2: TLabel
    Left = 8
    Top = 368
    Width = 36
    Height = 13
    Caption = 'Events:'
  end
  object lblLiveWeight: TLabel
    Left = 8
    Top = 336
    Width = 57
    Height = 13
    Caption = 'LiveWeight:'
  end
  object lblSalesPrice: TLabel
    Left = 152
    Top = 212
    Width = 53
    Height = 13
    Caption = 'SalesPrice:'
  end
  object btnOpen: TButton
    Left = 232
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Open'
    TabOrder = 3
    OnClick = btnOpenClick
  end
  object btnClose: TButton
    Left = 312
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Close'
    TabOrder = 4
    OnClick = btnCloseClick
  end
  object btnRelease: TButton
    Left = 312
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Release'
    TabOrder = 7
    OnClick = btnReleaseClick
  end
  object btnClaim: TButton
    Left = 232
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Claim'
    TabOrder = 6
    OnClick = btnClaimClick
  end
  object edtTimeout: TEdit
    Left = 80
    Top = 72
    Width = 145
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = '0'
  end
  object edtOpenResult: TEdit
    Left = 80
    Top = 40
    Width = 145
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
  object btnUpdateDevices: TButton
    Left = 312
    Top = 8
    Width = 73
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 1
    OnClick = btnUpdateDevicesClick
  end
  object cbDeviceName: TComboBox
    Left = 80
    Top = 8
    Width = 225
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object chbDeviceEnabled: TCheckBox
    Left = 8
    Top = 112
    Width = 113
    Height = 17
    Caption = 'DeviceEnabled'
    TabOrder = 8
    OnClick = chbDeviceEnabledClick
  end
  object chbFreezeEvents: TCheckBox
    Left = 8
    Top = 184
    Width = 105
    Height = 17
    Caption = 'FreezeEvents'
    TabOrder = 11
    OnClick = chbFreezeEventsClick
  end
  object chbAsyncMode: TCheckBox
    Left = 8
    Top = 208
    Width = 105
    Height = 17
    Caption = 'AsyncMode'
    TabOrder = 12
    OnClick = chbAsyncModeClick
  end
  object chbAutoDisable: TCheckBox
    Left = 8
    Top = 136
    Width = 97
    Height = 17
    Caption = 'AutoDisable'
    TabOrder = 9
    OnClick = chbAutoDisableClick
  end
  object chbDataEventEnabled: TCheckBox
    Left = 8
    Top = 160
    Width = 129
    Height = 17
    Caption = 'DataEventEnabled'
    TabOrder = 10
    OnClick = chbDataEventEnabledClick
  end
  object cbPowerNotify: TComboBox
    Left = 240
    Top = 112
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 14
    OnChange = cbPowerNotifyChange
    Items.Strings = (
      'PN_DISABLED'
      'PN_ENABLED')
  end
  object cbStatusNotify: TComboBox
    Left = 240
    Top = 136
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 15
    OnChange = cbStatusNotifyChange
    Items.Strings = (
      'SCAL_SN_DISABLED'
      'SCAL_SN_ENABLED')
  end
  object edtTareWeight: TEdit
    Left = 240
    Top = 160
    Width = 97
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 16
    Text = 'edtTareWeight'
  end
  object btnSetTareWeight: TButton
    Left = 342
    Top = 160
    Width = 43
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Set'
    TabOrder = 17
    OnClick = btnSetTareWeightClick
  end
  object edtUnitPrice: TEdit
    Left = 240
    Top = 184
    Width = 97
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 18
    Text = 'edtUnitPrice'
  end
  object btnSetUnitPrice: TButton
    Left = 342
    Top = 184
    Width = 43
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Set'
    TabOrder = 19
    OnClick = btnSetUnitPriceClick
  end
  object btnUpdatePage: TButton
    Left = 208
    Top = 416
    Width = 97
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'UpdatePage'
    TabOrder = 30
    OnClick = btnUpdatePageClick
  end
  object chbZeroValid: TCheckBox
    Left = 8
    Top = 232
    Width = 105
    Height = 17
    Caption = 'ZeroValid'
    TabOrder = 13
    OnClick = chbZeroValidClick
  end
  object memEvents: TMemo
    Left = 8
    Top = 384
    Width = 377
    Height = 25
    Anchors = [akLeft, akTop, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 28
  end
  object btnClearEvents: TButton
    Left = 312
    Top = 416
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 29
    OnClick = btnClearEventsClick
  end
  object btnDisplayText: TButton
    Left = 312
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'DisplayText'
    TabOrder = 26
    OnClick = btnDisplayTextClick
  end
  object edtScaleText: TEdit
    Left = 80
    Top = 312
    Width = 225
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 25
    Text = 'NCR 7874'
  end
  object btnReadWeight: TButton
    Left = 216
    Top = 264
    Width = 75
    Height = 41
    Anchors = [akTop, akRight]
    Caption = 'ReadWeight'
    TabOrder = 21
    OnClick = btnReadWeightClick
  end
  object edtWeightData: TEdit
    Left = 80
    Top = 264
    Width = 129
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 22
  end
  object edtReadWeightTimeout: TEdit
    Left = 80
    Top = 288
    Width = 129
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 23
    Text = '4000'
  end
  object btnZeroScale: TButton
    Left = 296
    Top = 264
    Width = 89
    Height = 41
    Anchors = [akTop, akRight]
    Caption = 'ZeroScale'
    TabOrder = 24
    OnClick = btnZeroScaleClick
  end
  object edtLiveWeight: TEdit
    Left = 80
    Top = 336
    Width = 225
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 27
  end
  object edtSalesPrice: TEdit
    Left = 240
    Top = 208
    Width = 97
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 20
    Text = 'edtSalesPrice'
  end
  object chbLiveWeightUpdate: TCheckBox
    Left = 80
    Top = 360
    Width = 305
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Enable LiveWeight update timer (100 ms)'
    TabOrder = 31
    OnClick = chbLiveWeightUpdateClick
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 8
    Top = 416
  end
end
