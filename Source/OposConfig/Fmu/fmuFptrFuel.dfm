object fmFptrFuel: TfmFptrFuel
  Left = 419
  Top = 198
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Fuel'
  ClientHeight = 327
  ClientWidth = 438
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
  object gbFuelFilter: TTntGroupBox
    Left = 0
    Top = 0
    Width = 433
    Height = 313
    Caption = 'Fuel receipt item amount round'
    TabOrder = 0
    DesignSize = (
      433
      313)
    object Label3: TTntLabel
      Left = 16
      Top = 88
      Width = 231
      Height = 13
      Caption = 'Fuel receipt item text used to determine fuel sales'
    end
    object lblFuelItemText: TTntLabel
      Left = 16
      Top = 112
      Width = 100
      Height = 13
      Caption = 'Fuel receipt item text:'
    end
    object lblFuelAmountStep: TTntLabel
      Left = 16
      Top = 240
      Width = 113
      Height = 13
      Caption = 'Fuel amount step, RUB:'
    end
    object lblFuelAmountPrecision: TTntLabel
      Left = 16
      Top = 272
      Width = 171
      Height = 13
      Caption = 'Fuel amount precision 0.01..1, RUB:'
    end
    object chbFuelRoundEnabled: TTntCheckBox
      Left = 16
      Top = 32
      Width = 297
      Height = 17
      Caption = 'Fuel receipt item amount round enabled'
      TabOrder = 0
    end
    object memFuelItemText: TTntMemo
      Left = 16
      Top = 128
      Width = 409
      Height = 97
      Anchors = [akLeft, akTop, akRight]
      Lines.Strings = (
        #1040#1048'-92'
        #1040#1048'-95'
        #1040#1048'-98'
        '')
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object edtFuelAmountStep: TTntEdit
      Left = 216
      Top = 240
      Width = 209
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      Text = 'edtFuelAmountStep'
    end
    object edtFuelAmountPrecision: TTntEdit
      Left = 216
      Top = 272
      Width = 209
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 4
      Text = 'edtFuelAmountPrecision'
    end
    object chbCashRoundEnabled: TTntCheckBox
      Left = 16
      Top = 56
      Width = 297
      Height = 17
      Caption = 'Only cash receipt round enabled'
      TabOrder = 1
    end
  end
end
