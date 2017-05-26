object fmFptrVatCode: TfmFptrVatCode
  Left = 346
  Top = 181
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'VAT codes'
  ClientHeight = 334
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    403
    334)
  PixelsPerInch = 96
  TextHeight = 13
  object lblAppVatCode: TLabel
    Left = 8
    Top = 44
    Width = 106
    Height = 13
    Caption = 'Application VAT code:'
  end
  object lblFptrVATCode: TLabel
    Left = 8
    Top = 76
    Width = 113
    Height = 13
    Caption = 'Fiscal printer VAT code:'
  end
  object lvVatCodes: TListView
    Left = 8
    Top = 112
    Width = 388
    Height = 215
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Application VAT code'
        Width = 200
      end
      item
        Caption = 'Printer VAT code'
        Width = 180
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnDelete: TButton
    Left = 320
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete'
    Enabled = False
    TabOrder = 1
    OnClick = btnDeleteClick
  end
  object btnAdd: TButton
    Left = 320
    Top = 40
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add'
    TabOrder = 2
    OnClick = btnAddClick
  end
  object seAppVatCode: TSpinEdit
    Left = 160
    Top = 40
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 1
  end
  object seFptrVatCode: TSpinEdit
    Left = 160
    Top = 72
    Width = 121
    Height = 22
    MaxValue = 6
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object chbVatCodeEnabled: TCheckBox
    Left = 8
    Top = 8
    Width = 281
    Height = 17
    Caption = 'Vat code decode enabled'
    TabOrder = 5
  end
end
