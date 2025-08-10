# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  libFunctions, 
  ...
}:

{
  # IMPORTS PARA MÓDULOS DO HARDWARE:
  imports = [  ];

  # OPÇÕES DE BOOT E MÓDULOS DO KERNEL:
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "ehci_pci" "ahci" "xhci_pci" "nvme" "sr_mod" ];
  boot.initrd.kernelModules = [  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [  ];

  # SISTEMAS DE ARQUIVOS:
  ## Raiz do sistema
  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/";
  #   fsType = "btrfs";
  #   options = [ "subvol=@" "compress=zstd:1" "noatime" ];
  # };
  # ## Home separada
  # fileSystems."/home" = {
  #   device = "/dev/disk/by-uuid/";
  #   fsType = "btrfs";
  #   options = [ "subvol=@home" "compress=zstd:1" "noatime" ];
  # };
  # ## Partição nix (obrigatória por sistema)
  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-uuid/";
  #   fsType = "btrfs";
  #   options = [ "subvol=@nix" "compress=zstd:1" "noatime" ];
  # };
  # ## Partição de boot EFI
  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/";
  #   fsType = "vfat";
  #   options = [ "fmask=0022" "dmask=0022" ];
  # };

  # CONFIGURAÇÕES DE GERENCIAMENTO DOS IPs DA MÁQUINA:
  networking.useDHCP = libFunctions.mkDefault true;

  # OPÇÕES CRÍTICAS DO SISTEMA:
  nixpkgs.hostPlatform = libFunctions.mkDefault "x86_64-linux";
}