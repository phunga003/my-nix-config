{ config, lib, ... }:
{

  # On generic Linux this block won't execute anyway
  users.users = lib.mkIf (!config.myconfig.enableGenericLinux) {
    ${config.myconfig.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "changeme";
    };
  };

  home-manager = {
    users.${config.myconfig.username} = {
      imports = [ ../home/default.nix ];
      #imports = [ (import ../home/default.nix) ];
      targets.genericLinux.enable = config.myconfig.enableGenericLinux;
      home.username = config.myconfig.username;
      home.homeDirectory = "/home/${config.myconfig.username}";
      home.stateVersion = "25.11";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
