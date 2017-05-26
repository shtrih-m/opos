object fmFptrPayType: TfmFptrPayType
  Left = 337
  Top = 266
  AutoScroll = False
  BorderIcons = [biSystemMenu]
  Caption = 'Pay types'
  ClientHeight = 224
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    464
    224)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDescription: TLabel
    Left = 8
    Top = 12
    Width = 121
    Height = 13
    Caption = 'Payment type description:'
  end
  object lblValue: TLabel
    Left = 8
    Top = 44
    Width = 94
    Height = 13
    Caption = 'Payment type code:'
  end
  object edtDescription: TEdit
    Left = 160
    Top = 8
    Width = 193
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object cbValue: TComboBox
    Left = 160
    Top = 40
    Width = 193
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Cash'
      'Payment type 2'
      'Payment type 3'
      'Payment type 4')
  end
  object lvPayTypes: TListView
    Left = 8
    Top = 72
    Width = 369
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #8470
      end
      item
        Caption = 'Description'
        Width = 100
      end
      item
        Caption = 'Code'
        Width = 180
      end>
    ColumnClick = False
    FlatScrollBars = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
  end
  object btnDelete: TButton
    Left = 384
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete'
    Enabled = False
    TabOrder = 3
    OnClick = btnDeleteClick
  end
  object btnAdd: TButton
    Left = 384
    Top = 72
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add'
    TabOrder = 4
    OnClick = btnAddClick
  end
end
