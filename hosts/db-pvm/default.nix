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
  ];

  myconfig.username = "postgresDB";

  myconfig.services.postgres = {
    enable = true;
    # NOTE: configure by adding and removing entries based on your needs, or make a different host
    databases = [ "guacamole" ];
    appUsers = [ "guacamole" ]; # role name matches db → ensureDBOwnership works
  };

  profiles.dev.nixTools.tooling = true;

}
