object fmMode: TfmMode
  Left = 511
  Top = 196
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Mode'
  ClientHeight = 293
  ClientWidth = 375
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    375
    293)
  PixelsPerInch = 96
  TextHeight = 13
  object gbConnectionParams: TGroupBox
    Left = 8
    Top = 8
    Width = 361
    Height = 137
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Connection parameters'
    TabOrder = 0
    DesignSize = (
      361
      137)
    object lblComPort: TLabel
      Left = 16
      Top = 24
      Width = 48
      Height = 13
      Caption = 'COM port:'
    end
    object lblBaudRate: TLabel
      Left = 16
      Top = 56
      Width = 51
      Height = 13
      Caption = 'BaudRate:'
    end
    object lblTimeout: TLabel
      Left = 16
      Top = 88
      Width = 41
      Height = 13
      Caption = 'Timeout:'
    end
    object cbBaudRate: TComboBox
      Left = 96
      Top = 56
      Width = 129
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        '2400'
        '4800'
        '9600'
        '19200'
        '38400'
        '57600'
        '115200')
    end
    object btnReadParameters: TButton
      Left = 232
      Top = 24
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Read parameters'
      TabOrder = 3
      OnClick = btnReadParametersClick
    end
    object btnWriteParameters: TButton
      Left = 232
      Top = 56
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Write parameters'
      TabOrder = 4
      OnClick = btnWriteParametersClick
    end
    object sePortNumber: TSpinEdit
      Left = 96
      Top = 24
      Width = 129
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object seTimeout: TSpinEdit
      Left = 96
      Top = 88
      Width = 129
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 0
    end
  end
  object gbScaleMode: TGroupBox
    Left = 8
    Top = 152
    Width = 361
    Height = 137
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Scale mode'
    TabOrder = 1
    DesignSize = (
      361
      137)
    object rbWeightMode: TRadioButton
      Left = 16
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Weight mode'
      TabOrder = 0
    end
    object rbGraduationMode: TRadioButton
      Left = 16
      Top = 64
      Width = 113
      Height = 17
      Caption = 'Graduation mode'
      TabOrder = 1
    end
    object rbDataMode: TRadioButton
      Left = 16
      Top = 96
      Width = 113
      Height = 17
      Caption = 'Data mode'
      TabOrder = 2
    end
    object btnReadMode: TButton
      Left = 232
      Top = 24
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Read mode'
      TabOrder = 3
      OnClick = btnReadModeClick
    end
    object btnWriteMode: TButton
      Left = 232
      Top = 56
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Write mode'
      TabOrder = 4
      OnClick = btnWriteModeClick
    end
  end
end
