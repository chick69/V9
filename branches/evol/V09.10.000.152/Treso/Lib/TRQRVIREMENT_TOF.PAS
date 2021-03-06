{ Unit� : Source TOF de la FICHE : TRQRVIREMENT
--------------------------------------------------------------------------------------
    Version   |  Date  | Qui |   Commentaires
--------------------------------------------------------------------------------------
 0.91          24/10/03  JP   Cr�ation de l'unit�
 7.05.001.001  06/10/06  JP   Gestion des ParamSoc multi soci�t�s
 7.05.001.001  24/10/06  JP   Gestion des filtres multi soci�t�s
                              Mise en place de l'anc�tre des �tats
--------------------------------------------------------------------------------------}
unit TRQRVIREMENT_TOF ;

interface

uses
  StdCtrls, Controls, Classes,
  {$IFNDEF EAGLCLIENT}
  QRS1, FE_Main,
  {$ELSE}
  eQRS1, MaineAGL,
  {$ENDIF}
  Sysutils, HCtrls, HEnt1, UTOF, uAncetreEtat;

type
  TOF_TRQRVIREMENT = class (TRANCETREETAT)
    procedure OnArgument(S : string); override;
    procedure OnLoad                ; override;
  private
    OrdreOk : Boolean;
    procedure BanqueOnChange(Sender : TObject);
  end ;

procedure TRLanceFiche_EtatVirement(Dom, Fiche, Range, Lequel, Arguments : string);

implementation

uses
  {$IFDEF TRCONF}
  UlibConfidentialite,
  {$ENDIF TRCONF}
  Commun{AssignDrapeau};

{---------------------------------------------------------------------------------------}
procedure TRLanceFiche_EtatVirement(Dom, Fiche, Range, Lequel, Arguments : string);
{---------------------------------------------------------------------------------------}
begin
  AGLLanceFiche(Dom, Fiche, Range, Lequel, Arguments);
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRVIREMENT.OnArgument (S : String ) ;
{---------------------------------------------------------------------------------------}
begin
  AvecParamSoc := True;
  inherited;

  Ecran.HelpContext := 150;
  OrdreOk := ReadTokenSt(S) = 'ORDRE';
  if OrdreOk then Ecran.Caption := '�ditions des ordres de virements'
             else Ecran.Caption := '�ditions des lettre de confirmation de virements';
  UpdateCaption(Ecran);
  if OrdreOk then
    SetControlText('ORDRE', 'X')
  else begin
    TCheckBox(GetControl('TEQ_FICEXPORT')).Checked := True;
    SetControlVisible('TEQ_FICEXPORT', False);
  end;

  {24/10/06 : On filtre les comptes en fonction des soci�t�s du regroupement Tr�so}
  if not EtatMD then begin
    THEdit(GetControl('TEQ_SGENERAL')).Plus := FiltreBanqueCp(THEdit(GetControl('TEQ_SGENERAL')).DataType, '', '');
    THEdit(GetControl('TEQ_DGENERAL')).Plus := FiltreBanqueCp(THEdit(GetControl('TEQ_DGENERAL')).DataType, '', '');
  end;
  THValComboBox(GetControl('TEQ_SBANQUE')).OnChange := BanqueOnChange;
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRVIREMENT.OnLoad;
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
  DConf   := AliasSQL(SQLConf, 'BQ', 'B1');
  SConf   := AliasSQL(SQLConf, 'BQ', 'B2');
  XX_WHERECONF.Text := DConf + SConf;
  {$ENDIF TRCONF}
end;

{---------------------------------------------------------------------------------------}
procedure TOF_TRQRVIREMENT.BanqueOnChange(Sender: TObject);
{---------------------------------------------------------------------------------------}
begin
  if not EtatMD then
    THEdit(GetControl('TEQ_SGENERAL')).Plus := FiltreBanqueCp(THEdit(GetControl('TEQ_SGENERAL')).DataType, '', '')
  else
    THEdit(GetControl('TEQ_SGENERAL')).Plus := '';

  if GetControlText('TEQ_SBANQUE') <> '' then
    THEdit(GetControl('TEQ_SGENERAL')).Plus := THEdit(GetControl('TEQ_SGENERAL')).Plus + ' AND BQ_BANQUE = "' + GetControlText('TEQ_SBANQUE') + '"';
  SetControlText('TEQ_SGENERAL', '');
end;

initialization
  RegisterClasses([TOF_TRQRVIREMENT]);

end.
