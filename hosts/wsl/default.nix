{ config, ... }:
{
  imports = [
    ../../modules/init-user.nix
    ../../modules/options.nix
    ../../profiles/dev/git.nix
    ../../profiles/dev/ssh.nix
    ../../profiles/dev/lang/c.nix
    ../../profiles/dev/lang/nix.nix
    ../../profiles/dev/lang/haskell.nix
    ../../profiles/dev/lang/cpp.nix
  ];

  myconfig.username = "nixos";

  # ---- profiles ----
  profiles.dev.c = {
    runtime = true;
    tooling = true;
  };

  profiles.dev.haskell = {
    runtime = true;
    tooling = true;
  };

  profiles.dev.cpp = {
    runtime = true;
    tooling = true;
    godot = true;
  };

  profiles.dev.nixTools.tooling = true;

  # home-manager = {
  #   users.${config.myconfig.username} = {
  #     imports = [ (import ../../home/default.nix) ];
  #     targets.genericLinux.enable = true;
  #     home.username = config.myconfig.username;
  #     home.homeDirectory = "/home/${config.myconfig.username}";
  #   };
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  # };

  # WSL specific
  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  environment.extraInit = ''
    export PATH=/etc/profiles/per-user/$USER/bin:$PATH
  '';
}
