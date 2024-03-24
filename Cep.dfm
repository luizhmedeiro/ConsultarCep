object FCeps: TFCeps
  Left = 0
  Top = 0
  Caption = 'Buscar CEP'
  ClientHeight = 232
  ClientWidth = 786
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
  object lblEndereco: TLabel
    Left = 280
    Top = 85
    Width = 3
    Height = 15
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 786
    Height = 78
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 13
      Top = 8
      Width = 80
      Height = 15
      Caption = 'Buscar por CEP'
    end
    object Label2: TLabel
      Left = 10
      Top = 52
      Width = 108
      Height = 30
      Caption = 'Buscar por endere'#231'o'#13#10
    end
    object Label3: TLabel
      Left = 128
      Top = 31
      Width = 35
      Height = 15
      Caption = 'Estado'
    end
    object Label4: TLabel
      Left = 174
      Top = 31
      Width = 37
      Height = 15
      Caption = 'Cidade'
    end
    object Label5: TLabel
      Left = 338
      Top = 31
      Width = 62
      Height = 15
      Caption = 'Logradouro'
    end
    object edtCep: TEdit
      Left = 128
      Top = 3
      Width = 121
      Height = 23
      NumbersOnly = True
      TabOrder = 0
    end
    object edtEstado: TEdit
      Left = 128
      Top = 48
      Width = 42
      Height = 23
      MaxLength = 2
      TabOrder = 2
    end
    object btnConsultar: TButton
      Left = 664
      Top = 3
      Width = 112
      Height = 25
      Caption = 'Consultar CEP'
      TabOrder = 1
      OnClick = btnConsultarClick
    end
    object btnEndereco: TButton
      Left = 664
      Top = 48
      Width = 112
      Height = 25
      Caption = 'Consultar Endere'#231'o'
      TabOrder = 5
      OnClick = btnEnderecoClick
    end
    object edtCidade: TEdit
      Left = 174
      Top = 48
      Width = 161
      Height = 23
      TabOrder = 3
    end
    object edtLogradouro: TEdit
      Left = 338
      Top = 48
      Width = 316
      Height = 23
      TabOrder = 4
    end
  end
  object MemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    Left = 40
    Top = 85
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
  object RESTClient1: TRESTClient
    BaseURL = 'http://viacep.com.br/ws'
    Params = <>
    SynchronizedEvents = False
    Left = 160
    Top = 101
  end
  object RESTRequest1: TRESTRequest
    AssignedValues = [rvConnectTimeout, rvReadTimeout]
    Client = RESTClient1
    Params = <>
    Resource = '01001000/json/'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 728
    Top = 69
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
    Left = 632
    Top = 77
  end
end