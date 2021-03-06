{***********UNITE*************************************************
Auteur  ...... :
Cr�� le ...... : 14/02/2001
Modifi� le ... :   /  /
Description .. : Source TOM de la TABLE : NATUREPREST (NATUREPREST)
Mots clefs ... : TOM;NATUREPREST
*****************************************************************}
Unit UTOMNATUREPREST ;

Interface

Uses StdCtrls, Controls, Classes, db, forms, sysutils, {$IFNDEF DBXPRESS} dbTables, {$ELSE} uDbxDataSet, {$ENDIF} ComCtrls,
     HCtrls, HEnt1, HMsgBox, UTOM, UTob,
{$IFDEF EAGLCLIENT}
      eFichList, efiche,
{$ELSE}
      FichList, fiche,
{$ENDIF}
      Graphics ;
Type
  TOM_NATUREPREST = Class (TOM)
    Code : THEdit;
    Delete,Insert : TToolBar;
    MetCalcPv,MetCalcPr,MetcalcPVTtc : THValComboBox;
    procedure OnNewRecord                ; override ;
    procedure OnDeleteRecord             ; override ;
    procedure OnUpdateRecord             ; override ;
    procedure OnAfterUpdateRecord        ; override ;
    procedure OnLoadRecord               ; override ;
    procedure OnChangeField ( F: TField) ; override ;
    procedure OnArgument ( S: String )   ; override ;
    procedure OnClose                    ; override ;
    procedure OnCancelRecord             ; override ;
  private
    procedure CodeExit(Sender: Tobject);
    procedure MetPvchange(Sender: Tobject);
    procedure MetPRchange(Sender: Tobject);
    procedure MetPvTTcChange(Sender: Tobject);
    end ;
const
	// libell�s des messages
	TexteMessage: array[1..4] of string 	= (
          {1}        'Vous devez renseigner un Code nature' //Catalogue
          {2}        ,'Vous devez renseigner la d�signation'  //Catalogue
          {3}        ,'Supression Impossible. Des prestations sont affect�es avec cette nature'  //Catalogue
          {4}        ,'Vous devez indiquer une m�thode de calcul du Prix HT'  //Catalogue
                     );

Implementation

procedure TOM_NATUREPREST.OnNewRecord ;
begin
  Inherited ;
  SetField ('BNP_TYPERESSOURCE','SAL');
  SetField ('BNP_CALCPRIXHT','AUC');
  SetField ('BNP_CALCPRIXPR','AUC');
  SetField ('BNP_CALCPRIXTTC','AUC');
end ;

procedure TOM_NATUREPREST.OnDeleteRecord ;
begin
  Inherited ;
if existeSql ('SELECT GA_LIBELLE FROM ARTICLE WHERE GA_NATUREPRES ="' + Getfield('BNP_NATUREPRES') + '"') then
begin
   lasterror:=3;
   PGIBox (TexteMessage[lasterror],String(ecran.Caption));
   exit
end;
end ;

procedure TOM_NATUREPREST.OnUpdateRecord ;
begin
  Inherited ;
  lasterror := 0;
  if Getfield('BNP_NATUREPRES') = '' then
  begin
     lasterror := 1;
     SetFocusControl('BNP_NATUREPRES');
  end
  else if Getfield ('BNP_LIBELLE') = '' then
  begin
     lasterror := 2;
     SetFocusControl('BNP_LIBELLE');
  end
  else if getfield('BNP_CALCPRIXHT') = '' then
  begin
     lasterror := 4;
     SetFocusControl('BNP_CALCPRIXHT');
  end;
  if lasterror <> 0 then
  begin
       PGIBox (TexteMessage[lasterror],String(ecran.Caption));
       Exit;
  end;
end ;

procedure TOM_NATUREPREST.OnAfterUpdateRecord ;
begin
  Inherited ;
end ;

procedure TOM_NATUREPREST.OnLoadRecord ;
begin
  Inherited ;
  // PR
  Thedit(getcontrol('BNP_COEFCALCPR')).Enabled := (getfield('BNP_CALCPRIXPR') <> 'AUC');
  TCheckBox(getcontrol('BNP_CALCAUTOPR')).Enabled  := (getfield('BNP_CALCPRIXPR') <> 'AUC');
  // PV HT
  Thedit(getcontrol('BNP_COEFCALCHT')).Enabled := (getfield('BNP_CALCPRIXHT') <> 'AUC');
  TCheckBox(getcontrol('BNP_CALCAUTOHT')).Enabled  := (getfield('BNP_CALCPRIXHT') <> 'AUC');
  // PV TTC
  Thedit(getcontrol('BNP_COEFCALCTTC')).Enabled := (getfield('BNP_CALCPRIXTTC') <> 'AUC');
  TCheckBox(getcontrol('BNP_CALCAUTOTTC')).Enabled  := (getfield('BNP_CALCPRIXTTC') <> 'AUC');

  if (getfield('BNP_CALCPRIXHT') <> 'AUC') then
      Thedit(getcontrol('BNP_COEFCALCHT')).Color  := clwindow
  else
      Thedit(getcontrol('BNP_COEFCALCHT')).Color  := clInactiveCaptiontext;

  if (getfield('BNP_CALCPRIXPR') <> 'AUC') then
      Thedit(getcontrol('BNP_COEFCALCPR')).Color  := clwindow
  else
      Thedit(getcontrol('BNP_COEFCALCPR')).Color  := clInactiveCaptiontext;

  if (getfield('BNP_CALCPRIXTTX') <> 'AUC') then
      Thedit(getcontrol('BNP_COEFCALCTTC')).Color  := clwindow
  else
      Thedit(getcontrol('BNP_COEFCALCTTC')).Color  := clInactiveCaptiontext;

end ;

procedure TOM_NATUREPREST.OnChangeField ( F: TField ) ;
begin
  Inherited ;
end ;

procedure TOM_NATUREPREST.OnArgument ( S: String ) ;
begin
  Inherited ;
  TToolbar (GetControl ('Binsert')).Visible := false;
  TToolbar (GetControl ('Bdelete')).Visible := true;
  MetCalcPv := THVAlComboBox(ecran.FindComponent ('BNP_CALCPRIXHT'));
  MetCalcPv.OnChange  := MetPvChange;
  MetCalcPR := THVAlComboBox(ecran.FindComponent ('BNP_CALCPRIXPR'));
  MetCalcPR.OnChange  := MetPRChange;
  MetCalcPVTtc := THVAlComboBox(ecran.FindComponent ('BNP_CALCPRIXTTC'));
  MetCalcPVTTC.OnChange  := MetPVTTCChange;

  Code := THedit (ecran.FindComponent ('BNP_NATUREPRES'));
  Code.OnExit := CodeExit;
end ;

procedure TOM_NATUREPREST.MetPvchange ( Sender : Tobject);
begin
   Thedit(getcontrol('BNP_COEFCALCHT')).Enabled := (MetcalcPv.value <> 'AUC');
   if (MetcalcPv.value <> 'AUC') then
      Thedit(getcontrol('BNP_COEFCALCHT')).Color  := clwindow
   else
      Thedit(getcontrol('BNP_COEFCALCHT')).Color  := clInactiveCaptiontext;
   TCheckBox(getcontrol('BNP_CALCAUTOHT')).Enabled  := (MetcalcPv.value <> 'AUC');
end;

procedure TOM_NATUREPREST.MetPvTTcChange ( Sender : Tobject);
begin
   Thedit(getcontrol('BNP_COEFCALCTTC')).Enabled := (MetcalcPvTTc.value <> 'AUC');
   if (MetcalcPvTTc.value <> 'AUC') then
      Thedit(getcontrol('BNP_COEFCALCTTC')).Color  := clwindow
   else
      Thedit(getcontrol('BNP_COEFCALCTTC')).Color  := clInactiveCaptiontext;
   TCheckBox(getcontrol('BNP_CALCAUTOTTC')).Enabled  := (MetcalcPvTTc.value <> 'AUC');
end;

procedure TOM_NATUREPREST.MetPRchange ( Sender : Tobject);
begin
   Thedit(getcontrol('BNP_COEFCALCPR')).Enabled := (MetcalcPR.value <> 'AUC');
   if (MetcalcPR.value <> 'AUC') then
      Thedit(getcontrol('BNP_COEFCALCPR')).Color  := clwindow
   else
      Thedit(getcontrol('BNP_COEFCALCPR')).Color  := clInactiveCaptiontext;
   TCheckBox(getcontrol('BNP_CALCAUTOPR')).Enabled  := (MetcalcPR.value <> 'AUC');
end;


procedure TOM_NATUREPREST.CodeExit ( Sender : Tobject);
begin
  Code.Text := Uppercase (Code.text);
end;


procedure TOM_NATUREPREST.OnClose ;
begin
  Inherited ;
end ;

procedure TOM_NATUREPREST.OnCancelRecord ;
begin
  Inherited ;
end ;

Initialization
  registerclasses ( [ TOM_NATUREPREST ] ) ;
end.
