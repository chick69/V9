{ Unit� : Source TOF de la FICHE : TRMULVIREMENT
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 0.91          02/10/03  JP   Cr�ation de l'unit�
 1.05.001.002  22/03/04  JP   V�rification que le compte de virments internes est
                              bien affect� aux flux d'�quilibrage
 1.2X.000.000  15/04/04  JP   Suppression de la simulation
                              Suppression de la r�alisation : maintenant toutes les �critures
                              li�es aux virements sont r�alis�es
                              Nouvelle gestion des natures (P, R, S)
 6.xx.xxx.xxx  20/07/04  JP   Gestion des commissions dans la r�alisation et l'int�gration
                              cf BComptaClick
 6.01.003.001  16/11/04  JP   FQ 10182 : Suppression des transactions lors de l'int�gration en comptabilit�
 6.30.001.002  02/03/05  JP   FQ 10210 : les commissions ne sont pas distingu�es des virements, ce qui fait
                              que lors de l'int�gration en comptabilit� on ne tient pas compte du compte de
                              contrepartie du flux commission et l'on met d'office le "Compte poublelle" (580xxx)
 6.50.001.003  23/03/05  JP   FQ 10223 : nouvelle gestion des messages d'erreur lors de la g�n�ration d'�critute
                              REMARQUE : j'en profite pour mettre en place une int�gration bas�e sur des Tobs
                                         et non plus les structures TrEcriture (cf. PrepareIntegration)
 7.00.001.001  12/01/06  JP   FQ 10323 : Correction de la gestion de la TVA
 7.05.001.001  18/09/06  JP   Mise en place de l'int�gration Multi-soci�t�s
 7.05.001.001  20/09/06  JP   Correction de la g�n�ration des fichiers
                              Ajout du bouton SelectAll
 8.10.001.004  08/08/07  JP   Gestion des confidentialit�s
--------------------------------------------------------------------------------------}
unit TRMULVIREMENT_TOF ;

interface

uses
  {$IFDEF VER150} variants,{$ENDIF}
  StdCtrls, Controls, Classes, Constantes, HStatus, CFONB, ParamSoc, FileCtrl,
  {$IFNDEF EAGLCLIENT}
  db, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} mul, FE_Main, HDB,
  {$ELSE}
  eMul, MaineAGL,
  {$ENDIF}
  {$IFDEF TRCONF}
  ULibConfidentialite,
  {$ENDIF TRCONF}
  uTob, Forms, SysUtils, ComCtrls, HCtrls, HEnt1, HMsgBox, UTOF, HTB97,
  Menus, UObjGen, ULibPieceCompta;

type
  {$IFDEF TRCONF}
  TOF_TRMULVIREMENT = class (TOFCONF)
  {$ELSE}
  TOF_TRMULVIREMENT = class (TOF)
  {$ENDIF TRCONF}
    procedure OnArgument(S : string); override;
    procedure OnLoad                ; override;
    procedure OnClose               ; override;
  private
    {$IFDEF EAGLCLIENT}
    FListe  : THGrid;
    {$ELSE}
    FListe  : THDBGrid;
    {$ENDIF}
    ckCompta  : TCheckBox;
    TobCompta : TobPieceCompta;
    lTransfert: TStringList;
    CodeFluxD : string;
    CodeFluxR : string;
    Montant   : Double;
    Remise    : string;
    NatEco    : string;
    Imputation: string;
    CodeVir   : string;
    DateTrait : string;
    CodePays  : string;
    RecSoc    : TInfosSoc;
    SCompte   : TCompte;
    DCompte   : TCompte;
    RecInf    : TInfosCFONB;
    RecTsf    : TTransfert;
    NumE      : Integer;
    CptePoubelle : string;
    TransfertOk  : Boolean;
    CheminVirement : string;
    ListeFichier : TStringList; {20/09/06}
    OldClef      : string; {20/09/06}
    OldDossier   : string; {20/09/06}
    CodeEuro     : string; {20/09/06}
    MsgErreur    : string;
    NomFichier   : string;

    {G�n�ration de virements}
    procedure RecupeInfoSoc(NomBase : string; SocOk : Boolean);
    procedure InitRecord   (NomBase : string; SocOk : Boolean);
    function  PutBanqueSource : Boolean;
    function  PutBanqueDest   : Boolean;
    function  PutTotal        : Boolean;
    function  CreerVirement   : Boolean;
    function  FinirVirement   : Boolean;
    function  PrepareVirement : Boolean;

    procedure BDeleteClick  (Sender : TObject);
    procedure BFichierClick (Sender : TObject);
    procedure BComptaClick  (Sender : TObject);
    procedure ListeDblClick (Sender : TObject);
    procedure MenuOnPopup   (Sender : TObject);
    procedure ckCochesClick (Sender : TObject);
    procedure BanqueChange  (Sender : TObject);
    procedure DeviseOnChange(Sender : TObject);
    procedure SlctAllClick  (Sender : TObject);
  end ;

procedure TRLanceFiche_MulVirements(Dom, Fiche, Range, Lequel, Arguments: string);

implementation

uses
  EQUILIBRAGE_TOM, Commun, UtilPGI, UProcEcriture, UProcCommission, UProcSolde, ExtCtrls{TImage},
  UProcGen {StrToChr}, cbpPath;

const
  GENWHERE = 'TEQ_FICEXPORT = "X"';
  CPTWHERE = 'TE_USERCOMPTABLE <> "" AND TE_USERCOMPTABLE IS NOT NULL';
  NOTCPTWH = 'TE_USERCOMPTABLE = "" OR TE_USERCOMPTABLE IS NULL';

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_MulVirements(Dom, Fiche, Range, Lequel, Arguments: string);
{---------------------------------------------------------------------------------------}
begin
  AglLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.OnArgument (S : String ) ;
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  c : string;
begin
  inherited;
  Ecran.HelpContext := 50000130;
  TPopupMenu(GetControl('POPMENU')).OnPopup := MenuOnPopup;

  ckCompta  := TCheckBox(GetControl('CKCOMPTA'));
  ckCompta .OnClick := ckCochesClick;

  TToolbarButton97(GetControl('BFICV')).OnClick := BFichierClick;
  TToolbarButton97(GetControl('BCPTA')).OnClick := BComptaClick;
  {Seul un superviseur peut r�aliser les �critures}
  {Si on filtre sur les virements d�j� int�gr�s, il est inutile de lancer l'int�gration
   18/10/06 : gestion des droits sur l(int�gration en compta}
  SetControlEnabled('BCPTA', AutoriseFonction(dac_Integration));

  TPopupMenu(GetControl('POPMENU')).Items[0].OnClick := BDeleteClick;
  TPopupMenu(GetControl('POPMENU')).Items[1].OnClick := BFichierClick;
  TPopupMenu(GetControl('POPMENU')).Items[2].OnClick := BComptaClick;
  AddMenuPop(TPopupMenu(GetControl('POPMENU')), '', '');

  {R�cup�ration du chemin par d�faut}
  CheminVirement := GetParamSocSecur('SO_CPCHEMINVIREMENT', TcbpPath.GetCegidUserLocalAppData);
  SetControlText('OUTPUTPATH', CheminVirement);
  SetControlText('EDREMISE', 'EQUILIBRAGE');

  TobCompta := TobPieceCompta.Create('***', nil, -1);
  lTransfert:= TStringList.Create;

  THValComboBox(GetControl('TEQ_SBANQUE')).OnChange := BanqueChange;

  TToolbarButton97(GetControl('BDELETE')).OnClick := BDeleteClick;
  {$IFDEF EAGLCLIENT}
  FListe := THGrid(GetControl('FLISTE'));
  {$ELSE}
  FListe := THDBGrid(GetControl('FLISTE'));
  {$ENDIF}
  FListe.OnDblClick := ListeDblClick;

  {20/09/06 : Gestion du bouton BSelectAll}
  SetControlVisible('BSELECTALL', True);
  TToolbarButton97(GetControl('BSELECTALL')).OnClick := SlctAllClick;

  {05/10/04 : gestion du drapeau}
  THValComboBox(GetControl('TEQ_DEVISE')).OnChange := DeviseOnChange;

  {20/09/06 : Plut�t que de passer par un TextFile, il me parait plus simple de passer par une StrinList}
  ListeFichier := TStringList.Create;

  Q := OpenSQL('SELECT D_DEVISE FROM DEVISE WHERE D_CODEISO = "EUR"', True);
  if not Q.EOF then
    CodeEuro := Q.FindField('D_DEVISE').AsString;
  if CodeEuro = '' then CodeEuro := 'EUR';
  Ferme(Q);

  c := FiltreBanqueCp(THEdit(GetControl('TEQ_SGENERAL')).DataType, '', '');
  THEdit(GetControl('TEQ_SGENERAL')).Plus := c;
  THEdit(GetControl('TEQ_DGENERAL')).Plus := c;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.OnClose;
{---------------------------------------------------------------------------------------}
begin
  if Assigned(TobCompta) then FreeAndNil(TobCompta);
  if Assigned(lTransfert) then FreeAndNil(lTransfert);
  if Assigned(ListeFichier) then FreeAndNil(ListeFichier); {20/06/09}
  inherited;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.OnLoad;
{---------------------------------------------------------------------------------------}
{$IFDEF TRCONF}
var
  DConf : string;
  SConf : string;
  SQLConf : string;
{$ENDIF TRCONF}
begin
  inherited;
  {$IFDEF TRCONF}
  DConf := '';
  SConf := '';
  SQLConf := TObjConfidentialite.GetWhereConf(V_PGI.User, tyc_Banque);
  if SQLConf <> '' then SQLConf := ' AND (' + SQLConf + ') ';
  DConf   := TrTrouveEtRemplace(SQLConf, 'BQ', 'BSBQ', True);
  SConf   := TrTrouveEtRemplace(SQLConf, 'BQ', 'BDBQ', True);
  XX_WHERECONF.Text := DConf + SConf;
  {$ENDIF TRCONF}
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.BanqueChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  THEdit(GetControl('TEQ_SGENERAL')).Plus := FiltreBanqueCp(THEdit(GetControl('TEQ_SGENERAL')).DataType, '', '');
  if GetControlText('TEQ_SBANQUE') <> '' then  
    THEdit(GetControl('TEQ_SGENERAL')).Plus := THEdit(GetControl('TEQ_SGENERAL')).Plus + ' AND BQ_BANQUE = "' + GetControlText('TEQ_SBANQUE') + '"';
  SetControlText('TEQ_SGENERAL', '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.BDeleteClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  p, n : Integer;
  SQL  : string;
  MsgO : Boolean;
  S, D : string;
  GS, GD : string;
  DS, DD : string;
  dCreaT : string;
begin
  n := FListe.NbSelected;
  MsgO := False;

  if n = 0 then begin
    HShowMessage('0;' + Ecran.Caption + ';Veuillez selectionner un virement !;W;O;O;O;', '', '');
    Exit;
  end;
  InitMove(n, 'Suppression de virement');
  try
    for P := 0 to n - 1 do begin
      FListe.gotoLeBookmark(p);
      S := GetField('TEQ_CLESOURCE');
      D := GetField('TEQ_CLEDESTINATION');
      GS := GetField('TEQ_SGENERAL');
      GD := GetField('TEQ_DGENERAL');
      DS := GetField('TEQ_SNODOSSIER');
      DD := GetField('TEQ_DNODOSSIER');
      dCreat := GetField('TEQ_DATECREATION');

      MoveCur(False);
      {On s'assure que l'une des deux �critures associ�es au virement n'a pas �t� inject�es en comptabilit�}
      SQL := 'SELECT TE_NATURE FROM TRECRITURE WHERE ' + CPTWHERE + ' AND TE_CLEOPERATION IN ("' + S + '", "' + D + '")';
      {Dans ce cas on ne peut supprimer le virement li�}
      if ExisteSQL(SQL) then begin
        if not MsgO then begin
          HShowMessage('1;' + Ecran.Caption + ';Certaines �critures li�es aux virements on �t� int�gr�es en compta.' +
                       'Ces virements ne pourront �tre supprim�s !;W;O;O;O;', '', '');
          MsgO := True;
        end;
      end
      else begin
        BeginTrans;
        try
          {Les �critures rattach�es au virement ne sont pas r�alis�es, on peut supprim� le virement}
          SQL := 'DELETE FROM EQUILIBRAGE WHERE TEQ_NUMEQUI = ' + VarToStr(GetField('TEQ_NUMEQUI'));
          ExecuteSQL(SQL);
          {La fonction recherche le num�ro de transaction qui est le m�me pour les deux �critures :
           il suffit de lui passer indiff�remment une seule clef}
          if not SupprimePiece(DS, '', '', S) then Abort;
          {Si les dossiers source et destination sont identiques, cela signifie que l'on n'est pas en
           mono soci�t� ou que l'on fait un virement au sein de la m�me soci�t� => le num�ro de transaction
           est donc le m�me pour tous les virements => pas besoin de lancer une double suppression}
          {25/09/06 : en Multi dossiers, il faut g�rer le NoDossier}
          if DS <> DD then
            if not SupprimePiece(DD, '', '', D) then Abort;

          {21/07/04 : ajout de ce petit oubli}
          RecalculSolde(GS, dCreat, 0, True);
          RecalculSolde(GD, dCreat, 0, True);
          CommitTrans;
        except
          on E : Exception do begin
            HShowMessage('2;' + Ecran.Caption + ';Impossible de supprimer le virement n� ' +
                         VarToStr(GetField('TEQ_NUMEQUI')) + ' ou les �critures correspondantes.;E;O;O;O;',  '', '');
            RollBack;
          end;
        end;
      end;
    end;
  finally
    FiniMove;
  end;

  FListe.ClearSelected;
  FListe.Refresh;
  {Raffraichissement du mul}
  TFMul(Ecran).BCherche.Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.ListeDblClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TRLanceFiche_DetailVirement('TR', 'TRFICVIREMENT', '', GetField('TEQ_NUMEQUI'), '');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.BFichierClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  if (TFMul(Ecran).FListe.NbSelected = 0)
  {$IFNDEF EAGLCLIENT}
  and not TFMul(Ecran).FListe.AllSelected
  {$ENDIF}
  then begin
    HShowMessage('2;' + Ecran.Caption + ';Veuillez s�lectionner des virements !;W;O;O;O;', '', '');
    Exit;
  end;

  if not PrepareVirement then Exit;

  ListeFichier.Clear; {20/09/06}
  {20/09/06 : Stocke la rupture par fichier : Dossier|Banque|Devise}
  OldClef := '';

  {$IFNDEF EAGLCLIENT}
  TFMul(Ecran).Q.First;
  if FListe.AllSelected then
    while not TFMul(Ecran).Q.EOF do begin
      if not CreerVirement then begin
        PgiError(MsgErreur);
        FListe.ClearSelected;
        Exit;
      end;
      TFMul(Ecran).Q.Next;
    end
  else
  {$ENDIF}
    for n := 0 to Fliste.nbSelected - 1 do begin
      Fliste.GotoLeBookmark(n);
      {$IFDEF EAGLCLIENT}
      TFMul(Ecran).Q.TQ.Seek(FListe.Row - 1);
      {$ENDIF}
      if not CreerVirement then begin
        PgiError(MsgErreur);
        FListe.ClearSelected;
        Exit;
      end;
    end;

  {Totalisation etEcriture du dernier fichier}
  FinirVirement;

  {09/06/04 : finitions !!}
  FListe.ClearSelected;
  PGIInfo(TraduireMemoire('Traitement termin�.'));
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.BComptaClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  n    : Integer;
  aTob : TOB; {23/03/05}
  g, s, c : string; {FQ 10182 : 16/11/04}
begin
  if not AutoriseFonction(dac_Integration) then begin
    HShowMessage('3;' + Ecran.Caption + ';Vous n''avez pas les droits pour cette fonctionnalit�.;I;O;O;O', '', '');
    Exit;
  end;

  TobCompta.ClearDetailPC;

  if FListe.nbSelected = 0 then begin
    HShowMessage('4;' + Ecran.Caption + ';Veuillez s�lectionner des virements !;W;O;O;O;', '', '');
    Exit;
  end;

  if (CodeFluxD = '') or (CodeFluxR = '') then begin
    {FQ 10182 : R�cup�ration des codes flux correspondant aux virements}
    CodeFluxD := CODETRANSACDEP;
    CodeFluxR := CODETRANSACREC;
  end;

  {Si les codes flux sont renseign�s, en th�orie les comptes de contre-parties sont bien renseign�s, car on fait
   un test sur la TomFluxTreso.OnUpdateRecord sur TFT_GENERAL. Ce compte est n�c�ssaire pour g�n�rer l'�criture
   de contrepartie en compta : on ne peut pas cr�er une pi�ce en compta avec compte A en d�bit et compte B en cr�dit.
   Les deux flux doivent avoir le m�me compte g�n�ral "poubelle" de sorte � �quilibrer la pi�ce en compta}
  if CptePoubelle = '' then begin
    {16/11/04 : FQ 10136 - 10182 : il est inutile de passer par les transactions. Si j'avais fais la modification dans la
                TofVirement, je l'avais oubli� ici}
    GetCibSensGeneral(g, s, c, CODETRANSACDEP);
    CptePoubelle := g;
    {JP 22/03/04 : Ce test manquait}
    if CptePoubelle = '' then begin
      HShowMessage('5;' + Ecran.Caption + ';Il n''y a pas de compte de virement interne attach� aux flux d''�quilibrage.'#13 +
                   'Les virements ne seront pas int�gr�s en comptabilit�;W;O;O;O;', '', '');
      Exit;
    end;

    {16/11/04 : FQ 10136 - 10182 : il est inutile de passer par les transactions. Si j'avais fais la modification dans la
                TofVirement, je l'avais oubli� ici}
    GetCibSensGeneral(g, s, c, CODETRANSACDEP);
    if (CptePoubelle <> g) then begin
      HShowMessage('6;' + Ecran.Caption + ';Les comptes g�n�raux des flux d''�quilibrage sont diff�rents.'#13 +
                   'Les virements ne seront pas int�gr�s en comptabilit�;W;O;O;O;', '', '');
      Exit;
    end;
  end;

  {30/05/05 : FQ 10223 : Initialisation des structures d'erreurs}
  InitGestionErreur(CatErr_CPT);

  InitMove(FListe.nbSelected, 'Int�gration en comptabilit�');
  {23/03/05 : Suppression des structures et remplacement par des tobs}
  aTob := TOB.Create('���', nil, -1);
  try
    {$IFNDEF EAGLCLIENT}
    TFMul(Ecran).Q.First;
    if FListe.AllSelected then
      while not TFMul(Ecran).Q.EOF do begin
        {20/07/04 : r�alisation des �critures de commissions rattach�es}
        aTob.LoadDetailFromSQL('SELECT * FROM TRECRITURE WHERE TE_NUMTRANSAC IN (SELECT TE_NUMTRANSAC FROM ' +
                               'TRECRITURE WHERE TE_CLEOPERATION = "' + TFMul(Ecran).Q.FindField('TEQ_CLESOURCE').AsString + '" ' +
                               'AND NOT (TE_NUMTRANSAC LIKE "' + CODEMODULECOU + '%")) ' +
                               'ORDER BY TE_NUMEROPIECE, TE_NUMLIGNE');
        {18/09/06 : Nouvelle int�gration des �critures en comptabilit� (gestion du multi-soci�t�s)}
        TRGenererPieceCompta(TobCompta, aTob);

        TFMul(Ecran).Q.Next;
      end
    else
    {$ENDIF}

      for n := 0 to FListe.nbSelected - 1 do begin
        FListe.GotoLeBookmark(n);
        {$IFDEF EAGLCLIENT}
        TFMul(Ecran).Q.TQ.Seek(FListe.Row - 1);
        {$ENDIF}
        MoveCur(False);

        {20/07/04 : r�alisation des �critures de commissions rattach�es}
        aTob.LoadDetailFromSQL('SELECT * FROM TRECRITURE WHERE TE_NUMTRANSAC IN (SELECT TE_NUMTRANSAC FROM ' +
                               'TRECRITURE WHERE TE_CLEOPERATION = "' + GetField('TEQ_CLESOURCE') + '" ' +
                               'AND NOT (TE_NUMTRANSAC LIKE "' + CODEMODULECOU + '%")) ' +
                               'ORDER BY TE_NUMEROPIECE, TE_NUMLIGNE');
        {18/09/06 : Nouvelle int�gration des �critures en comptabilit� (gestion du multi-soci�t�s)}
        TRGenererPieceCompta(TobCompta, aTob);
      end;
  finally
    if Assigned(aTob)   then FreeAndNil(aTob);
    FiniMove;
  end;

  {30/05/05 : FQ 10223 : Gestion des messages d'erreur}
  if not AfficheMessageErreur(Ecran.Caption, 'Certains virements n''ont pu �tre int�gr�s en comptabilit� : ') then begin
    if TobCompta.Detail.Count > 0 then
    {Maintenant que l'on a les �critures au format de la compta dans la tobCompta,
     on lance le processus d'int�gration en comptabilit� proprement dit}
    {18/09/06 : Nouvelle fonction de traitement Multi-soci�t�s}
    TRIntegrationPieces(TobCompta, False)
    else
       HShowMessage('7;' + Ecran.Caption + ';Aucune �criture n''a �t� int�gr�e.'#13 +
                       ' Veuillez v�rifier que les �critures li�es aux virements s�lectionn�s :'#13 +
                       '    1/ sont r�alis�es.'#13 +
                       '    2/ correspondent � un exercice ouvert en comptabilit�.'#13 +
                       '    3/ n''ont pas d�j� �t� int�gr�es.;I;O;O;O;', '', '');
  end;

  {Rafra�chissement du mul}
  TFMul(Ecran).BCherche.Click;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.MenuOnPopup(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  TPopupMenu(GetControl('POPMENU')).Items[2].Enabled := GetControlEnabled('BCPTA');
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.ckCochesClick(Sender : TObject);
{---------------------------------------------------------------------------------------}
var
  Clause : string;
begin
  Clause := GENWHERE;

  case ckCompta.State of
    cbUnchecked : Clause := Clause + ' AND ' + NOTCPTWH;
    cbChecked   : Clause := Clause + ' AND ' + CPTWHERE;
    cbGrayed    : ;
  end;

  {Si on filtre sur les virements d�j� int�gr�s, il est inutile de lancer l'int�gration
   18/10/06 : gestion des droits sur l(int�gration en compta}
  SetControlEnabled('BCPTA', not ckCompta.Checked and AutoriseFonction(dac_Integration));

  SetControlText('XX_WHERE', Clause);
  TFMul(Ecran).BCherche.Click;
end;


{---------------------------------------------------------------------------------------}
function TOF_TRMULVIREMENT.PrepareVirement : Boolean;
{---------------------------------------------------------------------------------------}
var
  n : Integer;
begin
  Result := False;
  
  {Gestion du fichier}
  CheminVirement := GetControlText('OUTPUTPATH');
  {On s'assure que l'emplacement du fichier est d�fini}
  if Trim(CheminVirement) = '' then begin
    HShowMessage('8;' + Ecran.Caption + ';Vous devez choisir r�pertoire pour les fichiers de virements !;W;O;O;O;', '', '');
    TFMul(Ecran).Pages.ActivePage := TFMul(Ecran).PComplement;
    SetFocusControl('OUTPUTPATH');
    Exit;
  end
  {... ou que le r�pertoire existe}
  else begin
    if not DirectoryExists(CheminVirement) then begin
      {On propose de le cr�er}
      if HShowMessage('9;' + Ecran.Caption + ';Voulez-vous cr�er le r�pertoire' + CheminVirement + ' !;Q;YN;Y;Y;', '', '') = mrYes then begin
        if not CreateDir(CheminVirement) then begin
          HShowMessage('10;' + Ecran.Caption + ';Impossible de cr�er le r�pertoire' + CheminVirement + ' !;E;O;O;O', '' , '');
          Exit;
        end;
      end
      else begin
        Exit;
      end;
    end;
  end;
  if CheminVirement[Length(CheminVirement)] <> '\' then CheminVirement := CheminVirement + '\';

  {Gestion de la date}
  if Trim((GetControlText('DATEENVOI'))) = '/  /' then begin
    HShowMessage('11;' + Ecran.Caption + ';Vous devez choisir une date d''envoi !;W;O;O;O;', '', '');
    TFMul(Ecran).Pages.ActivePage := TFMul(Ecran).PComplement;
    SetFocusControl('DATEENVOI');
    Exit;
  end;
  DateTrait := GetControlText('DATEENVOI');

  {On regarde maintenant s'il faut faire des transferts internationaux}
  lTransfert.Clear;
  {$IFNDEF EAGLCLIENT}
  TFMul(Ecran).Q.First;
  if FListe.AllSelected then
    while not TFMul(Ecran).Q.EOF do begin
      if (UpperCase(Copy(TFMul(Ecran).Q.FindField('TEQ_PAYSSOURCE').AsString, 1, 2)) <> 'FR') or
         (UpperCase(Copy(TFMul(Ecran).Q.FindField('TEQ_PAYSDEST'  ).AsString, 1, 2)) <> 'FR') or
         (TFMul(Ecran).Q.FindField('TEQ_DEVISE').AsString <> CodeEuro) then
        lTransfert.Add(TFMul(Ecran).Q.FindField('TEQ_NUMEQUI').AsString);
      TFMul(Ecran).Q.Next;
    end
  else
  {$ENDIF}
    for n := 0 to FListe.nbSelected - 1 do begin
      FListe.GotoLeBookmark(n);
      if (UpperCase(Copy(GetField('TEQ_PAYSSOURCE'), 1, 2)) <> 'FR') or
         (UpperCase(Copy(GetField('TEQ_PAYSDEST'  ), 1, 2)) <> 'FR') or
         (GetField('TEQ_DEVISE') <> CodeEuro) then lTransfert.Add(GetField('TEQ_NUMEQUI'));
    end;

  {On va g�n�rer des transfert}
  if lTransfert.Count > 0 then begin
    {Gestion de la r�f�rence de remise}
    if GetControlText('EDREMISE') = '' then begin
      HShowMessage('12;' + Ecran.Caption + ';Veuillez saisir une r�f�rence de remise !;W;O;O;O;', '', '');
      TFMul(Ecran).Pages.ActivePage := TFMul(Ecran).PComplement;
      SetFocusControl('EDREMISE');
      Exit;
    end;
    Remise := GetControlText('EDREMISE');

    {Gestion de la nature �conomique}
    if THValComboBox(GetControl('CBNATECO')).Value = '' then begin
      HShowMessage('13;' + Ecran.Caption + ';Veuillez saisir une nature �conomique !;W;O;O;O;', '', '');
      TFMul(Ecran).Pages.ActivePage := TFMul(Ecran).PComplement;
      SetFocusControl('CBNATECO');
      Exit;
    end;
    NatEco := GetControlText('CBNATECO');
  end;

  CodeVir := '76'; {21/09/06 : Virement de compte � compte}
  if TRadioButton(GetControl('RBBENEFICIAIRE'  )).Checked then Imputation := '13'
  else if TRadioButton(GetControl('RBBENEFEMET')).Checked then Imputation := '14'
  else if TRadioButton(GetControl('RBEMETTEUR' )).Checked then Imputation := '15';

  Result  := True;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.RecupeInfoSoc(NomBase : string; SocOk : Boolean);
{---------------------------------------------------------------------------------------}
var
  Q : TQuery;
  sPays : string;
begin
  if IsTresoMultiSoc then NomBase := GetInfosFromDossier('DOS_NODOSSIER', NomBase, 'DOS_NOMBASE')
                     else NomBase := '';
  if SocOk then begin
    {Constitution du record contenant les infos de la soci�t� �mettrice}
    RecSoc.Raison := GetParamsocDossierSecur('SO_LIBELLE' , '', NomBase);
    RecSoc.Adr1   := GetParamsocDossierSecur('SO_ADRESSE1', '', NomBase);
    RecSoc.Ville  := GetParamsocDossierSecur('SO_VILLE'   , '', NomBase);
    sPays         := GetParamsocDossierSecur('SO_PAYS'    , '', NomBase);
    RecSoc.Siret  := GetParamsocDossierSecur('SO_SIRET'   , '', NomBase);
  end
  else begin
    {Constitution du record contenant les infos de la soci�t� destinataire}
    RecTsf.Nom      := GetParamsocDossierSecur('SO_LIBELLE' , '', NomBase);
    RecTsf.Adresse1 := GetParamsocDossierSecur('SO_ADRESSE1', '', NomBase);
    RecTsf.Ville    := GetParamsocDossierSecur('SO_VILLE'   , '', NomBase);
    sPays           := GetParamsocDossierSecur('SO_PAYS'    , '', NomBase);
  end;

  {Recherche du libelle et du code Iso du pays de la soci�t�.
   A revoir pour le multi-soci�t�s}
  Q := OpenSQL('SELECT PY_CODEISO2, PY_LIBELLE FROM PAYS WHERE PY_PAYS= "' + sPays + '"', True);
  if not Q.EOF then begin
    if SocOk then RecSoc.Pays := Q.FindField('PY_LIBELLE').AsString
             else RecTsf.Pays := Q.FindField('PY_LIBELLE').AsString;
    CodePays := Q.FindField('PY_CODEISO2').AsString;
  end;
  Ferme(Q);

  if not SocOk then RecTsf.CodePays := CodePays;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.InitRecord(NomBase : string; SocOk : Boolean);
{---------------------------------------------------------------------------------------}
begin
  {R�cup�ration des coordonn�es du dossier �metteur}
  if SocOk then RecupeInfoSoc(NomBase, SocOk);

  RecInf.Code        := '';
  RecInf.NumEmetteur := '';
  RecInf.Motif       := 'Equilibrage';
  RecInf.Imputation  := Imputation;
  RecInf.Montant     := 0;
  RecInf.DateCreat   := Date;

  RecTsf.CodeBIC   := '';
  RecTsf.CodeIBAN  := '';
  RecTsf.Devise    := '';
  RecTsf.Nom       := '';
  RecTsf.Adresse1  := '';
  RecTsf.Ville     := '';
  RecTsf.Pays      := '';
  RecTsf.Pays2     := '';
  RecTsf.CodePays  := '';
  RecTsf.CodeIBAN2 := '';
  RecTsf.Devise2   := '';
  RecTsf.IdClient  := '';
  RecTsf.TypeRemise:= '';
  RecTsf.Remise    := '';
  RecTsf.NatEco    := '';
  RecTsf.DateExect := Date;
  RecTsf.Banque    := '';

  SCompte.General      := '';
  SCompte.CodeBanque   := '';
  SCompte.NumCompte    := '';
  SCompte.CodeGuichet  := '';
  SCompte.CleRib       := '';
  SCompte.Domiciliation:= '';
  SCompte.RaisonSoc    := '';
  SCompte.Divers       := '';

  DCompte.General      := '';
  DCompte.CodeBanque   := '';
  DCompte.NumCompte    := '';
  DCompte.CodeGuichet  := '';
  DCompte.CleRib       := '';
  DCompte.Domiciliation:= '';
  DCompte.RaisonSoc    := '';
  DCompte.Divers       := '';
end;

{---------------------------------------------------------------------------------------}
function TOF_TRMULVIREMENT.CreerVirement : Boolean;
{---------------------------------------------------------------------------------------}
var
  Clef : string;
begin
  Result := True;

  Clef := TFMul(Ecran).Q.FindField('TEQ_SNODOSSIER').AsString + '|' +
          TFMul(Ecran).Q.FindField('TEQ_SBANQUE').AsString + '|' +
          TFMul(Ecran).Q.FindField('TEQ_DEVISE').AsString;

  if Clef <> OldClef then begin
    {On cr�e l'enregistrement total et on �crit le fichier}
    if OldClef <> '' then
      if not FinirVirement then begin
        Result := False;
        Exit;
      end;

    InitRecord(TFMul(Ecran).Q.FindField('TEQ_SNODOSSIER').AsString, TFMul(Ecran).Q.FindField('TEQ_SNODOSSIER').AsString <> OldDossier);
    OldDossier := TFMul(Ecran).Q.FindField('TEQ_SNODOSSIER').AsString;

    NomFichier := TFMul(Ecran).Q.FindField('TEQ_FICVIR').AsString;
    ListeFichier.Clear;
    Montant := 0;
    NumE := 1;
    OldClef := Clef;
    TransfertOk := lTransfert.IndexOf(TFMul(Ecran).Q.FindField('TEQ_NUMEQUI').AsString) > -1;
    Result := PutBanqueSource;
  end;

  if Result then Result := PutBanqueDest;
end;

{---------------------------------------------------------------------------------------}
function TOF_TRMULVIREMENT.FinirVirement : Boolean;
{---------------------------------------------------------------------------------------}
var
  S    : string;
begin
  Result := True;

  S := NomFichier;
  {Ecrit La Ligne Total}
  PutTotal;
  {Si le chemin est vide !}
  if ExtractFilePath(S) = '' then
    S := CheminVirement + S; {On consid�re que le nom du fichier est toujours renseign�}

  {Test de l'existance du fichier et demande de remplacement}
  if not (FileExists(S) and (TrShowMessage(Ecran.Caption, 13, S, '') = mrNo)) then begin
    try
      ListeFichier.SaveToFile(s);
    except
      {Echec lors de la g�n�ration du fichier}
      on E : Exception do begin
        Result := False;
        MsgErreur := E.Message;
      end;
    end;
  end

  {On ne veut pas �craser le fichier existant}
  else begin
    Result := False;
    MsgErreur := TraduireMemoire('Traitement interrompu');
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_TRMULVIREMENT.PutBanqueSource : Boolean;
{---------------------------------------------------------------------------------------}
var
  Q     : TQuery;
  Ligne : string;
begin
  Result := True;

  Q := OpenSQL('SELECT BQ_ETABBQ, BQ_NUMEROCOMPTE, BQ_GUICHET, BQ_CLERIB, BQ_DOMICILIATION, BQ_NUMEMETVIR,'+
               ' BQ_LETTREVIR, D_CODEISO, BQ_CODEIBAN, BQ_CODEBIC, PY_CODEISO2, BQ_ADRESSE1, BQ_ADRESSE2,' +
               ' BQ_CODEPOSTAL, BQ_VILLE, BQ_LIBELLE, D_LIBELLE, PQ_ETABBQ FROM BANQUECP ' +
               ' LEFT JOIN PAYS ON PY_PAYS = BQ_PAYS' +
               ' LEFT JOIN DEVISE ON D_DEVISE = BQ_DEVISE' +
               ' LEFT JOIN BANQUES ON PQ_BANQUE = BQ_BANQUE' +
               ' WHERE BQ_CODE = "' + TFMul(Ecran).Q.FindField('TEQ_SGENERAL').AsString + '"', True);
  try
    RecInf.NumEmetteur := Q.FindField('BQ_NUMEMETVIR').AsString;
    {Tests sur le param�trage : Devise, Compte ...}
    if Q.FindField('D_CODEISO').AsString = '' then begin
      MsgErreur := TraduireMemoire('Veuillez renseigner le Code Iso de la devise : ') + Q.FindField('D_LIBELLE').AsString;
      Result := False;
      Exit;
    end
    else if RecInf.NumEmetteur = '' then begin
      MsgErreur := TraduireMemoire('Veuillez renseigner le num�ro d''�metteur du compte : ') + Q.FindField('BQ_DOMICILIATION').AsString;
      Result := False;
      Exit;
    end;

    {Initialisation du num�ro s�quentiel}
    RecInf.DateCreat := StrToDate(DateTrait);
    RecInf.Code      := CodeVir;{Pour le moment on ne g�re que les virements ordinaires}

    if TransfertOk then begin
      RecTsf.Remise    := AnsiUpperCase(Remise);
      RecTsf.CodeBIC   := Q.FindField('BQ_CODEBIC').AsString;
      RecTsf.CodeIBAN  := Q.FindField('BQ_CODEIBAN').AsString;
      RecTsf.Devise    := Q.FindField('D_CODEISO').AsString;
      RecTsf.CodeIBAN2 := Q.FindField('BQ_CODEIBAN').AsString;
      RecTsf.Devise2   := Q.FindField('D_CODEISO').AsString;
      RecTsf.DateExect := StrToDate(DateTrait);
      RecTsf.NatEco    := NatEco;
    end;

    SCompte.General  := TFMul(Ecran).Q.FindField('TEQ_SGENERAL').AsString;
    SCompte.CodeBanque    := Q.FindField('BQ_ETABBQ').AsString;
    {Dans le cas d'un compte �tranger, le code banque n'est pas renseign�, car on travaille sur l'IBAN.
     On va donc chercher dans la banque le code banque qui est obligatoire}
    if SCompte.CodeBanque = '' then
      SCompte.CodeBanque  := Q.FindField('PQ_ETABBQ').AsString;
    SCompte.NumCompte     := Q.FindField('BQ_NUMEROCOMPTE').AsString;
    SCompte.CodeGuichet   := Q.FindField('BQ_GUICHET').AsString;
    SCompte.CleRib        := Q.FindField('BQ_CLERIB').AsString;
    SCompte.Domiciliation := Q.FindField('BQ_DOMICILIATION').AsString;
    SCompte.Divers        := '';

    if TransfertOk then
      Ligne := TGenerationCFONB.EmetteurTrans(RecTsf, RecInf, RecSoc)
    else
      Ligne := TGenerationCFONB.EmetteurVIR(SCompte, RecInf);
    ListeFichier.Add(Ligne);
  finally
    Ferme(Q);
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_TRMULVIREMENT.PutBanqueDest : Boolean;
{---------------------------------------------------------------------------------------}
var
  Q     : TQuery;
  Ligne : string;
begin
  Result := True;

  DCompte.General := GetField('TEQ_DGENERAL');
  Q := OpenSQL('SELECT BQ_ETABBQ, BQ_NUMEROCOMPTE, BQ_GUICHET, BQ_CLERIB, BQ_LIBELLE, BQ_DOMICILIATION, D_LIBELLE, ' +
               'BQ_DEVISE, BQ_CODEIBAN, PY_CODEISO2, BQ_VILLE, BQ_CODEBIC, BQ_ADRESSE1, BQ_ADRESSE2, D_CODEISO, ' +
               'TRA_LIBELLE, TRA_VILLE, BQ_CODEPOSTAL, PY_LIBELLE, PQ_LIBELLE, PQ_ETABBQ FROM BANQUECP ' +
               'LEFT JOIN PAYS ON PY_PAYS = BQ_PAYS ' +
               'LEFT JOIN AGENCE ON TRA_AGENCE = BQ_AGENCE ' +
               'LEFT JOIN BANQUES ON PQ_BANQUE = BQ_BANQUE ' +
               'LEFT JOIN DEVISE ON D_DEVISE = BQ_DEVISE ' +
               'WHERE BQ_CODE = "' + DCompte.General + '"', True);
  try
    {Tests sur le param�trage : Devise}
    if Q.FindField('D_CODEISO').AsString = '' then begin
      MsgErreur := TraduireMemoire('Veuillez renseigner le Code Iso de la devise : ') + Q.FindField('D_LIBELLE').AsString;
      Result := False;
      Exit;
    end;

    RecInf.Montant := TFMul(Ecran).Q.FindField('TEQ_MONTANTDEV').AsFloat;
    Montant := RecInf.Montant + Montant;
    Inc(NumE);

    {D�tail du b�n�ficiaire}
    RecTsf.CodeIBAN    := Q.FindField('BQ_CODEIBAN').AsString;
    if TransfertOk then begin
      RecInf.NumEmetteur := IntToStr(NumE);
      RecupeInfoSoc(TFMul(Ecran).Q.FindField('TEQ_DNODOSSIER').AsString, False);
      if Imputation = '13' then
        RecTsf.Devise  := Q.FindField('D_CODEISO').AsString;
      Ligne := TGenerationCFONB.DetailTrans(RecTsf, RecInf);
      ListeFichier.Add(Ligne);
    end;


    {Detail banque b�n�ficiaire 2}
    Inc(NumE);
    if TransfertOk then begin
      RecInf.NumEmetteur := IntToStr(NumE);
      RecTsf.Banque  := Q.FindField('PQ_LIBELLE').AsString;
      RecTsf.Pays2   := Q.FindField('PY_LIBELLE').AsString;
      RecTsf.Agence  := Q.FindField('TRA_LIBELLE').AsString;
      RecTsf.Ville   := Q.FindField('TRA_VILLE').AsString;
      RecTsf.CodeBic := Q.FindField('BQ_CODEBIC').AsString;
      RecTsf.Pays    := CodeIsoDuPays(Q.FindField('PY_CODEISO2').AsString);
    end;

    DCompte.CodeBanque    := Q.FindField('BQ_ETABBQ').AsString;
    {Dans le cas d'un compte �tranger, le code banque n'est pas renseign�, car on travaille sur l'IBAN.
     On va donc chercher dans la banque le code banque qui est obligatoire}
    if DCompte.CodeBanque = '' then
      DCompte.CodeBanque  := Q.FindField('PQ_ETABBQ').AsString;
    DCompte.NumCompte     := Q.FindField('BQ_NUMEROCOMPTE').AsString;
    DCompte.CodeGuichet   := Q.FindField('BQ_GUICHET').AsString;
    DCompte.CleRib        := Q.FindField('BQ_CLERIB').AsString;
    DCompte.RaisonSoc     := Q.FindField('BQ_LIBELLE').AsString; {Libell�}
    DCompte.Domiciliation := Q.FindField('BQ_DOMICILIATION').AsString;

    DCompte.Divers  := 'Equilibrage';

    if TransfertOk then
      Ligne := TGenerationCFONB.DetailTrans2(RecTsf, RecInf)
    else
      Ligne := TGenerationCFONB.DetailVIR(DCompte, RecInf);

    ListeFichier.Add(Ligne);

  finally
    Ferme(Q);
  end;
end;

{---------------------------------------------------------------------------------------}
function TOF_TRMULVIREMENT.PutTotal : Boolean;
{---------------------------------------------------------------------------------------}
var
  Ligne : string;
begin
  Result := True;

  RecInf.Montant := Montant;

  if TransfertOk then begin
    Inc(NumE);
    RecInf.NumEmetteur := IntToStr(NumE);
    RecInf.DateCreat   := StrToDate(DateTrait);
    RecTsf.CodeIBAN    := RecTsf.CodeIBAN2;
    RecTsf.Devise      := RecTsf.Devise2;

    Ligne := TGenerationCFONB.TotalTrans(RecTsf, RecInf, RecSoc);
  end
  else
    Ligne := TGenerationCFONB.TotalVIR(RecInf);

  ListeFichier.Add(Ligne);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.DeviseOnChange(Sender : TObject);
{---------------------------------------------------------------------------------------}
begin
  AssignDrapeau(TImage(GetControl('IDEV')), GetControlText('TEQ_DEVISE'));
end;

{20/09/06 : Pour le mode eAgl
{---------------------------------------------------------------------------------------}
procedure TOF_TRMULVIREMENT.SlctAllClick(Sender: TObject);
{---------------------------------------------------------------------------------------}
var
  Fiche : TFMul;
begin
  Fiche := TFMul(Ecran);
  {$IFDEF EAGLCLIENT}
  if not Fiche.FListe.AllSelected then begin
    if not Fiche.FetchLesTous then Exit;
  end;
  {$ENDIF}
  Fiche.bSelectAllClick(nil);
end;

initialization
  RegisterClasses ( [ TOF_TRMULVIREMENT ] );

end.


