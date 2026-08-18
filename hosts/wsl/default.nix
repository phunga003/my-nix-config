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
    ../../profiles/dev/lang/golang.nix
  ];

  myconfig.username = "nixos";

  # ---- profiles ----
  profiles.dev = {
    c = {
      runtime = true;
      tooling = true;
    };

    haskell = {
      runtime = true;
      tooling = true;
    };

    cpp = {
      runtime = true;
      tooling = true;
      godot = false;
    };

    golang = {
      runtime = true;
      tooling = true;
    };

    nixTools.tooling = true;
  };
  # WSL specific
  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  environment.extraInit = ''
    export PATH=/etc/profiles/per-user/$USER/bin:$PATH
  '';
}
