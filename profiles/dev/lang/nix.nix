{ config, pkgs, lib, ... }:
let
  username = config.myconfig.username;
in
{
  options.profiles.dev.nixTools = {
    tooling = lib.mkEnableOption "nix tooling";
  };

  config = lib.mkMerge [
    (lib.mkIf config.profiles.dev.nixTools.tooling {
      home-manager.users.${username} = {
        home.packages = with pkgs; [ nixd ];
        programs.helix.languages = {
          language = [{
            name = "nix";
            language-servers = [ "nixd" ];
          }];
        };
      };
    })
  ];
}

