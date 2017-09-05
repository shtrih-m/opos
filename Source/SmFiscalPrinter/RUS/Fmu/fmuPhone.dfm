object fmPhone: TfmPhone
  Left = 508
  Top = 219
  ActiveControl = edtAddress
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072
  ClientHeight = 471
  ClientWidth = 232
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 157
    Height = 24
    Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TPngSpeedButton
    Left = 8
    Top = 408
    Width = 105
    Height = 57
    Caption = #1044#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = btnOKClick
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
  end
  object btnCancel: TPngSpeedButton
    Left = 120
    Top = 408
    Width = 105
    Height = 57
    Caption = #1053#1077#1090
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = btnCancelClick
    PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
  end
  object pnlKeyboard: TPanel
    Left = 5
    Top = 88
    Width = 222
    Height = 305
    Caption = 'pnlKeyboard'
    TabOrder = 0
    object btn1: TPngSpeedButton
      Left = 0
      Top = 0
      Width = 75
      Height = 75
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn1Click
    end
    object btn2: TPngSpeedButton
      Left = 74
      Top = 0
      Width = 75
      Height = 75
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn2Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn3: TPngSpeedButton
      Left = 148
      Top = 0
      Width = 75
      Height = 75
      Caption = '3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn3Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn4: TPngSpeedButton
      Left = 0
      Top = 74
      Width = 75
      Height = 75
      Caption = '4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn4Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn5: TPngSpeedButton
      Left = 74
      Top = 74
      Width = 75
      Height = 75
      Caption = '5'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn5Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn6: TPngSpeedButton
      Left = 148
      Top = 74
      Width = 75
      Height = 75
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn6Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn7: TPngSpeedButton
      Left = 0
      Top = 148
      Width = 75
      Height = 75
      Caption = '7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn7Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn8: TPngSpeedButton
      Left = 74
      Top = 148
      Width = 75
      Height = 75
      Caption = '8'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn8Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn9: TPngSpeedButton
      Left = 148
      Top = 148
      Width = 75
      Height = 75
      Caption = '9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn9Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btn0: TPngSpeedButton
      Left = 0
      Top = 222
      Width = 75
      Height = 75
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btn0Click
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btnPlus: TPngSpeedButton
      Left = 74
      Top = 222
      Width = 75
      Height = 75
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnPlusClick
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
    object btnBack: TPngSpeedButton
      Left = 148
      Top = 222
      Width = 75
      Height = 75
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnBackClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000040000000400806000000AA6971
        DE000002894944415478DAED9A314B1C411886E782040962952A55FE814D0844
        488C103090465148AD2016FE019174E2AF30B1505209E19A7065AC041124488A
        9088C11344AC2D8268C83BEC2D2CC7CEDECC37F3EDB7BB372F3CCD1E77CCFBDC
        EDEEECDCB4D490A7253D00E94401D203904E14203D00E94401D203904E14C0F0
        9923E00978245DAE977FE012DC700B5800AB60123C946E9D23E1186C816D7017
        5280FEA63F8359E99696F90EE6C159080163E02B7825DDCA31FA947801BA3E02
        EA5A3ECD017849155054FE2FD80757D20D7B19056FC0E39CD7E628028ACAEBF3
        6A069C4AB7CE19F31E78DB77BCED2A6050F969D0956E6B88FE055CA8E41791E6
        DA45409DCBA73904CFB3076C0534A1BCCE37F0DA554053CA93047094D733C515
        B00C6E092536C06FB0C32D80AB7C078C833678EF286113ACAB646ABB4890602D
        80BB7C1A170969F93414095602CA2AEF22A1BF3C55C240015C17BC0F2A39774D
        2992602A9FE68B4A1E6EBC05705FED0715C99340790F49807EA4ED3096A7140A
        5DBE50C027B0C45CDE45C24FB016B8BC51C033705452795B0945A196370AC8FB
        F6CB98E15124F894370AF8039E668EE95BCB04F8C1589E22C1B7BC51C03D7890
        3976D21350566C2484281F05A8780AD85F04F592D6944A564FAB503E9404A7DB
        E02F95DC09382454EA36A8639A087148A8DC4448A7682A1C524265A7C23A450F
        43212454FA61885B422D1E873925702E88E8F5C58F21059429C17749CCA5BC93
        803224F82E8ABA967716C029C17759FC9C509E24804B825448029A24812CA029
        12C87F8E364182F7DFE3B612DEA9066F90B091D0F82D323612EA10AF4D527597
        10649B5C56C2AE1AD28D92D90CED56D9FE0CED66E95A260A901E8074A200E901
        48270A901E8074A200E90148E73F6AEA22069753E3DB0000000049454E44AE42
        6082}
      PngOptions = [pngBlendOnDisabled, pngGrayscaleOnDisabled]
    end
  end
  object edtAddress: TEdit
    Left = 8
    Top = 48
    Width = 217
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnKeyPress = edtAddressKeyPress
  end
end
