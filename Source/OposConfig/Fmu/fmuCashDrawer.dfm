object fmCashDrawer: TfmCashDrawer
  Left = 435
  Top = 282
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cash drawer'
  ClientHeight = 173
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    432
    173)
  PixelsPerInch = 96
  TextHeight = 13
  object lblDrawerNumber: TTntLabel
    Left = 8
    Top = 16
    Width = 100
    Height = 13
    Caption = 'Cash drawer number:'
  end
  object lblFiscalPrinterDeviceName: TTntLabel
    Left = 8
    Top = 48
    Width = 127
    Height = 13
    Caption = 'Fiscal printer DeviceName:'
  end
  object lblCCOType: TTntLabel
    Left = 8
    Top = 80
    Width = 48
    Height = 13
    Caption = 'CCO type:'
  end
  object cbFiscalPrinterDeviceName: TTntComboBox
    Left = 144
    Top = 48
    Width = 281
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    Text = 'cbFiscalPrinterDeviceName'
  end
  object cbCCOType: TTntComboBox
    Left = 144
    Top = 80
    Width = 281
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'RCS CCO (default)'
      'NCR CCO')
  end
  object seDrawerNumber: TSpinEdit
    Left = 144
    Top = 16
    Width = 281
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 0
  end
  object OpenDialog: TTntOpenDialog
    Filter = 
      'Log files (*.log)|*.log|Text files (*.txt)|*.txt|All files (*.*)' +
      '|*.*'
    Left = 8
    Top = 144
  end
end
