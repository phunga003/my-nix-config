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
          "$HOME/dev/my-nix-config"
      fi
    '';
  };

  programs = {
    git = {
      enable = true;
      settings = {
        # change if you want
        user.name = "Mambo";
        user.email = "noreply.Matikanetannhauser@pretty-derby.jp";
      };
    };

    bash = {
      enable = true;
      sessionVariables = {
        COLORTERM = "truecolor";
      };
    };

    # TODO: Refactor
    starship = {
      enable = true;
      settings = {
        #format = "[$username@$hostname]($style)$directory$git_branch$git_status\n$character";
        # directory.style = "bold #89b4fa";
        #       username.show_always = true;
        #      hostname.ssh_only = false;

        format = ''
          \[[$username$hostname]($style)\] $directory$git_branch$git_status
          $character'';

        username = {
          show_always = true;
          format = "[$user]($style)";
          style_root = "bold red";
          style_user = "bold green";
        };
        hostname = {
          ssh_only = true;
          format = " $ssh_symbol[$hostname](bold green)";
        };
        directory = {
          truncation_length = 3;
          style = "bold #89b4fa";
        };
        git_branch = {
          format = ''\[[$symbol$branch](bold purple)\]'';
          symbol = "git:";
        };

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
