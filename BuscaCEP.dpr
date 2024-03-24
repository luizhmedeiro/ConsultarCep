program BuscaCEP;

uses
  Vcl.Forms,
  Cep in 'Cep.pas' {FCeps},
  DM_GravaDados in 'DM_GravaDados.pas' {DMD_GravaDados: TDataModule},
  uFuncoes in 'uFuncoes.pas',
  uFormat in 'uFormat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFCeps, FCeps);
  Application.CreateForm(TDMD_GravaDados, DMD_GravaDados);
  Application.Run;
end.
