{
  description = "my personal nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }:
    let
      mkHost =
        {
          modules,
          hostPlatform ? "x86_64-linux",
          stateVersion ? "25.11",
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit hostPlatform stateVersion; };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/common.nix
          ]
          ++ modules;
        };
    in
    {
      nixosConfigurations = {

        # WSL
        wsl = mkHost {
          modules = [
            nixos-wsl.nixosModules.default
            ./hosts/wsl/default.nix
          ];
        };

        # Proxmox vm running postgress
        db-pvm = mkHost {
          stateVersion = "26.05";
          modules = [ ./hosts/db-pvm/default.nix ];
        };
      };
    };
}
