object fmFptrDate: TfmFptrDate
  Left = 528
  Top = 225
  AutoScroll = False
  Caption = 'SetDate'
  ClientHeight = 270
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    392
    270)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDateType: TTntLabel
    Left = 8
    Top = 8
    Width = 50
    Height = 13
    Caption = 'DateType:'
  end
  object lblDate: TTntLabel
    Left = 8
    Top = 40
    Width = 26
    Height = 13
    Caption = 'Date:'
  end
  object cbDateType: TTntComboBox
    Left = 64
    Top = 8
    Width = 323
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    Items.Strings = (
      'FPTR_DT_CONF'
      'FPTR_DT_EOD'
      'FPTR_DT_RESET'
      'FPTR_DT_RTC'
      'FPTR_DT_VAT'
      'FPTR_DT_START')
  end
  object btnSetDate: TTntButton
    Left = 288
    Top = 80
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'SetDate'
    TabOrder = 3
    OnClick = btnSetDateClick
  end
  object edtDate: TTntEdit
    Left = 64
    Top = 40
    Width = 291
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object btnGetDate: TTntButton
    Left = 184
    Top = 80
    Width = 99
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'GetDate'
    TabOrder = 4
    OnClick = btnGetDateClick
  end
  object btnCurrentDateTime: TTntButton
    Left = 360
    Top = 40
    Width = 25
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 2
    OnClick = btnCurrentDateTimeClick
  end
end
