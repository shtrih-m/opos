object fmMain: TfmMain
  Left = 371
  Top = 148
  ActiveControl = btnClose
  AutoScroll = False
  Caption = 'OPOS test'
  ClientHeight = 600
  ClientWidth = 582
  Color = clBtnFace
  Constraints.MinHeight = 627
  Constraints.MinWidth = 590
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    582
    600)
  PixelsPerInch = 96
  TextHeight = 13
  object btnAbout: TTntButton
    Left = 424
    Top = 576
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'About...'
    TabOrder = 1
    OnClick = btnAboutClick
  end
  object btnClose: TTntButton
    Left = 504
    Top = 576
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 569
    Height = 561
    ActivePage = tsFiscalPrinter
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsFiscalPrinter: TTabSheet
      BorderWidth = 3
      Caption = 'FiscalPrinter'
    end
    object tsCashDrawer: TTabSheet
      BorderWidth = 3
      Caption = 'CashDrawer'
      ImageIndex = 1
    end
    object tsPosPrinter: TTabSheet
      Caption = 'POS Printer'
      ImageIndex = 2
    end
    object tsScale: TTabSheet
      Caption = 'Scale'
      ImageIndex = 3
    end
  end
end
