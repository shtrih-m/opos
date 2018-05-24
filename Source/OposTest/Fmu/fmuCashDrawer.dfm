object fmCashDrawer: TfmCashDrawer
  Left = 359
  Top = 136
  Anchors = [akTop]
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CashDrawer'
  ClientHeight = 437
  ClientWidth = 544
  Color = clBtnFace
  Constraints.MinHeight = 451
  Constraints.MinWidth = 552
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlData: TPanel
    Left = 178
    Top = 0
    Width = 366
    Height = 375
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 375
    Width = 544
    Height = 62
    Align = alBottom
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      544
      62)
    object lblTime: TTntLabel
      Left = 424
      Top = 16
      Width = 26
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Time:'
    end
    object lblResult: TTntLabel
      Left = 8
      Top = 14
      Width = 33
      Height = 13
      Caption = 'Result:'
    end
    object lblExtendedResult: TTntLabel
      Left = 8
      Top = 38
      Width = 103
      Height = 13
      Caption = 'ResultCodeExtended:'
    end
    object edtTime: TTntEdit
      Left = 472
      Top = 10
      Width = 65
      Height = 21
      TabStop = False
      Anchors = [akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object edtResult: TTntEdit
      Left = 120
      Top = 10
      Width = 297
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object edtExtendedResult: TTntEdit
      Left = 120
      Top = 34
      Width = 297
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 178
    Height = 375
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 2
    object lbPages: TTntListBox
      Left = 5
      Top = 5
      Width = 168
      Height = 365
      Style = lbOwnerDrawVariable
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 20
      ParentFont = False
      TabOrder = 0
      OnClick = lbPagesClick
    end
  end
end
