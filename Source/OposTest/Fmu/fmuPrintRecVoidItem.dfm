object fmPrintRecVoidItem: TfmPrintRecVoidItem
  Left = 474
  Top = 339
  AutoScroll = False
  Caption = 'PrintRecVoidItem'
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
  object lblDescription: TLabel
    Left = 8
    Top = 8
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblAmount: TLabel
    Left = 8
    Top = 32
    Width = 39
    Height = 13
    Caption = 'Amount:'
  end
  object lblQuantity: TLabel
    Left = 8
    Top = 56
    Width = 42
    Height = 13
    Caption = 'Quantity:'
  end
  object lblVatInfo: TLabel
    Left = 8
    Top = 128
    Width = 37
    Height = 13
    Caption = 'VatInfo:'
  end
  object lblAdjustmentType: TLabel
    Left = 8
    Top = 80
    Width = 79
    Height = 13
    Caption = 'AdjustmentType:'
  end
  object lblAdjustment: TLabel
    Left = 8
    Top = 104
    Width = 55
    Height = 13
    Caption = 'Adjustment:'
  end
  object btnExecute: TButton
    Left = 264
    Top = 160
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecVoidItem'
    TabOrder = 6
    OnClick = btnExecuteClick
  end
  object edtDescription: TEdit
    Left = 96
    Top = 8
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'Method printRecVoidItem'
  end
  object edtAmount: TEdit
    Left = 96
    Top = 32
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = '100'
  end
  object edtQuantity: TEdit
    Left = 96
    Top = 56
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = '1000'
  end
  object edtVatInfo: TEdit
    Left = 96
    Top = 128
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = '0'
  end
  object edtAdjustmentType: TEdit
    Left = 96
    Top = 80
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '0'
  end
  object edtAdjustment: TEdit
    Left = 96
    Top = 104
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = '0'
  end
end
