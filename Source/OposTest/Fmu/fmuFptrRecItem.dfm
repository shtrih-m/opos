object fmFptrRecItem: TfmFptrRecItem
  Left = 370
  Top = 343
  AutoScroll = False
  Caption = 'PrintRecItem'
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
    Top = 56
    Width = 56
    Height = 13
    Caption = 'Description:'
  end
  object lblPrice: TLabel
    Left = 8
    Top = 80
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object lblQuantity: TLabel
    Left = 8
    Top = 104
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
  object lblUnitPrice: TLabel
    Left = 8
    Top = 152
    Width = 46
    Height = 13
    Caption = 'UnitPrice:'
  end
  object lblUnitName: TLabel
    Left = 8
    Top = 176
    Width = 50
    Height = 13
    Caption = 'UnitName:'
  end
  object lblPreLine: TLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'PreLine:'
  end
  object lblPostLine: TLabel
    Left = 8
    Top = 32
    Width = 44
    Height = 13
    Caption = 'PostLine:'
  end
  object btnExecute: TButton
    Left = 264
    Top = 208
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintRecItem'
    TabOrder = 8
    OnClick = btnExecuteClick
  end
  object edtDescription: TEdit
    Left = 96
    Top = 56
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'printRecItem'
  end
  object edtPrice: TEdit
    Left = 96
    Top = 80
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = '100'
  end
  object edtQuantity: TEdit
    Left = 96
    Top = 104
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
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
  object edtUnitPrice: TEdit
    Left = 96
    Top = 152
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = '100'
  end
  object edtUnitName: TEdit
    Left = 96
    Top = 176
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 7
    Text = 'kg.'
  end
  object edtPreLine: TEdit
    Left = 96
    Top = 8
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'PreLine'
  end
  object edtPostLine: TEdit
    Left = 96
    Top = 32
    Width = 289
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'PostLine'
  end
end
