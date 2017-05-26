object fmFptrReplace: TfmFptrReplace
  Left = 372
  Top = 212
  Width = 480
  Height = 410
  Caption = 'Replace'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    472
    383)
  PixelsPerInch = 96
  TextHeight = 13
  object lblText: TLabel
    Left = 8
    Top = 168
    Width = 24
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Text:'
  end
  object lblReplacement: TLabel
    Left = 8
    Top = 272
    Width = 66
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Replacement:'
  end
  object ListView: TListView
    Left = 8
    Top = 32
    Width = 377
    Height = 129
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #8470
      end
      item
        Caption = 'Text'
        Width = 150
      end
      item
        AutoSize = True
        Caption = 'Replacement'
      end>
    ColumnClick = False
    HideSelection = False
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = ListViewChange
  end
  object btnAdd: TButton
    Left = 392
    Top = 32
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Add'
    TabOrder = 4
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 392
    Top = 64
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Delete'
    TabOrder = 5
    OnClick = btnDeleteClick
  end
  object btnClear: TButton
    Left = 392
    Top = 96
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Clear'
    TabOrder = 6
    OnClick = btnClearClick
  end
  object memText: TMemo
    Left = 8
    Top = 184
    Width = 377
    Height = 81
    Anchors = [akLeft, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 2
    WordWrap = False
    OnChange = memTextChange
  end
  object memReplacement: TMemo
    Left = 8
    Top = 288
    Width = 377
    Height = 81
    Anchors = [akLeft, akRight, akBottom]
    ScrollBars = ssVertical
    TabOrder = 3
    WordWrap = False
    OnChange = memReplacementChange
  end
  object chbTextReplacementEnabled: TCheckBox
    Left = 8
    Top = 8
    Width = 385
    Height = 17
    Caption = 'Text replacement enabled'
    TabOrder = 0
  end
end
