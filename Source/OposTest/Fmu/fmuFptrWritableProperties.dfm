object fmFptrWritableProperties: TfmFptrWritableProperties
  Left = 484
  Top = 375
  AutoScroll = False
  Caption = 'Writable properties'
  ClientHeight = 366
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    392
    366)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSlipSelection: TTntLabel
    Left = 8
    Top = 128
    Width = 64
    Height = 13
    Caption = 'SlipSelection:'
  end
  object lblChangeDue: TTntLabel
    Left = 8
    Top = 8
    Width = 60
    Height = 13
    Caption = 'ChangeDue:'
  end
  object lblDateType: TTntLabel
    Left = 8
    Top = 32
    Width = 50
    Height = 13
    Caption = 'DateType:'
  end
  object lblFiscalReceiptStation: TTntLabel
    Left = 8
    Top = 56
    Width = 100
    Height = 13
    Caption = 'FiscalReceiptStation:'
  end
  object lblFiscalReceiptType: TTntLabel
    Left = 8
    Top = 80
    Width = 91
    Height = 13
    Caption = 'FiscalReceiptType:'
  end
  object lblMessageType: TTntLabel
    Left = 8
    Top = 104
    Width = 70
    Height = 13
    Caption = 'MessageType:'
  end
  object lblPreLine: TTntLabel
    Left = 8
    Top = 152
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object lblPostLine: TTntLabel
    Left = 8
    Top = 176
    Width = 44
    Height = 13
    Caption = 'PostLine:'
  end
  object chbDeviceEnabled: TTntCheckBox
    Left = 8
    Top = 208
    Width = 105
    Height = 17
    Caption = 'DeviceEnabled'
    TabOrder = 0
    OnClick = chbDeviceEnabledClick
  end
  object chbFreezeEvents: TTntCheckBox
    Left = 8
    Top = 232
    Width = 105
    Height = 17
    Caption = 'FreezeEvents'
    TabOrder = 1
    OnClick = chbFreezeEventsClick
  end
  object chbPowerNotify: TTntCheckBox
    Left = 8
    Top = 256
    Width = 105
    Height = 17
    Caption = 'PowerNotify'
    TabOrder = 2
    OnClick = chbPowerNotifyClick
  end
  object chbAsyncMode: TTntCheckBox
    Left = 232
    Top = 208
    Width = 105
    Height = 17
    Caption = 'AsyncMode'
    TabOrder = 3
    OnClick = chbAsyncModeClick
  end
  object chbCheckTotal: TTntCheckBox
    Left = 120
    Top = 208
    Width = 105
    Height = 17
    Caption = 'CheckTotal'
    TabOrder = 4
    OnClick = chbCheckTotalClick
  end
  object chbDuplicateReceipt: TTntCheckBox
    Left = 120
    Top = 232
    Width = 105
    Height = 17
    Caption = 'DuplicateReceipt'
    TabOrder = 5
    OnClick = chbDuplicateReceiptClick
  end
  object chbFlagWhenIdle: TTntCheckBox
    Left = 120
    Top = 256
    Width = 105
    Height = 17
    Caption = 'FlagWhenIdle'
    TabOrder = 6
    OnClick = chbFlagWhenIdleClick
  end
  object cbSlipSelection: TTntComboBox
    Left = 112
    Top = 128
    Width = 274
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 7
    OnChange = cbSlipSelectionChange
    Items.Strings = (
      'FPTR_SS_FULL_LENGTH'
      'FPTR_SS_VALIDATION')
  end
  object edtChangeDue: TTntEdit
    Left = 112
    Top = 8
    Width = 274
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 8
    OnChange = edtChangeDueChange
  end
  object cbDateType: TTntComboBox
    Left = 112
    Top = 32
    Width = 274
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 9
    OnChange = cbDateTypeChange
    Items.Strings = (
      'FPTR_DT_CONF'
      'FPTR_DT_EOD'
      'FPTR_DT_RESET'
      'FPTR_DT_RTC'
      'FPTR_DT_VAT')
  end
  object cbFiscalReceiptStation: TTntComboBox
    Left = 112
    Top = 56
    Width = 274
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 10
    OnChange = cbFiscalReceiptStationChange
    Items.Strings = (
      'FPTR_RS_RECEIPT'
      'FPTR_RS_SLIP')
  end
  object cbFiscalReceiptType: TTntComboBox
    Left = 112
    Top = 80
    Width = 274
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 11
    OnChange = cbFiscalReceiptTypeChange
    Items.Strings = (
      'FPTR_RT_CASH_IN'
      'FPTR_RT_CASH_OUT'
      'FPTR_RT_GENERIC'
      'FPTR_RT_SALES'
      'FPTR_RT_SERVICE'
      'FPTR_RT_SIMPLE_INVOICE')
  end
  object cbMessageType: TTntComboBox
    Left = 112
    Top = 104
    Width = 274
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 12
    OnChange = cbMessageTypeChange
    Items.Strings = (
      'FPTR_MT_ADVANCE'
      'FPTR_MT_ADVANCE_PAID'
      'FPTR_MT_AMOUNT_TO_BE_PAID'
      'FPTR_MT_AMOUNT_TO_BE_PAID_BACK'
      'FPTR_MT_CARD'
      'FPTR_MT_CARD_NUMBER'
      'FPTR_MT_CARD_TYPE'
      'FPTR_MT_CASH'
      'FPTR_MT_CASHIER'
      'FPTR_MT_CASH_REGISTER_NUMBER'
      'FPTR_MT_CHANGE'
      'FPTR_MT_CHEQUE'
      'FPTR_MT_CLIENT_NUMBER'
      'FPTR_MT_CLIENT_SIGNATURE'
      'FPTR_MT_COUNTER_STATE'
      'FPTR_MT_CREDIT_CARD'
      'FPTR_MT_CURRENCY'
      'FPTR_MT_CURRENCY_VALUE'
      'FPTR_MT_DEPOSIT'
      'FPTR_MT_DEPOSIT_RETURNED'
      'FPTR_MT_DOT_LINE'
      'FPTR_MT_DRIVER_NUMB'
      'FPTR_MT_EMPTY_LINE'
      'FPTR_MT_FREE_TEXT'
      'FPTR_MT_FREE_TEXT_WITH_DAY_LIMIT'
      'FPTR_MT_GIVEN_DISCOUNT'
      'FPTR_MT_LOCAL_CREDIT'
      'FPTR_MT_MILEAGE_KM'
      'FPTR_MT_NOTE'
      'FPTR_MT_PAID'
      'FPTR_MT_PAY_IN'
      'FPTR_MT_POINT_GRANTED'
      'FPTR_MT_POINTS_BONUS'
      'FPTR_MT_POINTS_RECEIPT'
      'FPTR_MT_POINTS_TOTAL'
      'FPTR_MT_PROFITED'
      'FPTR_MT_RATE'
      'FPTR_MT_REGISTER_NUMB'
      'FPTR_MT_SHIFT_NUMBER'
      'FPTR_MT_STATE_OF_AN_ACCOUNT'
      'FPTR_MT_SUBSCRIPTION'
      'FPTR_MT_TABLE'
      'FPTR_MT_THANK_YOU_FOR_LOYALTY'
      'FPTR_MT_TRANSACTION_NUMB'
      'FPTR_MT_VALID_TO'
      'FPTR_MT_VOUCHER'
      'FPTR_MT_VOUCHER_PAID'
      'FPTR_MT_VOUCHER_VALUE'
      'FPTR_MT_WITH_DISCOUNT'
      'FPTR_MT_WITHOUT_UPLIFT')
  end
  object edtPreLine: TTntEdit
    Left = 112
    Top = 152
    Width = 274
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 13
    OnChange = edtPreLineChange
  end
  object edtPostLine: TTntEdit
    Left = 112
    Top = 176
    Width = 274
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 14
    OnChange = edtPostLineChange
  end
  object btnUpdate: TTntButton
    Left = 272
    Top = 240
    Width = 115
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Refresh'
    TabOrder = 15
    OnClick = btnUpdateClick
  end
end
