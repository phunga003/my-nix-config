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
        home.packages = with pkgs; [ nixd nixfmt-rfc-style ];
        programs.helix.languages = {
          language = [{
            name = "nix";
            language-servers = [ "nixd" ];
            formatter = {
              command = "nixfmt";
            };
            auto-format = true;
          }];
        };
      };
    })
  ];
}

