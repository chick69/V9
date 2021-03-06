{***********UNITE*************************************************
Auteur  ...... : M.ENTRESSANGLE
Cr�� le ...... : 21/10/2002
Modifi� le ... :   /  /    
Description .. : Pour s�lectionner un param�trage
Mots clefs ... : 
*****************************************************************}

unit USelectScript;

interface

uses
  Classes, Controls, StdCtrls, Forms,
  DB, DBGrids, DBTables, ExtCtrls, UPDomaine, Hqry, Grids, ADODB,
  udbxDataset, Hctrls;

type
  TFSelScript = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    ScriptSelect: TEdit;
    Panel3: TPanel;
    TDOMAINE: TLabel;
    SQ: TDataSource;
    Domaine: THValComboBox;
    Q: TQuery;
    QProfile: TStringField;
    QTablename: TStringField;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DOMAINEChange(Sender: TObject);
  private
    { d�clarations priv�es }
    DDomaine   : string;
  public
    { d�clarations publiques }
  end;

var
  FSelScript: TFSelScript;

Function  SelectScript (Var Dom : string): String;

implementation

uses UDMIMP;

{$R *.DFM}

Function SelectScript(Var Dom : string): String;
BEGIN
  FSelScript :=TFSelScript.Create(Application) ;
  Try
       FSelScript.ShowModal ;
  Finally
       Result := FSelScript.ScriptSelect.Text;
       Dom := FSelScript.DDomaine;
       FSelScript.Free ;
  End ;
END ;


procedure TFSelScript.DBGrid1DblClick(Sender: TObject);
begin
	ScriptSelect.Text := DBGrid1.SelectedField.Text;
        Q.DatabaseName := DMImport.DBGlobal.Name;
        DDomaine := DBGrid1.Fields[2].Text;
	ModalResult := mrOK;
end;

procedure TFSelScript.FormShow(Sender: TObject);
var
SelectQL    : string;
begin
    Q := OpenSQLADO (' SELECT Domaine,CLE,COMMENT from '+DMImport.GzImpReq.TableName, DMImport.Db );
    DDomaine   := Q.FindField('Domaine').asstring;
    ChargementComboDomaine (Domaine);
    SQ.DataSet := Q;
end;

procedure TFSelScript.DOMAINEChange(Sender: TObject);
var
SelectQL    : string;
begin
    SelectQL := ' SELECT Domaine,CLE,COMMENT from '+DMImport.GzImpReq.TableName
    + ' Where Domaine="'+ Domaine.Text+'"';
    Q := OpenSQLADO (SelectQL, DMImport.Db );
    DDomaine   := Q.FindField('Domaine').asstring;
end;

end.
