{ pkgs, lib, config, ... }:
let 
  username = "nixos";
in
{ 
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";  

  home.packages = with pkgs; [
    git
    clang-tools   
    jetbrains-mono
    home-manager
    erdtree
    nixd
  ];

  targets.genericLinux.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };
  
  programs.bash = {
    enable = true;
    sessionVariables = {
      COLORTERM = "truecolor";
    };

    # if Nix is running on WSL or non-standard
    initExtra = lib.mkIf config.targets.genericLinux.enable ''
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval $(ssh-agent -s) > /dev/null
      fi
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$character";  
      directory.style = "bold #89b4fa";
      username.disabled = true;
      hostname.disabled = true;
    };
  };

  programs.helix = {
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
      };
    };
    languages = {
      language = [
        {
          name = "c";
          language-servers = [ "clangd" ];
        }
        {
          name = "nix";
          language-servers = [ "nixd" ];
        }
      ];
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-macchiato";
    };
  };
}


