{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myconfig.services.postgres;
in
{
  options.myconfig.services.postgres = {
    enable = lib.mkEnableOption "PostgreSQL server";
    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Databases to ensure exist.";
    };
    appUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "App roles to ensure exist (ownership granted per-db separately).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = cfg.databases;
      ensureUsers = map (u: {
        name = u;
        ensureDBOwnership = true;
      }) cfg.appUsers;

      enableTCPIP = true; # ← TCP on, since Guac uses localhost:5432
      settings.listen_addresses = lib.mkDefault "localhost"; # ← but ONLY localhost, not 0.0.0.0

      authentication = lib.mkForce ''
        # TCP localhost with password — generalizes to remote later
        host  all  all  127.0.0.1/32  scram-sha-256
        host  all  all  ::1/128       scram-sha-256
        local all  all               peer
      '';
    };
  };
}
