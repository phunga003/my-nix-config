{ config, ... }:
{
  imports = [
    ../../profiles/platform/proxmox.nix
    ../../profiles/services/postgres.nix
    ../../modules/options.nix
    ../../modules/init-user.nix
    ../../profiles/dev/git.nix
    ../../profiles/dev/ssh.nix
    ../../profiles/dev/lang/nix.nix

    ../../profiles/services/guacamole.nix
  ];

  myconfig = {
    username = "postgresDB";

    services = {
      guacamole = {
        enable = true;
        dbHost = "localhost";
        dbPasswordFile = "/var/lib/guacamole-db-password";
      };

      postgres = {
        enable = true;
        # NOTE: configure by adding and removing entries based on your needs, or make a different host
        databases = [ "guacamole" ];
        appUsers = [ "guacamole" ];
      };
    };
  };

  profiles.dev.nixTools.tooling = true;

}
