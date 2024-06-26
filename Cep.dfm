object FCeps: TFCeps
  Left = 0
  Top = 0
  Caption = 'Buscar CEP'
  ClientHeight = 232
  ClientWidth = 864
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 864
    Height = 78
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 240
    ExplicitTop = 40
    ExplicitWidth = 786
    object Label1: TLabel
      Left = 4
      Top = 10
      Width = 80
      Height = 15
      Caption = 'Buscar por CEP'
    end
    object Label2: TLabel
      Left = 1
      Top = 52
      Width = 108
      Height = 30
      Caption = 'Buscar por endere'#231'o'#13#10
    end
    object Label3: TLabel
      Left = 111
      Top = 31
      Width = 35
      Height = 15
      Caption = 'Estado'
    end
    object Label4: TLabel
      Left = 218
      Top = 31
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object Label5: TLabel
      Left = 383
      Top = 31
      Width = 62
      Height = 15
      Caption = 'Logradouro'
    end
    object edtCep: TEdit
      Left = 111
      Top = 5
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 0
    end
    object edtEstado: TEdit
      Left = 111
      Top = 48
      Width = 105
      Height = 23
      MaxLength = 20
      TabOrder = 3
    end
    object btnConsultar: TButton
      Left = 744
      Top = 3
      Width = 114
      Height = 25
      Caption = 'Consultar CEP Json'
      TabOrder = 2
      OnClick = btnConsultarClick
    end
    object btnEndereco: TButton
      Left = 744
      Top = 48
      Width = 114
      Height = 25
      Caption = 'Endere'#231'o por Json'
      TabOrder = 7
      OnClick = btnEnderecoClick
    end
    object edtCidade: TEdit
      Left = 218
      Top = 48
      Width = 161
      Height = 23
      TabOrder = 4
    end
    object edtLogradouro: TEdit
      Left = 383
      Top = 48
      Width = 253
      Height = 23
      TabOrder = 5
      TextHint = 'Caso n'#227'o exista logradouro, informar "Centro"'
    end
    object btnConsultarXML: TButton
      Left = 638
      Top = 3
      Width = 103
      Height = 25
      Caption = 'Consultar por XML'
      TabOrder = 1
      OnClick = btnConsultarXMLClick
    end
    object btnEnderecoXml: TButton
      Left = 638
      Top = 48
      Width = 103
      Height = 25
      Caption = 'Endere'#231'o por XML'
      TabOrder = 6
      OnClick = btnEnderecoXmlClick
    end
  end
  object gridCep: TDBGrid
    Left = 0
    Top = 78
    Width = 864
    Height = 154
    Align = alClient
    DataSource = SCep
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'cep'
        Width = 88
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'logradouro'
        Width = 143
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'complemento'
        Width = 166
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'bairro'
        Width = 192
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'localidade'
        Width = 229
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'uf'
        Visible = True
      end>
  end
  object TCEP: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 96
    Top = 165
    object TCEPcep: TStringField
      FieldName = 'cep'
    end
    object TCEPlogradouro: TStringField
      FieldName = 'logradouro'
    end
    object TCEPcomplemento: TStringField
      FieldName = 'complemento'
    end
    object TCEPbairro: TStringField
      FieldName = 'bairro'
    end
    object TCEPlocalidade: TStringField
      FieldName = 'localidade'
    end
    object TCEPuf: TStringField
      FieldName = 'uf'
    end
  end
  object RESTClient1: TRESTClient
    BaseURL = 'http://viacep.com.br/ws'
    Params = <>
    SynchronizedEvents = False
    Left = 544
    Top = 85
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Resource = '01001000/json/'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 760
    Top = 173
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    Dataset = MemTable
    FieldDefs = <>
    Response = RESTResponse1
    TypesMode = Rich
    Left = 632
    Top = 133
  end
  object RESTResponse1: TRESTResponse
    Left = 760
    Top = 125
  end
  object IdHTTP1: TIdHTTP
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 304
    Top = 176
  end
  object SCep: TDataSource
    DataSet = TCEP
    Left = 48
    Top = 144
  end
  object MemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 208
    Top = 160
    object MemTablecep: TStringField
      FieldName = 'cep'
    end
    object MemTablelogradouro: TStringField
      FieldName = 'logradouro'
    end
    object MemTablecomplemento: TStringField
      FieldName = 'complemento'
    end
    object MemTablebairro: TStringField
      FieldName = 'bairro'
    end
    object MemTablelocalidade: TStringField
      FieldName = 'localidade'
    end
    object MemTableuf: TStringField
      FieldName = 'uf'
    end
  end
end
