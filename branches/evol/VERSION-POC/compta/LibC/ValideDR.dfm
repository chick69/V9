object FValideDR: TFValideDR
  Left = 220
  Top = 161
  HelpContext = 7505750
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Validation des lettres-ch'#232'que'
  ClientHeight = 324
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object G: THGrid
    Left = 0
    Top = 40
    Width = 450
    Height = 249
    Align = alClient
    ColCount = 4
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 0
    SortedCol = -1
    Titres.Strings = (
      'Tiers;G;S'
      'Libell'#233';G;S'
      'Montant;D;R'
      'Ch'#232'que;C;S')
    Couleur = False
    MultiSelect = False
    TitleBold = False
    TitleCenter = True
    ColCombo = 0
    SortEnabled = False
    SortRowExclude = 0
    TwoColors = True
    AlternateColor = 13224395
    ColWidths = (
      61
      154
      98
      111)
  end
  object pBoutons: TPanel
    Left = 0
    Top = 289
    Width = 450
    Height = 35
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 1
    object bAnnuler: THBitBtn
      Left = 385
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
      Left = 417
      Top = 4
      Width = 28
      Height = 27
      Hint = 'Aide'
      HelpContext = 1395200
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
    object BValider: THBitBtn
      Left = 353
      Top = 4
      Width = 28
      Height = 27
      Hint = 'Valider'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Margin = 3
      NumGlyphs = 2
      Spacing = -1
      GlobalIndexImage = 'Z0127_S16G1'
      IsControl = True
    end
    object bNumerote: THBitBtn
      Left = 4
      Top = 4
      Width = 28
      Height = 27
      Hint = 'Renum'#233'roter les ch'#232'ques '#224' partir du ch'#232'que s'#233'lectionn'#233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = bNumeroteClick
      Margin = 2
      Spacing = -1
      GlobalIndexImage = 'Z0165_S16G1'
      IsControl = True
    end
    object bDetruit: THBitBtn
      Left = 36
      Top = 4
      Width = 28
      Height = 27
      Hint = 'Marquer le ch'#232'que s'#233'lectionn'#233' comme d'#233'truit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = bDetruitClick
      Margin = 2
      NumGlyphs = 2
      Spacing = -1
      GlobalIndexImage = 'Z2102_S16G2'
      IsControl = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 40
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 2
    object HLabel1: THLabel
      Left = 7
      Top = 6
      Width = 432
      Height = 26
      AutoSize = False
      Caption = 
        'Indiquez si certains ch'#232'ques ont '#233't'#233' d'#233'truits '#224' l'#39'impression, et' +
        ' '#233'ventuellement renum'#233'rotez les ch'#232'ques imprim'#233's en cas de d'#233'cal' +
        'age.'
      WordWrap = True
    end
  end
  object Msg: THMsgBox
    Police.Charset = DEFAULT_CHARSET
    Police.Color = clWindowText
    Police.Height = -11
    Police.Name = 'MS Sans Serif'
    Police.Style = []
    Mess.Strings = (
      'D'#233'truit'
      
        '1;?caption?;Marquer le ch'#232'que s'#233'lectionn'#233' comme '#233'tant d'#233'truit ? ' +
        'Attention cette op'#233'ration est d'#233'finitive.;Q;YN;Y;N;')
    Left = 23
    Top = 195
  end
  object HMTrad: THSystemMenu
    Caption = '&Personnalisation'
    Separator = True
    Traduction = True
    Left = 64
    Top = 195
  end
end
