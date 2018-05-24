object fmMain: TfmMain
  Left = 600
  Top = 311
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'OPOS setup utility'
  ClientHeight = 311
  ClientWidth = 413
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
    413
    311)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDevices: TTntLabel
    Left = 112
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Devices:'
  end
  object lblDeviceType: TTntLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Device type:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 272
    Width = 401
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsTopLine
  end
  object lbDevices: TTntListBox
    Left = 112
    Top = 24
    Width = 209
    Height = 241
    Anchors = [akLeft, akTop, akBottom]
    BiDiMode = bdRightToLeftNoAlign
    ItemHeight = 13
    ParentBiDiMode = False
    TabOrder = 1
    OnClick = lbDevicesClick
    OnDblClick = EditDeviceClick
    OnKeyDown = lbDevicesKeyDown
  end
  object btnAddDevice: TTntBitBtn
    Left = 328
    Top = 88
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Add device'
    TabOrder = 4
    OnClick = btnAddDeviceClick
  end
  object btnDeleteDevice: TTntBitBtn
    Left = 328
    Top = 56
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Delete device'
    Enabled = False
    TabOrder = 3
    OnClick = btnDeleteDeviceClick
    NumGlyphs = 2
  end
  object btnEditDevice: TTntBitBtn
    Left = 328
    Top = 24
    Width = 81
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Edit device'
    Enabled = False
    TabOrder = 2
    OnClick = EditDeviceClick
    NumGlyphs = 2
  end
  object lbDeviceType: TTntListBox
    Left = 8
    Top = 24
    Width = 97
    Height = 241
    ItemHeight = 13
    Items.Strings = (
      'Fiscal Printer'
      'Cash Drawer'
      'POS Printer')
    TabOrder = 0
    OnClick = lbDeviceTypeClick
  end
  object btnClose: TTntButton
    Left = 328
    Top = 280
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Close'
    TabOrder = 5
    OnClick = btnCloseClick
  end
end
