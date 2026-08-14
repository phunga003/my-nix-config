{ config, lib, ... }:
let
  cfg = config.myconfig.networking.extraInterfaces;
in
{
  options.myconfig.networking.extraInterfaces = lib.mkOption {
    description = ''
      Additional static network interfaces to configure on this host,
      keyed by interface name (e.g. "ens19"). Each host declares the
      interfaces it needs; empty by default (no-op).
    '';
    default = { };
    example = lib.literalExpression ''
      {
        ens19 = { address = "10.10.10.2"; prefixLength = 24; };
        ens20 = { address = "10.20.0.2";  prefixLength = 24; };
      }
    '';
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          address = lib.mkOption {
            type = lib.types.str;
            description = "Static IPv4 address for this interface.";
          };
          prefixLength = lib.mkOption {
            type = lib.types.ints.between 0 32;
            default = 24;
            description = "IPv4 prefix length (CIDR).";
          };
          defaultGateway = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Optional default gateway via this interface. Leave null for
              segment-local interfaces (the common case) so this interface
              does NOT become the host's default route.
            '';
          };
        };
      }
    );
  };

  config = lib.mkIf (cfg != { }) {
    networking.interfaces = lib.mapAttrs (_name: i: {
      ipv4.addresses = [
        {
          address = i.address;
          prefixLength = i.prefixLength;
        }
      ];
    }) cfg;

    # gateways: only set for interfaces that explicitly asked for one
    networking.defaultGateway = lib.mkIf (lib.any (i: i.defaultGateway != null) (lib.attrValues cfg)) (
      let
        gw = lib.findFirst (i: i.defaultGateway != null) null (lib.attrValues cfg);
      in
      gw.defaultGateway
    );
  };
}
