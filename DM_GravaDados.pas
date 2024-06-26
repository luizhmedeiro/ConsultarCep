unit DM_GravaDados;

interface

uses
  uFuncoes,
  vcl.Dialogs,
  Vcl.StdCtrls,
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, Data.DB, FireDAC.VCLUI.Wait,
  FireDAC.Comp.DataSet, FireDAC.FMXUI.Wait, FireDAC.Comp.Client;

type
  TDMD_GravaDados = class(TDataModule)
    QEndereco: TFDQuery;
    QCep: TFDQuery;
    Conexao: TFDConnection;
    QInsereCep: TFDQuery;
    Transacao: TFDTransaction;
    QEditarCep: TFDQuery;
    QTodosCep: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function LocalizarCep(ACep: String): Boolean;
    function LocalizarEndereco(ALogradouro, ACidade, AEstado: String): Boolean;
    function InserirCEP(ADataSet: TDataSet): boolean;
    procedure EditarCep(ADataSet: TDataSet);
  end;

var
  DMD_GravaDados: TDMD_GravaDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDMD_GravaDados.DataModuleCreate(Sender: TObject);
begin
begin
  try
    with Conexao do
    begin
      Params.Values['Server'] := TFuncoes.LerIni('FIREBIRD','Server');
      Params.Values['Database'] := TFuncoes.LerIni('FIREBIRD','Database');
      Params.Values['UserName'] := TFuncoes.LerIni('FIREBIRD','User');
      Params.Values['Password'] := TFuncoes.LerIni('FIREBIRD','Password');
      Connected := True;
    end;
  except
      ShowMessage('Ocorreu uma Falha na configuração no Banco Firebird!');
  end;
end;
end;

procedure TDMD_GravaDados.DataModuleDestroy(Sender: TObject);
begin
QCep.Close;
QInsereCep.Close;
QEndereco.Close;
QEditarCep.Close;
Conexao.Connected := False;
end;

function TDMD_GravaDados.InserirCEP(ADataSet: TDataSet): boolean;
begin
Result := False;

if TFuncoes.SomenteNumero(ADataSet.FieldByName('cep').AsString) = '' then
  Exit;

Transacao.StartTransaction;
try
  QInsereCEP.Close;
  QInsereCEP.ParamByName('cep'). AsString := TFuncoes.SomenteNumero(ADataSet.FieldByName('cep').AsString);
  QInsereCEP.ParamByName('logradouro'). AsString := UpperCase(ADataSet.FieldByName('logradouro').AsString);
  QInsereCEP.ParamByName('complemento'). AsString := UpperCase(ADataSet.FieldByName('complemento').AsString);
  QInsereCEP.ParamByName('bairro'). AsString := UpperCase(ADataSet.FieldByName('bairro').AsString);
  QInsereCEP.ParamByName('cidade'). AsString := UpperCase(ADataSet.FieldByName('localidade').AsString);
  QInsereCEP.ParamByName('estado'). AsString := UpperCase(ADataSet.FieldByName('uf').AsString);
  QInsereCEP.ExecSQL;
  Transacao.Commit;
  Result := True;
except
  on e:exception do
  begin
    Transacao.Rollback;
    showmessage('Erro ao Inserir o cep: ' + ADataSet.FieldByName('cep').AsString + ' - ' + E.Message);
    Abort;
  end;
end;
end;

function TDMD_GravaDados.LocalizarCep(ACep: String): Boolean;
begin
QCep.Close;
QCep.ParamByName('cep').AsString := ACep;
QCep.Open;
Result := not QCep.IsEmpty;
end;

function TDMD_GravaDados.LocalizarEndereco(ALogradouro, ACidade, AEstado: String): Boolean;
begin
QEndereco.Close;
QEndereco.ParamByName('logradouro').AsString := UpperCase(ALogradouro);
QEndereco.ParamByName('cidade').AsString := UpperCase(ACidade);
QEndereco.ParamByName('estado').AsString := UpperCase(AEstado);
QEndereco.Open;
Result := not QEndereco.IsEmpty;
end;

procedure  TDMD_GravaDados.EditarCep(ADataSet: TDataSet);
begin
Transacao.StartTransaction;
try
  QEditarCep.Close;
  QEditarCep.ParamByName('cep'). AsString := TFuncoes.SomenteNumero(ADataSet.FieldByName('cep').AsString);
  QEditarCep.ParamByName('logradouro'). AsString := UpperCase(ADataSet.FieldByName('logradouro').AsString);
  QEditarCep.ParamByName('complemento'). AsString := UpperCase(ADataSet.FieldByName('complemento').AsString);
  QEditarCep.ParamByName('bairro'). AsString := UpperCase(ADataSet.FieldByName('bairro').AsString);
  QEditarCep.ParamByName('cidade'). AsString := UpperCase(ADataSet.FieldByName('localidade').AsString);
  QEditarCep.ParamByName('estado'). AsString := UpperCase(ADataSet.FieldByName('uf').AsString);
  QEditarCep.ExecSQL;
  Transacao.Commit;
except
  on e:exception do
  begin
    Transacao.Rollback;
    showmessage('Erro ao Inserir o cep: ' + ADataSet.FieldByName('cep').AsString + ' - ' + E.Message);
    Abort;
  end;
end;
end;

end.
