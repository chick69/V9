object FEcheUnit: TFEcheUnit
  Left = 224
  Top = 200
  HelpContext = 7529300
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Modification d'#39#233'ch'#233'ance'
  ClientHeight = 166
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBouton: TPanel
    Left = 0
    Top = 131
    Width = 331
    Height = 35
    Align = alBottom
    Caption = ' '
    TabOrder = 2
    object HLabel6: THLabel
      Left = 8
      Top = 10
      Width = 73
      Height = 13
      Caption = 'Montant origine'
      FocusControl = FMontant
    end
    object BValider: THBitBtn
      Left = 240
      Top = 4
      Width = 29
      Height = 27
      Hint = 'Valider la modification'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BValiderClick
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      Margin = 3
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object BFerme: THBitBtn
      Left = 272
      Top = 4
      Width = 28
      Height = 27
      Hint = 'Fermer'
      Cancel = True
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Glyph.Data = {
        CE070000424DCE07000000000000360000002800000024000000120000000100
        1800000000009807000000000000000000000000000000000000008284008284
        0082840082840082840082840082840082840082840082840082840082840082
        8400828400828400828400828400828400828400828400828400828400828400
        8284008284008284008284008284008284008284008284008284008284008284
        0082840082840082840082840082840082848482848482840082840082840082
        8400828400828400828400828400828400828400828400828400828400828400
        8284008284008284008284FFFFFF008284008284008284008284008284008284
        0082840082840082840082840082840082840082840082840082840000FF0000
        840000848482840082840082840082840082840082840000FF84828400828400
        8284008284008284008284008284008284008284848284848284FFFFFF008284
        008284008284008284008284008284FFFFFF0082840082840082840082840082
        840082840082840000FF00008400008400008484828400828400828400828400
        00FF000084000084848284008284008284008284008284008284008284848284
        FFFFFF008284848284FFFFFF008284008284008284FFFFFF848284848284FFFF
        FF0082840082840082840082840082840082840000FF00008400008400008400
        00848482840082840000FF000084000084000084000084848284008284008284
        008284008284008284848284FFFFFF008284008284848284FFFFFF008284FFFF
        FF848284008284008284848284FFFFFF00828400828400828400828400828400
        82840000FF000084000084000084000084848284000084000084000084000084
        000084848284008284008284008284008284008284848284FFFFFF0082840082
        84008284848284FFFFFF848284008284008284008284008284848284FFFFFF00
        82840082840082840082840082840082840000FF000084000084000084000084
        0000840000840000840000848482840082840082840082840082840082840082
        84008284848284FFFFFF00828400828400828484828400828400828400828400
        8284FFFFFF848284008284008284008284008284008284008284008284008284
        0000FF0000840000840000840000840000840000848482840082840082840082
        84008284008284008284008284008284008284848284FFFFFF00828400828400
        8284008284008284008284FFFFFF848284008284008284008284008284008284
        0082840082840082840082840082840000840000840000840000840000848482
        8400828400828400828400828400828400828400828400828400828400828400
        8284848284FFFFFF008284008284008284008284008284848284008284008284
        0082840082840082840082840082840082840082840082840082840000FF0000
        8400008400008400008484828400828400828400828400828400828400828400
        8284008284008284008284008284008284848284FFFFFF008284008284008284
        8482840082840082840082840082840082840082840082840082840082840082
        840082840000FF00008400008400008400008400008484828400828400828400
        8284008284008284008284008284008284008284008284008284008284848284
        008284008284008284008284848284FFFFFF0082840082840082840082840082
        840082840082840082840082840000FF00008400008400008484828400008400
        0084000084848284008284008284008284008284008284008284008284008284
        008284008284848284008284008284008284008284008284848284FFFFFF0082
        840082840082840082840082840082840082840082840000FF00008400008400
        00848482840082840000FF000084000084000084848284008284008284008284
        008284008284008284008284008284848284008284008284008284848284FFFF
        FF008284008284848284FFFFFF00828400828400828400828400828400828400
        82840000FF0000840000848482840082840082840082840000FF000084000084
        000084848284008284008284008284008284008284008284848284FFFFFF0082
        84008284848284008284848284FFFFFF008284008284848284FFFFFF00828400
        82840082840082840082840082840082840000FF000084008284008284008284
        0082840082840000FF0000840000840000840082840082840082840082840082
        84008284848284FFFFFFFFFFFF848284008284008284008284848284FFFFFF00
        8284008284848284FFFFFF008284008284008284008284008284008284008284
        0082840082840082840082840082840082840082840000FF0000840000FF0082
        8400828400828400828400828400828400828484828484828400828400828400
        8284008284008284848284FFFFFFFFFFFFFFFFFF848284008284008284008284
        0082840082840082840082840082840082840082840082840082840082840082
        8400828400828400828400828400828400828400828400828400828400828400
        8284008284008284008284008284008284008284008284848284848284848284
        0082840082840082840082840082840082840082840082840082840082840082
        8400828400828400828400828400828400828400828400828400828400828400
        8284008284008284008284008284008284008284008284008284008284008284
        008284008284008284008284008284008284}
      NumGlyphs = 2
    end
    object BAide: THBitBtn
      Left = 304
      Top = 4
      Width = 28
      Height = 27
      Hint = 'Aide'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BAideClick
      Margin = 2
      Spacing = -1
      GlobalIndexImage = 'Z1117_S16G1'
      IsControl = True
    end
    object MTANTORIG: THNumEdit
      Left = 92
      Top = 6
      Width = 137
      Height = 21
      Decimals = 2
      Digits = 12
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Masks.PositiveMask = '#,##0'
      Debit = False
      NumericType = ntDC
      ParentFont = False
      TabOrder = 3
      UseRounding = True
      Validate = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 331
    Height = 45
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 34
      Height = 13
      Caption = 'Journal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 164
      Top = 8
      Width = 23
      Height = 13
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Nature'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 164
      Top = 24
      Width = 37
      Height = 13
      Caption = 'Num'#233'ro'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object E_JOURNAL: TLabel
      Left = 48
      Top = 8
      Width = 109
      Height = 13
      AutoSize = False
      Caption = 'E_JOURNAL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object E_NATUREPIECE: TLabel
      Left = 48
      Top = 24
      Width = 109
      Height = 13
      AutoSize = False
      Caption = 'E_NATUREPIECE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object E_DATECOMPTABLE: TLabel
      Left = 216
      Top = 8
      Width = 109
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'E_DATECOMPTABLE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object E_NUMEROPIECE: TLabel
      Left = 216
      Top = 24
      Width = 109
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'E_NUMEROPIECE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 45
    Width = 331
    Height = 86
    Align = alClient
    TabOrder = 1
    object HLabel3: THLabel
      Left = 36
      Top = 67
      Width = 39
      Height = 13
      Caption = '&Montant'
      FocusControl = FMontant
    end
    object HLabel1: THLabel
      Left = 36
      Top = 12
      Width = 88
      Height = 13
      Caption = '&Mode de paiement'
      FocusControl = FModePaie
    end
    object HLabel2: THLabel
      Left = 36
      Top = 40
      Width = 82
      Height = 13
      Caption = '&Date d'#39#233'ch'#233'ance'
      FocusControl = FDateEche
    end
    object HLabel4: THLabel
      Left = 36
      Top = 112
      Width = 88
      Height = 13
      Caption = '&Mode de paiement'
      FocusControl = FModepaie2
    end
    object HLabel5: THLabel
      Left = 36
      Top = 140
      Width = 82
      Height = 13
      Caption = '&Date d'#39#233'ch'#233'ance'
      FocusControl = FDateEche2
    end
    object FTitreSup: TLabel
      Left = 12
      Top = 92
      Width = 193
      Height = 13
      Caption = 'Caract'#233'ristiques de l'#39#233'ch'#233'ance '#224' g'#233'n'#233'rer'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object FDateEche: TMaskEdit
      Left = 140
      Top = 36
      Width = 137
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
    end
    object FModePaie: THValComboBox
      Left = 140
      Top = 8
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      TagDispatch = 0
      DataType = 'TTMODEPAIE'
    end
    object FMontant: THNumEdit
      Left = 140
      Top = 64
      Width = 137
      Height = 21
      Decimals = 2
      Digits = 12
      Masks.PositiveMask = '#,##0'
      Debit = False
      NumericType = ntDC
      TabOrder = 2
      UseRounding = True
      Validate = False
    end
    object FDateEche2: TMaskEdit
      Left = 140
      Top = 136
      Width = 137
      Height = 21
      Enabled = False
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 4
      Text = '  /  /    '
    end
    object FModepaie2: THValComboBox
      Left = 140
      Top = 108
      Width = 137
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 3
      TagDispatch = 0
      DataType = 'TTMODEPAIE'
    end
  end
  object HME: THMsgBox
    Police.Charset = DEFAULT_CHARSET
    Police.Color = clWindowText
    Police.Height = -11
    Police.Name = 'MS Sans Serif'
    Police.Style = []
    Mess.Strings = (
      
        '0;Modification d'#39#233'ch'#233'ance;Vous ne pouvez pas modifier le montant' +
        ' '#224' la hausse !;W;O;O;O;'
      'Modification non effectu'#233'e'
      
        '2;Modification d'#39#233'ch'#233'ance;Vous ne pouvez pas renseigner un monta' +
        'nt nul !;W;O;O;O;'
      
        '3;Modification d'#39#233'ch'#233'ance;Vous devez renseigner une date valide ' +
        '!;W;O;O;O;'
      
        '4;Modification d'#39#233'ch'#233'ance;La date d'#39#233'ch'#233'ance doit respecter la p' +
        'lage de saisie autoris'#233'e;W;O;O;O;'
      
        '5;Modification d'#39#233'ch'#233'ance;Une '#233'criture ne peut pas avoir plus de' +
        ' douze '#233'ch'#233'ances;W;O;O;O;')
    Left = 292
    Top = 49
  end
  object HMTrad: THSystemMenu
    MaxInsideSize = False
    ActiveResize = False
    Caption = '&Personnalisation'
    Separator = True
    Traduction = True
    Left = 292
    Top = 92
  end
end