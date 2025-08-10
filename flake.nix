#
# ███████╗███████╗██████╗  ██████╗ ███╗   ██╗██╗██╗  ██╗     ██████╗ ███████╗
# ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗████╗  ██║██║╚██╗██╔╝    ██╔═══██╗██╔════╝
#   ███╔╝ █████╗  ██████╔╝██║   ██║██╔██╗ ██║██║ ╚███╔╝     ██║   ██║███████╗
#  ███╔╝  ██╔══╝  ██╔══██╗██║   ██║██║╚██╗██║██║ ██╔██╗     ██║   ██║╚════██║
# ███████╗███████╗██║  ██║╚██████╔╝██║ ╚████║██║██╔╝ ██╗    ╚██████╔╝███████║
# ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝     ╚═════╝ ╚══════╝
#

{
  # DECRIÇÃO DO PROJETO:
  description = "PROJETO ZERONIX OS!";

  # INPUTS (IMPORTAÇÕES DE PACOTES AO FLAKE):
  inputs = {
    ## Pacotes estáveis e a base do sistema
    nixosStable.url = "github:NixOS/nixpkgs/nixos-25.05";
    ## Pacotes instáveis secundários
    nixosUnstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ## Gerenciamento automático do disco (pós instalação)
    diskoManager = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixosStable";
    };
  };

  # OUTPUTS (EXPORTAÇÕES PRO RESTANTE DAS CONFIGURAÇÕES):
  outputs = {
    self, 
    nixosStable, 
    nixosUnstable, 
    diskoManager, 
    ...
  } @ inputs: let
    # DASH, ARGUMENTOS, PERFIS E FUNÇÕES AUXILIARES:
    ## 1. O DASHBOARD
    profileFeatures = import ./features.nix;
    ## 2. Argumentos críticos
    criticalArgs = {
      inherit inputs;
      libFunctions = nixosStable.lib;
      # modulesPath = "${nixosStable.nixos}/share/nixos/modules"; # <--- MARCADO PARA MANUTENÇÃO FUTURA, CAUSANDO ERROS CRÍTICOS!!!
    };
    ## 3. Perfis reutilizáveis gerados AUTOMATICAMENTE a partir da DASHBOARD
    machineProfiles = nixosStable.lib.mapAttrs ( profileName: features: {
      ### O módulo principal do perfil atuando como um hub/roteador
      modules = [ ./profiles/${profileName}.nix ];
      ### Os specialArgs são as próprias features do dashboard!
      specialArgs = features;
    }) profileFeatures;
    ## 4. Função construtora de hosts: Monta a configuração de um host
    buildHostConfig = { system, configName, machineProfile, hostName, userName, extraModules ? [], extraSpecialArgs ? {}, flags ? {} }: let
      pkgsForSystem  =  {
        stablePkgs = nixosStable.legacyPackages.${system};
        unstablePkgs = nixosUnstable.legacyPackages.${system};
      };
    in {
      modules = [ ./modules/common.nix ] ++ machineProfile.modules ++ extraModules ++ (
        nixosStable.lib.optionals ( flags.usesDisko or false ) [
          ### Inclui o módulo principal do Disko
          diskoManager.nixosModules.disko
          ### Inclui o layout de disco específico do host, seguindo nossa convenção
          ./hosts/${configName}/disko.nix
        ]
      );
      specialArgs = criticalArgs // pkgsForSystem // ( machineProfile.specialArgs or {} ) // flags // extraSpecialArgs // { inherit hostName userName; };
    };
    # BANCO DE DADOS DE MÁQUINAS/HOSTS, AGRUPADAS POR ARQUITETURA:
    hostsByArch = {
      "x86_64-linux" = {
        ## Vm de testes
        "vm_0" = { ### <--- Nome de busca (apelido que usa para o nix (ex: nixos-rebuild switch --flake .#apelido))
          machineProfile = machineProfiles.vms;
          hostName = "DESKTOP-VMWARE"; ### <--- Nome real (que a máquina terá na rede)
          userName = "wareuser";
          extraModules = [
            ### Módulo base
            ./hosts/vm_0/vm0.nix
          ];
          ## Flags específicas deste host aqui
          flags = {
            hasGUI = true; ### <--- Contém UI?
            isVM = true; ### <--- É uma VM?
            usesDisko = true; ### <--- Usa particionamento automático com Disko?
          };
        };
      };
    };
  in {
    # GERAÇÃO LÓGICA TOTALMENTE AUTOMÁTIZADA:
    nixosConfigurations = nixosStable.lib.foldl ( finalSet: newSet: finalSet // newSet ) {} ( # <--- Basicamente pega dois mapas e mescla eles num só, começando com um {}, o mapa vazio.
      nixosStable.lib.attrValues ( # <--- Pega a estrutura aninhada e extraí somente os valores em uma lista
        # LOOP EXTERNO: Itera sobre as ARQUITETURAS (`system` e `hosts`)
        nixosStable.lib.mapAttrs ( system: hosts: 
          # LOOP INTERNO: Itera sobre os HOSTS dentro de cada arquitetura
          nixosStable.lib.mapAttrs ( configName: hostConfig: 
            # O `hostName` aqui é o nome da máquina (ex: "DESKTOP-XXXXX")
            # O `hostConfig` são os dados dela
            nixosStable.lib.nixosSystem (
              # A configuração final é construída aqui...
              ( buildHostConfig ( hostConfig // { inherit configName system; }))
            )
          ) hosts
        ) hostsByArch
      )
    );
  };
}