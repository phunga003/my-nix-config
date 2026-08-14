{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.myconfig.services.guacamole;

  guacVer = config.services.guacamole-client.package.version;

  # Update version + hash from https://jdbc.postgresql.org/download/
  pgJdbcDriver = pkgs.fetchurl {
    url = "https://jdbc.postgresql.org/download/postgresql-42.7.4.jar";
    hash = "sha256-GIl2ch6tjoYn622DidUA3MwMm+vYhSaKMEcYAnSmAx4=";
  };

  guacJdbcExt = pkgs.stdenv.mkDerivation {
    name = "guacamole-auth-jdbc-postgresql-${guacVer}";
    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/guacamole/${guacVer}/binary/guacamole-auth-jdbc-${guacVer}.tar.gz";
      hash = "sha256-l7xf09Z9JcDpikddHf0wigN4WfVJ+sRxcccjt6cDk2Y=";
    };
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out $out/schema
      cp postgresql/guacamole-auth-jdbc-postgresql-${guacVer}.jar $out/
      cp postgresql/schema/*.sql $out/schema/
    '';
  };

  guacHome = pkgs.runCommand "guacamole-home" { } ''
    mkdir -p $out/extensions $out/lib
    cp ${guacJdbcExt}/guacamole-auth-jdbc-postgresql-${guacVer}.jar $out/extensions/
    cp ${pgJdbcDriver} $out/lib/postgresql.jar
  '';
in
{
  options.myconfig = {

    services.guacamole = {
      enable = lib.mkEnableOption "Apache Guacamole (Postgres/JDBC)";
      dbHost = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "PostgreSQL host Guacamole connects to.";
      };
      dbPort = lib.mkOption {
        type = lib.types.port;
        default = 5432;
      };
      dbName = lib.mkOption {
        type = lib.types.str;
        default = "guacamole";
      };
      dbUser = lib.mkOption {
        type = lib.types.str;
        default = "guacamole";
      };
      dbPasswordFile = lib.mkOption {
        type = lib.types.path;
        description = "Path to file containing the DB password (secret, not in git).";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    services.guacamole-server = {
      enable = true;
      host = "127.0.0.1";
      port = 4822;
    };

    systemd.services.guacamole-schema-init = {
      description = "Load Guacamole DB schema";
      wantedBy = [ "multi-user.target" ];
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
      before = [ "tomcat.service" ]; # schema must exist before Guac starts

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        export PGPASSWORD="$(cat ${cfg.dbPasswordFile})"
        if ${pkgs.postgresql}/bin/psql -h ${cfg.dbHost} -p ${toString cfg.dbPort} \
             -U ${cfg.dbUser} -d ${cfg.dbName} -tAc \
             "SELECT 1 FROM information_schema.tables WHERE table_name='guacamole_user'" \
             2>/dev/null | grep -q 1; then
          echo "Guacamole schema already present, skipping."
          exit 0
        fi

        for f in ${guacJdbcExt}/schema/*.sql; do
          echo "Loading $f"
          ${pkgs.postgresql}/bin/psql -h ${cfg.dbHost} -p ${toString cfg.dbPort} \
            -U ${cfg.dbUser} -d ${cfg.dbName} -v ON_ERROR_STOP=1 -f "$f"
        done
      '';
    };

    systemd.services.tomcat = {
      serviceConfig.StateDirectory = "guacamole";
      environment.GUACAMOLE_HOME = lib.mkForce "/var/lib/guacamole";
      preStart = ''
        mkdir -p /var/lib/guacamole/extensions /var/lib/guacamole/lib
        ln -sf ${guacHome}/extensions/* /var/lib/guacamole/extensions/
        ln -sf ${guacHome}/lib/* /var/lib/guacamole/lib/
        cat > /var/lib/guacamole/guacamole.properties <<EOF
        guacd-hostname: 127.0.0.1
        guacd-port: 4822
        postgresql-hostname: ${cfg.dbHost}
        postgresql-port: ${toString cfg.dbPort}
        postgresql-database: ${cfg.dbName}
        postgresql-username: ${cfg.dbUser}
        postgresql-password: $(cat ${cfg.dbPasswordFile})
        EOF
        chown tomcat:tomcat /var/lib/guacamole/guacamole.properties
        chmod 640 /var/lib/guacamole/guacamole.properties   
      '';
    };

    services.guacamole-client = {
      enable = true;
      enableWebserver = true;
      settings = {
        guacd-hostname = "127.0.0.1";
        guacd-port = 4822;
        postgresql-hostname = cfg.dbHost;
        postgresql-port = cfg.dbPort;
        postgresql-database = cfg.dbName;
        postgresql-username = cfg.dbUser;
      };
    };

    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
}
