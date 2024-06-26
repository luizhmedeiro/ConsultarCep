unit Cep;

interface

uses
  uFuncoes,
  DM_GravaDados,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, REST.Types, Vcl.ExtCtrls, REST.Client, System.JSON,
  REST.Response.Adapter, Data.Bind.Components, Data.Bind.ObjectScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, XMLIntf, XMLDoc,
  Vcl.Grids, Vcl.DBGrids;

type
  TFCeps = class(TForm)
    TCEP: TFDMemTable;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    RESTResponse1: TRESTResponse;
    Panel1: TPanel;
    Label1: TLabel;
    edtCep: TEdit;
    Label2: TLabel;
    edtEstado: TEdit;
    btnConsultar: TButton;
    btnEndereco: TButton;
    edtCidade: TEdit;
    edtLogradouro: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TCEPcep: TStringField;
    TCEPlogradouro: TStringField;
    TCEPcomplemento: TStringField;
    TCEPbairro: TStringField;
    TCEPlocalidade: TStringField;
    TCEPuf: TStringField;
    btnConsultarXML: TButton;
    IdHTTP1: TIdHTTP;
    btnEnderecoXml: TButton;
    gridCep: TDBGrid;
    SCep: TDataSource;
    MemTable: TFDMemTable;
    MemTablecep: TStringField;
    MemTablelogradouro: TStringField;
    MemTablecomplemento: TStringField;
    MemTablebairro: TStringField;
    MemTablelocalidade: TStringField;
    MemTableuf: TStringField;
    procedure btnConsultarClick(Sender: TObject);
    procedure btnEnderecoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnConsultarXMLClick(Sender: TObject);
    procedure btnEnderecoXmlClick(Sender: TObject);
  private
    DMGrava : TDMD_GravaDados;
    procedure EfetuarRequisicao(ARequisicao: String);
    procedure CarregarDados;
    procedure ConsultarCEP(ACep: string);
    procedure ConsultarEndereco(AEstado, ACidade, ALogradouro: String);
    procedure ConsultarCEPViaXML(ACep: String);
    procedure ConsultarEnderecoViaXML(AEstado, ACidade, ALogradouro: String);
    procedure EfetuarRequisicaoXML(ARequisicao: String; ATipoRequisicao:String = 'CEP');
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCeps: TFCeps;

implementation

{$R *.dfm}

procedure TFCeps.btnConsultarClick(Sender: TObject);
begin
  if Length(edtCEP.Text) <> 8 then
  begin
    ShowMessage('CEP inv�lido');
    edtCEP.SetFocus;
    exit;
  end;

  ConsultarCEP(edtCEP.Text);
end;

procedure TFCeps.btnEnderecoClick(Sender: TObject);
begin
  if not TFuncoes.ValidarCampo(edtEstado.Text) then
  begin
    ShowMessage('Estado inv�lido');
    edtEstado.SetFocus;
    Exit;
  end;

  if not TFuncoes.ValidarCampo(edtCidade.Text) then
  begin
    ShowMessage('Cidade inv�lida');
    edtCidade.SetFocus;
    Exit;
  end;

  if not TFuncoes.ValidarCampo(edtLogradouro.Text) then
  begin
    ShowMessage('Logradouro inv�lida');
    edtLogradouro.SetFocus;
    Exit;
  end;

  ConsultarEndereco(TFuncoes.ConverterEstado(edtEstado.Text), edtCidade.Text, edtLogradouro.Text);
end;

procedure TFCeps.btnEnderecoXmlClick(Sender: TObject);
begin
  if not TFuncoes.ValidarCampo(edtEstado.Text) then
  begin
    ShowMessage('Estado inv�lido');
    edtEstado.SetFocus;
    Exit;
  end;

  if not TFuncoes.ValidarCampo(edtCidade.Text) then
  begin
    ShowMessage('Cidade inv�lida');
    edtCidade.SetFocus;
    Exit;
  end;

  if not TFuncoes.ValidarCampo(edtLogradouro.Text) then
  begin
    ShowMessage('Logradouro inv�lida');
    edtLogradouro.SetFocus;
    Exit;
  end;

  ConsultarEnderecoViaXML(TFuncoes.ConverterEstado(edtEstado.Text), edtCidade.Text, edtLogradouro.Text);
end;

procedure TFCeps.btnConsultarXMLClick(Sender: TObject);
begin
  if Length(edtCEP.Text) <> 8 then
  begin
    ShowMessage('CEP inv�lido');
    edtCEP.SetFocus;
    exit;
  end;

  ConsultarCEPViaXML(edtCEP.Text);
end;

procedure TFCeps.EfetuarRequisicao(ARequisicao: String);
begin
// aqui poderia fazer uma classe especifica para bater o json.response
// e montar todo o objeto pronto com todos os dados em vez de trabalhar com tabela de memoria.
// mas creio q assim poder� identificar que consigo, inclusive quando trabalhava no SAJ procuradorias,
// ja foi desenvolvido com objetos.....
try
  RESTRequest1.Resource := TFuncoes.TrocarCaracterEspecial(ARequisicao, True) + '/json';
  RESTRequest1.Execute;

  if RESTRequest1.Response.StatusCode = 200 then
  begin
    if RESTRequest1.Response.Content.IndexOf('erro') > 0 then
    begin
        ShowMessage('CEP n�o encontrado');
        Exit;
    end
    else
    begin
      if MemTable.FieldByName('cep').AsString = '' then
      begin
        ShowMessage('Endere�o n�o localizado');
        Exit
      end;

      if DMGrava.LocalizarCep(TFuncoes.SomenteNumero(MemTable.FieldByName('cep').AsString)) then
        DMGrava.EditarCEP(MemTable)
      else
        DMGrava.InserirCEP(MemTable);

      CarregarDados;
    end;
  end
  else
    ShowMessage('Erro ao consultar CEP');
except
  on e:exception do
  begin
    ShowMessage('Erro ao consultar CEP');
  end;
end;
end;

procedure TFCeps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
TCEP.Close;
FreeAndNil(DMGrava);
end;

procedure TFCeps.FormCreate(Sender: TObject);
begin
DMGrava := TDMD_GravaDados.Create(nil);
end;

procedure TFCeps.FormShow(Sender: TObject);
begin
edtCep.SetFocus;
CarregarDados;
end;

procedure TFCeps.CarregarDados;
begin
// carrega os dados e joga para a tabela de memoria
DMGrava.QTodosCep.Close;
DMGrava.QTodosCep.Open;

TCEP.Close;
TCEP.Open;

DMGrava.QTodosCep.First;
while not DMGrava.QTodosCep.Eof do
begin
  TCEP.Append;
  TCEP.FieldByName('cep').AsString := DMGrava.QTodosCep.FieldByName('cep').AsString;
  TCEP.FieldByName('logradouro').AsString := DMGrava.QTodosCep.FieldByName('logradouro').AsString;
  TCEP.FieldByName('complemento').AsString := DMGrava.QTodosCep.FieldByName('complemento').AsString;
  TCEP.FieldByName('bairro').AsString := DMGrava.QTodosCep.FieldByName('bairro').AsString;
  TCEP.FieldByName('localidade').AsString := DMGrava.QTodosCep.FieldByName('cidade').AsString;
  TCEP.FieldByName('uf').AsString := DMGrava.QTodosCep.FieldByName('estado').AsString;
  TCEP.Post;

  DMGrava.QTodosCep.Next;
end;
end;

procedure TFCeps.ConsultarCEP(ACep: string);
begin
// aqui efetua a consulta do CEP

  if Length(edtCEP.Text) <> 8 then
  begin
    ShowMessage('CEP inv�lido');
    edtCEP.SetFocus;
    exit;
  end;

  if not DMGrava.LocalizarCep(edtCEP.Text) then
    EfetuarRequisicao(edtCEP.Text)
  else
  begin
    if MessageDlg('Endere�o j� cadastrado, deseja fazer uma nova consulta?', mtInformation, [mbYes, mbNo], 0) = 6 then
      EfetuarRequisicao(edtCEP.Text)
  end;
end;

procedure TFCeps.ConsultarEndereco(AEstado, ACidade, ALogradouro: String);
var
  lvRequisicao : String;
begin
// aqui efetua a consulta pelo endereco completo
  lvRequisicao := AEstado + '/' + ACidade + '/' + ALogradouro;

  if not DMGrava.LocalizarEndereco(Trim(ALogradouro), Trim(ACidade), Trim(AEstado)) then
    EfetuarRequisicao(lvRequisicao)
  else
  begin
    if MessageDlg('Endere�o j� cadastrado, deseja fazer uma nova consulta?', mtInformation, [mbYes, mbNo], 0) = 6 then
    begin
      EfetuarRequisicao(lvRequisicao)
    end
    else
      DMGrava.LocalizarCep(DMGrava.QEndereco.FieldByName('cep').AsString);
  end;
end;

procedure TFCeps.ConsultarEnderecoViaXML(AEstado, ACidade, ALogradouro: String);
var
  lvRequisicao : String;
begin
// aqui efetua a consulta pelo endereco completo
  lvRequisicao := AEstado + '/' + ACidade + '/' + ALogradouro;

  if not DMGrava.LocalizarEndereco(Trim(ALogradouro), Trim(ACidade), Trim(AEstado)) then
    EfetuarRequisicaoXML(lvRequisicao, 'ENDERECO')
  else
  begin
    if MessageDlg('Endere�o j� cadastrado, deseja fazer uma nova consulta?', mtInformation, [mbYes, mbNo], 0) = 6 then
    begin
      EfetuarRequisicaoXML(lvRequisicao, 'ENDERECO')
    end
    else
      DMGrava.LocalizarCep(DMGrava.QEndereco.FieldByName('cep').AsString);
  end;
end;

procedure TFCeps.ConsultarCEPViaXML(ACep: String);
begin
if not DMGrava.LocalizarCep(TFuncoes.SomenteNumero(ACep)) then
begin
  EfetuarRequisicaoXML(TFuncoes.SomenteNumero(ACep));
  DMGrava.InserirCEP(TCEP);
end
else
begin
  if MessageDlg('Endere�o j� cadastrado, deseja fazer uma nova consulta?', mtInformation, [mbYes, mbNo], 0) = 6 then
  begin
    EfetuarRequisicaoXML(TFuncoes.SomenteNumero(ACep))
  end
  else
    DMGrava.LocalizarCep(DMGrava.QEndereco.FieldByName('cep').AsString);
end;
end;

procedure TFCeps.EfetuarRequisicaoXML(ARequisicao: String; ATipoRequisicao:String = 'CEP');
var
  lvStream: TStringStream;
  lvXMl: IXMLDocument;
  lvNodeList: IXMLNodeList;
  lvNode: IXMLNode;
  i: Integer;
begin
  lvStream := TStringStream.Create;
  lvXMl    := TXMLDocument.Create('');
  try
    try
      idHTTP1.Get('http://viacep.com.br/ws/' + ARequisicao + '/xml', lvStream);

      lvStream.SaveToFile('arquivo.xml');
      lvXMl.LoadFromFile('arquivo.xml');

//    monta diferente quando � por cep ou endereco, tem 2 nodos a mais
      if ATipoRequisicao = 'CEP' then
        lvNodeList := lvXMl.ChildNodes['xmlcep'].ChildNodes
      else
      begin
        lvNodeList := lvXMl.ChildNodes['xmlcep'].ChildNodes;
        lvNodeList := lvNodeList.FindNode('enderecos').ChildNodes;
        lvNodeList := lvNodeList.FindNode('endereco').ChildNodes;
      end;

      if lvNodeList.Count <= 1 then
      begin
        ShowMessage('CEP n�o encontrado');
        Exit;
      end;

      TCEP.Append;

      for I := 0 to lvNodeList.Count - 1 do
      begin
        lvNode := lvNodeList.get(i);

        if not Assigned(TCEP.FindField(lvNode.NodeName)) then
          Continue;

        if lvNode.NodeValue = Null then
          Continue;

        if lvNode.NodeName = 'cep' then
          TCEP.FieldByName(lvNode.NodeName).AsString := TFuncoes.SomenteNumero(lvNode.NodeValue)
        else
          TCEP.FieldByName(lvNode.NodeName).AsString := lvNode.NodeValue;
      end;
      TCEP.Post;

      if DMGrava.LocalizarCep(TFuncoes.SomenteNumero(TCEP.FieldByName('cep').AsString)) then
      begin
        DMGrava.EditarCEP(TCEP);
        CarregarDados;
      end
      else
        DMGrava.InserirCEP(TCEP);

    except
      on e:Exception do
      begin
        ShowMessage('Erro ao Consultar CEP.');
      end;
    end;
  finally
    FreeAndNil(lvStream);
  end;
end;

end.
