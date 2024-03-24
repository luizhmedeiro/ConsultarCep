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
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

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
    lblEndereco: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    TCEPcep: TStringField;
    TCEPlogradouro: TStringField;
    TCEPcomplemento: TStringField;
    TCEPbairro: TStringField;
    TCEPlocalidade: TStringField;
    TCEPuf: TStringField;
    procedure btnConsultarClick(Sender: TObject);
    procedure btnEnderecoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    DMGrava : TDMD_GravaDados;
    procedure EfetuarRequisicao(ARequisicao: String);
    procedure CarregarDados;
    procedure ConsultarCEP(ACep: string);
    procedure ConsultarEndereco(AEstado, ACidade, ALogradouro: String);
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
    ShowMessage('CEP inválido');
    edtCEP.SetFocus;
    exit;
  end;

  ConsultarCEP(edtCEP.Text);
end;

procedure TFCeps.btnEnderecoClick(Sender: TObject);
begin
  if not TFuncoes.ValidarCampo(edtEstado.Text) then
  begin
    ShowMessage('Estado inválido');
    edtEstado.SetFocus;
    Exit;
  end;

  if not TFuncoes.ValidarCampo(edtCidade.Text) then
  begin
    ShowMessage('Cidade inválida');
    edtCidade.SetFocus;
    Exit;
  end;

  if not TFuncoes.ValidarCampo(edtLogradouro.Text) then
  begin
    ShowMessage('Logradouro inválida');
    edtLogradouro.SetFocus;
    Exit;
  end;

  ConsultarEndereco(TFuncoes.ConverterEstado(edtEstado.Text), edtCidade.Text, edtLogradouro.Text);
end;

procedure TFCeps.EfetuarRequisicao(ARequisicao: String);
begin
// aqui poderia fazer uma classe especifica para bater o json.response
// e montar todo o objeto pronto com todos os dados em vez de trabalhar com tabela de memoria.
// mas creio q assim poderá identificar que consigo, inclusive quando trabalhava no SAJ procuradorias,
// ja foi desenvolvido com objetos.....
try
  RESTRequest1.Resource := TFuncoes.TrocarCaracterEspecial(ARequisicao, True) + '/json';
  RESTRequest1.Execute;

  if RESTRequest1.Response.StatusCode = 200 then
  begin
    if RESTRequest1.Response.Content.IndexOf('erro') > 0 then
    begin
        ShowMessage('CEP não encontrado');
        Exit;
    end
    else
    begin
      if TCEP.FieldByName('cep').AsString = '' then
      begin
        ShowMessage('Endereço não localizado');
        Exit
      end;

      lblEndereco.Caption := 'CEP: ' + TCEP.FieldByName('cep').AsString + sLineBreak +
                             'End: ' + TCEP.FieldByName('logradouro').AsString + sLineBreak +
                             'Compl: ' + TCEP.FieldByName('complemento').AsString + sLineBreak +
                             'Bairro: ' + TCEP.FieldByName('bairro').AsString + sLineBreak +
                             'Cidade: ' + TCEP.FieldByName('localidade').AsString + sLineBreak +
                             'UF: ' +TCEP. FieldByName('uf').AsString + sLineBreak;

      if DMGrava.LocalizarCep(TFuncoes.SomenteNumero(TCEP.FieldByName('cep').AsString)) then
        DMGrava.EditarCEP(TCEP)
      else
        DMGrava.InserirCEP(TCEP);
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
FreeAndNil(DMGrava);
end;

procedure TFCeps.FormCreate(Sender: TObject);
begin
DMGrava := TDMD_GravaDados.Create(nil);
end;

procedure TFCeps.FormShow(Sender: TObject);
begin
edtCep.SetFocus;
end;

procedure TFCeps.CarregarDados;
begin
// carrega os dados e joga para a tabela de memoria(caso tivesse uma grid)
TCEP.Close;
TCEP.Open;
TCEP.Append;
TCEP.FieldByName('cep').AsString := DMGrava.QCep.FieldByName('cep').AsString;
TCEP.FieldByName('logradouro').AsString := DMGrava.QCep.FieldByName('logradouro').AsString;
TCEP.FieldByName('complemento').AsString := DMGrava.QCep.FieldByName('complemento').AsString;
TCEP.FieldByName('bairro').AsString := DMGrava.QCep.FieldByName('bairro').AsString;
TCEP.FieldByName('localidade').AsString := DMGrava.QCep.FieldByName('cidade').AsString;
TCEP.FieldByName('uf').AsString := DMGrava.QCep.FieldByName('estado').AsString;
TCEP.Post;

lblEndereco.Caption := 'CEP: ' + TCEP.FieldByName('cep').AsString + sLineBreak +
                       'End: ' + TCEP.FieldByName('logradouro').AsString + sLineBreak +
                       'Compl: ' + TCEP.FieldByName('complemento').AsString + sLineBreak +
                       'Bairro: ' + TCEP.FieldByName('bairro').AsString + sLineBreak +
                       'Cidade: ' + TCEP.FieldByName('localidade').AsString + sLineBreak +
                       'UF: ' + TCEP.FieldByName('uf').AsString + sLineBreak;
end;

procedure TFCeps.ConsultarCEP(ACep: string);
begin
// aqui efetua a consulta do CEP

  if Length(edtCEP.Text) <> 8 then
  begin
    ShowMessage('CEP inválido');
    edtCEP.SetFocus;
    exit;
  end;

  if not DMGrava.LocalizarCep(edtCEP.Text) then
    EfetuarRequisicao(edtCEP.Text)
  else
  begin
    if MessageDlg('Endereço já cadastrado, deseja fazer uma nova consulta?', mtInformation, [mbYes, mbNo], 0) = 6 then
      EfetuarRequisicao(edtCEP.Text)
    else
      CarregarDados;
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
    if MessageDlg('Endereço já cadastrado, deseja fazer uma nova consulta?', mtInformation, [mbYes, mbNo], 0) = 6 then
    begin
      EfetuarRequisicao(lvRequisicao)
    end
    else
    begin
      DMGrava.LocalizarCep(DMGrava.QEndereco.FieldByName('cep').AsString);
      CarregarDados;
    end;
  end;
end;

end.
