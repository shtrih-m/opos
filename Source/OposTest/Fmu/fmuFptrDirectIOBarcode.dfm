object fmFptrDirectIOBarcode: TfmFptrDirectIOBarcode
  Left = 362
  Top = 235
  AutoScroll = False
  Caption = 'DirectIO barcode'
  ClientHeight = 320
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    463
    320)
  PixelsPerInch = 96
  TextHeight = 13
  object btnPrintAll: TTntButton
    Left = 336
    Top = 264
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Print all barcodes'
    TabOrder = 3
    OnClick = btnPrintAllClick
  end
  object btnPrint1D: TTntButton
    Left = 80
    Top = 264
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Print all 1D barcodes'
    TabOrder = 1
    OnClick = btnPrint1DClick
  end
  object btnPrint2D: TTntButton
    Left = 208
    Top = 264
    Width = 121
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Print all 2D barcodes'
    TabOrder = 2
    OnClick = btnPrint2DClick
  end
  object gb2DBarcode: TTntGroupBox
    Left = 8
    Top = 8
    Width = 449
    Height = 249
    Anchors = [akLeft, akTop, akRight]
    Caption = '2D barcode'
    TabOrder = 0
    DesignSize = (
      449
      249)
    object lblBarcodeData: TTntLabel
      Left = 16
      Top = 24
      Width = 26
      Height = 13
      Caption = 'Data:'
    end
    object lblModuleSize: TTntLabel
      Left = 16
      Top = 184
      Width = 59
      Height = 13
      Caption = 'Module size:'
    end
    object lblAlignment: TTntLabel
      Left = 16
      Top = 216
      Width = 49
      Height = 13
      Caption = 'Alignment:'
    end
    object lblBarcodeType: TTntLabel
      Left = 16
      Top = 152
      Width = 66
      Height = 13
      Caption = 'Barcode type:'
    end
    object memBarcode: TTntMemo
      Left = 16
      Top = 40
      Width = 425
      Height = 105
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier'
      Font.Style = []
      Lines.Strings = (
        'https://checkl.fsrar.ru?id=fa07210-0041-4dc6-'
        'bbf2-1634282724418amdt=191015161 '
        
          '71amcn=0100000062870D0682B61230689D76826FAC92C5DC29955F0E3B5663B' +
          '4'
        '4C63A673C86B0976C0B24495848F6EF157792203A0D275'
        '1F525456644096478D256A910EFEABB67')
      ParentFont = False
      TabOrder = 0
      WordWrap = False
    end
    object btnPrintBarcode: TTntButton
      Left = 320
      Top = 152
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print barcode'
      TabOrder = 4
      OnClick = btnPrintBarcodeClick
    end
    object cbModuleSize: TTntComboBox
      Left = 88
      Top = 184
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8')
    end
    object cbAlignment: TTntComboBox
      Left = 88
      Top = 216
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        'CENTER'
        'LEFT'
        'RIGHT')
    end
    object cbBarcodeType: TTntComboBox
      Left = 88
      Top = 152
      Width = 121
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'QRCODE'
        'MICROQR'
        'AZTEC'
        'AZRUNE'
        'DATAMATRIX'
        'PDF417'
        'PDF417TRUNC'
        'MICROPDF417')
    end
    object btnPrintBarcodeHex: TTntButton
      Left = 320
      Top = 184
      Width = 121
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Print barcode hex'
      TabOrder = 5
      OnClick = btnPrintBarcodeHexClick
    end
  end
end
