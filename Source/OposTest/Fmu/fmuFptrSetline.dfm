object fmFptrSetLine: TfmFptrSetLine
  Left = 389
  Top = 247
  AutoScroll = False
  Caption = 'SetLine'
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
  object lblLineNumber: TLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'LineNumber:'
  end
  object lblHeaderLine: TLabel
    Left = 8
    Top = 32
    Width = 57
    Height = 13
    Caption = 'Header line:'
  end
  object lblTrailerLine: TLabel
    Left = 8
    Top = 56
    Width = 51
    Height = 13
    Caption = 'Trailer line:'
  end
  object btnSetHeaderLine: TButton
    Left = 288
    Top = 88
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SetHeaderLine'
    TabOrder = 4
    OnClick = btnSetHeaderLineClick
  end
  object edtLineNumber: TEdit
    Left = 80
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object edtHeaderLine: TEdit
    Left = 80
    Top = 32
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'HeaderLine'
  end
  object chbDoubleWidth: TCheckBox
    Left = 144
    Top = 8
    Width = 89
    Height = 17
    Caption = 'DoubleWidth'
    TabOrder = 1
  end
  object btnSetTrailerLine: TButton
    Left = 288
    Top = 120
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SetTrailerLine'
    TabOrder = 5
    OnClick = btnSetTrailerLineClick
  end
  object edtTrailerLine: TEdit
    Left = 80
    Top = 56
    Width = 305
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'TrailerLine'
  end
end
