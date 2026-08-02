{ lib, ... }:
{
  options.myconfig = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "The primary user of this machine";
    };

    enableGenericLinux = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable if the underlying OS is not Nix";
    };
  };

}
