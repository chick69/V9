{***********UNITE*************************************************
Auteur  ...... : FLO
Cr�� le ...... : 02/07/2007
Modifi� le ... :   /  /
Description .. : Source TOF des �tats de la gestion de pr�sence :
Suite ........ : - PYP : Compteurs de pr�sence
Mots clefs ... : TOF;PGEDITPRESENCE;COMPTEUR
*****************************************************************}
Unit UTOFPGEDITPRESENCE ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes,
     UTOF,
     UTOB;

Const NB_RUPTURES = 2;
Const NB_COLONNES = 6;
Const ANNU  = 1;
Const MENSU = 2;
Const HEBDO = 3;
Const JOUR  = 4;
Const CYCLE = 5;

Type
  TOF_PGEDITCOMPTEURSPRES = Class (TOF)
    procedure OnUpdate                 ; override ;
    procedure OnArgument (S : String ) ; override ;
  private
    TobEtat   : TOB;
    Tablettes : Array of Array[0..1] of String;
    NbCols    : Integer;
    Function  RechTablette (NomChamp : String) : String;
    procedure OnChangeRuptures (Sender : TObject);
    procedure GenereDateFin (Sender : TObject);
    procedure ChangePeriodicite (Sender : TObject);
    Procedure ChangeTheme (Sender : TObject);
    procedure ChangeNbColonnes (Sender : TObject);
  end ;

Implementation

Uses
{$IFNDEF EAGLCLIENT}
     db,
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} QRS1, uTobDebug, //mul,E dtREtat
     mul,
{$ELSE}
     eMul,
     eQRS1, 
{$ENDIF}
     forms,
     sysutils,
     ComCtrls,
     HCtrls,
     HEnt1,
     HMsgBox,
     EntPaie,
     HQry,
     P5Def;


procedure TOF_PGEDITCOMPTEURSPRES.OnUpdate ;
var OrderBy,Where,Select : String;
    i,num : Integer;
    Pages : TPageControl;
    Q : TQuery;
    TobCompteurs, T : TOB;
    TypePeriode : Integer;
    DD : TDateTime;
    Libelle,Tablette : String;
    Salarie,Compteur : String;
    Trouve : Boolean;
    TblColonnes : Array[1..NB_COLONNES] Of String;
    Requete : String;
begin
    Inherited ;
        If Assigned(TobEtat) Then FreeAndNil (TobEtat);
        TobEtat := Tob.Create('Edition',Nil,-1);

        // Construction dynamique du SELECT et ORDER BY pour les ruptures
        Select := 'PYP_SALARIE,PYP_COMPTEURPRES,PYR_LIBELLE,PYP_DATEDEBUTPRES,PYP_DATEFINPRES,PYP_QUANTITEPRES';
        OrderBy := '';
        For i := 1 To NB_RUPTURES Do
        Begin
                If (GetControlText('VRUPT'+IntToStr(i)) <> '') And (GetControlText('VRUPT'+IntToStr(i)) <> 'PYP_COMPTEURPRES') then
                Begin
                        If OrderBy <> '' then OrderBy := OrderBy + ',' + GetControlText('VRUPT'+IntToStr(i))
                        else OrderBy := GetControlText('VRUPT'+IntToStr(i));
                        Select := Select+','+GetControlText('VRUPT'+IntToStr(i));
                end;
        End;
        If OrderBy <> '' then OrderBy := OrderBy + ',';
        OrderBy := OrderBy + 'PYP_COMPTEURPRES,PYP_SALARIE';

        // R�cup�ration de la clause Where
        Pages := TPageControl(GetControl('PAGES'));
        Where := RecupWhereCritere(Pages);

        // G�n�ration des libell�s de colonnes
        TypePeriode := StrToInt(GetControlText('PYP_PERIODICITEPRE'));
        i := 1;
        Requete := 'SELECT PYP_DATEDEBUTPRES,PYP_DATEFINPRES FROM PGPRESENCESAL '+Where+' GROUP BY PYP_COMPTEURPRES,PYR_LIBELLE,PYP_DATEDEBUTPRES,PYP_DATEFINPRES ORDER BY PYP_DATEDEBUTPRES';
        Q := OpenSQL (Requete, True);
        If Q.EOF Then
        Begin
               // Aucune donn�e : pas la peine d'aller plus loin
               TFQRS1(Ecran).LaTob:= TobEtat;
               Ferme(Q);
               Exit;
        End;
        While (Not Q.EOF) And (i<=NbCols) Do
        Begin
               Libelle := '';
               Case TypePeriode Of
                    ANNU: Libelle := DateToStr(Q.FindField('PYP_DATEDEBUTPRES').AsDateTime)+' au '+DateToStr(Q.FindField('PYP_DATEFINPRES').AsDateTime);
                    MENSU:Libelle := DateToStr(Q.FindField('PYP_DATEDEBUTPRES').AsDateTime)+' au '+DateToStr(Q.FindField('PYP_DATEFINPRES').AsDateTime);
                    HEBDO:Libelle := DateToStr(Q.FindField('PYP_DATEDEBUTPRES').AsDateTime)+' au '+DateToStr(Q.FindField('PYP_DATEFINPRES').AsDateTime);
                    JOUR: Libelle := DateToStr(Q.FindField('PYP_DATEDEBUTPRES').AsDateTime);
               End;

               SetControlText('LIBELLE'+IntToStr(i),Libelle);
               TblColonnes[i] := DateToStr(Q.FindField('PYP_DATEDEBUTPRES').AsDateTime);
               i := i + 1;
               Q.Next;
        End;
        Ferme(Q);

        { Construction de la requ�te }

        Requete := 'SELECT ' + Select + ' FROM PGPRESENCESAL '+Where+' ORDER BY ' + OrderBy;

        // Cr�ation de la TOB
        Q := OpenSQL(Requete, True);
        TobCompteurs := Tob.Create('LesCompteurs', nil, -1);
        TobCompteurs.LoadDetailDB('LesCompteurs', '', '', Q, False);
        Ferme(Q);

        // Int�gration des frais en une seule ligne dans la TOB finale
        For i := 0 To TobCompteurs.Detail.Count-1 Do
        Begin
                // Recherche du salari�
                Salarie  := TobCompteurs.Detail[i].GetValue('PYP_SALARIE');
                Compteur := TobCompteurs.Detail[i].GetValue('PYP_COMPTEURPRES');
                T := TobEtat.FindFirst(['PYP_SALARIE','PYP_COMPTEURPRES'],[Salarie,Compteur],True);
                If T = Nil Then
                Begin
                      T := Tob.Create('LaFille', TobEtat, -1);
                      T.AddChampSupValeur('PYP_SALARIE',      Salarie);
                      T.AddChampSupValeur('PYP_COMPTEURPRES', Compteur);
                      T.AddChampSupValeur('PYR_LIBELLE',      TobCompteurs.Detail[i].GetValue('PYR_LIBELLE'));

                      // Ajout des ruptures
                      T.AddChampSupValeur('RUPTURE1',TobCompteurs.Detail[i].GetValue(GetControlText('VRUPT1')));
                      Tablette := RechTablette(GetControlText('VRUPT1'));
                      If (Tablette <> '') Then T.AddChampSupValeur('LIBRUPTURE1',RechDom(Tablette, TobCompteurs.Detail[i].GetValue(GetControlText('VRUPT1')), False));

                      T.AddChampSupValeur('RUPTURE2',TobCompteurs.Detail[i].GetValue(GetControlText('VRUPT2')));
                      Tablette := RechTablette(GetControlText('VRUPT2'));
                      If (Tablette <> '') Then T.AddChampSupValeur('LIBRUPTURE2',RechDom(Tablette, TobCompteurs.Detail[i].GetValue(GetControlText('VRUPT2')), False));

                      // Cr�ation � vide de tous les champs correspondant aux compteurs
                      T.AddChampSupValeur('MTT1',0);
                      T.AddChampSupValeur('MTT2',0);
                      T.AddChampSupValeur('MTT3',0);
                      T.AddChampSupValeur('MTT4',0);
                      T.AddChampSupValeur('MTT5',0);
                      T.AddChampSupValeur('MTT6',0);
                End;

                // Mise � jour de la TOB pour la quantit�
                If T <> Nil Then
                Begin
                      Num := 1;
                      Trouve := False;
                      While (Not Trouve) And (Num <= NbCols) Do
                      Begin
                             DD := TobCompteurs.Detail[i].GetValue('PYP_DATEDEBUTPRES');
                             If TblColonnes[Num] = DateToStr(DD) Then
                             Begin
                                  T.PutValue('MTT'+IntToStr(Num), TobCompteurs.Detail[i].GetValue('PYP_QUANTITEPRES'));
                                  Trouve := True;
                             End;
                             Num := Num + 1;
                      End;
                End;
        End;

        // Lib�ration de la TOB interm�diaire
        FreeAndNil (TobCompteurs);

        // Attribution de la TOB � l'�tat
        TFQRS1(Ecran).LaTob:= TobEtat;
end ;

procedure TOF_PGEDITCOMPTEURSPRES.OnArgument (S : String ) ;
Var
     Edit  : THEdit;
     i,Num : Integer;
     Combo : THValComboBox;
     CkBox : TCheckBox;
     Spin  : THSpinEdit;
begin
  Inherited ;

  // C�ation d'un listener sur la date de d�but
  Edit := THEdit(GetControl('PYP_DATEDEBUTPRES'));
  If Edit <> Nil then Edit.OnExit := GenereDateFin;

  // C�ation d'un listener sur le th�me
  Combo := THValComboBox(GetControl('PYP_THEMEPRE'));
  If Combo <> Nil then Combo.OnChange := ChangeTheme;

  // Idem sur le nombre d'occurrences
  Spin := THSpinEdit(GetControl('NBOCC'));
  If Spin <> Nil then Spin.OnChange := ChangeNbColonnes;

  // Idem sur la p�riodicit�
  Combo := THValComboBox(GetControl('PYP_PERIODICITEPRE'));
  If Combo <> Nil then Combo.OnChange := ChangePeriodicite;

  // Suppression des �l�ments journaliers et cycliques qui n'ont pas d'int�r�t pour l'�dition
  For i := Combo.Values.Count-1 DownTo 0 Do
  Begin
     // 004 : Journalier, 005 : Cycle
     If (Combo.Values[i] = '004') Or (Combo.Values[i] = '005') Then
     Begin
          Combo.Values.Delete(i);
          Combo.Items.Delete(i);
     End;
  End;

  // S�lection de l'hebdo par d�faut
 // SetControlText('PYP_PERIODICITEPRE', Combo.Values[2]);

  // Adaptation des ruptures
  For i := 1 To NB_RUPTURES do
  begin
          Combo := THValComboBox(GetControl('VRUPT'+IntToStr(i)));
          If Combo <> Nil Then
          begin
                  // Rendre invisible toutes les check-boxes de saut de page par d�faut
                  CkBox := TCheckBox(GetControl('CSRUPT'+IntToStr(i)));
                  CkBox.Visible := False;

                  // Sur le changement de valeur d'une combo, il faut afficher le saut de page
                  Combo.OnChange := OnChangeRuptures;

                  // Ajout des valeurs
                  If i <> 1 Then
                  Begin
                       Combo.Items.Add ('');
                       Combo.Values.Add('');
                  End;
                  Combo.Items.Add ('Compteur');
                  Combo.Values.Add('PYP_COMPTEURPRES');
                  Combo.Items.Add ('Etablissement');
                  Combo.Values.Add('PYP_ETABLISSEMENT');
                  For Num := 1 To VH_Paie.PGNbreStatOrg Do
                  Begin
                      Case Num Of
                         1 : Combo.Items.Add(VH_Paie.PGLibelleOrgStat1);
                         2 : Combo.Items.Add(VH_Paie.PGLibelleOrgStat2);
                         3 : Combo.Items.Add(VH_Paie.PGLibelleOrgStat3);
                         4 : Combo.Items.Add(VH_Paie.PGLibelleOrgStat4);
                      End;
                      Combo.Values.Add('PYP_TRAVAILN'+IntToStr(Num));
                  End;
          end;
  end;
  SetControlText('VRUPT1', 'PYP_COMPTEURPRES');

  // Recherche des libell�s des zones TRAVAIL, CODESTAT, LIBREPCMB
  for Num := 1 to 4 do
  begin
    VisibiliteChampSalarie(IntToStr(Num), GetControl('PYP_TRAVAILN' + IntToStr(Num)), GetControl('TPYP_TRAVAILN' + IntToStr(Num)));
  end;

  VisibiliteStat(GetControl('PYP_CODESTAT'), GetControl('TPYP_CODESTAT'));

  for Num := 1 to 4 do
  begin
    VisibiliteChamplibresal(Inttostr(Num), GetControl('PYP_LIBREPCMB' + IntToStr(Num)), GetControl('TPYP_LIBREPCMB' + IntToStr(Num)));
  end;

  If Assigned(TobEtat) Then FreeAndNil(TobEtat);
end ;


{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 02/07/2007
Modifi� le ... :   /  /
Description .. : Gestion des checkboxes pour les ruptures
Mots clefs ... :
*****************************************************************}
procedure TOF_PGEDITCOMPTEURSPRES.OnChangeRuptures(Sender: TObject);
Var
  i,j : Integer;
  Affiche : boolean;
  Valeur : String;
Begin
     // R�cup�ration du niveau de rupture
     i := StrToInt(Copy(TControl(Sender).Name,6,1));

     // D�termine s'il faut cacher ou afficher la checkbox de saut de page
     Affiche := (THValComboBox(GetControl('VRUPT'+IntToStr(i))).Value <> '');

     // Contr�le de coh�rence des ruptures
     For j:= 1 To (NB_RUPTURES-1) Do
     Begin
        If (THValComboBox(GetControl('VRUPT'+IntToStr(j))).Value = '') And
           (THValComboBox(GetControl('VRUPT'+IntToStr(j+1))).Value <> '') Then
          Begin
               PGIBox('Le niveau de rupture '+IntToStr(j)+' doit �tre renseign�',Ecran.Caption);
               GetControl('BValider').Enabled := False;
               Exit;
          End
     End;

     Valeur := THValComboBox(GetControl('VRUPT'+IntToStr(i))).Value;
     For j:=1 To NB_RUPTURES Do
     Begin
          If (i <> j) And (Valeur = THValComboBox(GetControl('VRUPT'+IntToStr(j))).Value) And (Valeur <> '') Then
          Begin
               PGIBox('La rupture '+IntToStr(i)+' doit �tre diff�rente de la '+IntToStr(j),Ecran.Caption);
               GetControl('BValider').Enabled := False;
               Exit;
          End;
     End;

     GetControl('BValider').Enabled := True;

     // Afficher/cacher la checkbox
     TCheckBox(GetControl('CSRUPT'+IntToStr(i))).Visible := Affiche;
     // Si on cache, on remet �galement l'�tat � "d�coch�"
     If (Affiche = False) Then TCheckBox(GetControl('CSRUPT'+IntToStr(i))).Checked := Affiche;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 02/07/2007
Modifi� le ... :   /  /
Description .. : G�n�ration de la date de fin de la p�riode de prise en 
Suite ........ : compte des compteurs
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEDITCOMPTEURSPRES.GenereDateFin(Sender: TObject);
Var
     TypePeriode : Integer;
     DD,DF       : TDateTime;
begin
      If (GetControlText('PYP_PERIODICITEPRE') <> '') And (StrToDate(GetControlText('PYP_DATEDEBUTPRES')) <> iDate1900) Then
      Begin
          TypePeriode := StrToInt(GetControlText('PYP_PERIODICITEPRE'));
          DD          := StrToDate(GetControlText('PYP_DATEDEBUTPRES'));
          Case TypePeriode Of
               ANNU  : DF := PlusDate(DD, NbCols, 'A') ;              // G�n�ration pour x ann�es
               MENSU : DF := FinDeMois(PlusDate(DD, NbCols, 'M'));   // G�n�ration pour x mois
               HEBDO : DF := PlusDate(DD, NbCols, 'S');               // G�n�ration pour x semaines
               JOUR  : DF := PlusDate(DD, NbCols, 'J');               // G�n�ration pour x jours
               Else
                    DF := DD;
          End;
          SetControlText('PYP_DATEFINPRES', DateToStr(DF));
      End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 02/07/2007
Modifi� le ... :   /  /    
Description .. : Recherche de la tablette associ�e � un champ
Mots clefs ... :
*****************************************************************}
Function TOF_PGEDITCOMPTEURSPRES.RechTablette (NomChamp : String) : String;
Var
  Champ,Valeur : String;
  Q : TQuery;
  i : Integer;
Begin
  Valeur := '';
  If (NomChamp <> '') And (Length(NomChamp) > 5) Then
  Begin
    Champ := Copy(NomChamp,5,255);

    // Afin de limiter les acc�s en base, on sauvegarde les r�sultats pr�c�dents de recherche de tablette
    If (Length(Tablettes) > 0) Then
    Begin
          For i:=0 To Length(Tablettes)-1 Do
          Begin
                If (Tablettes[i][0] = Champ) Then Begin Valeur := Tablettes[i][1]; Break; End;
          End;
    End;

    // Recherche de la tablette concern�e
    If (Valeur = '') Then
    Begin
          Q := OpenSql('SELECT DO_COMBO FROM DECOMBOS WHERE DO_NOMCHAMP like "%' + Champ + '%" ', True);
          Valeur := Q.FindField('DO_COMBO').AsString;
          Ferme(Q);
          // Sauvegarde de la valeur lue
          SetLength(Tablettes, Length(Tablettes)+1);
          Tablettes[Length(Tablettes)-1][0] := Champ;
          Tablettes[Length(Tablettes)-1][1] := Valeur;
    End;
  End;
  Result := Valeur;
End;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 04/07/2007
Modifi� le ... :   /  /    
Description .. : Met � jour la date de fin et le nombre de colonnes par 
Suite ........ : d�faut sur s�lection d'une p�riodicit�
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEDITCOMPTEURSPRES.ChangePeriodicite(Sender: TObject);
Var
     TypePeriode,Nb : Integer;
begin
      // Mise � jour du nombre de colonnes par d�faut
      If (GetControlText('PYP_PERIODICITEPRE') <> '') Then
      Begin
          TypePeriode := StrToInt(GetControlText('PYP_PERIODICITEPRE'));
          Nb := 1;
          Case TypePeriode Of
               ANNU  : Nb := 3;     // G�n�ration pour 3 ann�es
               MENSU : Nb := 6;     // G�n�ration pour un semestre
               HEBDO : Nb := 4;     // G�n�ration pour un mois
          End;
          SetControlText('NBOCC', IntToStr(Nb)) ;
          NbCols := Nb;

          // Actualisation de la date de fin
          GenereDateFin(Sender);
      End;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 04/07/2007
Modifi� le ... :   /  /    
Description .. : Met � jour la date de fin avec le nombre de colonnes
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEDITCOMPTEURSPRES.ChangeNbColonnes(Sender: TObject);
begin
      NbCols := StrToInt(GetControlText('NBOCC'));

      // Actualisation de la date de fin
      GenereDateFin(Sender);
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 04/07/2007
Modifi� le ... :   /  /    
Description .. : Rafra�chissement de la combo des compteurs en fonction 
Suite ........ : du th�me choisi
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGEDITCOMPTEURSPRES.ChangeTheme(Sender: TObject);
begin
      If (GetControlText('PYP_THEMEPRE') <> '') Then
      Begin
          SetControlText('PYP_COMPTEURPRES', '');
          SetControlProperty('PYP_COMPTEURPRES', 'Plus', ' AND PYR_THEMEPRE="'+GetControlText('PYP_THEMEPRE')+'"');
      End;
end;

Initialization
  registerclasses ( [ TOF_PGEDITCOMPTEURSPRES ] ) ;
end.

