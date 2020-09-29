object fmFptrDate: TfmFptrDate
  Left = 711
  Top = 187
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Date control'
  ClientHeight = 394
  ClientWidth = 424
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
  object lblValidTimeDiff: TTntLabel
    Left = 8
    Top = 16
    Width = 144
    Height = 13
    Caption = 'Valid time difference, seconds:'
  end
  object Label1: TLabel
    Left = 8
    Top = 48
    Width = 361
    Height = 41
    Caption = 
      'If valid time difference is more than zero, driver will check an' +
      'd '#13#10'correct date and time before fiscal day open.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object seValidTimeDiff: TSpinEdit
    Left = 168
    Top = 16
    Width = 113
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
end
