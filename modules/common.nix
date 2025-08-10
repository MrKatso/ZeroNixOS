# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  stablePkgs, 
  unstablePkgs, 
  libFunctions, 
  isVM, 
  ...
} @ allArgs: {
  # DESABILITA OS CANAIS LEGADOS, JÁ QUE ESTAMOS USANDO FLAKES:
  nix.channel.enable = false;
  ## Aplica configurações referente a ferramentas flake
  nix.settings = {
    auto-optimise-store = true;
    use-xdg-base-directories = true;
    experimental-features = [
      "nix-command" 
      "flakes"
    ];
  };

  # PACOTES MÍNIMOS:
  ## Ativação de pacotes proprietários
  nixpkgs.config.allowUnfree = true;
  ## Pacotes de baixa prioridade
  environment.systemPackages = map libFunctions.lowPrio ( with stablePkgs; [
    gitMinimal
  ]);

  # CONFIGURAÇÃO ESTÉTICA BÁSICA DO TTY:
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us-acentos";
  };

  # LOCAL E DATA DO SISTEMA:
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  ## Extras
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # CONFIGURAÇÕES DE SEGURANÇA DO SSH
  ## Configura o serviço SSH para permitir login APENAS com chaves
  ## (Esta opção só terá efeito se `services.openssh.enable = true` for definido em algum perfil)
  services.openssh.settings = {
    ### Permite login do root, mas APENAS com chave SSH
    PermitRootLogin = "prohibit-password";
    ### Desabilita o login com senha para TODOS os usuários
    PasswordAuthentication = false;
    ### Também desabilita outros métodos baseados em teclado/senha
    KbdInteractiveAuthentication = false;
  };

  # POLÍTICA DE SEGURANÇA DE USUÁRIOS:
  ## Esta é a opção chave. Ela torna os arquivos /etc/passwd e /etc/shadow
  ## imutáveis, gerenciados apenas pelo NixOS
  ## O comando `passwd` parará de funcionar
  security.mutableUsers = false;

  # CONFIGURAÇÃO DE SEGURANÇA DO ROOT:
  users.users.root = {
    ### 1. Define o shell padrão para consistência
    shell = stablePkgs.bash;
    ### 2. Desabilita o login por senha para o usuário root
    ### O `null` é um valor especial que desabilita a senha
    hashedPassword = null;
    ### 3. Chave(s) SSH pública(s) para acesso administrativo seguro
    ### Trava a conta root para que ninguém possa fazer login com uma senha
    openssh.authorizedKeys.keys = [
      #### SSH Windows desktop host
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMVAFsTMpCVg8fN4q3AZ/xHDSqi5ALensRqO+UXp0V1Q joao@DESKTOP-6QLEPFA"
    ];
  };

  # BOOTLOADER POR FLAG (Configuração permitida somente por VMs):
  boot.loader = libFunctions.mkMerge [
    ## Para máquinas virtuais, usar esse padrão (SYSTEMD-BOOT)
    ( libFunctions.mkIf isVM {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 3;
      efi.canTouchEfiVariables = true;
    })
    ## Para máquinas físicas, usar este (GRUB)
    ( libFunctions.mkIf (!isVM) {
      grub.enable = true;
      efi.canTouchEfiVariables = true;
    })
  ];

  # KERNEL MAIS ATUALIZADO POSSÍVEL:
  boot.kernelPackages = stablePkgs.linuxPackages_latest;

  # TRAVA DA VERSÃO DO SISTEMA:
  system.stateVersion = "25.05";
}