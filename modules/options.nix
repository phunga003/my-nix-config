{lib, ...}:
{
  options.myconfig.username = lib.mkOption {
    type = lib.types.str;
    default = "nixos";
    description = "The primary user of this machine";
  };
}
