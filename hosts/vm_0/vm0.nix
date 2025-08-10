# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  hostName, 
  userName, 
  ...
}: {
  ## Importando o módulo de hardware
  imports = [
    ./hardware.nix
  ];
  ## Configuração do hostname da máquina
  networking.hostName = hostName;
  ## Configuração de hostname da máquina
  users.users.${userName} = {
    description = "Usuário Administrador desta VM";
    isNormalUser = true;
    hashedPassword = "$6$75cyCxVrBIx4nhG1$XozRe4Tpnc17ZzLBRUQYgzRmovg1c/H8r/NrUncaP..3hqNBqyEmpG3klHAKyGfEZ4ilYppNZlFrMxEj1WC1h1";
    extraGroups = [
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      ### SSH Windows desktop host
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVAFsTMpCVg8fN4q3AZ/xHDSqi5ALensRqO+UXp0V1Q joao@DESKTOP-6QLEPFA"
    ];
  };
  ## Autorizando os usuários
  nix.settings.allowed-users = [ "${userName}" ];
}