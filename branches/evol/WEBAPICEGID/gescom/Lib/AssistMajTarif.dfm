�
 TFASSISTTARIF 0^)  TPF0�TFAssistTarifFAssistTarifLeft� Top� HelpContext�w�Caption!   Assistant mise à jour des tarifsClientHeightGClientWidthPixelsPerInch`
TextHeight �THLabellEtapeTop4  �TToolbarButton97
bPrecedentTop.  �TToolbarButton97bSuivantTop.  �TToolbarButton97bFinTop.  �TToolbarButton97bAnnulerTop.  �TToolbarButton97bAideTop.  �
THGroupBox	GroupBox1TopHeight	  �THPageControl2PLeft� 
ActivePage	TabSheet1 	TTabSheet	TabSheet1Caption	TabSheet1 TBevelPBevel1Left Top)WidthRHeight� AlignalClient  THLabelTINTROLeftTop4Width8Height-AutoSizeCaptioni   Cet assistant vous guide afin de paramètrer la mise à jour de vos tarifs préalablement sélectionnés.WordWrap	  THPanelPTITRELeft Top WidthRHeight)AlignalTopCaption   Mise à jour des tarifsFullRepaintFont.CharsetDEFAULT_CHARSET
Font.ColorclActiveCaptionFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder BackGroundEffectbdFlatColorShadowclWindowText
ColorStart	clBtnFace
TextEffecttenone  	TGroupBoxGBMAJLeftTopfWidthJHeightzCaption   Type de mise à jourFont.CharsetDEFAULT_CHARSET
Font.ColorclActiveCaptionFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder THLabelTCGPRIXLeft� TopWidth� Height&AutoSizeCaptionK   Permet de modifier le prix net ou la remise en précisant une date d'effet.Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	  THLabelTCBDATELeft� TopKWidth� Height'AutoSizeCaption7   Permet de modifier la période de validité des tarifs.Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	  	TCheckBoxCB_PRIXLeftTopWidth� HeightCaption&Modification du prixColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontTabOrder OnClickCB_PRIXClick  	TCheckBoxCB_DATELeftTopPWidth� HeightCaption   Modification de la &périodeColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontTabOrderOnClickCB_DATEClick    	TTabSheet	TabSheet2Caption	TabSheet2
ImageIndex TBevelPBevel2Left Top WidthRHeight� AlignalClient  THLabel
TDATEEFFETLeft%Top� Width7HeightCaption&Date d'effetFocusControl	DATEEFFET  	TGroupBoxGBPRIXLeftTopWidth1HeightnCaptionModification des prixFont.CharsetDEFAULT_CHARSET
Font.ColorclActiveCaptionFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder  THLabelTTYPEMAJPRIXLeftTopWidth\HeightCaption   &Type de mise à jourFocusControlTYPEMAJPRIXFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelTVALEURPRIXLeftTop2WidthHeightCaption&ValeurFocusControl
VALEURPRIXFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelTARRONDIPRIXLeftTopTWidthXHeightCaption   &Méthode d"arrondiFocusControlARRONDIPRIXFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THValComboBoxTYPEMAJPRIXLeft|TopWidth� HeightStylecsDropDownListFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ItemHeight 
ParentFontTabOrder OnChangeTYPEMAJPRIXChangeTagDispatch PlusAND CO_CODE Like "P%"Vide	
VideString	<<Aucun>>DataType
GCMAJTARIF  	THNumEdit
VALEURPRIXLeft|Top2Width� HeightTabStopColor	clBtnFaceDecimalsDigitsEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Masks.PositiveMask#,##0.00Debit
ParentFontTabOrderUseRounding	Validate  THValComboBoxARRONDIPRIXLeft|TopPWidth� HeightStylecsDropDownListFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ItemHeight 
ParentFontTabOrderTagDispatch DataTypeGCCODEARRONDI   	TGroupBoxGBREMISELeftTopyWidth1HeightYCaptionModification des remisesColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclActiveCaptionFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontTabOrder THLabelTTYPEMAJREMISELeftTopWidth\HeightCaption   T&ype de mise à jourFocusControlTYPEMAJREMISEFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelTVALEURREMISELeftTop;WidthHeightCaptionV&aleurFocusControlVALEURREMISEFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THValComboBoxTYPEMAJREMISELeft|TopWidth� HeightStylecsDropDownListFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ItemHeight 
ParentFontTabOrder OnChangeTYPEMAJREMISEChangeTagDispatch PlusAND CO_CODE Like "R%"Vide	
VideString	<<Aucun>>DataType
GCMAJTARIF  	THNumEditVALEURREMISELeft|Top7Width� HeightTabStopColor	clBtnFaceDecimalsDigitsEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Masks.PositiveMask#,##0.00Debit
ParentFontTabOrderUseRounding	Validate   THCritMaskEdit	DATEEFFETLeft� Top� Width� HeightEditMask!99 >L<LL 0000;1;_	MaxLengthTabOrderText           OnExitDATEEFFETExitTagDispatch OpeTypeotDateDefaultDateodDateControlerDate	   	TTabSheet	TabSheet3Caption	TabSheet3
ImageIndex TBevelPBevel3Left Top WidthRHeight� AlignalClient  	TGroupBox	GBPERIODELeftTopWidth=Height� Caption   Modification de la périodeFont.CharsetDEFAULT_CHARSET
Font.ColorclActiveCaptionFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder  THLabelTTYPEMAJPERIODELeftTopWidth\HeightCaption   &Type de mise à jourFocusControlTYPEMAJPERIODEFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabel	TNBREJOURLeftTop4WidthHHeightCaption&Nombre de jourFocusControlNBREJOURFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabel
TDATEDEBUTLeftToptWidthCHeightCaption   Dé&but périodeFocusControl	DATEDEBUTFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THLabelTDATEFINLeft� ToptWidth4HeightCaption   Fi&n périodeFocusControlDATEFINFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  THValComboBoxTYPEMAJPERIODELeft� TopWidth� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ItemHeight 
ParentFontTabOrder OnChangeTYPEMAJPERIODEChangeTagDispatch PlusAND CO_CODE Like "D%"Vide	
VideString	<<Aucun>>DataType
GCMAJTARIF  	THNumEditNBREJOURLeft� Top0WidthHeightTabStopColor	clBtnFaceDecimals DigitsEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Masks.PositiveMask#,##0Max      ��@Min       ��?Debit
ParentFontTabOrderUseRounding	Value       ��?Validate	  TUpDown
UpDownJourLeftTop0WidthHeight	AssociateNBREJOUREnabledMinMaxmPositionTabOrder  	TCheckBoxCBDATEDEBUTLeftTopXWidthyHeightTabStopCaption   Changer date &débutEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickCBDATEDEBUTClick  	TCheckBox	CBDATEFINLeft� TopXWidth� HeightTabStopCaptionChanger date &finEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickCBDATEFINClick  THCritMaskEditDATEFINLeft� Top� WidthyHeightTabStopColor	clBtnFaceEnabledEditMask!99 >L<LL 0000;1;_Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 	MaxLength
ParentFontTabOrderText           OnExitDATEFINExitTagDispatch OpeTypeotDateDefaultDateod2099ControlerDate	  THCritMaskEdit	DATEDEBUTLeftTop� WidthyHeightTabStopColor	clBtnFaceEnabledEditMask!99 >L<LL 0000;1;_Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 	MaxLength
ParentFontTabOrderText           OnExitDATEDEBUTExitTagDispatch OpeTypeotDateDefaultDateodDateControlerDate	    	TTabSheet	TabSheet4Caption	TabSheet4
ImageIndex TBevelPBevel4Left Top WidthRHeight� AlignalClient  THLabelTRecapLeftToplWidth;HeightCaption   Récapitulatif  TPanelPanelFinLeftTopWidthIHeightaTabOrder  THLabel	TTextFin1LeftTopWidthHeightCaptionr   Le paramètrage est maintenant correctement renseigné pour permettre le lancement de la  mise à jour des tarifs.WordWrap	  THLabel	TTextFin2LeftTop1WidthHeight'Caption�   Si vous désirez revoir le paramétrage, il suffit de cliquer sur le bouton Précédent sinon, le bouton Fin, permet de débuter le traitement.WordWrap	   TListBox	ListRecapLeftTop~WidthIHeighttColor	clBtnFace
ItemHeightTabOrder    �THPanel
PanelImageLeft �TToolbarButton97ImageLeft   THMsgBoxHRecapPolice.CharsetDEFAULT_CHARSETPolice.ColorclWindowTextPolice.Height�Police.NameMS Sans SerifPolice.Style Mess.StringsOuiNon#   ATTENTION : Tarif non enregistré !c   ATTENTION : Ce tarif, en cours de traitement par un autre utilisateur, n'a pas été enregistrée !   enregistrement(s) modifié's) Left� Top  THMsgBoxHMsgErrPolice.CharsetDEFAULT_CHARSETPolice.ColorclWindowTextPolice.Height�Police.NameMS Sans SerifPolice.Style Mess.Stringsn'est pas une date valide. Left<Top   