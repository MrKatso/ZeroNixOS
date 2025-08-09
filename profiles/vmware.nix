# IMPORTS E VARS NECESSÁRIOS PARA ESTE MÓDULO:
{ libFunctions, vim, ... }: {
  ## Imports de módulos para esta configuração
  imports = libFunctions.flatten [
    ( libFunctions.optionals vim [ ../../modules/vim.nix ])
  ];
}