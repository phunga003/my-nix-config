{ config, pkgs, lib, ... }:
let
  username = config.myconfig.username;
in
{
  options.profiles.dev.c = {
    runtime = lib.mkEnableOption "C runtime";
    tooling = lib.mkEnableOption "C tooling";
  };

  config = lib.mkMerge [
    (lib.mkIf config.profiles.dev.c.runtime {
      home-manager.users.${username}.home.packages = with pkgs; [ clang-tools ];
    })

    (lib.mkIf config.profiles.dev.c.tooling {
      home-manager.users.${username}.programs.helix.languages = {
        language = [{
          name = "c";
          language-servers = [ "clangd" ];
        }];
      };
    })
  ];
}

