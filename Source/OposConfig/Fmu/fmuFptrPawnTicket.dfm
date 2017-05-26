object fmFptrPawnTicket: TfmFptrPawnTicket
  Left = 330
  Top = 368
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Pawn ticket'
  ClientHeight = 224
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    335
    224)
  PixelsPerInch = 96
  TextHeight = 13
  object lblUniposSalesErrorText: TLabel
    Left = 8
    Top = 112
    Width = 79
    Height = 13
    Caption = 'Pawn ticket text:'
  end
  object memPawnTicketText: TMemo
    Left = 8
    Top = 128
    Width = 321
    Height = 81
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object rgPawnTicketMode: TRadioGroup
    Left = 8
    Top = 8
    Width = 321
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Pawn ticket mode'
    Items.Strings = (
      '0 - print none'
      '1 - print only first ticket'
      '2 - print all tickets')
    TabOrder = 1
  end
end
