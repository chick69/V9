{***********UNITE*************************************************
Auteur  ...... : 
Cr�� le ...... : 18/06/2007
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : UTOF_PGJOURNEETYPEDUP ()
Mots clefs ... : TOF;UTOF_PGJOURNEETYPEDUP
*****************************************************************
PT1  17/07/2007  FLO  Ajout d'une duplication par date d'un profil
}
Unit UTOF_PGPARAMPRESENCEDUP ;

Interface

Uses StdCtrls, 
     Controls, 
     Classes, 
{$IFNDEF EAGLCLIENT}
     db, 
     {$IFNDEF DBXPRESS} dbtables, {$ELSE} uDbxDataSet, {$ENDIF} 
     mul, 
{$else}
     eMul,
     uTob, 
{$ENDIF}
     forms, 
     sysutils, 
     ComCtrls,
     HCtrls, 
     HEnt1, 
     HMsgBox, 
     UTOF ; 
     
Type
  TOF_PGPARAMPRESENCEDUP = Class (TOF)   
    procedure OnUpdate                 ; override ;
    procedure OnArgument (S : String ) ; override ;
  Private
    mode, CodeADUPLIQUER , Appel, libelle, Newcode, DateValidite, DateValiditeOrig : string; //PT1
    procedure Dupliqueentete;
    procedure Dupliquedetail;
    procedure DupliqueDateDetail; //PT1
  end ;

Implementation

Uses
  Vierge;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 18/06/2007
Modifi� le ... : 17/07/2007 / PT1
Description .. : Validation
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGPARAMPRESENCEDUP.OnUpdate ;
var
  valideOK : Boolean;
begin
  Inherited ;

  libelle      := GetControlText('LIBELLE');
  Newcode      := GetControlText('NEWCODE');
  DateValidite := GetControlText('DATEVALIDITE'); //PT1
  valideok     := True;

  if appel = 'JTYP' then
  begin
  // cont�le de la duplication d'une journ�e type
    if Newcode = '' then
    begin
      PGIBox('La journ�e type doit �tre renseign�e.', Ecran.Caption);
      SetFocusControl('NEWCODE');
      lasterror := 1;
      valideok :=  false;
    end;
    if (existesql('SELECT PJO_JOURNEETYPE FROM JOURNEETYPE WHERE PJO_JOURNEETYPE = "'+Newcode+'"') and valideOK) then
    begin
      PGIBox('Cette journ�e type existe d�j� : duplication impossible.', Ecran.Caption);
      SetFocusControl('NEWCODE');
      lasterror := 1;
      valideok := false;
    end;
  end;

  if appel = 'PPRES' then
  begin
     If Mode <> 'DAT' Then //PT1
     Begin
          // cont�le de la duplication d'un profil de pr�sence
          if Newcode = '' then
          begin
               PGIBox('Vous devez choisir un nouveau code pour le compteur de pr�sence.', Ecran.Caption);
               SetFocusControl('NEWCODE');
               lasterror := 1;
               valideok :=  false;
          end;
          if (existesql('SELECT PPQ_PROFILPRES FROM PROFILPRESENCE WHERE PPQ_PROFILPRES = "'+Newcode+'"') and valideOK) then
          begin
               PGIBox('Ce profil de pr�sence existe d�j� : duplication impossible.', Ecran.Caption);
               SetFocusControl('NEWCODE');
               lasterror := 1;
               valideok := false;
          end;
     End
     Else
     Begin
          //PT1 - D�but
          If (DateValidite = '') Or (DateValidite = StDate1900) Then
          Begin
               PGIBox(TraduireMemoire('Veuillez renseigner la nouvelle date de validit�.'), Ecran.Caption);
               SetFocusControl('DATEVALIDITE');
               LastError := 1;
               ValideOK  := False;
          End
          Else
          Begin
               If (ExisteSQL('SELECT 1 FROM PROFILPRESENCE WHERE PPQ_PROFILPRES="'+CodeADUPLIQUER+'" AND PPQ_DATEVALIDITE="'+UsDateTime(StrToDate(DateValidite))+'"') And ValideOK) Then
               Begin
                    PGIError(TraduireMemoire('Ce profil de pr�sence existe d�j� � la date indiqu�e.'), 'Duplication impossible');
                    SetFocusControl('DATEVALIDITE');
                    LastError := 1;
                    ValideOK  := False;
               End;
          End;
          //PT1 - Fin
     End;
  end;

  If Mode <> 'DAT' Then //PT1
  Begin
     if (libelle = '') and valideOK  then
     begin
          PGIBox('Le libell� doit �tre renseign�.', Ecran.Caption);
          SetFocusControl('LIBELLE');
          lasterror := 1;
          valideOK := false;
     end;
  End;

  if valideOK then
  begin
          if mode = 'ENT' then dupliqueentete
          else if Mode = 'DAT' Then DupliqueDateDetail //PT1
          else dupliquedetail;
  end;
end;


{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 18/06/2007
Modifi� le ... : 17/07/2007 / PT1
Description .. : Initialisation de l'�cran
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGPARAMPRESENCEDUP.OnArgument (S : String ) ;
Var Lib : String;
begin
 Inherited ;
 Appel := readtokenst(S);
 CodeADUPLIQUER := readtokenst(S);
 mode := readtokenst(S);
 Lib := readtokenst(S);

 if appel = 'PPRES' then
 begin
     //PT1 - D�but
     DateValiditeOrig := readtokenst(S);
     
     // Pour une duplication par date, on n'affiche que le champ "Date de validit�"
     If Mode = 'DAT' Then
     Begin
          SetControlVisible ('T_DATEVALIDITE', True);
          SetControlVisible ('DATEVALIDITE', True);
          SetControlVisible ('T_CODE', False);
          SetControlVisible ('NEWCODE', False);
          SetControlVisible ('T_LIBELLE', False);
          SetControlVisible ('LIBELLE', False);
     End
     Else
     //PT1 - Fin
          //Le libell� par d�faut est le dernier des arguments
          SetControlText('LIBELLE', Lib);
 end;
end ;

{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 18/06/2007
Modifi� le ... :   /  /    
Description .. : Duplication de l'ent�te
Mots clefs ... : 
*****************************************************************}
procedure TOF_PGPARAMPRESENCEDUP.Dupliqueentete;
begin
(Ecran as TFVierge).Retour := Newcode + ';' + libelle;
Ecran.Close;
end;


{***********A.G.L.***********************************************
Auteur  ...... : NA
Cr�� le ...... : 18/06/2007
Modifi� le ... :   /  /    
Description .. : Duplication du d�tail
Mots clefs ... :
*****************************************************************}
Procedure TOF_PGPARAMPRESENCEDUP.DupliqueDetail;
var
stinsert : string;
begin
  if Appel = 'JTYP' then
  begin
  // duplication des droits de la journ�e type;
    stinsert := 'INSERT INTO DROITJOURNEETYPE (PDJ_JOURNEETYPE, PDJ_PGDROIT, PDJ_QUANTITE1, PDJ_QUANTITE2,'+
            'PDJ_LIBELLE, PDJ_DATECREATION, PDJ_DATEMODIF, PDJ_CREATEUR,PDJ_UTILISATEUR )'+
            'SELECT  "'+Newcode+'",PDJ_PGDROIT, PDJ_QUANTITE1, PDJ_QUANTITE2,'+
            'PDJ_LIBELLE, PDJ_DATECREATION, PDJ_DATEMODIF, PDJ_CREATEUR,PDJ_UTILISATEUR '+
            'FROM DROITJOURNEETYPE WHERE PDJ_JOURNEETYPE = "'+CodeAdupliquer+'"';
     ExecuteSQL ( stInsert );
  end;
  if appel = 'PPRES' then
  begin
  { duplication des compteurs associ�s }
    stinsert := 'INSERT INTO PROFILCOMPTEURPRES (PPV_PROFILPRES, PPV_DATEVALIDITE, '
              + ' PPV_COMPTEURPRES, PPV_LIBELLE, PPV_DATECREATION )'
              + 'SELECT "'+Newcode+'", PPV_DATEVALIDITE, '
              + ' PPV_COMPTEURPRES, PPV_LIBELLE, "'+USDATETIME(Date)+'" '
              + 'FROM PROFILCOMPTEURPRES WHERE PPV_PROFILPRES = "'+CodeAdupliquer+'" AND PPV_DATEVALIDITE="'+UsDateTime(StrToDate(DateValiditeOrig))+'"';  //PT1
     ExecuteSQL ( stInsert );
  end;
  (Ecran as TFVierge).Retour := Newcode + ';' + libelle;
  Ecran.Close;
end;

{***********A.G.L.***********************************************
Auteur  ...... : FLO
Cr�� le ...... : 17/07/2007
Modifi� le ... :   /  /
Description .. : Duplication d'un profil � une autre date avec le d�tail
Suite ........ : associ�
Mots clefs ... :
*****************************************************************}
procedure TOF_PGPARAMPRESENCEDUP.DupliqueDateDetail;
begin
     Try
     ExecuteSQL ( 'INSERT INTO PROFILCOMPTEURPRES (PPV_PROFILPRES, PPV_DATEVALIDITE, PPV_COMPTEURPRES, PPV_LIBELLE, PPV_DATECREATION )'
                  + 'SELECT "'+CodeAdupliquer+'", "'+UsDateTime(StrToDate(DateValidite))+'", '
                  + 'PPV_COMPTEURPRES, PPV_LIBELLE, "'+UsDateTime(Date)+'" '
                  + 'FROM PROFILCOMPTEURPRES '
                  + 'WHERE PPV_PROFILPRES="'+CodeAdupliquer+'" AND PPV_DATEVALIDITE="'+UsDateTime(StrToDate(DateValiditeOrig))+'"' );
     Except
          PGIInfo (TraduireMemoire('Les compteurs n''ont pas �t� dupliqu�s'));
          Rollback;
     End;
    (Ecran as TFVierge).Retour := DateValidite;
     Ecran.Close;
end;

Initialization
  registerclasses ( [ TOF_PGPARAMPRESENCEDUP ] ) ; 
end.
