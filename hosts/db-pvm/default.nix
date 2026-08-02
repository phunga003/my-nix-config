{ config, ... }:
{
  imports = [
    ../../profiles/platform/proxmox-vm.nix
    ../../profiles/services/postgres.nix
    ../../modules/options.nix
    ../../profiles/dev/git.nix
    ../../profiles/dev/ssh.nix
    ../../profiles/dev/lang/nix.nix
  ];

  myconfig.username = "postgresDB";

  myconfig.services.postgres = {
    enable = true;
    # NOTE: configure by adding and removing entries based on your needs, or make a different host
    databases = [ "guacamole" ];
    appUsers = [ "guacamole" ]; # role name matches db → ensureDBOwnership works
  };

  profiles.dev.nixTools.tooling = true;

  home-manager = {
    users.${config.myconfig.username} = {
      imports = [ (import ../../home/default.nix) ];
      targets.genericLinux.enable = true;
      home.username = config.myconfig.username;
      home.homeDirectory = "/home/${config.myconfig.username}";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

}
