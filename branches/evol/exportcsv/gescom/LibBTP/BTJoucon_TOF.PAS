{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 17/02/2004
Modifi� le ... :   /  /
Description .. : Source TOF de la FICHE : BTJOUCON ()
Mots clefs ... : TOF;BTJOUCON
*****************************************************************}
unit BTJOUCON_TOF;

interface

uses StdCtrls,
  Controls,
  Classes,
  {$IFNDEF EAGLCLIENT}
  db,
  {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF}
  Fe_Main,
  {$ELSE}
  MaineAGL,
  {$ENDIF}
  forms,
  sysutils,
  ComCtrls,
  Menus,
  HCtrls,
  HEnt1,
  HMsgBox,
  UTOF,
  Stat,
  HQry,
  UTOB,
  utobview,
  AGLInit,
  facture,
  uTofAfBaseCodeAffaire,
  CalcOLEGenericBTP;

type
  TOF_BTJOUCON = class(TOF_AFBASECODEAFFAIRE)
    procedure OnNew; override;
    procedure OnDelete; override;
    procedure OnUpdate; override;
    procedure OnLoad; override;
    procedure OnArgument(S: string); override;
    procedure OnClose; override;
    procedure NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit); override;

  private
    TV1         : TTobViewer;
    TOBBJC      : TOB;
    DateDeb     : TDateTime;
    DateFin     : TDateTime;
    CodeAffaire : String;
    CodeAffaire1: String;
    CodeAffaire2: String;
    CodeAffaire3: String;
    Ressource   : String;
    Nature      : string;
    //
    Ok_FullScreen : Boolean;
    //FV1 : 18/02/2014 - FS#892 - BAGE : Appel journal des consommations depuis la saisie des restes � d�penser
    LanceAuto   : Boolean;
    //
    procedure OnDblClickTV(Sender: TObject);
    procedure ChargeLesConsos;
    procedure CompletelesInfos;
    procedure AddChampsSupLoc(TOBB: TOB);
    procedure AlimenteInfoProv(TOBL, TOBF: TOB);
    procedure ControleChamp(Champ, Valeur: String);
    procedure ControleCritere(Critere: String);
  end;

implementation
uses Windows,vierge;

procedure TOF_BTJOUCON.OnNew;
begin
  inherited;
end;

procedure TOF_BTJOUCON.OnDelete;
begin
  inherited;
end;

procedure TOF_BTJOUCON.OnUpdate;
begin
  inherited;

  ChargeLesConsos;

  CompletelesInfos;

  if TOBBJC <> nil then TFStat(Ecran).LaTOB := TOBBJC;

end;

procedure TOF_BTJOUCON.OnLoad;
begin
  inherited;

  DateDeb := StrtoDate(GetControltext('BJCDATE'));
  DateFin := StrtoDate(GetControltext('BJCDATE_'));

  CodeAffaire := GetControltext('BJCAFFAIRE');
  CodeAffaire1 := GetControltext('BJCAFFAIRE1');
  CodeAffaire2 := GetControltext('BJCAFFAIRE2');
  CodeAffaire3 := GetControltext('BJCAFFAIRE3');

  Ressource := GetControltext('BJCRESSOURCE');

  Nature := GetControltext('BJCNATURE');
  if Ok_FullScreen then
  begin
  	ShowWindow(TForm(Ecran).Handle, SW_SHOWMAXIMIZED);
  	// PassagePleinEcran(THForm(Ecran)); //TForm(Ecran).WindowState := wsMaximized;
  end;


end;

procedure TOF_BTJOUCON.OnArgument(S: string);
var stArgument,Critere,Champ,Valeur : string;
		X : integer;
begin

  LanceAuto := False;
  Ok_fullScreen := false;

  SetControlText('XX_WHERE', '');

  // traitement des param�tres
  stArgument := S;
  Critere := (Trim (ReadTokenSt (stArgument)));

  while (Critere <> '') do
  begin
    if Critere <> '' then
    begin
      X := pos ('=', Critere) ;
      if x <> 0 then
      begin
        Champ := copy (Critere, 1, X - 1) ;
        Valeur := Copy (Critere, X + 1, length (Critere) - X) ;
        ControleChamp(Champ, Valeur);
      end;
    end;
    ControleCritere(Critere);
    Critere := (Trim (ReadTokenSt (stArgument))) ;
  end;
  inherited;

  // Gestion des �v�nements du TB

  TV1 := TTobViewer(GetControl('TV'));
  TV1.OnDblClick := OnDblClickTV;
  TOBBJC := TOB.create('Ma Tob', nil, -1);

end;

Procedure TOF_BTJOUCON.ControleChamp(Champ, Valeur : String);
var Aff0,Aff1,Aff2,Aff3,Aff4 : string;
begin

  if Champ = 'AFFAIRE' then
  begin
    BTPCodeAffaireDecoupe (valeur,Aff0,Aff1,Aff2,Aff3,Aff4,tacreat,false);
    SetControltext('BJCAFFAIRE',Valeur);
    SetControltext('BJCAFFAIRE0', Aff0);
    SetControltext('BJCAFFAIRE1', Aff1);
    SetControltext('BJCAFFAIRE2', Aff2);
    SetControltext('BJCAFFAIRE3', Aff3);
  end;

  if Champ = 'DATEDEB' then
  begin
    SetControltext('BJCDATE',Valeur);
  end;

  if Champ = 'DATEFIN' then
  begin
    SetControltext('BJCDATE_',Valeur);
  end;

  if Champ = 'NATUREMOUV' then SetControltext('BJCNATURE',Valeur);

end;

Procedure TOF_BTJOUCON.ControleCritere(Critere : String);
begin

  If Critere = 'AVANCE' then SetControlText('XX_WHERE', 'AND BCO_NATUREMOUV IN ("EXT","MO")');

  If Critere = 'FULLSCREEN' then Ok_FullScreen := True

end;

procedure TOF_BTJOUCON.OnClose;
begin
  inherited;
  if TOBBJC <> nil then FreeAndNil(TOBBJC);
end;

//******************************************************************************
//********************* Zooms / double clic  ***********************************
//******************************************************************************

procedure TOF_BTJOUCON.OnDblClickTV(Sender: TObject);
begin
end;

procedure TOF_BTJOUCON.NomsChampsAffaire(var Aff, Aff0, Aff1, Aff2, Aff3, Aff4, Aff_, Aff0_, Aff1_, Aff2_, Aff3_, Aff4_, Tiers, Tiers_: THEdit);
begin
  Aff0 := THEdit(GetControl('BJCAFFAIRE0'));
  Aff := THEdit(GetControl('BJCAFFAIRE'));
  Aff1 := THEdit(GetControl('BJCAFFAIRE1'));
  Aff2 := THEdit(GetControl('BJCAFFAIRE2'));
  Aff3 := THEdit(GetControl('BJCAFFAIRE3'));
  Aff4 := THEdit(GetControl('BJCAVENANT'));
end;

procedure TOF_BTJOUCON.ChargeLesConsos;
var
  Req, stWhere : string;
  QQ: Tquery;
begin
  Req := TFStat(Ecran).stSQL;
  // On met � jour la TOB uniquement pour les chantiers
  // ayant des mouvements dans les dates s�lectionn�es
  Req := Req + ' AND BCO_DATEMOUV BETWEEN "' + UsDateTime(DateDeb) +
    '" AND "' + UsDateTime(DateFin) + '"';

  if CodeAffaire <> '' then
  begin
    Req := Req + ' AND BCO_AFFAIRE = "' + CodeAffaire + '"';
  end
  else
  begin
    if CodeAffaire1 <> '' then
      Req := Req + ' AND BCO_AFFAIRE1 = "' + CodeAffaire1 + '"';
    if CodeAffaire2 <> '' then
      Req := Req + ' AND BCO_AFFAIRE2 = "' + CodeAffaire2 + '"';
    if CodeAffaire3 <> '' then
      Req := Req + ' AND BCO_AFFAIRE3 = "' + CodeAffaire3 + '"';
  end;
  if Ressource <> '' then
  begin
    Req := Req + ' AND BCO_RESSOURCE = "' + Ressource + '"';
  end;
  if Nature <> '' then
  begin
    Req := Req + ' AND BCO_NATUREMOUV = "' + Nature + '"';
  end;

  QQ := OpenSQL(Req, true,-1,'',true);
  TOBBJC.LoadDetailDB('', '', '', QQ, false);
  ferme(QQ);

end;

procedure TOF_BTJOUCON.AddChampsSupLoc (TOBB : TOB);
begin
	TOBB.AddChampSupValeur ('Fournisseur','');
	TOBB.AddChampSupValeur ('Provenance','');
end;

procedure TOF_BTJOUCON.AlimenteInfoProv (TOBL,TOBF : TOB);
var prov : string;
begin
	TOBL.putValue('Fournisseur',TOBF.GetValue('GL_TIERS'));
  Prov := RechDom ('GCNATUREPIECEG',TOBF.GetValue('BCO_NATUREPIECEG'),false)+' '+
  				IntToStr(TOBF.GetValue('BCO_NUMERO'))+ ' du '+DateToStr(TOBF.GetValue('GL_DATEPIECE'));
	TOBL.putValue('Provenance',prov);
end;

procedure TOF_BTJOUCON.CompletelesInfos;
var Indice : integer;
		TOBL,TOBF : TOB;
    TOBProv : TOB;
    QQ : TQuery;
    Req : String;
begin
	TOBProv := TOB.Create ('LES LIGNES FOUR',nil,-1);
  for Indice := 0 to TOBBJC.detail.count -1 do
  begin
    TOBL := TOBBJC.detail[Indice];
  	AddChampsSupLoc (TOBL);
    if (TCheckBox(GetCOntrol('INCLUSINFOFOU')).Checked) then
    begin
      if (TOBL.GetValue('BCO_NATUREMOUV')='FOU') or (TOBL.GetValue('BCO_NATUREMOUV')='EXT') then
      begin
        TOBProv.ClearDetail;
        Req := 'SELECT GL_TIERS,GL_DATEPIECE,BCO_NATUREPIECEG,BCO_SOUCHE,BCO_NUMERO,BCO_INDICEG '+
                       'FROM CONSOMMATIONS LEFT JOIN LIGNE ON GL_NATUREPIECEG=BCO_NATUREPIECEG AND '+
                       'GL_SOUCHE=BCO_SOUCHE AND GL_NUMERO=BCO_NUMERO AND GL_INDICEG=BCO_INDICEG ';
        if (TOBL.GetValue('BCO_NATUREPIECEG')='AF') or (TOBL.GetValue('NATUREPIECEG')='AFS') then     //Pas de lienvente pour les avoirs forunisseurs
          Req := Req + 'WHERE BCO_NUMMOUV='+floatToStr(TOBL.GetValue('BCO_NUMMOUV'))
        else
          Req := Req + 'WHERE BCO_LIENVENTE='+floatToStr(TOBL.GetValue('BCO_NUMMOUV'));

        QQ := OpenSql (req,true,-1,'',true);
        if not QQ.eof then
        begin
          TOBProv.LoadDetailDB ('CONSOMMATIONS','','',QQ,false);
          TOBF := TOBProv.findFirst(['BCO_NATUREPIECEG'],['FF'],true);
          if TOBF = nil then
          begin
            TOBF := TOBProv.findFirst(['BCO_NATUREPIECEG'],['AF'],true);
            if TOBF = nil then
            begin
              TOBF := TOBProv.findFirst(['BCO_NATUREPIECEG'],['AFS'],true);
              if TOBF = nil then
              begin
                TOBF := TOBProv.findFirst(['BCO_NATUREPIECEG'],['BLF'],true);
                if TOBF = nil then
                begin
                  TOBF := TOBProv.findFirst(['BCO_NATUREPIECEG'],['LFR'],true);
                  if TOBF <> nil then
                  begin
                    AlimenteInfoProv (TOBL,TOBF);
                  end;
                end else
                begin
                  AlimenteInfoProv (TOBL,TOBF);
                end;
              end else
              begin
                AlimenteInfoProv (TOBL,TOBF);
              end;
            end else
            begin
              AlimenteInfoProv (TOBL,TOBF);
            end;
          end else
          begin
            AlimenteInfoProv (TOBL,TOBF);
          end;
        end;
        ferme (QQ);
      end;
    end;
  end;
  if TOBProv <> nil then FreeAndNil(TOBProv);
end;

initialization
  registerclasses([TOF_BTJOUCON]);
end.
