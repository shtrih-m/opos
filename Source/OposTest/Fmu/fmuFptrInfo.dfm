object fmFptrInfo: TfmFptrInfo
  Left = 506
  Top = 258
  AutoScroll = False
  Caption = 'Info'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblServiceFileVersion_: TTntLabel
    Left = 8
    Top = 8
    Width = 210
    Height = 20
    Caption = 'Service object file version:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblServiceFileVersion: TTntLabel
    Left = 224
    Top = 8
    Width = 36
    Height = 20
    Caption = '0.14'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnRefresh: TTntButton
    Left = 304
    Top = 240
    Width = 81
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Refresh'
    TabOrder = 1
    OnClick = btnRefreshClick
  end
  object memDevices: TTntMemo
    Left = 8
    Top = 32
    Width = 378
    Height = 201
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
end
