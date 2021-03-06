{***********UNITE*************************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Dans cette unit�, on trouve LA FONCTION qui sera
Suite ........ : appel�e par l'AGL pour lancer les options.
Suite ........ : Ainsi que la gestion de l'HyperZoom, de la gestion de
Suite ........ : l'arobase, ...
Suite ........ : C'est aussi dans cette unit� que l'on d�fini le fichier ini
Suite ........ : utilis�, le nom de l'application, sa version, que l'on lance la
Suite ........ : s�rialisation, les diff�rentes possibilit�s d'action sur la mise �
Suite ........ : jour de structure, ...
Mots clefs ... : IMPORTANT;STRCTURE;MENU;SERIALISATION
*****************************************************************}
unit MENUEDTGG;

interface
Uses
  Windows, Messages,
  HEnt1,EntPGI,
{$ifdef eAGLClient}
  MenuOLX,MaineAGL,eTablette, UtilEagl,

{$else}
  MenuOLG, FE_Main,EdtEtat,
{$endif eAGLClient}

  Forms,sysutils,HMsgBox, Classes, Controls, HPanel,
  hctrls, MajTable,
  ExtCtrls, inifiles, UTOB,
  ImgList,Choix ;

Procedure InitApplication ;

type
  TFMenuDisp = class(TDatamodule)
    ImageList1  : TImageList;
    end ;

Var FMenuDisp : TFMenuDisp ;
    Soc,User,Motdepass    : string;
    OkExport,Minimise : Boolean;
implementation

{$R *.DFM}

Uses LicUtil,Ent1,
     ParamSoc, EdtREtat, ComCtrls, CPGRANDLIVRETL_TOF
      ;

Procedure RenseignelaSerieGG ;

begin
HalSocIni:='CEGIDPGI.INI' ;
//If OkSic Then HalSocIni:='CEGIDPGISIC.INI' ;

V_PGI.NumVersionBase:=0 ;
V_PGI.NumVersion:='1.0.0' ;
V_PGI.NumBuild:='002.001' ;
V_PGI.DateVersion:=EncodeDate(2007,02,16) ;


{$IFDEF EAGLCLIENT}
NomHalley:='EDT23' ;
TitreHalley:='Editions comptables' ;
{$ELSE}
NomHalley:='EDT23' ;
TitreHalley:='Editions comptables' ;
{$ENDIF}
Application.Title := TitreHalley ;

END ;


Procedure GoMenu(SuperUser : Boolean) ;
BEGIN
{$ifdef eAGLClient}
FMenuG.SetFunctions([TraduireMemoire('Edition analytique'),
                     TraduireMemoire('Liste analytique'),
                     TraduireMemoire('GL Analytique TL'),
                     TraduireMemoire('Param�trage'),
                     TraduireMemoire('Import data')
                    ],
                    [45100,45200,45250,45300,45600],
                    [46,47,48,49,60])
{$else}
FMenuG.SetFunctions([TraduireMemoire('Edition analytique'),
                     TraduireMemoire('Liste analytique'),
                     TraduireMemoire('GL Analytique TL'),
                     TraduireMemoire('Param�trage'),
                     TraduireMemoire('Import data')
                    ],
                    [45100,45200,45250,45300,45600],
                    [46,47,48,49,60])
{$endif}
END ;

FUNCTION CHARGEMAGHALLEYGG : Boolean ;
Var SuperUser : Boolean ;
    GG : Boolean ;
BEGIN
gg:=VH^.ModeSilencieux ; VH^.ModeSilencieux:=TRUE ;
Result:=CHARGEMAGHALLEY ;
SuperUser:=(V_PGI.PassWord=CryptageSt(DayPass(Date))) ;
GoMenu(SuperUser) ;
ChargeMenuPop(integer(hm2),FMenuG.DispatchX) ;
VH^.ModeSilencieux:=gg ;
END ;

//exemple rem c:\pgi00\app\COMSX.EXE /TRF=r�pertoire;Fichier d'import;IMPORT;SOCIETE;UTILISTATEUR;Adresse Email;TYPE �criture;TYPE �criture;Fichier RAPPORT;Gestion DOUBLON;Controle Paramsoc; Mode SANSECHEC;Option Minimis�
//exemple C:\PGI00\APP\COMSX.EXE /TRF=C:\tmp\FFF\;JOURNALGI.TRA;IMPORT;SECALDOS;CEGID;mentressangle@cegid.fr;N;N;RAPPORT.LOG;FALSE;FALSE;SANSECHEC;Minimized

Procedure LanceEtatLibre ( NatureEtat : String ) ;
Var
  CodeD : String;
begin
  CodeD:=Choisir('Choix d''un �tat libre','MODELES','MO_CODE || " " || MO_LIBELLE','MO_CODE','MO_NATURE="'+NatureEtat+'" AND MO_MENU="X"','', False, False, 999999112, '');
  if CodeD<>'' then LanceEtat('E',NatureEtat,CodeD,True,False,False,Nil,'','',False);
end;

Procedure LanceListeLibre ( NatureEtat : String ) ;
Var
  CodeD : String;
begin
  CodeD:=Choisir('Choix d''une liste libre','MODELES','MO_CODE || " " || MO_LIBELLE','MO_CODE','MO_NATURE="'+NatureEtat+'" AND MO_MENU="X" AND MO_EXPORT="X"','', False, False, 999999112, '');
  if CodeD<>'' then LanceEtat('E',NatureEtat,CodeD,True,True,False,Nil,'','',False);
end;

procedure EditEtatS5S7 (Tip,Nat,Modele : String ; AvecCreation : Boolean ; Spages : TPageControl ; StSQL,Titre : String );
BEGIN
EditEtat(Tip,Nat,Modele,AvecCreation,Spages,StSQL,Titre) ;
if Nat='RLC' then AvertirTable('ttModeleRLC') else
if Nat='REL' then AvertirTable('ttModeleRelance') else
if Nat='LCH' then AvertirTable('ttModeleLettreCHQ') else
if Nat='LTR' then BEGIN AvertirTable('ttModeleLettreTRA') ; AvertirTable('ttModeleBOR') ; END else
if Nat='UCO' then AvertirTable('ttModeleDetail') else
if Nat='BOR' then AvertirTable('ttModeleBOR') else
if Nat='SAI' then AvertirTable('ttModeleSAI') else
if Nat='BAP' then AvertirTable('ttModeleBAP') ;
END ;
{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette fonction est appell�e par l'AGL � chaque s�lection
Suite ........ : d'une option de menu, en lui indiquant le TAG du menu en
Suite ........ : question. Ce qui d�clenche l'action en question.
Suite ........ : L'AGL lance aussi cette fonction directement afin d'offrir �
Suite ........ : l'application la possibilit� d'agir avant ou apr�s la connexion,
Suite ........ : et avant ou apr�s la d�connexion.
Suite ........ : Cette fonction prend aussi en param�tre retourForce et
Suite ........ : SortieHalley. Si RetourForce est � True, alors l'AGL
Suite ........ : remontera au niveau des modules, si SortieHalley est �
Suite ........ : True, alors ...
Mots clefs ... : MENU;OPTION;DISPATCH
*****************************************************************}

Procedure DispatchUtil ( Num : Integer ; PRien : THPanel ; var retourforce,sortiehalley : boolean);
var
Numopt         : integer;
BEGIN
     Numopt := Num;
   case Numopt of
     16 :
     begin
     end;
     10 :
     begin
{$IFNDEF EAGLCLIENT}
{$IFDEF SCANGED}
        if V_PGI.RunFromLanceur then
          InitializeGedFiles(V_PGI.DefaultSectionDbName, nil)
        else
          InitializeGedFiles(V_PGI.DbName, nil);
{$ENDIF}
{$ENDIF}
          V_PGI.SAV:=FALSE ; //Apres connection
     end;
     11 :
          begin
               V_PGI.SAV:=FALSE ;
//               TCPContexte.Release;

          end;//Apr�s deconnection
     12 : BEGIN
             // Interdiction de lancer en direct
{$IFNDEF EAGLCLIENT}
          RenseignelaSerieGG ;
{$ENDIF}

          V_PGI.SAV:=FALSE ; //Avant connection ou seria
{$ifndef eAGLClient}
          FMenuG.OkVerifStructure:=FALSE ;
{$endif}
          END ;
     13 : V_PGI.SAV:=FALSE ; //Avant deconnection
     15 : ;
     100 : ;

     45100 : LanceEtatLibre('UCO') ;
     45200 : LanceListeLibre('UCO') ;
     45250 : CPLanceFiche_EtatGrandLivreSurTables;
     45300 : BEGIN
             EditEtatS5S7('E','UCO','',True,nil,'','') ;
{$IFDEF EAGLCLIENT}
             AvertirCacheServer('FORMES') ;
             AvertirCacheServer('FORMESP') ;
             AvertirCacheServer('MENU') ;
             AvertirCacheServer('MODELE') ;
             AvertirCacheServer('MODEDATA') ;
{$ENDIF}
             END ;

     45600 : BEGIN
             V_PGI.NumVersionBase:=850 ;
             AGLLanceFiche('YY', 'YYIMPORTOBJET', '', '', ''); // Import d'objets
{$IFDEF EAGLCLIENT}
             AvertirCacheServer('FORMES') ;
             AvertirCacheServer('FORMESP') ;
             AvertirCacheServer('MENU') ;
             AvertirCacheServer('MODELE') ;
             AvertirCacheServer('MODEDATA') ;
{$ENDIF}
             V_PGI.NumVersionBase:=0 ;
             END ;

     // liste des mouvement modifies et point�es
    else HShowMessage('2;?caption?;Fonction non disponible : ;W;O;O;O;',TitreHalley,IntToStr(Num)) ;
  end ;
END ;

{***********A.G.L.***********************************************
Auteur  ...... : Xavier PERSOUYRE
Cr�� le ...... : 09/08/2001
Modifi� le ... :   /  /
Description .. : Cette proc�dure permet d'initiliaser certaines r�f�rence de
Suite ........ : fonction, les modules des menus g�r�s par l'application, ...
Suite ........ :
Suite ........ : Cette proc�dure est appel�e directement dans le source du
Suite ........ : projet.
Mots clefs ... : INITILISATION
*****************************************************************}

Procedure AfterProtec ( sAcces : String ) ;
BEGIN
VH^.OkModCompta:=True ; VH^.OkModBudget:=TRUE ; VH^.OkModImmo:=TRUE ;
//V_PGI.Monoposte:=TRUE ;
V_PGI.VersionDemo:=FALSE ;

END ;


procedure InitApplication ;
begin
     { R�f�rence � la fonction PRINCIPALE qui permet de lancer les actions en fonction de la
       s�lection d'une option des menus.
       }
     FMenuG.OnDispatch:=DispatchUtil ;

     { R�f�rence � une fonction qui est lanc�e apr�s la connexion � la base et le chargement du dictionnaire }
     FMenuG.OnChargeMag:=ChargeMagHalleyGG ;

     { R�f�rence � une fonction qui est lanc�e avant la mise � jour de structure }
     FMenuG.OnMajAvant:=Nil ;

{$IFNDEF EAGLCLIENT}
     { R�f�rence � une fonction qui est lanc�e pendant la mise � jour de structure }
     FMenuG.OnMajpendant:=Nil ;
{$ENDIF}

     { R�f�rence � une fonction qui est lanc�e apr�s la mise � jour de structure }
     FMenuG.OnMajApres:=Nil ;
     FMenuG.OnChangeModule:=nil ;
     OkExport := FALSE;
     Minimise := FALSE;
FMenuG.OnAfterProtec:=AfterProtec ;
RenseignelaSerieGG ;
END ;

procedure DispatchTT(Num : Integer; Action : TActionFiche; Lequel,TT,Range : String) ;
begin

end ;

Procedure InitLaVariablePGI;
Begin
Apalatys:='CEGID' ;
Copyright:='� Copyright ' + Apalatys ;

HalSocIni:='CEGIDPGI.INI' ;
//If OkSic Then HalSocIni:='CEGIDPGISIC.INI' ;
V_PGI.OutLook:=TRUE ;
V_PGI.VersionDemo:=FALSE ;
V_PGI.MenuCourant:=0 ;
V_PGI.VersionDEV:=TRUE ;
V_PGI.ImpMatrix := True ;
V_PGI.OKOuvert:=FALSE ;
V_PGI.Halley:=TRUE ;
V_PGI.OfficeMsg:=True ;
V_PGI.NumMenuPop:=27 ;
V_PGI.DispatchTT:=DispatchTT ;
V_PGI.ParamSocLast:=False ;
V_PGI.RAZForme:=TRUE ;
V_PGI.NoModuleButtons:=False ;
V_PGI.PGIContexte:=[ctxCompta] ;
V_PGI.BlockMAJStruct:=True ;
V_PGI.EuroCertifiee:=False ;

V_PGI.SAV:=False ;
V_PGI.VersionReseau:=True ;
V_PGI.CegidAPalatys:=FALSE ;
V_PGI.CegidBureau:=TRUE ;
V_PGI.StandardSurDP:=True ;
V_PGI.MajPredefini:=False ;
V_PGI.MultiUserLogin:=False ;

V_PGI.NumMenuPop:=27 ;
V_PGI.OfficeMsg:=True ;
V_PGI.NoModuleButtons:=FALSE ;
V_PGI.NbColModuleButtons:=1 ;
V_PGI.LaSerie := S5;
RenseignelaSerieGG ;
if GetSynRegKey('Outlook',2,True)=2 then
  SaveSynRegKey('Outlook',False,True);
ChargeXuelib ;
end;


Initialization
{Version}
(*
If Pos('SIC',AnsiUpperCase(ParamStr(0)))>0 Then
  BEGIN
  OKSIC:=TRUE ;
  If PARAMCOUNT=2 Then If paramstr(1)='CEGID' Then OkSIC:=FALSE ;
  END Else OKSIC:=FALSE ;
*)
ProcChargeV_PGI :=  InitLaVariablePGI ;

end.
