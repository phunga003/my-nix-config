{ config, ... }:
{
  imports = [
    profiles/platform/proxmox-vm.nix
    profiles/services/postgres.nix
  ];

  myconfig.services.postgres = {
    enable = true;
    # NOTE: configure by adding and removing entries based on your needs, or make a different host
    databases = [ "guacamole" ];
    appUsers = [ "guacamole" ]; # role name matches db → ensureDBOwnership works
  };
}
