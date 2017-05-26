object fmPages: TfmPages
  Left = 382
  Top = 179
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Scale service page'
  ClientHeight = 408
  ClientWidth = 528
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
    528
    408)
  PixelsPerInch = 96
  TextHeight = 13
  object lblResult: TLabel
    Left = 8
    Top = 328
    Width = 33
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Result:'
  end
  object lblTxData: TLabel
    Left = 8
    Top = 352
    Width = 41
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'TX data:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblRxData: TLabel
    Left = 8
    Top = 376
    Width = 42
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'RX data:'
  end
  object btnOK: TButton
    Left = 376
    Top = 376
    Width = 147
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object lbPages: TListBox
    Left = 8
    Top = 8
    Width = 121
    Height = 313
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 18
    TabOrder = 1
    OnClick = lbPagesClick
  end
  object pnlPage: TPanel
    Left = 136
    Top = 8
    Width = 385
    Height = 313
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    Caption = 'pnlPage'
    TabOrder = 2
  end
  object edtRecieve: TEdit
    Left = 64
    Top = 376
    Width = 305
    Height = 21
    TabStop = False
    Anchors = [akLeft, akRight, akBottom]
    Color = clMenu
    ReadOnly = True
    TabOrder = 3
  end
  object edtTxData: TEdit
    Left = 64
    Top = 352
    Width = 305
    Height = 21
    TabStop = False
    Anchors = [akLeft, akRight, akBottom]
    Color = clMenu
    ReadOnly = True
    TabOrder = 4
  end
  object edtResult: TEdit
    Left = 64
    Top = 328
    Width = 305
    Height = 21
    TabStop = False
    Anchors = [akLeft, akRight, akBottom]
    Color = clMenu
    ReadOnly = True
    TabOrder = 5
  end
  object stxPassword: TStaticText
    Left = 376
    Top = 328
    Width = 53
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Password:'
    TabOrder = 6
  end
  object edtPassword: TEdit
    Left = 440
    Top = 328
    Width = 81
    Height = 21
    Anchors = [akRight, akBottom]
    MaxLength = 4
    TabOrder = 7
    Text = '30'
  end
  object stxTime: TStaticText
    Left = 376
    Top = 352
    Width = 49
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Time, ms:'
    TabOrder = 8
  end
  object edtTime: TEdit
    Left = 440
    Top = 352
    Width = 81
    Height = 21
    Anchors = [akRight, akBottom]
    Color = clBtnFace
    MaxLength = 4
    TabOrder = 9
    Text = '30'
  end
end
