# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
## Este módulo habilita o serviço OpenSSH e abre a porta do firewall
{
  config, 
  stablePkgs, 
  ...
}: {
  ## Ativa o serviço OpenSSH
  services.openssh.enable = true;

  ## Aqui abrimos as portas do firewall
  networking = {
    firewall  =  {
      ### Permitir entrada
      allowedTCPPorts = [ 22 ];
      ### Permitir saída
      allowedUDPPorts = [  ];
    };
  };
}