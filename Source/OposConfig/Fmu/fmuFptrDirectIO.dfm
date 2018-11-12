object fmFptrDirectIO: TfmFptrDirectIO
  Left = 536
  Top = 304
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'DirectIO'
  ClientHeight = 173
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object chbIgnoreDirectIOErrors: TTntCheckBox
    Left = 8
    Top = 16
    Width = 337
    Height = 17
    Caption = 'Ignore DirectIO errors'
    TabOrder = 0
    OnClick = PageChange
  end
end
