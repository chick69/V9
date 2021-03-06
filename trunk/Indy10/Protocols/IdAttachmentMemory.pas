{ $HDR$}
{**********************************************************************}
{ Unit archived using Team Coherence                                   }
{ Team Coherence is Copyright 2002 by Quality Software Components      }
{                                                                      }
{ For further information / comments, visit our WEB site at            }
{ http://www.TeamCoherence.com                                         }
{**********************************************************************}
{}
{ $Log:  13732: IdAttachmentMemory.pas
{
{   Rev 1.6    6/29/04 12:27:14 PM  RLebeau
{ Updated to remove DotNet conditionals
{ 
{ Updated constructor to call SetDataString()
}
{
{   Rev 1.5    2004.02.03 5:44:52 PM  czhower
{ Name changes
}
{
{   Rev 1.4    2004.02.03 2:12:04 PM  czhower
{ $I path change
}
{
{   Rev 1.3    24/01/2004 19:07:18  CCostelloe
{ Cleaned up warnings
}
{
{   Rev 1.2    14/12/2003 18:07:16  CCostelloe
{ Changed GetDataString to avoiud error 'String element cannot be passed to var
{ parameter'
}
{
{   Rev 1.1    13/05/2003 20:28:04  CCostelloe
{ Bug fix: remove default values in Create to avoid ambiguities with
{ Create(TCollection)
}
{
{   Rev 1.0    11/14/2002 02:12:46 PM  JPMugaas
}
unit IdAttachmentMemory;

interface

{$I IdCompilerDefines.inc}

uses
  Classes, SysUtils, IdAttachment, IdMessageParts, IdGlobal;

type
  TIdAttachmentMemory = class(TIdAttachment)
  protected
    FDataStream: TMemoryStream;
    FDataStreamBeforeLoadPosition: Int64;

    function GetDataStream: TStream;
    function GetDataString: string;
    procedure SetDataStream(const Value: TStream);
    procedure SetDataString(const Value: string);
  public
    {CC: Bug fix, remove default values to resolve ambiguities with Create(TCollection).}
    {constructor Create(Collection: TIdMessageParts; const CopyFrom: TStream = nil); reintroduce; overload;
    constructor Create(Collection: TIdMessageParts; const CopyFrom: String = ''); reintroduce; overload;}
    constructor Create(Collection: TIdMessageParts; const CopyFrom: TStream); reintroduce; overload;
    constructor Create(Collection: TIdMessageParts; const CopyFrom: String); reintroduce; overload;
    constructor Create(Collection: TCollection); overload; override;
    destructor Destroy; override;

    property DataStream: TStream read GetDataStream write SetDataStream;
    property DataString: string read GetDataString write SetDataString;
    function OpenLoadStream: TStream; override;
    procedure CloseLoadStream; override;
    procedure FinishTempStream; override;
    function PrepareTempStream: TStream; override;
  end;

implementation

{ TIdAttachmentMemory }

constructor TIdAttachmentMemory.Create(Collection: TIdMessageParts;
  const CopyFrom: TStream);
begin
  inherited Create(Collection);
  FDataStream := TMemoryStream.Create();
  if Assigned(CopyFrom) then begin
    FDataStream.CopyFrom(CopyFrom, CopyFrom.Size);
  end;
end;

procedure TIdAttachmentMemory.CloseLoadStream;
begin
  DataStream.Position := FDataStreamBeforeLoadPosition;
end;

constructor TIdAttachmentMemory.Create(Collection: TIdMessageParts;
  const CopyFrom: String);
begin
  inherited Create(Collection);
  FDataStream := TMemoryStream.Create;
  SetDataString(CopyFrom);
end;

destructor TIdAttachmentMemory.Destroy;
begin
  FDataStream.Free;
  inherited;
end;

function TIdAttachmentMemory.GetDataStream: TStream;
begin
  Result := FDataStream;
end;

function TIdAttachmentMemory.GetDataString: string;
var
  Pos: Int64;
begin
  Pos := FDataStream.Position;
  try
    FDataStream.Position := 0;
    Result := ReadStringFromStream(FDataStream, FDataStream.Size);
  finally
    FDataStream.Position := Pos;
  end;
end;

function TIdAttachmentMemory.OpenLoadStream: TStream;
begin
  FDataStreamBeforeLoadPosition := DataStream.Position;
  DataStream.Position := 0;
  Result := DataStream;
end;

procedure TIdAttachmentMemory.SetDataStream(const Value: TStream);
begin
  FDataStream.CopyFrom(Value, Value.Size);
end;

procedure TIdAttachmentMemory.SetDataString(const Value: string);
begin
  FDataStream.Size := 0;
  WriteStringToStream(FDataStream, Value);
end;

procedure TIdAttachmentMemory.FinishTempStream;
begin
  DataStream.Position := 0;
end;

function TIdAttachmentMemory.PrepareTempStream: TStream;
begin
  DataStream.Size := 0;
  Result := DataStream;
end;

constructor TIdAttachmentMemory.Create(Collection: TCollection);
begin
  inherited;
  FDataStream := TMemoryStream.Create;
end;

initialization
  RegisterClasses([TIdAttachmentMemory]);
end.
