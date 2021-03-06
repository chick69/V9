program Majcegid;

uses
  Forms,
  Hent1,
  MDispACeg in '..\..\commun\LibMajCegid\MDispACeg.pas' {gctie: TDataModule},
  HManifest in '..\..\COMMUN\Lib\HManifest.pas',
  Ent1 in '..\..\COMPTA\LIB4\Ent1.pas',
  AGLInitRT in '..\..\PROSPECT\lib\AGLInitRT.pas',
  Assist {FAssist},
  edtQR {EditQR},
  Fiche {FFiche},
  FichGrid {FFicheGrid},
  FichList {FFicheListe},
  GRS1 {FGRS1},
  MenuOLG {FMenuG},
  Mul {FMul},
  QRS1 {FQRS1},
  SplashG {SplashScreen},
  Tablette {FTablette},
  Vierge {FVierge},
  utilPGI in '..\..\COMMUN\LIB\utilPGI.pas',
  AJOUTSOCRGT_TOF in '..\..\COMMUN\LIB\AJOUTSOCRGT_TOF.pas',
  EntGC in '..\..\commun\lib\EntGC.pas',
  galEnv in '..\..\dp\Lib\galEnv.pas',
  MajHalley in '..\..\COMMUN\LIB\MajHalley.pas',
  AssistInitSoc in '..\..\commun\lib\AssistInitSoc.pas' {FAssistInitSoc},
  UtilSoc in '..\..\commun\lib\UtilSoc.pas',
  SAISUTIL in '..\..\compta\LIB4\SAISUTIL.pas',
  LettAuto in '..\..\commun\lib\Lettauto.pas',
  UtilSais in '..\..\compta\LIB4\UtilSais.pas',
  HCompte in '..\..\COMPTA\LIB4\HCompte.pas' {FZoom},
  HZoomSP in '..\..\COMPTA\LIB4\HZoomSP.pas' {FZoomSP},
  LettUtil in '..\..\compta\LIBC\LettUtil.pas',
  SaisComm in '..\..\compta\LIBC\SaisComm.pas',
  FichComm in '..\..\commun\lib\FichComm.pas',
  Exercice in '..\..\compta\LIB4\Exercice.pas' {FExercice},
  HRegCpte in '..\..\compta\LIB4\HREGCPTE.PAS',
  Devise in '..\..\compta\LIB4\Devise.pas' {FDevise},
  Chancel in '..\..\COMPTA\LIB4\Chancel.pas' {FChancel},
  TVA in '..\..\COMPTA\LIB4\TVA.pas' {FTva},
  Journal in '..\..\COMPTA\LIB4\Journal.pas' {FJournal},
  UTILEDT in '..\..\compta\LIBC\UTILEDT.pas',
  CPTESAV in '..\..\compta\LIBC\Cptesav.pas',
  CRITEDT in '..\..\compta\LIBC\Critedt.pas',
  CPTEUTIL in '..\..\compta\LIB4\Cpteutil.pas',
  tcalccum in '..\..\compta\LIB4\TCALCCUM.PAS',
  QR in '..\..\COMPTA\LIB4\QR.pas' {FQR},
  QRRupt in '..\..\compta\LIBC\QRRupt.pas',
  RapSuppr in '..\..\COMPTA\LIBC\RapSuppr.pas' {FRapsuppr},
  RappType in '..\..\compta\LIBC\RappType.pas',
  MulGene in '..\..\compta\LIBC\MulGene.pas' {FMulgene},
  Ventil in '..\..\COMPTA\LIBC\Ventil.pas' {FVentil},
  CodeSect in '..\..\COMPTA\LIBC\CodeSect.pas' {FCodesect},
  Structur in '..\..\COMPTA\LIBC\Structur.pas' {FStructure},
  BanqueCp in '..\..\COMPTA\LIB4\BanqueCp.pas' {FbanqueCP},
  LetBatch in '..\..\compta\LIBC\LetBatch.pas',
  ImpPrefG in '..\..\COMPTA\LIBC\ImpPrefG.pas' {FImporPRef},
  ModifZS in '..\..\COMPTA\LIBC\ModifZS.pas' {FModifZS},
  Budsect in '..\..\COMPTA\LIB4\Budsect.pas' {Fbudsect},
  BUDJALSP in '..\..\COMPTA\LIBC\BUDJALSP.PAS' {BudJalSP},
  MulTiers in '..\..\compta\LIBC\MulTiers.pas' {FMulTierC},
  MulSecti in '..\..\compta\LIBC\MulSecti.pas' {FMulSection},
  Venttype in '..\..\COMPTA\LIBC\Venttype.pas' {FVentilType},
  Codeafb in '..\..\COMPTA\LIB4\Codeafb.pas' {FCodeAFB},
  EtbMce in '..\..\COMPTA\LIBL\EtbMce.pas' {FMce},
  OuvreExo in '..\..\COMPTA\LIBC\OuvreExo.pas' {OuvExo},
  ImPlan in '..\..\compta\LIBI\ImPlan.pas',
  ImOuPlan in '..\..\compta\LIBI\ImOuPlan.pas',
  ImDotInt in '..\..\COMPTA\LIBI\ImDotInt.pas' {FDotInt},
  SoldeCpt in '..\..\compta\LIBC\SoldeCpt.pas',
  TabLiEdt in '..\..\COMPTA\LIBC\TabLiEdt.pas' {FTabLiEdt},
  TriTabLi in '..\..\compta\LIBC\TriTabLi.pas' {FChoiTri},
  EuroPGI in '..\..\commun\lib\EuroPGI.pas',
  TomProfilUser in '..\..\compta\libn\TomProfilUser.pas',
  DiversCommunTOT in '..\..\commun\lib\DiversCommunTOT.pas',
  AfInitSoc in '..\LIBA\AfInitSoc.pas',
  galOutil in '..\..\dp\LIB\galOutil.pas',
  UTOFYYIMPORTOBJET in '..\..\commun\lib\UTOFYYIMPORTOBJET.PAS',
  ImEnt in '..\..\compta\LIBI\ImEnt.pas',
  MajHalleyProc in '..\..\commun\lib\MajHalleyProc.pas',
  ImPlanInfo in '..\..\compta\LIBI\ImPlanInfo.pas',
  ImPlanMeth in '..\..\compta\LIBI\ImPlanMeth.pas',
  Outils in '..\..\compta\LIBI\Outils.pas',
  PlanAmor in '..\..\COMPTA\LIBI\PlanAmor.pas' {PlanAmortissement},
  ImEdCalc in '..\..\compta\LIBI\ImEdCalc.pas',
  ImContra in '..\..\compta\LIBI\ImContra.pas',
  planeche in '..\..\COMPTA\LIBI\planeche.pas' {FPlanEche},
  ImOutGen in '..\..\compta\LIBI\ImOutGen.pas',
  UTOMUTILISAT in '..\..\commun\lib\UTOMUTILISAT.PAS',
  UserGrp_tom in '..\..\commun\lib\UserGrp_tom.pas',
  ULibEcriture in '..\..\compta\LIBC\ULibEcriture.pas',
  ZCompte in '..\..\compta\LIBC\ZCompte.pas',
  TZ in '..\..\compta\LIBC\TZ.pas',
  ULibWindows in '..\..\compta\LIBC\ULibWindows.pas',
  TVAEtab in '..\..\COMPTA\LIB4\TVAEtab.pas' {FTvaEtab},
  SOUCHE_TOM in '..\..\compta\LIB4\SOUCHE_TOM.PAS',
  QRJDivis in '..\..\compta\LIBC\QRJDivis.pas' {QRJalDiv},
  Suprjal in '..\..\compta\LIBC\Suprjal.pas' {FSuprjal},
  Suprgene in '..\..\compta\LIBC\Suprgene.pas',
  Edtlegal in '..\..\COMPTA\LIBC\Edtlegal.pas' {FEdtLegal},
  Calcole in '..\..\compta\LIB4\Calcole.pas',
  UtilRessource in '..\LIBA\UtilRessource.pas',
  EntPGI in '..\..\commun\lib\EntPGI.pas',
  UtilGA in '..\LIBA\UtilGA.pas',
  DicoAf in '..\LIBA\DicoAf.pas',
  UtofExportConfidentialite in '..\..\prospect\lib\UtofExportConfidentialite.pas',
  Exercice_tom in '..\..\compta\libn\Exercice_tom.pas',
  Confidentialite_TOF in '..\..\commun\lib\Confidentialite_TOF.pas',
  MajSocParLot_TOF in '..\..\commun\lib\MajSocParLot_TOF.PAS',
  galFileTools in '..\..\cegidpgi\Lib\galFileTools.pas',
  wrapport in '..\..\commun\lib\wrapport.pas',
  wCommuns in '..\..\commun\lib\wCommuns.pas',
  AglInitCommun in '..\..\commun\lib\AglInitCommun.pas',
  ImportObjetLot_TOF in '..\..\commun\lib\ImportObjetLot_TOF.pas',
  MulJal in '..\..\compta\LIBC\MulJal.pas' {FMulJal},
  CPJOURNAL_TOM in '..\..\compta\Lib4\CPJOURNAL_TOM.pas',
  CPGENERAUX_TOM in '..\..\compta\Lib4\CPGENERAUX_TOM.PAS',
  CPSECTION_TOM in '..\..\compta\Lib4\CPSECTION_TOM.PAS',
  BANQUECP_TOM in '..\..\compta\LibN\BANQUECP_TOM.pas',
  CPCODEPOSTAL_TOF in '..\..\compta\LibN\CPCODEPOSTAL_TOF.PAS',
  UTOFGRILLEFILTRE in '..\..\compta\LibN\UTOFGRILLEFILTRE.PAS',
  CPREGION_TOF in '..\..\compta\LibN\CPREGION_TOF.PAS',
  CPTIERS_TOM in '..\..\compta\Lib4\CPTIERS_TOM.PAS',
  UtilEdt1 in '..\..\compta\LibC\utiledt1.pas',
  cummens in '..\..\COMPTA\LIBC\cummens.pas' {FCumMens},
  ULibExercice in '..\..\compta\LibC\ULibExercice.pas',
  LGCOMPTE_TOF in '..\..\compta\LibN\LGCOMPTE_TOF.PAS',
  CLgCpte in '..\..\compta\LibC\CLgCpte.pas',
  CORRESP_TOM in '..\..\compta\LibN\CORRESP_TOM.PAS',
  AmType in '..\..\compta\LibI\AmType.pas',
  UDossierSelect in '..\..\dp\Lib\UDossierSelect.pas',
  EntDP in '..\..\commun\lib\EntDP.pas',
  PwdDossier in '..\..\DP\LIB\PwdDossier.pas' {FPwdDossier},
  uLibStdCpta in '..\..\compta\libs\uLibStdCpta.pas',
  ImSaiCoef in '..\..\COMPTA\LIBI\ImSaiCoef.pas' {SaiCoefIm},
  ULibAnalytique in '..\..\compta\LibC\ULibAnalytique.pas',
  uRecupSQLModele in '..\..\commun\lib\uRecupSQLModele.pas',
  CPVENTILTYPECROIS_TOF in '..\..\compta\LibN\CPVENTILTYPECROIS_TOF.pas',
  trConstantes in '..\..\compta\Lib4\trConstantes.pas',
  Constantes in '..\..\treso\Lib\Constantes.pas',
  CPBALAUXIGEN_TOF in '..\..\compta\LibN\CPBALAUXIGEN_TOF.PAS',
  TofMeth in '..\..\compta\LibN\TofMeth.pas',
  CPBALANCECOMBI_TOF in '..\..\compta\LibN\CPBALANCECOMBI_TOF.PAS',
  UObjFiltres in '..\..\treso\Lib\UObjFiltres.pas',
  R_DE_RUB in '..\..\compta\LibN\R_DE_RUB.pas',
  XVISingleton in '..\..\compta\LibN\xvisingleton.pas',
  ZCumul in '..\..\compta\LibC\ZCumul.pas',
  galSystem in '..\..\cegidpgi\Lib\galSystem.pas',
  YYBUNDLE_TOF in '..\..\commun\lib\YYBUNDLE_TOF.PAS',
  EBizUtil in '..\LibEC\EBizUtil.pas',
  BackupRestore_TOF in '..\..\commun\lib\BackupRestore_TOF.pas',
  MajHalleyUtil in '..\..\commun\lib\MajHalleyUtil.pas',
  uTablesGed in '..\..\commun\lib\uTablesGed.pas',
  wJetons in '..\..\commun\lib\wJetons.pas',
  TiersUtil in '..\..\commun\lib\TiersUtil.pas',
  BundleDetail_TOF in '..\..\commun\lib\BundleDetail_TOF.pas',
  MajEnRafale in '..\..\commun\lib\MajEnRafale.PAS',
  ListUsersAutorises in '..\..\commun\lib\ListUsersAutorises.pas',
  AccesPortail_TOF in '..\..\commun\lib\AccesPortail_TOF.pas',
  Soussect in '..\..\COMPTA\LIBC\Soussect.pas' {FChoixSSec},
  Cloture in '..\..\COMPTA\LIBC\Cloture.pas' {FCloS},
  ParaClo in '..\..\COMPTA\LIBC\ParaClo.pas' {ParamClo},
  ULIBCLOTURE in '..\..\compta\LibN\ULIBCLOTURE.pas',
  galDossierCste in '..\..\DP\Lib\galDossierCste.pas',
  wParamFonction in '..\libw\WPARAMFONCTION.PAS',
  ULibIdentBancaire in '..\..\commun\Lib\ULibIdentBancaire.pas',
  UProcGen in '..\..\Treso\Lib\UProcGen.pas',
  EnvironnementUtil in '..\..\commun\Lib\EnvironnementUtil.pas',
  AGLInitGC in '..\Lib\AGLInitGC.pas',
  UTomArticle in '..\Lib\UTomArticle.pas',
  UDimArticle in '..\Lib\UDimArticle.pas',
  UtilArticle in '..\Lib\UtilArticle.pas',
  UtilTarif in '..\Lib\UtilTarif.pas',
  TimpFic in '..\..\compta\LibC\TImpFic.pas',
  ULibTrSynchro in '..\..\compta\LibN\ULibTrSynchro.pas',
  Commun in '..\..\Treso\Lib\Commun.pas',
  CPTypeCons in '..\..\compta\Lib4\CPTypeCons.pas',
  CPProcGen in '..\..\compta\Lib4\CPProcGen.pas',
  TarifUtil in '..\Lib\TarifUtil.pas',
  FactUtil in '..\Lib\FactUtil.pas',
  UtilGC in '..\Lib\UtilGC.pas',
  UtilDimArticle in '..\Lib\UtilDimArticle.pas',
  UtofMBOParamDim in '..\LibM\UtofMBOParamDim.pas',
  FactTOB in '..\Lib\FactTOB.pas',
  FactTarifs in '..\Lib\FactTarifs.pas',
  FactArticle in '..\Lib\FactArticle.pas',
  BTPUtil in '..\Libbtp\BTPUtil.pas',
  FactPiece in '..\Lib\FactPiece.pas',
  factligneBase in '..\LibBTP\factligneBase.pas',
  FactComm in '..\Lib\FactComm.pas',
  CalcOLEGescom in '..\Lib\CalcOLEGescom.pas',
  StockUtil in '..\Lib\StockUtil.pas',
  FactContreM in '..\Lib\FactContreM.pas',
  DepotUtil in '..\Lib\DepotUtil.pas',
  UTofPrixRevient in '..\Lib\UTofPrixRevient.pas',
  FactNomen in '..\Lib\FactNomen.pas',
  FactLotSerie in '..\Lib\FactLotSerie.pas',
  FactTiers in '..\Lib\FactTiers.pas',
  BTFactImprTOB in '..\LibBTP\BTFactImprTOB.pas',
  DicoBTP in '..\LibBTP\DicoBTP.pas',
  UtilMetres in '..\LibBTP\UtilMetres.pas',
  AffaireUtil in '..\LibA\affaireutil.pas',
  Echeance in '..\..\COMPTA\LIBC\Echeance.PAS' {FEcheance},
  FactVariante in '..\Lib\FactVariante.pas',
  NomenUtil in '..\Lib\NomenUtil.pas',
  FactCalc in '..\Lib\factcalc.pas',
  UTofPiedPort in '..\Lib\UTofPiedPort.pas',
  FactRg in '..\Lib\FactRg.pas',
  Factrgpbesoin in '..\LibBTP\Factrgpbesoin.pas',
  Facture in '..\Lib\Facture.pas' {FFacture},
  FactSpec in '..\Lib\FactSpec.pas',
  UtilFO in '..\Lib\UtilFO.pas',
  UtilChainage in '..\..\prospect\Lib\UtilChainage.pas',
  EntRT in '..\..\prospect\Lib\EntRT.pas',
  ctiAlerte in '..\..\commun\Lib\ctiAlerte.pas' {FCtiAlerte},
  ctiInterface in '..\..\commun\Lib\ctiInterface.pas',
  ctiConst in '..\..\commun\Lib\ctiConst.pas',
  UtilCtiAlerte in '..\..\commun\Lib\UtilCtiAlerte.pas',
  UTofTiersCti_Mul in '..\cti\UtofTiersCTI_Mul.pas',
  UTilSelection in '..\..\prospect\Lib\UtilSelection.pas',
  UtilRT in '..\..\prospect\Lib\UTILRT.PAS',
  KPMGUTIL in '..\..\prospect\Lib\KPMGUtil.PAS',
  UtilAction in '..\..\prospect\Lib\UtilAction.pas',
  YRESSOURCE in '..\..\commun\Lib\YRESSOURCE.PAS',
  wParam in '..\..\commun\Lib\WPARAM.PAS',
  YPlanning in '..\..\commun\Lib\YPLANNING.PAS',
  YPLANNING_TOM in '..\..\commun\Lib\YPLANNING_TOM.PAS',
  uTOMComm in '..\..\commun\Lib\uTOMComm.pas',
  YRESSOURCE_TOM in '..\..\commun\Lib\YRESSOURCE_TOM.PAS',
  UtofRess_Occup in '..\..\prospect\Lib\UTofRess_Occup.pas',
  Utomaction in '..\..\prospect\Lib\Utomaction.pas',
  UtilConfid in '..\Lib\UtilConfid.pas',
  UtilAlertes in '..\..\commun\Lib\UtilAlertes.pas',
  YAlertesConst in '..\..\commun\Lib\YAlertesConst.pas',
  YTABLEALERTES_TOM in '..\..\commun\Lib\YTABLEALERTES_TOM.pas',
  FactFormule in '..\Lib\FactFormule.pas',
  UTilFonctionCalcul in '..\Lib\UTilFonctionCalcul.pas',
  GcFonctionVar_Tof in '..\Lib\GcFonctionVar_Tof.pas',
  FactAdresse in '..\Lib\FactAdresse.pas',
  FGestAffDet in '..\LIB\FGestAffDet.pas' {FParamAffDet},
  FPrixMarche in '..\LIB\FPrixMarche.pas' {PrixMarche},
  FactBordereauMenu in '..\LibBTP\FactBordereauMenu.pas',
  CopierCollerUtil in '..\Lib\CopierCollerUtil.pas',
  FactEmplacementLivr in '..\LibBTP\FactEmplacementLivr.pas',
  UtofBTMemorisation in '..\Lib\UtofBTMemorisation.pas',
  FactCpta in '..\Lib\FactCpta.pas',
  TiersPayeur in '..\..\compta\LibC\TiersPayeur.pas',
  VentilCpta in '..\Lib\VentilCpta.pas',
  ECRPIECE_TOF in '..\..\commun\Lib\ECRPIECE_TOF.PAS',
  UtilInterCompta in '..\Lib\UtilInterCompta.pas',
  FactOuvrage in '..\LibBTP\FactOuvrage.pas',
  LigNomen in '..\LIB\LigNomen.pas' {FLigNomen},
  CasEmplois in '..\Lib\CasEmplois.pas' {FCasEmplois},
  NomenLig in '..\LIB\NomenLig.pas' {FNomenLig},
  NomenErr in '..\LIB\NomenErr.pas' {FNomenErr},
  FactTvaMilliem in '..\LibBTP\FactTvaMilliem.pas',
  AdressePiece in '..\LIB\AdressePiece.pas' {FAdrPiece},
  Ventana in '..\..\COMMUN\LIB\Ventana.pas' {FVentAna},
  CPSTRUCTURE_TOF in '..\..\compta\LibN\CPSTRUCTURE_TOF.PAS',
  UTofCegidPCI in '..\Lib\UTofCegidPCI.pas',
  UTofCegidLibreTiersCom in '..\Lib\UTofCegidLibreTiersCom.pas',
  GcComplPrix_tof in '..\Lib\GcComplPrix_tof.pas',
  SaisieSerie_TOF in '..\Lib\SaisieSerie_TOF.pas',
  DimUtil in '..\Lib\DimUtil.pas',
  InvUtil in '..\Lib\InvUtil.pas',
  UTofListeInv in '..\Lib\UTofListeInv.pas',
  UTofConsultStock in '..\Lib\UTofConsultStock.pas',
  LigDispolot in '..\LIB\LigDispolot.pas' {FLigDispolot},
  UTofGCPieceArtLie in '..\Lib\UTofGCPieceArtLie.pas',
  UTofSaisieAvanc in '..\Lib\UTofSaisieAvanc.pas',
  GCControleFacture_Tof in '..\Lib\GCControleFacture_Tof.pas',
  UtilGrp in '..\Lib\UtilGrp.pas',
  FactAffaire in '..\LibA\FactAffaire.pas',
  Tarifs in '..\Lib\Tarifs.PAS',
  ResulSuggestion in '..\LIB\ResulSuggestion.pas' {FResulSuggestion},
  CalculSuggestion in '..\Lib\CalculSuggestion.pas',
  SelectDocSuggestion in '..\Lib\SelectDocSuggestion.pas',
  UVOIRSUIVIPIECE in '..\Lib\uVoirSuiviPiece.pas',
  AppelMouvStkEx in '..\LibBTP\AppelMouvStkEx.pas',
  UTofMouvStkEx in '..\Lib\utofmouvStkEx.pas',
  UTofOptionEdit in '..\Lib\UTofOptionEdit.pas',
  UtilVariables in '..\LibBTP\UtilVariables.pas',
  FactUtilBTP in '..\LibBTP\FactUtilBTP.pas',
  UMetreArticle in '..\LibBTP\UMetreArticle.pas',
  FactTOBbtp in '..\LibBTP\FactTOBbtp.pas',
  UtilSuggestion in '..\LibBTP\UtilSuggestion.pas',
  FactCommBTP in '..\LibBTP\FactCommBTP.pas',
  CalcOLEGenericBTP in '..\LibBTP\CalcOLEGenericBTP.pas',
  TraducAffaire in '..\LibA\TraducAffaire.pas',
  ConfidentAffaire in '..\LibA\ConfidentAffaire.pas',
  AfUtilArticle in '..\LibA\AfUtilArticle.pas',
  AppelsUtil in '..\LibBTP\AppelsUtil.pas',
  UTofAfPiece in '..\LibA\UTofAfPiece.pas',
  UTOFBTANALDEV in '..\LibBTP\UTOFBtAnalDev.PAS',
  OptimizeOuv in '..\LibBTP\OptimizeOuv.pas',
  FactGrp in '..\Lib\FactGrp.pas',
  factAcompte in '..\LibBTP\factAcompte.pas',
  SimulRentabDoc in '..\LIBBTP\SimulRentabDoc.pas' {FSimulRentab},
  SimulRentabUtil in '..\LibBTP\SimulRentabUtil.pas',
  FactBordereau in '..\LibBTP\FactBordereau.pas',
  BTSELLIGBORD_TOF in '..\LibBTP\BTSELLIGBORD_TOF.pas',
  UtilFichiers in '..\LibBTP\UtilFichiers.pas',
  UTofBtSaisieVar in '..\LibBTP\UTofBtSaisieVar.pas',
  BTVARDOC_TOF in '..\LibBTP\BTVARDOC_TOF.pas',
  UAFO_Ressource in '..\LibA\UAFO_Ressource.pas',
  UAFO_Ferie in '..\LibA\UAFO_Ferie.pas',
  UTofAfBaseCodeAffaire in '..\LibA\UTofAfBaseCodeAffaire.pas',
  UTOFAFTRADUCCHAMPLIBRE in '..\LibA\UtofAfTRADUCCHAMPLIBRE.pas',
  uTOFComm in '..\..\commun\Lib\uTOFComm.PAS',
  uTreeTobFrame in '..\..\commun\Lib\uTreeTobFrame.pas' {FFrameTreeTob: TFrame},
  wTom in '..\libw\WTOM.PAS',
  AFPlanningCst in '..\LibA\AFPlanningCst.pas',
  UAFO_REGLES in '..\LibA\UAFO_REGLES.pas',
  UtilTaches in '..\LibA\UtilTaches.pas',
  UAFO_Affaire in '..\LibA\UAFO_Affaire.pas',
  UtilPhases in '..\LibBTP\UtilPhases.pas',
  UtilConso in '..\LibBTP\UtilConso.pas',
  UPlannifchUtil in '..\LibBTP\UPlannifchUtil.pas',
  UTofGCDatePiece in '..\Lib\UTofGCDatePiece.pas',
  AffaireCpta in '..\LibA\AffaireCpta.pas',
  EtudesUtil in '..\LibBTP\EtudesUtil.pas',
  EtudesExt in '..\LibBTP\EtudesExt.pas',
  UtilXlsBTP in '..\LibBTP\utilxlsBTP.pas',
  EtudesStruct in '..\LIBBTP\EtudesStruct.pas' {FEtudesStruct},
  EtudePiece in '..\LibBTP\EtudePiece.pas',
  FactAdresseBTP in '..\LibBTP\FactAdresseBTP.pas',
  FactureBtp in '..\LibBTP\FactureBtp.pas',
  FactMinute in '..\LibBTP\FactMinute.pas',
  UTOF_BTREACPRDOC in '..\LibBTP\UTOF_BTREACPRDOC.pas',
  UTOF_BTSAISDOCEXT in '..\LibBTP\UTOF_BTSAISDOCEXT.pas',
  UtilBlocage in '..\LibBTP\UtilBlocage.pas',
  FactActivite in '..\LibA\FactActivite.pas',
  ActiviteUtil in '..\LibA\activiteutil.pas',
  UTofAFTiers_Rech in '..\LibA\UtofafTiers_Rech.pas',
  UTofAFTiers_Mul in '..\LibA\UTofAFTiers_Mul.pas',
  UTofAFArticle_Mul in '..\LibA\UTofAFArticle_Mul.pas',
  GereTobInterne in '..\LibA\GereTobInterne.pas',
  UtofRessource_Mul in '..\LibA\UtofRessource_Mul.pas',
  UTofArticles_Aff in '..\LibA\UTofArticles_Aff.pas',
  UtofAfRevision in '..\LibA\utofafrevision.pas',
  uTofAfRevFormuleEdit in '..\LibA\uTofAfRevFormuleEdit.pas',
  UtilRevFormule in '..\LibA\UtilRevFormule.pas',
  UAFO_REVPRIXCALCULCOEF in '..\LibA\UAFO_REVPRIXCALCULCOEF.pas',
  UtilRevision in '..\LibA\UtilRevision.pas',
  FactLivrFromRecep in '..\LibBTP\FactLivrFromRecep.pas',
  BTREPARTTVA_TOF in '..\LibBTP\BTREPARTTVA_TOF.pas',
  UtilReglementAffaire in '..\LibBTP\UtilReglementAffaire.pas',
  UtilDuplicBordereaux in '..\LibBTP\UtilDuplicBordereaux.pas',
  FactGestParag in '..\LibBTP\FactGestParag.pas',
  GestRemplArticle in '..\LibBTP\GestRemplArticle.pas',
  BTFACTTEXTES in '..\LibBTP\BTFACTTEXTES.pas',
  BTAPPLICDETAILOUV_TOF in '..\LibBTP\BTAPPLICDETAILOUV_TOF.pas',
  PiecesRecalculs in '..\LibBTP\PiecesRecalculs.pas',
  BTRECALCPIECEUNI in '..\LibBTP\BTRECALCPIECEUNI.pas',
  BTPrepaLivr in '..\LibBTP\BTPrepaLivr.pas',
  factgrpBtp in '..\LibBTP\factgrpBtp.pas',
  UtilGrpBtp in '..\LibBTP\UtilGrpBtp.pas',
  Splash in '..\LIBBTP\Splash.pas' {FsplashScreen},
  UtilSaisieConso in '..\LibBTP\UtilSaisieConso.pas',
  UTOFMBOVALIDEMODELE in '..\LibM\UTOFMBOVALIDEMODELE.PAS',
  CalcOLEAffaire in '..\LibA\CalcOLEAffaire.pas',
  SyntheseUtil in '..\LibA\SyntheseUtil.pas',
  TarifCliArt in '..\LIB\TarifCliArt.pas' {FTarifCliArt},
  TarifRapide in '..\LIB\TarifRapide.pas' {FTarifRapide},
  TarifCond in '..\LIB\TarifCond.pas' {FTarifCond},
  ARTPHOTO_TOF in '..\LibM\ARTPHOTO_TOF.pas',
  UtilDispGC in '..\Lib\UtilDispGC.pas',
  UtomLiensOle in '..\..\commun\Lib\UtomLiensOle.pas',
  uYFILESTD2 in '..\..\ImportDP\lib\uYFILESTD2.pas',
  UtilOracle in '..\..\commun\Lib\UtilOracle.pas',
  DEVISE_TOM in '..\..\compta\LibN\DEVISE_TOM.pas',
  CPCHANCELL_TOF in '..\..\compta\LibN\CPCHANCELL_TOF.pas',
  PgDADSCommun in '..\..\paie\lib\PgDADSCommun.pas',
  CPAXE_TOM in '..\..\compta\LibN\CPAXE_TOM.PAS',
  uLibRevision in '..\..\compta\LibN\uLibRevision.pas',
  BalSit in '..\..\compta\LibN\BalSit.pas',
  uLibCalcEdtCompta in '..\..\compta\LibN\uLibCalcEdtCompta.pas',
  UTomEtabliss in '..\..\commun\Lib\UTomEtabliss.pas',
  EventDecla in '..\..\commun\Lib\EventDecla.pas',
  UTOMBanque in '..\..\commun\Lib\UTOMBanque.pas',
  TomAgence in '..\..\Treso\Lib\TomAgence.pas',
  TomCalendrier in '..\..\Treso\Lib\TomCalendrier.pas',
  UTOFMULPARAMGEN in '..\..\compta\LibS\UTOFMULPARAMGEN.pas',
  BTStructChampSup in '..\LibBTP\BTStructChampSup.pas',
  BTINFOLIVRAISONS_TOF in '..\LibBTP\BTINFOLIVRAISONS_TOF.PAS',
  UTOF_VideInside in '..\LIBBTP\UTOF_VideInside.pas',
  NewCalendar in '..\libbtp\NewCalendar.pas',
  SelectPhase in '..\LIBBTP\SelectPhase.pas',
  BTSelectDate in '..\LIBBTP\BTSelectDate.pas' {FselectDate},
  BTMODELHEBDO_TOF in '..\LIBBTP\BTMODELHEBDO_TOF.pas',
  UtilModeleConso in '..\LIBBTP\UtilModeleConso.pas',
  RegenereConso_TOF in '..\LIBBTP\RegenereConso_TOF.pas',
  SaisieConsommations in '..\LIBBTP\SaisieConsommations.pas',
  BTTVA_TOF in '..\LibBTP\BTTVA_TOF.PAS',
  BTMajStruct in '..\LIBBTP\BTMajStruct.pas',
  uEntCommun in '..\..\commun\Lib\uEntCommun.pas',
  UtilchampsSup in '..\LibBTP\UtilchampsSup.pas',
  UtilTOBPiece in '..\LibBTP\UtilTOBPiece.pas',
  UtilBTPgestChantier in '..\..\extensionCBP\UtilBTPgestChantier.pas',
  UmetresUtil in '..\..\extensionCBP\UmetresUtil.pas',
  uBTPVerrouilleDossier in '..\..\extensionCBP\uBTPVerrouilleDossier.pas',
  BTPGetVersions in '..\..\extensionCBP\BTPGetVersions.pas',
  ChangeVersions in '..\LIBBTP\ChangeVersions.pas' {FMajVerBtp},
  factdomaines in '..\LibBTP\factdomaines.pas',
  ControlIniFile in '..\LibBTP\ControlIniFile.pas',
  UImportLigneExcelFac in '..\LibBTP\UImportLigneExcelFac.pas',
  UCalculsMetre in '..\LibBTP\UCalculsMetre.pas',
  BTESTFORMULE_TOF in '..\LibBTP\BTESTFORMULE_TOF.PAS',
  BTSAISIEPAGEMETRE_TOF in '..\LibBTP\BTSAISIEPAGEMETRE_TOF.PAS',
  UtofBTChangeCodeArt in '..\LIBBTP\UtofBTChangeCodeArt.pas',
  UImportLigneNomen in '..\LibBTP\UImportLigneNomen.pas',
  UdateUtils in '..\LibBTP\UdateUtils.pas',
  BTMINUTEDEV_TOF in '..\LibBTP\BTMINUTEDEV_TOF.PAS',
  RegenEcheCon in '..\LibBTP\RegenEcheCon.pas' {FREGENECHECON},
  UCotraitanceOuv in '..\LibCotraitance\UCotraitanceOuv.pas',
  UCotraitance in '..\LibCotraitance\UCotraitance.pas',
  FactDetouvrage in '..\LibBTP\FactDetouvrage.pas',
  galPatience in '..\..\Cegidpgi\Lib\galPatience.pas' {FPatience},
  UtilOutils in '..\..\commun\Lib\UtilOutils.pas',
  CPOBJITRTPARAM in '..\..\compta\LibN\CPOBJITRTPARAM.PAS',
  CPOBJBANQUESH in '..\..\compta\LibN\CPOBJBANQUESH.PAS',
  CPProcBanqueAuxiliaire in '..\..\compta\Lib4\CPProcBanqueAuxiliaire.pas',
  UtilCbp in '..\..\commun\Lib\UtilCbp.pas',
  uInitBanque in '..\..\compta\LibN\uInitBanque.pas',
  DpJurOutilsBlob in '..\..\DP\Lib\DpJurOutilsBlob.pas',
  UBTPSequenceCpta in '..\..\compta\Lib4\UBTPSequenceCpta.pas',
  BobGestion in '..\..\commun\Lib\BobGestion.pas',
  uBobUtiles in '..\..\commun\Lib\uBobUtiles.pas',
  Udefexport in '..\LibCotraitance\Udefexport.pas',
  UtilsRapport in '..\..\CommunBTP\LIB\UtilsRapport.pas',
  BTPARAMMAIL_TOF in '..\LibCotraitance\BTPARAMMAIL_TOF.pas',
  FactTimbres in '..\LibBTP\FactTimbres.pas',
  TIMBRESPARAM_TOM in '..\LibBTP\TIMBRESPARAM_TOM.PAS',
  BTIMBRESPMUL_TOF in '..\LibBTP\BTIMBRESPMUL_TOF.PAS',
  BTSpigao in '..\LibBTP\BTSpigao.pas',
  GerePiece in '..\LIB\GerePiece.pas',
  Edisys_IULM_Core_TLB in '..\..\SPIGAO\Edisys_IULM_Core_TLB.pas',
  Edisys_IULM_Updater_TLB in '..\..\SPIGAO\Edisys_IULM_Updater_TLB.pas',
  mscorlib_TLB in '..\..\SPIGAO\mscorlib_TLB.pas',
  Edisys_IULM_Alert_TLB in '..\..\SPIGAO\Edisys_IULM_Alert_TLB.pas',
  Edisys_IULM_AXViewer_TLB in '..\..\SPIGAO\Edisys_IULM_AXViewer_TLB.pas',
  System_TLB in '..\..\SPIGAO\System_TLB.pas',
  System_Windows_Forms_TLB in '..\..\SPIGAO\System_Windows_Forms_TLB.pas',
  Accessibility_TLB in '..\..\SPIGAO\Accessibility_TLB.pas',
  uBTPGetDocument in '..\..\ExtensionCBP\uBTPGetDocument.pas',
  UtilBordereau in '..\..\ExtensionCBP\UtilBordereau.pas',
  uPGFnWorkRh in '..\..\paie\lib\uPGFnWorkRh.pas',
  FactRemplTypeLigne in '..\LibBTP\FactRemplTypeLigne.pas',
  UFactgestionAff in '..\LibBTP\UFactgestionAff.pas',
  UDemandeprix in '..\LibBTP\UDemandeprix.pas',
  DialogEx in '..\LibCotraitance\DialogEx.pas',
  UtilPlannifchantier in '..\LIBBTP\UtilPlannifchantier.pas',
  UfactExportXLS in '..\LibCotraitance\UfactExportXLS.pas',
  UExportPiece in '..\LibCotraitance\UExportPiece.pas',
  UtilsMail in '..\LibCotraitance\UtilsMail.pas',
  UtilsContacts in '..\LibCotraitance\UtilsContacts.pas',
  UtilAppelFiche in '..\LibBTP\UtilAppelFiche.pas',
  BTCONFIRMPASS_TOF in '..\LibBTP\BTCONFIRMPASS_TOF.PAS',
  UAuditPerf in '..\..\CommunBTP\LIB\UAuditPerf.pas',
  BTCLOTUREEX_TOF in '..\LIBBTP\BTCLOTUREEX_TOF.pas',
  AssistParamSocBtp in '..\LIBBTP\AssistParamSocBtp.pas' {FassistParamSoc},
  UtilLine in '..\LibBTP\UtilLine.pas',
  SplashS1 in '..\LibBTP\SplashS1.pas' {Splash_S1},
  RestaureS1 in '..\LibBTP\RestaureS1.pas' {Restaure_S1},
  UtilActionComSx in '..\LIBBTP\UtilActionComSx.pas',
  UApplication in '..\LibBTP\UApplication.pas',
  MsgUtil in '..\LIBBTP\MsgUtil.pas',
  HeureUtil in '..\liba\HeureUtil.pas',
  PlanUtil in '..\LIBBTP\PlanUtil.pas',
  uBtpEtatPlanning in '..\LibBTP\uBtpEtatPlanning.pas',
  URegenVues in '..\LibBTP\URegenVues.pas',
  BTGENODANAL_TOF in '..\..\LibODANAL\BTGENODANAL_TOF.PAS',
  UtilsTOB in '..\..\CommunBTP\LIB\UtilsTOB.pas',
  BTCONSULTODANAL_TOF in '..\..\LibODANAL\BTCONSULTODANAL_TOF.PAS',
  UMenusNeg in '..\LigNegoce\UMenusNeg.pas',
  BTREFUS_TOF in '..\LibBTP\BTREFUS_TOF.PAS',
  BTSELFACNEG_MUL_TOF in '..\LigNegoce\BTSELFACNEG_MUL_TOF.PAS',
  UtilLivraisonNEG in '..\LigNegoce\UtilLivraisonNEG.pas',
  BTPIECETIERS_MUL_TOF in '..\LigNegoce\BTPIECETIERS_MUL_TOF.PAS',
  ULiquidTva2014 in '..\LibBTP\ULiquidTva2014.pas',
  Edisys_IULM_CoreEvents in '..\..\SPIGAO\EVENTS\Edisys_IULM_CoreEvents.pas',
  PGInitRemDSN in '..\..\paie\lib\PGInitRemDSN.pas',
  BTRechargeFamTarif in '..\LibBTP\BTRechargeFamTarif.pas',
  BTFACTREVISION_TOF in '..\LibBTP\BTFACTREVISION_TOF.PAS';

{$R *.RES}

begin
  Application.Initialize;
  InitAgl;
  Application.Title := 'Maj Structure CEGID';
  Application.CreateForm(TFMenuG, FMenuG);
  InitApplication ;
  SplashScreen:=NIL  ;
  if paramcount=0 then
  BEGIN
    SplashScreen := TSplashScreen.Create(Nil) ;
    SplashScreen.Show ;
    SplashScreen.Update ;
  END ;
  Application.Run;
end.
