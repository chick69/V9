�
 TFASSISTOLE 0�h  TPF0�TFAssistOLE
FAssistOLELeftJTop� Caption
FAssistOLEClientHeight�ClientWidth"PixelsPerInch`
TextHeight �THLabellEtapeTop  �THLabellAideLeft� TopaWidthv  �THLabellRubLeft� TopWidth&HeightAutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  �TLabellSourceLeft� TopWidth1HeightAutoSize  �TToolbarButton97
bPrecedentLeft'Topz  �TToolbarButton97bSuivantLeftzTopz  �TToolbarButton97bFinLeft�TopzEnabled  �TToolbarButton97bAnnulerLeft� Topz  �TToolbarButton97bAideLeft� Topx  �THPanelPlanLeft� Top  �	TGroupBox	GroupBox1TopmWidth5  �TPageControlPLeft� TopHeight>
ActivePageChoixSourceOnEnterFlagExtEnter 	TTabSheetChoixFormuleCaptionChoixFormule TLabelLabel2LeftTopWidth5HeightAutoSizeCaptionBienvenue dans l'assistantFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel3Left+TopWidth� HeightAutoSizeCaption0   Quel type de données souhaîtez-vous extraire ?  THLabelHLabel2LeftCTopyWidthHeight'AutoSizeCaption�   Dans ce cas, vous pourrez extraire une information issue d'une fiche. Par exemple, le libellé d'un compte ou l'adresse d'un tiers.WordWrap	  THLabelHLabel4LeftCTop9WidthHeight+AutoSizeCaption�   Dans ce cas, vous pouvez extraire une information calculée et définir des critères personnalisés. Par exemple, vous obtiendrez le cumul d'une rubrique.WordWrap	  THLabelHLabel10LeftCTop� WidthHeightAutoSizeCaptionZ   Dans ce cas, vous pourrez extraire une constante comme par exemple le nombre de salariés.WordWrap	  TSpeedButtonbValLeft� Top� Width*HeightHint!Extrait la valeur d'une constante
GroupIndexCaptionValeurParentShowHintShowHint	VisibleOnClick	bValClick  TSpeedButtonbLibLeft� Top� Width*HeightHint#   Extrait le libellé d'une constante
GroupIndexCaption   LibelléParentShowHintShowHint	VisibleOnClick	bLibClick  TLabelRegroupementLeft+Top� Width� HeightCaptionRegroupement multi-dossiers  TRadioButtonrCumulLeftBTop&WidthdHeightCaption	un &cumulChecked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder TabStop	OnClickrCumulClick  TRadioButtonrChampLeftATopdWidthdHeightCaption	un c&hampFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickrChampClick  TRadioButton
rConstanteLeftATop� WidthjHeightCaptionune cons&tanteFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickrConstanteClick  TRadioButtonRSQLLeftATop� Width� HeightCaption   Une requète SQLFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClick	RSQLClick  THValComboBoxMULTIDOSSIERLeftATopWidth� HeightStylecsDropDownList
ItemHeight TabOrderTagDispatch Vide	DataTypeYYMULTIDOSSIER   	TTabSheetChoixSourceCaptionChoixSource TLabelLabel5LeftTop�Width� HeightCaption#   Choisissez la source des données :  TLabellBudgetLeft$Top~Width� HeightCaption/   Calculer les informations budgétaires sur le :  TRadioGrouprSourceLeftTop	Width)HeightrColumns	ItemIndex Items.Strings	Rubriques   Rubriques budgétaires   Comptes générauxTiersSections analytiques   Comptes budgétaires   Sections budgétairesJournauxBudgets	   Société   Généraux/Tiers   Généraux/SectionsComptes/Sections Budget TabOrderOnClickrSourceClickOnEnterrSourceEnter  TRadioGrouprBudgetLeftTop� Width)Height'Columns	ItemIndex Items.Strings   Budgeté	   Réalisé TabOrderOnClickrBudgetClick  	TGroupBoxgAxeLeftTop� Width)Height%TabOrder THLabellAxeLeft6TopWidthIHeightCaptionChoisissez l'axe  THValComboBoxcAxeLeft� TopWidthLHeightStylecsDropDownList
ItemHeightTabOrder OnChange
cAxeChangeOnEnter	cAxeEnterTagDispatch DataTypeTTAXE   	TGroupBoxGSensLeftTop� Width)Height*TabOrderVisible THLabelLSensLeft"TopWidthUHeightCaptionChoisissez le sens  THValComboBoxCSensLeft~TopWidthqHeightStylecsDropDownList
ItemHeightTabOrder TagDispatch DataTypeTTRUBCALCUL   TRadioGroupCMonnaieLeftTop� Width)Height#CaptionRestitution en ... Columns	ItemIndex Items.StringsMonnaie de tenueContrevaleur TabOrder  	TCheckBoxGC2Left� Top�WidthaHeightCaption
Get_Cumul2TabOrder   	TGroupBoxGBalSitLeftTop� Width)Height%TabOrder 	TCheckBoxCCBalSitLeft`TopWidthaHeightCaptionEn situationTabOrder OnClickCCBalSitClick    	TTabSheetPSQLCaptionSQL
ImageIndex 	TGroupBox	GroupBox2Left
TopWidth5Height� CaptionSQL TabOrder  	THSQLMemoZ_SQLLeftTopWidth1Height� AlignalClientFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrder 
ColorRules    	TCheckBox
FlagExtSQLLeft	Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit	RefCelSQLLeft� Top� Width� HeightEnabledTabOrderOnChangeRefCelRecChangeOnEnterRefCelEnter   	TTabSheetBudgetCaptionBudget TLabelLabel7Left,Top<Width"HeightCaption&Budget  THValComboBoxcBudgetLeft,TopNWidth� HeightStylecsDropDownList
ItemHeight TabOrder OnEntercDeviseEnterTagDispatch DataTypeTTBUDJAL  	TCheckBox
FlagExtBudLeft,Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit	RefCelBudLeft� Top� Width~HeightEnabledTabOrderOnEnterRefCelEnter   	TTabSheet
CptVariantCaptionCompte(s) "variant(s)"
ImageIndex
 TLabelLabel8Left,Top*Width� HeightCaption+   Paramètre variant de rubriques composites   TLabelLabel9Left5Top?Width� HeightCaption!(Comptes, racines ou fourchettes)  	TCheckBoxFlagExtVariantLeft,Top� WidthxHeightCaption   &Référence de celluleTabOrder OnClickFlagExtClickOnEnterFlagExtEnter  TEditRefCellVariantLeft� Top� Width~HeightEnabledTabOrderOnEnterRefCelEnter  TEditcCptVariantLeft,Top\Width� HeightTabOrderOnEntercCptVariantEnter   	TTabSheetChoixRecCaptionChoixRec TEditFindCodeLeft	Top� WidthHHeightCharCaseecUpperCaseTabOrder OnChangeFindCodeChangeOnEnterFindCodeEnter  TEditFindLibLeftTTop� Width� HeightTabOrderOnEnterFindLibEnter  	TCheckBox
FlagExtRecLeft	Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit	RefCelRecLeft� Top� Width� HeightEnabledTabOrderOnChangeRefCelRecChangeOnEnterRefCelEnter  THGridTHGRIDLeft	TopWidth.Height� ColCountDefaultRowHeight	FixedCols RowCountOptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect TabOrderOnClickTHGRIDClick	SortedCol�Titres.StringsCode   Libellé CouleurMultiSelect	TitleBoldTitleCenterColCombo SortEnabledSortRowExclude 	TwoColorsAlternateColor��� 	ColWidths@�     	TTabSheetChoixBalSitCaptionChoixBalSit
ImageIndex TLabelLabel10Left,Top<Width'HeightCaption&Balance  THValComboBoxCBalSitLeft,TopNWidth� HeightStylecsDropDownList
ItemHeight TabOrder OnEntercEtablissementEnterTagDispatch Vide	DataTypeCPBALSIT  	TCheckBoxFlagExtBalSitLeft,Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClick  TEditRefCelBalSitLeft� Top� Width~HeightEnabledTabOrderOnEnterRefCelEnter   	TTabSheet	ChoixRec2Caption	ChoixRec2
ImageIndex TEdit	FindCode2TagLeft	Top� WidthHHeightCharCaseecUpperCaseTabOrder OnChangeFindCode2ChangeOnEnterFindCodeEnter  TEditFindLib2TagLeftTTop� Width� HeightTabOrderOnChangeFindLib2ChangeOnEnterFindLibEnter  	TCheckBoxFlagExtRec2TagLeft	Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit
RefCelRec2TagLeft� Top� Width� HeightEnabledTabOrderOnChangeRefCelRecChangeOnEnterRefCelEnter  THGridGridRub2Left	Top
Width.Height� ColCountDefaultRowHeight	FixedCols RowCountOptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect TabOrderOnClickGridRub2Click
OnDblClickGridRubDblClickOnEnterGridRubEnter	SortedCol�Titres.StringsCode   Libellé CouleurMultiSelect	TitleBoldTitleCenterColCombo SortEnabledSortRowExclude 	TwoColorsAlternateColor��� 	ColWidths@�     	TTabSheetPeriodeCaptionPeriode THLabel	LExerciceLeft#Top-Width)HeightCaption	&Exercice  THLabelHLabel7Left#TopZWidth$HeightCaption	   &Période  THLabellDetailPeriodeLeft#Top� Width?HeightCaption   &ComplémentsVisible  THLabelLNumperiode1Left� TopnWidthHeightAutoSizeCaption   &àFocusControlNumPeriode1  THValComboBoxcNumPeriodeLeft� TopjWidth� HeightStylecsDropDownList
ItemHeight TabOrderVisibleOnClickcNumPeriodeClickTagDispatch Values.StringsNMBTQS   THValComboBox	cExerciceLeft#Top>WidthHeightStylecsDropDownList
ItemHeightTabOrderOnEntercExerciceEnterItems.StringsExercice courantExercice N-1Exercice N-2Exercice N-3Exercice N+1 TagDispatch Values.Strings ------+   THValComboBoxcPeriodeLeft#TopjWidth|HeightStylecsDropDownList
ItemHeightTabOrderOnChangecPeriodeChangeOnEntercPeriodeEnterItems.StringsExercice entierMoisBimestre	TrimestreQuadrimestreSemestreSemaine TagDispatch Values.StringsNMBTQSW   THValComboBoxcDetailPeriodeLeft#Top� WidthHeightStylecsDropDownList
ItemHeightTabOrderVisibleOnEntercDetailPeriodeEnterItems.Strings%   Uniquement la période sélectionnée6   Du début de l'exercice jusqu'à la période (incluse)6   Du début de la période jusqu'à la fin de l'exercice TagDispatch Values.Strings <>   	THNumEdit
NumPeriodeLeft� TopjWidthHeightDecimalsDigitsMasks.PositiveMask#,##0Min       ��?DebitTabOrderUseRounding	Value       ��?ValidateVisibleOnChangeNumPeriodeChangeOnEnterNumPeriodeEnterOnExitNumPeriodeExit  	TCheckBox
CheckExoOKLeft#TopWidthHeightCaption-   Les exercices sont calés sur l'année civileChecked	State	cbCheckedTabOrder OnClickCheckExoOKClick  	TCheckBox
FlagExtPerLeft#Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit	RefCelPerLeft� Top� Width� HeightEnabledTabOrder	OnEnterRefCelEnter  	THNumEditNumPeriode1Left� TopjWidthHeightDecimalsDigitsMasks.PositiveMask#,##0Min       ��?DebitTabOrderUseRounding	Value       ��?ValidateVisibleOnChangeNumPeriodeChangeOnEnterNumPeriodeEnterOnExitNumPeriode1Exit  THValComboBoxcAnneeLeft� TopjWidth:HeightStylecsDropDownList
ItemHeightTabOrderItems.Strings2010200920082007200620052004200320022001200019991998199719961995 TagDispatch Values.Strings2010200920082007200620052004200320022001200019991998199719961995    	TTabSheetCriteresCaptionCriteres THLabelHLabel5Left+Top$WidthqHeightAutoSizeCaption   &Type d'écrituresFocusControl
cNatureEcr  THLabelHLabel3Left+TopRWidth� HeightAutoSizeCaption   &Intégration des A-nouveauxFocusControl
cNatureEcr  THValComboBox
cNatureEcrLeft+Top5Width� HeightStylecsDropDownListCtl3D	
ItemHeight ParentCtl3DTabOrder OnEntercNatureEcrEnterTagDispatch DataTypeTTQUALPIECECRIT  THValComboBoxcIntegANLeft+TopdWidth� HeightStylecsDropDownListCtl3D	
ItemHeightParentCtl3DTabOrderOnEntercIntegANEnterItems.StringsAvec les A-nouveauxSans les A-nouveauxQue les A-nouveaux TagDispatch Values.Strings -#   	TCheckBox
FlagExtEcrLeft*Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit	RefCelEcrLeft� Top� Width� HeightEnabledTabOrderOnEnterRefCelEnter  TRadioGroupRevisionLeft+TopWidth� Height2	ItemIndexItems.Strings#   Inclure les écritures de révision#   Exclure les écritures de révision TabOrder  	TCheckBoxAvecIFRSLeft*Top� Width� HeightCaption   Inclure les écritures d'IFRSTabOrder   	TTabSheetEtablissementCaptionEtablissement TLabelLabel1Left,Top<WidthAHeightCaption&Etablissement  THValComboBoxcEtablissementLeft,TopNWidth� HeightStylecsDropDownList
ItemHeight TabOrder OnEntercEtablissementEnterTagDispatch Vide	DataTypeTTETABLISSEMENT  	TCheckBoxFlagExtEtabLeft,Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClick  TEdit
RefCelEtabLeft� Top� Width~HeightEnabledTabOrderOnEnterRefCelEnter   	TTabSheetDeviseCaptionDevise TLabelLabel4Left,Top<Width!HeightCaption&Devise  THValComboBoxcDeviseLeft,TopNWidth� HeightStylecsDropDownList
ItemHeight TabOrder OnEntercDeviseEnterTagDispatch Vide	DataTypeTTDEVISE  	TCheckBox
FlagExtDevLeft,Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEdit	RefCelDevLeft� Top� Width~HeightEnabledTabOrderOnEnterRefCelEnter   	TTabSheet
ChoixChampCaption
ChoixChamp THLabelHLabel1LeftTopWidth� Height	AlignmenttaCenterCaption%   Quel champ souhaîtez-vous extraire ?  	TCheckBoxFlagExtFieldLeftTop� WidthxHeightCaption   &Référence de celluleTabOrder OnClickFlagExtClickOnEnterFlagExtEnter  TEditRefCelFieldLeft� Top� Width� HeightEnabledTabOrderOnEnterRefCelEnter  	TCheckBoxcLibelleLeftTop� Width� HeightCaption-   &Afficher le libellé complet au lieu du codeTabOrderOnEnterFlagExtEnter  THGrid
GridFieldsLeftTopWidthLHeight� ColCountDefaultRowHeight	FixedCols RowCountOptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect TabOrderOnClickGridFieldsClick
OnDblClickGridFieldsDblClick	SortedCol�Titres.StringsChamp   Libellé CouleurMultiSelect	TitleBoldTitleCenterColCombo SortEnabledSortRowExclude 	TwoColorsAlternateColor��� 	ColWidths\�     	TTabSheetPAvancesCaptionPAvances
ImageIndex TToolbarButton97bEffaceAvanceLeft,Top� WidthHeightDisplayModedmGlyphOnly
Glyph.Data
�  �  BM�      6  (               |                      �  �   �� �   � � ��  ��� ��� �Ȥ ��� ��@  ��  @@  ��  @� ��� ` � ��� �� � ` ��� ��  ��� ��  ��i ��� ���  �o* ͸? 6�H A�� B^� zb� �Ob �/ vf(  E  >E (j j9� �2J      """ 000 ___ ))) UUU MMM BBB       999 ��� ��� ��� ` ``         ( +	      9 �    %    I ;  /    ] E  :  I S �  � + l!! Y  Q  jG g2  a  �1  � a { S gC �.. Y& FQ I.h �R �j #� �S  � � Jj l3u �AJ e7 ,� �� �,N �Q  �d Vo �CY r6 3�  �  _w qG� C� }-� ��  #nz  �& �s � � @ � ��@ �@   �  [� �  pR� L�$ ��
 {n6 �uD � � �q  � � J�V �H4 �2� pA� �h B�6 ��  �"� 3}� ��% �Z6  �\  H� ��" M�B RX� ��  �$� �Vs  �� <o� X�g ω  �� �.� Y� g�L �� �}: б  ��  �� =�� ��V �C� �q� ɢ8 �S� e�� ��F �M� j�� ��L ��� ��� ��� ��� ��� Z�� ��c  eL" ?N� ppP ��� ��� iii www ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� ��� f�� x�� ��� ��� ��� ��� 7�� T�� p�v ��x �d� Ӄ� 2?�  }� #xD `_$ ,   �  �  91 >�� �w �ذ !V 0   �Ȉ  y� �p� i�Q ��� �t� �|� ��� 9) 9b� ��� ��� 1  j�) ��� ��� ���   �  �   �� �   � � ��  ��� ������������������������������������������������������������� �����������  ������  ��� �  ��� �  ��� ��  � ��� ���� ���� ���� ���GlyphMask.Data
       OnClickbEffaceAvanceClick  THValComboBoxZ_C3LeftTopmWidthfHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrder TagDispatch   THValComboBoxZ_C2LeftTopMWidthfHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch   THValComboBoxZ_C1LeftTop-WidthfHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch   THValComboBoxZO1LeftjTop-WidthNHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch DataType	TTCOMPARE  THValComboBoxZO2LeftjTopMWidthNHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch DataType	TTCOMPARE  THValComboBoxZO3LeftjTopmWidthNHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch DataType	TTCOMPARE  TEditZV3Left� TopmWidthmHeightCtl3D	ParentCtl3DTabOrder  TEditZV2Left� TopMWidthmHeightCtl3D	ParentCtl3DTabOrder  TEditZV1Left� Top-WidthmHeightCtl3D	ParentCtl3DTabOrder  	TComboBoxZG1Left,Top-Width&HeightStylecsDropDownListCtl3D
ItemHeightParentCtl3DTabOrder	Items.StringsEtOu   	TComboBoxZG2Left,TopMWidth&HeightStylecsDropDownListCtl3D
ItemHeightParentCtl3DTabOrder
Items.StringsEtOu   THValComboBoxZ_C4LeftTop� WidthfHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch   THValComboBoxZ_C5LeftTop� WidthfHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch   THValComboBoxZ_C6LeftTop� WidthfHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch   THValComboBoxZO6LeftjTop� WidthNHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch DataType	TTCOMPARE  THValComboBoxZO5LeftjTop� WidthNHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch DataType	TTCOMPARE  THValComboBoxZO4LeftjTop� WidthNHeightStylecsDropDownListCtl3D
ItemHeight ParentCtl3DTabOrderTagDispatch DataType	TTCOMPARE  TEditZV4Left� Top� WidthmHeightCtl3D	ParentCtl3DTabOrder  TEditZV5Left� Top� WidthmHeightCtl3D	ParentCtl3DTabOrder  TEditZV6Left� Top� WidthmHeightCtl3D	ParentCtl3DTabOrder  	TComboBoxZG4Left,Top� Width&HeightStylecsDropDownListCtl3D
ItemHeightParentCtl3DTabOrderItems.StringsEtOu   	TComboBoxZG5Left,Top� Width&HeightStylecsDropDownListCtl3D
ItemHeightParentCtl3DTabOrderItems.StringsEtOu   	TComboBoxZG3Left,TopmWidth&HeightStylecsDropDownListCtl3D
ItemHeightParentCtl3DTabOrderItems.StringsEtOu   	TCheckBoxCBLibLeftTop
Width� HeightCaption   Voir les libellés des champsTabOrderOnClick
CBLibClick  TRadioGrouprEcrLeft� TopWidth� Height!CaptionEcritures...ColumnsEnabledItems.Strings   GénéralesAnalytiques TabOrderOnClick	rEcrClick   	TTabSheetResultatCaptionResultat TPanelPanel1Left TopWidthQHeight
BevelOuter	bvLoweredCaption TabOrder  THLabelHLabel8LeftmTopWidth{Height	AlignmenttaCenterCaption   Résumé de la formuleFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  THLabell1Left	Top$WidthLHeightCaptionType de formule  THLabell2Left	Top6WidthNHeightCaption   Source données  THLabell3Left	TopIWidthKHeightCaption   Type d'écritures  THLabell4Left	TopuWidthAHeightCaptionEtablissement  THLabell5Left	Top� Width!HeightCaptionDevise  THLabell6Left	Top� Width$HeightCaption   Période  THLabelpFormuleLeftTop� Width=Height-AutoSizeColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclMaroonFont.Height�	Font.NameCourier New
Font.StylefsBold ParentColor
ParentFontWordWrap	  THLabelr1Left^Top%Width� HeightAutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  THLabelr2Left^Top7Width� HeightAutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  THLabelr3Left^TopIWidth� Height'AutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  THLabelr4Left^TopvWidth� HeightAutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  THLabelr5Left^Top� Width� HeightAutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  THLabelr6Left^Top� Width� Height'AutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TBevelBevel3LeftgTopWidth� HeightShapebsFrameStylebsRaised  TBevelBevel4LeftTop-WidthBHeightShapebsBottomLineStylebsRaised  TBevelBevel5Left	Top?WidthBHeightShapebsBottomLineStylebsRaised  TBevelBevel6LeftToplWidthBHeightShapebsBottomLineStylebsRaised  TBevelBevel7Left	Top~WidthBHeightShapebsBottomLineStylebsRaised  TBevelBevel8Left	Top� WidthBHeightShapebsBottomLineStylebsRaised  TBevelBevel9Left	Top� WidthBHeightShapebsBottomLineStylebsRaised  TBevelBevel1LeftZTop)WidthHeight� Shape
bsLeftLineStylebsRaised  THLabelHLabel6Left	Top� WidthHeightCaptionFiltre  TBevelBevel2Left	Top� WidthBHeightShapebsBottomLineStylebsRaised  THLabelr7Left^Top� Width� Height"AutoSizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont     �	TGroupBox	TitleLineLeft� TopWidth^HeightTabOrder  �THValComboBoxcSourcesLeftTop� Width>HeightStylecsDropDownListColorclYellow
ItemHeightTabOrderVisibleItems.StringsRubrique comptable   Compte généralTiersSection analytiqueJournal   Rubrique budgetaire - budgeté   Rubrique budgetaire - réalisé   Compte budgétaire - budgeté   Compte budgétaire - réalisé   Section budgétaire - budgeté   Section budgétaire - réaliséBudget	   Société TagDispatch   �	TTabSheet	TabSheet1CaptionDevise TLabelLabel6Left,Top<Width!HeightCaption&Devise  THValComboBoxHValComboBox1Left,TopNWidth� HeightStylecsDropDownList
ItemHeight TabOrder OnEntercDeviseEnterTagDispatch Vide	DataTypeTTDEVISEETAT  	TCheckBox	CheckBox1Left,Top� WidthxHeightCaption   &Référence de celluleTabOrderOnClickFlagExtClickOnEnterFlagExtEnter  TEditEdit1Left� Top� Width~HeightEnabledTabOrderTextEdit1OnEnterRefCelEnter   �TListBox	cControlsLeftgTop�   �THMsgBoxMsgMess.StringsEtape71;Assistant;Voulez-vous quitter l'assistant ?;Q;YN;Y;C;I   2;Moniteur SQL;Vous ne pouvez pas exécuter ce type de commande.;W;O;O;O; LeftETop  �THMsgBoxMsgEFPolice.CharsetDEFAULT_CHARSETPolice.ColorclWindowTextPolice.Height�Police.NameMS Sans SerifPolice.Style Mess.Strings   Assistant états financiers8   Sélectionnez le type d'écritures à prendre en compte.D   Sélectionnez la manière d'intégrer les A-nouveaux dans le calcul.#   Sélectionnez l'exercice concerné."   Sélectionnez le type de période.6   Sélectionnez l'indice de la période dans l'exercice.Q   Sélectionnez si la période s'étend du début ou jusqu'à la fin de l'exercice.   Sélectionnez l'établissement.   Sélectionnez la devise.3   Sélectionnez un élément dans la liste ci-dessus.Filtrez la liste par code.   Filtrez la liste par libellé.   Aucun élément sélectionnéJanvier   FévrierMarsAvrilMaiJuinJuillet   Août	SeptembreOctobreNovembre	   Décembrede   àH   Renseignez la référence de la cellule contenant la valeur appropriée.<   Cochez cette case si la valeur est située dans une cellule.   Référence de cellule"   (société en cours d'utilisation)%   Sélectionnez la source des données.   Sélectionnez l'axe analytique.	Rubriques   Rubriques budgétaires   Comptes générauxTiersSections analytiques   Comptes budgétaires   Sections budgétairesJournauxBudgets	   SociétéRubrique	Rub. bud.CompteTiersSection
Cpte bud..
Sect. bud.JournalBudget	   Société	ConstanteCPour recopier la formule dans la cellule courante, cliquez sur Fin.&Devise&Budget   Sélectionnez le budget.(   Sélectionnez le(s) compte(s) variant(s).	Rubriques   Rubriques budgétaires   Comptes générauxTiersSections analytiques   Comptes budgétaires   Sections budgétairesJournauxBudgets	   Société   Généraux/Tiers   Généraux/SectionsComptes/Sections Budget   Left%Top  �THMsgBoxMsgFPolice.CharsetDEFAULT_CHARSETPolice.ColorclWindowTextPolice.Height�Police.NameMS Sans SerifPolice.Style Mess.StringsCumulChampConstante (valeur)   Constante (libellé)
Rubrique :   Rubrique budgétaire :Compte :Tiers :	Section :   Compte budgétaire :   Section budgétaire :	Journal :Budget :	   SociétéAxe   Référence de cellule :   (+ révision)Constante :Champ   Type d'écrituresCell. LeftfTop  �THSystemMenuHMTradLeft� Top   