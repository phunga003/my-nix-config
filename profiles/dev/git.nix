{ config, pkgs, ... }:
let
  username = config.myconfig.username;
in
{
  home-manager.users.${username}.home.packages = with pkgs; [ git ];
}

