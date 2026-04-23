{ pkgs, ... }:
let 
  username = "nixos";
in
{ 
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";  

  programs.bash.enable = true;

  home.packages = with pkgs; [
    git
    clang-tools   
    jetbrains-mono
  ];

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
      theme = "catppuccin_mocha";
      editor.lsp.display-messages = true;
    };
    languages = {
      language = [{
        name = "c";
        language-servers = [ "clangd" ];
      }];
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };
}


