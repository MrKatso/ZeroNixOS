# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{ libFunctions, ... }: let
  deviceLocal = libFunctions.mkDefault "/dev/nvme0n1";
in
# GERENCIAMENTO E CATÁLOGO DE PARTICIONAMENTO:
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = deviceLocal;
        content = {
          type = "gpt";
          partitions = {
            # PARTIÇÃO BOOT EFI
            ESP = {
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # PARTIÇÃO RESTANTE BTRFS
            NOS = {
              name = "NOS";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  # ROOT
                  "/@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd:1" "noatime" ];
                  };
                  # HOME SEPARADA
                  "/@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd:1" ];
                  };
                  # NIX PACKAGES
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd:1" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}