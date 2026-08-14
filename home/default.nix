{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./term.nix
    ./ide.nix
    ./git-config.nix
  ];

  home = {
    packages = with pkgs; [
      git
      jetbrains-mono
      home-manager
      erdtree
    ];

    # seed config repo
    activation.seedRepo = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "$HOME/dev/my-nix-config/.git" ]; then
        ${pkgs.git}/bin/git clone https://github.com/phunga003/my-nix-config.git \
          "$HOME/dev/my-nix-config"
      fi
    '';
  };

  programs = {
    bash = {
      enable = true;
      sessionVariables = {
        COLORTERM = "truecolor";
      };
    };

    zellij = {
      enable = true;
      settings = {
        theme = "catppuccin-macchiato";
      };
    };
  };

}
