{
  pkgs,
  lib,
  config,
  ...
}:
{
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
          "$HOME/dev/my-nix-cofig"
      fi
    '';
  };

  programs = {
    git = {
      enable = true;
      settings = {
        # change if you want
        user.name = "Goldship";
        user.email = "noreply.umamusume@pretty-derby.jp";
      };
    };

    bash = {
      enable = true;
      sessionVariables = {
        COLORTERM = "truecolor";
      };
    };

    starship = {
      enable = true;
      settings = {
        format = "$directory$git_branch$git_status$character";
        directory.style = "bold #89b4fa";
        username.disabled = true;
        hostname.disabled = true;
      };
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_macchiato";
        editor = {
          lsp.display-messages = true;
          color-modes = true;
          inline-diagnostics = {
            cursor-line = "warning";
            other-lines = "error";
          };
          indent-guides = {
            render = true;
            character = "│";
            skip-levels = 1;
          };
        };
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
