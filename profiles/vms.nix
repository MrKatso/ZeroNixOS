# RECEBEMOS AS FLAGS DO DASHBOARD (vmwareGuestTools, etc.)
# E TAMBÉM A FLAG `isVM` QUE VEM DO HOST
{
  libFunctions, 
  isVM, 
  vmwareGuestTool, 
  qemuGuestTools, 
  virtualboxGuestTools, 
  ssh, 
  ...
} @ allArgs: {
  ## Inclui os módulos de features com base no dashboard
  imports = ( libFunctions.flatten [
    ( libFunctions.optionals vmwareGuestTool [ ../modules/tools/vmware-guest.nix ])
    ( libFunctions.optionals qemuGuestTools [ ../modules/tools/qemu-guest.nix ])
    ( libFunctions.optionals virtualboxGuestTools [ ../modules/tools/virtualbox-guest.nix ])
    ( libFunctions.optionals ssh [ ../modules/services/ssh.nix ])
  ]);

  # OTIMIZAÇÕES GERAIS PARA QUALQUER VM:
  # Aqui usamos a flag `isVM` que definimos no `hostsByArch`
  # Essas configurações serão aplicadas a qualquer host que use este
  # perfil E tenha `isVM = true`
  ## Desabilita o TLP (gerenciamento de energia para laptops), inútil em VMs
  services.tlp.enable = libFunctions.mkIf isVM false;

  # Você pode adicionar outras otimizações aqui
  ## desabilitar o bluetooth por padrão, etc
  hardware.bluetooth.enable = libFunctions.mkIf isVM false;
}