object fmReceiptFormat: TfmReceiptFormat
  Left = 521
  Top = 200
  Width = 541
  Height = 457
  Caption = 'Receipt format'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    525
    419)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 513
    Height = 404
    ActivePage = tsReceiptFormat
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tsReceiptFormat: TTabSheet
      Caption = 'Receipt format'
      DesignSize = (
        505
        376)
      object lblMaxReceiptItems: TTntLabel
        Left = 24
        Top = 72
        Width = 103
        Height = 13
        Caption = 'Receipt items header:'
      end
      object Label1: TTntLabel
        Left = 24
        Top = 168
        Width = 94
        Height = 13
        Caption = 'Receipt item format:'
      end
      object lblRecPrintType: TTntLabel
        Left = 8
        Top = 8
        Width = 92
        Height = 13
        Caption = 'Receipt print mode:'
      end
      object Label2: TTntLabel
        Left = 24
        Top = 272
        Width = 95
        Height = 13
        Anchors = [akLeft, akRight, akBottom]
        Caption = 'Receipt items trailer:'
      end
      object memReceiptItemsHeader: TTntMemo
        Left = 24
        Top = 88
        Width = 478
        Height = 73
        Anchors = [akLeft, akTop, akRight]
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object memReceiptItemFormat: TTntMemo
        Left = 24
        Top = 184
        Width = 478
        Height = 73
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object cbRecPrintType: TTntComboBox
        Left = 128
        Top = 8
        Width = 241
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          'Printer'
          'Driver'
          'Template')
      end
      object chbPrintSingleQuantity: TTntCheckBox
        Left = 24
        Top = 40
        Width = 321
        Height = 17
        Caption = 'Print single quantity'
        TabOrder = 3
      end
      object memReceiptItemsTrailer: TTntMemo
        Left = 24
        Top = 288
        Width = 478
        Height = 73
        Anchors = [akLeft, akRight, akBottom]
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object chbPrintUnitName: TTntCheckBox
        Left = 160
        Top = 39
        Width = 273
        Height = 17
        Caption = 'Print unitName parameter'
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      BorderWidth = 3
      Caption = 'Format help'
      ImageIndex = 1
      object Memo: TTntMemo
        Left = 0
        Top = 0
        Width = 499
        Height = 370
        Align = alClient
        Color = clBtnFace
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Courier'
        Font.Style = []
        Lines.Strings = (
          ''
          '  TITLE - receipt item text'
          '  TOTAL - receipt item amount'
          '  POS - receipt item number'
          '  UNITPRICE - receipt item unit price'
          '  PRICE - receipt item price'
          '  QUAN - receipt item quantity'
          '  SUM - receipt item amount'
          '  DISCOUNT - receipt item discount amount'
          '  TOTAL_TAX - receipt item total and tax letter'
          '  TAX_LETTER - receipt item tax letter')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
end
