{ hostPlatform, stateVersion, ... }:
{
  nixpkgs.hostPlatform = hostPlatform;
  system.stateVersion = stateVersion;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
