{
  programs = {
    starship = {
      enable = true;
      settings = {
        format = ''
          [$username$hostname]($style) $directory $nix_shell$git_branch$git_status
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

        nix_shell = {
          format = "via [$symbol](bold blue) ";
          symbol = "❄";
          style = "bold blue";
          heuristic = true;
        };

        git_branch = {
          format = ''\[[$symbol$branch](bold purple)\]'';
          symbol = "git:";
        };
      };
    };
  };
}
