object fmGraph: TfmGraph
  Left = 317
  Top = 300
  AutoScroll = False
  Caption = 'Графика'
  ClientHeight = 343
  ClientWidth = 480
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TTntGroupBox
    Left = 8
    Top = 8
    Width = 465
    Height = 233
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object btnLoadImage: TTntButton
      Left = 312
      Top = 112
      Width = 145
      Height = 25
      Hint = 'LoadLineData'
      Anchors = [akTop, akRight]
      Caption = 'Загрузка картинки'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnLoadImageClick
    end
    object btnLoadLineDataEx: TTntButton
      Left = 312
      Top = 144
      Width = 145
      Height = 25
      Hint = 'LoadLineDataEx'
      Anchors = [akTop, akRight]
      Caption = 'Расширенная загрузка'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnLoadLineDataExClick
    end
    object btnWideLoadLineData: TTntButton
      Left = 312
      Top = 176
      Width = 145
      Height = 25
      Hint = 'WideLoadLineData'
      Anchors = [akTop, akRight]
      Caption = 'Загрузка одной командой'
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnWideLoadLineDataClick
    end
    object btnMonochrome1: TTntButton
      Left = 312
      Top = 48
      Width = 145
      Height = 25
      Hint = 'Монохромизировать1'
      Anchors = [akTop, akRight]
      Caption = 'Монохромизировать1'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnMonochrome1Click
    end
    object btnMonochrome2: TTntButton
      Left = 312
      Top = 80
      Width = 145
      Height = 25
      Hint = 'Монохромизировать2'
      Anchors = [akTop, akRight]
      Caption = 'Монохромизировать2'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnMonochrome2Click
    end
    object pnlImage: TTntPanel
      Left = 16
      Top = 16
      Width = 289
      Height = 185
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 5
      object Image: TImage
        Left = 32
        Top = 9
        Width = 169
        Height = 144
      end
    end
    object ProgressBar: TProgressBar
      Left = 16
      Top = 208
      Width = 289
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      Min = 0
      Max = 200
      Step = 1
      TabOrder = 6
      Visible = False
    end
    object btnOpenPicture: TTntBitBtn
      Left = 312
      Top = 16
      Width = 145
      Height = 25
      Hint = 'Открыть файл'
      Anchors = [akTop, akRight]
      Caption = 'Открыть файл'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = btnOpenPictureClick
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000000000000000000000000000000000000000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF000000000000
        0000000000000000000000000000000000000000000000000000000000FF0000
        FF0000FF0000FF0000FF80808080808080808080808080808080808080808080
        80808080808080808080800000FF0000FF0000FF0000FF0000FF000000000000
        0084840084840084840084840084840084840084840084840084840000000000
        FF0000FF0000FF0000FF808080808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C08080800000FF0000FF0000FF0000FF00000000FFFF
        0000000084840084840084840084840084840084840084840084840084840000
        000000FF0000FF0000FF808080E2E2E2808080C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C08080800000FF0000FF0000FF000000FFFFFF
        00FFFF0000000084840084840084840084840084840084840084840084840084
        840000000000FF0000FF808080FFFFFFE2E2E2808080C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C08080800000FF0000FF00000000FFFF
        FFFFFF00FFFF0000000084840084840084840084840084840084840084840084
        840084840000000000FF808080E2E2E2FFFFFFE2E2E2808080C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C08080800000FF000000FFFFFF
        00FFFFFFFFFF00FFFF0000000000000000000000000000000000000000000000
        00000000000000000000808080FFFFFFE2E2E2FFFFFFE2E2E280808080808080
        808080808080808080808080808080808080808080808080808000000000FFFF
        FFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFF0000000000FF0000
        FF0000FF0000FF0000FF808080E2E2E2FFFFFFE2E2E2FFFFFFE2E2E2FFFFFFE2
        E2E2FFFFFFE2E2E28080800000FF0000FF0000FF0000FF0000FF000000FFFFFF
        00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF0000000000FF0000
        FF0000FF0000FF0000FF808080FFFFFFE2E2E2FFFFFFE2E2E2FFFFFFE2E2E2FF
        FFFFE2E2E2FFFFFF8080800000FF0000FF0000FF0000FF0000FF00000000FFFF
        FFFFFF00FFFF0000000000000000000000000000000000000000000000FF0000
        FF0000FF0000FF0000FF808080E2E2E2FFFFFFE2E2E280808080808080808080
        80808080808080808080800000FF0000FF0000FF0000FF0000FF0000FF000000
        0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        000000000000000000FF0000FF8080808080808080800000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF8080808080808080800000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000000000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF0000FF0000FF0000FF0000FF8080808080800000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000000000FF0000FF0000FF0000
        000000FF0000000000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF8080800000FF0000FF0000FF8080800000FF8080800000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000000000000000000000
        FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
        00FF0000FF8080808080808080800000FF0000FF0000FF0000FF}
      Margin = 10
      NumGlyphs = 2
    end
  end
  object GroupBox2: TTntGroupBox
    Left = 8
    Top = 248
    Width = 465
    Height = 89
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    object lblFirstLineNumber: TTntLabel
      Left = 8
      Top = 18
      Width = 114
      Height = 13
      Caption = 'Номер первой строки:'
    end
    object lblLastLineNumber: TTntLabel
      Left = 8
      Top = 44
      Width = 132
      Height = 13
      Caption = 'Номер последней строки:'
    end
    object edtFirstLineNumber: TTntEdit
      Left = 152
      Top = 16
      Width = 65
      Height = 21
      Hint = 'FirstLineNumber'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '1'
    end
    object udFirstLineNumber: TUpDown
      Left = 217
      Top = 16
      Width = 15
      Height = 21
      Associate = edtFirstLineNumber
      Min = 0
      Max = 32767
      Position = 1
      TabOrder = 1
      Wrap = False
    end
    object edtLastLineNumber: TTntEdit
      Left = 152
      Top = 40
      Width = 65
      Height = 21
      Hint = 'LastLineNumber'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '200'
    end
    object udLastLineNumber: TUpDown
      Left = 217
      Top = 40
      Width = 15
      Height = 21
      Associate = edtLastLineNumber
      Min = 0
      Max = 32767
      Position = 200
      TabOrder = 3
      Wrap = False
    end
    object btnDraw: TTntButton
      Tag = 12
      Left = 311
      Top = 16
      Width = 146
      Height = 25
      Hint = 'Draw'
      Anchors = [akTop, akRight]
      Caption = 'Печать картинки'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = btnDrawClick
    end
    object btnDrawEx: TTntButton
      Left = 311
      Top = 48
      Width = 146
      Height = 25
      Hint = 'DrawEx'
      Anchors = [akTop, akRight]
      Caption = 'Расширенная печать'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnDrawExClick
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 32
    Top = 168
  end
end
