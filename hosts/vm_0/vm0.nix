# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  hostName, 
  ...
}: {
  ## Configuração do hostname da máquina
  networking.hostName = hostName;
  ## Importando o módulo de hardware
  imports = [
    ./hardware.nix
  ];
}