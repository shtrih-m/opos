object fmWeight: TfmWeight
  Left = 421
  Top = 208
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Weight'
  ClientHeight = 303
  ClientWidth = 391
  Color = clBtnFace
  DefaultMonitor = dmPrimary
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblTareWeight: TLabel
    Left = 8
    Top = 176
    Width = 59
    Height = 13
    Caption = 'Tare weight:'
  end
  object lblWeight: TLabel
    Left = 8
    Top = 8
    Width = 37
    Height = 13
    Caption = 'Weight:'
  end
  object lblPrice: TLabel
    Left = 136
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object lblAmount: TLabel
    Left = 264
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 208
    Width = 377
    Height = 17
    Shape = bsTopLine
  end
  object pnlWeight: TPanel
    Left = 8
    Top = 24
    Width = 121
    Height = 49
    BevelOuter = bvLowered
    BorderWidth = 5
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -29
    Font.Name = 'Arial Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblWeightValue: TLabel
      Left = 6
      Top = 6
      Width = 109
      Height = 37
      Align = alClient
      Alignment = taRightJustify
      Caption = '999.999'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -29
      Font.Name = 'Arial Unicode'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
  end
  object btnSetTare: TButton
    Left = 248
    Top = 144
    Width = 137
    Height = 25
    Caption = 'Set tare'
    TabOrder = 1
  end
  object btnZeroScale: TButton
    Left = 248
    Top = 112
    Width = 137
    Height = 25
    Caption = 'Zero scale'
    TabOrder = 2
  end
  object btnSetTareValue: TButton
    Left = 248
    Top = 176
    Width = 137
    Height = 25
    Caption = 'Set tare value'
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 72
    Top = 176
    Width = 169
    Height = 21
    MaxLength = 5
    TabOrder = 4
    Text = '0'
  end
  object chbAutoUpdate: TCheckBox
    Left = 8
    Top = 80
    Width = 137
    Height = 17
    Caption = 'Autoupdate values'
    TabOrder = 5
  end
  object pnlPrice: TPanel
    Left = 136
    Top = 24
    Width = 121
    Height = 49
    BevelOuter = bvLowered
    BorderWidth = 5
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -29
    Font.Name = 'Arial Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object lblPriceValue: TLabel
      Left = 6
      Top = 6
      Width = 109
      Height = 37
      Align = alClient
      Alignment = taRightJustify
      Caption = '999.999'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -29
      Font.Name = 'Arial Unicode'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pblAmount: TPanel
    Left = 264
    Top = 24
    Width = 121
    Height = 49
    BevelOuter = bvLowered
    BorderWidth = 5
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -29
    Font.Name = 'Arial Unicode'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    object lblAmountValue: TLabel
      Left = 6
      Top = 6
      Width = 109
      Height = 37
      Align = alClient
      Alignment = taRightJustify
      Caption = '999.999'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -29
      Font.Name = 'Arial Unicode'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
  end
  object btnUpdateWeight: TButton
    Left = 248
    Top = 80
    Width = 137
    Height = 25
    Caption = 'Read weight'
    TabOrder = 8
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 160
    Top = 80
  end
end
