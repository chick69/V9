object FMonoEche: TFMonoEche
  Left = 443
  Top = 136
  HelpContext = 7247100
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Saisie mono-'#233'ch'#233'ance'
  ClientHeight = 151
  ClientWidth = 239
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object HLabel1: THLabel
    Left = 4
    Top = 12
    Width = 88
    Height = 13
    Caption = '&Mode de paiement'
    FocusControl = FModePaie
  end
  object HLabel2: THLabel
    Left = 4
    Top = 40
    Width = 82
    Height = 13
    Caption = '&Date d'#39#233'ch'#233'ance'
    FocusControl = FDateEche
  end
  object HLabel3: THLabel
    Left = 4
    Top = 68
    Width = 70
    Height = 13
    Caption = 'Date de &valeur'
    FocusControl = FDatevaleur
  end
  object HNumTraiteCHQ: THLabel
    Left = 4
    Top = 96
    Width = 51
    Height = 13
    Caption = 'N'#176' ch'#232'que'
    FocusControl = FNumTraiteCHQ
  end
  object FModePaie: THValComboBox
    Left = 96
    Top = 8
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = FModePaieChange
    TagDispatch = 0
  end
  object FDateEche: TMaskEdit
    Left = 96
    Top = 36
    Width = 137
    Height = 21
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 1
    Text = '01/01/1900'
    OnExit = FDateEcheExit
  end
  object BValider: THBitBtn
    Left = 140
    Top = 121
    Width = 28
    Height = 27
    Hint = 'Valider'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
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
    Margin = 2
    NumGlyphs = 2
    Spacing = -1
    IsControl = True
  end
  object BAnnuler: THBitBtn
    Left = 172
    Top = 121
    Width = 28
    Height = 27
    Hint = 'Fermer'
    Cancel = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = BAnnulerClick
    Margin = 2
    Spacing = -1
    GlobalIndexImage = 'Z0021_S16G1'
    IsControl = True
  end
  object Baide: THBitBtn
    Left = 204
    Top = 121
    Width = 28
    Height = 27
    Hint = 'Aide'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = BaideClick
    GlobalIndexImage = 'Z1117_S16G1'
  end
  object FDatevaleur: TMaskEdit
    Left = 96
    Top = 64
    Width = 137
    Height = 21
    EditMask = '!99/99/0000;1;_'
    MaxLength = 10
    TabOrder = 2
    Text = '01/01/1900'
    OnExit = FDatevaleurExit
  end
  object FNumTraiteCHQ: TMaskEdit
    Left = 96
    Top = 92
    Width = 137
    Height = 21
    TabOrder = 3
    OnExit = FDatevaleurExit
  end
  object HM: THMsgBox
    Police.Charset = DEFAULT_CHARSET
    Police.Color = clWindowText
    Police.Height = -11
    Police.Name = 'MS Sans Serif'
    Police.Style = []
    Mess.Strings = (
      
        '0;Saisie mono-'#233'ch'#233'ance;Vous devez renseigner un mode de paiement' +
        ';W;O;O;O;'
      
        '1;Saisie mono-'#233'ch'#233'ance;Vous devez valider les informations;W;O;O' +
        ';O;'
      
        '2;Saisie mono-'#233'ch'#233'ance;La date d'#39#233'ch'#233'ance doit respecter la plag' +
        'e de saisie autoris'#233'e;W;O;O;O;'
      'N'#176' ch'#232'que'
      'N'#176' traite')
    Left = 12
    Top = 120
  end
  object HMTrad: THSystemMenu
    Caption = '&Personnalisation'
    Separator = True
    Traduction = True
    Left = 68
    Top = 120
  end
end