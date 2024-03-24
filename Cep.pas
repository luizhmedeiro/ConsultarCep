unit Cep;

interface

uses
  DM_GravaDados,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, REST.Types, Vcl.ExtCtrls, REST.Client,
  REST.Response.Adapter, Data.Bind.Components, Data.Bind.ObjectScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TFCeps = class(TForm)
    MemTable: TFDMemTable;
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
  private
    DMGrava : TDMD_GravaDados;
    procedure EfetuaRequisicao(ARequisicao: String);
    procedure CarregaDados;
    procedure ConsultarCEP(ACep: string);
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
  if edtCEP.Text <> ''  then
    ConsultarCEP(edtCEP.Text);
end;

procedure TFCeps.btnEnderecoClick(Sender: TObject);
var
  lvRequisicao: string;
begin
  if Trim(edtEstado.Text) = '' then
  begin
    ShowMessage('Estado inv�lido');
    edtEstado.SetFocus;
    Exit;
  end;

  if Trim(edtCidade.Text) = '' then
  begin
    ShowMessage('Cidade inv�lida');
    edtCidade.SetFocus;
    Exit;
  end;

  lvRequisicao := edtEstado.Text + '/' + edtCidade.Text + '/' + edtLogradouro.Text;
  if Trim(edtLogradouro.Text) = '' then
    lvRequisicao := edtEstado.Text + '/' + edtCidade.Text;

  if not DMGrava.LocalizaEndereco(Trim(edtLogradouro.Text), Trim(edtCidade.Text), Trim(edtEstado.Text)) then
    EfetuaRequisicao(lvRequisicao)
  else
  begin
    DMGrava.LocalizaCep(DMGrava.QEndereco.FieldByName('cep').AsString);
    CarregaDados;
  end;
end;

procedure TFCeps.EfetuaRequisicao(ARequisicao: String);
begin
// se tivesse mais tempo poderia fazer uma classe especifica para bater o json.response
// e montar todo o objeto pronto com todos os dados em vez de trabalhar com tabela de memoria.
// mas creio q assim poder� identificar que consigo, inclusive quando trabalhava no SAJ procuradorias,
// ja foi desenvolvido com objetos.....
try
  RESTRequest1.Resource := ARequisicao + '/json';
  RESTRequest1.Execute;

  if RESTRequest1.Response.StatusCode = 200 then
  begin
    if RESTRequest1.Response.Content.IndexOf('erro') > 0 then
        ShowMessage('CEP n�o encontrado')
    else
    begin
      if MemTable.FieldByName('cep').AsString = '' then
        ShowMessage('Endere�o n�o localizado');

      with MemTable do
      begin
        lblEndereco.Caption := 'CEP: ' + FieldByName('cep').AsString + sLineBreak +
                               'End: ' + FieldByName('logradouro').AsString + sLineBreak +
                               'Compl: ' + FieldByName('complemento').AsString + sLineBreak +
                               'Bairro: ' + FieldByName('bairro').AsString + sLineBreak +
                               'Cidade: ' + FieldByName('localidade').AsString + sLineBreak +
                               'UF: ' + FieldByName('uf').AsString + sLineBreak;

        DMGrava.InserirCEP(MemTable);
      end;
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

procedure TFCeps.CarregaDados;
begin
MemTable.Close;
MemTable.Open;

with MemTable do
begin
  Append;
  FieldByName('cep').AsString := DMGrava.QCep.FieldByName('cep').AsString;
  FieldByName('logradouro').AsString := DMGrava.QCep.FieldByName('logradouro').AsString;
  FieldByName('complemento').AsString := DMGrava.QCep.FieldByName('complemento').AsString;
  FieldByName('bairro').AsString := DMGrava.QCep.FieldByName('bairro').AsString;
  FieldByName('localidade').AsString := DMGrava.QCep.FieldByName('cidade').AsString;
  FieldByName('uf').AsString := DMGrava.QCep.FieldByName('estado').AsString;

  lblEndereco.Caption := 'CEP: ' + FieldByName('cep').AsString + sLineBreak +
                         'End: ' + FieldByName('logradouro').AsString + sLineBreak +
                         'Compl: ' + FieldByName('complemento').AsString + sLineBreak +
                         'Bairro: ' + FieldByName('bairro').AsString + sLineBreak +
                         'Cidade: ' + FieldByName('localidade').AsString + sLineBreak +
                         'UF: ' + FieldByName('uf').AsString + sLineBreak;

  MemTable.Post;
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

  if not DMGrava.LocalizaCep(edtCEP.Text) then
    EfetuaRequisicao(edtCEP.Text)
  else
    CarregaDados;
end;

end.