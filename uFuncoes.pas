unit uFuncoes;

interface

uses IniFiles, System.SysUtils, Vcl.StdCtrls, Classes, System.MaskUtils;

type
  TFuncoes = class
  private
  Public
    class function LerIni(Chave1, Chave2: String; ValorPadrao: String = ''): String; static;
    class function ValidarCampo(ATexto: String) : Boolean; static;
    class function SomenteNumero(AStr : string) : string; static;
    class function ConverterEstado(AEstado: string): string; static;
    class function TrocarCaracterEspecial(aTexto: string; aLimExt: boolean): string; static;
  end;

implementation

class function TFuncoes.LerIni(Chave1, Chave2: String; ValorPadrao: String = ''): String;
var
  Arquivo: String;
  FileIni: TIniFile;
begin
  Arquivo := ExtractFilePath(ParamStr(0)) + 'configuracao.ini';
  result := ValorPadrao;
  try
    FileIni := TIniFile.Create(Arquivo);
    if FileExists(Arquivo) then
      result := FileIni.ReadString(Chave1, Chave2, ValorPadrao);
  finally
    FreeAndNil(FileIni)
  end;
end;

class function TFuncoes.ValidarCampo(ATexto: String): Boolean;
begin
Result := Length(Trim(ATexto)) >= 3;
end;

class function TFuncoes.SomenteNumero(AStr : string) : string;
var
    x : integer;
begin
Result := '';
for x := 0 to Length(AStr) - 1 do
  if (AStr.Chars[x] In ['0'..'9']) then
    Result := Result + AStr.Chars[x];
end;

class function TFuncoes.ConverterEstado(AEstado: string): string;
begin
IF UpperCase(AEstado) = UpperCase('Acre') Then Result := 'AC';
IF UpperCase(AEstado) = UpperCase('Alagoas') Then Result := 'AL';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Amapa') Then Result := 'AP';
IF UpperCase(AEstado) = UpperCase('Amazonas') Then Result := 'AM';
IF UpperCase(AEstado) = UpperCase('Bahia') Then Result := 'BA';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Ceara') Then Result := 'CE';
IF UpperCase(AEstado) = UpperCase('Distrito Federal') Then Result := 'DF';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Espirito Santo') Then Result := 'ES';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Goais') Then Result := 'GO';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Maranhao') Then Result := 'MA';
IF UpperCase(AEstado) = UpperCase('Mato Grosso') Then Result := 'MT';
IF UpperCase(AEstado) = UpperCase('Mato Grosso do Sul') Then Result := 'MS';
IF UpperCase(AEstado) = UpperCase('Minas Gerais') Then Result := 'MG';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Para') Then Result := 'PA';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Paraiba') Then Result := 'PB';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Parana') Then Result := 'PR';
IF UpperCase(AEstado) = UpperCase('Pernambuco') Then Result := 'PE';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Piaui') Then Result := 'PI';
IF UpperCase(AEstado) = UpperCase('Rio de Janeiro') Then Result := 'RJ';
IF UpperCase(AEstado) = UpperCase('Rio Grande do Norte') Then Result := 'RN';
IF UpperCase(AEstado) = UpperCase('Rio Grande do Sul') Then Result := 'RS';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Rondonia') Then Result := 'RO';
IF UpperCase(AEstado) = UpperCase('Roraima') Then Result := 'RR';
IF UpperCase(AEstado) = UpperCase('Santa Catarina') Then Result := 'SC';
IF TrocarCaracterEspecial(UpperCase(AEstado), true) = UpperCase('Sao Paulo') Then Result := 'SP';
IF UpperCase(AEstado) = UpperCase('Sergipe') Then Result := 'SE';
IF UpperCase(AEstado) = UpperCase('Tocantins') Then Result := 'TO';
end;

class function TFuncoes.TrocarCaracterEspecial(aTexto : string; aLimExt : boolean) : string;
const
  //Lista de caracteres especiais
  xCarEsp: array[1..38] of String = ('á', 'à', 'ã', 'â', 'ä','Á', 'À', 'Ã', 'Â', 'Ä',
                                     'é', 'è','É', 'È','í', 'ì','Í', 'Ì',
                                     'ó', 'ò', 'ö','õ', 'ô','Ó', 'Ò', 'Ö', 'Õ', 'Ô',
                                     'ú', 'ù', 'ü','Ú','Ù', 'Ü','ç','Ç','ñ','Ñ');
  //Lista de caracteres para troca
  xCarTro: array[1..38] of String = ('a', 'a', 'a', 'a', 'a','A', 'A', 'A', 'A', 'A',
                                     'e', 'e','E', 'E','i', 'i','I', 'I',
                                     'o', 'o', 'o','o', 'o','O', 'O', 'O', 'O', 'O',
                                     'u', 'u', 'u','u','u', 'u','c','C','n', 'N');
  //Lista de Caracteres Extras
  xCarExt: array[1..48] of string = ('<','>','!','@','#','$','%','¨','&','*',
                                     '(',')','_','+','=','{','}','[',']','?',
                                     ';',':',',','|','*','"','~','^','´','`',
                                     '¨','æ','Æ','ø','£','Ø','ƒ','ª','º','¿',
                                     '®','½','¼','ß','µ','þ','ý','Ý');
var
  xTexto : string;
  i : Integer;
begin
   xTexto := aTexto;
   for i:=1 to 38 do
     xTexto := StringReplace(xTexto, xCarEsp[i], xCarTro[i], [rfreplaceall]);
   //De acordo com o parâmetro aLimExt, elimina caracteres extras.
   if (aLimExt) then
     for i:=1 to 48 do
       xTexto := StringReplace(xTexto, xCarExt[i], '', [rfreplaceall]);
   Result := xTexto;
end;

end.
