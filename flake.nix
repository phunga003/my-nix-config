{
  description = "my personal nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  
    };                                      
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations."nixos" =
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home/default.nix ];
      };
  };
}
