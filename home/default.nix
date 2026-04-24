{ pkgs, lib, config, ... }:
{ 
  home = {
    stateVersion = "25.11";  
    
    packages = with pkgs; [
      git
      jetbrains-mono
      home-manager
      erdtree
    ];
  };
    
  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "Khai";
        user.email = "phunga.prod@gmail.com";
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


