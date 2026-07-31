{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # local hardware config — supplied per-machine, NOT committed.
    # Generate this via 'nixos-generate-config'
    # requires: nixos-rebuild ... --impure
    /etc/nixos/hardware-configuration.nix
  ];

  # --- Proxmox VM platform basics ---
  services.qemuGuest.enable = true;

  # bootloader: SeaBIOS/MBR path
  # if a given VM is UEFI, override in that host file.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = lib.mkDefault "/dev/sda";

  # --- baseline access ---
  services.openssh.enable = true;
  networking.firewall.enable = true;

  time.timeZone = lib.mkDefault "UTC";

}
