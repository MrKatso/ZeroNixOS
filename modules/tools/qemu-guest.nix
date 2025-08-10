# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{
  config, 
  stablePkgs, 
  ...
}: {
  ## Habilita o agente QEMU Guest para melhor integração com KVM/Proxmox
  services.qemuGuest.enable = true;
}