# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{ stablePkgs, ... }: {
  # INSTALAÇÃO DO EDITOR VIM:
  environment.systemPackages = with stablePkgs; [
    vim 
  ];
}