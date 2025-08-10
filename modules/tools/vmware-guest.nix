# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  stablePkgs, 
  ...
}: {
  ## Habilita os Open VM Tools, que fornecem:
  ## - Sincronização de hora com o host
  ## - Copiar e colar entre host e VM
  ## - Redimensionamento dinâmico da tela
  ## - Desligamento gracioso a partir do VMware
  virtualisation.vmware.guest.enable = true;

  ## Garante que os drivers de vídeo corretos para VMware sejam usados
  ## para uma boa performance gráfica.
  services.xserver.videoDrivers = [ "vmware" ];
}