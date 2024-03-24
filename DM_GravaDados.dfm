object DMD_GravaDados: TDMD_GravaDados
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 200
  Width = 295
  object QEndereco: TFDQuery
    Connection = Conexao
    Transaction = Transacao
    SQL.Strings = (
      
        'select * from cep where cidade = :cidade and logradouro = :logra' +
        'douro and estado = :estado')
    Left = 112
    Top = 96
    ParamData = <
      item
        Name = 'CIDADE'
        DataType = ftString
        ParamType = ptInput
        Size = 60
      end
      item
        Name = 'LOGRADOURO'
        DataType = ftString
        ParamType = ptInput
        Size = 100
      end
      item
        Name = 'ESTADO'
        DataType = ftString
        ParamType = ptInput
        Size = 2
      end>
  end
  object QCep: TFDQuery
    Connection = Conexao
    SQL.Strings = (
      'select * from cep where cep = :cep')
    Left = 40
    Top = 104
    ParamData = <
      item
        Name = 'CEP'
        ParamType = ptInput
      end>
  end
  object Conexao: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Database=C:\Users\Luiz\Downloads\273-FontesCEP\Fontes\CEP.FDB')
    Left = 40
    Top = 24
  end
  object QInsereCep: TFDQuery
    Connection = Conexao
    Transaction = Transacao
    SQL.Strings = (
      
        'insert into cep (cep, logradouro, cidade, estado, complemento, b' +
        'airro) values (:cep, :logradouro, :cidade, :estado, :complemento' +
        ', :bairro)')
    Left = 112
    Top = 32
    ParamData = <
      item
        Name = 'CEP'
        ParamType = ptInput
      end
      item
        Name = 'LOGRADOURO'
        ParamType = ptInput
      end
      item
        Name = 'CIDADE'
        ParamType = ptInput
      end
      item
        Name = 'ESTADO'
        ParamType = ptInput
      end
      item
        Name = 'COMPLEMENTO'
        ParamType = ptInput
      end
      item
        Name = 'BAIRRO'
        ParamType = ptInput
      end>
  end
  object Transacao: TFDTransaction
    Connection = Conexao
    Left = 216
    Top = 40
  end
  object QEditarCep: TFDQuery
    Connection = Conexao
    Transaction = Transacao
    SQL.Strings = (
      'update '
      'cep'
      'set'
      'logradouro = :logradouro, '
      'cidade = :cidade, '
      'estado = :estado,'
      'complemento =  :complemento, '
      'bairro = :bairro'
      'where cep = :cep')
    Left = 192
    Top = 104
    ParamData = <
      item
        Name = 'LOGRADOURO'
        ParamType = ptInput
      end
      item
        Name = 'CIDADE'
        ParamType = ptInput
      end
      item
        Name = 'ESTADO'
        ParamType = ptInput
      end
      item
        Name = 'COMPLEMENTO'
        ParamType = ptInput
      end
      item
        Name = 'BAIRRO'
        ParamType = ptInput
      end
      item
        Name = 'CEP'
        ParamType = ptInput
      end>
  end
end
