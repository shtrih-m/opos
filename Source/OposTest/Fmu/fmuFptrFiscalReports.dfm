object fmFptrFiscalReports: TfmFptrFiscalReports
  Left = 353
  Top = 217
  AutoScroll = False
  Caption = 'Fiscal Reports'
  ClientHeight = 287
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    392
    287)
  PixelsPerInch = 96
  TextHeight = 13
  object lblReportType: TLabel
    Left = 8
    Top = 80
    Width = 59
    Height = 13
    Caption = 'ReportType:'
  end
  object lblStartNum: TLabel
    Left = 8
    Top = 104
    Width = 47
    Height = 13
    Caption = 'StartNum:'
  end
  object lblEndNum: TLabel
    Left = 8
    Top = 128
    Width = 44
    Height = 13
    Caption = 'EndNum:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 72
    Width = 378
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 8
    Top = 192
    Width = 378
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Shape = bsTopLine
  end
  object lblDate1: TLabel
    Left = 8
    Top = 200
    Width = 32
    Height = 13
    Caption = 'Date1:'
  end
  object lblDate2: TLabel
    Left = 8
    Top = 224
    Width = 32
    Height = 13
    Caption = 'Date2:'
  end
  object btnPrintReport: TButton
    Left = 249
    Top = 160
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintReport'
    TabOrder = 10
    OnClick = btnPrintReportClick
  end
  object edtReportType: TEdit
    Left = 72
    Top = 80
    Width = 73
    Height = 21
    TabOrder = 2
    Text = '1'
  end
  object cbReportType: TComboBox
    Left = 152
    Top = 80
    Width = 234
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbReportTypeChange
    Items.Strings = (
      'FPTR_RT_ORDINAL'
      'FPTR_RT_DATE'
      'FPTR_RT_EOD_ORDINAL')
  end
  object edtStartNum: TEdit
    Left = 72
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '0'
  end
  object edtEndNum: TEdit
    Left = 72
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 7
    Text = '0'
  end
  object btnPrintXReport: TButton
    Left = 249
    Top = 8
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintXReport'
    TabOrder = 0
    OnClick = btnPrintXReportClick
  end
  object btnPrintZReport: TButton
    Left = 249
    Top = 40
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintZReport'
    TabOrder = 1
    OnClick = btnPrintZReportClick
  end
  object dtpStart: TDateTimePicker
    Left = 200
    Top = 104
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Date = 38087.694083854200000000
    Time = 38087.694083854200000000
    TabOrder = 5
    OnChange = dtpStartChange
  end
  object dtpEnd: TDateTimePicker
    Left = 200
    Top = 128
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Date = 38087.694083854200000000
    Time = 38087.694083854200000000
    TabOrder = 8
    OnChange = dtpEndChange
  end
  object btnStartDate: TButton
    Left = 353
    Top = 104
    Width = 33
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 6
    OnClick = btnStartDateClick
  end
  object btnEndDate: TButton
    Left = 353
    Top = 128
    Width = 33
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 9
    OnClick = btnEndDateClick
  end
  object btnPrintPeriodicTotalsReport: TButton
    Left = 249
    Top = 256
    Width = 137
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'PrintPeriodicTotalsReport'
    TabOrder = 17
    OnClick = btnPrintPeriodicTotalsReportClick
  end
  object edtDate1: TEdit
    Left = 72
    Top = 200
    Width = 121
    Height = 21
    TabOrder = 11
    Text = '0'
  end
  object edtDate2: TEdit
    Left = 72
    Top = 224
    Width = 121
    Height = 21
    TabOrder = 14
    Text = '0'
  end
  object dtpDate1: TDateTimePicker
    Left = 200
    Top = 200
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Date = 38087.694083854200000000
    Time = 38087.694083854200000000
    TabOrder = 12
    OnChange = dtpDate1Change
  end
  object dtpDate2: TDateTimePicker
    Left = 200
    Top = 224
    Width = 146
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Date = 38087.694083854200000000
    Time = 38087.694083854200000000
    TabOrder = 15
    OnChange = dtpDate2Change
  end
  object btnDate1: TButton
    Left = 353
    Top = 200
    Width = 33
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 13
    OnClick = btnDate1Click
  end
  object btnDate2: TButton
    Left = 353
    Top = 224
    Width = 33
    Height = 22
    Anchors = [akTop, akRight]
    Caption = '...'
    TabOrder = 16
    OnClick = btnDate2Click
  end
end
