Projeto para consultar o CEP e retonar via https://viacep.com.br

Desenvolvido em delphi 12, utilizando FIREDAC como conexão com a base de dados firebird.

configurações a serem feitas.

Arquivo de conexão que fica junto com o EXE, configuracao.ini.

indicar o caminho da base de dados.

exemplo

[FIREBIRD]
Server=localhost
User=SYSDBA
Password=masterkey
Database=..\..\Fontes\CEP.FDB

após essa configuração rodar o arquivo BuscaCEP.exe

que fica na pasta Fontes\Win32\Debug
