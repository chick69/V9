unit AGLInitBtp;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Hctrls, ExtCtrls, HTB97, StdCtrls, HPanel, UIUtil, Hent1, Menus,
  HSysMenu, Mask, Buttons,
  {$IFNDEF EAGLCLIENT}
  Db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  DBCtrls,Hdb,Mul,fe_main,edtRetat,
  {$ELSE}
  eMul,MainEagl,HQry,UtilEagl,
  {$ENDIF}
  HStatus, hmsgbox,UTOF, UtilPGI, UTOM,
  UTOB, HFLabel, Ent1, SaisUtil, LookUp, Math, FactUtil, EntGC,FactSpec,
  FactCalc, StockUtil,M3FP,  AglInit, FactComm, FactCpta, Facture,
  AdressePiece, Clipbrd, AffaireUtil, ComCtrls, HRichEdt, HRichOLE,
  FactNomen, VentAna, SaisComm, Doc_Parser, LigNomen,
  DimUtil, LigDispoLot, UTofGCPieceArtLie,ShellAPI, DicoBTP, FactGrp,
  BTPUtil, Etudes,EtudesUtil,UtilArticle,UtofBTChangeCodeArt,ParamSoc,FactAcompte,FactRg,
  UTOFBTClotureDev,BTPLANNIFCH_TOF,FactOuvrage,UPlannifchUtil,FactTOB,BTGENCONTRETU_TOF,
  Utof_VideInside
	,FactTvaMilliem,uEntCommun
  ;

const
	// libell�s des messages
	TexteMessage: array[1..11] of string 	= (
          {1}        'Confirmez-vous l''acceptation des devis s�lectionn�s ?'
          {2}       ,'Confirmez-vous le refus des devis s�lectionn�s ?'
          {3}       ,'Confirmez-vous la r�activation des devis s�lectionn�s ?'
          {4}       ,'Confirmez-vous la facturation des devis s�lectionn�s ? '
          {5}       ,' sur l''affaire '
          {6}       ,'Le transfert des lignes d''activit� a �chou�, voulez-vous annuler le refus ?'
          {7}       ,'Confirmez-vous l''acceptation des appels d''offre s�lectionn�s?'
          {8}       ,'Confirmez-vous le changement de codification des articles s�lectionn�s ?'
          {9}       ,'Confirmez-vous le traitement de cl�ture des chantiers s�lectionn�s ?'
          {10}      ,'Confirmez-vous la validation des �tudes s�lectionn�es ?'
          {11}      ,'Confirmez-vous l''annulation de l''acceptation des devis s�lectionn�s ?'
                       );

type TAcceptationDocument = class
     public
     TOBPiece,TOBTiers,TOBAcomptes,TOBAcomptes_O : TOB;
     TobPieceRG,TOBBasesRg : TOB;
     QQ : Tquery;
     cledoc : R_Cledoc;
     Sql : string;
     NaturePiece,Souche,Tiers : string ;
     Numero,Indice: integer;
     Result : boolean;
     pass : boolean;
     private
     procedure LibereTOBS;
     procedure CreateTobs;
    procedure ValideLaPieceAcompte;
     public
     destructor Destroy; override;
     constructor Create;
     Procedure ChargeLesTObs;
     Procedure DemandeAcompte;
     procedure GereReglements;
     end;

procedure AglPlannificationChantier (Parms : array of variant ; nb : integer) ;
procedure AglGenereContreEtude (Parms : array of variant ; nb : integer) ;
Function AGLCreerPieceBTP( parms: array of variant; nb: integer ): variant;


     procedure SaisieAvancementChantier (NaturePiece, Datepiece, Souche, Tiers, AffaireRef : String; NumeroPiece, Indice : integer; Action : TActionFiche ) ;
		 Procedure DecisionStockReappro;

		 Function DemandeAcompteOk (NaturePiece,Souche,Tiers : string ; Numero,Indice: integer; pass : boolean=false): boolean;
			procedure AglAvancementChantier (Parms : array of variant ; nb : integer) ;

implementation
uses factvariante,
     BTPrepaLivr,
     facturebtp,
     FactCommBtp,
     PiecesRecalculs,
     UtilSoc,
     UtilTOBPiece;

Procedure PositionneEtatAffaire(CodeAffaire, CodeEtat : String);
begin
	ExecuteSQL('UPDATE AFFAIRE SET AFF_ETATAFFAIRE="' + CodeEtat +'" WHERE AFF_AFFAIRE="' + CodeAffaire +'"');
end;

function PositionnePieceMorteVivante (naturepiece,souche : string ;numero,indice: integer;etat:string;var EtatPrec:string):boolean;
var QQ: Tquery;
    Sql : string;
begin
sql := 'SELECT GP_VIVANTE FROM PIECE WHERE GP_NATUREPIECEG="'+naturepiece+'" AND'
     + ' GP_SOUCHE="'+souche+'" AND '
     + ' GP_NUMERO='+inttostr(numero)+' AND GP_INDICEG='+inttostr(indice);
QQ := OpenSql (sql,true,-1,'',true);
if QQ.eof then BEGIN result := false; ferme (QQ); Exit; END;
EtatPrec := QQ.findfield('GP_VIVANTE').AsString;
ferme (QQ);
sql := 'UPDATE PIECE SET GP_VIVANTE="'+Etat+'" WHERE GP_NATUREPIECEG="'+naturepiece+'" AND'
     + ' GP_SOUCHE="'+souche+'" AND '
     + ' GP_NUMERO='+inttostr(numero)+' AND GP_INDICEG='+inttostr(indice);
result:=(ExecuteSql(Sql)>0);
sql := 'UPDATE LIGNE SET GL_VIVANTE="'+Etat+'" WHERE GL_NATUREPIECEG="'+naturepiece+'" AND'
     + ' GL_SOUCHE="'+souche+'" AND '
     + ' GL_NUMERO='+inttostr(numero)+' AND GL_INDICEG='+inttostr(indice);
result:=(ExecuteSql(Sql)>0);
end;

Procedure AGLChangeCodeArticle ( parms: array of variant; nb: integer );
var F : TForm;
    CodeArticle,NewCode,TypeArticle,Prefixe,Libelle : string;
    i,lng : integer;
    Q : Tquery;
begin
F:=TForm(Longint(Parms[0]));
if (TFMul(F).FListe=nil) then exit;
if (PGIAskAF (TexteMessage[8], F.Caption)<>mrYes) then exit;
if TFMul(F).Fliste.AllSelected then
  BEGIN
  Q:=TFMul(F).Q;
  Q.First;
  while Not Q.EOF do
     BEGIN
     CodeArticle:=Q.FindField('GA_CODEARTICLE').AsString;
     Libelle:=Q.FindField('GA_LIBELLE').AsString;
     TypeArticle:=Q.FindField('GA_TYPEARTICLE').AsString;
     if Parms[1] = 'PREFIX' then
        begin
        if TYPEARTICLE = 'MAR' then prefixe := trim(GetParamsoc('SO_GCPREFIXEART'))
        else if (TYPEARTICLE = 'PRE') or (TYPEARTICLE = 'CTR') then prefixe := trim(GetParamsoc('SO_GCPREFIXEPRE'))
        else if (TYPEARTICLE = 'NOM') or (TYPEARTICLE = 'OUV') then prefixe := trim(GetParamsoc('SO_GCPREFIXENOM'))
        else continue; // pas de prefixe donc suivant s'il vous plait...
        // Controle prefixe Existant
        if copy(CodeArticle,1,length(prefixe))=Prefixe then continue; // pas besoin de traiter ceux qui l'ont deja
        lng := GetParamsoc('SO_GCLGNUMART');
        newCode := copy (Prefixe+CodeArticle,1,lng);
        end
     else if Parms[1] = 'CHGCODE' then
        begin
        if TYPEARTICLE = 'MAR' then prefixe := trim(GetParamsoc('SO_GCPREFIXEART'))
        else if (TYPEARTICLE = 'PRE') or (TYPEARTICLE = 'CTR') then prefixe := trim(GetParamsoc('SO_GCPREFIXEPRE'))
        else if (TYPEARTICLE = 'NOM') or (TYPEARTICLE = 'OUV') then prefixe := trim(GetParamsoc('SO_GCPREFIXENOM'))
        else prefixe := '';
        if not SaisieNewCodeArt (prefixe,TypeArticle,CodeArticle,Libelle,NewCode) then continue;
        end;
     ChangeCodificationArticle(CodeArticle,newCode);
     Q.NEXT;
     END;
  TFMul(F).Fliste.AllSelected:=False;
  END ELSE
  BEGIN
  for i:=0 to TFMul(F).Fliste.nbSelected-1 do
      begin
      TFMul(F).Fliste.GotoLeBookmark(i);
      CodeArticle:=TFMul(F).Fliste.datasource.dataset.FindField('GA_CODEARTICLE').AsString;
      Libelle:=TFMul(F).Fliste.datasource.dataset.FindField('GA_LIBELLE').AsString;
      TypeArticle:=TFMul(F).Fliste.datasource.dataset.FindField('GA_TYPEARTICLE').AsString;
      if Parms[1] = 'PREFIX' then
         begin
      // Controle prefixe Existant
         if TYPEARTICLE = 'MAR' then prefixe := trim(GetParamsoc('SO_GCPREFIXEART'))
         else if (TYPEARTICLE = 'PRE') or (TYPEARTICLE = 'CTR') then prefixe := trim(GetParamsoc('SO_GCPREFIXEPRE'))
         else if (TYPEARTICLE = 'NOM') or (TYPEARTICLE = 'OUV') then prefixe := trim(GetParamsoc('SO_GCPREFIXENOM'))
         else continue; // pas de prefixe donc suivant s'il vous plait...
         if copy(CodeArticle,1,length(prefixe))=Prefixe then continue; // pas besoin de traiter ceux qui l'ont deja
         lng := GetParamsoc('SO_GCLGNUMART');
         newCode := copy (Prefixe+CodeArticle,1,lng);
         end else if Parms[1] = 'CHGCODE' then
             begin
             if TYPEARTICLE = 'MAR' then prefixe := trim(GetParamsoc('SO_GCPREFIXEART'))
             else if (TYPEARTICLE = 'PRE') or (TYPEARTICLE = 'CTR') then prefixe := trim(GetParamsoc('SO_GCPREFIXEPRE'))
             else if (TYPEARTICLE = 'NOM') or (TYPEARTICLE = 'OUV') then prefixe := trim(GetParamsoc('SO_GCPREFIXENOM'))
             else Prefixe := '';
             if not SaisieNewCodeArt (prefixe,TypeArticle,CodeArticle,Libelle,NewCode) then continue;
             end;
      ChangeCodificationArticle(CodeArticle,newCode);
      end;
  END;
end;

function AGLIsMasterOnShared (parms : array of variant; nb : integer) : variant;
begin
  result := IsMasterOnShare(Parms[0]);
end;

Function AGLCreerPieceBTP( parms: array of variant; nb: integer ): variant;
Var CleDocAffaire : R_CLEDOC;
    Nbpiece : Integer;
    EnPa : boolean;
    StatutAffaire : String;
begin
// param�tres :
// Parms[0] : Client
// Parms[1] : Affaire
// Parms[2] : Nature de pi�ce
// Parms[3] : si avenant = Code affairedevis du devis de base sinon = 00
// Parms[4] : mode de traitement
// Parms[5] : Type d'affaire (A,W,I)

	FillChar(CleDocAffaire,Sizeof(CleDocAffaire),#0) ;
	CleDocAffaire.NaturePiece:=Parms[2];
	CleDocAffaire.DatePiece:=V_PGI.DateEntree;
	enPa := false;

  StatutAffaire := Parms[5];
//
	if Pos (CledocAffaire.NaturePiece,'PBT;CBT;LBT;')  >0 then EnPa := true;
//
	if (Parms[1] = '') Or (Parms[4] = 'CRE') then
  	 NbPiece := -1
	else
  	 NbPiece := SelectPieceAffaire(Parms[1], 'AFF', CleDocAffaire);
//
  if (NbPiece > 0) then
  	 begin
  	 SaisiePiece(CleDocAffaire, taModif,Parms[0], Parms[1], Parms[3],false,false,false,EnPa,False, StatutAffaire);
  	 end
  else if (Parms[3] = '') or (Parms[1] <> '') then
  	 begin
  	 SaisiePiece(CleDocAffaire, taCreat,Parms[0], Parms[1], Parms[3],false,false,false,EnPa,False, StatutAffaire);
  	 end;

end;

Function DemandeAcompteOk (NaturePiece,Souche,Tiers : string ; Numero,Indice: integer; pass : boolean=false): boolean;
var XX : TAcceptationDocument;
begin
XX := TAcceptationDocument.create;
XX.naturePiece := NaturePiece;
XX.Souche := Souche;
XX.numero := numero;
XX.Indice := Indice;
XX.Tiers := Tiers;
XX.ChargeLesTobs;
//
XX.DemandeAcompte;
result := XX.result;
//
XX.free;
end;

Procedure PrepaAcceptationDevis(Codessaff, AffaireRef, naturepiece, souche:string; numero, indice:integer; Tiers:string; TOBAff :TOB;DemandeAcompte : boolean; AnnulAcceptation : boolean);
var
TOBTiers,TOBPiece:TOB;
Sql,etatprec:string;
QQ,Q1 : TQuery ;
RefPiece,REq : string;
CleDocAffaire : R_CLEDOC;
Begin
	if not AnnulAcceptation then
  begin
    if (Copy(Codessaff,16,2) <> '00') then
      begin
      // si avenant, contr�le que le devis initial est accept�
      QQ:=OpenSQL('SELECT AFF_ETATAFFAIRE FROM AFFAIRE WHERE AFF_AFFAIRE="'+Copy(Codessaff,1,15)+'00"',TRUE,-1,'',true) ;
      if Not QQ.EOF then
        begin
        if (QQ.Fields[0].AsString <> 'ACP') AND (QQ.Fields[0].AsString <> 'TER') then
          begin
          PGIInfoAF ('Acceptation de l''avenant impossible car le devis initial n''est pas accept�.','Acceptation de devis');
          Ferme(QQ) ;
          exit;
          end;
        end;
     Ferme(QQ) ;
     end;
     if DemandeAcompte then
        BEGIN
        if not DemandeAcompteOk (NaturePiece,Souche,Tiers,Numero,Indice) then
           begin
           PGIInfoAF ('Acceptation impossible : Pas d''acompte d�fini.','Acceptation de devis');
           Exit;
           end;
        END;
     // Ajout contr�le si un devis accept� par affaire selon param�tre soci�t�
     if (GetParamSocSecur('SO_BTUNDEVISPARAFFAIRE',False)) and
        (SelectPieceAffaire(AffaireRef, 'AFF', CleDocAffaire, True) > 0) then
     begin
        PgiInfo(TraduireMemoire('Saisie impossible, un devis a d�j� �t� accept� pour cette affaire.'));
        Exit;
     end;
  //   Modif brl 24/03 :
  //   if not PositionnePieceMorteVivante (naturepiece,souche,numero,indice,'-',etatprec) then exit;
     TOBTiers := TOB.create ('TIERS',nil,-1);
     QQ := opensql('SELECT * FROM TIERS WHERE T_TIERS="'+Tiers+'"',true,-1,'',true);
     TOBTIers.selectdb ('',QQ);
     ferme (QQ);
     if (TobTiers.GetValue('T_NATUREAUXI')='PRO') then
     begin
  //   if GetInfoParPiece(naturepiece,'GPP_PROCLI') = 'X' then
         begin
         // transformer le tiers de PRO en CLI
         TobTiers.putValue('T_NATUREAUXI','CLI');
         TOBTiers.SetAllModifie (true);
         TOBTiers.UpdateDB;
         end;
     end;
     TOBTiers.Free;

     // Lecture de l'affaire
     TOBAff.InitValeurs ;
     TOBAff.SelectDB('"'+Codessaff+'"',Nil) ;
     // Modif sur la fiche affaire du devis accept�
     TOBAff.PutValue('AFF_ETATAFFAIRE', 'ACP');
     TOBAff.PutValue('AFF_DATESIGNE', V_PGI.DateEntree);

     TOBAff.UpdateDB(false);

     //maj fiche affaire reference
     Sql := 'UPDATE AFFAIRE SET AFF_ETATAFFAIRE = "ACP" WHERE AFF_AFFAIRE='+'"'+AffaireRef+'"';
     ExecuteSQL(Sql);
  end else
  begin
   TOBPiece := TOB.Create ('PIECE',nil,-1);
   QQ := OpenSql ('SELECT * FROM PIECE WHERE GP_NATUREPIECEG="'+naturepiece+'" AND GP_SOUCHE="'+souche+'" AND '+
   								'GP_NUMERO='+InttoStr(numero)+' AND GP_INDICEG='+IntToStr(indice),true,-1,'',true);
   if not QQ.eof then
   begin
   	TOBPiece.selectDb ('',QQ);
    RefPiece := EncodeRefPiece (TOBPiece,0,false);
    RefPiece := Copy(RefPiece,1,length(RefPiece)-1); // pour enlever le ; de fin
    Req := 'SELECT DISTINCT GL_NUMERO FROM LIGNE WHERE GL_NATUREPIECEG IN ("FBT","DAC","ABT") AND GL_PIECEPRECEDENTE LIKE "'+
           RefPiece+'%"';
    Q1 := OpenSql (Req,True,-1,'',true);
    if not Q1.eof then
    begin
      TOBPiece.free;
      ferme (Q1);
      ferme(QQ);
      PgiBox (TraduireMemoire('Impossible : Une Facture existe'),'Annulation de l''acceptation de devis');
      exit;
    end else
    begin
    	ferme (Q1);
    end;
   end else
   begin
   	TOBPiece.free;
   end;
   ferme(QQ);

   TOBAff.InitValeurs ;
   TOBAff.SelectDB('"'+Codessaff+'"',Nil) ;
   if TOBAff.GetValue('AFF_PREPARE')='X' then
   begin
   	PGIInfoAF ('Impossible : Document d�j� transform�','Annulation de l''acceptation de devis');
    Exit;
   end;
   // Modif sur la fiche affaire du devis accept�
   TOBAff.PutValue('AFF_ETATAFFAIRE', 'ENC');
   TOBAff.PutValue('AFF_DATESIGNE', iDate1900 );

   TOBAff.UpdateDB(false);

  end;
End;

Procedure PrepaAcceptationEtude(Codessaff, naturepiece, souche:string; numero, indice:integer; TOBAff,TobPieces :TOB);
var
TobPiece:TOB;
Sql:string;
Begin

// Lecture de l'affaire
TOBAff.InitValeurs ;
TOBAff.SelectDB('"'+Codessaff+'"',Nil) ;
// Modif sur la fiche affaire de l'�tude accept�e
if NaturePiece = 'DAP' then
TOBAff.PutValue('AFF_ETATAFFAIRE', 'ACA')
else
TOBAff.PutValue('AFF_ETATAFFAIRE', 'ACP');
TOBAff.PutValue('AFF_DATESIGNE', V_PGI.DateEntree);

TOBAff.UpdateDB(false);

// Remplissage de la TOB contenant les pieces selectionn�es
TobPiece := Tob.Create ('PIECE', TobPieces,-1);
Sql := '"'+ NaturePiece
       + '";"'+ Souche
       + '";"'+ inttostr(Numero)
       + '";"'+ inttostr(Indice) + '"';

TobPiece.selectDB (sql, Nil, False);
End;

Procedure DecisionStockReappro;
var TOBDate : TOB;
    DateFin : TdateTime;
    StWhere : String;
begin
(*
  DateFin := 0;
  TOBDate := TOB.Create ('The Date',nil,-1);
  TOBDate.AddChampSupValeur ('DATELIMITE',V_PGI.DateEntree,false);
  TRY
    TheTob := TOBDate;
    SaisirHorsInside('BTDATEPREP');
    if TheTob = nil then Exit;
    DateFin := TheTob.getValue('DATELIMITE');
  FINALLY
    TOBDate.free;
    TheTob := nil;

    stWhere := ' AND GL_DATEPIECE<="' + UsDateTime(DateFin) + '"';

    LanceEtat( 'E', 'GZF', 'BTA', True, False, False, nil, stWhere, '', False) ;
  END;
*)
    LanceEtat( 'E', 'GZF', 'BTA', True, False, False, nil, '', '', False) ;
end;

procedure AGLValideAcceptDevis( parms: array of variant; nb: integer ) ;
var
F : TForm;
Q : TQuery ;
i :integer;
TOBAff,TOBPieces :TOB;
Numero, Indice : integer;
CodeAffaire, Affaireref, NaturePiece, Souche :string;
Tiers, Mess : string;
DemandeAcompte,AnnulAcceptation : boolean;
begin
F:=TForm(Longint(Parms[0]));
DemandeAcompte := (Parms[1] = 'X');
AnnulAcceptation := (Parms[3] = 'X');
if (TFMul(F).FListe=nil) then exit;
Q:=TFMul(F).Q;
if Parms[2] = VH_GC.AFNatProposition then
begin
  Mess:=TexteMessage[10]
end else
begin
	if AnnulAcceptation then
  begin
  	Mess:=TexteMessage[11];
  end else
  begin
  	Mess:=TexteMessage[1];
  end;
end;
if (PGIAskAF (Mess, F.Caption)<>mrYes) then exit;
SourisSablier;

TOBAff:=TOB.Create('AFFAIRE',Nil,-1) ;

// on cr�e une TOB de toutes les �tudes s�lectionn�es
TobPieces := TOB.Create ('Liste des �tudes',NIL, -1);

try
if TFMul(F).Fliste.AllSelected then
BEGIN
  Q.First;
  while Not Q.EOF do
  BEGIN
    CodeAffaire:=Q.FindField('AFF_AFFAIRE').AsString;
    AffaireRef:=Q.FindField('GP_AFFAIRE').AsString;
    NaturePiece:=Q.FindField('GP_NATUREPIECEG').AsString;
    Souche:=Q.FindField('GP_SOUCHE').AsString;
    Numero:=Q.FindField('GP_NUMERO').AsInteger;
    Indice:=Q.FindField('GP_INDICEG').AsInteger;
    Tiers:=Q.findfield('GP_TIERS').asString;
    if NaturePiece = VH_GC.AFNatAffaire then
       PrepaAcceptationDevis(CodeAffaire, AffaireRef, NaturePiece, Souche, Numero, Indice, Tiers,TOBAff,DemandeAcompte,AnnulAcceptation)
    else
       PrepaAcceptationEtude(CodeAffaire, NaturePiece, Souche, Numero, Indice, TOBAff, TobPieces);
    Q.NEXT;
  END;
  TFMul(F).Fliste.AllSelected:=False;
END
else
begin
  for i:=0 to TFMul(F).Fliste.nbSelected-1 do
  begin
    TFMul(F).Fliste.GotoLeBookmark(i);
    CodeAffaire:=TFMul(F).Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
    AffaireRef:=TFMul(F).Fliste.datasource.dataset.FindField('GP_AFFAIRE').AsString;
    NaturePiece:=TFMul(F).Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
    Souche:=TFMul(F).Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
    Numero:=TFMul(F).Fliste.datasource.dataset.FindField('GP_NUMERO').AsInteger;
    Indice:=TFMul(F).Fliste.datasource.dataset.FindField('GP_INDICEG').AsInteger;
    Tiers:=Q.findfield('GP_TIERS').asString;
    if NaturePiece = VH_GC.AFNatAffaire then
       PrepaAcceptationDevis(CodeAffaire, AffaireRef, NaturePiece, Souche, Numero, Indice, Tiers, TOBAff,DemandeAcompte,AnnulAcceptation)
    else
    	 PrepaAcceptationEtude(CodeAffaire, NaturePiece, Souche, Numero, Indice, TOBAff, TobPieces);

  end;
end;

// G�n�ration des devis depuis les �tudes
if NaturePiece = VH_GC.AFNatProposition then
  RegroupeLesPieces(TobPieces, VH_GC.AFNatAffaire, True, False, True,0, V_PGI.DateEntree,true,false,false,true,false,'',true);

finally
TOBAff.Free; TobPieces.Free;
SourisNormale ;
end;

end;

procedure AGLClotureTechnique( parms: array of variant; nb: integer ) ;
var
F : TForm;
i,Indice :integer;
TobPieces,TobPiece,TobPieceB,TOBPiecesDAC,TOBFAC:TOB;
Numero : integer;
CodeAffaire, Affaireref, Tiers, NaturePiece, DatePiece, Souche,TypeGeneration :string;
Sql,EtatPrec,NewEtat,Req:string;
CleDocAffaire : R_CleDoc;
QQ : TQuery ;
NbMois :integer ;
DateCloture,DateFinGarantie : TDateTime;
Retour : boolean ;
LesAcomptes : TOB;
AcomptesObligatoire : boolean;
messag : string;
begin
F:=TForm(Longint(Parms[0]));
AcomptesObligatoire := false;
if (TFMul(F).FListe=nil) then exit;
if (PGIAskAF (TexteMessage[9], F.Caption)<>mrYes) then exit;
DateCloture := V_PGI.DateEntree;
if not SaisieDateCloture (DateCloture) then exit;
NbMois := ValeurI(GetParamSocSecur('SO_AFALIMGARANTI', 0));
if NbMois <> 0 then DateFinGarantie := PlusDate(DateCloture,NbMois,'M') else DateFinGarantie := PlusDate(DateCloture,12,'M');
SourisSablier;
// on cr�e une TOB de toutes les pieces s�lectionn�es
TobPieces := TOB.Create ('Liste des pieces',NIL, -1);
TobPiecesDAC := TOB.Create ('Liste des pieces acomptes',NIL, -1);
LesAcomptes := TOB.create ('Liste des acomptes',Nil,-1);
TOBFAC := TOB.Create ('LES PIECERG',nil,-1);
try
for i:=0 to TFMul(F).Fliste.nbSelected-1 do
  begin
  LesAcomptes.clearDetail;
  TFMul(F).Fliste.GotoLeBookmark(i);
  CodeAffaire:=TFMul(F).Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
  AffaireRef:=TFMul(F).Fliste.datasource.dataset.FindField('GP_AFFAIRE').AsString;
  Tiers:=TFMul(F).Fliste.datasource.dataset.FindField('GP_TIERS').AsString;
  NaturePiece:=TFMul(F).Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
  DatePiece:=TFMul(F).Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsString;
  Souche:=TFMul(F).Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
  Numero:=TFMul(F).Fliste.datasource.dataset.FindField('GP_NUMERO').AsInteger;
  Indice:=TFMul(F).Fliste.datasource.dataset.FindField('GP_INDICEG').AsInteger;
  TypeGeneration:= RenvoieTypeFact(CodeAffaire); // on peut pas le recuperer dans le datasource directement

  // Saisie des avancements
  CleDocAffaire.NaturePiece:= NaturePiece;
  CleDocAffaire.DatePiece:= StrToDate(DatePiece);
  CleDocAffaire.Souche:= Souche;
  CleDocAffaire.NumeroPiece:= Numero;
  CleDocAffaire.Indice:= Indice;

  if TypeGeneration = 'DAC' then
      begin
      if PositionnePieceMorteVivante (naturepiece,souche,numero,indice,'X',EtatPrec) then
         BEGIN
         retour:=SaisieAvancementAcompte(True,AcomptesObligatoire,LesAcomptes,CleDocAffaire, taModif,Tiers, AffaireRef, '', True);
         newEtat := EtatPrec;
         if PositionnePieceMorteVivante (naturepiece,souche,numero,indice,NewEtat,EtatPrec) then
            BEGIN
            if (retour = True) then
               begin
          // Remplissage de la TOB contenant les pieces selectionn�es

               TobPiece := Tob.Create ('PIECE', TobPiecesDAC,-1);
               TOBPiece.AddChampSupValeur ('AFF_OKSIZERO','-');
               TobPieceb := Tob.Create ('PIECE', TobPieces,-1);
               TOBPieceb.addChampSupValeur ('TYPEFAC',TypeGeneration,false);
(*
               Sql := '"'+ NaturePiece
                   + '";"'+ Souche
                   + '";"'+ inttostr(Numero)
                   + '";"'+ inttostr(Indice) + '"';
*)
               QQ :=OpenSql ( 'SELECT *,AFF_OKSIZERO FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS ' +
                             'WHERE ' + WherePiece(CleDocAffaire, ttdPiece, False), True,-1,'',true);
               TobPiece.selectDB ('', QQ, False);
               ferme (QQ);
               (*
               if lesAcomptes.detail.count > 0 then
                  begin
                  for Indice := 0 to LesAcomptes.detail.count -1 do
                      begin
                      TOBAA := TOB.Create ('ACOMPTES',TOBPIece,-1);
                      TOBAA.dupliquer (LesAcomptes.detail[Indice],true,true);
                      end;
                  end;
               *)
               TobPieceB.dupliquer (TOBPiece,true,true);
               end;
             END;
         END;
      END ELSE
      BEGIn
      // modif brl 24/03 : en facturation directe, le devis est positionn� en pi�ce morte lors de la cl�ture.
      if TypeGeneration = 'DIR' then PositionnePieceMorteVivante (naturepiece,souche,numero,indice,'-',EtatPrec);

      TobPiece := Tob.Create ('PIECE', TobPieces,-1);
      TOBPiece.AddChampSupValeur ('AFF_OKSIZERO','-');
      TOBPiece.addChampSupValeur ('TYPEFAC',TypeGeneration,false);
(*
      Sql := '"'+ NaturePiece
             + '";"'+ Souche
             + '";"'+ inttostr(Numero)
             + '";"'+ inttostr(Indice) + '"';
*)
      QQ :=OpenSql ( 'SELECT *,AFF_OKSIZERO,AFF_PREPARE FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS ' +
                   'WHERE ' + WherePiece(CleDocAffaire, ttdPiece, False), True,-1,'',true);
      TOBPiece.selectDb ('',QQ,false);
      ferme (QQ);

{$IFNDEF LINE}
      if (TypeGeneration <> 'DIR') and
      	 (TOBPiece.getValue('GP_AFFAIRE')<> '') and
         (TOBPiece.getValue('AFF_PREPARE') <> 'X') then
         begin
	          messag := 'Le devis '+inttostr(TOBPiece.GetValue('GP_NUMERO'))+' n''est pr�sent dans aucune pr�vision de chantier.'+
            					'#13#10 Confirmez-vous le traitement ?';
         	  if PgiAsk (messag) <> Mryes then
            begin
            	TOBPiece.free;
            end;
         end;
{$ENDIF}
      END;
  end;

if TobPiecesDac.Detail.Count > 0 then
  begin
  // Regroupement des pieces pour g�n�ration de la facture
  if RegroupeLesPieces(TobPiecesDac, 'FBT', False, False, True,0, DateCloture,True,false,false,false,True) <> 0 then
     BEGIN
     TobPieces.Free; TOBPiecesDac.free; TOBFAC.Free;
     LesAcomptes.free;
     SourisNormale ;
     exit;
     END;
  end;

  for I := 0 to TOBPieces.detail.count -1 do
      begin
      TobPiece := TOBPieces.detail[i];
      CodeAffaire := TOBPiece.GetValue('GP_AFFAIREDEVIS');
      TypeGeneration:= RenvoieTypeFact(CodeAffaire);
      sql := 'UPDATE AFFAIRE SET AFF_ETATAFFAIRE="TER",AFF_DATEFIN="'+usdatetime(DateCloture)+
             '",AFF_DATEGARANTIE="'+UsDateTime(DateFinGarantie)+'" WHERE AFF_AFFAIRE="'+CodeAffaire+'"';
      if (ExecuteSql (Sql) > 0 ) then
         begin
         sql := 'SELECT GP_NATUREPIECEG,GP_DATEPIECE,GP_SOUCHE,GP_NUMERO,GP_INDICEG FROM PIECE WHERE GP_NATUREPIECEG="FBT" '+
                'AND GP_AFFAIREDEVIS="'+CodeAffaire+'"';
         QQ := OpenSql (sql,true,-1,'',true);
         if not QQ.eof then
            begin
            TOBFAC.ClearDetail;
            TOBFAC.LoadDetailDB ('PIECE','','',QQ,false);
            ferme (QQ);
            for Indice := 0 to TOBFAC.detail.count -1 do
                begin
                Req := 'UPDATE PIECERG SET PRG_DATEECH="'+UsDateTime(DateFinGarantie)+'"'+
                'WHERE PRG_NATUREPIECEG="'+TOBFAC.detail[Indice].GetValue('GP_NATUREPIECEG')+'" AND '+
                'PRG_DATEPIECE="'+UsDateTime(TOBFAC.detail[Indice].GetValue('GP_DATEPIECE'))+'" AND '+
                'PRG_SOUCHE="'+TOBFAC.detail[Indice].GetValue('GP_SOUCHE')+'" AND '+
                'PRG_NUMERO='+inttostr(TOBFAC.detail[Indice].GetValue('GP_NUMERO'))+' AND '+
                'PRG_INDICEG='+inttostr(TOBFAC.detail[Indice].GetValue('GP_INDICEG'));
                ExecuteSql (req)
                end;
            end else ferme (QQ);
         end;
      end;

finally
TobPieces.Free; TOBPiecesDac.free;
TOBFAC.free;
LesAcomptes.free;
SourisNormale ;
end;
end;

procedure AGLValidePrepaFactures( parms: array of variant; nb: integer ) ;
var
F : TForm;
i,Indice :integer;
TobPieces,TobPiece,TOBPiecesDAC,TOBMilliemes:TOB;
Numero : integer;
CodeAffaire, Affaireref, Tiers, NaturePiece, DatePiece, Souche,TypeGeneration :string;
Sql,EtatPrec,NewEtat:string;
CleDocAffaire : R_CleDoc;
Retour : boolean ;
LesAcomptes,TOBAA : TOB;
AcomptesObligatoire : boolean;
QQ : Tquery;
begin
F:=TForm(Longint(Parms[0]));
AcomptesObligatoire := (Parms[1]='X');
if (TFMul(F).FListe=nil) then exit;
if (PGIAskAF (TexteMessage[4], F.Caption)<>mrYes) then exit;

SourisSablier;
// on cr�e une TOB de toutes les pieces s�lectionn�es
TobPieces := TOB.Create ('Liste des pieces',NIL, -1);
TobPiecesDAC := TOB.Create ('Liste des pieces acomptes',NIL, -1);
LesAcomptes := TOB.create ('Liste des acomptes',Nil,-1);
TOBMilliemes := TOB.create ('LES MILLIEMES',Nil,-1);
try
for i:=0 to TFMul(F).Fliste.nbSelected-1 do
  begin
  LesAcomptes.clearDetail;
  TFMul(F).Fliste.GotoLeBookmark(i);
  CodeAffaire:=TFMul(F).Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;
  AffaireRef:=TFMul(F).Fliste.datasource.dataset.FindField('GP_AFFAIRE').AsString;
  Tiers:=TFMul(F).Fliste.datasource.dataset.FindField('GP_TIERS').AsString;
  NaturePiece:=TFMul(F).Fliste.datasource.dataset.FindField('GP_NATUREPIECEG').AsString;
  DatePiece:=TFMul(F).Fliste.datasource.dataset.FindField('GP_DATEPIECE').AsString;
  Souche:=TFMul(F).Fliste.datasource.dataset.FindField('GP_SOUCHE').AsString;
  Numero:=TFMul(F).Fliste.datasource.dataset.FindField('GP_NUMERO').AsInteger;
  Indice:=TFMul(F).Fliste.datasource.dataset.FindField('GP_INDICEG').AsInteger;
  TypeGeneration:=TFMul(F).Fliste.datasource.dataset.FindField('AFF_GENERAUTO').AsString;
//  TypeGeneration:= RenvoieTypeFact(CodeAffaire); // on peut pas le recuperer dans le datasource directement

  // Saisie des avancements
  CleDocAffaire.NaturePiece:= NaturePiece;
  CleDocAffaire.DatePiece:= StrToDate(DatePiece);
  CleDocAffaire.Souche:= Souche;
  CleDocAffaire.NumeroPiece:= Numero;
  CleDocAffaire.Indice:= Indice;

  if naturePiece = 'DAP' then
     begin
     TobPiece := Tob.Create ('PIECE', TobPieces,-1);
		 TOBPiece.AddChampSupValeur ('AFF_OKSIZERO','-');
 		 TOBPiece.AddChampSupValeur ('RUPTMILLIEME','');
     QQ :=OpenSql ( 'SELECT *,AFF_OKSIZERO,AFF_GENERAUTO FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS ' +
                    'WHERE ' + WherePiece(CleDocAffaire, ttdPiece, False), True,-1,'',true);
     TOBPiece.selectDb ('',QQ,false);
     ferme (QQ);
     end
  // on positionne la pi�ce comme vivante pour saisir les avancements
  else if PositionnePieceMorteVivante (naturepiece,souche,numero,indice,'X',EtatPrec) then
     BEGIN
     retour:=SaisieAvancementAcompte(False,AcomptesObligatoire,LesAcomptes,CleDocAffaire, taModif,Tiers, AffaireRef, '', True);
     newEtat := EtatPrec;
     // on remet la pi�ce dans son �tat initial
//     if PositionnePieceMorteVivante (naturepiece,souche,numero,indice,NewEtat,EtatPrec) then
        BEGIN
        if (retour = True) then
           begin
           // Remplissage de la TOB contenant les pieces selectionn�es
           if TypeGeneration = 'DAC' then
              TobPiece := Tob.Create ('PIECE', TobPiecesDAC,-1)
           else
              TobPiece := Tob.Create ('PIECE', TobPieces,-1);

      		 TOBPiece.AddChampSupValeur ('AFF_OKSIZERO','-');
      		 TOBPiece.AddChampSupValeur ('RUPTMILLIEME','');

           QQ :=OpenSql ( 'SELECT *,AFF_OKSIZERO,AFF_GENERAUTO FROM PIECE LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS ' +
                         'WHERE ' + WherePiece(CleDocAffaire, ttdPiece, False), True,-1,'',true);
           TOBPiece.selectDb ('',QQ,false);
           ferme (QQ);
//
					 TOBMilliemes.ClearDetail;
					 QQ := OPenSql ('SELECT BPM_CATEGORIETAXE,BPM_FAMILLETAXE,BPM_MILLIEME FROM BTPIECEMILIEME WHERE '+WherePiece (CledocAffaire,TTdRepartmill,false),True,-1,'',true);
           if not QQ.eof then
           begin
           	 TOBMilliemes.LoadDetailDB ('BTPIECEMILIEME','','',QQ,false);
             TOBPiece.putValue('RUPTMILLIEME',EncodeRepartTva (TOBMilliemes));
           end;
           Ferme(QQ);
//
(*           Sql := '"'+ NaturePiece
               + '";"'+ Souche
               + '";"'+ inttostr(Numero)
               + '";"'+ inttostr(Indice) + '"';
           TobPiece.selectDB (sql, Nil, False);
*)
           if lesAcomptes.detail.count > 0 then
              begin
              for Indice := 0 to LesAcomptes.detail.count -1 do
                  begin
                  TOBAA := TOB.Create ('ACOMPTES',TOBPIece,-1);
                  TOBAA.dupliquer (LesAcomptes.detail[Indice],true,true);
                  end;
              end;
           end;
         END;
     END;
  end;

// traitement des situations et factures directes
if TobPieces.Detail.Count > 0 then
  begin
  // Regroupement des pieces
  if naturePiece = 'DAP' then
	   RegroupeLesPieces(TobPieces, 'FPR', False, False, True,0, V_PGI.DateEntree)
  else
	  RegroupeLesPieces(TobPieces, 'FBT', False, False, True,0, V_PGI.DateEntree);
  // Pour les situations, le devis initial est mort d�s la premi�re facture
  For i:=0 to TobPieces.Detail.Count-1 Do
    begin
    CodeAffaire:=Tobpieces.Detail[i].Getvalue('GP_AFFAIREDEVIS');
    TypeGeneration:= RenvoieTypeFact(CodeAffaire);
    if naturePiece = 'DAP' then
    	begin
			PositionneEtatAffaire(CodeAffaire, 'FAC');
      end;
    if TypeGeneration = 'AVA' then
      begin
      naturepiece:=Tobpieces.Detail[i].Getvalue('GP_NATUREPIECEG');
      souche:=Tobpieces.Detail[i].Getvalue('GP_SOUCHE');
      numero:=Tobpieces.Detail[i].Getvalue('GP_NUMERO');
      indice:=Tobpieces.Detail[i].Getvalue('GP_INDICEG');
//      PositionnePieceMorteVivante (naturepiece,souche,numero,indice,'-',EtatPrec);
      end;
    end;
  end;

// traitement des demandes d'acomptes
if TobPiecesDac.Detail.Count > 0 then
  begin
  // Regroupement des pieces pour demande d'acompte
  RegroupeLesPieces(TobPiecesDac, 'DAC', False, False, True,0, V_PGI.DateEntree);
  // Pour les demandes d'acomptes, le devis initial est mort d�s la premi�re facture
  For i:=0 to TobPiecesDac.Detail.Count-1 Do
    begin
    naturepiece:=TobPiecesDac.Detail[i].Getvalue('GP_NATUREPIECEG');
    souche:=TobPiecesDac.Detail[i].Getvalue('GP_SOUCHE');
    numero:=TobPiecesDac.Detail[i].Getvalue('GP_NUMERO');
    indice:=TobPiecesDac.Detail[i].Getvalue('GP_INDICEG');
//    PositionnePieceMorteVivante (naturepiece,souche,numero,indice,'-',EtatPrec);
    end;
  end;

finally
TobPieces.Free; TOBPiecesDac.free; TOBMilliemes.free;
LesAcomptes.free;
SourisNormale ;
end;
end;

procedure AGLAfficheAvenant( parms: array of variant; nb: integer ) ;
var
F : TForm;
i : integer;
begin
F:=TForm(Longint(Parms[0]));
TFMul(F).Fliste.EditorMode := True;

for i := 0 to TFMul(F).Fliste.Columns.Count-1 do
  begin
  if TFMul(F).Fliste.columns[i].FieldName = 'AFF_AVENANT' then
    if TFMul(F).Fliste.columns[i].Field.AsString = '00' then
    begin
        TFMul(F).Fliste.Columns[i].Field.Value := '';
    end;
  end;

end;

procedure AfterGenerationPiece (TOBOffres,TOBPieces,TOBAffairesP : TOB);
var Indice : integer;
    TOBTiers,TOBpiece,TOBOffre,TOBAffaireP : TOB;
    Sql : string;
    QQ : TQuery;
begin
  // Mise a jour des pi�ces pr�c�dentes
  for Indice := 0 to TOBPieces.detail.Count -1 do
  begin
    TOBPiece := TOBPieces.detail[Indice];
    if TOBPiece <> NIL THEN
    BEGIN
      TOBOffre := TOBOffres.FindFirst (['AFF_AFFAIRE'],[TOBPiece.GetValue('OLD_AFFAIRE')],true);
      if TOBOffre <> nil then
      begin
        TOBPiece.putValue('GP_AFFAIRE',TOBOffre.GetValue('AFF_AFFAIRE'));
        TOBPiece.putValue('GP_AFFAIRE1',TOBOffre.GetValue('AFF_AFFAIRE1'));
        TOBPiece.putValue('GP_AFFAIRE2',TOBOffre.GetValue('AFF_AFFAIRE2'));
        TOBPiece.putValue('GP_AFFAIRE3',TOBOffre.GetValue('AFF_AFFAIRE3'));
        TOBPiece.putValue('GP_AVENANT',TOBOffre.GetValue('AFF_AVENANT'));
        (*
        TOBAffaireP := TOBAffairesP.FindFirst (['AFF_AFFAIRE'],[TOBPiece.getValue('GP_AFFAIREDEVIS')],true);
        if TOBAffaireP <> nil then
        begin
          TOBAffaireP.PutValue('AFF_AFFAIREREF',TOBPiece.GetValue('GP_AFFAIRE'));
          TOBAffaireP.PutValue('AFF_AFFAIREINIT',TOBPiece.GetValue('GP_AFFAIRE'));
          TOBAffaireP.updatedb (false);
        end;
        *)
        //maj lIGNE DE PIECE
        Sql := 'UPDATE LIGNE SET GL_AFFAIRE = "'+TOBPiece.GetValue('GP_AFFAIRE')+'",'+
               'GL_AFFAIRE1="'+ TOBPiece.GetValue('GP_AFFAIRE1') + '",' +
               'GL_AFFAIRE2="'+ TOBPiece.GetValue('GP_AFFAIRE2') + '",' +
               'GL_AFFAIRE3="'+ TOBPiece.GetValue('GP_AFFAIRE3') + '",' +
               'GL_AVENANT="'+ TOBPiece.GetValue('GP_AVENANT') + '" ' +
               'WHERE GL_NATUREPIECEG="'+TOBPiece.GetValue('GP_NATUREPIECEG')+'" AND ' +
               'GL_SOUCHE="'+TOBPIece.GetValue('GP_SOUCHE')+'" AND ' +
               'GL_NUMERO='+inttostr(TOBPIece.GetValue('GP_NUMERO'))+' AND ' +
               'GL_INDICEG='+inttostr(TOBPIece.GetValue('GP_INDICEG'));
        ExecuteSQL(Sql);
        TOBPiece.updateDb(false);
      end;
    END;
  end;

  // Mise � jour des appels d'offres initiaux
  for Indice := 0 to TOBOffres.detail.count -1 do
  begin
    TOBOffre := TOBOffres.detail[Indice];
    TOBOffre.clearDetail;
    //
    TOBTiers := TOB.create ('TIERS',nil,-1);
    QQ := opensql('SELECT * FROM TIERS WHERE T_TIERS="'+TOBOffre.GetValue('AFF_TIERS')+'"',true,-1,'',true);
    TOBTIers.selectdb ('',QQ);
    ferme (QQ);
    if (TobTiers.GetValue('T_NATUREAUXI')='PRO') then
    begin
//      if GetInfoParPiece(VH_GC.AFNatAffaire,'GPP_PROCLI') = 'X' then
      begin
        // transformer le tiers de PRO en CLI
        TobTiers.putValue('T_NATUREAUXI','CLI');
        TOBTiers.SetAllModifie (true);
        TOBTiers.UpdateDB;
      end;
    end;
    TOBTiers.Free;
  end;
  (*
  TOBOffres.SetAllModifie (true);
  TOBOffres.UpdateDB (true);
  *)
  //
end;

procedure BeforeGenerationPieces (TOBOffres,TOBPieces,TOBAffaires,TOBAffairesP : TOB; Var Ok_Genere : boolean);
var Indice,IndDetOf : integer;
    TOBOffre,TOBAffaire,TOBEtude,TOBPiece,TOBAffaireP : TOB;
    Sql   : string;
    CleDocAffaire : R_CLEDOC;
    QQ    : TQuery;
    StSQL : string;
begin

  Ok_Genere := True;

  if TOBOffres.detail.count > 0 then
  begin
    For Indice := 0 To TOBOffres.detail.count -1 do // Niveau 0 Affaire (offres)
    begin
      TOBOffre := TOBOffres.detail[Indice];
      if TOBOffre.getValue('TRAITOK') = 'X' then
      begin
      	(*
        // MAJ Affaire pr�c�dente (Appel D'offre)
        TOBOffre.putvalue('AFF_ETATAFFAIRE','ACP');
        TOBOffre.PutValue('AFF_DATESIGNE', V_PGI.DateEntree);

        // creation de l'affaire principale (Affaire a cr�er ou rattach�e)
        TOBAffaire := TOB.create ('AFFAIRE',TobAffaires,-1);
        TOBAFFAIRE.Dupliquer (TOBOffre,false,true);

        TOBAffaire.PutValue ('AFF_AFFAIRE',TOBOffre.getValue('NAFF_AFFAIRE'));
        TOBAffaire.PutValue ('AFF_AFFAIRE0',TOBOffre.getValue('NAFF_AFFAIRE0'));
        TOBAffaire.PutValue ('AFF_AFFAIRE1',TOBOffre.getValue('NAFF_AFFAIRE1'));
        TOBAffaire.PutValue ('AFF_AFFAIRE2',TOBOffre.getValue('NAFF_AFFAIRE2'));
        TOBAffaire.PutValue ('AFF_AFFAIRE3',TOBOffre.getValue('NAFF_AFFAIRE3'));
        TOBAffaire.PutValue ('AFF_AVENANT',TOBOffre.getValue('NAFF_AVENANT'));

        TOBAffaire.PutValue('AFF_STATUTAFFAIRE','AFF');
        TOBAffaire.PutValue('AFF_AFFAIREREF',TOBOffre.GetValue('NAFF_AFFAIRE'));
        TOBAffaire.PutValue('AFF_REGROUPEFACT',TOBoffre.GetValue('REGROUPFACTBIS'));
        TOBAffaire.PutValue('AFF_GENERAUTO',TOBoffre.GetValue('AFF_GENERAUTO'));
        TOBAffaire.PutValue('AFF_ETATAFFAIRE', 'ENC');
        TOBAffaire.PutValue('AFF_DATESIGNE', V_PGI.DateEntree);
        *)
        for IndDetOf := 0 to TOBOffre.detail.count -1 do // niveau 1 (detail de l'appel d'offre)
        begin
          // appel de tous les documents rattach�s a l'appel d'offre
          TOBEtude := TOBOffre.detail[IndDetOf];
          DecodeRefPiece (TOBEtude.GetValue('BDE_PIECEASSOCIEE'),CleDocAffaire);
          QQ:=OpenSQL('SELECT * FROM PIECE WHERE '+WherePiece(CleDocAffaire,ttdPiece,False),True,-1,'',true) ;
          if not QQ.eof then
          begin
            TOBPiece := TOB.create ('PIECE',TOBPieces,-1);
            TOBPiece.SelectDB('',QQ) ;
            Ferme(QQ) ;

            //FV1 : contr�le si les lignes de documents sont valoris�es
            StSQL := 'select ##TOP 1##* from ligne ';
            StSQL := StSQL + 'WHERE GL_PUHT = 0 AND GL_TYPELIGNE="ART"';
            StSQL := StSQL + '  AND GL_NATUREPIECEG="' + TOBPiece.GetValue('GP_NATUREPIECEG') + '"';
            StSQL := StSQL + '  AND GL_SOUCHE="' + TOBPIece.GetValue('GP_SOUCHE') + '"';
            StSQL := StSQL + '  AND GL_NUMERO=' + inttostr(TOBPIece.GetValue('GP_NUMERO'));
            StSQL := StSQL + '  AND GL_INDICEG=' + inttostr(TOBPIece.GetValue('GP_INDICEG'));
            Ok_Genere := (Ok_Genere and ExisteSQL(StSQL));

            // sauvegarde
            TOBPiece.AddChampSupValeur ('OLD_AFFAIRE',TOBPiece.GetValue('GP_AFFAIRE'));

            QQ := OPENSql ('SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE="'+TOBPIece.getVAlue('GP_AFFAIREDEVIS')+'"',true,-1,'',true);
            if not QQ.eof Then
            begin
              TOBAffaireP := TOB.Create ('AFFAIRE',TOBAffairesP,-1);
              TOBAffaireP.selectDb ('',QQ);
              TOBAffaireP.PutValue('AFF_ETATAFFAIRE','ACP');
              TOBAffaireP.PutValue('AFF_AFFAIREREF',TOBOffre.GetValue('AFF_AFFAIRE'));
              TOBAffaireP.PutValue('AFF_AFFAIREINIT',TOBOffre.GetValue('AFF_AFFAIREINIT'));
              TOBAffaireP.UpdateDB (false);
            end;
            Ferme (QQ);

            // maj du nouveau code affaire dans la nouvelle pi�ce : le devis
            TOBPiece.putValue('GP_AFFAIRE',TOBOffre.GetValue('AFF_AFFAIRE'));
            TOBPiece.putValue('GP_AFFAIRE1',TOBOffre.GetValue('AFF_AFFAIRE1'));
            TOBPiece.putValue('GP_AFFAIRE2',TOBOffre.GetValue('AFF_AFFAIRE2'));
            TOBPiece.putValue('GP_AFFAIRE3',TOBOffre.GetValue('AFF_AFFAIRE3'));
            TOBPiece.putValue('GP_AVENANT',TOBOffre.GetValue('AFF_AVENANT'));
            //
            TOBPiece.updateDb(false);

            //maj lIGNE DE PIECE
            Sql := 'UPDATE LIGNE SET GL_AFFAIRE = "'+TOBPiece.GetValue('GP_AFFAIRE')+'",'+
                   'GL_AFFAIRE1="'+ TOBPiece.GetValue('GP_AFFAIRE1') + '",' +
                   'GL_AFFAIRE2="'+ TOBPiece.GetValue('GP_AFFAIRE2') + '",' +
                   'GL_AFFAIRE3="'+ TOBPiece.GetValue('GP_AFFAIRE3') + '",' +
                   'GL_AVENANT="'+ TOBPiece.GetValue('GP_AVENANT') + '" ' +
                   'WHERE GL_NATUREPIECEG="'+TOBPiece.GetValue('GP_NATUREPIECEG')+'" AND ' +
                   'GL_SOUCHE="'+TOBPIece.GetValue('GP_SOUCHE')+'" AND ' +
                   'GL_NUMERO='+inttostr(TOBPIece.GetValue('GP_NUMERO'))+' AND ' +
                   'GL_INDICEG='+inttostr(TOBPIece.GetValue('GP_INDICEG'));
            ExecuteSQL(Sql);

          end else Ferme(QQ);
        end;
      end;
    end;
    if TObAffaires.detail.count > 0 then
    begin
      // les pieces de l'affaire sont maintenant cr��s
      TOBAffaires.SetAllModifie (true);
      {NewOne}
      //  TOBAffaires.insertDB (nil,true); // on cree les affaires pour qu'il puisse retrouver ses petits
      For Indice := 0 To TOBAffaires.detail.count -1 do
      begin
        if TobAffaires.detail[Indice].getValue('NEW_AFFAIRE')= 'X' then TobAffaires.detail[Indice].InsertDb(nil);
      end;
    end;
  end;
end;

procedure AGLAccepteAppelOffre( parms: array of variant; nb: integer ) ;
var
  F           : TForm;
  i           : integer;
  TOBOffres   : TOB;
  TOBOffre    : TOB;
  TOBAffaires : TOB;
  TOBPIeces   : TOB;
  TOBAffairesP: TOB;
  Indice      : integer;
  CodeAffaire : string;
  QQ          : TQuery ;
  Ok_Genere   : Boolean;
begin

  F:=TForm(Longint(Parms[0]));

  if (TFMul(F).FListe=nil) then exit;
  if (PGIAskAF (TexteMessage[7], F.Caption)<>mrYes) then exit;

  SourisSablier;

  // on cr�e une TOB de toutes les pieces s�lectionn�es
  TOBOffres := TOB.Create ('Appels offre',NIL, -1);
  TOBPieces := TOB.Create ('LES PIECES',nil,-1);
  TOBAffaireS := TOB.create ('LES AFFAIRES',nil,-1);
  TOBAffairesP := TOB.create ('LES AFFAIRES PIECES',nil,-1);

  try
    for i:=0 to TFMul(F).Fliste.nbSelected-1 do
    begin
      TFMul(F).Fliste.GotoLeBookmark(i);
      CodeAffaire:=TFMul(F).Fliste.datasource.dataset.FindField('AFF_AFFAIRE').AsString;

      TOBOffre := TOB.create ('AFFAIRE',TOBOffres,-1);
      QQ := opensql ('SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE="' + CodeAffaire + '"',true,-1,'',true);
      if not QQ.eof then
      begin
        TOBOffre.selectdb ('',QQ);
        TOBOffre.AddChampSupValeur ('TRAITOK','-',false);
        TOBOffre.AddChampSupValeur ('REGROUPFACTBIS',TOBOffre.GetValue('AFF_REGROUPEFACT'),false);
        TOBoffre.addchampsupvaleur('NEW_AFFAIRE', 'X');
        TOBoffre.addchampsupvaleur('AFFAIRE_INIT', 'X');
        TOBoffre.addchampsupvaleur('OLD_AFFAIRE', TOBOffre.getValue('AFF_AFFAIRE'));
        //
        TOBoffre.addchampsupvaleur('NAFF_AFFAIRE', TOBOffre.getValue('AFF_AFFAIRE'));
        TOBoffre.addchampsupvaleur('NAFF_AFFAIRE0', TOBOffre.getValue('AFF_AFFAIRE0'));
        TOBoffre.addchampsupvaleur('NAFF_AFFAIRE1', TOBOffre.getValue('AFF_AFFAIRE1'));
        TOBoffre.addchampsupvaleur('NAFF_AFFAIRE2', TOBOffre.getValue('AFF_AFFAIRE2'));
        TOBoffre.addchampsupvaleur('NAFF_AFFAIRE3', TOBOffre.getValue('AFF_AFFAIRE3'));
        TOBoffre.addchampsupvaleur('NAFF_AVENANT', TOBOffre.getValue('AFF_AVENANT'));
        ferme(QQ);
        QQ := Opensql ('SELECT * FROM BDETETUDE WHERE BDE_AFFAIRE="' + CodeAffaire + '"',true,-1,'',true);
        if not QQ.eof then TOBOffre.LoadDetailDB ('BDETETUDE','','',QQ,false,true);
      end;
      ferme (QQ);
    end;

    if TobOffres.Detail.Count > 0 then
    begin
      // traitement de chaque d�tail
      Indice := 0;
      repeat
        TOBOffre := TOBOffres.detail[Indice];
        if GestionDetailEtude ('','',TOBOffre.GetValue('AFF_AFFAIRE'), (TOBOffre.getValue('AFF_MANDATAIRE')='X'),taModif ,TOBOffre,TatAccept) = true then
        Begin
          TOBOffre.putvalue('TRAITOK','X');
          inc (Indice);
        End else TOBOffre.free;
      until Indice>=TOBOffres.detail.count;

      if TOBOffres.detail.count = 0 then Exit;

      BeforeGenerationPieces (TOBOffres,TOBPieces, TOBAffaires,TOBAffairesP, Ok_Genere);

      if Ok_Genere then
      begin
        PGIInfo('Toutes les lignes du document ne sont pas valoris�es');
      end;

      {NewOne}
      if RegroupeLesPieces(TobPieces, VH_GC.AFNatAffaire, False, False, True,0, V_PGI.DateEntree,true,false,false,true) <> 0 then
      begin
//       TOBAffaires.DeleteDB (true); // on Vire les affaires de reference
        For Indice := 0 To TOBAffaires.detail.count -1 do
        begin
          if TobAffaires.detail[Indice].getValue('NEW_AFFAIRE')= 'X' then
              TobAffaires.detail[Indice].DeleteDB (false);
        end;
      end else
      BEGIN
        AfterGenerationPiece (TOBOffres,TOBPieces,TOBAffairesP);
      END;

    end;
  finally
    TobOffres.Free;
    TOBPieces.free;
    TOBAffairesP.free;
    TOBAFFAIRES.free;
    SourisNormale ;
  end;
end;

procedure AGLPointageDemandeAct (parms: array of variant; nb: integer ) ;
var TOBAffaire,TOBTIers : TOB;
    Q : TQuery;
    Affaire : string;
begin
TOBAffaire := TOB.Create ('AFFAIRE',nil,-1);
TOBTiers := TOB.Create ('TIERS',nil,-1);
Affaire := Parms[1];
Q := Opensql ('SELECT * FROM AFFAIRE WHERE AFF_AFFAIRE="'+Affaire+'"',true,-1,'',true);
TOBAffaire.selectdb ('',Q);
ferme (Q);
Q := Opensql ('SELECT * FROM TIERS WHERE T_TIERS="'+TOBAffaire.GetValue('AFF_TIERS')+'"',true,-1,'',true);
TOBTiers.selectdb ('',Q);
ferme (Q);
TheTOB := TOBAffaire;
TheTob.data := TOBTiers;
TRY
AGLLanceFiche('BTP','BTREGLDAC','','','ACTION=MODIFICATION') ;
FINALLY
TOBAffaire.free;
TOBTiers.free;
TheTOB := nil;
END;
end;

procedure AjouteDebutparagFrais (TOBfrais : TOB);
var TOBL,TOBRef : TOB;
begin
  if TOBFrais.detail.count = 0 then Exit;
	TOBref := TOBFrais.detail[0];
	TOBL:=NewTobLigne(TOBFrais,1);
//	TOBL := TOB.Create ('LIGNE',TOBFrais,0);
  InitialiseLigne (TOBL,0,0);
  TOBL.putValue('GL_TYPELIGNE','DP1');
  TOBL.PutValue('GL_NATUREPIECEG', TOBRef.GetValue('GL_NATUREPIECEG'));
  TOBL.PutValue('GL_SOUCHE', TOBRef.GetValue('GL_SOUCHE'));
  TOBL.PutValue('GL_NUMERO', TOBRef.GetValue('GL_NUMERO'));
  TOBL.PutValue('GL_INDICEG', TOBRef.GetValue('GL_INDICEG'));
  TOBL.putValue('GL_TIERS',TOBref.getValue('GL_TIERS'));
//
  TOBL.PutValue('GL_TIERSFACTURE', TOBref.GetValue('GL_TIERSFACTURE'));
  TOBL.PutValue('GL_TIERSLIVRE', TOBref.GetValue('GL_TIERSLIVRE'));
  TOBL.PutValue('GL_TIERSPAYEUR', TOBref.GetValue('GL_TIERSPAYEUR'));
  TOBL.PutValue('GL_TARIFSPECIAL', TOBref.GetValue('GL_TARIFSPECIAL'));
  TOBL.PutValue('GL_TARIFTIERS', TOBref.GetValue('GL_TARIFTIERS')); //mcd 20/01/03 oubli ...
  TOBL.PutValue('GL_DATEPIECE', TOBref.GetValue('GL_DATEPIECE'));
  TOBL.PutValue('GL_NATUREPIECEG', TOBref.GetValue('GL_NATUREPIECEG'));
  TOBL.PutValue('GL_ETABLISSEMENT', TOBref.GetValue('GL_ETABLISSEMENT'));
  TOBL.PutValue('GL_FACTUREHT', TOBref.GetValue('GL_FACTUREHT'));
  TOBL.PutValue('GL_DEVISE', TOBref.GetValue('GL_DEVISE'));
  TOBL.PutValue('GL_TAUXDEV', TOBref.GetValue('GL_TAUXDEV'));
  TOBL.PutValue('GL_COTATION', TOBref.GetValue('GL_COTATION'));
  TOBL.PutValue('GL_NUMERO', TOBref.GetValue('GL_NUMERO'));
  TOBL.PutValue('GL_REGIMETAXE', TOBref.GetValue('GL_REGIMETAXE'));
  TOBL.PutValue('GL_REPRESENTANT', TOBref.GetValue('GL_REPRESENTANT'));
  TOBL.PutValue('GL_APPORTEUR', TOBref.GetValue('GL_APPORTEUR'));
  TOBL.PutValue('GL_VIVANTE', TOBref.GetValue('GL_VIVANTE'));
  TOBL.PutValue('GL_ESCOMPTE', TOBref.GetValue('GL_ESCOMPTE'));
  TOBL.PutValue('GL_REMISEPIED', TOBref.GetValue('GL_REMISEPIED'));
  TOBL.PutValue('GL_SAISIECONTRE', TOBref.GetValue('GL_SAISIECONTRE'));
  TOBL.PutValue('GL_DOMAINE', TOBref.GetValue('GL_DOMAINE'));
  {Affaires}
  TOBL.PutValue('GL_AFFAIRE', TOBref.GetValue('GL_AFFAIRE'));
  TOBL.PutValue('GL_AFFAIRE1', TOBref.GetValue('GL_AFFAIRE1'));
  TOBL.PutValue('GL_AFFAIRE2', TOBref.GetValue('GL_AFFAIRE2'));
  TOBL.PutValue('GL_AFFAIRE3', TOBref.GetValue('GL_AFFAIRE3'));
  TOBL.PutValue('GL_AVENANT', TOBref.GetValue('GL_AVENANT'));
//
  TOBL.putValue('GL_NIVEAUIMBRIC',1);
  TOBL.putValue('GL_LIBELLE',traduireMemoire('Frais de chantier'));
end;


procedure AjouteFinparagFrais (TOBfrais : TOB);
var TOBL,TOBRef : TOB;
begin
  if TOBFrais.detail.count = 0 then Exit;
	TOBref := TOBFrais.detail[0];
	TOBL:=NewTobLigne(TOBFrais,0);
//	TOBL := TOB.Create ('LIGNE',TOBFrais,-1);
  InitialiseLigne (TOBL,TOBfrais.detail.count-1,0);
  TOBL.putValue('GL_TYPELIGNE','TP1');
  TOBL.PutValue('GL_NATUREPIECEG', TOBRef.GetValue('GL_NATUREPIECEG'));
  TOBL.PutValue('GL_SOUCHE', TOBRef.GetValue('GL_SOUCHE'));
  TOBL.PutValue('GL_NUMERO', TOBRef.GetValue('GL_NUMERO'));
  TOBL.PutValue('GL_INDICEG', TOBRef.GetValue('GL_INDICEG'));
  TOBL.putValue('GL_TIERS',TOBref.getValue('GL_TIERS'));
//
  TOBL.PutValue('GL_TIERSFACTURE', TOBref.GetValue('GL_TIERSFACTURE'));
  TOBL.PutValue('GL_TIERSLIVRE', TOBref.GetValue('GL_TIERSLIVRE'));
  TOBL.PutValue('GL_TIERSPAYEUR', TOBref.GetValue('GL_TIERSPAYEUR'));
  TOBL.PutValue('GL_TARIFSPECIAL', TOBref.GetValue('GL_TARIFSPECIAL'));
  TOBL.PutValue('GL_TARIFTIERS', TOBref.GetValue('GL_TARIFTIERS')); //mcd 20/01/03 oubli ...
  TOBL.PutValue('GL_DATEPIECE', TOBref.GetValue('GL_DATEPIECE'));
  TOBL.PutValue('GL_NATUREPIECEG', TOBref.GetValue('GL_NATUREPIECEG'));
  TOBL.PutValue('GL_ETABLISSEMENT', TOBref.GetValue('GL_ETABLISSEMENT'));
  TOBL.PutValue('GL_FACTUREHT', TOBref.GetValue('GL_FACTUREHT'));
  TOBL.PutValue('GL_DEVISE', TOBref.GetValue('GL_DEVISE'));
  TOBL.PutValue('GL_TAUXDEV', TOBref.GetValue('GL_TAUXDEV'));
  TOBL.PutValue('GL_COTATION', TOBref.GetValue('GL_COTATION'));
  TOBL.PutValue('GL_NUMERO', TOBref.GetValue('GL_NUMERO'));
  TOBL.PutValue('GL_REGIMETAXE', TOBref.GetValue('GL_REGIMETAXE'));
  TOBL.PutValue('GL_REPRESENTANT', TOBref.GetValue('GL_REPRESENTANT'));
  TOBL.PutValue('GL_APPORTEUR', TOBref.GetValue('GL_APPORTEUR'));
  TOBL.PutValue('GL_VIVANTE', TOBref.GetValue('GL_VIVANTE'));
  TOBL.PutValue('GL_ESCOMPTE', TOBref.GetValue('GL_ESCOMPTE'));
  TOBL.PutValue('GL_REMISEPIED', TOBref.GetValue('GL_REMISEPIED'));
  TOBL.PutValue('GL_SAISIECONTRE', TOBref.GetValue('GL_SAISIECONTRE'));
  TOBL.PutValue('GL_DOMAINE', TOBref.GetValue('GL_DOMAINE'));
  {Affaires}
  TOBL.PutValue('GL_AFFAIRE', TOBref.GetValue('GL_AFFAIRE'));
  TOBL.PutValue('GL_AFFAIRE1', TOBref.GetValue('GL_AFFAIRE1'));
  TOBL.PutValue('GL_AFFAIRE2', TOBref.GetValue('GL_AFFAIRE2'));
  TOBL.PutValue('GL_AFFAIRE3', TOBref.GetValue('GL_AFFAIRE3'));
  TOBL.PutValue('GL_AVENANT', TOBref.GetValue('GL_AVENANT'));
//
  TOBL.putValue('GL_NIVEAUIMBRIC',1);
  TOBL.putValue('GL_LIBELLE',traduireMemoire('Total frais de chantier'));
end;

procedure IncrementeLesNiveaux  (TOBfrais : TOB) ;
var TOBL : TOB;
		Indice,TheNiveau : integer;
    TheParag : string;
begin
	for Indice := 0 to TOBfrais.detail.count -1 do
  begin
  	TOBL := TOBfrais.detail[Indice];
    if IsParagraphe (TOBL) then
    begin
       TheNiveau := TOBL.getValue('GL_NIVEAUIMBRIC');
       TheParag := Copy(TOBL.GEtValue('GL_TYPELIGNE'),1,2);
       Inc (TheNiveau);
       TOBL.PutValue('GL_NIVEAUIMBRIC',TheNiveau);
       TOBL.PutValue('GL_TYPELIGNE',TheParag+InttoStr(TheNiveau));
    end;
  end;
end;

procedure AjouteDebutFinFrais (TOBFrais : TOB);
begin
  IncrementeLesNiveaux(TOBFrais);
  AjouteDebutparagFrais (TOBfrais);
  AjouteFinparagFrais (TOBfrais);
end;

procedure AglPlannificationChantier (Parms : array of variant ; nb : integer) ;
var
TobPiece,TOBOuvrage,TOBArticles,TOBFrais,TOBOuvrageFrais,TOBBasesL:TOB;
TheAction : TActionFiche;
Sql:string;
CleDocAffaire,Cledoc : R_CleDoc;
//Naturepiece,souche,datepiece : string;
{Numeropiece,Indice,}IndiceOuv : integer;
Q : Tquery;
begin

{$IFNDEF LINE}
  if not ExistReplacePou then exit;
{$ENDIF}

  IndiceOuv := 1;
  
  CleDocAffaire.NaturePiece:= string(Parms[1]);
  CleDocAffaire.datePiece  := strToDate(Parms[2]);
  CleDocAffaire.Souche     := string(Parms[3]);
  CleDocAffaire.NumeroPiece:= longint(Parms[4]);
  CleDocAffaire.indice     := longint(Parms[5]);

  // on cr�e une TOB de toutes les pieces s�lectionn�es
  TobPiece := TOB.Create ('PIECE',NIL, -1);
  TOBOuvrage := TOB.Create ('LIGNEOUV',nil,-1);
  TobFrais := TOB.Create ('PIECE',NIL, -1);
  TOBOuvrageFrais := TOB.Create ('LIGNEOUV',nil,-1);
  TOBBasesL := TOB.create ('LES LIGNEBASE',nil,-1);
//  TOBArticles := TOB.Create ('ARTICLES',nil,-1);
  try
    // Piece
    SourisSablier;
    Q:=OpenSQL ('SELECT * FROM PIECE WHERE '+ WherePiece(CleDocAffaire,ttdPiece,False),True,-1,'',true) ;
    TobPiece.selectDB ('',Q);
    Ferme(Q) ;
    Q:=OpenSQL ('SELECT * FROM LIGNEBASE WHERE '+WherePiece(CleDocAffaire,ttdLigneBase,False),True,-1,'',true) ;
    TobBasesL.loadDetailDb ('LIGNEBASE','','',Q,false);
    Ferme(Q) ;
    if PieceNonMiseAJourOptimise (TOBPiece,TOBBasesL) then BEGIN PgiBox('Veuillez recalculer la pi�ce pr�alablement.'); exit; END;
    if ControleChantierBTP (TOBPiece,BTTModif) then
    begin
      if TOBPiece.getValue('GP_AFFAIRE')<>'' then
      begin
      // Lignes de document
      Sql := MakeSelectLigneBtp (true,false,false);
      Sql := Sql + ' WHERE ' + WherePiece(CleDocAffaire, ttdLigne,false) + ' ORDER BY GL_NUMLIGNE';
      Q:=OpenSQL (SQL,True,-1,'',true) ;
      TOBPiece.LoadDetailDB ('LIGNE','','',Q,True,true) ;
      Ferme(Q) ;
      // --
      // Recup des frais detaill�s
      // --
      if TOBPiece.detail.count > 0 then
      begin
//      	if TOBpiece.detail[0].GetValue('GL_PIECEORIGINE')<> '' then
        RetrouvePieceFraisBtp (Cledoc,TOBpiece,TheAction);
    		if (Cledoc.NumeroPiece <> 0) then
        begin
//          DecodeRefPiece (TOBpiece.detail[0].GetValue('GL_PIECEORIGINE'),cledoc);
//          cledoc.naturePiece := 'FRC'; // frais de chantier
          Q:=OpenSQL ('SELECT * FROM PIECE WHERE '+WherePiece(CleDoc,ttdPiece,False),True,-1,'',true) ;
          TobFrais.selectDB ('',Q);
          Ferme(Q) ;
          Sql := MakeSelectLigneBtp (true,false,false);
          Sql := Sql + ' WHERE ' + WherePiece(cledoc, ttdLigne,false) + ' ORDER BY GL_NUMLIGNE';
      		Q:=OpenSQL (SQL,True,-1,'',true) ;
      		TOBFrais.LoadDetailDB ('LIGNE','','',Q,True,true) ;
      		Ferme(Q) ;
          AjouteDebutFinFrais (TOBFrais);
      		ChargeLesOuvrages (TOBFrais,TOBOuvrageFrais,cledoc);
        end;
      end;
      // --
(*      LoadLesOuvrages (TOBPIece,TOBOuvrage,TOBArticles,cledocAffaire,IndiceOuv); *)
      ChargeLesOuvrages (TOBPIece,TOBOuvrage,cledocAffaire);
      // --
      SourisNormale ;
      SetPlannification(TOBPiece,TOBOuvrage,TOBFrais,TOBOuvrageFrais);
      end else
      begin
        PgiInfo ('On ne peut pas g�n�rer de pr�vision de chantier sur un devis non rattach� � un chantier');
      end;
    end;
  finally
    SourisNormale ;
    TobPiece.Free;
    TOBOuvrage.free;
    TobFrais.Free;
    TOBBasesL.free;
    TOBOuvrageFrais.free;
//    TOBARticles.free;
  end;
end;

procedure SaisieAvancementChantier (NaturePiece, Datepiece, Souche, Tiers, AffaireRef : String; NumeroPiece, Indice : integer; Action : TActionFiche ) ;
var
  CleDocAffaire : R_CleDoc;
  EtatPrec,NewEtat:string;
begin
  CleDocAffaire.NaturePiece:= NaturePiece;
  CleDocAffaire.datePiece  := strToDate(Datepiece);
  CleDocAffaire.Souche     := Souche;
  CleDocAffaire.NumeroPiece:= NumeroPiece;
  CleDocAffaire.indice     := indice;

  // on positionne la pi�ce comme vivante pour saisir les avancements
  if PositionnePieceMorteVivante (naturepiece,souche,numeropiece,indice,'X',EtatPrec) then
     BEGIN
     SaisieAvancementAcompte( False,False,Nil,CleDocAffaire,Action,Tiers,AffaireRef,'',True);
     newEtat := EtatPrec;
     // on remet la pi�ce dans son �tat initial
     PositionnePieceMorteVivante (naturepiece,souche,numeropiece,indice,NewEtat,EtatPrec);
     END;

end;

procedure AglAvancementChantier (Parms : array of variant ; nb : integer) ;
begin
  SaisieAvancementChantier (Parms[1],Parms[2],Parms[3],Parms[6],Parms[7],longint(Parms[4]),longint(Parms[5]),Tamodif);
end;

{ AcceptationDocument }

constructor TAcceptationDocument.Create;
begin
CreateTobs;
Result := false;
end;

destructor TAcceptationDocument.Destroy;
begin
  inherited;
LibereTobs;
end;

procedure TAcceptationDocument.CreateTobs;
begin
// Creation des tobs
TobPiece := Tob.Create ('PIECE', nil,-1);
TOBTiers := TOB.create ('TIERS',nil,-1);
TOBAcomptes := TOB.create ('LACOMPTE',nil,-1);
TOBPieceRG := TOB.Create ('LESRETENUES',nil,-1);
TOBBAsesRg := TOB.Create ('LESBASESRG',nil,-1);
TOBAcomptes_O := TOB.create ('LES ACOMPTES',nil,-1);
end;

procedure TAcceptationDocument.LibereTOBS;
begin
TOBTiers.free; TOBTiers := nil;
TOBPiece.free; TOBPiece := nil;
TOBAcomptes.free; TOBAcomptes := nil;
TOBAcomptes_O.free; TOBAcomptes_O := nil;
TOBPieceRG.free; TOBPieceRG := nil;
TOBBasesRG.free; TOBBasesRG := nil;
end;

procedure TAcceptationDocument.ChargeLesTObs;
begin
// Remplissage des tobs
Sql := '"'+ NaturePiece
       + '";"'+ Souche
       + '";"'+ inttostr(Numero)
       + '";"'+ inttostr(Indice) + '"';
TobPiece.selectDB (sql, Nil, False);

FillChar(CleDoc,Sizeof(CleDoc),#0) ;
CleDoc.NaturePiece:= TOBPIECE.GetValue('GP_NATUREPIECEG');
CleDoc.DatePiece:= TOBPIECE.GetValue('GP_DATEPIECE');
CleDoc.Souche:= TOBPIECE.GetValue('GP_SOUCHE');
CleDoc.NumeroPiece:= TOBPIECE.GetValue('GP_NUMERO');
CleDoc.Indice:= TOBPIECE.GetValue('GP_INDICEG');
// --
QQ := opensql('SELECT * FROM TIERS WHERE T_TIERS="'+Tiers+'"',true,-1,'',true);
TOBTIers.selectdb ('',QQ);
ferme (QQ);
LoadLesRetenues (TOBPiece,TOBPieceRG,TOBBasesRG,CleDoc);
LoadLesAcomptes(TOBPiece,TOBAcomptes,CleDoc) ;
TOBACOmptes_O.Dupliquer (TOBAcomptes,true,true);
end;

procedure TAcceptationDocument.DemandeAcompte;
var TOBACC : TOB;
    LibelleDocument : string;           
    ret : string;
begin
// Si il existe un acompte rattache inutile de demander l'acompte
if (TOBAcomptes.detail.count > 0) and (not pass) then BEGIN result:= true; Exit; END;
//
TobAcc:=Tob.Create('Les acomptes',nil,-1) ;
Tob.Create('',TobAcc,-1);
TobAcc.Detail[0].Dupliquer(TobTiers,False,TRUE,TRUE);
Tob.Create('',TobAcc.Detail[0],-1);
TobAcc.Detail[0].Detail[0].Dupliquer(TobPiece,False,TRUE,TRUE);
TheTob:=TobAcc ;
TOBAcomptes.ChangeParent(TobAcc.Detail[0].Detail[0],-1);
TheTob.data := TOBPieceRG;
LibelleDocument := 'Saisie d''acompte pour le document '+inttostr(Numero);
// ---
ret := AGLLanceFiche('BTP','BTACOMPTES','','','ACTION=CREATION;LIBELLE='+LibelleDocument) ;
TOBAcomptes.ChangeParent(nil,-1);
TobAcc.Free;
if TOBAcomptes.detail.count > 0 then
   begin
   if Transactions(ValideLaPieceAcompte,1)= oeOk then Result := true;
   end;
end;

procedure TAcceptationDocument.GereReglements;
var TOBAcc: TOB;
  StRegle: string;
  LibelleDocument : string;           
begin
  TobAcc:=Tob.Create('Les acomptes',nil,-1) ;
  Tob.Create('',TobAcc,-1);
  TobAcc.Detail[0].Dupliquer(TobTiers,False,TRUE,TRUE);
  Tob.Create('',TobAcc.Detail[0],-1);
  TobAcc.Detail[0].Detail[0].Dupliquer(TobPiece,False,TRUE,TRUE);
  TheTob:=TobAcc ;
  TOBAcomptes.ChangeParent(TobAcc.Detail[0].Detail[0],-1);
  TheTob.data := TOBPieceRG;
  LibelleDocument := 'Saisie d''acompte pour le document '+inttostr(Numero);
  // ---
  StRegle := ';ISREGLEMENT=X';
  AGLLanceFiche('BTP', 'BTACOMPTES', '', '', 'ACTION=CREATION;ISREGLEMENT=X;LIBELLE='+LibelleDocument);
  TOBAcomptes.ChangeParent(nil, -1);
  TobAcc.Free;
  if Transactions(ValideLaPieceAcompte,0)= oeOk then Result := true;
end;

procedure TAcceptationDocument.ValideLaPieceAcompte;
begin
// nettoyage
if TOBAcomptes_O.detail.count > 0 then if not TOBAComptes_O.DeleteDB then V_PGI.IOError := OeUnknown;
//
ValideLesAcomptes (TOBPiece,TOBAcomptes);
if V_PGI.IOError = OEOk then if not TOBPiece.UpdateDb (false) then V_PGI.IOError := OEUnknown;
if (V_PGI.IOError = OEOk) and (TOBAcomptes.detail.count > 0) then if not MajMontantAcompte(TOBPiece,TOBAcomptes) then V_PGI.IOError := OEUnknown;
end;

procedure AglGenereContreEtude (Parms : array of variant ; nb : integer) ;
var
TobPiece,TOBOuvrage,TOBArticles,TOBBasesL:TOB;
Sql,Req:string;
CleDocAffaire,Cledoc : R_CleDoc;
IndiceOuv : integer;
Q : Tquery;
begin
  if not ExistReplacePou then exit;
  IndiceOuv := 1;
  CleDocAffaire.NaturePiece:= string(Parms[1]);
  CleDocAffaire.datePiece  := strToDate(Parms[2]);
  CleDocAffaire.Souche     := string(Parms[3]);
  CleDocAffaire.NumeroPiece:= longint(Parms[4]);
  CleDocAffaire.indice     := longint(Parms[5]);
  // on cr�e une TOB de toutes les pieces s�lectionn�es
  TobPiece := TOB.Create ('PIECE',NIL, -1);
  TOBOuvrage := TOB.Create ('LIGNEOUV',nil,-1);
  TOBBasesL := TOB.Create('LES LIGNES BASES',nil,-1);
  try
    // Piece
    SourisSablier;
//
    Req := 'SELECT PIECE.*';
    req := req + ',AFF_GENERAUTO,AFF_OKSIZERO,AFF_ETATAFFAIRE AS ETATDOC FROM PIECE '+
                 'LEFT JOIN AFFAIRE ON AFF_AFFAIRE=GP_AFFAIREDEVIS ';
    Req := Req + 'WHERE ' + WherePiece(CleDocAffaire, ttdPiece, False);
    Q := OpenSQL(Req, True,-1, '', True);
    TobPiece.SelectDb ('',Q);
//
    Ferme(Q) ;
    Q:=OpenSQL ('SELECT * FROM LIGNEBASE WHERE '+WherePiece(CleDocAffaire,ttdLigneBase,False),True,-1,'',true) ;
    TobBasesL.loadDetailDb ('LIGNEBASE','','',Q,false);
    Ferme(Q) ;
    if PieceNonMiseAJourOptimise (TOBPiece,TobbasesL) then BEGIN PgiBox('Veuillez recalculer la pi�ce pr�alablement.'); exit; END;
    if TOBPiece.getValue('GP_AFFAIRE')<>'' then
    begin
      if ControleChantierBTP (TOBPiece,BTTModif) then
      begin
        // Lignes de document
        Sql := MakeSelectLigneBtp (true,false,false) +
             ' WHERE '+WherePiece(CleDocAffaire,ttdligne,False)+
             ' ORDER BY GL_NUMLIGNE' ;
        Q:=OpenSQL (SQL,True,-1,'',true) ;
        TOBPiece.LoadDetailDB ('LIGNE','','',Q,True,true) ;
        Ferme(Q) ;
        // --
        PieceAjouteSousDetail (TOBPiece,true,false,true);
        ChargeLesOuvrages (TOBPIece,TOBOuvrage,cledocAffaire);
        // --
        SourisNormale ;
        SetContreEtude(TOBPiece,TOBOuvrage);
      end;
    end else
    begin
      PgiInfo ('On ne peut pas g�n�rer de contre-�tude d''un devis non rattach� � un chantier');
    end;
  finally
    SourisNormale ;
    TobPiece.Free;
    TOBOuvrage.free;
  	TOBBasesL.free;
  end;
end;

//////////////////////////////////////////////////////////////////////////////
procedure initM3Btp();
begin
 RegisterAglFunc( 'CreerPieceBTP',False,6,AGLCreerPieceBTP);
 RegisterAglProc( 'ValideAcceptDevis',True,4,AGLValideAcceptDevis);
 RegisterAglProc( 'ValidePrepaFactures',True,1,AGLValidePrepaFactures);
 RegisterAglProc( 'AfficheAvenant',True,0,AGLAfficheAvenant);
 RegisterAglProc( 'AccepteAppelOffre',True,0,AGLAccepteAppelOffre);
 RegisterAglProc( 'ChangementCodifArticle',True,1,AGLChangeCodeArticle);
 RegisterAglProc( 'PointageDemandeAct',True,1,AGLPointageDemandeAct);
 RegisterAglProc( 'ClotureTechnique',True,0,AGLClotureTechnique);
 RegisterAglProc( 'PlannificationChantier',True,5,AGLPlannificationCHantier);
 RegisterAglProc( 'AvancementChantier',True,7,AGLAvancementChantier);
 RegisterAglProc( 'GenereContreEtude',True,5,AglGenereContreEtude);
 RegisterAglFunc( 'AGLISMasterOnShared',False,0,AGLIsMasterOnShared);
 end;


Initialization
initM3Btp();
finalization
end.