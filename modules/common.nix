# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  stablePkgs, 
  unstablePkgs, 
  libFunctions, 
  modulesPath, 
  hasGUI, 
  isVM, 
  ...
}: {
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
    curl 
    wget 
    git 
    htop
  ]);

  # CONFIGURAÇÃO ESTÉTICA DO TTY:
  console = {
    font = "ter-v16n";
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

  # BOOTLOADER POR FLAG (Permitido somente em máquinas vir):
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