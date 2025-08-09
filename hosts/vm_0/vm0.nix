# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  stablePkgs, 
  unstablePkgs, 
  libFunctions, 
  modulesPath, 
  ...
}: {
  ## Configuração do hostname da máquina
  networking.hostName = hostName;
  ## Importando o módulo de hardware
  imports = [
    ./hardware.nix
  ];
}